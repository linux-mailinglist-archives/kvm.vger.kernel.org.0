Return-Path: <kvm+bounces-9905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C657867913
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:52:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 321E5293F7C
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:52:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0603913AA23;
	Mon, 26 Feb 2024 14:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PDNLVYDu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A449E13A879;
	Mon, 26 Feb 2024 14:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958217; cv=none; b=KKtPaSOE8hm5oU0gYUGXf7KIvZpYVe+alI5sKA7xlmpmMjp9GkBGEKADinXKPSz8/3K5fqx8GwkWRP2B2906UZO/gK8uWQG0wWwBWpHXAI2gFB5ZGJp95IhFojynXhaGR2R4NTXg/Wz3Ta1d7APLpV+9HDcIf8EKBn+4F+ts+74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958217; c=relaxed/simple;
	bh=QvIfkotJQxMfa11Ye+5Mx3wJUOol1gW3+VkFSNADlgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M29P2vdem1OjHlksJjqjywDbtnQZrUDmhm1qKcvm1LEyfDFt7hOKJ4IvNWFUp96CGXh7LPyd3XzLqaMR61U9keQRh7Yg/u4S3BQ6T8F1ZdHGyZpXLDBfGiXHX2J6KHKKos2zjzDjA1wQ1Cnrz4s0O4ywyyMXYt39PBF0ZsuCRkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PDNLVYDu; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6e0f43074edso2168511a34.1;
        Mon, 26 Feb 2024 06:36:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958214; x=1709563014; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HdqH8jVNXmEu4zs1zan2Z9bnYeRZlguwUihIbfO84eA=;
        b=PDNLVYDuhvgcfAQ5VsTHEfTR5kK26G412sx+wCWD6+hkKZ8441GE6au7P4C5lozW+Y
         ffjIA8e18VL9SnNmE8IitGQFu4bBGiK3W6+9Zgvclo39zcmpprr2zny9Om/viMQqmB/G
         roGDmCk2bXF94wDcawunQECGhZeKbjO0zinG3wb3BBwMJ+OYFHNzbRXt2LVsrK9A8i9L
         7V/ZdlGhKAXRIPdh7jWXIr5rht3FNOXvTl3l9ddHJmbuxTxHmP5IMsEpxBpAgmGjAUJ0
         nxiYr6M4/qsutgzgBXumth6iJSSZ2Z3CUM7HKDplkzfKbxCX6Iu+WFbZBL0EhuexUI/r
         MpqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958214; x=1709563014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HdqH8jVNXmEu4zs1zan2Z9bnYeRZlguwUihIbfO84eA=;
        b=YvdHQHsVs9fAZpfSJqOJk0c4Mn+HRlH8Gu8S829qVHgjze/Bw7ghU0TZ0qOHYztZQk
         1TcjwWH7WKLFITdADMSTGBUWHMECpRD4xnQZsSOKsu1+C59wjbYc64AA6HRCEiXai37i
         5rYbxbuP75CNiC9aRkWeT5bItQ/bFzIfBNKh6ZIoqkKriLkxmvrv2W5GJBDP9rLtYRGB
         UXv92AAWWR3QYbN5Qct/bxbteX9RLZdEGwLDT/wvwcjxexowUt3SKHaTi5oR2X5pOmwH
         kl6m1vRjjZ+oh5tTX98F3yg8TPV8Otol51iDRUfGl7gRSRniSIgNEp5ixoP9GAXiI0CF
         TRKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlmXSvpFPrNAWQsMOk668SDXDCHAm9uCEWYMfDLU8JR83KDdJEH/FFtyXlbTrZqcYfE1obsgSN5c3ipWLT90pOht+M
X-Gm-Message-State: AOJu0YxS8PhHJ3IF327hVzN5iQmAwP8Ufmy76/XL2R7kimau2aWYbp6g
	ubYtREn2G7TAT3LEweqqvchAYj8Hix9XZ9Cf4xtnMRaMn1kR0Q7FyMaLmmFw
X-Google-Smtp-Source: AGHT+IGzhilLnOqDnW8DtlnwMh+tC9Pj86iMFec5r5I9e0Ve/nJKQ5bcBi6m3xQOLVYQTSM7JwtmLA==
X-Received: by 2002:a05:6358:4428:b0:17a:def8:5687 with SMTP id z40-20020a056358442800b0017adef85687mr5692172rwc.27.1708958214434;
        Mon, 26 Feb 2024 06:36:54 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id d4-20020a634f04000000b005d8b2f04eb7sm3922538pgb.62.2024.02.26.06.36.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:54 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
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
Subject: [RFC PATCH 42/73] KVM: x86/PVM: Support for kvm_exit() tracepoint
Date: Mon, 26 Feb 2024 22:35:59 +0800
Message-Id: <20240226143630.33643-43-jiangshanlai@gmail.com>
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

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

Similar to VMX/SVM, add necessary information to support kvm_exit()
tracepoint.

Suggested-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 41 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/pvm/pvm.h | 35 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/trace.h   |  7 ++++++-
 3 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index e68052f33186..6ac599587567 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -1996,6 +1996,43 @@ static int pvm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	return 0;
 }
 
+static u32 pvm_get_syscall_exit_reason(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	unsigned long rip = kvm_rip_read(vcpu);
+
+	if (is_smod(pvm)) {
+		if (rip == pvm->msr_retu_rip_plus2)
+			return PVM_EXIT_REASONS_ERETU;
+		else if (rip == pvm->msr_rets_rip_plus2)
+			return PVM_EXIT_REASONS_ERETS;
+		else
+			return PVM_EXIT_REASONS_HYPERCALL;
+	}
+
+	return PVM_EXIT_REASONS_SYSCALL;
+}
+
+static void pvm_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1, u64 *info2,
+			      u32 *intr_info, u32 *error_code)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	if (pvm->exit_vector == PVM_SYSCALL_VECTOR)
+		*reason = pvm_get_syscall_exit_reason(vcpu);
+	else if (pvm->exit_vector == IA32_SYSCALL_VECTOR)
+		*reason = PVM_EXIT_REASONS_INT80;
+	else if (pvm->exit_vector >= FIRST_EXTERNAL_VECTOR &&
+		 pvm->exit_vector < NR_VECTORS)
+		*reason = PVM_EXIT_REASONS_INTERRUPT;
+	else
+		*reason = pvm->exit_vector;
+	*info1 = pvm->exit_vector;
+	*info2 = pvm->exit_error_code;
+	*intr_info = pvm->exit_vector;
+	*error_code = pvm->exit_error_code;
+}
+
 static void pvm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_pvm *pvm = to_pvm(vcpu);
@@ -2298,6 +2335,8 @@ static fastpath_t pvm_vcpu_run(struct kvm_vcpu *vcpu)
 	mark_page_dirty_in_slot(vcpu->kvm, pvm->pvcs_gpc.memslot,
 				pvm->pvcs_gpc.gpa >> PAGE_SHIFT);
 
+	trace_kvm_exit(vcpu, KVM_ISA_PVM);
+
 	return EXIT_FASTPATH_NONE;
 }
 
@@ -2627,6 +2666,8 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.refresh_apicv_exec_ctrl = pvm_refresh_apicv_exec_ctrl,
 	.deliver_interrupt = pvm_deliver_interrupt,
 
+	.get_exit_info = pvm_get_exit_info,
+
 	.vcpu_after_set_cpuid = pvm_vcpu_after_set_cpuid,
 
 	.check_intercept = pvm_check_intercept,
diff --git a/arch/x86/kvm/pvm/pvm.h b/arch/x86/kvm/pvm/pvm.h
index f28ab0b48f40..2f8fdb0ae3df 100644
--- a/arch/x86/kvm/pvm/pvm.h
+++ b/arch/x86/kvm/pvm/pvm.h
@@ -10,6 +10,41 @@
 #define PVM_SYSCALL_VECTOR		SWITCH_EXIT_REASONS_SYSCALL
 #define PVM_FAILED_VMENTRY_VECTOR	SWITCH_EXIT_REASONS_FAILED_VMETNRY
 
+#define PVM_EXIT_REASONS_SHIFT		16
+#define PVM_EXIT_REASONS_SYSCALL	(1UL << PVM_EXIT_REASONS_SHIFT)
+#define PVM_EXIT_REASONS_HYPERCALL	(2UL << PVM_EXIT_REASONS_SHIFT)
+#define PVM_EXIT_REASONS_ERETU		(3UL << PVM_EXIT_REASONS_SHIFT)
+#define PVM_EXIT_REASONS_ERETS		(4UL << PVM_EXIT_REASONS_SHIFT)
+#define PVM_EXIT_REASONS_INTERRUPT	(5UL << PVM_EXIT_REASONS_SHIFT)
+#define PVM_EXIT_REASONS_INT80		(6UL << PVM_EXIT_REASONS_SHIFT)
+
+#define PVM_EXIT_REASONS		\
+	{ DE_VECTOR, "DE excp" },	\
+	{ DB_VECTOR, "DB excp" },	\
+	{ NMI_VECTOR, "NMI excp" },	\
+	{ BP_VECTOR, "BP excp" },	\
+	{ OF_VECTOR, "OF excp" },	\
+	{ BR_VECTOR, "BR excp" },	\
+	{ UD_VECTOR, "UD excp" },	\
+	{ NM_VECTOR, "NM excp" },	\
+	{ DF_VECTOR, "DF excp" },	\
+	{ TS_VECTOR, "TS excp" },	\
+	{ SS_VECTOR, "SS excp" },	\
+	{ GP_VECTOR, "GP excp" },	\
+	{ PF_VECTOR, "PF excp" },	\
+	{ MF_VECTOR, "MF excp" },	\
+	{ AC_VECTOR, "AC excp" },	\
+	{ MC_VECTOR, "MC excp" },	\
+	{ XM_VECTOR, "XM excp" },	\
+	{ VE_VECTOR, "VE excp" },	\
+	{ PVM_EXIT_REASONS_SYSCALL, "SYSCALL" },	\
+	{ PVM_EXIT_REASONS_HYPERCALL, "HYPERCALL" },	\
+	{ PVM_EXIT_REASONS_ERETU, "ERETU" },		\
+	{ PVM_EXIT_REASONS_ERETS, "ERETS" },		\
+	{ PVM_EXIT_REASONS_INTERRUPT, "INTERRUPT" },	\
+	{ PVM_EXIT_REASONS_INT80, "INT80" },		\
+	{ PVM_FAILED_VMENTRY_VECTOR, "FAILED_VMENTRY" }
+
 #define PT_L4_SHIFT		39
 #define PT_L4_SIZE		(1UL << PT_L4_SHIFT)
 #define DEFAULT_RANGE_L4_SIZE	(32 * PT_L4_SIZE)
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 83843379813e..3d6549679e98 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -8,6 +8,8 @@
 #include <asm/clocksource.h>
 #include <asm/pvclock-abi.h>
 
+#include "pvm/pvm.h"
+
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvm
 
@@ -282,11 +284,14 @@ TRACE_EVENT(kvm_apic,
 
 #define KVM_ISA_VMX   1
 #define KVM_ISA_SVM   2
+#define KVM_ISA_PVM   3
 
 #define kvm_print_exit_reason(exit_reason, isa)				\
 	(isa == KVM_ISA_VMX) ?						\
 	__print_symbolic(exit_reason & 0xffff, VMX_EXIT_REASONS) :	\
-	__print_symbolic(exit_reason, SVM_EXIT_REASONS),		\
+	((isa == KVM_ISA_SVM) ?						\
+	__print_symbolic(exit_reason, SVM_EXIT_REASONS) :		\
+	__print_symbolic(exit_reason, PVM_EXIT_REASONS)),		\
 	(isa == KVM_ISA_VMX && exit_reason & ~0xffff) ? " " : "",	\
 	(isa == KVM_ISA_VMX) ?						\
 	__print_flags(exit_reason & ~0xffff, " ", VMX_EXIT_REASON_FLAGS) : ""
-- 
2.19.1.6.gb485710b


