Return-Path: <kvm+bounces-71083-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CDqdJfLPj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71083-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:29:22 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FCD913AAA1
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EF65F30A8D88
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D6828488F;
	Sat, 14 Feb 2026 01:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vHeMcmhb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A4A29ACDB
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032433; cv=none; b=Q6WTqXY+Hxw8lkCO7KvWFXzrsrEsj5zIi3Q9tTRQoHTnpClvosTMfS6mp0H1eM/PIOs8OOCXHI57iSO/cB0IBU9pTY+XUSfNcod7ZsUz5nLMNMFFB7R84AGs3HyrlHPO0qEqiY62hJOLzrXd7nFS8pkyoLQcly1MciBW0fM7hOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032433; c=relaxed/simple;
	bh=gnRLsQcZywazDuEdGGXGGq+fa2JWlZCKtOcI/j1sQ60=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ejoU758SM/nkgb66OBmYX0hMw+eDwC+nUqdrIHpb3qVVCJufM/5YhGQWDdcua55Zw8EKEqiIlqZdWUBR4v69ET7mUvkus+g/CYdBN3y6hY+bGb50eIua19gXAFZEayVHp3UV7NQo7K/TVffaUjwaQgptfwDvqRzAatk+pYfzwFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vHeMcmhb; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-824b05ba554so3464962b3a.1
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032431; x=1771637231; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=LlribCFdngaQSRseMvArVzR7Ue2wpxs9f06/EhF3nRU=;
        b=vHeMcmhbQyG4zdBO/z9AEYaEFKIN4P87I9An6Ii9awX7yFFAi9Z0skbcusdMkICY5M
         DBF4H0UhTRqiyyzbCbHC4+OfJdMVq9P77FdsHyNGXCG+MTzLZk04isiNCLPtBgoGbyI9
         7YCiofmaPVDImyxm0+ZeB8dDwOafRu6C5H4vrI95YKbndKZsn1iunI6rUGPw6gU21gRz
         bwMmR8UvyTjtPbMFQUZda5MPGisMWQa2Zwq4LBvkt3187xdRROZl+SIa0adxV2HpbrpW
         VO8yLb0pHnnp2s2l3uIpu6s5A+L2ZJ/vTWHqU668WIRL9X8sC7vPVmHTei3Z9Zop2AKf
         1ixA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032431; x=1771637231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LlribCFdngaQSRseMvArVzR7Ue2wpxs9f06/EhF3nRU=;
        b=BYThdESvT2vjUFUVy8S01QReltW30i3diCm9zDY5TtvVtpUvzuuma7I/kyOO7vDHIk
         mvXYCa4eJaaCvAgiQ7koX3XMeC4bGX2BLDnJpJXApqEZgykbyB3V999r9xwZnsu1zlIj
         dn2LTkKNSBJKrRjHTwtFr1YPZ4sDoTP4AIsCX8aNumhjmDataDBQYFTagCep8z2DKzy4
         AacLd8rHCp+SIJkCXT90/evmuBXc4NOLSzdAdUlLYQk16dFgC1aFxjcMjvC6QdCjyoFZ
         xfWM47e0Kc9VnDscxVGrfsvu9MntWOtBhxIuEACYMrxa5Yy/XVnwB07WVliMARbeY1Ir
         47Ag==
X-Forwarded-Encrypted: i=1; AJvYcCXof7g6MNnN2afUaAWw6S863gdGfN1QUOE91+kkXjIB1OjopA3TNNvN1cjbPNBvbPbp9t8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDFBf+5qjOmobJbaH9NgZXEGvAmjgK46viyxxHYz00eo+Pt2Ln
	MBAIlW7g2P/ZhnwYzyljNTnLMlmgB69BSdzI8VSQ4Sft5PwQOlk2naMquEiUyazZE9BlXCkXY0M
	JvCU4cg==
X-Received: from pfbem2.prod.google.com ([2002:a05:6a00:3742:b0:823:c4bd:60eb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4b10:b0:81c:785e:1216
 with SMTP id d2e1a72fcca58-824d932e621mr967760b3a.0.1771032431208; Fri, 13
 Feb 2026 17:27:11 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:26:49 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-4-seanjc@google.com>
Subject: [PATCH v3 03/16] KVM: x86: Move "kvm_rebooting" to kernel as "virt_rebooting"
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71083-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 1FCD913AAA1
X-Rspamd-Action: no action

Move "kvm_rebooting" to the kernel, exported for KVM, as one of many steps
towards extracting the innermost VMXON and EFER.SVME management logic out
of KVM and into to core x86.

For lack of a better name, call the new file "hw.c", to yield "virt
hardware" when combined with its parent directory.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/virt.h | 11 +++++++++++
 arch/x86/kvm/svm/svm.c      |  3 ++-
 arch/x86/kvm/svm/vmenter.S  | 10 +++++-----
 arch/x86/kvm/vmx/tdx.c      |  3 ++-
 arch/x86/kvm/vmx/vmenter.S  |  2 +-
 arch/x86/kvm/vmx/vmx.c      |  5 +++--
 arch/x86/kvm/x86.c          | 17 ++++++++---------
 arch/x86/kvm/x86.h          |  1 -
 arch/x86/virt/Makefile      |  2 ++
 arch/x86/virt/hw.c          |  7 +++++++
 10 files changed, 41 insertions(+), 20 deletions(-)
 create mode 100644 arch/x86/include/asm/virt.h
 create mode 100644 arch/x86/virt/hw.c

diff --git a/arch/x86/include/asm/virt.h b/arch/x86/include/asm/virt.h
new file mode 100644
index 000000000000..131b9bf9ef3c
--- /dev/null
+++ b/arch/x86/include/asm/virt.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _ASM_X86_VIRT_H
+#define _ASM_X86_VIRT_H
+
+#include <linux/types.h>
+
+#if IS_ENABLED(CONFIG_KVM_X86)
+extern bool virt_rebooting;
+#endif
+
+#endif /* _ASM_X86_VIRT_H */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 8f8bc863e214..0ae66c770ebc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -44,6 +44,7 @@
 #include <asm/traps.h>
 #include <asm/reboot.h>
 #include <asm/fpu/api.h>
+#include <asm/virt.h>
 
 #include <trace/events/ipi.h>
 
@@ -495,7 +496,7 @@ static inline void kvm_cpu_svm_disable(void)
 
 static void svm_emergency_disable_virtualization_cpu(void)
 {
-	kvm_rebooting = true;
+	virt_rebooting = true;
 
 	kvm_cpu_svm_disable();
 }
diff --git a/arch/x86/kvm/svm/vmenter.S b/arch/x86/kvm/svm/vmenter.S
index 3392bcadfb89..d47c5c93c991 100644
--- a/arch/x86/kvm/svm/vmenter.S
+++ b/arch/x86/kvm/svm/vmenter.S
@@ -298,16 +298,16 @@ SYM_FUNC_START(__svm_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY (%_ASM_SP)
 
-10:	cmpb $0, _ASM_RIP(kvm_rebooting)
+10:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 2b
 	ud2
-30:	cmpb $0, _ASM_RIP(kvm_rebooting)
+30:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 4b
 	ud2
-50:	cmpb $0, _ASM_RIP(kvm_rebooting)
+50:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 6b
 	ud2
-70:	cmpb $0, _ASM_RIP(kvm_rebooting)
+70:	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne 8b
 	ud2
 
@@ -394,7 +394,7 @@ SYM_FUNC_START(__svm_sev_es_vcpu_run)
 	RESTORE_GUEST_SPEC_CTRL_BODY
 	RESTORE_HOST_SPEC_CTRL_BODY %sil
 
-3:	cmpb $0, kvm_rebooting(%rip)
+3:	cmpb $0, virt_rebooting(%rip)
 	jne 2b
 	ud2
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5df9d32d2058..0c790eb0bfa6 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -6,6 +6,7 @@
 #include <linux/misc_cgroup.h>
 #include <linux/mmu_context.h>
 #include <asm/tdx.h>
+#include <asm/virt.h>
 #include "capabilities.h"
 #include "mmu.h"
 #include "x86_ops.h"
@@ -1994,7 +1995,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	 * TDX_SEAMCALL_VMFAILINVALID.
 	 */
 	if (unlikely((vp_enter_ret & TDX_SW_ERROR) == TDX_SW_ERROR)) {
-		KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
+		KVM_BUG_ON(!virt_rebooting, vcpu->kvm);
 		goto unhandled_exit;
 	}
 
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 4426d34811fc..8a481dae9cae 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -310,7 +310,7 @@ SYM_INNER_LABEL_ALIGN(vmx_vmexit, SYM_L_GLOBAL)
 	RET
 
 .Lfixup:
-	cmpb $0, _ASM_RIP(kvm_rebooting)
+	cmpb $0, _ASM_RIP(virt_rebooting)
 	jne .Lvmfail
 	ud2
 .Lvmfail:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 967b58a8ab9d..fc6e3b620866 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -48,6 +48,7 @@
 #include <asm/msr.h>
 #include <asm/mwait.h>
 #include <asm/spec-ctrl.h>
+#include <asm/virt.h>
 #include <asm/vmx.h>
 
 #include <trace/events/ipi.h>
@@ -814,13 +815,13 @@ void vmx_emergency_disable_virtualization_cpu(void)
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
 
-	kvm_rebooting = true;
+	virt_rebooting = true;
 
 	/*
 	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
 	 * set in task context.  If this races with VMX is disabled by an NMI,
 	 * VMCLEAR and VMXOFF may #UD, but KVM will eat those faults due to
-	 * kvm_rebooting set.
+	 * virt_rebooting set.
 	 */
 	if (!(__read_cr4() & X86_CR4_VMXE))
 		return;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 77edc24f8309..69937d14f5e1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -83,6 +83,8 @@
 #include <asm/intel_pt.h>
 #include <asm/emulate_prefix.h>
 #include <asm/sgx.h>
+#include <asm/virt.h>
+
 #include <clocksource/hyperv_timer.h>
 
 #define CREATE_TRACE_POINTS
@@ -700,9 +702,6 @@ static void drop_user_return_notifiers(void)
 		kvm_on_user_return(&msrs->urn);
 }
 
-__visible bool kvm_rebooting;
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
-
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
  *
@@ -713,7 +712,7 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_rebooting);
 noinstr void kvm_spurious_fault(void)
 {
 	/* Fault while not rebooting.  We want the trace. */
-	BUG_ON(!kvm_rebooting);
+	BUG_ON(!virt_rebooting);
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_spurious_fault);
 
@@ -13184,16 +13183,16 @@ int kvm_arch_enable_virtualization_cpu(void)
 void kvm_arch_shutdown(void)
 {
 	/*
-	 * Set kvm_rebooting to indicate that KVM has asynchronously disabled
+	 * Set virt_rebooting to indicate that KVM has asynchronously disabled
 	 * hardware virtualization, i.e. that errors and/or exceptions on SVM
 	 * and VMX instructions are expected and should be ignored.
 	 */
-	kvm_rebooting = true;
+	virt_rebooting = true;
 
 	/*
-	 * Ensure kvm_rebooting is visible before IPIs are sent to other CPUs
+	 * Ensure virt_rebooting is visible before IPIs are sent to other CPUs
 	 * to disable virtualization.  Effectively pairs with the reception of
-	 * the IPI (kvm_rebooting is read in task/exception context, but only
+	 * the IPI (virt_rebooting is read in task/exception context, but only
 	 * _needs_ to be read as %true after the IPI function callback disables
 	 * virtualization).
 	 */
@@ -13214,7 +13213,7 @@ void kvm_arch_disable_virtualization_cpu(void)
 	 * disable virtualization arrives.  Handle the extreme edge case here
 	 * instead of trying to account for it in the normal flows.
 	 */
-	if (in_task() || WARN_ON_ONCE(!kvm_rebooting))
+	if (in_task() || WARN_ON_ONCE(!virt_rebooting))
 		drop_user_return_notifiers();
 	else
 		__module_get(THIS_MODULE);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index b314649e5c02..94d4f07aaaa0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -54,7 +54,6 @@ struct kvm_host_values {
 	u64 arch_capabilities;
 };
 
-extern bool kvm_rebooting;
 void kvm_spurious_fault(void);
 
 #define SIZE_OF_MEMSLOTS_HASHTABLE \
diff --git a/arch/x86/virt/Makefile b/arch/x86/virt/Makefile
index ea343fc392dc..6e485751650c 100644
--- a/arch/x86/virt/Makefile
+++ b/arch/x86/virt/Makefile
@@ -1,2 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y	+= svm/ vmx/
+
+obj-$(subst m,y,$(CONFIG_KVM_X86)) += hw.o
\ No newline at end of file
diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
new file mode 100644
index 000000000000..df3dc18d19b4
--- /dev/null
+++ b/arch/x86/virt/hw.c
@@ -0,0 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <linux/kvm_types.h>
+
+#include <asm/virt.h>
+
+__visible bool virt_rebooting;
+EXPORT_SYMBOL_FOR_KVM(virt_rebooting);
-- 
2.53.0.310.g728cabbaf7-goog


