Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30E9054BB36
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357509AbiFNUJp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:09:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357493AbiFNUJG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:09:06 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF0A4F1DF
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:12 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id w70-20020a638249000000b00406e420acfdso3682622pgd.2
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=98aCqm9xw9nDmwuzmU0jJimOnA/h6/nIweHPxTZxc5M=;
        b=Htt41QOGs2JjQff/mGVeHLvR5We5QXTnpyiTvfFcegzpA2lPTINGRU/6pViGqTgt6Y
         8pdris5VJYT/Ls2rcQrGIpihdKltRXLkXMstaD2NHRTif2RvfMq4VJxgbBL+9VufXNfY
         czFN/xb2gbxjY9EM3oMObGNVvZ1X3/w7amafpUyAytOM6f72ena38PB9JEtqY79VzhX2
         u/jIRO+lZaLvj+ohGScTBKVmkzxG7WZEOenXCtUEx+hTHbHB5/fadLUN+s5hzYVpHEnt
         4fS6wZ26PtdmhTeqkG1T6eZJQpUq692TiM2CX4WKlVEO3XsXfoLPz4UVeCZHz1ywlNuY
         iN3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=98aCqm9xw9nDmwuzmU0jJimOnA/h6/nIweHPxTZxc5M=;
        b=eaizDDpBZs+QzH4yh8cBW6wXcS/oBF/Yn8+rS79BR60hp5UwEG2Wh8rcdTzQdOMJfd
         9Xf/kcUrvT3bpQZdcxU44AKBmpNi6G1ZDk8Kw2Xq+g0mYSo9z716YYslDmAwjw0KcavU
         GnOFqrGXRNfbnJ+4rgpon/E98UhhKq9ih2V1uvdZYylTsgexO4DKijmN21cI7qimzNyQ
         j8i1F5LsLozt5Tcb5Lh8JVExNN1G4Aob9fLReFtDM1wQqqV0BukdQxZ3BISG8V1OPiFP
         l+Et0Rs3kbhI5XBemuab5Ptkqvbs5BjQyEW2rDr+9W6tTewEuIEV8QO1JSXFm6QtKNuA
         i62w==
X-Gm-Message-State: AOAM531XJphcKOz8KGc4tle+FxbqS0bd7EFZxzHBTOjN/4bj7C5+rhDb
        LJQ/k123M4IchAkhBripdXQovsm1/uo=
X-Google-Smtp-Source: ABdhPJwQQ7atUFm1lXFyaMmlSSBxIAGy8UPBgUtugEt3COcHtGRUcML0zRBsKKPA6eztUx9QAXg52AAygf0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:218c:b0:51c:c64:3f6a with SMTP id
 h12-20020a056a00218c00b0051c0c643f6amr6054245pfi.50.1655237286151; Tue, 14
 Jun 2022 13:08:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:55 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-31-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 30/42] KVM: selftests: Make get_supported_cpuid() returns "const"
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

Tag the returned CPUID pointers from kvm_get_supported_cpuid(),
kvm_get_supported_hv_cpuid(), and vcpu_get_supported_hv_cpuid() "const"
to prevent reintroducing the broken pattern of modifying the static
"cpuid" variable used by kvm_get_supported_cpuid() to cache the results
of KVM_GET_SUPPORTED_CPUID.

Update downstream consumers as needed.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  | 24 ++++++++---------
 .../selftests/kvm/lib/x86_64/processor.c      | 27 ++++++-------------
 .../testing/selftests/kvm/x86_64/cpuid_test.c | 12 ++++-----
 .../selftests/kvm/x86_64/hyperv_cpuid.c       | 10 +++----
 .../kvm/x86_64/pmu_event_filter_test.c        | 10 +++----
 .../selftests/kvm/x86_64/vmx_pmu_caps_test.c  |  2 +-
 6 files changed, 36 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 98d05e153fa3..617b437ce0f9 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -583,7 +583,9 @@ static inline void vcpu_xcrs_set(struct kvm_vcpu *vcpu, struct kvm_xcrs *xcrs)
 	vcpu_ioctl(vcpu, KVM_SET_XCRS, xcrs);
 }
 
-struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
+const struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
+const struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void);
+const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu);
 
 bool kvm_cpuid_has(const struct kvm_cpuid2 *cpuid,
 		   struct kvm_x86_cpu_feature feature);
@@ -616,15 +618,17 @@ static inline struct kvm_cpuid2 *allocate_kvm_cpuid2(int nr_entries)
 	return cpuid;
 }
 
-struct kvm_cpuid_entry2 *get_cpuid_entry(struct kvm_cpuid2 *cpuid,
-					 uint32_t function, uint32_t index);
-void vcpu_init_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid);
+const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
+					       uint32_t function, uint32_t index);
+void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid);
+void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu);
 
 static inline struct kvm_cpuid_entry2 *__vcpu_get_cpuid_entry(struct kvm_vcpu *vcpu,
 							      uint32_t function,
 							      uint32_t index)
 {
-	return get_cpuid_entry(vcpu->cpuid, function, index);
+	return (struct kvm_cpuid_entry2 *)get_cpuid_entry(vcpu->cpuid,
+							  function, index);
 }
 
 static inline struct kvm_cpuid_entry2 *vcpu_get_cpuid_entry(struct kvm_vcpu *vcpu,
@@ -676,14 +680,13 @@ static inline void vcpu_clear_cpuid_feature(struct kvm_vcpu *vcpu,
 	vcpu_set_or_clear_cpuid_feature(vcpu, feature, false);
 }
 
-static inline struct kvm_cpuid_entry2 *kvm_get_supported_cpuid_index(uint32_t function,
-								     uint32_t index)
+static inline const struct kvm_cpuid_entry2 *kvm_get_supported_cpuid_index(uint32_t function,
+									   uint32_t index)
 {
 	return get_cpuid_entry(kvm_get_supported_cpuid(), function, index);
 }
 
-static inline struct kvm_cpuid_entry2 *
-kvm_get_supported_cpuid_entry(uint32_t function)
+static inline const struct kvm_cpuid_entry2 *kvm_get_supported_cpuid_entry(uint32_t function)
 {
 	return kvm_get_supported_cpuid_index(function, 0);
 }
@@ -730,9 +733,6 @@ void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 		       uint64_t a3);
 
-struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void);
-void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu);
-struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu);
 void vm_xsave_req_perm(int bit);
 
 enum pg_level {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 2a878703dc3f..eb73c690edd9 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -676,18 +676,7 @@ void vcpu_arch_free(struct kvm_vcpu *vcpu)
 		free(vcpu->cpuid);
 }
 
-/*
- * KVM Supported CPUID Get
- *
- * Input Args: None
- *
- * Output Args:
- *
- * Return: The supported KVM CPUID
- *
- * Get the guest CPUID supported by KVM.
- */
-struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
+const struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 {
 	static struct kvm_cpuid2 *cpuid;
 	int kvm_fd;
@@ -745,7 +734,7 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
 	return buffer.entry.data;
 }
 
-void vcpu_init_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid)
+void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid)
 {
 	TEST_ASSERT(cpuid != vcpu->cpuid, "@cpuid can't be the vCPU's CPUID");
 
@@ -1079,7 +1068,7 @@ uint32_t kvm_get_cpuid_max_extended(void)
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 {
-	struct kvm_cpuid_entry2 *entry;
+	const struct kvm_cpuid_entry2 *entry;
 	bool pae;
 
 	/* SDM 4.1.4 */
@@ -1191,8 +1180,8 @@ void assert_on_unhandled_exception(struct kvm_vcpu *vcpu)
 	}
 }
 
-struct kvm_cpuid_entry2 *get_cpuid_entry(struct kvm_cpuid2 *cpuid,
-					 uint32_t function, uint32_t index)
+const struct kvm_cpuid_entry2 *get_cpuid_entry(const struct kvm_cpuid2 *cpuid,
+					       uint32_t function, uint32_t index)
 {
 	int i;
 
@@ -1218,7 +1207,7 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 	return r;
 }
 
-struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
+const struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
 {
 	static struct kvm_cpuid2 *cpuid;
 	int kvm_fd;
@@ -1238,7 +1227,7 @@ struct kvm_cpuid2 *kvm_get_supported_hv_cpuid(void)
 void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu)
 {
 	static struct kvm_cpuid2 *cpuid_full;
-	struct kvm_cpuid2 *cpuid_sys, *cpuid_hv;
+	const struct kvm_cpuid2 *cpuid_sys, *cpuid_hv;
 	int i, nent = 0;
 
 	if (!cpuid_full) {
@@ -1268,7 +1257,7 @@ void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_init_cpuid(vcpu, cpuid_full);
 }
 
-struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
+const struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid2 *cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
 
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 694583803468..2b8ac307da64 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -66,7 +66,7 @@ static void guest_main(struct kvm_cpuid2 *guest_cpuid)
 	GUEST_DONE();
 }
 
-static bool is_cpuid_mangled(struct kvm_cpuid_entry2 *entrie)
+static bool is_cpuid_mangled(const struct kvm_cpuid_entry2 *entrie)
 {
 	int i;
 
@@ -79,9 +79,10 @@ static bool is_cpuid_mangled(struct kvm_cpuid_entry2 *entrie)
 	return false;
 }
 
-static void compare_cpuids(struct kvm_cpuid2 *cpuid1, struct kvm_cpuid2 *cpuid2)
+static void compare_cpuids(const struct kvm_cpuid2 *cpuid1,
+			   const struct kvm_cpuid2 *cpuid2)
 {
-	struct kvm_cpuid_entry2 *e1, *e2;
+	const struct kvm_cpuid_entry2 *e1, *e2;
 	int i;
 
 	TEST_ASSERT(cpuid1->nent == cpuid2->nent,
@@ -175,7 +176,6 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 
 int main(void)
 {
-	struct kvm_cpuid2 *supp_cpuid;
 	struct kvm_vcpu *vcpu;
 	vm_vaddr_t cpuid_gva;
 	struct kvm_vm *vm;
@@ -183,9 +183,7 @@ int main(void)
 
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
-	supp_cpuid = kvm_get_supported_cpuid();
-
-	compare_cpuids(supp_cpuid, vcpu->cpuid);
+	compare_cpuids(kvm_get_supported_cpuid(), vcpu->cpuid);
 
 	vcpu_alloc_cpuid(vm, &cpuid_gva, vcpu->cpuid);
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
index c406b95cba9b..e804eb08dff9 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_cpuid.c
@@ -43,7 +43,7 @@ static bool smt_possible(void)
 	return res;
 }
 
-static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
+static void test_hv_cpuid(const struct kvm_cpuid2 *hv_cpuid_entries,
 			  bool evmcs_expected)
 {
 	int i;
@@ -56,7 +56,7 @@ static void test_hv_cpuid(struct kvm_cpuid2 *hv_cpuid_entries,
 		    nent_expected, hv_cpuid_entries->nent);
 
 	for (i = 0; i < hv_cpuid_entries->nent; i++) {
-		struct kvm_cpuid_entry2 *entry = &hv_cpuid_entries->entries[i];
+		const struct kvm_cpuid_entry2 *entry = &hv_cpuid_entries->entries[i];
 
 		TEST_ASSERT((entry->function >= 0x40000000) &&
 			    (entry->function <= 0x40000082),
@@ -131,7 +131,7 @@ void test_hv_cpuid_e2big(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 int main(int argc, char *argv[])
 {
 	struct kvm_vm *vm;
-	struct kvm_cpuid2 *hv_cpuid_entries;
+	const struct kvm_cpuid2 *hv_cpuid_entries;
 	struct kvm_vcpu *vcpu;
 
 	/* Tell stdout not to buffer its content */
@@ -146,7 +146,7 @@ int main(int argc, char *argv[])
 
 	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vcpu);
 	test_hv_cpuid(hv_cpuid_entries, false);
-	free(hv_cpuid_entries);
+	free((void *)hv_cpuid_entries);
 
 	if (!kvm_cpu_has(X86_FEATURE_VMX) ||
 	    !kvm_has_cap(KVM_CAP_HYPERV_ENLIGHTENED_VMCS)) {
@@ -156,7 +156,7 @@ int main(int argc, char *argv[])
 	vcpu_enable_evmcs(vcpu);
 	hv_cpuid_entries = vcpu_get_supported_hv_cpuid(vcpu);
 	test_hv_cpuid(hv_cpuid_entries, true);
-	free(hv_cpuid_entries);
+	free((void *)hv_cpuid_entries);
 
 do_sys:
 	/* Test system ioctl version */
diff --git a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
index 786b3a794f84..090d9c5e1c14 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_event_filter_test.c
@@ -384,7 +384,7 @@ static void test_pmu_config_disable(void (*guest_code)(void))
  * counter per logical processor, an EBX bit vector of length greater
  * than 5, and EBX[5] clear.
  */
-static bool check_intel_pmu_leaf(struct kvm_cpuid_entry2 *entry)
+static bool check_intel_pmu_leaf(const struct kvm_cpuid_entry2 *entry)
 {
 	union cpuid10_eax eax = { .full = entry->eax };
 	union cpuid10_ebx ebx = { .full = entry->ebx };
@@ -400,10 +400,10 @@ static bool check_intel_pmu_leaf(struct kvm_cpuid_entry2 *entry)
  */
 static bool use_intel_pmu(void)
 {
-	struct kvm_cpuid_entry2 *entry;
+	const struct kvm_cpuid_entry2 *entry;
 
 	entry = kvm_get_supported_cpuid_index(0xa, 0);
-	return is_intel_cpu() && entry && check_intel_pmu_leaf(entry);
+	return is_intel_cpu() && check_intel_pmu_leaf(entry);
 }
 
 static bool is_zen1(uint32_t eax)
@@ -432,10 +432,10 @@ static bool is_zen3(uint32_t eax)
  */
 static bool use_amd_pmu(void)
 {
-	struct kvm_cpuid_entry2 *entry;
+	const struct kvm_cpuid_entry2 *entry;
 
 	entry = kvm_get_supported_cpuid_index(1, 0);
-	return is_amd_cpu() && entry &&
+	return is_amd_cpu() &&
 		(is_zen1(entry->eax) ||
 		 is_zen2(entry->eax) ||
 		 is_zen3(entry->eax));
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
index dc3869d5aff0..689517f2aae6 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_pmu_caps_test.c
@@ -53,7 +53,7 @@ static void guest_code(void)
 
 int main(int argc, char *argv[])
 {
-	struct kvm_cpuid_entry2 *entry_a_0;
+	const struct kvm_cpuid_entry2 *entry_a_0;
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
 	int ret;
-- 
2.36.1.476.g0c4daa206d-goog

