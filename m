Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC0D42AE2C
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 22:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbhJLUvR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 16:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbhJLUvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 16:51:14 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39E2C061746
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 13:49:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id b9-20020a5b07890000b0290558245b7eabso736135ybq.10
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 13:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5rpbBBxXYnQlKlnVXmOdTaySI3jmj1Cw0Iss9XL2zks=;
        b=gElW6d9WHAnykPbijck4HL/tN67aQq1ATwA2uNw6a4+YIuGWts+7E0vh05z61cOpen
         ocWO3g2vlDUCrV7SZpzAazUrILZBfFLzsObrGmLjJdcFzOohe63yFaq+3qJSII5CDeZ8
         74XVlK69bD82ti2lENcGBd7XppFYIO/7ssq0n7YGxi+IKP2r3lbJL1XmDAGoidHwZbh2
         TpADVVSY/1RGX9IzK92uViQK5PfTX9CoB5x4I0IuG1upGVMHVZKdKXrXWOruTjdE2c2s
         h2WOg6EQh1lrsKvgZtTLxQBG/bltc4+2ynf3/R5RgAta+Eu31hY+nY6MzARw4iTWv92t
         uDzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5rpbBBxXYnQlKlnVXmOdTaySI3jmj1Cw0Iss9XL2zks=;
        b=yn35XF1yQ239JxPdul5wAlfSvErZ11MshriAq+ngZk2E/E37p5J1LUcFyFnQ4+Cx9q
         YbWugJrx0/hFAucfTHKyTxbj2/VEwO1Xdm32ze707v2S1/HRwL+JOsFUUMPZuYHPnVGY
         6H0lCJLlDEFFd09BStpb/8MYuLzwUZO86nQqOCDxPlWTTyFXJ86iIPYsrt+SSDhGIGIo
         1yYEHDaiawJgiZP6u2D4iBMPztCprtD/Fotx2UMy2YzojOhHEejRMQ2/Alo1Bc4k9vtT
         b+s+YunYbVzTE5+GkFuDc/Jji26Rde50b503dsJ+Xx7Vsocn9ZhZmDbPb8za8xk4yufW
         x1oA==
X-Gm-Message-State: AOAM533KcpKEcZgcHLE4eVJqbwRFPTrvPfehLWwH7onwoSYJpn2RvL4T
        bfwtt82IifnB/24aNBYQCWnBh63uef/w9HiZp7dUFy86GVDCloRLGQsepJ2APHxF20Wc2b6GEHB
        WsxEUm2/8Zv3zerkqOr7M4hV4w7asxX3fobqa9XKms+toWy92V0dmZbjK5Q==
X-Google-Smtp-Source: ABdhPJx93TFToUDDdvJSQFzb2D1wjxhb26KvL1sSgu9zdjuHkSVDSxSHcaBX9dzwA+fEY/goqYfh89Ub/3I=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:bab5:e2c:2623:d2f8])
 (user=pgonda job=sendgmr) by 2002:a25:a105:: with SMTP id z5mr31004516ybh.247.1634071751188;
 Tue, 12 Oct 2021 13:49:11 -0700 (PDT)
Date:   Tue, 12 Oct 2021 13:48:57 -0700
In-Reply-To: <20211012204858.3614961-1-pgonda@google.com>
Message-Id: <20211012204858.3614961-5-pgonda@google.com>
Mime-Version: 1.0
References: <20211012204858.3614961-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH 4/5 V10] selftest: KVM: Add open sev dev helper
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactors out open path support from open_kvm_dev_path_or_exit() and
adds new helper for SEV device path.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 24 +++++++++++--------
 tools/testing/selftests/kvm/lib/x86_64/svm.c  | 13 ++++++++++
 4 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 1b3ef5757819..adf4fa274808 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -82,6 +82,7 @@ struct vm_guest_mode_params {
 };
 extern const struct vm_guest_mode_params vm_guest_mode_params[];
 
+int open_path_or_exit(const char *path, int flags);
 int open_kvm_dev_path_or_exit(void);
 int kvm_check_cap(long cap);
 int vm_enable_cap(struct kvm_vm *vm, struct kvm_enable_cap *cap);
diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index b7531c83b8ae..587fbe408b99 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -46,4 +46,6 @@ static inline bool cpu_has_svm(void)
 	return ecx & CPUID_SVM;
 }
 
+int open_sev_dev_path_or_exit(void);
+
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 0fe66ca6139a..ea88e6b14670 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -31,6 +31,19 @@ static void *align(void *x, size_t size)
 	return (void *) (((size_t) x + mask) & ~mask);
 }
 
+int open_path_or_exit(const char *path, int flags)
+{
+	int fd;
+
+	fd = open(path, flags);
+	if (fd < 0) {
+		print_skip("%s not available (errno: %d)", path, errno);
+		exit(KSFT_SKIP);
+	}
+
+	return fd;
+}
+
 /*
  * Open KVM_DEV_PATH if available, otherwise exit the entire program.
  *
@@ -42,16 +55,7 @@ static void *align(void *x, size_t size)
  */
 static int _open_kvm_dev_path_or_exit(int flags)
 {
-	int fd;
-
-	fd = open(KVM_DEV_PATH, flags);
-	if (fd < 0) {
-		print_skip("%s not available, is KVM loaded? (errno: %d)",
-			   KVM_DEV_PATH, errno);
-		exit(KSFT_SKIP);
-	}
-
-	return fd;
+	return open_path_or_exit(KVM_DEV_PATH, flags);
 }
 
 int open_kvm_dev_path_or_exit(void)
diff --git a/tools/testing/selftests/kvm/lib/x86_64/svm.c b/tools/testing/selftests/kvm/lib/x86_64/svm.c
index 2ac98d70d02b..14a8618efa9c 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/svm.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/svm.c
@@ -13,6 +13,8 @@
 #include "processor.h"
 #include "svm_util.h"
 
+#define SEV_DEV_PATH "/dev/sev"
+
 struct gpr64_regs guest_regs;
 u64 rflags;
 
@@ -160,3 +162,14 @@ void nested_svm_check_supported(void)
 		exit(KSFT_SKIP);
 	}
 }
+
+/*
+ * Open SEV_DEV_PATH if available, otherwise exit the entire program.
+ *
+ * Return:
+ *   The opened file descriptor of /dev/sev.
+ */
+int open_sev_dev_path_or_exit(void)
+{
+	return open_path_or_exit(SEV_DEV_PATH, 0);
+}
-- 
2.33.0.882.g93a45727a2-goog

