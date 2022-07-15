Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE32057685C
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiGOUmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbiGOUmo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:42:44 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480FF87F7A
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:41 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id u64-20020a638543000000b00412b09eae15so3247329pgd.15
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=zAIzwNL1ZGu8Ha11sVgZyzB6yTaoLkRwOERB20vi4nY=;
        b=EurqSh6MJ6wlyS4+Sh9tJwu/HEy7rGSJQqpYhUR61nkdiH3KH4Cw7LjzlQUCUeyjz2
         PyS9gmEIRy2ETWOx0ZHY4LxVBDcPBtfwR1Hdzuv+hXiQMZTLwJ8a4PcReR5HJp1mQtgY
         SwAEN7qHDCj+XfF8MIl41meeJIheLHre8taVSiRaxyy3mY8iHYI3Jzfn2rErlwA8vItm
         HXy6o4uPQmNtDGIBE5+Znqc4VmDmlHNzlXz64yOtu5lodDhKNagxwhdk1N2NpbEMNsW2
         6f3X8yLQ0QHrVAjFK8gDd3UWc6XOVpfqND19h4o2DC/1RRgcEfzMmOWLdSTXEBKGmm/W
         vCKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=zAIzwNL1ZGu8Ha11sVgZyzB6yTaoLkRwOERB20vi4nY=;
        b=mkfgO/vSyiOjP+RKpk6gWROLmAOdIU79AXJUdtRhfKpJgj2I4Q+BNt5RtwKWjpNbms
         dpMtH8vpyyCfklcsaigvJJpxc2ucFANnV0VnapJaGn73nxyJBIxjINHIu/iOFhe0SDl1
         pKhczQG7Bx/fJsYTCPTNBpl4Lxrvz/kafpHOYcn6CdPF4LAlC2vOfgjMiuR/pJz/Cbcv
         0X6vAQg3+u3CRLWnzp4ITxKYNBfCjCLLodts5cM41lxBctyb7i1hrM6j8OfWytEjSh1H
         qRdC/otqJdIoPhaXO6BDrX2+StsA9xbHa7gs1Yxd4F10PL4wwVJd/5zD2rUS9V97q8JB
         VW1Q==
X-Gm-Message-State: AJIora/Ti17ovPnWKFCoxksfEaNlME7/j2AmyA2BCB0FOsb/gWWXyQdh
        BZsIGJdXCijVIS7sHij9u7tjAqNVK1w=
X-Google-Smtp-Source: AGRyM1uLYHwhtfSSMyTwaaAREVO1MvQ8DKjdD7vBMLSLZxa1wqqAoAF4oD9QamDDzVQgKp2AyyCQ6i36jCA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:c245:b0:16b:e818:b75c with SMTP id
 5-20020a170902c24500b0016be818b75cmr15675585plg.101.1657917760703; Fri, 15
 Jul 2022 13:42:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:06 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 04/24] KVM: nVMX: Treat General Detect #DB (DR7.GD=1) as fault-like
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index 05c34a72c266..2409ed8dbc71 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3846,16 +3846,29 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
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
@@ -3867,9 +3880,10 @@ static inline bool vmx_pending_dbg_trap(struct kvm_vcpu *vcpu)
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
@@ -3926,7 +3940,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * while delivering the pending exception.
 	 */
 
-	if (vcpu->arch.exception.pending && !vmx_pending_dbg_trap(vcpu)) {
+	if (vcpu->arch.exception.pending && !vmx_get_pending_dbg_trap(vcpu)) {
 		if (vmx->nested.nested_run_pending)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-- 
2.37.0.170.g444d1eabd0-goog

