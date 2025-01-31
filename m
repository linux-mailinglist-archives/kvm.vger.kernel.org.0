Return-Path: <kvm+bounces-36998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25752A23E92
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 14:44:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1181C3A90E2
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 13:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9782D1C5D73;
	Fri, 31 Jan 2025 13:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CGAGjFYi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456571C5486
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 13:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738331055; cv=none; b=hx69fAsP/WzSSrAyo/JkZek7UfMrw6xCiw3VEV8CZhjv2ZyO6t2RLVAxx1+Sgw7q/nqtPSvtYXkRm5bBNe4ZcyQyTMyzHbTSAtIsT8Jm20ooFYg8wh31xlxP7HOjebBqKp92ugzXX0GB5MoMF1z8PQGcMaisRim3G2wUkYE4amc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738331055; c=relaxed/simple;
	bh=ZTnumPN0hO6W8SA+XJ4TwwIzgqswOeC8ByqSfrB1TcQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=uFMfqc8Pz2YCI6HO11QkDd9GBy/sMaCOg+4y/ZIaFkSPDQA+2e1B3xuEhNUHjzBGrWKvxASipnf9thjtoYvLadDLO57a+sKm5E9AA0Xco0Dnqx1MftjguH0JPTbxzmdH1j+S/Mdxq0UHaPDBcD0vdfR5IhAPoVV/sPvsDLT7t1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CGAGjFYi; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738331053; x=1769867053;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=ZTnumPN0hO6W8SA+XJ4TwwIzgqswOeC8ByqSfrB1TcQ=;
  b=CGAGjFYiPYY/OMtc6KwDyShKAVADneF9CLfrM22QU7cvmeJffj3BLj8j
   QPbJfKXbnHcO4iT7NlJviZUK4sVFAQk5R3ucqJpOceK0tUG3EqsQgyy0s
   XIyC8lAvYx14ncW2FT25Tk/+gRmaStnyCSvpoxUMDyiy3dm0MExv0phSX
   PiAZ9dEEvJkKO9Cq3KywNKzFtwWrQavqCq36RHCd20KfhqXVkgFUjykEQ
   eUhLyGAh6v4TNvGqk/dUtpNLAfY/JCm76Efya7onLzojRGN8QOPl+nYdI
   Q7S6iBXv8xyLG+idSsyBiMWigmiFUqEyadc/Qs41/JWOHC+1tpHOXE0rT
   Q==;
X-CSE-ConnectionGUID: x7xNiWjMQiePhCnT8TuCzQ==
X-CSE-MsgGUID: 0r6J6lfmTO+cEmDnbRNK4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11332"; a="64261042"
X-IronPort-AV: E=Sophos;i="6.13,248,1732608000"; 
   d="scan'208";a="64261042"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2025 05:44:13 -0800
X-CSE-ConnectionGUID: mAOG6B2yQ6KpL4JBtHC8Lg==
X-CSE-MsgGUID: nD3E8qP5RFyLYMD7BZDhDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="132889101"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 31 Jan 2025 05:44:12 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tdrJa-000mQv-09;
	Fri, 31 Jan 2025 13:44:10 +0000
Date: Fri, 31 Jan 2025 21:43:23 +0800
From: kernel test robot <lkp@intel.com>
To: Kai Huang <kai.huang@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, kvm@vger.kernel.org,
	Farrah Chen <farrah.chen@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [kvm:kvm-coco-queue-20250129 43/129] include/linux/init.h:319:27:
 error: redefinition of '__exitcall_vt_exit'
Message-ID: <202501312122.IIuMSJu4-lkp@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git kvm-coco-queue-20250129
head:   0bc4f452607db4e7eee4d3056cd6ec98636260bc
commit: 4b55a8f7c5f508fe1dd0005aecc81bbb5676aaec [43/129] KVM: VMX: Refactor VMX module init/exit functions
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20250131/202501312122.IIuMSJu4-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250131/202501312122.IIuMSJu4-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501312122.IIuMSJu4-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from include/linux/moduleparam.h:5,
                    from arch/x86/kvm/vmx/main.c:2:
   arch/x86/kvm/vmx/main.c:176:13: error: 'vt_exit' undeclared here (not in a function); did you mean 'vmx_exit'?
     176 | module_exit(vt_exit);
         |             ^~~~~~~
   include/linux/init.h:319:57: note: in definition of macro '__exitcall'
     319 |         static exitcall_t __exitcall_##fn __exit_call = fn
         |                                                         ^~
   arch/x86/kvm/vmx/main.c:176:1: note: in expansion of macro 'module_exit'
     176 | module_exit(vt_exit);
         | ^~~~~~~~~~~
>> include/linux/init.h:319:27: error: redefinition of '__exitcall_vt_exit'
     319 |         static exitcall_t __exitcall_##fn __exit_call = fn
         |                           ^~~~~~~~~~~
   include/linux/module.h:100:25: note: in expansion of macro '__exitcall'
     100 | #define module_exit(x)  __exitcall(x);
         |                         ^~~~~~~~~~
   arch/x86/kvm/vmx/main.c:183:1: note: in expansion of macro 'module_exit'
     183 | module_exit(vt_exit);
         | ^~~~~~~~~~~
   include/linux/init.h:319:27: note: previous definition of '__exitcall_vt_exit' with type 'exitcall_t' {aka 'void (*)(void)'}
     319 |         static exitcall_t __exitcall_##fn __exit_call = fn
         |                           ^~~~~~~~~~~
   include/linux/module.h:100:25: note: in expansion of macro '__exitcall'
     100 | #define module_exit(x)  __exitcall(x);
         |                         ^~~~~~~~~~
   arch/x86/kvm/vmx/main.c:176:1: note: in expansion of macro 'module_exit'
     176 | module_exit(vt_exit);
         | ^~~~~~~~~~~


vim +/__exitcall_vt_exit +319 include/linux/init.h

^1da177e4c3f41 Linus Torvalds 2005-04-16  317  
^1da177e4c3f41 Linus Torvalds 2005-04-16  318  #define __exitcall(fn)						\
^1da177e4c3f41 Linus Torvalds 2005-04-16 @319  	static exitcall_t __exitcall_##fn __exit_call = fn
^1da177e4c3f41 Linus Torvalds 2005-04-16  320  

:::::: The code at line 319 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

