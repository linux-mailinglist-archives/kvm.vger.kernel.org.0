Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49486E0107
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 23:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbjDLVfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 17:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjDLVfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 17:35:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE568A7E
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id h206-20020a2521d7000000b00b8f3681db1eso3993838ybh.11
        for <kvm@vger.kernel.org>; Wed, 12 Apr 2023 14:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681335334; x=1683927334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/Enih2OM3xwbE5JxqMI9mr7glLAzseUE52pRXsIPwpY=;
        b=LJSLx2GmrRRLif5bbLyYGFln1e+mukhuEhQ8NMHWImtHxszerqlY/NKn+zz1MUyL4g
         Rlbv9IpPwkTyJx8bnss02J6GJZz2JTwlgyaXgxqHU3tn4LkPOw11BCHr/ArqNWqOxIB2
         hHqqC6FrtyMb61n7b+Ls90p9ALsXIFcnVJa/q40H84E0KOXzBt6kpUTjEjtE+ocWlBdY
         RNd/SE0HnxV79jWKOBVBGLq8MMReIJ4+vmT4abRVkyAkKHk+1t/UXey6drvtWNdrlN4i
         um/lqceHm0LhijaKXqX57GaVUClwr+zMEqAwGOYFMXAvgIRufjrICOxdPvn8Hhik5V3Q
         3yeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681335334; x=1683927334;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Enih2OM3xwbE5JxqMI9mr7glLAzseUE52pRXsIPwpY=;
        b=Lfi/X/xgHqWCQZfxH9UGPnbgVLQeYIR6T6t5RYYJJYcNQQ2O4xrdadyilZWRb21QTI
         3511oEFC3WFyeO2AGKb+SOXgmUCuNLkJlrZ0Vk6ueoKQ392S8GI3lre9+lg8KXvUAhir
         49QahhFSrypBiQKEoZwvtX3k2qHRtd1iYWTt+nnxm5YnDXuaxatSMnvkphh7qyiLiy58
         3uPXMg9+O9e9kuTrBUKbEgYiXSRn/ctRkuXGUSo2dR5JI+PK5DmvkzUoG6sX299s5hqt
         T3M1ufbJMX81UuMyDjGdjDXpEkD/jKOuU6I/lmitbmKsSC23FVzeFc9QSDKTaCe+9EVt
         ry2w==
X-Gm-Message-State: AAQBX9fVYF6xmeHhQM/P1+thjPWJeg6R2GywAGhqeqBPc2qsQWyogo1Q
        VjTPDHzL9+h/1blE1Wk58wDDxbjbesQE4g==
X-Google-Smtp-Source: AKy350ZFX3aP1qiu5losJdiyWVTYHetybhx9O9AbXDP6rP4+1JK6fQgdp+4BmbBKGbw0H30C9IftH48afs2buA==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a25:3354:0:b0:b8e:f726:d198 with SMTP id
 z81-20020a253354000000b00b8ef726d198mr5949388ybz.8.1681335334026; Wed, 12 Apr
 2023 14:35:34 -0700 (PDT)
Date:   Wed, 12 Apr 2023 21:35:09 +0000
In-Reply-To: <20230412213510.1220557-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230412213510.1220557-22-amoorthy@google.com>
Subject: [PATCH v3 21/22] KVM: selftests: Add memslot_flags parameter to memstress_create_vm()
From:   Anish Moorthy <amoorthy@google.com>
To:     pbonzini@redhat.com, maz@kernel.org
Cc:     oliver.upton@linux.dev, seanjc@google.com, jthoughton@google.com,
        amoorthy@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Memslot flags aren't currently exposed to the tests, and are just always
set to 0. Add a parameter to allow tests to manually set those flags.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 tools/testing/selftests/kvm/access_tracking_perf_test.c       | 2 +-
 tools/testing/selftests/kvm/demand_paging_test.c              | 4 ++--
 tools/testing/selftests/kvm/dirty_log_perf_test.c             | 2 +-
 tools/testing/selftests/kvm/include/memstress.h               | 2 +-
 tools/testing/selftests/kvm/lib/memstress.c                   | 4 ++--
 .../testing/selftests/kvm/memslot_modification_stress_test.c  | 2 +-
 6 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 3c7defd34f567..b51656b408b83 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -306,7 +306,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct kvm_vm *vm;
 	int nr_vcpus = params->nr_vcpus;
 
-	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1, 0,
 				 params->backing_src, !overlap_memory_access);
 
 	memstress_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index c729cee4c2055..e84dde345edbc 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -144,8 +144,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int i, num_uffds = 0;
 	uint64_t uffd_region_size;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
-				 p->src_type, p->partition_vcpu_memory_access);
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
+				1, 0, p->src_type, p->partition_vcpu_memory_access);
 
 	demand_paging_size = get_backing_src_pagesz(p->src_type);
 
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index e9d6d1aecf89c..6c8749193cfa4 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -224,7 +224,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int i;
 
 	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
-				 p->slots, p->backing_src,
+				 p->slots, 0, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
 	pr_info("Random seed: %u\n", p->random_seed);
diff --git a/tools/testing/selftests/kvm/include/memstress.h b/tools/testing/selftests/kvm/include/memstress.h
index 72e3e358ef7bd..1cba965d2d331 100644
--- a/tools/testing/selftests/kvm/include/memstress.h
+++ b/tools/testing/selftests/kvm/include/memstress.h
@@ -56,7 +56,7 @@ struct memstress_args {
 extern struct memstress_args memstress_args;
 
 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   uint64_t vcpu_memory_bytes, int slots, uint32_t slot_flags,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access);
 void memstress_destroy_vm(struct kvm_vm *vm);
diff --git a/tools/testing/selftests/kvm/lib/memstress.c b/tools/testing/selftests/kvm/lib/memstress.c
index 5f1d3173c238c..7589b8cef6911 100644
--- a/tools/testing/selftests/kvm/lib/memstress.c
+++ b/tools/testing/selftests/kvm/lib/memstress.c
@@ -119,7 +119,7 @@ void memstress_setup_vcpus(struct kvm_vm *vm, int nr_vcpus,
 }
 
 struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
-				   uint64_t vcpu_memory_bytes, int slots,
+				   uint64_t vcpu_memory_bytes, int slots, uint32_t slot_flags,
 				   enum vm_mem_backing_src_type backing_src,
 				   bool partition_vcpu_memory_access)
 {
@@ -207,7 +207,7 @@ struct kvm_vm *memstress_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 
 		vm_userspace_mem_region_add(vm, backing_src, region_start,
 					    MEMSTRESS_MEM_SLOT_INDEX + i,
-					    region_pages, 0);
+					    region_pages, slot_flags);
 	}
 
 	/* Do mapping for the demand paging memory slot */
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index 9855c41ca811f..0b19ec3ecc9cc 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -95,7 +95,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct test_params *p = arg;
 	struct kvm_vm *vm;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
+	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1, 0,
 				 VM_MEM_SRC_ANONYMOUS,
 				 p->partition_vcpu_memory_access);
 
-- 
2.40.0.577.gac1e443424-goog

