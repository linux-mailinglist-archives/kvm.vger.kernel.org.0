Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4374DD00E
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 22:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiCQVUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 17:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbiCQVUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 17:20:34 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3454B2457
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 14:19:16 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id lr15-20020a17090b4b8f00b001c646e432baso5918911pjb.3
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 14:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6mHysSGkjSaV0ili798Q1zLL9ynUJ9JmihmTcdCLIZY=;
        b=kgTRMhvOjKo0YDi1oWQ8YuJ3ZeMPo74qt+/vjGdCcuqs8dkrP0TRKHe74cxBTHRisY
         pXpC7Ow+2tv6+LH3Y4J+kRigvMhRBwP34m3TIOywj5vMh3PHyuS2pozWWwFAF+JxmyQI
         ijSEtzxiCCln73+qzuFQho1qJyA+9K7PlXH2aic3sOO5/pXWtBiwYCpg7UtF2Nc/mZ0y
         leTXS0J1RZwoak/k4U9aNUICFCK2CU74Zziu/oRs7R4IMrbpMQExf1frRcDqN5tTsem9
         7Y9xQ2+RG8tgUfvE4x3Xa2sLU0ccGllxOI/YzO8blwRuY/8ZXvt3XFGf8gf/N8V/mUXi
         VhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6mHysSGkjSaV0ili798Q1zLL9ynUJ9JmihmTcdCLIZY=;
        b=BNEIbz5Q5+rJQDw+9eOWE5fIiUQazFW6I4ovsqVYDgYz5QKtnKeUVRpDh0cRLqe8by
         +h2k4HQXPjbGp2B5aJiykwuqjuCRqzNE58WqaABV5obZrxWYOXeWEgC5A7yonpKmDpsG
         /75O4eOxwaFBBEJFIJuev5PG7dtzsGqHO27u/pmGDZwU2DXZ1q3BenrlVUwHpTcPYpqs
         W3XlBYo1Zqsyuekb2KmD9WHFTa5wUCyzs3/miE2Hi4trp5ObxCoOesGbeWjn2UmpZ8k2
         OdQ0KQgfDJyIS4L8RpKxHvFAmG8jzdZROw7CR/hse8XSisqymjJPrhCtXgy9Pts8UFlh
         H5yw==
X-Gm-Message-State: AOAM532ApB3fZd0BU/tJe6UqHr/MbYUjUSzgEECiZ/1pxjJSAhq1LQxQ
        OVYgV60UVRKZoPKgMb/PO+JPjlENOMo=
X-Google-Smtp-Source: ABdhPJzRlMtFf9+BfW4ekzaU3Vlw86V5D1cZQ96eDB6kmJFiiAOOAjp/f1ObJsH6I7e0TQxtVo1VhFUhRlE=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:ef70:31aa:2364:9dda])
 (user=pgonda job=sendgmr) by 2002:a17:902:e74f:b0:151:c20b:5f39 with SMTP id
 p15-20020a170902e74f00b00151c20b5f39mr6866669plf.43.1647551956388; Thu, 17
 Mar 2022 14:19:16 -0700 (PDT)
Date:   Thu, 17 Mar 2022 14:19:13 -0700
Message-Id: <20220317211913.1397427-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH] x86/sev-es: Replace open-coded hlt-loop with sev_es_terminate()
From:   Peter Gonda <pgonda@google.com>
To:     x86@kernel.org
Cc:     Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

Replace the hlt loop in handle_vc_boot_ghcb() with an
sev_es_terminate(). The hlt gives the system no indication the guest is
unhappy. The termination request will signal there was an error during
VC handling during boot.


Cc: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index e6d316a01fdd..ae87fbf27724 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1425,6 +1425,5 @@ bool __init handle_vc_boot_ghcb(struct pt_regs *regs)
 fail:
 	show_regs(regs);
 
-	while (true)
-		halt();
+	sev_es_terminate(GHCB_SEV_ES_GEN_REQ);
 }
-- 
2.35.1.894.gb6a874cedc-goog

