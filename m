Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE674EE859
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 08:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245587AbiDAGi5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 02:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245517AbiDAGiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 02:38:46 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B3C19236C
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:52 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id k69-20020a628448000000b004fd8affa86aso1095578pfd.12
        for <kvm@vger.kernel.org>; Thu, 31 Mar 2022 23:36:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=uzcMfPPC4r9DDGZEKc9Z+WT8d8M153ZB7YHzP50uvCQ=;
        b=sejzPoMfvygP+Yln6s7tbom3x27vqmjv+uyd79uPjN3jxvfF1wmqSlZxhPazjIOTrR
         V63nVwYUn6riNiFEpx242Cla0yUMB5ZPL3hVfLMlzCtGRGChXeobeN7IWM5exWkIZzLm
         7qUSYt+8YqmjecCpxTc5MFGv7uGJhFp4qE4tYaXHhGqVq9gND/05SlJ32xq3jeGdd21h
         nzs6jh+kRm8cXA9GYM00Z0hVDvMr4UtSfVPYFyWqhfdtH/b1wHlfcLU0X4aXEvpFpraI
         DmEv5f0Zw9L4DOeapIvTN0h33kQyhVbYUr04noqzZ0mzlgqxRgsAC+vahAdD71/5k0DT
         vO3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=uzcMfPPC4r9DDGZEKc9Z+WT8d8M153ZB7YHzP50uvCQ=;
        b=B/resyEt79jRPL/XDKonG4fc2yG+jq7K3UTTvsSDVbzt5IFXfJ9VGAN5ZBah4+LdTa
         T5EYnIvU6ZOr4XhQGmFSOEUyrq23wB7dptmHD/EinnFH1Mgz9EU+llL+eIOmA/CWs5LT
         XqTgKey6b3dooy9u0052ZACg2M94AjPyBG6LPMzlI3fRkZENAp/7uxtCFJtSq7NDv7u9
         BibAI7dPBr9Vc1E8kEjjxox4jCmJruCuanMkkwh4WT2MAHwAvtl2OTeK47fXe5QrVoDR
         ErENyVhyagamjY7PhwMEzS8nzvQqkP2GgXjf1NS++cV8eyjDRv2TxMMM/oDI+B18Hawz
         bAsA==
X-Gm-Message-State: AOAM530oAShQlWUezVzBoj308e58d1abXNVMUL3SaHFYj55IN7b37B+D
        CBO1Gshs0tuTSKQ4Plnzhp2fwoW5Bbo0
X-Google-Smtp-Source: ABdhPJyAOejzhvbgsx7VN0zVrvPkMlMTUNrgRtrz5gzaixv2702AoUZ4mGJxU7txTGviK1moyXxJiP62V/yX
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a05:6a00:140f:b0:4e0:6995:9c48 with SMTP
 id l15-20020a056a00140f00b004e069959c48mr9243091pfu.59.1648795012083; Thu, 31
 Mar 2022 23:36:52 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri,  1 Apr 2022 06:36:36 +0000
In-Reply-To: <20220401063636.2414200-1-mizhang@google.com>
Message-Id: <20220401063636.2414200-7-mizhang@google.com>
Mime-Version: 1.0
References: <20220401063636.2414200-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
Subject: [PATCH v3 6/6] selftests: KVM: use page stats to check if dirty
 logging works properly
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
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

When dirty logging is enabled, KVM will remap all accessed pages in
NPT/EPT at 4K. This property could be used to check if
the page stats metrics work properly in KVM mmu. At the same time, this
logic might be used the other way around: using page stats to verify if
dirty logging really splits all huge pages. Moreover, when dirty logging is
disabled, KVM zaps corresponding SPTEs and we could check whether the large
pages come back when guest touches the pages again.

So add page stats checking in dirty logging performance selftest. In
particular, add checks in three locations:
 - just after vm is created;
 - after populating memory into vm but before enabling dirty logging;
 - finish dirty logging but before disabling it;
 - behind the final iteration after disabling dirty logging.

Tested using commands:
 - ./dirty_log_perf_test -s anonymous_hugetlb_1gb
 - ./dirty_log_perf_test -s anonymous_hugetlb_2mb
 - ./dirty_log_perf_test -s anonymous_thp

Cc: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Jing Zhang <jingzhangos@google.com>
Cc: Peter Xu <peterx@redhat.com>

Suggested-by: Ben Gardon <bgardon@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index c9d9e513ca04..dd48aabfff5c 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -25,6 +25,10 @@
 #define GICR_BASE_GPA			0x80A0000ULL
 #endif
 
+#ifdef __x86_64__
+#include "processor.h"
+#endif
+
 /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
 #define TEST_HOST_LOOP_N		2UL
 
@@ -191,6 +195,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				 p->slots, p->backing_src,
 				 p->partition_vcpu_memory_access);
 
+#ifdef __x86_64__
+	TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") == 0,
+		    "4K page is non zero");
+	TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") == 0,
+		    "2M page is non zero");
+	TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") == 0,
+		    "1G page is non zero");
+#endif
 	perf_test_set_wr_fract(vm, p->wr_fract);
 
 	guest_num_pages = (nr_vcpus * guest_percpu_mem_size) >> vm_get_page_shift(vm);
@@ -232,6 +244,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Populate memory time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+#ifdef __x86_64__
+	TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") != 0,
+		    "4K page is zero");
+	if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
+	    p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB)
+		TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") != 0,
+			    "2M page is zero");
+	if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
+		TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") != 0,
+			    "1G page is zero");
+#endif
 	/* Enable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	enable_dirty_logging(vm, p->slots);
@@ -277,6 +300,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 				iteration, ts_diff.tv_sec, ts_diff.tv_nsec);
 		}
 	}
+#ifdef __x86_64__
+	TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") != 0,
+		    "4K page is zero after dirty logging");
+	TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") == 0,
+		    "2M page is non-zero after dirty logging");
+	TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") == 0,
+		    "1G page is non-zero after dirty logging");
+#endif
 
 	/* Disable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
@@ -285,6 +316,28 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Disabling dirty logging time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+	/*
+	 * Increment iteration to run the vcpus again to ensure all pages come
+	 * back.
+	 */
+	iteration++;
+	pr_info("Starting the final iteration to get all pages back.\n");
+	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
+		while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id])
+		       != iteration)
+			;
+	}
+
+#ifdef __x86_64__
+	if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP ||
+	    p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_2MB)
+		TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") != 0,
+			    "2M page is zero");
+	if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
+		TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") != 0,
+			    "1G page is zero");
+#endif
+
 	/* Tell the vcpu thread to quit */
 	host_quit = true;
 	perf_test_join_vcpu_threads(nr_vcpus);
-- 
2.35.1.1094.g7c7d902a7c-goog

