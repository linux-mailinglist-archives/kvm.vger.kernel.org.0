Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E7F38B8F1
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 23:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhETV2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 17:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbhETV2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 17:28:37 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6DDC061574
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 14:27:14 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id a141-20020a621a930000b02902de0bf944f8so6620866pfa.10
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 14:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=I/auGhq1eWSFefVzANoMgQJp5Fh+Nykj1tN4pbZ2ZlE=;
        b=hVD0ORK/CiYqoZpRgLCL+94ZIglqLsO4OHYlV7tmwkLoDdgPCpHbb308qY6q32Xt56
         t0cGMDCvagLlBYolQUVfFUwHNSzJjy8OOEBT5PGLJus2/PeAJ1LPS/bF4Ug9Q40b7qux
         yVaa2kB/a2p5bOCVzqbNlxf1K1+wgbKrLfiqyLDJ4ZZ/yayBZ1xw/gHpIEJRZdIiI2Mf
         MUhLm63Dg3kXSQQ4j2215ySQibJHks1G2TxYr8RbhOiaJPSrqGxZiuAcsZ0qoiOypDjl
         CNC6AqUFzhn80E4AEpRQe0yCj6uk7Rt1p9f1XujVeO3zaMnK5w/EGD+jCyQVUdkfiMy4
         uYFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=I/auGhq1eWSFefVzANoMgQJp5Fh+Nykj1tN4pbZ2ZlE=;
        b=tNB7OIFkJU/9ni1GjBLqDToNpqylNdJu0TNCjxKs07UNYBw0JgG46uTRx3G7WjOsye
         xchmjJEcc8DShBxot6ych1rV+Vt4JGCVtjCvK9CsVMPtVrvMzl82uRWHcc/zqTfmdSJE
         tdS5Dn46NQ1XlQ0cPR9SBe5dimPALvP96rtfglD6n8sKsM97dPns91raECo8bZK12TnZ
         ErflTuuEouLzhaHOrkLt5K1InBPd1B64RtPfbemS8kYXirj7dGHjoPMbgAc05RfKqprN
         BumkzeRso/6VUXQEJZVOEMPXXCBJqIPMF9EIlcX2hE9LKX0k+98fORl8fK3gJPcLKEup
         TYdA==
X-Gm-Message-State: AOAM532qXWbnmUc1+sQAUCjbe4T+EpeLO2djTahraQPrKZQC9C2qxA5u
        AmqstGnTP34iaRr8oiBLpOEIuzVoIJehbguIeTEx5+CQ65DSigVGupYij+OgIs4a12/yG5xK8El
        7ZyOC2agQeLwB53J5KNoPzdm8fjWV2nHdsNZjE0ouxH7tAD1gbwDzr0UB2bsYURw=
X-Google-Smtp-Source: ABdhPJxGWPYPe8Nb5GBu01Eu0xfTcQLh9hX4cVcDwkgQTVdqOof+cqMJr/hDwVdgCrQLZq1CJTHGCVPgNsYLfQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:787:b029:2dd:15b6:515a with SMTP
 id g7-20020a056a000787b02902dd15b6515amr6680433pfu.26.1621546033988; Thu, 20
 May 2021 14:27:13 -0700 (PDT)
Date:   Thu, 20 May 2021 21:26:54 +0000
Message-Id: <20210520212654.712276-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH] KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vm_get_max_gfn() casts vm->max_gfn from a uint64_t to an unsigned int,
which causes the upper 32-bits of the max_gfn to get truncated.

Nobody noticed until now likely because vm_get_max_gfn() is only used
as a mechanism to create a memslot in an unused region of the guest
physical address space (the top), and the top of the 32-bit physical
address space was always good enough.

This fix reveals a bug in memslot_modification_stress_test which was
trying to create a dummy memslot past the end of guest physical memory.
Fix that by moving the dummy memslot lower.

Fixes: 52200d0d944e ("KVM: selftests: Remove duplicate guest mode handling")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c     |  2 +-
 .../testing/selftests/kvm/lib/perf_test_util.c |  2 +-
 .../kvm/memslot_modification_stress_test.c     | 18 +++++++++++-------
 4 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 84982eb02b29..5d9b35d09251 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -303,7 +303,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
 unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
-unsigned int vm_get_max_gfn(struct kvm_vm *vm);
+uint64_t vm_get_max_gfn(struct kvm_vm *vm);
 int vm_get_fd(struct kvm_vm *vm);
 
 unsigned int vm_calc_num_guest_pages(enum vm_guest_mode mode, size_t size);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1af1009254c4..aeffbb1e7c7d 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2058,7 +2058,7 @@ unsigned int vm_get_page_shift(struct kvm_vm *vm)
 	return vm->page_shift;
 }
 
-unsigned int vm_get_max_gfn(struct kvm_vm *vm)
+uint64_t vm_get_max_gfn(struct kvm_vm *vm)
 {
 	return vm->max_gfn;
 }
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 81490b9b4e32..ed4424ed26d6 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -80,7 +80,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	 */
 	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
 		    "Requested more guest memory than address space allows.\n"
-		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
+		    "    guest pages: %lx max gfn: %lx vcpus: %d wss: %lx]\n",
 		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
 		    vcpu_memory_bytes);
 
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 6096bf0a5b34..98351ba0933c 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -71,14 +71,22 @@ struct memslot_antagonist_args {
 };
 
 static void add_remove_memslot(struct kvm_vm *vm, useconds_t delay,
-			      uint64_t nr_modifications, uint64_t gpa)
+			       uint64_t nr_modifications)
 {
+	const uint64_t pages = 1;
+	uint64_t gpa;
 	int i;
 
+	/*
+	 * Add the dummy memslot just below the perf_test_util memslot, which is
+	 * at the top of the guest physical address space.
+	 */
+	gpa = guest_test_phys_mem - pages * vm_get_page_size(vm);
+
 	for (i = 0; i < nr_modifications; i++) {
 		usleep(delay);
 		vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa,
-					    DUMMY_MEMSLOT_INDEX, 1, 0);
+					    DUMMY_MEMSLOT_INDEX, pages, 0);
 
 		vm_mem_region_delete(vm, DUMMY_MEMSLOT_INDEX);
 	}
@@ -120,11 +128,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Started all vCPUs\n");
 
 	add_remove_memslot(vm, p->memslot_modification_delay,
-			   p->nr_memslot_modifications,
-			   guest_test_phys_mem +
-			   (guest_percpu_mem_size * nr_vcpus) +
-			   perf_test_args.host_page_size +
-			   perf_test_args.guest_page_size);
+			   p->nr_memslot_modifications);
 
 	run_vcpus = false;
 
-- 
2.31.1.818.g46aad6cb9e-goog

