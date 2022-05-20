Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB79B52F63F
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 01:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354159AbiETXdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 19:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243528AbiETXdO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 19:33:14 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7896B199B36
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:13 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id z186-20020a6233c3000000b00510a6bc2864so4742762pfz.10
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 16:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vHJUCGMEgJqpClQFFW0EWRWWAeT42MMPHlt4o+8BnGc=;
        b=p9kSyvLQx2Zcxh3pNRyiwAII5bzE9hhRdnONEsbj4YPpdix0dmYBcRPnQocosjh5rm
         78Grm3y27uBlrAKebW/VWrBu2sD2F6ZgrcjFaZDFJh3eSpGfb/NYkHUJNT3TSSfvPDSk
         9350tPhHBwhFKHjgRTHcikraAy1tD2LW8XNO94Kz+9zhwv/LozAuuOCWXhXGPUtjMtYO
         tD+YOLEOyrDsbijG6YYheLC4cgIDIl0jVh0oP2KdVg/gtLwYrXMFt7sFNX0lk8csCq4/
         6KkQnzIbZCt7nnTI9xZpIXwWp4gkFGXL5+iWM6+EDRU2L65DSpiTUheI7D9i6x9iXXBh
         wQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vHJUCGMEgJqpClQFFW0EWRWWAeT42MMPHlt4o+8BnGc=;
        b=a79t6NZavIovrbOKyM4AQNNGkZuo4ZAZpNSATzBBuMDjDQRXC3Z6ocCnyAqweTrZmn
         9+Td6HjJIosSGl+YFwiZuAZjVuSWSslWUYcl3tIlp+M/EHw9Hb8Uy7sF4mQo6YlcKnvZ
         fCQ8jlkW3DuWJZf6TedFqYMbyL+NKJBenv+6+YAxqKbiN6fyGh3+AMBCTUSA3fF2Rsl+
         03k+ZxFx3AR6f/jE+2Q+G2QkQqdmF7sYuXvcRXiqfhhDDekOQ/DT+9pRsnTCOPig2fpS
         quc7+eifE2xQwxemBxJlzxMgaXAqpFG+v9gXOkEWMpEw6KLoVjEfJQQyd/xOs3gNpnII
         cwNQ==
X-Gm-Message-State: AOAM531CViCHql7rIBXbxzV0JrU18Czsx9TeMOm9rvML8hNxyzeMdQdD
        RiXYY1rR9yzwr1ZxWyqKsJ3h1I0rWqF7ew==
X-Google-Smtp-Source: ABdhPJxWEA52/Ew9jC+/Mr4wrmF+W4/T+jyMdqd+SSZKG+rwsjDU/8KXerbAE6YQRyofVA7xkw42+bC785bMsQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90b:164a:b0:1dc:981d:f197 with SMTP
 id il10-20020a17090b164a00b001dc981df197mr14135472pjb.228.1653089593011; Fri,
 20 May 2022 16:33:13 -0700 (PDT)
Date:   Fri, 20 May 2022 23:32:49 +0000
In-Reply-To: <20220520233249.3776001-1-dmatlack@google.com>
Message-Id: <20220520233249.3776001-12-dmatlack@google.com>
Mime-Version: 1.0
References: <20220520233249.3776001-1-dmatlack@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 11/11] KVM: selftests: Restrict test region to 48-bit
 physical addresses when using nested
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>, Peter Xu <peterx@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        David Matlack <dmatlack@google.com>
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

The selftests nested code only supports 4-level paging at the moment.
This means it cannot map nested guest physical addresses with more than
48 bits. Allow perf_test_util nested mode to work on hosts with more
than 48 physical addresses by restricting the guest test region to
48-bits.

While here, opportunistically fix an off-by-one error when dealing with
vm_get_max_gfn(). perf_test_util.c was treating this as the maximum
number of GFNs, rather than the maximum allowed GFN. This didn't result
in any correctness issues, but it did end up shifting the test region
down slightly when using huge pages.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../testing/selftests/kvm/lib/perf_test_util.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
index b2ff2cee2e51..f989ff91f022 100644
--- a/tools/testing/selftests/kvm/lib/perf_test_util.c
+++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
@@ -110,6 +110,7 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 	struct kvm_vm *vm;
 	uint64_t guest_num_pages, slot0_pages = DEFAULT_GUEST_PHY_PAGES;
 	uint64_t backing_src_pagesz = get_backing_src_pagesz(backing_src);
+	uint64_t region_end_gfn;
 	int i;
 
 	pr_info("Testing guest mode: %s\n", vm_guest_mode_string(mode));
@@ -151,18 +152,29 @@ struct kvm_vm *perf_test_create_vm(enum vm_guest_mode mode, int vcpus,
 
 	pta->vm = vm;
 
+	/* Put the test region at the top guest physical memory. */
+	region_end_gfn = vm_get_max_gfn(vm) + 1;
+
+#ifdef __x86_64__
+	/*
+	 * When running vCPUs in L2, restrict the test region to 48 bits to
+	 * avoid needing 5-level page tables to identity map L2.
+	 */
+	if (pta->nested)
+		region_end_gfn = min(region_end_gfn, (1UL << 48) / pta->guest_page_size);
+#endif
 	/*
 	 * If there should be more memory in the guest test region than there
 	 * can be pages in the guest, it will definitely cause problems.
 	 */
-	TEST_ASSERT(guest_num_pages < vm_get_max_gfn(vm),
+	TEST_ASSERT(guest_num_pages < region_end_gfn,
 		    "Requested more guest memory than address space allows.\n"
 		    "    guest pages: %" PRIx64 " max gfn: %" PRIx64
 		    " vcpus: %d wss: %" PRIx64 "]\n",
-		    guest_num_pages, vm_get_max_gfn(vm), vcpus,
+		    guest_num_pages, region_end_gfn - 1, vcpus,
 		    vcpu_memory_bytes);
 
-	pta->gpa = (vm_get_max_gfn(vm) - guest_num_pages) * pta->guest_page_size;
+	pta->gpa = (region_end_gfn - guest_num_pages) * pta->guest_page_size;
 	pta->gpa = align_down(pta->gpa, backing_src_pagesz);
 #ifdef __s390x__
 	/* Align to 1M (segment size) */
-- 
2.36.1.124.g0e6072fb45-goog

