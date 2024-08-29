Return-Path: <kvm+bounces-25380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3063964A9C
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 17:51:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DDCA1F23EE3
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:51:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21C2F1B3F08;
	Thu, 29 Aug 2024 15:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="brZmY7at"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBC61B4C33;
	Thu, 29 Aug 2024 15:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724946633; cv=none; b=D+vynjjiUvZANCfIq0Lc/CoJRBtl5TlUH6mD6tPJE3dsjGzDFxb8T9T+SGOPY3BlJkLsqyZxAhOD0zH7fWGdODBt9h6jt/kxrGPLEiKcL7rTywRINvN1PJi54JsUPI4+rPubnKO3l0T0B0LeCf1sv0T0RCxy+l78XFZjsJGhlT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724946633; c=relaxed/simple;
	bh=MXbs9o4JsCqnOHzV2NkYU9Q0uIU+cS5hql1pqmeZMs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SZOzaLKLXzJdTrzurCUFFzncqs95T2rlr+qNOsYKVyNw6RIvlrhVpol8Q+1r1TEO4ZT3OopcEadIi3VI888jsXWStsn1Jq6kp1IrSIQuKn9H9ZUGtHNMO2oRjmuWKwsFMZkFhmgj3qOpIExCHBLqkcoVU47cg56M0LTMPA96L5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=brZmY7at; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724946631; x=1756482631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MXbs9o4JsCqnOHzV2NkYU9Q0uIU+cS5hql1pqmeZMs8=;
  b=brZmY7atZgVb8/qr2bhXSYU56jxl4n5zmEA8lVuq9JqMnoOeZ+fvo7t5
   1cJV8YdvZEIMzkQfrvaJJIhUdp4kALNbxK0/lcoA/enxJu6EXPkOxALHG
   vznckwlGgkNtwzE0QREN3tQTMxnU4E0a7lZC9xasYYuoqL/Kg6ZaWgChY
   tkV1wMOkktK4iJIYgwLPZxIxCwXjTAP85FbaG8am7mZNtrEWTcrek21g/
   QBfK1RqXPl6bTJiM+P7LWUqgLyXNaaPYoBi2a2Qb8H/GvNJI1UPXhwExw
   IIkGVqcHIvlc1uBd/i2b9qBMwkwjGdSu99Bt6F+Oq44b/lwZOVZtMaknA
   g==;
X-CSE-ConnectionGUID: VBd90OYZSI6shcF5Z84plg==
X-CSE-MsgGUID: uyTEHOaDQCKos63gTjz7RA==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23505190"
X-IronPort-AV: E=Sophos;i="6.10,186,1719903600"; 
   d="scan'208";a="23505190"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 08:50:30 -0700
X-CSE-ConnectionGUID: J83LXIxzSzmT98GJ4pj8/A==
X-CSE-MsgGUID: Z+lyrEAUTdejag2LclzVgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,186,1719903600"; 
   d="scan'208";a="63943997"
Received: from lkp-server01.sh.intel.com (HELO 9c6b1c7d3b50) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 29 Aug 2024 08:50:27 -0700
Received: from kbuild by 9c6b1c7d3b50 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sjhPl-0000Py-0J;
	Thu, 29 Aug 2024 15:50:25 +0000
Date: Thu, 29 Aug 2024 23:50:06 +0800
From: kernel test robot <lkp@intel.com>
To: Vegard Nossum <vegard.nossum@oracle.com>,
	Masahiro Yamada <masahiroy@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-omap@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-um@lists.infradead.org,
	bpf@vger.kernel.org, llvm@lists.linux.dev,
	Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: [PATCH] kbuild: use objcopy to generate asm-offsets
Message-ID: <202408292301.KMuvybe3-lkp@intel.com>
References: <20240828083605.3093701-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240828083605.3093701-1-vegard.nossum@oracle.com>

Hi Vegard,

kernel test robot noticed the following build errors:

[auto build test ERROR on masahiroy-kbuild/for-next]
[also build test ERROR on masahiroy-kbuild/fixes soc/for-next kvmarm/next kvm/queue uml/next krzk-mem-ctrl/for-next bpf-next/master bpf/master linus/master v6.11-rc5 next-20240829]
[cannot apply to tmlind-omap/for-next kvm/linux-next uml/fixes]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Vegard-Nossum/kbuild-use-objcopy-to-generate-asm-offsets/20240828-163854
base:   https://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild.git for-next
patch link:    https://lore.kernel.org/r/20240828083605.3093701-1-vegard.nossum%40oracle.com
patch subject: [PATCH] kbuild: use objcopy to generate asm-offsets
config: arc-allnoconfig (https://download.01.org/0day-ci/archive/20240829/202408292301.KMuvybe3-lkp@intel.com/config)
compiler: arc-elf-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240829/202408292301.KMuvybe3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408292301.KMuvybe3-lkp@intel.com/

All errors (new ones prefixed by >>):

   {standard input}: Assembler messages:
>> {standard input}: Error: .size expression for main does not evaluate to a constant
   make[3]: *** [scripts/Makefile.build:244: scripts/mod/devicetable-offsets.o] Error 1
   make[3]: Target 'scripts/mod/' not remade because of errors.
   make[2]: *** [Makefile:1192: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:224: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:224: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

