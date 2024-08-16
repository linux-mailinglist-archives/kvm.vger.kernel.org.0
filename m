Return-Path: <kvm+bounces-24340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2D2953FF4
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 05:06:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8312A283994
	for <lists+kvm@lfdr.de>; Fri, 16 Aug 2024 03:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB7575D8F0;
	Fri, 16 Aug 2024 03:06:10 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EEB226AC3;
	Fri, 16 Aug 2024 03:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723777570; cv=none; b=r7884+Ab4ZYruqieKDfPi8g5XxPSInCXynqOR+9l7YDVyUnd6hKCR0ivMvrDmoGbYWeke/gxEFjIjt6ogLdpu3ZG8y8bpxFaVLA8oP4fN4F8BOW4yD/4nvNdQgOe6nJ8Wlkm++2EMS6S27Kkos78RzAs2qrivWnVyv1w79mc6EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723777570; c=relaxed/simple;
	bh=Q5jKHxkQo5cKICAWzxggHH1KD8+cy9WU3r9nsCJ5+G8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=oWRaC6+w7FPbGIHvg0/DNF/lx11nl+mlBbkLYTlvGHue42iINyEp3oF53ulrqNdleHus9FrBCmuOWHdXkNbbrsl9u9ALMNKxD/KsJ71ojpDW4jowvhylfyLsm7VDxy/3m5pR0jKBroqoJZ2pqGelqADXBPTPSQzjhep6PpYsVAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4WlRZK0cDdz1S82h;
	Fri, 16 Aug 2024 11:00:41 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 90FAE14010C;
	Fri, 16 Aug 2024 11:05:35 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 16 Aug 2024 11:05:34 +0800
Message-ID: <1147332f-790e-487f-8816-1860b8744ab2@huawei.com>
Date: Fri, 16 Aug 2024 11:05:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/19] mm: Support huge pfnmaps
Content-Language: en-US
To: Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
	<axelrasmussen@google.com>, <linux-arm-kernel@lists.infradead.org>,
	<x86@kernel.org>, Will Deacon <will@kernel.org>, Gavin Shan
	<gshan@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Zi Yan
	<ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas
	<catalin.marinas@arm.com>, Ingo Molnar <mingo@redhat.com>, Alistair Popple
	<apopple@nvidia.com>, Borislav Petkov <bp@alien8.de>, David Hildenbrand
	<david@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
	<kvm@vger.kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Alex
 Williamson <alex.williamson@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>
References: <20240809160909.1023470-1-peterx@redhat.com>
 <20240814123715.GB2032816@nvidia.com> <Zr5VA6QSBHO3rpS8@x1n>
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <Zr5VA6QSBHO3rpS8@x1n>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf100008.china.huawei.com (7.185.36.138)



On 2024/8/16 3:20, Peter Xu wrote:
> On Wed, Aug 14, 2024 at 09:37:15AM -0300, Jason Gunthorpe wrote:
>>> Currently, only x86_64 (1G+2M) and arm64 (2M) are supported.
>>
>> There is definitely interest here in extending ARM to support the 1G
>> size too, what is missing?
> 
> Currently PUD pfnmap relies on THP_PUD config option:
> 
> config ARCH_SUPPORTS_PUD_PFNMAP
> 	def_bool y
> 	depends on ARCH_SUPPORTS_HUGE_PFNMAP && HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
> 
> Arm64 unfortunately doesn't yet support dax 1G, so not applicable yet.
> 
> Ideally, pfnmap is too simple comparing to real THPs and it shouldn't
> require to depend on THP at all, but we'll need things like below to land
> first:
> 
> https://lore.kernel.org/r/20240717220219.3743374-1-peterx@redhat.com
> 
> I sent that first a while ago, but I didn't collect enough inputs, and I
> decided to unblock this series from that, so x86_64 shouldn't be affected,
> and arm64 will at least start to have 2M.
> 
>>
>>> The other trick is how to allow gup-fast working for such huge mappings
>>> even if there's no direct sign of knowing whether it's a normal page or
>>> MMIO mapping.  This series chose to keep the pte_special solution, so that
>>> it reuses similar idea on setting a special bit to pfnmap PMDs/PUDs so that
>>> gup-fast will be able to identify them and fail properly.
>>
>> Make sense
>>
>>> More architectures / More page sizes
>>> ------------------------------------
>>>
>>> Currently only x86_64 (2M+1G) and arm64 (2M) are supported.
>>>
>>> For example, if arm64 can start to support THP_PUD one day, the huge pfnmap
>>> on 1G will be automatically enabled.

A draft patch to enable THP_PUD on arm64, only passed with 
DEBUG_VM_PGTABLE, we may test pud pfnmaps on arm64.

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a2f8ff354ca6..ff0d27c72020 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -184,6 +184,7 @@ config ARM64
  	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
  	select HAVE_ARCH_TRACEHOOK
  	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if PGTABLE_LEVELS > 2
  	select HAVE_ARCH_VMAP_STACK
  	select HAVE_ARM_SMCCC
  	select HAVE_ASM_MODVERSIONS
diff --git a/arch/arm64/include/asm/pgtable.h 
b/arch/arm64/include/asm/pgtable.h
index 7a4f5604be3f..e013fe458476 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -763,6 +763,25 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
  #define pud_valid(pud)		pte_valid(pud_pte(pud))
  #define pud_user(pud)		pte_user(pud_pte(pud))
  #define pud_user_exec(pud)	pte_user_exec(pud_pte(pud))
+#define pud_dirty(pud)		pte_dirty(pud_pte(pud))
+#define pud_devmap(pud)		pte_devmap(pud_pte(pud))
+#define pud_wrprotect(pud)	pte_pud(pte_wrprotect(pud_pte(pud)))
+#define pud_mkold(pud)		pte_pud(pte_mkold(pud_pte(pud)))
+#define pud_mkwrite(pud)	pte_pud(pte_mkwrite_novma(pud_pte(pud)))
+#define pud_mkclean(pud)	pte_pud(pte_mkclean(pud_pte(pud)))
+#define pud_mkdirty(pud)	pte_pud(pte_mkdirty(pud_pte(pud)))
+
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline int pud_trans_huge(pud_t pud)
+{
+	return pud_val(pud) && pud_present(pud) && !(pud_val(pud) & 
PUD_TABLE_BIT);
+}
+
+static inline pud_t pud_mkdevmap(pud_t pud)
+{
+	return pte_pud(set_pte_bit(pud_pte(pud), __pgprot(PTE_DEVMAP)));
+}
+#endif

  static inline bool pgtable_l4_enabled(void);

@@ -1137,10 +1156,20 @@ static inline int pmdp_set_access_flags(struct 
vm_area_struct *vma,
  							pmd_pte(entry), dirty);
  }

+static inline int pudp_set_access_flags(struct vm_area_struct *vma,
+					unsigned long address, pud_t *pudp,
+					pud_t entry, int dirty)
+{
+	return __ptep_set_access_flags(vma, address, (pte_t *)pudp,
+							pud_pte(entry), dirty);
+}
+
+#ifndef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
  static inline int pud_devmap(pud_t pud)
  {
  	return 0;
  }
+#endif

  static inline int pgd_devmap(pgd_t pgd)
  {
@@ -1213,6 +1242,13 @@ static inline int 
pmdp_test_and_clear_young(struct vm_area_struct *vma,
  {
  	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
  }
+
+static inline int pudp_test_and_clear_young(struct vm_area_struct *vma,
+					    unsigned long address,
+					    pud_t *pudp)
+{
+	return __ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
+}
  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */

  static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
@@ -1433,6 +1469,7 @@ static inline void update_mmu_cache_range(struct 
vm_fault *vmf,
  #define update_mmu_cache(vma, addr, ptep) \
  	update_mmu_cache_range(NULL, vma, addr, ptep, 1)
  #define update_mmu_cache_pmd(vma, address, pmd) do { } while (0)
+#define update_mmu_cache_pud(vma, address, pud) do { } while (0)

  #ifdef CONFIG_ARM64_PA_BITS_52
  #define phys_to_ttbr(addr)	(((addr) | ((addr) >> 46)) & 
TTBR_BADDR_MASK_52)
-- 
2.27.0


>>
>> Oh that sounds like a bigger step..
> 
> Just to mention, no real THP 1G needed here for pfnmaps.  The real gap here
> is only about the pud helpers that only exists so far with CONFIG_THP_PUD
> in huge_memory.c.
> 
>>   
>>> VFIO is so far the only consumer for the huge pfnmaps after this series
>>> applied.  Besides above remap_pfn_range() generic optimization, device
>>> driver can also try to optimize its mmap() on a better VA alignment for
>>> either PMD/PUD sizes.  This may, iiuc, normally require userspace changes,
>>> as the driver doesn't normally decide the VA to map a bar.  But I don't
>>> think I know all the drivers to know the full picture.
>>
>> How does alignment work? In most caes I'm aware of the userspace does
>> not use MAP_FIXED so the expectation would be for the kernel to
>> automatically select a high alignment. I suppose your cases are
>> working because qemu uses MAP_FIXED and naturally aligns the BAR
>> addresses?
>>
>>> - x86_64 + AMD GPU
>>>    - Needs Alex's modified QEMU to guarantee proper VA alignment to make
>>>      sure all pages to be mapped with PUDs
>>
>> Oh :(
> 
> So I suppose this answers above. :) Yes, alignment needed.
> 

