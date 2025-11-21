Return-Path: <kvm+bounces-64244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E42DFC7B883
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:34:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 89EF235CA7B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D986A303A3C;
	Fri, 21 Nov 2025 19:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Li3eok0Y"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02FB30102F
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 19:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763753550; cv=none; b=aE6kMmZ9CwB08l+ofU0OSfT5wx2S++f4LsvvpJI8lAU9cqojaxlID4/4tZBIw8W0MNySlKsdV4UCUQxa1IydZ5o5aom79f3wRrEG0Fl6BqxWnreN05TfADwFmdDLhpmeDqkC7e+RVXPYsfgVS+2tmj1Mp2FWFugSja6y/nBt2wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763753550; c=relaxed/simple;
	bh=q4779enIlpIZ/M7xTWWkuOCJtBgoZfGwhoeNudGanw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4XdLMYQA7rmpTJ+wom8hVNiOcdpDZGmuNjEwSzSiaie+dc42awzgxoZowvBijpW2bDEy/MamoqMhNmGomQD5GewAh8UfCqVFOi3g8bsuwvy79hQFCS9r/yRhuOKwedfDy2PqM+bO4hOkNEWTMd/EWvvwsaCDyrJ/Jtbjnjkiko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Li3eok0Y; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763753545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MUQekoanX4MF7SAslz8LER0NkRAktod+nMDf79bvmH4=;
	b=Li3eok0YbZP/MvK9X/blz5vRG7nnTCdj+p10pIMsd+Ek+Wb51TuYpC1n5HqX7W8ttq0Duv
	xYUgXuFa7nCSjqYjVP1P8VL6PvCGIT9RPWxCNtqEFAE6XHfMP70A7bD50Y6K+WSRCeW4v3
	CGXNfaNes+/ZjUx0yT0hInc/DM1+UJo=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Ken Hofsass <hofsass@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 1/3] KVM: x86: Add CR3 to guest debug info
Date: Fri, 21 Nov 2025 19:32:02 +0000
Message-ID: <20251121193204.952988-2-yosry.ahmed@linux.dev>
In-Reply-To: <20251121193204.952988-1-yosry.ahmed@linux.dev>
References: <20251121193204.952988-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add the value of CR3 to the information returned to userspace on
KVM_EXIT_DEBUG. Use KVM_CAP_X86_GUEST_DEBUG_CR3 to advertise this.

During guest debugging, the value of CR3 can be used by VM debuggers to
(roughly) identify the process running in the guest. This can be used to
index debugging events by process, or filter events from some processes
and quickly skip them.

Currently, debuggers would need to use the KVM_GET_SREGS ioctl on every
event to get the value of CR3, which considerably slows things down.
This can be easily avoided by adding the value of CR3 to the captured
debugging info.

Signed-off-by: Ken Hofsass <hofsass@google.com>
Co-developed-by: Ken Hofsass <hofsass@google.com>
Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/svm/svm.c          | 2 ++
 arch/x86/kvm/vmx/vmx.c          | 2 ++
 arch/x86/kvm/x86.c              | 3 +++
 include/uapi/linux/kvm.h        | 1 +
 5 files changed, 9 insertions(+)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7ceff6583652..c351e458189b 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -293,6 +293,7 @@ struct kvm_debug_exit_arch {
 	__u64 pc;
 	__u64 dr6;
 	__u64 dr7;
+	__u64 cr3;
 };
 
 #define KVM_GUESTDBG_USE_SW_BP		0x00010000
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f56c2d895011..85982e96b927 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1920,6 +1920,7 @@ static int db_interception(struct kvm_vcpu *vcpu)
 		kvm_run->debug.arch.dr7 = svm->vmcb->save.dr7;
 		kvm_run->debug.arch.pc =
 			svm->vmcb->save.cs.base + svm->vmcb->save.rip;
+		kvm_run->debug.arch.cr3 = svm->vmcb->save.cr3;
 		kvm_run->debug.arch.exception = DB_VECTOR;
 		return 0;
 	}
@@ -1934,6 +1935,7 @@ static int bp_interception(struct kvm_vcpu *vcpu)
 
 	kvm_run->exit_reason = KVM_EXIT_DEBUG;
 	kvm_run->debug.arch.pc = svm->vmcb->save.cs.base + svm->vmcb->save.rip;
+	kvm_run->debug.arch.cr3 = svm->vmcb->save.cr3;
 	kvm_run->debug.arch.exception = BP_VECTOR;
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4cbe8c84b636..9fd8a6140af4 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5454,6 +5454,7 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
 		kvm_run->debug.arch.exception = ex_no;
+		kvm_run->debug.arch.cr3 = kvm_read_cr3(vcpu);
 		break;
 	case AC_VECTOR:
 		if (vmx_guest_inject_ac(vcpu)) {
@@ -5685,6 +5686,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 			vcpu->run->debug.arch.dr6 = DR6_BD | DR6_ACTIVE_LOW;
 			vcpu->run->debug.arch.dr7 = dr7;
 			vcpu->run->debug.arch.pc = kvm_get_linear_rip(vcpu);
+			vcpu->run->debug.arch.cr3 = kvm_read_cr3(vcpu);
 			vcpu->run->debug.arch.exception = DB_VECTOR;
 			vcpu->run->exit_reason = KVM_EXIT_DEBUG;
 			return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0c6d899d53dd..636ad63ac34a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4855,6 +4855,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_MEMORY_FAULT_INFO:
 	case KVM_CAP_X86_GUEST_MODE:
 	case KVM_CAP_ONE_REG:
+	case KVM_CAP_X86_GUEST_DEBUG_CR3:
 		r = 1;
 		break;
 	case KVM_CAP_PRE_FAULT_MEMORY:
@@ -9195,6 +9196,7 @@ static int kvm_vcpu_do_singlestep(struct kvm_vcpu *vcpu)
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
 		kvm_run->debug.arch.dr6 = DR6_BS | DR6_ACTIVE_LOW;
 		kvm_run->debug.arch.pc = kvm_get_linear_rip(vcpu);
+		kvm_run->debug.arch.cr3 = kvm_read_cr3(vcpu);
 		kvm_run->debug.arch.exception = DB_VECTOR;
 		kvm_run->exit_reason = KVM_EXIT_DEBUG;
 		return 0;
@@ -9277,6 +9279,7 @@ static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
 		if (dr6 != 0) {
 			kvm_run->debug.arch.dr6 = dr6 | DR6_ACTIVE_LOW;
 			kvm_run->debug.arch.pc = eip;
+			kvm_run->debug.arch.cr3 = kvm_read_cr3(vcpu);
 			kvm_run->debug.arch.exception = DB_VECTOR;
 			kvm_run->exit_reason = KVM_EXIT_DEBUG;
 			*r = 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 52f6000ab020..58842b74fca1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -963,6 +963,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
+#define KVM_CAP_X86_GUEST_DEBUG_CR3 245
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.52.0.rc2.455.g230fcf2819-goog


