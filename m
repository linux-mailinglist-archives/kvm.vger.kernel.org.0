Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1103B5A71B4
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 01:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiH3XTp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 19:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231981AbiH3XSc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 19:18:32 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6141DA2DAD
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:54 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3363b1dffa0so191017667b3.23
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 16:16:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc;
        bh=0/AOaEGMOEnLVXpdVz+tnbQ5CU/MJUfDeOnF55UijTA=;
        b=jQsCyEnKs5hrZxLo6apERPwi2BNAmod0kshAu73HyV4Kd5qazKYLn/Syy8pMB2nLuQ
         czINm+nAC3Mk8VYCnx1hVrMv6qklB8pbRIWFpguRbfwrUWZEnvGx0WR8e/3fmprxG2ky
         XqqjWsC0cYVtsn7HlPoEmnl/oaLEnB0CAdg/x/mas5xbpO8AtgF5nxfrYc+q4sO4RvUG
         lDmfQJ/ttD9lwts7AFVRiVLCvJsBcLqwvFllWL+t4Cs+nh4DImNOOnJTIHqLKMwHUqfy
         H21HQMkA4+f6TdA3hkOOgKvk3kB/5z/T7K6AfoZiQJxuoL29pHoiD41iMBcb+R04/J73
         e/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=0/AOaEGMOEnLVXpdVz+tnbQ5CU/MJUfDeOnF55UijTA=;
        b=yCJ7C5ANpKMgJA6Et7qyH30g6TQnQzGo7wxfL2DpOj2FMtRhQYcD6mOX61p+7Oqxpo
         gzD5SdtVZKeV0wazLmcvmTEbPyf+rgyYSshXdhcRVo6g6xUNfdTwXNRPmIKdOtBltSME
         lZKCJeuunRWAujglmmLoNNzZREPp5FeH9oUV9ORsxFGHNSyCLdFD312pQ8UMA/vACxKF
         5HWjnAipqcFR15HN6Jyspybs09W0kucWK/jKCHDC+cFK41RnrGmmpOXqiAgA+QjEh1+B
         4qDHwKGx6sGCFpfX36PbHiea5gHgeFkQa9knGORikt11uJ+VIHtqoGPQfIjZUMNq5ZgN
         6I8w==
X-Gm-Message-State: ACgBeo14Gft6OnPO3hHYj9b5PXh4MFoullwRno8l+FaKsryenHV1VxoG
        vrwwz9OKXBAWdXBHQd80sgPuHKaQJ04=
X-Google-Smtp-Source: AA6agR79fTtCYzmzR8E9SiUtgFrrMHPTvZrTGe3eji+9gZAiFbPGV4RpLl0m2jL2z9s7ZeKPXEDeVUpg51s=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c106:0:b0:695:9412:2f0e with SMTP id
 r6-20020a25c106000000b0069594122f0emr13900907ybf.206.1661901408989; Tue, 30
 Aug 2022 16:16:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Aug 2022 23:16:06 +0000
In-Reply-To: <20220830231614.3580124-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220830231614.3580124-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830231614.3580124-20-seanjc@google.com>
Subject: [PATCH v5 19/27] KVM: nVMX: Add a helper to identify low-priority #DB traps
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

Add a helper to identify "low"-priority #DB traps, i.e. trap-like #DBs
that aren't TSS T flag #DBs, and tweak the related code to operate on any
queued exception.  A future commit will separate exceptions that are
intercepted by L1, i.e. cause nested VM-Exit, from those that do NOT
trigger nested VM-Exit.  I.e. there will be multiple exception structs
and multiple invocations of the helpers.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4bc2250502ea..b76c69c50649 100644
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
2.37.2.672.g94769d06f0-goog

