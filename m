Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055FD7185B
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 14:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732130AbfGWMjP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 08:39:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40494 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726720AbfGWMjP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 08:39:15 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F38002F8BD2;
        Tue, 23 Jul 2019 12:39:14 +0000 (UTC)
Received: from [10.36.117.239] (ovpn-117-239.ams2.redhat.com [10.36.117.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 943EF5D9D3;
        Tue, 23 Jul 2019 12:39:10 +0000 (UTC)
Subject: Re: [PATCH v2 3/9] KVM: arm/arm64: vgic-its: Add MSI-LPI translation
 cache invalidation
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "Saidi, Ali" <alisaidi@amazon.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-4-marc.zyngier@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <00033552-f4e1-81c0-1e7d-09f2593b758a@redhat.com>
Date:   Tue, 23 Jul 2019 14:39:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190611170336.121706-4-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 23 Jul 2019 12:39:15 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/11/19 7:03 PM, Marc Zyngier wrote:
> There's a number of cases where we need to invalidate the caching
> of translations, so let's add basic support for that.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 23 +++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h     |  1 +
>  2 files changed, 24 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index ce9bcddeb7f1..9b6b66204b97 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -546,6 +546,29 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
>  	return 0;
>  }
>  
> +void vgic_its_invalidate_cache(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_translation_cache_entry *cte;
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> +
> +	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
> +		/*
> +		 * If we hit a NULL entry, there is nothing after this
> +		 * point.
> +		 */
> +		if (!cte->irq)
> +			break;
> +
> +		__vgic_put_lpi_locked(kvm, cte->irq);
> +		cte->irq = NULL;
> +	}
> +
> +	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
> +}
> +
>  int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>  			 u32 devid, u32 eventid, struct vgic_irq **irq)
>  {
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index afac2fed7df4..072f810dc441 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -319,6 +319,7 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>  struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
>  void vgic_lpi_translation_cache_init(struct kvm *kvm);
>  void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
> +void vgic_its_invalidate_cache(struct kvm *kvm);
>  
>  bool vgic_supports_direct_msis(struct kvm *kvm);
>  int vgic_v4_init(struct kvm *kvm);
> 
