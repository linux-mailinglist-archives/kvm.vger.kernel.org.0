Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4AB24E58B7
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 19:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344076AbiCWSvM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 14:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344074AbiCWSvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 14:51:07 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD62760D8C
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:49:32 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id rm11-20020a17090b3ecb00b001c713925e58so4962294pjb.6
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=c5fKyu9jH6XE+xJIVIS/L5W4c26nrxs3xWXA5jPM5YY=;
        b=C10LlrNWhm5bgZg0y2T/cSnRWn4NBv6Ijy73wn6fsYLtVEUL3MMaxw54JXOLlBTv5a
         rEp1JHZVuekBqV0GnPIZlSn42sL9jJxM5z2FiEMxawlv8e4IFUnLSht3LAgncURiXIv9
         X03pTiQKbwSpWLbW/+uv9hfjxViNtYEzD9Q4TG5xr3CXpfkGhNIa9hYJQrjNuzueHEvb
         AmRBZAsmQpWTw5SkbcX5z4s1q7yCKJXgnGdcOnEiUi7GoBsWclCRnC1hxRxrFOOAAolz
         lC6jkplgy96DC+JPbcLIxIZLrEO9c7Lw65m4cw726nQuwRnrV++Y//AN7EwTVIB1HLcc
         8ZBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=c5fKyu9jH6XE+xJIVIS/L5W4c26nrxs3xWXA5jPM5YY=;
        b=N4Kh0IvqABxThOA3P2jeK54lvtw9AbVSj1tMBJqrZdXbNFLSsxkse4ryeKbnOqIexx
         zMEPHK9/MjtoKgDeAFUpmQiTFHDdRMhBqvy4yELNuuVYEXLqVAmK0XhMsFMxLoWhOfcL
         FjhUVntj4qcZjsop4i8oOmIhtyfnWLQryBtOBACnQOxICBl/7qbZk5Mna6pR0p9E1CIL
         z8EL0xzDHm8MJxWkFgNS3hn3ftetO6XucG1SZ7M2a4j49519kOlBxZacFnPS5ueTb2jz
         Zkxpk/cgsINtQTnfpqtnA9Phv1epLWtXYbv3r68/owHWvZaDhXHtHZxvklFbeFGoAXod
         FSCQ==
X-Gm-Message-State: AOAM5316cKFfYDnKH5Ij1IHVZd0ra7k2JqDt0D0QGB/5rGxNleBXFFsH
        GD3zaqVpJXq+zaz9WK6l8FhYkIUI3i0V
X-Google-Smtp-Source: ABdhPJw3TuVBjn2xN6D1q57cS12a8wgK2abT8t4Ffi0TQtHWkk8eOzNArS5pVnsQWrxWouXWLqUKQflUznSt
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:903:1d1:b0:154:61ec:749b with SMTP id
 e17-20020a17090301d100b0015461ec749bmr1495211plh.52.1648061372281; Wed, 23
 Mar 2022 11:49:32 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Wed, 23 Mar 2022 18:49:15 +0000
In-Reply-To: <20220323184915.1335049-1-mizhang@google.com>
Message-Id: <20220323184915.1335049-6-mizhang@google.com>
Mime-Version: 1.0
References: <20220323184915.1335049-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v2 4/4] selftests: KVM: use dirty logging to check if page
 stats work correctly
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Peter Xu <peterx@redhat.com>
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
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 1954b964d1cf..21431b0f5547 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -19,6 +19,10 @@
 #include "perf_test_util.h"
 #include "guest_modes.h"
 
+#ifdef __x86_64__
+#include "processor.h"
+#endif
+
 /* How many host loops to run by default (one KVM_GET_DIRTY_LOG for each loop)*/
 #define TEST_HOST_LOOP_N		2UL
 
@@ -185,6 +189,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -222,6 +234,17 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -267,6 +290,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -275,6 +306,28 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
2.35.1.1021.g381101b075-goog

