Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A596B71868
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 14:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387837AbfGWMn5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 08:43:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732336AbfGWMn5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 08:43:57 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B0D342F8BDD;
        Tue, 23 Jul 2019 12:43:56 +0000 (UTC)
Received: from [10.36.117.239] (ovpn-117-239.ams2.redhat.com [10.36.117.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B9BD0646C7;
        Tue, 23 Jul 2019 12:43:51 +0000 (UTC)
Subject: Re: [PATCH v2 1/9] KVM: arm/arm64: vgic: Add LPI translation cache
 definition
To:     Marc Zyngier <marc.zyngier@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Suzuki K Poulose <suzuki.poulose@arm.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        Julien Thierry <julien.thierry@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Saidi, Ali" <alisaidi@amazon.com>
References: <20190611170336.121706-1-marc.zyngier@arm.com>
 <20190611170336.121706-2-marc.zyngier@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <f6388e96-5e22-3b84-532a-e28582e5f4d5@redhat.com>
Date:   Tue, 23 Jul 2019 14:43:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190611170336.121706-2-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 23 Jul 2019 12:43:56 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,
On 6/11/19 7:03 PM, Marc Zyngier wrote:
> Add the basic data structure that expresses an MSI to LPI
> translation as well as the allocation/release hooks.
> 
> THe size of the cache is arbitrarily defined as 4*nr_vcpus.
The
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/kvm/arm_vgic.h        |  3 +++
>  virt/kvm/arm/vgic/vgic-init.c |  5 ++++
>  virt/kvm/arm/vgic/vgic-its.c  | 49 +++++++++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h      |  2 ++
>  4 files changed, 59 insertions(+)
> 
> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> index c36c86f1ec9a..ca7bcf52dc85 100644
> --- a/include/kvm/arm_vgic.h
> +++ b/include/kvm/arm_vgic.h
> @@ -260,6 +260,9 @@ struct vgic_dist {
>  	struct list_head	lpi_list_head;
>  	int			lpi_list_count;
>  
> +	/* LPI translation cache */
> +	struct list_head	lpi_translation_cache;
> +
>  	/* used by vgic-debug */
>  	struct vgic_state_iter *iter;
>  
> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> index 3bdb31eaed64..c7c4c77dd430 100644
> --- a/virt/kvm/arm/vgic/vgic-init.c
> +++ b/virt/kvm/arm/vgic/vgic-init.c
> @@ -64,6 +64,7 @@ void kvm_vgic_early_init(struct kvm *kvm)
>  	struct vgic_dist *dist = &kvm->arch.vgic;
>  
>  	INIT_LIST_HEAD(&dist->lpi_list_head);
> +	INIT_LIST_HEAD(&dist->lpi_translation_cache);
>  	raw_spin_lock_init(&dist->lpi_list_lock);
>  }
>  
> @@ -305,6 +306,7 @@ int vgic_init(struct kvm *kvm)
>  	}
>  
>  	if (vgic_has_its(kvm)) {
> +		vgic_lpi_translation_cache_init(kvm);
>  		ret = vgic_v4_init(kvm);
>  		if (ret)
>  			goto out;
> @@ -346,6 +348,9 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
>  		INIT_LIST_HEAD(&dist->rd_regions);
>  	}
>  
> +	if (vgic_has_its(kvm))
> +		vgic_lpi_translation_cache_destroy(kvm);
> +
>  	if (vgic_supports_direct_msis(kvm))
>  		vgic_v4_teardown(kvm);
>  }
> diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
> index 44ceaccb18cf..ce9bcddeb7f1 100644
> --- a/virt/kvm/arm/vgic/vgic-its.c
> +++ b/virt/kvm/arm/vgic/vgic-its.c
> @@ -149,6 +149,14 @@ struct its_ite {
>  	u32 event_id;
>  };
>  
> +struct vgic_translation_cache_entry {
> +	struct list_head	entry;
> +	phys_addr_t		db;
> +	u32			devid;
> +	u32			eventid;
> +	struct vgic_irq		*irq;
> +};
> +
>  /**
>   * struct vgic_its_abi - ITS abi ops and settings
>   * @cte_esz: collection table entry size
> @@ -1668,6 +1676,45 @@ static int vgic_register_its_iodev(struct kvm *kvm, struct vgic_its *its,
>  	return ret;
>  }
>  
> +/* Default is 16 cached LPIs per vcpu */
> +#define LPI_DEFAULT_PCPU_CACHE_SIZE	16
> +
> +void vgic_lpi_translation_cache_init(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	unsigned int sz;
> +	int i;
> +
> +	if (!list_empty(&dist->lpi_translation_cache))
> +		return;
> +
> +	sz = atomic_read(&kvm->online_vcpus) * LPI_DEFAULT_PCPU_CACHE_SIZE;
> +
> +	for (i = 0; i < sz; i++) {
> +		struct vgic_translation_cache_entry *cte;
> +
> +		/* An allocation failure is not fatal */
> +		cte = kzalloc(sizeof(*cte), GFP_KERNEL);
> +		if (WARN_ON(!cte))
> +			break;
> +
> +		INIT_LIST_HEAD(&cte->entry);
> +		list_add(&cte->entry, &dist->lpi_translation_cache);
> +	}
> +}
> +
> +void vgic_lpi_translation_cache_destroy(struct kvm *kvm)
> +{
> +	struct vgic_dist *dist = &kvm->arch.vgic;
> +	struct vgic_translation_cache_entry *cte, *tmp;
> +
> +	list_for_each_entry_safe(cte, tmp,
> +				 &dist->lpi_translation_cache, entry) {
> +		list_del(&cte->entry);
> +		kfree(cte);
> +	}
> +}
> +
>  #define INITIAL_BASER_VALUE						  \
>  	(GIC_BASER_CACHEABILITY(GITS_BASER, INNER, RaWb)		| \
>  	 GIC_BASER_CACHEABILITY(GITS_BASER, OUTER, SameAsInner)		| \
> @@ -1696,6 +1743,8 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>  			kfree(its);
>  			return ret;
>  		}
> +
> +		vgic_lpi_translation_cache_init(dev->kvm);
>  	}
>  
>  	mutex_init(&its->its_lock);
> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> index abeeffabc456..50aad705c4a9 100644
> --- a/virt/kvm/arm/vgic/vgic.h
> +++ b/virt/kvm/arm/vgic/vgic.h
> @@ -316,6 +316,8 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr);
>  int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
>  			 u32 devid, u32 eventid, struct vgic_irq **irq);
>  struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
> +void vgic_lpi_translation_cache_init(struct kvm *kvm);
> +void vgic_lpi_translation_cache_destroy(struct kvm *kvm);
>  
>  bool vgic_supports_direct_msis(struct kvm *kvm);
>  int vgic_v4_init(struct kvm *kvm);
> 
Reviewed-by: Eric Auger <eric.auger@redhat.com>

Thanks

Eric
