Return-Path: <kvm+bounces-63601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7959DC6BDA6
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:25:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B08954E29E3
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE5C325739;
	Tue, 18 Nov 2025 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gYqAVY++"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85EF231B12D
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504620; cv=none; b=MDyb1NVHXYO0y5Su0iSa0bR0kYbB40Tj0bWezDnMQCWRfAHCPjOoQOZ57+CyS0VheugMcjmbTMsdqABWrD+vYnuQi24VMjncvCPzPuuUb0bEtairMFcYxChx0Q7LYOc5URFpzIIB90gN4XW9821b0RK3j2OlV4sgoGVfjrHdTJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504620; c=relaxed/simple;
	bh=Z/DjTbMxxtwfS6uS1n7NXBorkMmU7tvMoEYXRuGPlFQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lOWF2NaHigJIm6IuOKc8zmCPDbtLdjxygz838lktl14UHuLBxOLkGhhaCCKunq6hJrEDQHHHE0EkTb9etn5d/DbUqz3lY+hsM23eHQ2yRtwG1IjvZKiCUtCZjIoN7uRxhy3x3PrYJbFR+/WhyJPv9Rqo0Wc5U/oznr3IWLt96Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gYqAVY++; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-297dfae179bso147049825ad.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763504618; x=1764109418; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=k6abdiQWX2NNeyGNyymJ5zH7pnooPhs4/ECKEvEmQik=;
        b=gYqAVY++AYmR9LlTNHqD4/4FxcCOidwUoSPEoZQO19ddolzD/G9brsKUTsaGedrO8j
         wrIvaTJj3WJkhKKngxgKUbFOp9jI8aie3+N4h6c0ZkJ+NragRcu57M+g/lqXRJkHZU9h
         xhQ00FxtTPYcGxxg8pKRErllfVKDrWszmj2MXx0p2hKWwrFSw2YffwCjXogRdue4P/zo
         lAiQhCYUHH7v5+NHHq3VWmCCR2q4iRFBPf3wFAgwsGf0km/+qJy7hcu46olV6NuXghZl
         0xj+zP8Ln9CjrU8SX4frSKrkIg+QYqE4TMmgVzgW0bt+4CWmQemEUCEJ/qrCqcGS3m73
         QyJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763504618; x=1764109418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k6abdiQWX2NNeyGNyymJ5zH7pnooPhs4/ECKEvEmQik=;
        b=Vt6kXDUC46+S/Yn/DLyC8nDmNwZdMkDp44a/8qs6IbXXLRH9Vz/3tVwD00sBA+sxLw
         hRntNHHULDofEoSxB+1+5v/jhLUn/3/HEbKadAgl5KCeK4DPfjcfqyDo0XqH0zLRx7Cv
         7UkThzPGPZZz2LHmBuGKqvTOacB84IH19pKq/jh2TLSeBarbDDnLDOUJ0Gccjr6nlA2Y
         F/xAogzb8JdYmw/1Ya5NvQ21WvGw2xkM78empBs3iR6UjHaMIRwARmUOKgCQm6DeDfeu
         xcQ0id8K3cavxA0ndX/JDwtEYyI7dSCxUjOZVOu+a/YyqWLNMiAJCUnmLf+dYvCcYpPR
         C58Q==
X-Gm-Message-State: AOJu0YzfVoOWHNFFwrN95JrV0Dawqq4CDhS0HImiRCzxquMjC5mVAvzO
	QVwHVnLFNEjzGsdatMBqS1kTiyD97NYIqnfZcGddcCQCkwqHMCddIZI+lI5lZpQJnxf/EuncghR
	Ql8f4oQ==
X-Google-Smtp-Source: AGHT+IGDcfTyticzqgBK5utKn+m9UElTi2gzKfFB2rNfhe1Y5J2SFjpR1n1x5g/sAvVBxZxGoKfHROFByYI=
X-Received: from plbko13.prod.google.com ([2002:a17:903:7cd:b0:297:ddac:51ad])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2b0e:b0:295:9d7f:9296
 with SMTP id d9443c01a7336-29a054a857amr6014265ad.45.1763504617836; Tue, 18
 Nov 2025 14:23:37 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 18 Nov 2025 14:23:28 -0800
In-Reply-To: <20251118222328.2265758-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251118222328.2265758-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251118222328.2265758-5-seanjc@google.com>
Subject: [PATCH v2 4/4] KVM: x86: Load guest/host PKRU outside of the fastpath
 run loop
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Jon Kohler <jon@nutanix.com>, Tony Lindgren <tony.lindgren@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Move KVM's swapping of PKRU outside of the fastpath loop, as there is no
KVM code anywhere in the fastpath that accesses guest/userspace memory,
i.e. that can consume protection keys.

As documented by commit 1be0e61c1f25 ("KVM, pkeys: save/restore PKRU when
guest/host switches"), KVM just needs to ensure the host's PKRU is loaded
when KVM (or the kernel at-large) may access userspace memory.  And at the
time of commit 1be0e61c1f25, KVM didn't have a fastpath, and PKU was
strictly contained to VMX, i.e. there was no reason to swap PKRU outside
of vmx_vcpu_run().

Over time, the "need" to swap PKRU close to VM-Enter was likely falsely
solidified by the association with XFEATUREs in commit 37486135d3a7
("KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it to x86.c"),
and XFEATURE swapping was in turn moved close to VM-Enter/VM-Exit as a
KVM hack-a-fix ution for an #MC handler bug by commit 1811d979c716
("x86/kvm: move kvm_load/put_guest_xcr0 into atomic context").

Deferring the PKRU loads shaves ~40 cycles off the fastpath for Intel,
and ~60 cycles for AMD.  E.g. using INVD in KVM-Unit-Test's vmexit.c,
with extra hacks to enable CR4.PKE and PKRU=(-1u & ~0x3), latency numbers
for AMD Turin go from ~1560 => ~1500, and for Intel Emerald Rapids, go
from ~810 => ~770.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Jon Kohler <jon@nutanix.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  2 --
 arch/x86/kvm/vmx/vmx.c |  4 ----
 arch/x86/kvm/x86.c     | 14 ++++++++++----
 arch/x86/kvm/x86.h     |  2 --
 4 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index bf34378ebe2d..1c67c1a6771d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4246,7 +4246,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 		svm_set_dr6(vcpu, DR6_ACTIVE_LOW);
 
 	clgi();
-	kvm_load_guest_xsave_state(vcpu);
 
 	/*
 	 * Hardware only context switches DEBUGCTL if LBR virtualization is
@@ -4289,7 +4288,6 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
 		update_debugctlmsr(vcpu->arch.host_debugctl);
 
-	kvm_load_host_xsave_state(vcpu);
 	stgi();
 
 	/* Any pending NMI will happen here */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f369c499b2c3..9b8a6405da95 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7475,8 +7475,6 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		vmx_set_interrupt_shadow(vcpu, 0);
 
-	kvm_load_guest_xsave_state(vcpu);
-
 	pt_guest_enter(vmx);
 
 	atomic_switch_perf_msrs(vmx);
@@ -7520,8 +7518,6 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 
 	pt_guest_exit(vmx);
 
-	kvm_load_host_xsave_state(vcpu);
-
 	if (is_guest_mode(vcpu)) {
 		/*
 		 * Track VMLAUNCH/VMRESUME that have made past guest state
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d8d547c5e014..9586a26eb27e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1246,7 +1246,7 @@ static void kvm_load_host_xfeatures(struct kvm_vcpu *vcpu)
 	}
 }
 
-void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
+static void kvm_load_guest_pkru(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.guest_state_protected)
 		return;
@@ -1257,9 +1257,8 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 	     kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE)))
 		wrpkru(vcpu->arch.pkru);
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_load_guest_xsave_state);
 
-void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
+static void kvm_load_host_pkru(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->arch.guest_state_protected)
 		return;
@@ -1272,7 +1271,6 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 			wrpkru(vcpu->arch.host_pkru);
 	}
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_load_host_xsave_state);
 
 #ifdef CONFIG_X86_64
 static inline u64 kvm_guest_supported_xfd(struct kvm_vcpu *vcpu)
@@ -11350,6 +11348,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	guest_timing_enter_irqoff();
 
+	/*
+	 * Swap PKRU with hardware breakpoints disabled to minimize the number
+	 * of flows where non-KVM code can run with guest state loaded.
+	 */
+	kvm_load_guest_pkru(vcpu);
+
 	for (;;) {
 		/*
 		 * Assert that vCPU vs. VM APICv state is consistent.  An APICv
@@ -11378,6 +11382,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		++vcpu->stat.exits;
 	}
 
+	kvm_load_host_pkru(vcpu);
+
 	/*
 	 * Do this here before restoring debug registers on the host.  And
 	 * since we do this before handling the vmexit, a DR access vmexit
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index f3dc77f006f9..24c754b0db2e 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -622,8 +622,6 @@ static inline void kvm_machine_check(void)
 #endif
 }
 
-void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
-void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
-- 
2.52.0.rc1.455.g30608eb744-goog


