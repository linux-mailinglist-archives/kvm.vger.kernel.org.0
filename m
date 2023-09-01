Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76A297903C4
	for <lists+kvm@lfdr.de>; Sat,  2 Sep 2023 00:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351100AbjIAWuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Sep 2023 18:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351090AbjIAWug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Sep 2023 18:50:36 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB83CDA
        for <kvm@vger.kernel.org>; Fri,  1 Sep 2023 15:50:22 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-68a4075f42fso2967776b3a.3
        for <kvm@vger.kernel.org>; Fri, 01 Sep 2023 15:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693608622; x=1694213422; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=9dNopdbv9hrhS+DPYeYDnM0MQksjT6J23li5h6GE4Hw=;
        b=IbxYP4ollvOf1UmgOwxyCh+l4WVejlSk9TM+/buVmB0Tc1lGrNhjI96LtnOWM3JPwu
         4A3Y1raB+g5ATEV7VHZr2Ej2NBZ3Ruza3PWc+dIKIwkcnX1h/BfV1jxpUHfd7q5kPV09
         xwbkAGOkmfd61wb8Lyv4E9tf1ztTvLQtp/5eWxLEhuyd9CyDzwQcclE9KjOfo0cmXebc
         aXqQOm4K+7z574rvEGQl9vuv4n6gaHb8s/GHv+iVcYXLcHNPdMlftqvNztnFaN2yStr+
         l+iUVgxZVJkAWBzP0AKnBy6a+Km7y0hA/8yzPBoj4j3Mz8+SMut69hSdIioxRmyv6UMO
         oXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693608622; x=1694213422;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9dNopdbv9hrhS+DPYeYDnM0MQksjT6J23li5h6GE4Hw=;
        b=GhdE7lI1jZF7400/5cg7Un1JuPThh+XRdnxXJp1mjKd4Bk1IiHtL4BBpPbRiRBIex4
         NPZgdLatucuVsbFhTzZ1rFgpqlylGFvkNCyU6/ccZ9MAxa9P3oNjJukwtFZgLKP7g7MA
         5v9+gvLY1B7Tx5trnF3/55WIOD0ZvTVCJm7Q/nyrwdhjOclT3FJ4YSmJA0ZAF1dME9o/
         jMpt81XKWP2nd7fu551rTkrhXu408k/7MJ8M8Mo3nKHFyMA5aptrzORUfK4vqWM3ctbp
         rIqxygwWeMLeVsD0vP8ysvMldeYhpLRkAKUflr1eK+aMIK/joRpTcmp2yNVvZD2XMbpH
         rU6A==
X-Gm-Message-State: AOJu0YzjfO9dtE0GNb3mBjJ+lOMW8l1q2R8gVcc1ITHoe4ieeqH7wvMT
        hQzWtkX1JhCqyvgQiIX+Bo3Hr/20O/U=
X-Google-Smtp-Source: AGHT+IGDqZ3hLfXSEBCkfsirH0H/+qGGWMJVLLim9R8jF7rlWtGnxg5k/7t9ecHnhied6y7Y+P+Kl2UqtUg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a8f:b0:68b:c408:a2a4 with SMTP id
 e15-20020a056a001a8f00b0068bc408a2a4mr1492733pfv.6.1693608622257; Fri, 01 Sep
 2023 15:50:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  1 Sep 2023 15:50:03 -0700
In-Reply-To: <20230901225004.3604702-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230901225004.3604702-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230901225004.3604702-8-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 7/7] nVMX: Fix the noncanonical HOST_RIP testcase
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

Do a bare VMLAUNCH for the noncanonical HOST_RIP testcase to actually test
the noncanonical RIP instead of the sane value written by vmlaunch().  Put
up a variety of warnings around test_vmx_vmlaunch_must_fail() to
discourage improper usage.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/vmx_tests.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 9d0f2050..560d430e 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -3284,6 +3284,32 @@ static void invvpid_test(void)
 	invvpid_test_not_in_vmx_operation();
 }
 
+static void test_assert_vmlaunch_inst_error(u32 expected_error)
+{
+	u32 vmx_inst_err = vmcs_read(VMX_INST_ERROR);
+
+	report(vmx_inst_err == expected_error,
+	       "VMX inst error is %d (actual %d)", expected_error, vmx_inst_err);
+}
+
+/*
+ * This version is wildly unsafe and should _only_ be used to test VM-Fail
+ * scenarios involving HOST_RIP.
+ */
+static void test_vmx_vmlaunch_must_fail(u32 expected_error)
+{
+	/* Read the function name. */
+	TEST_ASSERT(expected_error);
+
+	/*
+	 * Don't bother with any prep work, if VMLAUNCH passes the VM-Fail
+	 * consistency checks and generates a VM-Exit, then the test is doomed
+	 * no matter what as it will jump to a garbage RIP.
+	 */
+	__asm__ __volatile__ ("vmlaunch");
+	test_assert_vmlaunch_inst_error(expected_error);
+}
+
 /*
  * Test for early VMLAUNCH failure. Returns true if VMLAUNCH makes it
  * at least as far as the guest-state checks. Returns false if the
@@ -3321,16 +3347,11 @@ success:
 static void test_vmx_vmlaunch(u32 xerror)
 {
 	bool success = vmlaunch();
-	u32 vmx_inst_err;
 
 	report(success == !xerror, "vmlaunch %s",
 	       !xerror ? "succeeds" : "fails");
-	if (!success && xerror) {
-		vmx_inst_err = vmcs_read(VMX_INST_ERROR);
-		report(vmx_inst_err == xerror,
-		       "VMX inst error is %d (actual %d)", xerror,
-		       vmx_inst_err);
-	}
+	if (!success && xerror)
+		test_assert_vmlaunch_inst_error(xerror);
 }
 
 /*
@@ -7640,7 +7661,7 @@ static void test_host_addr_size(void)
 
 	vmcs_write(HOST_RIP, NONCANONICAL);
 	report_prefix_pushf("HOST_RIP %llx", NONCANONICAL);
-	test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
+	test_vmx_vmlaunch_must_fail(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 	report_prefix_pop();
 
 	vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
-- 
2.42.0.283.g2d96d420d3-goog

