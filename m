Return-Path: <kvm+bounces-60084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A567BBDFD26
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 19:14:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E6D56485BB6
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 17:14:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A412C33A01D;
	Wed, 15 Oct 2025 17:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YWzWa9J3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70273376B8
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 17:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760548446; cv=none; b=GsSJ+rFTOjwmfxrbqmIMhLBVTBE9osY3D1zxZV4HUdMzlm9tQqoaqnroHjkIVm9b3J8XFHA6nRaTIiz4Pv/n5rmpfYTH3M0BLT4JaBqDwGuaQOk96N+U4742gXM3sAx5xfcoB/w3tHrkz8xD8hg/o5lq67GWlijyunC7OkQm56k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760548446; c=relaxed/simple;
	bh=Hab7fHDfDjE0Y/wHSkX4u0aYBvabsid/PwoR0nxnWmc=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qcXZX6TVTEMxhj3ylmo9+paE+HFqGDuOoVfraBDZSeoB5Qk21wRQYbWEt2Oe51hB8YuP0Z8W6SivTtamBLwFKhVA1rrRfvl/SP9s0rvH1yAjggdv94srPkCBSRXVcHW8TP4n0Hv5jAiKofmQtwOvBFLeGT/AIxtTFXfTkggb7eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YWzWa9J3; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4256fae4b46so4964328f8f.0
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 10:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760548443; x=1761153243; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BUc6JEVovpC/n0lisIRRlrZC5viDRiRLArSH+3NnX+g=;
        b=YWzWa9J3/c5HJNrC+m5dJ6IT7IQpPkb3TFFlhFe7lrV9NjMXFS49/wCGY/O4vo/M7A
         43/ftYcFBJCB/aIVa/U000pH06QV5i9RTv0nQ8RkEHO2g4l1cNklv3Sh/6jap1US2ajD
         mYWFMmlgoLVotyGZvPKC+t1nMirDbyF5Dw+iEoNXgAsod1IHobww/XCC+wQN362lZiEv
         DQcandmIoAvNtxXuDDv4R/3JzLFCgsJwE+qq+2qbG46jIzfEs/ambt3GtKkxUNZaRbWa
         Sd61TG0fS+lp2zGu2P73CX8IJ0DvzOZng6/bEBbhGBpvmXmbPPyoPex3xOXtn+GzT71v
         VeXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760548443; x=1761153243;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BUc6JEVovpC/n0lisIRRlrZC5viDRiRLArSH+3NnX+g=;
        b=dGEDxZDDE4pQbpJ5gGha15y48FY5mpzGW1te3QssjelQPzmVx751/CoTkF//on7Psq
         WY2hvg/atjJgA6J3ky09SDVGZMiB0b5ArQMStT/QatoUk8Pv0ol/qDfAUmXqKU1tGgZY
         AwyHrdhWUGaIupGw8WcBUM9WwVIyxsw2alV0f/CWlgLoaOThRBrPTMcEJgmlahmXYYvb
         PvUXcGKA3dA5Q9wi4ByPEDztjxBaQFruMIlsoxXrnUdS0dKGU5E3mbNrZJUO2CePt0Pu
         6Ds1tJFb0fXw9i+/eo80JpjJ1GOXlHm+xWXiHs7sDrnrww4EGSUZ/kEOl+sfFgpzFUqW
         hf6w==
X-Forwarded-Encrypted: i=1; AJvYcCWVWJZ/hOQl68NarTaiYaPqcIsvjnNnzNQDMO9/HYwyyZzIp/55gnFdCOvGfgEEPESY8EI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHjO4/CuIyye4/4EauX9ARwO8WXVGUMTQVCF6n55EXa9LuJB4G
	9YrS9zBUwoxEY6gsJHDKvAkEHx7HJyV9sPgFEi9qBh07oEOHj0YBTqGiBXV+ign4K+60K/jpbe6
	aKCcedCCK/0baIQ==
X-Google-Smtp-Source: AGHT+IHBr6W0XUlE5qvroBz9EmQK5wN/7aWoshMW5hIgeTFZ2bOcdfRnDTjCDcamT99WzGXInPIRcaoc1n1zgw==
X-Received: from wruk18.prod.google.com ([2002:a5d:6292:0:b0:424:21b0:f156])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:26cc:b0:425:8134:706 with SMTP id ffacd0b85a97d-42667177f6emr20491027f8f.16.1760548443016;
 Wed, 15 Oct 2025 10:14:03 -0700 (PDT)
Date: Wed, 15 Oct 2025 17:13:55 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAFLW72gC/3XMQQ6CMBCF4auQWTuGAYqVlfcwLGqZQhOkpMVGQ
 3p3K3uX/0vet0NgbzlAV+zgOdpg3ZKjOhWgJ7WMjHbIDVVZCSqpxkeDM20GV/Z6feHlWpMko4S UDeTT6tnY9wHe+9yTDZvzn8OP9Fv/UpGQcGiFFnXbsiJ1G50bZz5r94Q+pfQFZY3yBK0AAAA=
X-Change-Id: 20251013-b4-l1tf-percpu-793181fa5884
X-Mailer: b4 0.14.2
Message-ID: <20251015-b4-l1tf-percpu-v2-1-6d7a8d3d40e9@google.com>
Subject: [PATCH v2] KVM: x86: Unify L1TF flushing under per-CPU variable
From: Brendan Jackman <jackmanb@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"

Currently the tracking of the need to flush L1D for L1TF is tracked by
two bits: one per-CPU and one per-vCPU.

The per-vCPU bit is always set when the vCPU shows up on a core, so
there is no interesting state that's truly per-vCPU. Indeed, this is a
requirement, since L1D is a part of the physical CPU.

So simplify this by combining the two bits.

The vCPU bit was being written from preemption-enabled regions. For
those cases, use raw_cpu_write() (via a variant of the setter function)
to avoid DEBUG_PREEMPT failures. If the vCPU is getting migrated, the
CPU that gets its bit set in these paths is not important; vcpu_load()
must always set it on the destination CPU before the guest is resumed.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Changes in v2:
- Moved the bit back to irq_stat
- Fixed DEBUG_PREEMPT issues by adding a _raw variant
- Link to v1: https://lore.kernel.org/r/20251013-b4-l1tf-percpu-v1-1-d65c5366ea1a@google.com
---
 arch/x86/include/asm/hardirq.h  |  6 ++++++
 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/vmx.c          | 20 +++++---------------
 arch/x86/kvm/x86.c              |  6 +++---
 6 files changed, 16 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/hardirq.h b/arch/x86/include/asm/hardirq.h
index f00c09ffe6a95f07342bb0c6cea3769d71eecfa9..8a5c5deadb5912cc9ae080740c8a7372e6ef7577 100644
--- a/arch/x86/include/asm/hardirq.h
+++ b/arch/x86/include/asm/hardirq.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_HARDIRQ_H
 #define _ASM_X86_HARDIRQ_H
 
+#include <linux/percpu.h>
 #include <linux/threads.h>
 
 typedef struct {
@@ -78,6 +79,11 @@ static __always_inline void kvm_set_cpu_l1tf_flush_l1d(void)
 	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
 }
 
+static __always_inline void kvm_set_cpu_l1tf_flush_l1d_raw(void)
+{
+	raw_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 1);
+}
+
 static __always_inline void kvm_clear_cpu_l1tf_flush_l1d(void)
 {
 	__this_cpu_write(irq_stat.kvm_cpu_l1tf_flush_l1d, 0);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f3f07263a2ffffe670be2658eb9cb..fcdc65ab13d8383018577aacf19e832e6c4ceb0b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1055,9 +1055,6 @@ struct kvm_vcpu_arch {
 	/* be preempted when it's in kernel-mode(cpl=0) */
 	bool preempted_in_kernel;
 
-	/* Flush the L1 Data cache for L1TF mitigation on VMENTER */
-	bool l1tf_flush_l1d;
-
 	/* Host CPU on which VM-entry was most recently attempted */
 	int last_vmentry_cpu;
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 667d66cf76d5e52c22f9517914307244ae868eea..8c0dce401a42d977756ca82d249bb33c858b9c9f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4859,7 +4859,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 	 */
 	BUILD_BUG_ON(lower_32_bits(PFERR_SYNTHETIC_MASK));
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_set_cpu_l1tf_flush_l1d();
 	if (!flags) {
 		trace_kvm_page_fault(vcpu, fault_address, error_code);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 76271962cb7083b475de6d7d24bf9cb918050650..1d376b4e6aa4abc475c1aac2ee937dbedb834cb1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3880,7 +3880,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		goto vmentry_failed;
 
 	/* Hide L1D cache contents from the nested guest.  */
-	vmx->vcpu.arch.l1tf_flush_l1d = true;
+	kvm_set_cpu_l1tf_flush_l1d_raw();
 
 	/*
 	 * Must happen outside of nested_vmx_enter_non_root_mode() as it will
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 546272a5d34da301710df1d89414f41fc9b24a1f..6515beefa1fc8da042c0b66c207250ccf79c888e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6673,26 +6673,16 @@ static noinstr void vmx_l1d_flush(struct kvm_vcpu *vcpu)
 	 * 'always'
 	 */
 	if (static_branch_likely(&vmx_l1d_flush_cond)) {
-		bool flush_l1d;
-
 		/*
-		 * Clear the per-vcpu flush bit, it gets set again if the vCPU
+		 * Clear the per-cpu flush bit, it gets set again if the vCPU
 		 * is reloaded, i.e. if the vCPU is scheduled out or if KVM
 		 * exits to userspace, or if KVM reaches one of the unsafe
-		 * VMEXIT handlers, e.g. if KVM calls into the emulator.
+		 * VMEXIT handlers, e.g. if KVM calls into the emulator,
+		 * or from the interrupt handlers.
 		 */
-		flush_l1d = vcpu->arch.l1tf_flush_l1d;
-		vcpu->arch.l1tf_flush_l1d = false;
-
-		/*
-		 * Clear the per-cpu flush bit, it gets set again from
-		 * the interrupt handlers.
-		 */
-		flush_l1d |= kvm_get_cpu_l1tf_flush_l1d();
-		kvm_clear_cpu_l1tf_flush_l1d();
-
-		if (!flush_l1d)
+		if (!kvm_get_cpu_l1tf_flush_l1d())
 			return;
+		kvm_clear_cpu_l1tf_flush_l1d();
 	}
 
 	vcpu->stat.l1d_flush++;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4b8138bd48572fd161eda73d2dbdc1dcd0bcbcac..dc886c4b9b1fe3d63a4c255ed4fc533d20fd1962 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5190,7 +5190,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_set_cpu_l1tf_flush_l1d();
 
 	if (vcpu->scheduled_out && pmu->version && pmu->event_count) {
 		pmu->need_cleanup = true;
@@ -8000,7 +8000,7 @@ int kvm_write_guest_virt_system(struct kvm_vcpu *vcpu, gva_t addr, void *val,
 				unsigned int bytes, struct x86_exception *exception)
 {
 	/* kvm_write_guest_virt_system can pull in tons of pages. */
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_set_cpu_l1tf_flush_l1d_raw();
 
 	return kvm_write_guest_virt_helper(addr, val, bytes, vcpu,
 					   PFERR_WRITE_MASK, exception);
@@ -9396,7 +9396,7 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		return handle_emulation_failure(vcpu, emulation_type);
 	}
 
-	vcpu->arch.l1tf_flush_l1d = true;
+	kvm_set_cpu_l1tf_flush_l1d_raw();
 
 	if (!(emulation_type & EMULTYPE_NO_DECODE)) {
 		kvm_clear_exception_queue(vcpu);

---
base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
change-id: 20251013-b4-l1tf-percpu-793181fa5884

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


