Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BEA493E8A
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 17:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356228AbiASQqA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 11:46:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356215AbiASQp5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 11:45:57 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F64AC061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 08:45:57 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id q4-20020aa78424000000b004c022bd294eso1895978pfn.1
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 08:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=K0R65dke/1V33m8zh6lNnvCgpLK4Zxzc+KjXhgOQ+hk=;
        b=hsITvGKcZ+JY/AMdqQBtngJ9eF1HHubdtKQ7dqWkePq2L29wmZdW6n6Mg0yuym89Aj
         DihmFga9kDHpBAYHCoACdQ23+fEQYhohtoc7eobg0FB/k+6t0PNyAa+/Qo82LR6CxMl+
         YsihdX+HgWSeEpqWaC8k/dFKCO8lVgYfdlBN3SJxOStd3twN9c/OHPKcjA1MS+OFcwgt
         WM1PMz51fAzzb0rDJCIt/sVKpDnbmLJBwaDfi6gTpxLZrWCowySrUE8qPzx/1c8XU2K4
         4ugi5nIZRxSul8uFMi66EzQQ0vtf2BvsdWU66kP6xkI1wpp2312kt4VSu19ppBwg14Jx
         Mdsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=K0R65dke/1V33m8zh6lNnvCgpLK4Zxzc+KjXhgOQ+hk=;
        b=N/4EXbLtDqKorLEvvaGqGeZwf8me2pc5vdgiCft9HJTz8Ikc9Wjpa30QcdWrLau3WD
         BCBOoWw4n88k8t2DbjsR/7yi9xPCXLxiqrhqSOalbnp6T29RIco40qKVkbC80oMSVx6C
         PG0X3EgxJd2JTjZ+qP7bv1DYT1fl7Jve+BiiQWnxVC/oI4SvGhXkYEz5lolP1jjxvWcw
         SAe3LIq1VWNAnJgL7AVgVD7hcWuofnuNTlPhal9TSOURk7/Zf2klR6sh6SIJfWHPfl64
         CUQrBjdmRAQmeSUlHUuyj9JRy216/NEEyPATESNHHcVzsUro19RWi+jBjQ59PQx97yLb
         //Qg==
X-Gm-Message-State: AOAM531sMlrzog1EV6vbovpbDQkiwazS2lNHmshWsRO1FApDiGXADhSP
        zw8IrssgU1xfzXs1uNAggNaWjrsl/JsQxlWcngEkopdvEmHHK/SvEBQAblEE/hZsRFUKZ128d1u
        /tNxGbCgl8065cMG842BOApsImwjSh8uw2Aey7agJ9E5Z2ER95nW3+sghmthE/+9QZcFn
X-Google-Smtp-Source: ABdhPJwObjaFXWN6TVVXBoXToHvWOKebT/FgX+ZgshcZUC/R5dvNOF7jbpkhuT/R17uON0mCT767G4PNKSALe15Q
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a05:6a00:1681:b0:4a8:2462:ba0a with
 SMTP id k1-20020a056a00168100b004a82462ba0amr31628322pfc.75.1642610756583;
 Wed, 19 Jan 2022 08:45:56 -0800 (PST)
Date:   Wed, 19 Jan 2022 16:45:40 +0000
In-Reply-To: <20220119164541.3905055-1-aaronlewis@google.com>
Message-Id: <20220119164541.3905055-3-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220119164541.3905055-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH v3 2/3] x86: Add support for running a nested
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
 x86/vmx.c | 24 ++++++++++++++++++++++--
 x86/vmx.h |  2 ++
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index f4fbb94..51eed8c 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1884,15 +1884,35 @@ void test_add_teardown(test_teardown_func func, void *data)
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
+}
+
+void test_set_guest_finished(void)
+{
+	guest_finished = 1;
 }
 
 static void check_for_guest_termination(union exit_reason exit_reason)
diff --git a/x86/vmx.h b/x86/vmx.h
index 4423986..11cb665 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -1055,7 +1055,9 @@ void hypercall(u32 hypercall_no);
 typedef void (*test_guest_func)(void);
 typedef void (*test_teardown_func)(void *data);
 void test_set_guest(test_guest_func func);
+void test_override_guest(test_guest_func func);
 void test_add_teardown(test_teardown_func func, void *data);
 void test_skip(const char *msg);
+void test_set_guest_finished(void);
 
 #endif
-- 
2.34.1.703.g22d0c6ccf7-goog

