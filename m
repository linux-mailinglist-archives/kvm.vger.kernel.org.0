Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90504777465
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 11:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbjHJJYp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 05:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbjHJJYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 05:24:44 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FF80212A;
        Thu, 10 Aug 2023 02:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691659484; x=1723195484;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=l5W7lo8AGp5GcicUaxx0a/KM1cCcP+g4Zw3OCaKNJvo=;
  b=OMlvpYIRAWItfKCvhnKJoXYJuqWPgAKtkk6MmZ0oOhbV0u4GbM5ioakD
   5TOFQwqxA73uDUIEeNl+uAXcOV39boZI9R71ztmZyRGOmwEEimDoW8hSp
   6ROUa8YSj1rq1fgfO2nStWjfm3fMUQ+aknFe5KWLfzVzZ80Yg+jz19tnL
   J+ery6a4+2Qzxxp4GB2E1ZL88q1k9JiVeg0YTq6E7oNgNSaK+Mnco1quP
   P7seLr3Of/DAb6gsX0eIr4oEu9yBpYGcGE4b0n65qOZj+es4lhmY8OlTe
   wIPKwYaroNxC9HeoL0nRtHMyKISDsF4G0Zb3FzbDr3zFwf9F3SdjtRfHz
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="437701464"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="437701464"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:24:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="725720308"
X-IronPort-AV: E=Sophos;i="6.01,161,1684825200"; 
   d="scan'208";a="725720308"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2023 02:24:40 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, mike.kravetz@oracle.com,
        apopple@nvidia.com, jgg@nvidia.com, rppt@kernel.org,
        akpm@linux-foundation.org, kevin.tian@intel.com, david@redhat.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH v2 1/5] mm/mmu_notifier: introduce a new mmu notifier flag MMU_NOTIFIER_RANGE_NUMA
Date:   Thu, 10 Aug 2023 16:57:43 +0800
Message-Id: <20230810085743.25977-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230810085636.25914-1-yan.y.zhao@intel.com>
References: <20230810085636.25914-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new mmu notifier flag MMU_NOTIFIER_RANGE_NUMA to indicate the
notification of MMU_NOTIFY_PROTECTION_VMA is for NUMA balance purpose
specifically.

So that, the subscriber of mmu notifier, like KVM, can recognize this
type of notification and do numa protection specific operations in the
handler.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 include/linux/mmu_notifier.h | 1 +
 mm/mprotect.c                | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 64a3e051c3c4..a6dc829a4bce 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -60,6 +60,7 @@ enum mmu_notifier_event {
 };
 
 #define MMU_NOTIFIER_RANGE_BLOCKABLE (1 << 0)
+#define MMU_NOTIFIER_RANGE_NUMA (1 << 1)
 
 struct mmu_notifier_ops {
 	/*
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 6f658d483704..cb99a7d66467 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -381,7 +381,9 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 		/* invoke the mmu notifier if the pmd is populated */
 		if (!range.start) {
 			mmu_notifier_range_init(&range,
-				MMU_NOTIFY_PROTECTION_VMA, 0,
+				MMU_NOTIFY_PROTECTION_VMA,
+				cp_flags & MM_CP_PROT_NUMA ?
+				MMU_NOTIFIER_RANGE_NUMA : 0,
 				vma->vm_mm, addr, end);
 			mmu_notifier_invalidate_range_start(&range);
 		}
-- 
2.17.1

