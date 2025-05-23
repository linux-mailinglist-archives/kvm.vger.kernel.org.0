Return-Path: <kvm+bounces-47521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01028AC1AC7
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 05:49:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 19E393B1A54
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:49:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF84B223335;
	Fri, 23 May 2025 03:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VrG+HFJM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BA01519A0;
	Fri, 23 May 2025 03:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747972149; cv=none; b=A0vX/MpFbE0KvFWZbyj6H6FxJIw12tapgU/HguL+uU/JOx62dui5N/kB7aDysQOjmbCoKf7qcRsxfw9LvAbTxywiC/zK/KiUzpuhFUXB2KuK5jEvqz9vNQF6YYsizA1CP9B923kQiiFvcuZ8BHnJzE8o1YhT+kBzjtp+sfpc8Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747972149; c=relaxed/simple;
	bh=W0I1h/EFOaXWHoneVKr55BZEEapiZElQ6WMainFSWps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZvOpb1LPVQPP28KiDftXSj1FcMAHrw9rqu/IoOHA4V+GX3AIC4nr5oAJv3qGIigjwegLU0STmfY2LDBDCENWZEIlTNEAmj/4RkCk2RTNbIsgqOFzi7gmkdeLp0kCsw9kZfXKXJu7+iB1hdpK7T8FHQdwRJOuTh7GzfUBJj+kDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VrG+HFJM; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747972147; x=1779508147;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=W0I1h/EFOaXWHoneVKr55BZEEapiZElQ6WMainFSWps=;
  b=VrG+HFJM91OCsbD6N9+HLYS3XnDpXuLdP6ll4N+DqJZEzElPR9XhT1EV
   lmA+QNLHGN95GRAkmjFVvJkx0BBwwyt7oIY9E1/M1O5naca8DHLTJtTRR
   cewSfhF8ElS1vVHAi4Q23pbJjo2gg53C439VYOBAydCqp/XLcPZDZQQ35
   O8bI8mvtZNFrxYtH/zeiS/JERhN1Eci4W4lRiFSERjSmApyyAslUz3Jnw
   f8Zq0nVcZ+77pR7/MJy8GXO1wPUYPtDk5BhbRZaii2S8kbfVI0Ho3Xmox
   UeuqBQvumPVwQohKALtjase5wQoXU9V4puhwzqI6URcteAT5/O5NulpK+
   g==;
X-CSE-ConnectionGUID: LAsLKR51SjSmMAXOw9wqBA==
X-CSE-MsgGUID: d+eFs/pyRQavSbLtqYvkWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="49915778"
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="49915778"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 20:49:06 -0700
X-CSE-ConnectionGUID: dkunbL94RdmQJVUYFsoLtw==
X-CSE-MsgGUID: 2AmUQwVESvaXiXzhANKj0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,307,1739865600"; 
   d="scan'208";a="140747623"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa009.jf.intel.com with ESMTP; 22 May 2025 20:49:02 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uIJP2-000PzW-0E;
	Fri, 23 May 2025 03:49:00 +0000
Date: Fri, 23 May 2025 11:48:20 +0800
From: kernel test robot <lkp@intel.com>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, frankja@linux.ibm.com,
	borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
	nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
	agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
	schlameuss@linux.ibm.com
Subject: Re: [PATCH v3 3/4] KVM: s390: refactor and split some gmap helpers
Message-ID: <202505231158.TssIVgKH-lkp@intel.com>
References: <20250522132259.167708-4-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250522132259.167708-4-imbrenda@linux.ibm.com>

Hi Claudio,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvms390/next]
[also build test ERROR on s390/features kvm/queue kvm/next mst-vhost/linux-next linus/master v6.15-rc7 next-20250522]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Claudio-Imbrenda/s390-remove-unneeded-includes/20250522-212623
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git next
patch link:    https://lore.kernel.org/r/20250522132259.167708-4-imbrenda%40linux.ibm.com
patch subject: [PATCH v3 3/4] KVM: s390: refactor and split some gmap helpers
config: s390-randconfig-001-20250523 (https://download.01.org/0day-ci/archive/20250523/202505231158.TssIVgKH-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250523/202505231158.TssIVgKH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505231158.TssIVgKH-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/s390/mm/gmap_helpers.c: In function 'ptep_zap_swap_entry':
>> arch/s390/mm/gmap_helpers.c:26:7: error: implicit declaration of function 'non_swap_entry'; did you mean 'init_wait_entry'? [-Werror=implicit-function-declaration]
     if (!non_swap_entry(entry))
          ^~~~~~~~~~~~~~
          init_wait_entry
>> arch/s390/mm/gmap_helpers.c:28:11: error: implicit declaration of function 'is_migration_entry'; did you mean 'list_first_entry'? [-Werror=implicit-function-declaration]
     else if (is_migration_entry(entry))
              ^~~~~~~~~~~~~~~~~~
              list_first_entry
>> arch/s390/mm/gmap_helpers.c:29:33: error: implicit declaration of function 'pfn_swap_entry_folio'; did you mean 'filemap_dirty_folio'? [-Werror=implicit-function-declaration]
      dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
                                    ^~~~~~~~~~~~~~~~~~~~
                                    filemap_dirty_folio
   arch/s390/mm/gmap_helpers.c:29:33: warning: passing argument 1 of 'mm_counter' makes pointer from integer without a cast [-Wint-conversion]
      dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/s390/mm/gmap_helpers.c:9:
   include/linux/mm.h:2725:44: note: expected 'struct folio *' but argument is of type 'int'
    static inline int mm_counter(struct folio *folio)
                                 ~~~~~~~~~~~~~~^~~~~
>> arch/s390/mm/gmap_helpers.c:30:2: error: implicit declaration of function 'free_swap_and_cache'; did you mean 'free_pgd_range'? [-Werror=implicit-function-declaration]
     free_swap_and_cache(entry);
     ^~~~~~~~~~~~~~~~~~~
     free_pgd_range
   arch/s390/mm/gmap_helpers.c: In function 'gmap_helper_zap_one_page':
>> arch/s390/mm/gmap_helpers.c:60:27: error: implicit declaration of function 'pte_to_swp_entry'; did you mean 'ptep_zap_swap_entry'? [-Werror=implicit-function-declaration]
      ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
                              ^~~~~~~~~~~~~~~~
                              ptep_zap_swap_entry
>> arch/s390/mm/gmap_helpers.c:60:27: error: incompatible type for argument 2 of 'ptep_zap_swap_entry'
      ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
                              ^~~~~~~~~~~~~~~~~~~~~~~
   arch/s390/mm/gmap_helpers.c:24:67: note: expected 'swp_entry_t' {aka 'struct <anonymous>'} but argument is of type 'int'
    static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
                                                          ~~~~~~~~~~~~^~~~~
   cc1: some warnings being treated as errors


vim +26 arch/s390/mm/gmap_helpers.c

    14	
    15	/**
    16	 * ptep_zap_swap_entry() - discard a swap entry.
    17	 * @mm: the mm
    18	 * @entry: the swap entry that needs to be zapped
    19	 *
    20	 * Discards the given swap entry. If the swap entry was an actual swap
    21	 * entry (and not a migration entry, for example), the actual swapped
    22	 * page is also discarded from swap.
    23	 */
    24	static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
    25	{
  > 26		if (!non_swap_entry(entry))
    27			dec_mm_counter(mm, MM_SWAPENTS);
  > 28		else if (is_migration_entry(entry))
  > 29			dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
  > 30		free_swap_and_cache(entry);
    31	}
    32	
    33	/**
    34	 * gmap_helper_zap_one_page() - discard a page if it was swapped.
    35	 * @mm: the mm
    36	 * @vmaddr: the userspace virtual address that needs to be discarded
    37	 *
    38	 * If the given address maps to a swap entry, discard it.
    39	 *
    40	 * Context: needs to be called while holding the mmap lock.
    41	 */
    42	void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
    43	{
    44		struct vm_area_struct *vma;
    45		spinlock_t *ptl;
    46		pte_t *ptep;
    47	
    48		mmap_assert_locked(mm);
    49	
    50		/* Find the vm address for the guest address */
    51		vma = vma_lookup(mm, vmaddr);
    52		if (!vma || is_vm_hugetlb_page(vma))
    53			return;
    54	
    55		/* Get pointer to the page table entry */
    56		ptep = get_locked_pte(mm, vmaddr, &ptl);
    57		if (unlikely(!ptep))
    58			return;
    59		if (pte_swap(*ptep))
  > 60			ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
    61		pte_unmap_unlock(ptep, ptl);
    62	}
    63	EXPORT_SYMBOL_GPL(gmap_helper_zap_one_page);
    64	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

