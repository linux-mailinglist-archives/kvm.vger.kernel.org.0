Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56F0454BC2B
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242772AbiFNUrv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbiFNUro (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:47:44 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992D81E3FC
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:43 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-313e5c642dcso35463627b3.3
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jEcsHGHZ3tbmjisn5h6g94WTrwdGvhdt4EBmx2YsX+U=;
        b=LOxkx5oIOTsQ5sTn5IbpHJJPqFHBqQKUqN/C8g6IBCxB5QmVwXyUe3/dhubAVdk7pF
         QjdafCBIojLN3yYLJjkdNgkCCwNwC/58ktSG5g0KIkPr8C7oaMoKdCBJB+rVVLvq92r5
         NJTAdqGZPeeScjH5p6o3ndzELWbwbMwQnPYkurnYT5JdMNqqgZXLmgExqTu9+JS5UBZq
         8EfbMgr716/OYvgnyHkUEGQc2Vr3ZJDkMAluYfqv6S8usClFPC0dewoSk1VJFtHbD/r2
         DR8m6j31+RlthN0Xzf30lZysD/fTSn12i1haGdJcCOERy88Xbb6clENUsTjjCd+dhdKj
         r7zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jEcsHGHZ3tbmjisn5h6g94WTrwdGvhdt4EBmx2YsX+U=;
        b=ctoFyiXdkuhJxmc6s33yKiiGX3yPaLXl8mwQjz7pLBi721Lb8+YxTPYcQp2X7F8dbX
         923jzDnp9q5w/nSHUHkAZ8cg/6QndTwJRR52pjyMI9ximSDQPkTe/HhFLjNtZ8rz2WnU
         9KaASwuzgthyJatVfhBB9tYf8kCFM9rWorcGftapujxI+GArgxstq4FKSJGlkYZDbVYs
         rcelsT7eOH1x6DCUstcATgh2ACnTtPsrag9hdXA62R9NKGd+gYg85IhLy6yxZzD8JF2a
         OrvTlOdcA+5UB8To+2Wku0sdfwl9Ri4QbhYh+IpJwfIfIeZ1V08l9TwHa3F2qa8maHB0
         ke/Q==
X-Gm-Message-State: AJIora+uQbDEnZQwc8BgKTKBOGCpl7Qfn/cRtJGoWQVt/UFDs1rZagy8
        ZPRkaIfQea5mwlqd/YZAQ8fS7WBb+oA=
X-Google-Smtp-Source: AGRyM1tQYhTGKvlNHn213iE9pmBdoZ5Tro+vA82JvY1EHUiyq9fB5NCsmwyDOTqZom0mtUhlWLPT+jvidvE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:a227:0:b0:663:5bea:8954 with SMTP id
 b36-20020a25a227000000b006635bea8954mr7153891ybi.513.1655239662864; Tue, 14
 Jun 2022 13:47:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:47:13 +0000
In-Reply-To: <20220614204730.3359543-1-seanjc@google.com>
Message-Id: <20220614204730.3359543-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220614204730.3359543-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 04/21] KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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

Exclude General Detect #DBs, which have fault-like behavior but also have
a non-zero payload (DR6.BD=1), from nVMX's handling of pending debug
traps.  Opportunistically rewrite the comment to better document what is
being checked, i.e. "has a non-zero payload" vs. "has a payload", and to
call out the many caveats surrounding #DBs that KVM dodges one way or
another.

Cc: Oliver Upton <oupton@google.com>
Cc: Peter Shier <pshier@google.com>
Fixes: 684c0422da71 ("KVM: nVMX: Handle pending #DB when injecting INIT VM-exit")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 33ffc8bcf9cd..61bc80fc4cfa 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3857,16 +3857,29 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
 }
 
 /*
- * Returns true if a debug trap is pending delivery.
+ * Returns true if a debug trap is (likely) pending delivery.  Infer the class
+ * of a #DB (trap-like vs. fault-like) from the exception payload (to-be-DR6).
+ * Using the payload is flawed because code breakpoints (fault-like) and data
+ * breakpoints (trap-like) set the same bits in DR6 (breakpoint detected), i.e.
+ * this will return false positives if a to-be-injected code breakpoint #DB is
+ * pending (from KVM's perspective, but not "pending" across an instruction
+ * boundary).  ICEBP, a.k.a. INT1, is also not reflected here even though it
+ * too is trap-like.
  *
- * In KVM, debug traps bear an exception payload. As such, the class of a #DB
- * exception may be inferred from the presence of an exception payload.
+ * KVM "works" despite these flaws as ICEBP isn't currently supported by the
+ * emulator, Monitor Trap Flag is not marked pending on intercepted #DBs (the
+ * #DB has already happened), and MTF isn't marked pending on code breakpoints
+ * from the emulator (because such #DBs are fault-like and thus don't trigger
+ * actions that fire on instruction retire).
  */
-static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
+static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.exception.pending &&
-			vcpu->arch.exception.nr == DB_VECTOR &&
-			vcpu->arch.exception.payload;
+	if (!vcpu->arch.exception.pending ||
+	    vcpu->arch.exception.nr != DB_VECTOR)
+		return 0;
+
+	/* General Detect #DBs are always fault-like. */
+	return vcpu->arch.exception.payload & ~DR6_BD;
 }
 
 /*
@@ -3878,9 +3891,10 @@ static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
  */
 static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
 {
-	if (vmx_pending_dbg_trap(vcpu))
-		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS,
-			    vcpu->arch.exception.payload);
+	unsigned long pending_dbg = vmx_get_pending_dbg_trap(vcpu);
+
+	if (pending_dbg)
+		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, pending_dbg);
 }
 
 static bool nested_vmx_preemption_timer_pending(struct kvm_vcpu *vcpu)
@@ -3937,7 +3951,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * while delivering the pending exception.
 	 */
 
-	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
+	if (vcpu->arch.exception.pending && !vmx_get_pending_dbg_trap(vcpu)) {
 		if (vmx->nested.nested_run_pending)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-- 
2.36.1.476.g0c4daa206d-goog

