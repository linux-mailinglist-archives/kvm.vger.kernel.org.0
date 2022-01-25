Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF79B49BD31
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 21:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiAYUb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 15:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbiAYUbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 15:31:55 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E45C061744
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:31:55 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id p7-20020a1709026b8700b0014a8d8fbf6fso5641174plk.23
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:31:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IraJ+i0C01TB7vYRSJOE9wmwStAuSFPD4ji/HUmRIn4=;
        b=PPEax5fHwKKcg6doh6wJCzEPrJcky9CqzawWtGLeUso61+IHvtMGxzLaybH1mDr/pK
         uEUPtsT/AAItFnz/1UkcPHBAalowREZ9fW9DuhIIM/dLKiAnv7UR4OBLM5riPan8NeYy
         HXZKyj8TEDw7W9TUERMGFcN0dxRC4gsTjNdUUAhteUG5JBGTwLFcA7kBaOLDroBwrxhI
         XHL/znW9IdhPY6BwypV3Z+93tXeCXtwBP4uE+bgDnVFxpmME6KevoMwgNMV3NtXfdd2w
         8aKYO3fd1lwzhWst/yB8iXRqzmsKSPGjIA6YNGD9uE8yoFigfz7670EGK2XxiGi46+Tv
         fWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IraJ+i0C01TB7vYRSJOE9wmwStAuSFPD4ji/HUmRIn4=;
        b=O6ioJddiRfNIZcXit+xS6g5z0NUoFr3D5kplqcI2nB70m3jgAlTJYO9u7ivxZcGNAc
         o5hxKmdBi1lGRYXBrCmf6mlOjzgh8ANILaqaO3NSpdEGPIIh47SM42D46FDvn/IK1vWt
         1/hJAZNg+aoT05gTPmPp6MqEO+vtM3tIxaOQmaduV8dEcfQxfvlz/q/jf5oMfnK5ho0x
         nUMRz4IgfHPk67PXS1oQx2Ld0jEYSb6NcrfCpqfBVpvueI+Uchx8pVXCZEYV326Ie0pK
         luGbJQDsI3clp1zMQgAiLl/KHSrE0xhp52sutB1UGPzS+uP9Imk06XobPVy0ZtgaSsY7
         l4bA==
X-Gm-Message-State: AOAM533EVHuBliX06THoT4xSW/Zt9fMcfyGc9CQwVAaVN0vAJwHF9qeG
        jo2qubACFk7XasEo1K9TPqZ3L4reM+fQDStJa/Ht8Bb8CoJJxKWRHQgp7acFI43TeHeL3bRzeNx
        Y1RQ9uElxdakpDdd+0HPm9pGXopnObaVt4apSroELFvF4KzkDp1dL5OYRWdVmhi+Gcfy3
X-Google-Smtp-Source: ABdhPJxLFmEGMReYxV0O9hgoScELh1L/xPGQT/Gy8dXjHbdaCAofOh1B2Aa3dplpycMRnKU7LwqeIJB8GDupcauX
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:9883:b0:14a:d16e:b480 with SMTP
 id s3-20020a170902988300b0014ad16eb480mr20304988plp.21.1643142714987; Tue, 25
 Jan 2022 12:31:54 -0800 (PST)
Date:   Tue, 25 Jan 2022 20:31:25 +0000
In-Reply-To: <20220125203127.1161838-1-aaronlewis@google.com>
Message-Id: <20220125203127.1161838-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220125203127.1161838-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH v5 2/4] x86: Add support for running a nested
 guest multiple times in one test
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KUT has a limit of only being able to run one nested guest per vmx test.
This is limiting and not necessary.  Add support for allowing a test to
run guest code multiple times.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/vmx.c | 19 +++++++++++++++++--
 x86/vmx.h |  1 +
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index f4fbb94..b2d8393 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1884,15 +1884,30 @@ void test_add_teardown(test_teardown_func func, void *data)
 	step->data = data;
 }
 
+static void __test_set_guest(test_guest_func func)
+{
+	assert(current->v2);
+	v2_guest_main = func;
+}
+
 /*
  * Set the target of the first enter_guest call. Can only be called once per
  * test. Must be called before first enter_guest call.
  */
 void test_set_guest(test_guest_func func)
 {
-	assert(current->v2);
 	TEST_ASSERT_MSG(!v2_guest_main, "Already set guest func.");
-	v2_guest_main = func;
+	__test_set_guest(func);
+}
+
+/*
+ * Set the target of the enter_guest call and reset the RIP so 'func' will
+ * start from the beginning.  This can be called multiple times per test.
+ */
+void test_override_guest(test_guest_func func)
+{
+	__test_set_guest(func);
+	init_vmcs_guest();
 }
 
 static void check_for_guest_termination(union exit_reason exit_reason)
diff --git a/x86/vmx.h b/x86/vmx.h
index 4423986..dabd5da 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -1055,6 +1055,7 @@ void hypercall(u32 hypercall_no);
 typedef void (*test_guest_func)(void);
 typedef void (*test_teardown_func)(void *data);
 void test_set_guest(test_guest_func func);
+void test_override_guest(test_guest_func func);
 void test_add_teardown(test_teardown_func func, void *data);
 void test_skip(const char *msg);
 
-- 
2.35.0.rc0.227.g00780c9af4-goog

