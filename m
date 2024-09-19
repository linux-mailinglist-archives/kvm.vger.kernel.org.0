Return-Path: <kvm+bounces-27120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DF297C2D9
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36656B21CC6
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 02:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DB301EF1D;
	Thu, 19 Sep 2024 02:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SQQt22vj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 990E3BA3D
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 02:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726713190; cv=none; b=BJKTX17pEVgKNSsC36yFyu9h/V52W2TqZ/cZBvuRU/nU90kjXzMg8GK+Yn/+AqaQ6xtIag5RXUN6M8C0JsYY63UHhiw9KCHYd2xeBuGFpwuoNP2muBGAl3uovqio7sh8pyyujiuw8/nAWDF7+HXXJjBA6shepI+9lv0/kVxt22k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726713190; c=relaxed/simple;
	bh=LnVqCTl/DSIuzexp1Q7fc9Ja/psmiLqRekrpQqozjyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gb9L5ok7K8e6dU8UHjZcTd7QiC5v5h/VgAOOMAsmj9eI9ThQMBhCB/LFyJRr8lHgVFpebrwy8X6ywKKCBAb2oDDjyTmbzXdm5OKCiajzXSeIQXUd6FnI27QiZc1hNDJYG3w6jYK4GiTQglfL3tuOpoGJljEh+0XfdMeXNhy1zWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SQQt22vj; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726713189; x=1758249189;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LnVqCTl/DSIuzexp1Q7fc9Ja/psmiLqRekrpQqozjyY=;
  b=SQQt22vj7gDvowMLI/SX7x6g0Qn8sRyvcKwP7oczZHa/8KxRnHoTjejI
   i5Z2B6pl2idGXJ7lRnKIIcNKH8IJyn6oPeNbHV7BGZbI2Zfe3RXzJrBR+
   kmc159gqWpfWPluZNVrJrVc3oUhbX3zgjkplrVePJvvi9EDQXIfPEDnhy
   Tmzh/LhqDsnH1++C+BjNkWUuSgJ7mxrubBbcD0qyplGEpzOMi2vJ91rd+
   eR/QX1TNDrVPPiOUZoC/zNy7Dd9BL3iOKCpfkcVAR7++45jCJlpGzMzUe
   VnxGieDTtXrWgS/GlUwDvjgr+twHYzLBZYOOVuyWXDWL0h5KGy91t9wbk
   Q==;
X-CSE-ConnectionGUID: 6YB+C1+HSyq/0UG/KwHsgQ==
X-CSE-MsgGUID: 6APvbkdPQNqsiUY1sh1+MA==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="36226629"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="36226629"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 19:33:09 -0700
X-CSE-ConnectionGUID: OpZ8ImQ4SV6f7eis63ZUEA==
X-CSE-MsgGUID: g8GKn9P0RpWj2x1uW2tsFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="74315463"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa004.fm.intel.com with ESMTP; 18 Sep 2024 19:33:05 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sr6yd-000CpW-0g;
	Thu, 19 Sep 2024 02:33:03 +0000
Date: Thu, 19 Sep 2024 10:32:22 +0800
From: kernel test robot <lkp@intel.com>
To: Lilit Janpoladyan <lilitj@amazon.com>, kvm@vger.kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	nh-open-source@amazon.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 4/8] KVM: return value from kvm_arch_sync_dirty_log
Message-ID: <202409191039.OFrXIvns-lkp@intel.com>
References: <20240918152807.25135-5-lilitj@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240918152807.25135-5-lilitj@amazon.com>

Hi Lilit,

kernel test robot noticed the following build warnings:

[auto build test WARNING on powerpc/topic/ppc-kvm]
[also build test WARNING on v6.11]
[cannot apply to kvmarm/next kvm/queue linus/master kvm/linux-next next-20240918]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lilit-Janpoladyan/arm64-add-an-interface-for-stage-2-page-tracking/20240918-233004
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
patch link:    https://lore.kernel.org/r/20240918152807.25135-5-lilitj%40amazon.com
patch subject: [PATCH 4/8] KVM: return value from kvm_arch_sync_dirty_log
config: s390-allmodconfig (https://download.01.org/0day-ci/archive/20240919/202409191039.OFrXIvns-lkp@intel.com/config)
compiler: clang version 20.0.0git (https://github.com/llvm/llvm-project 8663a75fa2f31299ab8d1d90288d9df92aadee88)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240919/202409191039.OFrXIvns-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409191039.OFrXIvns-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/s390/kvm/kvm-s390.c:22:
   In file included from include/linux/kvm_host.h:16:
   In file included from include/linux/mm.h:2228:
   include/linux/vmstat.h:500:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     500 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     501 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:507:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     507 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     508 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:514:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     514 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:519:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     519 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     520 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:528:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     528 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     529 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/s390/kvm/kvm-s390.c:22:
   In file included from include/linux/kvm_host.h:19:
   In file included from include/linux/msi.h:24:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/s390/include/asm/io.h:93:
   include/asm-generic/io.h:548:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     548 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:561:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     561 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
         |                                                           ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
     102 | #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
         |                                                      ^
   In file included from arch/s390/kvm/kvm-s390.c:22:
   In file included from include/linux/kvm_host.h:19:
   In file included from include/linux/msi.h:24:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/s390/include/asm/io.h:93:
   include/asm-generic/io.h:574:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     574 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
         |                                                           ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
     115 | #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
         |                                                      ^
   In file included from arch/s390/kvm/kvm-s390.c:22:
   In file included from include/linux/kvm_host.h:19:
   In file included from include/linux/msi.h:24:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:14:
   In file included from arch/s390/include/asm/io.h:93:
   include/asm-generic/io.h:585:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     585 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:595:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     595 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:605:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     605 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:693:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     693 |         readsb(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:701:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     701 |         readsw(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:709:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     709 |         readsl(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:718:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     718 |         writesb(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:727:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     727 |         writesw(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:736:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     736 |         writesl(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
>> arch/s390/kvm/kvm-s390.c:705:4: warning: non-void function 'kvm_arch_sync_dirty_log' should return a value [-Wreturn-mismatch]
     705 |                         return;
         |                         ^
   18 warnings generated.


vim +/kvm_arch_sync_dirty_log +705 arch/s390/kvm/kvm-s390.c

5b5865e81387b9 Lilit Janpoladyan     2024-09-18  679  
522a3b6f0285f5 Lilit Janpoladyan     2024-09-18  680  int kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
15f36ebd34b5b2 Jason J. Herne        2012-08-02  681  {
0959e168678d2d Janosch Frank         2018-07-17  682  	int i;
15f36ebd34b5b2 Jason J. Herne        2012-08-02  683  	gfn_t cur_gfn, last_gfn;
0959e168678d2d Janosch Frank         2018-07-17  684  	unsigned long gaddr, vmaddr;
15f36ebd34b5b2 Jason J. Herne        2012-08-02  685  	struct gmap *gmap = kvm->arch.gmap;
0959e168678d2d Janosch Frank         2018-07-17  686  	DECLARE_BITMAP(bitmap, _PAGE_ENTRIES);
15f36ebd34b5b2 Jason J. Herne        2012-08-02  687  
0959e168678d2d Janosch Frank         2018-07-17  688  	/* Loop over all guest segments */
0959e168678d2d Janosch Frank         2018-07-17  689  	cur_gfn = memslot->base_gfn;
15f36ebd34b5b2 Jason J. Herne        2012-08-02  690  	last_gfn = memslot->base_gfn + memslot->npages;
0959e168678d2d Janosch Frank         2018-07-17  691  	for (; cur_gfn <= last_gfn; cur_gfn += _PAGE_ENTRIES) {
0959e168678d2d Janosch Frank         2018-07-17  692  		gaddr = gfn_to_gpa(cur_gfn);
0959e168678d2d Janosch Frank         2018-07-17  693  		vmaddr = gfn_to_hva_memslot(memslot, cur_gfn);
0959e168678d2d Janosch Frank         2018-07-17  694  		if (kvm_is_error_hva(vmaddr))
0959e168678d2d Janosch Frank         2018-07-17  695  			continue;
0959e168678d2d Janosch Frank         2018-07-17  696  
0959e168678d2d Janosch Frank         2018-07-17  697  		bitmap_zero(bitmap, _PAGE_ENTRIES);
0959e168678d2d Janosch Frank         2018-07-17  698  		gmap_sync_dirty_log_pmd(gmap, bitmap, gaddr, vmaddr);
0959e168678d2d Janosch Frank         2018-07-17  699  		for (i = 0; i < _PAGE_ENTRIES; i++) {
0959e168678d2d Janosch Frank         2018-07-17  700  			if (test_bit(i, bitmap))
0959e168678d2d Janosch Frank         2018-07-17  701  				mark_page_dirty(kvm, cur_gfn + i);
0959e168678d2d Janosch Frank         2018-07-17  702  		}
15f36ebd34b5b2 Jason J. Herne        2012-08-02  703  
1763f8d09d522b Christian Borntraeger 2016-02-03  704  		if (fatal_signal_pending(current))
1763f8d09d522b Christian Borntraeger 2016-02-03 @705  			return;
70c88a00fbf659 Christian Borntraeger 2016-02-02  706  		cond_resched();
15f36ebd34b5b2 Jason J. Herne        2012-08-02  707  	}
522a3b6f0285f5 Lilit Janpoladyan     2024-09-18  708  	return 0;
15f36ebd34b5b2 Jason J. Herne        2012-08-02  709  }
15f36ebd34b5b2 Jason J. Herne        2012-08-02  710  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

