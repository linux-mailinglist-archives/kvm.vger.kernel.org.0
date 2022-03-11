Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA244D58E9
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 04:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346037AbiCKD3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 22:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346030AbiCKD3P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 22:29:15 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBD3EB325
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:12 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id bj8-20020a056a02018800b0035ec8c16f0bso4054368pgb.11
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 19:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=j4Z3T+nzzIPRS6v7RNtG7klN67ptidGFnGzueq2K4lA=;
        b=ZoWE8aSMXhRnbdnYUKJb/+InFLaumFndZAxbWr2Xetg1Mpig0CEcJL6dTdPZB/R851
         3joeMc8nNG0Jn3syn9EVyM9wL0buqRTW8TJENX26wbHccDz3g183otaOVLJkv3lobo0C
         NWmCThPSgO+Gb0ik+U6TzXR5/0tAz0/A4H/XABISWFdhB+p3Vid+pqlxgv5NRRfzruLs
         vd4RQJBFEs0SXXgpixydqt/xnl/qWRzkZ93NPOJWjKYas5Bo+yJC/kw8r6GcPGK2Brf1
         /JV0Lgp7xt+1KeOBndPb6y8c76Mmj5jgetbqG+tFceapYw4OyDdgiqIc0mKR12B1diQ+
         3UrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=j4Z3T+nzzIPRS6v7RNtG7klN67ptidGFnGzueq2K4lA=;
        b=xoZfnuZXKsN7c5CHzuyRxvDBujSmJ+eNf0VDLwhWeHngyH2Pyj7ZvpL+uZIAp/fLJ3
         j0rG3ikqKuf5tObKahfAmCNw+ISu3qsF01+sixuxzgxGwv4jIaTaHXkv4N0bC1r18mlC
         ZP4MejaOFzDrguXdT3rLXWAYwJU/43JzaUw9p4Sk/dxOc3q0sCuBVWrtWR+E2t16q//d
         yaxFlfyBKKXTV1HMBIXRurFECpGbtaZJA+wVY29Yc6Fw9jxPU0aNSkHv2jEgMcF/Vxqb
         PChP5n9fzFCx441U3B7hPCo8f0ZUI9MTtUx7EOfrtQN+BulTJX23ElMtdfplCaGhyg2P
         hvRg==
X-Gm-Message-State: AOAM533aotVzwVEN7D0DYtOG8SbpWobN0xqdC5X7UDgKl80gPJWa4rzq
        mL9pFTXpzlYGHYIf0fd6q1iFfDhgoFk=
X-Google-Smtp-Source: ABdhPJz9vgLqgAlkmRAnk1nSs/gcNRQ9fjAPHBeNipVq0wvL8suZfMpo5RvlYD7tCfYlthJeiYYFZv21oIE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7895:b0:14b:6b63:b3fa with SMTP id
 q21-20020a170902789500b0014b6b63b3famr8166081pll.156.1646969292083; Thu, 10
 Mar 2022 19:28:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 11 Mar 2022 03:27:45 +0000
In-Reply-To: <20220311032801.3467418-1-seanjc@google.com>
Message-Id: <20220311032801.3467418-6-seanjc@google.com>
Mime-Version: 1.0
References: <20220311032801.3467418-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 05/21] KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like
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
index 7bdda9ef2828..298a58eaac32 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3832,16 +3832,29 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
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
@@ -3853,9 +3866,10 @@ static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
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
@@ -3912,7 +3926,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * while delivering the pending exception.
 	 */
 
-	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
+	if (vcpu->arch.exception.pending && !vmx_get_pending_dbg_trap(vcpu)) {
 		if (vmx->nested.nested_run_pending)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-- 
2.35.1.723.g4982287a31-goog

