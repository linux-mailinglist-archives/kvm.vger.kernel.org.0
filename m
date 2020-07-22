Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA533228E9A
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 05:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731964AbgGVD0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 23:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731976AbgGVD0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 23:26:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730E5C061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:49 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 8so845914ybc.23
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 20:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VLViaE9BMLq1Koj5GPqKDedU+cZQMogTKZxkSxXxKVg=;
        b=HATSyVqubp4GjAvIuFch2NyJKRjcmVVEUReVtiy1lsa7sNHrpLh59EbgnBvj56BPS8
         VJp8lWtLN+Scb/ytJiwDUURkSJkpIjIX9uiBh/b1hwvptBugPcdECe/SlcGPmS647Una
         kS/3orMuDCW9+AVkzrzkKjQVBS2SQAPHJOGhmBWLMLyaeaCDyyCrmd8FvC4UB1ypSYOx
         hIOHA05AGyKqbpxUo6tx1yjc0Tp6FFxPVa8W40AiVn/BvpeGqte0xB7w7yeMx4zoQngH
         qPFIWxwY4CKEUfhGfA3E5cIrfc1YFJdbVZBj3qLfzvLk0L/lNobedwHMv2Ypju7EmOUm
         hRWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VLViaE9BMLq1Koj5GPqKDedU+cZQMogTKZxkSxXxKVg=;
        b=PNy73Vlu3vPJc/l4wWHS3O1GzrOfDBysi2541JTrBpbUbbhi4pdw6b1pQV4vyN02Jp
         VMcNQiY84TAqLjUSeQTjzsZCGRSK6ggWV6uzKcphv9nqtafnm23dDhsSdkQoV4LlMwTf
         fsPqPDeJjR05vDiPrGtjK55D6qNzFirb09PxpdCiMQzN9YewHe9hp4m2hK5yGygfFs94
         Sus8Ci33ZMaJ3uNkymEq/vHwldnM8s8lxMkHNbdLYQhwR/Vf22pXY+wi9+99WXYyY8eC
         ZXYzCbO6x6WgmnBELFLMIT4SG0/Hrig6ID3t3UuCeW53noU535g28Em3S9/Hdtg0zaZO
         VurA==
X-Gm-Message-State: AOAM532c0XS1rbqscDpdxRPojLGNZz0TYzq10wq0GcZb9imWI4BHB53R
        Us7oONrqXLQSmGnBRGhtUjLp85iLxXhBNn/yPhuUKX9IORjtNughwJ+A7StvVFDEPYDE8QHq/mZ
        rClCTVTK99UJMrsecoSqBlsXq6JNjVik8ReSbdCXBNRtYeE5eARxXzCi+zA==
X-Google-Smtp-Source: ABdhPJx670GXfdvIHPmRRsC8tpDVdoYR5B0nAASdj1rh4HVW5zMlS4NhRCfNY3S6YZzxPdnPvAtigBnWDH4=
X-Received: by 2002:a25:d80b:: with SMTP id p11mr45636296ybg.506.1595388408649;
 Tue, 21 Jul 2020 20:26:48 -0700 (PDT)
Date:   Wed, 22 Jul 2020 03:26:28 +0000
In-Reply-To: <20200722032629.3687068-1-oupton@google.com>
Message-Id: <20200722032629.3687068-5-oupton@google.com>
Mime-Version: 1.0
References: <20200722032629.3687068-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v3 4/5] selftests: kvm: use a helper function for reading cpuid
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Hornyack <peterhornyack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Derived from kvm-unit-tests.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h      | 15 +++++++++++++++
 .../selftests/kvm/include/x86_64/svm_util.h       |  7 ++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 82b7fe16a824..316fbd4700ef 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -338,6 +338,21 @@ uint32_t kvm_get_cpuid_max_basic(void);
 uint32_t kvm_get_cpuid_max_extended(void);
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits);
 
+struct cpuid {
+	u32 a, b, c, d;
+};
+
+static inline struct cpuid raw_cpuid(u32 function, u32 index)
+{
+	struct cpuid r;
+
+	asm volatile("cpuid"
+		     : "=a"(r.a), "=b"(r.b), "=c"(r.c), "=d"(r.d)
+		     : "0"(function), "2"(index));
+
+	return r;
+}
+
 /*
  * Basic CPU control in CR0
  */
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index b7531c83b8ae..47a13aaee460 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -38,12 +38,9 @@ void nested_svm_check_supported(void);
 
 static inline bool cpu_has_svm(void)
 {
-	u32 eax = 0x80000001, ecx;
+	struct cpuid r = raw_cpuid(0x80000001, 0);
 
-	asm("cpuid" :
-	    "=a" (eax), "=c" (ecx) : "0" (eax) : "ebx", "edx");
-
-	return ecx & CPUID_SVM;
+	return r.c & CPUID_SVM;
 }
 
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
-- 
2.28.0.rc0.142.g3c755180ce-goog

