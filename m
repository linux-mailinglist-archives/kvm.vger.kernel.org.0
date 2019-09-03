Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5485A6449
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 10:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbfICIrJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 04:47:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49524 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726452AbfICIrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 04:47:09 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E2536308FBFC;
        Tue,  3 Sep 2019 08:47:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C784160C18;
        Tue,  3 Sep 2019 08:47:05 +0000 (UTC)
Date:   Tue, 3 Sep 2019 10:47:03 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Steven Price <steven.price@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 10/10] arm64: Retrieve stolen time as paravirtualized
 guest
Message-ID: <20190903084703.hwpelmr7fikb32nj@kamzik.brq.redhat.com>
References: <20190830084255.55113-1-steven.price@arm.com>
 <20190830084255.55113-11-steven.price@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830084255.55113-11-steven.price@arm.com>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 03 Sep 2019 08:47:09 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 30, 2019 at 09:42:55AM +0100, Steven Price wrote:
> Enable paravirtualization features when running under a hypervisor
> supporting the PV_TIME_ST hypercall.
> 
> For each (v)CPU, we ask the hypervisor for the location of a shared
> page which the hypervisor will use to report stolen time to us. We set
> pv_time_ops to the stolen time function which simply reads the stolen
> value from the shared page for a VCPU. We guarantee single-copy
> atomicity using READ_ONCE which means we can also read the stolen
> time for another VCPU than the currently running one while it is
> potentially being updated by the hypervisor.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/paravirt.h |   9 +-
>  arch/arm64/kernel/paravirt.c      | 148 ++++++++++++++++++++++++++++++
>  arch/arm64/kernel/time.c          |   3 +
>  include/linux/cpuhotplug.h        |   1 +
>  4 files changed, 160 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
> index 799d9dd6f7cc..125c26c42902 100644
> --- a/arch/arm64/include/asm/paravirt.h
> +++ b/arch/arm64/include/asm/paravirt.h
> @@ -21,6 +21,13 @@ static inline u64 paravirt_steal_clock(int cpu)
>  {
>  	return pv_ops.time.steal_clock(cpu);
>  }
> -#endif
> +
> +int __init kvm_guest_init(void);
> +
> +#else
> +
> +#define kvm_guest_init()
> +
> +#endif // CONFIG_PARAVIRT
>  
>  #endif
> diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
> index 4cfed91fe256..5bf3be7ccf7e 100644
> --- a/arch/arm64/kernel/paravirt.c
> +++ b/arch/arm64/kernel/paravirt.c
> @@ -6,13 +6,161 @@
>   * Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>   */
>  
> +#define pr_fmt(fmt) "kvmarm-pv: " fmt
> +
> +#include <linux/arm-smccc.h>
> +#include <linux/cpuhotplug.h>
>  #include <linux/export.h>
> +#include <linux/io.h>
>  #include <linux/jump_label.h>
> +#include <linux/printk.h>
> +#include <linux/psci.h>
> +#include <linux/reboot.h>
> +#include <linux/slab.h>
>  #include <linux/types.h>
> +
>  #include <asm/paravirt.h>
> +#include <asm/pvclock-abi.h>
> +#include <asm/smp_plat.h>
>  
>  struct static_key paravirt_steal_enabled;
>  struct static_key paravirt_steal_rq_enabled;
>  
>  struct paravirt_patch_template pv_ops;
>  EXPORT_SYMBOL_GPL(pv_ops);
> +
> +struct kvmarm_stolen_time_region {
> +	struct pvclock_vcpu_stolen_time *kaddr;
> +};
> +
> +static DEFINE_PER_CPU(struct kvmarm_stolen_time_region, stolen_time_region);
> +
> +static bool steal_acc = true;
> +static int __init parse_no_stealacc(char *arg)
> +{
> +	steal_acc = false;
> +	return 0;
> +}
> +
> +early_param("no-steal-acc", parse_no_stealacc);

Need to also add an 'ARM64' to the
Documentation/admin-guide/kernel-parameters.txt entry for this.

Thanks,
drew
