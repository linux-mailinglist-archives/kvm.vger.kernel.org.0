Return-Path: <kvm+bounces-33162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 914BC9E586D
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 15:23:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4B8E8285863
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 14:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B391F21A45A;
	Thu,  5 Dec 2024 14:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I6ZV16EP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE248217F50;
	Thu,  5 Dec 2024 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733408626; cv=none; b=U6uRncmxL3BCQ/JfI7iL5lqVfql48k0GWe7ZFrEj+ZV/szqSyK8bhcxzpUGCtqZyP9nb2ztGuWRowsjH3lDs76O3qTYuuV6pgA4y7lOzE//wVG5u74lJJyZtxYhltStZGzweZx02uCJpQH5aa7VVL9tF5HON40pXa9IE+bgzhOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733408626; c=relaxed/simple;
	bh=wwkkJQKuVKIstuMSBCRhrsXwlus/ArcTkrxaTl4VJo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u4e29VQpwscqoo/HpxzpZCkLtDgafnGlEd/tOjlQFyCwnfHTUwTAvoEtnqo8xrzeTOb++QaNoP5NiKLpNlTpdlDU5AmzOVAWOb1kL4dXRH4q83qJc9qt69z+tUOIXfV9hXniz9HIJ82fpGUn9ILyqcrgeMlFhxQn33HS+4Z6aGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I6ZV16EP; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733408625; x=1764944625;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wwkkJQKuVKIstuMSBCRhrsXwlus/ArcTkrxaTl4VJo4=;
  b=I6ZV16EPY6V9ynUIPjsJzAEu0EhAjL9MZrakjhxUgiDi4f4qNxG0b/2I
   S2OCLmQQMTE/o8LiRfnsIJvievpKFEPzzgAYfjyja5FOj0T+s7o/mNZSv
   DDn14qU2ibVrOpXtyaCzP1k/lHmCtxZxPNCwEAAVeHmxFyTNwcBP6RsgA
   G61DjZT6E4djcUSB8QjPL27zbQZ7jp+Ak15zuyx4UU2B2kbO6lbh2loCX
   JiI9Gc9s9LLiO1JsGAY6rlBMDkGLT4uUDbEj69X/wz+t6iVMvt6TeLI7b
   IQqOcFg8PV8JD0Y5rwaBulhxWRcfZjRVoSwboBVdjWy3wlSoaYfIdpg5K
   g==;
X-CSE-ConnectionGUID: wSceiMINQMWl4LEWE8ciqQ==
X-CSE-MsgGUID: 9UyEJEMnQ1Oxj9Rw+b2Z6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11277"; a="33637342"
X-IronPort-AV: E=Sophos;i="6.12,210,1728975600"; 
   d="scan'208";a="33637342"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 06:23:44 -0800
X-CSE-ConnectionGUID: 8CmpKIUuR1ikCloIPgyAYg==
X-CSE-MsgGUID: LKEgyXOcSkKfshkGA+W9kw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,210,1728975600"; 
   d="scan'208";a="125015938"
Received: from lkp-server01.sh.intel.com (HELO 82a3f569d0cb) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 05 Dec 2024 06:23:40 -0800
Received: from kbuild by 82a3f569d0cb with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tJClV-00004t-23;
	Thu, 05 Dec 2024 14:23:37 +0000
Date: Thu, 5 Dec 2024 22:22:50 +0800
From: kernel test robot <lkp@intel.com>
To: James Houghton <jthoughton@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Cc: oe-kbuild-all@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Yan Zhao <yan.y.zhao@intel.com>,
	James Houghton <jthoughton@google.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Anish Moorthy <amoorthy@google.com>,
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
	David Matlack <dmatlack@google.com>, Wang@google.com,
	Wei W <wei.w.wang@intel.com>, kvm@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v1 01/13] KVM: Add KVM_MEM_USERFAULT memslot flag and
 bitmap
Message-ID: <202412052133.pTg3UAQm-lkp@intel.com>
References: <20241204191349.1730936-2-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204191349.1730936-2-jthoughton@google.com>

Hi James,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 4d911c7abee56771b0219a9fbf0120d06bdc9c14]

url:    https://github.com/intel-lab-lkp/linux/commits/James-Houghton/KVM-Add-KVM_MEM_USERFAULT-memslot-flag-and-bitmap/20241205-032516
base:   4d911c7abee56771b0219a9fbf0120d06bdc9c14
patch link:    https://lore.kernel.org/r/20241204191349.1730936-2-jthoughton%40google.com
patch subject: [PATCH v1 01/13] KVM: Add KVM_MEM_USERFAULT memslot flag and bitmap
config: i386-buildonly-randconfig-006 (https://download.01.org/0day-ci/archive/20241205/202412052133.pTg3UAQm-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241205/202412052133.pTg3UAQm-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412052133.pTg3UAQm-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function '__kvm_set_memory_region':
>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:2049:41: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    2049 |                 new->userfault_bitmap = (unsigned long *)mem->userfault_bitmap;
         |                                         ^


vim +2049 arch/x86/kvm/../../../virt/kvm/kvm_main.c

  1931	
  1932	/*
  1933	 * Allocate some memory and give it an address in the guest physical address
  1934	 * space.
  1935	 *
  1936	 * Discontiguous memory is allowed, mostly for framebuffers.
  1937	 *
  1938	 * Must be called holding kvm->slots_lock for write.
  1939	 */
  1940	int __kvm_set_memory_region(struct kvm *kvm,
  1941				    const struct kvm_userspace_memory_region2 *mem)
  1942	{
  1943		struct kvm_memory_slot *old, *new;
  1944		struct kvm_memslots *slots;
  1945		enum kvm_mr_change change;
  1946		unsigned long npages;
  1947		gfn_t base_gfn;
  1948		int as_id, id;
  1949		int r;
  1950	
  1951		r = check_memory_region_flags(kvm, mem);
  1952		if (r)
  1953			return r;
  1954	
  1955		as_id = mem->slot >> 16;
  1956		id = (u16)mem->slot;
  1957	
  1958		/* General sanity checks */
  1959		if ((mem->memory_size & (PAGE_SIZE - 1)) ||
  1960		    (mem->memory_size != (unsigned long)mem->memory_size))
  1961			return -EINVAL;
  1962		if (mem->guest_phys_addr & (PAGE_SIZE - 1))
  1963			return -EINVAL;
  1964		/* We can read the guest memory with __xxx_user() later on. */
  1965		if ((mem->userspace_addr & (PAGE_SIZE - 1)) ||
  1966		    (mem->userspace_addr != untagged_addr(mem->userspace_addr)) ||
  1967		     !access_ok((void __user *)(unsigned long)mem->userspace_addr,
  1968				mem->memory_size))
  1969			return -EINVAL;
  1970		if (mem->flags & KVM_MEM_GUEST_MEMFD &&
  1971		    (mem->guest_memfd_offset & (PAGE_SIZE - 1) ||
  1972		     mem->guest_memfd_offset + mem->memory_size < mem->guest_memfd_offset))
  1973			return -EINVAL;
  1974		if (as_id >= kvm_arch_nr_memslot_as_ids(kvm) || id >= KVM_MEM_SLOTS_NUM)
  1975			return -EINVAL;
  1976		if (mem->guest_phys_addr + mem->memory_size < mem->guest_phys_addr)
  1977			return -EINVAL;
  1978		if ((mem->memory_size >> PAGE_SHIFT) > KVM_MEM_MAX_NR_PAGES)
  1979			return -EINVAL;
  1980	
  1981		slots = __kvm_memslots(kvm, as_id);
  1982	
  1983		/*
  1984		 * Note, the old memslot (and the pointer itself!) may be invalidated
  1985		 * and/or destroyed by kvm_set_memslot().
  1986		 */
  1987		old = id_to_memslot(slots, id);
  1988	
  1989		if (!mem->memory_size) {
  1990			if (!old || !old->npages)
  1991				return -EINVAL;
  1992	
  1993			if (WARN_ON_ONCE(kvm->nr_memslot_pages < old->npages))
  1994				return -EIO;
  1995	
  1996			return kvm_set_memslot(kvm, old, NULL, KVM_MR_DELETE);
  1997		}
  1998	
  1999		base_gfn = (mem->guest_phys_addr >> PAGE_SHIFT);
  2000		npages = (mem->memory_size >> PAGE_SHIFT);
  2001	
  2002		if (!old || !old->npages) {
  2003			change = KVM_MR_CREATE;
  2004	
  2005			/*
  2006			 * To simplify KVM internals, the total number of pages across
  2007			 * all memslots must fit in an unsigned long.
  2008			 */
  2009			if ((kvm->nr_memslot_pages + npages) < kvm->nr_memslot_pages)
  2010				return -EINVAL;
  2011		} else { /* Modify an existing slot. */
  2012			/* Private memslots are immutable, they can only be deleted. */
  2013			if (mem->flags & KVM_MEM_GUEST_MEMFD)
  2014				return -EINVAL;
  2015			if ((mem->userspace_addr != old->userspace_addr) ||
  2016			    (npages != old->npages) ||
  2017			    ((mem->flags ^ old->flags) & KVM_MEM_READONLY))
  2018				return -EINVAL;
  2019	
  2020			if (base_gfn != old->base_gfn)
  2021				change = KVM_MR_MOVE;
  2022			else if (mem->flags != old->flags)
  2023				change = KVM_MR_FLAGS_ONLY;
  2024			else /* Nothing to change. */
  2025				return 0;
  2026		}
  2027	
  2028		if ((change == KVM_MR_CREATE || change == KVM_MR_MOVE) &&
  2029		    kvm_check_memslot_overlap(slots, id, base_gfn, base_gfn + npages))
  2030			return -EEXIST;
  2031	
  2032		/* Allocate a slot that will persist in the memslot. */
  2033		new = kzalloc(sizeof(*new), GFP_KERNEL_ACCOUNT);
  2034		if (!new)
  2035			return -ENOMEM;
  2036	
  2037		new->as_id = as_id;
  2038		new->id = id;
  2039		new->base_gfn = base_gfn;
  2040		new->npages = npages;
  2041		new->flags = mem->flags;
  2042		new->userspace_addr = mem->userspace_addr;
  2043		if (mem->flags & KVM_MEM_GUEST_MEMFD) {
  2044			r = kvm_gmem_bind(kvm, new, mem->guest_memfd, mem->guest_memfd_offset);
  2045			if (r)
  2046				goto out;
  2047		}
  2048		if (mem->flags & KVM_MEM_USERFAULT)
> 2049			new->userfault_bitmap = (unsigned long *)mem->userfault_bitmap;
  2050	
  2051		r = kvm_set_memslot(kvm, old, new, change);
  2052		if (r)
  2053			goto out_unbind;
  2054	
  2055		return 0;
  2056	
  2057	out_unbind:
  2058		if (mem->flags & KVM_MEM_GUEST_MEMFD)
  2059			kvm_gmem_unbind(new);
  2060	out:
  2061		kfree(new);
  2062		return r;
  2063	}
  2064	EXPORT_SYMBOL_GPL(__kvm_set_memory_region);
  2065	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

