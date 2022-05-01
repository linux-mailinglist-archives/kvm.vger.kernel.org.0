Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 892EB51687B
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 00:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355596AbiEAWL0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 18:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355565AbiEAWLY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 18:11:24 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6582A1CB37;
        Sun,  1 May 2022 15:07:57 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlHjH-0008MX-9t; Mon, 02 May 2022 00:07:47 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 01/12] KVM: nSVM: Sync next_rip field from vmcb12 to vmcb02
Date:   Mon,  2 May 2022 00:07:25 +0200
Message-Id: <c2e0a3d78db3ae30530f11d4e9254b452a89f42b.1651440202.git.maciej.szmigiero@oracle.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651440202.git.maciej.szmigiero@oracle.com>
References: <cover.1651440202.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>

The next_rip field of a VMCB is *not* an output-only field for a VMRUN.
This field value (instead of the saved guest RIP) in used by the CPU for
the return address pushed on stack when injecting a software interrupt or
INT3 or INTO exception.

Make sure this field gets synced from vmcb12 to vmcb02 when entering L2 or
loading a nested state and NRIPS is exposed to L1.  If NRIPS is supported
in hardware but not exposed to L1 (nrips=0 or hidden by userspace), stuff
vmcb02's next_rip from the new L2 RIP to emulate a !NRIPS CPU (which
saves RIP on the stack as-is).

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 22 +++++++++++++++++++---
 arch/x86/kvm/svm/svm.h    |  1 +
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index bed5e1692cef..91a1f9ff2b86 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -371,6 +371,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->nested_ctl          = from->nested_ctl;
 	to->event_inj           = from->event_inj;
 	to->event_inj_err       = from->event_inj_err;
+	to->next_rip            = from->next_rip;
 	to->nested_cr3          = from->nested_cr3;
 	to->virt_ext            = from->virt_ext;
 	to->pause_filter_count  = from->pause_filter_count;
@@ -608,7 +609,8 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	}
 }
 
-static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
+static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
+					  unsigned long vmcb12_rip)
 {
 	u32 int_ctl_vmcb01_bits = V_INTR_MASKING_MASK;
 	u32 int_ctl_vmcb12_bits = V_TPR_MASK | V_IRQ_INJECTION_BITS_MASK;
@@ -662,6 +664,19 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	vmcb02->control.event_inj           = svm->nested.ctl.event_inj;
 	vmcb02->control.event_inj_err       = svm->nested.ctl.event_inj_err;
 
+	/*
+	 * next_rip is consumed on VMRUN as the return address pushed on the
+	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
+	 * to L1, take it verbatim from vmcb12.  If nrips is supported in
+	 * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
+	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
+	 * prior to injecting the event).
+	 */
+	if (svm->nrips_enabled)
+		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
+	else if (boot_cpu_has(X86_FEATURE_NRIPS))
+		vmcb02->control.next_rip    = vmcb12_rip;
+
 	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
 					      LBR_CTL_ENABLE_MASK;
 	if (svm->lbrv_enabled)
@@ -745,7 +760,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm);
+	nested_vmcb02_prepare_control(svm, vmcb12->save.rip);
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, svm->nested.save.cr3,
@@ -1418,6 +1433,7 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->nested_ctl           = from->nested_ctl;
 	dst->event_inj            = from->event_inj;
 	dst->event_inj_err        = from->event_inj_err;
+	dst->next_rip             = from->next_rip;
 	dst->nested_cr3           = from->nested_cr3;
 	dst->virt_ext              = from->virt_ext;
 	dst->pause_filter_count   = from->pause_filter_count;
@@ -1602,7 +1618,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	nested_copy_vmcb_control_to_cache(svm, ctl);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
-	nested_vmcb02_prepare_control(svm);
+	nested_vmcb02_prepare_control(svm, svm->vmcb->save.rip);
 
 	/*
 	 * While the nested guest CR3 is already checked and set by
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 32220a1b0ea2..7d97e4d18c8b 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -139,6 +139,7 @@ struct vmcb_ctrl_area_cached {
 	u64 nested_ctl;
 	u32 event_inj;
 	u32 event_inj_err;
+	u64 next_rip;
 	u64 nested_cr3;
 	u64 virt_ext;
 	u32 clean;
