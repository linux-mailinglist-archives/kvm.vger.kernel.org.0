Return-Path: <kvm+bounces-39813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0801FA4B187
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 13:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F1B03A4432
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 12:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2E8BAD24;
	Sun,  2 Mar 2025 12:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SdJ395FA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0391E32B7
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 12:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740918139; cv=none; b=Bq+W4zMk1FtMuPaWCcxxoHfEmqMP2pysI1GCo4ZklCjB6PyuMh+0mJGaYEihOiUr/+Gw5UghWpRfP4y5fF+3KESLqbF6AXkeJpNs0EcPm0rPBYsLlV2EonZWUq+mqlujYmCjoo82qwJ/CPxJAn51Ye1e0vsrJsJ9+3r+MRcs4vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740918139; c=relaxed/simple;
	bh=mm5g5Qi3GNbN0ogRtaaW+NlB1O0QzamvPu9LuH/JH/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=lceiyoD/ijvsLINWank9XqHwLCWVk/xYTaB2k+rq+MDQV7iRo6sqOrpPZI0bFqhY7d8hyi46DPEkNl/nHOer25WJlZmC1+6h+fvzKa1f8vWykFQqpV/YeZIcZ3G+I7/aylCLW4Q29Yku/o9USA6wwlR1V6bdTifjnoG7j7lfnMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SdJ395FA; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740918137; x=1772454137;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=mm5g5Qi3GNbN0ogRtaaW+NlB1O0QzamvPu9LuH/JH/Y=;
  b=SdJ395FA1Y4bs0lN26JzLg5lbUZ6dmVJ7LWeNOf64XVQdI9iPYiAF7hP
   yU2ne/nMD/E9iT2izTkzLlRaaYxQdr12FXcnGGQKkEUdAOeVzMfQdSFH3
   JcDGqyHCt29uFlzeIpFqYevBILtoTyDGzl9TmhmZXHMcArCoDH1LUJkqo
   aEQpGuJ29/6+FKSxb9DI/Ik4FO02ItCLJd5BquGF9lx6Z62/uD/awAKD6
   /d7JdikRRQ+F0fvnnXn2oNS6338f/pSklarIsTvwvD6OcXGEFK9Mva4oe
   TWFjimszU+gKSU8VDjTnNmA9zOFcyzHs4/Fz7OR7rpNk2O2NsF3s65mod
   w==;
X-CSE-ConnectionGUID: Tnla3IhySPqhjWOMiuN0uw==
X-CSE-MsgGUID: xrpKyJUiS2e94r7mBTWxJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11360"; a="41715580"
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="41715580"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 04:22:16 -0800
X-CSE-ConnectionGUID: lQnVAaAFQ8aukS+ZYEWmnw==
X-CSE-MsgGUID: d3FRLjHATU+1Tzu+r/AGdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="122718317"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by orviesa003.jf.intel.com with ESMTP; 02 Mar 2025 04:22:13 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1toiKO-000HJk-2c;
	Sun, 02 Mar 2025 12:21:59 +0000
Date: Sun, 2 Mar 2025 20:20:55 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tony Lindgren <tony.lindgren@linux.intel.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Kai Huang <kai.huang@intel.com>, Yan Zhao <yan.y.zhao@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [kvm:kvm-coco-queue 26/127] ERROR: modpost: "tdx_vm_init"
 [arch/x86/kvm/kvm-intel.ko] undefined!
Message-ID: <202503022020.onowlHpb-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue
head:   9fe4541afcfad987d39790f0a40527af190bf0dd
commit: 7c8278105bcfa9b1b68ef64f7142d28e3c0bd965 [26/127] KVM: TDX: create/destroy VM structure
config: x86_64-randconfig-077-20250302 (https://download.01.org/0day-ci/archive/20250302/202503022020.onowlHpb-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250302/202503022020.onowlHpb-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503022020.onowlHpb-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "tdx_vm_init" [arch/x86/kvm/kvm-intel.ko] undefined!
>> ERROR: modpost: "tdx_vm_destroy" [arch/x86/kvm/kvm-intel.ko] undefined!
>> ERROR: modpost: "tdx_mmu_release_hkid" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_vm_ioctl" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "enable_tdx" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_cleanup" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_bringup" [arch/x86/kvm/kvm-intel.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

