Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1948851B323
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381869AbiEDXFc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379922AbiEDXAk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 19:00:40 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86525996B
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:39 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id bj12-20020a170902850c00b0015adf30aaccso1367551plb.15
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uOr41+tdJVYLxDkWuJx6M0IYtFi7QOjS3AiAeI8OZ2o=;
        b=BYM2feCQSonfux390GUnTv2hcP+gXRIGb6zQ/OjqfKZmbdV9xPk3UnkzvDTRRyE9rZ
         uKnhq1c7y8Vo1Tgr1MGiwb8YO/EOxA3No9KRP5xYd36YdpXi+b9ejGy3SxkONe2zE9rG
         Y4SBVuDvnvUXvjq01xFEW637Rs0eChQ3udqFL4j7SKBIh61d0KrmdlW6cd8jTL3+mtKA
         Ks9zpTj4vUFRd544Y/hveN9jecRYExI4eFk3PErVs378LjjcHii/eaRnQWyMFK/+PZ3A
         V7v3dL6dnzCM9LXBsQynEmCCct3E/Rda+j2WoFAcm8HiHinwmdbtvHGHROOnjvvMeIQj
         RYEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uOr41+tdJVYLxDkWuJx6M0IYtFi7QOjS3AiAeI8OZ2o=;
        b=AurYq6TUSzDPu0DW3vhCL90mPepSP+uuEKmjU/t94G667UwuuUVckKXUZKYdq4hNc+
         BmROuEehMzPpG64qC9zBLJH2wsQOdGHx/CVd+KqubB96KoxAetFlMxd/J4kK2Y7FGfaB
         +Fj/S69JwFDafMcTI8s4ZRc0XENN8tF9v7YcwsJNX5ZlZ3XznQPcItckwU/boRR/fFnU
         CoVvt1GnegrsxlYAMOyhJUUWHPEEOo90uAZOkHXd/75uUXpwYM4df+X6zm2CHdOf6g88
         Fmx8qJxKRY7SEIPfYbrJky6tLkvAAPjuK+CmSeDM9iwsxfyORY8Ut23kLTMKilXasvU6
         n2yA==
X-Gm-Message-State: AOAM531DFXQxXqwfz66yvAXUV+yDaMvOoqdILOqfDsBucMKiRZLfWr1R
        dwudaQcjjqgYEwNHRe2PcHn8C42p58k=
X-Google-Smtp-Source: ABdhPJyoOaiCnsxksGom3aVlnpl26L3vB02cHkhbJZpmvsj/W0iDbjAknTMM4gxcfUhtvEw8jU63ySySaho=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:198f:b0:50e:7e6:6d5c with SMTP id
 d15-20020a056a00198f00b0050e07e66d5cmr11509289pfl.20.1651704786747; Wed, 04
 May 2022 15:53:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:49:11 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-126-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 125/128] KVM: selftests: Drop @num_percpu_pages from __vm_create_with_vcpus()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop @num_percpu_pages from __vm_create_with_vcpus(), all callers pass
'0' and there's unlikely to be a test that allocates just enough memory
that it needs a per-CPU allocation, but not so much that it won't just do
its own memory management.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util_base.h | 4 ++--
 tools/testing/selftests/kvm/kvm_page_table_test.c   | 2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c          | 7 +++----
 tools/testing/selftests/kvm/lib/perf_test_util.c    | 2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 7867f6c7ae2c..b9c806982dbd 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -543,14 +543,14 @@ static inline struct kvm_vm *vm_create(uint64_t nr_pages)
 }
 
 struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
-				      uint64_t extra_mem_pages, uint32_t num_percpu_pages,
+				      uint64_t extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[]);
 
 static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
 						  void *guest_code,
 						  struct kvm_vcpu *vcpus[])
 {
-	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, 0, 0,
+	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, 0,
 				      guest_code, vcpus);
 }
 
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index a68c57572ab4..f42c6ac6d71d 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -254,7 +254,7 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 
 	/* Create a VM with enough guest pages */
 	guest_num_pages = test_mem_size / guest_page_size;
-	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages, 0,
+	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages,
 				    guest_code, test_args.vcpus);
 
 	/* Align down GPA of the testing memslot */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a63acd40bcf5..a8bbafc67d97 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -285,7 +285,6 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
  *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
  *   nr_vcpus - VCPU count
  *   extra_mem_pages - Non-slot0 physical memory total size
- *   num_percpu_pages - Per-cpu physical memory pages
  *   guest_code - Guest entry point
  *   vcpuids - VCPU IDs
  *
@@ -299,7 +298,7 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
  * no real memory allocation for non-slot0 memory in this function.
  */
 struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
-				      uint64_t extra_mem_pages, uint32_t num_percpu_pages,
+				      uint64_t extra_mem_pages,
 				      void *guest_code, struct kvm_vcpu *vcpus[])
 {
 	uint64_t vcpu_pages, extra_pg_pages, pages;
@@ -314,7 +313,7 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 	 * N pages) will be: N/x+N/x^2+N/x^3+... which is definitely smaller
 	 * than N/x*2.
 	 */
-	vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
+	vcpu_pages = nr_vcpus * DEFAULT_STACK_PGS;
 	extra_pg_pages = (DEFAULT_GUEST_PHY_PAGES + extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
 	pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
 
@@ -337,7 +336,7 @@ struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 	struct kvm_vcpu *vcpus[1];
 	struct kvm_vm *vm;
 
-	vm = __vm_create_with_vcpus(VM_MODE_DEFAULT, 1, extra_mem_pages, 0,
+	vm = __vm_create_with_vcpus(VM_MODE_DEFAULT, 1, extra_mem_pages,
 				    guest_code, vcpus);
 
 	*vcpu = vcpus[0];
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 656f309584aa..1f25ed69ca98 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -144,7 +144,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * The memory is also added to memslot 0, but that's a benign side
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
-	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages, 0,
+	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages,
 				    guest_code, vcpus);
 
 	pta->vm = vm;
-- 
2.36.0.464.gb9c8b46e94-goog

