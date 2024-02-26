Return-Path: <kvm+bounces-9885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C10768678DF
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:44:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E3F831C221A7
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72434133291;
	Mon, 26 Feb 2024 14:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZuFFqiG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F27132C2C;
	Mon, 26 Feb 2024 14:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958152; cv=none; b=DwVlYYMeVTac20peuS1RYMITc9EDCMxnvmxIb5ZA+oifKX8O2uOKd8qnk8HnzSiGkLmcrc2wCX6tk3xalBZBbUjp09W2y7bIqvuSnL2eL0uHlW0LEBfY58VAd2FNcKdbpMA5SUAUIC+X3K6cz6PBxKyP6U0dJ3PBJWrKCjd2+h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958152; c=relaxed/simple;
	bh=1vEfezG9QmRjQ8J3U1Aysh33N+lTsittc0ac1Dd6Rxg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eJirbmJJ+75WzxUb3E+cUNliqaelPGwDI9GA5tSCc97cbrQTH6Db1JQm2KuwcYbM7tD0d+rbr7q80eD7xL/qIQ6fwY28X3t/HiM+6XTFLCFj2hLKCV7y3dVuTAyuvp605OnEfSw3Rh19urkzq3JXEWnZY7OKCOzVaratRFQx0R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EZuFFqiG; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-5e42b4bbfa4so2299073a12.1;
        Mon, 26 Feb 2024 06:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958150; x=1709562950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEYgEPxnIogvnB7Zjz1HomLlX+OknwZSPNHHST0cuPA=;
        b=EZuFFqiGBF1LnvyJWBASWUZ/gpOEn8ZODCE2XB4VmTWRIb/rRBCoyC+QXhHKZe7rwx
         +8nSur37gYI+VZlMfNB3bAnJCPx9F7q9NhEmM9bT0GBj/czYJD8yin8B9Ov+yHEM4HUX
         hAdI6MqR10D55hKHPI/7aVwhXBCrD6jTLvYS5zCXD12DZuPLIX0BkBpiu1/tQkHMI9ot
         BD7uPBHaCzTYwU5u6s4819x0eYSTfUJclHXk/pRVtKr0EBljSfh1pkJwrCiPVQ0SZcv6
         GC9ET7wLThsTb+z2/IkJ8dgdF0OnPyjdGuFWXlJPP1FHfBp3E/+19kst9/NC+Bzo6VVk
         BAWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958150; x=1709562950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GEYgEPxnIogvnB7Zjz1HomLlX+OknwZSPNHHST0cuPA=;
        b=VbbShAuxKhYXUA7Wphj49zd7JMp79f1oQlWJHNMtiHDJgQl82iVUvGrMfM59KXi5LE
         UA6VnvKNIqBqyrwawA4mm9A5f+c7ps7xSu1aAPwrHUlwdUkfBfA+QoInP57sL7yi/WvE
         vWMhXXR3BSxUipocZrZMrIwKEEofzz8fvWMdZxqLxtlVb/L2/ROw3rCxDfapzOLhs7jy
         QVa0ySqAjI1nENGu1u2iFpv/WM3dPXihTNxy4cZZXAbdrBkV/gKNAgQAD9QP0zMvM+h8
         tf8aacDGkfjZpPwMRsBZ2WceK9b1nVizj5LEcWVkYsJOMImi22nZdu68DbdO+JTxGKss
         Z8VQ==
X-Forwarded-Encrypted: i=1; AJvYcCXv/lQGFw7iFTMBmQGUHz4hGfDCAZsFhkp3Zk21m31iN5iB6b088bHq6aX0CH9dFPy3VLsFGFAMhArp9vR4S/YOTG/G
X-Gm-Message-State: AOJu0YyECQf1EtaBFtGNolqlcN3mlfSmI+7+UeYbGPbpiK3baTM6Zy8z
	TESDaqlmG16ZwewVdjFjicOBibkclk1RitDvlGkEUU2OtgMGE6kB0bxbn3yR
X-Google-Smtp-Source: AGHT+IGXuqJi3oC1P9HsXiXL3F0CcvclMb8/tyAsW4SrKL+SdfZxtrL7dAPtTXQRkM5ULNQY0enwQw==
X-Received: by 2002:a17:90a:68c8:b0:299:42d1:91df with SMTP id q8-20020a17090a68c800b0029942d191dfmr5769463pjj.14.1708958150219;
        Mon, 26 Feb 2024 06:35:50 -0800 (PST)
Received: from localhost ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id t20-20020a17090ad15400b00299101c1341sm4541312pjw.18.2024.02.26.06.35.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:49 -0800 (PST)
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
Subject: [RFC PATCH 22/73] KVM: x86/PVM: Handle some VM exits before enable interrupts
Date: Mon, 26 Feb 2024 22:35:39 +0800
Message-Id: <20240226143630.33643-23-jiangshanlai@gmail.com>
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

Similar to VMX, NMI should be handled in non-instrumented code early
after VM exit. Additionally, #PF, #VE, #VC, and #DB need early handling
in non-instrumented code as well. Host interrupts and #MC need to be
handled before enabling interrupts.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 89 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h |  8 ++++
 2 files changed, 97 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 00a50ed0c118..29c6d8da7c19 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -265,6 +265,58 @@ static void pvm_setup_mce(struct kvm_vcpu *vcpu)
 {
 }
 
+static int handle_exit_external_interrupt(struct kvm_vcpu *vcpu)
+{
+	++vcpu->stat.irq_exits;
+	return 1;
+}
+
+static int handle_exit_failed_vmentry(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	u32 error_code = pvm->exit_error_code;
+
+	kvm_queue_exception_e(vcpu, GP_VECTOR, error_code);
+	return 1;
+}
+
+/*
+ * The guest has exited.  See if we can fix it or if we need userspace
+ * assistance.
+ */
+static int pvm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	u32 exit_reason = pvm->exit_vector;
+
+	if (exit_reason >= FIRST_EXTERNAL_VECTOR && exit_reason < NR_VECTORS)
+		return handle_exit_external_interrupt(vcpu);
+	else if (exit_reason == PVM_FAILED_VMENTRY_VECTOR)
+		return handle_exit_failed_vmentry(vcpu);
+
+	vcpu_unimpl(vcpu, "pvm: unexpected exit reason 0x%x\n", exit_reason);
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror =
+		KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = exit_reason;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	return 0;
+}
+
+static void pvm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	u32 vector = pvm->exit_vector;
+	gate_desc *desc = (gate_desc *)host_idt_base + vector;
+
+	if (vector >= FIRST_EXTERNAL_VECTOR && vector < NR_VECTORS &&
+	    vector != IA32_SYSCALL_VECTOR)
+		kvm_do_interrupt_irqoff(vcpu, gate_offset(desc));
+	else if (vector == MC_VECTOR)
+		kvm_machine_check();
+}
+
 static bool pvm_has_emulated_msr(struct kvm *kvm, u32 index)
 {
 	switch (index) {
@@ -369,6 +421,40 @@ static noinstr void pvm_vcpu_run_noinstr(struct kvm_vcpu *vcpu)
 	pvm->exit_vector = (ret_regs->orig_ax >> 32);
 	pvm->exit_error_code = (u32)ret_regs->orig_ax;
 
+	// handle noinstr vmexits reasons.
+	switch (pvm->exit_vector) {
+	case PF_VECTOR:
+		// if the exit due to #PF, check for async #PF.
+		pvm->exit_cr2 = read_cr2();
+		vcpu->arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
+		break;
+	case NMI_VECTOR:
+		kvm_do_nmi_irqoff(vcpu);
+		break;
+	case VE_VECTOR:
+		// TODO: pvm host is TDX guest.
+		// tdx_get_ve_info(&pvm->host_ve);
+		break;
+	case X86_TRAP_VC:
+		/*
+		 * TODO: pvm host is SEV guest.
+		 * if (!vc_is_db(error_code)) {
+		 *      collect info and handle the first part for #VC
+		 *      break;
+		 * } else {
+		 *      get_debugreg(pvm->exit_dr6, 6);
+		 *      set_debugreg(DR6_RESERVED, 6);
+		 * }
+		 */
+		break;
+	case DB_VECTOR:
+		get_debugreg(pvm->exit_dr6, 6);
+		set_debugreg(DR6_RESERVED, 6);
+		break;
+	default:
+		break;
+	}
+
 	guest_state_exit_irqoff();
 }
 
@@ -682,9 +768,12 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 
 	.vcpu_pre_run = pvm_vcpu_pre_run,
 	.vcpu_run = pvm_vcpu_run,
+	.handle_exit = pvm_handle_exit,
 
 	.vcpu_after_set_cpuid = pvm_vcpu_after_set_cpuid,
 
+	.handle_exit_irqoff = pvm_handle_exit_irqoff,
+
 	.sched_in = pvm_sched_in,
 
 	.nested_ops = &pvm_nested_ops,
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index 349f4eac98ec..123cfe1c3c6a 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -7,6 +7,8 @@
 
 #define SWITCH_FLAGS_INIT	(SWITCH_FLAGS_SMOD)
 
+#define PVM_FAILED_VMENTRY_VECTOR	SWITCH_EXIT_REASONS_FAILED_VMETNRY
+
 #define PT_L4_SHIFT		39
 #define PT_L4_SIZE		(1UL << PT_L4_SHIFT)
 #define DEFAULT_RANGE_L4_SIZE	(32 * PT_L4_SIZE)
@@ -35,6 +37,12 @@ struct vcpu_pvm {
 
 	u16 host_ds_sel, host_es_sel;
 
+	union {
+		unsigned long exit_extra;
+		unsigned long exit_cr2;
+		unsigned long exit_dr6;
+		struct ve_info exit_ve;
+	};
 	u32 exit_vector;
 	u32 exit_error_code;
 	u32 hw_cs, hw_ss;
-- 
2.19.1.6.gb485710b


