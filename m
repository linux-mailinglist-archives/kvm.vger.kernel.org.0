Return-Path: <kvm+bounces-70267-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CIzRIWOYg2lnpwMAu9opvQ
	(envelope-from <kvm+bounces-70267-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 20:05:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0964EEBDA2
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 20:05:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 68C0C3015A5B
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 19:04:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5784142848E;
	Wed,  4 Feb 2026 19:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TWH4g7e2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 295B9427A16;
	Wed,  4 Feb 2026 19:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770231879; cv=none; b=Dg2n+/US4Qa6cEegU081oTb8HL4IJtUqAm87VKT+0Q5EHEVIjKxf/ed2ZgRWc7/vXtZQceS7f2YmHgzV7gXJiOnn0R9K/cYF/9C1KrRDQNxKIhCQMNgAzkfvrD2Gm2IPXuUoeN59307AcWjkzdpugUZOXzqAV+T5tcvVan2eyps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770231879; c=relaxed/simple;
	bh=aEgivNh6lf5umyGVj1PNqoU0kduEbNPMta4Z0lh4ySg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sf8ZnkYLymAZLP10XHJmAvcASfUZEBPEjViR6pQpwxVRZM2h0DRr0NwRDkZdO11QZjE2TgMLhuUMKiqYZ9ym56XNgkgepk2gzWDCEanNgMtDqk8FbAPONG1jt4h59z2Lqr3mf8l5muaGB140KMTPtr2MF3zy+0jEAx5Ad6eZZTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TWH4g7e2; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770231879; x=1801767879;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aEgivNh6lf5umyGVj1PNqoU0kduEbNPMta4Z0lh4ySg=;
  b=TWH4g7e2wARj848PC4LWL5mzbbjPYl0GYHOIH5N3gCI3ISx/lTzUgivf
   KYEr/S6Gkn54ecJe9LTN4DB+rPpv52PGBfzaBnAeH2IANVPqIRvyjjLTN
   huhhRMCWuBhzvWAdp5oxh9QWn9kpdSkRIOiunR0foec/4GIAlt/skKTK3
   7fW6Q3ylmhUK1Yf9Ev0Zp5KwzM0JvO3Pgg7+ZCU4B2zkvX3zJcY8eOb+P
   6lR9KDqUQtnZFI9GDv6z2pGoilT6B3Oy15Dy3jC1gSux4mS+PzWl5xdnf
   UwBulrz6M/pS9sF0rrm6/qezt7kCZzUcIKnN+WNkOjkLeKvMUydyKWHX2
   A==;
X-CSE-ConnectionGUID: wFC8v9W8SEOaEdNb443NzA==
X-CSE-MsgGUID: JYxSJhgGTtW++ttWBae2Qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82797734"
X-IronPort-AV: E=Sophos;i="6.21,273,1763452800"; 
   d="scan'208";a="82797734"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Feb 2026 11:04:38 -0800
X-CSE-ConnectionGUID: Fa3lG6CZSvagjstaQ6uPDA==
X-CSE-MsgGUID: tcXmNBmaQnSzW20DrV4KTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,273,1763452800"; 
   d="scan'208";a="233178785"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by fmviesa002.fm.intel.com with ESMTP; 04 Feb 2026 11:04:33 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vniAx-00000000j7U-08MJ;
	Wed, 04 Feb 2026 19:04:31 +0000
Date: Thu, 5 Feb 2026 03:03:32 +0800
From: kernel test robot <lkp@intel.com>
To: Zixing Liu <liushuyu@aosc.io>, WANG Xuerui <kernel@xen0n.name>,
	Huacai Chen <chenhuacai@kernel.org>, Bibo Mao <maobibo@loongson.cn>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Kexy Biscuit <kexybiscuit@aosc.io>, Mingcong Bai <jeffbai@aosc.io>,
	Zixing Liu <liushuyu@aosc.io>, Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	kvm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH v4] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
Message-ID: <202602050229.BAdKUB3a-lkp@intel.com>
References: <20260204113601.912413-1-liushuyu@aosc.io>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204113601.912413-1-liushuyu@aosc.io>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70267-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lkp@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 0964EEBDA2
X-Rspamd-Action: no action

Hi Zixing,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvm/next linus/master v6.19-rc8]
[cannot apply to kvm/linux-next next-20260204]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Zixing-Liu/KVM-Add-KVM_GET_REG_LIST-ioctl-for-LoongArch/20260204-193844
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20260204113601.912413-1-liushuyu%40aosc.io
patch subject: [PATCH v4] KVM: Add KVM_GET_REG_LIST ioctl for LoongArch
config: loongarch-defconfig (https://download.01.org/0day-ci/archive/20260205/202602050229.BAdKUB3a-lkp@intel.com/config)
compiler: clang version 19.1.7 (https://github.com/llvm/llvm-project cd708029e0b2869e80abe31ddb175f7c35361f90)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260205/202602050229.BAdKUB3a-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602050229.BAdKUB3a-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   In file included from arch/loongarch/kvm/vcpu.c:6:
   In file included from arch/loongarch/include/asm/kvm_host.h:21:
   In file included from arch/loongarch/include/asm/kvm_mmu.h:9:
>> include/linux/kvm_host.h:389:23: error: field has incomplete type 'struct kvm_vcpu_arch'
     389 |         struct kvm_vcpu_arch arch;
         |                              ^
   include/linux/kvm_host.h:389:9: note: forward declaration of 'struct kvm_vcpu_arch'
     389 |         struct kvm_vcpu_arch arch;
         |                ^
>> include/linux/kvm_host.h:390:23: error: field has incomplete type 'struct kvm_vcpu_stat'
     390 |         struct kvm_vcpu_stat stat;
         |                              ^
   include/linux/kvm_host.h:390:9: note: forward declaration of 'struct kvm_vcpu_stat'
     390 |         struct kvm_vcpu_stat stat;
         |                ^
>> include/linux/kvm_host.h:601:30: error: field has incomplete type 'struct kvm_arch_memory_slot'
     601 |         struct kvm_arch_memory_slot arch;
         |                                     ^
   include/linux/kvm_host.h:601:9: note: forward declaration of 'struct kvm_arch_memory_slot'
     601 |         struct kvm_arch_memory_slot arch;
         |                ^
>> include/linux/kvm_host.h:831:21: error: field has incomplete type 'struct kvm_vm_stat'
     831 |         struct kvm_vm_stat stat;
         |                            ^
   include/linux/kvm_host.h:831:9: note: forward declaration of 'struct kvm_vm_stat'
     831 |         struct kvm_vm_stat stat;
         |                ^
>> include/linux/kvm_host.h:832:18: error: field has incomplete type 'struct kvm_arch'
     832 |         struct kvm_arch arch;
         |                         ^
   include/linux/kvm_host.h:832:9: note: forward declaration of 'struct kvm_arch'
     832 |         struct kvm_arch arch;
         |                ^
>> include/linux/kvm_host.h:1023:11: error: use of undeclared identifier 'KVM_MAX_VCPUS'
    1023 |         if (id < KVM_MAX_VCPUS)
         |                  ^
   In file included from arch/loongarch/kvm/vcpu.c:6:
>> arch/loongarch/include/asm/kvm_host.h:46:9: warning: 'KVM_DIRTY_LOG_MANUAL_CAPS' macro redefined [-Wmacro-redefined]
      46 | #define KVM_DIRTY_LOG_MANUAL_CAPS       \
         |         ^
   include/linux/kvm_host.h:643:9: note: previous definition is here
     643 | #define KVM_DIRTY_LOG_MANUAL_CAPS KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE
         |         ^
>> arch/loongarch/kvm/vcpu.c:48:10: error: assigning to 'struct kvm_context *' from incompatible type 'void'
      48 |         context = this_cpu_ptr(vcpu->kvm->arch.vmcs);
         |                 ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/vcpu.c:63:10: error: assigning to 'struct kvm_context *' from incompatible type 'void'
      63 |         context = this_cpu_ptr(vcpu->kvm->arch.vmcs);
         |                 ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/vcpu.c:1669:11: error: assigning to 'struct kvm_context *' from incompatible type 'void'
    1669 |                 context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
         |                         ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   arch/loongarch/kvm/vcpu.c:1691:10: error: assigning to 'struct kvm_context *' from incompatible type 'void'
    1691 |         context = per_cpu_ptr(vcpu->kvm->arch.vmcs, cpu);
         |                 ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   1 warning and 10 errors generated.


vim +389 include/linux/kvm_host.h

af585b921e5d1e include/linux/kvm_host.h Gleb Natapov        2010-10-14  372  
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  373  #ifdef CONFIG_HAVE_KVM_CPU_RELAX_INTERCEPT
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  374  	/*
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  375  	 * Cpu relax intercept or pause loop exit optimization
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  376  	 * in_spin_loop: set when a vcpu does a pause loop exit
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  377  	 *  or cpu relax intercepted.
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  378  	 * dy_eligible: indicates whether vcpu is eligible for directed yield.
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  379  	 */
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  380  	struct {
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  381  		bool in_spin_loop;
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  382  		bool dy_eligible;
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  383  	} spin_loop;
4c088493c8d07e include/linux/kvm_host.h Raghavendra K T     2012-07-18  384  #endif
a6816314af5749 include/linux/kvm_host.h David Matlack       2024-05-03  385  	bool wants_to_run;
3a08a8f9f0936e include/linux/kvm_host.h Raghavendra K T     2013-03-04  386  	bool preempted;
d73eb57b80b98a include/linux/kvm_host.h Wanpeng Li          2019-07-18  387  	bool ready;
d1ae567fb8b559 include/linux/kvm_host.h Sean Christopherson 2024-05-21  388  	bool scheduled_out;
d657a98e3c2053 drivers/kvm/kvm.h        Zhang Xiantao       2007-12-14 @389  	struct kvm_vcpu_arch arch;
ce55c049459cff include/linux/kvm_host.h Jing Zhang          2021-06-18 @390  	struct kvm_vcpu_stat stat;
ce55c049459cff include/linux/kvm_host.h Jing Zhang          2021-06-18  391  	char stats_id[KVM_STATS_NAME_SIZE];
fb04a1eddb1a65 include/linux/kvm_host.h Peter Xu            2020-09-30  392  	struct kvm_dirty_ring dirty_ring;
fe22ed827c5b60 include/linux/kvm_host.h David Matlack       2021-08-04  393  
fe22ed827c5b60 include/linux/kvm_host.h David Matlack       2021-08-04  394  	/*
a54d806688fe1e include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  395  	 * The most recently used memslot by this vCPU and the slots generation
a54d806688fe1e include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  396  	 * for which it is valid.
a54d806688fe1e include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  397  	 * No wraparound protection is needed since generations won't overflow in
a54d806688fe1e include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  398  	 * thousands of years, even assuming 1M memslot operations per second.
fe22ed827c5b60 include/linux/kvm_host.h David Matlack       2021-08-04  399  	 */
a54d806688fe1e include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  400  	struct kvm_memory_slot *last_used_slot;
a54d806688fe1e include/linux/kvm_host.h Maciej S. Szmigiero 2021-12-06  401  	u64 last_used_slot_gen;
d657a98e3c2053 drivers/kvm/kvm.h        Zhang Xiantao       2007-12-14  402  };
d657a98e3c2053 drivers/kvm/kvm.h        Zhang Xiantao       2007-12-14  403  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

