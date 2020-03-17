Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2043188CB8
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 19:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgCQSBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 14:01:08 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38269 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgCQSBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 14:01:08 -0400
Received: by mail-wm1-f68.google.com with SMTP id t13so278690wmi.3;
        Tue, 17 Mar 2020 11:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=T32itqq2iG4R5xS3SgZFa5iW2a5HV4efCuB1zt7pHvc=;
        b=lzLaNmkppxWDxmNZQ5aCmmzdE6ZG+qKLm+AhRSLlpp5qilmm1HBdRI8dHLwrCc2a7W
         dl8Af4rsjAmG4zMHhS1/8xMtyuOAYQOP6NmYRxsV16FV+tqgshQwUge9Xhw82Kym+deb
         uSq856n67xzcF1GRNnLoR6yHYqfSxaOUWbPnFaPCgcLuURldLm1TwChTH1dYRRjWRY11
         TjKkghMQ/3dS1qyHwCKjpy3V4kpgg5WOy3Ez7bqq8iKa5m1ipM2U2LtPGFgXOTk9dezm
         WovKDgMsAin2jESSMlq1FNryLUkl4FdAQlAzhQZ9V55pdHIyJVKOMW+VnAoLcNDPx0G7
         O5SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=T32itqq2iG4R5xS3SgZFa5iW2a5HV4efCuB1zt7pHvc=;
        b=tazGW23eQ7ldr4jhnPlH9k0yGmfd+8E9Xc/GUXYEu9HTJKXHuN7zR3q5hff7fKBv8B
         KLSFjD6apgs1PffiWIBeYwt6nOwVdY/D80BxLTp43RCVKfM/s0EXL7ooOoToUvMgjqP1
         zwUMnKT4RQjG4IxotMf6vL3Si8Add+iMwN0F7smoFB1NdjaebREnZZyl76Dtx7WiucMG
         ll99ByP+sYzZ/o15Wo8a/j3guhe8McdPIl9w8ghdeN5UKdoi5Vu5Hv6Ssfz3Lqoby4JP
         svWnEXAMSL2Mc8H1Ad0w30tYDO7p/dWrydJCS3W0wfRR4ZQWx5dnafRY1j5zm+EudNut
         chzg==
X-Gm-Message-State: ANhLgQ0uD4AYna2JTQF+Of5uUd86d+8ZMJdiNc5tfj4pI0n2GWvB5h7E
        6nm3Q19KMo32CXn3d/9upyDaxhLb
X-Google-Smtp-Source: ADFU+vt3RGoK8s2yNUjqUV+NqdyImargYWiitWSLtlUNk1uRN2/kGm+q/TY2uiVncgJvOTLctkSeTg==
X-Received: by 2002:a05:600c:2c06:: with SMTP id q6mr246073wmg.52.1584468065931;
        Tue, 17 Mar 2020 11:01:05 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.174.5])
        by smtp.gmail.com with ESMTPSA id j39sm5955220wre.11.2020.03.17.11.01.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Mar 2020 11:01:04 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, sean.j.christopherson@intel.com
Subject: [PATCH] KVM: nVMX: remove side effects from nested_vmx_exit_reflected
Date:   Tue, 17 Mar 2020 19:00:59 +0100
Message-Id: <1584468059-3585-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The name of nested_vmx_exit_reflected suggests that it's purely
a test, but it actually marks VMCS12 pages as dirty.  Move this to
vmx_handle_exit, observing that the initial nested_run_pending check in
nested_vmx_exit_reflected is pointless---nested_run_pending has just
been cleared in vmx_vcpu_run and won't be set until handle_vmlaunch
or handle_vmresume.

Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 18 ++----------------
 arch/x86/kvm/vmx/nested.h |  1 +
 arch/x86/kvm/vmx/vmx.c    | 19 +++++++++++++++++--
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8578513907d7..4ff859c99946 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3527,7 +3527,7 @@ static void vmcs12_save_pending_event(struct kvm_vcpu *vcpu,
 }
 
 
-static void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
+void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 	gfn_t gfn;
@@ -5543,8 +5543,7 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
 
-	if (vmx->nested.nested_run_pending)
-		return false;
+	WARN_ON_ONCE(vmx->nested.nested_run_pending);
 
 	if (unlikely(vmx->fail)) {
 		trace_kvm_nested_vmenter_failed(
@@ -5553,19 +5552,6 @@ bool nested_vmx_exit_reflected(struct kvm_vcpu *vcpu, u32 exit_reason)
 		return true;
 	}
 
-	/*
-	 * The host physical addresses of some pages of guest memory
-	 * are loaded into the vmcs02 (e.g. vmcs12's Virtual APIC
-	 * Page). The CPU may write to these pages via their host
-	 * physical address while L2 is running, bypassing any
-	 * address-translation-based dirty tracking (e.g. EPT write
-	 * protection).
-	 *
-	 * Mark them dirty on every exit from L2 to prevent them from
-	 * getting out of sync with dirty tracking.
-	 */
-	nested_mark_vmcs12_pages_dirty(vcpu);
-
 	trace_kvm_nested_vmexit(kvm_rip_read(vcpu), exit_reason,
 				vmcs_readl(EXIT_QUALIFICATION),
 				vmx->idt_vectoring_info,
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 21d36652f213..f70968b76d33 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -33,6 +33,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
 void nested_vmx_pmu_entry_exit_ctls_update(struct kvm_vcpu *vcpu);
+void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
 bool nested_vmx_check_io_bitmaps(struct kvm_vcpu *vcpu, unsigned int port,
 				 int size);
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b447d66f44e6..07299a957d4a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5851,8 +5851,23 @@ static int vmx_handle_exit(struct kvm_vcpu *vcpu,
 	if (vmx->emulation_required)
 		return handle_invalid_guest_state(vcpu);
 
-	if (is_guest_mode(vcpu) && nested_vmx_exit_reflected(vcpu, exit_reason))
-		return nested_vmx_reflect_vmexit(vcpu, exit_reason);
+	if (is_guest_mode(vcpu)) {
+		/*
+		 * The host physical addresses of some pages of guest memory
+		 * are loaded into the vmcs02 (e.g. vmcs12's Virtual APIC
+		 * Page). The CPU may write to these pages via their host
+		 * physical address while L2 is running, bypassing any
+		 * address-translation-based dirty tracking (e.g. EPT write
+		 * protection).
+		 *
+		 * Mark them dirty on every exit from L2 to prevent them from
+		 * getting out of sync with dirty tracking.
+		 */
+		nested_mark_vmcs12_pages_dirty(vcpu);
+
+		if (nested_vmx_exit_reflected(vcpu, exit_reason))
+			return nested_vmx_reflect_vmexit(vcpu, exit_reason);
+	}
 
 	if (exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY) {
 		dump_vmcs();
-- 
1.8.3.1

