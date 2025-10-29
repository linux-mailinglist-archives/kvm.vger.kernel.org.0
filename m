Return-Path: <kvm+bounces-61432-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 39FD0C1D6E6
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 22:27:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DBC984E39F3
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:26:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD82F31986F;
	Wed, 29 Oct 2025 21:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ci2+SNlq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC6431961C;
	Wed, 29 Oct 2025 21:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761773207; cv=none; b=t65dOXu8TQuppbfhGTWDDRDfF0Qq5SnXYoDGtEKpD8fG7tI4F5Njy6FY5HqSaH+1dBYYy9xPup4vlQSMA4SSecDiP0Cy3R0KRzvA3Hx8rVZe0m0tsuvl1XLCQzDWtRNZrF7T4uMJ7cPt9x8hbeB7YSW9RFh+n6+DRmjfd6gQ+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761773207; c=relaxed/simple;
	bh=jsR8NGNs6hd0OXeFCWqSqCAhot1lMSHp9uAptmE6h8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2TIWHdR0aLEC/+p5XzUJcfXNY0t/Dsdk4tgyr7G5x5BDm+ytjQIbGGHXg+VI6Q9qafxhPUe9ZIup+O8AHn2+cZNh+LbuM3viYNqDi9AkAIT3sU52jYpcF0KFYKj5Z1Ot+6h+sgfayjl4u6bIH6IdZFQbsL/aJrM1noCn8dzXaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ci2+SNlq; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761773205; x=1793309205;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jsR8NGNs6hd0OXeFCWqSqCAhot1lMSHp9uAptmE6h8Q=;
  b=Ci2+SNlqvgomNATxupsstiFz+RxreCYLWR5AiM5O5CEos/XmNQGDWPHP
   cY85qyYdRMdsD5IibK2uBTG1foHUdM7rS4aAdqpvie1pGgIXcu3E6U0UL
   ONP2eEhqsox2QbwGv5cuGmsxuzelqYN2c1cl+bdHNSR2HPUSDW1SH1bOh
   tVdh3ady5cTNjsPm9cY406Mj3rTcpqiyU3l5tjEoX7UOR/VLbRqqZc1ng
   WDdn9Wf9R8ox5YAt58RdToJSljzWzoaefyJtwnGt5HOBjTC0wZssvmEdb
   AGq1WoG8Sn8Xio/Z/GiHReZP+b/q1TZz4IJlDWY2YcRSGTh12Fns8Mf8l
   Q==;
X-CSE-ConnectionGUID: l6jVH5BgRJ+enhmYREu8Ng==
X-CSE-MsgGUID: IalmG1saTRyybv/3RcMjKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="63791285"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="63791285"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:26:45 -0700
X-CSE-ConnectionGUID: qQltWVofRkGtozbSVlDTAg==
X-CSE-MsgGUID: 9r1A/kbTSOGSdbvQ2MB4pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="189847076"
Received: from vverma7-desk1.amr.corp.intel.com (HELO desk) ([10.124.223.151])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:26:43 -0700
Date: Wed, 29 Oct 2025 14:26:43 -0700
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
Subject: [PATCH 2/3] x86/mmio: Rename cpu_buf_vm_clear to
 cpu_buf_vm_clear_mmio_only
Message-ID: <20251029-verw-vm-v1-2-babf9b961519@linux.intel.com>
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

cpu_buf_vm_clear static key is only used by the MMIO Stale Data mitigation.
Rename it to avoid mixing it up with X86_FEATURE_CLEAR_CPU_BUF_VM.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/include/asm/nospec-branch.h | 2 +-
 arch/x86/kernel/cpu/bugs.c           | 8 ++++----
 arch/x86/kvm/mmu/spte.c              | 2 +-
 arch/x86/kvm/vmx/vmx.c               | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 08ed5a2e46a5fd790bcb1b73feb6469518809c06..cb46f5d188de47834466474ec8030bb2a2e4fdf3 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -580,7 +580,7 @@ DECLARE_STATIC_KEY_FALSE(cpu_buf_idle_clear);
 
 DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
 
-DECLARE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
+DECLARE_STATIC_KEY_FALSE(cpu_buf_vm_clear_mmio_only);
 
 extern u16 x86_verw_sel;
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 6d00a9ea7b4f28da291114a7a096b26cc129b57e..e7c31c23fbeeb1aba4f538934c1e8a997adff522 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -197,8 +197,8 @@ DEFINE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
  * X86_FEATURE_CLEAR_CPU_BUF_VM, and should only be enabled when KVM-only
  * mitigation is required.
  */
-DEFINE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
-EXPORT_SYMBOL_GPL(cpu_buf_vm_clear);
+DEFINE_STATIC_KEY_FALSE(cpu_buf_vm_clear_mmio_only);
+EXPORT_SYMBOL_GPL(cpu_buf_vm_clear_mmio_only);
 
 #undef pr_fmt
 #define pr_fmt(fmt)	"mitigations: " fmt
@@ -750,9 +750,9 @@ static void __init mmio_apply_mitigation(void)
 	 */
 	if (verw_clear_cpu_buf_mitigation_selected) {
 		setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF);
-		static_branch_disable(&cpu_buf_vm_clear);
+		static_branch_disable(&cpu_buf_vm_clear_mmio_only);
 	} else {
-		static_branch_enable(&cpu_buf_vm_clear);
+		static_branch_enable(&cpu_buf_vm_clear_mmio_only);
 	}
 	setup_force_cpu_cap(X86_FEATURE_CLEAR_CPU_BUF_VM);
 
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 37647afde7d3acfa1301a771ac44792eab879495..380d6675027499715e49e5b35ef76e17451fd77b 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -292,7 +292,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
 	}
 
-	if (static_branch_unlikely(&cpu_buf_vm_clear) &&
+	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only) &&
 	    !kvm_vcpu_can_access_host_mmio(vcpu) &&
 	    kvm_is_mmio_pfn(pfn, &is_host_mmio))
 		kvm_track_host_mmio_mapping(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f87c216d976d7d344c924aa4cc18fe1bf8f9b731..451be757b3d1b2fec6b2b79157f26dd43bc368b8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -903,7 +903,7 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
 	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
 		flags |= VMX_RUN_SAVE_SPEC_CTRL;
 
-	if (static_branch_unlikely(&cpu_buf_vm_clear) &&
+	if (static_branch_unlikely(&cpu_buf_vm_clear_mmio_only) &&
 	    kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
 		flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
 

-- 
2.34.1



