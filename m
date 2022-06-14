Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A5754BB3D
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 22:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353684AbiFNUIo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 16:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357224AbiFNUIA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 16:08:00 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6C3B27B04
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:45 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 190-20020a6306c7000000b004089a651e4eso2362351pgg.20
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 13:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=hHYs1CgMxsK1k9Vi8KGsv4zPtK7ZFwYVZyJnd/Yk1Cg=;
        b=bU+bgH83cUlJY1z4QcN203bnumc5dy54FGYc/+DggICznvnhV6ETc2yhry4U9Pnt4x
         1xUi3R1JKWYjiwYY/9UaR1GQCHXFsNYK00kFoom/OI3xO2u1EJ/kQAiOZSS2N9S4rQRh
         /xUzCP1F5iU1PGV7LksybFeL+3UCKaga4tTqrLUvzHaD4/GK8yISDR1FhHfEQ78+OBeY
         8ur+WTTf8cB03jc3vNEDjnbN0bGyt+y0JHtTKpp64KpxoJPRa/NWf+hj7r1vnfx16fMg
         5RcqwH2Zgi1Y8jqRFUNinwUtIjk6a6J247pmyX2nxL4Fe0iY4ovbegdZgN7RtPtvDUj/
         doew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=hHYs1CgMxsK1k9Vi8KGsv4zPtK7ZFwYVZyJnd/Yk1Cg=;
        b=yl9i9lhphQ0m9d8vUvZnLs9uvZdUfxLuYc8BbM00u0vMhQlEbHROsF8BKilk+5n915
         YEbqMCcw8mM8eY53S7Wtl7rNEQrqg0dHoNDHPLAjp3W11QxpDot6HEHobPmkMfwozNNv
         15aDhXlfAoGhgXTTD3XOzWVX3rbhQWYLcFEWbFmtJGqpiSNpN7cB5eOkDIFxJSbn72Zt
         q9lvsNGX7elmJ4TCHwA5yZrhj6BdXLYBiyhNETk+q+h7d1DkHN0waZbUYoLVgIefW7hn
         gePy7FMAF+0283RKRYr1iXRpurDQqFY2g39ZRQlcfQRg83qV0puLHCydBovF5zbD1+O8
         fqTQ==
X-Gm-Message-State: AJIora92yyp+oi3nrBq5kHFkKV5TRkAjIMadk2J1j14aoiGbp1Tl8wJt
        etgpPnDsMTTYllNL/C2kspQUaOaphgM=
X-Google-Smtp-Source: AGRyM1uexK/G9eM66+Bh90bg2qJEgX6hlOeW++qr81Wyz/Vh85kDzcrQsKIsv3T5iZDK+iqR0hIIcp+LQeI=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:178f:b0:1e3:3ba:c185 with SMTP id
 q15-20020a17090a178f00b001e303bac185mr192376pja.1.1655237264941; Tue, 14 Jun
 2022 13:07:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Jun 2022 20:06:43 +0000
In-Reply-To: <20220614200707.3315957-1-seanjc@google.com>
Message-Id: <20220614200707.3315957-19-seanjc@google.com>
Mime-Version: 1.0
References: <20220614200707.3315957-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v2 18/42] KVM: selftests: Cache CPUID in struct kvm_vcpu
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

Cache a vCPU's CPUID information in "struct kvm_vcpu" to allow fixing the
mess where tests, often unknowingly, modify the global/static "cpuid"
allocated by kvm_get_supported_cpuid().

Add vcpu_init_cpuid() to handle stuffing an entirely different CPUID
model, e.g. during vCPU creation or when switching to the Hyper-V enabled
CPUID model.  Automatically refresh the cache on vcpu_set_cpuid() so that
any adjustments made by KVM are always reflected in the cache.  Drop
vcpu_get_cpuid() entirely to force tests to use the cache, and to allow
adding e.g. vcpu_get_cpuid_entry() in the future without creating a
conflicting set of APIs where vcpu_get_cpuid() does KVM_GET_CPUID2, but
vcpu_get_cpuid_entry() does not.

Opportunistically convert the VMX nested state test and KVM PV test to
manipulating the vCPU's CPUID (because it's easy), but use
vcpu_init_cpuid() for the Hyper-V features test and "emulator error" test
to effectively retain their current behavior as they're less trivial to
convert.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  5 +++
 .../selftests/kvm/include/x86_64/processor.h  | 25 +++++++----
 tools/testing/selftests/kvm/lib/kvm_util.c    |  7 ++++
 .../selftests/kvm/lib/x86_64/processor.c      | 42 +++++++++----------
 .../testing/selftests/kvm/x86_64/cpuid_test.c | 18 ++++----
 .../kvm/x86_64/emulator_error_test.c          |  2 +-
 .../selftests/kvm/x86_64/hyperv_features.c    |  2 +-
 .../selftests/kvm/x86_64/kvm_pv_test.c        |  6 +--
 .../kvm/x86_64/vmx_set_nested_state_test.c    |  6 +--
 .../selftests/kvm/x86_64/xapic_state_test.c   |  4 +-
 10 files changed, 68 insertions(+), 49 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 1b9e8719c624..a344ec2afe03 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -50,6 +50,9 @@ struct kvm_vcpu {
 	int fd;
 	struct kvm_vm *vm;
 	struct kvm_run *run;
+#ifdef __x86_64__
+	struct kvm_cpuid2 *cpuid;
+#endif
 	struct kvm_dirty_gfn *dirty_gfns;
 	uint32_t fetch_index;
 	uint32_t dirty_gfns_count;
@@ -690,6 +693,8 @@ static inline struct kvm_vcpu *vm_vcpu_recreate(struct kvm_vm *vm,
 	return vm_arch_vcpu_recreate(vm, vcpu_id);
 }
 
+void vcpu_arch_free(struct kvm_vcpu *vcpu);
+
 void virt_arch_pgd_alloc(struct kvm_vm *vm);
 
 static inline void virt_pgd_alloc(struct kvm_vm *vm)
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 002ed02cc2ef..7c14e5ffd515 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -616,18 +616,29 @@ static inline struct kvm_cpuid2 *allocate_kvm_cpuid2(int nr_entries)
 	return cpuid;
 }
 
-struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vcpu *vcpu);
+void vcpu_init_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid);
 
-static inline int __vcpu_set_cpuid(struct kvm_vcpu *vcpu,
-				   struct kvm_cpuid2 *cpuid)
+static inline int __vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 {
-	return __vcpu_ioctl(vcpu, KVM_SET_CPUID2, cpuid);
+	int r;
+
+	TEST_ASSERT(vcpu->cpuid, "Must do vcpu_init_cpuid() first");
+	r = __vcpu_ioctl(vcpu, KVM_SET_CPUID2, vcpu->cpuid);
+	if (r)
+		return r;
+
+	/* On success, refresh the cache to pick up adjustments made by KVM. */
+	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
+	return 0;
 }
 
-static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu,
-				  struct kvm_cpuid2 *cpuid)
+static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 {
-	vcpu_ioctl(vcpu, KVM_SET_CPUID2, cpuid);
+	TEST_ASSERT(vcpu->cpuid, "Must do vcpu_init_cpuid() first");
+	vcpu_ioctl(vcpu, KVM_SET_CPUID2, vcpu->cpuid);
+
+	/* Refresh the cache to pick up adjustments made by KVM. */
+	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
 }
 
 struct kvm_cpuid_entry2 *
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 38c6083c9ce1..4da0f7b7985d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -476,6 +476,11 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 	return &region->region;
 }
 
+__weak void vcpu_arch_free(struct kvm_vcpu *vcpu)
+{
+
+}
+
 /*
  * VM VCPU Remove
  *
@@ -505,6 +510,8 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
 
 	list_del(&vcpu->list);
+
+	vcpu_arch_free(vcpu);
 	free(vcpu);
 }
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index e9a2c606c6c3..55838c603102 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -648,7 +648,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				     DEFAULT_GUEST_STACK_VADDR_MIN);
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
-	vcpu_set_cpuid(vcpu, kvm_get_supported_cpuid());
+	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
 	vcpu_setup(vm, vcpu);
 
 	/* Setup guest general purpose registers */
@@ -669,11 +669,17 @@ struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, uint32_t vcpu_id)
 {
 	struct kvm_vcpu *vcpu = __vm_vcpu_add(vm, vcpu_id);
 
-	vcpu_set_cpuid(vcpu, kvm_get_supported_cpuid());
+	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
 
 	return vcpu;
 }
 
+void vcpu_arch_free(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->cpuid)
+		free(vcpu->cpuid);
+}
+
 /*
  * KVM Supported CPUID Get
  *
@@ -743,31 +749,23 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
 	return buffer.entry.data;
 }
 
-struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vcpu *vcpu)
+void vcpu_init_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid)
 {
-	struct kvm_cpuid2 *cpuid;
-	int max_ent;
-	int rc = -1;
+	TEST_ASSERT(cpuid != vcpu->cpuid, "@cpuid can't be the vCPU's CPUID");
 
-	cpuid = allocate_kvm_cpuid2(MAX_NR_CPUID_ENTRIES);
-	max_ent = cpuid->nent;
-
-	for (cpuid->nent = 1; cpuid->nent <= max_ent; cpuid->nent++) {
-		rc = __vcpu_ioctl(vcpu, KVM_GET_CPUID2, cpuid);
-		if (!rc)
-			break;
-
-		TEST_ASSERT(rc == -1 && errno == E2BIG,
-			    "KVM_GET_CPUID2 should either succeed or give E2BIG: %d %d",
-			    rc, errno);
+	/* Allow overriding the default CPUID. */
+	if (vcpu->cpuid && vcpu->cpuid->nent < cpuid->nent) {
+		free(vcpu->cpuid);
+		vcpu->cpuid = NULL;
 	}
 
-	TEST_ASSERT(!rc, KVM_IOCTL_ERROR(KVM_GET_CPUID2, rc));
-	return cpuid;
+	if (!vcpu->cpuid)
+		vcpu->cpuid = allocate_kvm_cpuid2(cpuid->nent);
+
+	memcpy(vcpu->cpuid, cpuid, kvm_cpuid2_size(cpuid->nent));
+	vcpu_set_cpuid(vcpu);
 }
 
-
-
 /*
  * Locate a cpuid entry.
  *
@@ -1285,7 +1283,7 @@ void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu)
 		cpuid_full->nent = nent + cpuid_hv->nent;
 	}
 
-	vcpu_set_cpuid(vcpu, cpuid_full);
+	vcpu_init_cpuid(vcpu, cpuid_full);
 }
 
 struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vcpu *vcpu)
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index dac5b1ebb512..ca36557646b0 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -145,21 +145,22 @@ struct kvm_cpuid2 *vcpu_alloc_cpuid(struct kvm_vm *vm, vm_vaddr_t *p_gva, struct
 	return guest_cpuids;
 }
 
-static void set_cpuid_after_run(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid)
+static void set_cpuid_after_run(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpuid2 *cpuid = vcpu->cpuid;
 	struct kvm_cpuid_entry2 *ent;
 	int rc;
 	u32 eax, ebx, x;
 
 	/* Setting unmodified CPUID is allowed */
-	rc = __vcpu_set_cpuid(vcpu, cpuid);
+	rc = __vcpu_set_cpuid(vcpu);
 	TEST_ASSERT(!rc, "Setting unmodified CPUID after KVM_RUN failed: %d", rc);
 
 	/* Changing CPU features is forbidden */
 	ent = get_cpuid(cpuid, 0x7, 0);
 	ebx = ent->ebx;
 	ent->ebx--;
-	rc = __vcpu_set_cpuid(vcpu, cpuid);
+	rc = __vcpu_set_cpuid(vcpu);
 	TEST_ASSERT(rc, "Changing CPU features should fail");
 	ent->ebx = ebx;
 
@@ -168,14 +169,14 @@ static void set_cpuid_after_run(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid)
 	eax = ent->eax;
 	x = eax & 0xff;
 	ent->eax = (eax & ~0xffu) | (x - 1);
-	rc = __vcpu_set_cpuid(vcpu, cpuid);
+	rc = __vcpu_set_cpuid(vcpu);
 	TEST_ASSERT(rc, "Changing MAXPHYADDR should fail");
 	ent->eax = eax;
 }
 
 int main(void)
 {
-	struct kvm_cpuid2 *supp_cpuid, *cpuid2;
+	struct kvm_cpuid2 *supp_cpuid;
 	struct kvm_vcpu *vcpu;
 	vm_vaddr_t cpuid_gva;
 	struct kvm_vm *vm;
@@ -184,18 +185,17 @@ int main(void)
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 
 	supp_cpuid = kvm_get_supported_cpuid();
-	cpuid2 = vcpu_get_cpuid(vcpu);
 
-	compare_cpuids(supp_cpuid, cpuid2);
+	compare_cpuids(supp_cpuid, vcpu->cpuid);
 
-	vcpu_alloc_cpuid(vm, &cpuid_gva, cpuid2);
+	vcpu_alloc_cpuid(vm, &cpuid_gva, vcpu->cpuid);
 
 	vcpu_args_set(vcpu, 1, cpuid_gva);
 
 	for (stage = 0; stage < 3; stage++)
 		run_vcpu(vcpu, stage);
 
-	set_cpuid_after_run(vcpu, cpuid2);
+	set_cpuid_after_run(vcpu);
 
 	kvm_vm_free(vm);
 }
diff --git a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
index bfff2d271c48..bb410c359599 100644
--- a/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
+++ b/tools/testing/selftests/kvm/x86_64/emulator_error_test.c
@@ -172,7 +172,7 @@ int main(int argc, char *argv[])
 	entry->eax = (entry->eax & 0xffffff00) | MAXPHYADDR;
 	set_cpuid(cpuid, entry);
 
-	vcpu_set_cpuid(vcpu, cpuid);
+	vcpu_init_cpuid(vcpu, cpuid);
 
 	rc = kvm_check_cap(KVM_CAP_EXIT_ON_EMULATION_FAILURE);
 	TEST_ASSERT(rc, "KVM_CAP_EXIT_ON_EMULATION_FAILURE is unavailable");
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index d5f37495ade8..f08f51bad68b 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -161,7 +161,7 @@ static void hv_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		    "failed to set HYPERV_CPUID_ENLIGHTMENT_INFO leaf");
 	TEST_ASSERT(set_cpuid(cpuid, dbg),
 		    "failed to set HYPERV_CPUID_SYNDBG_PLATFORM_CAPABILITIES leaf");
-	vcpu_set_cpuid(vcpu, cpuid);
+	vcpu_init_cpuid(vcpu, cpuid);
 }
 
 static void guest_test_msrs_access(void)
diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 5901ccec7079..e3bb9b803944 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -200,7 +200,6 @@ static void enter_guest(struct kvm_vcpu *vcpu)
 
 int main(void)
 {
-	struct kvm_cpuid2 *best;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 
@@ -210,9 +209,8 @@ int main(void)
 
 	vcpu_enable_cap(vcpu, KVM_CAP_ENFORCE_PV_FEATURE_CPUID, 1);
 
-	best = kvm_get_supported_cpuid();
-	clear_kvm_cpuid_features(best);
-	vcpu_set_cpuid(vcpu, best);
+	clear_kvm_cpuid_features(vcpu->cpuid);
+	vcpu_set_cpuid(vcpu);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vcpu);
diff --git a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
index 66cb2d0054e6..1cf78ec007f2 100644
--- a/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
@@ -121,7 +121,7 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
 	test_nested_state(vcpu, state);
 
 	/* Enable VMX in the guest CPUID. */
-	vcpu_set_cpuid(vcpu, kvm_get_supported_cpuid());
+	vcpu_set_cpuid(vcpu);
 
 	/*
 	 * Setting vmxon_pa == -1ull and vmcs_pa == -1ull exits early without
@@ -245,7 +245,7 @@ void test_vmx_nested_state(struct kvm_vcpu *vcpu)
 
 void disable_vmx(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpuid2 *cpuid = kvm_get_supported_cpuid();
+	struct kvm_cpuid2 *cpuid = vcpu->cpuid;
 	int i;
 
 	for (i = 0; i < cpuid->nent; ++i)
@@ -255,7 +255,7 @@ void disable_vmx(struct kvm_vcpu *vcpu)
 	TEST_ASSERT(i != cpuid->nent, "CPUID function 1 not found");
 
 	cpuid->entries[i].ecx &= ~CPUID_VMX;
-	vcpu_set_cpuid(vcpu, cpuid);
+	vcpu_set_cpuid(vcpu);
 	cpuid->entries[i].ecx |= CPUID_VMX;
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
index 5c5dc7bbb4e2..7728730c2dda 100644
--- a/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xapic_state_test.c
@@ -138,13 +138,13 @@ int main(int argc, char *argv[])
 	vm = vm_create_with_one_vcpu(&x.vcpu, xapic_guest_code);
 	x.is_x2apic = false;
 
-	cpuid = vcpu_get_cpuid(x.vcpu);
+	cpuid = x.vcpu->cpuid;
 	for (i = 0; i < cpuid->nent; i++) {
 		if (cpuid->entries[i].function == 1)
 			break;
 	}
 	cpuid->entries[i].ecx &= ~BIT(21);
-	vcpu_set_cpuid(x.vcpu, cpuid);
+	vcpu_set_cpuid(x.vcpu);
 
 	virt_pg_map(vm, APIC_DEFAULT_GPA, APIC_DEFAULT_GPA);
 	test_icr(&x);
-- 
2.36.1.476.g0c4daa206d-goog

