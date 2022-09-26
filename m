Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D585EAF37
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 20:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbiIZSIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 14:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbiIZSHs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 14:07:48 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A32BF61
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 10:52:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b18-20020a253412000000b006b0177978eeso6504077yba.21
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 10:52:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=TzTdhz8BhtFitnWuIvfdpebQMSyglvBrW2AfRQ4FnSI=;
        b=PGgy1pYnKmN4e3fNie0bIPegv/abVlfkk7lD5mv+6tgp61+p1i1mDPPTVP4zJR7qvv
         o0T99WGDb5hPhIUvGOH99uOqU8q1obehqItE9+eVzC2KuxT1b6cDqm0lJ0bAIKkjlE4k
         AJOGXs530WR+Omn64R4e2xveCFao2INz/CrtGaausMMpf0fUAruQOOEchUi5JXHDRepr
         NHsXkOGq+p182eHnxavzlfIPKanfM4ZpidGht0d8SkV2gS/D1D2KeWP6ijSS+o7pThF0
         4r6EquylioB9JAWaQFowm408zCnSZzlctdZ2L6+pWIg1VZN71pN/je44bfbNL/E/65Jl
         ZKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=TzTdhz8BhtFitnWuIvfdpebQMSyglvBrW2AfRQ4FnSI=;
        b=UidSus2fAwR0wW52+ptHOD8ewirWtEXlD9IWpSt+pOBbOKMndblxI+RuQybEJ1MRSw
         /3J6+t5pJEOxzzcj7qR1dWmPFoRQVVCeFxgfzcp9U5O0gF/fxzOEmYbF1qgFpSyV103c
         PIImHSEoHYiszD4toVNuFtSiKJaCzoPdRqv+ceoB2xTy6yeMiU4hdd+sfpuqr27yFrgH
         g6tCj5BiGoZWb6/l42dlpbjC2ewVTuXqZYwn78bTXMLORJEzSBTvGayvQEogc6gm9Hgg
         0jZenR1xxTcCMdxhMryT+hmRJ2BffaqTaVNh0R7JFLPbBMhWEyv+7nYcIFFOge9oAiUb
         4hKw==
X-Gm-Message-State: ACrzQf1F4PRONIPDYQE26yZoxQWrrmQA5Jxzpajcv/Ve41oACQqP/2DC
        x773aYehk/YLqW8ZEfJbSQmH/DSu+r0dqw==
X-Google-Smtp-Source: AMsMyM4O7JtA63FRb10cK/TcyAHABAWl2NtK0x0Wf/kLUnbKTiRJkPogYQB7/g1h21HEaRT8raM0BvY59XkJLA==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a5b:cc4:0:b0:6ae:2a6c:59e6 with SMTP id
 e4-20020a5b0cc4000000b006ae2a6c59e6mr21891138ybr.59.1664214747346; Mon, 26
 Sep 2022 10:52:27 -0700 (PDT)
Date:   Mon, 26 Sep 2022 10:52:19 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220926175219.605113-1-dmatlack@google.com>
Subject: [PATCH] KVM: selftests: Fix nx_huge_pages_test on TDP-disabled hosts
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org
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

Map the test's huge page region with 2MiB virtual mappings so that KVM
can shadow the region with huge pages. This fixes nx_huge_pages_test on
hosts where TDP hardware support is disabled.

Purposely do not skip this test on TDP-disabled hosts. While we don't
care about NX Huge Pages on TDP-disabled hosts from a security
perspective, KVM does support it, and so we should test it.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h        |  2 ++
 tools/testing/selftests/kvm/lib/x86_64/processor.c  | 13 +++++++++++++
 .../selftests/kvm/x86_64/nx_huge_pages_test.c       |  9 +++++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0cbc71b7af50..4ffaa79fd8d6 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -855,6 +855,8 @@ enum pg_level {
 #define PG_SIZE_1G PG_LEVEL_SIZE(PG_LEVEL_1G)
 
 void __virt_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr, int level);
+void virt_map_2m(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		 uint64_t nr_2m_pages);
 
 /*
  * Basic CPU control in CR0
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 2e6e61bbe81b..df8a1498ea28 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -214,6 +214,19 @@ void virt_arch_pg_map(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr)
 	__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_4K);
 }
 
+void virt_map_2m(struct kvm_vm *vm, uint64_t vaddr, uint64_t paddr,
+		 uint64_t nr_2m_pages)
+{
+	int i;
+
+	for (i = 0; i < nr_2m_pages; i++) {
+		__virt_pg_map(vm, vaddr, paddr, PG_LEVEL_2M);
+
+		vaddr += PG_SIZE_2M;
+		paddr += PG_SIZE_2M;
+	}
+}
+
 static uint64_t *_vm_get_page_table_entry(struct kvm_vm *vm,
 					  struct kvm_vcpu *vcpu,
 					  uint64_t vaddr)
diff --git a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
index cc6421716400..a850769692b7 100644
--- a/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
+++ b/tools/testing/selftests/kvm/x86_64/nx_huge_pages_test.c
@@ -22,7 +22,8 @@
 #define HPAGE_GPA		(4UL << 30) /* 4G prevents collision w/ slot 0 */
 #define HPAGE_GVA		HPAGE_GPA /* GVA is arbitrary, so use GPA. */
 #define PAGES_PER_2MB_HUGE_PAGE 512
-#define HPAGE_SLOT_NPAGES	(3 * PAGES_PER_2MB_HUGE_PAGE)
+#define HPAGE_SLOT_2MB_PAGES	3
+#define HPAGE_SLOT_NPAGES	(HPAGE_SLOT_2MB_PAGES * PAGES_PER_2MB_HUGE_PAGE)
 
 /*
  * Passed by nx_huge_pages_test.sh to provide an easy warning if this test is
@@ -141,7 +142,11 @@ void run_test(int reclaim_period_ms, bool disable_nx_huge_pages,
 				    HPAGE_GPA, HPAGE_SLOT,
 				    HPAGE_SLOT_NPAGES, 0);
 
-	virt_map(vm, HPAGE_GVA, HPAGE_GPA, HPAGE_SLOT_NPAGES);
+	/*
+	 * Use 2MiB virtual mappings so that KVM can map the region with huge
+	 * pages even if TDP is disabled.
+	 */
+	virt_map_2m(vm, HPAGE_GVA, HPAGE_GPA, HPAGE_SLOT_2MB_PAGES);
 
 	hva = addr_gpa2hva(vm, HPAGE_GPA);
 	memset(hva, RETURN_OPCODE, HPAGE_SLOT_NPAGES * PAGE_SIZE);

base-commit: 372d07084593dc7a399bf9bee815711b1fb1bcf2
prerequisite-patch-id: 2e3661ba8856c29b769499bac525b6943d9284b8
-- 
2.37.3.998.g577e59143f-goog

