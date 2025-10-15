Return-Path: <kvm+bounces-60068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D3F0BDD8C8
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 10:54:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 388A34F959F
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 08:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66194319855;
	Wed, 15 Oct 2025 08:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WPcsC4v/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F143191DA;
	Wed, 15 Oct 2025 08:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760518458; cv=none; b=fpgQivo+krzAj74tNQoH4HNZxv46rRCcQUMSCcbzaSJPFtrFV/BkOkmgiyDwMsfm4cYqXqTNKJWsWkx81fToJUER4x+xui5+ta3hpXM3rydAP7ZSOD/kie/sVtgRuNjSww8Wyq+NJ4z0NrpcU5u9aGzdJbzZBxRlmtLYveZO6EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760518458; c=relaxed/simple;
	bh=+BB5rvJB9mUeya+4DU9TUHtTCg+zs/03Q0ZHCN0cD80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0Xcu8wBTTKEGBsGohAYYIQMc7gnJcT9a+5QNImKAcwYkXQFtHqSorurHGjKcqjJ5LFiytLWYasDN9HUIN//e1wQCHoPmnP6K4hOjzCgFnGt494ndgucxb4tj3zGZzf49B+48Z0oLhk1jBCXqMVYlyshGmULq9g0ZNuzJLs0gp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WPcsC4v/; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760518456; x=1792054456;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=+BB5rvJB9mUeya+4DU9TUHtTCg+zs/03Q0ZHCN0cD80=;
  b=WPcsC4v/wegg97rWI6CL8SZMCnh4RAqTBNddGaGQUxsB3vmYcW08EbzD
   DO2T/eKgePq9Yj+qRz6ZVFPqPPLq+r0Ms6qSU3C+NN2A+uK4hYMVAziW9
   AX1oR3xASbcaYpisGg0bVlXAi6F5ywEnYHl9cSW238a+t9lOohjmzmR62
   +QqXOI2GnnjJ56FzhLk8CFshpAL976ukZneFAzVEnAm3hX6xNoB77MPvJ
   x9qDPJ9qq4WJQ2AdtxT/PlNZ1qC9Opz1l+bP21v/EJrVbuAksYpvqPQPn
   XPuT8pDLxl302xY9Qm7Di5O04UOLJI0MeVNtVdza4mGll0Xb8xKIcDZwg
   A==;
X-CSE-ConnectionGUID: +j5ceC0LSViK4YVnblzb5Q==
X-CSE-MsgGUID: n1Q1Aq/bQcOeEQcpOqj0eA==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="50253063"
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="50253063"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 01:54:15 -0700
X-CSE-ConnectionGUID: 9G14ytpfQl2dHZh/4Qmtzg==
X-CSE-MsgGUID: zzuIIelBSnefzwE8pAWIJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,230,1754982000"; 
   d="scan'208";a="213062822"
Received: from lkp-server02.sh.intel.com (HELO 66d7546c76b2) ([10.239.97.151])
  by fmviesa001.fm.intel.com with ESMTP; 15 Oct 2025 01:54:10 -0700
Received: from kbuild by 66d7546c76b2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1v8xGq-0003eZ-0P;
	Wed, 15 Oct 2025 08:54:08 +0000
Date: Wed, 15 Oct 2025 16:53:32 +0800
From: kernel test robot <lkp@intel.com>
To: Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
	x86@kernel.org, linux-hyperv@vger.kernel.org,
	virtualization@lists.linux.dev, kvm@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, Juergen Gross <jgross@suse.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v3 21/21] x86/pvlocks: Move paravirt spinlock functions
 into own header
Message-ID: <202510151611.uYXVunzo-lkp@intel.com>
References: <20251006074606.1266-22-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251006074606.1266-22-jgross@suse.com>

Hi Juergen,

kernel test robot noticed the following build errors:

[auto build test ERROR on tip/sched/core]
[also build test ERROR on kvm/queue kvm/next linus/master v6.18-rc1 next-20251014]
[cannot apply to tip/x86/core kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Juergen-Gross/x86-paravirt-Remove-not-needed-includes-of-paravirt-h/20251010-094850
base:   tip/sched/core
patch link:    https://lore.kernel.org/r/20251006074606.1266-22-jgross%40suse.com
patch subject: [PATCH v3 21/21] x86/pvlocks: Move paravirt spinlock functions into own header
config: x86_64-randconfig-001-20251015 (https://download.01.org/0day-ci/archive/20251015/202510151611.uYXVunzo-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251015/202510151611.uYXVunzo-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202510151611.uYXVunzo-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: vmlinux.o: in function `kvm_guest_init':
   arch/x86/kernel/kvm.c:828:(.init.text+0x440f4): undefined reference to `pv_ops_lock'
>> ld: arch/x86/kernel/kvm.c:828:(.init.text+0x4410e): undefined reference to `pv_ops_lock'
   ld: arch/x86/kernel/kvm.c:828:(.init.text+0x4411a): undefined reference to `pv_ops_lock'

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

