Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8A2E5A7196
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbiH3XR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:17:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbiH3XRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:17:17 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D484A0248
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:27 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 36-20020a17090a0fa700b001fd64c962afso5384626pjz.5
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=cNQuNeWyRHQgOj4jrxbhlCOXcJ4T7+kRTqVJB33Ymrw=;
        b=pwcbOpDxqsQS1Fv94mfH9hIu542GuS2+Fnk+N/X1e0buw7zBEcus1yP5JbKiryySbo
         0ty0C7RbSZdYAQ3Vn9cpHaVMDf7XRGSN9BunvsybMV6qFxOpIo+vojMkNU8yaLiAsm3z
         DR1zpsMAD0Dd8M3bwm+dSKfT67/wAUf4AZauAhuUHP/LavD/9Nz66nDbMmGZi3d/4dKK
         kAamSIE7uJbaolhD1ExJ9QABS8v2oVT+fY4qpNc7/ZgCOkby0kevQxS/NwHoh6Oymt8z
         cPBcZalzqN5aoaSygfp3QwiYhb1xCYC7l7uEvoe1X5LqK99KErnXraZZSjhkK5iU9IQB
         Bgcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=cNQuNeWyRHQgOj4jrxbhlCOXcJ4T7+kRTqVJB33Ymrw=;
        b=Lsk9+diF8XCtfDs3QG5/wxPJINSPTC0e4brP5cRtJfTcYhvRxR7EblkQlepkprEUTV
         4UUiZjiIKe1cxgLoTV3TuQg15Y+t0Q1f+YXAHrnG8E8JJl2RaKOPwt8f/t41Dz81SrbM
         52XV7ArJmhTeIKto2auQzAF7tH5crBPvQQJ++vhUzQqj8GoSX0PZxIs6DVZ01Z/to0ID
         Gqai1mE7gxoyZKRy9ictSTwz/JIyqaiEPyw7jKDg6NN8MWCDDQ/xNRhcDLb5pIhXj9PT
         GJW1/zW9RramldjBMw3L/3CAyLtfGoaUVZEXZw53zFDvcGkwxXkg+5VbM1fOsGpuegxT
         8WSw==
X-Gm-Message-State: ACgBeo2kob+Mr+q45/xFr06xrYa+iz4GraxXURJsXlTzF5P/CSes5NS7
        UFOMY8C6VepUIwiIJs1TrIDMmsC/m7E=
X-Google-Smtp-Source: AA6agR4m02pis1qh+TDoZtmCLoo4gyWr8tA9X0my22KIOYFNgMvUeqsuvznp0p9kvjwvgzhImeawt1Fkuxg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1943:b0:53a:8602:6758 with SMTP id
 s3-20020a056a00194300b0053a86026758mr3548761pfk.47.1661901386796; Tue, 30 Aug
 2022 16:16:26 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:15:53 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-7-seanjc@google.com>
Subject: [PATCH v5 06/27] KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 2ca8f1ad9c59..b540c7bf4753 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3853,16 +3853,29 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
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
@@ -3874,9 +3887,10 @@ static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
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
@@ -3933,7 +3947,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * while delivering the pending exception.
 	 */
 
-	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
+	if (vcpu->arch.exception.pending && !vmx_get_pending_dbg_trap(vcpu)) {
 		if (vmx->nested.nested_run_pending)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-- 
2.37.2.672.g94769d06f0-goog

