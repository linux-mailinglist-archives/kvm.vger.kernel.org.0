Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD9C4C4F48
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 21:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbiBYUJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 15:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235861AbiBYUJL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 15:09:11 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC72F1F03AD
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:38 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id k9-20020a0566022d8900b0064165576298so4478256iow.15
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 12:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Wgqi2KPCKBH/bMb5m85+vN32dj3dX5av+lDesCp799s=;
        b=tP/KWvEp6pObSe1aZomRtu4dt3spd3WFqOmIAa1Xo7Ho6Qq+/BMjMfqHAyKTpdMrpj
         ftlH2XaSOqfnIlNtRWDPhWE5PL6vlwjwN+BiX89SnCyr/RJ4AG4QjIyTrfMlaR5cUqO5
         1kTzReramW1gH8g8IYbOmjOgmXe9WThy0UAwkK6Ez7YaWDs+Up2iYgm1SSZ4LvjB2hhW
         l6Kkc3JIDQzCqO5LKcBpiGK7stGNZbB8Fwf09+qHBIVCn5+blI8EQRL2i3pRG3ze98IP
         C5MqMhlyUs8QVrIhbFZVHCnVrs50sQuA2HDZrL7GnlZvS8dhJ24I9gvrgO7HFUWBvoBU
         LXDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Wgqi2KPCKBH/bMb5m85+vN32dj3dX5av+lDesCp799s=;
        b=DvVG6y2BhEBoNDVGPqeVD0gfPxJbamhfmlYt02YEtPectDOj1IKvBjr15xzMbD0CSC
         5APKWl1roQb7hKXCWLVA1tNqfD/KfHATaaBb2jNawXqCo/tcfTxSLOMF+708ebY8M+lP
         EKWZiSE02XMUCAmV5OIUoNeHQuYVGvD+b25Mel5o+luqvzKRY6UE7fxfdJpnII7RH26M
         46H8x0hKWsterYNuvm/EtNeVCqOfLGkk77BzbF+VgZDEG+HFZfXxcW4t6Xfxxffv2Ain
         +4jWT9l6JaRgP3jg/u9zlVoLEVZf0n3bGmsU8O9JHdC8NKfXZlCr4A56YfM9B5ZMA7dy
         aoEw==
X-Gm-Message-State: AOAM531JWdR1OuiqnSPDGFyTRXiNZgNlnUzqnYWj8cUeSeWtnt/YtXEk
        gF9hf2SBA2SKyM/U0ZOrFlqg200jdk7y18TxEELlkHGZ9qU6ClPJXhjGt6EqLhiUnUhj5qn9Exu
        SQtWS89WNomZ0pL8RnLcKsJViK7l2UJK2JSRMUHAfiOulhpMcIW5BhKY4bw==
X-Google-Smtp-Source: ABdhPJyZV1c7GMZ7YjRYAhht0IkMeAoVgBKaI/bKyKVbxF0iTRTDhZPSeaD2Mg0J42S+iS1ZRLAFtKUj5XI=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6638:964:b0:314:5c66:e9c1 with SMTP id
 o4-20020a056638096400b003145c66e9c1mr7580125jaj.250.1645819718093; Fri, 25
 Feb 2022 12:08:38 -0800 (PST)
Date:   Fri, 25 Feb 2022 20:08:21 +0000
In-Reply-To: <20220225200823.2522321-1-oupton@google.com>
Message-Id: <20220225200823.2522321-5-oupton@google.com>
Mime-Version: 1.0
References: <20220225200823.2522321-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 4/6] selftests: KVM: Separate static alloc from
 KVM_GET_SUPPORTED_CPUID call
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The library code allows for a single allocation of CPUID to store the
value returned by KVM_GET_SUPPORTED_CPUID. Subsequent calls to the
helper simply return a pointer to the aforementioned allocation. A
subsequent change introduces a selftest that contains test cases which
adjust the CPUID value before calling KVM_SET_CPUID2. Using a single
definition of CPUID is problematic, as the changes are not isolated to a
single test case.

Create a helper that allocates memory for CPUID on a per-call basis.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 .../selftests/kvm/lib/x86_64/processor.c      | 33 +++++++++++++++----
 2 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 8a470da7b71a..e36ab7de7717 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -390,6 +390,7 @@ void kvm_x86_state_cleanup(struct kvm_x86_state *state);
 
 struct kvm_msr_list *kvm_get_msr_index_list(void);
 uint64_t kvm_get_feature_msr(uint64_t msr_index);
+struct kvm_cpuid2 *_kvm_get_supported_cpuid(void);
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
 
 struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 9f000dfb5594..b8921cd09ede 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -772,17 +772,14 @@ static struct kvm_cpuid2 *allocate_kvm_cpuid2(void)
  *
  * Return: The supported KVM CPUID
  *
- * Get the guest CPUID supported by KVM.
+ * Gets the supported guest CPUID with the KVM_GET_SUPPORTED_CPUID ioctl.
  */
-struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
+struct kvm_cpuid2 *_kvm_get_supported_cpuid(void)
 {
-	static struct kvm_cpuid2 *cpuid;
+	struct kvm_cpuid2 *cpuid;
 	int ret;
 	int kvm_fd;
 
-	if (cpuid)
-		return cpuid;
-
 	cpuid = allocate_kvm_cpuid2();
 	kvm_fd = open_kvm_dev_path_or_exit();
 
@@ -794,6 +791,30 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 	return cpuid;
 }
 
+/*
+ * KVM Supported CPUID Get
+ *
+ * Input Args: None
+ *
+ * Output Args: None
+ *
+ * Return: The supported KVM CPUID
+ *
+ * Gets the supported guest CPUID with the KVM_GET_SUPPORTED_CPUID ioctl.
+ * The first call creates a static allocation of CPUID for the process.
+ * Subsequent calls will return a pointer to the previously allocated CPUID.
+ */
+struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
+{
+	static struct kvm_cpuid2 *cpuid;
+
+	if (cpuid)
+		return cpuid;
+
+	cpuid = _kvm_get_supported_cpuid();
+	return cpuid;
+}
+
 /*
  * KVM Get MSR
  *
-- 
2.35.1.574.g5d30c73bfb-goog

