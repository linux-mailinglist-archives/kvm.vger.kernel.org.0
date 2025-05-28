Return-Path: <kvm+bounces-47913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C2B6AC7473
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 01:20:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ECBFA437C8
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 23:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5CD7221561;
	Wed, 28 May 2025 23:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f8eOGPjS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D732236EB;
	Wed, 28 May 2025 23:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748474292; cv=none; b=m4XuyGpvJ6kYQcUMIjsxprBOKARiG0YdP54v2gkbMr9qOs5uZUojvpcZauDuQbXkwCxTJQjYuVcvAWFBoyijOdMfkXOrtg4nWjyamWgFBYrVIveY4LH/L07jrXcCfUbLbptoDK+iMSYdo0/bQcvKN05py4CPCuH/1MrA3X1Bgwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748474292; c=relaxed/simple;
	bh=jTXbawS0IX96rFwszkT9kCM9dGjFANXvjb9fYEZEKIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtwsH9imMGnuBYdm2+qAwf05fYEzQ4XVJFCcuD9bIKufUKb1zUmAF3BQDPqfDg5oBbmYPh+uWv7n6/V2pmSOyk0ut4q4GodBE5cjdhPJEO+r+9GneB9SX0dD7jLUyU5T2QueeKOC7W4FVUrIRNbGDTVqaAw773iEPKSbIebtjxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f8eOGPjS; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748474291; x=1780010291;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jTXbawS0IX96rFwszkT9kCM9dGjFANXvjb9fYEZEKIQ=;
  b=f8eOGPjSPTxQsZcYW+2cSt1VC9rX8gQbewPAl3VE0eu4wK/a4Hw32b3e
   mkdinDiPykmpZ2jzBI+NyqUVs89VwH5VCoLr6MEPyKgD4w1SjsOjrGPS2
   Ihx1I2gpH6ZVWAwCxBFSXu/T7+HZc3yYCDeGRasYXn49RnJXxm/sbnVB0
   jP6YLGCLQ1DCg6ZA0RE27RwZ/p7eI1BX3ZmkfxbbEVZKKfqTbOS6jdp06
   dUF4jaM7uNoEg4I5DAa9bGeQuCItzHyz/r4008OXik13At0hQWbV1lONY
   s8FNlonTWrfJfaC8dXG+PzjBhkNStEJwg9ZeAdbqh/Pv1/9ts+EipulL9
   Q==;
X-CSE-ConnectionGUID: vZhFyn+RTyav2PIAa9rb7w==
X-CSE-MsgGUID: jo+/F0D8SGasLRiwktzsIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="53145989"
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="53145989"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 16:18:09 -0700
X-CSE-ConnectionGUID: iwficSJmT/qS3pdcAJGGYg==
X-CSE-MsgGUID: N7yDre9XSIaIrg+kwGzUcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="148155222"
Received: from lkp-server01.sh.intel.com (HELO 1992f890471c) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 28 May 2025 16:18:01 -0700
Received: from kbuild by 1992f890471c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uKQ23-000W9E-17;
	Wed, 28 May 2025 23:17:59 +0000
Date: Thu, 29 May 2025 07:17:02 +0800
From: kernel test robot <lkp@intel.com>
To: Fuad Tabba <tabba@google.com>, kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, pbonzini@redhat.com,
	chenhuacai@kernel.org, mpe@ellerman.id.au, anup@brainfault.org,
	paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	seanjc@google.com, viro@zeniv.linux.org.uk, brauner@kernel.org,
	willy@infradead.org, akpm@linux-foundation.org,
	xiaoyao.li@intel.com, yilun.xu@intel.com,
	chao.p.peng@linux.intel.com, jarkko@kernel.org, amoorthy@google.com,
	dmatlack@google.com, isaku.yamahata@intel.com, mic@digikod.net,
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com,
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com,
	wei.w.wang@intel.com
Subject: Re: [PATCH v10 08/16] KVM: guest_memfd: Allow host to map
 guest_memfd pages
Message-ID: <202505290736.HR4GYiOF-lkp@intel.com>
References: <20250527180245.1413463-9-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250527180245.1413463-9-tabba@google.com>

Hi Fuad,

kernel test robot noticed the following build errors:

[auto build test ERROR on 0ff41df1cb268fc69e703a08a57ee14ae967d0ca]

url:    https://github.com/intel-lab-lkp/linux/commits/Fuad-Tabba/KVM-Rename-CONFIG_KVM_PRIVATE_MEM-to-CONFIG_KVM_GMEM/20250528-020608
base:   0ff41df1cb268fc69e703a08a57ee14ae967d0ca
patch link:    https://lore.kernel.org/r/20250527180245.1413463-9-tabba%40google.com
patch subject: [PATCH v10 08/16] KVM: guest_memfd: Allow host to map guest_memfd pages
config: powerpc-allmodconfig (https://download.01.org/0day-ci/archive/20250529/202505290736.HR4GYiOF-lkp@intel.com/config)
compiler: powerpc64-linux-gcc (GCC) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250529/202505290736.HR4GYiOF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202505290736.HR4GYiOF-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/powerpc/kvm/../../../virt/kvm/guest_memfd.c: In function '__kvm_gmem_create':
   arch/powerpc/kvm/../../../virt/kvm/guest_memfd.c:487:14: error: implicit declaration of function 'get_unused_fd_flags' [-Wimplicit-function-declaration]
     487 |         fd = get_unused_fd_flags(0);
         |              ^~~~~~~~~~~~~~~~~~~
   arch/powerpc/kvm/../../../virt/kvm/guest_memfd.c:524:9: error: implicit declaration of function 'fd_install'; did you mean 'fs_initcall'? [-Wimplicit-function-declaration]
     524 |         fd_install(fd, file);
         |         ^~~~~~~~~~
         |         fs_initcall
   arch/powerpc/kvm/../../../virt/kvm/guest_memfd.c:530:9: error: implicit declaration of function 'put_unused_fd'; did you mean 'put_user_ns'? [-Wimplicit-function-declaration]
     530 |         put_unused_fd(fd);
         |         ^~~~~~~~~~~~~
         |         put_user_ns
   arch/powerpc/kvm/../../../virt/kvm/guest_memfd.c: In function 'kvm_gmem_create':
>> arch/powerpc/kvm/../../../virt/kvm/guest_memfd.c:540:13: error: implicit declaration of function 'kvm_arch_supports_gmem_shared_mem' [-Wimplicit-function-declaration]
     540 |         if (kvm_arch_supports_gmem_shared_mem(kvm))
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/powerpc/kvm/../../../virt/kvm/guest_memfd.c: In function 'kvm_gmem_bind':
   arch/powerpc/kvm/../../../virt/kvm/guest_memfd.c:564:16: error: implicit declaration of function 'fget'; did you mean 'sget'? [-Wimplicit-function-declaration]
     564 |         file = fget(fd);
         |                ^~~~
         |                sget
   arch/powerpc/kvm/../../../virt/kvm/guest_memfd.c:564:14: error: assignment to 'struct file *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     564 |         file = fget(fd);
         |              ^
   arch/powerpc/kvm/../../../virt/kvm/guest_memfd.c:614:9: error: implicit declaration of function 'fput'; did you mean 'iput'? [-Wimplicit-function-declaration]
     614 |         fput(file);
         |         ^~~~
         |         iput


vim +/kvm_arch_supports_gmem_shared_mem +540 arch/powerpc/kvm/../../../virt/kvm/guest_memfd.c

   533	
   534	int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
   535	{
   536		loff_t size = args->size;
   537		u64 flags = args->flags;
   538		u64 valid_flags = 0;
   539	
 > 540		if (kvm_arch_supports_gmem_shared_mem(kvm))
   541			valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
   542	
   543		if (flags & ~valid_flags)
   544			return -EINVAL;
   545	
   546		if (size <= 0 || !PAGE_ALIGNED(size))
   547			return -EINVAL;
   548	
   549		return __kvm_gmem_create(kvm, size, flags);
   550	}
   551	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

