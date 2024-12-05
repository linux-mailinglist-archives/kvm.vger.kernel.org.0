Return-Path: <kvm+bounces-33127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 02D299E54A1
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 12:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A8035281CAD
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 11:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F3592144B5;
	Thu,  5 Dec 2024 11:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bIKTxC5n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD082144A4;
	Thu,  5 Dec 2024 11:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733399641; cv=none; b=rpS+8bDS3YRG2m34Nj0xM+HWuXcKJ1jpMplYrRi3wiJC2YbRYp5vDmuzCKnGVXHJf2VXEzqdbDgnJi5HQgceo3zevsIEMGOHfRc8kOzZRtmizQCa8BFSOCs06yjZM+DFZWX7Is9pm1i1gtPRXcSqF1zVPkAisTlt4+kQoINDlFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733399641; c=relaxed/simple;
	bh=FRyYeWHuT16TJ1pPRuXZ4fEoLV6czcJ/L3feRyc8wfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mUl8Pfuof98ZP8i0aLkOkIhMFj6zLPtwVPHRcSMHi+O+X73MMqwXKI8S4Cjnr/un0B9EwcTcPJJoFc/suhNMBR43uBFMIYLAuUNT6hfAf8Nm9RB3p6MNP2T73fiAB8DID3TbVImqiwKjgaxTDWoF6gp85C+q/faOT9o5afb58WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bIKTxC5n; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733399638; x=1764935638;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FRyYeWHuT16TJ1pPRuXZ4fEoLV6czcJ/L3feRyc8wfg=;
  b=bIKTxC5no9PJEC7e3Ua7YfnnNBtoZAQdhCc/BiOBywR36NOecrUm+Jzy
   uZDHQ+6swQYPVt6N2rFYcIvyxRKB4PozommmSsC13xo85MO9hPVA7280b
   jBVtYdw/vT5EX3uHMMDAHWfpvEwyCV3aKlGKWlT5m24Eseita4taTlK4B
   M0mmaOswpbA+gKB9gmjHatwvAuHI75IVYpuijLKU9tylRvQB/8MZx7cIR
   qOw3yj7wF39h0slCS4IRTt0SWXFlb1dB+pR9IQh7HEAmAbKVrHidoojde
   GlxEiv8qdLHVJkPmOBNim9K+MQx7h2fkP/UkErydBkrcm1so93xWp3Uha
   A==;
X-CSE-ConnectionGUID: UZutqAiDTeCKGoyEY5Ed2w==
X-CSE-MsgGUID: gQIORNd1TUODrjjNgVW/GQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11276"; a="59114645"
X-IronPort-AV: E=Sophos;i="6.12,210,1728975600"; 
   d="scan'208";a="59114645"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2024 03:53:57 -0800
X-CSE-ConnectionGUID: YEDaCdP7S3ebOP/c4wLnQg==
X-CSE-MsgGUID: 1Yoj6dBFSq+1TfWPX6XJew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,210,1728975600"; 
   d="scan'208";a="99152051"
Received: from lkp-server02.sh.intel.com (HELO 1f5a171d57e2) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 05 Dec 2024 03:53:52 -0800
Received: from kbuild by 1f5a171d57e2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tJAQX-00048n-2K;
	Thu, 05 Dec 2024 11:53:49 +0000
Date: Thu, 5 Dec 2024 19:52:43 +0800
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
Message-ID: <202412051904.GNL7BE1X-lkp@intel.com>
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
config: x86_64-randconfig-121 (https://download.01.org/0day-ci/archive/20241205/202412051904.GNL7BE1X-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241205/202412051904.GNL7BE1X-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202412051904.GNL7BE1X-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   arch/x86/kvm/../../../virt/kvm/kvm_main.c: note: in included file:
   include/linux/kvm_host.h:2080:54: sparse: sparse: array of flexible structures
   include/linux/kvm_host.h:2082:56: sparse: sparse: array of flexible structures
>> arch/x86/kvm/../../../virt/kvm/kvm_main.c:2049:39: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected unsigned long [noderef] __user *userfault_bitmap @@     got unsigned long * @@
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:2049:39: sparse:     expected unsigned long [noderef] __user *userfault_bitmap
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:2049:39: sparse:     got unsigned long *
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:626:25: sparse: sparse: context imbalance in 'kvm_mmu_notifier_invalidate_range_start' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:626:25: sparse: sparse: context imbalance in 'kvm_mmu_notifier_invalidate_range_end' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:626:25: sparse: sparse: context imbalance in 'kvm_mmu_notifier_clear_flush_young' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:626:25: sparse: sparse: context imbalance in 'kvm_mmu_notifier_clear_young' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:626:25: sparse: sparse: context imbalance in 'kvm_mmu_notifier_test_young' - different lock contexts for basic block
   arch/x86/kvm/../../../virt/kvm/kvm_main.c: note: in included file (through include/linux/mutex.h, include/linux/kvm_types.h, include/kvm/iodev.h):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   arch/x86/kvm/../../../virt/kvm/kvm_main.c:1960:49: sparse: sparse: self-comparison always evaluates to false
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true

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

