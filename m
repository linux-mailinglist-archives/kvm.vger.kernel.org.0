Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C02E1F1DEC
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 18:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730669AbgFHQ6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 12:58:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39242 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730236AbgFHQ6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Jun 2020 12:58:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591635513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DjeaWq24L9IqEh+sMIQV7yL5aFDflGPNZnawA6peKro=;
        b=NpaVW4l4JQaN+1NBu+d/IrxE8uwFblFIMJZln7wZ2IYodZRyO/1UECAnfr5oTeofiC8XZQ
        KpkXw8eot2AeRsZItGCJDH9AfPZ94WXQkUqWTcQn+3tKFhtClZSybkGRQVfI797QVVmt10
        IlzKtQVgQlbYG3QvN1hYGN3jXeHQQTc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-459-kkFr2eOeNk2Vl7IHHGtkgg-1; Mon, 08 Jun 2020 12:58:10 -0400
X-MC-Unique: kkFr2eOeNk2Vl7IHHGtkgg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 73EAFA0C09;
        Mon,  8 Jun 2020 16:58:08 +0000 (UTC)
Received: from [10.36.112.85] (ovpn-112-85.ams2.redhat.com [10.36.112.85])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7115679598;
        Mon,  8 Jun 2020 16:58:06 +0000 (UTC)
Subject: Re: [PATCH] KVM: arm64: Allow in-atomic injection of SPIs
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
References: <20200526161136.451312-1-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <0a3875f0-9918-51f3-08eb-29a72eeb1306@redhat.com>
Date:   Mon, 8 Jun 2020 18:58:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200526161136.451312-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 5/26/20 6:11 PM, Marc Zyngier wrote:
> On a system that uses SPIs to implement MSIs (as it would be
> the case on a GICv2 system exposing a GICv2m to its guests),
> we deny the possibility of injecting SPIs on the in-atomic
> fast-path.
> 
> This results in a very large amount of context-switches
> (roughly equivalent to twice the interrupt rate) on the host,
> and suboptimal performance for the guest (as measured with
> a test workload involving a virtio interface backed by vhost-net).
> Given that GICv2 systems are usually on the low-end of the spectrum
> performance wise, they could do without the aggravation.
> 
> We solved this for GICv3+ITS by having a translation cache. But
> SPIs do not need any extra infrastructure, and can be immediately
> injected in the virtual distributor as the locking is already
> heavy enough that we don't need to worry about anything.
> 
> This halves the number of context switches for the same workload.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/vgic/vgic-irqfd.c | 20 ++++++++++++++++----
>  arch/arm64/kvm/vgic/vgic-its.c   |  3 +--
>  2 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
> index d8cdfea5cc96..11a9f81115ab 100644
> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
There is still a comment above saying
 * Currently only direct MSI injection is supported.
> @@ -107,15 +107,27 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>  			      struct kvm *kvm, int irq_source_id, int level,
>  			      bool line_status)
>  {
> -	if (e->type == KVM_IRQ_ROUTING_MSI && vgic_has_its(kvm) && level) {
> +	if (!level)
> +		return -EWOULDBLOCK;
> +
> +	switch (e->type) {
> +	case KVM_IRQ_ROUTING_MSI: {
>  		struct kvm_msi msi;
>  
> +		if (!vgic_has_its(kvm))
> +			return -EINVAL;
Shouldn't we return -EWOULDBLOCK by default?
QEMU does not use that path with GICv2m but in kvm_set_routing_entry() I
don't see any check related to the ITS.
> +
>  		kvm_populate_msi(e, &msi);
> -		if (!vgic_its_inject_cached_translation(kvm, &msi))
> -			return 0;
> +		return vgic_its_inject_cached_translation(kvm, &msi);

>  	}
>  
> -	return -EWOULDBLOCK;
> +	case KVM_IRQ_ROUTING_IRQCHIP:
> +		/* Injecting SPIs is always possible in atomic context */
> +		return vgic_irqfd_set_irq(e, kvm, irq_source_id, 1, line_status);
what about the 	mutex_lock(&kvm->lock) called from within
vgic_irqfd_set_irq/kvm_vgic_inject_irq/vgic_lazy_init
> +
> +	default:
> +		return -EWOULDBLOCK;
> +	}
>  }
>  
>  int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index c012a52b19f5..40cbaca81333 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -757,9 +757,8 @@ int vgic_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
>  
>  	db = (u64)msi->address_hi << 32 | msi->address_lo;
>  	irq = vgic_its_check_cache(kvm, db, msi->devid, msi->data);
> -
>  	if (!irq)
> -		return -1;
> +		return -EWOULDBLOCK;
>  
>  	raw_spin_lock_irqsave(&irq->irq_lock, flags);
>  	irq->pending_latch = true;
> 
Thanks

Eric

