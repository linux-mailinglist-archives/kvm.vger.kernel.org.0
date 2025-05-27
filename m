Return-Path: <kvm+bounces-47767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85740AC4A53
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 10:30:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27AFC3ADD4F
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 08:29:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD3BC24A041;
	Tue, 27 May 2025 08:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OG//zieZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F721F4624;
	Tue, 27 May 2025 08:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748334592; cv=none; b=DHMbu7pMdHChIjx2CYgdnsvKqc3zUVsuBKpCG5XGePCdiVJ2BZ7ar0mH0BbGlPymStaxH/9/XBk9BGnb+YZKxV6BowI9rP9UA8hPHRKWTg+zCZPwJNoz/lCNeDdIrlUmoceWDsbiOtbTbC7k0YXpZpDJ/ZwfvT7LPJj/1Mq8Vfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748334592; c=relaxed/simple;
	bh=ugfZN0SUpmbp6D7qxaTk6vM0bypkNanL8Fpsm3ejQ18=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fIQhsms2QyPZZMwd5LmvQuKG5545Pod/FwwwCVCj8WUpHpwqLY/ph5VSK1eOE9q+NIPEM09x1bpTOI9keU312zYg662x0TCKiUqXVTi7Wb4UiolNiL9M86iVivP703MTsw8RAcntz5bLJuw6AHs0N6G4kVfgxTjscSEt55yoWSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OG//zieZ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748334590; x=1779870590;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ugfZN0SUpmbp6D7qxaTk6vM0bypkNanL8Fpsm3ejQ18=;
  b=OG//zieZ6tp/5O1PNX0ZazXEc8KGst2An/rXY7TFWJxpZnXYrqyRyAOS
   /TAln+VYfnv6hW8BNbXB4hxUkXeowGggpSurQPf0pP/Tdb7JiFgkvQjAJ
   4YVOmbuBJlTaqyPAA6AV3p3eaqEATJNixtCeUs8iEX4De+MtDfpYjR4qA
   S7y+OqYoK2g7cUu6cB2nT6VlS7DBMh3FWAjgDINDLydS+Xz0859lu4FzR
   nrtWOaNg1i51NbH9cpc4cjnGxUL93djArAtsc8j17Xfjm7KaePFTZ8NOo
   OvjkWGI+gG+OTSvB8ZYHcJp7zIvsot6kCrngCmwpndH+6eI+101OP5X6p
   g==;
X-CSE-ConnectionGUID: ysf37yyXT5q1d/AUeIDKcQ==
X-CSE-MsgGUID: 5SwJtpN1QVOZMSDE2mXeBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11445"; a="52935082"
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="52935082"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 01:29:49 -0700
X-CSE-ConnectionGUID: oPfIhA4FS9m4ysw+PPKwHg==
X-CSE-MsgGUID: LXlv4f9IRn2EKZPP2Ec8Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,317,1739865600"; 
   d="scan'208";a="165908940"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 27 May 2025 01:29:47 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uJpgu-000T24-1X;
	Tue, 27 May 2025 08:29:44 +0000
Date: Tue, 27 May 2025 16:28:55 +0800
From: kernel test robot <lkp@intel.com>
To: Edward Adam Davis <eadavis@qq.com>, seanjc@google.com
Cc: oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	binbin.wu@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next] KVM: VMX: add noinstr for is_td_vcpu and is_td
Message-ID: <202505271443.0QM8TjLH-lkp@intel.com>
References: <tencent_27A451976AF76E66DF1379C3604976A3A505@qq.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_27A451976AF76E66DF1379C3604976A3A505@qq.com>

Hi Edward,

kernel test robot noticed the following build warnings:

[auto build test WARNING on next-20250526]

url:    https://github.com/intel-lab-lkp/linux/commits/Edward-Adam-Davis/KVM-VMX-add-noinstr-for-is_td_vcpu-and-is_td/20250527-114712
base:   next-20250526
patch link:    https://lore.kernel.org/r/tencent_27A451976AF76E66DF1379C3604976A3A505%40qq.com
patch subject: [PATCH next] KVM: VMX: add noinstr for is_td_vcpu and is_td
config: x86_64-buildonly-randconfig-001-20250527 (https://download.01.org/0day-ci/archive/20250527/202505271443.0QM8TjLH-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250527/202505271443.0QM8TjLH-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505271443.0QM8TjLH-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/x86/kvm/vmx/vmx.h:20,
                    from arch/x86/kvm/vmx/hyperv.h:7,
                    from arch/x86/kvm/vmx/nested.c:13:
>> arch/x86/kvm/vmx/common.h:74:21: warning: 'is_td' defined but not used [-Wunused-function]
      74 | static noinstr bool is_td(struct kvm *kvm) { return false; }
         |                     ^~~~~


vim +/is_td +74 arch/x86/kvm/vmx/common.h

    73	
  > 74	static noinstr bool is_td(struct kvm *kvm) { return false; }
    75	static noinstr bool is_td_vcpu(struct kvm_vcpu *vcpu) { return false; }
    76	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

