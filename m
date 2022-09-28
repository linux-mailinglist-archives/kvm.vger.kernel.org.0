Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEC35EE49C
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 20:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234051AbiI1StJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 14:49:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234100AbiI1StH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 14:49:07 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DB1EFA47
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:49:05 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a10-20020a5b0aca000000b006b05bfb6ab0so11887823ybr.9
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=DRbk7AZvRYHRYi7wFDkcB2FJmrkOC/4Javo36Re7Ndw=;
        b=bCYLv3E9c+QLVPgmfZszrxBwupEgG0KmSw9VK8uHWsNOHoLDcjLSYNIIPiazxfYBMV
         g95b3fEypyIC1zuLJI9JsA/1XEYQBqoqHiHbN4MUKgKGc33wfF1L9F4S68EDmi1jLyTs
         SuhugW9VH8xpS73zffDrPkh+h1IA3S/buYSOJJGCGVJCuZeCt7s9ZZIehz/JyZuLdRWT
         xEwH+6b6jTpdmAb9+DEjwEkg2nNnX99aASGpnnXLIy7OkrF+rzwuiYhBgJXBr0v2gswY
         8VWZisbygrKVkzlaMN7UZeCB+bBVVYFQgoPNfyd+OIr4IzMIfVjYdo+63xFEug9n2hgx
         2MvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=DRbk7AZvRYHRYi7wFDkcB2FJmrkOC/4Javo36Re7Ndw=;
        b=0yDeNGIkKi5MlGlZtAJoZvHD5/Z0UQEK10RYuJQvPOw2khCWCVUIZa4LN3BCC5YfZB
         koBT9UGNiBE/B9mdmgK5Keg194vVuDzgUMqsV6JyanHynZEx0lBsnigU636tkIvIM1RL
         vxrPdZrzsrCilARYa+K7f5w4ge6xNDVvKfXMfHNmGAmAb1bkNumO4VGq9pXzJHzkh2YP
         odHCl+WpETm/kTygHU1PDdrmiaOBu9Kz54aDWPf3dWUPRc00MXMAokxDRHAHMOjUwylu
         m4fphdJMURFLet21bQWE8TnYxpA0GRsekZK8Iqv7c2E+0FT/P06YSUJrqp7iAxpWicSD
         YwSg==
X-Gm-Message-State: ACrzQf1N9Bc5qhMNcsyBfNgug42Akt9JjmDwRRJHJGRx/Ike9ldordvF
        fPcbS/azNtVD2vKl+q2zr5YvI+yTVQE1RA==
X-Google-Smtp-Source: AMsMyM7wwu4g+yYMiTgbyHHsWFzlyRIGM70eAs9pvnpwMqEHBOFyaWsgJi9eUZDprh9aRCDtWCJPtgLeJbfM8Q==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:1442:b0:696:4962:a73 with SMTP
 id a2-20020a056902144200b0069649620a73mr31126637ybv.386.1664390944541; Wed,
 28 Sep 2022 11:49:04 -0700 (PDT)
Date:   Wed, 28 Sep 2022 11:48:53 -0700
In-Reply-To: <20220928184853.1681781-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220928184853.1681781-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220928184853.1681781-4-dmatlack@google.com>
Subject: [PATCH v2 3/3] KVM: selftests: Fix nx_huge_pages_test on TDP-disabled hosts
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
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
index 0cbc71b7af50..3082c2a4089b 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -825,6 +825,8 @@ static inline uint8_t wrmsr_safe(uint32_t msr, uint64_t val)
 	return kvm_asm_safe("wrmsr", "a"(val & -1u), "d"(val >> 32), "c"(msr));
 }
 
+bool kvm_tdp_enabled(void);
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
index 522d3e2009fb..5b2ee0c32e27 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -111,6 +111,14 @@ static void sregs_dump(FILE *stream, struct kvm_sregs *sregs, uint8_t indent)
 	}
 }
 
+bool kvm_tdp_enabled(void)
+{
+	if (is_amd_cpu())
+		return get_module_param_bool("kvm_amd", "npt");
+	else
+		return get_module_param_bool("kvm_intel", "ept");
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
index cc6421716400..e50e3a50ed9d 100644
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
+	if (kvm_tdp_enabled())
+		virt_map_level(vm, HPAGE_GVA, HPAGE_GPA, nr_bytes, PG_LEVEL_4K);
+	else
+		virt_map_level(vm, HPAGE_GVA, HPAGE_GPA, nr_bytes, PG_LEVEL_2M);
 
 	hva = addr_gpa2hva(vm, HPAGE_GPA);
-	memset(hva, RETURN_OPCODE, HPAGE_SLOT_NPAGES * PAGE_SIZE);
+	memset(hva, RETURN_OPCODE, nr_bytes);
 
 	check_2m_page_count(vm, 0);
 	check_split_count(vm, 0);
-- 
2.37.3.998.g577e59143f-goog

