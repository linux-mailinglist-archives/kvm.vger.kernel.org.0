Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18BFA44CE14
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbhKKAGT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234321AbhKKAGR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:17 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E7CDC061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:29 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id h35-20020a63f923000000b002d5262fdfc4so2342361pgi.2
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lq+Ydb05ASTFOfpIegkfapvb1bR6QTHCEmkE3rw574Q=;
        b=KGIe8YCYy1RvGRhVtiuQgWOCZA4MTGxgCAfNEuwQHkxa2UG9RG3nV1KUFkREUHGZf7
         lBtVkJWKlJwFj6Rz5UOwB3zNPt1tbphHV6jLZSyDGWfUP6BDjSZqln7Dnm+KkATfpkWv
         vXatnx0cbKRsWkmtDB6K1pdWWWWYzSVDBU54ZuCPSZXlF9sYprzcEpXSmiFkXbLl6UJM
         0w2IgZdd2LevLAdN/N1QWiYGmwEkGJyq64XPmgRRVIO6QvZzl4uJ8pwL0gqaiIyhaNkV
         Z+IO6TDon5/vb+enHoX5qp+m0TwMiRU4YrV9LwiNtUYuLFFfdwlr/04iBu1xG75TZk1E
         K0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lq+Ydb05ASTFOfpIegkfapvb1bR6QTHCEmkE3rw574Q=;
        b=A4Nod6vuvh+m7up1r0V9KpyW8KONsRxz51sJ9VGH5wAxvi+ijPZ06Itz9VstuVqxZI
         Ck20LpDb2z0pk8lc7t9PdAr1aTMlOhI8/cf6lmnupUAju7IXT88So9u47fhSH59qrsx4
         ueLm0g3UWEVQ2gRCh8O8Pmm78iHOH1NjW9N3VNSqS7+26AH1gaWlMkMB/sB8aJ81hclP
         iHPmN6TTX9azZ+cZMzZim5rBadIv0Q4r1wQa+5yHqCVsTziifeX9V9dxIbr/ml0CEhGp
         0MBudOl4WNiezd7ciqr74gFIeHxg+Pjaf4S0oeN8KvC2o+GXhhxhJgOB4SZ5rGRur7OA
         L8vA==
X-Gm-Message-State: AOAM5335jAqoEZcZ5Di+6xnFjA9hG0mt99LkZk8wVnvHdM0FiV1HYTPX
        HzyoFKYN4TmikGv34WVHWx9djwfpsSFAVw==
X-Google-Smtp-Source: ABdhPJwuCOVEViwhvkIcBY9LKBt6z6Hutnz9K4/e6AYko7uQZDJixzhFLByvnza6IJ4OURip1Tq6lIKeDnSExw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:db81:: with SMTP id
 h1mr22160549pjv.46.1636589009128; Wed, 10 Nov 2021 16:03:29 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:03:06 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 08/12] KVM: selftests: Move per-VM GPA into perf_test_args
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

Move the per-VM GPA into perf_test_args instead of storing it as a
separate global variable.  It's not obvious that guest_test_phys_mem
holds a GPA, nor that it's connected/coupled with per_vcpu->gpa.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/perf_test_util.h    |  8 +------
 .../selftests/kvm/lib/perf_test_util.c        | 21 +++++++------------
 .../kvm/memslot_modification_stress_test.c    |  2 +-
 3 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 20aec72fe7b8..d7cde1ab2a85 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -29,6 +29,7 @@ struct perf_test_vcpu_args {
 struct perf_test_args {
 	struct kvm_vm *vm;
 	uint64_t host_page_size;
+	uint64_t gpa;
 	uint64_t guest_page_size;
 	int wr_fract;
 
@@ -37,13 +38,6 @@ struct perf_test_args {
 
 extern struct perf_test_args perf_test_args;
 
-/*
- * Guest physical memory offset of the testing memory slot.
- * This will be set to the topmost valid physical address minus
- * the test memory size.
- */
-extern uint64_t guest_test_phys_mem;
-
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   uint64_t vcpu_memory_bytes, int slots,
 				   enum vm_mem_backing_src_type backing_src);
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index d9c6bcb7964d..0fc2d834c1c7 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -10,8 +10,6 @@
 
 struct perf_test_args perf_test_args;
 
-uint64_t guest_test_phys_mem;
-
 /*
  * Guest virtual memory offset of the testing memory slot.
  * Must not conflict with identity mapped test code.
@@ -97,20 +95,18 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
 		    vcpu_memory_bytes);
 
-	guest_test_phys_mem = (vm_get_max_gfn(vm) - guest_num_pages) *
-			      pta->guest_page_size;
-	guest_test_phys_mem = align_down(guest_test_phys_mem, backing_src_pagesz);
+	pta->gpa = (vm_get_max_gfn(vm) - guest_num_pages) * pta->guest_page_size;
+	pta->gpa = align_down(pta->gpa, backing_src_pagesz);
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
-	guest_test_phys_mem = align_down(guest_test_phys_mem, 1 << 20);
+	pta->gpa = align_down(pta->gpa, 1 << 20);
 #endif
-	pr_info("guest physical test memory offset: 0x%lx\n", guest_test_phys_mem);
+	pr_info("guest physical test memory offset: 0x%lx\n", pta->gpa);
 
 	/* Add extra memory slots for testing */
 	for (i = 0; i < slots; i++) {
 		uint64_t region_pages = guest_num_pages / slots;
-		vm_paddr_t region_start = guest_test_phys_mem +
-			region_pages * pta->guest_page_size * i;
+		vm_paddr_t region_start = pta->gpa + region_pages * pta->guest_page_size * i;
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
 					    PERF_TEST_MEM_SLOT_INDEX + i,
@@ -118,7 +114,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	}
 
 	/* Do mapping for the demand paging memory slot */
-	virt_map(vm, guest_test_virt_mem, guest_test_phys_mem, guest_num_pages);
+	virt_map(vm, guest_test_virt_mem, pta->gpa, guest_num_pages);
 
 	ucall_init(vm, NULL);
 
@@ -148,13 +144,12 @@ void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
 					 (vcpu_id * vcpu_memory_bytes);
 			vcpu_args->pages = vcpu_memory_bytes /
 					   pta->guest_page_size;
-			vcpu_args->gpa = guest_test_phys_mem +
-					 (vcpu_id * vcpu_memory_bytes);
+			vcpu_args->gpa = pta->gpa + (vcpu_id * vcpu_memory_bytes);
 		} else {
 			vcpu_args->gva = guest_test_virt_mem;
 			vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
 					   pta->guest_page_size;
-			vcpu_args->gpa = guest_test_phys_mem;
+			vcpu_args->gpa = pta->gpa;
 		}
 
 		vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 4cfcafea9f5a..d105180d5e8c 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -80,7 +80,7 @@ static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
 	 * Add the dummy memslot just below the perf_test_util memslot, which is
 	 * at the top of the guest physical address space.
 	 */
-	gpa = guest_test_phys_mem - pages * vm_get_page_size(vm);
+	gpa = perf_test_args.gpa - pages * vm_get_page_size(vm);
 
 	for (i = 0; i < nr_modifications; i++) {
 		usleep(delay);
-- 
2.34.0.rc1.387.gb447b232ab-goog

