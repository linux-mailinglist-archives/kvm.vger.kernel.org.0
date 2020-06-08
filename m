Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA781F1E40
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 19:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387514AbgFHRTI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 13:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730490AbgFHRTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 13:19:08 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F9DB206C3;
        Mon,  8 Jun 2020 17:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591636747;
        bh=eN+Clm/cvykfn8Xvcj8t9z6v+LWSyFOpU01cRVXweQg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=siCGluGb7baF8rUg5uT2B8cjcn9mEflYF4YucD+8g9aqI5NtviAuyvsYxSA1flASp
         kyNu+G/yQRdqy5+2ovlmgJeg/zKHSqrUowrRe5ofRYHtVY+fiB+NJcrJosIg2GGbjn
         fqFzHOiKUPoPBSrHC6EWxHCbfpF68oK++mPhopMw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jiLQP-001B5a-O4; Mon, 08 Jun 2020 18:19:05 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Jun 2020 18:19:05 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Allow in-atomic injection of SPIs
In-Reply-To: <0a3875f0-9918-51f3-08eb-29a72eeb1306@redhat.com>
References: <20200526161136.451312-1-maz@kernel.org>
 <0a3875f0-9918-51f3-08eb-29a72eeb1306@redhat.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <e3a8ea9947616f895021310127fe1477@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020-06-08 17:58, Auger Eric wrote:
> Hi Marc,
> 
> On 5/26/20 6:11 PM, Marc Zyngier wrote:
>> On a system that uses SPIs to implement MSIs (as it would be
>> the case on a GICv2 system exposing a GICv2m to its guests),
>> we deny the possibility of injecting SPIs on the in-atomic
>> fast-path.
>> 
>> This results in a very large amount of context-switches
>> (roughly equivalent to twice the interrupt rate) on the host,
>> and suboptimal performance for the guest (as measured with
>> a test workload involving a virtio interface backed by vhost-net).
>> Given that GICv2 systems are usually on the low-end of the spectrum
>> performance wise, they could do without the aggravation.
>> 
>> We solved this for GICv3+ITS by having a translation cache. But
>> SPIs do not need any extra infrastructure, and can be immediately
>> injected in the virtual distributor as the locking is already
>> heavy enough that we don't need to worry about anything.
>> 
>> This halves the number of context switches for the same workload.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>> ---
>>  arch/arm64/kvm/vgic/vgic-irqfd.c | 20 ++++++++++++++++----
>>  arch/arm64/kvm/vgic/vgic-its.c   |  3 +--
>>  2 files changed, 17 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c 
>> b/arch/arm64/kvm/vgic/vgic-irqfd.c
>> index d8cdfea5cc96..11a9f81115ab 100644
>> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
>> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
> There is still a comment above saying
>  * Currently only direct MSI injection is supported.

I believe this comment to be correct. There is no path other
than MSI injection that leads us here. Case in point, we only
ever inject a rising edge through this API, never a falling one.

>> @@ -107,15 +107,27 @@ int kvm_arch_set_irq_inatomic(struct 
>> kvm_kernel_irq_routing_entry *e,
>>  			      struct kvm *kvm, int irq_source_id, int level,
>>  			      bool line_status)
>>  {
>> -	if (e->type == KVM_IRQ_ROUTING_MSI && vgic_has_its(kvm) && level) {
>> +	if (!level)
>> +		return -EWOULDBLOCK;
>> +
>> +	switch (e->type) {
>> +	case KVM_IRQ_ROUTING_MSI: {
>>  		struct kvm_msi msi;
>> 
>> +		if (!vgic_has_its(kvm))
>> +			return -EINVAL;
> Shouldn't we return -EWOULDBLOCK by default?
> QEMU does not use that path with GICv2m but in kvm_set_routing_entry() 
> I
> don't see any check related to the ITS.

Fair enough. I really don't anticipate anyone to be using
KVM_IRQ_ROUTING_MSI with anything but the ITS, but who knows,
people are crazy! ;-)

>> +
>>  		kvm_populate_msi(e, &msi);
>> -		if (!vgic_its_inject_cached_translation(kvm, &msi))
>> -			return 0;
>> +		return vgic_its_inject_cached_translation(kvm, &msi);
> 
>>  	}
>> 
>> -	return -EWOULDBLOCK;
>> +	case KVM_IRQ_ROUTING_IRQCHIP:
>> +		/* Injecting SPIs is always possible in atomic context */
>> +		return vgic_irqfd_set_irq(e, kvm, irq_source_id, 1, line_status);
> what about the 	mutex_lock(&kvm->lock) called from within
> vgic_irqfd_set_irq/kvm_vgic_inject_irq/vgic_lazy_init

Holy crap. The lazy GIC init strikes again :-(.
How about this on top of the existing patch:

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c 
b/arch/arm64/kvm/vgic/vgic-irqfd.c
index 11a9f81115ab..6e5ca04d5589 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -115,19 +115,23 @@ int kvm_arch_set_irq_inatomic(struct 
kvm_kernel_irq_routing_entry *e,
  		struct kvm_msi msi;

  		if (!vgic_has_its(kvm))
-			return -EINVAL;
+			break;

  		kvm_populate_msi(e, &msi);
  		return vgic_its_inject_cached_translation(kvm, &msi);
  	}

  	case KVM_IRQ_ROUTING_IRQCHIP:
-		/* Injecting SPIs is always possible in atomic context */
+		/*
+		 * Injecting SPIs is always possible in atomic context
+		 * as long as the damn vgic is initialized.
+		 */
+		if (unlikely(!vgic_initialized(kvm)))
+			break;
  		return vgic_irqfd_set_irq(e, kvm, irq_source_id, 1, line_status);
-
-	default:
-		return -EWOULDBLOCK;
  	}
+
+	return -EWOULDBLOCK;
  }

  int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)


Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
