Return-Path: <kvm+bounces-68312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15851D329DF
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 15:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 319FF3015185
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 14:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C243E3375A7;
	Fri, 16 Jan 2026 14:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="ptsJUHpr"
X-Original-To: kvm@vger.kernel.org
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4919B3358CF;
	Fri, 16 Jan 2026 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768573797; cv=none; b=RMKDLbGB2TImH9uX3mIbMWvidhqYxAzdTjEZN6OgI8G7ucbmMk+iSOYns6858EVt3aycTpbrp4UyfQhJOO9rHJbT4d2ynnaoQ88h0/Y52hawKSHZnwxpLbMH2pv+1E5tzXhw3eFBrc7BttiaRU+7SuzYcMyqU4spUzdjiFeYtcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768573797; c=relaxed/simple;
	bh=P5bWELZnx7HYKRLyJElIsQ45aniTXklzKdmwJZ7bIFs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AWEUs4rHfjXrbxEPSZfCaEvOo3EIJ6FGNn4L7rrgfIHk09XJWbvvZzRtep0kO+n31QdNl8GvF1/CnBweNQTJymDLrj6F2pam2VHnuYSXZ2eouTroq97buIjpyHhsLYzDmR0I4JM0AGuJVAsQFwjEztTcF4CEaciiAERZgg/LYfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=ptsJUHpr; arc=none smtp.client-ip=115.124.30.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768573787; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=SSFZKRDXOJaADb5rkCSYzMMDSCFhuQrEDCCYOkyHnFY=;
	b=ptsJUHprdFYibIYfQ49CzYuO5jkXkeYadaSpSEegDoaenIqtvpTyOzxPCsW9c4oZmg7KogU5w0FCknQiTjcjU+i9+BfM+cDR5SbEmwIrC16s7ztuI6zxT+b1d0CzZKYzOyzQSX62jtNbxsRjqofRqIqo5fU/Ic8t6QfkgOBhBT4=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WxARS8i_1768573784 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 16 Jan 2026 22:29:45 +0800
From: fangyu.yu@linux.alibaba.com
To: andrew.jones@oss.qualcomm.com
Cc: ajones@ventanamicro.com,
	alex@ghiti.fr,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	atish.patra@linux.dev,
	corbet@lwn.net,
	fangyu.yu@linux.alibaba.com,
	guoren@kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	palmer@dabbelt.com,
	pbonzini@redhat.com,
	pjw@kernel.org,
	rkrcmar@ventanamicro.com
Subject: Re: Re: [PATCH v2] RISC-V: KVM: Support runtime configuration for per-VM's HGATP mode
Date: Fri, 16 Jan 2026 22:29:39 +0800
Message-Id: <20260116142939.30503-1-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <7rxerhpw33mhucn2m563iersxfarcck67vcmm5o3u25tmcrahf@lsjqygd5jj4b>
References: <7rxerhpw33mhucn2m563iersxfarcck67vcmm5o3u25tmcrahf@lsjqygd5jj4b>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

>> From: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>>
>> Introduces two per-VM architecture-specific fields to support runtime
>> configuration of the G-stage page table format:
>>
>> - kvm->arch.kvm_riscv_gstage_mode: specifies the HGATP mode used by the
>>   current VM;
>> - kvm->arch.kvm_riscv_gstage_pgd_levels: the corresponding number of page
>>   table levels for the selected mode.
>>
>> These fields replace the previous global variables
>> kvm_riscv_gstage_mode and kvm_riscv_gstage_pgd_levels, enabling different
>> virtual machines to independently select their G-stage page table format
>> instead of being forced to share the maximum mode detected by the kernel
>> at boot time.
>>
>> Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
>> ---
>>  arch/riscv/include/asm/kvm_gstage.h | 12 ++---
>>  arch/riscv/include/asm/kvm_host.h   |  4 ++
>>  arch/riscv/kvm/gstage.c             | 82 +++++++++++++++++------------
>>  arch/riscv/kvm/main.c               |  4 +-
>>  arch/riscv/kvm/mmu.c                | 18 +++++--
>>  arch/riscv/kvm/vm.c                 |  2 +-
>>  arch/riscv/kvm/vmid.c               |  2 +-
>>  7 files changed, 74 insertions(+), 50 deletions(-)
>>
>> diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/kvm_gstage.h
>> index 595e2183173e..fdcada123b3f 100644
>> --- a/arch/riscv/include/asm/kvm_gstage.h
>> +++ b/arch/riscv/include/asm/kvm_gstage.h
>> @@ -29,16 +29,11 @@ struct kvm_gstage_mapping {
>>  #define kvm_riscv_gstage_index_bits	10
>>  #endif
>>
>> -extern unsigned long kvm_riscv_gstage_mode;
>> -extern unsigned long kvm_riscv_gstage_pgd_levels;
>> +extern unsigned long kvm_riscv_gstage_max_mode;
>> +extern unsigned long kvm_riscv_gstage_max_pgd_levels;
>>
>>  #define kvm_riscv_gstage_pgd_xbits	2
>>  #define kvm_riscv_gstage_pgd_size	(1UL << (HGATP_PAGE_SHIFT + kvm_riscv_gstage_pgd_xbits))
>> -#define kvm_riscv_gstage_gpa_bits	(HGATP_PAGE_SHIFT + \
>> -					 (kvm_riscv_gstage_pgd_levels * \
>> -					  kvm_riscv_gstage_index_bits) + \
>> -					 kvm_riscv_gstage_pgd_xbits)
>> -#define kvm_riscv_gstage_gpa_size	((gpa_t)(1ULL << kvm_riscv_gstage_gpa_bits))
>>
>>  bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
>>  			       pte_t **ptepp, u32 *ptep_level);
>> @@ -69,4 +64,7 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
>>
>>  void kvm_riscv_gstage_mode_detect(void);
>>
>> +gpa_t kvm_riscv_gstage_gpa_size(struct kvm_arch *k);
>> +unsigned long kvm_riscv_gstage_gpa_bits(struct kvm_arch *k);
>> +
>>  #endif
>> diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
>> index 24585304c02b..27ea8e8fd5b0 100644
>> --- a/arch/riscv/include/asm/kvm_host.h
>> +++ b/arch/riscv/include/asm/kvm_host.h
>> @@ -103,6 +103,10 @@ struct kvm_arch {
>>
>>  	/* KVM_CAP_RISCV_MP_STATE_RESET */
>>  	bool mp_state_reset;
>> +
>> +	unsigned long kvm_riscv_gstage_mode;
>
>There's a 1:1 mapping for mode/levels, so we don't need to track both.
>Since mode is rarely used, then I think something like this would still
>provide enough convenience without requiring the storage allocation.
>
> static inline unsigned long kvm_riscv_gstage_mode(struct kvm_gstage *gstage)
> {
>     unsigned long modes[] = {
>         [2] = HGATP_MODE_SV32X4,
>         [3] = HGATP_MODE_SV39X4,
>         [4] = HGATP_MODE_SV48X4,
>         [5] = HGATP_MODE_SV57X4,
>     };
>
>     return modes[gstage->kvm->arch.kvm_riscv_gstage_pgd_levels];
> }

Thanks for the suggestion.

You're right that gstage mode has a 1:1 mapping with pgd_levels, so keeping
both is redundant. In the next revision I'll drop kvm_riscv_gstage_mode and
derive HGATP.MODE from kvm_riscv_gstage_pgd_levels via a small helper.

>> +	unsigned long kvm_riscv_gstage_pgd_levels;
>> +	bool gstage_mode_initialized;
>>  };
>>
>>  struct kvm_cpu_trap {
>> diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
>> index b67d60d722c2..06452e4c2ab2 100644
>> --- a/arch/riscv/kvm/gstage.c
>> +++ b/arch/riscv/kvm/gstage.c
>> @@ -12,22 +12,23 @@
>>  #include <asm/kvm_gstage.h>
>>
>>  #ifdef CONFIG_64BIT
>> -unsigned long kvm_riscv_gstage_mode __ro_after_init = HGATP_MODE_SV39X4;
>> -unsigned long kvm_riscv_gstage_pgd_levels __ro_after_init = 3;
>> +unsigned long kvm_riscv_gstage_max_mode __ro_after_init = HGATP_MODE_SV39X4;
>
>With a kvm_riscv_gstage_mode() function we don't need
>kvm_riscv_gstage_max_mode either.

Thanks, agreed.

>> +unsigned long kvm_riscv_gstage_max_pgd_levels __ro_after_init = 3;
>>  #else
>> -unsigned long kvm_riscv_gstage_mode __ro_after_init = HGATP_MODE_SV32X4;
>> -unsigned long kvm_riscv_gstage_pgd_levels __ro_after_init = 2;
>> +unsigned long kvm_riscv_gstage_max_mode __ro_after_init = HGATP_MODE_SV32X4;
>> +unsigned long kvm_riscv_gstage_max_pgd_levels __ro_after_init = 2;
>>  #endif
>>
>>  #define gstage_pte_leaf(__ptep)	\
>>  	(pte_val(*(__ptep)) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC))
>>
>> -static inline unsigned long gstage_pte_index(gpa_t addr, u32 level)
>> +static inline unsigned long gstage_pte_index(struct kvm_gstage *gstage,
>> +					     gpa_t addr, u32 level)
>>  {
>>  	unsigned long mask;
>>  	unsigned long shift = HGATP_PAGE_SHIFT + (kvm_riscv_gstage_index_bits * level);
>>
>> -	if (level == (kvm_riscv_gstage_pgd_levels - 1))
>> +	if (level == (gstage->kvm->arch.kvm_riscv_gstage_pgd_levels - 1))
>
>nit: we can drop the unnecessary () while touching this line.

Ack, will fix.

>>  		mask = (PTRS_PER_PTE * (1UL << kvm_riscv_gstage_pgd_xbits)) - 1;
>>  	else
>>  		mask = PTRS_PER_PTE - 1;
>> @@ -40,12 +41,13 @@ static inline unsigned long gstage_pte_page_vaddr(pte_t pte)
>>  	return (unsigned long)pfn_to_virt(__page_val_to_pfn(pte_val(pte)));
>>  }
>>
>> -static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
>> +static int gstage_page_size_to_level(struct kvm_gstage *gstage, unsigned long page_size,
>> +				     u32 *out_level)
>>  {
>>  	u32 i;
>>  	unsigned long psz = 1UL << 12;
>>
>> -	for (i = 0; i < kvm_riscv_gstage_pgd_levels; i++) {
>> +	for (i = 0; i < gstage->kvm->arch.kvm_riscv_gstage_pgd_levels; i++) {
>>  		if (page_size == (psz << (i * kvm_riscv_gstage_index_bits))) {
>>  			*out_level = i;
>>  			return 0;
>> @@ -55,21 +57,23 @@ static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
>>  	return -EINVAL;
>>  }
>>
>> -static int gstage_level_to_page_order(u32 level, unsigned long *out_pgorder)
>> +static int gstage_level_to_page_order(struct kvm_gstage *gstage, u32 level,
>> +				      unsigned long *out_pgorder)
>>  {
>> -	if (kvm_riscv_gstage_pgd_levels < level)
>> +	if (gstage->kvm->arch.kvm_riscv_gstage_pgd_levels < level)
>>  		return -EINVAL;
>>
>>  	*out_pgorder = 12 + (level * kvm_riscv_gstage_index_bits);
>>  	return 0;
>>  }
>>
>> -static int gstage_level_to_page_size(u32 level, unsigned long *out_pgsize)
>> +static int gstage_level_to_page_size(struct kvm_gstage *gstage, u32 level,
>> +				     unsigned long *out_pgsize)
>>  {
>>  	int rc;
>>  	unsigned long page_order = PAGE_SHIFT;
>>
>> -	rc = gstage_level_to_page_order(level, &page_order);
>> +	rc = gstage_level_to_page_order(gstage, level, &page_order);
>>  	if (rc)
>>  		return rc;
>>
>> @@ -81,11 +85,11 @@ bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
>>  			       pte_t **ptepp, u32 *ptep_level)
>>  {
>>  	pte_t *ptep;
>> -	u32 current_level = kvm_riscv_gstage_pgd_levels - 1;
>> +	u32 current_level = gstage->kvm->arch.kvm_riscv_gstage_pgd_levels - 1;
>>
>>  	*ptep_level = current_level;
>>  	ptep = (pte_t *)gstage->pgd;
>> -	ptep = &ptep[gstage_pte_index(addr, current_level)];
>> +	ptep = &ptep[gstage_pte_index(gstage, addr, current_level)];
>>  	while (ptep && pte_val(ptep_get(ptep))) {
>>  		if (gstage_pte_leaf(ptep)) {
>>  			*ptep_level = current_level;
>> @@ -97,7 +101,7 @@ bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
>>  			current_level--;
>>  			*ptep_level = current_level;
>>  			ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
>> -			ptep = &ptep[gstage_pte_index(addr, current_level)];
>> +			ptep = &ptep[gstage_pte_index(gstage, addr, current_level)];
>>  		} else {
>>  			ptep = NULL;
>>  		}
>> @@ -110,7 +114,7 @@ static void gstage_tlb_flush(struct kvm_gstage *gstage, u32 level, gpa_t addr)
>>  {
>>  	unsigned long order = PAGE_SHIFT;
>>
>> -	if (gstage_level_to_page_order(level, &order))
>> +	if (gstage_level_to_page_order(gstage, level, &order))
>>  		return;
>>  	addr &= ~(BIT(order) - 1);
>>
>> @@ -125,9 +129,9 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
>>  			     struct kvm_mmu_memory_cache *pcache,
>>  			     const struct kvm_gstage_mapping *map)
>>  {
>> -	u32 current_level = kvm_riscv_gstage_pgd_levels - 1;
>> +	u32 current_level = gstage->kvm->arch.kvm_riscv_gstage_pgd_levels - 1;
>>  	pte_t *next_ptep = (pte_t *)gstage->pgd;
>> -	pte_t *ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
>> +	pte_t *ptep = &next_ptep[gstage_pte_index(gstage, map->addr, current_level)];
>>
>>  	if (current_level < map->level)
>>  		return -EINVAL;
>> @@ -151,7 +155,7 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
>>  		}
>>
>>  		current_level--;
>> -		ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
>> +		ptep = &next_ptep[gstage_pte_index(gstage, map->addr, current_level)];
>>  	}
>>
>>  	if (pte_val(*ptep) != pte_val(map->pte)) {
>> @@ -175,7 +179,7 @@ int kvm_riscv_gstage_map_page(struct kvm_gstage *gstage,
>>  	out_map->addr = gpa;
>>  	out_map->level = 0;
>>
>> -	ret = gstage_page_size_to_level(page_size, &out_map->level);
>> +	ret = gstage_page_size_to_level(gstage, page_size, &out_map->level);
>>  	if (ret)
>>  		return ret;
>>
>> @@ -217,7 +221,7 @@ void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
>>  	u32 next_ptep_level;
>>  	unsigned long next_page_size, page_size;
>>
>> -	ret = gstage_level_to_page_size(ptep_level, &page_size);
>> +	ret = gstage_level_to_page_size(gstage, ptep_level, &page_size);
>>  	if (ret)
>>  		return;
>>
>> @@ -229,7 +233,7 @@ void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
>>  	if (ptep_level && !gstage_pte_leaf(ptep)) {
>>  		next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
>>  		next_ptep_level = ptep_level - 1;
>> -		ret = gstage_level_to_page_size(next_ptep_level, &next_page_size);
>> +		ret = gstage_level_to_page_size(gstage, next_ptep_level, &next_page_size);
>>  		if (ret)
>>  			return;
>>
>> @@ -263,7 +267,7 @@ void kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
>>
>>  	while (addr < end) {
>>  		found_leaf = kvm_riscv_gstage_get_leaf(gstage, addr, &ptep, &ptep_level);
>> -		ret = gstage_level_to_page_size(ptep_level, &page_size);
>> +		ret = gstage_level_to_page_size(gstage, ptep_level, &page_size);
>>  		if (ret)
>>  			break;
>>
>> @@ -297,7 +301,7 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
>>
>>  	while (addr < end) {
>>  		found_leaf = kvm_riscv_gstage_get_leaf(gstage, addr, &ptep, &ptep_level);
>> -		ret = gstage_level_to_page_size(ptep_level, &page_size);
>> +		ret = gstage_level_to_page_size(gstage, ptep_level, &page_size);
>>  		if (ret)
>>  			break;
>>
>> @@ -319,41 +323,51 @@ void __init kvm_riscv_gstage_mode_detect(void)
>>  	/* Try Sv57x4 G-stage mode */
>>  	csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
>>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
>> -		kvm_riscv_gstage_mode = HGATP_MODE_SV57X4;
>> -		kvm_riscv_gstage_pgd_levels = 5;
>> +		kvm_riscv_gstage_max_mode = HGATP_MODE_SV57X4;
>> +		kvm_riscv_gstage_max_pgd_levels = 5;
>>  		goto done;
>>  	}
>>
>>  	/* Try Sv48x4 G-stage mode */
>>  	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
>>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
>> -		kvm_riscv_gstage_mode = HGATP_MODE_SV48X4;
>> -		kvm_riscv_gstage_pgd_levels = 4;
>> +		kvm_riscv_gstage_max_mode = HGATP_MODE_SV48X4;
>> +		kvm_riscv_gstage_max_pgd_levels = 4;
>>  		goto done;
>>  	}
>>
>>  	/* Try Sv39x4 G-stage mode */
>>  	csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
>>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV39X4) {
>> -		kvm_riscv_gstage_mode = HGATP_MODE_SV39X4;
>> -		kvm_riscv_gstage_pgd_levels = 3;
>> +		kvm_riscv_gstage_max_mode = HGATP_MODE_SV39X4;
>> +		kvm_riscv_gstage_max_pgd_levels = 3;
>>  		goto done;
>>  	}
>>  #else /* CONFIG_32BIT */
>>  	/* Try Sv32x4 G-stage mode */
>>  	csr_write(CSR_HGATP, HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
>>  	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV32X4) {
>> -		kvm_riscv_gstage_mode = HGATP_MODE_SV32X4;
>> -		kvm_riscv_gstage_pgd_levels = 2;
>> +		kvm_riscv_gstage_max_mode = HGATP_MODE_SV32X4;
>> +		kvm_riscv_gstage_max_pgd_levels = 2;
>>  		goto done;
>>  	}
>>  #endif
>>
>>  	/* KVM depends on !HGATP_MODE_OFF */
>> -	kvm_riscv_gstage_mode = HGATP_MODE_OFF;
>> -	kvm_riscv_gstage_pgd_levels = 0;
>> +	kvm_riscv_gstage_max_mode = HGATP_MODE_OFF;
>> +	kvm_riscv_gstage_max_pgd_levels = 0;
>>
>>  done:
>>  	csr_write(CSR_HGATP, 0);
>>  	kvm_riscv_local_hfence_gvma_all();
>>  }
>> +
>> +unsigned long kvm_riscv_gstage_gpa_bits(struct kvm_arch *k) {
>
>Did you run checkpatch? I think it requires '{' to be on its own line.
>
>nit: s/k/ka/ would be consistent with other archs, although I see k is
>used in riscv's kvm_riscv_mmu_update_hgatp() but that can be fixed up
>in this patch since there's a change in the same place too.

Thanks for catching that.

Yes, checkpatch complains about the opening brace placement here. I'll fix
the style by moving '{' onto its own line. I'll also rename the argument
from 'k' to 'ka' for consistency (and update the existing usage in
kvm_riscv_mmu_update_hgatp() in the same patch since we're touching it
anyway).

I'll apply the same fixes to kvm_riscv_gstage_gpa_size() as well.

>
>> +	return (HGATP_PAGE_SHIFT + (k->kvm_riscv_gstage_pgd_levels *
>> +		    kvm_riscv_gstage_index_bits) +
>> +		    kvm_riscv_gstage_pgd_xbits);
>> +}
>> +
>> +gpa_t kvm_riscv_gstage_gpa_size(struct kvm_arch *k) {
>
>same comments as above
>
>> +	return ((gpa_t)(1ULL << kvm_riscv_gstage_gpa_bits(k)));
>
> return BIT_ULL(kvm_riscv_gstage_gpa_bits(ka))
>
>(the cast is implicit from return type)
>
>> +}
>> diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
>> index 45536af521f0..56a246e0e791 100644
>> --- a/arch/riscv/kvm/main.c
>> +++ b/arch/riscv/kvm/main.c
>> @@ -105,7 +105,7 @@ static int __init riscv_kvm_init(void)
>>  		return rc;
>>
>>  	kvm_riscv_gstage_mode_detect();
>> -	switch (kvm_riscv_gstage_mode) {
>> +	switch (kvm_riscv_gstage_max_mode) {
>>  	case HGATP_MODE_SV32X4:
>>  		str = "Sv32x4";
>>  		break;
>> @@ -164,7 +164,7 @@ static int __init riscv_kvm_init(void)
>>  			 (rc) ? slist : "no features");
>>  	}
>>
>> -	kvm_info("using %s G-stage page table format\n", str);
>> +	kvm_info("Max G-stage page table format %s \n", str);
>>
>>  	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
>>
>> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
>> index 4ab06697bfc0..574783907162 100644
>> --- a/arch/riscv/kvm/mmu.c
>> +++ b/arch/riscv/kvm/mmu.c
>> @@ -67,7 +67,7 @@ int kvm_riscv_mmu_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>>  		if (!writable)
>>  			map.pte = pte_wrprotect(map.pte);
>>
>> -		ret = kvm_mmu_topup_memory_cache(&pcache, kvm_riscv_gstage_pgd_levels);
>> +		ret = kvm_mmu_topup_memory_cache(&pcache,kvm->arch.kvm_riscv_gstage_pgd_levels);
>                                                         ^ missing space
>
>>  		if (ret)
>>  			goto out;
>>
>> @@ -186,8 +186,9 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
>>  	 * space addressable by the KVM guest GPA space.
>>  	 */
>>  	if ((new->base_gfn + new->npages) >=
>> -	    (kvm_riscv_gstage_gpa_size >> PAGE_SHIFT))
>> +			(kvm_riscv_gstage_gpa_size(&kvm->arch) >> PAGE_SHIFT)) {
>>  		return -EFAULT;
>> +	}
>
>nit: Remove the unnecessary () and the '{' and the condition will fit on
>one 100 char line.

Ack.

>>
>>  	hva = new->userspace_addr;
>>  	size = new->npages << PAGE_SHIFT;
>> @@ -332,7 +333,7 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
>>  	memset(out_map, 0, sizeof(*out_map));
>>
>>  	/* We need minimum second+third level pages */
>> -	ret = kvm_mmu_topup_memory_cache(pcache, kvm_riscv_gstage_pgd_levels);
>> +	ret = kvm_mmu_topup_memory_cache(pcache, kvm->arch.kvm_riscv_gstage_pgd_levels);
>>  	if (ret) {
>>  		kvm_err("Failed to topup G-stage cache\n");
>>  		return ret;
>> @@ -431,6 +432,11 @@ int kvm_riscv_mmu_alloc_pgd(struct kvm *kvm)
>>  		return -ENOMEM;
>>  	kvm->arch.pgd = page_to_virt(pgd_page);
>>  	kvm->arch.pgd_phys = page_to_phys(pgd_page);
>> +	if (!kvm->arch.gstage_mode_initialized) {
>> +		/*user-space didn't set KVM_CAP_RISC_HGATP_MODE cap*/
>                  ^ missing space                                  ^ missing space
>> +		kvm->arch.kvm_riscv_gstage_mode = kvm_riscv_gstage_max_mode;
>> +		kvm->arch.kvm_riscv_gstage_pgd_levels = kvm_riscv_gstage_max_pgd_levels;
>
>Missing 'kvm->arch.gstage_mode_initialized = true' statement.

The initialization is done in the following commit of this series (patch 2/2)

>> +	}
>>
>>  	return 0;
>>  }
>> @@ -446,10 +452,12 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
>>  		gstage.flags = 0;
>>  		gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
>>  		gstage.pgd = kvm->arch.pgd;
>> -		kvm_riscv_gstage_unmap_range(&gstage, 0UL, kvm_riscv_gstage_gpa_size, false);
>> +		kvm_riscv_gstage_unmap_range(&gstage, 0UL, kvm_riscv_gstage_gpa_size(&kvm->arch), false);
>>  		pgd = READ_ONCE(kvm->arch.pgd);
>>  		kvm->arch.pgd = NULL;
>>  		kvm->arch.pgd_phys = 0;
>> +		kvm->arch.kvm_riscv_gstage_mode = HGATP_MODE_OFF;
>> +		kvm->arch.kvm_riscv_gstage_pgd_levels = 0;
>>  	}
>>  	spin_unlock(&kvm->mmu_lock);
>>
>> @@ -459,8 +467,8 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
>>
>>  void kvm_riscv_mmu_update_hgatp(struct kvm_vcpu *vcpu)
>>  {
>> -	unsigned long hgatp = kvm_riscv_gstage_mode << HGATP_MODE_SHIFT;
>>  	struct kvm_arch *k = &vcpu->kvm->arch;
>> +	unsigned long hgatp = k->kvm_riscv_gstage_mode << HGATP_MODE_SHIFT;
>>
>>  	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) & HGATP_VMID;
>>  	hgatp |= (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
>> diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
>> index 66d91ae6e9b2..4b2156df40fc 100644
>> --- a/arch/riscv/kvm/vm.c
>> +++ b/arch/riscv/kvm/vm.c
>> @@ -200,7 +200,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  		r = KVM_USER_MEM_SLOTS;
>>  		break;
>>  	case KVM_CAP_VM_GPA_BITS:
>> -		r = kvm_riscv_gstage_gpa_bits;
>> +		r = kvm_riscv_gstage_gpa_bits(&kvm->arch);
>>  		break;
>>  	default:
>>  		r = 0;
>> diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
>> index cf34d448289d..db27430f111e 100644
>> --- a/arch/riscv/kvm/vmid.c
>> +++ b/arch/riscv/kvm/vmid.c
>> @@ -26,7 +26,7 @@ static DEFINE_SPINLOCK(vmid_lock);
>>  void __init kvm_riscv_gstage_vmid_detect(void)
>>  {
>>  	/* Figure-out number of VMID bits in HW */
>> -	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
>> +	csr_write(CSR_HGATP, (kvm_riscv_gstage_max_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
>>  	vmid_bits = csr_read(CSR_HGATP);
>>  	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
>>  	vmid_bits = fls_long(vmid_bits);
>> --
>> 2.50.1
>>
>
>Thanks,
>drew
>
Thanks,
Fangyu

