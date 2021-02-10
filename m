Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCC4317402
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbhBJXKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbhBJXJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:09:31 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDB8C061226
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:07:02 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id x4so4237339ybj.22
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:07:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=xzPdpv8MHYE/+y1yIo/W7K5+bKtlPzwP+COJMIds9zc=;
        b=N88xDPdcfGLluTxiRIyEqoDZAZTdnaa6C+IfZ8QM1WX43gcTRsxhXpufBm23LJ5uqZ
         UNxN8q68FDCnBma5UdZj6Ej1bArWTjXehrQK93rXQ8RqdEHYyUN5j2aPTULweB2vCh+O
         J4WXqkrDaKi6oyflVYSq75rvSiAKIHivDzoL5/ZsZRd3B9dCZ1T0PuCQsVRtqOB2uD47
         +hcSsllQzcG3yLpvgWKeHGc97waiYYMQmklO68Frdy81t7Tuhg1k4eQnPShW/9RoVqhs
         Y1NOGWysDDTl4UKi0ZbClT75vRRbD94MYhujrprfokxlmZIVceZeexF9RkS4LzeEBGgI
         hZyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=xzPdpv8MHYE/+y1yIo/W7K5+bKtlPzwP+COJMIds9zc=;
        b=UltgWYjvsHPRHqWyZ+kPzv5LUipCLo7O0wIvb0qXmDxRXKs7HzjhEpQY6iZgKGyph5
         6gAStbOqxpI2wBCbDq+d7WQlETmYgrumQWNpdHu6dQwkOAt1ttdx4CXhS55Ze0e2jtiY
         QETylT9Wow2LfSdPxnT/L0prDQWQF47+F8pVCnGy/vx4tBMbltrxEKIveb6oHl0n8mlf
         kOBcSMcoy6dkCUcA0LqtrH0Epj3liTmkSVk9+TKr/NVu7lYeGpl62klgITXRI9xvzNtX
         OtS3ikmTNAwkH8KigrFaKcwNpQb90MKoCIdsbVbl1rjMi4d8sP0EXsM5J7/scgAY10w7
         GyYQ==
X-Gm-Message-State: AOAM533dIf3maXWGr4g3lXkLYxYyrka65Hu8Y1k+qrL0ITkZFh+ByTgc
        hC8yeiUW8/4hOLVntBkrnhhuH/jCXTY=
X-Google-Smtp-Source: ABdhPJxGaPCMuU/hHBMxf+330j4xifGRLCQx84eoj9h3tH7LS+XLp9nHuWZkoaEQovrnhM4RpW2zP8OSr7Y=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a25:ce51:: with SMTP id x78mr7620057ybe.198.1612998422267;
 Wed, 10 Feb 2021 15:07:02 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:23 -0800
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
Message-Id: <20210210230625.550939-14-seanjc@google.com>
Mime-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 13/15] KVM: selftests: Sync perf_test_args to guest during VM creation
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

Copy perf_test_args to the guest during VM creation instead of relying on
the caller to do so at their leisure.  Ideally, tests wouldn't even be
able to modify perf_test_args, i.e. they would have no motivation to do
the sync, but enforcing that is arguably a net negative for readability.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c           | 7 +------
 tools/testing/selftests/kvm/dirty_log_perf_test.c          | 6 +-----
 tools/testing/selftests/kvm/include/perf_test_util.h       | 1 +
 tools/testing/selftests/kvm/lib/perf_test_util.c           | 6 ++++++
 .../selftests/kvm/memslot_modification_stress_test.c       | 7 +------
 5 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 00f2c795b68d..d06ff8f37c53 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -267,11 +267,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int r;
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
-				 VM_MEM_SRC_ANONYMOUS,
+				 VM_MEM_SRC_ANONYMOUS, 1,
 				 p->partition_vcpu_memory_access);
 
-	perf_test_args.wr_fract = 1;
-
 	guest_data_prototype = malloc(getpagesize());
 	TEST_ASSERT(guest_data_prototype,
 		    "Failed to allocate buffer for guest data pattern");
@@ -319,9 +317,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 		}
 	}
 
-	/* Export the shared variables to the guest */
-	sync_global_to_guest(vm, perf_test_args);
-
 	pr_info("Finished creating vCPUs and starting uffd threads\n");
 
 	clock_gettime(CLOCK_MONOTONIC, &start);
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 2c809452eac1..9ab24bf50c60 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -114,11 +114,9 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec clear_dirty_log_total = (struct timespec){0};
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
-				 p->backing_src,
+				 p->backing_src, p->wr_fract,
 				 p->partition_vcpu_memory_access);
 
-	perf_test_args.wr_fract = p->wr_fract;
-
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
 	guest_num_pages = vm_adjust_num_guest_pages(mode, guest_num_pages);
 	host_num_pages = vm_num_host_pages(mode, guest_num_pages);
@@ -133,8 +131,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
 	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
 
-	sync_global_to_guest(vm, perf_test_args);
-
 	/* Start the iterations */
 	iteration = 0;
 	host_quit = false;
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 3a21e82a0173..330e528f206f 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -40,6 +40,7 @@ extern struct perf_test_args perf_test_args;
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   uint64_t vcpu_memory_bytes,
 				   enum vm_mem_backing_src_type backing_src,
+				   int wr_fract,
 				   bool partition_vcpu_memory_access);
 void perf_test_destroy_vm(struct kvm_vm *vm);
 
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 3aa99365726b..6f41fe2685cb 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -85,6 +85,7 @@ static void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   uint64_t vcpu_memory_bytes,
 				   enum vm_mem_backing_src_type backing_src,
+				   int wr_fract,
 				   bool partition_vcpu_memory_access)
 {
 	struct perf_test_args *pta = &perf_test_args;
@@ -93,6 +94,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
 
+	pta->wr_fract = wr_fract;
+
 	/*
 	 * Snapshot the non-huge page size.  This is used by the guest code to
 	 * access/dirty pages at the logging granularity.
@@ -148,6 +151,9 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	ucall_init(vm, NULL);
 
+	/* Export the shared variables to the guest */
+	sync_global_to_guest(vm, perf_test_args);
+
 	return vm;
 }
 
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 949822833b6b..5ea9d7ef248e 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -98,17 +98,12 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int vcpu_id;
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
-				 VM_MEM_SRC_ANONYMOUS,
+				 VM_MEM_SRC_ANONYMOUS, 1,
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
2.30.0.478.g8a0d178c01-goog

