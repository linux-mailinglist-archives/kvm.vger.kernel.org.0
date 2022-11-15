Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305A362A444
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 22:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbiKOVjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 16:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238806AbiKOVi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 16:38:58 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DA026101
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 13:38:54 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id u18-20020a627912000000b0056d93d8b8bdso8419455pfc.16
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 13:38:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tuWVwJ16YEkS5FVgRWJyUapc80qRQY7AsPIqQryq7YE=;
        b=Wpu8ji1MBWg33BnAZTlztobw9K3WTIOlK7sZASVsqXi3+vyDsQxwAhGAJAdjSmbLv2
         Cd2v+DUyc4BduafbFeSbrEBZM8bTt4thoOJ0BvGXG8/UYUpM0zbDh+WY6PK33JuEMUhV
         +2VmVOacoW9hnUlbA20zdD/tg3YYkUBlFT9YSMeYCgbvkwx9OWEuw4M9j34VzSjLjiug
         wQPPi3RjOHtNH/E1p/1oSpAEax6UmhFunrzv0zsKtP5+RdwnIQW93r4ThqXuSyoIr21Z
         ha6zv+DzeEqQtpzRb8Is84rpxsX/kiAOXHtbviwNRC44C1UTxKasvlD7ej2HlWY20Kvg
         N3jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tuWVwJ16YEkS5FVgRWJyUapc80qRQY7AsPIqQryq7YE=;
        b=pfyJAHhegKyLzeECSLZ6C1BzehIQJ3ObKcxuT0BrR2xzqw2TPmZ/rhSf8wxuXPsaLV
         ePIjrPig5j+CUHdYxEGLrP7aSSBbZ3Uhc70QL7kKBtKZFwlZBLKcey74yEdmmx+PxEex
         0vrqTPwyxsfDqQfgWhLdApNkt6LS1olnXEUYviRjGfIMges6iCH/KwWkIWoryNg0aXmo
         bpL7iAfjzH8Kn7H/M+6SNXM0hbLVeqIixK44ansWbjUPnf507A/n6axLFec7q9HfiMnL
         N442nI7PEuQ56IQ87gZ1ZmvwGasbFDA6wX4155VWT+E3isZs8E+kSXMRIhks49e0WzXU
         PiRg==
X-Gm-Message-State: ANoB5pmFz9JjkBs0nW4UQI3AqSuUR14GEs1qX2VSTzM87KXob7r3WGba
        rEDqLZQBDql+CnllzvR4nhBJRohkJMVrAp6u
X-Google-Smtp-Source: AA0mqf6Q1YyObHItnZTLRmBRd/YOvA7Td6u2WD5jwrCF/b+6ZgmuBWmMB+wp0A3+Sm7gxvRryEm4NnUIMie4Nb7C
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:a17:902:d64f:b0:188:beef:b68f with SMTP
 id y15-20020a170902d64f00b00188beefb68fmr5588393plh.172.1668548334142; Tue,
 15 Nov 2022 13:38:54 -0800 (PST)
Date:   Tue, 15 Nov 2022 21:38:44 +0000
In-Reply-To: <20221115213845.3348210-1-vannapurve@google.com>
Mime-Version: 1.0
References: <20221115213845.3348210-1-vannapurve@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115213845.3348210-3-vannapurve@google.com>
Subject: [V4 PATCH 2/3] KVM: selftests: Add arch specific initialization
From:   Vishal Annapurve <vannapurve@google.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, shuah@kernel.org, bgardon@google.com,
        seanjc@google.com, oupton@google.com, peterx@redhat.com,
        vkuznets@redhat.com, dmatlack@google.com, pgonda@google.com,
        andrew.jones@linux.dev, Vishal Annapurve <vannapurve@google.com>
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

Introduce arch specific API: kvm_selftest_arch_init to allow each arch to
handle initialization before running any selftest logic.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Andrew Jones <andrew.jones@linux.dev>
Reviewed-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h      |  5 +++++
 .../selftests/kvm/lib/aarch64/processor.c      | 18 +++++++++---------
 tools/testing/selftests/kvm/lib/kvm_util.c     |  6 ++++++
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index e42a09cd24a0..eec0e4898efe 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -838,4 +838,9 @@ static inline int __vm_disable_nx_huge_pages(struct kvm_vm *vm)
 	return __vm_enable_cap(vm, KVM_CAP_VM_DISABLE_NX_HUGE_PAGES, 0);
 }
 
+/*
+ * API to execute architecture specific setup before executing main().
+ */
+void kvm_selftest_arch_init(void);
+
 #endif /* SELFTEST_KVM_UTIL_BASE_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/processor.c b/tools/testing/selftests/kvm/lib/aarch64/processor.c
index 6f5551368944..0de4aabc0c76 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/processor.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/processor.c
@@ -495,15 +495,6 @@ void aarch64_get_supported_page_sizes(uint32_t ipa,
 	close(kvm_fd);
 }
 
-/*
- * arm64 doesn't have a true default mode, so start by computing the
- * available IPA space and page sizes early.
- */
-void __attribute__((constructor)) init_guest_modes(void)
-{
-       guest_modes_append_default();
-}
-
 void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 	       uint64_t arg2, uint64_t arg3, uint64_t arg4, uint64_t arg5,
 	       uint64_t arg6, struct arm_smccc_res *res)
@@ -528,3 +519,12 @@ void smccc_hvc(uint32_t function_id, uint64_t arg0, uint64_t arg1,
 		       [arg4] "r"(arg4), [arg5] "r"(arg5), [arg6] "r"(arg6)
 		     : "x0", "x1", "x2", "x3", "x4", "x5", "x6", "x7");
 }
+
+void kvm_selftest_arch_init(void)
+{
+	/*
+	 * arm64 doesn't have a true default mode, so start by computing the
+	 * available IPA space and page sizes early.
+	 */
+	guest_modes_append_default();
+}
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 37d7d144c74e..deb4c731b9fa 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2022,8 +2022,14 @@ void __vm_get_stat(struct kvm_vm *vm, const char *stat_name, uint64_t *data,
 	}
 }
 
+__weak void kvm_selftest_arch_init(void)
+{
+}
+
 void __attribute((constructor)) kvm_selftest_init(void)
 {
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
+
+	kvm_selftest_arch_init();
 }
-- 
2.38.1.431.g37b22c650d-goog

