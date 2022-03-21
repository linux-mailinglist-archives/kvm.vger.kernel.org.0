Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8840D4E1E7A
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 01:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343929AbiCUA2Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Mar 2022 20:28:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343898AbiCUA2L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Mar 2022 20:28:11 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 064E3DE910
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 17:26:47 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id o12-20020a17090a420c00b001c65aec76c0so7689764pjg.8
        for <kvm@vger.kernel.org>; Sun, 20 Mar 2022 17:26:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Fmv+HMc2DFxNt8CxUdSLz9dfbbTJJCLxSOxGsXm4RyU=;
        b=p6WWOu56th14hFbz/vDJsj1YNlhWpB7KWlRQjlG5lF4dyCxZxdkzJkQU/tJPoez92d
         maakq/dfxmhfKGNOZYWMgEKpDoKtFAgijvHMmtYdKhUALE5ymi1R5lTAcHpGpyth9NMf
         zLrmS3vhHPaaPsoQVmefiC/MjXoB0+gEZmiY0coOY2wrbWU/wCxd4F5t1N8bnMiJd+ab
         nhjgojLKs3DtNzC0Bm6ejviuERcb3oxb7/dkWQtPSyV0kSSm2ArXx1WZTCNoLXs8rwBY
         ecDJ78LUFg6Exe7b5GrWHuRX2wfCdtxK8sQe0zG5z1W/0Afu2KR9/lsuAYZrKEoSzkgu
         7KrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Fmv+HMc2DFxNt8CxUdSLz9dfbbTJJCLxSOxGsXm4RyU=;
        b=bqw+YBKGjjBLoHkZolRgPRreKOD1fDwa6XoB3iTFsfs3mFHBWqasekKRgudl/9fKE1
         IUOAIJV8bi1eMpBZsXkfLKKd8SaBirmoLhSeJJV6jKyj/xLdliE2QuZf1idgd4mYDp3t
         IScnNBb3Q7RnY/ge4UrHmleWT9HhUiq9Cnlcjgb8mPzyVaiXcjqDlWdKkt8yznQbtfGk
         r6GHoW4AZgDtOmAA1E/C8gdemTgwJ0FoVlqpwztL06g9rVOUt9XC1GnhCx9Zzlr0upkx
         vhrkwT0w2d4WBMX8NynlD8oKb7OdV+oLucLgq56Eji1Zp+mzhTyc5AwQr2b/ZIFXT1G1
         mlRg==
X-Gm-Message-State: AOAM532DUPZTtdgEiJQ4dgwZdqjrPBXPmqrA4ZredAA57Pa/dvw/EEhl
        I5CuhGlbaCE6t/3bLZaXFSw5nt4F7ro8
X-Google-Smtp-Source: ABdhPJyKZwK8L7OgfM5eCJrVgG7L/KDRJs9ML8qnRmGqUKzDjY6RiXCxrTBNf2fA8anI5bY3FN33eH2UxTo1
X-Received: from mizhang-super.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1071])
 (user=mizhang job=sendgmr) by 2002:a17:902:b941:b0:14d:af72:3f23 with SMTP id
 h1-20020a170902b94100b0014daf723f23mr10621824pls.6.1647822406401; Sun, 20 Mar
 2022 17:26:46 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Mon, 21 Mar 2022 00:26:38 +0000
In-Reply-To: <20220321002638.379672-1-mizhang@google.com>
Message-Id: <20220321002638.379672-5-mizhang@google.com>
Mime-Version: 1.0
References: <20220321002638.379672-1-mizhang@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH 4/4] selftests: KVM: use dirty logging to check if page stats
 work correctly
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
        Peter Xu <peterx@redhat.com>, Ben Gardon <bgorden@google.com>
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

When dirty logging is enabled, KVM splits the all hugepage mapping in
NPT/EPT into the smallest 4K size. This property could be used to check if
the page stats metrics work properly in KVM mmu. At the same time, this
logic might be used the other way around: using page stats to verify if
dirty logging really splits all huge pages. Moreover, when dirty logging is
disabled, KVM zaps corresponding SPTEs and we could check whether the large
pages come back when guest touches the pages again.

So add page stats checking in dirty logging performance selftest. In
particular, add checks in three locations:
 - just after vm is created;
 - after populating memory into vm but before enabling dirty logging;
 - just after turning on dirty logging.
 - after one final iteration after turning off dirty logging.

Tested using commands:
 - ./dirty_log_perf_test -s anonymous_hugetlb_1gb
 - ./dirty_log_perf_test -s anonymous_thp

Cc: Sean Christopherson <seanjc@google.com>
Cc: David Matlack <dmatlack@google.com>
Cc: Jing Zhang <jingzhangos@google.com>
Cc: Peter Xu <peterx@redhat.com>

Suggested-by: Ben Gardon <bgorden@google.com>
Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 .../selftests/kvm/dirty_log_perf_test.c       | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 1954b964d1cf..ab0457d91658 100644
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
@@ -222,6 +234,16 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Populate memory time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+#ifdef __x86_64__
+	TEST_ASSERT(vm_get_single_stat(vm, "pages_4k") != 0,
+		    "4K page is zero");
+	if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP)
+		TEST_ASSERT(vm_get_single_stat(vm, "pages_2m") != 0,
+			    "2M page is zero");
+	if (p->backing_src == VM_MEM_SRC_ANONYMOUS_HUGETLB_1GB)
+		TEST_ASSERT(vm_get_single_stat(vm, "pages_1g") != 0,
+			    "1G page is zero");
+#endif
 	/* Enable dirty logging */
 	clock_gettime(CLOCK_MONOTONIC, &start);
 	enable_dirty_logging(vm, p->slots);
@@ -267,6 +289,14 @@ static void run_test(enum vm_guest_mode mode, void *arg)
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
@@ -275,6 +305,28 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 	pr_info("Disabling dirty logging time: %ld.%.9lds\n",
 		ts_diff.tv_sec, ts_diff.tv_nsec);
 
+#ifdef __x86_64__
+	/*
+	 * Increment iteration to run the vcpus again to verify if huge pages
+	 * come back.
+	 */
+	iteration++;
+	pr_info("Starting the final iteration to verify page stats\n");
+
+	for (vcpu_id = 0; vcpu_id < nr_vcpus; vcpu_id++) {
+		while (READ_ONCE(vcpu_last_completed_iteration[vcpu_id])
+		       != iteration)
+			;
+	}
+
+	if (p->backing_src == VM_MEM_SRC_ANONYMOUS_THP)
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
2.35.1.894.gb6a874cedc-goog

