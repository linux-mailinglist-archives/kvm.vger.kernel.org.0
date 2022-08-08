Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB6358BE80
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 02:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233233AbiHHAgO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 20:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbiHHAgM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 20:36:12 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C0C263EA
        for <kvm@vger.kernel.org>; Sun,  7 Aug 2022 17:36:11 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id r6-20020a17090a2e8600b001f0768a1af1so7697990pjd.8
        for <kvm@vger.kernel.org>; Sun, 07 Aug 2022 17:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=asDbFP4JFb0e7xA7oblyxbYFEsRwuDE3XnS3dP45ers=;
        b=LPofzHp+QejVs7YORkGjTw0QzbKv6neHoKdc1Kn+bCR9ask7qi7J6yXD4Ru3ua4A8x
         LH5FpGl3wy8hfJZlzucaU+VpuxwY+1EbOFPV33yOWEHlEejKqPyb1d2csrHvfFoRXKiL
         mVJbBno//jGY6tUY7SqBSMGAlrFfzF4Ls/ra5q7zb7gZsn9+IGcuRQd4eVbASi5gK6Zw
         4/GND6X2SMSiyIOKes/BrDeUtjgfZU9Oh9+s+UMXR9C4237pBJDkSKVsM+dVPE1y/BqW
         OVeeh/FGpz/0yXL84AG4I2E1G4Wb9j/1JavzYSZLI6n9bfmvyBU9Z90WK2dEs6elR7K+
         tGNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=asDbFP4JFb0e7xA7oblyxbYFEsRwuDE3XnS3dP45ers=;
        b=uv+k1MMrHj59qB/qe9tmM4yxkZ2o4TFuNzAubtjbnuDBxmmyQeedSeFk5arMQ13nC3
         1J66KESYVQ3Qfly1BuYY6QgAXRc3CpXSylb5mmWyfKqPeWnzrKC9eer67+mfytXiV9C0
         o8ZPGzYd0oqftl0cGWg2kdbQkhYroXYjCuUHPOMxzNxl0PoaQ2vl5cA3XwvQYQDBLTkB
         XotxjNwm+7L8y4jLg/GHhq4NRebhu6/ctCMEJhIKVY6BoCg7uAxT80kX9tXPtKVGdJMh
         VFlcuDH/gmjkTlkgALxCgDxQRWgHcjfeKx2Eb1a1plGIhs4NQ+/MkYikY3fqXZwsrhr2
         R3Zg==
X-Gm-Message-State: ACgBeo1SUdOneKklCsiHS3KlTLEGZpfnSJ+zEKuXviyTJi50IIRMSyeY
        GJkmmrSMuYU6gymNGxEoJu4tqpBMJIog
X-Google-Smtp-Source: AA6agR6fsNI1kDM+j+yiPgAkODdBZ5nkVNdQ+2RFnfzoIbQbkcztGnkSv3+NNlbmmX3iiKTbeBpl9f0UcnIk
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:902:cec6:b0:16e:ec03:ff1 with SMTP id
 d6-20020a170902cec600b0016eec030ff1mr16704649plg.96.1659918970839; Sun, 07
 Aug 2022 17:36:10 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon,  8 Aug 2022 00:36:04 +0000
In-Reply-To: <20220808003606.424212-1-mizhang@google.com>
Message-Id: <20220808003606.424212-2-mizhang@google.com>
Mime-Version: 1.0
References: <20220808003606.424212-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v3 1/3] KVM: x86: Update trace function for nested VM entry to
 support VMX
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update trace function for nested VM entry to support VMX. Existing trace
function only supports nested VMX and the information printed out is AMD
specific.

So, update trace_kvm_nested_vmrun() to trace_kvm_nested_vmenter(), since
'vmenter' is generic. Add a new field 'isa' to recognize Intel and AMD;
Update the output to print out VMX/SVM related naming respectively, eg.,
vmcb vs. vmcs; npt vs. ept.

Opportunistically update the call site of trace_kvm_nested_vmenter() to make
one line per parameter.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/nested.c |  6 ++++--
 arch/x86/kvm/trace.h      | 28 ++++++++++++++++++----------
 arch/x86/kvm/x86.c        |  2 +-
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba7cd26f438f..0a148a352c3a 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -724,11 +724,13 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
 
-	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
+	trace_kvm_nested_vmenter(svm->vmcb->save.rip,
+			       vmcb12_gpa,
 			       vmcb12->save.rip,
 			       vmcb12->control.int_ctl,
 			       vmcb12->control.event_inj,
-			       vmcb12->control.nested_ctl);
+			       vmcb12->control.nested_ctl,
+			       KVM_ISA_SVM);
 
 	trace_kvm_nested_intercepts(vmcb12->control.intercepts[INTERCEPT_CR] & 0xffff,
 				    vmcb12->control.intercepts[INTERCEPT_CR] >> 16,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index de4762517569..3ef29c7e4f69 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -578,10 +578,11 @@ TRACE_EVENT(kvm_pv_eoi,
 /*
  * Tracepoint for nested VMRUN
  */
-TRACE_EVENT(kvm_nested_vmrun,
+TRACE_EVENT(kvm_nested_vmenter,
 	    TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
-		     __u32 event_inj, bool npt),
-	    TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, npt),
+		     __u32 event_inj, bool tdp_enabled, __u32 isa),
+	    TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, tdp_enabled,
+		    isa),
 
 	TP_STRUCT__entry(
 		__field(	__u64,		rip		)
@@ -589,7 +590,8 @@ TRACE_EVENT(kvm_nested_vmrun,
 		__field(	__u64,		nested_rip	)
 		__field(	__u32,		int_ctl		)
 		__field(	__u32,		event_inj	)
-		__field(	bool,		npt		)
+		__field(	bool,		tdp_enabled	)
+		__field(	__u32,		isa		)
 	),
 
 	TP_fast_assign(
@@ -598,14 +600,20 @@ TRACE_EVENT(kvm_nested_vmrun,
 		__entry->nested_rip	= nested_rip;
 		__entry->int_ctl	= int_ctl;
 		__entry->event_inj	= event_inj;
-		__entry->npt		= npt;
+		__entry->tdp_enabled	= tdp_enabled;
+		__entry->isa		= isa;
 	),
 
-	TP_printk("rip: 0x%016llx vmcb: 0x%016llx nrip: 0x%016llx int_ctl: 0x%08x "
-		  "event_inj: 0x%08x npt: %s",
-		__entry->rip, __entry->vmcb, __entry->nested_rip,
-		__entry->int_ctl, __entry->event_inj,
-		__entry->npt ? "on" : "off")
+	TP_printk("rip: 0x%016llx %s: 0x%016llx nested_rip: 0x%016llx "
+		  "int_ctl: 0x%08x event_inj: 0x%08x nested_%s: %s",
+		__entry->rip,
+		__entry->isa == KVM_ISA_VMX ? "vmcs" : "vmcb",
+		__entry->vmcb,
+		__entry->nested_rip,
+		__entry->int_ctl,
+		__entry->event_inj,
+		__entry->isa == KVM_ISA_VMX ? "ept" : "npt",
+		__entry->tdp_enabled ? "on" : "off")
 );
 
 TRACE_EVENT(kvm_nested_intercepts,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1910e1e78b15..52f6351dc15b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13084,7 +13084,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
-- 
2.37.1.559.g78731f0fdb-goog

