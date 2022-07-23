Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73D3857EAD9
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 02:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbiGWAx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 20:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbiGWAxI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 20:53:08 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38399C1994
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:21 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id e123-20020a636981000000b0041a3e675844so3039378pgc.23
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 17:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=T7ZTAzFvlMNUytdgH9fHZ5hBLaLMdGvy2GiaJFqTamQ=;
        b=YkyM0tuSTGHGXWkmXGXxraYWNkICZoIIZ/iNxzXeej5x62mZNIzndSUh7y35R+tRQT
         yX+h/pIuM34hqyXRcWKNf1ZKTqoZwhg8hw6M3u9Km2yQ2Oexi+ex8qBUXWepRoBjE7Gc
         BiFdywACFdX8qvB7TRmqtU8tQ2+vtXYIem4s+zuDCZMhIoeG+1z44CoryhCPsIn4CkCS
         0olu86UllNl4xe1DVS3ABIK1/pdAoNdqIuXk+mQ70lqaMc1pvtFuMgx7cIunQYj5qh9n
         BA/FmPAX+UsDTI6SAHC8qMgfxMEjTSeqb8TQTHp7toXcVDnZymLoqLwrr83h+y4FM+Uf
         8pNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=T7ZTAzFvlMNUytdgH9fHZ5hBLaLMdGvy2GiaJFqTamQ=;
        b=phpXLyQHib9HhT2rkOxaDjxW5zun6fKxlTFzJESSALLhtnkFRfKnf6X0z1/NzN2xok
         0K+cCY6yZ9vsBZe/JZL6J2VBtOnuVSL4rctGsls20DkoSJwt7Fod47865fK9Cr3vljoc
         4+LWIdparuUqhR2BXiqQeWzftYTN1wZbyDKxRiNQXrCgQ54qFq4fYqq5ZhcbCiizCOVt
         9dXtLYxuFZ0WxvBYjo9WHPpREputnyPwPfvJpOQwZLcahTHcKyP0exmPEvFBrGbZAphq
         GUgI9Ftgn210JLB4RdQWpVpo+ezQfQwO4oO3aapQrsrwGLv84mqAY2FQZznvudzOjCYP
         5FKg==
X-Gm-Message-State: AJIora/lwhAue01AzvwMVqLrl/V+I+JKLe5+F2TrfiGGf6K3o9kzw69N
        qeuB4+BuSabLF7/Um8DsBCNWS0B/yBw=
X-Google-Smtp-Source: AGRyM1sg2xe3MgIUnLos3pSzqxTvjVbzTpT5+F8l9dkitvp9xzW9036R4xVmCrDZhp+w18d8uqJgKyejya0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:887:b0:1f2:af6:4d20 with SMTP id
 v7-20020a17090a088700b001f20af64d20mr20342695pjc.190.1658537529073; Fri, 22
 Jul 2022 17:52:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 00:51:30 +0000
In-Reply-To: <20220723005137.1649592-1-seanjc@google.com>
Message-Id: <20220723005137.1649592-18-seanjc@google.com>
Mime-Version: 1.0
References: <20220723005137.1649592-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v4 17/24] KVM: nVMX: Add a helper to identify low-priority #DB traps
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

Add a helper to identify "low"-priority #DB traps, i.e. trap-like #DBs
that aren't TSS T flag #DBs, and tweak the related code to operate on any
queued exception.  A future commit will separate exceptions that are
intercepted by L1, i.e. cause nested VM-Exit, from those that do NOT
trigger nested VM-Exit.  I.e. there will be multiple exception structs
and multiple invocations of the helpers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com
---
 arch/x86/kvm/vmx/nested.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 361c788a73d5..379a7b647ac7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3866,14 +3866,24 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
  * from the emulator (because such #DBs are fault-like and thus don't trigger
  * actions that fire on instruction retire).
  */
-static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
+static unsigned long vmx_get_pending_dbg_trap(struct kvm_queued_exception *ex)
 {
-	if (!vcpu->arch.exception.pending ||
-	    vcpu->arch.exception.vector != DB_VECTOR)
+	if (!ex->pending || ex->vector != DB_VECTOR)
 		return 0;
 
 	/* General Detect #DBs are always fault-like. */
-	return vcpu->arch.exception.payload & ~DR6_BD;
+	return ex->payload & ~DR6_BD;
+}
+
+/*
+ * Returns true if there's a pending #DB exception that is lower priority than
+ * a pending Monitor Trap Flag VM-Exit.  TSS T-flag #DBs are not emulated by
+ * KVM, but could theoretically be injected by userspace.  Note, this code is
+ * imperfect, see above.
+ */
+static bool vmx_is_low_priority_db_trap(struct kvm_queued_exception *ex)
+{
+	return vmx_get_pending_dbg_trap(ex) & ~DR6_BT;
 }
 
 /*
@@ -3885,8 +3895,9 @@ static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
  */
 static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
 {
-	unsigned long pending_dbg = vmx_get_pending_dbg_trap(vcpu);
+	unsigned long pending_dbg;
 
+	pending_dbg = vmx_get_pending_dbg_trap(&vcpu->arch.exception);
 	if (pending_dbg)
 		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, pending_dbg);
 }
@@ -3956,7 +3967,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * prioritize SMI over MTF and trap-like #DBs.
 	 */
 	if (vcpu->arch.exception.pending &&
-	    !(vmx_get_pending_dbg_trap(vcpu) & ~DR6_BT)) {
+	    !vmx_is_low_priority_db_trap(&vcpu->arch.exception)) {
 		if (block_nested_exceptions)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-- 
2.37.1.359.gd136c6c3e2-goog

