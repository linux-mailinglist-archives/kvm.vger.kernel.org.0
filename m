Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0255023B3CA
	for <lists+kvm@lfdr.de>; Tue,  4 Aug 2020 06:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgHDEU7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Aug 2020 00:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgHDEU6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Aug 2020 00:20:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A4DC06174A
        for <kvm@vger.kernel.org>; Mon,  3 Aug 2020 21:20:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a127so51306602ybb.14
        for <kvm@vger.kernel.org>; Mon, 03 Aug 2020 21:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ekkRqwCzpqNMyGqJ+IRasMCYa9RWitCN8gbAOG6hXZk=;
        b=MzLRCwgmVe1d+5I0WOIS0U9CrCUYF4M3JbVIo6ANGyAhKNLKYsthIHEVFqISGtbDzw
         nQ36PyjlsnnXqKN3806i6lDPnCwTujCE5ioXaJtxgsXHWOmqlNLaQSxorvuxqktkbiW0
         QWqnNt44fXxFwRSi/LhOY2TIJnUadY0EpcrplOUSMwlcJoZQqvBODsH3C3jU+3SCfHpm
         s/Z4p2KoF3osYWnI3+6YEG+bwJrJtSCmDaFWn8ar6yluvhlyZ+xMgtjYw8UjHJImQwwP
         DZGCAfekS4mV7QctoarlI+Ater27beXNzjt0m0N8HCpqjnrn5/idQeb56EayFP5exxtM
         tRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ekkRqwCzpqNMyGqJ+IRasMCYa9RWitCN8gbAOG6hXZk=;
        b=kNwCj08aB9FWfuPBlCn2VvA3oDNZ2Zt3NkZd1fCv0U8w+q5tEN9CspjpHdlEY5it86
         BOT7u7+nHzfKYTYwgbL6CMCGicIULsriyMrcR9IUNspLsW+vhhrBGq4ZQXnD+Nf9NEVO
         R9pkJ6Q7PBZY7MF/HFSt1PfCwRsnaz5IxrlYbySa8rUKPEy/9xsJFZxH0TxJakbCWHj2
         pxkxgg3k6IBPMG8gJ9B4hrnro+DBRtfF/Xyjn6T6S9An/DQm1bzcX8jMT6NnXcHIgnAw
         eslmpCw+kMgT78ayROoQ32/UTI3U6qam2GarHYMWxtoKctVNQx4RTbNZMIAg7bOWkl/E
         fZ8g==
X-Gm-Message-State: AOAM533TCZftbbSv9sc5brUQnAIe9utg84jrdCA++z2fRimynSJJeOni
        RpHvR0MgX855JCEMLGgmxJbwvYvHR9Q+TU2x
X-Google-Smtp-Source: ABdhPJw64jiau5VUkGApgQyQWba/ROMFe5/War77J64dUHeJghJ8JHrJeU1tF3lYsbeEGDShEW0kfgBoZg/B7/gK
X-Received: by 2002:a25:ba42:: with SMTP id z2mr30928789ybj.336.1596514857952;
 Mon, 03 Aug 2020 21:20:57 -0700 (PDT)
Date:   Mon,  3 Aug 2020 21:20:39 -0700
In-Reply-To: <20200804042043.3592620-1-aaronlewis@google.com>
Message-Id: <20200804042043.3592620-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200804042043.3592620-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.163.g6104cc2f0b6-goog
Subject: [PATCH 2/6] KVM: x86: Add support for exiting to userspace on rdmsr
 or wrmsr
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support for exiting to userspace on a rdmsr or wrmsr instruction if
the MSR being read from or written to is in the user_exit_msrs list.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 Documentation/virt/kvm/api.rst | 29 +++++++++++-
 arch/x86/kvm/trace.h           | 24 ++++++++++
 arch/x86/kvm/x86.c             | 83 ++++++++++++++++++++++++++++++++++
 include/trace/events/kvm.h     |  2 +-
 include/uapi/linux/kvm.h       | 10 ++++
 5 files changed, 145 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 7d8167c165aa..8b7078707e0a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4885,8 +4885,9 @@ to the byte array.
 
 .. note::
 
-      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR and
-      KVM_EXIT_EPR the corresponding
+      For KVM_EXIT_IO, KVM_EXIT_MMIO, KVM_EXIT_OSI, KVM_EXIT_PAPR,
+      KVM_EXIT_EPR, KVM_EXIT_X86_RDMSR, and KVM_EXIT_X86_WRMSR the
+      corresponding
 
 operations are complete (and guest state is consistent) only after userspace
 has re-entered the kernel with KVM_RUN.  The kernel side will first finish
@@ -5179,6 +5180,30 @@ Note that KVM does not skip the faulting instruction as it does for
 KVM_EXIT_MMIO, but userspace has to emulate any change to the processing state
 if it decides to decode and emulate the instruction.
 
+::
+
+    /* KVM_EXIT_X86_RDMSR */
+    /* KVM_EXIT_X86_WRMSR */
+    struct {
+      __u8 inject_gp; /* out */
+      __u8 pad[3];
+      __u32 index;    /* i.e. ecx; out */
+      __u64 data;     /* in (wrmsr) / out (rdmsr) */
+    } msr;
+
+If the exit_reason is KVM_EXIT_X86_RDMSR then a rdmsr instruction in the guest
+needs to be processed by userspace.  If the exit_reason is KVM_EXIT_X86_WRMSR
+then a wrmsr instruction in the guest needs to be processed by userspace.
+
+Userspace can tell KVM to inject a #GP into the guest by setting the
+'inject_gp' flag.  Setting the flag to 1 tells KVM to inject a GP into the
+guest.  Setting the flag to 0 tells KVM to not inject a GP into the guest.
+
+The MSR being processed is indicated by 'index'.  If a read is being processed
+the 'data' field is expected to be filled out by userspace (as an out
+parameter). If a write is being processed the 'data' field will contain the
+updated value of the MSR (as an in parameter).
+
 ::
 
 		/* Fix the size of the union. */
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index b66432b015d2..d03143ebd6f0 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -367,6 +367,30 @@ TRACE_EVENT(kvm_msr,
 #define trace_kvm_msr_read_ex(ecx)         trace_kvm_msr(0, ecx, 0, true)
 #define trace_kvm_msr_write_ex(ecx, data)  trace_kvm_msr(1, ecx, data, true)
 
+TRACE_EVENT(kvm_userspace_msr,
+	TP_PROTO(bool is_write, u8 inject_gp, u32 index, u64 data),
+	TP_ARGS(is_write, inject_gp, index, data),
+
+	TP_STRUCT__entry(
+		__field(bool,	is_write)
+		__field(u8,	inject_gp)
+		__field(u32,	index)
+		__field(u64,	data)
+	),
+
+	TP_fast_assign(
+		__entry->is_write	= is_write;
+		__entry->inject_gp	= inject_gp;
+		__entry->index		= index;
+		__entry->data		= data;
+	),
+
+	TP_printk("userspace %s %x = 0x%llx, %s",
+		  __entry->is_write ? "wrmsr" : "rdmsr",
+		  __entry->index, __entry->data,
+		  __entry->inject_gp ? "inject_gp" : "no_gp")
+);
+
 /*
  * Tracepoint for guest CR access.
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 46a0fb9e0869..47619b49818a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -108,6 +108,8 @@ static void __kvm_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags);
 static void store_regs(struct kvm_vcpu *vcpu);
 static int sync_regs(struct kvm_vcpu *vcpu);
 
+bool kvm_msr_user_exit(struct kvm *kvm, u32 index);
+
 struct kvm_x86_ops kvm_x86_ops __read_mostly;
 EXPORT_SYMBOL_GPL(kvm_x86_ops);
 
@@ -1549,11 +1551,61 @@ int kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
 }
 EXPORT_SYMBOL_GPL(kvm_set_msr);
 
+/*
+ * On success, returns 1 so that __vcpu_run() will happen next. On
+ * error, returns 0.
+ */
+static int complete_userspace_msr(struct kvm_vcpu *vcpu, bool is_write)
+{
+	u32 ecx = vcpu->run->msr.index;
+	u64 data = vcpu->run->msr.data;
+
+	trace_kvm_userspace_msr(is_write,
+				vcpu->run->msr.inject_gp,
+				vcpu->run->msr.index,
+				vcpu->run->msr.data);
+
+	if (vcpu->run->msr.inject_gp) {
+		trace_kvm_msr(is_write, ecx, data, true);
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
+	trace_kvm_msr(is_write, ecx, data, false);
+	if (!is_write) {
+		kvm_rax_write(vcpu, data & -1u);
+		kvm_rdx_write(vcpu, (data >> 32) & -1u);
+	}
+
+	return kvm_skip_emulated_instruction(vcpu);
+}
+
+static int complete_userspace_rdmsr(struct kvm_vcpu *vcpu)
+{
+	return complete_userspace_msr(vcpu, false);
+}
+
+static int complete_userspace_wrmsr(struct kvm_vcpu *vcpu)
+{
+	return complete_userspace_msr(vcpu, true);
+}
+
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 {
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data;
 
+	if (kvm_msr_user_exit(vcpu->kvm, ecx)) {
+		vcpu->run->exit_reason = KVM_EXIT_X86_RDMSR;
+		vcpu->run->msr.index = ecx;
+		vcpu->run->msr.data = 0;
+		vcpu->run->msr.inject_gp = 0;
+		memset(vcpu->run->msr.pad, 0, sizeof(vcpu->run->msr.pad));
+		vcpu->arch.complete_userspace_io =
+			complete_userspace_rdmsr;
+		return 0;
+	}
+
 	if (kvm_get_msr(vcpu, ecx, &data)) {
 		trace_kvm_msr_read_ex(ecx);
 		kvm_inject_gp(vcpu, 0);
@@ -1573,6 +1625,17 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data = kvm_read_edx_eax(vcpu);
 
+	if (kvm_msr_user_exit(vcpu->kvm, ecx)) {
+		vcpu->run->exit_reason = KVM_EXIT_X86_WRMSR;
+		vcpu->run->msr.index = ecx;
+		vcpu->run->msr.data = data;
+		vcpu->run->msr.inject_gp = 0;
+		memset(vcpu->run->msr.pad, 0, sizeof(vcpu->run->msr.pad));
+		vcpu->arch.complete_userspace_io =
+			complete_userspace_wrmsr;
+		return 0;
+	}
+
 	if (kvm_set_msr(vcpu, ecx, data)) {
 		trace_kvm_msr_write_ex(ecx, data);
 		kvm_inject_gp(vcpu, 0);
@@ -3455,6 +3518,25 @@ static int kvm_vm_ioctl_set_exit_msrs(struct kvm *kvm,
 	return 0;
 }
 
+bool kvm_msr_user_exit(struct kvm *kvm, u32 index)
+{
+	struct kvm_msr_list *exit_msrs;
+	int i;
+
+	exit_msrs = kvm->arch.user_exit_msrs;
+
+	if (!exit_msrs)
+		return false;
+
+	for (i = 0; i < exit_msrs->nmsrs; ++i) {
+		if (exit_msrs->indices[i] == index)
+			return true;
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(kvm_msr_user_exit);
+
 int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 {
 	int r = 0;
@@ -10762,3 +10844,4 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_userspace_msr);
diff --git a/include/trace/events/kvm.h b/include/trace/events/kvm.h
index 2c735a3e6613..19f33a704174 100644
--- a/include/trace/events/kvm.h
+++ b/include/trace/events/kvm.h
@@ -17,7 +17,7 @@
 	ERSN(NMI), ERSN(INTERNAL_ERROR), ERSN(OSI), ERSN(PAPR_HCALL),	\
 	ERSN(S390_UCONTROL), ERSN(WATCHDOG), ERSN(S390_TSCH), ERSN(EPR),\
 	ERSN(SYSTEM_EVENT), ERSN(S390_STSI), ERSN(IOAPIC_EOI),          \
-	ERSN(HYPERV)
+	ERSN(HYPERV), ERSN(X86_RDMSR), ERSN(X86_WRMSR)
 
 TRACE_EVENT(kvm_userspace_exit,
 	    TP_PROTO(__u32 reason, int errno),
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index de4638c1bd15..2b7d21e6338c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -248,6 +248,8 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_X86_RDMSR        29
+#define KVM_EXIT_X86_WRMSR        30
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -412,6 +414,14 @@ struct kvm_run {
 			__u64 esr_iss;
 			__u64 fault_ipa;
 		} arm_nisv;
+		/* KVM_EXIT_X86_RDMSR */
+		/* KVM_EXIT_X86_RDMSR */
+		struct {
+			__u8 inject_gp;
+			__u8 pad[3];
+			__u32 index;
+			__u64 data;
+		} msr;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
-- 
2.28.0.163.g6104cc2f0b6-goog

