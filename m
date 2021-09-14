Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C82440B53A
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 18:48:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbhINQtA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 12:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbhINQsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 12:48:54 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07114C061762
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:47:37 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id z8-20020a17090acb0800b001996f635e3bso2697pjt.6
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 09:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RBZaKuZALLe3rJ2+w08+UFnfhUVY8qw7FYW7+il7fnw=;
        b=oWWwD7gHC/h2WvG5OvgLQJwZ0NDmC2d0/Yyu2V7ag8ZO8zNb2bhVmG41eid62kEIyC
         77aSl5+H08sBkT3bjDqKQuYTEFb9b+I8oqYokRGsc/+Y26V08J0F1QaHNfiD92U9m7JS
         0268Q3FxwOMErA3LFMMDhre9aNkuhIy5f+aqpAMBpvfQgHBoVitVH5lT/jkX+JHKWx0M
         NBZcugs+USZl0WkD6UBNb/na3yc3rG34oNDaf+1cMZMlimHpcnZuRsgDBYgbOxN1o4j1
         Rg2fAyNtdGtSsckA4brNd9FcCl4CsaiXx/K8inY/6yDZwLDl5g7m4UTDTqS9UaZSBg+h
         rGlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RBZaKuZALLe3rJ2+w08+UFnfhUVY8qw7FYW7+il7fnw=;
        b=1h6uSQE0Kr9GrtCe2gRdXRvteGbxBWEfWo15SKU/1OXBx7yo+UDR/8RwZLPh5W1kgR
         Aptn1+coZ3uyyfnJplQ4bFSvZ/wL1X6KSynUgNhKaNxDbc0+NfteReXR149qtxXwsrBT
         Sp9d8fBg5ImwKyzEPF/wblDnHajgyiIH/nAaAPwXUvAbYvYym2/hv3a4qVNM4iVB8J1q
         BfRGUaOB4b1Kkn3DpkoVNmBFgyjuq325ahgs2J9sXP/wfcEpZMCIqv5DwFbcF5tTUGpy
         z/IO8qFkIgFvOuiyIpWseniuueLBNbuAFUVDkERhso3rgI+Gdb9Ni9QemuKmAJj1Pbl8
         4ueA==
X-Gm-Message-State: AOAM531jM8pjtYEtV9atNElPSv4SLiQIL1csm60rO42id194Qv8NZLm0
        b0X8fvrRSac/M9sk5T/IPlnHV2g4+UwBhu8P62DU9dLIiQiE/LOuVD2jepqIgGkqohFTfQF2YXc
        5aCNPCtXSVL0jp/N5WHk6a+NXhwp1gDXzXTmrffGxy5tkCHImE1urUSkKrA==
X-Google-Smtp-Source: ABdhPJz5b2sWFWA7Hij160fti1PQK6qxeRt7EVoNflAD8mou/fhMjlVbsKujgGQWgRL6EdEqRvmgxW/ZYQ4=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:204:b358:1f40:79d5:ab23])
 (user=pgonda job=sendgmr) by 2002:a17:90a:194a:: with SMTP id
 10mr3143001pjh.176.1631638056374; Tue, 14 Sep 2021 09:47:36 -0700 (PDT)
Date:   Tue, 14 Sep 2021 09:47:26 -0700
In-Reply-To: <20210914164727.3007031-1-pgonda@google.com>
Message-Id: <20210914164727.3007031-4-pgonda@google.com>
Mime-Version: 1.0
References: <20210914164727.3007031-1-pgonda@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 3/4 V8] selftest: KVM: Add open sev dev helper
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactors out open path support from open_kvm_dev_path_or_exit() and
adds new helper for SEV device path.

Signed-off-by: Peter Gonda <pgonda@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Wanpeng Li <wanpengli@tencent.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 .../testing/selftests/kvm/include/kvm_util.h  |  1 +
 .../selftests/kvm/include/x86_64/svm_util.h   |  2 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 24 +++++++++++--------
 tools/testing/selftests/kvm/lib/x86_64/svm.c  | 13 ++++++++++
 4 files changed, 30 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 010b59b13917..368e88305046 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -80,6 +80,7 @@ struct vm_guest_mode_params {
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
index 10a8ed691c66..06a6c04010fb 100644
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
2.33.0.309.g3052b89438-goog

