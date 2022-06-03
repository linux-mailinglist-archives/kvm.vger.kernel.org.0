Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0618E53C228
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiFCAyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240622AbiFCArb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:31 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E2824A
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:48 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id y11-20020aa7804b000000b0051ba2c16046so3476646pfm.20
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MPgzvQxFGMahxtdA/6O7orJ/XzllDICCkjKusRmOEac=;
        b=SZ0V9hHYykV5NOYNk0mA2DDERh0XJA9VMQwRNWl2qCw8fYzX8Hw4IQyFmPT5l05QlX
         N3wempi9eSalQYv98lAO+1plYUotHURCoSahLANOk1f02lrENM2oEP4tASj0PuO8G00r
         /bZOBQDepAohKMR6gAHxzrLHlmi+wX1JDYAvd1V75qu0PzrpQo6OoeM80oPkyb9lWCGr
         ZpC3s6eOZfSTxp4//Nu4jc6ofS+Eq3S8Ek02RnCh5ArRmm74rc/1H985TjfWt8DQgzE8
         1iZr9Ol00qyHcPKq+uqtUs3G2KihZX6F4m6W42/yu1Qf1rvPauCRJU8O41625vqDjYGw
         BfdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MPgzvQxFGMahxtdA/6O7orJ/XzllDICCkjKusRmOEac=;
        b=TPHMaWUmS7yNSd4DCz8z9vvXleb1N/HpsgsfxOi8D119qPLES67p4i7SKKashDn8ge
         kR/fD9BV+PIYGRia1VFrv3gg4WUMcVHtVFEju7khycwf0nlHWy0OZanLE37PbuG3NDDT
         c4/JJEYZU1CRsHOhvrYeVpC573OAVFO2z5mWP81SCpPousNvGOFN04cO1O1pCI3e61OR
         MpuXoMzyJSDrwT8HOIsVD2Op47+H5ozaZTQbmYLDnroCHxoUStdezKHZqBZ/mr7HdQ7o
         U9u3k0kLaSwY1bbiiCe9zJNcRUo/V3xgzBK8P+xTqsFHc1Cb9lMyYpx7kvDUWj8X21LC
         nWiA==
X-Gm-Message-State: AOAM530LRLxfrObXROnn37oDHCl/KJKbW79HNMMRSWXiZa0LXc5g4RDd
        Rb/Kz1cc3521jV90iIFQb4O/Wjax6oE=
X-Google-Smtp-Source: ABdhPJwiSSHOYhuCWgZoe5jTP5oo6yUMHE0HGpJC/qQHig86nL5OqfQABfaBvk5XEq0m/dZ0Nw5IThd4hZU=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:e8d6:b0:161:ea52:cd52 with SMTP id
 v22-20020a170902e8d600b00161ea52cd52mr7503959plg.71.1654217208242; Thu, 02
 Jun 2022 17:46:48 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:53 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-107-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 106/144] KVM: selftests: Add VM creation helper that
 "returns" vCPUs
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

Add a VM creator that "returns" the created vCPUs by filling the provided
array.  This will allow converting multi-vCPU tests away from hardcoded
vCPU IDs.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h       | 17 +++++++++++++----
 .../testing/selftests/kvm/kvm_page_table_test.c |  4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c      | 17 ++++++++++-------
 .../testing/selftests/kvm/lib/perf_test_util.c  |  4 ++--
 4 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 2c7a8a91ebe2..c0b2158a53d5 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -563,10 +563,19 @@ struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_me
 					    uint32_t vcpuids[]);
 
 /* Like vm_create_default_with_vcpus, but accepts mode and slot0 memory as a parameter */
-struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
-				    uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
-				    uint32_t num_percpu_pages, void *guest_code,
-				    uint32_t vcpuids[]);
+struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+				      uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
+				      uint32_t num_percpu_pages, void *guest_code,
+				      uint32_t vcpuids[], struct kvm_vcpu *vcpus[]);
+
+static inline struct kvm_vm *vm_create_with_vcpus(uint32_t nr_vcpus,
+						  void *guest_code,
+						  struct kvm_vcpu *vcpus[])
+{
+	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus,
+				      DEFAULT_GUEST_PHY_PAGES, 0, 0,
+				      guest_code, NULL, vcpus);
+}
 
 /*
  * Create a VM with a single vCPU with reasonable defaults and @extra_mem_pages
diff --git a/tools/testing/selftests/kvm/kvm_page_table_test.c b/tools/testing/selftests/kvm/kvm_page_table_test.c
index 2c4a7563a4f8..e91bc7f1400d 100644
--- a/tools/testing/selftests/kvm/kvm_page_table_test.c
+++ b/tools/testing/selftests/kvm/kvm_page_table_test.c
@@ -268,8 +268,8 @@ static struct kvm_vm *pre_init_before_test(enum vm_guest_mode mode, void *arg)
 
 	/* Create a VM with enough guest pages */
 	guest_num_pages = test_mem_size / guest_page_size;
-	vm = vm_create_with_vcpus(mode, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
-				  guest_num_pages, 0, guest_code, NULL);
+	vm = __vm_create_with_vcpus(mode, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
+				    guest_num_pages, 0, guest_code, NULL, NULL);
 
 	/* Align down GPA of the testing memslot */
 	if (!p->phys_offset)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 8ed1baf6b0eb..132a591ba029 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -296,12 +296,13 @@ struct kvm_vm *__vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
  * extra_mem_pages is only used to calculate the maximum page table size,
  * no real memory allocation for non-slot0 memory in this function.
  */
-struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
-				    uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
-				    uint32_t num_percpu_pages, void *guest_code,
-				    uint32_t vcpuids[])
+struct kvm_vm *__vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+				      uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
+				      uint32_t num_percpu_pages, void *guest_code,
+				      uint32_t vcpuids[], struct kvm_vcpu *vcpus[])
 {
 	uint64_t vcpu_pages, extra_pg_pages, pages;
+	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
 	int i;
 
@@ -328,7 +329,9 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 	for (i = 0; i < nr_vcpus; ++i) {
 		uint32_t vcpuid = vcpuids ? vcpuids[i] : i;
 
-		vm_vcpu_add(vm, vcpuid, guest_code);
+		vcpu = vm_vcpu_add(vm, vcpuid, guest_code);
+		if (vcpus)
+			vcpus[i] = vcpu;
 	}
 
 	return vm;
@@ -338,8 +341,8 @@ struct kvm_vm *vm_create_default_with_vcpus(uint32_t nr_vcpus, uint64_t extra_me
 					    uint32_t num_percpu_pages, void *guest_code,
 					    uint32_t vcpuids[])
 {
-	return vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
-				    extra_mem_pages, num_percpu_pages, guest_code, vcpuids);
+	return __vm_create_with_vcpus(VM_MODE_DEFAULT, nr_vcpus, DEFAULT_GUEST_PHY_PAGES,
+				      extra_mem_pages, num_percpu_pages, guest_code, vcpuids, NULL);
 }
 
 struct kvm_vm *vm_create_default(uint32_t vcpuid, uint64_t extra_mem_pages,
diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index 722df3a28791..5b80ba7f12e4 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -139,8 +139,8 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	 * The memory is also added to memslot 0, but that's a benign side
 	 * effect as KVM allows aliasing HVAs in meslots.
 	 */
-	vm = vm_create_with_vcpus(mode, vcpus, DEFAULT_GUEST_PHY_PAGES,
-				  guest_num_pages, 0, guest_code, NULL);
+	vm = __vm_create_with_vcpus(mode, vcpus, DEFAULT_GUEST_PHY_PAGES,
+				    guest_num_pages, 0, guest_code, NULL, NULL);
 
 	pta->vm = vm;
 
-- 
2.36.1.255.ge46751e96f-goog

