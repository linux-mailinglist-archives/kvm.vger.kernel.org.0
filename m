Return-Path: <kvm+bounces-60130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B1810BE2451
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 11:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A079E4EC6D2
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 09:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D37B3112C5;
	Thu, 16 Oct 2025 09:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cTw+2o82"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B89310762;
	Thu, 16 Oct 2025 09:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760605241; cv=none; b=mc5dGbOVxOKVxH9XahE0c5DUKOeC845yO4wOGowdLFZEqmCQWbOVqw6VsFVY05GbfeOW1IXeV7MALKmGf9f8S8bjtSesE7YdgB8IAyhc68MTKF4viWMRzMoPtdYGC/F01fqLcUjQtUGrThNhOx8IqRNbOnKmr46EquGWlGGAz8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760605241; c=relaxed/simple;
	bh=AW7nB6IN76ipnUXef9ZFBUX9Cq6m129avw212mcs+6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rv8NF3YalnHIdW+qWrd1k3T8+N9vwc+MjMtWi1Et7PE/121iisP6iiXJ4QD9dpJonvVeMigiwmJh1ulPLCoIdXSWTjLzpHqt7Kl3/5S8tSKjD82PetSU5z4FTTXJy9cteh4HM++6TV6DyP8lYyJugdb1l21mNib614Ih98lVccM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cTw+2o82; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760605239; x=1792141239;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AW7nB6IN76ipnUXef9ZFBUX9Cq6m129avw212mcs+6E=;
  b=cTw+2o82QzIBHykapzUw4zfdofhJJhsNAXP4Y0WAye9s5bqHFt4/Ex3/
   ekUn7YlxSP/7d4ymXXxvmQc5qya8sSMJJnCG6Eq5A6/qVE67exYyUYVVq
   /ebCP4pWPsHheAFyG9ZrMVsjHksMwFpBtvB5qXQEypM5rV6aHg//gkOx5
   sTgIlU1OBXn3N5qRQH+UpZNFmLCHT7lUaJsZ5X3AY0NTj+zUIS106GyA9
   IHvhPA9I96CLYChFOiQ7NauaRrSFilZWIHUxKRZ5UAj6fMl68fbrFDqFo
   ul3jaFnhvuSDcUM/Y1qvHGkQQDTdYZerlvYMaq2OWCDApSkqnnaNXf3gz
   Q==;
X-CSE-ConnectionGUID: lzivQ1oBSt6xPZcszE9Yvg==
X-CSE-MsgGUID: IeFT9n+KRjSEFbq1VgLS8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="62886224"
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="62886224"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 02:00:37 -0700
X-CSE-ConnectionGUID: ZFx0uxHXTvqKR8uM02vRpw==
X-CSE-MsgGUID: 8ygwFBOBSIahmV6x2k007g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="183200150"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 16 Oct 2025 02:00:34 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v9JqZ-0004cB-32;
	Thu, 16 Oct 2025 09:00:31 +0000
Date: Thu, 16 Oct 2025 16:59:42 +0800
From: kernel test robot <lkp@intel.com>
To: Brendan Jackman <jackmanb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH v2] KVM: x86: Unify L1TF flushing under per-CPU variable
Message-ID: <202510161648.7Ere0Lfz-lkp@intel.com>
References: <20251015-b4-l1tf-percpu-v2-1-6d7a8d3d40e9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015-b4-l1tf-percpu-v2-1-6d7a8d3d40e9@google.com>

Hi Brendan,

kernel test robot noticed the following build errors:

[auto build test ERROR on 6b36119b94d0b2bb8cea9d512017efafd461d6ac]

url:    https://github.com/intel-lab-lkp/linux/commits/Brendan-Jackman/KVM-x86-Unify-L1TF-flushing-under-per-CPU-variable/20251016-011539
base:   6b36119b94d0b2bb8cea9d512017efafd461d6ac
patch link:    https://lore.kernel.org/r/20251015-b4-l1tf-percpu-v2-1-6d7a8d3d40e9%40google.com
patch subject: [PATCH v2] KVM: x86: Unify L1TF flushing under per-CPU variable
config: i386-buildonly-randconfig-005-20251016 (https://download.01.org/0day-ci/archive/20251016/202510161648.7Ere0Lfz-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251016/202510161648.7Ere0Lfz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510161648.7Ere0Lfz-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/x86/kvm/x86.c:8003:2: error: call to undeclared function 'kvm_set_cpu_l1tf_flush_l1d_raw'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    8003 |         kvm_set_cpu_l1tf_flush_l1d_raw();
         |         ^
   arch/x86/kvm/x86.c:8003:2: note: did you mean 'kvm_set_cpu_l1tf_flush_l1d'?
   arch/x86/include/asm/hardirq.h:97:29: note: 'kvm_set_cpu_l1tf_flush_l1d' declared here
      97 | static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void) { }
         |                             ^
   arch/x86/kvm/x86.c:9399:2: error: call to undeclared function 'kvm_set_cpu_l1tf_flush_l1d_raw'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    9399 |         kvm_set_cpu_l1tf_flush_l1d_raw();
         |         ^
   2 errors generated.


vim +/kvm_set_cpu_l1tf_flush_l1d_raw +8003 arch/x86/kvm/x86.c

  7998	
  7999	int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
  8000					unsigned int bytes, struct x86_exception *exception)
  8001	{
  8002		/* kvm_write_guest_virt_system can pull in tons of pages. */
> 8003		kvm_set_cpu_l1tf_flush_l1d_raw();
  8004	
  8005		return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
  8006						   PFERR_WRITE_MASK, exception);
  8007	}
  8008	EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_write_guest_virt_system);
  8009	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

