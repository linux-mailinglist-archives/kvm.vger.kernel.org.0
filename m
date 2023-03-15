Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB8FB6BA517
	for <lists+kvm@lfdr.de>; Wed, 15 Mar 2023 03:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCOCS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 22:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbjCOCSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 22:18:15 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8AD1A97F
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:13 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-54352648c1eso67494057b3.9
        for <kvm@vger.kernel.org>; Tue, 14 Mar 2023 19:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678846692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mEznPiSbaCiL3Is+YrkLXyxUf5ngMg4h6AMinScVsr8=;
        b=rK9UyswBaIu0UH0YhRLrss1oWLImqUxJ0kHaA+Mvi9LLmgXQ8qZzzPlEOrqKt9Yna8
         LnrzZy7Yp+yAlVR/xToeAVB12A6L4//vPZvAY6NeZV77Rl3Hl4k4ar6TfaBA+tDFl1Kp
         8VQZZOhqibGW6RGfQJAbpDG8Ff/uEiKpr90OPsh2vYHmT2vK/pkVfshiw1WjfQO+hvyt
         YpwsR6rWKLUpelimw6xPxwC2kTnoRAU/Yli+8c+xrLT41YOVnDAHoQ3z34qL1efnEwzT
         BRk382sCgQd8YkpYGsGUsVx4ATciCbKISj07oPASI4ThK3RCsv39RhmGDFVYzyJgarsZ
         wdBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678846692;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mEznPiSbaCiL3Is+YrkLXyxUf5ngMg4h6AMinScVsr8=;
        b=emSvwqohUG9dp+1LvHnyWs0mselU7Ofrw5pxzbUfqgAO6sg4emBohsM74yOhs4l1om
         3UFAa6ORzcQKqDgl/PBg5Z9GtXs+w/Qosx9658Ld6nWzHRWD+C4ojm0UqmFCOgJiy/ba
         7iG+w4WuTr4r/v0+eZzm4BUC7lCC/lVb3HesToK0SBPzpF1oAvPGINSc2Zz+UMM6RFTa
         i5bUQudpPK/zDa1BJh6jHQbDcIxXqxXW0SB4cLo/8aw9Wd6NaIaPX24JujR6Ld2jVGAJ
         lu6zq6Saq4lGmgmWNeav9946GYbCiqU906RX2H+iXO/1fEtVakh1ntuWB4JlvkyWOXPj
         tFdg==
X-Gm-Message-State: AO0yUKVJzjwj/dVZIfWD6WEG74KT1XFJ0mA+CLLKQJYoOsEZrboOEw75
        jkRYSYs0UHq6zecoqGcuhTroin22XMMrqw==
X-Google-Smtp-Source: AK7set/RdS/9R9oHQI5q5i/HXDVp2pGT2xrQzO3YHU5x6YhhiA3qZI47xn5heoBvXFf5xn7ePttCWCrPr+1gPg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a81:a782:0:b0:541:6763:3ce1 with SMTP id
 e124-20020a81a782000000b0054167633ce1mr8809567ywh.2.1678846692636; Tue, 14
 Mar 2023 19:18:12 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:17:37 +0000
In-Reply-To: <20230315021738.1151386-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230315021738.1151386-1-amoorthy@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230315021738.1151386-14-amoorthy@google.com>
Subject: [WIP Patch v2 13/14] KVM: selftests: Add memslot_flags parameter to memstress_create_vm
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com
Cc:     jthoughton@google.com, kvm@vger.kernel.org,
        Anish Moorthy <amoorthy@google.com>
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
 tools/testing/selftests/kvm/access_tracking_perf_test.c     | 2 +-
 tools/testing/selftests/kvm/demand_paging_test.c            | 6 ++++--
 tools/testing/selftests/kvm/dirty_log_perf_test.c           | 2 +-
 tools/testing/selftests/kvm/include/memstress.h             | 2 +-
 tools/testing/selftests/kvm/lib/memstress.c                 | 4 ++--
 .../selftests/kvm/memslot_modification_stress_test.c        | 2 +-
 6 files changed, 10 insertions(+), 8 deletions(-)

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
index f8c1831614a9d..607cd2846e39c 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -146,8 +146,10 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int i, num_uffds = 0;
 	uint64_t uffd_region_size;
 
-	vm = memstress_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
-				 p->src_type, p->partition_vcpu_memory_access);
+	vm = memstress_create_vm(
+		mode, nr_vcpus, guest_percpu_mem_size,
+		1, 0,
+		p->src_type, p->partition_vcpu_memory_access);
 
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
2.40.0.rc1.284.g88254d51c5-goog

