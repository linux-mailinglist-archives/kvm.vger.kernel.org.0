Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171927903BF
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 00:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351056AbjIAWuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 18:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351048AbjIAWuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 18:50:17 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050F5E40
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 15:50:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7b9eb73dcdso2172244276.0
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 15:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693608612; x=1694213412; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=f+WbxhXD/grNbEd0NPYgopCkg6yQMV8Lb6vhbCCiTAs=;
        b=Ar4ddVtsLcfBsTDD5R0xmgP8wRZ6Q7eeEqArdT852Z04i/+uqMuwyl32SDsnGvEtqo
         xsdsgIUHapTpaxcq9Dd2tRmkSVMr19NxI/sgACWkpSGCKr3Mqzrdi3cXzJ6F90d6sW+B
         6CCxbL1KYxGnkdoC7L8BqRJS8+JjwVCmJ+EZ0HHDPZL1FsyKu0gyUfdUcZr/gTPTBCsS
         kyXRUQeDAJuP9ynszFzNNlPKaFeD+n+0QJqzBYlxUjhF+CHoZidIdLw/wUYaIfGkKKdR
         JnjX0OMYEKHCAd9k6tT2ZJcwzebjPl4yueCkVALCGgDbmnrpomaXAvv90Q7/aWb8anue
         ebCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693608612; x=1694213412;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+WbxhXD/grNbEd0NPYgopCkg6yQMV8Lb6vhbCCiTAs=;
        b=HWR+pTDJMLgvfsdZm3pFJK7H8KIgpJRie2tcV5JHvExuiA7+fs0oNmkaqls7Nl9T5c
         2KDbEAV9FmCgv4znfwGVq5ndN2OK8gnAq0RcrrFsBQznlJ7dBgeOCf09aYkDegXjednp
         WWVuYaby4xR8QWYyeQ2peeSOT1UZSTgRbJR3gNhYhjJccOB421O3L2uofIpcHp6VlNs0
         8n60+Cwcoc9+PppDPAk+8z9hMn6NRh1KYQzYoHh9N7u4P7g40Funti0eH2xKSx64T7xF
         NwAhvnY1DZDrdmTJgKImusod/K2IS5LUYy7N7EdbG+OIZ8YUQPBHjrW7oY1GgTIuUnwh
         sl7w==
X-Gm-Message-State: AOJu0YwU4N7gAQGtufucQPkzbtpaUjLnDOLlBMd0/+L8Sm509Jv8NkrR
        El7sCEuglysmq8iUxwyRZwqBj+XZHJY=
X-Google-Smtp-Source: AGHT+IHo76y81mIeIsmyhNSnwqhzGqbMtyRgBpVjm9/BjItx8zhxyPpZErqo3i4WZLpyjBwL20mvOxJXRmM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d80a:0:b0:d08:ea77:52d4 with SMTP id
 p10-20020a25d80a000000b00d08ea7752d4mr99644ybg.12.1693608611622; Fri, 01 Sep
 2023 15:50:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  1 Sep 2023 15:49:58 -0700
In-Reply-To: <20230901225004.3604702-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230901225004.3604702-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230901225004.3604702-3-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 2/7] nVMX: Assert CR4.PAE is set when testing
 64-bit host
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Assert that PAE is set in the original CR4 value when the host is setup to
VM-Exit to 64-bit mode in test_host_addr_size().  If CR4.PAE isn't set
then something is wildly broken and all bets are off as VM-Enter can't
possibly succeed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 226f526d..9ec0f512 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7620,6 +7620,8 @@ static void test_host_addr_size(void)
 	u64 tmp;
 
 	if (vmcs_read(EXI_CONTROLS) & EXI_HOST_64) {
+		assert(cr4_saved & X86_CR4_PAE);
+
 		vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
 		report_prefix_pushf("\"IA-32e mode guest\" enabled");
 		test_vmx_vmlaunch(0);
@@ -7640,14 +7642,10 @@ static void test_host_addr_size(void)
 			report_prefix_pop();
 		}
 
-		if (cr4_saved & X86_CR4_PAE) {
-			vmcs_write(HOST_CR4, cr4_saved  & ~X86_CR4_PAE);
-			report_prefix_pushf("\"CR4.PAE\" unset");
-			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-		} else {
-			report_prefix_pushf("\"CR4.PAE\" set");
-			test_vmx_vmlaunch(0);
-		}
+		vmcs_write(HOST_CR4, cr4_saved  & ~X86_CR4_PAE);
+		report_prefix_pushf("\"CR4.PAE\" unset");
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+		vmcs_write(HOST_CR4, cr4_saved);
 		report_prefix_pop();
 
 		vmcs_write(HOST_RIP, NONCANONICAL);
-- 
2.42.0.283.g2d96d420d3-goog

