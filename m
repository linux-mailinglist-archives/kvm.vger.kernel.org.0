Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69E2E18B2FF
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 13:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgCSMKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 08:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgCSMKO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 08:10:14 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C90F20663;
        Thu, 19 Mar 2020 12:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584619813;
        bh=6rNervqAIpsCbSWbaL/JCxlPQb2xA9V11QRKwIxvVgM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VkE/6xNgNrrioz0QRL3zM5ILQU3OSG57GIjlZZrKDGhV/HVFLdz56qJBc3Y579LxN
         YJiAgzgnKU+1JFICbzzROJb4RBh3sc7b3ZVObwQXYIrmOddLbmPeJRQFc+j3Qnyv5i
         +f6MY4lnf0La6fi+k75jfCDTuaKdSxcKPM8M8/OY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jEu03-00DvjA-9X; Thu, 19 Mar 2020 12:10:11 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 19 Mar 2020 12:10:11 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 20/23] KVM: arm64: GICv4.1: Plumb SGI implementation
 selection in the distributor
In-Reply-To: <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-21-maz@kernel.org>
 <72832f51-bbde-8502-3e03-189ac20a0143@huawei.com>
Message-ID: <4a06fae9c93e10351276d173747d17f4@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 2020-03-18 06:34, Zenghui Yu wrote:
> Hi Marc,
> 
> On 2020/3/5 4:33, Marc Zyngier wrote:
>> The GICv4.1 architecture gives the hypervisor the option to let
>> the guest choose whether it wants the good old SGIs with an
>> active state, or the new, HW-based ones that do not have one.
>> 
>> For this, plumb the configuration of SGIs into the GICv3 MMIO
>> handling, present the GICD_TYPER2.nASSGIcap to the guest,
>> and handle the GICD_CTLR.nASSGIreq setting.
>> 
>> In order to be able to deal with the restore of a guest, also
>> apply the GICD_CTLR.nASSGIreq setting at first run so that we
>> can move the restored SGIs to the HW if that's what the guest
>> had selected in a previous life.
> 
> I'm okay with the restore path.  But it seems that we still fail to
> save the pending state of vSGI - software pending_latch of HW-based
> vSGIs will not be updated (and always be false) because we directly
> inject them through ITS, so vgic_v3_uaccess_read_pending() can't
> tell the correct pending state to user-space (the correct one should
> be latched in HW).
> 
> It would be good if we can sync the hardware state into pending_latch
> at an appropriate time (just before save), but not sure if we can...

The problem is to find the "appropriate time". It would require to 
define
a point in the save sequence where we transition the state from HW to
SW. I'm not keen on adding more state than we already have.

But what we can do is to just ask the HW to give us the right state
on userspace access, at all times. How about this:

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 48fd9fc229a2..281fe7216c59 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -305,8 +305,18 @@ static unsigned long 
vgic_v3_uaccess_read_pending(struct kvm_vcpu *vcpu,
  	 */
  	for (i = 0; i < len * 8; i++) {
  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+		bool state = irq->pending_latch;

-		if (irq->pending_latch)
+		if (irq->hw && vgic_irq_is_sgi(irq->intid)) {
+			int err;
+
+			err = irq_get_irqchip_state(irq->host_irq,
+						    IRQCHIP_STATE_PENDING,
+						    &state);
+			WARN_ON(err);
+		}
+
+		if (state)
  			value |= (1U << i);

  		vgic_put_irq(vcpu->kvm, irq);

I can add this to "KVM: arm64: GICv4.1: Add direct injection capability 
to SGI registers".

> 
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>   virt/kvm/arm/vgic/vgic-mmio-v3.c | 48 
>> ++++++++++++++++++++++++++++++--
>>   virt/kvm/arm/vgic/vgic-v3.c      |  2 ++
>>   2 files changed, 48 insertions(+), 2 deletions(-)
>> 
>> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c 
>> b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> index de89da76a379..442f3b8c2559 100644
>> --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
>> @@ -3,6 +3,7 @@
>>    * VGICv3 MMIO handling functions
>>    */
>>   +#include <linux/bitfield.h>
>>   #include <linux/irqchip/arm-gic-v3.h>
>>   #include <linux/kvm.h>
>>   #include <linux/kvm_host.h>
>> @@ -70,6 +71,8 @@ static unsigned long vgic_mmio_read_v3_misc(struct 
>> kvm_vcpu *vcpu,
>>   		if (vgic->enabled)
>>   			value |= GICD_CTLR_ENABLE_SS_G1;
>>   		value |= GICD_CTLR_ARE_NS | GICD_CTLR_DS;
>> +		if (kvm_vgic_global_state.has_gicv4_1 && vgic->nassgireq)
> 
> Looking at how we handle the GICD_CTLR.nASSGIreq setting, I think
> "nassgireq==true" already indicates "has_gicv4_1==true".  So this
> can be simplified.

Indeed. I've now dropped the has_gicv4.1 check.

> But I wonder that should we use nassgireq to *only* keep track what
> the guest had written into the GICD_CTLR.nASSGIreq.  If not, we may
> lose the guest-request bit after migration among hosts with different
> has_gicv4_1 settings.

I'm unsure of what you're suggesting here. If userspace tries to set
GICD_CTLR.nASSGIreq on a non-4.1 host, this bit will not latch.
Userspace can check that at restore time. Or we could fail the
userspace write, which is a bit odd (the bit is otherwise RES0).

Could you clarify your proposal?

> The remaining patches all look good to me :-). I will wait for you to
> confirm these two concerns.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
