Return-Path: <kvm+bounces-14389-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A783A8A2643
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:12:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CB1B01C22012
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 06:12:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8DD224FD;
	Fri, 12 Apr 2024 06:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PWFjKsic"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E36DF1F60B
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 06:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712902356; cv=none; b=qo7IMwSxmvYtGV6OViBlLyKX29zlUylVEELbxSCJgpphgKuL71267e2mFd6P++/LGk1kER00DaNAyUxv1yofLCbx5b4u46GhS21yTlS/POvu1yp4b2r0+6LBVIYs5ajyemA6LoX8TFcHgJzIU+FlpOv01I3lm/ghzZwPkAWGwFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712902356; c=relaxed/simple;
	bh=xWRHVpdbdTmp39ThjwxKNCpHQ0iZavEKQ6v4pQ8vzM4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=NboiA6UpX2HJEB7zzxwPXNBJBHrmLwC5jtZAuxjvh0AJNLWqEkChCvnpf92w1ofgmpY+cKT7c4CJc3VtkdXwYXbtXwBInrL9/kjMVi7oSN3BheeUynERAYqD5Z1zCOVfMji4r0JOlia/IdzneH3RDrsuOsqDcA/YD7KVRjfBxVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PWFjKsic; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712902355; x=1744438355;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=xWRHVpdbdTmp39ThjwxKNCpHQ0iZavEKQ6v4pQ8vzM4=;
  b=PWFjKsicbX7sik0102F/6Kt5DBsiCw+L375mXP5RVe3h4QAU/OXZffY6
   hkLJ9Ke4tmQRUKQAej9xtPSy18jNfnvNu4lfSZ9wvYSVauVX++ttUtENt
   6JseVUhQh6SghvOh3lFRw9evJeih5l23+hb1fqmp8MxpBWiGjZaWyD0gr
   b1lU24iDEJV8DStnhmef6ylToVYuNGojpjG/iU8JClGjNbwLc5kCznHk/
   RZQbK9xBzKPy+agsGvUS3+hPe1b4VU8MZaODdWyxluz5QoLkx63rA1YR/
   Jz0sgGw4KYXNZ7C3r2PV5KDoNkjgW3XpDwMV4fguRL/Akob9OmLqNox2o
   Q==;
X-CSE-ConnectionGUID: QIOxv84XQFqUaBQkmF5O1w==
X-CSE-MsgGUID: 8wjmNTByQ2ym640GWjSrQA==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8218764"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8218764"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 23:12:35 -0700
X-CSE-ConnectionGUID: DOGdUYjwQ8CM3OL7v0RhHw==
X-CSE-MsgGUID: OkYfvjxzQGaRwmXCGyHlMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="21197074"
Received: from lkp-server01.sh.intel.com (HELO e61807b1d151) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 11 Apr 2024 23:12:31 -0700
Received: from kbuild by e61807b1d151 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rvA9F-0009Rf-2E;
	Fri, 12 Apr 2024 06:12:29 +0000
Date: Fri, 12 Apr 2024 14:12:11 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Robert Hu <robert.hu@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	Danmei Wei <danmei.wei@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Subject: [kvm:queue 23/29] kernel/events/uprobes.c:160:35: error: storage
 size of 'range' isn't known
Message-ID: <202404121456.kg5QIV3w-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
head:   415efaaf0d973684af5fa7c9ddccf111485f9f1b
commit: b06d4c260e93214808f9dd6031226b1b0e2937f1 [23/29] mm: replace set_pte_at_notify() with just set_pte_at()
config: sparc64-defconfig (https://download.01.org/0day-ci/archive/20240412/202404121456.kg5QIV3w-lkp@intel.com/config)
compiler: sparc64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240412/202404121456.kg5QIV3w-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404121456.kg5QIV3w-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/events/uprobes.c: In function '__replace_page':
>> kernel/events/uprobes.c:160:35: error: storage size of 'range' isn't known
     160 |         struct mmu_notifier_range range;
         |                                   ^~~~~
>> kernel/events/uprobes.c:162:9: error: implicit declaration of function 'mmu_notifier_range_init' [-Werror=implicit-function-declaration]
     162 |         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
         |         ^~~~~~~~~~~~~~~~~~~~~~~
>> kernel/events/uprobes.c:162:41: error: 'MMU_NOTIFY_CLEAR' undeclared (first use in this function)
     162 |         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
         |                                         ^~~~~~~~~~~~~~~~
   kernel/events/uprobes.c:162:41: note: each undeclared identifier is reported only once for each function it appears in
>> kernel/events/uprobes.c:175:9: error: implicit declaration of function 'mmu_notifier_invalidate_range_start' [-Werror=implicit-function-declaration]
     175 |         mmu_notifier_invalidate_range_start(&range);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> kernel/events/uprobes.c:208:9: error: implicit declaration of function 'mmu_notifier_invalidate_range_end' [-Werror=implicit-function-declaration]
     208 |         mmu_notifier_invalidate_range_end(&range);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   kernel/events/uprobes.c:160:35: warning: unused variable 'range' [-Wunused-variable]
     160 |         struct mmu_notifier_range range;
         |                                   ^~~~~
   cc1: some warnings being treated as errors


vim +160 kernel/events/uprobes.c

cb113b47d09818 kernel/events/uprobes.c Oleg Nesterov           2012-07-29  138  
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  139  /**
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  140   * __replace_page - replace page in vma by new page.
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  141   * based on replace_page in mm/ksm.c
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  142   *
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  143   * @vma:      vma that holds the pte pointing to page
c517ee744b96e4 kernel/events/uprobes.c Oleg Nesterov           2012-07-29  144   * @addr:     address the old @page is mapped at
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  145   * @old_page: the page we are replacing by new_page
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  146   * @new_page: the modified page we replace page by
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  147   *
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  148   * If @new_page is NULL, only unmap @old_page.
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  149   *
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  150   * Returns 0 on success, negative error code otherwise.
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  151   */
c517ee744b96e4 kernel/events/uprobes.c Oleg Nesterov           2012-07-29  152  static int __replace_page(struct vm_area_struct *vma, unsigned long addr,
bdfaa2eecd5f6c kernel/events/uprobes.c Oleg Nesterov           2016-08-17  153  				struct page *old_page, struct page *new_page)
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  154  {
5fcd079af9ed4e kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  155) 	struct folio *old_folio = page_folio(old_page);
82e66bf76173a1 kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  156) 	struct folio *new_folio;
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  157  	struct mm_struct *mm = vma->vm_mm;
5fcd079af9ed4e kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  158) 	DEFINE_FOLIO_VMA_WALK(pvmw, old_folio, vma, addr, 0);
9f92448ceeea53 kernel/events/uprobes.c Oleg Nesterov           2012-07-29  159  	int err;
ac46d4f3c43241 kernel/events/uprobes.c Jérôme Glisse           2018-12-28 @160  	struct mmu_notifier_range range;
00501b531c4723 kernel/events/uprobes.c Johannes Weiner         2014-08-08  161  
7d4a8be0c4b2b7 kernel/events/uprobes.c Alistair Popple         2023-01-10 @162  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, addr,
6f4f13e8d9e27c kernel/events/uprobes.c Jérôme Glisse           2019-05-13  163  				addr + PAGE_SIZE);
ac46d4f3c43241 kernel/events/uprobes.c Jérôme Glisse           2018-12-28  164  
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  165  	if (new_page) {
82e66bf76173a1 kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  166) 		new_folio = page_folio(new_page);
82e66bf76173a1 kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  167) 		err = mem_cgroup_charge(new_folio, vma->vm_mm, GFP_KERNEL);
00501b531c4723 kernel/events/uprobes.c Johannes Weiner         2014-08-08  168  		if (err)
00501b531c4723 kernel/events/uprobes.c Johannes Weiner         2014-08-08  169  			return err;
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  170  	}
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  171  
5fcd079af9ed4e kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  172) 	/* For folio_free_swap() below */
5fcd079af9ed4e kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  173) 	folio_lock(old_folio);
9f92448ceeea53 kernel/events/uprobes.c Oleg Nesterov           2012-07-29  174  
ac46d4f3c43241 kernel/events/uprobes.c Jérôme Glisse           2018-12-28 @175  	mmu_notifier_invalidate_range_start(&range);
9f92448ceeea53 kernel/events/uprobes.c Oleg Nesterov           2012-07-29  176  	err = -EAGAIN;
9d82c69438d0df kernel/events/uprobes.c Johannes Weiner         2020-06-03  177  	if (!page_vma_mapped_walk(&pvmw))
9f92448ceeea53 kernel/events/uprobes.c Oleg Nesterov           2012-07-29  178  		goto unlock;
14fa2daa15887f kernel/events/uprobes.c Kirill A. Shutemov      2017-02-24  179  	VM_BUG_ON_PAGE(addr != pvmw.address, old_page);
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  180  
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  181  	if (new_page) {
82e66bf76173a1 kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  182) 		folio_get(new_folio);
2853b66b601a26 kernel/events/uprobes.c Matthew Wilcox (Oracle  2023-12-11  183) 		folio_add_new_anon_rmap(new_folio, vma, addr);
82e66bf76173a1 kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  184) 		folio_add_lru_vma(new_folio, vma);
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  185  	} else
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  186  		/* no new page, just dec_mm_counter for old_page */
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  187  		dec_mm_counter(mm, MM_ANONPAGES);
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  188  
5fcd079af9ed4e kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  189) 	if (!folio_test_anon(old_folio)) {
6b27cc6c66abf0 kernel/events/uprobes.c Kefeng Wang             2024-01-11  190  		dec_mm_counter(mm, mm_counter_file(old_folio));
7396fa818d6278 kernel/events/uprobes.c Srikar Dronamraju       2012-04-11  191  		inc_mm_counter(mm, MM_ANONPAGES);
7396fa818d6278 kernel/events/uprobes.c Srikar Dronamraju       2012-04-11  192  	}
7396fa818d6278 kernel/events/uprobes.c Srikar Dronamraju       2012-04-11  193  
c33c794828f212 kernel/events/uprobes.c Ryan Roberts            2023-06-12  194  	flush_cache_page(vma, addr, pte_pfn(ptep_get(pvmw.pte)));
ec8832d007cb7b kernel/events/uprobes.c Alistair Popple         2023-07-25  195  	ptep_clear_flush(vma, addr, pvmw.pte);
fb4fb04ff4dd37 kernel/events/uprobes.c Song Liu                2019-09-23  196  	if (new_page)
b06d4c260e9321 kernel/events/uprobes.c Paolo Bonzini           2024-04-05  197  		set_pte_at(mm, addr, pvmw.pte,
14fa2daa15887f kernel/events/uprobes.c Kirill A. Shutemov      2017-02-24  198  			   mk_pte(new_page, vma->vm_page_prot));
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  199  
5cc9695f06b065 kernel/events/uprobes.c David Hildenbrand       2023-12-20  200  	folio_remove_rmap_pte(old_folio, old_page, vma);
5fcd079af9ed4e kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  201) 	if (!folio_mapped(old_folio))
5fcd079af9ed4e kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  202) 		folio_free_swap(old_folio);
14fa2daa15887f kernel/events/uprobes.c Kirill A. Shutemov      2017-02-24  203  	page_vma_mapped_walk_done(&pvmw);
5fcd079af9ed4e kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  204) 	folio_put(old_folio);
194f8dcbe9629d kernel/events/uprobes.c Oleg Nesterov           2012-07-29  205  
9f92448ceeea53 kernel/events/uprobes.c Oleg Nesterov           2012-07-29  206  	err = 0;
9f92448ceeea53 kernel/events/uprobes.c Oleg Nesterov           2012-07-29  207   unlock:
ac46d4f3c43241 kernel/events/uprobes.c Jérôme Glisse           2018-12-28 @208  	mmu_notifier_invalidate_range_end(&range);
5fcd079af9ed4e kernel/events/uprobes.c Matthew Wilcox (Oracle  2022-09-02  209) 	folio_unlock(old_folio);
9f92448ceeea53 kernel/events/uprobes.c Oleg Nesterov           2012-07-29  210  	return err;
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  211  }
2b144498350860 kernel/uprobes.c        Srikar Dronamraju       2012-02-09  212  

:::::: The code at line 160 was first introduced by commit
:::::: ac46d4f3c43241ffa23d5bf36153a0830c0e02cc mm/mmu_notifier: use structure for invalidate_range_start/end calls v2

:::::: TO: Jérôme Glisse <jglisse@redhat.com>
:::::: CC: Linus Torvalds <torvalds@linux-foundation.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

