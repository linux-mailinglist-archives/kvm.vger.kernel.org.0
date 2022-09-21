Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C595E569E
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 01:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiIUXMB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 19:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbiIUXL7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 19:11:59 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98355A6C55
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 16:11:57 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id pc10-20020a17090b3b8a00b00202be8d81d2so187615pjb.1
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 16:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=5N+qD6kUfA6Yjc8dlhLRYo8RtzvrgVUSBJOdifVU1N0=;
        b=UctH4ZPfffrS1HfkBMJQCmKMEP8RHM7tbR2Qx5RAQms17rGMmYPt4CuHjYLdHr3Blw
         IanOIiu60sJnLNAfh+rDsSlDkDOVWPSif7NcjeQynSOICbb3JsbR87geXRbJNIApdeGJ
         banIxP/ubH1QsgciW6IeCcs9bFFjshkCKPIFM/BnabozdS69PlOZlzCmSVitLr/L4H3s
         Cb0f9dToq0OMGl63i8m6DoY8D+sHVfz86QVO+sifCbtlCjabxKHPjev8IG7Bt3imYJDD
         h7DEHrcxW4KRi/ZS3Gu66bDGkVk3pamMi5ffEqIHmgmzkYTifunjADSJCxi4XUkEba2v
         C8og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=5N+qD6kUfA6Yjc8dlhLRYo8RtzvrgVUSBJOdifVU1N0=;
        b=zE6bq/J4U+IhimxSjWs3ZiMPIAfc5zElaubTRIIgzq3PpydMTxWk5o0oO2O4+r+3I+
         7egfkpUuuh+xMI5FCgeAratgE7pggpDAK78mYdOV1GTvXC7qxdVyYsRoVKNe4OBImOOZ
         zA9Cz0aEpoJCr/HJqctAeROjgInDYG6/s3rf2yK5pkrcfZovgodEl2mNL3c1oDbPTtZO
         GBTsSvRqff8i3uhEWvW3ZQIRuyRUdIcvNsY4JooQTsOD49te/YhmooXYhlaFwFnevtIJ
         vZ1vC7WkmZAP3fR3Y0xRjp9M7x2bdDvRzWkmY157FTtkkNnCOZSAzgdOlGZv7X2h83hm
         kWWA==
X-Gm-Message-State: ACrzQf2L9V1cNdbMx4j8IfFDWTUTd3vi7nDw8T4m1GGy+c0UxJZ2ep8J
        dx8/ihZNbV8/KsXUCdBB8fws0y7UjrCT
X-Google-Smtp-Source: AMsMyM5oltV0dcetU1A61JUWjVMhrImpQ5MUt0rlmj5gAqYa2ej9/SVcI7X5pLglMw/rq0qMd68VPbaeHO+8
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90b:10a:b0:200:2849:235f with SMTP id
 p10-20020a17090b010a00b002002849235fmr29593pjz.1.1663801916619; Wed, 21 Sep
 2022 16:11:56 -0700 (PDT)
Date:   Wed, 21 Sep 2022 16:11:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220921231151.2321058-1-vipinsh@google.com>
Subject: [PATCH] KVM: selftests: Fix hyperv_features test failure when built
 on Clang
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     jmattson@google.com, vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

hyperv_features test fails when built on Clang. It throws error:

	 Failed guest assert: !hcall->ud_expected || res == hcall->expect at
	 x86_64/hyperv_features.c:90

On GCC, EAX is set to 0 before the hypercall whereas in Clang it is not,
this causes EAX to have garbage value when hypercall is returned in Clang
binary.

Fix by executing the guest assertion only when ud_expected is false.

Fixes: cc5851c6be86 ("KVM: selftests: Use exception fixup for #UD/#GP Hyper-V MSR/hcall tests")
Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>

---
 tools/testing/selftests/kvm/x86_64/hyperv_features.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 79ab0152d281..ad01868548f9 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -81,13 +81,13 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 	}
 
 	vector = hypercall(hcall->control, input, output, &res);
-	if (hcall->ud_expected)
+	if (hcall->ud_expected) {
 		GUEST_ASSERT_2(vector == UD_VECTOR, hcall->control, vector);
-	else
+	} else {
 		GUEST_ASSERT_2(!vector, hcall->control, vector);
+		GUEST_ASSERT_2(res == hcall->expect, hcall->expect, res);
+	}
 
-	GUEST_ASSERT_2(!hcall->ud_expected || res == hcall->expect,
-			hcall->expect, res);
 	GUEST_DONE();
 }
 
-- 
2.37.3.968.ga6b4b080e4-goog

