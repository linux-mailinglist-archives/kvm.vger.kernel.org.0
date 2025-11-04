Return-Path: <kvm+bounces-62005-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F0BC32770
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 18:55:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 478CA189E359
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 17:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B9B33DED9;
	Tue,  4 Nov 2025 17:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b="ng785WiB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED4B33DECC
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762278937; cv=none; b=u7RBdjIkYts1PiV/NA7Sc34xvxCy39HwEBttyQ2nWvCs1SfsTt2MNSn+dee9mbqTAUR0iw661Ccbcbx90LFvOm5XYk9fQNm+/v8dIGU0XOEdhXp2fRVIVYUqgROf6Wcb2DIxf3Gz5spNILmqihwlSj66WuTznGam1LjQ07U9xb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762278937; c=relaxed/simple;
	bh=Ns9touSbmWL005gMfkb5Fc1ImJ+7OPCtVopg0dxgteQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Rs+s+vPfFGPQRJI2uOW/+AAD8cueZOHH22x3rAdnGywUMhvhwfw605NSJY5Dlg2uVVYj3rU2G2v/yWyWLn/9QOHWuTX4Rhl6zFmYfjt31R4/4sAwITvRfpwPcNNtR8HzMaU7kd34bPa/4pvLV/Tc5H/8rD4uM5NtZ5NdrY8DAfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com; spf=none smtp.mailfrom=osandov.com; dkim=pass (2048-bit key) header.d=osandov-com.20230601.gappssmtp.com header.i=@osandov-com.20230601.gappssmtp.com header.b=ng785WiB; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osandov.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7adc44440c6so69512b3a.3
        for <kvm@vger.kernel.org>; Tue, 04 Nov 2025 09:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20230601.gappssmtp.com; s=20230601; t=1762278935; x=1762883735; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LcNL8ALLmXVyH8B9LPT35aiVTJwd6Qa/CtPhJUExtKU=;
        b=ng785WiBXF8vmS6NAK8ejZmou9+74A05Kas8E1WQQXUmwVrsbr5zPF896LQsagiZyf
         8s62NfW0T73oBt89uJr6Yu/r8RCRTQSFMjlnJ4RHZGP0v/EzcyLP5EXLrQE0Bge/8JYM
         xSyWFe1VQZnkf8rOV8ggDH3Y0XAJXiAf/EsxaKR4PtiMrW/p2TQ6QVnnrfVYVBx6spDc
         hVrIoKQ0ZdUOzD7i5YuEymf2+M7bRleBkiqKUkdjSTSwlHnz/AuluaFTVeTqyftoY2KP
         bE1M5LfXe9tiSwScBxYZgBlPi87ons5VFlWmoKEDepstW6b5hNG4GF1fOLD85bpPfi2j
         GU8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762278935; x=1762883735;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LcNL8ALLmXVyH8B9LPT35aiVTJwd6Qa/CtPhJUExtKU=;
        b=pgmpjrpyFRgZYX7j+3y2x3pllDTIHDJJpgoMpggUuBpa/Rxy9IVeJi9fIwA/S4D4Xh
         CN0ZS1t1AOuUfQy5v1lh8ezwlRiT0g5G7zAeYlKGZ/qAhyPtxDHrZ2Qxgy1N9KSZp3DG
         LymzTZiKHwh1raMCZ0ayaePJnmBkoDMzWWJENBiGC2TZeOtXVdhH8nHjjByJ0N3pA1Jg
         8zGHoOufc2ZuttcojF86LoU6ZdrYgaP4BAEYz0fSi7AFLPFqQSaVu5xSde39tU+Jry8f
         Cz7DJn4FftBo8xU9u4+S5X1wlxbK01/0l1CUrhIxn89z2f3fkQqkhHr7+rIWvEzw6Ili
         8rpg==
X-Forwarded-Encrypted: i=1; AJvYcCVeXGdovsGhIEESFfSBmUgIVW1/kaYnBoK5FIw3ZWAS395jVuiu+CyT7gN8hfjCRRoJnvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIEKQuWli0NfFen15SbrAG3u0fRUL4ExE2Ivcpqgp/x7+RJ3L9
	cDCp6sP/9G64gJ41avjfeb8Za8Jpk1CdL+J1yn46BGRwB/y+8dGprmaCdyRJJuhVhVY=
X-Gm-Gg: ASbGncsWx8BVPI+Q8EpJ/wAFspHn8kj1Yu47et8sGmALgX2yFh8z884Qj3GeDeXPM32
	1zPG9TsIbUCbiC0HEaNi1Tt+B6vXr6Jm2hygwPa1/LLlZB/mgsv299fVUY7SQhnIplvPBR4BZGn
	YoY2HU8J3HgrNMhKOrHrqGNsFK+McjsqHFiiTThmkiDzTH9QuzgfBFPfUlJNHIUSUD+YRo4McXv
	UzGmOzF/Od+0lvzELcweFDCpom4cE0AtWiBB5/eLSo1sWptEk38cElrNcrsSBEXy3HgrlC/6UBY
	S/WGUj255li3ZPTyF5RWJo6CmODz2KPagVKoZ+QE/zNP0n2AmDxwK4HG9KoKj6jP+24RuonV5Gp
	18eKLb/dGegwRNaZxsj+f1p6tFh0o/GSuqJmFgWlKKenzre+/+vnabCcaQ61pt5F2Uj7QNNI=
X-Google-Smtp-Source: AGHT+IEgQ0avsse0iSFO7AY8lQaN0rPaEUZwl8nhqTfF56Tdo5836ZHnq/+rcn6gEGPNnK+B4BqQJw==
X-Received: by 2002:a05:6a20:12c3:b0:342:41fd:38d5 with SMTP id adf61e73a8af0-34f87107a75mr76263637.7.1762278935093;
        Tue, 04 Nov 2025 09:55:35 -0800 (PST)
Received: from telecaster.tfbnw.net ([2620:10d:c090:400::5:5bc5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd3247ef3sm3620878b3a.11.2025.11.04.09.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 09:55:34 -0800 (PST)
From: Omar Sandoval <osandov@osandov.com>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org
Cc: Gregory Price <gourry@gourry.net>,
	kernel-team@fb.com
Subject: [PATCH v3] KVM: SVM: Don't skip unrelated instruction if INT3/INTO is replaced
Date: Tue,  4 Nov 2025 09:55:26 -0800
Message-ID: <1cc6dcdf36e3add7ee7c8d90ad58414eeb6c3d34.1762278762.git.osandov@fb.com>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Omar Sandoval <osandov@fb.com>

When re-injecting a soft interrupt from an INT3, INT0, or (select) INTn
instruction, discard the exception and retry the instruction if the code
stream is changed (e.g. by a different vCPU) between when the CPU
executes the instruction and when KVM decodes the instruction to get the
next RIP.

As effectively predicted by commit 6ef88d6e36c2 ("KVM: SVM: Re-inject
INT3/INTO instead of retrying the instruction"), failure to verify that
the correct INTn instruction was decoded can effectively clobber guest
state due to decoding the wrong instruction and thus specifying the
wrong next RIP.

The bug most often manifests as "Oops: int3" panics on static branch
checks in Linux guests.  Enabling or disabling a static branch in Linux
uses the kernel's "text poke" code patching mechanism.  To modify code
while other CPUs may be executing that code, Linux (temporarily)
replaces the first byte of the original instruction with an int3 (opcode
0xcc), then patches in the new code stream except for the first byte,
and finally replaces the int3 with the first byte of the new code
stream.  If a CPU hits the int3, i.e. executes the code while it's being
modified, then the guest kernel must look up the RIP to determine how to
handle the #BP, e.g. by emulating the new instruction.  If the RIP is
incorrect, then this lookup fails and the guest kernel panics.

The bug reproduces almost instantly by hacking the guest kernel to
repeatedly check a static branch[1] while running a drgn script[2] on
the host to constantly swap out the memory containing the guest's TSS.

[1]: https://gist.github.com/osandov/44d17c51c28c0ac998ea0334edf90b5a
[2]: https://gist.github.com/osandov/10e45e45afa29b11e0c7209247afc00b

Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")
Cc: stable@vger.kernel.org
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Omar Sandoval <osandov@fb.com>
---
Changes from v2 (https://lore.kernel.org/all/6ab4e8e5c5d6ea95f568a1ff8044779137dce428.1761774582.git.osandov@fb.com/):

- Fixed EMULTYPE_SET_SOFT_INT_VECTOR -> EMULTYPE_GET_SOFT_INT_VECTOR
  typo.
- Added explicit u32 cast to EMULTYPE_SET_SOFT_INT_VECTOR to make it
  clear that it won't overflow.
- Rebased on Linus's tree as of c9cfc122f03711a5124b4aafab3211cf4d35a2ac.

 arch/x86/include/asm/kvm_host.h |  9 +++++++++
 arch/x86/kvm/svm/svm.c          | 24 +++++++++++++-----------
 arch/x86/kvm/x86.c              | 21 +++++++++++++++++++++
 3 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..974d64bf0a4d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2143,6 +2143,11 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
  *			     the gfn, i.e. retrying the instruction will hit a
  *			     !PRESENT fault, which results in a new shadow page
  *			     and sends KVM back to square one.
+ *
+ * EMULTYPE_SKIP_SOFT_INT - Set in combination with EMULTYPE_SKIP to only skip
+ *                          an instruction if it could generate a given software
+ *                          interrupt, which must be encoded via
+ *                          EMULTYPE_SET_SOFT_INT_VECTOR().
  */
 #define EMULTYPE_NO_DECODE	    (1 << 0)
 #define EMULTYPE_TRAP_UD	    (1 << 1)
@@ -2153,6 +2158,10 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
 #define EMULTYPE_PF		    (1 << 6)
 #define EMULTYPE_COMPLETE_USER_EXIT (1 << 7)
 #define EMULTYPE_WRITE_PF_TO_SP	    (1 << 8)
+#define EMULTYPE_SKIP_SOFT_INT	    (1 << 9)
+
+#define EMULTYPE_SET_SOFT_INT_VECTOR(v)	((u32)((v) & 0xff) << 16)
+#define EMULTYPE_GET_SOFT_INT_VECTOR(e)	(((e) >> 16) & 0xff)
 
 static inline bool kvm_can_emulate_event_vectoring(int emul_type)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 153c12dbf3eb..a9fb60bbd1c7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -272,6 +272,7 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 }
 
 static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
+					   int emul_type,
 					   bool commit_side_effects)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -293,7 +294,7 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 		if (unlikely(!commit_side_effects))
 			old_rflags = svm->vmcb->save.rflags;
 
-		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+		if (!kvm_emulate_instruction(vcpu, emul_type))
 			return 0;
 
 		if (unlikely(!commit_side_effects))
@@ -311,11 +312,13 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 
 static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-	return __svm_skip_emulated_instruction(vcpu, true);
+	return __svm_skip_emulated_instruction(vcpu, EMULTYPE_SKIP, true);
 }
 
-static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
+static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu, u8 vector)
 {
+	const int emul_type = EMULTYPE_SKIP | EMULTYPE_SKIP_SOFT_INT |
+			      EMULTYPE_SET_SOFT_INT_VECTOR(vector);
 	unsigned long rip, old_rip = kvm_rip_read(vcpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
@@ -331,7 +334,7 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 	 * in use, the skip must not commit any side effects such as clearing
 	 * the interrupt shadow or RFLAGS.RF.
 	 */
-	if (!__svm_skip_emulated_instruction(vcpu, !nrips))
+	if (!__svm_skip_emulated_instruction(vcpu, emul_type, !nrips))
 		return -EIO;
 
 	rip = kvm_rip_read(vcpu);
@@ -367,7 +370,7 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 	kvm_deliver_exception_payload(vcpu, ex);
 
 	if (kvm_exception_is_soft(ex->vector) &&
-	    svm_update_soft_interrupt_rip(vcpu))
+	    svm_update_soft_interrupt_rip(vcpu, ex->vector))
 		return;
 
 	svm->vmcb->control.event_inj = ex->vector
@@ -3637,11 +3640,12 @@ static bool svm_set_vnmi_pending(struct kvm_vcpu *vcpu)
 
 static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
+	struct kvm_queued_interrupt *intr = &vcpu->arch.interrupt;
 	struct vcpu_svm *svm = to_svm(vcpu);
 	u32 type;
 
-	if (vcpu->arch.interrupt.soft) {
-		if (svm_update_soft_interrupt_rip(vcpu))
+	if (intr->soft) {
+		if (svm_update_soft_interrupt_rip(vcpu, intr->nr))
 			return;
 
 		type = SVM_EVTINJ_TYPE_SOFT;
@@ -3649,12 +3653,10 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 		type = SVM_EVTINJ_TYPE_INTR;
 	}
 
-	trace_kvm_inj_virq(vcpu->arch.interrupt.nr,
-			   vcpu->arch.interrupt.soft, reinjected);
+	trace_kvm_inj_virq(intr->nr, intr->soft, reinjected);
 	++vcpu->stat.irq_injections;
 
-	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
-				       SVM_EVTINJ_VALID | type;
+	svm->vmcb->control.event_inj = intr->nr | SVM_EVTINJ_VALID | type;
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..9dc66cca154d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9338,6 +9338,23 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
 	return false;
 }
 
+static bool is_soft_int_instruction(struct x86_emulate_ctxt *ctxt,
+				    int emulation_type)
+{
+	u8 vector = EMULTYPE_GET_SOFT_INT_VECTOR(emulation_type);
+
+	switch (ctxt->b) {
+	case 0xcc:
+		return vector == BP_VECTOR;
+	case 0xcd:
+		return vector == ctxt->src.val;
+	case 0xce:
+		return vector == OF_VECTOR;
+	default:
+		return false;
+	}
+}
+
 /*
  * Decode an instruction for emulation.  The caller is responsible for handling
  * code breakpoints.  Note, manually detecting code breakpoints is unnecessary
@@ -9448,6 +9465,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * injecting single-step #DBs.
 	 */
 	if (emulation_type & EMULTYPE_SKIP) {
+		if (emulation_type & EMULTYPE_SKIP_SOFT_INT &&
+		    !is_soft_int_instruction(ctxt, emulation_type))
+			return 0;
+
 		if (ctxt->mode != X86EMUL_MODE_PROT64)
 			ctxt->eip = (u32)ctxt->_eip;
 		else
-- 
2.51.1


