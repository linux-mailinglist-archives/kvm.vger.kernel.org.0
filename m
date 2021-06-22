Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E76D73B093F
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 17:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbhFVPkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 11:40:41 -0400
Received: from foss.arm.com ([217.140.110.172]:51462 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231680AbhFVPkh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 11:40:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B2EDA31B;
        Tue, 22 Jun 2021 08:38:21 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4A5BC3F718;
        Tue, 22 Jun 2021 08:38:20 -0700 (PDT)
Subject: Re: [PATCH v4 0/9] KVM: arm64: Initial host support for the Apple M1
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Hector Martin <marcan@marcan.st>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kernel-team@android.com
References: <20210601104005.81332-1-maz@kernel.org>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <9bc0923c-5c3b-eeac-86ee-c3234c486955@arm.com>
Date:   Tue, 22 Jun 2021 16:39:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210601104005.81332-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/1/21 11:39 AM, Marc Zyngier wrote:
> This is a new version of the series previously posted at [3], reworking
> the vGIC and timer code to cope with the M1 braindead^Wamusing nature.
>
> Hardly any change this time around, mostly rebased on top of upstream
> now that the dependencies have made it in.
>
> Tested with multiple concurrent VMs running from an initramfs.
>
> Until someone shouts loudly now, I'll take this into 5.14 (and in
> -next from tomorrow).

I am not familiar with irqdomains or with the irqchip infrastructure, so I can't
really comment on patch #8.

I tried testing this with a GICv3 by modifying the driver to set
no_hw_deactivation and no_maint_irq_mask:

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 340c51d87677..d0c6f808d7f4 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -565,8 +565,10 @@ int kvm_vgic_hyp_init(void)
        if (ret)
                return ret;
 
+       /*
        if (!has_mask)
                return 0;
+               */
 
        ret = request_percpu_irq(kvm_vgic_global_state.maint_irq,
                                 vgic_maintenance_handler,
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 453fc425eede..9ce4dee20655 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1850,6 +1850,12 @@ static void __init gic_of_setup_kvm_info(struct device_node
*node)
        if (!ret)
                gic_v3_kvm_info.vcpu = r;
 
+       gic_v3_kvm_info.no_hw_deactivation = true;
+       gic_v3_kvm_info.no_maint_irq_mask = true;
+
+       vgic_set_kvm_info(&gic_v3_kvm_info);
+       return;
+
        gic_v3_kvm_info.has_v4 = gic_data.rdists.has_vlpis;
        gic_v3_kvm_info.has_v4_1 = gic_data.rdists.has_rvpeid;
        vgic_set_kvm_info(&gic_v3_kvm_info);

Kept the maintenance irq ID so the IRQ gets enabled at the Redistributor level. I
don't know if I managed to break something with those changes, but when testing on
the model and on a rockpro64 (with the patches cherry-picked on top of v5.13-rc7)
I kept seeing rcu stalls. I assume I did something wrong.

Thanks,

Alex

>
> * From v3 [3]:
>   - Rebased on 5.13-rc4 to match the kvmarm/next base
>   - Moved stuff from patch #7 to its logical spot in patch #8
>   - Changed the include/linux/irqchip/arm-vgic-info.h guard
>   - Collected RBs from Alex, with thanks
>
> * From v2 [2]:
>   - Rebased on 5.13-rc1
>   - Fixed a couple of nits in the GIC registration code
>
> * From v1 [1]:
>   - Rebased on Hector's v4 posting[0]
>   - Dropped a couple of patches that have been merged in the above series
>   - Fixed irq_ack callback on the timer path
>
> [0] https://lore.kernel.org/r/20210402090542.131194-1-marcan@marcan.st
> [1] https://lore.kernel.org/r/20210316174617.173033-1-maz@kernel.org
> [2] https://lore.kernel.org/r/20210403112931.1043452-1-maz@kernel.org
> [3] https://lore.kernel.org/r/20210510134824.1910399-1-maz@kernel.org
>
> Marc Zyngier (9):
>   irqchip/gic: Split vGIC probing information from the GIC code
>   KVM: arm64: Handle physical FIQ as an IRQ while running a guest
>   KVM: arm64: vgic: Be tolerant to the lack of maintenance interrupt
>     masking
>   KVM: arm64: vgic: Let an interrupt controller advertise lack of HW
>     deactivation
>   KVM: arm64: vgic: move irq->get_input_level into an ops structure
>   KVM: arm64: vgic: Implement SW-driven deactivation
>   KVM: arm64: timer: Refactor IRQ configuration
>   KVM: arm64: timer: Add support for SW-based deactivation
>   irqchip/apple-aic: Advertise some level of vGICv3 compatibility
>
>  arch/arm64/kvm/arch_timer.c            | 162 +++++++++++++++++++++----
>  arch/arm64/kvm/hyp/hyp-entry.S         |   6 +-
>  arch/arm64/kvm/vgic/vgic-init.c        |  36 +++++-
>  arch/arm64/kvm/vgic/vgic-v2.c          |  19 ++-
>  arch/arm64/kvm/vgic/vgic-v3.c          |  19 ++-
>  arch/arm64/kvm/vgic/vgic.c             |  14 +--
>  drivers/irqchip/irq-apple-aic.c        |   9 ++
>  drivers/irqchip/irq-gic-common.c       |  13 --
>  drivers/irqchip/irq-gic-common.h       |   2 -
>  drivers/irqchip/irq-gic-v3.c           |   6 +-
>  drivers/irqchip/irq-gic.c              |   6 +-
>  include/kvm/arm_vgic.h                 |  41 +++++--
>  include/linux/irqchip/arm-gic-common.h |  25 +---
>  include/linux/irqchip/arm-vgic-info.h  |  45 +++++++
>  14 files changed, 299 insertions(+), 104 deletions(-)
>  create mode 100644 include/linux/irqchip/arm-vgic-info.h
>
