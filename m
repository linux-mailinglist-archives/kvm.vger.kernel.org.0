Return-Path: <kvm+bounces-61433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B751DC1D6F5
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 22:27:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 876C44277DD
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:27:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 840F6319840;
	Wed, 29 Oct 2025 21:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cchiK5BF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC213195E7;
	Wed, 29 Oct 2025 21:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761773224; cv=none; b=ivSFZXSArtNhb07xyShcqpbpgAe4OFFV7jD93xu27VxOKs50h0LmRoiFp84iqZ8vBWRtNzJ0CKwM1pP3PeyZdPORLFkUNvBUdIOBKPa6x3FqVD23bv+NBxeLReZyw5CC+MrlmATnU3fMhijoqhcbmgBFzkWdmPC86v49D3k4+Qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761773224; c=relaxed/simple;
	bh=A53qZ0uLzFAnJw49FPl291qShHFAc1moPoAeVDbmF5I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OzAvis3CrISQNpXTASEbKDGWxCXp575L23dkl20AV2pkBfFcgCEQhjImN1+6/qtuhUQ7q57BKRmPHNkT4HnnLwO+ARQGrMn7fILmH6cDmFSzvTcCDkSunVPNaoqPR4/wFQ9DJfsi7dggT2+3Y36lw89A43OR5asWOby02WjvHUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cchiK5BF; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761773223; x=1793309223;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=A53qZ0uLzFAnJw49FPl291qShHFAc1moPoAeVDbmF5I=;
  b=cchiK5BFLwz13PQAiK+5fBaKh36cByN9Xwhp/fyGVIbPTqaRVBPFi6X0
   Y7WTuctFiApvZbDapgn5z+6cVesVnCghIpWLmS3iWmaP+YcbdR26K9l6P
   h0ynJiHi5vZvOJjSoMPEY86CLr9MskLyf13oyFNecV1J/eSGcUBExSoQM
   dTMYMWDUqIvwCv3IJy8GUs1vpzF22vz5f2ouoK1AcbPXPZGHVOxOENQ5Y
   PXryH8YEfe5tABLKfX5FXx/ZOel06g7WP/RSpkGatYFzagltxtlRRxz5H
   R9CbIt/VLxyOX4rrEAXE9DqnV01owyCt44FIyPnd/uvWcC5jw5yjs+0fo
   g==;
X-CSE-ConnectionGUID: zw71Y0AnQOSvz1WwGc5d5A==
X-CSE-MsgGUID: jFlqe8vcRuWRuo8webMC7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67742946"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67742946"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:27:01 -0700
X-CSE-ConnectionGUID: FXzmgxM7SguTNHtWdw38Sw==
X-CSE-MsgGUID: +ad/AQMIS36ddcBG3i4/AQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="186518157"
Received: from vverma7-desk1.amr.corp.intel.com (HELO desk) ([10.124.223.151])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:27:00 -0700
Date: Wed, 29 Oct 2025 14:26:59 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Tao Zhang <tao1.zhang@intel.com>, Jim Mattson <jmattson@google.com>,
	Brendan Jackman <jackmanb@google.com>
Subject: [PATCH 3/3] x86/mmio: Unify VERW mitigation for guests
Message-ID: <20251029-verw-vm-v1-3-babf9b961519@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251029-verw-vm-v1-0-babf9b961519@linux.intel.com>

When a system is only affected by MMIO Stale Data, VERW mitigation is
currently handled differently than other data sampling attacks like
MDS/TAA/RFDS, that do the VERW in asm. This is because for MMIO Stale Data,
VERW is needed only when the guest can access host MMIO, this was tricky to
check in asm.

Refactoring done by:

  83ebe7157483 ("KVM: VMX: Apply MMIO Stale Data mitigation if KVM maps
  MMIO into the guest")

now makes it easier to execute VERW conditionally in asm based on
VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO.

Unify MMIO Stale Data mitigation with other VERW-based mitigations and only
have single VERW callsite in __vmx_vcpu_run(). Remove the now unnecessary
call to x86_clear_cpu_buffer() in vmx_vcpu_enter_exit().

This also untangles L1D Flush and MMIO Stale Data mitigation. Earlier, an
L1D Flush would skip the VERW for MMIO Stale Data. Now, both the
mitigations are independent of each other. Although, this has little
practical implication since there are no CPUs that are affected by L1TF and
are *only* affected by MMIO Stale Data (i.e. not affected by MDS/TAA/RFDS).
But, this makes the code cleaner and easier to maintain.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/kvm/vmx/run_flags.h | 12 ++++++------
 arch/x86/kvm/vmx/vmenter.S   |  5 +++++
 arch/x86/kvm/vmx/vmx.c       | 26 ++++++++++----------------
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
index 2f20fb170def8b10c8c0c46f7ba751f845c19e2c..004fe1ca89f05524bf3986540056de2caf0abbad 100644
--- a/arch/x86/kvm/vmx/run_flags.h
+++ b/arch/x86/kvm/vmx/run_flags.h
@@ -2,12 +2,12 @@
 #ifndef __KVM_X86_VMX_RUN_FLAGS_H
 #define __KVM_X86_VMX_RUN_FLAGS_H
 
-#define VMX_RUN_VMRESUME_SHIFT				0
-#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT			1
-#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT	2
+#define VMX_RUN_VMRESUME_SHIFT			0
+#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT		1
+#define VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT		2
 
-#define VMX_RUN_VMRESUME			BIT(VMX_RUN_VMRESUME_SHIFT)
-#define VMX_RUN_SAVE_SPEC_CTRL			BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
-#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT)
+#define VMX_RUN_VMRESUME		BIT(VMX_RUN_VMRESUME_SHIFT)
+#define VMX_RUN_SAVE_SPEC_CTRL		BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
+#define VMX_RUN_CLEAR_CPU_BUFFERS	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT)
 
 #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 0dd23beae207795484150698d1674dc4044cc520..ec91f4267eca319ffa8e6079887e8dfecc7f96d8 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -137,6 +137,9 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load @regs to RAX. */
 	mov (%_ASM_SP), %_ASM_AX
 
+	/* jz .Lskip_clear_cpu_buffers below relies on this */
+	test $VMX_RUN_CLEAR_CPU_BUFFERS, %ebx
+
 	/* Check if vmlaunch or vmresume is needed */
 	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
 
@@ -160,6 +163,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
+	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
+	jz .Lskip_clear_cpu_buffers
 	/* Clobbers EFLAGS.ZF */
 	VM_CLEAR_CPU_BUFFERS
 .Lskip_clear_cpu_buffers:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 451be757b3d1b2fec6b2b79157f26dd43bc368b8..303935882a9f8d1d8f81a499cdce1fdc8dad62f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -903,9 +903,16 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
 	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
 		flags |= VMX_RUN_SAVE_SPEC_CTRL;
 
-	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only) &&
-	    kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
-		flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
+	/*
+	 * When affected by MMIO Stale Data only (and not other data sampling
+	 * attacks) only clear for MMIO-capable guests.
+	 */
+	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only)) {
+		if (kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
+			flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
+	} else {
+		flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
+	}
 
 	return flags;
 }
@@ -7320,21 +7327,8 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 
 	guest_state_enter_irqoff();
 
-	/*
-	 * L1D Flush includes CPU buffer clear to mitigate MDS, but VERW
-	 * mitigation for MDS is done late in VMentry and is still
-	 * executed in spite of L1D Flush. This is because an extra VERW
-	 * should not matter much after the big hammer L1D Flush.
-	 *
-	 * cpu_buf_vm_clear is used when system is not vulnerable to MDS/TAA,
-	 * and is affected by MMIO Stale Data. In such cases mitigation in only
-	 * needed against an MMIO capable guest.
-	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
-	else if (static_branch_unlikely(&cpu_buf_vm_clear) &&
-		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
-		x86_clear_cpu_buffers();
 
 	vmx_disable_fb_clear(vmx);
 

-- 
2.34.1



