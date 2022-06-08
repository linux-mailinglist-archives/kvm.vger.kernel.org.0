Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE23E544027
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 01:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235288AbiFHXvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 19:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235215AbiFHXvE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 19:51:04 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1498E170657
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 16:52:54 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id y1-20020a17090a390100b001e66bb0fcefso13189385pjb.0
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 16:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=7LTxZeQDL+PveA5Flm8SP++va5dkWw0A5QbQb5Z5aLg=;
        b=sgx4UGl8T6yyy/hQhoqkFGwZRFbwSuDe1Fb3+5VAmE72F3Gs/PfjVQ8iERBcbuY8wO
         ToI/pDLJ3+x8oC+KGBhnpVY88Wj4xuEKMI41akGhfxu7YBxDyzXrYU3m/JTfixHGbqTV
         S8Y2LPZRMHgI17+ET+RxPS7a1Ki01hYNuBXd2PBa5HZsVPB0IlhJJ+ZU/FzwnB/kNTcc
         EnGHXThAnOV1fxyrzwGoNEMixrlozPsnh0IDU6C2DprTkYJma4557nYLjAHLBxZOrMkY
         TaczqR50g0uiTq+g+lVaYmIbvefJH4BcMhNK7zNJRKJSPNBh/wxrwNm9Y4XvO+WejuzD
         zEcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=7LTxZeQDL+PveA5Flm8SP++va5dkWw0A5QbQb5Z5aLg=;
        b=Dju/BbcqV8DsCkgNUmyZ1HGGX+nwAxE4heznZkmrWSX7ToRDBdHXn3yl8dkoIO3EET
         LwwkoqwF9v/lAzi95cuCuH2VxySsoGkGZjp/DRPOw9UBtx2NLNURQgILlHeZLJVGNMNI
         fX/PgjkdRp1iVX9QEc47lcu80KJcAYCD1YTnLiYBURyfQIdKeuLbT2gqn7It5wnEX3ve
         iwwYXLR933hlWmpbz4SvsjjREJDwxBr7zsb9w8Btdn8aSanDez+z4OTVX6LFCVRqoE77
         6N8ufBaANblnpzRMatYdKekkBBNptYYD2q3dQbGnAUO1LM+h/C4eFlva7hQj1aeCM3hA
         QqUg==
X-Gm-Message-State: AOAM530khfEfcN2jm4E9aXx1/cfhTTjwqk9aaSZf98JhCFwTvoS4mON0
        SCuOAWGaaxYefzAuoEN0il16U4jjbGo=
X-Google-Smtp-Source: ABdhPJzsfm6JupJq9uvR3g68ekQSya0a4tio7PthHgyUyeHsafhd5/ckMJWpDs7zyJjo9ZElIKo9V/3HBU0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1c02:b0:1e3:4b6d:4269 with SMTP id
 oc2-20020a17090b1c0200b001e34b6d4269mr469077pjb.57.1654732373607; Wed, 08 Jun
 2022 16:52:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  8 Jun 2022 23:52:35 +0000
In-Reply-To: <20220608235238.3881916-1-seanjc@google.com>
Message-Id: <20220608235238.3881916-8-seanjc@google.com>
Mime-Version: 1.0
References: <20220608235238.3881916-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [kvm-unit-tests PATCH 07/10] nVMX: Check result of VMXON in INIT/SIPI tests
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

Assert that VMXON succeeds in the INIT/SIPI tests, _vmx_on() doesn't
check the result, i.e. doesn't guarantee success.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 1b277cfb..4c963b96 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9695,7 +9695,7 @@ static void init_signal_test_thread(void *data)
 	u64 *ap_vmxon_region = alloc_page();
 	enable_vmx();
 	init_vmx(ap_vmxon_region);
-	_vmx_on(ap_vmxon_region);
+	TEST_ASSERT(!_vmx_on(ap_vmxon_region));
 
 	/* Signal CPU have entered VMX operation */
 	vmx_set_test_stage(1);
@@ -9743,7 +9743,7 @@ static void init_signal_test_thread(void *data)
 	while (vmx_get_test_stage() != 8)
 		;
 	/* Enter VMX operation (i.e. exec VMXON) */
-	_vmx_on(ap_vmxon_region);
+	TEST_ASSERT(!_vmx_on(ap_vmxon_region));
 	/* Signal to BSP we are in VMX operation */
 	vmx_set_test_stage(9);
 
@@ -9920,7 +9920,7 @@ static void sipi_test_ap_thread(void *data)
 	ap_vmxon_region = alloc_page();
 	enable_vmx();
 	init_vmx(ap_vmxon_region);
-	_vmx_on(ap_vmxon_region);
+	TEST_ASSERT(!_vmx_on(ap_vmxon_region));
 	init_vmcs(&ap_vmcs);
 	make_vmcs_current(ap_vmcs);
 
-- 
2.36.1.255.ge46751e96f-goog

