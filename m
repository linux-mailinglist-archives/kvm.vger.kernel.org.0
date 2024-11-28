Return-Path: <kvm+bounces-32747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 560849DB903
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 14:42:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7AA8CB20C5B
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 13:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7BCA1AA786;
	Thu, 28 Nov 2024 13:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ad1ocinq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8B219CD01;
	Thu, 28 Nov 2024 13:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732801315; cv=none; b=sh1fRMY59a/uL1SzruRzjP+a5HWh1YpaIF3aJZIOTfmXpEUrxfU20ZxTz5ANx8/LGnghO31RNnEpg07QFqJfNl/UfYUZBjJ6Dr2DFd1w5DdAOn+uKeX3EKD2tFCt9874HubagZ3xLACOt4lyQUvwt+a7QjGaAft4QoCEfsj3UHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732801315; c=relaxed/simple;
	bh=CoeNok1JJKZZVY9DJx2xNqK5OkyHWdXN60Hs1ewINYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rgRAYM+l6RR8dN8hfEYvXtbNeMlwfLUa/og4LJ73p/xyIFrN6hfhLLF18B3Dzg8MNcSmVY8zbr64eM8SfyBSwgI1PglX/sthaT+M2+9ytyO7CixeLoYR0D/1SiuyGfbTFL02Crymv/QpeVGGbpXxuxHs8unXi/XpqleFKtUXUU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ad1ocinq; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732801313; x=1764337313;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CoeNok1JJKZZVY9DJx2xNqK5OkyHWdXN60Hs1ewINYA=;
  b=ad1ocinqKuaNDewXqhW/MKRZKhXUpW+9bUi6afmUL9jWnkqZch2pDDYN
   Vln4Jg5LaQpg3rFsaIi87vp7O7sUa+XZ2ZSyYbVZm1eCA44wthWqwRmae
   KcndVCCKkwx0XwL8LDbyNJtGnwByHVbMLb6VjbGKQ0QdT5BFpILJi+sCa
   dr+qDG79afqV7jtoBJQ3Ob6gHanZVpPBr3HzA+M6M3buuezebKG//QYmP
   UC6GTax53gj8h3cgORziv9HRssgHlHML/dlyJJ3uZb6T++fmrt2py7Sj8
   g02n6TJrprBg4zICFoEfQHGwFCa72D4G9u1/odNccGjdtosj+FbW0gI6i
   A==;
X-CSE-ConnectionGUID: Sl4jW/YWTuyKw4+KI2iVsQ==
X-CSE-MsgGUID: FD9RaLZRTYif0MFM4/q4pQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11270"; a="36964267"
X-IronPort-AV: E=Sophos;i="6.12,192,1728975600"; 
   d="scan'208";a="36964267"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2024 05:41:52 -0800
X-CSE-ConnectionGUID: oZeyx57GQdmV2b171QQHXA==
X-CSE-MsgGUID: Ft4thJbZTCGRZ/HpA8MDKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,192,1728975600"; 
   d="scan'208";a="92410279"
Received: from lkp-server01.sh.intel.com (HELO 8122d2fc1967) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 28 Nov 2024 05:41:49 -0800
Received: from kbuild by 8122d2fc1967 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tGemB-0009cp-0o;
	Thu, 28 Nov 2024 13:41:47 +0000
Date: Thu, 28 Nov 2024 21:41:42 +0800
From: kernel test robot <lkp@intel.com>
To: Melody Wang <huibo.wang@amd.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Neeraj Upadhyay <neeraj.upadhyay@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Melody Wang <huibo.wang@amd.com>
Subject: Re: [PATCH v3 5/7] KVM: SVM: Inject MCEs when restricted injection
 is active
Message-ID: <202411282157.6f84J7Wh-lkp@intel.com>
References: <20241127225539.5567-6-huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241127225539.5567-6-huibo.wang@amd.com>

Hi Melody,

kernel test robot noticed the following build warnings:

[auto build test WARNING on kvm/queue]
[also build test WARNING on mst-vhost/linux-next tip/x86/core linus/master v6.12 next-20241128]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Melody-Wang/x86-sev-Define-the-HV-doorbell-page-structure/20241128-122321
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20241127225539.5567-6-huibo.wang%40amd.com
patch subject: [PATCH v3 5/7] KVM: SVM: Inject MCEs when restricted injection is active
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20241128/202411282157.6f84J7Wh-lkp@intel.com/config)
compiler: clang version 19.1.3 (https://github.com/llvm/llvm-project ab51eccf88f5321e7c60591c5546b254b6afab99)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241128/202411282157.6f84J7Wh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202411282157.6f84J7Wh-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/x86/kvm/x86.c:20:
   In file included from include/linux/kvm_host.h:16:
   In file included from include/linux/mm.h:2213:
   include/linux/vmstat.h:504:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     504 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     505 |                            item];
         |                            ~~~~
   include/linux/vmstat.h:511:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     511 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     512 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
   include/linux/vmstat.h:518:36: warning: arithmetic between different enumeration types ('enum node_stat_item' and 'enum lru_list') [-Wenum-enum-conversion]
     518 |         return node_stat_name(NR_LRU_BASE + lru) + 3; // skip "nr_"
         |                               ~~~~~~~~~~~ ^ ~~~
   include/linux/vmstat.h:524:43: warning: arithmetic between different enumeration types ('enum zone_stat_item' and 'enum numa_stat_item') [-Wenum-enum-conversion]
     524 |         return vmstat_text[NR_VM_ZONE_STAT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~ ^
     525 |                            NR_VM_NUMA_EVENT_ITEMS +
         |                            ~~~~~~~~~~~~~~~~~~~~~~
>> arch/x86/kvm/x86.c:10373:2: warning: label at end of compound statement is a C23 extension [-Wc23-extensions]
    10373 |         }
          |         ^
   5 warnings generated.


vim +10373 arch/x86/kvm/x86.c

b97f074583736c Maxim Levitsky      2021-02-25  10214  
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10215  /*
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10216   * Check for any event (interrupt or exception) that is ready to be injected,
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10217   * and if there is at least one event, inject the event with the highest
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10218   * priority.  This handles both "pending" events, i.e. events that have never
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10219   * been injected into the guest, and "injected" events, i.e. events that were
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10220   * injected as part of a previous VM-Enter, but weren't successfully delivered
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10221   * and need to be re-injected.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10222   *
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10223   * Note, this is not guaranteed to be invoked on a guest instruction boundary,
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10224   * i.e. doesn't guarantee that there's an event window in the guest.  KVM must
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10225   * be able to inject exceptions in the "middle" of an instruction, and so must
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10226   * also be able to re-inject NMIs and IRQs in the middle of an instruction.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10227   * I.e. for exceptions and re-injected events, NOT invoking this on instruction
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10228   * boundaries is necessary and correct.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10229   *
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10230   * For simplicity, KVM uses a single path to inject all events (except events
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10231   * that are injected directly from L1 to L2) and doesn't explicitly track
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10232   * instruction boundaries for asynchronous events.  However, because VM-Exits
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10233   * that can occur during instruction execution typically result in KVM skipping
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10234   * the instruction or injecting an exception, e.g. instruction and exception
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10235   * intercepts, and because pending exceptions have higher priority than pending
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10236   * interrupts, KVM still honors instruction boundaries in most scenarios.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10237   *
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10238   * But, if a VM-Exit occurs during instruction execution, and KVM does NOT skip
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10239   * the instruction or inject an exception, then KVM can incorrecty inject a new
54aa699e8094ef Bjorn Helgaas       2024-01-02  10240   * asynchronous event if the event became pending after the CPU fetched the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10241   * instruction (in the guest).  E.g. if a page fault (#PF, #NPF, EPT violation)
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10242   * occurs and is resolved by KVM, a coincident NMI, SMI, IRQ, etc... can be
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10243   * injected on the restarted instruction instead of being deferred until the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10244   * instruction completes.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10245   *
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10246   * In practice, this virtualization hole is unlikely to be observed by the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10247   * guest, and even less likely to cause functional problems.  To detect the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10248   * hole, the guest would have to trigger an event on a side effect of an early
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10249   * phase of instruction execution, e.g. on the instruction fetch from memory.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10250   * And for it to be a functional problem, the guest would need to depend on the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10251   * ordering between that side effect, the instruction completing, _and_ the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10252   * delivery of the asynchronous event.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10253   */
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10254  static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10255  				       bool *req_immediate_exit)
95ba82731374eb Gleb Natapov        2009-04-21  10256  {
28360f88706837 Sean Christopherson 2022-08-30  10257  	bool can_inject;
b6b8a1451fc404 Jan Kiszka          2014-03-07  10258  	int r;
b6b8a1451fc404 Jan Kiszka          2014-03-07  10259  
6c593b5276e6ce Sean Christopherson 2022-08-30  10260  	/*
54aa699e8094ef Bjorn Helgaas       2024-01-02  10261  	 * Process nested events first, as nested VM-Exit supersedes event
6c593b5276e6ce Sean Christopherson 2022-08-30  10262  	 * re-injection.  If there's an event queued for re-injection, it will
6c593b5276e6ce Sean Christopherson 2022-08-30  10263  	 * be saved into the appropriate vmc{b,s}12 fields on nested VM-Exit.
6c593b5276e6ce Sean Christopherson 2022-08-30  10264  	 */
6c593b5276e6ce Sean Christopherson 2022-08-30  10265  	if (is_guest_mode(vcpu))
6c593b5276e6ce Sean Christopherson 2022-08-30  10266  		r = kvm_check_nested_events(vcpu);
6c593b5276e6ce Sean Christopherson 2022-08-30  10267  	else
6c593b5276e6ce Sean Christopherson 2022-08-30  10268  		r = 0;
b59bb7bdf08ee9 Gleb Natapov        2009-07-09  10269  
664f8e26b00c76 Wanpeng Li          2017-08-24  10270  	/*
6c593b5276e6ce Sean Christopherson 2022-08-30  10271  	 * Re-inject exceptions and events *especially* if immediate entry+exit
6c593b5276e6ce Sean Christopherson 2022-08-30  10272  	 * to/from L2 is needed, as any event that has already been injected
6c593b5276e6ce Sean Christopherson 2022-08-30  10273  	 * into L2 needs to complete its lifecycle before injecting a new event.
6c593b5276e6ce Sean Christopherson 2022-08-30  10274  	 *
6c593b5276e6ce Sean Christopherson 2022-08-30  10275  	 * Don't re-inject an NMI or interrupt if there is a pending exception.
6c593b5276e6ce Sean Christopherson 2022-08-30  10276  	 * This collision arises if an exception occurred while vectoring the
6c593b5276e6ce Sean Christopherson 2022-08-30  10277  	 * injected event, KVM intercepted said exception, and KVM ultimately
6c593b5276e6ce Sean Christopherson 2022-08-30  10278  	 * determined the fault belongs to the guest and queues the exception
6c593b5276e6ce Sean Christopherson 2022-08-30  10279  	 * for injection back into the guest.
6c593b5276e6ce Sean Christopherson 2022-08-30  10280  	 *
6c593b5276e6ce Sean Christopherson 2022-08-30  10281  	 * "Injected" interrupts can also collide with pending exceptions if
6c593b5276e6ce Sean Christopherson 2022-08-30  10282  	 * userspace ignores the "ready for injection" flag and blindly queues
6c593b5276e6ce Sean Christopherson 2022-08-30  10283  	 * an interrupt.  In that case, prioritizing the exception is correct,
6c593b5276e6ce Sean Christopherson 2022-08-30  10284  	 * as the exception "occurred" before the exit to userspace.  Trap-like
6c593b5276e6ce Sean Christopherson 2022-08-30  10285  	 * exceptions, e.g. most #DBs, have higher priority than interrupts.
6c593b5276e6ce Sean Christopherson 2022-08-30  10286  	 * And while fault-like exceptions, e.g. #GP and #PF, are the lowest
6c593b5276e6ce Sean Christopherson 2022-08-30  10287  	 * priority, they're only generated (pended) during instruction
6c593b5276e6ce Sean Christopherson 2022-08-30  10288  	 * execution, and interrupts are recognized at instruction boundaries.
6c593b5276e6ce Sean Christopherson 2022-08-30  10289  	 * Thus a pending fault-like exception means the fault occurred on the
6c593b5276e6ce Sean Christopherson 2022-08-30  10290  	 * *previous* instruction and must be serviced prior to recognizing any
6c593b5276e6ce Sean Christopherson 2022-08-30  10291  	 * new events in order to fully complete the previous instruction.
6c593b5276e6ce Sean Christopherson 2022-08-30  10292  	 */
6c593b5276e6ce Sean Christopherson 2022-08-30  10293  	if (vcpu->arch.exception.injected)
b97f074583736c Maxim Levitsky      2021-02-25  10294  		kvm_inject_exception(vcpu);
7709aba8f71613 Sean Christopherson 2022-08-30  10295  	else if (kvm_is_exception_pending(vcpu))
6c593b5276e6ce Sean Christopherson 2022-08-30  10296  		; /* see above */
6c593b5276e6ce Sean Christopherson 2022-08-30  10297  	else if (vcpu->arch.nmi_injected)
896046474f8d2e Wei Wang            2024-05-07  10298  		kvm_x86_call(inject_nmi)(vcpu);
6c593b5276e6ce Sean Christopherson 2022-08-30  10299  	else if (vcpu->arch.interrupt.injected)
896046474f8d2e Wei Wang            2024-05-07  10300  		kvm_x86_call(inject_irq)(vcpu, true);
b6b8a1451fc404 Jan Kiszka          2014-03-07  10301  
6c593b5276e6ce Sean Christopherson 2022-08-30  10302  	/*
6c593b5276e6ce Sean Christopherson 2022-08-30  10303  	 * Exceptions that morph to VM-Exits are handled above, and pending
6c593b5276e6ce Sean Christopherson 2022-08-30  10304  	 * exceptions on top of injected exceptions that do not VM-Exit should
6c593b5276e6ce Sean Christopherson 2022-08-30  10305  	 * either morph to #DF or, sadly, override the injected exception.
6c593b5276e6ce Sean Christopherson 2022-08-30  10306  	 */
3b82b8d7fdf7c1 Sean Christopherson 2020-04-22  10307  	WARN_ON_ONCE(vcpu->arch.exception.injected &&
3b82b8d7fdf7c1 Sean Christopherson 2020-04-22  10308  		     vcpu->arch.exception.pending);
3b82b8d7fdf7c1 Sean Christopherson 2020-04-22  10309  
1a680e355c9477 Liran Alon          2018-03-23  10310  	/*
6c593b5276e6ce Sean Christopherson 2022-08-30  10311  	 * Bail if immediate entry+exit to/from the guest is needed to complete
6c593b5276e6ce Sean Christopherson 2022-08-30  10312  	 * nested VM-Enter or event re-injection so that a different pending
6c593b5276e6ce Sean Christopherson 2022-08-30  10313  	 * event can be serviced (or if KVM needs to exit to userspace).
6c593b5276e6ce Sean Christopherson 2022-08-30  10314  	 *
6c593b5276e6ce Sean Christopherson 2022-08-30  10315  	 * Otherwise, continue processing events even if VM-Exit occurred.  The
6c593b5276e6ce Sean Christopherson 2022-08-30  10316  	 * VM-Exit will have cleared exceptions that were meant for L2, but
6c593b5276e6ce Sean Christopherson 2022-08-30  10317  	 * there may now be events that can be injected into L1.
1a680e355c9477 Liran Alon          2018-03-23  10318  	 */
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10319  	if (r < 0)
a5f6909a71f922 Jim Mattson         2021-06-04  10320  		goto out;
95ba82731374eb Gleb Natapov        2009-04-21  10321  
7709aba8f71613 Sean Christopherson 2022-08-30  10322  	/*
7709aba8f71613 Sean Christopherson 2022-08-30  10323  	 * A pending exception VM-Exit should either result in nested VM-Exit
7709aba8f71613 Sean Christopherson 2022-08-30  10324  	 * or force an immediate re-entry and exit to/from L2, and exception
7709aba8f71613 Sean Christopherson 2022-08-30  10325  	 * VM-Exits cannot be injected (flag should _never_ be set).
7709aba8f71613 Sean Christopherson 2022-08-30  10326  	 */
7709aba8f71613 Sean Christopherson 2022-08-30  10327  	WARN_ON_ONCE(vcpu->arch.exception_vmexit.injected ||
7709aba8f71613 Sean Christopherson 2022-08-30  10328  		     vcpu->arch.exception_vmexit.pending);
7709aba8f71613 Sean Christopherson 2022-08-30  10329  
28360f88706837 Sean Christopherson 2022-08-30  10330  	/*
28360f88706837 Sean Christopherson 2022-08-30  10331  	 * New events, other than exceptions, cannot be injected if KVM needs
28360f88706837 Sean Christopherson 2022-08-30  10332  	 * to re-inject a previous event.  See above comments on re-injecting
28360f88706837 Sean Christopherson 2022-08-30  10333  	 * for why pending exceptions get priority.
28360f88706837 Sean Christopherson 2022-08-30  10334  	 */
28360f88706837 Sean Christopherson 2022-08-30  10335  	can_inject = !kvm_event_needs_reinjection(vcpu);
28360f88706837 Sean Christopherson 2022-08-30  10336  
664f8e26b00c76 Wanpeng Li          2017-08-24  10337  	if (vcpu->arch.exception.pending) {
5623f751bd9c43 Sean Christopherson 2022-08-30  10338  		/*
5623f751bd9c43 Sean Christopherson 2022-08-30  10339  		 * Fault-class exceptions, except #DBs, set RF=1 in the RFLAGS
5623f751bd9c43 Sean Christopherson 2022-08-30  10340  		 * value pushed on the stack.  Trap-like exception and all #DBs
5623f751bd9c43 Sean Christopherson 2022-08-30  10341  		 * leave RF as-is (KVM follows Intel's behavior in this regard;
5623f751bd9c43 Sean Christopherson 2022-08-30  10342  		 * AMD states that code breakpoint #DBs excplitly clear RF=0).
5623f751bd9c43 Sean Christopherson 2022-08-30  10343  		 *
5623f751bd9c43 Sean Christopherson 2022-08-30  10344  		 * Note, most versions of Intel's SDM and AMD's APM incorrectly
5623f751bd9c43 Sean Christopherson 2022-08-30  10345  		 * describe the behavior of General Detect #DBs, which are
5623f751bd9c43 Sean Christopherson 2022-08-30  10346  		 * fault-like.  They do _not_ set RF, a la code breakpoints.
5623f751bd9c43 Sean Christopherson 2022-08-30  10347  		 */
d4963e319f1f78 Sean Christopherson 2022-08-30  10348  		if (exception_type(vcpu->arch.exception.vector) == EXCPT_FAULT)
664f8e26b00c76 Wanpeng Li          2017-08-24  10349  			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
664f8e26b00c76 Wanpeng Li          2017-08-24  10350  					     X86_EFLAGS_RF);
664f8e26b00c76 Wanpeng Li          2017-08-24  10351  
d4963e319f1f78 Sean Christopherson 2022-08-30  10352  		if (vcpu->arch.exception.vector == DB_VECTOR) {
d4963e319f1f78 Sean Christopherson 2022-08-30  10353  			kvm_deliver_exception_payload(vcpu, &vcpu->arch.exception);
f10c729ff96528 Jim Mattson         2018-10-16  10354  			if (vcpu->arch.dr7 & DR7_GD) {
664f8e26b00c76 Wanpeng Li          2017-08-24  10355  				vcpu->arch.dr7 &= ~DR7_GD;
664f8e26b00c76 Wanpeng Li          2017-08-24  10356  				kvm_update_dr7(vcpu);
664f8e26b00c76 Wanpeng Li          2017-08-24  10357  			}
f10c729ff96528 Jim Mattson         2018-10-16  10358  		}
664f8e26b00c76 Wanpeng Li          2017-08-24  10359  
8b59e4b9d4bdfd Melody Wang         2024-11-27  10360  		if (vcpu->arch.exception.vector == MC_VECTOR) {
8b59e4b9d4bdfd Melody Wang         2024-11-27  10361  			r = static_call(kvm_x86_mce_allowed)(vcpu);
8b59e4b9d4bdfd Melody Wang         2024-11-27  10362  			if (!r)
8b59e4b9d4bdfd Melody Wang         2024-11-27  10363  				goto out_except;
8b59e4b9d4bdfd Melody Wang         2024-11-27  10364  		}
8b59e4b9d4bdfd Melody Wang         2024-11-27  10365  
b97f074583736c Maxim Levitsky      2021-02-25  10366  		kvm_inject_exception(vcpu);
a61d7c5432ac5a Sean Christopherson 2022-05-02  10367  
a61d7c5432ac5a Sean Christopherson 2022-05-02  10368  		vcpu->arch.exception.pending = false;
a61d7c5432ac5a Sean Christopherson 2022-05-02  10369  		vcpu->arch.exception.injected = true;
a61d7c5432ac5a Sean Christopherson 2022-05-02  10370  
c6b22f59d694d0 Paolo Bonzini       2020-05-26  10371  		can_inject = false;
8b59e4b9d4bdfd Melody Wang         2024-11-27  10372  out_except:
1a680e355c9477 Liran Alon          2018-03-23 @10373  	}
1a680e355c9477 Liran Alon          2018-03-23  10374  
61e5f69ef08379 Maxim Levitsky      2021-08-11  10375  	/* Don't inject interrupts if the user asked to avoid doing so */
61e5f69ef08379 Maxim Levitsky      2021-08-11  10376  	if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ)
61e5f69ef08379 Maxim Levitsky      2021-08-11  10377  		return 0;
61e5f69ef08379 Maxim Levitsky      2021-08-11  10378  
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10379  	/*
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10380  	 * Finally, inject interrupt events.  If an event cannot be injected
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10381  	 * due to architectural conditions (e.g. IF=0) a window-open exit
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10382  	 * will re-request KVM_REQ_EVENT.  Sometimes however an event is pending
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10383  	 * and can architecturally be injected, but we cannot do it right now:
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10384  	 * an interrupt could have arrived just now and we have to inject it
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10385  	 * as a vmexit, or there could already an event in the queue, which is
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10386  	 * indicated by can_inject.  In that case we request an immediate exit
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10387  	 * in order to make progress and get back here for another iteration.
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10388  	 * The kvm_x86_ops hooks communicate this by returning -EBUSY.
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10389  	 */
31e83e21cf00fe Paolo Bonzini       2022-09-29  10390  #ifdef CONFIG_KVM_SMM
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10391  	if (vcpu->arch.smi_pending) {
896046474f8d2e Wei Wang            2024-05-07  10392  		r = can_inject ? kvm_x86_call(smi_allowed)(vcpu, true) :
896046474f8d2e Wei Wang            2024-05-07  10393  				 -EBUSY;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10394  		if (r < 0)
a5f6909a71f922 Jim Mattson         2021-06-04  10395  			goto out;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10396  		if (r) {
c43203cab1e2e1 Paolo Bonzini       2016-06-01  10397  			vcpu->arch.smi_pending = false;
52797bf9a875c4 Liran Alon          2017-11-15  10398  			++vcpu->arch.smi_count;
ee2cd4b7555e3a Paolo Bonzini       2016-06-01  10399  			enter_smm(vcpu);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10400  			can_inject = false;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10401  		} else
896046474f8d2e Wei Wang            2024-05-07  10402  			kvm_x86_call(enable_smi_window)(vcpu);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10403  	}
31e83e21cf00fe Paolo Bonzini       2022-09-29  10404  #endif
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10405  
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10406  	if (vcpu->arch.nmi_pending) {
896046474f8d2e Wei Wang            2024-05-07  10407  		r = can_inject ? kvm_x86_call(nmi_allowed)(vcpu, true) :
896046474f8d2e Wei Wang            2024-05-07  10408  				 -EBUSY;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10409  		if (r < 0)
a5f6909a71f922 Jim Mattson         2021-06-04  10410  			goto out;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10411  		if (r) {
7460fb4a340033 Avi Kivity          2011-09-20  10412  			--vcpu->arch.nmi_pending;
95ba82731374eb Gleb Natapov        2009-04-21  10413  			vcpu->arch.nmi_injected = true;
896046474f8d2e Wei Wang            2024-05-07  10414  			kvm_x86_call(inject_nmi)(vcpu);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10415  			can_inject = false;
896046474f8d2e Wei Wang            2024-05-07  10416  			WARN_ON(kvm_x86_call(nmi_allowed)(vcpu, true) < 0);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10417  		}
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10418  		if (vcpu->arch.nmi_pending)
896046474f8d2e Wei Wang            2024-05-07  10419  			kvm_x86_call(enable_nmi_window)(vcpu);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10420  	}
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10421  
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10422  	if (kvm_cpu_has_injectable_intr(vcpu)) {
896046474f8d2e Wei Wang            2024-05-07  10423  		r = can_inject ? kvm_x86_call(interrupt_allowed)(vcpu, true) :
896046474f8d2e Wei Wang            2024-05-07  10424  				 -EBUSY;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10425  		if (r < 0)
a5f6909a71f922 Jim Mattson         2021-06-04  10426  			goto out;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10427  		if (r) {
bf672720e83cf0 Maxim Levitsky      2023-07-26  10428  			int irq = kvm_cpu_get_interrupt(vcpu);
bf672720e83cf0 Maxim Levitsky      2023-07-26  10429  
bf672720e83cf0 Maxim Levitsky      2023-07-26  10430  			if (!WARN_ON_ONCE(irq == -1)) {
bf672720e83cf0 Maxim Levitsky      2023-07-26  10431  				kvm_queue_interrupt(vcpu, irq, false);
896046474f8d2e Wei Wang            2024-05-07  10432  				kvm_x86_call(inject_irq)(vcpu, false);
896046474f8d2e Wei Wang            2024-05-07  10433  				WARN_ON(kvm_x86_call(interrupt_allowed)(vcpu, true) < 0);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10434  			}
bf672720e83cf0 Maxim Levitsky      2023-07-26  10435  		}
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10436  		if (kvm_cpu_has_injectable_intr(vcpu))
896046474f8d2e Wei Wang            2024-05-07  10437  			kvm_x86_call(enable_irq_window)(vcpu);
95ba82731374eb Gleb Natapov        2009-04-21  10438  	}
ee2cd4b7555e3a Paolo Bonzini       2016-06-01  10439  
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10440  	if (is_guest_mode(vcpu) &&
5b4ac1a1b71373 Paolo Bonzini       2022-09-21  10441  	    kvm_x86_ops.nested_ops->has_events &&
32f55e475ce2c4 Sean Christopherson 2024-06-07  10442  	    kvm_x86_ops.nested_ops->has_events(vcpu, true))
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10443  		*req_immediate_exit = true;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10444  
dea0d5a2fde622 Sean Christopherson 2022-09-30  10445  	/*
dea0d5a2fde622 Sean Christopherson 2022-09-30  10446  	 * KVM must never queue a new exception while injecting an event; KVM
dea0d5a2fde622 Sean Christopherson 2022-09-30  10447  	 * is done emulating and should only propagate the to-be-injected event
dea0d5a2fde622 Sean Christopherson 2022-09-30  10448  	 * to the VMCS/VMCB.  Queueing a new exception can put the vCPU into an
dea0d5a2fde622 Sean Christopherson 2022-09-30  10449  	 * infinite loop as KVM will bail from VM-Enter to inject the pending
dea0d5a2fde622 Sean Christopherson 2022-09-30  10450  	 * exception and start the cycle all over.
dea0d5a2fde622 Sean Christopherson 2022-09-30  10451  	 *
dea0d5a2fde622 Sean Christopherson 2022-09-30  10452  	 * Exempt triple faults as they have special handling and won't put the
dea0d5a2fde622 Sean Christopherson 2022-09-30  10453  	 * vCPU into an infinite loop.  Triple fault can be queued when running
dea0d5a2fde622 Sean Christopherson 2022-09-30  10454  	 * VMX without unrestricted guest, as that requires KVM to emulate Real
dea0d5a2fde622 Sean Christopherson 2022-09-30  10455  	 * Mode events (see kvm_inject_realmode_interrupt()).
dea0d5a2fde622 Sean Christopherson 2022-09-30  10456  	 */
dea0d5a2fde622 Sean Christopherson 2022-09-30  10457  	WARN_ON_ONCE(vcpu->arch.exception.pending ||
dea0d5a2fde622 Sean Christopherson 2022-09-30  10458  		     vcpu->arch.exception_vmexit.pending);
a5f6909a71f922 Jim Mattson         2021-06-04  10459  	return 0;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10460  
a5f6909a71f922 Jim Mattson         2021-06-04  10461  out:
a5f6909a71f922 Jim Mattson         2021-06-04  10462  	if (r == -EBUSY) {
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10463  		*req_immediate_exit = true;
a5f6909a71f922 Jim Mattson         2021-06-04  10464  		r = 0;
a5f6909a71f922 Jim Mattson         2021-06-04  10465  	}
a5f6909a71f922 Jim Mattson         2021-06-04  10466  	return r;
95ba82731374eb Gleb Natapov        2009-04-21  10467  }
95ba82731374eb Gleb Natapov        2009-04-21  10468  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

