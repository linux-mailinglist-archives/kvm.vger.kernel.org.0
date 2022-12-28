Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFC7658668
	for <lists+kvm@lfdr.de>; Wed, 28 Dec 2022 20:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbiL1TYz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Dec 2022 14:24:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiL1TYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Dec 2022 14:24:51 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732CD17439
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 11:24:50 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id v186-20020a6389c3000000b0049b4debf9d9so2526950pgd.13
        for <kvm@vger.kernel.org>; Wed, 28 Dec 2022 11:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mo9WWk49bq3o6GgXHJZvpBlrKizEyknLEVuJxarZm6w=;
        b=cpM7ihQBd4FEp1qLIXzpJmruvJ3gQgEt9GzCCQuDYzGWE0/JQl180tij1IgB+3C1fI
         NI/CRB81Gq7Pn7zvsbktzzDsMrOjqyRGhefHNbr/27eV0KSb4bCymBjgValGjt5659P5
         hnCuNueNq8N5g0T66+w9ELo5UBp8JnSXjCa9c3UVTjbtYAeJzkqJcs5a1fnnFFO1mAp1
         LDzoMxKw2q/igdHUkIIUKWPRY4xdesLfXRisswaP4wC5MvSNJbOf3E1Y+S66a+hQj4lS
         5oYExQ4FmaX+p9xdEUupA5dRNDU9nWqyptcGEq35t6lkLJu41sgez82NakYbR60frdT0
         RgJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Mo9WWk49bq3o6GgXHJZvpBlrKizEyknLEVuJxarZm6w=;
        b=BjIzm1MX4YibfelWhKRm9FAwdqtOW4vhX34s+x70WpA6GQhHM1D4v4Eiz66WeY1o2K
         VC3VdAUJf4kTrhfH63cjxaXuVQupsB0l+nWf7gHX+RYdVZ/e8tzinAT9nDtcWo4DBjl8
         klHjug4zYEnniFHhI1DL2gZkJC+ccKcqlUhS2rWl0rIyNkOu8PPukUxLugw+9gxC+3ih
         YeVWTgZGUrv9368Gv+jd6pbISIpCA1gJhFSAPtwHFj7bw/6x9vI7nGN6USXC1n7EFrum
         ggXKTOkYYxeTi7gMNlSQkCJDW3i1udlfGCiv3yLdUKgSzLsfoCVXre+mx9g7rbhp/cyP
         JTAw==
X-Gm-Message-State: AFqh2kol7Relk2Xwc4wfCP7u7gKgWLyQrYFfboVX7bI7fi2tdwk0N9yC
        GMeDbSmGLaIXdO0n74LqTLd8JBMfLRKJV89f
X-Google-Smtp-Source: AMrXdXtkZ+HcHbVmFeuaUfv5lwMV1eVF0Rl5j7xYKonekBJINuj3BtwPXCLd3BflIhE0ONbuqzWkDl/Nee6iIaDK
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:a17:90b:4d83:b0:220:1f03:129b with SMTP
 id oj3-20020a17090b4d8300b002201f03129bmr106930pjb.0.1672255489536; Wed, 28
 Dec 2022 11:24:49 -0800 (PST)
Date:   Wed, 28 Dec 2022 19:24:35 +0000
In-Reply-To: <20221228192438.2835203-1-vannapurve@google.com>
Mime-Version: 1.0
References: <20221228192438.2835203-1-vannapurve@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221228192438.2835203-2-vannapurve@google.com>
Subject: [V4 PATCH 1/4] KVM: selftests: x86: use this_cpu_* helpers
From:   Vishal Annapurve <vannapurve@google.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, shuah@kernel.org, bgardon@google.com,
        seanjc@google.com, oupton@google.com, peterx@redhat.com,
        vkuznets@redhat.com, dmatlack@google.com,
        Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use this_cpu_* helpers to query the cpu vendor.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 22 +++++++++++++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 16 ++------------
 2 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 2a5f47d51388..84edac133d8f 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -555,6 +555,28 @@ static inline uint32_t this_cpu_model(void)
 	return x86_model(this_cpu_fms());
 }
 
+static inline bool this_cpu_vendor_string_is(const char *vendor)
+{
+	const uint32_t *chunk = (const uint32_t *)vendor;
+	uint32_t eax, ebx, ecx, edx;
+
+	cpuid(0, &eax, &ebx, &ecx, &edx);
+	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
+}
+
+static inline bool this_cpu_is_intel(void)
+{
+	return this_cpu_vendor_string_is("GenuineIntel");
+}
+
+/*
+ * Exclude early K5 samples with a vendor string of "AMDisbetter!"
+ */
+static inline bool this_cpu_is_amd(void)
+{
+	return this_cpu_vendor_string_is("AuthenticAMD");
+}
+
 static inline uint32_t __this_cpu_has(uint32_t function, uint32_t index,
 				      uint8_t reg, uint8_t lo, uint8_t hi)
 {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index acfa1d01e7df..a799af572f3f 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1006,26 +1006,14 @@ void kvm_x86_state_cleanup(struct kvm_x86_state *state)
 	free(state);
 }
 
-static bool cpu_vendor_string_is(const char *vendor)
-{
-	const uint32_t *chunk = (const uint32_t *)vendor;
-	uint32_t eax, ebx, ecx, edx;
-
-	cpuid(0, &eax, &ebx, &ecx, &edx);
-	return (ebx == chunk[0] && edx == chunk[1] && ecx == chunk[2]);
-}
-
 bool is_intel_cpu(void)
 {
-	return cpu_vendor_string_is("GenuineIntel");
+	return this_cpu_is_intel();
 }
 
-/*
- * Exclude early K5 samples with a vendor string of "AMDisbetter!"
- */
 bool is_amd_cpu(void)
 {
-	return cpu_vendor_string_is("AuthenticAMD");
+	return this_cpu_is_amd();
 }
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
-- 
2.39.0.314.g84b9a713c41-goog

