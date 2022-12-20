Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A6266523D5
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 16:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbiLTPmf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 10:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbiLTPm3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 10:42:29 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8993312D1C
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 07:42:28 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3bd1ff8fadfso146145877b3.18
        for <kvm@vger.kernel.org>; Tue, 20 Dec 2022 07:42:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dsKa095cTH49SjbkUqWhE5H1MZLKKt7lRal8x2NoCtE=;
        b=Ft+A7TEX38QV7o1ykXA/7fx4gVDgUuwIxuZ0DCWDJFG9acS//ANtB8UHO+yFW2gSex
         qhctHSJwSVuf/3fF8FZCAwQTfWFo7aL/0FYFnlz9ImM5BZWYJ6kJvomCgbChzeQFFJIY
         1tA5imqyNbd5XDLIIPtiu02en+BqCJ06vVlB9iytma7Fi8o3sa/B/n66xyJ6bvieal4G
         oQGZD19Aaw4qR5N3jf9oIXQeXnPbMPNchs5jshzZGD+UO7pCnpkmnLWxj4uLNCBZ6SxJ
         gC/LWAT8ZxZ3p2vDoOhVY20USQT8CFPrlykXmFjD/AxQut/gDgFxdlZVWpW//yeUtBrQ
         wMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dsKa095cTH49SjbkUqWhE5H1MZLKKt7lRal8x2NoCtE=;
        b=g4J8rNc6gARJEfqI2dr8ixKEFI/UO5rkLTSpD/gQrQtsuN/3RRsCOczEsjq7ZxKFvX
         J8aT3nuMQhXzBbVlJyePvGXiMu6l/Qj1HHzh7YgYTS4DY24vRXuoxCSljuLwzaDU4hPI
         q5huLRW2B5BMCD0eQ8eZ+yiTVspWv3rPMdivwKODBTxY6CQkbP9y+LPtdUjokoe4X1hQ
         CLdoS2iVOwmnwyzB9cw+evoukXeZI+fHhSc2yB439knKx/2d7qIEWPabcbJe8i+PhlPY
         L81FOi+bHX0Z/x4Q6foCGj5XXKdLSdJyXrBIeeVOXQzbgOO6hEDOViuPPAkpwTijy3ol
         uYEg==
X-Gm-Message-State: ANoB5pnSdoleJuIMjpQAj1LfWhoG09dhHfPw7h06UXbGp7MFz+8EP4hA
        /ICbxbiN6aGh4zXjT9B/ZNKERGEnotk=
X-Google-Smtp-Source: AA0mqf4DYgS6xBopT3iAX+K1lX+8LK2WPFhx0Qob75zBuJ1Igc4LCcuhx/1Gd13dQcp1DU83Hd6+rJoCZ40=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5602:0:b0:713:5263:3442 with SMTP id
 k2-20020a255602000000b0071352633442mr4279506ybb.362.1671550947708; Tue, 20
 Dec 2022 07:42:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Dec 2022 15:42:24 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220154224.526568-1-seanjc@google.com>
Subject: [PATCH] KVM: nVMX: Document that ignoring memory failures for VMCLEAR
 is deliberate
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Jim Mattson <jmattson@google.com>
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

Explicitly drop the result of kvm_vcpu_write_guest() when writing the
"launch state" as part of VMCLEAR emulation, and add a comment to call
out that KVM's behavior is architecturally valid.  Intel's pseudocode
effectively says that VMCLEAR is a nop if the target VMCS address isn't
in memory, e.g. if the address points at MMIO.

Add a FIXME to call out that suppressing failures on __copy_to_user() is
wrong, as memory (a memslot) does exist in that case.  Punt the issue to
the future as open coding kvm_vcpu_write_guest() just to make sure the
guest dies with -EFAULT isn't worth the extra complexity.  The flaw will
need to be addressed if KVM ever does something intelligent on uaccess
failures, e.g. to support post-copy demand paging, but in that case KVM
will need a more thorough overhaul, i.e. VMCLEAR shouldn't need to open
code a core KVM helper.

No functional change intended.

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Addresses-Coverity-ID: 1527765 ("Error handling issues")
Fixes: 587d7e72aedc ("kvm: nVMX: VMCLEAR should not cause the vCPU to shut down")
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index b6f4411b613e..f18f3a9f0943 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5296,10 +5296,19 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 		if (vmptr == vmx->nested.current_vmptr)
 			nested_release_vmcs12(vcpu);
 
-		kvm_vcpu_write_guest(vcpu,
-				     vmptr + offsetof(struct vmcs12,
-						      launch_state),
-				     &zero, sizeof(zero));
+		/*
+		 * Silently ignore memory errors on VMCLEAR, Intel's pseudocode
+		 * for VMCLEAR includes a "ensure that data for VMCS referenced
+		 * by the operand is in memory" clause that guards writes to
+		 * memory, i.e. doing nothing for I/O is architecturally valid.
+		 *
+		 * FIXME: Suppress failures if and only if no memslot is found,
+		 * i.e. exit to userspace if __copy_to_user() fails.
+		 */
+		(void)kvm_vcpu_write_guest(vcpu,
+					   vmptr + offsetof(struct vmcs12,
+							    launch_state),
+					   &zero, sizeof(zero));
 	} else if (vmx->nested.hv_evmcs && vmptr == vmx->nested.hv_evmcs_vmptr) {
 		nested_release_evmcs(vcpu);
 	}

base-commit: 9d75a3251adfbcf444681474511b58042a364863
-- 
2.39.0.314.g84b9a713c41-goog

