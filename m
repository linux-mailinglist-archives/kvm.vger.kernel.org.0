Return-Path: <kvm+bounces-39809-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FBEFA4AF68
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 07:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 156223B2F67
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 06:25:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA6C01CAA87;
	Sun,  2 Mar 2025 06:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eBemv09b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1A113DB9F
	for <kvm@vger.kernel.org>; Sun,  2 Mar 2025 06:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740896728; cv=none; b=o4Iu90FAHo7O1gFe1tmJkgNZ7WcX2JYUIdgFW3BrloLhNK8af7gifC/YawPnq5zV0XoZ8OixN38yX7h9jDd6ducrx8YAwoqvHPa4OxDLshjLwXSL7DtfOaB6RKVJ6EMY2uyeEhRA74iuehJEAUuljxsHEU3D4yyGnAGeA8lArH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740896728; c=relaxed/simple;
	bh=mhhVzqwnYuRELiyOy2GFAyYuwUCmZwpABiv+2apeI7k=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=LGGYGtGskNAmDgSqAB6ZtLCzJ19kGKZHv23BgjbaDni3yKl3pldvwe8wQMxMSoEmLeR89ibi292u9qcI9A3LJ0kVgEqTY+qW7ZPH/b8vPqUPz88KX5171jx++4zvOnZ8W4ErBY6ZBurWV0bkEc1R3gDruj81mEj8BGprePmyzVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eBemv09b; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740896726; x=1772432726;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=mhhVzqwnYuRELiyOy2GFAyYuwUCmZwpABiv+2apeI7k=;
  b=eBemv09b+KRmIbax4Pmy9llNZk1q8Wl5zdSUzAy7AvSLW47SaM0ehUnX
   AoXDYwqK1TUmyAvClVHA9wK7Bv1k3UhJx36pQq9ilVRYQi7QcC59CtGbF
   49R821qTwc864TrYvk1OAHfVa+ARBIMElZpKFgjL543rJDB5vnyuW5xdI
   DE+KavNWuqAawuCVuLtTZWmKieK0X97WsyotihO/E9bPsBI5sY7+AqA8r
   4HI+AxCxrWm2tfJJ0m6NxfK3KCk9JBCCECvh4QEDvsrRxEY4/Z3pB9ECJ
   5mBJnD+qvD7bFRdtP1hhTEk+kx8GZEmyfZ9ZXZXxI+aoD5hrfnhavoRCG
   A==;
X-CSE-ConnectionGUID: B4z39eFNRT2JIOzRfkEGmQ==
X-CSE-MsgGUID: Pd8Hkr3SQVS5rfUFQqO9PQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11360"; a="59330182"
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="59330182"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2025 22:25:26 -0800
X-CSE-ConnectionGUID: F2Ipzb8iS3yqwzTn2OdeSw==
X-CSE-MsgGUID: b5LMBuvORbm/4blfCsz/rQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="117489578"
Received: from lkp-server02.sh.intel.com (HELO 76cde6cc1f07) ([10.239.97.151])
  by fmviesa006.fm.intel.com with ESMTP; 01 Mar 2025 22:25:24 -0800
Received: from kbuild by 76cde6cc1f07 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1toclN-000H7s-2I;
	Sun, 02 Mar 2025 06:25:21 +0000
Date: Sun, 2 Mar 2025 14:24:57 +0800
From: kernel test robot <lkp@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	kvm@vger.kernel.org, Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [kvm:kvm-coco-queue 20/127] ERROR: modpost: "enable_tdx"
 [arch/x86/kvm/kvm-intel.ko] undefined!
Message-ID: <202503021436.STomlZOE-lkp@intel.com>
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
commit: a58e01fec9ad144302cd8dfc0b6524315cdb2883 [20/127] KVM: TDX: Add placeholders for TDX VM/vCPU structures
config: x86_64-randconfig-077-20250302 (https://download.01.org/0day-ci/archive/20250302/202503021436.STomlZOE-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250302/202503021436.STomlZOE-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503021436.STomlZOE-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "enable_tdx" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_cleanup" [arch/x86/kvm/kvm-intel.ko] undefined!
ERROR: modpost: "tdx_bringup" [arch/x86/kvm/kvm-intel.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

