Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C6757528F
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 18:15:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235770AbiGNQPL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 12:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232196AbiGNQPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 12:15:10 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF31961103
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 09:15:09 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id rm8-20020a17090b3ec800b001f07b25d636so1537164pjb.1
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 09:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dkEOdt8z+1pIQSagezdkrllstfb6INtaLLesK3p4CFI=;
        b=BTqgtld3O0GZjr5HkJ9RWeiVcRRn9e0qpM2xaMxSrQ5grDnHFU8XFUTNVsvSGr7DdM
         N8JwjeXyxLVVRBODIiX0mz54cAuOyigdpfYGa40s2hKIgOCvOqWMXrbzLBX5O3HPTNNN
         EXeRT1NsxYPv2CP93dpsDA/vzlY/MsgQ2KqsNHFA0cxxOKRJSFFzckCUMYgmvtXsHHJD
         SanvoBeFGCH9s+JA89HUki8rNeNdj9VDB7WQqKaIu1Nr5tUdrNS8U0jq6/qdhT6s1nVn
         NZrzQB/7Kw7TXp3K+05A0kYWeMHFy3h/7LWTorqxfAEJD77G7GyXlYcOFPb2/DLJErBX
         aNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dkEOdt8z+1pIQSagezdkrllstfb6INtaLLesK3p4CFI=;
        b=FwrILKV8ASPZJzW9xRP8IkI7HX4bOa3gBmRQZow79IT0SW6V5sUeELcJoY3ZdRZyKB
         aa4uAJZpZS3QLMVsG/4RrfK5jSFRaBy1Unliy+4uJUU0zt4Xk/NAvwNjf/Pv5qqxgIeO
         B/B7YBz1NiCuH9D2QMhfWXdcK0bmtXYHnf7cZceZoPmSce8qv0o2U1hRVBkwZkBOJ9ub
         KUlCox7Fn+uloCUs9JEW9/13vnBFFcDOkczmzN2H43scnRYJ2N9aMsyPKTWfCauW2GYj
         /JRZLIOBHVftI33n5Bl+i/yW4YupVdP1q81mkvHXjxScYF5sCKTbkIZ4YRxc0cy+62yS
         JsQA==
X-Gm-Message-State: AJIora+jr8uBb0tZa0US/6wHb7ocfgFxJ8ZQPX853Fg+M/e7GxCZZb8Y
        ZgmtTicQAWrufq0b55W9ia44Ymh1rUHLSASlGCwdYp2NDDBhuoZUbG7kKBREQMQkwoxFMb/1mt0
        2IXVWjojcTxaDHooVsMdUz9oefZ9eG2UtpDCu1hYAVp7tsJKDv7ubXApt0FA8jAIiAckn
X-Google-Smtp-Source: AGRyM1udvxYxqlIxV6mOWp22PGdrBMm+XOHXxss5gIHJ+vtF2LRL+YDv00LU8hXPtLb9kGthpv4Eqy9dZ6yN3/+w
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP
 id t9-20020a17090a024900b001e0a8a33c6cmr606882pje.0.1657815308711; Thu, 14
 Jul 2022 09:15:08 -0700 (PDT)
Date:   Thu, 14 Jul 2022 16:13:15 +0000
Message-Id: <20220714161314.1715227-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.144.g8ac04bfd2-goog
Subject: [RFC PATCH] KVM: x86: Protect the unused bits in MSR exiting flags
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
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

The flags for KVM_CAP_X86_USER_SPACE_MSR and KVM_X86_SET_MSR_FILTER
have no protection for their unused bits.  Without protection, future
development for these features will be difficult.  Add the protection
needed to make it possible to extend these features in the future.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---

Posting as an RFC to get feedback whether it's too late to protect the
unused flag bits.  My hope is this feature is still new enough, and not
widely used enough, and this change is reasonable enough to be able to be
corrected.  These bits should have been protected from the start, but
unfortunately they were not.

Another option would be to correct this by adding a quirk, but fixing
it that has its down sides.   It complicates the code more than it
would otherwise be, and complicates the usage for anyone using any new
features introduce in the future because they would also have to enable
a quirk.  For long term simplicity my hope is to be able to just patch
the original change.

 arch/x86/kvm/x86.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1910e1e78b15..ae9b7df86b1a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6029,6 +6029,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		break;
 	case KVM_CAP_X86_USER_SPACE_MSR:
+		r = -EINVAL;
+		if (cap->args[0] & ~(KVM_MSR_EXIT_REASON_INVAL |
+				     KVM_MSR_EXIT_REASON_UNKNOWN |
+				     KVM_MSR_EXIT_REASON_FILTER))
+			break;
 		kvm->arch.user_space_msr_mask = cap->args[0];
 		r = 0;
 		break;
@@ -6183,6 +6188,9 @@ static int kvm_vm_ioctl_set_msr_filter(struct kvm *kvm, void __user *argp)
 	if (copy_from_user(&filter, user_msr_filter, sizeof(filter)))
 		return -EFAULT;
 
+	if (filter.flags & ~KVM_MSR_FILTER_DEFAULT_DENY)
+		return -EINVAL;
+
 	for (i = 0; i < ARRAY_SIZE(filter.ranges); i++)
 		empty &= !filter.ranges[i].nmsrs;
 
-- 
2.37.0.144.g8ac04bfd2-goog

