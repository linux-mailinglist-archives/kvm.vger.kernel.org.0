Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437674D59A7
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 05:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346368AbiCKEgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 23:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346345AbiCKEg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 23:36:27 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5E3C0869
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:35:24 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id m14-20020a17090a4d8e00b001bf2d4926c5so7169898pjh.3
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 20:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/6LQxDqWY4Esp9ZSrV3TLgBHw5oWwKje6YnPfn1gVe0=;
        b=Ek/1bsnAG/hVG7ii8JsZz32AwUfIFyGF5Pg/fau347mO2ZAfGwG0UB614TTFDqGnhZ
         rHNZfjHHrDTghOxk5BEyXlc0ltIELClmRGKqBoATRPt2BS7goqkfj8BkJF29etWZSBfQ
         ogfd/KgGzcaYkGTucgBwZK3rAZVi17Fqq+ecgRtxGKBYwsyLlIfTprCJQVJ2gxW2R2Hh
         YhQYnkAcQY23qa+zzBLg8Ex98nPHW4hsW6gQs9OibMFI4knEYxJTrytypXM1npoyVx3f
         3aQveppHSVg8Y2Lzih9UHdlOV6na/TLEB6DxPm7h8aP3uXOC5vLh7KTd70LuVtgaRbql
         SbpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/6LQxDqWY4Esp9ZSrV3TLgBHw5oWwKje6YnPfn1gVe0=;
        b=bjHGPtDVx0qES4Lu4enFfhWh3rVsa98IUMsLT1tu7MslzrHXBa/onS5Ti0jO/17x3s
         VjhlpkFiaCNYtdM0BSfkZmqDunlTFY6p/Xg0R3yD15GpDKhy979U88aAJBUv5z+aJCuF
         l9Y2tVeMA3Xa7pM0JWN6onSZpUhoDVf3SxcXMVmBLiA/r6MFbHvI4WIo3QGtOXk8kMhy
         yWDi95etS89F51kSkrSE7oR1f8r83j9LUyIa++MdYfDqTSiwTqWqcBrT1OIsxZxYmoJb
         V2raA1wmQpga1uNT4ZtRtjnvGBPA20Po20bl1dXbFUMR45LSjHMKxv/6E3O11mncZtXY
         pqRA==
X-Gm-Message-State: AOAM5330aUPyz4iA1VEPmDlW94Mp92BvizEvenOjbBGzYYeJ+gj54xN3
        Tfu6OwQG+HpgYesdHeAT3OpOdeCr7g4=
X-Google-Smtp-Source: ABdhPJzaU/3SkUVoi8JwM+s+Wt6EJBlWPhdtMUcMIgfxrHnURy15ljF5E+wyiVXG/Sj3nonWf14vKGKFkXQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2284:b0:4f7:86a3:6f6 with SMTP id
 f4-20020a056a00228400b004f786a306f6mr3370520pfe.20.1646973324382; Thu, 10 Mar
 2022 20:35:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 04:35:17 +0000
In-Reply-To: <20220311043517.17027-1-seanjc@google.com>
Message-Id: <20220311043517.17027-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220311043517.17027-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 3/3] KVM: x86: Trace all APICv inhibit changes and capture
 overall status
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Trace all APICv inhibit changes instead of just those that result in
APICv being (un)inhibited, and log the current state.  Debugging why
APICv isn't working is frustrating as it's hard to see why APICv is still
inhibited, and logging only the first inhibition means unnecessary onion
peeling.

Opportunistically drop the export of the tracepoint, it is not and should
not be used by vendor code due to the need to serialize toggling via
apicv_update_lock.

Note, using the common flow means kvm_apicv_init() switched from atomic
to non-atomic bitwise operations.  The VM is unreachable at init, so
non-atomic is perfectly ok.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/trace.h | 18 ++++++++++--------
 arch/x86/kvm/x86.c   | 29 +++++++++++++++++++----------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 105037a251b5..e3a24b8f04be 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1339,23 +1339,25 @@ TRACE_EVENT(kvm_hv_stimer_cleanup,
 		  __entry->vcpu_id, __entry->timer_index)
 );
 
-TRACE_EVENT(kvm_apicv_update_request,
-	    TP_PROTO(int reason, bool activate),
-	    TP_ARGS(reason, activate),
+TRACE_EVENT(kvm_apicv_inhibit_changed,
+	    TP_PROTO(int reason, bool set, unsigned long inhibits),
+	    TP_ARGS(reason, set, inhibits),
 
 	TP_STRUCT__entry(
 		__field(int, reason)
-		__field(bool, activate)
+		__field(bool, set)
+		__field(unsigned long, inhibits)
 	),
 
 	TP_fast_assign(
 		__entry->reason = reason;
-		__entry->activate = activate;
+		__entry->set = set;
+		__entry->inhibits = inhibits;
 	),
 
-	TP_printk("%s reason=%u",
-		  __entry->activate ? "activate" : "deactivate",
-		  __entry->reason)
+	TP_printk("%s reason=%u, inhibits=0x%lx",
+		  __entry->set ? "set" : "cleared",
+		  __entry->reason, __entry->inhibits)
 );
 
 TRACE_EVENT(kvm_apicv_accept_irq,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 965688aa6b45..7333322a22ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9053,15 +9053,29 @@ bool kvm_apicv_activated(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_apicv_activated);
 
+
+static void set_or_clear_apicv_inhibit(unsigned long *inhibits,
+				       enum kvm_apicv_inhibit reason, bool set)
+{
+	if (set)
+		__set_bit(reason, inhibits);
+	else
+		__clear_bit(reason, inhibits);
+
+	trace_kvm_apicv_inhibit_changed(reason, set, *inhibits);
+}
+
 static void kvm_apicv_init(struct kvm *kvm)
 {
+	unsigned long *inhibits = &kvm->arch.apicv_inhibit_reasons;
+
 	init_rwsem(&kvm->arch.apicv_update_lock);
 
-	set_bit(APICV_INHIBIT_REASON_ABSENT,
-		&kvm->arch.apicv_inhibit_reasons);
+	set_or_clear_apicv_inhibit(inhibits, APICV_INHIBIT_REASON_ABSENT, true);
+
 	if (!enable_apicv)
-		set_bit(APICV_INHIBIT_REASON_DISABLE,
-			&kvm->arch.apicv_inhibit_reasons);
+		set_or_clear_apicv_inhibit(inhibits,
+					   APICV_INHIBIT_REASON_ABSENT, true);
 }
 
 static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
@@ -9747,13 +9761,9 @@ void __kvm_set_or_clear_apicv_inhibit(struct kvm *kvm,
 
 	old = new = kvm->arch.apicv_inhibit_reasons;
 
-	if (set)
-		__set_bit(reason, &new);
-	else
-		__clear_bit(reason, &new);
+	set_or_clear_apicv_inhibit(&new, reason, set);
 
 	if (!!old != !!new) {
-		trace_kvm_apicv_update_request(reason, !set);
 		/*
 		 * Kick all vCPUs before setting apicv_inhibit_reasons to avoid
 		 * false positives in the sanity check WARN in svm_vcpu_run().
@@ -12939,7 +12949,6 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_pi_irte_update);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_unaccelerated_access);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_incomplete_ipi);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_avic_ga_log);
-EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_update_request);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_apicv_accept_irq);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
-- 
2.35.1.723.g4982287a31-goog

