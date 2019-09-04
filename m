Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44E6A8C16
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732980AbfIDQJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:09:26 -0400
Received: from foss.arm.com ([217.140.110.172]:57760 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731869AbfIDQBP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:01:15 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8F5CB28;
        Wed,  4 Sep 2019 09:01:14 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9042B3F246;
        Wed,  4 Sep 2019 09:01:12 -0700 (PDT)
Subject: Re: [PATCH v4 10/10] arm64: Retrieve stolen time as paravirtualized
 guest
To:     Andrew Jones <drjones@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Pouloze <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190830084255.55113-1-steven.price@arm.com>
 <20190830084255.55113-11-steven.price@arm.com>
 <20190903084703.hwpelmr7fikb32nj@kamzik.brq.redhat.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <329fa72e-5c92-602e-a010-2083366221d1@arm.com>
Date:   Wed, 4 Sep 2019 17:01:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190903084703.hwpelmr7fikb32nj@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/09/2019 09:47, Andrew Jones wrote:
> On Fri, Aug 30, 2019 at 09:42:55AM +0100, Steven Price wrote:
>> Enable paravirtualization features when running under a hypervisor
>> supporting the PV_TIME_ST hypercall.
>>
>> For each (v)CPU, we ask the hypervisor for the location of a shared
>> page which the hypervisor will use to report stolen time to us. We set
>> pv_time_ops to the stolen time function which simply reads the stolen
>> value from the shared page for a VCPU. We guarantee single-copy
>> atomicity using READ_ONCE which means we can also read the stolen
>> time for another VCPU than the currently running one while it is
>> potentially being updated by the hypervisor.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>  arch/arm64/include/asm/paravirt.h |   9 +-
>>  arch/arm64/kernel/paravirt.c      | 148 ++++++++++++++++++++++++++++++
>>  arch/arm64/kernel/time.c          |   3 +
>>  include/linux/cpuhotplug.h        |   1 +
>>  4 files changed, 160 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/paravirt.h b/arch/arm64/include/asm/paravirt.h
>> index 799d9dd6f7cc..125c26c42902 100644
>> --- a/arch/arm64/include/asm/paravirt.h
>> +++ b/arch/arm64/include/asm/paravirt.h
>> @@ -21,6 +21,13 @@ static inline u64 paravirt_steal_clock(int cpu)
>>  {
>>  	return pv_ops.time.steal_clock(cpu);
>>  }
>> -#endif
>> +
>> +int __init kvm_guest_init(void);
>> +
>> +#else
>> +
>> +#define kvm_guest_init()
>> +
>> +#endif // CONFIG_PARAVIRT
>>  
>>  #endif
>> diff --git a/arch/arm64/kernel/paravirt.c b/arch/arm64/kernel/paravirt.c
>> index 4cfed91fe256..5bf3be7ccf7e 100644
>> --- a/arch/arm64/kernel/paravirt.c
>> +++ b/arch/arm64/kernel/paravirt.c
>> @@ -6,13 +6,161 @@
>>   * Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
>>   */
>>  
>> +#define pr_fmt(fmt) "kvmarm-pv: " fmt
>> +
>> +#include <linux/arm-smccc.h>
>> +#include <linux/cpuhotplug.h>
>>  #include <linux/export.h>
>> +#include <linux/io.h>
>>  #include <linux/jump_label.h>
>> +#include <linux/printk.h>
>> +#include <linux/psci.h>
>> +#include <linux/reboot.h>
>> +#include <linux/slab.h>
>>  #include <linux/types.h>
>> +
>>  #include <asm/paravirt.h>
>> +#include <asm/pvclock-abi.h>
>> +#include <asm/smp_plat.h>
>>  
>>  struct static_key paravirt_steal_enabled;
>>  struct static_key paravirt_steal_rq_enabled;
>>  
>>  struct paravirt_patch_template pv_ops;
>>  EXPORT_SYMBOL_GPL(pv_ops);
>> +
>> +struct kvmarm_stolen_time_region {
>> +	struct pvclock_vcpu_stolen_time *kaddr;
>> +};
>> +
>> +static DEFINE_PER_CPU(struct kvmarm_stolen_time_region, stolen_time_region);
>> +
>> +static bool steal_acc = true;
>> +static int __init parse_no_stealacc(char *arg)
>> +{
>> +	steal_acc = false;
>> +	return 0;
>> +}
>> +
>> +early_param("no-steal-acc", parse_no_stealacc);
> 
> Need to also add an 'ARM64' to the
> Documentation/admin-guide/kernel-parameters.txt entry for this.

Good point, thanks for the pointer.

Steve

