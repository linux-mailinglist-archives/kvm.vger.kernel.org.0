Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBE451B32C
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 01:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381822AbiEDXFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 19:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379891AbiEDXAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 19:00:39 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259FE580DD
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 15:53:39 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id j187-20020a638bc4000000b003c1922b0f1bso1355115pge.3
        for <kvm@vger.kernel.org>; Wed, 04 May 2022 15:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=dFBe1lmgUuHfgVEf/tWxUdsjz8V/jIyv1HB3zTqy8d4=;
        b=gUIn0iKG/RJ6GvoYEmstIRITXyAtpehhtZpI5KlyTDmXmDCxmvXoCaRAIjNy0bvsj+
         0Rr36FjT3G4TWn/IGVUKeS2vqTtfGoXyg3JPXDvB4JymtdUUYWCjbiaOMu4yuQlwPMya
         cA1wjotdw4yJtuaM73VHgXy3K+c/QBRXaS0OZv+CHmETsBFVkRRjOHDUcMqkuqDSJ6sD
         oXGRxNctSTYu8yYSoc12aYEJrNL8KXfaDwT6ETxmSfUk+5sKqwSPJqMLIHkn1orexrda
         OKDN3Lif6bTpYlCxUX7vhPB2u4/mZKuE6EyCxgzMt0pjsqAvzXp7ACyxguLd06COt6eC
         NL2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=dFBe1lmgUuHfgVEf/tWxUdsjz8V/jIyv1HB3zTqy8d4=;
        b=XFn06ZMfHfqjyRXxgodyIBB8WQ9Wf/sjwcOjVci5CBdNmkMdkA4ik5VgTJxTsAnRLR
         Dra42xdzv+G8JWfQGSkwBL/trHTRRDiCnFiNJpTr4PP0De3A1n9qMZ//9ZkbOzuU+vBa
         Bd2lAqYxy9yFdG0zhY8VDJHSQTIa8o6SPK/crqop9A8HdFM1wPO3lHi5isTSZ0NLTbfy
         sMmCK9b+I1QI3tgCkBu6zoaKkDgKvUicm18lxxBR96YLfVinpItNMeRARgWVLbfP/eHp
         rMtGTjYJwzhlFlY27lUm1Gq5tLoE0yWLP1BelQgHSN96NlZCf4frMsL6X2LvODX0rDW9
         76vg==
X-Gm-Message-State: AOAM533u5UoCUuWHRXTq8Vn/0NwOq3w3VA6l1hLKFSppYcvGe3Dd0oTl
        b0GMLlbGPIeydv5b1M9B74WMS6cIqDg=
X-Google-Smtp-Source: ABdhPJy7czNhLhfLpBDbJ9Qzf8nvp7Cs7jqZHyJfSrtrQRieDYfcDTd6otPWsu9HkJCAwnDIctCRazIWH0w=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:244b:b0:15e:9b15:4890 with SMTP id
 l11-20020a170903244b00b0015e9b154890mr20515502pls.160.1651704785043; Wed, 04
 May 2022 15:53:05 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  4 May 2022 22:49:10 +0000
In-Reply-To: <20220504224914.1654036-1-seanjc@google.com>
Message-Id: <20220504224914.1654036-125-seanjc@google.com>
Mime-Version: 1.0
References: <20220504224914.1654036-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH 124/128] KVM: selftests: Drop @slot0_mem_pages from __vm_create_with_vcpus()
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

All callers of __vm_create_with_vcpus() pass DEFAULT_GUEST_PHY_PAGES for
@slot_mem_pages; drop the param and just hardcode the "default" as the
base number of pages for slot0.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  9 +++-----
 .../selftests/kvm/kvm_page_table_test.c       |  5 ++---
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++------------
 .../selftests/kvm/lib/perf_test_util.c        |  4 ++--
 4 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 6fdb2abffcd9..7867f6c7ae2c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -542,18 +542,15 @@ static inline struct kvm_vm *vm_create(uint64_t nr_pages)
 	return __vm_create(VM_MODE_DEFAULT, nr_pages);
 }
 
-/* Like vm_create_default_with_vcpus, but accepts mode and slot0 memory as a parameter */
 struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
-				      uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
-				      uint32_t num_percpu_pages, void *guest_code,
-				      struct kvm_vcpu *vcpus[]);
+				      uint64_t extra_mem_pages, uint32_t num_percpu_pages,
+				      void *guest_code, struct kvm_vcpu *vcpus[]);
 
 static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
 						  void *guest_code,
 						  struct kvm_vcpu *vcpus[])
 {
-	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus,
-				      DEFAULT_GUEST_PHY_PAGES, 0, 0,
+	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, 0, 0,
 				      guest_code, vcpus);
 }
 
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 0f8792aa0366..a68c57572ab4 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -254,9 +254,8 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 
 	/* Create a VM with enough guest pages */
 	guest_num_pages = test_mem_size / guest_page_size;
-	vm = __vm_create_with_vcpus(mode, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
-				    guest_num_pages, 0, guest_code,
-				    test_args.vcpus);
+	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages, 0,
+				    guest_code, test_args.vcpus);
 
 	/* Align down GPA of the testing memslot */
 	if (!p->phys_offset)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index a8af75167b7a..a63acd40bcf5 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -284,7 +284,6 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
  * Input Args:
  *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
  *   nr_vcpus - VCPU count
- *   slot0_mem_pages - Slot0 physical memory size
  *   extra_mem_pages - Non-slot0 physical memory total size
  *   num_percpu_pages - Per-cpu physical memory pages
  *   guest_code - Guest entry point
@@ -295,15 +294,13 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
  * Return:
  *   Pointer to opaque structure that describes the created VM.
  *
- * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K),
- * with customized slot0 memory size, at least 512 pages currently.
+ * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K).
  * extra_mem_pages is only used to calculate the maximum page table size,
  * no real memory allocation for non-slot0 memory in this function.
  */
 struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
-				      uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
-				      uint32_t num_percpu_pages, void *guest_code,
-				      struct kvm_vcpu *vcpus[])
+				      uint64_t extra_mem_pages, uint32_t num_percpu_pages,
+				      void *guest_code, struct kvm_vcpu *vcpus[])
 {
 	uint64_t vcpu_pages, extra_pg_pages, pages;
 	struct kvm_vm *vm;
@@ -311,10 +308,6 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 
 	TEST_ASSERT(!nr_vcpus || vcpus, "Must provide vCPU array");
 
-	/* Force slot0 memory size not small than DEFAULT_GUEST_PHY_PAGES */
-	if (slot0_mem_pages < DEFAULT_GUEST_PHY_PAGES)
-		slot0_mem_pages = DEFAULT_GUEST_PHY_PAGES;
-
 	/* The maximum page table size for a memory region will be when the
 	 * smallest pages are used. Considering each page contains x page
 	 * table descriptors, the total extra size for page tables (for extra
@@ -322,8 +315,8 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 	 * than N/x*2.
 	 */
 	vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
-	extra_pg_pages = (slot0_mem_pages + extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
-	pages = slot0_mem_pages + vcpu_pages + extra_pg_pages;
+	extra_pg_pages = (DEFAULT_GUEST_PHY_PAGES + extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
+	pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
 
 	TEST_ASSERT(nr_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
 		    "nr_vcpus = %d too large for host, max-vcpus = %d",
@@ -344,8 +337,8 @@ struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
 	struct kvm_vcpu *vcpus[1];
 	struct kvm_vm *vm;
 
-	vm = __vm_create_with_vcpus(VM_MODE_DEFAULT, 1, DEFAULT_GUEST_PHY_PAGES,
-				    extra_mem_pages, 0, guest_code, vcpus);
+	vm = __vm_create_with_vcpus(VM_MODE_DEFAULT, 1, extra_mem_pages, 0,
+				    guest_code, vcpus);
 
 	*vcpu = vcpus[0];
 	return vm;
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index f62d773eb29c..656f309584aa 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -144,8 +144,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int nr_vcpus,
 	 * The memory is also added to memslot 0, but that's a benign side
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
-	vm = __vm_create_with_vcpus(mode, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
-				    guest_num_pages, 0, guest_code, vcpus);
+	vm = __vm_create_with_vcpus(mode, nr_vcpus, guest_num_pages, 0,
+				    guest_code, vcpus);
 
 	pta->vm = vm;
 
-- 
2.36.0.464.gb9c8b46e94-goog

