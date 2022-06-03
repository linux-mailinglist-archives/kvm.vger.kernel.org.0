Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6059D53C2DD
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240267AbiFCA4c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241217AbiFCAu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:50:29 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19B132043
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:47:44 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id v3-20020a1709028d8300b00163fc70a4dbso3467139plo.19
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:47:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=N9Gry8VczxXnWSfDRSE9e8v6DYqSsDG5vuiHaCWrBjk=;
        b=QN+A6cFHLzyjzlBXY1owXF7+yi2NhK9QGD67wUxrLw2moXoy7f+0O7G23MHZG7zom3
         Y00xr66ySRJwWSbE2NZJ23WFC/vqTv1AB0t4gIAmFkdlEEW9PqBM6JF0Y5JdAehNb2LD
         mvX2rITlYqWrScqs712BIt9sMZRRCiwuE0VPdQrJXuIsIWXft4SDIPpBNh6DudrepBPK
         SXF7RfgXNRi1iBS8/cvuU/WezLYDFTb4M/hRIUgPdab7RN8W9v2/VHqDxBey8rIYvOIJ
         E9u6DEgoxubgM5/e7+G2vkmZCc3SPrYXBOH0fsFFABA5Qx30iHwP5ceVfLHcaTVPAV0W
         VYsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=N9Gry8VczxXnWSfDRSE9e8v6DYqSsDG5vuiHaCWrBjk=;
        b=ZIo1MP//aXIre3/GVbv65GmggNL6nN0YCNdQSjdikFwVvgkAqM/1YANTk2P6oqdYsY
         dAXxoGhYyEpk4FBo5fI75+QMzqyiiipB6XwjkD93mjHVdvInOgVYbMy03tZls9knDRs2
         C9sV0wCHedPxih7mls4LduAQbPeCvRfLtabJkgtObl/OTkzANhFyC90+6ro9Q9Sxkz2l
         qzAxcH9MvdThMJ0y1/M0FxZq31tXLkyvVVQpONOYe5PvWlhFNHAlW1oC7ak40HFCv+jb
         Uev6LnBFjQyAcJcWR6npFY4gmDnJKjOgELd15diTbOMCLuTvLX4KxXF8PdtrBEkFNySt
         GvcQ==
X-Gm-Message-State: AOAM5328FZYt3S4iws6nMQQ5vbpY4ID7l39H7VmSCr/6pBG9vGxmCMOR
        HbL0VUiYu7Y3Zq3ZRhcY5Nl3J4k4qR8=
X-Google-Smtp-Source: ABdhPJw6BBqkx846FSdRja5dk88XZjZ/XYOFmW+jZXG0F24dY1V1oIxPVkXQzzFqcFaceks33ky1WAAUpjM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:228c:b0:163:baf6:582a with SMTP id
 b12-20020a170903228c00b00163baf6582amr7554349plh.43.1654217262359; Thu, 02
 Jun 2022 17:47:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:43:23 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-137-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 136/144] KVM: selftests: Drop @slot0_mem_pages from __vm_create_with_vcpus()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index 45f536f99399..f84e01612c52 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -561,18 +561,15 @@ static inline struct kvm_vm *vm_create(uint64_t nr_pages)
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
index 855ea3dbf8f1..f68234a2ee83 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -280,7 +280,6 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
  * Input Args:
  *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
  *   nr_vcpus - VCPU count
- *   slot0_mem_pages - Slot0 physical memory size
  *   extra_mem_pages - Non-slot0 physical memory total size
  *   num_percpu_pages - Per-cpu physical memory pages
  *   guest_code - Guest entry point
@@ -291,15 +290,13 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
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
@@ -307,10 +304,6 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 
 	TEST_ASSERT(!nr_vcpus || vcpus, "Must provide vCPU array");
 
-	/* Force slot0 memory size not small than DEFAULT_GUEST_PHY_PAGES */
-	if (slot0_mem_pages < DEFAULT_GUEST_PHY_PAGES)
-		slot0_mem_pages = DEFAULT_GUEST_PHY_PAGES;
-
 	/* The maximum page table size for a memory region will be when the
 	 * smallest pages are used. Considering each page contains x page
 	 * table descriptors, the total extra size for page tables (for extra
@@ -318,8 +311,8 @@ struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus
 	 * than N/x*2.
 	 */
 	vcpu_pages = (DEFAULT_STACK_PGS + num_percpu_pages) * nr_vcpus;
-	extra_pg_pages = (slot0_mem_pages + extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
-	pages = slot0_mem_pages + vcpu_pages + extra_pg_pages;
+	extra_pg_pages = (DEFAULT_GUEST_PHY_PAGES + extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
+	pages = DEFAULT_GUEST_PHY_PAGES + vcpu_pages + extra_pg_pages;
 
 	TEST_ASSERT(nr_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
 		    "nr_vcpus = %d too large for host, max-vcpus = %d",
@@ -340,8 +333,8 @@ struct kvm_vm *__vm_create_with_one_vcpu(struct kvm_vcpu **vcpu,
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
2.36.1.255.ge46751e96f-goog

