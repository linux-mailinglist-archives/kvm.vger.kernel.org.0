Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7906E50C67A
	for <lists+kvm@lfdr.de>; Sat, 23 Apr 2022 04:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232039AbiDWCRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 22:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbiDWCRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 22:17:20 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 661F921BACC
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:25 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id x14-20020aa793ae000000b0050ad3a0b472so5024087pff.6
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 19:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2fpXsZJhGbr4MoYNSTdShihZ64Vsg8Cw64xWWeEmfo8=;
        b=h1b6lSgWxe8TBdg42eLDaS/rCLqPvrgXgz9XuK1/dcZ+XRF2KuTO0fLelihQFovgIL
         oupmS6D6UcCvaYPnwp0D6Il6duyzcSQ7343q2f1nWaVesl9OlCtq9mkRkyiAiRSMbytF
         7d+E4qjU04hxfbI0NmBx/31x628HGxgmf2C3qd2Hlj0/M9AkZqShmJ+YkXEa/mDirnlB
         wXhWU51c1t1c+ug4fiOdzmkPDVxnJx0Yn05SZfZwGucGVVdkBqxMqS+6d9B9mV5gw/01
         sWDqDgcnlY7rMobVY8+3Oc2rC+cbJDFfrD3CVrU8Vot8zsc52p84b0WJHnl0o9CZUgcg
         EdfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2fpXsZJhGbr4MoYNSTdShihZ64Vsg8Cw64xWWeEmfo8=;
        b=mfiujQwrylST47G0sbSeVBaRR7zVLI6jUiFIaMS3kDNLHo6wz9wIvnJEVjFHjS5Zal
         J44mQft/2bvt97h5GgBChTbx6BAETx8INi82WBMxkfm1iohKjAQo4uGeCUsdkXOobgl1
         n9M2tq10xH5iRGRnEf4gRg2ieon6ZJdTy//n3n/jTY+CeemcD9Dhq1vxM6WmzzZydEbq
         dMNH5VOuPh95h49krwrcywooTwCQ0CMVQqmySQ82ubG+kWwqXPMQ7IF2BCwWX2dTNHUQ
         gONZ9jPyAM2QUEWTBlMVBz0Xxln6q0OjtIu/K2FTi4H+IdtPja3ftWRL7g4vO2LQwWzJ
         K6+w==
X-Gm-Message-State: AOAM532ms1+ZxSlJmJJuu0pn2CFp+wmFKY1BOVl86pXQo5yNeKzlJCFg
        ABK346WIxz29r4NBxolPVoUw581LDIk=
X-Google-Smtp-Source: ABdhPJzkeFWXkid1f7CdUq2JgPMwKM+U8A2gs99SEHa1ULCf6QpWZgib2qh+1qu3CjwxCcXqx5APei0SkhI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:22d4:b0:50a:8540:431f with SMTP id
 f20-20020a056a0022d400b0050a8540431fmr8059369pfj.54.1650680064933; Fri, 22
 Apr 2022 19:14:24 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Apr 2022 02:14:07 +0000
In-Reply-To: <20220423021411.784383-1-seanjc@google.com>
Message-Id: <20220423021411.784383-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220423021411.784383-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v2 07/11] KVM: x86: Trace re-injected exceptions
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Trace exceptions that are re-injected, not just those that KVM is
injecting for the first time.  Debugging re-injection bugs is painful
enough as is, not having visibility into what KVM is doing only makes
things worse.

Delay propagating pending=>injected in the non-reinjection path so that
the tracing can properly identify reinjected exceptions.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/trace.h | 12 ++++++++----
 arch/x86/kvm/x86.c   | 16 +++++++++-------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index de4762517569..d07428e660e3 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -358,25 +358,29 @@ TRACE_EVENT(kvm_inj_virq,
  * Tracepoint for kvm interrupt injection:
  */
 TRACE_EVENT(kvm_inj_exception,
-	TP_PROTO(unsigned exception, bool has_error, unsigned error_code),
-	TP_ARGS(exception, has_error, error_code),
+	TP_PROTO(unsigned exception, bool has_error, unsigned error_code,
+		 bool reinjected),
+	TP_ARGS(exception, has_error, error_code, reinjected),
 
 	TP_STRUCT__entry(
 		__field(	u8,	exception	)
 		__field(	u8,	has_error	)
 		__field(	u32,	error_code	)
+		__field(	bool,	reinjected	)
 	),
 
 	TP_fast_assign(
 		__entry->exception	= exception;
 		__entry->has_error	= has_error;
 		__entry->error_code	= error_code;
+		__entry->reinjected	= reinjected;
 	),
 
-	TP_printk("%s (0x%x)",
+	TP_printk("%s (0x%x)%s",
 		  __print_symbolic(__entry->exception, kvm_trace_sym_exc),
 		  /* FIXME: don't print error_code if not present */
-		  __entry->has_error ? __entry->error_code : 0)
+		  __entry->has_error ? __entry->error_code : 0,
+		  __entry->reinjected ? " [reinjected]" : "")
 );
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 951d0a78ccda..c3ee8dc00d3a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9393,6 +9393,11 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
+	trace_kvm_inj_exception(vcpu->arch.exception.nr,
+				vcpu->arch.exception.has_error_code,
+				vcpu->arch.exception.error_code,
+				vcpu->arch.exception.injected);
+
 	if (vcpu->arch.exception.error_code && !is_protmode(vcpu))
 		vcpu->arch.exception.error_code = false;
 	static_call(kvm_x86_queue_exception)(vcpu);
@@ -9450,13 +9455,6 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 
 	/* try to inject new event if pending */
 	if (vcpu->arch.exception.pending) {
-		trace_kvm_inj_exception(vcpu->arch.exception.nr,
-					vcpu->arch.exception.has_error_code,
-					vcpu->arch.exception.error_code);
-
-		vcpu->arch.exception.pending = false;
-		vcpu->arch.exception.injected = true;
-
 		if (exception_type(vcpu->arch.exception.nr) == EXCPT_FAULT)
 			__kvm_set_rflags(vcpu, kvm_get_rflags(vcpu) |
 					     X86_EFLAGS_RF);
@@ -9470,6 +9468,10 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 		}
 
 		kvm_inject_exception(vcpu);
+
+		vcpu->arch.exception.pending = false;
+		vcpu->arch.exception.injected = true;
+
 		can_inject = false;
 	}
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

