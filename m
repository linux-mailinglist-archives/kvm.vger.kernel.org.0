Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE84C71B7E
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 17:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbfGWPV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 11:21:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52076 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbfGWPV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 11:21:59 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6863830ADC79;
        Tue, 23 Jul 2019 15:21:58 +0000 (UTC)
Received: from [10.36.116.111] (ovpn-116-111.ams2.redhat.com [10.36.116.111])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 42BB05C25A;
        Tue, 23 Jul 2019 15:21:55 +0000 (UTC)
Subject: Re: [PATCH v2 7/9] KVM: arm/arm64: vgic-its: Cache successful
 MSI->LPI translation
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
 <20190611170336.121706-8-marc.zyngier@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <159e93d3-571d-dae8-92d8-54a56f367012@redhat.com>
Date:   Tue, 23 Jul 2019 17:21:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190611170336.121706-8-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 23 Jul 2019 15:21:58 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 6/11/19 7:03 PM, Marc Zyngier wrote:
> On a successful translation, preserve the parameters in the LPI
> translation cache. Each translation is reusing the last slot
> in the list, naturally evincting the least recently used entry.
evicting
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/vgic/vgic-its.c | 86 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 86 insertions(+)
> 
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 0aa0cbbc3af6..62932458476a 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -546,6 +546,90 @@ static unsigned long vgic_mmio_read_its_idregs(struct kvm *kvm,
>  	return 0;
>  }
>  
> +static struct vgic_irq *__vgic_its_check_cache(struct vgic_dist *dist,
> +					       phys_addr_t db,
> +					       u32 devid, u32 eventid)
> +{
> +	struct vgic_translation_cache_entry *cte;
> +	struct vgic_irq *irq = NULL;
> +
> +	list_for_each_entry(cte, &dist->lpi_translation_cache, entry) {
> +		/*
> +		 * If we hit a NULL entry, there is nothing after this
> +		 * point.
> +		 */
> +		if (!cte->irq)
> +			break;
> +
> +		if (cte->db == db &&
> +		    cte->devid == devid &&
> +		    cte->eventid == eventid) {
> +			/*
> +			 * Move this entry to the head, as it is the
> +			 * most recently used.
> +			 */
> +			list_move(&cte->entry, &dist->lpi_translation_cache);
> +			irq = cte->irq;
> +			break;
> +		}
> +	}
> +
> +	return irq;
> +}
> +
> +static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
> +				       u32 devid, u32 eventid,
> +				       struct vgic_irq *irq)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_translation_cache_entry *cte;
> +	unsigned long flags;
> +	phys_addr_t db;
> +
> +	/* Do not cache a directly injected interrupt */
> +	if (irq->hw)
> +		return;
> +
> +	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
> +
> +	if (unlikely(list_empty(&dist->lpi_translation_cache)))
> +		goto out;
> +
> +	/*
> +	 * We could have raced with another CPU caching the same
> +	 * translation behind our back, so let's check it is not in
> +	 * already
> +	 */
> +	db = its->vgic_its_base + GITS_TRANSLATER;
> +	if (__vgic_its_check_cache(dist, db, devid, eventid))
> +		goto out;
> +
> +	/* Always reuse the last entry (LRU policy) */
> +	cte = list_last_entry(&dist->lpi_translation_cache,
> +			      typeof(*cte), entry);
> +
> +	/*
> +	 * Caching the translation implies having an extra reference
> +	 * to the interrupt, so drop the potential reference on what
> +	 * was in the cache, and increment it on the new interrupt.
> +	 */
> +	if (cte->irq)
> +		__vgic_put_lpi_locked(kvm, cte->irq);
> +
> +	vgic_get_irq_kref(irq);
> +
> +	cte->db		= db;
> +	cte->devid	= devid;
> +	cte->eventid	= eventid;
> +	cte->irq	= irq;
> +
> +	/* Move the new translation to the head of the list */
> +	list_move(&cte->entry, &dist->lpi_translation_cache);
> +
> +out:
> +	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
> +}
> +
>  void vgic_its_invalidate_cache(struct kvm *kvm)
>  {
>  	struct vgic_dist *dist = &kvm->arch.vgic;
> @@ -589,6 +673,8 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>  	if (!vcpu->arch.vgic_cpu.lpis_enabled)
>  		return -EBUSY;
>  
> +	vgic_its_cache_translation(kvm, its, devid, eventid, ite->irq);
> +
>  	*irq = ite->irq;
>  	return 0;
>  }
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
