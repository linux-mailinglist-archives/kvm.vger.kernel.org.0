Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376BC657028
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 23:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiL0WFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 17:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbiL0WFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 17:05:22 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5044DD2D2
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 14:05:22 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id z10-20020a170902ccca00b001898329db72so10913853ple.21
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 14:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SIwEUSavBoITwwYI+yoZ0NJrgRxIvxAncOUcb0u8hq4=;
        b=kkQQTJDqXneY+ptax9c0yTFjItDqWeoB+rrGanKGHmw6khHKzYX88IMp0pfpq8oIgq
         ZeFxWk4EN1+ZhIIVZYytVavsAMv1oWM7e8sYiKUr7RjTeibIEOJObVshWeV+aGW+AwdK
         UjUGWLDdDoKc4NYqI1EwY3mYXMOsQ2Se8PDxR8sAWzz1EBmTfK0H15DUvm1VGJ0ml15/
         n0WjMxwusncrgIEL10Qpztt7yFwRpuy7sraza5wRWE4815J0/rxgD4csWJACA4pb9zhW
         NteagjMWJbkQe+QLnRUmyfZJPsdODwuOEkbzmPoYHl27TQInINnyA91iO0C6cw7aKb+n
         hEWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SIwEUSavBoITwwYI+yoZ0NJrgRxIvxAncOUcb0u8hq4=;
        b=mjG3DM1raL00mDuuxEBUcNT2uKp5YMVjmwBj7uxb+WztxNymhlPqX0PhNoCd04sRgU
         VUAN1Njz5B0G8hFVizNy73JmVqCyGXqSYlytQLn7MC3tdber8RfHoRzucHeqcI35t0EQ
         GDB05Ed8d/GcmM/BAroqsqGDY8AuM8FSmRgF7cgTzTK+/y4J2duYkJffpHP1Y2ON3yGy
         iWPrguhyjXsPZ4LJyA7NyUrwQXCiScR+9iNBTXIEiG1MIGRIStOq5VZzU1Ms8DBuDyQu
         xW1HFjVEATNs6yszOXR8UP4wusiy3fmrMhVKHr3PZbtVJkeaB2rY5wNqLopbzNbz4Qmb
         9RoQ==
X-Gm-Message-State: AFqh2krC0yQ5AORnR2mNE5FkchAcb2pksTJ2w4X4E3cqQoz4rhgkkZkh
        lpiXWAzT9Nmg9gb2WDrtaJQkXrXks3z416c4kvKKrvH6EQgB4BmUuSJXucsm3x8D52OtBCdwa9+
        iduXO8yowpVBKBU7Y4q42hMPxeP55kJFb2ZcVtJO6A2EVPzguVYjhs5X5CbYvunMwvZ0R
X-Google-Smtp-Source: AMrXdXupMc9zjkwjQKIAGYNlFRG/xJmcZVkrgJ4tqqIhHokDxZSowWVh7mk4lY1ibVlxGPXQPTrDGmRf/a823uqx
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:902:6908:b0:190:f5e9:dc03 with SMTP
 id j8-20020a170902690800b00190f5e9dc03mr1045184plk.134.1672178721544; Tue, 27
 Dec 2022 14:05:21 -0800 (PST)
Date:   Tue, 27 Dec 2022 22:05:18 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221227220518.965948-1-aaronlewis@google.com>
Subject: [PATCH] KVM: selftests: Assert that XSAVE supports XTILE in amx_test
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The check in amx_test that ensures that XSAVE supports XTILE, doesn't
actually check anything.  It simply returns a bool which the test does
nothing with.

Additionally, the check ensures that at least one of the XTILE bits are
set, XTILECFG or XTILEDATA, when it really should be checking that both
are set.

Change both behaviors to:
 1) Asserting if the check fails.
 2) Fail if both XTILECFG and XTILEDATA aren't set.

Fixes: 5dc19f1c7dd3 ("KVM: selftests: Convert AMX test to use X86_PROPRETY_XXX")
Fixes: bf70636d9443 ("selftest: kvm: Add amx selftest")
Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 tools/testing/selftests/kvm/x86_64/amx_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index bd72c6eb3b670..db1b38ca7c840 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -119,9 +119,9 @@ static inline void check_cpuid_xsave(void)
 	GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
 }
 
-static bool check_xsave_supports_xtile(void)
+static inline void check_xsave_supports_xtile(void)
 {
-	return __xgetbv(0) & XFEATURE_MASK_XTILE;
+	GUEST_ASSERT((__xgetbv(0) & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE);
 }
 
 static void check_xtile_info(void)
-- 
2.39.0.314.g84b9a713c41-goog

