Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AFB33EAEE
	for <lists+kvm@lfdr.de>; Wed, 17 Mar 2021 08:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbhCQH5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 03:57:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:60076 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230221AbhCQH5a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 03:57:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1615967848; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mee6Y3oBKYswlI6OGhWkSltHQeRklEfp7DNpmFJ+4UA=;
        b=qU27V+83mFteQx0y9W41H09Fb9/cnRQw26xu6Owi/2aM/djNaWJdA0hFhr/PlDzE789xik
        +AZNCaykQ70yd/tHT/9PHFj/cdT8ghO9iufkW8ogM3xQiHnohZvMXFQYudb//waE8OpbHS
        hWKLP6UAfTj9/eyBtAKURhEPXwdI1mE=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A7D4CAE05;
        Wed, 17 Mar 2021 07:57:28 +0000 (UTC)
Date:   Wed, 17 Mar 2021 08:57:27 +0100
From:   Michal Hocko <mhocko@suse.com>
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: arm: memcg awareness
Message-ID: <YFG2Z1q9MJGr8Zek@dhcp22.suse.cz>
References: <1615959984-7122-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1615959984-7122-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed 17-03-21 13:46:24, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> KVM allocations in the arm kvm code which are tied to the life 
> of the VM process should be charged to the VM process's cgroup.

How much memory are we talking about?

> This will help the memcg controler to do the right decisions.

This is a bit vague. What is the right decision? AFAICS none of that
memory is considered during oom victim selection. The only thing memcg
controler can help with is to contain and account this additional
memory. This might help to better isolate multiple workloads on the same
system. Maybe this is what you wanted to say? Or maybe this is a way to
prevent untrusted users from consuming a lot of memory?

> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/arm64/kvm/arm.c               |  5 +++--
>  arch/arm64/kvm/hyp/pgtable.c       |  4 ++--
>  arch/arm64/kvm/mmu.c               |  4 ++--
>  arch/arm64/kvm/pmu-emul.c          |  2 +-
>  arch/arm64/kvm/reset.c             |  2 +-
>  arch/arm64/kvm/vgic/vgic-debug.c   |  2 +-
>  arch/arm64/kvm/vgic/vgic-init.c    |  2 +-
>  arch/arm64/kvm/vgic/vgic-irqfd.c   |  2 +-
>  arch/arm64/kvm/vgic/vgic-its.c     | 14 +++++++-------
>  arch/arm64/kvm/vgic/vgic-mmio-v3.c |  2 +-
>  arch/arm64/kvm/vgic/vgic-v4.c      |  2 +-
>  11 files changed, 21 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 7f06ba7..8040874 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -278,9 +278,10 @@ long kvm_arch_dev_ioctl(struct file *filp,
>  struct kvm *kvm_arch_alloc_vm(void)
>  {
>  	if (!has_vhe())
> -		return kzalloc(sizeof(struct kvm), GFP_KERNEL);
> +		return kzalloc(sizeof(struct kvm), GFP_KERNEL_ACCOUNT);
>  
> -	return vzalloc(sizeof(struct kvm));
> +	return __vmalloc(sizeof(struct kvm),
> +			GFP_KERNEL_ACCOUNT | __GFP_ZERO);
>  }
>  
>  void kvm_arch_free_vm(struct kvm *kvm)
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 926fc07..a0845d3 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -366,7 +366,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
>  	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
>  		return -EINVAL;
>  
> -	childp = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
> +	childp = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>  	if (!childp)
>  		return -ENOMEM;
>  
> @@ -401,7 +401,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits)
>  {
>  	u64 levels = ARM64_HW_PGTABLE_LEVELS(va_bits);
>  
> -	pgt->pgd = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL);
> +	pgt->pgd = (kvm_pte_t *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
>  	if (!pgt->pgd)
>  		return -ENOMEM;
>  
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 8711894..8c9dc49 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -370,7 +370,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>  		return -EINVAL;
>  	}
>  
> -	pgt = kzalloc(sizeof(*pgt), GFP_KERNEL);
> +	pgt = kzalloc(sizeof(*pgt), GFP_KERNEL_ACCOUNT);
>  	if (!pgt)
>  		return -ENOMEM;
>  
> @@ -1244,7 +1244,7 @@ int kvm_mmu_init(void)
>  		goto out;
>  	}
>  
> -	hyp_pgtable = kzalloc(sizeof(*hyp_pgtable), GFP_KERNEL);
> +	hyp_pgtable = kzalloc(sizeof(*hyp_pgtable), GFP_KERNEL_ACCOUNT);
>  	if (!hyp_pgtable) {
>  		kvm_err("Hyp mode page-table not allocated\n");
>  		err = -ENOMEM;
> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> index e32c6e1..00cf750 100644
> --- a/arch/arm64/kvm/pmu-emul.c
> +++ b/arch/arm64/kvm/pmu-emul.c
> @@ -967,7 +967,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
>  		mutex_lock(&vcpu->kvm->lock);
>  
>  		if (!vcpu->kvm->arch.pmu_filter) {
> -			vcpu->kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL);
> +			vcpu->kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
>  			if (!vcpu->kvm->arch.pmu_filter) {
>  				mutex_unlock(&vcpu->kvm->lock);
>  				return -ENOMEM;
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index bd354cd..3cbcf6b 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -110,7 +110,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
>  		    vl > SVE_VL_ARCH_MAX))
>  		return -EIO;
>  
> -	buf = kzalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl)), GFP_KERNEL);
> +	buf = kzalloc(SVE_SIG_REGS_SIZE(sve_vq_from_vl(vl)), GFP_KERNEL_ACCOUNT);
>  	if (!buf)
>  		return -ENOMEM;
>  
> diff --git a/arch/arm64/kvm/vgic/vgic-debug.c b/arch/arm64/kvm/vgic/vgic-debug.c
> index f38c40a..e6a01f2 100644
> --- a/arch/arm64/kvm/vgic/vgic-debug.c
> +++ b/arch/arm64/kvm/vgic/vgic-debug.c
> @@ -92,7 +92,7 @@ static void *vgic_debug_start(struct seq_file *s, loff_t *pos)
>  		goto out;
>  	}
>  
> -	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
> +	iter = kmalloc(sizeof(*iter), GFP_KERNEL_ACCOUNT);
>  	if (!iter) {
>  		iter = ERR_PTR(-ENOMEM);
>  		goto out;
> diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
> index 052917d..27d1513 100644
> --- a/arch/arm64/kvm/vgic/vgic-init.c
> +++ b/arch/arm64/kvm/vgic/vgic-init.c
> @@ -134,7 +134,7 @@ static int kvm_vgic_dist_init(struct kvm *kvm, unsigned int nr_spis)
>  	struct kvm_vcpu *vcpu0 = kvm_get_vcpu(kvm, 0);
>  	int i;
>  
> -	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL);
> +	dist->spis = kcalloc(nr_spis, sizeof(struct vgic_irq), GFP_KERNEL_ACCOUNT);
>  	if (!dist->spis)
>  		return  -ENOMEM;
>  
> diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
> index 79f8899..475059b 100644
> --- a/arch/arm64/kvm/vgic/vgic-irqfd.c
> +++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
> @@ -139,7 +139,7 @@ int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
>  	u32 nr = dist->nr_spis;
>  	int i, ret;
>  
> -	entries = kcalloc(nr, sizeof(*entries), GFP_KERNEL);
> +	entries = kcalloc(nr, sizeof(*entries), GFP_KERNEL_ACCOUNT);
>  	if (!entries)
>  		return -ENOMEM;
>  
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 40cbaca..bd90730 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -48,7 +48,7 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
>  	if (irq)
>  		return irq;
>  
> -	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL);
> +	irq = kzalloc(sizeof(struct vgic_irq), GFP_KERNEL_ACCOUNT);
>  	if (!irq)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -332,7 +332,7 @@ int vgic_copy_lpi_list(struct kvm *kvm, struct kvm_vcpu *vcpu, u32 **intid_ptr)
>  	 * we must be careful not to overrun the array.
>  	 */
>  	irq_count = READ_ONCE(dist->lpi_list_count);
> -	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL);
> +	intids = kmalloc_array(irq_count, sizeof(intids[0]), GFP_KERNEL_ACCOUNT);
>  	if (!intids)
>  		return -ENOMEM;
>  
> @@ -985,7 +985,7 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
>  	if (!vgic_its_check_id(its, its->baser_coll_table, coll_id, NULL))
>  		return E_ITS_MAPC_COLLECTION_OOR;
>  
> -	collection = kzalloc(sizeof(*collection), GFP_KERNEL);
> +	collection = kzalloc(sizeof(*collection), GFP_KERNEL_ACCOUNT);
>  	if (!collection)
>  		return -ENOMEM;
>  
> @@ -1029,7 +1029,7 @@ static struct its_ite *vgic_its_alloc_ite(struct its_device *device,
>  {
>  	struct its_ite *ite;
>  
> -	ite = kzalloc(sizeof(*ite), GFP_KERNEL);
> +	ite = kzalloc(sizeof(*ite), GFP_KERNEL_ACCOUNT);
>  	if (!ite)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -1150,7 +1150,7 @@ static struct its_device *vgic_its_alloc_device(struct vgic_its *its,
>  {
>  	struct its_device *device;
>  
> -	device = kzalloc(sizeof(*device), GFP_KERNEL);
> +	device = kzalloc(sizeof(*device), GFP_KERNEL_ACCOUNT);
>  	if (!device)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -1847,7 +1847,7 @@ void vgic_lpi_translation_cache_init(struct kvm *kvm)
>  		struct vgic_translation_cache_entry *cte;
>  
>  		/* An allocation failure is not fatal */
> -		cte = kzalloc(sizeof(*cte), GFP_KERNEL);
> +		cte = kzalloc(sizeof(*cte), GFP_KERNEL_ACCOUNT);
>  		if (WARN_ON(!cte))
>  			break;
>  
> @@ -1888,7 +1888,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
>  	if (type != KVM_DEV_TYPE_ARM_VGIC_ITS)
>  		return -ENODEV;
>  
> -	its = kzalloc(sizeof(struct vgic_its), GFP_KERNEL);
> +	its = kzalloc(sizeof(struct vgic_its), GFP_KERNEL_ACCOUNT);
>  	if (!its)
>  		return -ENOMEM;
>  
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> index 15a6c98..22ab4ba 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
> @@ -826,7 +826,7 @@ static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
>  	if (vgic_v3_rdist_overlap(kvm, base, size))
>  		return -EINVAL;
>  
> -	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL);
> +	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL_ACCOUNT);
>  	if (!rdreg)
>  		return -ENOMEM;
>  
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> index 66508b0..a80cc37 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -227,7 +227,7 @@ int vgic_v4_init(struct kvm *kvm)
>  	nr_vcpus = atomic_read(&kvm->online_vcpus);
>  
>  	dist->its_vm.vpes = kcalloc(nr_vcpus, sizeof(*dist->its_vm.vpes),
> -				    GFP_KERNEL);
> +				    GFP_KERNEL_ACCOUNT);
>  	if (!dist->its_vm.vpes)
>  		return -ENOMEM;
>  
> -- 
> 2.7.4

-- 
Michal Hocko
SUSE Labs
