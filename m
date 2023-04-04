Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1093C6D6988
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbjDDQyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbjDDQyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:54:11 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3964EE8
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:53:52 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id o14-20020a62f90e000000b0062d87d997eeso11811247pfh.18
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680627231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=seYfaNNrBFkf9Lk4dNK5VYiaJrQbK8nq8yADl/cE+5E=;
        b=G4RplOJV2t3NbvPWA7HAtR9MXxB9CMHG1AMkSZ4NcftTZcv2YLf1+dDA6OODx+i9eT
         aIxImBtv3MFsW8+9owK50sySvDqa/alUKNHre3P2A5zgAfPfGAMLiG26u5dl+rRUECBT
         CBq5PncE9hvV8/J7YrdJJuQwJyQaUaHYZM3rexIvzT8tT6ZfVhdB6OpD9yQ3gOdw+ufv
         SsAmyyq8jzWBRnIbVLB1xq4Z6fPwaqC3hQcJVmUjaJriVcFPLRbYFjfbif3oCtaIOO4o
         zg+vmCOsKeKXnngoF0iYR/A/JM0VhcunPQv2sJbkOS/XvUqz5g0M/N1V+eue0OjSMXog
         NUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680627231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=seYfaNNrBFkf9Lk4dNK5VYiaJrQbK8nq8yADl/cE+5E=;
        b=KMCPtVO2kRK4I+vKj2yOCU2pQ33iW0PkLakeF0/7Bw+pY6oWI/SGlwr9l6tQzRCaJS
         hdrnd78A3sxP8NX/TRx0n+hlUFBL96gxp8CyRvDO7lHMkpOdOfWVf2/S+mtL9GDDs7dX
         SWk/axPv/YsLV3AA6TEHhZlt1TbGPaWjbqhYBdMjyrvkWU44i7ht8pOQIho/AYaryXmJ
         CbkuQ+WON8x3D8fZD07ousshA1rWKbsku+njlmltcFF0614vQM1gCrCi089qZNPL8voK
         XWadkgHfb4nwi6XaL9ibD8bp1lxiJ4rHUf5raSazx5VQ/8fL45jQPItpC2aI6rOw9bl0
         WTlg==
X-Gm-Message-State: AAQBX9fem0mIvxsXAWjT0zm6oxOkd3akPq82lbP+iW5idX9y+ciEA2Ht
        4+2aMruWlERUXGtOPqHk0/C1cETs2JY=
X-Google-Smtp-Source: AKy350Y6q1au+t34hQu7TScOGt4Zv4K7rPXiHphTVWmRTw/TyVG0IH73jKElCz755UWu+DfsaG1Pxxgoxvs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d598:b0:230:b842:143e with SMTP id
 v24-20020a17090ad59800b00230b842143emr1150186pju.6.1680627231701; Tue, 04 Apr
 2023 09:53:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 09:53:35 -0700
In-Reply-To: <20230404165341.163500-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230404165341.163500-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230404165341.163500-5-seanjc@google.com>
Subject: [kvm-unit-tests PATCH v4 4/9] x86/access: Use standard pass/fail
 reporting machinery
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Mathias Krause <minipli@grsecurity.net>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the standard reporting machinery in the access test so that future
changes to skip variants of the test actually get reported as SKIPs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c      | 4 ++--
 x86/access.h      | 2 +-
 x86/access_test.c | 8 +++-----
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 2d3d7c7b..1677d52e 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -1209,7 +1209,7 @@ const ac_test_fn ac_test_cases[] =
 	check_effective_sp_permissions,
 };
 
-int ac_test_run(int pt_levels)
+void ac_test_run(int pt_levels)
 {
 	ac_test_t at;
 	ac_pt_env_t pt_env;
@@ -1292,5 +1292,5 @@ int ac_test_run(int pt_levels)
 
 	printf("\n%d tests, %d failures\n", tests, tests - successes);
 
-	return successes == tests;
+	report(successes == tests, "%d-level paging tests", pt_levels);
 }
diff --git a/x86/access.h b/x86/access.h
index bcfa7b26..9a6c5628 100644
--- a/x86/access.h
+++ b/x86/access.h
@@ -4,6 +4,6 @@
 #define PT_LEVEL_PML4 4
 #define PT_LEVEL_PML5 5
 
-int ac_test_run(int page_table_levels);
+void ac_test_run(int page_table_levels);
 
 #endif // X86_ACCESS_H
\ No newline at end of file
diff --git a/x86/access_test.c b/x86/access_test.c
index 74360698..2ac649d2 100644
--- a/x86/access_test.c
+++ b/x86/access_test.c
@@ -5,10 +5,8 @@
 
 int main(void)
 {
-	int r;
-
 	printf("starting test\n\n");
-	r = ac_test_run(PT_LEVEL_PML4);
+	ac_test_run(PT_LEVEL_PML4);
 
 #ifndef CONFIG_EFI
 	/*
@@ -18,9 +16,9 @@ int main(void)
 	if (this_cpu_has(X86_FEATURE_LA57)) {
 		printf("starting 5-level paging test.\n\n");
 		setup_5level_page_table();
-		r = ac_test_run(PT_LEVEL_PML5);
+		ac_test_run(PT_LEVEL_PML5);
 	}
 #endif
 
-	return r ? 0 : 1;
+	return report_summary();
 }
-- 
2.40.0.348.gf938b09366-goog

