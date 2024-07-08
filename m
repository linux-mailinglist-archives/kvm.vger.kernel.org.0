Return-Path: <kvm+bounces-21077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B96C929BD6
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 07:56:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F31D7281482
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2024 05:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C23711720;
	Mon,  8 Jul 2024 05:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZC3Q3kjA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAA5171C2;
	Mon,  8 Jul 2024 05:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720418167; cv=none; b=pkZ2ueirAiQRCzn4cjhwTRXbYcuut1I6NjSuco+c0Dce5un+D+l+XDXBBOQpOrEhqIgWg0SBxYZmd2f0o9L71VYAnRAKcip+GB9eAlTe7rzEFwps8r4VoYwULYtukkUwcMHi0sqnMGhKlKYT133soglVB5IqzZoCuy/NKY+0X5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720418167; c=relaxed/simple;
	bh=fVnw4Bj8q0usrFxXHnjxvc9swJLTMEqCRv0t650qfiw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMdip8OB71U9hjEdshwPeIlfU8gSpcA65DDKVZaW0JBzzOJ+02U4IC6SuLq0kELCFvNdPDUx2Yx2GATa0/8P27vLroGpbP6QXOPkgyK7r8PtOqFosQri6LXaGmiUWItXLTgQq24L++Qc5tfRxYR+OxJhhEg6XKJwqvNJwSZ6TSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZC3Q3kjA; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720418165; x=1751954165;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=fVnw4Bj8q0usrFxXHnjxvc9swJLTMEqCRv0t650qfiw=;
  b=ZC3Q3kjA7mbff9gaCliTNmTtoTxGgjIHV8zorpoA6PReahQ6Mzr46Msj
   VHF7Z7/cfdmTIrahUOLuTswsG4WxAjYaqoRqW6mBN2xqIl6qLBl9iNoxC
   jS89dua0ZhmxwyHtcFVWOXnb74cxmokq2MVsIOuphvAbdghuYBhS7Qic0
   KfdgrJI/qpf94gvgFpg+be5WPXzriFY+J/jG+1/7eT8cJAHJDpM2A7JZd
   6QIlLybJ9E92uVeqkR5pj8MrH4UIefqFh0s8C3WmKjCHebbwbCUGxm31N
   lw8aYkt/wlvOF10IprbGTXUWVzMPZ2jLJLvwAIHstYJ1ysZq9dw7AWUbF
   Q==;
X-CSE-ConnectionGUID: 3Az+pAFeSU2UYVUrgZifaA==
X-CSE-MsgGUID: 0KzjAmtQTUO92CHfoxeqwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11126"; a="35135580"
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="35135580"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2024 22:56:04 -0700
X-CSE-ConnectionGUID: mtRzB10PS36VYDIwUipRag==
X-CSE-MsgGUID: b0LvFIxhTCG+EF5zYWO9LA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,191,1716274800"; 
   d="scan'208";a="47455805"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa010.fm.intel.com with ESMTP; 07 Jul 2024 22:56:00 -0700
Date: Mon, 8 Jul 2024 13:55:59 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: Sean Christopherson <seanjc@google.com>, isaku.yamahata@intel.com,
	pbonzini@redhat.com, erdemaktas@google.com, vkuznets@redhat.com,
	vannapurve@google.com, jmattson@google.com, mlevitsk@redhat.com,
	xiaoyao.li@intel.com, chao.gao@intel.com,
	rick.p.edgecombe@intel.com, yuan.yao@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, "Hao, Xudong" <xudong.hao@intel.com>
Subject: Re: VMX Preemption Timer appears to be buggy on SKX, CLX, and ICX
Message-ID: <20240708055559.rl4w5xfhj3uru6j2@yy-desk-7060>
References: <cover.1718214999.git.reinette.chatre@intel.com>
 <2fccf35715b5ba8aec5e5708d86ad7015b8d74e6.1718214999.git.reinette.chatre@intel.com>
 <Zn9X0yFxZi_Mrlnt@google.com>
 <8a34f1d4-9f43-4fa7-9566-144b5eeda4d9@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a34f1d4-9f43-4fa7-9566-144b5eeda4d9@intel.com>
User-Agent: NeoMutt/20171215

On Wed, Jul 03, 2024 at 01:14:09PM -0700, Reinette Chatre wrote:
> Hi Sean,
>
> On 6/28/24 5:39 PM, Sean Christopherson wrote:
> > Forking this off to try and avoid confusion...
> >
> > On Wed, Jun 12, 2024, Reinette Chatre wrote:
>
> ...
>
> > > +
> > > +		freq = (tmict - tmcct) * tdcrs[i].divide_count * tsc_hz / (tsc1 - tsc0);
> > > +		/* Check if measured frequency is within 1% of configured frequency. */
> > > +		GUEST_ASSERT(freq < apic_hz * 101 / 100);
> > > +		GUEST_ASSERT(freq > apic_hz * 99 / 100);
> > > +	}
> >
> > This test fails on our SKX, CLX, and ICX systems due to what appears to be a CPU
> > bug.  It looks like something APICv related is clobbering internal VMX timer state?
> > Or maybe there's a tearing or truncation issue?
>
> It has been a few days. Just a note to let you know that we are investigating this.
> On my side I have not yet been able to reproduce this issue. I tested
> kvm-x86-next-2024.06.28 on an ICX and an CLX system by running 100 iterations of
> apic_bus_clock_test and they all passed. Since I have lack of experience here there are
> some Intel virtualization experts helping out with this investigation and I hope that
> they will be some insights from the analysis and testing that you already provided.
>
> Reinette
>

I can reproduce this on my side, even with apicv disabled by
'insmod $kernel_path/arch/x86/kvm/kvm-intel.ko enable_apicv=N'.
@Sean I think we're observing same issue, please see the details
below:

apic_bus_clock_test can't reproduce this may because the
preemption timer value calculation relies on apic bus
frequency/TMICT/Divide count/host TSC frequency and ratio
between preemption timer and host TSC frequency, too many
factors to generate the 'magic' value there. So I changed
KVM and added a small KVM kselftest tool to set the
preemption timer value directly from guest, this makes the
reproducing easily. The changes are attached at end of this
comment.

The trace I captured below came form host with 1.7GHz TSC,
the VM_EXIT_SAVE_VMX_PREEMPTION_TIMER is enabled to get the
cpu saved vmcs.VMX_PREEMPTION_TIMER_VALUE after VMEXIT. I
set the vmcs.VMX_PREEMPTION_TIMER_VALUE to 0x880042ad which
is the 'magic' number on this 1.7Ghz TSC machine:

preempt_test  20677.199521: kvm:kvm_vmx_debug: kvm_vmx_debug: 3, a0:0x77fd5554 a1:0x880042ad a2:0x880042ad a3:0x20462e98d9b9
  a0: The previous vmcs.VMX_PREEMPTION_TIMER_VALUE value
      saved by CPU when VMEXIT.
  a1: The new preemption timer value wrote to
      vmcs.VMX_PREEMPTION_TIMER_VALUE.
  a2: The value read back from
      vmcs.VMX_PREEMPTION_TIMER_VALUE, for double confirmation.
  a3: The host tsc at the time point, debug only.

preempt_test  20677.199579:      kvm:kvm_exit: reason PREEMPTION_TIMER rip 0x40274d info 0 0 intr 0

preempt_test  20677.199579: kvm:kvm_vmx_debug: kvm_vmx_debug: 2, a0:0x34 a1:0x0 a2:0x87fea9b0 a3:0x20462e9a5749
  a0: The VMEXIT reason, 0x34 is preemption timer VMEXIT.
  a1: The read back vmcs.VMX_PREEMPTION_TIMER_VALUE value, here 0.
  a2: The next preemption timer value should be written to
      vmcs, calculates from the (target tsc - current tsc) >>
      7. Now the preemption timer vmexit happend only after
      ~58 microseconds elapsed, it should happen after
      ~171.79 seconds but not such soon, the issue is
      reproduced.

Another more easy way to observe this symptom w/o care the
'magic' preemption timer vlaue is use the maximum preemption
timer value 0xffffffff, below log w/ 0xffffffff is captured
from same machine:

preempt_test 20530.456589: kvm:kvm_vmx_debug: kvm_vmx_debug: 3, a0:0x77fd5551 a1:0xffffffff a2:0xffffffff a3:0x200c1971ca5d

  a0: The previous vmcs.VMX_PREEMPTION_TIMER_VALUE value
      saved by CPU when VMEXIT.
  a1: The new preemption timer value wrote to
      vmcs.VMX_PREEMPTION_TIMER_VALUE.
  a2: The read back value from
      vmcs.VMX_PREEMPTION_TIMER_VALUE, double confirmation.
  a3: the host tsc at the time point, debug only.

preempt_test 20530.456690:      kvm:kvm_exit: reason VMCALL rip 0x4131a0 info 0 0 intr 0
  The preempt_test checks preemption timer state every
  100us, this VMEXIT is expected behavior.

preempt_test 20530.456691:     kvm:kvm_entry: vcpu 0, rip 0x4131a3

preempt_test 20530.456691: kvm:kvm_vmx_debug: kvm_vmx_debug: 3, a0:0x77ff82cc a1:0xfffe900b a2:0xfffe900b a3:0x200c19746d45
  a0: The previous vmcs.VMX_PREEMPTION_TIMER_VALUE value
      saved by CPU when VMEXIT. The difference value
      shouldn't be such huge number 0xffffffff - 0x77ff82cc
      = 0x88007D33 when just ~100us elapsed from previous
      VMENTRY, the issue is reproduced.

Use 0x88000000 as preemption timer value to verify this
preempt_test tool, the preemption timer VMEXIT happend after
~171.45 seconds which is expected behavior on the host
1.7Ghz TSC system:

The preemption timer VMEXIT should happen after:
2281701376 × 128 / 1700000000 = 171.79 seconds.

Attached my changes in KVM and kselftest tool for
reproducing here, based on:
https://github.com/kvm-x86/linux.git
tag:kvm-x86-next-2024.06.28

Patch 01:

From a977bf12a8cd1bbe401e68d3702c0b5aa3bf66e4 Mon Sep 17 00:00:00 2001
From: Yao Yuan <yuan.yao@intel.com>
Date: Thu, 4 Jul 2024 09:59:55 +0800
Subject: [PATCH 1/2] KVM: x86: Introudce trace_kvm_vmx_debug()

debug only common trace.

Signed-off-by: Yao Yuan <yuan.yao@intel.com>
---
 arch/x86/kvm/trace.h | 28 ++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c   |  1 +
 2 files changed, 29 insertions(+)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index d3aeffd6ae75..7b9eb23d71d3 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -34,6 +34,34 @@ TRACE_EVENT(kvm_entry,
 		  __entry->immediate_exit ? "[immediate exit]" : "")
 );

+TRACE_EVENT(kvm_vmx_debug,
+	    TP_PROTO(unsigned long n, unsigned long a0,
+		     unsigned long a1,
+		     unsigned long a2,
+		     unsigned long a3),
+	    TP_ARGS(n, a0, a1, a2, a3),
+
+	TP_STRUCT__entry(
+		 __field(	unsigned long,	n		)
+		__field(	unsigned long,	a0		)
+		__field(	unsigned long,	a1		)
+		__field(	unsigned long,	a2		)
+		__field(	unsigned long,	a3		)
+	),
+
+	TP_fast_assign(
+		__entry->n      = n;
+		__entry->a0		= a0;
+		__entry->a1		= a1;
+		__entry->a2		= a2;
+		__entry->a3		= a3;
+	),
+
+	TP_printk("kvm_vmx_debug: %ld, a0:0x%lx a1:0x%lx a2:0x%lx a3:0x%lx",
+		  __entry->n, __entry->a0, __entry->a1, __entry->a2, __entry->a3)
+);
+
+
 /*
  * Tracepoint for hypercall.
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 994743266480..6d1972d6c988 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14036,6 +14036,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmx_debug);

 static int __init kvm_x86_init(void)
 {
--
2.27.0

Patch 02:

From a3bdce4f2f93810372f6068396776ac702946d16 Mon Sep 17 00:00:00 2001
From: Yao Yuan <yuan.yao@intel.com>
Date: Wed, 3 Jul 2024 14:08:02 +0800
Subject: [PATCH 2/2] [DEBUG] preempt timer debug test

A specific kselftesting based program to allow set the VMX
preempt timer value from VM directly.

Introduce 2 hypercall 0x56780001/2, 01 to set the preempt
timer value, 02 to wait for the preemption time expired.

Usage:
Reload kvm applied this change, then:
$KRNEL_SRC_ROOT/tools/testing/selftests/kvm/x86_64/preempt_test -p 'preempt_timer_vale'

'preempt_timer_vale' is the preempt timer value in DEC format, HEX is not supported.

For example:

perf record -e "kvm:*" tools/testing/selftests/kvm/x86_64/preempt_test -p 2281718445

Above set the preempt value to 2281718445(0x880042AD) and
capture the trace, then check the kvm_vmx_debug in the trace
to know the preempt timer behavior.

Signed-off-by: Yao Yuan <yuan.yao@intel.com>
---
 tools/testing/selftests/kvm/Makefile          |   1 +
 arch/x86/kvm/vmx/vmx.h                        |   5 +
 arch/x86/kvm/vmx/vmx.c                        | 113 +++++++++++++++++-
 .../selftests/kvm/x86_64/preempt_test.c       |  82 +++++++++++++
 4 files changed, 198 insertions(+), 3 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/x86_64/preempt_test.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ad8b5d15f2bd..957509957f80 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -129,6 +129,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/amx_test
 TEST_GEN_PROGS_x86_64 += x86_64/max_vcpuid_cap_test
 TEST_GEN_PROGS_x86_64 += x86_64/triple_fault_event_test
 TEST_GEN_PROGS_x86_64 += x86_64/recalc_apic_map_test
+TEST_GEN_PROGS_x86_64 += x86_64/preempt_test
 TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
 TEST_GEN_PROGS_x86_64 += demand_paging_test
 TEST_GEN_PROGS_x86_64 += dirty_log_test
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 42498fa63abb..82ea0ccc7a63 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -368,6 +368,11 @@ struct vcpu_vmx {

 	/* ve_info must be page aligned. */
 	struct vmx_ve_information *ve_info;
+
+	volatile bool debug_timer;
+	bool debug_timer_set_to_hardware;
+	u32 debug_timer_val;
+	u64 debug_timer_deadline_tsc;
 };

 struct kvm_vmx {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..73f084c29f9a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4431,8 +4431,9 @@ static u32 vmx_vmexit_ctrl(void)
 	 * Not used by KVM and never set in vmcs01 or vmcs02, but emulated for
 	 * nested virtualization and thus allowed to be set in vmcs12.
 	 */
-	vmexit_ctrl &= ~(VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER |
-			 VM_EXIT_SAVE_VMX_PREEMPTION_TIMER);
+	vmexit_ctrl &= ~(VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER);
+	pr_info("Set VM_EXIT_SAVE_VMX_PREEMPTION_TIMER forcedly for preempt timer debug\n");
+

 	if (vmx_pt_mode_is_system())
 		vmexit_ctrl &= ~(VM_EXIT_PT_CONCEAL_PIP |
@@ -5993,11 +5994,41 @@ static int handle_pml_full(struct kvm_vcpu *vcpu)
 	return 1;
 }

+static fastpath_t handle_fastpath_debug_timer(struct kvm_vcpu *vcpu,
+					      bool force_immediate_exit)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u64 tscl;
+	u32 delta;
+
+	tscl = rdtsc();
+
+	if (vmx->debug_timer_deadline_tsc > tscl)
+		delta = (u32)((vmx->debug_timer_deadline_tsc - tscl) >>
+			      cpu_preemption_timer_multi);
+	else
+		delta = 0;
+
+	trace_kvm_vmx_debug(2UL,
+			    (unsigned long)vmcs_read32(VM_EXIT_REASON),
+			    (unsigned long)vmcs_read32(VMX_PREEMPTION_TIMER_VALUE),
+			    (unsigned long)delta, tscl);
+
+	vmx->debug_timer = false;
+
+	return EXIT_FASTPATH_REENTER_GUEST;
+}
+
 static fastpath_t handle_fastpath_preemption_timer(struct kvm_vcpu *vcpu,
 						   bool force_immediate_exit)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);

+	WARN_ON(vmx->debug_timer && force_immediate_exit);
+	if (vmx->debug_timer)
+		return handle_fastpath_debug_timer(vcpu,
+						   force_immediate_exit);
+
 	/*
 	 * In the *extremely* unlikely scenario that this is a spurious VM-Exit
 	 * due to the timer expiring while it was "soft" disabled, just eat the
@@ -6096,6 +6127,60 @@ static int handle_notify(struct kvm_vcpu *vcpu)
 	return 1;
 }

+static unsigned long vmx_debug_set_preempt_timer(struct kvm_vcpu *vcpu,
+						 unsigned long a0,
+						 unsigned long a1,
+						 unsigned long a2,
+						 unsigned long a3)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	vmx->debug_timer = true;
+	vmx->debug_timer_set_to_hardware = false;
+	vmx->debug_timer_val = a0;
+	vmx->debug_timer_deadline_tsc = rdtsc() + (a0 << cpu_preemption_timer_multi);
+	pr_info("debug_timer = %u\n", (u32)a0);
+
+	return 0;
+}
+
+
+static unsigned long vmx_debug_get_preempt_timer_result(struct kvm_vcpu *vcpu,
+							unsigned long a0,
+							unsigned long a1,
+							unsigned long a2,
+							unsigned long a3)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (vmx->debug_timer)
+		return 1;
+	return 0;
+}
+
+static int vmx_emulate_hypercall(struct kvm_vcpu *vcpu)
+{
+	unsigned long nr, a0, a1, a2, a3;
+	unsigned long ret;
+
+	nr = kvm_rax_read(vcpu);
+	if (nr != 0x87650001 && nr != 0x87650002)
+		return kvm_emulate_hypercall(vcpu);
+
+	a0 = kvm_rbx_read(vcpu);
+	a1 = kvm_rcx_read(vcpu);
+	a2 = kvm_rdx_read(vcpu);
+	a3 = kvm_rsi_read(vcpu);
+
+	if (nr == 0x87650001)
+		ret = vmx_debug_set_preempt_timer(vcpu, a0, a1, a2, a3);
+	else
+		ret = vmx_debug_get_preempt_timer_result(vcpu, a0, a1, a2, a3);
+
+	kvm_rax_write(vcpu, ret);
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
 /*
  * The exit handlers return 1 if the exit was handled fully and guest execution
  * may resume.  Otherwise they set the kvm_run parameter to indicate what needs
@@ -6117,7 +6202,7 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[EXIT_REASON_INVD]		      = kvm_emulate_invd,
 	[EXIT_REASON_INVLPG]		      = handle_invlpg,
 	[EXIT_REASON_RDPMC]                   = kvm_emulate_rdpmc,
-	[EXIT_REASON_VMCALL]                  = kvm_emulate_hypercall,
+	[EXIT_REASON_VMCALL]                  = vmx_emulate_hypercall,
 	[EXIT_REASON_VMCLEAR]		      = handle_vmx_instruction,
 	[EXIT_REASON_VMLAUNCH]		      = handle_vmx_instruction,
 	[EXIT_REASON_VMPTRLD]		      = handle_vmx_instruction,
@@ -7199,6 +7284,28 @@ static void vmx_update_hv_timer(struct kvm_vcpu *vcpu, bool force_immediate_exit
 	if (force_immediate_exit) {
 		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, 0);
 		vmx->loaded_vmcs->hv_timer_soft_disabled = false;
+	} else if (vmx->debug_timer) {
+		u32 old;
+
+		tscl = rdtsc();
+
+		if (!vmx->debug_timer_set_to_hardware) {
+			delta_tsc = vmx->debug_timer_val;
+			vmx->debug_timer_set_to_hardware = true;
+		} else {
+			if (vmx->debug_timer_deadline_tsc > tscl)
+				delta_tsc = (u32)((vmx->debug_timer_deadline_tsc - tscl)
+						  >> cpu_preemption_timer_multi);
+			else
+				delta_tsc = 0;
+		}
+
+		old = vmcs_read32(VMX_PREEMPTION_TIMER_VALUE);
+		vmcs_write32(VMX_PREEMPTION_TIMER_VALUE, delta_tsc);
+		trace_kvm_vmx_debug(3UL, old,
+				    vmcs_read32(VMX_PREEMPTION_TIMER_VALUE),
+				    delta_tsc, tscl);
+		vmx->loaded_vmcs->hv_timer_soft_disabled = false;
 	} else if (vmx->hv_deadline_tsc != -1) {
 		tscl = rdtsc();
 		if (vmx->hv_deadline_tsc > tscl)
diff --git a/tools/testing/selftests/kvm/x86_64/preempt_test.c b/tools/testing/selftests/kvm/x86_64/preempt_test.c
new file mode 100644
index 000000000000..2e58cfee61d0
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/preempt_test.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024 Intel Corporation
+ *
+ * Debug the preemption timer behavior
+ */
+
+#include "test_util.h"
+#include "processor.h"
+#include "ucall_common.h"
+
+uint32_t preempt_timer_val = 0x1000000;
+static void guest_code(uint64_t apic_hz, uint64_t delay_ms)
+{
+	volatile unsigned long r;
+
+	kvm_hypercall(0x87650001, preempt_timer_val, 0, 0, 0);
+	do {
+		udelay(100);
+		r = kvm_hypercall(0x87650002, 0, 0, 0, 0);
+	} while(r != 0);
+
+	GUEST_DONE();
+}
+
+static void do_test(struct kvm_vcpu *vcpu)
+{
+	bool done = false;
+	struct ucall uc;
+
+	while (!done) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_DONE:
+			done = true;
+			break;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
+static void run_test(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	vm = vm_create(1);
+
+	sync_global_to_guest(vm, preempt_timer_val);
+
+	vcpu = vm_vcpu_add(vm, 0, guest_code);
+
+	do_test(vcpu);
+
+	kvm_vm_free(vm);
+}
+
+
+int main(int argc, char *argv[])
+{
+	int opt;
+
+	while ((opt = getopt(argc, argv, "p:h")) != -1) {
+		switch (opt) {
+		case 'p':
+			preempt_timer_val = atoi(optarg);
+			break;
+		default:
+			exit(KSFT_SKIP);
+		}
+	}
+
+	printf("preempt timer value:%u(0x%x)\n",
+	       preempt_timer_val, preempt_timer_val);
+
+	run_test();
+}
--
2.27.0

