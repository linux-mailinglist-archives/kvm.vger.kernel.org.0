Return-Path: <kvm+bounces-16131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D64E58B4CBC
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 18:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2F9BEB21233
	for <lists+kvm@lfdr.de>; Sun, 28 Apr 2024 16:38:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A858971B40;
	Sun, 28 Apr 2024 16:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SNQp9fCz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F8A433DA;
	Sun, 28 Apr 2024 16:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714322322; cv=none; b=aUCoUFcwsIUdcOBTNLTIyo+aj7dw5MCUwmWBN1phG0jseBM2UZ2duqzLJmcWV9iBZsX1jFDY3mx8HHcPzeGJ5rXkXJdwq6X6nTlzPrVum9sVvBBl0NICLXJlbc/n2Bfkog3Ttiy/vdvySngb25H35kHBKJOxypSyW8AepabZH7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714322322; c=relaxed/simple;
	bh=WSj7lu2b4X/UglnfYC8ObjrLUSF53g3nGeBhb8ymiJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=proUnxhE+9Y6Wghe5VIpSYcwrlwoEfcv3zbfLbBhZTEeh1ZZL0fTT0WhrNhyQDAc9ODQ4vyBcu99qvjuXuzSWV2T7cBgYl6Jo1IMbO3Aj34SCnjx/Ya0BVawShPLcoU6B+VvbvKWWvS1FLWJypRa4dcZCCfNaoZOI0cQJz0DmjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SNQp9fCz; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714322321; x=1745858321;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WSj7lu2b4X/UglnfYC8ObjrLUSF53g3nGeBhb8ymiJQ=;
  b=SNQp9fCzcERy5ol1k3spTGbe5+wk+UTIIatQtKQQVoYm16CN7Mlv/go2
   pYcV0HjWP/N3P2YOySp0KSJ62QzYp6NhEkTNQNDQuZi7ZUfOEUagEzNx5
   wJ4HueNxHIDvVJWmGz8e/4O65FsdutV+WtGLskfUcnzzn6A6OuwPH9oGK
   8q6vdFnTtSNDwOPyZXaz3t0ffhUXsQmnayLxkmAj0YpAs0/xugoNpZ8tK
   vJ6ARhadtJTP0q9S0BjEmV3ZI+85lWhr50eZSL81+nsee8fvY0JnHZm2J
   VRc8CmXIshjzbPrssc+SQbtY6kswpuEHPn2MP8AwEbOCyi8/l5k2aXVIF
   g==;
X-CSE-ConnectionGUID: oiYNMPxySYed0r4k6xcZ6g==
X-CSE-MsgGUID: lhKnAcIcQHa0nxSdNiSf1A==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="27508324"
X-IronPort-AV: E=Sophos;i="6.07,237,1708416000"; 
   d="scan'208";a="27508324"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2024 09:38:40 -0700
X-CSE-ConnectionGUID: 1lt0aqshR62GFUHxtdZWqw==
X-CSE-MsgGUID: CKEGUDIXSTuDOL2KFztXMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,237,1708416000"; 
   d="scan'208";a="26522158"
Received: from lkp-server01.sh.intel.com (HELO e434dd42e5a1) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 28 Apr 2024 09:38:38 -0700
Received: from kbuild by e434dd42e5a1 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1s17Xv-0006Ue-1C;
	Sun, 28 Apr 2024 16:38:35 +0000
Date: Mon, 29 Apr 2024 00:38:10 +0800
From: kernel test robot <lkp@intel.com>
To: Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Juergen Gross <jgross@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: oe-kbuild-all@lists.linux.dev, loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Subject: Re: [PATCH v8 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
Message-ID: <202404290016.T9p5GhVr-lkp@intel.com>
References: <20240428100518.1642324-4-maobibo@loongson.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240428100518.1642324-4-maobibo@loongson.cn>

Hi Bibo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 5eb4573ea63d0c83bf58fb7c243fc2c2b6966c02]

url:    https://github.com/intel-lab-lkp/linux/commits/Bibo-Mao/LoongArch-smp-Refine-some-ipi-functions-on-LoongArch-platform/20240428-180850
base:   5eb4573ea63d0c83bf58fb7c243fc2c2b6966c02
patch link:    https://lore.kernel.org/r/20240428100518.1642324-4-maobibo%40loongson.cn
patch subject: [PATCH v8 3/6] LoongArch: KVM: Add cpucfg area for kvm hypervisor
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20240429/202404290016.T9p5GhVr-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 13.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240429/202404290016.T9p5GhVr-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202404290016.T9p5GhVr-lkp@intel.com/

All warnings (new ones prefixed by >>):

   arch/loongarch/kvm/exit.c: In function 'kvm_emu_cpucfg':
>> arch/loongarch/kvm/exit.c:213:23: warning: variable 'plv' set but not used [-Wunused-but-set-variable]
     213 |         unsigned long plv;
         |                       ^~~


vim +/plv +213 arch/loongarch/kvm/exit.c

   208	
   209	static int kvm_emu_cpucfg(struct kvm_vcpu *vcpu, larch_inst inst)
   210	{
   211		int rd, rj;
   212		unsigned int index;
 > 213		unsigned long plv;
   214	
   215		rd = inst.reg2_format.rd;
   216		rj = inst.reg2_format.rj;
   217		++vcpu->stat.cpucfg_exits;
   218		index = vcpu->arch.gprs[rj];
   219	
   220		/*
   221		 * By LoongArch Reference Manual 2.2.10.5
   222		 * Return value is 0 for undefined cpucfg index
   223		 *
   224		 * Disable preemption since hw gcsr is accessed
   225		 */
   226		preempt_disable();
   227		plv = kvm_read_hw_gcsr(LOONGARCH_CSR_CRMD) >> CSR_CRMD_PLV_SHIFT;
   228		switch (index) {
   229		case 0 ... (KVM_MAX_CPUCFG_REGS - 1):
   230			vcpu->arch.gprs[rd] = vcpu->arch.cpucfg[index];
   231			break;
   232		case CPUCFG_KVM_SIG:
   233			/* Cpucfg emulation between 0x40000000 -- 0x400000ff */
   234			vcpu->arch.gprs[rd] = *(unsigned int *)KVM_SIGNATURE;
   235			break;
   236		default:
   237			vcpu->arch.gprs[rd] = 0;
   238			break;
   239		}
   240	
   241		preempt_enable();
   242		return EMULATE_DONE;
   243	}
   244	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

