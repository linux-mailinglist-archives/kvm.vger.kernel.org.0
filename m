Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80D7D2289B8
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 22:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbgGUUSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 16:18:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730631AbgGUUS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 16:18:27 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15E66C061794
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 13:18:27 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id cq11so189513pjb.0
        for <kvm@vger.kernel.org>; Tue, 21 Jul 2020 13:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VLViaE9BMLq1Koj5GPqKDedU+cZQMogTKZxkSxXxKVg=;
        b=IOGA/9/esuLd1jSvZt1tKWq8Gf//XKf2wJ7w1II7VUa1SJpHmCccEJHKugath3bEkv
         iCTyq/Od2T/UVslhp1jVEhS1Qd5brFiU/l9aZ9szzLhskYw3gZmQFc5jsuFMUtos1DAw
         c1phLyHRXSX3+w9CJYY7jfxTNgo0Qm91sip0GegI9rOxpTPvqhX1GyFS9qh2qeu2A/nw
         NE4JGwe06ezD2d3eeDnIFsE06aa1e9pEU6mA8Bq+vNtGiTqELXlFm1lGd+xrWoa0tcqd
         C41RjpEL04ZxmwRV8Y+V1I91g2zCT2f9yq7C327THMgrAmotKrMPpguPoMQF/1hL1Qjt
         idRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VLViaE9BMLq1Koj5GPqKDedU+cZQMogTKZxkSxXxKVg=;
        b=INdOZL1Rc43bhPReCMsdUr60h0eKSNYdXONQUC6DO8D6HreXgdW8TprxUKdD4Bm0W6
         UYIyjtznV0L0T3ATIeQiWVVqy7TbNP4um+gEDXOInAaB3ZN9lhjXWfBWEibFc8YhqQwk
         RxWO8j2ty4ICc0/BpCIlv3454ILzbSnETNpIsjnjgO/J7ZMtGmrlzEEUq9oloCN1HrwG
         bCm+vvu7kysMDjr6PFJpIbzftRHpKUcJ9BP3+9Kfkh3CStPqeOI3va6u8U9AtUcRiMSz
         V+szkUapqWBZHu/0Y4BjtQUTVvbLZCFh7ds0Tf0jTVV/fpFiB3SqYMhBr9te901bdaOS
         +xDQ==
X-Gm-Message-State: AOAM5301tLFJBLHrPr278VV6Fj5DR1zSdcFDoOYGV9pJxGASglTzr8Bb
        qAXlkdEWdn/I5L3cLdlY6vvVQSasJjUGWLnVNinWHnhulrjCZp7isQGMwGEx1jWGOsWTBtKgv3j
        +NyYS0Ywzx9Ll/kmQoc6eH1xxqpKUZogHTqM9PkJToOKWdO9l6nIP6tk8Kg==
X-Google-Smtp-Source: ABdhPJy+C8F1k/Pk6nvVZScqLC2v9HTgA3c2N0XTMLizwiLeJZE/tEcafpGCGq3Nf2KXQhclvMQpsuEvl9Q=
X-Received: by 2002:a63:3d42:: with SMTP id k63mr23889406pga.330.1595362706398;
 Tue, 21 Jul 2020 13:18:26 -0700 (PDT)
Date:   Tue, 21 Jul 2020 20:18:13 +0000
In-Reply-To: <20200721201814.2340705-1-oupton@google.com>
Message-Id: <20200721201814.2340705-5-oupton@google.com>
Mime-Version: 1.0
References: <20200721201814.2340705-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v2 4/5] selftests: kvm: use a helper function for reading cpuid
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

