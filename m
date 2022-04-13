Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE00B4FFD58
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 20:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbiDMSDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 14:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237607AbiDMSC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 14:02:28 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EE041604
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:00:04 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id f12-20020a170902ce8c00b0015874d582e8so1548188plg.7
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3UKcgaouWDljoBhDJNavl7iHJ9K4UWQ5k+7D01IUkUU=;
        b=i1LjNyj0MfWmClJT9PfmfWxlCGWG1mhzWBvkSRz4Hwmt2mE12WeqUlJ2ktSPAWym7p
         2lceXs2Ff5HmbmubdwUFXPqbvPDNnD26dUUz3C7nKYW7Ol8ZGz+TbasHddOngbsv7M22
         Rm/Y0C4ulAOrpjWMCxARkkPhjEhweZ4zzLmh8WlRzPD1u3nnikEzmmsLLOjl55/0cX7q
         iHd2HBP9IcAQB5JXMMA0yM38wgkXg5F5vQEyZB/0/z5egSRt9khEg/oS6WW8O7J+ofNb
         Lrg9o+7uJpBVNv+QEYewY6Okig2iZRfkaYE+KIPpM+aWuc5zOYfbj7Hy6R0awrlbI1tW
         B4JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3UKcgaouWDljoBhDJNavl7iHJ9K4UWQ5k+7D01IUkUU=;
        b=mrKogw5CHx2Rx/0K+T/mcHWGqu0rxZagBNsDDeARkohLTmGmvRY1NCJSybNA5K8UO/
         M6GomIsd7X2rIq9ZaGBqfBfxYiOoCcsBmfnl6HW+JCT0EnqPjIxNDKdnFS17c4xWlr4M
         fCFjMG/CvNA/GcwdgBHM6Tj1Wp0WmIOarAuNgg5XWNXwUAbcr7GXi7xqAgme4yZOkWjQ
         e3avOZ+FVsGxj29FfBn1xRila0TzFDZG4AeBDa8TOFMOM4/ds/ubEZgkz/vZBh2z3hzn
         e/IdCfKPD6KYZrht3SLz/yxOarRTHxTmXcxEi7OlaVsYx92fh/Xy1wMKc8jtZxpJn4vr
         Wi/A==
X-Gm-Message-State: AOAM533miNu/ywJmX1eU/6V6b3h4T0O9zdZlnuzMbggPDxgzUIlsvCzX
        mneAve0Hc1EUfg9DnLI3H00gvDS5ioX/
X-Google-Smtp-Source: ABdhPJxEgv3bZO/MXBspajYZ97mvWEzxbBffsN8qoEnCjAE++uaayaerZdHkHynBoa07zL4ad89k0EzRJ/Ns
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:c087:f2f2:f5f0:f73])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:22c7:b0:505:9c6e:de39 with SMTP
 id f7-20020a056a0022c700b005059c6ede39mr23398922pfj.79.1649872804260; Wed, 13
 Apr 2022 11:00:04 -0700 (PDT)
Date:   Wed, 13 Apr 2022 10:59:43 -0700
In-Reply-To: <20220413175944.71705-1-bgardon@google.com>
Message-Id: <20220413175944.71705-10-bgardon@google.com>
Mime-Version: 1.0
References: <20220413175944.71705-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 09/10] KVM: selftests: Factor out calculation of pages
 needed for a VM
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Factor out the calculation of the number of pages needed for a VM to
make it easier to separate creating the VM and adding vCPUs.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 59 ++++++++++++++-----
 2 files changed, 47 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 001b55ae25f8..1dac3c6607f1 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -312,6 +312,10 @@ vm_paddr_t vm_phy_pages_alloc(struct kvm_vm *vm, size_t num,
 			      vm_paddr_t paddr_min, uint32_t memslot);
 vm_paddr_t vm_alloc_page_table(struct kvm_vm *vm);
 
+uint64_t vm_pages_needed(enum vm_guest_mode mode, uint32_t nr_vcpus,
+			 uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
+			 uint32_t num_percpu_pages);
+
 /*
  * Create a VM with reasonable defaults
  *
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index d332f02370d1..5ffed44ab328 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -377,7 +377,7 @@ struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
 }
 
 /*
- * VM Create with customized parameters
+ * Get the number of pages needed for a VM
  *
  * Input Args:
  *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
@@ -385,27 +385,17 @@ struct kvm_vm *vm_create_without_vcpus(enum vm_guest_mode mode, uint64_t pages)
  *   slot0_mem_pages - Slot0 physical memory size
  *   extra_mem_pages - Non-slot0 physical memory total size
  *   num_percpu_pages - Per-cpu physical memory pages
- *   guest_code - Guest entry point
- *   vcpuids - VCPU IDs
  *
  * Output Args: None
  *
  * Return:
- *   Pointer to opaque structure that describes the created VM.
- *
- * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K),
- * with customized slot0 memory size, at least 512 pages currently.
- * extra_mem_pages is only used to calculate the maximum page table size,
- * no real memory allocation for non-slot0 memory in this function.
+ *   The number of pages needed for the VM.
  */
-struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
-				    uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
-				    uint32_t num_percpu_pages, void *guest_code,
-				    uint32_t vcpuids[])
+uint64_t vm_pages_needed(enum vm_guest_mode mode, uint32_t nr_vcpus,
+			 uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
+			 uint32_t num_percpu_pages)
 {
 	uint64_t vcpu_pages, extra_pg_pages, pages;
-	struct kvm_vm *vm;
-	int i;
 
 	/* Force slot0 memory size not small than DEFAULT_GUEST_PHY_PAGES */
 	if (slot0_mem_pages < DEFAULT_GUEST_PHY_PAGES)
@@ -421,11 +411,48 @@ struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
 	extra_pg_pages = (slot0_mem_pages + extra_mem_pages + vcpu_pages) / PTES_PER_MIN_PAGE * 2;
 	pages = slot0_mem_pages + vcpu_pages + extra_pg_pages;
 
+	pages = vm_adjust_num_guest_pages(mode, pages);
+
+	return pages;
+}
+
+/*
+ * VM Create with customized parameters
+ *
+ * Input Args:
+ *   mode - VM Mode (e.g. VM_MODE_P52V48_4K)
+ *   nr_vcpus - VCPU count
+ *   slot0_mem_pages - Slot0 physical memory size
+ *   extra_mem_pages - Non-slot0 physical memory total size
+ *   num_percpu_pages - Per-cpu physical memory pages
+ *   guest_code - Guest entry point
+ *   vcpuids - VCPU IDs
+ *
+ * Output Args: None
+ *
+ * Return:
+ *   Pointer to opaque structure that describes the created VM.
+ *
+ * Creates a VM with the mode specified by mode (e.g. VM_MODE_P52V48_4K),
+ * with customized slot0 memory size, at least 512 pages currently.
+ * extra_mem_pages is only used to calculate the maximum page table size,
+ * no real memory allocation for non-slot0 memory in this function.
+ */
+struct kvm_vm *vm_create_with_vcpus(enum vm_guest_mode mode, uint32_t nr_vcpus,
+				    uint64_t slot0_mem_pages, uint64_t extra_mem_pages,
+				    uint32_t num_percpu_pages, void *guest_code,
+				    uint32_t vcpuids[])
+{
+	uint64_t pages;
+	struct kvm_vm *vm;
+	int i;
+
 	TEST_ASSERT(nr_vcpus <= kvm_check_cap(KVM_CAP_MAX_VCPUS),
 		    "nr_vcpus = %d too large for host, max-vcpus = %d",
 		    nr_vcpus, kvm_check_cap(KVM_CAP_MAX_VCPUS));
 
-	pages = vm_adjust_num_guest_pages(mode, pages);
+	pages = vm_pages_needed(mode, nr_vcpus, slot0_mem_pages,
+				extra_mem_pages, num_percpu_pages);
 
 	vm = vm_create_without_vcpus(mode, pages);
 
-- 
2.35.1.1178.g4f1659d476-goog

