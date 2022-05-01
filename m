Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEFB516889
	for <lists+kvm@lfdr.de>; Mon,  2 May 2022 00:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377951AbiEAWMq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 1 May 2022 18:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377835AbiEAWMj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 1 May 2022 18:12:39 -0400
Received: from vps-vb.mhejs.net (vps-vb.mhejs.net [37.28.154.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD625EBED;
        Sun,  1 May 2022 15:08:53 -0700 (PDT)
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1nlHkE-0008Pw-09; Mon, 02 May 2022 00:08:46 +0200
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 12/12] KVM: nSVM: Drop support for CPUs without NRIPS (NextRIP Save) support
Date:   Mon,  2 May 2022 00:07:36 +0200
Message-Id: <f0302382cf45d7a9527b4aebbfe694bbcfa7aff5.1651440202.git.maciej.szmigiero@oracle.com>
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

From: Sean Christopherson <seanjc@google.com>

Drop nested support for CPUs without NRIPS, as requiring NRIPS
simplifies a handful of paths in KVM.

NRIPS was introduced in 2009, i.e. every AMD-based CPU released in the
last decade should support NRIPS.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Not-signed-off-by: Sean Christopherson <seanjc@google.com>
[MSS: Just drop nested support for these CPUs instead of SVM support in general]
Signed-off-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
---
 arch/x86/kvm/svm/nested.c | 14 +++++---------
 arch/x86/kvm/svm/svm.c    | 19 +++++++++++--------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2cf92c12706a..e5c05e3427ae 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -691,14 +691,13 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	/*
 	 * next_rip is consumed on VMRUN as the return address pushed on the
 	 * stack for injected soft exceptions/interrupts.  If nrips is exposed
-	 * to L1, take it verbatim from vmcb12.  If nrips is supported in
-	 * hardware but not exposed to L1, stuff the actual L2 RIP to emulate
-	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
-	 * prior to injecting the event).
+	 * to L1, take it verbatim from vmcb12.  If nrips is not exposed to L1,
+	 * stuff the actual L2 RIP to emulate what an nrips=0 CPU would do (L1
+	 * is responsible for advancing RIP prior to injecting the event).
 	 */
 	if (svm->nrips_enabled)
 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
-	else if (boot_cpu_has(X86_FEATURE_NRIPS))
+	else
 		vmcb02->control.next_rip    = vmcb12_rip;
 
 	svm->nmi_l1_to_l2 = is_evtinj_nmi(vmcb02->control.event_inj);
@@ -706,10 +705,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		svm->soft_int_injected = true;
 		svm->soft_int_csbase = svm->vmcb->save.cs.base;
 		svm->soft_int_old_rip = vmcb12_rip;
-		if (svm->nrips_enabled)
-			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
-		else
-			svm->soft_int_next_rip = vmcb12_rip;
+		svm->soft_int_next_rip = vmcb02->control.next_rip;
 	}
 
 	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 88eacbbe9348..dc980fa0daa8 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4330,9 +4330,7 @@ static int svm_check_intercept(struct kvm_vcpu *vcpu,
 		break;
 	}
 
-	/* TODO: Advertise NRIPS to guest hypervisor unconditionally */
-	if (static_cpu_has(X86_FEATURE_NRIPS))
-		vmcb->control.next_rip  = info->next_rip;
+	vmcb->control.next_rip  = info->next_rip;
 	vmcb->control.exit_code = icpt_info.exit_code;
 	vmexit = nested_svm_exit_handled(svm);
 
@@ -4961,6 +4959,16 @@ static __init int svm_hardware_setup(void)
 		pause_filter_thresh = 0;
 	}
 
+	if (nrips) {
+		if (!boot_cpu_has(X86_FEATURE_NRIPS))
+			nrips = false;
+	}
+
+	if (!nrips && nested) {
+		pr_notice("kvm: Nested Virtualization requires NRIPS (NextRIP Save)\n");
+		nested = false;
+	}
+
 	if (nested) {
 		printk(KERN_INFO "kvm: Nested Virtualization enabled\n");
 		kvm_enable_efer_bits(EFER_SVME | EFER_LMSLE);
@@ -4995,11 +5003,6 @@ static __init int svm_hardware_setup(void)
 			goto err;
 	}
 
-	if (nrips) {
-		if (!boot_cpu_has(X86_FEATURE_NRIPS))
-			nrips = false;
-	}
-
 	enable_apicv = avic = avic && npt_enabled && (boot_cpu_has(X86_FEATURE_AVIC) || force_avic);
 
 	if (enable_apicv) {
