Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81657903C2
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 00:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351094AbjIAWua (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 18:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238767AbjIAWu0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 18:50:26 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71C9E56
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 15:50:18 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-591138c0978so28502057b3.1
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 15:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693608618; x=1694213418; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=o4uMkW6+u2fqOnORIlbAm4eByiwjzu00DIRnYZ+D4Ek=;
        b=rH6zwK7E+ajlARZ9usyaFLo80FSVg25GTylh2or5jtTvlUPDLMjuDZ5/9IN9KQZJCV
         kqBDkv0BOUAoo74TCJjGSrAWMSWgv6VGecifvN3xox39lh2+ZcBW4iSOhGLkZEzE0AoP
         +xZxO+tecTP5wKxHaP6Uy9or0kNhhmhJvvXND4HoSFHERRzp7bZxuBSYryDYApd0xI44
         YDy28zcX3aA9lkyWjmWN0uQeJ54r1CguwQpDDgODmeNfh8mrOO08LM8QY1flmoyXWSJP
         gBK9UAdzGO0rJg6hzpidLEkbkmeLEe3b/Tgx7QBcy98pQD3gJ3TCCmkfLqK3kF1qkghJ
         MEkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693608618; x=1694213418;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o4uMkW6+u2fqOnORIlbAm4eByiwjzu00DIRnYZ+D4Ek=;
        b=cOZJ+ZaeGOyqx6vFsuIeOk7Giq/dCq4gJbyG1BnRYlM0KSaAXihD1dOTzsy1TWLv/+
         N5bFdxEFd+Ufy1t4NWtASkyNDqjukOAole4NQWajh0wkeYUyOQWO5sSAADbVxWmORMjD
         GirX45Jh6MUKVoSbSdTQYW+VPmrZIW8xMGpAiESugS+6lXgrZWhH7jSGOktZvfaxgrb8
         AwVFfKShP8jivgataJyIjDsg8xVpRz3boS1FjpP/2llWVilj+WfSUUv9DoBhEBWaevvw
         1kuCn3YK+loHq5d/LeWzBIuwI6n8iLDJ5nDOH9vwP734L2MnC+96KDzlQ+yEHukY4Bma
         38wQ==
X-Gm-Message-State: AOJu0Yx9I1onOtPqHlGDhJz38Ko5Xsc32r+Hcr9aEMR5pfzygNJG3hid
        UcoP2oRMWtVmRL4VLQvbp4iNv6gPET8=
X-Google-Smtp-Source: AGHT+IE0z4XE+GZyUgUr4YFsCW8qZIBo/khtB8qpZXKB9+1nw0z7JvhTIGpNhyZPvcL2sqTtI9YcX/wPrHg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad16:0:b0:58f:b749:a50b with SMTP id
 l22-20020a81ad16000000b0058fb749a50bmr101834ywh.4.1693608618089; Fri, 01 Sep
 2023 15:50:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  1 Sep 2023 15:50:01 -0700
In-Reply-To: <20230901225004.3604702-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230901225004.3604702-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230901225004.3604702-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 5/7] nVMX: Shuffle test_host_addr_size() tests
 to "restore" CR4 and RIP
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

Re-order the testcases in test_host_addr_size() to guarantee that the host
CR4 and RIP values are either written or restored before each testcase.
If a test fails unexpectedly, running with a test value from a previous
testcase may cause all subsequent tests to also fail, e.g. if the CR4
PCIDE test fails, all of the RIP tests will fail because of the bad CR4.

This also "fixes" the noncanonical RIP testcase, as running with the bad
CR4 setup by the !PAE testcase would mask a missed noncanonical check.

[sean: Surprise! The bad CR4 is indeed masking a bug.  I'm leaving it for
 now and intentionally creating a failing testcase for a commit or two to
 highlight the importance of cleaning up after testcases, and isolating
 what is actually being tested.]

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 376d0a53..1a340242 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7634,6 +7634,12 @@ static void test_host_addr_size(void)
 		report_prefix_pop();
 	}
 
+	vmcs_write(HOST_CR4, cr4_saved  & ~X86_CR4_PAE);
+	report_prefix_pushf("\"CR4.PAE\" unset");
+	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+	vmcs_write(HOST_CR4, cr4_saved);
+	report_prefix_pop();
+
 	for (i = 32; i <= 63; i = i + 4) {
 		tmp = rip_saved | 1ull << i;
 		vmcs_write(HOST_RIP, tmp);
@@ -7642,12 +7648,6 @@ static void test_host_addr_size(void)
 		report_prefix_pop();
 	}
 
-	vmcs_write(HOST_CR4, cr4_saved  & ~X86_CR4_PAE);
-	report_prefix_pushf("\"CR4.PAE\" unset");
-	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
-	vmcs_write(HOST_CR4, cr4_saved);
-	report_prefix_pop();
-
 	vmcs_write(HOST_RIP, NONCANONICAL);
 	report_prefix_pushf("HOST_RIP %llx", NONCANONICAL);
 	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
@@ -7657,7 +7657,17 @@ static void test_host_addr_size(void)
 	vmcs_write(HOST_RIP, rip_saved);
 	vmcs_write(HOST_CR4, cr4_saved);
 
-	/* Restore host's active RIP and CR4 values. */
+	/*
+	 * Restore host's active CR4 and RIP values by triggering a VM-Exit.
+	 * The original CR4 and RIP values in the VMCS are restored between
+	 * testcases as needed, but don't guarantee a VM-Exit and so the active
+	 * CR4 and RIP may still hold a test value.  Running with the test CR4
+	 * and RIP values at some point is unavoidable, and the active values
+	 * are unlikely to affect VM-Enter, so the above doen't force a VM-Exit
+	 * between testcases.  Note, if VM-Enter is surrounded by CALL+RET then
+	 * the active RIP will already be restored, but that's also not
+	 * guaranteed, and CR4 needs to be restored regardless.
+	 */
 	report_prefix_pushf("restore host state");
 	test_vmx_vmlaunch(0);
 	report_prefix_pop();
-- 
2.42.0.283.g2d96d420d3-goog

