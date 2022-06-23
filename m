Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2396E558617
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 20:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiFWSIm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 14:08:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236049AbiFWSGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 14:06:42 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9397089D0F
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 10:19:01 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id h18-20020a170902f55200b0016a4a78bd71so2738825plf.9
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 10:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=OfpJNowxBUFq6HGX9ecpdnodRX9bSyGbGZdG0Pw0Nvw=;
        b=X11UvkoUIym4fWAIiiVnNg8IPEcEu9qC1v5KMXIAXNHYPHSvSaMme4WPiW3+8qXhSx
         uFwVvujHGLlEZ0Of9DQDDXjK7NVaCLrdU3MKbsUNyZDwayxStPR6OjY7e1ISduKG9VJK
         ziKFElcuFjh4QgSogzI59VNvuY+ebiGUQXKQQrgdw+DklLFzL4Oz1/qYJ1pwALsh+g4P
         RH+DnnmaZVn4LJJ4viF5MLGED9TmyJfThVsxIdc+MadWby1PLvp7b5lvbgWSHRwOYupt
         kR/hPBMa2u6DHJ9+sTaK+bA9QhBeYCY/aYPrgyg9jnjudNVEAEeq1ugDBukNEb2OSNpw
         6qnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=OfpJNowxBUFq6HGX9ecpdnodRX9bSyGbGZdG0Pw0Nvw=;
        b=4qjPVQ7Bu1C4hoD4fLu59ciuhNOfdjoTYuyuxaWvLzReTP7gspfkIm+wO5Vw3LM/QE
         L9t5f8OEAP6RWmXVkVrsmSt7BI3PuQEuBl3FkIi7psDqOJf0cu6LShDKYFpuKa9s7h+m
         Re+kyK68XlJGCrJDAuG2bVllRs2AkS3IhpWS13AY9Bl4NvD1XtNcagdSr43/4YbFmVbs
         9JU3hnJjPiy5Tbx8K/oeuOcd1PB1qnf1stYUe1nJYS/ZAf4KluY9NsB8CyCr0fyJv2k8
         e8y2IPy0qLZAIWc9u26YSIcDeEoSzPI2ETLj7ENEOqkT0OI46utGtg2Nc+r9q+JJx8uC
         PKEA==
X-Gm-Message-State: AJIora8ggh9zYILUfcug582vLtobEjwhF4lipeDdyagTMbdb0pbce8wz
        GnLK9+Nhf2weWsHj0EOBPw2Yp+FcE19x
X-Google-Smtp-Source: AGRyM1sLykLfKCEgWphambxF6Mwz8XVU0CArLfRvGqh+uy1ZVV07fOUZHMnoNU22xtlsgyK8bzcNT8lU0RtA
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:90b:1e42:b0:1ec:f362:8488 with SMTP id
 pi2-20020a17090b1e4200b001ecf3628488mr5097264pjb.32.1656004741042; Thu, 23
 Jun 2022 10:19:01 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Thu, 23 Jun 2022 17:18:58 +0000
Message-Id: <20220623171858.2083637-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH] KVM: x86/svm: add __GFP_ACCOUNT to __sev_dbg_{en,de}crypt_user()
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
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

Adding the accounting flag when allocating pages within the SEV function,
since these memory pages should belong to individual VM.

No functional change intended.

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 51fd985cf21d..e2c7fada0b3d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -844,7 +844,7 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 
 	/* If source buffer is not aligned then use an intermediate buffer */
 	if (!IS_ALIGNED((unsigned long)vaddr, 16)) {
-		src_tpage = alloc_page(GFP_KERNEL);
+		src_tpage = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!src_tpage)
 			return -ENOMEM;
 
@@ -865,7 +865,7 @@ static int __sev_dbg_encrypt_user(struct kvm *kvm, unsigned long paddr,
 	if (!IS_ALIGNED((unsigned long)dst_vaddr, 16) || !IS_ALIGNED(size, 16)) {
 		int dst_offset;
 
-		dst_tpage = alloc_page(GFP_KERNEL);
+		dst_tpage = alloc_page(GFP_KERNEL_ACCOUNT);
 		if (!dst_tpage) {
 			ret = -ENOMEM;
 			goto e_free;

base-commit: 922d4578cfd017da67f545bfd07331bda86f795d
-- 
2.37.0.rc0.104.g0611611a94-goog

