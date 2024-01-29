Return-Path: <kvm+bounces-7293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E8BF83FB9A
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 02:04:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A6EC1F23218
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 01:04:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA26BD27A;
	Mon, 29 Jan 2024 01:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S4/0uFcB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE582DDA7
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 01:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706490238; cv=none; b=MmGl7v6SVOrp5IEOEpj3wQOMsMVIdgVKuDYtQAHMTfnRJ7XuNwqS4COsy1qWXPudv0lud4JnbIpS5nzsPhfSLt/MP8q6zfjOsXElS98fHErMcZv4bOyku+gwUvtenYb7U3dTUkF9uDcvWYut5z0rxnAiWJLGlLCS6Z+0jY0ZM5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706490238; c=relaxed/simple;
	bh=7dCyYyC9HvsH0TC63mIxeQgXtZjfv1V7t2rD9NAJ8Jk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d7epOqUOMbFtLjrDi20XtevXO9TZS1KC2I0B8do0/oMZGwcXdVfFHMCiQ/Nmu8jbCiCSGn0wh1QNm8+kAzmz5QnEU4jQa6Tcqj3NppDIqky/hZ2ixGWJiwd+L6VqkW7FYr+xD2HK6EqblIvVPWThNIpLBtF0UKL8no1rFsx7ziw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S4/0uFcB; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706490237; x=1738026237;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7dCyYyC9HvsH0TC63mIxeQgXtZjfv1V7t2rD9NAJ8Jk=;
  b=S4/0uFcB8Uljbg/BkszEOU3zfu+pUqqH2ruH97Jwrpf4T56Y2yAKjTDM
   0zQEuPgKRdtyQSr9WcpK9aUxots4BtS55NLcQ5qwqXipCwpFt33f7x2fO
   L0Q3taPTV52sw3/Tok1HVzRbjdZ+D0ZNwNKmXTj/6Nrj7kb706iP2RoG/
   mXl9dktq3356bmomatL4ojw0OkZ4bXnurap22+K6+7orcwDHHz99k0Qne
   zVKEJdigcJI3G5wK23nMFry1uNUFHRYwqS9L1U6mdBylnLU2ZQB+Ql7yK
   cX4F1j3CsUtmukee8V5TfriUhzUyZFNXUvzeMrXI7wi/b52BIGT7w8lXZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="10207112"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="10207112"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 17:03:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10967"; a="906910595"
X-IronPort-AV: E=Sophos;i="6.05,226,1701158400"; 
   d="scan'208";a="906910595"
Received: from lkp-server01.sh.intel.com (HELO 370188f8dc87) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 28 Jan 2024 17:03:53 -0800
Received: from kbuild by 370188f8dc87 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1rUG3y-0003uW-2i;
	Mon, 29 Jan 2024 01:03:50 +0000
Date: Mon, 29 Jan 2024 09:03:25 +0800
From: kernel test robot <lkp@intel.com>
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Jing Zhang <jingzhangos@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH 13/15] KVM: arm64: vgic-its: Protect cached vgic_irq
 pointers with RCU
Message-ID: <202401290835.TjDnhUFI-lkp@intel.com>
References: <20240124204909.105952-14-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124204909.105952-14-oliver.upton@linux.dev>

Hi Oliver,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 6613476e225e090cc9aad49be7fa504e290dd33d]

url:    https://github.com/intel-lab-lkp/linux/commits/Oliver-Upton/KVM-arm64-vgic-Store-LPIs-in-an-xarray/20240125-045255
base:   6613476e225e090cc9aad49be7fa504e290dd33d
patch link:    https://lore.kernel.org/r/20240124204909.105952-14-oliver.upton%40linux.dev
patch subject: [PATCH 13/15] KVM: arm64: vgic-its: Protect cached vgic_irq pointers with RCU
config: arm64-randconfig-r112-20240128 (https://download.01.org/0day-ci/archive/20240129/202401290835.TjDnhUFI-lkp@intel.com/config)
compiler: clang version 18.0.0git (https://github.com/llvm/llvm-project a31a60074717fc40887cfe132b77eec93bedd307)
reproduce: (https://download.01.org/0day-ci/archive/20240129/202401290835.TjDnhUFI-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202401290835.TjDnhUFI-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/arm64/kvm/vgic/vgic-its.c:705:41: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct vgic_irq *irq @@     got struct vgic_irq [noderef] __rcu *irq @@
   arch/arm64/kvm/vgic/vgic-its.c:705:41: sparse:     expected struct vgic_irq *irq
   arch/arm64/kvm/vgic/vgic-its.c:705:41: sparse:     got struct vgic_irq [noderef] __rcu *irq
   arch/arm64/kvm/vgic/vgic-its.c:727:38: sparse: sparse: incorrect type in argument 2 (different address spaces) @@     expected struct vgic_irq *irq @@     got struct vgic_irq [noderef] __rcu *irq @@
   arch/arm64/kvm/vgic/vgic-its.c:727:38: sparse:     expected struct vgic_irq *irq
   arch/arm64/kvm/vgic/vgic-its.c:727:38: sparse:     got struct vgic_irq [noderef] __rcu *irq
   arch/arm64/kvm/vgic/vgic-its.c:891:17: sparse: sparse: cast to restricted __le64
   arch/arm64/kvm/vgic/vgic-its.c:1031:24: sparse: sparse: cast to restricted __le64
   arch/arm64/kvm/vgic/vgic-its.c:2245:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [assigned] [usertype] val @@     got restricted __le64 [usertype] @@
   arch/arm64/kvm/vgic/vgic-its.c:2245:13: sparse:     expected unsigned long long [assigned] [usertype] val
   arch/arm64/kvm/vgic/vgic-its.c:2245:13: sparse:     got restricted __le64 [usertype]
   arch/arm64/kvm/vgic/vgic-its.c:2271:15: sparse: sparse: cast to restricted __le64
   arch/arm64/kvm/vgic/vgic-its.c:2397:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [assigned] [usertype] val @@     got restricted __le64 [usertype] @@
   arch/arm64/kvm/vgic/vgic-its.c:2397:13: sparse:     expected unsigned long long [assigned] [usertype] val
   arch/arm64/kvm/vgic/vgic-its.c:2397:13: sparse:     got restricted __le64 [usertype]
   arch/arm64/kvm/vgic/vgic-its.c:2424:17: sparse: sparse: cast to restricted __le64
   arch/arm64/kvm/vgic/vgic-its.c:2525:17: sparse: sparse: cast to restricted __le64
   arch/arm64/kvm/vgic/vgic-its.c:2584:13: sparse: sparse: incorrect type in assignment (different base types) @@     expected unsigned long long [assigned] [usertype] val @@     got restricted __le64 [usertype] @@
   arch/arm64/kvm/vgic/vgic-its.c:2584:13: sparse:     expected unsigned long long [assigned] [usertype] val
   arch/arm64/kvm/vgic/vgic-its.c:2584:13: sparse:     got restricted __le64 [usertype]
   arch/arm64/kvm/vgic/vgic-its.c:2605:15: sparse: sparse: cast to restricted __le64
   arch/arm64/kvm/vgic/vgic-its.c:39:24: sparse: sparse: context imbalance in 'vgic_add_lpi' - different lock contexts for basic block
   arch/arm64/kvm/vgic/vgic-its.c:284:12: sparse: sparse: context imbalance in 'update_lpi_config' - different lock contexts for basic block
   arch/arm64/kvm/vgic/vgic-its.c:458:9: sparse: sparse: context imbalance in 'its_sync_lpi_pending_table' - different lock contexts for basic block
   arch/arm64/kvm/vgic/vgic-its.c: note: in included file (through include/linux/random.h, arch/arm64/include/asm/pointer_auth.h, arch/arm64/include/asm/processor.h, ...):
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   arch/arm64/kvm/vgic/vgic-its.c:796:12: sparse: sparse: context imbalance in 'vgic_its_trigger_msi' - different lock contexts for basic block
   arch/arm64/kvm/vgic/vgic-its.c:818:5: sparse: sparse: context imbalance in 'vgic_its_inject_cached_translation' - wrong count at exit
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true
   include/linux/list.h:83:21: sparse: sparse: self-comparison always evaluates to true

vim +705 arch/arm64/kvm/vgic/vgic-its.c

73dcc3dd6274b9 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  637  
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  638  static void vgic_its_cache_translation(struct kvm *kvm, struct vgic_its *its,
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  639  				       u32 devid, u32 eventid,
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  640  				       struct vgic_irq *irq)
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  641  {
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  642  	struct vgic_translation_cache_entry *new, *victim;
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  643  	struct vgic_dist *dist = &kvm->arch.vgic;
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  644  	unsigned long flags;
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  645  	phys_addr_t db;
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  646  
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  647  	/* Do not cache a directly injected interrupt */
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  648  	if (irq->hw)
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  649  		return;
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  650  
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  651  	new = victim = kzalloc(sizeof(*new), GFP_KERNEL_ACCOUNT);
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  652  	if (!new)
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  653  		return;
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  654  
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  655  	raw_spin_lock_irqsave(&dist->lpi_list_lock, flags);
131b61b5cd90e9 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  656  	rcu_read_lock();
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  657  
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  658  	/*
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  659  	 * We could have raced with another CPU caching the same
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  660  	 * translation behind our back, so let's check it is not in
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  661  	 * already
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  662  	 */
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  663  	db = its->vgic_its_base + GITS_TRANSLATER;
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  664  	if (__vgic_its_check_cache(dist, db, devid, eventid))
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  665  		goto out;
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  666  
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  667  	if (dist->lpi_cache_count >= vgic_its_max_cache_size(kvm)) {
73dcc3dd6274b9 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  668  		victim = vgic_its_cache_victim(dist);
73dcc3dd6274b9 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  669  		if (WARN_ON_ONCE(!victim)) {
73dcc3dd6274b9 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  670  			victim = new;
73dcc3dd6274b9 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  671  			goto out;
73dcc3dd6274b9 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  672  		}
73dcc3dd6274b9 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  673  
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  674  		list_del(&victim->entry);
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  675  		dist->lpi_cache_count--;
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  676  	} else {
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  677  		victim = NULL;
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  678  	}
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  679  
7f253bdb6144f3 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  680  	/*
7f253bdb6144f3 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  681  	 * The irq refcount is guaranteed to be nonzero while holding the
7f253bdb6144f3 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  682  	 * its_lock, as the ITE (and the reference it holds) cannot be freed.
7f253bdb6144f3 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  683  	 */
7f253bdb6144f3 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  684  	lockdep_assert_held(&its->its_lock);
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  685  	vgic_get_irq_kref(irq);
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  686  
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  687  	new->db		= db;
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  688  	new->devid	= devid;
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  689  	new->eventid	= eventid;
131b61b5cd90e9 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  690  	rcu_assign_pointer(new->irq, irq);
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  691  
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  692  	/* Move the new translation to the head of the list */
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  693  	list_add(&new->entry, &dist->lpi_translation_cache);
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  694  
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  695  out:
131b61b5cd90e9 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  696  	rcu_read_unlock();
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  697  	raw_spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  698  
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  699  	/*
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  700  	 * Caching the translation implies having an extra reference
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  701  	 * to the interrupt, so drop the potential reference on what
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  702  	 * was in the cache, and increment it on the new interrupt.
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  703  	 */
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  704  	if (victim && victim->irq)
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24 @705  		vgic_put_irq(kvm, victim->irq);
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  706  
8fb2f0e370c963 arch/arm64/kvm/vgic/vgic-its.c Oliver Upton 2024-01-24  707  	kfree(victim);
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  708  }
89489ee9ced892 virt/kvm/arm/vgic/vgic-its.c   Marc Zyngier 2019-03-18  709  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

