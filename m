Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F1F49BD32
	for <lists+kvm@lfdr.de>; Tue, 25 Jan 2022 21:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiAYUcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jan 2022 15:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232103AbiAYUcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jan 2022 15:32:02 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FF37C061747
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:32:02 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id q21-20020a170902edd500b0014ae79cc6d5so5639020plk.18
        for <kvm@vger.kernel.org>; Tue, 25 Jan 2022 12:32:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8aDRqqZElF9pdZ78J9uxS24EVWOgt3ahYwBdFdRKzIk=;
        b=DczfssVyTXPsVHFs0USg59RHf83Wd6I9QtiwHpug4Oz4OcYsxbxofyvpick7EgD4Z0
         IMJxSXdscz9CMQFIGb24Dol/B7cgIeeWZOy71YPQhaTjHBB40/Ss9Dm4ma/TBfYnDq84
         i/8DD5STksX/QlyXp+vnrn+y3AEYI7z7RV+Qe9w2eb8i9h+/eNuZb0Qr5m1GrzVKQd+B
         R8gGa0R858ezoIw+Dljzi8+kL6Yq1HBKPcRUPr+8XAbKjH1Wg89d3m6LXsaCt75M3PyM
         Qe6+jCZw+s1hFr6zfGlk1h+O9cthiCSmiONIu99k4/ys/bvskQskSo9OJIql9aYW9B66
         W7Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8aDRqqZElF9pdZ78J9uxS24EVWOgt3ahYwBdFdRKzIk=;
        b=UJcMLwMwSUo0hu5/ybXLC/lfX0VoRxnWytR94spGAtQoW4M3bytF0dhCjuIqkhWpGj
         ZwVIorbbwM+0QflTCS4wb6Db8O10usDwS3PX4dhSQP/IcQXdhIrbiwj7lTpw6XAb69Jj
         pjidsXn/q68zqWMkctfNgW4naZnKGWnTjTadqAqHwuscxefH/yNgST914M6jmR0VmVUq
         u6QOvNVK9YQhgsphuBzGqEsCtZOUkrTzaE+l+IQ8yP6lWauuvdgDf/DYFQGYKg42+V5d
         cAgRt8w6i8gauOaCCCQeRGH65Whm0tkRSW+AL5Pa1r/Su+MHoaM/ewKpmmEv3X3oW0Ke
         D2PQ==
X-Gm-Message-State: AOAM5309yoxgg2G2xLwkdFdjea1imyabBOh3pJTXvSfouPozLBopYikO
        pLQodThk+kURGt6iOHmHm7UsdS1YDP4U2P5q8zrqC8hCOyFhbVMJG817TLtbs+TgE0dE9RTC93Z
        2jSMd9PduAiaO6pw2IpE2v3Cdcyrx8YuL3J3vOGSa6E+YrCDmOZQVAgQWYc5l3at7EFDd
X-Google-Smtp-Source: ABdhPJxSo0Sl4Z/DohzSNw48b1g1bYBXSTQ5IgIRvVO7/uiuJQbZcE6fdyzczXX9yPRY9mBH7wiUZOlQivrKzwNv
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:903:11cf:b0:149:a17a:361b with SMTP
 id q15-20020a17090311cf00b00149a17a361bmr20723422plh.146.1643142721504; Tue,
 25 Jan 2022 12:32:01 -0800 (PST)
Date:   Tue, 25 Jan 2022 20:31:26 +0000
In-Reply-To: <20220125203127.1161838-1-aaronlewis@google.com>
Message-Id: <20220125203127.1161838-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220125203127.1161838-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [kvm-unit-tests PATCH v5 3/4] x86: Add a helper to allow tests to
 signal completion without a vmcall()
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Putting a vmcall() at the end of a nested test isn't always convenient
to do, and isn't necessary.  Add a helper to allow the nested test
to make it possible to skip this requirement.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 x86/vmx.c | 5 +++++
 x86/vmx.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/x86/vmx.c b/x86/vmx.c
index b2d8393..51eed8c 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1910,6 +1910,11 @@ void test_override_guest(test_guest_func func)
 	init_vmcs_guest();
 }
 
+void test_set_guest_finished(void)
+{
+	guest_finished = 1;
+}
+
 static void check_for_guest_termination(union exit_reason exit_reason)
 {
 	if (is_hypercall(exit_reason)) {
diff --git a/x86/vmx.h b/x86/vmx.h
index dabd5da..11cb665 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -1058,5 +1058,6 @@ void test_set_guest(test_guest_func func);
 void test_override_guest(test_guest_func func);
 void test_add_teardown(test_teardown_func func, void *data);
 void test_skip(const char *msg);
+void test_set_guest_finished(void);
 
 #endif
-- 
2.35.0.rc0.227.g00780c9af4-goog

