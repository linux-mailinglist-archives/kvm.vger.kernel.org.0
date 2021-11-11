Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1D944CE18
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhKKAG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234356AbhKKAGX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:23 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD02C0613F5
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:35 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id r7-20020a63ce47000000b002a5cadd2f25so2318550pgi.9
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rvcyrFmDmaJFNRkxwJiSiKOCz4Rgltqo0FYJ1UfGbbo=;
        b=IvykEiR6ya4qykcVXSlBOINsv4jNaThsg1SqIWwQVedcUn6HENT49JhNN9kCQDxRIf
         kNkiXRiRfPlN3eduNFKTKnvbozM6DgGOzH9VhqDVyWTwtEBkDdqOxTw1xP0T6EFYK6yb
         yXv6xpEYFVD2CXhvUqEOCuO/pvi74dnFydd6t9wRpUkwj+Bmg1OSIIP14RIQNvxnkyeN
         x0EeRx8ywUVfskketCzZFM6HRbQ/7/Lpa2tHEeerZcxhJ+4kq8q6nCWGRsYg2tvx5fmT
         Gmota6llXZRqlwwERIuAVrCZLKgr0DhyWMgSHjor1BN+bkfOYlO1I6Uf9v5e0mFQXlmb
         gazQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rvcyrFmDmaJFNRkxwJiSiKOCz4Rgltqo0FYJ1UfGbbo=;
        b=3vNLtmPQHJie37daTG3lub8OI7mQICV2f6HY19Sr13yvViFhsQrfvF7UHz/nsKTnmQ
         FYrEf5rvUhiwz8uUK5WPy78TyoErg0bChTdhkPlNpqFogRtJlpbYn3Vlfe1XiJ3mU0OW
         +MjAAlFshM/56mWKTX/mq+0NuUrSZ3x/0ojS3hOHMpbxLD3fSpzGQqsvb+MnFoM9zTuY
         AP3f1S0SAIBRHB3JMNvFKvyTb+PC2dolwcAbNvnhTPOMCNqQtWqT4vB6rAucw2va/YT3
         noGliVrg18nFVI89WIprl2r3alSIKdkADGkXVxzlTt+PVcj5aAIbWVj/6MT8reGZB0AS
         J/fQ==
X-Gm-Message-State: AOAM533BQ2Ix0qPV84HQ7IOf3hZS3EVs1apq6P+zgRl7IZ8DYD1yTM3A
        lTFQCOfNbrbkBzdAaNW0DDyU5TodNwz9CA==
X-Google-Smtp-Source: ABdhPJwWRDHoQchmESuSFK9TkqSTCeJOMTzIIKw5aAiH+GAF5LN8UCWO3+fRvoy5cSvZIi91vtIrcffFv50xvg==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:a23:b0:43d:e856:a3d4 with SMTP
 id p35-20020a056a000a2300b0043de856a3d4mr2966152pfh.17.1636589015292; Wed, 10
 Nov 2021 16:03:35 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:03:10 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-13-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 12/12] KVM: selftests: Sync perf_test_args to guest during
 VM creation
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

Copy perf_test_args to the guest during VM creation instead of relying on
the caller to do so at their leisure.  Ideally, tests wouldn't even be
able to modify perf_test_args, i.e. they would have no motivation to do
the sync, but enforcing that is arguably a net negative for readability.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Set wr_fract=1 by default and add helper to override it since the new
 access_tracking_perf_test needs to set it dynamically.]
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c        |  3 +--
 tools/testing/selftests/kvm/demand_paging_test.c     |  5 -----
 tools/testing/selftests/kvm/dirty_log_perf_test.c    |  4 +---
 tools/testing/selftests/kvm/include/perf_test_util.h |  2 ++
 tools/testing/selftests/kvm/lib/perf_test_util.c     | 12 ++++++++++++
 .../selftests/kvm/memslot_modification_stress_test.c |  5 -----
 6 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index fdef6c906388..5364a2ed7c68 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -277,8 +277,7 @@ static void run_iteration(struct kvm_vm *vm, int vcpus, const char *description)
 static void access_memory(struct kvm_vm *vm, int vcpus, enum access_type access,
 			  const char *description)
 {
-	perf_test_args.wr_fract = (access == ACCESS_READ) ? INT_MAX : 1;
-	sync_global_to_guest(vm, perf_test_args);
+	perf_test_set_wr_fract(vm, (access == ACCESS_READ) ? INT_MAX : 1);
 	iteration_work = ITERATION_ACCESS_MEMORY;
 	run_iteration(vm, vcpus, description);
 }
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 0fee44f5e5ae..26f8fd8a57ec 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -295,8 +295,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
 				 p->src_type, p->partition_vcpu_memory_access);
 
-	perf_test_args.wr_fract = 1;
-
 	demand_paging_size = get_backing_src_pagesz(p->src_type);
 
 	guest_data_prototype = malloc(demand_paging_size);
@@ -345,9 +343,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		}
 	}
 
-	/* Export the shared variables to the guest */
-	sync_global_to_guest(vm, perf_test_args);
-
 	pr_info("Finished creating vCPUs and starting uffd threads\n");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 62f9cc2a3146..583b4d95aa98 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -189,7 +189,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				 p->slots, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
-	perf_test_args.wr_fract = p->wr_fract;
+	perf_test_set_wr_fract(vm, p->wr_fract);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
@@ -207,8 +207,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
 	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
 
-	sync_global_to_guest(vm, perf_test_args);
-
 	/* Start the iterations */
 	iteration = 0;
 	host_quit = false;
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 91804be1cf53..74e3622b3a6e 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -43,4 +43,6 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   bool partition_vcpu_memory_access);
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
+void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract);
+
 #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 13c8bc22f4e1..77f9eb5667c9 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -94,6 +94,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
+	/* By default vCPUs will write to memory. */
+	pta->wr_fract = 1;
+
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
 	 * access/dirty pages at the logging granularity.
@@ -157,6 +160,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	ucall_init(vm, NULL);
 
+	/* Export the shared variables to the guest. */
+	sync_global_to_guest(vm, perf_test_args);
+
 	return vm;
 }
 
@@ -165,3 +171,9 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
 }
+
+void perf_test_set_wr_fract(struct kvm_vm *vm, int wr_fract)
+{
+	perf_test_args.wr_fract = wr_fract;
+	sync_global_to_guest(vm, perf_test_args);
+}
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 27af0bb8deb7..df431d0da1ee 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -108,14 +108,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				 VM_MEM_SRC_ANONYMOUS,
 				 p->partition_vcpu_memory_access);
 
-	perf_test_args.wr_fract = 1;
-
 	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
 	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
 
-	/* Export the shared variables to the guest */
-	sync_global_to_guest(vm, perf_test_args);
-
 	pr_info("Finished creating vCPUs\n");
 
 	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++)
-- 
2.34.0.rc1.387.gb447b232ab-goog

