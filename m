Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8B8244CE17
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234357AbhKKAGZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234334AbhKKAGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:22 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65C98C061208
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:34 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id y18-20020a17090abd1200b001a4dcd1501cso1913247pjr.4
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oPOrXyFFJcoT+Z6YSOHN3QIBuNHlfGqSkus829P7wUs=;
        b=HmmNcD0/Ux+zJgM2j5LP7dO7EmXmk6eYphyXlBE3G+c1zU99DAeR+sAQb8oUnax8L+
         7xnSZ83lllU2uP8ZvkIovMs0TCAf89cO55ehEoTx8wG5oYlFKz6FBamG31Hs9FCv6P4Y
         op7xVq5I+Wln12exuyiReNUudTogX9x0wvWMMHXJOveMSk8kPvN9BIM8fqxraRaeHJj7
         A5GMOZl5G0CQBINsWsVYjquErPdWCSvBsrUDDV5KDelstCqK+AwgcYnA8Wx7LXrEVW8P
         sSpwgzsjv0m7Zw4Ffs2rSJR3NvXpDOJ3GDESlgztTBibJDyFfCiAZh6yyxWgO5/idDrc
         w+bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oPOrXyFFJcoT+Z6YSOHN3QIBuNHlfGqSkus829P7wUs=;
        b=iHSjBETS7yr/qFOuHCiJsqoJEANUN3+C0FoCzeHHGZ48hmlZfGu7hN7DpiAncnBa5u
         jN66yhsEwDkAZAL/Ex91rVdkzBK/6I1ZO0o30sJQE79m6DkwQVxbfgQUMHKABjo+pxOF
         +ev7MOAAKcasxU1QWkfoDnqCxZ/l3/OVL3l6tiEVJEBAmgPRxeeouxLPvKyKLWHCkeFf
         JmAzbpVoRE3fDusKK7F9NZcRUwqZzvon9I2R4fyyZPbEZzVnYH5uFbPnCCqQNsR4vFxz
         n2aaU1v1Wf1IfNHcoUUWwxtG2B5j+XZJi7J47y/2WHyxv5b2I5UbPJBbh8VHmh345xyk
         KpEw==
X-Gm-Message-State: AOAM533eAHsNKHt9cxy1BSN9LAC5zpLWnSlolCwecpOny38VfV9ssvAN
        qzvLJcOwxKYQqJgUIRJMJr7UiwnarEqPGQ==
X-Google-Smtp-Source: ABdhPJxBV31vclE73Z220pV0LyLT21CYMtHJcdMU4+LvkT5ouC22LkcXdK4DanPShvVJiNLnBdY72aTZj49AsA==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a05:6a00:807:b0:49f:d6ab:590c with SMTP
 id m7-20020a056a00080700b0049fd6ab590cmr2979208pfk.32.1636589013916; Wed, 10
 Nov 2021 16:03:33 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:03:09 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 11/12] KVM: selftests: Fill per-vCPU struct during
 "perf_test" VM creation
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

Fill the per-vCPU args when creating the perf_test VM instead of having
the caller do so.  This helps ensure that any adjustments to the number
of pages (and thus vcpu_memory_bytes) are reflected in the per-VM args.
Automatically filling the per-vCPU args will also allow a future patch
to do the sync to the guest during creation.

Signed-off-by: Sean Christopherson <seanjc@google.com>
[Updated access_tracking_perf_test as well.]
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/access_tracking_perf_test.c |  5 +-
 .../selftests/kvm/demand_paging_test.c        |  5 +-
 .../selftests/kvm/dirty_log_perf_test.c       |  6 +-
 .../selftests/kvm/include/perf_test_util.h    |  6 +-
 .../selftests/kvm/lib/perf_test_util.c        | 71 ++++++++++---------
 .../kvm/memslot_modification_stress_test.c    |  6 +-
 6 files changed, 45 insertions(+), 54 deletions(-)

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 5d95113c7b7c..fdef6c906388 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -332,10 +332,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int vcpus = params->vcpus;
 
 	vm = perf_test_create_vm(mode, vcpus, params->vcpu_memory_bytes, 1,
-				 params->backing_src);
-
-	perf_test_setup_vcpus(vm, vcpus, params->vcpu_memory_bytes,
-			      !overlap_memory_access);
+				 params->backing_src, !overlap_memory_access);
 
 	vcpu_threads = create_vcpu_threads(vcpus);
 
diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/testing/selftests/kvm/demand_paging_test.c
index 3c729a0a1ab1..0fee44f5e5ae 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -293,7 +293,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int r;
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
-				 p->src_type);
+				 p->src_type, p->partition_vcpu_memory_access);
 
 	perf_test_args.wr_fract = 1;
 
@@ -307,9 +307,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
 	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
 
-	perf_test_setup_vcpus(vm, nr_vcpus, guest_percpu_mem_size,
-			      p->partition_vcpu_memory_access);
-
 	if (p->uffd_mode) {
 		uffd_handler_threads =
 			malloc(nr_vcpus * sizeof(*uffd_handler_threads));
diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 7ffab5bd5ce5..62f9cc2a3146 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -186,7 +186,8 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	struct timespec clear_dirty_log_total = (struct timespec){0};
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size,
-				 p->slots, p->backing_src);
+				 p->slots, p->backing_src,
+				 p->partition_vcpu_memory_access);
 
 	perf_test_args.wr_fract = p->wr_fract;
 
@@ -206,9 +207,6 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
 	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
 
-	perf_test_setup_vcpus(vm, nr_vcpus, guest_percpu_mem_size,
-			      p->partition_vcpu_memory_access);
-
 	sync_global_to_guest(vm, perf_test_args);
 
 	/* Start the iterations */
diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
index 9348580dc5be..91804be1cf53 100644
--- a/tools/testing/selftests/kvm/include/perf_test_util.h
+++ b/tools/testing/selftests/kvm/include/perf_test_util.h
@@ -39,10 +39,8 @@ extern struct perf_test_args perf_test_args;
 
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   uint64_t vcpu_memory_bytes, int slots,
-				   enum vm_mem_backing_src_type backing_src);
+				   enum vm_mem_backing_src_type backing_src,
+				   bool partition_vcpu_memory_access);
 void perf_test_destroy_vm(struct kvm_vm *vm);
-void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
-			   uint64_t vcpu_memory_bytes,
-			   bool partition_vcpu_memory_access);
 
 #endif /* SELFTEST_KVM_PERF_TEST_UTIL_H */
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index b3154b5b0cfd..13c8bc22f4e1 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -48,9 +48,43 @@ static void guest_code(uint32_t vcpu_id)
 	}
 }
 
+void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
+			   uint64_t vcpu_memory_bytes,
+			   bool partition_vcpu_memory_access)
+{
+	struct perf_test_args *pta = &perf_test_args;
+	struct perf_test_vcpu_args *vcpu_args;
+	int vcpu_id;
+
+	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
+		vcpu_args = &pta->vcpu_args[vcpu_id];
+
+		vcpu_args->vcpu_id = vcpu_id;
+		if (partition_vcpu_memory_access) {
+			vcpu_args->gva = guest_test_virt_mem +
+					 (vcpu_id * vcpu_memory_bytes);
+			vcpu_args->pages = vcpu_memory_bytes /
+					   pta->guest_page_size;
+			vcpu_args->gpa = pta->gpa + (vcpu_id * vcpu_memory_bytes);
+		} else {
+			vcpu_args->gva = guest_test_virt_mem;
+			vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
+					   pta->guest_page_size;
+			vcpu_args->gpa = pta->gpa;
+		}
+
+		vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
+
+		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
+			 vcpu_id, vcpu_args->gpa, vcpu_args->gpa +
+			 (vcpu_args->pages * pta->guest_page_size));
+	}
+}
+
 struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 				   uint64_t vcpu_memory_bytes, int slots,
-				   enum vm_mem_backing_src_type backing_src)
+				   enum vm_mem_backing_src_type backing_src,
+				   bool partition_vcpu_memory_access)
 {
 	struct perf_test_args *pta = &perf_test_args;
 	struct kvm_vm *vm;
@@ -119,6 +153,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	/* Do mapping for the demand paging memory slot */
 	virt_map(vm, guest_test_virt_mem, pta->gpa, guest_num_pages);
 
+	perf_test_setup_vcpus(vm, vcpus, vcpu_memory_bytes, partition_vcpu_memory_access);
+
 	ucall_init(vm, NULL);
 
 	return vm;
@@ -129,36 +165,3 @@ void perf_test_destroy_vm(struct kvm_vm *vm)
 	ucall_uninit(vm);
 	kvm_vm_free(vm);
 }
-
-void perf_test_setup_vcpus(struct kvm_vm *vm, int vcpus,
-			   uint64_t vcpu_memory_bytes,
-			   bool partition_vcpu_memory_access)
-{
-	struct perf_test_args *pta = &perf_test_args;
-	struct perf_test_vcpu_args *vcpu_args;
-	int vcpu_id;
-
-	for (vcpu_id = 0; vcpu_id < vcpus; vcpu_id++) {
-		vcpu_args = &pta->vcpu_args[vcpu_id];
-
-		vcpu_args->vcpu_id = vcpu_id;
-		if (partition_vcpu_memory_access) {
-			vcpu_args->gva = guest_test_virt_mem +
-					 (vcpu_id * vcpu_memory_bytes);
-			vcpu_args->pages = vcpu_memory_bytes /
-					   pta->guest_page_size;
-			vcpu_args->gpa = pta->gpa + (vcpu_id * vcpu_memory_bytes);
-		} else {
-			vcpu_args->gva = guest_test_virt_mem;
-			vcpu_args->pages = (vcpus * vcpu_memory_bytes) /
-					   pta->guest_page_size;
-			vcpu_args->gpa = pta->gpa;
-		}
-
-		vcpu_args_set(vm, vcpu_id, 1, vcpu_id);
-
-		pr_debug("Added VCPU %d with test mem gpa [%lx, %lx)\n",
-			 vcpu_id, vcpu_args->gpa, vcpu_args->gpa +
-			 (vcpu_args->pages * pta->guest_page_size));
-	}
-}
diff --git a/tools/testing/selftests/kvm/memslot_modification_stress_test.c b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
index d105180d5e8c..27af0bb8deb7 100644
--- a/tools/testing/selftests/kvm/memslot_modification_stress_test.c
+++ b/tools/testing/selftests/kvm/memslot_modification_stress_test.c
@@ -105,16 +105,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	int vcpu_id;
 
 	vm = perf_test_create_vm(mode, nr_vcpus, guest_percpu_mem_size, 1,
-				 VM_MEM_SRC_ANONYMOUS);
+				 VM_MEM_SRC_ANONYMOUS,
+				 p->partition_vcpu_memory_access);
 
 	perf_test_args.wr_fract = 1;
 
 	vcpu_threads = malloc(nr_vcpus * sizeof(*vcpu_threads));
 	TEST_ASSERT(vcpu_threads, "Memory allocation failed");
 
-	perf_test_setup_vcpus(vm, nr_vcpus, guest_percpu_mem_size,
-			      p->partition_vcpu_memory_access);
-
 	/* Export the shared variables to the guest */
 	sync_global_to_guest(vm, perf_test_args);
 
-- 
2.34.0.rc1.387.gb447b232ab-goog

