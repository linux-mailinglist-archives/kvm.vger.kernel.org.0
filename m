Return-Path: <kvm+bounces-20035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FA8490FB84
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 05:06:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CDCB281BD2
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2024 03:06:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294DB1E535;
	Thu, 20 Jun 2024 03:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CnPtMkdy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE1F1BF3F;
	Thu, 20 Jun 2024 03:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718852774; cv=none; b=DPqdyixboGmjpKa68Gz8rSsDpnNl914kbDVwZb2C/OOSUwPaTLVpTegTC4GDl2XlMx4OFACY9xvXK7oWIYPvFkKWLXNhBlEc41Zg8aplwqcAXzGcDlE+hqbAgsmnyRhD6RZdoWAvyk3wJerofn5RvkRqxj7EUVwsLvVRV82DdCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718852774; c=relaxed/simple;
	bh=+TiDdWFghcssxRQ+mZJFAXhs8tsVnC7tqfb+Nels7K8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pa0ydPP5Aw+NsmDrotuzOfha57qEEUJ8FUe9wzlHgnOauaCaWiyJiJRONRH+AcYcEBzeAwKJWvRO8y7D0vUkRXmjDezp3sfbTNGCupfpovp7wo4g00j5hF2pysk9/4eN0iFp6INBa7+y5s4biNii/oSzDjf9zgNL+ky0QyGlQ+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CnPtMkdy; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718852773; x=1750388773;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+TiDdWFghcssxRQ+mZJFAXhs8tsVnC7tqfb+Nels7K8=;
  b=CnPtMkdyDFoSJz97+bCpHUsPwsWUxN097DLM4ErGHj81WCoy2GpoO65b
   3lvtrmT578hm5FwH6AJUojlU0DwoYylle0TguphXR2WoCvT1dGLvmHwHE
   TzJcgfkK72ngOv6JE86QeQkvuiM97WzkDz7Tz9b1oa7iWK2zuh86u6QYW
   QySd2Sn2kvyHRn+TmVm5KX7Qrv+19/8NB1vA/xShtLUPs5oq6+gq2qumr
   2jy2CvwQPvZ6ZSiySGAJo1IltUnf7ahnLm8q3TxagDzZ9uJr07BgUBHnx
   8VUOPc8FMXypX0nL6+1rcwnQ3+AyFJr66FJFfnMIR2usmTrz6/NzSzPoI
   A==;
X-CSE-ConnectionGUID: Hz56s0RCTGCYtid6+jNF0Q==
X-CSE-MsgGUID: c7ePYqmeRgay5cGCRVBdow==
X-IronPort-AV: E=McAfee;i="6700,10204,11108"; a="12155897"
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="12155897"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2024 20:06:13 -0700
X-CSE-ConnectionGUID: GaaSKUuFRtK56OgAejTiBQ==
X-CSE-MsgGUID: WyYZ1FFCQl6C6hrukb6ryA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,251,1712646000"; 
   d="scan'208";a="42201605"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 19 Jun 2024 20:06:10 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sK87k-0007Fx-11;
	Thu, 20 Jun 2024 03:06:08 +0000
Date: Thu, 20 Jun 2024 11:05:19 +0800
From: kernel test robot <lkp@intel.com>
To: Bibo Mao <maobibo@loongson.cn>, Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@kernel.org>
Cc: oe-kbuild-all@lists.linux.dev, WANG Xuerui <kernel@xen0n.name>,
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
	loongarch@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] LoongArch: KVM: Mark page accessed and dirty with
 page ref added
Message-ID: <202406201000.BjivosoH-lkp@intel.com>
References: <20240619080940.2690756-7-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240619080940.2690756-7-maobibo@loongson.cn>

Hi Bibo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 92e5605a199efbaee59fb19e15d6cc2103a04ec2]

url:    https://github.com/intel-lab-lkp/linux/commits/Bibo-Mao/LoongArch-KVM-Delay-secondary-mmu-tlb-flush-until-guest-entry/20240619-161831
base:   92e5605a199efbaee59fb19e15d6cc2103a04ec2
patch link:    https://lore.kernel.org/r/20240619080940.2690756-7-maobibo%40loongson.cn
patch subject: [PATCH v2 6/6] LoongArch: KVM: Mark page accessed and dirty with page ref added
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20240620/202406201000.BjivosoH-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240620/202406201000.BjivosoH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406201000.BjivosoH-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/loongarch/kvm/mmu.o: warning: objtool: __jump_table+0x0: special: can't find orig instruction


objdump-func vmlinux.o __jump_table:

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

