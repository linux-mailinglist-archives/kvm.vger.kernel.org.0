Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E31578827
	for <lists+kvm@lfdr.de>; Mon, 18 Jul 2022 19:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234513AbiGRRNk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jul 2022 13:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiGRRNj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Jul 2022 13:13:39 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4557C2B261
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:13:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l6-20020a25bf86000000b00668c915a3f2so9057329ybk.4
        for <kvm@vger.kernel.org>; Mon, 18 Jul 2022 10:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=WarabMBj13RxoDgeWgXDdPLkycNJG5rfzGfvvAIbx1M=;
        b=GdzcESNFTxQpHw5RrEe4BvDjP3yIgc0Vn8dvnyIZZ9Zt+VqLfU3Y03yvsr7ki6JzgU
         tkbV09GrdKR/Iug+EKnQ969oSlb+koFidVQMVxbaIoGIw/HwhW3WQTrNtpuuL+juLqpY
         FJrQuvgfDM1NJieksxdVVJ8zULie0xydLRN8+/C9lHiGTwQCpQiDtHS6O2UjyZC86fbR
         xwcuUGVG6o4if3ajLoY76QlrHcxpZnwoNdRzoAZWO6jL0coJq1YIXufLzZGZ/ciLlzab
         stbHU8UkFc7YwCd3AzAArFSLVoQkrbmwsBVIBNsfylCJ0KCO7xblLf1Bv+gfrbQyfNVw
         J5FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=WarabMBj13RxoDgeWgXDdPLkycNJG5rfzGfvvAIbx1M=;
        b=DTKy5nMudnTU5+VK/uiT7WyvtKWdAZzW4IdGu0av9P0DDy2D8IinHj77zou9iWZXP7
         0feM0EHJKWTutgJyUQ2eTn82PcNgeZUcTUOmGDK16f3kR68wpiFRUtB/cPPBOZU2s/LA
         P884nmTKt1TUp/NJvo8IzpC0YVSVHb4zO6hyCG9ZPskZf9IKEHG4/CwI/rkxvHJYEnZm
         k2gVUAID+IzrLD3dMzAJOBR1d3LF4AKMNgn5FsvrugUzzM9sLq6/6VRmaJ7YUlxqVYDy
         d/RXVXYMbi/rTmzgeJjLv4T3VQR90DXjcQ0CSWRsmPz8q7KEieJSgvWcVCNAE5vJnmUL
         1wsw==
X-Gm-Message-State: AJIora+YkIz55ZAjZyuzxBao9LhiiAC/giWpK1t9oVU5zN5ZfcCxhVTP
        oj+4N2BqHWrEPkR/2RRu72ypiS4QkgMv
X-Google-Smtp-Source: AGRyM1sB9LI/oNxRdq8oJd9at9/+u0r7mDgLj9lsebQiK7+AAeuV/Tj/txhxAPWhyGXHu+w2JHmVcHSkO5oj
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a81:a18f:0:b0:31c:9318:71c5 with SMTP id
 y137-20020a81a18f000000b0031c931871c5mr31684268ywg.465.1658164417545; Mon, 18
 Jul 2022 10:13:37 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 18 Jul 2022 17:13:31 +0000
In-Reply-To: <20220718171333.1321831-1-mizhang@google.com>
Message-Id: <20220718171333.1321831-2-mizhang@google.com>
Mime-Version: 1.0
References: <20220718171333.1321831-1-mizhang@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 1/2] KVM: nested/x86: update trace_kvm_nested_vmrun() to
 suppot VMX
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update trace_kvm_nested_vmrun() to support VMX by adding a new field 'isa';
update the output to print out VMX/SVM related naming respectively,
eg., vmcb vs. vmcs; npt vs. ept.

In addition, print nested EPT/NPT address instead of the 1bit of nested
ept/npt on/off. This should convey more information in the trace. When
nested ept/npt is not used, simply print "0x0" so that we don't lose any
information.

Opportunistically update the call site of trace_kvm_nested_vmrun() to make
one line per parameter.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/nested.c |  7 +++++--
 arch/x86/kvm/trace.h      | 29 ++++++++++++++++++++---------
 2 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba7cd26f438f..8581164b6808 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -724,11 +724,14 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
 
-	trace_kvm_nested_vmrun(svm->vmcb->save.rip, vmcb12_gpa,
+	trace_kvm_nested_vmrun(svm->vmcb->save.rip,
+			       vmcb12_gpa,
 			       vmcb12->save.rip,
 			       vmcb12->control.int_ctl,
 			       vmcb12->control.event_inj,
-			       vmcb12->control.nested_ctl);
+			       vmcb12->control.nested_ctl,
+			       vmcb12->control.nested_cr3,
+			       KVM_ISA_SVM);
 
 	trace_kvm_nested_intercepts(vmcb12->control.intercepts[INTERCEPT_CR] & 0xffff,
 				    vmcb12->control.intercepts[INTERCEPT_CR] >> 16,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index de4762517569..aac4c8bd2c3a 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -580,8 +580,10 @@ TRACE_EVENT(kvm_pv_eoi,
  */
 TRACE_EVENT(kvm_nested_vmrun,
 	    TP_PROTO(__u64 rip, __u64 vmcb, __u64 nested_rip, __u32 int_ctl,
-		     __u32 event_inj, bool npt),
-	    TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, npt),
+		     __u32 event_inj, bool npt_enabled, __u64 npt_addr,
+		     __u32 isa),
+	    TP_ARGS(rip, vmcb, nested_rip, int_ctl, event_inj, npt_enabled,
+		    npt_addr, isa),
 
 	TP_STRUCT__entry(
 		__field(	__u64,		rip		)
@@ -589,7 +591,9 @@ TRACE_EVENT(kvm_nested_vmrun,
 		__field(	__u64,		nested_rip	)
 		__field(	__u32,		int_ctl		)
 		__field(	__u32,		event_inj	)
-		__field(	bool,		npt		)
+		__field(	bool,		npt_enabled	)
+		__field(	__u64,		npt_addr	)
+		__field(	__u32,		isa		)
 	),
 
 	TP_fast_assign(
@@ -598,14 +602,21 @@ TRACE_EVENT(kvm_nested_vmrun,
 		__entry->nested_rip	= nested_rip;
 		__entry->int_ctl	= int_ctl;
 		__entry->event_inj	= event_inj;
-		__entry->npt		= npt;
+		__entry->npt_enabled	= npt_enabled;
+		__entry->npt_addr	= npt_addr;
+		__entry->isa		= isa;
 	),
 
-	TP_printk("rip: 0x%016llx vmcb: 0x%016llx nrip: 0x%016llx int_ctl: 0x%08x "
-		  "event_inj: 0x%08x npt: %s",
-		__entry->rip, __entry->vmcb, __entry->nested_rip,
-		__entry->int_ctl, __entry->event_inj,
-		__entry->npt ? "on" : "off")
+	TP_printk("rip: 0x%016llx %s: 0x%016llx nested rip: 0x%016llx "
+		  "int_ctl: 0x%08x event_inj: 0x%08x nested %s: 0x%016llx",
+		__entry->rip,
+		__entry->isa == KVM_ISA_VMX ? "vmcs" : "vmcb",
+		__entry->vmcb,
+		__entry->nested_rip,
+		__entry->int_ctl,
+		__entry->event_inj,
+		__entry->isa == KVM_ISA_VMX ? "ept" : "npt",
+		__entry->npt_enabled ? __entry->npt_addr : 0x0)
 );
 
 TRACE_EVENT(kvm_nested_intercepts,
-- 
2.37.0.170.g444d1eabd0-goog

