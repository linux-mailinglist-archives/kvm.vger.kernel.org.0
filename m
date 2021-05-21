Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B516338CC60
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 19:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238242AbhEURj6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 13:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234956AbhEURjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 May 2021 13:39:55 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C030BC061574
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 10:38:31 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id s5-20020aa78d450000b02902ace63a7e93so12884709pfe.8
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 10:38:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=xdGv0OCyISv0+o0WfZ9E36lugmUmFkFPCE+9HuHmiFo=;
        b=tws0Kf7f5L/2Gwcun3oTIPiZ6BcC7MezDjAMMISE3AGuhML7tnmgye1zNnqOnpoFvo
         32RR3qJonuAxF/3slmxzRx0lZr5DEfTDXyUen7mh2jxb6U1lVUIWj//jzL2l5eMfNUFm
         Nw48qW6T13fs+JmWnHUdQ3wkGPyyMjk0XCzocrT+eGnjHRcnQi5U0eKqlMl/vuXwzCvi
         cpuCZSuDIbN0FZFXMO7X5//wdCe9n9xFQu8Lj0hkDeUvIgilg0+jLnUpijD2urVsS9DP
         g/iujR+uEYiPHQs1QDqfeY1PmdPhpDAosPk0Ce3TrHB0PgqP+3wxqp+0ETBTfGzo3mTf
         L/iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=xdGv0OCyISv0+o0WfZ9E36lugmUmFkFPCE+9HuHmiFo=;
        b=aNjBI58CdGFWAq9p8GVGdJnWMiGwg0NlUFikryafJJi23S3jZvlKQCYEHzVaSMHejr
         29H5qqTP4o3+dkST+QIbtoSGaVvhBoMVHOxhF4BATYSWxhE6QLnxtiRst8530YxAJj5t
         R/z1AurrSWLqx/B11Jm51ETXe5mouK/ihIZlZR/KCm7RNUu0dCZbXmRIWdtU+bA4MdDP
         PknkEhk0QQLVETV/Wg3SUO4BHdsPxGQH/UwZhV/f7ZkcOwHFV1PqBpnJgkPe6ZBhg2jG
         SCDsN1bBkCjXTB4QeqQuGQhRSWLkqwXZOUFwscaHJFxiCSjPZasGeD4gHWGcOYL3TJYG
         Nn5g==
X-Gm-Message-State: AOAM531fksSG3lUg+1M67OcdFe+Vq24QUhlHHbGo5TNJ1pynOvGrHvyV
        phiIw8rka+3vNJuW9SC878s7c6dtJKNMDLe26VQaxBigS0be2ILUBLaAbqGHM2ZuZh/IA/sQoef
        94ifV3k22Jz39b7PC00GhKjosOTMkY7sZyVQG3LI3gA4TtEaOUXq4zvMiUPr26AE=
X-Google-Smtp-Source: ABdhPJxnpsTU8PnjyyNFBMud+YBLmfmd78OkBsf1wTmW8Bt2hM19YVd9RD1SPyQmoDp5xS/DCbe55NZmBUxQpw==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:29c4:: with SMTP id
 h62mr12331562pjd.177.1621618711076; Fri, 21 May 2021 10:38:31 -0700 (PDT)
Date:   Fri, 21 May 2021 17:38:28 +0000
Message-Id: <20210521173828.1180619-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH v2] KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org, Venkatesh Srinivas <venkateshs@chromium.org>
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
Reviewed-by: Venkatesh Srinivas <venkateshs@chromium.org>
Signed-off-by: David Matlack <dmatlack@google.com>
---

v1 -> v2:
 - Added Venkatesh's R-b line.
 - Used PRIx64 to print uint64_t instead of %lx.

 tools/testing/selftests/kvm/include/kvm_util.h |  2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c     |  2 +-
 .../testing/selftests/kvm/lib/perf_test_util.c |  4 +++-
 .../kvm/memslot_modification_stress_test.c     | 18 +++++++++++-------
 4 files changed, 16 insertions(+), 10 deletions(-)

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
index 81490b9b4e32..abf381800a59 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -2,6 +2,7 @@
 /*
  * Copyright (C) 2020, Google LLC.
  */
+#include <inttypes.h>
 
 #include "kvm_util.h"
 #include "perf_test_util.h"
@@ -80,7 +81,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	 */
 	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
 		    "Requested more guest memory than address space allows.\n"
-		    "    guest pages: %lx max gfn: %x vcpus: %d wss: %lx]\n",
+		    "    guest pages: %" PRIx64 " max gfn: %" PRIx64
+		    " vcpus: %d wss: %" PRIx64 "]\n",
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

