Return-Path: <kvm+bounces-52078-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C37AEB010A0
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 03:14:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 269637627C7
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 01:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F04212CD88;
	Fri, 11 Jul 2025 01:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DMcmDpAv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C13F7482;
	Fri, 11 Jul 2025 01:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752196470; cv=none; b=ipT2wn/YQ3+0EHrf40fGngf2CezyZXvOaqxbpw84KXmVXBRRIz07tmjEEChpvFKd61P51ha9e7cdBBEgVIOVeASnYqhsteNok6irT9cJ/knfUvhrJQ8mBVFA9J5EG/eNk+Sr12bjJmy9Pxm80HKyOGaVdyhx7elFbQzSw+yVvok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752196470; c=relaxed/simple;
	bh=DYCyMUrFWv8UxDeY8uzqr2IcSenrjZosj8k5QvYfXP0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AhVSAMeDiv7kI/kzELaZ8LhO3/FYCszbJtcQCzIaffreid0PfsBYUaY/D4aigXLNNrTeP5DQNywRjsz72CC4I4PHEDxUxHrMkH0VNCZynvJXFQyvzgHfl5QetUiBnvs+3hzHwK3fGF/COr2O8rFrg0jmnPNzrXHu6NnhXiuIG+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DMcmDpAv; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752196468; x=1783732468;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DYCyMUrFWv8UxDeY8uzqr2IcSenrjZosj8k5QvYfXP0=;
  b=DMcmDpAvmRQ/It/KBIGean8JsIyPZp4iOLu4PkCsLk0h3+Vm7p3odjBy
   EKBYjwlIlta8pMef6ONfXpTCLpeUaLN2FQLajHQDfnMHCtU41LcLvGu20
   MwjQC+j7N61EjXk7RE33vJ/Ri7l687h53HJgcvCyBW3kjCsIYMKpWh+HO
   rsUtTVcVjAt9s0QdAa/KNXyrKAMVYdHR7Of2A47CUuSYooqmeGVDVWF5+
   5v+b5uyuTeUwbuWUF2egSD5pXzZPWn7k7/kh8ii+vUASPS354nPpsBJLQ
   YYzRtq+5slgaWQVyi7ETZVdtTjbmOZWcUp6hbMsS1bLG/b9MZq1EO95+s
   w==;
X-CSE-ConnectionGUID: CCS0Ly9dRRS5Hll2k8aFag==
X-CSE-MsgGUID: iJ0Ipxp9RFWFeTTHHcpJvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="72072980"
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="72072980"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 18:14:28 -0700
X-CSE-ConnectionGUID: SdMKwLrVSoGO7g8IqZPS7g==
X-CSE-MsgGUID: rUIlbZKsQDaO0ykbXJymng==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="156964041"
Received: from lkp-server01.sh.intel.com (HELO 9ee84586c615) ([10.239.97.150])
  by fmviesa010.fm.intel.com with ESMTP; 10 Jul 2025 18:14:20 -0700
Received: from kbuild by 9ee84586c615 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1ua2LC-0005hB-0n;
	Fri, 11 Jul 2025 01:14:18 +0000
Date: Fri, 11 Jul 2025 09:14:06 +0800
From: kernel test robot <lkp@intel.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org,
	kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com
Subject: Re: [PATCH v13 14/20] KVM: x86: Enable guest_memfd mmap for default
 VM type
Message-ID: <202507110822.EaBBAGre-lkp@intel.com>
References: <20250709105946.4009897-15-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250709105946.4009897-15-tabba@google.com>

Hi Fuad,

kernel test robot noticed the following build errors:

[auto build test ERROR on d7b8f8e20813f0179d8ef519541a3527e7661d3a]

url:    https://github.com/intel-lab-lkp/linux/commits/Fuad-Tabba/KVM-Rename-CONFIG_KVM_PRIVATE_MEM-to-CONFIG_KVM_GMEM/20250709-190344
base:   d7b8f8e20813f0179d8ef519541a3527e7661d3a
patch link:    https://lore.kernel.org/r/20250709105946.4009897-15-tabba%40google.com
patch subject: [PATCH v13 14/20] KVM: x86: Enable guest_memfd mmap for default VM type
config: i386-randconfig-013-20250711 (https://download.01.org/0day-ci/archive/20250711/202507110822.EaBBAGre-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250711/202507110822.EaBBAGre-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507110822.EaBBAGre-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/x86/kvm/../../../virt/kvm/guest_memfd.c: In function 'kvm_gmem_supports_mmap':
   arch/x86/kvm/../../../virt/kvm/guest_memfd.c:317:27: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
     317 |         const u64 flags = (u64)inode->i_private;
         |                           ^
   In file included from <command-line>:
   arch/x86/kvm/../../../virt/kvm/guest_memfd.c: In function 'kvm_gmem_bind':
>> include/linux/compiler_types.h:568:45: error: call to '__compiletime_assert_624' declared with attribute error: BUILD_BUG_ON failed: sizeof(gfn_t) != sizeof(slot->gmem.pgoff)
     568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |                                             ^
   include/linux/compiler_types.h:549:25: note: in definition of macro '__compiletime_assert'
     549 |                         prefix ## suffix();                             \
         |                         ^~~~~~
   include/linux/compiler_types.h:568:9: note: in expansion of macro '_compiletime_assert'
     568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
         |         ^~~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
      39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
         |                                     ^~~~~~~~~~~~~~~~~~
   include/linux/build_bug.h:50:9: note: in expansion of macro 'BUILD_BUG_ON_MSG'
      50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
         |         ^~~~~~~~~~~~~~~~
   arch/x86/kvm/../../../virt/kvm/guest_memfd.c:558:9: note: in expansion of macro 'BUILD_BUG_ON'
     558 |         BUILD_BUG_ON(sizeof(gfn_t) != sizeof(slot->gmem.pgoff));
         |         ^~~~~~~~~~~~


vim +/__compiletime_assert_624 +568 include/linux/compiler_types.h

eb5c2d4b45e3d2 Will Deacon 2020-07-21  554  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  555  #define _compiletime_assert(condition, msg, prefix, suffix) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21  556  	__compiletime_assert(condition, msg, prefix, suffix)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  557  
eb5c2d4b45e3d2 Will Deacon 2020-07-21  558  /**
eb5c2d4b45e3d2 Will Deacon 2020-07-21  559   * compiletime_assert - break build and emit msg if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  560   * @condition: a compile-time constant condition to check
eb5c2d4b45e3d2 Will Deacon 2020-07-21  561   * @msg:       a message to emit if condition is false
eb5c2d4b45e3d2 Will Deacon 2020-07-21  562   *
eb5c2d4b45e3d2 Will Deacon 2020-07-21  563   * In tradition of POSIX assert, this macro will break the build if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  564   * supplied condition is *false*, emitting the supplied error message if the
eb5c2d4b45e3d2 Will Deacon 2020-07-21  565   * compiler has support to do so.
eb5c2d4b45e3d2 Will Deacon 2020-07-21  566   */
eb5c2d4b45e3d2 Will Deacon 2020-07-21  567  #define compiletime_assert(condition, msg) \
eb5c2d4b45e3d2 Will Deacon 2020-07-21 @568  	_compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
eb5c2d4b45e3d2 Will Deacon 2020-07-21  569  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

