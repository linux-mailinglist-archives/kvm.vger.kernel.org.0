Return-Path: <kvm+bounces-16336-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CFD88B896F
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 13:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ED031F23526
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 11:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67BB383A15;
	Wed,  1 May 2024 11:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fNNzMM9a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7227E777;
	Wed,  1 May 2024 11:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714564159; cv=none; b=cFRmwqE0LtYsDIEMeEEyfky+zS6vJjQV9Ve/pBo+fuYXhXneTsQqtIlzk2saYouQcpHcTb1aNjBiUvnuXI0hZcklhzHzddAazJTi9GMeXaNGtc/SLENSGn0V3jwfU4mHJOPoBFZHxCVkM0CG67Z/vg/JKJr0O4xvhqMUeONkKLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714564159; c=relaxed/simple;
	bh=R16gAg1aOi2c1wz86lmY8hgLoTujdYnbg4klhq5jr7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bEgoMVztIoQah/x3gBVDNl/pZm+6cr0j8pAaXdFFlU+yGz9qyTs2WClpv722AbaPp1lVKrtgHoIx0VfdDGoKyCto7YgpZzmqG46irSFW6Y7TQYaGi8TSqK/ELtg6xFzpUDGCsmflBAKo/S7nizHFyDt83fz9Y4viiPnrtchZjPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fNNzMM9a; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714564157; x=1746100157;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=R16gAg1aOi2c1wz86lmY8hgLoTujdYnbg4klhq5jr7g=;
  b=fNNzMM9aPdyolgs95pZs17smIpWzT/d9C24B4QT2uFN/hzCHK2TwNtKX
   rlglb6WhkyE5UvQviXMrhWGpVL5tsXQm4zfsQNW5gBwBT5GAj6V4cobNt
   4RNis1LT8RqiXjn1k16CS0a3Z+u6v5tmHVcRiHCZvboteJK4Njksbm70k
   IjhnRHFIkpQTGeSPPSYsCyco5v/+IVsCsLhZQ4CajQ5AhOAK2ZFbBPzl+
   2kmcUXv6PGCIH1px8z2fJGdKDQrdA2oB8H3BtJsCAAWobXSAYHgY6zQ44
   0lo47YSXFFL1QNGwaoZ03GM0756/ZHy5m17EYPgpvGQqKFe+fQSA1ZOff
   Q==;
X-CSE-ConnectionGUID: 2lJEN8kATzmkSeG88GJ1mA==
X-CSE-MsgGUID: Y/8Yy4kyQmmNhOESIHdK5A==
X-IronPort-AV: E=McAfee;i="6600,9927,11060"; a="21706772"
X-IronPort-AV: E=Sophos;i="6.07,245,1708416000"; 
   d="scan'208";a="21706772"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 04:49:17 -0700
X-CSE-ConnectionGUID: rAjYdQUfRGi+L3T6pE9xJw==
X-CSE-MsgGUID: cn2Ej6jAT0utR/u6PAydXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,245,1708416000"; 
   d="scan'208";a="31478703"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 01 May 2024 04:49:11 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s28SS-0009UP-2t;
	Wed, 01 May 2024 11:49:08 +0000
Date: Wed, 1 May 2024 19:48:25 +0800
From: kernel test robot <lkp@intel.com>
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
	rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
	arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
	harisokn@amazon.com, joao.m.martins@oracle.com,
	boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
	ankur.a.arora@oracle.com
Subject: Re: [PATCH 4/9] cpuidle-haltpoll: define arch_haltpoll_supported()
Message-ID: <202405011942.NBEU9bJO-lkp@intel.com>
References: <20240430183730.561960-5-ankur.a.arora@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240430183730.561960-5-ankur.a.arora@oracle.com>

Hi Ankur,

kernel test robot noticed the following build errors:

[auto build test ERROR on rafael-pm/linux-next]
[also build test ERROR on rafael-pm/bleeding-edge tip/x86/core arm64/for-next/core linus/master v6.9-rc6 next-20240430]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ankur-Arora/cpuidle-rename-ARCH_HAS_CPU_RELAX-to-ARCH_HAS_OPTIMIZED_POLL/20240501-024252
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
patch link:    https://lore.kernel.org/r/20240430183730.561960-5-ankur.a.arora%40oracle.com
patch subject: [PATCH 4/9] cpuidle-haltpoll: define arch_haltpoll_supported()
config: i386-buildonly-randconfig-001-20240501 (https://download.01.org/0day-ci/archive/20240501/202405011942.NBEU9bJO-lkp@intel.com/config)
compiler: clang version 18.1.4 (https://github.com/llvm/llvm-project e6c3289804a67ea0bb6a86fadbe454dd93b8d855)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240501/202405011942.NBEU9bJO-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202405011942.NBEU9bJO-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: arch_haltpoll_enable
   >>> referenced by cpuidle-haltpoll.c
   >>>               drivers/cpuidle/cpuidle-haltpoll.o:(haltpoll_cpu_online) in archive vmlinux.a
--
>> ld.lld: error: undefined symbol: arch_haltpoll_disable
   >>> referenced by cpuidle-haltpoll.c
   >>>               drivers/cpuidle/cpuidle-haltpoll.o:(haltpoll_cpu_offline) in archive vmlinux.a
--
>> ld.lld: error: undefined symbol: arch_haltpoll_supported
   >>> referenced by cpuidle-haltpoll.c
   >>>               drivers/cpuidle/cpuidle-haltpoll.o:(haltpoll_init) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

