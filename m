Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2519745D2AA
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352957AbhKYCBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348639AbhKYB7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:01 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC558C061374
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:07 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id d3-20020a17090a6a4300b001a70e45f34cso2337161pjm.0
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2WPvFXe+smrF3abD3Uwst1jNz/E7mquO/sbV/gfmeq4=;
        b=srqZZi3TGAwh5zTOhhz2tKz0xJyIcuawJjMqjz00NC+JlpvDL4Ph5S01WWoNOWbgQV
         uFqnR/1r2AEg8GGlYVIFFgvX6WIBN8Kbybg9nkRW0RR7g0pUr4+jsRxbUx2DekiHY/BW
         2UmiGGEgcmo70zqMsyug/xPNME9N7WtlI3TvFb+6ZcaqeAXTzvzU4SZLqly30Hoeqkbl
         RENFh6oeKDhfPa1F08aQMd62gvRC22VdNgWHs4Cfsopi6PEy5k4U4wEN0D542vFttaoG
         9+EEUaBaNbvTZw/Cq1p0j2zdyacR17rH+nP32+/NzDIHROEu7OYQmziVvCvMt2sT93ai
         kGHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2WPvFXe+smrF3abD3Uwst1jNz/E7mquO/sbV/gfmeq4=;
        b=I8O1NYZrr8uDZRrqb9UiCXxTgAJBPR1LHTmJK1W+fguN8O4JlBEnbK0O8Tjmlf40Qc
         0Re3ZyeEBOaY9iHo/2gj2HmAq8PMzXlTl5Hao6YQ+dYxVTekglJ6q/dQgVEfp49oWHe1
         uIVgGOQNl891gxOuk79lAZPddkybpKyfYfbWJBmphDPkn16AKYqJv2Op0Sw58iu1WQn6
         2EGP0CP5vju1Ss8nd7K1S4NCUnxC6RTY/S9x+cc0FP6x1xA7HfiO5TcjEDZUyRw52LqR
         lBbtegQReRPkX24p4/nTWPutee+mTBxMx0Fll1WByNs5rYI4WcPrvyTQGBL0gRvXE9gO
         C7iA==
X-Gm-Message-State: AOAM533Vya9BgJfejy0Bitg2jBEeD1Wvet7TLCLEFlkjecFXrTyfRej3
        ImkNAOY0FYodh9HiQlq4q9QP1b43XT4=
X-Google-Smtp-Source: ABdhPJxb6oafmIxDrBvdIkNkFI+HFSrxsDZaXPrTg0nUuVQXEONm0u1GaaI/85JWYe/Sk0yoa3gfNujwqqA=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:9882:b0:143:91ca:ca6e with SMTP id
 s2-20020a170902988200b0014391caca6emr24413115plp.64.1637803747218; Wed, 24
 Nov 2021 17:29:07 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:22 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-5-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 04/39] x86/access: Stop pretending the test is
 SMP friendly
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove SMP "support", the test is not remotely SMP friendly.  It can
barely survive one CPU modifying page tables, two would be pure carnage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 60bb379..749b50c 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -5,8 +5,6 @@
 #include "x86/vm.h"
 #include "access.h"
 
-#define smp_id() 0
-
 #define true 1
 #define false 0
 
@@ -1142,8 +1140,7 @@ int ac_test_run(int page_table_levels)
 	}
 
 	ac_env_int(&pool);
-	ac_test_init(&at, (void *)(0x123400000000 + 16 * smp_id()),
-		page_table_levels);
+	ac_test_init(&at, (void *)(0x123400000000), page_table_levels);
 	do {
 		++tests;
 		successes += ac_test_exec(&at, &pool);
-- 
2.34.0.rc2.393.gf8c9666880-goog

