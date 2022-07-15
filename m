Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616E957687C
	for <lists+kvm@lfdr.de>; Fri, 15 Jul 2022 22:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbiGOUpI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jul 2022 16:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiGOUny (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jul 2022 16:43:54 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B2D88F03
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:15 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p35-20020a631e63000000b0041992866de0so3223406pgm.19
        for <kvm@vger.kernel.org>; Fri, 15 Jul 2022 13:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=jy1PZAUQ0P4jHoHWuSaxEGbHwtNYkzT5sbHzv9tiaz0=;
        b=QRbphJ9UpDJAJGVrLJPN/Bq9pRrqAck2RRoRtrSiPyVx9Bxnfv6fC7rnvH/SmUrRA8
         v4hXcRPU9c/dEwHiaNGuCeWHy7AWuG8wcZGBUyUx0efbE4NEqresgauWo0yA8tX733VV
         0LRiXdRYRCyTDUfzB5ntSAy0/q1IBbdAbcIFXH86oruj+kkFmAs1Rt9Behvf1/mbRIyy
         m+CbVfqzTtYDnIZhVA617J8cdlxFfjyQcTHasOIeqfzds6mUxvuZQHEyZnNMvUm8cRSM
         pCYdPtSacDQ+/n5Q/pqwoUAVLpMnBJsu6Y+GZk5u4PQVXyWPgsryLq8UHRtB/kqEJ4RG
         XdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=jy1PZAUQ0P4jHoHWuSaxEGbHwtNYkzT5sbHzv9tiaz0=;
        b=lOVnhcGIsI1gIhNU8PVOpHAoZX9E/kK9dRFP72g3zYRad8lIfsOyjkLwP8xSwj6kCQ
         cVln7h36F9rpLVKrBAbWTLSI+nCKowvjDpi548tUfAQZDKwZ4LhiJnqVIEMoWCUcNcE2
         mhPP8IhxOQZOs5sByl2Y+gU/dmESXS4nksgRzo/VHvAzkxq1KWDENkUd4DD6dG0fLAYk
         exq/GILFfUPxlQ03r1x7tvahjPNiPD3inB8WlkHE/x0qDUIn+xidAQe27w9nPbyRLCTN
         JcIEiJY/j7754wFh+fOYOcYVfpwikQjboSfZ1Y6VPiA0vcoLpn9H0RNacZOi9YRhd039
         Y/FA==
X-Gm-Message-State: AJIora+Ib8uVEZkhSOh4DjYCnRvJxg63azEy3gBq9Q1ZPmA+RFCfhAO4
        6+qV/NKrTyQyoMS0OoALzqVVoCizplM=
X-Google-Smtp-Source: AGRyM1vDu/zPVPoJh4NE3/Bj7Xwte2rQwtVsYEmcZxGzijgsrvf3qY2quN9UBlJTHTeP22uSNV945y8qmJo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4211:b0:52a:c86e:aba3 with SMTP id
 cd17-20020a056a00421100b0052ac86eaba3mr16138144pfb.41.1657917782880; Fri, 15
 Jul 2022 13:43:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jul 2022 20:42:19 +0000
In-Reply-To: <20220715204226.3655170-1-seanjc@google.com>
Message-Id: <20220715204226.3655170-18-seanjc@google.com>
Mime-Version: 1.0
References: <20220715204226.3655170-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH v2 17/24] KVM: nVMX: Add a helper to identify low-priority #DB traps
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
---
 arch/x86/kvm/vmx/nested.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a0a4eddce445..c3fc8b484785 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3859,14 +3859,24 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
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
@@ -3878,8 +3888,9 @@ static inline unsigned long vmx_get_pending_dbg_trap(struct kvm_vcpu *vcpu)
  */
 static void nested_vmx_update_pending_dbg(struct kvm_vcpu *vcpu)
 {
-	unsigned long pending_dbg = vmx_get_pending_dbg_trap(vcpu);
+	unsigned long pending_dbg;
 
+	pending_dbg = vmx_get_pending_dbg_trap(&vcpu->arch.exception);
 	if (pending_dbg)
 		vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, pending_dbg);
 }
@@ -3949,7 +3960,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * prioritize SMI over MTF and trap-like #DBs.
 	 */
 	if (vcpu->arch.exception.pending &&
-	    !(vmx_get_pending_dbg_trap(vcpu) & ~DR6_BT)) {
+	    !vmx_is_low_priority_db_trap(&vcpu->arch.exception)) {
 		if (block_nested_exceptions)
 			return -EBUSY;
 		if (!nested_vmx_check_exception(vcpu, &exit_qual))
-- 
2.37.0.170.g444d1eabd0-goog

