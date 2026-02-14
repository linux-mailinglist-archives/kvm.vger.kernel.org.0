Return-Path: <kvm+bounces-71088-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eI0WJXrQj2l7TwEAu9opvQ
	(envelope-from <kvm+bounces-71088-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:31:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 379B613AB17
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 02:31:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6BFB73104886
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 01:27:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC6929D28F;
	Sat, 14 Feb 2026 01:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CCQoMUPR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57273284881
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 01:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771032445; cv=none; b=oEsT2DZfXm9FGeFEFZ7wjZnuAMwt+mB1yyvouFLp+AcGAnvodB0hNnGUiobCe7n1ojGD3x+cfadDRIQ0BKqYzcmvFJp6hYkvdE3XRJCpZPqt5qr0JzqUNrsb6dfrEJ3jC99+B8ahfzNEmfrjXG30ShLwTr13llOgpei1NgKtUDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771032445; c=relaxed/simple;
	bh=/EVryE9KEraeRZcfAjdAXyVVep9IRYm2MBvmK48Hx8s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ur9W+B+gy8oLCaUBs7dvZuKT79UpQExGrbCvtm2qUcPMZ3SIO0Es6L629kK9DX1O5CIQxTGyPrpM2kJ/nB4zbxSd89iL/UueAlzVUYFeTODsyGFuCb4rf800pIrW6oN/0x+N7qTdSQAMkqGm8muw72VNmsuu/e9JVr0WgAXm65U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CCQoMUPR; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aaf2f3bef6so18029815ad.0
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 17:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771032437; x=1771637237; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=+DBpVUd3qPIKBqituI0MpYpKiFQclysQZsAv6lUaJSc=;
        b=CCQoMUPRXVQojyWut7IIWgXv7JuaFRLLOEwK8U7SKmhwW+lcXolwahsmferyelNTXm
         XkR5H63TxdsCMqQcCrpEwRz/mvfkNoc8dcImt0yYvRtktbIS6UBnS4+c1roobKgp4an0
         hZxDmAeJKPqCdVACLaEBSKUsbV4e6eurISaYxsb/27FszTQvwmo2uCOo/RVfaccjDFfd
         loEKCqaoxvGROHUscMza21W/xmWU/gPsSAt5Scq6cWkPog6nfLFeV3kSn7IMLM6cIKc4
         OfzYcTAToq4cjAjY7LGtDnYKP/3/KrrEdJp9Y8DdYytvlO80Ty05lsJhqMGd+XPAF8qI
         xXTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771032437; x=1771637237;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+DBpVUd3qPIKBqituI0MpYpKiFQclysQZsAv6lUaJSc=;
        b=Nm41riaicJCdPMa0oWIfRYTXz7WH2lzXq6w1TMmEdv8QD5lyfuP+iFr7fsFQk2Yn9R
         PQIQiJK0hNVuoSrUux/NVpbJbV8kKYDd4jraKsDPa3o8U4sSN07hUWhBMF0Aa7SJZNJU
         dPnFD2D+j/VArVidSIk3F9P6FcBHJBsoVvAtCvrBMlwSi1g0BsJPNvGVZ/TAmRQD0sYl
         XFkYWecApyjw7iUxzKnXiQCdQ0bhfKpEKkp/0+wxvz5MBZw17c8f8PIP653UVorEW/fK
         dtGboi9MxWb+dQL32WxH+tXk60gU3Yce23qVauplUAQR+W3MWM8ZhGbuMOXEJyG/4wac
         eLWg==
X-Forwarded-Encrypted: i=1; AJvYcCXp6L8IkCtTPQX6COtqTIPq1C4HAs8+p+Hk7rEyhloRsaAtkpsVjyB0o85hxLY9QaF1VvU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzNHV1xCqsLhgLIF62lBzfHHrOI9wS/yl5HjgOaeBR34vCGgM8X
	aQs7EFMPHioMElimw/WWR6TiMAz6bw/yVtRIV4VAKqwzxmmmBgJVvZCUAEmx5tgUrGxxQUYab3Q
	g9EAGPg==
X-Received: from pjbnd8.prod.google.com ([2002:a17:90b:4cc8:b0:356:2c99:c20a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db0f:b0:2aa:de68:98c8
 with SMTP id d9443c01a7336-2ad1740c141mr11643275ad.4.1771032436499; Fri, 13
 Feb 2026 17:27:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 13 Feb 2026 17:26:52 -0800
In-Reply-To: <20260214012702.2368778-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <20260214012702.2368778-7-seanjc@google.com>
Subject: [PATCH v3 06/16] KVM: VMX: Move core VMXON enablement to kernel
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
	TAGGED_FROM(0.00)[bounces-71088-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 379B613AB17
X-Rspamd-Action: no action

Move the innermost VMXON+VMXOFF logic out of KVM and into to core x86 so
that TDX can (eventually) force VMXON without having to rely on KVM being
loaded, e.g. to do SEAMCALLs during initialization.

Opportunistically update the comment regarding emergency disabling via NMI
to clarify that virt_rebooting will be set by _another_ emergency callback,
i.e. that virt_rebooting doesn't need to be set before VMCLEAR, only
before _this_ invocation does VMXOFF.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/events/intel/pt.c  |  1 -
 arch/x86/include/asm/virt.h |  6 +--
 arch/x86/kvm/vmx/vmx.c      | 73 +++----------------------------
 arch/x86/virt/hw.c          | 85 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 92 insertions(+), 73 deletions(-)

diff --git a/arch/x86/events/intel/pt.c b/arch/x86/events/intel/pt.c
index 44524a387c58..b5726b50e77d 100644
--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1591,7 +1591,6 @@ void intel_pt_handle_vmx(int on)
 
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL_FOR_KVM(intel_pt_handle_vmx);
 
 /*
  * PMU callbacks
diff --git a/arch/x86/include/asm/virt.h b/arch/x86/include/asm/virt.h
index 0da6db4f5b0c..cca0210a5c16 100644
--- a/arch/x86/include/asm/virt.h
+++ b/arch/x86/include/asm/virt.h
@@ -2,8 +2,6 @@
 #ifndef _ASM_X86_VIRT_H
 #define _ASM_X86_VIRT_H
 
-#include <linux/percpu-defs.h>
-
 #include <asm/reboot.h>
 
 #if IS_ENABLED(CONFIG_KVM_X86)
@@ -12,7 +10,9 @@ extern bool virt_rebooting;
 void __init x86_virt_init(void);
 
 #if IS_ENABLED(CONFIG_KVM_INTEL)
-DECLARE_PER_CPU(struct vmcs *, root_vmcs);
+int x86_vmx_enable_virtualization_cpu(void);
+int x86_vmx_disable_virtualization_cpu(void);
+void x86_vmx_emergency_disable_virtualization_cpu(void);
 #endif
 
 #else
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e767835a4f3a..36238cc694fd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -786,41 +786,16 @@ static int vmx_set_guest_uret_msr(struct vcpu_vmx *vmx,
 	return ret;
 }
 
-/*
- * Disable VMX and clear CR4.VMXE (even if VMXOFF faults)
- *
- * Note, VMXOFF causes a #UD if the CPU is !post-VMXON, but it's impossible to
- * atomically track post-VMXON state, e.g. this may be called in NMI context.
- * Eat all faults as all other faults on VMXOFF faults are mode related, i.e.
- * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
- * magically in RM, VM86, compat mode, or at CPL>0.
- */
-static int kvm_cpu_vmxoff(void)
-{
-	asm goto("1: vmxoff\n\t"
-			  _ASM_EXTABLE(1b, %l[fault])
-			  ::: "cc", "memory" : fault);
-
-	cr4_clear_bits(X86_CR4_VMXE);
-	return 0;
-
-fault:
-	cr4_clear_bits(X86_CR4_VMXE);
-	return -EIO;
-}
-
 void vmx_emergency_disable_virtualization_cpu(void)
 {
 	int cpu = raw_smp_processor_id();
 	struct loaded_vmcs *v;
 
-	virt_rebooting = true;
-
 	/*
 	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
-	 * set in task context.  If this races with VMX is disabled by an NMI,
-	 * VMCLEAR and VMXOFF may #UD, but KVM will eat those faults due to
-	 * virt_rebooting set.
+	 * set in task context.  If this races with _another_ emergency call
+	 * from NMI context, VMCLEAR may #UD, but KVM will eat those faults due
+	 * to virt_rebooting being set by the interrupting NMI callback.
 	 */
 	if (!(__read_cr4() & X86_CR4_VMXE))
 		return;
@@ -832,7 +807,7 @@ void vmx_emergency_disable_virtualization_cpu(void)
 			vmcs_clear(v->shadow_vmcs);
 	}
 
-	kvm_cpu_vmxoff();
+	x86_vmx_emergency_disable_virtualization_cpu();
 }
 
 static void __loaded_vmcs_clear(void *arg)
@@ -2988,34 +2963,9 @@ int vmx_check_processor_compat(void)
 	return 0;
 }
 
-static int kvm_cpu_vmxon(u64 vmxon_pointer)
-{
-	u64 msr;
-
-	cr4_set_bits(X86_CR4_VMXE);
-
-	asm goto("1: vmxon %[vmxon_pointer]\n\t"
-			  _ASM_EXTABLE(1b, %l[fault])
-			  : : [vmxon_pointer] "m"(vmxon_pointer)
-			  : : fault);
-	return 0;
-
-fault:
-	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
-		  rdmsrq_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
-	cr4_clear_bits(X86_CR4_VMXE);
-
-	return -EFAULT;
-}
-
 int vmx_enable_virtualization_cpu(void)
 {
 	int cpu = raw_smp_processor_id();
-	u64 phys_addr = __pa(per_cpu(root_vmcs, cpu));
-	int r;
-
-	if (cr4_read_shadow() & X86_CR4_VMXE)
-		return -EBUSY;
 
 	/*
 	 * This can happen if we hot-added a CPU but failed to allocate
@@ -3024,15 +2974,7 @@ int vmx_enable_virtualization_cpu(void)
 	if (kvm_is_using_evmcs() && !hv_get_vp_assist_page(cpu))
 		return -EFAULT;
 
-	intel_pt_handle_vmx(1);
-
-	r = kvm_cpu_vmxon(phys_addr);
-	if (r) {
-		intel_pt_handle_vmx(0);
-		return r;
-	}
-
-	return 0;
+	return x86_vmx_enable_virtualization_cpu();
 }
 
 static void vmclear_local_loaded_vmcss(void)
@@ -3049,12 +2991,9 @@ void vmx_disable_virtualization_cpu(void)
 {
 	vmclear_local_loaded_vmcss();
 
-	if (kvm_cpu_vmxoff())
-		kvm_spurious_fault();
+	x86_vmx_disable_virtualization_cpu();
 
 	hv_reset_evmcs();
-
-	intel_pt_handle_vmx(0);
 }
 
 struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags)
diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
index 40495872fdfb..dc426c2bc24a 100644
--- a/arch/x86/virt/hw.c
+++ b/arch/x86/virt/hw.c
@@ -15,8 +15,89 @@ __visible bool virt_rebooting;
 EXPORT_SYMBOL_FOR_KVM(virt_rebooting);
 
 #if IS_ENABLED(CONFIG_KVM_INTEL)
-DEFINE_PER_CPU(struct vmcs *, root_vmcs);
-EXPORT_PER_CPU_SYMBOL(root_vmcs);
+static DEFINE_PER_CPU(struct vmcs *, root_vmcs);
+
+static int x86_virt_cpu_vmxon(void)
+{
+	u64 vmxon_pointer = __pa(per_cpu(root_vmcs, raw_smp_processor_id()));
+	u64 msr;
+
+	cr4_set_bits(X86_CR4_VMXE);
+
+	asm goto("1: vmxon %[vmxon_pointer]\n\t"
+			  _ASM_EXTABLE(1b, %l[fault])
+			  : : [vmxon_pointer] "m"(vmxon_pointer)
+			  : : fault);
+	return 0;
+
+fault:
+	WARN_ONCE(1, "VMXON faulted, MSR_IA32_FEAT_CTL (0x3a) = 0x%llx\n",
+		  rdmsrq_safe(MSR_IA32_FEAT_CTL, &msr) ? 0xdeadbeef : msr);
+	cr4_clear_bits(X86_CR4_VMXE);
+
+	return -EFAULT;
+}
+
+int x86_vmx_enable_virtualization_cpu(void)
+{
+	int r;
+
+	if (cr4_read_shadow() & X86_CR4_VMXE)
+		return -EBUSY;
+
+	intel_pt_handle_vmx(1);
+
+	r = x86_virt_cpu_vmxon();
+	if (r) {
+		intel_pt_handle_vmx(0);
+		return r;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_FOR_KVM(x86_vmx_enable_virtualization_cpu);
+
+/*
+ * Disable VMX and clear CR4.VMXE (even if VMXOFF faults)
+ *
+ * Note, VMXOFF causes a #UD if the CPU is !post-VMXON, but it's impossible to
+ * atomically track post-VMXON state, e.g. this may be called in NMI context.
+ * Eat all faults as all other faults on VMXOFF faults are mode related, i.e.
+ * faults are guaranteed to be due to the !post-VMXON check unless the CPU is
+ * magically in RM, VM86, compat mode, or at CPL>0.
+ */
+int x86_vmx_disable_virtualization_cpu(void)
+{
+	int r = -EIO;
+
+	asm goto("1: vmxoff\n\t"
+		 _ASM_EXTABLE(1b, %l[fault])
+		 ::: "cc", "memory" : fault);
+	r = 0;
+
+fault:
+	cr4_clear_bits(X86_CR4_VMXE);
+	intel_pt_handle_vmx(0);
+	return r;
+}
+EXPORT_SYMBOL_FOR_KVM(x86_vmx_disable_virtualization_cpu);
+
+void x86_vmx_emergency_disable_virtualization_cpu(void)
+{
+	virt_rebooting = true;
+
+	/*
+	 * Note, CR4.VMXE can be _cleared_ in NMI context, but it can only be
+	 * set in task context.  If this races with _another_ emergency call
+	 * from NMI context, VMXOFF may #UD, but kernel will eat those faults
+	 * due to virt_rebooting being set by the interrupting NMI callback.
+	 */
+	if (!(__read_cr4() & X86_CR4_VMXE))
+		return;
+
+	x86_vmx_disable_virtualization_cpu();
+}
+EXPORT_SYMBOL_FOR_KVM(x86_vmx_emergency_disable_virtualization_cpu);
 
 static __init void x86_vmx_exit(void)
 {
-- 
2.53.0.310.g728cabbaf7-goog


