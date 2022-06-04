Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B09153D450
	for <lists+kvm@lfdr.de>; Sat,  4 Jun 2022 03:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350176AbiFDBW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 21:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344995AbiFDBWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 21:22:20 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80145A162
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 18:21:45 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id x128-20020a628686000000b0051bbf64668cso3529692pfd.23
        for <kvm@vger.kernel.org>; Fri, 03 Jun 2022 18:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=OcXgy1m5p5sqn5wtDZ8wsO+JIR/leVCIH38Z60Ex5X4=;
        b=Z8BeYbpBnk3fRT+oQoXDJIV45+AAITMcG1fwWAtBHOhg971zT2buQ6HI6BIKj2wC4/
         5w8AawZqQB6En7PwH5jvqut0cyGrrCva1yZEMQXtU67i2jdnTEGczz3V1OyJGORkGcar
         GgG149Xh5k7BCNT3L9GEJ+8ptOZUfjhPBZQFzN3tggB2ewGEVIMkdSTl61wPQ6oQ6Ey4
         +C1QY2sFHpQmEkFWNxgNPqf7WhoEg+lE8N32drHCJZnhQuCl3VmW8QX6+Z8I5BQ1ispN
         8J99b+NSskjcu60lRTA6NnpsYZ6Huu15UOCkGUI6XfgfnIke3JMHx0spUo7tiUmN240h
         E9XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=OcXgy1m5p5sqn5wtDZ8wsO+JIR/leVCIH38Z60Ex5X4=;
        b=nqsWfLAAKOmuAAn9OpDBLcr0/U3loWfj1AH+ekKA4wz+PtUeZcQVFBBy5npMDbbdoj
         41DkJRqn1NLO7RwM2cAEU+XVDfWXEgg13RdBG/NgYZsDUZWo1hu6kDIksKs0+p4DRh23
         iFxq/MvJCmAU93hmD9A9Wd1iJzE4M8AYBfH254AvOtdVWhjXDpz7vzO5HfzExedRBw54
         A1K/90e/jWw62HI6saafwq4yEEEZIlZOCVaLRfgEWd4JdpOJpDzlDhFDeGEuYa+GTQEj
         iMk5m9EFURI0RLrFnGGOncxmMKBJmu7aM0MVgTg0jHVxQ3D1TG6W4MiB+eaglsBSFJz4
         J04w==
X-Gm-Message-State: AOAM533pODvQ2vazVv4cOCMh+TXa1CfQ3mRSp1ZVBR1Xuwz0+p3AhD5L
        60In+PJ6vXilJU/jG18Ynh/SgNvYKL4=
X-Google-Smtp-Source: ABdhPJy3JyTuuK0XewhL2Xaj/9GIODFtqH7peEmVOOTMI1SCPuhwfK5fzQ025pMsZDm/GGGk7P6eLTxTADk=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:7005:b0:163:ffe7:32eb with SMTP id
 y5-20020a170902700500b00163ffe732ebmr12771281plk.18.1654305691734; Fri, 03
 Jun 2022 18:21:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  4 Jun 2022 01:20:34 +0000
In-Reply-To: <20220604012058.1972195-1-seanjc@google.com>
Message-Id: <20220604012058.1972195-19-seanjc@google.com>
Mime-Version: 1.0
References: <20220604012058.1972195-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH 18/42] KVM: selftests: Cache CPUID in struct kvm_vcpu
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
index 93661d26ac4e..0eeae1dfbe63 100644
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
index 6b6a72693289..f170fd5f8726 100644
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
index d73d9eba2585..6a7949c8ba5d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -475,6 +475,11 @@ kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
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
@@ -504,6 +509,8 @@ static void vm_vcpu_rm(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	TEST_ASSERT(!ret,  __KVM_SYSCALL_ERROR("close()", ret));
 
 	list_del(&vcpu->list);
+
+	vcpu_arch_free(vcpu);
 	free(vcpu);
 }
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 05eac8134119..c252c7463970 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -649,7 +649,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id,
 				     DEFAULT_GUEST_STACK_VADDR_MIN);
 
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
-	vcpu_set_cpuid(vcpu, kvm_get_supported_cpuid());
+	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
 	vcpu_setup(vm, vcpu);
 
 	/* Setup guest general purpose registers */
@@ -670,11 +670,17 @@ struct kvm_vcpu *vm_arch_vcpu_recreate(struct kvm_vm *vm, uint32_t vcpu_id)
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
@@ -744,31 +750,23 @@ uint64_t kvm_get_feature_msr(uint64_t msr_index)
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
@@ -1286,7 +1284,7 @@ void vcpu_set_hv_cpuid(struct kvm_vcpu *vcpu)
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
2.36.1.255.ge46751e96f-goog

