Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3494CD60
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 14:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730886AbfFTMEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 08:04:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726392AbfFTMEs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 08:04:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 600E6307D871;
        Thu, 20 Jun 2019 12:04:46 +0000 (UTC)
Received: from localhost (unknown [10.43.2.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 140AD19807;
        Thu, 20 Jun 2019 12:04:13 +0000 (UTC)
Date:   Thu, 20 Jun 2019 14:04:09 +0200
From:   Igor Mammedov <imammedo@redhat.com>
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     <pbonzini@redhat.com>, <mst@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>, <zhengxiang9@huawei.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
Subject: Re: [PATCH v17 01/10] hw/arm/virt: Add RAS platform version for
 migration
Message-ID: <20190620140409.3c713760@redhat.com>
In-Reply-To: <1557832703-42620-2-git-send-email-gengdongjiu@huawei.com>
References: <1557832703-42620-1-git-send-email-gengdongjiu@huawei.com>
        <1557832703-42620-2-git-send-email-gengdongjiu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 20 Jun 2019 12:04:47 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 14 May 2019 04:18:14 -0700
Dongjiu Geng <gengdongjiu@huawei.com> wrote:

> Support this feature since version 4.1, disable it by
> default in the old version.
> 
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> ---
>  hw/arm/virt.c         | 6 ++++++
>  include/hw/arm/virt.h | 1 +
>  2 files changed, 7 insertions(+)
> 
> diff --git a/hw/arm/virt.c b/hw/arm/virt.c
> index 5331ab7..7bdd41b 100644
> --- a/hw/arm/virt.c
> +++ b/hw/arm/virt.c
> @@ -2043,8 +2043,14 @@ DEFINE_VIRT_MACHINE_AS_LATEST(4, 1)
>  
>  static void virt_machine_4_0_options(MachineClass *mc)
>  {
> +    VirtMachineClass *vmc = VIRT_MACHINE_CLASS(OBJECT_CLASS(mc));
> +
>      virt_machine_4_1_options(mc);
>      compat_props_add(mc->compat_props, hw_compat_4_0, hw_compat_4_0_len);
> +    /* Disable memory recovery feature for 4.0 as RAS support was
> +     * introduced with 4.1.
> +     */
> +    vmc->no_ras = true;

So it would mean that the feature is enabled unconditionally for
new machine types and consumes resources whether user needs it or not.

In light of the race for leaner QEMU and faster startup times,
it might be better to make RAS optional and make user explicitly
enable it using a machine option.


>  }
>  DEFINE_VIRT_MACHINE(4, 0)
>  
> diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
> index 4240709..7f1a033 100644
> --- a/include/hw/arm/virt.h
> +++ b/include/hw/arm/virt.h
> @@ -104,6 +104,7 @@ typedef struct {
>      bool disallow_affinity_adjustment;
>      bool no_its;
>      bool no_pmu;
> +    bool no_ras;
>      bool claim_edge_triggered_timers;
>      bool smbios_old_sys_ver;
>      bool no_highmem_ecam;

