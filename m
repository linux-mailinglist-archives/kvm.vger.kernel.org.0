Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6AE49EDDC
	for <lists+kvm@lfdr.de>; Thu, 27 Jan 2022 22:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239981AbiA0V4E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 16:56:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239231AbiA0V4D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 16:56:03 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04B10C06173B
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 13:56:03 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id x11-20020a170902a38b00b0014b620deff1so2114138pla.9
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 13:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HuuDW+YAjO2tjakrYNYOG8QxGe892Ix2mEDbHrYIoR4=;
        b=OOD6QdqGUhSAGtNIt3BTlWewnS2aqEnlaDBy9jfmBntWUby7EqRNEMyd36qcwt5vcb
         /As7hxMmWxaLjmxwTCfJGgA9AKlIdq6Unydrdw1XwbxTZbhsl7dYWs519zcpBaaLUHHd
         csGXOlwAS9qdGURxGwxhZ3v/0Gr7EDHMNkdQAsi31W4x7Ly17H84TgP5sEUr0HJd4wjG
         Rfs8xFXd8IUUfbsaq8Eql2ckYyuwdA/9ZI+Ni2iSP9sN+iJxQqkXBjeBfCIaQJywl2IJ
         LtKodoeddRxRXCShKA/PR6GbCq0eSgREhCkBsw0/gcnJK7EXmqdBJHpWSpvXp4Sgpt1v
         52ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HuuDW+YAjO2tjakrYNYOG8QxGe892Ix2mEDbHrYIoR4=;
        b=pdLRUfHcwMNSx7woIR7r4RVnl/ZiSl9+uchii2ik9KZieJO3lk2USDcv8uMyP+dJk2
         wqmEF7K8AzwR3XvUApSrzLCl+GToMW+1vBvHLtjTbE1m9SutTmYDyMMTH7rcnS0v3Dia
         ZjUmBzGwH5ZWNWDG99FxpRJj37QtihnteamvDYH8of/NRqSayKNxSZmH9Ay8eAlY4C1g
         sohzqInkKCdNJaMwD/n6ZP59rhZ9bK13cwXN3NnpYXNPPHF5aXqbn9HnR+6NQ3tZRUjY
         iSssq7XFTgoq4RqzI4ZBGsHyw1yAtkPB1IVDW2jKsApa7dbVAshnKQBqUe7JpztCGjai
         NIqw==
X-Gm-Message-State: AOAM533A4vGoVk+erlqs5Aoul8ka4rnvF4LYSCVoHIrvpwUinWQa44gp
        ucAsC513Lv2HyJ5gBb7l5WcmnxmQadUx47b5OBQ5bUEujwO9OFHIlkcAwDv6MKK0OrFuQoYBnlV
        GLZDk/biNwxHT37IW1OBc273YrTfOGt7jazkuK4kME5QUrFvvRsSP5AtgDUbyxG0=
X-Google-Smtp-Source: ABdhPJwA4cO0EWj3YkJ78bdDVbdyQWKGtvRNSVqxnrf4oGcLE9Wvpig+SJ5H1OIdeQc59YXkYPM5EfIjsEN2Zg==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a05:6a00:8d2:: with SMTP id
 s18mr4576964pfu.5.1643320562379; Thu, 27 Jan 2022 13:56:02 -0800 (PST)
Date:   Thu, 27 Jan 2022 13:55:47 -0800
In-Reply-To: <20220127215548.2016946-1-jmattson@google.com>
Message-Id: <20220127215548.2016946-2-jmattson@google.com>
Mime-Version: 1.0
References: <20220127215548.2016946-1-jmattson@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [kvm-unit-tests PATCH 2/3] x86: tsc_adjust: Use report_skip when
 skipping test
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Opportunistically reorder the code to reduce indentation.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/tsc_adjust.c | 52 ++++++++++++++++++++++++------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/x86/tsc_adjust.c b/x86/tsc_adjust.c
index b0d79c499edb..c98c1eacb8dc 100644
--- a/x86/tsc_adjust.c
+++ b/x86/tsc_adjust.c
@@ -5,32 +5,32 @@ int main(void)
 {
 	u64 t1, t2, t3, t4, t5;
 
-	if (this_cpu_has(X86_FEATURE_TSC_ADJUST)) { // MSR_IA32_TSC_ADJUST Feature is enabled?
-		report(rdmsr(MSR_IA32_TSC_ADJUST) == 0x0,
-		       "MSR_IA32_TSC_ADJUST msr initialization");
-		t3 = 100000000000ull;
-		t1 = rdtsc();
-		wrmsr(MSR_IA32_TSC_ADJUST, t3);
-		t2 = rdtsc();
-		report(rdmsr(MSR_IA32_TSC_ADJUST) == t3,
-		       "MSR_IA32_TSC_ADJUST msr read / write");
-		report((t2 - t1) >= t3,
-		       "TSC adjustment for MSR_IA32_TSC_ADJUST value");
-		t3 = 0x0;
-		wrmsr(MSR_IA32_TSC_ADJUST, t3);
-		report(rdmsr(MSR_IA32_TSC_ADJUST) == t3,
-		       "MSR_IA32_TSC_ADJUST msr read / write");
-		t4 = 100000000000ull;
-		t1 = rdtsc();
-		wrtsc(t4);
-		t2 = rdtsc();
-		t5 = rdmsr(MSR_IA32_TSC_ADJUST);
-		report(t1 <= t4 - t5,
-		       "Internal TSC advances across write to IA32_TSC");
-		report(t2 >= t4, "IA32_TSC advances after write to IA32_TSC");
-	}
-	else {
-		report_pass("MSR_IA32_TSC_ADJUST feature not enabled");
+	if (!this_cpu_has(X86_FEATURE_TSC_ADJUST)) {
+		report_skip("MSR_IA32_TSC_ADJUST feature not enabled");
+		return report_summary();
 	}
+
+	report(rdmsr(MSR_IA32_TSC_ADJUST) == 0x0,
+	       "MSR_IA32_TSC_ADJUST msr initialization");
+	t3 = 100000000000ull;
+	t1 = rdtsc();
+	wrmsr(MSR_IA32_TSC_ADJUST, t3);
+	t2 = rdtsc();
+	report(rdmsr(MSR_IA32_TSC_ADJUST) == t3,
+	       "MSR_IA32_TSC_ADJUST msr read / write");
+	report((t2 - t1) >= t3,
+	       "TSC adjustment for MSR_IA32_TSC_ADJUST value");
+	t3 = 0x0;
+	wrmsr(MSR_IA32_TSC_ADJUST, t3);
+	report(rdmsr(MSR_IA32_TSC_ADJUST) == t3,
+	       "MSR_IA32_TSC_ADJUST msr read / write");
+	t4 = 100000000000ull;
+	t1 = rdtsc();
+	wrtsc(t4);
+	t2 = rdtsc();
+	t5 = rdmsr(MSR_IA32_TSC_ADJUST);
+	report(t1 <= t4 - t5, "Internal TSC advances across write to IA32_TSC");
+	report(t2 >= t4, "IA32_TSC advances after write to IA32_TSC");
+
 	return report_summary();
 }
-- 
2.35.0.rc2.247.g8bbb082509-goog

