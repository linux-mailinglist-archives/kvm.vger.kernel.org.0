Return-Path: <kvm+bounces-22004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B144F937E9E
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 03:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 084E52824ED
	for <lists+kvm@lfdr.de>; Sat, 20 Jul 2024 01:36:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE516883D;
	Sat, 20 Jul 2024 01:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CsNw4QFw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837743201
	for <kvm@vger.kernel.org>; Sat, 20 Jul 2024 01:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721439358; cv=none; b=rOpPcxRFlwfqL8SAcOfvXO3g8ws3K+F1oxEXoNX68X4a0MSobjkox2fqBpmWDj2RXwwHEVi+1NwOpQFJ0SEyQhQ59hRYFK/aiGs/RPYocTiIhBJqo06jg2i9PYZg4usgtWJ2lunfNMkiqYO/oTlWF+0K7wFBrivhbfNSOL4TDBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721439358; c=relaxed/simple;
	bh=m+0mmqV7O3rlLYP/uVKegSLNgXXmjx3rL0kDYsxdiGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HAg8hw87NH8m/NsAk1g7UTn6KFQs82xFo44c1TViTsKvS09ezLdym3bRpOe/29BwZKbTdnt2YM4oCSYvfuO74iWQ3un0tH00+8zx2bx1jgMl+0v2FvIn+Fp+rfUgAjMlCe9Tx1zyxU7GikjZCw7tBgH/ibPHvJ3xbf+j10KaBi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CsNw4QFw; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721439357; x=1752975357;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=m+0mmqV7O3rlLYP/uVKegSLNgXXmjx3rL0kDYsxdiGo=;
  b=CsNw4QFwRGRikBMP80B3uGJamTnmyGC8n7loVYlBcDxLUyYrgimawqEU
   RAn1WUD4irW2IBBOxfNVH+RebDRV0BwFdW6pWuNZw1rxXas6EUJvYtOx3
   MN3JFL/Tw0sGT0c5nEfjNJy6KPkwosZTNfU+9owSHdigsVs7Ehjg2bANS
   WwcRLOj1D9MViGSRhmjtCv2uE1UqnWuyYTRVANlfU8s8qy5Vbc6vIu8FM
   AmmNcrWRJXatx5Y6q5/vbMWnXfoJbkW/pkU7SudI93CJT+towci8pzpBP
   9CDgkxfNqIE/v2xr9+62ZDtorXOvGrfWUCWWaS3sRRtdoRhuphEo9OcFi
   g==;
X-CSE-ConnectionGUID: A7DhAaTiTE+x3yCM06x9VQ==
X-CSE-MsgGUID: CoE3f3JdSaGTB/m6SxYsEg==
X-IronPort-AV: E=McAfee;i="6700,10204,11138"; a="29697000"
X-IronPort-AV: E=Sophos;i="6.09,222,1716274800"; 
   d="scan'208";a="29697000"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 18:35:56 -0700
X-CSE-ConnectionGUID: NVekY47nT8q5kT9T0N6oUQ==
X-CSE-MsgGUID: YU0j4Y4qSH+E4iXHDS3uAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,222,1716274800"; 
   d="scan'208";a="56129313"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 19 Jul 2024 18:35:54 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sUz0o-000ikE-33;
	Sat, 20 Jul 2024 01:35:50 +0000
Date: Sat, 20 Jul 2024 09:35:16 +0800
From: kernel test robot <lkp@intel.com>
To: Ilias Stamatis <ilstam@amazon.com>, kvm@vger.kernel.org,
	pbonzini@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, pdurrant@amazon.co.uk, dwmw@amazon.co.uk,
	nh-open-source@amazon.com, Ilias Stamatis <ilstam@amazon.com>
Subject: Re: [PATCH v2 3/6] KVM: Support poll() on coalesced mmio buffer fds
Message-ID: <202407200922.pJAJMVRk-lkp@intel.com>
References: <20240718193543.624039-4-ilstam@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240718193543.624039-4-ilstam@amazon.com>

Hi Ilias,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on next-20240719]
[cannot apply to mst-vhost/linux-next linus/master kvm/linux-next v6.10]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Ilias-Stamatis/KVM-Fix-coalesced_mmio_has_room/20240719-034316
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20240718193543.624039-4-ilstam%40amazon.com
patch subject: [PATCH v2 3/6] KVM: Support poll() on coalesced mmio buffer fds
config: x86_64-randconfig-122-20240719 (https://download.01.org/0day-ci/archive/20240720/202407200922.pJAJMVRk-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240720/202407200922.pJAJMVRk-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202407200922.pJAJMVRk-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:241:22: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __poll_t [usertype] mask @@     got int @@
   arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:241:22: sparse:     expected restricted __poll_t [usertype] mask
   arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c:241:22: sparse:     got int
   arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c: note: in included file (through include/linux/mmzone.h, include/linux/gfp.h, include/linux/mm.h, ...):
   include/linux/page-flags.h:240:46: sparse: sparse: self-comparison always evaluates to false
   include/linux/page-flags.h:240:46: sparse: sparse: self-comparison always evaluates to false

vim +241 arch/x86/kvm/../../../virt/kvm/coalesced_mmio.c

   231	
   232	static __poll_t coalesced_mmio_buffer_poll(struct file *file, struct poll_table_struct *wait)
   233	{
   234		struct kvm_coalesced_mmio_buffer_dev *dev = file->private_data;
   235		__poll_t mask = 0;
   236	
   237		poll_wait(file, &dev->wait_queue, wait);
   238	
   239		spin_lock(&dev->ring_lock);
   240		if (dev->ring && (READ_ONCE(dev->ring->first) != READ_ONCE(dev->ring->last)))
 > 241			mask = POLLIN | POLLRDNORM;
   242		spin_unlock(&dev->ring_lock);
   243	
   244		return mask;
   245	}
   246	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

