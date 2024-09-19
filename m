Return-Path: <kvm+bounces-27118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BDDE97C2B6
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 03:51:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16695282C75
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 01:51:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E0AB171A7;
	Thu, 19 Sep 2024 01:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EViG3WTK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E726FA933
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 01:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726710668; cv=none; b=SYd5AZFLJ4owIzrgaPig5laY0ifLFBPSb7ZDC91DEeYfVVtTUVQo0ymxwA1sjuZ8JkxU0QmFbtd1q9p6A3ebZcJ85aJMhidImidn1ZIcVUO3MrqShfoZZFPNvYhQJq/lkESe9oiYPIbiOoansZpt6Xr4DzB3AT1QFxjYEecy5uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726710668; c=relaxed/simple;
	bh=bq5XVGJhOUssVaQsQJa4EXSuW70ktn5ArNHkNSi8o84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DgKQxDVh58zkWUssQxzXeXSgsYNgpCoP5qsvAfDvwwsGN8lWhgXTBKTRK3O+QIwrOuByDrPGh4/psMAq3/qA80R1BdQeljj8auCMrQ3leVxHk4mjN3whrrAdmldBubr9mpv218ISxgiUfTf6ldFVYaFVcsGdmaqXc1iaGCjUjW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EViG3WTK; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726710667; x=1758246667;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bq5XVGJhOUssVaQsQJa4EXSuW70ktn5ArNHkNSi8o84=;
  b=EViG3WTKfqv3qUq/PEIIn/U52DnqkL1gcuUWR/ZmOyXChT3Cxhg1A6zT
   dABFwJ5hmcO3J2o41PbbDPp09RKQXvxn1w1ysvbaKW0jhqNN+MY66XJf0
   JxrabsybdvED4stPB3d8mjDowC6oh9fzwh1R4hTx7xpRMZo1T1TYfU9JZ
   V5b9zu6aeKBsERIfZEnwwEprlUqTk5IJX11D3M2ZYYHh9cOsZ39QojTRf
   GtWwx8acrZQs6+gxySw45BYQJEQrYgR9OuYELTE7f0rweH0QogjtkxdiP
   M1e5RZtvs4+7RBPKCsFWOumwk8A67KkOE0pomIRunOxH/KoICGbjRDi4Y
   g==;
X-CSE-ConnectionGUID: hNJ+/F1rQLGWqYkaoAj4QQ==
X-CSE-MsgGUID: X8iMkX2GTdiU0mkmheT4RA==
X-IronPort-AV: E=McAfee;i="6700,10204,11199"; a="13583747"
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="13583747"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2024 18:51:06 -0700
X-CSE-ConnectionGUID: mX7DV9WuR8i9xr+k7GMxNQ==
X-CSE-MsgGUID: EiH87qedTVyQOHypWE598w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,240,1719903600"; 
   d="scan'208";a="70012634"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 18 Sep 2024 18:51:03 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sr6Jx-000Cna-2E;
	Thu, 19 Sep 2024 01:51:01 +0000
Date: Thu, 19 Sep 2024 09:50:36 +0800
From: kernel test robot <lkp@intel.com>
To: Lilit Janpoladyan <lilitj@amazon.com>, kvm@vger.kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	nh-open-source@amazon.com
Cc: oe-kbuild-all@lists.linux.dev
Subject: Re: [PATCH 4/8] KVM: return value from kvm_arch_sync_dirty_log
Message-ID: <202409190941.BQaCqQSk-lkp@intel.com>
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

kernel test robot noticed the following build errors:

[auto build test ERROR on powerpc/topic/ppc-kvm]
[also build test ERROR on v6.11]
[cannot apply to kvmarm/next kvm/queue linus/master kvm/linux-next next-20240918]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Lilit-Janpoladyan/arm64-add-an-interface-for-stage-2-page-tracking/20240918-233004
base:   https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git topic/ppc-kvm
patch link:    https://lore.kernel.org/r/20240918152807.25135-5-lilitj%40amazon.com
patch subject: [PATCH 4/8] KVM: return value from kvm_arch_sync_dirty_log
config: s390-allyesconfig (https://download.01.org/0day-ci/archive/20240919/202409190941.BQaCqQSk-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240919/202409190941.BQaCqQSk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202409190941.BQaCqQSk-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/s390/kvm/kvm-s390.c: In function 'kvm_arch_sync_dirty_log':
>> arch/s390/kvm/kvm-s390.c:705:25: error: 'return' with no value, in function returning non-void [-Wreturn-mismatch]
     705 |                         return;
         |                         ^~~~~~
   arch/s390/kvm/kvm-s390.c:680:5: note: declared here
     680 | int kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
         |     ^~~~~~~~~~~~~~~~~~~~~~~


vim +/return +705 arch/s390/kvm/kvm-s390.c

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

