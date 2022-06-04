Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE69153D483
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350171AbiFDBWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:22:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350167AbiFDBWS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:18 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8660259336
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j11-20020a05690212cb00b006454988d225so8153469ybu.10
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=2nzbG4tOFbNPVrwFNrAhbiBqvXzlQFgyph9XzwhODew=;
        b=JyPTO7S9D1Qyxfuxm2wrOYMchzpd60OlVQByfMkAGcam3znmhaD3zoczzLDVVr0C9S
         qoSNGV6v/IemASXnU8UqOVKWoq4VVVYnurAkfT2nI23amuPpsBE3aVKnr/ouZZZlo0Cb
         U6cfLAR7fPcYOxLUXzXyfpMAYHSIan/Q2eDbLDFWk5PHr48VMy7aKnbR++YuZkKHLsKH
         31CWtiqMFuWTFO6m72mhZiqNNfej02HaffOHgBrxNu/jvFd9NqZol6SO3V58GLKdjNtn
         MGhP9Z14TfdJ9Hw/uLCryOdyalO3M5pZgeLCJg4VBemR1DiJWXWeVKmJtMWIjsqcTeP8
         Ztiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=2nzbG4tOFbNPVrwFNrAhbiBqvXzlQFgyph9XzwhODew=;
        b=RuSX5z8mC/KJ5UYnq+PkCoXGlRjkmk76X0CvFzOawLnTE3mo94i8u9jWimkT+eCmQd
         iicZ2H8T8KqdlGz9jzXSx64gEGAJSSaj9dPp7su1RHp7liOxUqOznyCUNSY+5po7D6Hw
         q7QHRFoHR+y+SwwvZQ7KY3yu/K2nZ4emAX4EtYC94nksHGaHytWoL7wzk7K4gx40/S2O
         /sgD5ekNrU3VLk9TXuoOKY52FH7a6BvSc9rB3/O1+pQJzS8yq+Mns4KZBlYrLwwHec0b
         nbHnY4b+ZOQMiOr4/hOfOnnXtsSji3kg4FOOcQlei2TwxCTXsBtYNHK4ng7HPTkIs7/Y
         00YQ==
X-Gm-Message-State: AOAM532JxIwNEY9xXXrQdYdV4mq2IMv4pMFtCjI4XXOG5WkNh616yFV/
        91AOSKXbTsYV5euTrGY93MWrrGPmbwM=
X-Google-Smtp-Source: ABdhPJz+dJP7G5HiCv9u07R08uVr6zUs40URy8kUmDodPyb9db0BanFmrMqLJBXE1jWDg/Czhir0IYXPJBs=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100d:b0:660:514a:8787 with SMTP id
 w13-20020a056902100d00b00660514a8787mr11183750ybt.583.1654305690058; Fri, 03
 Jun 2022 18:21:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:33 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-18-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 17/42] KVM: selftests: Split out kvm_cpuid2_size() from allocate_kvm_cpuid2()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
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

Split out the computation of the effective size of a kvm_cpuid2 struct
from allocate_kvm_cpuid2(), and modify both to take an arbitrary number
of entries.  Future commits will add caching of a vCPU's CPUID model, and
will (a) be able to precisely size the entries array, and (b) will need
to know the effective size of the struct in order to copy to/from the
cache.

Expose the helpers so that the Hyper-V Features test can use them in the
(somewhat distant) future.  The Hyper-V test very, very subtly relies on
propagating CPUID info across vCPU instances, and will need to make a
copy of the previous vCPU's CPUID information when it switches to using
the per-vCPU cache.  Alternatively, KVM could provide helpers to
duplicate and/or copy a kvm_cpuid2 instance, but each is literally a
single line of code if the helpers are exposed, and it's not like the
size of kvm_cpuid2 is secret knowledge.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 23 +++++++++
 .../selftests/kvm/lib/x86_64/processor.c      | 48 +++----------------
 2 files changed, 30 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index f4345961d447..6b6a72693289 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -593,6 +593,29 @@ static inline bool kvm_cpu_has(struct kvm_x86_cpu_feature feature)
 	return kvm_cpuid_has(kvm_get_supported_cpuid(), feature);
 }
 
+static inline size_t kvm_cpuid2_size(int nr_entries)
+{
+	return sizeof(struct kvm_cpuid2) +
+	       sizeof(struct kvm_cpuid_entry2) * nr_entries;
+}
+
+/*
+ * Allocate a "struct kvm_cpuid2* instance, with the 0-length arrary of
+ * entries sized to hold @nr_entries.  The caller is responsible for freeing
+ * the struct.
+ */
+static inline struct kvm_cpuid2 *allocate_kvm_cpuid2(int nr_entries)
+{
+	struct kvm_cpuid2 *cpuid;
+
+	cpuid = malloc(kvm_cpuid2_size(nr_entries));
+	TEST_ASSERT(cpuid, "-ENOMEM when allocating kvm_cpuid2");
+
+	cpuid->nent = nr_entries;
+
+	return cpuid;
+}
+
 struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vcpu *vcpu);
 
 static inline int __vcpu_set_cpuid(struct kvm_vcpu *vcpu,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index e60afab6b88f..05eac8134119 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -16,6 +16,8 @@
 #define DEFAULT_CODE_SELECTOR 0x8
 #define DEFAULT_DATA_SELECTOR 0x10
 
+#define MAX_NR_CPUID_ENTRIES 100
+
 vm_vaddr_t exception_handlers;
 
 static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
@@ -673,40 +675,6 @@ struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, uint32_t vcpu_id)
 	return vcpu;
 }
 
-/*
- * Allocate an instance of struct kvm_cpuid2
- *
- * Input Args: None
- *
- * Output Args: None
- *
- * Return: A pointer to the allocated struct. The caller is responsible
- * for freeing this struct.
- *
- * Since kvm_cpuid2 uses a 0-length array to allow a the size of the
- * array to be decided at allocation time, allocation is slightly
- * complicated. This function uses a reasonable default length for
- * the array and performs the appropriate allocation.
- */
-static struct kvm_cpuid2 *allocate_kvm_cpuid2(void)
-{
-	struct kvm_cpuid2 *cpuid;
-	int nent = 100;
-	size_t size;
-
-	size = sizeof(*cpuid);
-	size += nent * sizeof(struct kvm_cpuid_entry2);
-	cpuid = malloc(size);
-	if (!cpuid) {
-		perror("malloc");
-		abort();
-	}
-
-	cpuid->nent = nent;
-
-	return cpuid;
-}
-
 /*
  * KVM Supported CPUID Get
  *
@@ -726,7 +694,7 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 	if (cpuid)
 		return cpuid;
 
-	cpuid = allocate_kvm_cpuid2();
+	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 	kvm_fd = open_kvm_dev_path_or_exit();
 
 	kvm_ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
@@ -782,7 +750,7 @@ struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vcpu *vcpu)
 	int max_ent;
 	int rc = -1;
 
-	cpuid = allocate_kvm_cpuid2();
+	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 	max_ent = cpuid->nent;
 
 	for (cpuid->nent = 1; cpuid->nent <= max_ent; cpuid->nent++) {
@@ -1279,7 +1247,7 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
 	if (cpuid)
 		return cpuid;
 
-	cpuid = allocate_kvm_cpuid2();
+	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 	kvm_fd = open_kvm_dev_path_or_exit();
 
 	kvm_ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
@@ -1298,9 +1266,7 @@ void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu)
 		cpuid_sys = kvm_get_supported_cpuid();
 		cpuid_hv = kvm_get_supported_hv_cpuid();
 
-		cpuid_full = malloc(sizeof(*cpuid_full) +
-				    (cpuid_sys->nent + cpuid_hv->nent) *
-				    sizeof(struct kvm_cpuid_entry2));
+		cpuid_full = allocate_kvm_cpuid2(cpuid_sys->nent + cpuid_hv->nent);
 		if (!cpuid_full) {
 			perror("malloc");
 			abort();
@@ -1327,7 +1293,7 @@ struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
 {
 	static struct kvm_cpuid2 *cpuid;
 
-	cpuid = allocate_kvm_cpuid2();
+	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 
 	vcpu_ioctl(vcpu, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
 
-- 
2.36.1.255.ge46751e96f-goog

