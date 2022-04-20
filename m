Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41C47508E86
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381215AbiDTRie (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381180AbiDTRiU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:38:20 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51DA3969C
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:33 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id u8-20020a170903124800b0015195a5826cso1212654plh.4
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F7BTz3UYuckCYc6h4+8BkViO+YHmKFw1VG8oiYkTzgM=;
        b=sCbgwuLgrv/khlU2vBDG9v2HoneCXMOefIYAuUa2j8GPOgjPwbLpi3He5El5tUNQWE
         sn3aLRY2eF2M6d2nMevXGxh+c4CUTrgq+r04sTXUr6kpDOWM++gCGLNFXYDM5mFIDN9a
         e3J3FMxgXibPjcmAuViSZAWDf67HQoB4CHv8RtQvFnCPHfwcl3ZQFpmMJmIahfGtxzPe
         5LzxUo+Vw79XjvPzwxjJyKVRWSEomgNehatsabJbFPOxeUQ38HJlEtEGYruM9HcBqzYa
         yNjLH82tSmw0QzYVndCUBnfgOvDOt2I9wji+bK31sqetJEgwM2tcXfDA4FqEAehLrrAd
         LirA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F7BTz3UYuckCYc6h4+8BkViO+YHmKFw1VG8oiYkTzgM=;
        b=z/oU5M3gPU+YluO4JhpS+0So9kbJpuk8GQBxwsCSbB1KcXCmWScehH29APMsJ2wxiC
         b3EVLFI+QJ3sHx4h3RjVu7hKeqwroA8r7dj3F23fwcCxfc+NsFpLDK75s1l123qyJFMR
         rTzoSg110sQfRGypD32X/W7GpZyLigrFozkKf1jSINSSNSz4H9DXgWAT5fsf8afc/U1j
         PsvuJY/LqOARFjD9iGFglbAuaUMx/Qq96FPTlMxbnCfb/ZrLI4ODo57tA+0ryI+Yss60
         gChbEp/uzLdOMJYx1pMJPWO+v1HU4DlRrj4bYWtJRDf4WjgHosoxUhFy2NaA+qtIyDov
         rB/A==
X-Gm-Message-State: AOAM5312jMaPmBW+ipg3ePsuAXAacySGhstRZYgNdsBibFRZPV9CfGul
        VMIX1V6yjtQEp195A38hGhxu3lTlLeVT
X-Google-Smtp-Source: ABdhPJza1o9TizJ9V4m5v3pPsQ19ezTv5C2RbqVG53c878oDXhLABn9JLz07ry5Y2Xh7dwlngHlQjg66I0Qa
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6ea6:489a:aad6:761c])
 (user=bgardon job=sendgmr) by 2002:a17:90b:4a92:b0:1d2:8f4c:feee with SMTP id
 lp18-20020a17090b4a9200b001d28f4cfeeemr5654544pjb.41.1650476133363; Wed, 20
 Apr 2022 10:35:33 -0700 (PDT)
Date:   Wed, 20 Apr 2022 10:35:12 -0700
In-Reply-To: <20220420173513.1217360-1-bgardon@google.com>
Message-Id: <20220420173513.1217360-10-bgardon@google.com>
Mime-Version: 1.0
References: <20220420173513.1217360-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v6 09/10] KVM: selftests: Factor out calculation of pages
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the calculation of the number of pages needed for a VM to
make it easier to separate creating the VM and adding vCPUs.

Reviewed-by: David Matlack <dmatlack@google.com>
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
index 9896cc49eb54..392abd3c323d 100644
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
2.36.0.rc0.470.gd361397f0d-goog

