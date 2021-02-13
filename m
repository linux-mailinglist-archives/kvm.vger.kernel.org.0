Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D25A31A905
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhBMAwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232287AbhBMAwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:52:00 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157A2C0617AA
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:36 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id f3so1519870ybg.15
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4/zuTH5SAwBEhAeoyaVLOks5C/8P9wHBnzUFavIOLk8=;
        b=s+oXipZ6yecLqPMU3rX0QhB2XzhuAwb9QNI+3AJlokHkJ2/o5GxKndtdVsWBmxzpcU
         DdCQBi7Mc3hoo6OMLBtG2maAgaqMd45ko82uPhyFuCYTuoyMp7Zj4Mm2LvnmNVeecGBU
         yVUmijWN3hCJrxoeehLsVyD70jJvbkti4Os2glK28almIjplJB3l/ejBPn4/7GCBtjd8
         0pFxzgkBv54a0kH/1Zc27OY16fuJFIRqWutualLHtnTCkbunJ6HqmaiZC0JtqZC8UIeg
         gYcZtdlCXu2KZqdJw7jxIPkd1FDjfGKYUJPIq49iHRUU+t8QABroZ6vcVSwQWDucGAsK
         4RMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4/zuTH5SAwBEhAeoyaVLOks5C/8P9wHBnzUFavIOLk8=;
        b=QT54LnxbBRLu54/JmfQpYqqTnvjqb7pfWRdcuF9HPPxfftXoZOCawREBwF0M3D0nF4
         o28GIdiAo4PWx4reO8GFEV6+JSg2/T8k/NESE6obtmkso0HHhdpzSQAJG3Oj3/o8/fO/
         mY/h3FRQ007lFofftYOwEt49en6MKwLMvNv/dIup8lcM1gyY4za7XjyyFXhoWb3ca9Kg
         VUcEvBQrhbHSga0n8TYF9c3bNEOvpAYWA3He34TgPOyyggGMpqwbyYpFkc/5Mf2xqBPa
         uTlyV5NiuSKmNH5ALLBm/syr79c0j8CFJ0gVH3ylhNS/LO0k/AMM86yD1dWglVOyjCpR
         ITIA==
X-Gm-Message-State: AOAM532mETo2+vkA6NBWW7LzA8RD6dk6NBux72Djvpig9XSo4SMEfc+Z
        1oiIhp7iAzgBxq0Ncwichy8wFMX4U1E=
X-Google-Smtp-Source: ABdhPJwRpIOAwKGTBkrSNtQ2peg5RJBH7kNNlsuhvGsFoqI0qZsXjtEjWgj3M8V9YbgMlEom8Vs70Zqe06s=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a25:d94b:: with SMTP id q72mr7215415ybg.135.1613177435305;
 Fri, 12 Feb 2021 16:50:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:07 -0800
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Message-Id: <20210213005015.1651772-7-seanjc@google.com>
Mime-Version: 1.0
References: <20210213005015.1651772-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 06/14] KVM: nVMX: Disable PML in hardware when running L2
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unconditionally disable PML in vmcs02, KVM emulates PML purely in the
MMU, e.g. vmx_flush_pml_buffer() doesn't even try to copy the L2 GPAs
from vmcs02's buffer to vmcs12.  At best, enabling PML is a nop.  At
worst, it will cause vmx_flush_pml_buffer() to record bogus GFNs in the
dirty logs.

Initialize vmcs02.GUEST_PML_INDEX such that PML writes would trigger
VM-Exit if PML was somehow enabled, skip flushing the buffer for guest
mode since the index is bogus, and freak out if a PML full exit occurs
when L2 is active.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 29 +++++++++++++++--------------
 arch/x86/kvm/vmx/vmx.c    | 12 ++++++++++--
 2 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b2f0b5e9cd63..0c6dda9980a6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2167,15 +2167,13 @@ static void prepare_vmcs02_constant_state(struct vcpu_vmx *vmx)
 		vmcs_write64(MSR_BITMAP, __pa(vmx->nested.vmcs02.msr_bitmap));
 
 	/*
-	 * The PML address never changes, so it is constant in vmcs02.
-	 * Conceptually we want to copy the PML index from vmcs01 here,
-	 * and then back to vmcs01 on nested vmexit.  But since we flush
-	 * the log and reset GUEST_PML_INDEX on each vmexit, the PML
-	 * index is also effectively constant in vmcs02.
+	 * PML is emulated for L2, but never enabled in hardware as the MMU
+	 * handles A/D emulation.  Disabling PML for L2 also avoids having to
+	 * deal with filtering out L2 GPAs from the buffer.
 	 */
 	if (enable_pml) {
-		vmcs_write64(PML_ADDRESS, page_to_phys(vmx->pml_pg));
-		vmcs_write16(GUEST_PML_INDEX, PML_ENTITY_NUM - 1);
+		vmcs_write64(PML_ADDRESS, 0);
+		vmcs_write16(GUEST_PML_INDEX, -1);
 	}
 
 	if (cpu_has_vmx_encls_vmexit())
@@ -2210,7 +2208,7 @@ static void prepare_vmcs02_early_rare(struct vcpu_vmx *vmx,
 
 static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
-	u32 exec_control, vmcs12_exec_ctrl;
+	u32 exec_control;
 	u64 guest_efer = nested_vmx_calc_efer(vmx, vmcs12);
 
 	if (vmx->nested.dirty_vmcs12 || vmx->nested.hv_evmcs)
@@ -2284,11 +2282,11 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
 				  SECONDARY_EXEC_ENABLE_VMFUNC);
 		if (nested_cpu_has(vmcs12,
-				   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS)) {
-			vmcs12_exec_ctrl = vmcs12->secondary_vm_exec_control &
-				~SECONDARY_EXEC_ENABLE_PML;
-			exec_control |= vmcs12_exec_ctrl;
-		}
+				   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
+			exec_control |= vmcs12->secondary_vm_exec_control;
+
+		/* PML is emulated and never enabled in hardware for L2. */
+		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
 
 		/* VMCS shadowing for L2 is emulated for now */
 		exec_control &= ~SECONDARY_EXEC_SHADOW_VMCS;
@@ -5793,7 +5791,10 @@ static bool nested_vmx_l0_wants_exit(struct kvm_vcpu *vcpu,
 	case EXIT_REASON_PREEMPTION_TIMER:
 		return true;
 	case EXIT_REASON_PML_FULL:
-		/* We emulate PML support to L1. */
+		/*
+		 * PML is emulated for an L1 VMM and should never be enabled in
+		 * vmcs02, always "handle" PML_FULL by exiting to userspace.
+		 */
 		return true;
 	case EXIT_REASON_VMFUNC:
 		/* VM functions are emulated through L2->L0 vmexits. */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e0a3a9be654b..b47ed3f412ef 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5976,9 +5976,10 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * updated. Another good is, in kvm_vm_ioctl_get_dirty_log, before
 	 * querying dirty_bitmap, we only need to kick all vcpus out of guest
 	 * mode as if vcpus is in root mode, the PML buffer must has been
-	 * flushed already.
+	 * flushed already.  Note, PML is never enabled in hardware while
+	 * running L2.
 	 */
-	if (enable_pml)
+	if (enable_pml && !is_guest_mode(vcpu))
 		vmx_flush_pml_buffer(vcpu);
 
 	/*
@@ -5994,6 +5995,13 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		return handle_invalid_guest_state(vcpu);
 
 	if (is_guest_mode(vcpu)) {
+		/*
+		 * PML is never enabled when running L2, bail immediately if a
+		 * PML full exit occurs as something is horribly wrong.
+		 */
+		if (exit_reason.basic == EXIT_REASON_PML_FULL)
+			goto unexpected_vmexit;
+
 		/*
 		 * The host physical addresses of some pages of guest memory
 		 * are loaded into the vmcs02 (e.g. vmcs12's Virtual APIC
-- 
2.30.0.478.g8a0d178c01-goog

