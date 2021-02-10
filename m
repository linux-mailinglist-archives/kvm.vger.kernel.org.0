Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451823173EF
	for <lists+kvm@lfdr.de>; Thu, 11 Feb 2021 00:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbhBJXIG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 18:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233831AbhBJXHy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 18:07:54 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2F2C06178C
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:42 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id d194so2976447qke.3
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 15:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=c19kP48HP44DYzRTxNvBkL6r5zKqdROTV6wmdYv7tSc=;
        b=OwrLzE0kO7weELha4Kp1fyhG7sdykoXrp0hwGwAAbyFvISToZvRacz1aipJVy1fkZU
         cgbCsaaFfNJ4JdQyKwFr3WMrkI0jYq6noOQD/foIe32KUAa8VdjEK3G+UW54t6hRADdb
         wycUuoQd7td8LXJMQczRU7OyLqKoh1f0bKv74CLxndstbBo+kocEypj5wHubHb/3e4vF
         yzuxhUF6i2pk2NHghivBINolGwgbwsRV713qAKG1LQHT3UhYQmx6OlHo3RlRaixnZKhV
         9DAQwZ632SXkezIFRW9EEmwd1lKTW8wAt54/RSkjvrzinOCN0/I5/DHLslWvPCgOojxx
         gQZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=c19kP48HP44DYzRTxNvBkL6r5zKqdROTV6wmdYv7tSc=;
        b=aacVbCoxrUsgeGXPkVi9U2xEpM2cHThNB3+tu0I4OmfNavG7IJ+cgAkl3YEGahO0CM
         bA/UDgZLeuk9Ap9qnfnQ9X16bYJxiRafHSf1wWAG2DtsQPW/eDq8qqbLJz2qLxkB0BeI
         HbCV51+qvQamL8RhWFMTNibhFaJX7SgTVHGz4v0SrwGtcBKeSiaphRuQ9RcPVWhIjwcy
         zR+P29HW8ERteH4lVVbxuyS/JqMVuTkvrisU6igQIdkV9eYWd+/HVXSPuLKliUbHrmwF
         SkJSeytGY1B4V9+sX2OS8i5N4y0wmDEinFXnowlsgZwYYvTayRPi+d161VHB012j1aBx
         YcUA==
X-Gm-Message-State: AOAM530X5QEIjPigVIfP/7vwrdP3VXxmZpPDATggOkijao2rZHVOHsYF
        676M456usAXs/fRQBc75TptV9Cs8uMA=
X-Google-Smtp-Source: ABdhPJwFT6XTMSr0mgp0F4wxa8DFbIUWyWCBFcDFVsnJMDNy8e1Pgi+q+46odnLgegTgvbm111Zk9SL5Sa4=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:11fc:33d:bf1:4cb8])
 (user=seanjc job=sendgmr) by 2002:a05:6214:1144:: with SMTP id
 b4mr5496535qvt.12.1612998401429; Wed, 10 Feb 2021 15:06:41 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 10 Feb 2021 15:06:14 -0800
In-Reply-To: <20210210230625.550939-1-seanjc@google.com>
Message-Id: <20210210230625.550939-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210210230625.550939-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 04/15] KVM: selftests: Force stronger HVA alignment (1gb) for hugepages
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Align the HVA for hugepage memslots to 1gb, as opposed to incorrectly
assuming all architectures' hugepages are 512*page_size.

For x86, multiplying by 512 is correct, but only for 2mb pages, e.g.
systems that support 1gb pages will never be able to use them for mapping
guest memory, and thus those flows will not be exercised.

For arm64, powerpc, and s390 (and mips?), hardcoding the multiplier to
512 is either flat out wrong, or at best correct only in certain
configurations.

Hardcoding the _alignment_ to 1gb is a compromise between correctness and
simplicity.  Due to the myriad flavors of hugepages across architectures,
attempting to enumerate the exact hugepage size is difficult, and likely
requires probing the kernel.

But, there is no need for precision since a stronger alignment will not
prevent creating a smaller hugepage.  For all but the most extreme cases,
e.g. arm64's 16gb contiguous PMDs, aligning to 1gb is sufficient to allow
KVM to back the guest with hugepages.

Add the new alignment in kvm_util.h so that it can be used by callers of
vm_userspace_mem_region_add(), e.g. to also ensure GPAs are aligned.

Cc: Ben Gardon <bgardon@google.com>
Cc: Yanan Wang <wangyanan55@huawei.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Aaron Lewis <aaronlewis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 13 +++++++++++++
 tools/testing/selftests/kvm/lib/kvm_util.c     |  4 +---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 4b5d2362a68a..a7dbdf46aa51 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -68,6 +68,19 @@ enum vm_guest_mode {
 #define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
 #define PTES_PER_MIN_PAGE	ptes_per_page(MIN_PAGE_SIZE)
 
+/*
+ * KVM_UTIL_HUGEPAGE_ALIGNMENT is selftest's required alignment for both host
+ * and guest addresses when backing guest memory with hugepages.  This is not
+ * the exact size of hugepages, rather it's a size that should allow backing
+ * the guest with hugepages on all architectures.  Precisely tracking the exact
+ * sizes across all architectures is more pain than gain, e.g. x86 supports 2mb
+ * and 1gb hugepages, arm64 supports 2mb and 1gb hugepages when using 4kb pages
+ * and 512mb hugepages when using 64kb pages (ignoring contiguous TLB entries),
+ * powerpc radix supports 1gb hugepages when using 64kb pages, s390 supports 1mb
+ * hugepages, and so on and so forth.
+ */
+#define KVM_UTIL_HUGEPAGE_ALIGNMENT	(1ULL << 30)
+
 #define vm_guest_mode_string(m) vm_guest_mode_string[m]
 extern const char * const vm_guest_mode_string[];
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index deaeb47b5a6d..2e497fbab6ae 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -18,7 +18,6 @@
 #include <unistd.h>
 #include <linux/kernel.h>
 
-#define KVM_UTIL_PGS_PER_HUGEPG 512
 #define KVM_UTIL_MIN_PFN	2
 
 /*
@@ -670,7 +669,6 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 {
 	int ret;
 	struct userspace_mem_region *region;
-	size_t huge_page_size = KVM_UTIL_PGS_PER_HUGEPG * vm->page_size;
 	size_t alignment;
 
 	TEST_ASSERT(vm_adjust_num_guest_pages(vm->mode, npages) == npages,
@@ -733,7 +731,7 @@ void vm_userspace_mem_region_add(struct kvm_vm *vm,
 
 	if (src_type == VM_MEM_SRC_ANONYMOUS_THP ||
 	    src_type == VM_MEM_SRC_ANONYMOUS_HUGETLB)
-		alignment = max(huge_page_size, alignment);
+		alignment = max((size_t)KVM_UTIL_HUGEPAGE_ALIGNMENT, alignment);
 	else
 		ASSERT_EQ(src_type, VM_MEM_SRC_ANONYMOUS);
 
-- 
2.30.0.478.g8a0d178c01-goog

