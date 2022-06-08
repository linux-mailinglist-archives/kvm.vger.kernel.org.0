Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAC2544026
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235386AbiFHXvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiFHXvB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:51:01 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918DF17CC8A
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 16:52:52 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id f9-20020a636a09000000b003c61848e622so10854473pgc.0
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 16:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=J7R1gSo+oUH/FTeZkdyYxLvII4iVrvsMjS0mB5HmK2A=;
        b=J1wuA4A4vAQX0vW+3XjgludLEUgCY58xEYEryhLkGRvjVT3y/W0pxzlU/M/LTdZk3R
         K+gOB3NliyXVn7UTNnxPu2dRMSXfL9kP+H9ZsFa8tzMk36pw0LCdC/N7bsuYsLDbv7Iz
         OErKNARgGLlJzghAOpdKF4D41mcFlgT+UvAf3/De0XkdkaHordk49iJbzOeMSe8U2eEN
         GBM/QMsarOgmCd6l2yg62BInXXZoChEgpPg/Cqh4EZJ6KZlcCAuFm0VlzpoFe/4Ml9E1
         /Mpt+pZA2vAPPuh4LqJcGqG1ksJBXdD/xSs81zbvnNQWXTEu2AM1PnscsyErDpO2cOrj
         OZ5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=J7R1gSo+oUH/FTeZkdyYxLvII4iVrvsMjS0mB5HmK2A=;
        b=sDNjWD1kcPxaXniwlyCD+JHrvostUda/4qrZ+bgYbLRxrfisEV4dW3cQLBiMKDf97l
         k2A2rR65i+B0GNi1DW+c6wfOXoDYR6w764ASS1ec9YVaIGR/g96A4kqlB7vmhIE6CfLU
         dLVGfmLgTcZWrZzukswWPfm0c2FvdKOSy7luF1NqWvTPVa6Et2MgY5zQJBS1abc7eRqp
         Go0vDTsjtRuRe1BZrNMa06qhaUmv2FrgRV7ag2TLkpblU6jtH2pEsH5afRSvKNyQxelY
         2Xr/BjLH7yraK94ByQQ+m9+Fv0iXO8etUtGWMFXx5QfxKVgj4lzniltAzVPVrGCvkmfb
         gPDA==
X-Gm-Message-State: AOAM531VRvXoYSCQFW4M82e76Tik+QL0PVcX+ddhheaChAyVFnO3bqvp
        HScg+cmS0IiagAdu9WrMnwSgR6uEbLE=
X-Google-Smtp-Source: ABdhPJwCJg73RZSBczqpeg3KJ2bnQfkVq7vc0s7VvpgnwBBZ6ufPli5RNMgM71chOmIOlf65aAOnLw5s3yc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:9217:0:b0:518:367d:fa85 with SMTP id
 23-20020aa79217000000b00518367dfa85mr103397587pfo.9.1654732371967; Wed, 08
 Jun 2022 16:52:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 23:52:34 +0000
In-Reply-To: <20220608235238.3881916-1-seanjc@google.com>
Message-Id: <20220608235238.3881916-7-seanjc@google.com>
Mime-Version: 1.0
References: <20220608235238.3881916-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [kvm-unit-tests PATCH 06/10] nVMX: Check the results of VMXON/VMXOFF
 in feature control test
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

Assert that VMXON and VMXOFF succeed in the feature control test.
Despite a lack of "safe" or underscores, vmx_on() and vmx_off() do not
guarantee success.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index 65305238..8475bf3b 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1401,8 +1401,8 @@ static void init_bsp_vmx(void)
 
 static void do_vmxon_off(void *data)
 {
-	vmx_on();
-	vmx_off();
+	TEST_ASSERT(!vmx_on());
+	TEST_ASSERT(!vmx_off());
 }
 
 static void do_write_feature_control(void *data)
-- 
2.36.1.255.ge46751e96f-goog

