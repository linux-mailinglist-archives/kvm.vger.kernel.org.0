Return-Path: <kvm+bounces-27278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A6A697E26B
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 18:18:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2CFDA1F21461
	for <lists+kvm@lfdr.de>; Sun, 22 Sep 2024 16:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF8D2576F;
	Sun, 22 Sep 2024 16:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kRenC6FD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C4D1C695
	for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 16:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727021891; cv=none; b=M/+MY3bDsfAvTpFkKrHZKOpfubDPMj0b/JDqGo7N63Wj2yiSWFkB4sAQ8eaWaBKS2gElcptFHK1BJMhqDHZw1wQQuThH2acexxmv52R7kkSGtWUqADVj0wXkQqsL3FWtNsRoGp9EfiwSM/gXKj14nqmtE1Cj8kwxBTgEW5Rnn2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727021891; c=relaxed/simple;
	bh=l+pHHFaaTt0v8pBAAKbKlDUDZo041W6MKNZhaK3bKtI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WGToaMRZGe+aFvbLMsDOrPAscTV5mjAJZjjp6M8z4gccQNMqsLu9Fpr1Y06oWDvvARKP9+yOFv70lv8hyNSoKABt3g3PmyNU15j4q1wFR8g1Kk/fGEI1YeJ4GtJkuX598LQk/YHa0OwlFfB0XKsLesQS3jqdwg6fcuW5AEN0lXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kRenC6FD; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-207510f3242so46919625ad.0
        for <kvm@vger.kernel.org>; Sun, 22 Sep 2024 09:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727021889; x=1727626689; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8C0hzk3cftIt6mgnsy72jgk6JMieI7UypLC5PItOVw=;
        b=kRenC6FDlisiR0LIXr9EZid0GCVay9zER9psxiZ2U02GiCleEsNYlQEqWa0lKpec0N
         sfz+uFq06RPGxvHs6xMjf+3kdSBv9HRuRTjtefg6SPyQs6n2nMTOqQOuMtGqAysGCBvm
         jw8/Y7eamrlqa4vLhfdzAOHyGXorms/4uyJbGByi9zlxZnOuP/hF4Sw00q0SYLRSzcnI
         7tCfosBqTsjCBIHjr9jf+ockMs+ojZOTzmpgJ69ZRHVaJ8mJBRkkf6H0vharWx776xKo
         Qtx3qkLnzWZgi4FgDF5/GF8WycGm4ceBnnvIXisMAfVUkNw+1FwvBNrIfB8Ii3YNS6za
         KYCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727021889; x=1727626689;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8C0hzk3cftIt6mgnsy72jgk6JMieI7UypLC5PItOVw=;
        b=v+3hEMrMHH7MrpGPJxOETgykEXuiYpcPTySCsI7Ehn2wQGb9UBfUqjp03UrJqbrrSM
         t7Kbcdm+WVMnUeLeCsIldyyfKiYkyVqWXFUneyP4P5FYIWl0aeN5gLdDNHIMKE3eVisv
         ymnYTHS9mYrXgSVCOZj20ve+FrvFOb507ukp6n7jyViHOgEIdwDDJXhy4za9+jqkwGt+
         CV54aWywfhrJvoCURie7nGrJVaquxzj635hFAQd6FcBEChZ5egQShSNenq2ijIfiGMnw
         xjiQvBmHJeYGyBMgXBJuyPUCUJ5SmKLov5H8q2Jqg/+kXlE8NxlpeKhKSC7h1k49tWe4
         HIyQ==
X-Gm-Message-State: AOJu0YzKDuMx9xKCZNk8JnK4XX85tPGIllgOao/pIvwy/+hOvLDKNKFW
	Qvjq+IhykmAjVyeVzOvAy0s6j26QB15u139e1kWS53OnORXzD/MzhIHn5pVoRXKfQNEwwyPjOZ8
	jNw==
X-Google-Smtp-Source: AGHT+IEosLx2lddQGGIDPXkRP/2Rd2dCs7XcOgrC4ORS29XnzMIqTpa4/aNZsQ/utBFHJOxiR3G+rfv6gqs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e543:b0:206:c5ec:1445 with SMTP id
 d9443c01a7336-208d8549200mr2148095ad.8.1727021888940; Sun, 22 Sep 2024
 09:18:08 -0700 (PDT)
Date: Sun, 22 Sep 2024 09:17:58 -0700
In-Reply-To: <20240920154422.2890096-1-vkuznets@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240920154422.2890096-1-vkuznets@redhat.com>
Message-ID: <ZvBDNpFG6SbDYDDl@google.com>
Subject: Re: [PATCH] KVM: selftests: x86: Avoid using SSE/AVX instructions
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Jan Richter <jarichte@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Sep 20, 2024, Vitaly Kuznetsov wrote:
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 48d32c5aa3eb..3f1b24ed7245 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -238,6 +238,7 @@ CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
>  	-fno-stack-protector -fno-PIE -I$(LINUX_TOOL_INCLUDE) \
>  	-I$(LINUX_TOOL_ARCH_INCLUDE) -I$(LINUX_HDR_PATH) -Iinclude \
>  	-I$(<D) -Iinclude/$(ARCH_DIR) -I ../rseq -I.. $(EXTRA_CFLAGS) \
> +	-march=x86-64-v2 \

I would rather go straight to playing nice with AVX.  Not because I care about
being able to use AVX, but because pretty much every instance where KVM selftests
punts setup to individual tests eventually leads to gross copy+paste code.

The diff ends up being bigger than I was hoping, but that's largely because tests
are already manually enabling stuff in XCR0 (see above copy+paste complaint).

I can post the below later this week (probably as multiple patches).

Note, -march=x86-64-v3 is there just to make it easy to test, I won't actually
include that in the patches :-)

---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/x86_64/processor.h  |  5 ++++
 .../selftests/kvm/lib/x86_64/processor.c      | 24 +++++++++++++++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 23 ++++--------------
 .../testing/selftests/kvm/x86_64/cpuid_test.c |  6 ++++-
 .../selftests/kvm/x86_64/sev_smoke_test.c     | 11 ---------
 .../testing/selftests/kvm/x86_64/state_test.c |  5 ----
 .../selftests/kvm/x86_64/xcr0_cpuid_test.c    | 11 ++++++---
 8 files changed, 47 insertions(+), 39 deletions(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 960cf6a77198..7ef4b3cc403d 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -238,6 +238,7 @@ else
 LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
 endif
 CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
+	-march=x86-64-v3 \
 	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
 	-fno-builtin-memcmp -fno-builtin-memcpy \
 	-fno-builtin-memset -fno-builtin-strnlen \
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e247f99e0473..645200e95f89 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1049,6 +1049,11 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
 }
 
+static inline void vcpu_get_cpuid(struct kvm_vcpu *vcpu)
+{
+	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
+}
+
 void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
 			     struct kvm_x86_cpu_property property,
 			     uint32_t value);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 974bcd2df6d7..636b29ba8985 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -506,6 +506,8 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 
 	sregs.cr0 = X86_CR0_PE | X86_CR0_NE | X86_CR0_PG;
 	sregs.cr4 |= X86_CR4_PAE | X86_CR4_OSFXSR;
+	if (kvm_cpu_has(X86_FEATURE_XSAVE))
+		sregs.cr4 |= X86_CR4_OSXSAVE;
 	sregs.efer |= (EFER_LME | EFER_LMA | EFER_NX);
 
 	kvm_seg_set_unusable(&sregs.ldt);
@@ -519,6 +521,20 @@ static void vcpu_init_sregs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
 	vcpu_sregs_set(vcpu, &sregs);
 }
 
+static void vcpu_init_xcrs(struct kvm_vm *vm, struct kvm_vcpu *vcpu)
+{
+	struct kvm_xcrs xcrs = {
+		.nr_xcrs = 1,
+		.xcrs[0].xcr = 0,
+		.xcrs[0].value = kvm_cpu_supported_xcr0(),
+	};
+
+	if (!kvm_cpu_has(X86_FEATURE_XSAVE))
+		return;
+
+	vcpu_xcrs_set(vcpu, &xcrs);
+}
+
 static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 			  int dpl, unsigned short selector)
 {
@@ -675,6 +691,7 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	vcpu = __vm_vcpu_add(vm, vcpu_id);
 	vcpu_init_cpuid(vcpu, kvm_get_supported_cpuid());
 	vcpu_init_sregs(vm, vcpu);
+	vcpu_init_xcrs(vm, vcpu);
 
 	/* Setup guest general purpose registers */
 	vcpu_regs_get(vcpu, &regs);
@@ -686,6 +703,13 @@ struct kvm_vcpu *vm_arch_vcpu_add(struct kvm_vm *vm, uint32_t vcpu_id)
 	mp_state.mp_state = 0;
 	vcpu_mp_state_set(vcpu, &mp_state);
 
+	/*
+	 * Refresh CPUID after setting SREGS and XCR0, so that KVM's "runtime"
+	 * updates to guest CPUID, e.g. for OSXSAVE and XSAVE state size, are
+	 * reflected into selftests' vCPU CPUID cache, i.e. so that the cache
+	 * is consistent with vCPU state.
+	 */
+	vcpu_get_cpuid(vcpu);
 	return vcpu;
 }
 
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 903940c54d2d..f4ce5a185a7d 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -86,6 +86,8 @@ static inline void __xsavec(struct xstate *xstate, uint64_t rfbm)
 
 static void check_xtile_info(void)
 {
+	GUEST_ASSERT((xgetbv(0) & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE);
+
 	GUEST_ASSERT(this_cpu_has_p(X86_PROPERTY_XSTATE_MAX_SIZE_XCR0));
 	GUEST_ASSERT(this_cpu_property(X86_PROPERTY_XSTATE_MAX_SIZE_XCR0) <= XSAVE_SIZE);
 
@@ -122,29 +124,12 @@ static void set_tilecfg(struct tile_config *cfg)
 	}
 }
 
-static void init_regs(void)
-{
-	uint64_t cr4, xcr0;
-
-	GUEST_ASSERT(this_cpu_has(X86_FEATURE_XSAVE));
-
-	/* turn on CR4.OSXSAVE */
-	cr4 = get_cr4();
-	cr4 |= X86_CR4_OSXSAVE;
-	set_cr4(cr4);
-	GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
-
-	xcr0 = xgetbv(0);
-	xcr0 |= XFEATURE_MASK_XTILE;
-	xsetbv(0x0, xcr0);
-	GUEST_ASSERT((xgetbv(0) & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE);
-}
-
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 						    struct tile_data *tiledata,
 						    struct xstate *xstate)
 {
-	init_regs();
+	GUEST_ASSERT(this_cpu_has(X86_FEATURE_XSAVE) &&
+		     this_cpu_has(X86_FEATURE_OSXSAVE));
 	check_xtile_info();
 	GUEST_SYNC(1);
 
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 8c579ce714e9..e79a6577254f 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -37,7 +37,11 @@ static void test_guest_cpuids(struct kvm_cpuid2 *guest_cpuid)
 
 		GUEST_ASSERT_EQ(eax, guest_cpuid->entries[i].eax);
 		GUEST_ASSERT_EQ(ebx, guest_cpuid->entries[i].ebx);
-		GUEST_ASSERT_EQ(ecx, guest_cpuid->entries[i].ecx);
+		__GUEST_ASSERT(ecx == guest_cpuid->entries[i].ecx,
+			       "CPUID.0x%x.0x%x.ECX 0%x != 0x%x",
+			       guest_cpuid->entries[i].function,
+			       guest_cpuid->entries[i].index,
+			       ecx, guest_cpuid->entries[i].ecx);
 		GUEST_ASSERT_EQ(edx, guest_cpuid->entries[i].edx);
 	}
 
diff --git a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
index 2e9197eb1652..59a5a2227944 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_smoke_test.c
@@ -70,12 +70,6 @@ static void test_sync_vmsa(uint32_t policy)
 
 	double x87val = M_PI;
 	struct kvm_xsave __attribute__((aligned(64))) xsave = { 0 };
-	struct kvm_sregs sregs;
-	struct kvm_xcrs xcrs = {
-		.nr_xcrs = 1,
-		.xcrs[0].xcr = 0,
-		.xcrs[0].value = XFEATURE_MASK_X87_AVX,
-	};
 
 	vm = vm_sev_create_with_one_vcpu(KVM_X86_SEV_ES_VM, guest_code_xsave, &vcpu);
 	gva = vm_vaddr_alloc_shared(vm, PAGE_SIZE, KVM_UTIL_MIN_VADDR,
@@ -84,11 +78,6 @@ static void test_sync_vmsa(uint32_t policy)
 
 	vcpu_args_set(vcpu, 1, gva);
 
-	vcpu_sregs_get(vcpu, &sregs);
-	sregs.cr4 |= X86_CR4_OSFXSR | X86_CR4_OSXSAVE;
-	vcpu_sregs_set(vcpu, &sregs);
-
-	vcpu_xcrs_set(vcpu, &xcrs);
 	asm("fninit\n"
 	    "vpcmpeqb %%ymm4, %%ymm4, %%ymm4\n"
 	    "fldl %3\n"
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index 1c756db329e5..141b7fc0c965 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -145,11 +145,6 @@ static void __attribute__((__flatten__)) guest_code(void *arg)
 
 		memset(buffer, 0xcc, sizeof(buffer));
 
-		set_cr4(get_cr4() | X86_CR4_OSXSAVE);
-		GUEST_ASSERT(this_cpu_has(X86_FEATURE_OSXSAVE));
-
-		xsetbv(0, xgetbv(0) | supported_xcr0);
-
 		/*
 		 * Modify state for all supported xfeatures to take them out of
 		 * their "init" state, i.e. to make them show up in XSTATE_BV.
diff --git a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
index 95ce192d0753..c8a5c5e51661 100644
--- a/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xcr0_cpuid_test.c
@@ -48,16 +48,16 @@ do {									\
 
 static void guest_code(void)
 {
-	uint64_t xcr0_reset;
+	uint64_t initial_xcr0;
 	uint64_t supported_xcr0;
 	int i, vector;
 
 	set_cr4(get_cr4() | X86_CR4_OSXSAVE);
 
-	xcr0_reset = xgetbv(0);
+	initial_xcr0 = xgetbv(0);
 	supported_xcr0 = this_cpu_supported_xcr0();
 
-	GUEST_ASSERT(xcr0_reset == XFEATURE_MASK_FP);
+	GUEST_ASSERT(initial_xcr0 == supported_xcr0);
 
 	/* Check AVX */
 	ASSERT_XFEATURE_DEPENDENCIES(supported_xcr0,
@@ -79,6 +79,11 @@ static void guest_code(void)
 	ASSERT_ALL_OR_NONE_XFEATURE(supported_xcr0,
 				    XFEATURE_MASK_XTILE);
 
+	vector = xsetbv_safe(0, XFEATURE_MASK_FP);
+	__GUEST_ASSERT(!vector,
+		       "Expected success on XSETBV(FP), got vector '0x%x'",
+		       vector);
+
 	vector = xsetbv_safe(0, supported_xcr0);
 	__GUEST_ASSERT(!vector,
 		       "Expected success on XSETBV(0x%lx), got vector '0x%x'",

base-commit: 3f8df6285271d9d8f17d733433e5213a63b83a0b
-- 


