Return-Path: <kvm+bounces-23594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E3494B552
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 05:06:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18F68281031
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 03:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B2B926AF7;
	Thu,  8 Aug 2024 03:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gI9WAjzV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C48129D1C
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 03:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723086408; cv=none; b=atZDQLusVScrFJGTv37F5SDqhd8i+jnaI8LG9qAxcfn7OJtM8nnZcWPbY5ji3oAfNFmUrvQdO+3CxrUzM5QSdUVdycke0BzA72/9OgQR0IIOk5Q25flRgg/IVjP3q6o5lKru2QjHb1y01vr1b7hJB59UFfu0u8RH8hXFeS9pt80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723086408; c=relaxed/simple;
	bh=YCmbyQanPw3vuwKaQHr4MtLBUjyYVzF52LWa8YVi76s=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=BWGvP/6CDUlVIWk2j9tH+16PU/EFMGuBDzL/TYDhT/WvHxxhXjc0hKal3a0pRhtUuuffZOHgfVfo1k/10utb4Y2wtK5l4YWpDy0hA+dS/EGRv9ASKDfN3hkM1EMW5NwUhkC7czBKGTarmE6AvDlgFSSkxpBOOZ4iG21AxdtLYRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gI9WAjzV; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723086406; x=1754622406;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=YCmbyQanPw3vuwKaQHr4MtLBUjyYVzF52LWa8YVi76s=;
  b=gI9WAjzVZlr1OPF34V6higoPgAkJjQwCjH4MAAqVIE1il3jrX67MVltj
   Qhkl5K09/UpOM3j+D+49Sh4u8LUFKKOkvwAK2FUchspyw9TjZpKiT5R2C
   dSqr+Utp6BNGfdTkzA8n6YdMfYAEes0fY/aCS3rNxGowLqpcVFA1UizZ0
   cjlC0uYPzkcaz92fxIsLnB+d4AYz1jXWc6Z8oE+y/79PEbdCrojRwlhQW
   3e+ht/x4dc0buKjxnYdxKMkR6x6133lwVWlCHlxP67HZkthfdmQqoGhtW
   vazrPPUqPzeDKnOcYU0ZGDCJeCjXAhrYOLneQ8jYtg9A5warxC6zOxk7F
   w==;
X-CSE-ConnectionGUID: Pmf6uQkHR0+Um0V6YZB63A==
X-CSE-MsgGUID: Kjt6VMC2Q3eMDuWRXAdryg==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="32596300"
X-IronPort-AV: E=Sophos;i="6.09,271,1716274800"; 
   d="scan'208";a="32596300"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2024 20:06:45 -0700
X-CSE-ConnectionGUID: OqP3DVC9To6wEA1DgjCsng==
X-CSE-MsgGUID: nQvnWqJKQ4e0TeTCKvsdpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,271,1716274800"; 
   d="scan'208";a="57032738"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by fmviesa009.fm.intel.com with ESMTP; 07 Aug 2024 20:06:44 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sbtUA-0005su-1R;
	Thu, 08 Aug 2024 03:06:42 +0000
Date: Thu, 8 Aug 2024 11:05:43 +0800
From: kernel test robot <lkp@intel.com>
To: Peter Xu <peterx@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org
Subject: [awilliam-vfio:vfio-huge-fault 443/453]
 arch/s390/pci/pci_mmio.c:127:21: warning: unused variable 'ptl'
Message-ID: <202408081010.KniYhdHB-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://github.com/awilliam/linux-vfio.git vfio-huge-fault
head:   0b72bf5c1dbf066b3a167e0033d8401ae2e2726f
commit: e93ffb9dfe21dc8f7f91afb6947bf30fff79d9a6 [443/453] s390/pci_mmio: Use follow_pfnmap API
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20240808/202408081010.KniYhdHB-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240808/202408081010.KniYhdHB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408081010.KniYhdHB-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/s390/pci/pci_mmio.c: In function '__do_sys_s390_pci_mmio_write':
>> arch/s390/pci/pci_mmio.c:127:21: warning: unused variable 'ptl' [-Wunused-variable]
     127 |         spinlock_t *ptl;
         |                     ^~~
>> arch/s390/pci/pci_mmio.c:126:16: warning: unused variable 'ptep' [-Wunused-variable]
     126 |         pte_t *ptep;
         |                ^~~~


vim +/ptl +127 arch/s390/pci/pci_mmio.c

4eafad7febd482 Alexey Ishchuk    2014-11-14  117  
4eafad7febd482 Alexey Ishchuk    2014-11-14  118  SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
4eafad7febd482 Alexey Ishchuk    2014-11-14  119  		const void __user *, user_buffer, size_t, length)
4eafad7febd482 Alexey Ishchuk    2014-11-14  120  {
e93ffb9dfe21dc Peter Xu          2024-04-23  121  	struct follow_pfnmap_args args = { };
4eafad7febd482 Alexey Ishchuk    2014-11-14  122  	u8 local_buf[64];
4eafad7febd482 Alexey Ishchuk    2014-11-14  123  	void __iomem *io_addr;
4eafad7febd482 Alexey Ishchuk    2014-11-14  124  	void *buf;
a67a88b0b8de16 Daniel Vetter     2020-10-21  125  	struct vm_area_struct *vma;
a67a88b0b8de16 Daniel Vetter     2020-10-21 @126  	pte_t *ptep;
a67a88b0b8de16 Daniel Vetter     2020-10-21 @127  	spinlock_t *ptl;
4eafad7febd482 Alexey Ishchuk    2014-11-14  128  	long ret;
4eafad7febd482 Alexey Ishchuk    2014-11-14  129  
4eafad7febd482 Alexey Ishchuk    2014-11-14  130  	if (!zpci_is_enabled())
4eafad7febd482 Alexey Ishchuk    2014-11-14  131  		return -ENODEV;
4eafad7febd482 Alexey Ishchuk    2014-11-14  132  
4eafad7febd482 Alexey Ishchuk    2014-11-14  133  	if (length <= 0 || PAGE_SIZE - (mmio_addr & ~PAGE_MASK) < length)
4eafad7febd482 Alexey Ishchuk    2014-11-14  134  		return -EINVAL;
f058599e22d59e Niklas Schnelle   2020-03-26  135  
f058599e22d59e Niklas Schnelle   2020-03-26  136  	/*
4631f3ca493a7c Niklas Schnelle   2020-07-07  137  	 * We only support write access to MIO capable devices if we are on
4631f3ca493a7c Niklas Schnelle   2020-07-07  138  	 * a MIO enabled system. Otherwise we would have to check for every
4631f3ca493a7c Niklas Schnelle   2020-07-07  139  	 * address if it is a special ZPCI_ADDR and would have to do
a67a88b0b8de16 Daniel Vetter     2020-10-21  140  	 * a pfn lookup which we don't need for MIO capable devices.  Currently
4631f3ca493a7c Niklas Schnelle   2020-07-07  141  	 * ISM devices are the only devices without MIO support and there is no
4631f3ca493a7c Niklas Schnelle   2020-07-07  142  	 * known need for accessing these from userspace.
f058599e22d59e Niklas Schnelle   2020-03-26  143  	 */
f058599e22d59e Niklas Schnelle   2020-03-26  144  	if (static_branch_likely(&have_mio)) {
f058599e22d59e Niklas Schnelle   2020-03-26  145  		ret = __memcpy_toio_inuser((void  __iomem *) mmio_addr,
f058599e22d59e Niklas Schnelle   2020-03-26  146  					user_buffer,
f058599e22d59e Niklas Schnelle   2020-03-26  147  					length);
f058599e22d59e Niklas Schnelle   2020-03-26  148  		return ret;
f058599e22d59e Niklas Schnelle   2020-03-26  149  	}
f058599e22d59e Niklas Schnelle   2020-03-26  150  
4eafad7febd482 Alexey Ishchuk    2014-11-14  151  	if (length > 64) {
4eafad7febd482 Alexey Ishchuk    2014-11-14  152  		buf = kmalloc(length, GFP_KERNEL);
4eafad7febd482 Alexey Ishchuk    2014-11-14  153  		if (!buf)
4eafad7febd482 Alexey Ishchuk    2014-11-14  154  			return -ENOMEM;
4eafad7febd482 Alexey Ishchuk    2014-11-14  155  	} else
4eafad7febd482 Alexey Ishchuk    2014-11-14  156  		buf = local_buf;
4eafad7febd482 Alexey Ishchuk    2014-11-14  157  
a67a88b0b8de16 Daniel Vetter     2020-10-21  158  	ret = -EFAULT;
a67a88b0b8de16 Daniel Vetter     2020-10-21  159  	if (copy_from_user(buf, user_buffer, length))
a67a88b0b8de16 Daniel Vetter     2020-10-21  160  		goto out_free;
a67a88b0b8de16 Daniel Vetter     2020-10-21  161  
a67a88b0b8de16 Daniel Vetter     2020-10-21  162  	mmap_read_lock(current->mm);
a67a88b0b8de16 Daniel Vetter     2020-10-21  163  	ret = -EINVAL;
a8b92b8c1eac8d David Hildenbrand 2021-09-09  164  	vma = vma_lookup(current->mm, mmio_addr);
a67a88b0b8de16 Daniel Vetter     2020-10-21  165  	if (!vma)
a67a88b0b8de16 Daniel Vetter     2020-10-21  166  		goto out_unlock_mmap;
a67a88b0b8de16 Daniel Vetter     2020-10-21  167  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)))
a67a88b0b8de16 Daniel Vetter     2020-10-21  168  		goto out_unlock_mmap;
a67a88b0b8de16 Daniel Vetter     2020-10-21  169  	ret = -EACCES;
a67a88b0b8de16 Daniel Vetter     2020-10-21  170  	if (!(vma->vm_flags & VM_WRITE))
a67a88b0b8de16 Daniel Vetter     2020-10-21  171  		goto out_unlock_mmap;
a67a88b0b8de16 Daniel Vetter     2020-10-21  172  
e93ffb9dfe21dc Peter Xu          2024-04-23  173  	args.address = mmio_addr;
e93ffb9dfe21dc Peter Xu          2024-04-23  174  	args.vma = vma;
e93ffb9dfe21dc Peter Xu          2024-04-23  175  	ret = follow_pfnmap_start(&args);
4eafad7febd482 Alexey Ishchuk    2014-11-14  176  	if (ret)
a67a88b0b8de16 Daniel Vetter     2020-10-21  177  		goto out_unlock_mmap;
a67a88b0b8de16 Daniel Vetter     2020-10-21  178  
e93ffb9dfe21dc Peter Xu          2024-04-23  179  	io_addr = (void __iomem *)((args.pfn << PAGE_SHIFT) |
f058599e22d59e Niklas Schnelle   2020-03-26  180  			(mmio_addr & ~PAGE_MASK));
4eafad7febd482 Alexey Ishchuk    2014-11-14  181  
4eafad7febd482 Alexey Ishchuk    2014-11-14  182  	if ((unsigned long) io_addr < ZPCI_IOMAP_ADDR_BASE)
a67a88b0b8de16 Daniel Vetter     2020-10-21  183  		goto out_unlock_pt;
4eafad7febd482 Alexey Ishchuk    2014-11-14  184  
f0483044c1c960 Sebastian Ott     2015-02-25  185  	ret = zpci_memcpy_toio(io_addr, buf, length);
a67a88b0b8de16 Daniel Vetter     2020-10-21  186  out_unlock_pt:
e93ffb9dfe21dc Peter Xu          2024-04-23  187  	follow_pfnmap_end(&args);
a67a88b0b8de16 Daniel Vetter     2020-10-21  188  out_unlock_mmap:
a67a88b0b8de16 Daniel Vetter     2020-10-21  189  	mmap_read_unlock(current->mm);
a67a88b0b8de16 Daniel Vetter     2020-10-21  190  out_free:
4eafad7febd482 Alexey Ishchuk    2014-11-14  191  	if (buf != local_buf)
4eafad7febd482 Alexey Ishchuk    2014-11-14  192  		kfree(buf);
4eafad7febd482 Alexey Ishchuk    2014-11-14  193  	return ret;
4eafad7febd482 Alexey Ishchuk    2014-11-14  194  }
4eafad7febd482 Alexey Ishchuk    2014-11-14  195  

:::::: The code at line 127 was first introduced by commit
:::::: a67a88b0b8de16b4cd6ad50bfe0e03605904dc75 s390/pci: remove races against pte updates

:::::: TO: Daniel Vetter <daniel.vetter@ffwll.ch>
:::::: CC: Heiko Carstens <hca@linux.ibm.com>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

