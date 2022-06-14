Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0132B54BB32
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357475AbiFNUIS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357217AbiFNUIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE55727146
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:43 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y66-20020a62ce45000000b0051bb4d19f5fso4220211pfg.18
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CEG3CJA3T32C0gPYBuKCbmkH92xhHKXCyYJXkyouerY=;
        b=dtJ4GvALEhmxEVYBs2chY8pzwRAXgqgmmWWEtgDilKGOIKa/eR/WHOdU5Fm50VTQSm
         ASCGPRAL070TK4zUPlidhtOjJQSv4BtgvVoaEb5ULT+J3WxGa2B8OHsEM8zeueAEQmxu
         rmUY2WzvFvt0LTpabzktombu0Z1WIOR36Hbh2JxkYaE5CgIPLBSypF01gzHC1JF9MNem
         U0tJKcgtkJ/I2zTh/k+H+LL76zTnPYXN7Suzff4oQD6x9jKqUi41m1l0DmQa1Isdh9E+
         XDEXU1/IUIhhpfEwAnj1cxTLJOWirdlQIgB3wFirEFBfK93WIupNerNjWFKtce46TTHq
         opCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CEG3CJA3T32C0gPYBuKCbmkH92xhHKXCyYJXkyouerY=;
        b=nD+utLrYqMWFF7tiM+bSJ8gUX9aw5eoG+ZFTeTNac40wDu1Kh0z1zirxhiE4MduZaE
         dT+Dnl2YHu56ciDYLM2udZ5Bx57YuAwa7AER4LMUvNVH26bTjNC+Aim69QsRXhfuUCwI
         ZqkC2VGJMMIFm6LIzC9ZdLgIsLwIDkv9rew0lyWhtFxP2bFohbiCbQYxAiTLzzvEO06K
         70OicPZkR+NhlqHkz3OK0CjrQzAzw5o563C7jU0vDV0qdGVaMoy8ICbhC2F/Fk12Q5w8
         /cPuTmL+tcaydgQ0xTvfEi4mVZEFk9Z7p+CNJrRsqabb+VnizTIu6mewFJ+5DCsvK4i+
         3teg==
X-Gm-Message-State: AJIora83W8kYnCJ7h1VQI148IgGCgx2je/jZL83FrEJqMKhpY2A8vmW9
        YCYGC6u1ghbrfPdfqBvEXu4+E5u5BlU=
X-Google-Smtp-Source: ABdhPJwbg13NsMMqPnrgV7ewwb6XxOstI31ZoJyGbnr/FuQBFZgaXPeNHE+OUzHrMrlGzXZH/uxSkDNVEHY=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:aa7:9728:0:b0:51b:e78e:b333 with SMTP id
 k8-20020aa79728000000b0051be78eb333mr6045991pfg.36.1655237263254; Tue, 14 Jun
 2022 13:07:43 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:42 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-18-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 17/42] KVM: selftests: Split out kvm_cpuid2_size() from allocate_kvm_cpuid2()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
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
index f5fa7d2e44a6..002ed02cc2ef 100644
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
index 7666f24a145a..e9a2c606c6c3 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -16,6 +16,8 @@
 #define DEFAULT_CODE_SELECTOR 0x8
 #define DEFAULT_DATA_SELECTOR 0x10
 
+#define MAX_NR_CPUID_ENTRIES 100
+
 vm_vaddr_t exception_handlers;
 
 static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
@@ -672,40 +674,6 @@ struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, uint32_t vcpu_id)
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
@@ -725,7 +693,7 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 	if (cpuid)
 		return cpuid;
 
-	cpuid = allocate_kvm_cpuid2();
+	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 	kvm_fd = open_kvm_dev_path_or_exit();
 
 	kvm_ioctl(kvm_fd, KVM_GET_SUPPORTED_CPUID, cpuid);
@@ -781,7 +749,7 @@ struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vcpu *vcpu)
 	int max_ent;
 	int rc = -1;
 
-	cpuid = allocate_kvm_cpuid2();
+	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 	max_ent = cpuid->nent;
 
 	for (cpuid->nent = 1; cpuid->nent <= max_ent; cpuid->nent++) {
@@ -1278,7 +1246,7 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
 	if (cpuid)
 		return cpuid;
 
-	cpuid = allocate_kvm_cpuid2();
+	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 	kvm_fd = open_kvm_dev_path_or_exit();
 
 	kvm_ioctl(kvm_fd, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
@@ -1297,9 +1265,7 @@ void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu)
 		cpuid_sys = kvm_get_supported_cpuid();
 		cpuid_hv = kvm_get_supported_hv_cpuid();
 
-		cpuid_full = malloc(sizeof(*cpuid_full) +
-				    (cpuid_sys->nent + cpuid_hv->nent) *
-				    sizeof(struct kvm_cpuid_entry2));
+		cpuid_full = allocate_kvm_cpuid2(cpuid_sys->nent + cpuid_hv->nent);
 		if (!cpuid_full) {
 			perror("malloc");
 			abort();
@@ -1326,7 +1292,7 @@ struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
 {
 	static struct kvm_cpuid2 *cpuid;
 
-	cpuid = allocate_kvm_cpuid2();
+	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 
 	vcpu_ioctl(vcpu, KVM_GET_SUPPORTED_HV_CPUID, cpuid);
 
-- 
2.36.1.476.g0c4daa206d-goog

