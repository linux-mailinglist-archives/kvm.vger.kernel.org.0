Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D903173F3
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbhBJXIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbhBJXIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:08:14 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1D8AC061221
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:55 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 78so4242196ybn.14
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5DjAXbitjeHVG5TxDqK2++eKHJ0ymPCTq8V7Nw57/kA=;
        b=fvsehImJ5cIZtskxusx76DIQTu+/oeiLuohwNIAHFHruRJtT2KOpg3mfPWe6/TQL9r
         bE9LipnBOc72xAM9foaUC5cuIZAOvSdzJ63ZgH161iBpIIwoEL3gJBncmfAJXkBg6epG
         470Ts1JG8Wwcaw93ge3QsGJ88zerMsO5670sRkJOr1JNwj1oIi6ouR02QfHA1apbOUpH
         kfqAs+abDLDKJShazwsX7TWbqh+VzyLq1i2TdWlJ24ZNIqaEwjE3kv1nLJHfKq/LISoG
         kkB5p13/WsKOkMbTYQA4O/yDliUOFIppZ3n9A+6wN20PuEGioHv857YxdZ9a0iEey6Ng
         8nHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5DjAXbitjeHVG5TxDqK2++eKHJ0ymPCTq8V7Nw57/kA=;
        b=JG1uEVT5hTwMiLvjRHvXSuiKnMzmvdHoW9pN6hHirRcNs5UuTHfgka+HWuo5kXHqkg
         3m33G1SJkUOGUzZBzX1X91cMnQMcRnZrhnMJipWLKDu0FB47eW1HnLsM3QvO3Mhwimhe
         SsudFp0n7uqXy7ohuFmY0Ri5sZH208GZxn+xM1zhwowxMWloHnOHsjFfUGchDE6AVz6E
         SvrBPHHviAh0w0jSzL7rDWHpo+vLtdzmZsuwCci4W3/V85EHPWo9mwWhQWA88Bcx8lUC
         eOEG0uBXU+OBhnHHyvASXazAbPgBq1IbHlfBEjwGlBHTVjGsDgTsmmhwpXZsBJs5loju
         Mp1g==
X-Gm-Message-State: AOAM531xU1P5qwPsOrqlCSglZSuU1VZp/acDQ+1GRiJMOnjeeCJlqCOh
        8T5fIrWmqoHaN4drqfzrQnrMvnU5Fm0=
X-Google-Smtp-Source: ABdhPJwk20GDwVrtR0WXMBUyTtlj2OgLHbBnBAGq3lcFyLdY1X8407i7E1b2oYwpsWfClEp9vTerSvUn7Og=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a25:1643:: with SMTP id 64mr6808196ybw.169.1612998415062;
 Wed, 10 Feb 2021 15:06:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:20 -0800
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
Message-Id: <20210210230625.550939-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 10/15] KVM: selftests: Remove perf_test_args.host_page_size
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove perf_test_args.host_page_size and instead use getpagesize() so
that it's somewhat obvious that, for tests that care about the host page
size, they care about the system page size, not the hardware page size,
e.g. that the logic is unchanged if hugepages are in play.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c          | 8 ++++----
 tools/testing/selftests/kvm/include/perf_test_util.h      | 1 -
 tools/testing/selftests/kvm/lib/perf_test_util.c          | 6 ++----
 .../selftests/kvm/memslot_modification_stress_test.c      | 2 +-
 4 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0cbf111e6c21..b937a65b0e6d 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -83,7 +83,7 @@ static int handle_uffd_page_request(int uffd, uint64_t addr)
 
 	copy.src = (uint64_t)guest_data_prototype;
 	copy.dst = addr;
-	copy.len = perf_test_args.host_page_size;
+	copy.len = getpagesize();
 	copy.mode = 0;
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
@@ -100,7 +100,7 @@ static int handle_uffd_page_request(int uffd, uint64_t addr)
 	PER_PAGE_DEBUG("UFFDIO_COPY %d \t%ld ns\n", tid,
 		       timespec_to_ns(ts_diff));
 	PER_PAGE_DEBUG("Paged in %ld bytes at 0x%lx from thread %d\n",
-		       perf_test_args.host_page_size, addr, tid);
+		       getpagesize(), addr, tid);
 
 	return 0;
 }
@@ -271,10 +271,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 
 	perf_test_args.wr_fract = 1;
 
-	guest_data_prototype = malloc(perf_test_args.host_page_size);
+	guest_data_prototype = malloc(getpagesize());
 	TEST_ASSERT(guest_data_prototype,
 		    "Failed to allocate buffer for guest data pattern");
-	memset(guest_data_prototype, 0xAB, perf_test_args.host_page_size);
+	memset(guest_data_prototype, 0xAB, getpagesize());
 
 	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
 	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index cccf1c44bddb..223fe6b79a04 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -28,7 +28,6 @@ struct perf_test_vcpu_args {
 
 struct perf_test_args {
 	struct kvm_vm *vm;
-	uint64_t host_page_size;
 	uint64_t gpa;
 	uint64_t guest_page_size;
 	int wr_fract;
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 03f125236021..982a86c8eeaa 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -57,8 +57,6 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
-	pta->host_page_size = getpagesize();
-
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
 	 * access/dirty pages at the logging granularity.
@@ -68,7 +66,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	guest_num_pages = vm_adjust_num_guest_pages(mode,
 				(vcpus * vcpu_memory_bytes) / pta->guest_page_size);
 
-	TEST_ASSERT(vcpu_memory_bytes % pta->host_page_size == 0,
+	TEST_ASSERT(vcpu_memory_bytes % getpagesize() == 0,
 		    "Guest memory size is not host page size aligned.");
 	TEST_ASSERT(vcpu_memory_bytes % pta->guest_page_size == 0,
 		    "Guest memory size is not guest page size aligned.");
@@ -88,7 +86,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 		    guest_num_pages, vm_get_max_gfn(vm), vcpus, vcpu_memory_bytes);
 
 	pta->gpa = (vm_get_max_gfn(vm) - guest_num_pages) * pta->guest_page_size;
-	pta->gpa &= ~(pta->host_page_size - 1);
+	pta->gpa &= ~(getpagesize() - 1);
 	if (backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
 	    backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB)
 		pta->gpa &= ~(KVM_UTIL_HUGEPAGE_ALIGNMENT - 1);
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 569bb1f55bdf..b3b8f08e91ad 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -123,7 +123,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 			   p->nr_memslot_modifications,
 			   perf_test_args.gpa +
 			   (guest_percpu_mem_size * nr_vcpus) +
-			   perf_test_args.host_page_size +
+			   getpagesize() +
 			   perf_test_args.guest_page_size);
 
 	run_vcpus = false;
-- 
2.30.0.478.g8a0d178c01-goog

