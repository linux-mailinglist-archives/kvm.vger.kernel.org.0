Return-Path: <kvm+bounces-60604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AFA02BF464C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 04:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4450C4E9714
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 02:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99CA02749CE;
	Tue, 21 Oct 2025 02:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FKq6Ya6R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFB233F3;
	Tue, 21 Oct 2025 02:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761014343; cv=none; b=WN/KJWcajszOpPnBmlYAxR8q+JDhATQFawoBpuIpmWFgMfthkl+Rcml9as+RmFEpWzH/bJaTVmrZJnP8jfnN2iT1lm6Pqppzb63+SO8gHv2U5zSNDAUrqfsJAx1KlJ/52zXA27oniJt1y8N84/UBDIxQ53ZI7WSdEUqBXtNcZo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761014343; c=relaxed/simple;
	bh=YelTUj/Itdkam8XSpN2bVMX//XFvL4Up4guJiyWU22A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuBkvKksih70H3NhzBjd7nUMBv8QR4gA8zkMPxA8g6BKfueGoYzJGfwgxk/NvDCxCVl4JZ2UUpcqoS8DbLe+OLdoprLOsMl32c4+bu9Ak+rtdsM61MN/LI1cHOsHd+r07TFpN/JdDoYofqg0gqXoNbRsK46vOJJbKlHARRBU/5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FKq6Ya6R; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761014342; x=1792550342;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YelTUj/Itdkam8XSpN2bVMX//XFvL4Up4guJiyWU22A=;
  b=FKq6Ya6Rp+sZRWQoEGbni1VMHIv1513KEgpnHgJUq6d2pLr/5dcEIX9L
   ht9cYavrTL/PcRYCewg1P9Zw0FML6sWp7QtoUJNnYiVNat7Uo2I83JPvV
   9OCFMXVKDzEK6NM1S/CoWxfnKjmMLxjj5yTx8xClYwVCyVLU8a7s5v7n3
   Ighpdg0Aqn/YDfgQB2Jgm5gDqTMb7u51BcNTeqeMyXL++C/O6NGaZCBoP
   ZSXN+1iWyYU3N4P11e85igkSPMl8nOgNMNLf0Wkg1E2UnG74/J8X5gMHM
   Ve0NfU23zYePv+GZEyoyqU1Ig403xDwAhw/I2cc19sJdNQHkrQFaz8HOU
   w==;
X-CSE-ConnectionGUID: VbjorKztQxOk14d7Mxnkog==
X-CSE-MsgGUID: 5djaHwEARBmq2SGKT6FndA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="85760274"
X-IronPort-AV: E=Sophos;i="6.19,243,1754982000"; 
   d="scan'208";a="85760274"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 19:39:01 -0700
X-CSE-ConnectionGUID: WRGaFpn+QCyegQjI8CmtOQ==
X-CSE-MsgGUID: klALRghhR2mbbGPA9iCDaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,243,1754982000"; 
   d="scan'208";a="187743891"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 20 Oct 2025 19:38:58 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vB2H1-000AOP-1d;
	Tue, 21 Oct 2025 02:38:55 +0000
Date: Tue, 21 Oct 2025 10:38:33 +0800
From: kernel test robot <lkp@intel.com>
To: fangyu.yu@linux.alibaba.com, anup@brainfault.org, atish.patra@linux.dev,
	pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	alex@ghiti.fr, pbonzini@redhat.com, jiangyifei@huawei.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, guoren@kernel.org,
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: Re: [PATCH] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
Message-ID: <202510211010.XRaEeuBa-lkp@intel.com>
References: <20251020130801.68356-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251020130801.68356-1-fangyu.yu@linux.alibaba.com>

Hi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on kvm/next linus/master v6.18-rc2 next-20251020]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/fangyu-yu-linux-alibaba-com/RISC-V-KVM-Remove-automatic-I-O-mapping-for-VM_PFNMAP/20251020-210957
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20251020130801.68356-1-fangyu.yu%40linux.alibaba.com
patch subject: [PATCH] RISC-V: KVM: Remove automatic I/O mapping for VM_PFNMAP
config: riscv-defconfig (https://download.01.org/0day-ci/archive/20251021/202510211010.XRaEeuBa-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 754ebc6ebb9fb9fbee7aef33478c74ea74949853)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251021/202510211010.XRaEeuBa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510211010.XRaEeuBa-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/riscv/kvm/mmu.c:211:9: warning: variable 'vm_start' set but not used [-Wunused-but-set-variable]
     211 |                 hva_t vm_start, vm_end;
         |                       ^
>> arch/riscv/kvm/mmu.c:174:8: warning: variable 'base_gpa' set but not used [-Wunused-but-set-variable]
     174 |         gpa_t base_gpa;
         |               ^
   2 warnings generated.


vim +/vm_start +211 arch/riscv/kvm/mmu.c

99cdc6c18c2d815 Anup Patel          2021-09-27  167  
99cdc6c18c2d815 Anup Patel          2021-09-27  168  int kvm_arch_prepare_memory_region(struct kvm *kvm,
537a17b31493009 Sean Christopherson 2021-12-06  169  				const struct kvm_memory_slot *old,
537a17b31493009 Sean Christopherson 2021-12-06  170  				struct kvm_memory_slot *new,
99cdc6c18c2d815 Anup Patel          2021-09-27  171  				enum kvm_mr_change change)
99cdc6c18c2d815 Anup Patel          2021-09-27  172  {
d01495d4cffb327 Sean Christopherson 2021-12-06  173  	hva_t hva, reg_end, size;
d01495d4cffb327 Sean Christopherson 2021-12-06 @174  	gpa_t base_gpa;
d01495d4cffb327 Sean Christopherson 2021-12-06  175  	bool writable;
9d05c1fee837572 Anup Patel          2021-09-27  176  	int ret = 0;
9d05c1fee837572 Anup Patel          2021-09-27  177  
9d05c1fee837572 Anup Patel          2021-09-27  178  	if (change != KVM_MR_CREATE && change != KVM_MR_MOVE &&
9d05c1fee837572 Anup Patel          2021-09-27  179  			change != KVM_MR_FLAGS_ONLY)
99cdc6c18c2d815 Anup Patel          2021-09-27  180  		return 0;
9d05c1fee837572 Anup Patel          2021-09-27  181  
9d05c1fee837572 Anup Patel          2021-09-27  182  	/*
9d05c1fee837572 Anup Patel          2021-09-27  183  	 * Prevent userspace from creating a memory region outside of the GPA
9d05c1fee837572 Anup Patel          2021-09-27  184  	 * space addressable by the KVM guest GPA space.
9d05c1fee837572 Anup Patel          2021-09-27  185  	 */
537a17b31493009 Sean Christopherson 2021-12-06  186  	if ((new->base_gfn + new->npages) >=
dd82e35638d67f4 Anup Patel          2025-06-18  187  	    (kvm_riscv_gstage_gpa_size >> PAGE_SHIFT))
9d05c1fee837572 Anup Patel          2021-09-27  188  		return -EFAULT;
9d05c1fee837572 Anup Patel          2021-09-27  189  
d01495d4cffb327 Sean Christopherson 2021-12-06  190  	hva = new->userspace_addr;
d01495d4cffb327 Sean Christopherson 2021-12-06  191  	size = new->npages << PAGE_SHIFT;
d01495d4cffb327 Sean Christopherson 2021-12-06  192  	reg_end = hva + size;
d01495d4cffb327 Sean Christopherson 2021-12-06  193  	base_gpa = new->base_gfn << PAGE_SHIFT;
d01495d4cffb327 Sean Christopherson 2021-12-06  194  	writable = !(new->flags & KVM_MEM_READONLY);
d01495d4cffb327 Sean Christopherson 2021-12-06  195  
9d05c1fee837572 Anup Patel          2021-09-27  196  	mmap_read_lock(current->mm);
9d05c1fee837572 Anup Patel          2021-09-27  197  
9d05c1fee837572 Anup Patel          2021-09-27  198  	/*
9d05c1fee837572 Anup Patel          2021-09-27  199  	 * A memory region could potentially cover multiple VMAs, and
b35152e0fb35983 Fangyu Yu           2025-10-20  200  	 * any holes between them, so iterate over all of them.
9d05c1fee837572 Anup Patel          2021-09-27  201  	 *
9d05c1fee837572 Anup Patel          2021-09-27  202  	 *     +--------------------------------------------+
9d05c1fee837572 Anup Patel          2021-09-27  203  	 * +---------------+----------------+   +----------------+
9d05c1fee837572 Anup Patel          2021-09-27  204  	 * |   : VMA 1     |      VMA 2     |   |    VMA 3  :    |
9d05c1fee837572 Anup Patel          2021-09-27  205  	 * +---------------+----------------+   +----------------+
9d05c1fee837572 Anup Patel          2021-09-27  206  	 *     |               memory region                |
9d05c1fee837572 Anup Patel          2021-09-27  207  	 *     +--------------------------------------------+
9d05c1fee837572 Anup Patel          2021-09-27  208  	 */
9d05c1fee837572 Anup Patel          2021-09-27  209  	do {
fce11b667022766 Quan Zhou           2025-06-17  210  		struct vm_area_struct *vma;
9d05c1fee837572 Anup Patel          2021-09-27 @211  		hva_t vm_start, vm_end;
9d05c1fee837572 Anup Patel          2021-09-27  212  
fce11b667022766 Quan Zhou           2025-06-17  213  		vma = find_vma_intersection(current->mm, hva, reg_end);
fce11b667022766 Quan Zhou           2025-06-17  214  		if (!vma)
9d05c1fee837572 Anup Patel          2021-09-27  215  			break;
9d05c1fee837572 Anup Patel          2021-09-27  216  
9d05c1fee837572 Anup Patel          2021-09-27  217  		/*
9d05c1fee837572 Anup Patel          2021-09-27  218  		 * Mapping a read-only VMA is only allowed if the
9d05c1fee837572 Anup Patel          2021-09-27  219  		 * memory region is configured as read-only.
9d05c1fee837572 Anup Patel          2021-09-27  220  		 */
9d05c1fee837572 Anup Patel          2021-09-27  221  		if (writable && !(vma->vm_flags & VM_WRITE)) {
9d05c1fee837572 Anup Patel          2021-09-27  222  			ret = -EPERM;
9d05c1fee837572 Anup Patel          2021-09-27  223  			break;
9d05c1fee837572 Anup Patel          2021-09-27  224  		}
9d05c1fee837572 Anup Patel          2021-09-27  225  
9d05c1fee837572 Anup Patel          2021-09-27  226  		/* Take the intersection of this VMA with the memory region */
9d05c1fee837572 Anup Patel          2021-09-27  227  		vm_start = max(hva, vma->vm_start);
9d05c1fee837572 Anup Patel          2021-09-27  228  		vm_end = min(reg_end, vma->vm_end);
9d05c1fee837572 Anup Patel          2021-09-27  229  
9d05c1fee837572 Anup Patel          2021-09-27  230  		if (vma->vm_flags & VM_PFNMAP) {
9d05c1fee837572 Anup Patel          2021-09-27  231  			/* IO region dirty page logging not allowed */
537a17b31493009 Sean Christopherson 2021-12-06  232  			if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
9d05c1fee837572 Anup Patel          2021-09-27  233  				ret = -EINVAL;
9d05c1fee837572 Anup Patel          2021-09-27  234  				goto out;
9d05c1fee837572 Anup Patel          2021-09-27  235  			}
9d05c1fee837572 Anup Patel          2021-09-27  236  		}
9d05c1fee837572 Anup Patel          2021-09-27  237  		hva = vm_end;
9d05c1fee837572 Anup Patel          2021-09-27  238  	} while (hva < reg_end);
9d05c1fee837572 Anup Patel          2021-09-27  239  
9d05c1fee837572 Anup Patel          2021-09-27  240  out:
9d05c1fee837572 Anup Patel          2021-09-27  241  	mmap_read_unlock(current->mm);
9d05c1fee837572 Anup Patel          2021-09-27  242  	return ret;
99cdc6c18c2d815 Anup Patel          2021-09-27  243  }
99cdc6c18c2d815 Anup Patel          2021-09-27  244  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

