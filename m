Return-Path: <kvm+bounces-11818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DF13087C31C
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 19:55:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 06F371C20F47
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 18:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D5576035;
	Thu, 14 Mar 2024 18:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lh6mZLRY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A269757E3
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 18:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710442506; cv=none; b=OWHcdUf5OBBVzLd0YbN1rdoEsFziGc4zgi6Rv1i20fgcsnvtXaN/xi83406mZg9ngqI4Iw0xwnygmWSUDg+hNOnTVZQI3H3NP1YC6g87stD0BQ36p0TtnfP1bWzl23JKaApC4NVNmcOX1mJrIwfpOOQSzk+bPO8NSEJZoHe3Jaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710442506; c=relaxed/simple;
	bh=EMJRx8SSjyWKJEA47Fx++/ID68qFGbsXeFFdrGx+uJQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sCvSjKcIi666UfINLHXvPQU2CK9b0FzD2fa+Gcs1QFzaRhEKv4Wbr8Odx0jmj1ShQJWpRH23VFGb0KGjcNTFqzGivTmP95BrbYFtSRyaMCKclaB12XtB5ldiDZ+Ab8cgYPJHSmSMOh2f2oDTuxrrfV6zbYY2GhAXuHU6lOMUOQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lh6mZLRY; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60cc00203faso29486637b3.2
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 11:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710442503; x=1711047303; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NvzHDkK63Oa7MmelAXu2DrtJh2IlG1wR0jNzRcE2MMA=;
        b=lh6mZLRY0bGTWGQuwoZU3yM4E+n++cSp1xtPx9YJPmaYuUIefffACf3i9Q9njC/enq
         GRau56i4k6IL7wQ7DJIIk2vSUDLQAIWNuFCMlxrz9OIk5pJ+T1rslpYz0Nvb9mdw+Ct3
         OElTvjagz72M+T/ivYVGAl+Vw7F+MZPlFcf2X0QWGmm0AUN9caqvG/zkgmh/w+OgIlky
         21XAYMu668q/4896PxDm+a83rHQuH8HY6/cwVXELUYCKsucuXwfvjum0ga9xYAK8oEBZ
         dARoaG2IvzaQ4PiG5qUz4LP604gZG6Cc5+XSb+0cdfaVXytTWAcsbmQbGRgW3uQ7xEJW
         bymA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710442503; x=1711047303;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NvzHDkK63Oa7MmelAXu2DrtJh2IlG1wR0jNzRcE2MMA=;
        b=R1wOtJgLcZBnJv83Pz+qCVogNyLasbP1P12K+6RWMU8PUxG2sj2mG3NmFmd4LEKi01
         5QTqxdjrTX4YdlBZgE5Gq287ixJ8CYh6WhMvZcmBEjkYbcltWF0gVzApVt/0xt99ZKsV
         /HQTT1IfVYpoK4zp78Ry0/SDSuM2fDvDBl+XCqGWuU8ausyU0RESs+d5DROVRMHdxSpL
         +uDcOnDjlykYZlT2WacJsIEcCrpK7CDGrng6rmmWXQGLMniwlwdVIiEi3rCuy//nelCm
         /wBa73rbw8OXX0huuXVZNgUaP++Jdc8v0U4IYl5LoeEUyPiu6Gwg47Beb9Ow0S4T6qf8
         dr0A==
X-Gm-Message-State: AOJu0YwmwmYyGDBNRrgcnxpHajkJd/DGB+ldlIMtpmjB/MImM5gW9uSw
	h6Yxxo3CZ22gLr94Hn6G9zfz6Pw/Idj50DSsD4+pihA1swclamWGLv3DrLz3dTDhWtXgKdJAz64
	y9A==
X-Google-Smtp-Source: AGHT+IGoIsxHFIUNId9qdYbp+v67IVJuW3NrOEBDdlgtrs6pUVvhUIMquDklED8pzE9AvlSgmXc9mQGDCIo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1004:b0:dc6:44d4:bee0 with SMTP id
 w4-20020a056902100400b00dc644d4bee0mr197ybt.7.1710442503231; Thu, 14 Mar 2024
 11:55:03 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Mar 2024 11:54:54 -0700
In-Reply-To: <20240314185459.2439072-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240314185459.2439072-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.291.gc1ea87d7ee-goog
Message-ID: <20240314185459.2439072-2-seanjc@google.com>
Subject: [PATCH 1/5] KVM: selftests: Provide a global pseudo-RNG instance for
 all tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a global guest_random_state instance, i.e. a pseudo-RNG, so that an
RNG is available for *all* tests.  This will allow randomizing behavior
in core library code, e.g. x86 will utilize the pRNG to conditionally
force emulation of writes from within common guest code.

To allow for deterministic runs, and to be compatible with existing tests,
allow tests to override the seed used to initialize the pRNG.

Note, the seed *must* be overwritten before a VM is created in order for
the seed to take effect, though it's perfectly fine for a test to
initialize multiple VMs with different seeds.

And as evidenced by memstress_guest_code(), it's also a-ok to instantiate
more RNGs using the global seed (or a modified version of it).  The goal
of the global RNG is purely to ensure that _a_ source of random numbers is
available, it doesn't have to be the _only_ RNG.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/dirty_log_perf_test.c |  9 ++++-----
 tools/testing/selftests/kvm/dirty_log_test.c    | 17 +----------------
 tools/testing/selftests/kvm/include/memstress.h |  1 -
 tools/testing/selftests/kvm/include/test_util.h |  8 ++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c      |  9 +++++++++
 tools/testing/selftests/kvm/lib/memstress.c     |  8 +-------
 6 files changed, 23 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 504f6fe980e8..5cda9780c378 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -132,7 +132,6 @@ struct test_params {
 	enum vm_mem_backing_src_type backing_src;
 	int slots;
 	uint32_t write_percent;
-	uint32_t random_seed;
 	bool random_access;
 };
 
@@ -156,8 +155,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				 p->slots, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
-	pr_info("Random seed: %u\n", p->random_seed);
-	memstress_set_random_seed(vm, p->random_seed);
 	memstress_set_write_percent(vm, p->write_percent);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm->page_shift;
@@ -346,11 +343,13 @@ int main(int argc, char *argv[])
 		.partition_vcpu_memory_access = true,
 		.backing_src = DEFAULT_VM_MEM_SRC,
 		.slots = 1,
-		.random_seed = 1,
 		.write_percent = 100,
 	};
 	int opt;
 
+	/* Override the seed to be deterministic by default. */
+	guest_random_seed = 1;
+
 	dirty_log_manual_caps =
 		kvm_check_cap(KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2);
 	dirty_log_manual_caps &= (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE |
@@ -395,7 +394,7 @@ int main(int argc, char *argv[])
 			p.phys_offset = strtoull(optarg, NULL, 0);
 			break;
 		case 'r':
-			p.random_seed = atoi_positive("Random seed", optarg);
+			guest_random_seed = atoi_positive("Random seed", optarg);
 			break;
 		case 's':
 			p.backing_src = parse_backing_src_type(optarg);
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index eaad5b20854c..525d92dda646 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -76,7 +76,6 @@
 static uint64_t host_page_size;
 static uint64_t guest_page_size;
 static uint64_t guest_num_pages;
-static uint64_t random_array[TEST_PAGES_PER_LOOP];
 static uint64_t iteration;
 
 /*
@@ -115,13 +114,12 @@ static void guest_code(void)
 	while (true) {
 		for (i = 0; i < TEST_PAGES_PER_LOOP; i++) {
 			addr = guest_test_virt_mem;
-			addr += (READ_ONCE(random_array[i]) % guest_num_pages)
+			addr += (guest_random_u64(&guest_rng) % guest_num_pages)
 				* guest_page_size;
 			addr = align_down(addr, host_page_size);
 			*(uint64_t *)addr = READ_ONCE(iteration);
 		}
 
-		/* Tell the host that we need more random numbers */
 		GUEST_SYNC(1);
 	}
 }
@@ -508,20 +506,10 @@ static void log_mode_after_vcpu_run(struct kvm_vcpu *vcpu, int ret, int err)
 		mode->after_vcpu_run(vcpu, ret, err);
 }
 
-static void generate_random_array(uint64_t *guest_array, uint64_t size)
-{
-	uint64_t i;
-
-	for (i = 0; i < size; i++)
-		guest_array[i] = random();
-}
-
 static void *vcpu_worker(void *data)
 {
 	int ret;
 	struct kvm_vcpu *vcpu = data;
-	struct kvm_vm *vm = vcpu->vm;
-	uint64_t *guest_array;
 	uint64_t pages_count = 0;
 	struct kvm_signal_mask *sigmask = alloca(offsetof(struct kvm_signal_mask, sigset)
 						 + sizeof(sigset_t));
@@ -540,11 +528,8 @@ static void *vcpu_worker(void *data)
 	sigemptyset(sigset);
 	sigaddset(sigset, SIG_IPI);
 
-	guest_array = addr_gva2hva(vm, (vm_vaddr_t)random_array);
-
 	while (!READ_ONCE(host_quit)) {
 		/* Clear any existing kick signals */
-		generate_random_array(guest_array, TEST_PAGES_PER_LOOP);
 		pages_count += TEST_PAGES_PER_LOOP;
 		/* Let the guest dirty the random pages */
 		ret = __vcpu_run(vcpu);
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index ce4e603050ea..9071eb6dea60 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -62,7 +62,6 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 void memstress_destroy_vm(struct kvm_vm *vm);
 
 void memstress_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
-void memstress_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
 void memstress_set_random_access(struct kvm_vm *vm, bool random_access);
 
 void memstress_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct memstress_vcpu_args *));
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 8a6e30612c86..4b78fb7e539e 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -91,9 +91,17 @@ struct guest_random_state {
 	uint32_t seed;
 };
 
+extern uint32_t guest_random_seed;
+extern struct guest_random_state guest_rng;
+
 struct guest_random_state new_guest_random_state(uint32_t seed);
 uint32_t guest_random_u32(struct guest_random_state *state);
 
+static inline uint64_t guest_random_u64(struct guest_random_state *state)
+{
+	return ((uint64_t)guest_random_u32(state) << 32) | guest_random_u32(state);
+}
+
 enum vm_mem_backing_src_type {
 	VM_MEM_SRC_ANONYMOUS,
 	VM_MEM_SRC_ANONYMOUS_THP,
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b2262b5fad9e..02d7fa70d440 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -20,6 +20,9 @@
 
 #define KVM_UTIL_MIN_PFN	2
 
+uint32_t guest_random_seed;
+struct guest_random_state guest_rng;
+
 static int vcpu_mmap_sz(void);
 
 int open_path_or_exit(const char *path, int flags)
@@ -433,6 +436,10 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint32_t nr_runnable_vcpus,
 	slot0 = memslot2region(vm, 0);
 	ucall_init(vm, slot0->region.guest_phys_addr + slot0->region.memory_size);
 
+	pr_info("Random seed: 0x%x\n", guest_random_seed);
+	guest_rng = new_guest_random_state(guest_random_seed);
+	sync_global_to_guest(vm, guest_rng);
+
 	kvm_arch_vm_post_create(vm);
 
 	return vm;
@@ -2306,6 +2313,8 @@ void __attribute((constructor)) kvm_selftest_init(void)
 	/* Tell stdout not to buffer its content. */
 	setbuf(stdout, NULL);
 
+	guest_random_seed = random();
+
 	kvm_selftest_arch_init();
 }
 
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index cf2c73971308..f8bfb4988368 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -56,7 +56,7 @@ void memstress_guest_code(uint32_t vcpu_idx)
 	uint64_t page;
 	int i;
 
-	rand_state = new_guest_random_state(args->random_seed + vcpu_idx);
+	rand_state = new_guest_random_state(guest_random_seed + vcpu_idx);
 
 	gva = vcpu_args->gva;
 	pages = vcpu_args->pages;
@@ -243,12 +243,6 @@ void memstress_set_write_percent(struct kvm_vm *vm, uint32_t write_percent)
 	sync_global_to_guest(vm, memstress_args.write_percent);
 }
 
-void memstress_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
-{
-	memstress_args.random_seed = random_seed;
-	sync_global_to_guest(vm, memstress_args.random_seed);
-}
-
 void memstress_set_random_access(struct kvm_vm *vm, bool random_access)
 {
 	memstress_args.random_access = random_access;
-- 
2.44.0.291.gc1ea87d7ee-goog


