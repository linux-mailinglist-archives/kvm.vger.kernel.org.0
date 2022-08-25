Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976715A1CDA
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 00:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244484AbiHYW6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 18:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244468AbiHYW6J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 18:58:09 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3774C6EBC
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 15:58:07 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-335ff2ef600so365933927b3.18
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 15:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=wX6f3Odvjz4F7Hal7LKKrZsLMNpsU/ZOr3kUt12Hrdw=;
        b=ePwiA86IU6ajvcecOukINsd4ZYf3xHEn+2u/MCnJRdfZUS1t3ztKHdF1gwvJoRaID3
         7CiNU9yRu4e1BypxkFLwI8TzId2PumYz88L0QBaKibm3sJofU8k0ELV4LbKfrc0CUWsa
         LLywnJPoAC7LNchySzg2X0llHiy5guITKiygTVSUdm+WSNG1L++mUFG+HHhWo/KpRFXg
         z3+LaNq26/kzU0Tbdp9napC9eQugcnu5ev858qEROWO2LLC/Q9hCBlDgvuq8X4Q6Ez+4
         Ito0I8yLAFdSNLj4/Pl3IE6toeRA11DzIkh/37onOdKW7kAO5FH1aAF6MkTxoDzxbGKR
         c7ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=wX6f3Odvjz4F7Hal7LKKrZsLMNpsU/ZOr3kUt12Hrdw=;
        b=KQxbMPqpYAIcPmw0wCNpIvxT9KQukcg8MrdJBIxdDLBGSIYMxBu/hTb8n/B8XcFK/7
         1PzyF2/YDn5lGKHNNYDaxMVKRPbbraLNPjfIonPwVwuHMGY9z8eCjXN59nTKu2HX9o4a
         bKXVWnviWMG9c1/etTIspJSOOwWjUlmpWqOAOQ1FbEP8zZNNWSEUCb9o6lqxPWqgC0k7
         wNUYPu5XDjU3eSU5bxsXl0driuDrrFiyVTTfiFT/1HFqB9XIAZ6qk1OwY4aK1RvdpDmO
         //6XP0Xkqx20Pn0KS4URWVFId8ZuR2OU47i76aqkgcftORYbtD+xmWQGfQNcv+cOrs/E
         eEmg==
X-Gm-Message-State: ACgBeo1jvbgfJpsCu9kh7pWcaXUc019GSHfRcJofKNg/i0JOZgI3d4zb
        XYDIJSHcozoIvra1T/pflVNHYreb+Mbm
X-Google-Smtp-Source: AA6agR5GbnSy3kehJOFUmZlLAOaVnM/d5MemD/wEjTt6QgrkUsj1gYxbzrLeiTfyILaQX/gzlCfBqv5X99UH
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a25:6601:0:b0:693:caac:2d8b with SMTP id
 a1-20020a256601000000b00693caac2d8bmr5169050ybc.579.1661468286604; Thu, 25
 Aug 2022 15:58:06 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Thu, 25 Aug 2022 22:57:53 +0000
In-Reply-To: <20220825225755.907001-1-mizhang@google.com>
Mime-Version: 1.0
References: <20220825225755.907001-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220825225755.907001-2-mizhang@google.com>
Subject: [PATCH v4 1/3] KVM: x86: Update trace function for nested VM entry to
 support VMX
From:   Mingwei Zhang <mizhang@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 76dcc8a3e849..835c508eed8e 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -781,11 +781,13 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
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
index 2120d7c060a9..e7f0da9474f0 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -589,10 +589,11 @@ TRACE_EVENT(kvm_pv_eoi,
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
@@ -600,7 +601,8 @@ TRACE_EVENT(kvm_nested_vmrun,
 		__field(	__u64,		nested_rip	)
 		__field(	__u32,		int_ctl		)
 		__field(	__u32,		event_inj	)
-		__field(	bool,		npt		)
+		__field(	bool,		tdp_enabled	)
+		__field(	__u32,		isa		)
 	),
 
 	TP_fast_assign(
@@ -609,14 +611,20 @@ TRACE_EVENT(kvm_nested_vmrun,
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
index d7374d768296..0c36528ab345 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13375,7 +13375,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_page_fault);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_msr);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_cr);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmrun);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmenter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_vmexit_inject);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_nested_intr_vmexit);
-- 
2.37.2.672.g94769d06f0-goog

