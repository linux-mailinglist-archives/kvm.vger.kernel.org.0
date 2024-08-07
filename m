Return-Path: <kvm+bounces-23587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D779894B3A0
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 01:31:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 286B5B2386A
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 23:31:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F55145FF5;
	Wed,  7 Aug 2024 23:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OnNXKNnd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944C72B9A1;
	Wed,  7 Aug 2024 23:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723073489; cv=none; b=tYgqJhd+fbvVjbsv1YYMSzo0cSETQcrBk4zszDHIe1LmquGQLL0M4NeIHylJsQrYsrG1YfnHx6bSKdy5+DEkLvryxqvW4QVXWOgoB0r1lVEfZU24bJCFuCLYXnnGWPgmGShYaaYMBVbpA4PIVQ75JPa8Qnabrhux2uLm91+/EnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723073489; c=relaxed/simple;
	bh=bMG1okqwNx0sMoRctqPVg2TXYbATA2m/erTIpjDvr6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W69vZ02USEb1aiB2lXawzYzsm6xuO7V8On494Gx+/5RialFmMUn54HdPP6LLPKhhmF8q5EtXFgjx5fJTlf3WSVoTFp0emB3a8rmqB2xx1H33SEGHnlsEmY2IREE9y2jhz0FDiahAeG0v2mHoEPahCP3OokjAkdtiYVNmgb/0Rn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OnNXKNnd; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723073487; x=1754609487;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=bMG1okqwNx0sMoRctqPVg2TXYbATA2m/erTIpjDvr6Y=;
  b=OnNXKNnd+lHttDDZkIGUCu7LLwmxsgEUtCI4NG1FGXSOXQDzNUrxWnio
   4tOpMu7+j4uKza/9p/z5QJ8dlxJHDmZTK+CMD50fWj3frZiE+DSlf+nq9
   S8y6ev6Ap5KCQgAcHo+0L6BQKYyzAMHH2a4ocZe+yhhI1h0AIczh7zdLB
   524SBbs11GWsl6VsoKekGCuoLoMrunyxBXH7A+322rjXv9F6I+GVeQKWR
   Zxe/se13nSDoZyg3+ncgoGkuZhMJ9uE7ovCMPc5wF3Rvv+N/LOTP5pHM4
   94fIsknNQQdQSHhUzfJOAbKTcgihlATbyVsnpZHx36FtW6VuHAuxGRfXV
   Q==;
X-CSE-ConnectionGUID: O7qH/u9sR5aK8rrcPVkcrQ==
X-CSE-MsgGUID: OyVnK/GURmefiVCLz3Zngw==
X-IronPort-AV: E=McAfee;i="6700,10204,11157"; a="12909325"
X-IronPort-AV: E=Sophos;i="6.09,271,1716274800"; 
   d="scan'208";a="12909325"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2024 16:31:25 -0700
X-CSE-ConnectionGUID: h6X0Mo2wRAG1yZdsG8tEqQ==
X-CSE-MsgGUID: 4NdFmQXsQTSvyXQFa1oXKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,271,1716274800"; 
   d="scan'208";a="57097037"
Received: from unknown (HELO b6bf6c95bbab) ([10.239.97.151])
  by fmviesa010.fm.intel.com with ESMTP; 07 Aug 2024 16:31:21 -0700
Received: from kbuild by b6bf6c95bbab with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sbq7j-0005nW-2D;
	Wed, 07 Aug 2024 23:31:19 +0000
Date: Thu, 8 Aug 2024 07:30:41 +0800
From: kernel test robot <lkp@intel.com>
To: Melody Wang <huibo.wang@amd.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>,
	Melody Wang <huibo.wang@amd.com>
Subject: Re: [PATCH 5/6] KVM: SVM: Inject MCEs when restricted injection is
 active
Message-ID: <202408080703.tBFpvbaa-lkp@intel.com>
References: <ec9b446fe9554effef9a9c5cec348e3f627ff581.1722989996.git.huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec9b446fe9554effef9a9c5cec348e3f627ff581.1722989996.git.huibo.wang@amd.com>

Hi Melody,

kernel test robot noticed the following build warnings:

[auto build test WARNING on tip/x86/core]
[also build test WARNING on linus/master v6.11-rc2 next-20240807]
[cannot apply to kvm/queue mst-vhost/linux-next kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Melody-Wang/x86-sev-Define-the-HV-doorbell-page-structure/20240807-090812
base:   tip/x86/core
patch link:    https://lore.kernel.org/r/ec9b446fe9554effef9a9c5cec348e3f627ff581.1722989996.git.huibo.wang%40amd.com
patch subject: [PATCH 5/6] KVM: SVM: Inject MCEs when restricted injection is active
config: x86_64-buildonly-randconfig-004-20240808 (https://download.01.org/0day-ci/archive/20240808/202408080703.tBFpvbaa-lkp@intel.com/config)
compiler: clang version 18.1.5 (https://github.com/llvm/llvm-project 617a15a9eac96088ae5e9134248d8236e34b91b1)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240808/202408080703.tBFpvbaa-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202408080703.tBFpvbaa-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/x86/kvm/x86.c:10503:2: warning: label at end of compound statement is a C23 extension [-Wc23-extensions]
    10503 |         }
          |         ^
   1 warning generated.


vim +10503 arch/x86/kvm/x86.c

b97f074583736c Maxim Levitsky      2021-02-25  10344  
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10345  /*
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10346   * Check for any event (interrupt or exception) that is ready to be injected,
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10347   * and if there is at least one event, inject the event with the highest
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10348   * priority.  This handles both "pending" events, i.e. events that have never
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10349   * been injected into the guest, and "injected" events, i.e. events that were
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10350   * injected as part of a previous VM-Enter, but weren't successfully delivered
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10351   * and need to be re-injected.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10352   *
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10353   * Note, this is not guaranteed to be invoked on a guest instruction boundary,
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10354   * i.e. doesn't guarantee that there's an event window in the guest.  KVM must
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10355   * be able to inject exceptions in the "middle" of an instruction, and so must
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10356   * also be able to re-inject NMIs and IRQs in the middle of an instruction.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10357   * I.e. for exceptions and re-injected events, NOT invoking this on instruction
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10358   * boundaries is necessary and correct.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10359   *
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10360   * For simplicity, KVM uses a single path to inject all events (except events
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10361   * that are injected directly from L1 to L2) and doesn't explicitly track
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10362   * instruction boundaries for asynchronous events.  However, because VM-Exits
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10363   * that can occur during instruction execution typically result in KVM skipping
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10364   * the instruction or injecting an exception, e.g. instruction and exception
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10365   * intercepts, and because pending exceptions have higher priority than pending
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10366   * interrupts, KVM still honors instruction boundaries in most scenarios.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10367   *
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10368   * But, if a VM-Exit occurs during instruction execution, and KVM does NOT skip
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10369   * the instruction or inject an exception, then KVM can incorrecty inject a new
54aa699e8094ef Bjorn Helgaas       2024-01-02  10370   * asynchronous event if the event became pending after the CPU fetched the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10371   * instruction (in the guest).  E.g. if a page fault (#PF, #NPF, EPT violation)
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10372   * occurs and is resolved by KVM, a coincident NMI, SMI, IRQ, etc... can be
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10373   * injected on the restarted instruction instead of being deferred until the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10374   * instruction completes.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10375   *
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10376   * In practice, this virtualization hole is unlikely to be observed by the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10377   * guest, and even less likely to cause functional problems.  To detect the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10378   * hole, the guest would have to trigger an event on a side effect of an early
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10379   * phase of instruction execution, e.g. on the instruction fetch from memory.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10380   * And for it to be a functional problem, the guest would need to depend on the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10381   * ordering between that side effect, the instruction completing, _and_ the
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10382   * delivery of the asynchronous event.
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10383   */
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10384  static int kvm_check_and_inject_events(struct kvm_vcpu *vcpu,
e746c1f1b94ac9 Sean Christopherson 2022-08-30  10385  				       bool *req_immediate_exit)
95ba82731374eb Gleb Natapov        2009-04-21  10386  {
28360f88706837 Sean Christopherson 2022-08-30  10387  	bool can_inject;
b6b8a1451fc404 Jan Kiszka          2014-03-07  10388  	int r;
b6b8a1451fc404 Jan Kiszka          2014-03-07  10389  
6c593b5276e6ce Sean Christopherson 2022-08-30  10390  	/*
54aa699e8094ef Bjorn Helgaas       2024-01-02  10391  	 * Process nested events first, as nested VM-Exit supersedes event
6c593b5276e6ce Sean Christopherson 2022-08-30  10392  	 * re-injection.  If there's an event queued for re-injection, it will
6c593b5276e6ce Sean Christopherson 2022-08-30  10393  	 * be saved into the appropriate vmc{b,s}12 fields on nested VM-Exit.
6c593b5276e6ce Sean Christopherson 2022-08-30  10394  	 */
6c593b5276e6ce Sean Christopherson 2022-08-30  10395  	if (is_guest_mode(vcpu))
6c593b5276e6ce Sean Christopherson 2022-08-30  10396  		r = kvm_check_nested_events(vcpu);
6c593b5276e6ce Sean Christopherson 2022-08-30  10397  	else
6c593b5276e6ce Sean Christopherson 2022-08-30  10398  		r = 0;
b59bb7bdf08ee9 Gleb Natapov        2009-07-09  10399  
664f8e26b00c76 Wanpeng Li          2017-08-24  10400  	/*
6c593b5276e6ce Sean Christopherson 2022-08-30  10401  	 * Re-inject exceptions and events *especially* if immediate entry+exit
6c593b5276e6ce Sean Christopherson 2022-08-30  10402  	 * to/from L2 is needed, as any event that has already been injected
6c593b5276e6ce Sean Christopherson 2022-08-30  10403  	 * into L2 needs to complete its lifecycle before injecting a new event.
6c593b5276e6ce Sean Christopherson 2022-08-30  10404  	 *
6c593b5276e6ce Sean Christopherson 2022-08-30  10405  	 * Don't re-inject an NMI or interrupt if there is a pending exception.
6c593b5276e6ce Sean Christopherson 2022-08-30  10406  	 * This collision arises if an exception occurred while vectoring the
6c593b5276e6ce Sean Christopherson 2022-08-30  10407  	 * injected event, KVM intercepted said exception, and KVM ultimately
6c593b5276e6ce Sean Christopherson 2022-08-30  10408  	 * determined the fault belongs to the guest and queues the exception
6c593b5276e6ce Sean Christopherson 2022-08-30  10409  	 * for injection back into the guest.
6c593b5276e6ce Sean Christopherson 2022-08-30  10410  	 *
6c593b5276e6ce Sean Christopherson 2022-08-30  10411  	 * "Injected" interrupts can also collide with pending exceptions if
6c593b5276e6ce Sean Christopherson 2022-08-30  10412  	 * userspace ignores the "ready for injection" flag and blindly queues
6c593b5276e6ce Sean Christopherson 2022-08-30  10413  	 * an interrupt.  In that case, prioritizing the exception is correct,
6c593b5276e6ce Sean Christopherson 2022-08-30  10414  	 * as the exception "occurred" before the exit to userspace.  Trap-like
6c593b5276e6ce Sean Christopherson 2022-08-30  10415  	 * exceptions, e.g. most #DBs, have higher priority than interrupts.
6c593b5276e6ce Sean Christopherson 2022-08-30  10416  	 * And while fault-like exceptions, e.g. #GP and #PF, are the lowest
6c593b5276e6ce Sean Christopherson 2022-08-30  10417  	 * priority, they're only generated (pended) during instruction
6c593b5276e6ce Sean Christopherson 2022-08-30  10418  	 * execution, and interrupts are recognized at instruction boundaries.
6c593b5276e6ce Sean Christopherson 2022-08-30  10419  	 * Thus a pending fault-like exception means the fault occurred on the
6c593b5276e6ce Sean Christopherson 2022-08-30  10420  	 * *previous* instruction and must be serviced prior to recognizing any
6c593b5276e6ce Sean Christopherson 2022-08-30  10421  	 * new events in order to fully complete the previous instruction.
6c593b5276e6ce Sean Christopherson 2022-08-30  10422  	 */
6c593b5276e6ce Sean Christopherson 2022-08-30  10423  	if (vcpu->arch.exception.injected)
b97f074583736c Maxim Levitsky      2021-02-25  10424  		kvm_inject_exception(vcpu);
7709aba8f71613 Sean Christopherson 2022-08-30  10425  	else if (kvm_is_exception_pending(vcpu))
6c593b5276e6ce Sean Christopherson 2022-08-30  10426  		; /* see above */
6c593b5276e6ce Sean Christopherson 2022-08-30  10427  	else if (vcpu->arch.nmi_injected)
896046474f8d2e Wei Wang            2024-05-07  10428  		kvm_x86_call(inject_nmi)(vcpu);
6c593b5276e6ce Sean Christopherson 2022-08-30  10429  	else if (vcpu->arch.interrupt.injected)
896046474f8d2e Wei Wang            2024-05-07  10430  		kvm_x86_call(inject_irq)(vcpu, true);
b6b8a1451fc404 Jan Kiszka          2014-03-07  10431  
6c593b5276e6ce Sean Christopherson 2022-08-30  10432  	/*
6c593b5276e6ce Sean Christopherson 2022-08-30  10433  	 * Exceptions that morph to VM-Exits are handled above, and pending
6c593b5276e6ce Sean Christopherson 2022-08-30  10434  	 * exceptions on top of injected exceptions that do not VM-Exit should
6c593b5276e6ce Sean Christopherson 2022-08-30  10435  	 * either morph to #DF or, sadly, override the injected exception.
6c593b5276e6ce Sean Christopherson 2022-08-30  10436  	 */
3b82b8d7fdf7c1 Sean Christopherson 2020-04-22  10437  	WARN_ON_ONCE(vcpu->arch.exception.injected &&
3b82b8d7fdf7c1 Sean Christopherson 2020-04-22  10438  		     vcpu->arch.exception.pending);
3b82b8d7fdf7c1 Sean Christopherson 2020-04-22  10439  
1a680e355c9477 Liran Alon          2018-03-23  10440  	/*
6c593b5276e6ce Sean Christopherson 2022-08-30  10441  	 * Bail if immediate entry+exit to/from the guest is needed to complete
6c593b5276e6ce Sean Christopherson 2022-08-30  10442  	 * nested VM-Enter or event re-injection so that a different pending
6c593b5276e6ce Sean Christopherson 2022-08-30  10443  	 * event can be serviced (or if KVM needs to exit to userspace).
6c593b5276e6ce Sean Christopherson 2022-08-30  10444  	 *
6c593b5276e6ce Sean Christopherson 2022-08-30  10445  	 * Otherwise, continue processing events even if VM-Exit occurred.  The
6c593b5276e6ce Sean Christopherson 2022-08-30  10446  	 * VM-Exit will have cleared exceptions that were meant for L2, but
6c593b5276e6ce Sean Christopherson 2022-08-30  10447  	 * there may now be events that can be injected into L1.
1a680e355c9477 Liran Alon          2018-03-23  10448  	 */
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10449  	if (r < 0)
a5f6909a71f922 Jim Mattson         2021-06-04  10450  		goto out;
95ba82731374eb Gleb Natapov        2009-04-21  10451  
7709aba8f71613 Sean Christopherson 2022-08-30  10452  	/*
7709aba8f71613 Sean Christopherson 2022-08-30  10453  	 * A pending exception VM-Exit should either result in nested VM-Exit
7709aba8f71613 Sean Christopherson 2022-08-30  10454  	 * or force an immediate re-entry and exit to/from L2, and exception
7709aba8f71613 Sean Christopherson 2022-08-30  10455  	 * VM-Exits cannot be injected (flag should _never_ be set).
7709aba8f71613 Sean Christopherson 2022-08-30  10456  	 */
7709aba8f71613 Sean Christopherson 2022-08-30  10457  	WARN_ON_ONCE(vcpu->arch.exception_vmexit.injected ||
7709aba8f71613 Sean Christopherson 2022-08-30  10458  		     vcpu->arch.exception_vmexit.pending);
7709aba8f71613 Sean Christopherson 2022-08-30  10459  
28360f88706837 Sean Christopherson 2022-08-30  10460  	/*
28360f88706837 Sean Christopherson 2022-08-30  10461  	 * New events, other than exceptions, cannot be injected if KVM needs
28360f88706837 Sean Christopherson 2022-08-30  10462  	 * to re-inject a previous event.  See above comments on re-injecting
28360f88706837 Sean Christopherson 2022-08-30  10463  	 * for why pending exceptions get priority.
28360f88706837 Sean Christopherson 2022-08-30  10464  	 */
28360f88706837 Sean Christopherson 2022-08-30  10465  	can_inject = !kvm_event_needs_reinjection(vcpu);
28360f88706837 Sean Christopherson 2022-08-30  10466  
664f8e26b00c76 Wanpeng Li          2017-08-24  10467  	if (vcpu->arch.exception.pending) {
5623f751bd9c43 Sean Christopherson 2022-08-30  10468  		/*
5623f751bd9c43 Sean Christopherson 2022-08-30  10469  		 * Fault-class exceptions, except #DBs, set RF=1 in the RFLAGS
5623f751bd9c43 Sean Christopherson 2022-08-30  10470  		 * value pushed on the stack.  Trap-like exception and all #DBs
5623f751bd9c43 Sean Christopherson 2022-08-30  10471  		 * leave RF as-is (KVM follows Intel's behavior in this regard;
5623f751bd9c43 Sean Christopherson 2022-08-30  10472  		 * AMD states that code breakpoint #DBs excplitly clear RF=0).
5623f751bd9c43 Sean Christopherson 2022-08-30  10473  		 *
5623f751bd9c43 Sean Christopherson 2022-08-30  10474  		 * Note, most versions of Intel's SDM and AMD's APM incorrectly
5623f751bd9c43 Sean Christopherson 2022-08-30  10475  		 * describe the behavior of General Detect #DBs, which are
5623f751bd9c43 Sean Christopherson 2022-08-30  10476  		 * fault-like.  They do _not_ set RF, a la code breakpoints.
5623f751bd9c43 Sean Christopherson 2022-08-30  10477  		 */
d4963e319f1f78 Sean Christopherson 2022-08-30  10478  		if (exception_type(vcpu->arch.exception.vector) == EXCPT_FAULT)
664f8e26b00c76 Wanpeng Li          2017-08-24  10479  			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
664f8e26b00c76 Wanpeng Li          2017-08-24  10480  					     X86_EFLAGS_RF);
664f8e26b00c76 Wanpeng Li          2017-08-24  10481  
d4963e319f1f78 Sean Christopherson 2022-08-30  10482  		if (vcpu->arch.exception.vector == DB_VECTOR) {
d4963e319f1f78 Sean Christopherson 2022-08-30  10483  			kvm_deliver_exception_payload(vcpu, &vcpu->arch.exception);
f10c729ff96528 Jim Mattson         2018-10-16  10484  			if (vcpu->arch.dr7 & DR7_GD) {
664f8e26b00c76 Wanpeng Li          2017-08-24  10485  				vcpu->arch.dr7 &= ~DR7_GD;
664f8e26b00c76 Wanpeng Li          2017-08-24  10486  				kvm_update_dr7(vcpu);
664f8e26b00c76 Wanpeng Li          2017-08-24  10487  			}
f10c729ff96528 Jim Mattson         2018-10-16  10488  		}
664f8e26b00c76 Wanpeng Li          2017-08-24  10489  
fc9708f9726240 Melody Wang         2024-08-07  10490  		if (vcpu->arch.exception.vector == MC_VECTOR) {
fc9708f9726240 Melody Wang         2024-08-07  10491  			r = static_call(kvm_x86_mce_allowed)(vcpu);
fc9708f9726240 Melody Wang         2024-08-07  10492  			if (!r)
fc9708f9726240 Melody Wang         2024-08-07  10493  				goto out_except;
fc9708f9726240 Melody Wang         2024-08-07  10494  		}
fc9708f9726240 Melody Wang         2024-08-07  10495  
b97f074583736c Maxim Levitsky      2021-02-25  10496  		kvm_inject_exception(vcpu);
a61d7c5432ac5a Sean Christopherson 2022-05-02  10497  
a61d7c5432ac5a Sean Christopherson 2022-05-02  10498  		vcpu->arch.exception.pending = false;
a61d7c5432ac5a Sean Christopherson 2022-05-02  10499  		vcpu->arch.exception.injected = true;
a61d7c5432ac5a Sean Christopherson 2022-05-02  10500  
c6b22f59d694d0 Paolo Bonzini       2020-05-26  10501  		can_inject = false;
fc9708f9726240 Melody Wang         2024-08-07  10502  out_except:
1a680e355c9477 Liran Alon          2018-03-23 @10503  	}
1a680e355c9477 Liran Alon          2018-03-23  10504  
61e5f69ef08379 Maxim Levitsky      2021-08-11  10505  	/* Don't inject interrupts if the user asked to avoid doing so */
61e5f69ef08379 Maxim Levitsky      2021-08-11  10506  	if (vcpu->guest_debug & KVM_GUESTDBG_BLOCKIRQ)
61e5f69ef08379 Maxim Levitsky      2021-08-11  10507  		return 0;
61e5f69ef08379 Maxim Levitsky      2021-08-11  10508  
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10509  	/*
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10510  	 * Finally, inject interrupt events.  If an event cannot be injected
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10511  	 * due to architectural conditions (e.g. IF=0) a window-open exit
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10512  	 * will re-request KVM_REQ_EVENT.  Sometimes however an event is pending
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10513  	 * and can architecturally be injected, but we cannot do it right now:
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10514  	 * an interrupt could have arrived just now and we have to inject it
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10515  	 * as a vmexit, or there could already an event in the queue, which is
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10516  	 * indicated by can_inject.  In that case we request an immediate exit
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10517  	 * in order to make progress and get back here for another iteration.
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10518  	 * The kvm_x86_ops hooks communicate this by returning -EBUSY.
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10519  	 */
31e83e21cf00fe Paolo Bonzini       2022-09-29  10520  #ifdef CONFIG_KVM_SMM
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10521  	if (vcpu->arch.smi_pending) {
896046474f8d2e Wei Wang            2024-05-07  10522  		r = can_inject ? kvm_x86_call(smi_allowed)(vcpu, true) :
896046474f8d2e Wei Wang            2024-05-07  10523  				 -EBUSY;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10524  		if (r < 0)
a5f6909a71f922 Jim Mattson         2021-06-04  10525  			goto out;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10526  		if (r) {
c43203cab1e2e1 Paolo Bonzini       2016-06-01  10527  			vcpu->arch.smi_pending = false;
52797bf9a875c4 Liran Alon          2017-11-15  10528  			++vcpu->arch.smi_count;
ee2cd4b7555e3a Paolo Bonzini       2016-06-01  10529  			enter_smm(vcpu);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10530  			can_inject = false;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10531  		} else
896046474f8d2e Wei Wang            2024-05-07  10532  			kvm_x86_call(enable_smi_window)(vcpu);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10533  	}
31e83e21cf00fe Paolo Bonzini       2022-09-29  10534  #endif
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10535  
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10536  	if (vcpu->arch.nmi_pending) {
896046474f8d2e Wei Wang            2024-05-07  10537  		r = can_inject ? kvm_x86_call(nmi_allowed)(vcpu, true) :
896046474f8d2e Wei Wang            2024-05-07  10538  				 -EBUSY;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10539  		if (r < 0)
a5f6909a71f922 Jim Mattson         2021-06-04  10540  			goto out;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10541  		if (r) {
7460fb4a340033 Avi Kivity          2011-09-20  10542  			--vcpu->arch.nmi_pending;
95ba82731374eb Gleb Natapov        2009-04-21  10543  			vcpu->arch.nmi_injected = true;
896046474f8d2e Wei Wang            2024-05-07  10544  			kvm_x86_call(inject_nmi)(vcpu);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10545  			can_inject = false;
896046474f8d2e Wei Wang            2024-05-07  10546  			WARN_ON(kvm_x86_call(nmi_allowed)(vcpu, true) < 0);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10547  		}
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10548  		if (vcpu->arch.nmi_pending)
896046474f8d2e Wei Wang            2024-05-07  10549  			kvm_x86_call(enable_nmi_window)(vcpu);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10550  	}
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10551  
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10552  	if (kvm_cpu_has_injectable_intr(vcpu)) {
896046474f8d2e Wei Wang            2024-05-07  10553  		r = can_inject ? kvm_x86_call(interrupt_allowed)(vcpu, true) :
896046474f8d2e Wei Wang            2024-05-07  10554  				 -EBUSY;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10555  		if (r < 0)
a5f6909a71f922 Jim Mattson         2021-06-04  10556  			goto out;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10557  		if (r) {
bf672720e83cf0 Maxim Levitsky      2023-07-26  10558  			int irq = kvm_cpu_get_interrupt(vcpu);
bf672720e83cf0 Maxim Levitsky      2023-07-26  10559  
bf672720e83cf0 Maxim Levitsky      2023-07-26  10560  			if (!WARN_ON_ONCE(irq == -1)) {
bf672720e83cf0 Maxim Levitsky      2023-07-26  10561  				kvm_queue_interrupt(vcpu, irq, false);
896046474f8d2e Wei Wang            2024-05-07  10562  				kvm_x86_call(inject_irq)(vcpu, false);
896046474f8d2e Wei Wang            2024-05-07  10563  				WARN_ON(kvm_x86_call(interrupt_allowed)(vcpu, true) < 0);
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10564  			}
bf672720e83cf0 Maxim Levitsky      2023-07-26  10565  		}
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10566  		if (kvm_cpu_has_injectable_intr(vcpu))
896046474f8d2e Wei Wang            2024-05-07  10567  			kvm_x86_call(enable_irq_window)(vcpu);
95ba82731374eb Gleb Natapov        2009-04-21  10568  	}
ee2cd4b7555e3a Paolo Bonzini       2016-06-01  10569  
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10570  	if (is_guest_mode(vcpu) &&
5b4ac1a1b71373 Paolo Bonzini       2022-09-21  10571  	    kvm_x86_ops.nested_ops->has_events &&
32f55e475ce2c4 Sean Christopherson 2024-06-07  10572  	    kvm_x86_ops.nested_ops->has_events(vcpu, true))
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10573  		*req_immediate_exit = true;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10574  
dea0d5a2fde622 Sean Christopherson 2022-09-30  10575  	/*
dea0d5a2fde622 Sean Christopherson 2022-09-30  10576  	 * KVM must never queue a new exception while injecting an event; KVM
dea0d5a2fde622 Sean Christopherson 2022-09-30  10577  	 * is done emulating and should only propagate the to-be-injected event
dea0d5a2fde622 Sean Christopherson 2022-09-30  10578  	 * to the VMCS/VMCB.  Queueing a new exception can put the vCPU into an
dea0d5a2fde622 Sean Christopherson 2022-09-30  10579  	 * infinite loop as KVM will bail from VM-Enter to inject the pending
dea0d5a2fde622 Sean Christopherson 2022-09-30  10580  	 * exception and start the cycle all over.
dea0d5a2fde622 Sean Christopherson 2022-09-30  10581  	 *
dea0d5a2fde622 Sean Christopherson 2022-09-30  10582  	 * Exempt triple faults as they have special handling and won't put the
dea0d5a2fde622 Sean Christopherson 2022-09-30  10583  	 * vCPU into an infinite loop.  Triple fault can be queued when running
dea0d5a2fde622 Sean Christopherson 2022-09-30  10584  	 * VMX without unrestricted guest, as that requires KVM to emulate Real
dea0d5a2fde622 Sean Christopherson 2022-09-30  10585  	 * Mode events (see kvm_inject_realmode_interrupt()).
dea0d5a2fde622 Sean Christopherson 2022-09-30  10586  	 */
dea0d5a2fde622 Sean Christopherson 2022-09-30  10587  	WARN_ON_ONCE(vcpu->arch.exception.pending ||
dea0d5a2fde622 Sean Christopherson 2022-09-30  10588  		     vcpu->arch.exception_vmexit.pending);
a5f6909a71f922 Jim Mattson         2021-06-04  10589  	return 0;
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10590  
a5f6909a71f922 Jim Mattson         2021-06-04  10591  out:
a5f6909a71f922 Jim Mattson         2021-06-04  10592  	if (r == -EBUSY) {
c9d40913ac5a21 Paolo Bonzini       2020-05-22  10593  		*req_immediate_exit = true;
a5f6909a71f922 Jim Mattson         2021-06-04  10594  		r = 0;
a5f6909a71f922 Jim Mattson         2021-06-04  10595  	}
a5f6909a71f922 Jim Mattson         2021-06-04  10596  	return r;
95ba82731374eb Gleb Natapov        2009-04-21  10597  }
95ba82731374eb Gleb Natapov        2009-04-21  10598  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

