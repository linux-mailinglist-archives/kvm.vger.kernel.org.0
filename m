Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4A386D71A5
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 02:45:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbjDEApp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 20:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236671AbjDEApd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 20:45:33 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7895A4ED0
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 17:45:31 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id gj9-20020a17090b108900b0024038c818a0so10746390pjb.7
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 17:45:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680655530;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SL1I67lV9tgXgAEvmRnaRT+4/QRS9Sk5XoUvQ3XeqRI=;
        b=J1cGRcd7ht1RyeB1dMJiFXaAS4GM2LJk6yDcKESwIL0R8iRCfuxajLpzX5zKnLczuT
         bxHd8FnJcmI+SMglu4+SA0klmsqwRW5SfSo5bl5HR6bJHuu1qPq6v3juzseWWsYJgb/V
         qrrGQHve/MBiMDnwbl1Esflahc8hUQ8bBJobaJ6AxXYy65kpWiJyj3l4dYWC7G27Im0e
         t74ZnovCetz0rNdxnZIXALMXptBqCyPGES/luAPTP1pp0sriD8E2SrddR/A2hqU9zu7A
         ooe89p4LhjJK3UJbupaz4huRnLNo5WWpBkBpLENrTH0Edn7F1ChvNZXsQlCy9xesCATr
         orEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680655530;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SL1I67lV9tgXgAEvmRnaRT+4/QRS9Sk5XoUvQ3XeqRI=;
        b=8A5xyFnnr1R5NECPK+FBCxbbqpnwktF31hPUpbwY5wvMPdVxKra0kwELxG9mFu1fnj
         qbnl+tSxuY+QBJi0hwq7k0bN+IH7iokPhA+SZbJ06E4VlOCkQAHvPyJ9xNI1OXN6vl5h
         Vi4qVMFsz31pu4tNhrO1oT7Pp9uTtqADEPDr/CBB28UhOG8JiHa1kBIvz4hGCZP5UUxX
         7HgJWKrF9NMLsdFLLkt/iqKOej/7e3pIX2QPjkzEKdOEb5C+aszllgXgnxOyfZO2gejU
         MRrcKOj8+FsjNkrsixfB2x1P8QK3XQ7KNGWi/6++r1REH6DLmnkJGNoY/02MSXHGd+Gk
         Y+Jg==
X-Gm-Message-State: AAQBX9frU2FZEroK7NPUXElCMaBfcqSb4HROQycJEiAZnnfuDo+Pskgc
        13HK66yKgSDCBhFTt42fY1V4qASSvSw=
X-Google-Smtp-Source: AKy350b+7TkaPc85UJyDGGxPNsKQJ5NzJqSs32SuDcgOx/mehzhkZh/APMybqR/hRpf7gTv56c0ExKyqQ5k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4591:b0:234:acfd:c8da with SMTP id
 v17-20020a17090a459100b00234acfdc8damr1604747pjg.2.1680655530265; Tue, 04 Apr
 2023 17:45:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  4 Apr 2023 17:45:18 -0700
In-Reply-To: <20230405004520.421768-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230405004520.421768-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230405004520.421768-5-seanjc@google.com>
Subject: [PATCH v4 4/6] KVM: selftests: Rework dynamic XFeature helper to take
 mask, not bit
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Take the XFeature mask in __vm_xsave_require_permission() instead of the
bit so that there's no need to define macros for both the bit and the
mask.  Asserting that only a single bit is set and retrieving said bit
is easy enough via log2 helpers.

Opportunistically clean up the error message for the
ARCH_REQ_XCOMP_GUEST_PERM sanity check.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h    |  6 +++---
 .../selftests/kvm/lib/x86_64/processor.c        | 17 ++++++++++-------
 tools/testing/selftests/kvm/x86_64/amx_test.c   |  2 +-
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index f6061fe7057f..41d798375570 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1098,10 +1098,10 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 uint64_t __xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
 void xen_hypercall(uint64_t nr, uint64_t a0, void *a1);
 
-void __vm_xsave_require_permission(int bit, const char *name);
+void __vm_xsave_require_permission(uint64_t xfeature, const char *name);
 
-#define vm_xsave_require_permission(perm)	\
-	__vm_xsave_require_permission(perm, #perm)
+#define vm_xsave_require_permission(xfeature)	\
+	__vm_xsave_require_permission(xfeature, #xfeature)
 
 enum pg_level {
 	PG_LEVEL_NONE,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index a12b21a2ef37..898b30096c80 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -697,7 +697,7 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
 	return buffer.entry.data;
 }
 
-void __vm_xsave_require_permission(int bit, const char *name)
+void __vm_xsave_require_permission(uint64_t xfeature, const char *name)
 {
 	int kvm_fd;
 	u64 bitmask;
@@ -705,12 +705,15 @@ void __vm_xsave_require_permission(int bit, const char *name)
 	struct kvm_device_attr attr = {
 		.group = 0,
 		.attr = KVM_X86_XCOMP_GUEST_SUPP,
-		.addr = (unsigned long) &bitmask
+		.addr = (unsigned long) &bitmask,
 	};
 
 	TEST_ASSERT(!kvm_supported_cpuid,
 		    "kvm_get_supported_cpuid() cannot be used before ARCH_REQ_XCOMP_GUEST_PERM");
 
+	TEST_ASSERT(is_power_of_2(xfeature),
+		    "Dynamic XFeatures must be enabled one at a time");
+
 	kvm_fd = open_kvm_dev_path_or_exit();
 	rc = __kvm_ioctl(kvm_fd, KVM_GET_DEVICE_ATTR, &attr);
 	close(kvm_fd);
@@ -720,16 +723,16 @@ void __vm_xsave_require_permission(int bit, const char *name)
 
 	TEST_ASSERT(rc == 0, "KVM_GET_DEVICE_ATTR(0, KVM_X86_XCOMP_GUEST_SUPP) error: %ld", rc);
 
-	__TEST_REQUIRE(bitmask & (1ULL << bit),
+	__TEST_REQUIRE(bitmask & xfeature,
 		       "Required XSAVE feature '%s' not supported", name);
 
-	TEST_REQUIRE(!syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, bit));
+	TEST_REQUIRE(!syscall(SYS_arch_prctl, ARCH_REQ_XCOMP_GUEST_PERM, ilog2(xfeature)));
 
 	rc = syscall(SYS_arch_prctl, ARCH_GET_XCOMP_GUEST_PERM, &bitmask);
 	TEST_ASSERT(rc == 0, "prctl(ARCH_GET_XCOMP_GUEST_PERM) error: %ld", rc);
-	TEST_ASSERT(bitmask & (1ULL << bit),
-		    "prctl(ARCH_REQ_XCOMP_GUEST_PERM) failure bitmask=0x%lx",
-		    bitmask);
+	TEST_ASSERT(bitmask & xfeature,
+		    "'%s' (0x%lx) not permitted after prctl(ARCH_REQ_XCOMP_GUEST_PERM) perrmited=0x%lx",
+		    name, xfeature, bitmask);
 }
 
 void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid)
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index af1ef6f79d32..a0f74f5121a6 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -233,7 +233,7 @@ int main(int argc, char *argv[])
 	 * Note, all off-by-default features must be enabled before anything
 	 * caches KVM_GET_SUPPORTED_CPUID, e.g. before using kvm_cpu_has().
 	 */
-	vm_xsave_require_permission(XSTATE_XTILE_DATA_BIT);
+	vm_xsave_require_permission(XFEATURE_MASK_XTILEDATA);
 
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XFD));
 	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_XSAVE));
-- 
2.40.0.348.gf938b09366-goog

