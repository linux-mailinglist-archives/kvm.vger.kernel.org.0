Return-Path: <kvm+bounces-9912-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 53AC8867924
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:55:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0A112828C2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E77145324;
	Mon, 26 Feb 2024 14:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k9wdROLO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D5F1420DA;
	Mon, 26 Feb 2024 14:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958239; cv=none; b=tF+sA2x1GzrBizQg9um2Pk37beIB6T/kpMJ9Do2m+tUPclCUn+s4/my1ImE1FYgkBiCnjvM5BLgsfFTjGmDbwL4ZEB4+zIzmo+wai2WcHo+eweCfdzCUYNnQ4wRw9P+wdFW3jWdOoRPhencXkskLuFlSyFi1F4FFxGxKjOXzwik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958239; c=relaxed/simple;
	bh=llmkTWOAec6cDScmK8+FHAQ4llySQV//Sto5/x2wJt4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M6oNpWCMhgPb/PYgSlpi7MMYJEhPj+Cs10F/7Xe7R5T3B0oGkCZKR7dfjxGyazdRn/I/L8w93FFYJgJSJEIrz4A2kOU3jItWg2jqLtTtpDxUJg/8gOkjLcMjCsjliHG5YJAWkWKiVnyPoOPWg0LnnV09ryC0byIsznWkELa9goE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k9wdROLO; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5a058b9bd2dso1430383eaf.2;
        Mon, 26 Feb 2024 06:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958237; x=1709563037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ykebOMEhe42hVzZj9dP5i+rdn/qFbIaVrdxgINn/tr0=;
        b=k9wdROLOyvwHuBHNcfxN9Am/Nyyn0/VOCKv1+pi6Ziyt2GTQDB2dlLQlvoxjHtjpyq
         9lzToBexSRO31RpztlcJagtuFvlyN0jLOfMHRVuvhDZhi5KlMSp7Rav7ce2Mp6txVoNt
         6+SmpZR5gHWvvahR1ghbm/D5vsmBn4sPeha6tUVMjVGW29Jws53HSM3ZpdAZdk0WbjtY
         MOOxE7Er/hidX2gFgfw5P2pmtxdsKPEZvH/bn2ZRa6zj8Co9KolUn1zxrVss+wGWxjgE
         KlF7+qFCR9wZNrCa4kE55Ek2aJtvLrotEz4T4VxyVBZ+Dcigt/CzAo8TU6vF9WhZaMRY
         aB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958237; x=1709563037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ykebOMEhe42hVzZj9dP5i+rdn/qFbIaVrdxgINn/tr0=;
        b=paNwf/7relrXgy6rtB7Q3evD/s4ICFt9V/r4X1DwkDMbRMTP9FOoeFgB2A3eKs8OvG
         UgDPrSyKydCito6r4n3xBYWmXzMcmSrlPPxtcaWjY4Cu6oiWPWzUPGojbZlNC+ylMFii
         rUtcbMQeXqi7xAhq2+faRMav/beSfeU944f2VftsJ3UlJbWmlEHU9msOhWI+JuGl9WpO
         CdFNLrcVVMbyLCmhmjvs1oFFBF67/2bq6OdcuUY/osEFkE4Bqtm9Gou1w4y4CYFLcTz9
         TXEM174Nxh+Yitd+C+7W/eBH3kkzcgqGaQJ2EwPdiUNhBIvSe5itwI0drMnbnr36MCkC
         zj1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUUzabg0gTuqJ8VriLOKNH16zpUMdcUbo7Ymt7YT/hwxsBbT9t8BNP4lW+nUV9vAMNVn1W0yBeq9lmJ6RmOE9k/hJxs
X-Gm-Message-State: AOJu0YyISOrGrrUZzv8rCD//Y+RqyaIi5rAbF/rTmGuT3AlEdgXmJMbx
	0krMl7yvUYnE/pxFlrF6e+cSgG+FQp2EIdiWEg7K0+vnYz2afJYv3Lycc6UD
X-Google-Smtp-Source: AGHT+IHJKCdVjrIAJjKbEQPVzAmdRI/uDh7uFII5PW1H93GcBZt4ZQV27iVaUqhBwEHgUMLpQnh6qA==
X-Received: by 2002:a05:6359:4c1b:b0:17b:ac0e:a6ba with SMTP id kj27-20020a0563594c1b00b0017bac0ea6bamr4415509rwc.22.1708958237086;
        Mon, 26 Feb 2024 06:37:17 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id j5-20020a63ec05000000b005dc8702f0a9sm4132218pgh.1.2024.02.26.06.37.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:37:16 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 49/73] KVM: x86/PVM: Implement emulation for non-PVM mode
Date: Mon, 26 Feb 2024 22:36:06 +0800
Message-Id: <20240226143630.33643-50-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

The PVM hypervisor supports a modified long mode with PVM ABI, known as
PVM mode. PVM mode includes a 64-bit supervisor mode, 64-bit user mode,
and a 32-bit compatible user mode. The 32-bit supervisor mode and other
operating modes are considered non-PVM modes. In PVM mode, the states of
system registers are standard, and the guest is allowed to run on the
hardware. So far, non-PVM mode is required for booting the guest and
bringing up vCPUs. Currently, there is only basic support for non-PVM
mode through instruction emulation.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 145 +++++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/pvm/pvm.h |   1 +
 2 files changed, 139 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index b261309fc946..e4b8f0108c31 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -12,6 +12,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#include <linux/entry-kvm.h>
 
 #include <asm/gsseg.h>
 #include <asm/io_bitmap.h>
@@ -218,6 +219,104 @@ static void pvm_update_guest_cpuid_faulting(struct kvm_vcpu *vcpu, u64 data)
 	preempt_enable();
 }
 
+/*
+ * Non-PVM mode is not a part of PVM.  Basic support for it via emulation.
+ * Non-PVM mode is required for booting the guest and bringing up vCPUs so far.
+ *
+ * In future, when VMM can directly boot the guest and bring vCPUs up from
+ * 64-bit mode without any help from non-64-bit mode, then the support non-PVM
+ * mode will be removed.
+ */
+#define CONVERT_TO_PVM_CR0_OFF	(X86_CR0_NW | X86_CR0_CD)
+#define CONVERT_TO_PVM_CR0_ON	(X86_CR0_NE | X86_CR0_AM | X86_CR0_WP | \
+				 X86_CR0_PG | X86_CR0_PE)
+
+static bool try_to_convert_to_pvm_mode(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	unsigned long cr0 = vcpu->arch.cr0;
+
+	if (!is_long_mode(vcpu))
+		return false;
+	if (!pvm->segments[VCPU_SREG_CS].l) {
+		if (is_smod(pvm))
+			return false;
+		if (!pvm->segments[VCPU_SREG_CS].db)
+			return false;
+	}
+
+	/* Atomically set EFER_SCE converting to PVM mode. */
+	if ((vcpu->arch.efer | EFER_SCE) != vcpu->arch.efer)
+		vcpu->arch.efer |= EFER_SCE;
+
+	/* Change CR0 on converting to PVM mode. */
+	cr0 &= ~CONVERT_TO_PVM_CR0_OFF;
+	cr0 |= CONVERT_TO_PVM_CR0_ON;
+	if (cr0 != vcpu->arch.cr0)
+		kvm_set_cr0(vcpu, cr0);
+
+	/* Atomically set MSR_STAR on converting to PVM mode. */
+	if (!kernel_cs_by_msr(pvm->msr_star))
+		pvm->msr_star = ((u64)pvm->segments[VCPU_SREG_CS].selector << 32) |
+				((u64)__USER32_CS << 48);
+
+	pvm->non_pvm_mode = false;
+
+	return true;
+}
+
+static int handle_non_pvm_mode(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	int ret = 1;
+	unsigned int count = 130;
+
+	if (try_to_convert_to_pvm_mode(vcpu))
+		return 1;
+
+	while (pvm->non_pvm_mode && count-- != 0) {
+		if (kvm_test_request(KVM_REQ_EVENT, vcpu))
+			return 1;
+
+		if (try_to_convert_to_pvm_mode(vcpu))
+			return 1;
+
+		ret = kvm_emulate_instruction(vcpu, 0);
+
+		if (!ret)
+			goto out;
+
+		/* don't do mode switch in emulation */
+		if (!is_smod(pvm))
+			goto emulation_error;
+
+		if (vcpu->arch.exception.pending)
+			goto emulation_error;
+
+		if (vcpu->arch.halt_request) {
+			vcpu->arch.halt_request = 0;
+			ret = kvm_emulate_halt_noskip(vcpu);
+			goto out;
+		}
+		/*
+		 * Note, return 1 and not 0, vcpu_run() will invoke
+		 * xfer_to_guest_mode() which will create a proper return
+		 * code.
+		 */
+		if (__xfer_to_guest_mode_work_pending())
+			return 1;
+	}
+
+out:
+	return ret;
+
+emulation_error:
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
+	vcpu->run->internal.ndata = 0;
+	return 0;
+}
+
 // switch_to_smod() and switch_to_umod() switch the mode (smod/umod) and
 // the CR3.  No vTLB flushing when switching the CR3 per PVM Spec.
 static inline void switch_to_smod(struct kvm_vcpu *vcpu)
@@ -359,6 +458,10 @@ static void pvm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 	if (pvm->loaded_cpu_state)
 		return;
 
+	// we can't load guest state to hardware when guest is not on long mode
+	if (unlikely(pvm->non_pvm_mode))
+		return;
+
 	pvm->loaded_cpu_state = 1;
 
 #ifdef CONFIG_X86_IOPL_IOPERM
@@ -1138,6 +1241,11 @@ static void pvm_get_segment(struct kvm_vcpu *vcpu,
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
 
+	if (pvm->non_pvm_mode) {
+		*var = pvm->segments[seg];
+		return;
+	}
+
 	// Update CS or SS to reflect the current mode.
 	if (seg == VCPU_SREG_CS) {
 		if (is_smod(pvm)) {
@@ -1209,7 +1317,7 @@ static void pvm_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int
 			if (cpl != var->dpl)
 				goto invalid_change;
 			if (cpl == 0 && !var->l)
-				goto invalid_change;
+				pvm->non_pvm_mode = true;
 		}
 		break;
 	case VCPU_SREG_LDTR:
@@ -1231,12 +1339,17 @@ static void pvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
 
-	if (pvm->hw_cs == __USER_CS) {
-		*db = 0;
-		*l = 1;
+	if (pvm->non_pvm_mode) {
+		*db = pvm->segments[VCPU_SREG_CS].db;
+		*l = pvm->segments[VCPU_SREG_CS].l;
 	} else {
-		*db = 1;
-		*l = 0;
+		if (pvm->hw_cs == __USER_CS) {
+			*db = 0;
+			*l = 1;
+		} else {
+			*db = 1;
+			*l = 0;
+		}
 	}
 }
 
@@ -1513,7 +1626,7 @@ static void pvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	 * user mode, so that when the guest switches back to supervisor mode,
 	 * the X86_EFLAGS_IF is already cleared.
 	 */
-	if (!need_update || !is_smod(pvm))
+	if (unlikely(pvm->non_pvm_mode) || !need_update || !is_smod(pvm))
 		return;
 
 	if (rflags & X86_EFLAGS_IF) {
@@ -1536,7 +1649,11 @@ static u32 pvm_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 
 static void pvm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 {
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
 	/* PVM spec: ignore interrupt shadow when in PVM mode. */
+	if (pvm->non_pvm_mode)
+		pvm->int_shadow = mask;
 }
 
 static void enable_irq_window(struct kvm_vcpu *vcpu)
@@ -2212,6 +2329,9 @@ static int pvm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
 	u32 exit_reason = pvm->exit_vector;
 
+	if (unlikely(pvm->non_pvm_mode))
+		return handle_non_pvm_mode(vcpu);
+
 	if (exit_reason == PVM_SYSCALL_VECTOR)
 		return handle_exit_syscall(vcpu);
 	else if (exit_reason >= 0 && exit_reason < FIRST_EXTERNAL_VECTOR)
@@ -2546,6 +2666,13 @@ static fastpath_t pvm_vcpu_run(struct kvm_vcpu *vcpu)
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
 	bool is_smod_befor_run = is_smod(pvm);
 
+	/*
+	 * Don't enter guest if guest state is invalid, let the exit handler
+	 * start emulation until we arrive back to a valid state.
+	 */
+	if (pvm->non_pvm_mode)
+		return EXIT_FASTPATH_NONE;
+
 	trace_kvm_entry(vcpu);
 
 	pvm_load_guest_xsave_state(vcpu);
@@ -2657,6 +2784,10 @@ static void pvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	if (!boot_cpu_has(X86_FEATURE_CPUID_FAULT))
 		vcpu->arch.msr_platform_info &= ~MSR_PLATFORM_INFO_CPUID_FAULT;
 
+	// Non-PVM mode resets
+	pvm->non_pvm_mode = true;
+	pvm->msr_star = 0;
+
 	// X86 resets
 	for (i = 0; i < ARRAY_SIZE(pvm->segments); i++)
 		reset_segment(&pvm->segments[i], i);
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index e49d9dc70a94..1a4feddb13b3 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -106,6 +106,7 @@ struct vcpu_pvm {
 
 	int loaded_cpu_state;
 	int int_shadow;
+	bool non_pvm_mode;
 	bool nmi_mask;
 
 	unsigned long guest_dr7;
-- 
2.19.1.6.gb485710b


