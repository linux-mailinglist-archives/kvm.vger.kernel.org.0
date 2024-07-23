Return-Path: <kvm+bounces-22131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D31A93A7F2
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 21:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25D271F23A57
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 19:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0616D14885C;
	Tue, 23 Jul 2024 19:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O4vCf/Yp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9740E14264A;
	Tue, 23 Jul 2024 19:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721764676; cv=none; b=hUSOIdZgddwgBNSVCArdx5bHi+byofjJezEPVNCjZbemLGhVt2aqgKmdgzrRWDYmfh21z7QT3YQLqVfWLOHwfQfgQoJ8qpOBqoeGRiawc391Pa4xFXlPgFJdL9MJwnh2rbiOFzk6Z7McLa/FUs6h4gvL4sr5vcwjC69TWkO/354=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721764676; c=relaxed/simple;
	bh=F7oV1U3Aj4pE+kbk85/bZihDwGPL4aFznra86IAEkRc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YEef5lOjQY9FXugOEuluOGpoXx9MpBgden42RMqO5S3LQSilO9jjzQV69pXCMKlIf6YpMTJtxyV4SlHHn31Ayd6TqwYQTBZtSKBlLvlEZ7OO+lwr3cZIB1dellvsxwxLt4/eIh1vE/dbqxTP6xlY7CgshfTxvnNVcyk1+T4Fve8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O4vCf/Yp; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721764673; x=1753300673;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=F7oV1U3Aj4pE+kbk85/bZihDwGPL4aFznra86IAEkRc=;
  b=O4vCf/YppWqKGW9GYiONKpbI/AzyqnFGQTOBIQZ9NF6734XCGkFHNfn2
   X55rnnlsJiVXzhUDkb0bSiRKCE5Yjg7NQ7yqF0BvrRFzjtuzIUjDY/TCQ
   rXXfuWexb87FQKrEMD1UiRUOnwUnU/mpIhpZ5je9cgu2cYIb3OZoATBqC
   8+O9QXgkiuMZnCvglIj2zk33R6/6OIttz/GYhxiuZ2bsQ9CTbwnP/mjvy
   RYli3NS2Fc05NTVaDavb87nV1f7mzrzHqHGX3YOxInwVIqgrlkvFrvLyT
   02xOc933B2aRSNsL3IohxHN/cdpvfx48Pq3I0bjGelFPCbkanI0hTiTeO
   w==;
X-CSE-ConnectionGUID: FcokTKuOThWRtZXi7uKVuA==
X-CSE-MsgGUID: +P637xSCTI6/Is25I0EW/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11142"; a="19597408"
X-IronPort-AV: E=Sophos;i="6.09,231,1716274800"; 
   d="scan'208";a="19597408"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2024 12:57:53 -0700
X-CSE-ConnectionGUID: BtbfYRwFQ0SaLgP0xDjQUw==
X-CSE-MsgGUID: P6YDV3w2TPi6cmQybAH2pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,231,1716274800"; 
   d="scan'208";a="52065548"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa007.fm.intel.com with ESMTP; 23 Jul 2024 12:57:50 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sWLds-000mJc-1L;
	Tue, 23 Jul 2024 19:57:48 +0000
Date: Wed, 24 Jul 2024 03:57:35 +0800
From: kernel test robot <lkp@intel.com>
To: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Peter Zijlstra <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>
Cc: oe-kbuild-all@lists.linux.dev, WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, virtualization@lists.linux.dev
Subject: Re: [PATCH 2/2] LoongArch: KVM: Add paravirt qspinlock in guest side
Message-ID: <202407240320.qqd1uWiE-lkp@intel.com>
References: <20240723073825.1811600-3-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723073825.1811600-3-maobibo@loongson.cn>

Hi Bibo,

kernel test robot noticed the following build errors:

[auto build test ERROR on 7846b618e0a4c3e08888099d1d4512722b39ca99]

url:    https://github.com/intel-lab-lkp/linux/commits/Bibo-Mao/LoongArch-KVM-Add-paravirt-qspinlock-in-kvm-side/20240723-160536
base:   7846b618e0a4c3e08888099d1d4512722b39ca99
patch link:    https://lore.kernel.org/r/20240723073825.1811600-3-maobibo%40loongson.cn
patch subject: [PATCH 2/2] LoongArch: KVM: Add paravirt qspinlock in guest side
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20240724/202407240320.qqd1uWiE-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240724/202407240320.qqd1uWiE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407240320.qqd1uWiE-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

>> arch/loongarch/kernel/paravirt.c:309: warning: expecting prototype for queued_spin_unlock(). Prototype was for native_queued_spin_unlock() instead
--
   In file included from include/linux/atomic.h:80,
                    from include/asm-generic/bitops/atomic.h:5,
                    from arch/loongarch/include/asm/bitops.h:27,
                    from include/linux/bitops.h:63,
                    from include/linux/kernel.h:23,
                    from include/linux/cpumask.h:11,
                    from include/linux/smp.h:13,
                    from kernel/locking/qspinlock.c:16:
   kernel/locking/qspinlock_paravirt.h: In function 'pv_kick_node':
>> include/linux/atomic/atomic-arch-fallback.h:242:34: error: initialization of 'u8 *' {aka 'unsigned char *'} from incompatible pointer type 'enum vcpu_state *' [-Wincompatible-pointer-types]
     242 |         typeof(*(_ptr)) *___op = (_oldp), ___o = *___op, ___r; \
         |                                  ^
   include/linux/atomic/atomic-instrumented.h:4908:9: note: in expansion of macro 'raw_try_cmpxchg_relaxed'
    4908 |         raw_try_cmpxchg_relaxed(__ai_ptr, __ai_oldp, __VA_ARGS__); \
         |         ^~~~~~~~~~~~~~~~~~~~~~~
   kernel/locking/qspinlock_paravirt.h:377:14: note: in expansion of macro 'try_cmpxchg_relaxed'
     377 |         if (!try_cmpxchg_relaxed(&pn->state, &old, vcpu_hashed))
         |              ^~~~~~~~~~~~~~~~~~~


vim +309 arch/loongarch/kernel/paravirt.c

   303	
   304	/**
   305	 * queued_spin_unlock - release a queued spinlock
   306	 * @lock : Pointer to queued spinlock structure
   307	 */
   308	static void native_queued_spin_unlock(struct qspinlock *lock)
 > 309	{
   310		/*
   311		 * unlock() needs release semantics:
   312		 */
   313		smp_store_release(&lock->locked, 0);
   314	}
   315	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

