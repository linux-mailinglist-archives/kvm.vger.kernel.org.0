Return-Path: <kvm+bounces-62038-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B543C33BAD
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 03:04:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49A9946560E
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 02:04:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7851D22DF9E;
	Wed,  5 Nov 2025 02:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RO+y0NPz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BEB28DC4
	for <kvm@vger.kernel.org>; Wed,  5 Nov 2025 02:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762308265; cv=none; b=HIf2fKj7fb3kGUp+BeRb02MZj6xTAU2lhLiVrahT34vkhU4NmafFahkPYy9XVUvN3JKyHwDUtpopaK/VUuot97Yf/bhzXdp6EVndf0e8vcoW7gsQLJ/NjUosSI9tAOQe8LzJKoTR+G7YYYJz5Mz6Ck3wgbv1qk2JOahrH9q2Xbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762308265; c=relaxed/simple;
	bh=79KjyqTVlFvWryaG61zBG7OjWd5+U+JNcu4D3sQkAb0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TXmxrkx5Gsa98PpiScl0q92rS1wrPvj7YBT9OJrBSeQJWAxlOh0hLAM2KFbo8/8+XcPk3k5RwzOIkpjCQ9QUEwyrr43qNKvoSKZzguYzKMxkK8OU8tNveaya0RvjJUAwpLkRrRcnsbLK488E5fPpRLH1/yIOh522CF/wwqDVQ/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RO+y0NPz; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762308264; x=1793844264;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=79KjyqTVlFvWryaG61zBG7OjWd5+U+JNcu4D3sQkAb0=;
  b=RO+y0NPz5lgp8rbkUmxhYEkdGnjwyNPE3hf2vHPp2Wx6eopJZalyzaVd
   fpYgO9dfoCclKZlsJswycowc5dJZBQxa1lBWHhhda1rU/uVRKzvNsjK4n
   zFYnLAlDu5fYV8OnCk7xxSwWBEwEMMha/AT9+2gvo6a1qOlyvoCiLiq91
   AX9lfKoD0mvDKpLffqW+WgqU1+hiYd8o6lH9XbCq7WSsuDnJI8A4jaIws
   S6hfDzHFzPQP15q9WzF7W3orAmSzHdRATHbxMTCx6BUK+2pAA/zUJvw/6
   2UREdbYCEH+4/qVxn+7R93FMrbYZtuXfgDC6V0wbdIm4P573WpQI7cjnx
   Q==;
X-CSE-ConnectionGUID: p1pnaL2KT7GZKnZQUW4Pbw==
X-CSE-MsgGUID: ekYjQH7QQhm06VxN/3FOnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64322283"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64322283"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 18:04:24 -0800
X-CSE-ConnectionGUID: xSkiRYsLS6CKL8wvq7w4dA==
X-CSE-MsgGUID: Ssuz/sw4TJeIZFPhVyS4Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,280,1754982000"; 
   d="scan'208";a="186569005"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by orviesa006.jf.intel.com with ESMTP; 04 Nov 2025 18:04:07 -0800
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1vGSrB-000S2R-12;
	Wed, 05 Nov 2025 02:03:04 +0000
Date: Wed, 5 Nov 2025 10:01:36 +0800
From: kernel test robot <lkp@intel.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Volodymyr Babchuk <Volodymyr_Babchuk@epam.com>
Subject: Re: [PATCH 05/33] KVM: arm64: GICv3: Detect and work around the lack
 of ICV_DIR_EL1 trapping
Message-ID: <202511050925.kQxVnIUB-lkp@intel.com>
References: <20251103165517.2960148-6-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103165517.2960148-6-maz@kernel.org>

Hi Marc,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvmarm/next]
[also build test ERROR on linus/master v6.18-rc4 next-20251104]
[cannot apply to arm64/for-next/core tip/irq/core]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Marc-Zyngier/irqchip-gic-Add-missing-GICH_HCR-control-bits/20251104-011133
base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
patch link:    https://lore.kernel.org/r/20251103165517.2960148-6-maz%40kernel.org
patch subject: [PATCH 05/33] KVM: arm64: GICv3: Detect and work around the lack of ICV_DIR_EL1 trapping
config: arm64-randconfig-003-20251105 (https://download.01.org/0day-ci/archive/20251105/202511050925.kQxVnIUB-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 8.5.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251105/202511050925.kQxVnIUB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202511050925.kQxVnIUB-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/arm64/kernel/hyp-stub.S: Assembler messages:
>> arch/arm64/kernel/hyp-stub.S:59: Error: unknown or missing system register name at operand 2 -- `mrs x1,ich_vtr_el2'


vim +59 arch/arm64/kernel/hyp-stub.S

    45	
    46		.align 11
    47	
    48	SYM_CODE_START_LOCAL(elx_sync)
    49		cmp	x0, #HVC_SET_VECTORS
    50		b.ne	1f
    51		msr	vbar_el2, x1
    52		b	9f
    53	
    54	1:	cmp	x0, #HVC_FINALISE_EL2
    55		b.eq	__finalise_el2
    56	
    57		cmp	x0, #HVC_GET_ICH_VTR_EL2
    58		b.ne	2f
  > 59		mrs	x1, ich_vtr_el2
    60		b	9f
    61	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

