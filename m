Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7241FABAA
	for <lists+kvm@lfdr.de>; Tue, 16 Jun 2020 10:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgFPIxE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Jun 2020 04:53:04 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:31003 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725710AbgFPIxE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Jun 2020 04:53:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592297582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x6AWtnIXsr8Pf+vdCf9SuJ7M4o4r+GS5IQOCBagOKD0=;
        b=BsbLGtC5FS9SAFVgWW+Kw3H6V8saOaA+ZUCmmOaM5DbcCGnB5nkCx0Nf6DuhbUyG+dXxhc
        PBiQZUR8y9G2fAeWsznJMTU+2QEP9i64wcbMCKmGr8BUwXKnSvY9Z0Ha65XOlML5L7y4LC
        O2nN/gkqLaGMyBi/otmpd2DC8wF6m1s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-168-Kncd8T43NEerIrj_COjv7A-1; Tue, 16 Jun 2020 04:52:58 -0400
X-MC-Unique: Kncd8T43NEerIrj_COjv7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1E637873429;
        Tue, 16 Jun 2020 08:52:57 +0000 (UTC)
Received: from [10.36.114.197] (ovpn-114-197.ams2.redhat.com [10.36.114.197])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ABD4260BEC;
        Tue, 16 Jun 2020 08:52:54 +0000 (UTC)
Subject: Re: [PATCH v2] KVM: arm64: Allow in-atomic injection of SPIs
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>, yuzenghui@huawei.com,
        kernel-team@android.com,
        Julien Thierry <julien.thierry.kdev@gmail.com>
References: <20200615203844.14793-1-maz@kernel.org>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <c4c2d7ec-16a2-a019-283d-18a9bd576d81@redhat.com>
Date:   Tue, 16 Jun 2020 10:52:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200615203844.14793-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/15/20 10:38 PM, Marc Zyngier wrote:
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
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric

> ---
> * From v1:
>   - Drop confusing comment (Zenghui, Eric)
>   - Now consistently return -EWOULDBLOCK when unable to inject (Eric)
>   - Don't inject if the vgic isn't initialized yet (Eric)
> 
>  arch/arm64/kvm/vgic/vgic-irqfd.c | 24 +++++++++++++++++++-----
>  arch/arm64/kvm/vgic/vgic-its.c   |  3 +--
>  2 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
> index d8cdfea5cc96..79f8899b234c 100644
> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
> @@ -100,19 +100,33 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>  
>  /**
>   * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
> - *
> - * Currently only direct MSI injection is supported.
>   */
>  int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
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
> +			break;
> +
>  		kvm_populate_msi(e, &msi);
> -		if (!vgic_its_inject_cached_translation(kvm, &msi))
> -			return 0;
> +		return vgic_its_inject_cached_translation(kvm, &msi);
> +	}
> +
> +	case KVM_IRQ_ROUTING_IRQCHIP:
> +		/*
> +		 * Injecting SPIs is always possible in atomic context
> +		 * as long as the damn vgic is initialized.
> +		 */
> +		if (unlikely(!vgic_initialized(kvm)))
> +			break;
> +		return vgic_irqfd_set_irq(e, kvm, irq_source_id, 1, line_status);
>  	}
>  
>  	return -EWOULDBLOCK;
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

