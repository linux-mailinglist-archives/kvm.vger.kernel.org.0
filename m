Return-Path: <kvm+bounces-9904-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AC17867911
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:52:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA5D71F2DEC6
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9121112CDAF;
	Mon, 26 Feb 2024 14:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MF2Te05o"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61FE13A27E;
	Mon, 26 Feb 2024 14:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958214; cv=none; b=J98nMspZxKi6boeC+2NPygnH/VaRbUA5mtfoXwhB2ZfrgYpxogWHCL61tB9p60Ny6W95CULavXL0sJ4pQgtNTdlJOX+0FL4ViJiS91fm9v4P+cKFU6Gfe8Z5roHPVpXnlpbJBcDTDHGLy4yY9JxVY3UJwYVQSIDjw0+vEJIl/zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958214; c=relaxed/simple;
	bh=Hf0BNKBIZ56qS48eJNOQyF5J6qUwZwEo0QFLiddsBX8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fQxcEKLXwc1bZX8cYIcjI5C/sbwi5iRupGDf/OyNwd6UoIgbCUlaFcu7M2rZ20K6oIrkBmxRpbk9uEqI8lUpUGvNwXzka0v0F6CWjWiA9Hg2TrsMx2E6WnJoykEbkWuQM2gtd7qzoTkHtpkpRWGx9lcZmRK8ydV/wth/QF10CdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MF2Te05o; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5a09c79bb2dso256390eaf.2;
        Mon, 26 Feb 2024 06:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958211; x=1709563011; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uOInb/lRonlNK+MHppezKyZznP49HjtDhF1ZnprcgPA=;
        b=MF2Te05oosZ4bIwtKWK6nj6T3FNe3rt5FV42bJUBSD4On9DYu6rwycd+4VFBeU6R6F
         57xBS+NpMalgqp17wrHyRKpuclEaAIa4VxmGwNOKpZXGV/kAihiQkfrgVsrM7yPl1dsL
         k/4TFYvRLncs1ioqYql0KzW98ynNHgmgzN//dynbeljM8Wh+xSSOpDGG/oYY1Ai8Vq+U
         u+DkEwEneiNSGnUawctbud9cNBZBXW0J32sus2WGkQw7M0KdXrT2ABn59HVBhVyYannx
         mkzThQpERed4lWAQ5GKuIyp3z8k5dFjFZyJxwzhCp8a+JNi40etubw/Z5LxLJ6m1ZJ/M
         RGFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958211; x=1709563011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uOInb/lRonlNK+MHppezKyZznP49HjtDhF1ZnprcgPA=;
        b=fLoGXyZSjw7xBTTYmrjNMK83kzmpUQw6xsjqjdpWBhZF+JCDIPr3lsbF9ss0twbuxP
         mVRhfOknguM3XUnQGwof3LrGS7mMo2wQFTuqKgDD7vLxkgS2G0NnRe1ynoNbuAFar0dv
         Nayz8ayGO51fe1zZm3+DhjnLAV8nP63WWfNdfVcXEvO/SS8L9Y4cROab8L3NhfkgfJ7C
         jDGzDs/3RBOF0pcW7rH+oBs43dmVEP2ka9ekIIuUK8IrkDLr55HeblK5ozkGu+KKCYJJ
         Z+3e8w3/08tcfH8rYHhhPaw42byJ99LCKPr3RVjuES4pPDInkehBdEnrW+uk31Un0ncm
         MoiQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/vZM9uiiE8hCugzWkHrofVVTHCXB7viM6EFVkkFxXIIcoK07cqqA9tISOW1DOB8VsMMsmp1A5hzj4a0myDClHmwfW
X-Gm-Message-State: AOJu0YxLRt8RBVyfzyA6wClxPyIj2Ba3z5wxJVxBr3wUaSpyMyx9OcsF
	wUh7Zaro+IYRTfyB9Fjx8/thpEh+08gVobn6zkIitnMWz4xCGNObrDSC+9Kx
X-Google-Smtp-Source: AGHT+IFLnhttqMOFxckoM1wrT4XTJOBuizOceWWP2mvuPI+Y3DasCYzrbMYy8iyVtW5bJc17zqiXTg==
X-Received: by 2002:a05:6358:9226:b0:179:ff:2486 with SMTP id d38-20020a056358922600b0017900ff2486mr9648425rwb.29.1708958211198;
        Mon, 26 Feb 2024 06:36:51 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id e6-20020a63ee06000000b005dc491ccdcesm4051500pgi.14.2024.02.26.06.36.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:50 -0800 (PST)
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
Subject: [RFC PATCH 41/73] KVM: x86/PVM: Allow to load guest TLS in host GDT
Date: Mon, 26 Feb 2024 22:35:58 +0800
Message-Id: <20240226143630.33643-42-jiangshanlai@gmail.com>
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

The 32-bit process needs to use TLS in libc, so a hypercall is
introduced to load the guest TLS into the host GDT. The checking of the
guest TLS is the same as tls_desc_okay() in the arch/x86/kernel/tls.c
file.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 81 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h |  1 +
 2 files changed, 82 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index ee55e99fb204..e68052f33186 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -281,6 +281,26 @@ static void segments_save_guest_and_switch_to_host(struct vcpu_pvm *pvm)
 	wrmsrl(MSR_FS_BASE, current->thread.fsbase);
 }
 
+/*
+ * Load guest TLS entries into the GDT.
+ */
+static inline void host_gdt_set_tls(struct vcpu_pvm *pvm)
+{
+	struct desc_struct *gdt = get_current_gdt_rw();
+	unsigned int i;
+
+	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++)
+		gdt[GDT_ENTRY_TLS_MIN + i] = pvm->tls_array[i];
+}
+
+/*
+ * Load current task's TLS into the GDT.
+ */
+static inline void host_gdt_restore_tls(void)
+{
+	native_load_tls(&current->thread, smp_processor_id());
+}
+
 static void pvm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
@@ -304,6 +324,8 @@ static void pvm_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
 		native_tss_invalidate_io_bitmap();
 #endif
 
+	host_gdt_set_tls(pvm);
+
 #ifdef CONFIG_MODIFY_LDT_SYSCALL
 	/* PVM doesn't support LDT. */
 	if (unlikely(current->mm->context.ldt))
@@ -334,6 +356,8 @@ static void pvm_prepare_switch_to_host(struct vcpu_pvm *pvm)
 		kvm_load_ldt(GDT_ENTRY_LDT*8);
 #endif
 
+	host_gdt_restore_tls();
+
 	segments_save_guest_and_switch_to_host(pvm);
 	pvm->loaded_cpu_state = 0;
 }
@@ -1629,6 +1653,60 @@ static int handle_hc_wrmsr(struct kvm_vcpu *vcpu, u32 index, u64 value)
 	return 1;
 }
 
+// Check if the tls desc is allowed on the host GDT.
+// The same logic as tls_desc_okay() in arch/x86/kernel/tls.c.
+static bool tls_desc_okay(struct desc_struct *desc)
+{
+	// Only allow present segments.
+	if (!desc->p)
+		return false;
+
+	// Only allow data segments.
+	if (desc->type & (1 << 3))
+		return false;
+
+	// Only allow 32-bit data segments.
+	if (!desc->d)
+		return false;
+
+	return true;
+}
+
+/*
+ * Hypercall: PVM_HC_LOAD_TLS
+ *	Load guest TLS desc into host GDT.
+ */
+static int handle_hc_load_tls(struct kvm_vcpu *vcpu, unsigned long tls_desc_0,
+			      unsigned long tls_desc_1, unsigned long tls_desc_2)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	unsigned long *tls_array = (unsigned long *)&pvm->tls_array[0];
+	int i;
+
+	tls_array[0] = tls_desc_0;
+	tls_array[1] = tls_desc_1;
+	tls_array[2] = tls_desc_2;
+
+	for (i = 0; i < GDT_ENTRY_TLS_ENTRIES; i++) {
+		if (!tls_desc_okay(&pvm->tls_array[i])) {
+			pvm->tls_array[i] = (struct desc_struct){0};
+			continue;
+		}
+		/* Standarding TLS descs, same as fill_ldt(). */
+		pvm->tls_array[i].type |= 1;
+		pvm->tls_array[i].s = 1;
+		pvm->tls_array[i].dpl = 0x3;
+		pvm->tls_array[i].l = 0;
+	}
+
+	preempt_disable();
+	if (pvm->loaded_cpu_state)
+		host_gdt_set_tls(pvm);
+	preempt_enable();
+
+	return 1;
+}
+
 static int handle_kvm_hypercall(struct kvm_vcpu *vcpu)
 {
 	int r;
@@ -1679,6 +1757,8 @@ static int handle_exit_syscall(struct kvm_vcpu *vcpu)
 		return handle_hc_rdmsr(vcpu, a0);
 	case PVM_HC_WRMSR:
 		return handle_hc_wrmsr(vcpu, a0, a1);
+	case PVM_HC_LOAD_TLS:
+		return handle_hc_load_tls(vcpu, a0, a1, a2);
 	default:
 		return handle_kvm_hypercall(vcpu);
 	}
@@ -2296,6 +2376,7 @@ static void pvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	pvm->hw_ss = __USER_DS;
 	pvm->int_shadow = 0;
 	pvm->nmi_mask = false;
+	memset(&pvm->tls_array[0], 0, sizeof(pvm->tls_array));
 
 	pvm->msr_vcpu_struct = 0;
 	pvm->msr_supervisor_rsp = 0;
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index 31060831e009..f28ab0b48f40 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -98,6 +98,7 @@ struct vcpu_pvm {
 	struct kvm_segment segments[NR_VCPU_SREG];
 	struct desc_ptr idt_ptr;
 	struct desc_ptr gdt_ptr;
+	struct desc_struct tls_array[GDT_ENTRY_TLS_ENTRIES];
 };
 
 struct kvm_pvm {
-- 
2.19.1.6.gb485710b


