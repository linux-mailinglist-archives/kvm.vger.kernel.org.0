Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D52844CE0E
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhKKAGJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbhKKAGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:08 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D6AC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:20 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id z19-20020aa79593000000b0049472f5e52dso2829456pfj.13
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=WtDMBXK2xKejOW7vJx3s9hYalI/00GyHa6SMuePndz4=;
        b=MIQwflEc6oqXjx70AVZ5eD9bECa7/wR2oaCnLFO1sgudZJUmsZZiAHGaQl6KVll1HS
         OE26HkuzYdDoJI4BUx3G/iYamd71ylH3jzaF7ISeStVqPlyhU1lf9CLUNM5ehD1nfB1B
         Myk2NDce9ijnp3HWA+Ex76LbliZ100faFXcIa7esrgFFGhfN9YLqPuW7BUAi1F8uV6Ck
         J2p2qiPR1itAITCJFgNWF95GAR2sd4zKNBUPOKyGliCw6ofoNT2UfkdKNgaHvWTYADkM
         2yIaYLX9tLIXnB0L1KJR7I7J6ns+0dfaZUKnOYShBRdnsZBH87Vuuiaoz7jQvlAj+Tm/
         vwmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WtDMBXK2xKejOW7vJx3s9hYalI/00GyHa6SMuePndz4=;
        b=J8UeOO27ISQzXERJS0o/fv6mi9j80WOD9F/t5y/cALRg2Y/kWsg7HnHTFvZDmjKTfL
         Kqs8KBIVEf9PgEN1KKuCm0aVYV0CEaNZKFxVK8vwxuV6hUKPSEKXijXvEC3bHLWKpGvz
         BriLe1yHy/D9dhPR8yYdLIMxFAziY6tlq0s71Va/Btdm0yMF5smyymwU8XmSFlElZDSi
         /jzYZ+5MQsAqa4j56l/cCInwLKQhI2CpitkDqMO/uVVqvKxOR2RwJcWnHHMi5XoCrbI4
         TXzSKy4psVsoTjDiBjQ+xlRFMPtjUCHS6eoaaO3jztSUzP1kzTZ9QHhtzVTeXghRTT47
         akbA==
X-Gm-Message-State: AOAM532+xjUs82RU8E+76FzuH2o1Jws64Rt/2lm2TPZgbwirw07Pz7HZ
        EV4168sTqFz8UeDDBR8ZWunW1y9slU4Cxw==
X-Google-Smtp-Source: ABdhPJyjwwDbvwMkJuAXBlyZitIg5ob7ltdE+zySMBMf2rRxbOp7FDC5CCbx17iUukikZcqmABazxAFbSHItow==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:903:24c:b0:13f:2377:ef3a with SMTP id
 j12-20020a170903024c00b0013f2377ef3amr2949466plh.59.1636588999681; Wed, 10
 Nov 2021 16:03:19 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:03:00 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-3-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 02/12] KVM: selftests: Expose align() helpers to tests
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Refactor align() to work with non-pointers and split into separate
helpers for aligning up vs. down. Add align_ptr_up() for use with
pointers. Expose all helpers so that they can be used by tests and/or
other utilities.  The align_down() helper in particular will be used to
ensure gpa alignment for hugepages.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Added sepearate up/down helpers and replaced open-coded alignment
 bit math throughout the KVM selftests.]
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  |  6 ++---
 .../testing/selftests/kvm/include/test_util.h | 25 +++++++++++++++++++
 .../selftests/kvm/kvm_page_table_test.c       |  2 +-
 tools/testing/selftests/kvm/lib/elf.c         |  3 +--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 13 ++--------
 .../selftests/kvm/lib/perf_test_util.c        |  4 +--
 6 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 792c60e1b17d..3fcd89e195c7 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -115,7 +115,7 @@ static void guest_code(void)
 			addr = guest_test_virt_mem;
 			addr += (READ_ONCE(random_array[i]) % guest_num_pages)
 				* guest_page_size;
-			addr &= ~(host_page_size - 1);
+			addr = align_down(addr, host_page_size);
 			*(uint64_t *)addr = READ_ONCE(iteration);
 		}
 
@@ -737,14 +737,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	if (!p->phys_offset) {
 		guest_test_phys_mem = (vm_get_max_gfn(vm) -
 				       guest_num_pages) * guest_page_size;
-		guest_test_phys_mem &= ~(host_page_size - 1);
+		guest_test_phys_mem = align_down(guest_test_phys_mem, host_page_size);
 	} else {
 		guest_test_phys_mem = p->phys_offset;
 	}
 
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
-	guest_test_phys_mem &= ~((1 << 20) - 1);
+	guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
 #endif
 
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index f8fddc84c0d3..78c06310cc0e 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -117,4 +117,29 @@ static inline bool backing_src_is_shared(enum vm_mem_backing_src_type t)
 	return vm_mem_backing_src_alias(t)->flag & MAP_SHARED;
 }
 
+/* Aligns x up to the next multiple of size. Size must be a power of 2. */
+static inline uint64_t align_up(uint64_t x, uint64_t size)
+{
+	uint64_t mask = size - 1;
+
+	TEST_ASSERT(size != 0 && !(size & (size - 1)),
+		    "size not a power of 2: %lu", size);
+	return ((x + mask) & ~mask);
+}
+
+static inline uint64_t align_down(uint64_t x, uint64_t size)
+{
+	uint64_t x_aligned_up = align_up(x, size);
+
+	if (x == x_aligned_up)
+		return x;
+	else
+		return x_aligned_up - size;
+}
+
+static inline void *align_ptr_up(void *x, size_t size)
+{
+	return (void *)align_up((unsigned long)x, size);
+}
+
 #endif /* SELFTEST_KVM_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 36407cb0ec85..3836322add00 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -280,7 +280,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 #ifdef __s390x__
 	alignment = max(0x100000, alignment);
 #endif
-	guest_test_phys_mem &= ~(alignment - 1);
+	guest_test_phys_mem = align_down(guest_test_virt_mem, alignment);
 
 	/* Set up the shared data structure test_args */
 	test_args.vm = vm;
diff --git a/tools/testing/selftests/kvm/lib/elf.c b/tools/testing/selftests/kvm/lib/elf.c
index eac44f5d0db0..13e8e3dcf984 100644
--- a/tools/testing/selftests/kvm/lib/elf.c
+++ b/tools/testing/selftests/kvm/lib/elf.c
@@ -157,8 +157,7 @@ void kvm_vm_elf_load(struct kvm_vm *vm, const char *filename)
 			"memsize of 0,\n"
 			"  phdr index: %u p_memsz: 0x%" PRIx64,
 			n1, (uint64_t) phdr.p_memsz);
-		vm_vaddr_t seg_vstart = phdr.p_vaddr;
-		seg_vstart &= ~(vm_vaddr_t)(vm->page_size - 1);
+		vm_vaddr_t seg_vstart = align_down(phdr.p_vaddr, vm->page_size);
 		vm_vaddr_t seg_vend = phdr.p_vaddr + phdr.p_memsz - 1;
 		seg_vend |= vm->page_size - 1;
 		size_t seg_size = seg_vend - seg_vstart + 1;
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index b624c24290dd..63375118d48f 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -22,15 +22,6 @@
 
 static int vcpu_mmap_sz(void);
 
-/* Aligns x up to the next multiple of size. Size must be a power of 2. */
-static void *align(void *x, size_t size)
-{
-	size_t mask = size - 1;
-	TEST_ASSERT(size != 0 && !(size & (size - 1)),
-		    "size not a power of 2: %lu", size);
-	return (void *) (((size_t) x + mask) & ~mask);
-}
-
 /*
  * Open KVM_DEV_PATH if available, otherwise exit the entire program.
  *
@@ -911,7 +902,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 		    region->mmap_start, errno);
 
 	/* Align host address */
-	region->host_mem = align(region->mmap_start, alignment);
+	region->host_mem = align_ptr_up(region->mmap_start, alignment);
 
 	/* As needed perform madvise */
 	if ((src_type == VM_MEM_SRC_ANONYMOUS ||
@@ -954,7 +945,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 			    "mmap of alias failed, errno: %i", errno);
 
 		/* Align host alias address */
-		region->host_alias = align(region->mmap_alias, alignment);
+		region->host_alias = align_ptr_up(region->mmap_alias, alignment);
 	}
 }
 
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 0ef80dbdc116..6b8d5020dc54 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -92,10 +92,10 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
 			      perf_test_args.guest_page_size;
-	guest_test_phys_mem &= ~(perf_test_args.host_page_size - 1);
+	guest_test_phys_mem = align_down(guest_test_phys_mem, perf_test_args.host_page_size);
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
-	guest_test_phys_mem &= ~((1 << 20) - 1);
+	guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
 #endif
 	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

