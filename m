Return-Path: <kvm+bounces-42034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32149A7194D
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 15:50:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E5EC17B891
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 14:45:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1071F5850;
	Wed, 26 Mar 2025 14:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SSDHVgs8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272CD1F3BA5;
	Wed, 26 Mar 2025 14:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743000191; cv=none; b=p+e3z+FxWtGF5+tLFi1DUmSuVHYDlx9ji3YBBeSj8tGCiuOPH0Cu8Xzf5IvBVD/IJH1hCvRsDuI7vgYQvhnsai9bdmJ81fKcqgdfLXbiyJlCCbOPGpmzhvYyySt2MiRHHUNm79ZzJZNbunQaKWXAExNq7OV8F5bnGTd8oCjRTJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743000191; c=relaxed/simple;
	bh=8ruiAexsDkLplsXd3Wz44waqyHX3oMolkpYe0zqHwws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BhArWI9ea/iPofzZ2+ysowmh+NwsmN9xU9pqDEf+AfTWyvu4IZkvfEyqWGTpYASWEkyOs/KkkOTl21AuVOdrP92G06Kyn1dVvpngDvfoi59TqdQbEpLczxPm3nrYEyzAlJQNX0+IfALneR9eAEQTsylODESpuFmPkNicNHt2nsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SSDHVgs8; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743000190; x=1774536190;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8ruiAexsDkLplsXd3Wz44waqyHX3oMolkpYe0zqHwws=;
  b=SSDHVgs80DhSOJ4IaxTDZFC4NnhPvaGqJZnSDJJbgkU06JCwJOOiBgpx
   DeiT1qKKuHtGrEM+O3Nm/LUWjXy0uDV3BVk/moJo75uy6TOPQmFqBb8EM
   GZCl3v+dgcz9HPTv+bUz+uGlunIY46uwXNGQlWOOAIjKwoDHlRY1PvbYi
   1Fejm+zU8UhMKykVZzpOobE61QTvGWE4Dkqrlgp9Wg+RImu/CWQt3qxkR
   zsu/+qfG3G5gZSLE05LnsTtOuXzbt5es0L5NXSpG5/3gIZ+NdCdGtlF+J
   /lxGVVISn7Bl8XlJ45zECVYDVdjCzEYLHXKXUUPxHm9uVBbE5v6ariW7v
   Q==;
X-CSE-ConnectionGUID: UsGm2F4rSjqe6LxcxbN7lA==
X-CSE-MsgGUID: JeLbZT73R0qCnltNYzZGcA==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="44179686"
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="44179686"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 07:43:09 -0700
X-CSE-ConnectionGUID: jI/+7xQ0QY+hOlssQhJQDA==
X-CSE-MsgGUID: oVDthJJ2SIuQ1QogZ8W1Rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="129982866"
Received: from lkp-server02.sh.intel.com (HELO e98e3655d6d2) ([10.239.97.151])
  by orviesa005.jf.intel.com with ESMTP; 26 Mar 2025 07:43:03 -0700
Received: from kbuild by e98e3655d6d2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1txRy0-0005oR-1c;
	Wed, 26 Mar 2025 14:42:55 +0000
Date: Wed, 26 Mar 2025 22:42:20 +0800
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
Subject: Re: [PATCH v7 5/9] KVM: x86: Mark KVM_X86_SW_PROTECTED_VM as
 supporting guest_memfd shared memory
Message-ID: <202503262202.WSGvs92t-lkp@intel.com>
References: <20250318161823.4005529-6-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250318161823.4005529-6-tabba@google.com>

Hi Fuad,

kernel test robot noticed the following build errors:

[auto build test ERROR on 4701f33a10702d5fc577c32434eb62adde0a1ae1]

url:    https://github.com/intel-lab-lkp/linux/commits/Fuad-Tabba/mm-Consolidate-freeing-of-typed-folios-on-final-folio_put/20250319-003340
base:   4701f33a10702d5fc577c32434eb62adde0a1ae1
patch link:    https://lore.kernel.org/r/20250318161823.4005529-6-tabba%40google.com
patch subject: [PATCH v7 5/9] KVM: x86: Mark KVM_X86_SW_PROTECTED_VM as supporting guest_memfd shared memory
config: x86_64-randconfig-078-20250326 (https://download.01.org/0day-ci/archive/20250326/202503262202.WSGvs92t-lkp@intel.com/config)
compiler: clang version 20.1.1 (https://github.com/llvm/llvm-project 424c2d9b7e4de40d0804dd374721e6411c27d1d1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250326/202503262202.WSGvs92t-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503262202.WSGvs92t-lkp@intel.com/

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: kvm_gmem_handle_folio_put
   >>> referenced by swap.c:110 (mm/swap.c:110)
   >>>               mm/swap.o:(free_typed_folio) in archive vmlinux.a

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

