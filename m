Return-Path: <kvm+bounces-40936-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 052E0A5F7DE
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 15:22:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9B0C3BF4A7
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 14:21:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A73DA267F5C;
	Thu, 13 Mar 2025 14:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GQVqXQYJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB75267B87;
	Thu, 13 Mar 2025 14:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741875717; cv=none; b=HZWtxqK6KxBxX8OqaE4eb1rhHgeA1T0Nn6TFMwlJInTNvqYticab5gFZzOwm0awuAPHM/3i9cnR1StVids+HxB9kDmqO9VYGpbGBc+DQGfNsmbDJQR4D/BSDxRdXZcd8hMvNZP8NT4C5yWRvMfcID2X6U9ucgEpvZ24QhWM9ncs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741875717; c=relaxed/simple;
	bh=FZGBmGms+TGXeGz/gxxLPrKHWPZfjyc+sRwOk3cnf5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iGkzY8VkncWCq78x6NPzXQqSP3fMV8awfrM/7x4muxho3h0HhaG+AaXyQmq9fH4JUlb2ftH5Km6yewIBzXXEM8p+v/S+HZ4FQBYXxSbx4VzwwLurtps/CTHFwV5jsRP8rxOvk62+oGRV7fV/ucKX9pRCHDIKXZ9RE/m0cN7s+BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GQVqXQYJ; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741875715; x=1773411715;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FZGBmGms+TGXeGz/gxxLPrKHWPZfjyc+sRwOk3cnf5k=;
  b=GQVqXQYJFkHrXZkAFcxaIit5/8iKRPe8J0NTLs90N/o2PzSsxkQc1fz0
   vqm+n+MEjFjyT3qqG/6Ur/vicw+Jj72McEeYQ2onXkZzLX6T+dQLAWL+2
   lcyMRqJmyxA1KL2DoBCTWVFGEY4BiVYlziLBumsIVozSSHNUTclqSsxFA
   vos03ulK86xPbocXv1J60uoX5QvuoD/G7lGgtAkQlWlQorvB69s/0Cgg3
   wweScKgwi0B4K1cQRCygzzsucWoh7HXmxVDDWdI4B0A2MKA+td9myORkh
   VF97aYQavFNinb1VYVTGfJDHwzTRAlosOYcVESoiCk4pA6+tYP+Mkhv/x
   g==;
X-CSE-ConnectionGUID: dtWZuvOsQgS9rkLTOOEvWg==
X-CSE-MsgGUID: Gz5Fkh1DQD6v8Jps4HoXtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11372"; a="43173179"
X-IronPort-AV: E=Sophos;i="6.14,244,1736841600"; 
   d="scan'208";a="43173179"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 07:21:55 -0700
X-CSE-ConnectionGUID: rgVzKyghTUuLgBgj3SL2mA==
X-CSE-MsgGUID: JQFdTckuTfCVIMwnKqXgYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,244,1736841600"; 
   d="scan'208";a="126026799"
Received: from lkp-server02.sh.intel.com (HELO a4747d147074) ([10.239.97.151])
  by orviesa004.jf.intel.com with ESMTP; 13 Mar 2025 07:21:47 -0700
Received: from kbuild by a4747d147074 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tsjRQ-0009Vj-3D;
	Thu, 13 Mar 2025 14:21:44 +0000
Date: Thu, 13 Mar 2025 22:20:46 +0800
From: kernel test robot <lkp@intel.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au,
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk,
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com
Subject: Re: [PATCH v6 09/10] KVM: arm64: Enable mapping guest_memfd in arm64
Message-ID: <202503132205.Ajz52k8I-lkp@intel.com>
References: <20250312175824.1809636-10-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250312175824.1809636-10-tabba@google.com>

Hi Fuad,

kernel test robot noticed the following build errors:

[auto build test ERROR on 80e54e84911a923c40d7bee33a34c1b4be148d7a]

url:    https://github.com/intel-lab-lkp/linux/commits/Fuad-Tabba/mm-Consolidate-freeing-of-typed-folios-on-final-folio_put/20250313-020010
base:   80e54e84911a923c40d7bee33a34c1b4be148d7a
patch link:    https://lore.kernel.org/r/20250312175824.1809636-10-tabba%40google.com
patch subject: [PATCH v6 09/10] KVM: arm64: Enable mapping guest_memfd in arm64
config: arm64-allnoconfig (https://download.01.org/0day-ci/archive/20250313/202503132205.Ajz52k8I-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250313/202503132205.Ajz52k8I-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503132205.Ajz52k8I-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from arch/arm64/kernel/asm-offsets.c:15:
>> include/linux/kvm_host.h:725:20: error: redefinition of 'kvm_arch_has_private_mem'
     725 | static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~
   In file included from include/linux/kvm_host.h:45:
   arch/arm64/include/asm/kvm_host.h:1546:20: note: previous definition of 'kvm_arch_has_private_mem' with type 'bool(struct kvm *)' {aka '_Bool(struct kvm *)'}
    1546 | static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~
>> include/linux/kvm_host.h:736:20: error: redefinition of 'kvm_arch_gmem_supports_shared_mem'
     736 | static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/include/asm/kvm_host.h:1551:20: note: previous definition of 'kvm_arch_gmem_supports_shared_mem' with type 'bool(struct kvm *)' {aka '_Bool(struct kvm *)'}
    1551 | static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
         |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   make[3]: *** [scripts/Makefile.build:102: arch/arm64/kernel/asm-offsets.s] Error 1
   make[3]: Target 'prepare' not remade because of errors.
   make[2]: *** [Makefile:1269: prepare0] Error 2
   make[2]: Target 'prepare' not remade because of errors.
   make[1]: *** [Makefile:251: __sub-make] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:251: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.


vim +/kvm_arch_has_private_mem +725 include/linux/kvm_host.h

f481b069e674378 Paolo Bonzini       2015-05-17  719  
a7800aa80ea4d53 Sean Christopherson 2023-11-13  720  /*
a7800aa80ea4d53 Sean Christopherson 2023-11-13  721   * Arch code must define kvm_arch_has_private_mem if support for private memory
a7800aa80ea4d53 Sean Christopherson 2023-11-13  722   * is enabled.
a7800aa80ea4d53 Sean Christopherson 2023-11-13  723   */
a7800aa80ea4d53 Sean Christopherson 2023-11-13  724  #if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_PRIVATE_MEM)
a7800aa80ea4d53 Sean Christopherson 2023-11-13 @725  static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
a7800aa80ea4d53 Sean Christopherson 2023-11-13  726  {
a7800aa80ea4d53 Sean Christopherson 2023-11-13  727  	return false;
a7800aa80ea4d53 Sean Christopherson 2023-11-13  728  }
a7800aa80ea4d53 Sean Christopherson 2023-11-13  729  #endif
a7800aa80ea4d53 Sean Christopherson 2023-11-13  730  
a765e4ca28eb657 Fuad Tabba          2025-03-12  731  /*
a765e4ca28eb657 Fuad Tabba          2025-03-12  732   * Arch code must define kvm_arch_gmem_supports_shared_mem if support for
a765e4ca28eb657 Fuad Tabba          2025-03-12  733   * private memory is enabled and it supports in-place shared/private conversion.
a765e4ca28eb657 Fuad Tabba          2025-03-12  734   */
a765e4ca28eb657 Fuad Tabba          2025-03-12  735  #if !defined(kvm_arch_gmem_supports_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM)
a765e4ca28eb657 Fuad Tabba          2025-03-12 @736  static inline bool kvm_arch_gmem_supports_shared_mem(struct kvm *kvm)
a765e4ca28eb657 Fuad Tabba          2025-03-12  737  {
a765e4ca28eb657 Fuad Tabba          2025-03-12  738  	return false;
a765e4ca28eb657 Fuad Tabba          2025-03-12  739  }
a765e4ca28eb657 Fuad Tabba          2025-03-12  740  #endif
a765e4ca28eb657 Fuad Tabba          2025-03-12  741  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

