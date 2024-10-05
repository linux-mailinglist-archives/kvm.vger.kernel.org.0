Return-Path: <kvm+bounces-28003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D472D991384
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 02:32:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C82C2840A8
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2024 00:32:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F27AAC125;
	Sat,  5 Oct 2024 00:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ChbyQTVj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7903B4A3E;
	Sat,  5 Oct 2024 00:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728088311; cv=none; b=XxJHCGCAeJfn3/gIPuRBt0LnErML/3b3w/GBtSqNHBH3WxJjHJKoQn/kTnR7Mpx6RRyiMikl7Uw8zkVzMiPUEOMDK9eVnP8AJpNbk6q/kkd86oJHT7PnbTzA2kjpWottewPxbdiMepokStI84iX6H5cflzB39Mw8bG1qB5lVxlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728088311; c=relaxed/simple;
	bh=fisvYHlAi5uYfnh9DKgiQuCX0NawSYHqjeYtsvrspLg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XaPJGHstYM5LSyDvM3NJUBdcS001kuhT9Jb3s2/BoRfBNQoznSLr3cKJw8aD/vV69uTTslL7U5Zpq6VDVyqPt82JRzrF9mgD5H+Wl/+O7P7qiVlNQPjDOo0dHS05e7lAimiCUEvWFKYf7Pbsr84uqYEnUJ9DG1trKfg1uKkEwLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ChbyQTVj; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728088309; x=1759624309;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fisvYHlAi5uYfnh9DKgiQuCX0NawSYHqjeYtsvrspLg=;
  b=ChbyQTVjetzYvlAhADKGaPw5jKQfX5KILwdPH4BgEAMdVbJcUw1GEkyJ
   angn/ORabg7v7NuBLDfl4AX0elTCCssaCXrgyUCdbevH++YWmVK1ZjWjB
   92pkyzWwslwt5BIeR3K3gkRDM0aUfFWv8hlhOis/wGipMVayAJekCg79s
   j/+02zcbZZZ/ma79QlZ4OCngCfCgEhAM5JmwalWWcHG/DjjyVcpohK5VS
   lQBVD2B4L1dAi0pJb+PFfd9XP+6VPAEj2wUDTOPasI2J2cPGvGqkNnynI
   WJ9ja2w7VtB+dJ3g5vCMzZjzNeU5ImsiCHC4h4ub8/WbCC7qeVwCkRTeJ
   Q==;
X-CSE-ConnectionGUID: rWPu/aubSvSR49g/rHKwRw==
X-CSE-MsgGUID: RlBX/SWfRv2EPEIO1Ir2lA==
X-IronPort-AV: E=McAfee;i="6700,10204,11215"; a="49851941"
X-IronPort-AV: E=Sophos;i="6.11,178,1725346800"; 
   d="scan'208";a="49851941"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2024 17:31:49 -0700
X-CSE-ConnectionGUID: 5Y3LDSg9R2+kKS3QBRFAMA==
X-CSE-MsgGUID: 441BmZfhR26UoJ5rU1Or5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,178,1725346800"; 
   d="scan'208";a="75296114"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 04 Oct 2024 17:31:48 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1swsi0-0002NT-2t;
	Sat, 05 Oct 2024 00:31:44 +0000
Date: Sat, 5 Oct 2024 08:30:45 +0800
From: kernel test robot <lkp@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Paul Gazzillo <paul@pgazz.com>,
	Necip Fazil Yildiran <fazilyildiran@gmail.com>,
	oe-kbuild-all@lists.linux.dev, seanjc@google.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] KVM: x86: leave kvm.ko out of the build if no vendor
 module is requested
Message-ID: <202410050850.Ztr6bJEq-lkp@intel.com>
References: <20241003230806.229001-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241003230806.229001-2-pbonzini@redhat.com>

Hi Paolo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on linus/master v6.12-rc1 next-20241004]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paolo-Bonzini/KVM-x86-leave-kvm-ko-out-of-the-build-if-no-vendor-module-is-requested/20241004-071034
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20241003230806.229001-2-pbonzini%40redhat.com
patch subject: [PATCH 1/2] KVM: x86: leave kvm.ko out of the build if no vendor module is requested
config: x86_64-kismet-CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES-CONFIG_KVM_GENERIC_PRIVATE_MEM-0-0 (https://download.01.org/0day-ci/archive/20241005/202410050850.Ztr6bJEq-lkp@intel.com/config)
reproduce: (https://download.01.org/0day-ci/archive/20241005/202410050850.Ztr6bJEq-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410050850.Ztr6bJEq-lkp@intel.com/

kismet warnings: (new ones prefixed by >>)
>> kismet: WARNING: unmet direct dependencies detected for KVM_GENERIC_MEMORY_ATTRIBUTES when selected by KVM_GENERIC_PRIVATE_MEM
   WARNING: unmet direct dependencies detected for KVM_GENERIC_MEMORY_ATTRIBUTES
     Depends on [n]: KVM_GENERIC_MMU_NOTIFIER [=n]
     Selected by [y]:
     - KVM_GENERIC_PRIVATE_MEM [=y]

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

