Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61155EFCC2
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 20:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbiI2SMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 14:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235182AbiI2SMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 14:12:20 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0BD41F4968
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:12:19 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y65-20020a25c844000000b006bb773548d5so1785747ybf.5
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 11:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=vHwzS54Y53ehavJ4BjQpYa5xOZkQhZYDuoBBs+bJ/jI=;
        b=lwDERgBwa1EJAvI80jJ6JXqDMnDLG9U/Vd9k65ZLWYAKQCpmLpxraEW2TPoJSBKFyR
         K3yZ+t/RoUxnvncJ5uyv4TcLJbpXBl/y1yLDfPV8l0E5oL+jigMh12YjAQYm14rKMjs8
         dj25DGEvxTNoeASvdONfJTYJgmJxH/DnhcQKof7nJEjuIhW8uuDOVRJ2AaLx2XI9AGjH
         6VndFybeBpBa7usrqIPHAyq8L/o/CjkAqe5Af2Kf0TwkCzzZKPjES22vXHKq572fAk05
         YSgv+KNuuGCmIRLN9R1YOUURyBxuFujuC1ncD7i3C1VGY1gZImWiKRteUFje9J+WbzX/
         iT6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=vHwzS54Y53ehavJ4BjQpYa5xOZkQhZYDuoBBs+bJ/jI=;
        b=7rGnwF7B3z3SNpDepgmlbMmp1v+h0H6Onp5DSrWuBxUhkhS9FoTXI1F2ga4C90du42
         3wAjhKDCj/YgJ/5lZ+1A0tHHijjLZtPdE92TjU+tHbnv6rWBbqScysr/hZ57MQ8BKTzI
         OQf1DOmjiwgKeKPpYa5LpWfmSZ7zqoTzqKKwmS164H8c3JQChLrSwSlwBVm1/zWQ6nk6
         GayS69Fdrc/Z6VgPn0r4RRju+1YnJSY0nXyfkMsWe2ZnnOv+qB4kNzjRffDEmM/0ZLfP
         tMn/y8kAYt59LxVjAAzYdiaf9FJiH6tobnRry41yZCgKB5VecHNuiNZVitFlueaUD19y
         R4rg==
X-Gm-Message-State: ACrzQf2bJPK+e1NtTi4kNmIL1l/9s/DRtXitgpqx8q8Y72Iam61F3+BQ
        d7AnJOs0RO6hhmQYhd1k3KHst+4n5/7wxA==
X-Google-Smtp-Source: AMsMyM4zTO9rm9N+mHBBXa5+EZ9+aFDcbTzTRBBDnOZfEUlZa+Yt5h0701ROfsGLmU66kA88J+R37wdNVRHEsQ==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:2448:0:b0:6bc:a7ee:60ba with SMTP id
 k69-20020a252448000000b006bca7ee60bamr4582854ybk.232.1664475139405; Thu, 29
 Sep 2022 11:12:19 -0700 (PDT)
Date:   Thu, 29 Sep 2022 11:12:07 -0700
In-Reply-To: <20220929181207.2281449-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220929181207.2281449-1-dmatlack@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20220929181207.2281449-4-dmatlack@google.com>
Subject: [PATCH v3 3/3] KVM: selftests: Fix nx_huge_pages_test on TDP-disabled hosts
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>, kvm@vger.kernel.org
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

Map the test's huge page region with 2MiB virtual mappings when TDP is
disabled so that KVM can shadow the region with huge pages. This fixes
nx_huge_pages_test on hosts where TDP hardware support is disabled.

Purposely do not skip this test on TDP-disabled hosts. While we don't
care about NX Huge Pages on TDP-disabled hosts from a security
perspective, KVM does support it, and so we should test it.

For TDP-enabled hosts, continue mapping the region with 4KiB pages to
ensure that KVM can map it with huge pages irrespective of the guest
mappings.

Fixes: 8448ec5993be ("KVM: selftests: Add NX huge pages test")
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  4 +++
 .../selftests/kvm/lib/x86_64/processor.c      | 27 +++++++++++++++++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c | 19 +++++++++++--
 3 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0cbc71b7af50..e8ca0d8a6a7e 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -825,6 +825,8 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
 }
 
+bool kvm_is_tdp_enabled(void);
+
 uint64_t vm_get_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
 				 uint64_t vaddr);
 void vm_set_page_table_entry(struct kvm_vm *vm, struct kvm_vcpu *vcpu,
@@ -855,6 +857,8 @@ enum pg_level {
 #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
 
 void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
+void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		    uint64_t nr_bytes, int level);
 
 /*
  * Basic CPU control in CR0
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index fab0f526fb81..39c4409ef56a 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -111,6 +111,14 @@ static void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent)
 	}
 }
 
+bool kvm_is_tdp_enabled(void)
+{
+	if (is_intel_cpu())
+		return get_kvm_intel_param_bool("ept");
+	else
+		return get_kvm_amd_param_bool("npt");
+}
+
 void virt_arch_pgd_alloc(struct kvm_vm *vm)
 {
 	TEST_ASSERT(vm->mode == VM_MODE_PXXV48_4K, "Attempt to use "
@@ -214,6 +222,25 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
 }
 
+void virt_map_level(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		    uint64_t nr_bytes, int level)
+{
+	uint64_t pg_size = PG_LEVEL_SIZE(level);
+	uint64_t nr_pages = nr_bytes / pg_size;
+	int i;
+
+	TEST_ASSERT(nr_bytes % pg_size == 0,
+		    "Region size not aligned: nr_bytes: 0x%lx, page size: 0x%lx",
+		    nr_bytes, pg_size);
+
+	for (i = 0; i < nr_pages; i++) {
+		__virt_pg_map(vm, vaddr, paddr, level);
+
+		vaddr += pg_size;
+		paddr += pg_size;
+	}
+}
+
 static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
 					  struct kvm_vcpu *vcpu,
 					  uint64_t vaddr)
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index cc6421716400..8c1181a5ba56 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -112,6 +112,7 @@ void run_test(int reclaim_period_ms, bool disable_nx_huge_pages,
 {
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
+	uint64_t nr_bytes;
 	void *hva;
 	int r;
 
@@ -141,10 +142,24 @@ void run_test(int reclaim_period_ms, bool disable_nx_huge_pages,
 				    HPAGE_GPA, HPAGE_SLOT,
 				    HPAGE_SLOT_NPAGES, 0);
 
-	virt_map(vm, HPAGE_GVA, HPAGE_GPA, HPAGE_SLOT_NPAGES);
+	nr_bytes = HPAGE_SLOT_NPAGES * vm->page_size;
+
+	/*
+	 * Ensure that KVM can map HPAGE_SLOT with huge pages by mapping the
+	 * region into the guest with 2MiB pages whenever TDP is disabled (i.e.
+	 * whenever KVM is shadowing the guest page tables).
+	 *
+	 * When TDP is enabled, KVM should be able to map HPAGE_SLOT with huge
+	 * pages irrespective of the guest page size, so map with 4KiB pages
+	 * to test that that is the case.
+	 */
+	if (kvm_is_tdp_enabled())
+		virt_map_level(vm, HPAGE_GVA, HPAGE_GPA, nr_bytes, PG_LEVEL_4K);
+	else
+		virt_map_level(vm, HPAGE_GVA, HPAGE_GPA, nr_bytes, PG_LEVEL_2M);
 
 	hva = addr_gpa2hva(vm, HPAGE_GPA);
-	memset(hva, RETURN_OPCODE, HPAGE_SLOT_NPAGES * PAGE_SIZE);
+	memset(hva, RETURN_OPCODE, nr_bytes);
 
 	check_2m_page_count(vm, 0);
 	check_split_count(vm, 0);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

