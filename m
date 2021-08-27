Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3858B3F9E24
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 19:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236929AbhH0RmL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 13:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhH0RmK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 13:42:10 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8585C061757
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 10:41:21 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id q26-20020aa7961a000000b003ef3d207770so1152075pfg.16
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 10:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=yA8GvsKQ2KeyW1CCPabYTh5PAhjqu8+nGZffh6KNxP4=;
        b=HTZ32sK9reTHnDyc2R55ncThdHKTRlXfD9mhuPdx8yRXYy1uKTbs236uIzcT6IaP95
         ubXU9RNfTOxSkJX7yaoTkrFNx4TByKhp0MFEunuTYZLT/D/5OKNdiDLnXOmPppCRyfyf
         WIoHIUzY8x6szKoXlAWCSCwgIINuV+JCIjtlxaXH6Yl8hx878QII9eJlZ28sRqR9XCyC
         M//jjJYeuJsqXOxjpHL4kjFt1I55y+KAlB7aZulRljlwGwp+t+89DoK48NU2BbnF0+PG
         ym2Lk6GEYZbGrDcii63BwF3A9Rrjira67lWjsM8MVzpzBma6CWO6apxRcqQ/sCzbpLyl
         eoOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=yA8GvsKQ2KeyW1CCPabYTh5PAhjqu8+nGZffh6KNxP4=;
        b=cfrNtUkrrKZWfu1s1f1zywreFTNVgo+t8oi5FAFvaNIo42ZossbLo2+I+trfNCPpeo
         39rirMgmj+awPt60UG1a3QUm43+MxG3TrS9j+W8aKZloQlmhL3q2R1dtUJa0uT0I6qET
         LwQ2ih0h0N5Y1bA5JK1IS2f9m1EDfojOXKeRUB7vp7+7jriAo8A+UCRvMjPqIXM/OlaG
         yGJoIRxg5EtRwf/WILEGr/Fm7Y6UqG+BBa6hmvgWf9Dv+aou5SZAS+uf/pixYKtanuzy
         jDQhCw3nLji/I/7PaTXNNElyw+6/f94yRHHj1l9J+jY9SNZ3tgKWGXJ1ANdoxKDm2S/q
         yAuQ==
X-Gm-Message-State: AOAM532VqzbAROfMCMc//DfAnpMM8hsjG8XFMme3PhovxY594HbHIn90
        gXB6/6Jn6FC4ZxYkNLh9MF60Lf8B9c7dT5JgdlDL3Ys9FkIB/yFcDitV1UeCvOTiocEMeEdz7Si
        30P85p9bTpbQnwYajwAl3PsMfj3K4u1/4wrhDch+6K8EbiZlQo9oHrMk8seTbaRw69prrsGc=
X-Google-Smtp-Source: ABdhPJzLBH4JcYAWzejXEbUs+yJnNNycOFVtZivK2+sTkBsEPxLfmfayQTnaZy9SrADo8k/IY06hVb1C0mPmNI6WxA==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:aa7:999c:0:b0:3f2:8100:79c2 with SMTP
 id k28-20020aa7999c000000b003f2810079c2mr5113621pfh.80.1630086081106; Fri, 27
 Aug 2021 10:41:21 -0700 (PDT)
Date:   Fri, 27 Aug 2021 17:41:09 +0000
Message-Id: <20210827174110.3723076-1-jingzhangos@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH 1/2] KVM: stats: Add counters for VMX all/L2/nested exit reasons
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These stats will be used to monitor the nested virtualization use in
VMs. Most importantly: VMXON exits are evidence that the guest has
enabled VMX, VMLAUNCH/VMRESUME exits are evidence that the guest has run
an L2.

Original-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/x86/include/asm/kvm_host.h | 4 ++++
 arch/x86/include/uapi/asm/vmx.h | 1 +
 arch/x86/kvm/vmx/vmx.c          | 7 ++++++-
 arch/x86/kvm/x86.c              | 5 ++++-
 include/linux/kvm_host.h        | 4 ++++
 5 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 09b256db394a..dd2380c9ea96 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -34,6 +34,7 @@
 #include <asm/kvm_page_track.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/hyperv-tlfs.h>
+#include <asm/vmx.h>
 
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
 
@@ -1257,6 +1258,9 @@ struct kvm_vcpu_stat {
 	u64 directed_yield_attempted;
 	u64 directed_yield_successful;
 	u64 guest_mode;
+	u64 vmx_all_exits[EXIT_REASON_NUM];
+	u64 vmx_l2_exits[EXIT_REASON_NUM];
+	u64 vmx_nested_exits[EXIT_REASON_NUM];
 };
 
 struct x86_instruction_info;
diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 946d761adbd3..563b3901ef7a 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -91,6 +91,7 @@
 #define EXIT_REASON_UMWAIT              67
 #define EXIT_REASON_TPAUSE              68
 #define EXIT_REASON_BUS_LOCK            74
+#define EXIT_REASON_NUM                 (EXIT_REASON_BUS_LOCK + 1)
 
 #define VMX_EXIT_REASONS \
 	{ EXIT_REASON_EXCEPTION_NMI,         "EXCEPTION_NMI" }, \
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fada1055f325..5cd9f02a458a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5890,6 +5890,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	u32 vectoring_info = vmx->idt_vectoring_info;
 	u16 exit_handler_index;
 
+	++vcpu->stat.vmx_all_exits[exit_reason.basic];
+
 	/*
 	 * Flush logged GPAs PML buffer, this will make dirty_bitmap more
 	 * updated. Another good is, in kvm_vm_ioctl_get_dirty_log, before
@@ -5915,6 +5917,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		return handle_invalid_guest_state(vcpu);
 
 	if (is_guest_mode(vcpu)) {
+		++vcpu->stat.vmx_l2_exits[exit_reason.basic];
 		/*
 		 * PML is never enabled when running L2, bail immediately if a
 		 * PML full exit occurs as something is horribly wrong.
@@ -5935,8 +5938,10 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		 */
 		nested_mark_vmcs12_pages_dirty(vcpu);
 
-		if (nested_vmx_reflect_vmexit(vcpu))
+		if (nested_vmx_reflect_vmexit(vcpu)) {
+			++vcpu->stat.vmx_nested_exits[exit_reason.basic];
 			return 1;
+		}
 	}
 
 	if (exit_reason.failed_vmentry) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 86539c1686fa..245ad1d147dd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -277,7 +277,10 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
 	STATS_DESC_COUNTER(VCPU, nested_run),
 	STATS_DESC_COUNTER(VCPU, directed_yield_attempted),
 	STATS_DESC_COUNTER(VCPU, directed_yield_successful),
-	STATS_DESC_ICOUNTER(VCPU, guest_mode)
+	STATS_DESC_ICOUNTER(VCPU, guest_mode),
+	STATS_DESC_LINHIST_COUNTER(VCPU, vmx_all_exits, EXIT_REASON_NUM, 1),
+	STATS_DESC_LINHIST_COUNTER(VCPU, vmx_l2_exits, EXIT_REASON_NUM, 1),
+	STATS_DESC_LINHIST_COUNTER(VCPU, vmx_nested_exits, EXIT_REASON_NUM, 1),
 };
 
 const struct kvm_stats_header kvm_vcpu_stats_header = {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e4d712e9f760..47e986450b06 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1429,6 +1429,10 @@ struct _kvm_stats_desc {
 #define STATS_DESC_PCOUNTER(SCOPE, name)				       \
 	STATS_DESC_PEAK(SCOPE, name, KVM_STATS_UNIT_NONE,		       \
 		KVM_STATS_BASE_POW10, 0)
+/* Linear histogram for counter */
+#define STATS_DESC_LINHIST_COUNTER(SCOPE, name, sz, bsz)		       \
+	STATS_DESC_LINEAR_HIST(SCOPE, name, KVM_STATS_UNIT_NONE,	       \
+		KVM_STATS_BASE_POW10, 0, sz, bsz)
 
 /* Cumulative time in nanosecond */
 #define STATS_DESC_TIME_NSEC(SCOPE, name)				       \

base-commit: 680c7e3be6a3d502248771fe42c911f99d7e006c
-- 
2.33.0.259.gc128427fd7-goog

