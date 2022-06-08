Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41D18544029
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbiFHXvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbiFHXvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:51:06 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FAE6462
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 16:52:57 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id y2-20020a655b42000000b0040014afa54cso171485pgr.21
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 16:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=aGc4nzTus6cFJYiA6Zc2wi7XNpxMgNlMybpT7jsm0n4=;
        b=r7ZSIShOg4/awxk6M6aurtKDudpNVBT/rE9eGV5317xmGNBYA6zLMscLyn4r9l932Z
         LeDswhcmC76vu8USMyKqFMA85ds5BlWgTzCzYtNBSnpvklxhArsoI9GZb+BF16n56nZc
         yfNSR5NHuSOmtKk7eEB6aaQE1TPp/sbrzePc6HqSVAQBZ5Yt/9/CASTkKOwoX+Xgji4O
         KU9dFEowe/ZkMmNRP8gwCfDMu62kQ+KwTya4Jygl3dh3SZviA9JP4iSKHJd0u62HW57c
         0RdTdrzojkX/ebf6891TAHiGzlKYlEQYDOEihuHxULVFrjeKykMJ3wI6rf3wqC1RDPFt
         29HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=aGc4nzTus6cFJYiA6Zc2wi7XNpxMgNlMybpT7jsm0n4=;
        b=oW4KNQo3d1I8ZLZPZUZwCba5aKoc9oNWrgyGa+pKBLXOlDsfCBeFnsyiD0MZMmfgmv
         ax1o6gNOD4oGgyG21WkxfkXKgzZNl0iE+hTRD3dZstm5HV0+Ieuyep50XAR8H9vVGZfk
         0igYyhi5m4rmgkU60I8gIe/T7wjkBJTC7zKaYhwqnY5ZqWQo9iJWDThrQCv9ah9ZRlMK
         tLlTFJ3+oZbciAtMxSwTdI+wmF5cY2aS4Ltvf7BjDOaW1DdMl2GndP97Dqv57bPgAurs
         H5cYGn4c5KUO9SsTXpb52vc2jzpEzi8nmfqmlrNAZtm/CM6ifM2+jEefDi2fcpDHkKcx
         Ssjg==
X-Gm-Message-State: AOAM532Fupkjls8PDZNyOH1EpFQIo6RDysI6Iy14CnR9u3z/AGkHNGDH
        +jcFmTDcsGA3N/XgcWp8mqrpWnvQyaA=
X-Google-Smtp-Source: ABdhPJyMUuzr+KtCyK+9ZlU3IaJsZEnr1U0rNmvqmP6+PpTQb/6PR+zy6Ag92a6BN/osWPWql3CmCcvS70k=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2286:b0:51c:48b7:a445 with SMTP id
 f6-20020a056a00228600b0051c48b7a445mr8498743pfe.62.1654732376865; Wed, 08 Jun
 2022 16:52:56 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 23:52:37 +0000
In-Reply-To: <20220608235238.3881916-1-seanjc@google.com>
Message-Id: <20220608235238.3881916-10-seanjc@google.com>
Mime-Version: 1.0
References: <20220608235238.3881916-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [kvm-unit-tests PATCH 09/10] nVMX: Simplify test_vmxon() by returning
 directly on failure
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
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

Return '1' directly if a VMXON subtest fails, using a second variable and
a goto is silly.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 09e54332..4562e91f 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1455,43 +1455,35 @@ static int test_vmx_feature_control(void)
 
 static int test_vmxon(void)
 {
-	int ret, ret1;
 	u64 *vmxon_region;
 	int width = cpuid_maxphyaddr();
+	int ret;
 
 	/* Unaligned page access */
 	vmxon_region = (u64 *)((intptr_t)bsp_vmxon_region + 1);
-	ret1 = __vmxon_safe(vmxon_region);
-	report(ret1 < 0, "test vmxon with unaligned vmxon region");
-	if (ret1 >= 0) {
-		ret = 1;
-		goto out;
-	}
+	ret = __vmxon_safe(vmxon_region);
+	report(ret < 0, "test vmxon with unaligned vmxon region");
+	if (ret >= 0)
+		return 1;
 
 	/* gpa bits beyond physical address width are set*/
 	vmxon_region = (u64 *)((intptr_t)bsp_vmxon_region | ((u64)1 << (width+1)));
-	ret1 = __vmxon_safe(vmxon_region);
-	report(ret1 < 0, "test vmxon with bits set beyond physical address width");
-	if (ret1 >= 0) {
-		ret = 1;
-		goto out;
-	}
+	ret = __vmxon_safe(vmxon_region);
+	report(ret < 0, "test vmxon with bits set beyond physical address width");
+	if (ret >= 0)
+		return 1;
 
 	/* invalid revision identifier */
 	*bsp_vmxon_region = 0xba9da9;
-	ret1 = vmxon_safe();
-	report(ret1 < 0, "test vmxon with invalid revision identifier");
-	if (ret1 >= 0) {
-		ret = 1;
-		goto out;
-	}
+	ret = vmxon_safe();
+	report(ret < 0, "test vmxon with invalid revision identifier");
+	if (ret >= 0)
+		return 1;
 
 	/* and finally a valid region */
 	*bsp_vmxon_region = basic.revision;
 	ret = vmxon_safe();
 	report(!ret, "test vmxon with valid vmxon region");
-
-out:
 	return ret;
 }
 
-- 
2.36.1.255.ge46751e96f-goog

