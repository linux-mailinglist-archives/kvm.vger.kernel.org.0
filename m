Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4261C44CE0F
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 01:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhKKAGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 19:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbhKKAGK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 19:06:10 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29556C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:22 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id f206-20020a6238d7000000b004a02dd7156bso1278823pfa.5
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 16:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9I1vEfUzF0fIg2NkKXs5rUv0nbug7Sm5Bkxz8KRA3Ew=;
        b=KFoekFATRR6k/UnlF7jju0y7F1G+vI0rMS9+lxHk8+nBxJgZTUjH+uf47hwZ5FxCPW
         whSGN7FLJ7SZoqpSnVfKSwIVqLTisxJ/JTKJjZ7JfufgBMyav54zNIBPWrvhC0S1RNqF
         QDnmHsBHOvFCRZ1ATWZBMAwproq2IYM1+7OC6Yvlev4rUG6+tg5r4YK1jOuzDfviOy19
         WZ36pjXyXSJgsS9XjrOiw42hgM07sQT028c2yZIQdFF+1cV03sSaXn12dJudD9dGTEIw
         gm0RJJP6o1EuYJno+OjAHYLqBSZty0WDi4p6JVU8qnbDKbY5n++a525e8dJeMmH5R9vN
         f6FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9I1vEfUzF0fIg2NkKXs5rUv0nbug7Sm5Bkxz8KRA3Ew=;
        b=Nxykq2g6jmuP5jtg/RcYNAwkj1CaN/4eYpKZvImhoPFFbCyQFIticQVAOeMvAjyzxX
         GotckHBpYzUt4W2t3FGGvzvPeojwvnFC4XnLFSd3M15cOsbxdwPJs7Wi4IM4HEC6n3YT
         45Aj4Z3wCc/1WKXruwg/jZKfJsX6mVr39k6N7dF3ZxVnJ0k4F3qvzVe+PlcAqsnCkKIa
         mIGzvs7GQOw7yidZCujseTq0F1vseI7SkW7RGdkTX4/E/twazVEvcpiE2coFN31tmJsG
         ezdpHFXzm/7pIHwVQlN3urus5J+DhgAqkMR6/93C2yIUQtZfSTcVc3JS675D4heACAEL
         czbw==
X-Gm-Message-State: AOAM5332q1tsc5ryL/1hGBiK4O2LTxJ5x01kZ5nCuxLmrxcU2/x0/Z+D
        DAmu5war4edDmh51fyxM5sdL429nZaq/9A==
X-Google-Smtp-Source: ABdhPJwNzAk/IL/P6vBP9cQwPI+KD4OFkjXWk6wHPXNBb/vK6/obTvM6lNGJo0AYRGFCq7BtFb9UPTCGri1Q7g==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr89935pjf.1.1636589001326; Wed, 10 Nov 2021 16:03:21 -0800 (PST)
Date:   Thu, 11 Nov 2021 00:03:01 +0000
In-Reply-To: <20211111000310.1435032-1-dmatlack@google.com>
Message-Id: <20211111000310.1435032-4-dmatlack@google.com>
Mime-Version: 1.0
References: <20211111000310.1435032-1-dmatlack@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH v2 03/12] KVM: selftests: Assert mmap HVA is aligned when
 using HugeTLB
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Manually padding and aligning the mmap region is only needed when using
THP. When using HugeTLB, mmap will always return an address aligned to
the HugeTLB page size. Add a comment to clarify this and assert the mmap
behavior for HugeTLB.

Cc: Ben Gardon <bgardon@google.com>
Cc: Yanan Wang <wangyanan55@huawei.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
[Removed requirement that HugeTLB mmaps must be padded per Yanan's
 feedback and added assertion that mmap returns aligned addresses
 when using HugeTLB.]
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/include/test_util.h |  1 +
 tools/testing/selftests/kvm/lib/kvm_util.c      | 11 +++++++++++
 tools/testing/selftests/kvm/lib/test_util.c     |  5 +++++
 3 files changed, 17 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
index 78c06310cc0e..99e0dcdc923f 100644
--- a/tools/testing/selftests/kvm/include/test_util.h
+++ b/tools/testing/selftests/kvm/include/test_util.h
@@ -104,6 +104,7 @@ size_t get_trans_hugepagesz(void);
 size_t get_def_hugetlb_pagesz(void);
 const struct vm_mem_backing_src_alias *vm_mem_backing_src_alias(uint32_t i);
 size_t get_backing_src_pagesz(uint32_t i);
+bool is_backing_src_hugetlb(uint32_t i);
 void backing_src_help(const char *flag);
 enum vm_mem_backing_src_type parse_backing_src_type(const char *type_name);
 long get_run_delay(void);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 63375118d48f..07f37456bba0 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -866,6 +866,12 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 	alignment = 1;
 #endif
 
+	/*
+	 * When using THP mmap is not guaranteed to returned a hugepage aligned
+	 * address so we have to pad the mmap. Padding is not needed for HugeTLB
+	 * because mmap will always return an address aligned to the HugeTLB
+	 * page size.
+	 */
 	if (src_type == VM_MEM_SRC_ANONYMOUS_THP)
 		alignment = max(backing_src_pagesz, alignment);
 
@@ -901,6 +907,11 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 		    "test_malloc failed, mmap_start: %p errno: %i",
 		    region->mmap_start, errno);
 
+	TEST_ASSERT(!is_backing_src_hugetlb(src_type) ||
+		    region->mmap_start == align_ptr_up(region->mmap_start, backing_src_pagesz),
+		    "mmap_start %p is not aligned to HugeTLB page size 0x%lx",
+		    region->mmap_start, backing_src_pagesz);
+
 	/* Align host address */
 	region->host_mem = align_ptr_up(region->mmap_start, alignment);
 
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
index b72429108993..6d23878bbfe1 100644
--- a/tools/testing/selftests/kvm/lib/test_util.c
+++ b/tools/testing/selftests/kvm/lib/test_util.c
@@ -283,6 +283,11 @@ size_t get_backing_src_pagesz(uint32_t i)
 	}
 }
 
+bool is_backing_src_hugetlb(uint32_t i)
+{
+	return !!(vm_mem_backing_src_alias(i)->flag & MAP_HUGETLB);
+}
+
 static void print_available_backing_src_types(const char *prefix)
 {
 	int i;
-- 
2.34.0.rc1.387.gb447b232ab-goog

