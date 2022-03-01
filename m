Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19544C83B2
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 07:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiCAGE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 01:04:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbiCAGEw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 01:04:52 -0500
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10C9E60D84
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:11 -0800 (PST)
Received: by mail-il1-x14a.google.com with SMTP id r4-20020a92d444000000b002c26d0c9354so10428650ilm.15
        for <kvm@vger.kernel.org>; Mon, 28 Feb 2022 22:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Wgqi2KPCKBH/bMb5m85+vN32dj3dX5av+lDesCp799s=;
        b=do7HFnBqFt/mQ6mPr6awgcpxK4/atJuQzEJBpvhh+J65YWPsH4xQr4qytT6tRmYkxC
         Ne49f8ddcbGne5ua0yd533R2HiHfgOZJKhv09EgkxJEtrFZGsoJlA+kZ8B8gtHocR/rN
         Orbx0OQ25QmLLxRuWDRKSwPShfxR6KDvpRL7Cn3lFaGJkAEBws0ETAzuuRcdKHe6vhCP
         CDtiDkHS1MqECcZ/x3uwq8YDd51CWPNIxa94nzAjBKwN/bTUgOR08k7M2E8Y3Jeqg4QM
         A6rooxDhMYQf6HXdAKt5ZLc0LWCmkN2tWb2B33MGXt/21uBbPn22qdC/3P6O4J5XfNa2
         ZRkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Wgqi2KPCKBH/bMb5m85+vN32dj3dX5av+lDesCp799s=;
        b=SFV31Kh2nvJFljQDglqoFhIauihfJMMrX8hKCcr0lyuCAiwP20VCDluV2tEn/4XGHr
         CWnfYv4W01E+Tm6ATBSeJPXoXBuCC6Yw9p7GaEvizTwSh0Jb4gvSVDQcyfrYfYu+2KJX
         bE3cLkKSNrMpDi+sS6ZigxsZwA42aDMqw2ZzQ9EQSy13E3nUqVy4n0D8Lv52wkdygL3B
         ImVKXQxJCHZYL4Ww82NHxiEykMhrtY0IdlmrHgKWWo3HJmI8Q92Ie87JZBUqmRwCdNrj
         KXQP4CgHXlxcZvdAEDjh+QD1umRDgGoPDXDOHoDQ0n+VpPSSxF3B5mvcSNcn8sMijyPz
         P6XA==
X-Gm-Message-State: AOAM53096H8q/vL2GCRzCDbURRLUhUBuZgdyUGVT3jQYcfQHbKb7OKT2
        +mBJNqrATjm4NS4nudrQAvIu9dmFwi5+ijuTEi05jZA6ThDtqL0GjGC93eKTH9rn4P61HBi3Bf5
        vJg+Z50okaJYjvVTG7AVM5O245tbvSbEvdHfBlzl2EmnsHPsfTP6qasaWPg==
X-Google-Smtp-Source: ABdhPJy2jwNdQqeXJ9+0yxw19Q4q8daYK8SXc/+efNbMYVDN9KegvkPTKRcCUjsxld0LCE3zRWcUVECHuqo=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a92:b107:0:b0:2be:cb81:dd96 with SMTP id
 t7-20020a92b107000000b002becb81dd96mr21320841ilh.189.1646114651083; Mon, 28
 Feb 2022 22:04:11 -0800 (PST)
Date:   Tue,  1 Mar 2022 06:03:49 +0000
In-Reply-To: <20220301060351.442881-1-oupton@google.com>
Message-Id: <20220301060351.442881-7-oupton@google.com>
Mime-Version: 1.0
References: <20220301060351.442881-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v4 6/8] selftests: KVM: Separate static alloc from
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
X-Spam-Status: No, score=-10.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
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

