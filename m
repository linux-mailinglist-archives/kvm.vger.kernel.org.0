Return-Path: <kvm+bounces-20508-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FDD89174CF
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 01:39:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D2A251F22CC4
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 23:39:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CD9C17F39B;
	Tue, 25 Jun 2024 23:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AmDgpYC+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FF01494A3
	for <kvm@vger.kernel.org>; Tue, 25 Jun 2024 23:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358747; cv=none; b=K+AZecq0/4OpiSnu8rCQue3bxnznTrjvjVr/iiJov8olaIp823PWIkoFVHNtxoaW/eiPmRt4mj+DesKrPp4rMLCunY4sXMyJxie4oOJ5ZLoGtg7a7DAA1LGIvp5cZBv18tR4TLzODt4n8PqpP4eFFdbXIM5V2Xg1Tvegq1RFwDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358747; c=relaxed/simple;
	bh=c5S+PvYFw1THnX/NR5WSr2hpTWmvbJcAaqBG5TNgCXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VjFz+eWOKPOZ43rGN6wmEU2De5ZSslHG/5Jqs0i6s/JBiE57yew12Lfa/mW4yTzjfo10TAq0HCBvKA55awileiykbi4X9azvWA6Th/80aevpkL2YS9GTa6nHpU7IjEHil8J1nTpYnB0AN6iT7qeoT5yg4gkTKvoMVSW/TK+txzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AmDgpYC+; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719358746; x=1750894746;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c5S+PvYFw1THnX/NR5WSr2hpTWmvbJcAaqBG5TNgCXg=;
  b=AmDgpYC+hefFUml3fROQvUigt/dqq3ftQ8MCe/sO9kF1BBTjAYp92tcC
   Smpi/Egbeu3y4RJHn0ChZ1upB6iBejHWlkSYRcxiaMPph0uGVbpIhso8g
   0drgkFlCE5/noE09CeNCZdR+3tay+LA6+XuLj6nGuJZiub/V4zUY96V7Q
   RezZ49ZGHoWZzNIjBEj3+EbSBq9m/zcgwu9vMQby8ua6wpLoDp0JQbkLg
   7wVi9njl2HS2YMh49JLeR0dXtrI54LNWOx6An2hKZcET0l3FmgLxjnt1X
   ENVuaUhF7aS3Vc31I5IMLtVgWYYvQ0kuTdpNWaDv8kaNcIRHFDd9XRZ5W
   w==;
X-CSE-ConnectionGUID: RcuSyL6ZSsOdH1qM3D8hbg==
X-CSE-MsgGUID: y5HDr6JYQKS12/p3tJs4jQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16634592"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="16634592"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 16:39:06 -0700
X-CSE-ConnectionGUID: ionq9pMKQnO6zgpYneVJdg==
X-CSE-MsgGUID: IFCBErGKT4aHx7my7C92Gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="44523719"
Received: from lkp-server01.sh.intel.com (HELO 68891e0c336b) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 25 Jun 2024 16:39:05 -0700
Received: from kbuild by 68891e0c336b with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sMFkb-000EoO-1E;
	Tue, 25 Jun 2024 23:39:01 +0000
Date: Wed, 26 Jun 2024 07:38:07 +0800
From: kernel test robot <lkp@intel.com>
To: Jim Mattson <jmattson@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86: Complain about an attempt to change the APIC
 base address
Message-ID: <202406260749.ZqcsICau-lkp@intel.com>
References: <20240621224946.4083742-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621224946.4083742-1-jmattson@google.com>

Hi Jim,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on linus/master v6.10-rc5 next-20240625]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Jim-Mattson/KVM-x86-Complain-about-an-attempt-to-change-the-APIC-base-address/20240625-181629
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20240621224946.4083742-1-jmattson%40google.com
patch subject: [PATCH] KVM: x86: Complain about an attempt to change the APIC base address
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20240626/202406260749.ZqcsICau-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240626/202406260749.ZqcsICau-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202406260749.ZqcsICau-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/lapic.c:2587:8: warning: format specifies type 'unsigned long long' but the argument has type 'unsigned long' [-Wformat]
    2586 |                 vcpu_unimpl(vcpu, "APIC base %#llx is not %#llx",
         |                                              ~~~~~
         |                                              %#lx
    2587 |                             apic->base_address, APIC_DEFAULT_PHYS_BASE);
         |                             ^~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:861:44: note: expanded from macro 'vcpu_unimpl'
     860 |         kvm_pr_unimpl("vcpu%i, guest rIP: 0x%lx " fmt,                  \
         |                                                   ~~~
     861 |                         (vcpu)->vcpu_id, kvm_rip_read(vcpu), ## __VA_ARGS__)
         |                                                                 ^~~~~~~~~~~
   include/linux/kvm_host.h:856:33: note: expanded from macro 'kvm_pr_unimpl'
     855 |         pr_err_ratelimited("kvm [%i]: " fmt, \
         |                                         ~~~
     856 |                            task_tgid_nr(current), ## __VA_ARGS__)
         |                                                      ^~~~~~~~~~~
   include/linux/printk.h:672:45: note: expanded from macro 'pr_err_ratelimited'
     672 |         printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                                            ~~~     ^~~~~~~~~~~
   include/linux/printk.h:658:17: note: expanded from macro 'printk_ratelimited'
     658 |                 printk(fmt, ##__VA_ARGS__);                             \
         |                        ~~~    ^~~~~~~~~~~
   include/linux/printk.h:464:60: note: expanded from macro 'printk'
     464 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:436:19: note: expanded from macro 'printk_index_wrap'
     436 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
>> arch/x86/kvm/lapic.c:2587:28: warning: format specifies type 'unsigned long long' but the argument has type 'unsigned int' [-Wformat]
    2586 |                 vcpu_unimpl(vcpu, "APIC base %#llx is not %#llx",
         |                                                           ~~~~~
         |                                                           %#x
    2587 |                             apic->base_address, APIC_DEFAULT_PHYS_BASE);
         |                                                 ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/kvm_host.h:861:44: note: expanded from macro 'vcpu_unimpl'
     860 |         kvm_pr_unimpl("vcpu%i, guest rIP: 0x%lx " fmt,                  \
         |                                                   ~~~
     861 |                         (vcpu)->vcpu_id, kvm_rip_read(vcpu), ## __VA_ARGS__)
         |                                                                 ^~~~~~~~~~~
   include/linux/kvm_host.h:856:33: note: expanded from macro 'kvm_pr_unimpl'
     855 |         pr_err_ratelimited("kvm [%i]: " fmt, \
         |                                         ~~~
     856 |                            task_tgid_nr(current), ## __VA_ARGS__)
         |                                                      ^~~~~~~~~~~
   include/linux/printk.h:672:45: note: expanded from macro 'pr_err_ratelimited'
     672 |         printk_ratelimited(KERN_ERR pr_fmt(fmt), ##__VA_ARGS__)
         |                                            ~~~     ^~~~~~~~~~~
   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limit=0 to see all)
   include/linux/printk.h:464:60: note: expanded from macro 'printk'
     464 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
         |                                                     ~~~    ^~~~~~~~~~~
   include/linux/printk.h:436:19: note: expanded from macro 'printk_index_wrap'
     436 |                 _p_func(_fmt, ##__VA_ARGS__);                           \
         |                         ~~~~    ^~~~~~~~~~~
   arch/x86/include/asm/apicdef.h:15:33: note: expanded from macro 'APIC_DEFAULT_PHYS_BASE'
      15 | #define APIC_DEFAULT_PHYS_BASE          0xfee00000
         |                                         ^~~~~~~~~~
   2 warnings generated.


vim +2587 arch/x86/kvm/lapic.c

  2542	
  2543	void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value)
  2544	{
  2545		u64 old_value = vcpu->arch.apic_base;
  2546		struct kvm_lapic *apic = vcpu->arch.apic;
  2547	
  2548		vcpu->arch.apic_base = value;
  2549	
  2550		if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE)
  2551			kvm_update_cpuid_runtime(vcpu);
  2552	
  2553		if (!apic)
  2554			return;
  2555	
  2556		/* update jump label if enable bit changes */
  2557		if ((old_value ^ value) & MSR_IA32_APICBASE_ENABLE) {
  2558			if (value & MSR_IA32_APICBASE_ENABLE) {
  2559				kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
  2560				static_branch_slow_dec_deferred(&apic_hw_disabled);
  2561				/* Check if there are APF page ready requests pending */
  2562				kvm_make_request(KVM_REQ_APF_READY, vcpu);
  2563			} else {
  2564				static_branch_inc(&apic_hw_disabled.key);
  2565				atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
  2566			}
  2567		}
  2568	
  2569		if ((old_value ^ value) & X2APIC_ENABLE) {
  2570			if (value & X2APIC_ENABLE)
  2571				kvm_apic_set_x2apic_id(apic, vcpu->vcpu_id);
  2572			else if (value & MSR_IA32_APICBASE_ENABLE)
  2573				kvm_apic_set_xapic_id(apic, vcpu->vcpu_id);
  2574		}
  2575	
  2576		if ((old_value ^ value) & (MSR_IA32_APICBASE_ENABLE | X2APIC_ENABLE)) {
  2577			kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
  2578			static_call_cond(kvm_x86_set_virtual_apic_mode)(vcpu);
  2579		}
  2580	
  2581		apic->base_address = apic->vcpu->arch.apic_base &
  2582				     MSR_IA32_APICBASE_BASE;
  2583	
  2584		if ((value & MSR_IA32_APICBASE_ENABLE) &&
  2585		     apic->base_address != APIC_DEFAULT_PHYS_BASE) {
  2586			vcpu_unimpl(vcpu, "APIC base %#llx is not %#llx",
> 2587				    apic->base_address, APIC_DEFAULT_PHYS_BASE);
  2588			kvm_set_apicv_inhibit(apic->vcpu->kvm,
  2589					      APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
  2590		}
  2591	}
  2592	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

