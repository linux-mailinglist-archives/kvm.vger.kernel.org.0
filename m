Return-Path: <kvm+bounces-29316-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 929FC9A93B0
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 01:05:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B79F01C21651
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 23:05:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4275520012C;
	Mon, 21 Oct 2024 23:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hCkqY/ox"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B530B1FF056;
	Mon, 21 Oct 2024 23:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729551840; cv=none; b=NxGMMim6TyGefCetv71EQFoTceHLjZYfYXHxAPtvB5DiaMMh1GyajC/0mBAT3ZojoIJW1vwBoy+0ATjr/PV6ZP1i+qEpqO2LERkmVUCSHuBr4glG3nP5vuGl+bpRg7Pp6Drp7o9n9R1UgePdKZWmbZ9EhqdmRV+1Y7c2ww3rm6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729551840; c=relaxed/simple;
	bh=xEoJneP1gRLSYSS8hkJXB6bpUcGSpxe3av0Sx+H3ICU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dn6xQ/xigIwfNtRji7n4jhgzLw7Tj0mrlnIA4YR69NRR7RePiYfoyAvq2uVY9o7H+vIWNC79iY2l+jiIzF8wRHFgoPIdXxRxFm9t8oCCIVPnMOxFQmoanj98+4STHpaR14HvtIECbjLSpbWRwnFjm8PT6Oz1BJ1t1p9hxWKbU68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hCkqY/ox; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729551839; x=1761087839;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xEoJneP1gRLSYSS8hkJXB6bpUcGSpxe3av0Sx+H3ICU=;
  b=hCkqY/oxlrjPzbGLXW3+yi2/V/e8avlMqsORAw49Fy9LuioOjXPy9cwW
   nfVS051Ovrqm2Ra3PRZGJcSJyRZHf3aVf5WnWvl0ALWJRM5k8WB7mXm/i
   VMmFJW4XkB0j4+7PLm8QJb6BzpDt/ssIkdX7vRx16TWAT7HVwbw3517/6
   1O65Nn+K2/06FyuIohWblvp7+X1WYNjplnChHG9c9zkUrjMc7WMd3HZ9Q
   9Jd6fV+obdJTrxNTHaSZnAhgxg7HI+diYxMFT1RP2JkK9twCUEmWjP8Nq
   umdmk4cBCMrr6siodYE0Z4mOaxI8k9Tm/tVC/bJE/K+1VbI3OEui+pdtj
   w==;
X-CSE-ConnectionGUID: F91IqDO4Rem2CEQwWMuCTQ==
X-CSE-MsgGUID: EpdZybyXQsmxmP9cR4MavA==
X-IronPort-AV: E=McAfee;i="6700,10204,11232"; a="29159857"
X-IronPort-AV: E=Sophos;i="6.11,221,1725346800"; 
   d="scan'208";a="29159857"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2024 16:03:59 -0700
X-CSE-ConnectionGUID: VaJe7yjxSHuG6IT+9eYllw==
X-CSE-MsgGUID: DqOO+PwmQS+XChE9W0gfXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,221,1725346800"; 
   d="scan'208";a="110432442"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by fmviesa001.fm.intel.com with ESMTP; 21 Oct 2024 16:03:54 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t31RI-000SiV-1u;
	Mon, 21 Oct 2024 23:03:52 +0000
Date: Tue, 22 Oct 2024 07:03:18 +0800
From: kernel test robot <lkp@intel.com>
To: Nikunj A Dadhania <nikunj@amd.com>, linux-kernel@vger.kernel.org,
	thomas.lendacky@amd.com, bp@alien8.de, x86@kernel.org,
	kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, mingo@redhat.com, tglx@linutronix.de,
	dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
	pbonzini@redhat.com, nikunj@amd.com,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Juergen Gross <jgross@suse.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH v13 11/13] tsc: Switch to native sched clock
Message-ID: <202410220640.W8Ynjt5W-lkp@intel.com>
References: <20241021055156.2342564-12-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241021055156.2342564-12-nikunj@amd.com>

Hi Nikunj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 0a895c0d9b73d934de95aa0dd4e631c394bdd25d]

url:    https://github.com/intel-lab-lkp/linux/commits/Nikunj-A-Dadhania/x86-sev-Carve-out-and-export-SNP-guest-messaging-init-routines/20241021-140125
base:   0a895c0d9b73d934de95aa0dd4e631c394bdd25d
patch link:    https://lore.kernel.org/r/20241021055156.2342564-12-nikunj%40amd.com
patch subject: [PATCH v13 11/13] tsc: Switch to native sched clock
config: i386-buildonly-randconfig-002-20241022 (https://download.01.org/0day-ci/archive/20241022/202410220640.W8Ynjt5W-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241022/202410220640.W8Ynjt5W-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410220640.W8Ynjt5W-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kernel/tsc.c:293:6: warning: no previous prototype for 'enable_native_sched_clock' [-Wmissing-prototypes]
     293 | void enable_native_sched_clock(void) { }
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~


vim +/enable_native_sched_clock +293 arch/x86/kernel/tsc.c

   292	
 > 293	void enable_native_sched_clock(void) { }
   294	#endif
   295	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

