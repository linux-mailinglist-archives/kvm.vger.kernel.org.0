Return-Path: <kvm+bounces-53274-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3477AB0F833
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 18:33:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 325121898F31
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 16:34:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B93EC1F582A;
	Wed, 23 Jul 2025 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UBevyuAE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6339C1F4628
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 16:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753288423; cv=none; b=rN8zL1B4bF5IzpuxqwQq1Hlb/BpeqOnncE8+vBtYfp6m9xgCszFvHO0ewp3audlfz0RmKq5l4ONhnzEqMsrFG0d3+nn9VzuCJhkJYOMYSAqvX49EiTAZA6rg1vHr3Z171JNqUi4kEffc2kqt4RmyM/xWy6bTcxuRUBbYg0FCkec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753288423; c=relaxed/simple;
	bh=oF1i5b2lTL96fJ4t2ke7yLrfadoHxz5fZwaCgJOdC0U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oL/RqzXOxNa1kex7BSo4/xct9hDVDx+Qsawu/CwZKJ3ejIuM3xzILAiebMchD3cA2+ROalQ6fyj+gzhq/v0SkXAKsBTbwwNKDDoQCtQsFScYZklHqj+rKu9kO6IMojxqO40uIKdI7PH8H29CBt4WH0t4OBPttCZvH++ZvI41HXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UBevyuAE; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753288422; x=1784824422;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oF1i5b2lTL96fJ4t2ke7yLrfadoHxz5fZwaCgJOdC0U=;
  b=UBevyuAEbxqYxBgzG8ALiHo1XRDxikCIthY1Jjm6LALwLMMpdKEp8miK
   bX8kSlc1aMtwECrJas4u7yyYLGJCWMnSqNkfd0ZxgR5V52tHLnb4cDy+7
   R1a561fXFQPujfGTAj48Bxt+fVqY5NwnAjDe/HjGWvyZjSPLka44GgwQL
   9JIrWFiUUMquXtQgb0xvLH5mq9EDzvKa5DYMHx1zvrR4XKlMjot97+Mr4
   /lkSUf92jAam3mSnnrVCOeJ7LSjaAY4cODW5H+2EA+czYJCzD8LcnIVFI
   B8lKsUlx6AeyZ3990xzQ34VchfKD5DRthYU7jN2LkaCAGHnBa1PJWEDI3
   g==;
X-CSE-ConnectionGUID: bw7jVuqPTfWV63D++CgT7w==
X-CSE-MsgGUID: 3bfpPQFSR+Sd1jV48thw3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="55537346"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55537346"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2025 09:33:40 -0700
X-CSE-ConnectionGUID: FqMn6sH4SGelAGq6LGv3fA==
X-CSE-MsgGUID: ILIvTBsoQ4iGXcIR8Cj42g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="159628874"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by fmviesa006.fm.intel.com with ESMTP; 23 Jul 2025 09:33:37 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uecPO-000JZ9-1h;
	Wed, 23 Jul 2025 16:33:34 +0000
Date: Thu, 24 Jul 2025 00:33:11 +0800
From: kernel test robot <lkp@intel.com>
To: Hogan Wang <hogan.wang@huawei.com>, x86@kernel.org,
	dave.hansen@linux.intel.com, kvm@vger.kernel.org,
	alex.williamson@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, weidong.huang@huawei.com,
	yechuan@huawei.com, hogan.wang@huawei.com,
	wangxinxin.wang@huawei.com, jianjay.zhou@huawei.com,
	wangjie88@huawei.com
Subject: Re: [PATCH] x86/irq: introduce repair_irq try to repair CPU vector
Message-ID: <202507240030.11iG6frT-lkp@intel.com>
References: <20250723015045.1701-1-hogan.wang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723015045.1701-1-hogan.wang@huawei.com>

Hi Hogan,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/irq/core]
[also build test ERROR on tip/master tip/x86/core awilliam-vfio/next linus/master v6.16-rc7 next-20250723]
[cannot apply to tip/auto-latest awilliam-vfio/for-linus]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Hogan-Wang/x86-irq-introduce-repair_irq-try-to-repair-CPU-vector/20250723-095327
base:   tip/irq/core
patch link:    https://lore.kernel.org/r/20250723015045.1701-1-hogan.wang%40huawei.com
patch subject: [PATCH] x86/irq: introduce repair_irq try to repair CPU vector
config: openrisc-allnoconfig (https://download.01.org/0day-ci/archive/20250724/202507240030.11iG6frT-lkp@intel.com/config)
compiler: or1k-linux-gcc (GCC) 15.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250724/202507240030.11iG6frT-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507240030.11iG6frT-lkp@intel.com/

All errors (new ones prefixed by >>):

   kernel/irq/manage.c: In function 'repair_irq':
>> kernel/irq/manage.c:1431:9: error: implicit declaration of function 'irq_domain_repair_irq'; did you mean 'irq_domain_free_irqs'? [-Wimplicit-function-declaration]
    1431 |         irq_domain_repair_irq(irq_desc_get_irq_data(desc));
         |         ^~~~~~~~~~~~~~~~~~~~~
         |         irq_domain_free_irqs


vim +1431 kernel/irq/manage.c

  1420	
  1421	
  1422	void repair_irq(unsigned int irq)
  1423	{
  1424		struct irq_desc *desc = irq_to_desc(irq);
  1425		unsigned long flags;
  1426	
  1427		mutex_lock(&desc->request_mutex);
  1428		chip_bus_lock(desc);
  1429		raw_spin_lock_irqsave(&desc->lock, flags);
  1430	
> 1431		irq_domain_repair_irq(irq_desc_get_irq_data(desc));
  1432	
  1433		raw_spin_unlock_irqrestore(&desc->lock, flags);
  1434		chip_bus_sync_unlock(desc);
  1435		mutex_unlock(&desc->request_mutex);
  1436	}
  1437	EXPORT_SYMBOL(repair_irq);
  1438	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

