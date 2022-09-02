Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F07A5AAAD0
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 11:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbiIBJD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 05:03:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiIBJDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 05:03:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4587A1D19;
        Fri,  2 Sep 2022 02:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662109401; x=1693645401;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PjiMaqOiXtXbGzUpzVo9H2Dd8g2N0f0rVIBAjHIDQGA=;
  b=E4375lV7v5aEjfaq4B3VayAVpltVObOpY2KkvIy1+T+q/wuTKMie+xOG
   GXBZC4z/cy208K0QpNAnXu7rcu1WbScZFWFA06OA3L94n95kvecLg7ISU
   LxUhuNtbncmXDhQiAtvSEPmrYISLvW7069g7epQcG9Emv0CEhkdPOWiq5
   gz/OTiTJNlFU+mE47WvkRw9c80aEKZ/WdhAObSBYO2eA2B0pLIRU21U3K
   T97M8QFSf654TKAcv+xHPcoEWLZ4JidqSoPi5IszJYO9HlUBY0t1xkIfM
   Q+bk2a4kWAFqeEpOWaOxsU4O/ePgWIVglXauApagBYIkX06vtwwnP8Sv9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="296721082"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="296721082"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 02:03:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="941218617"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.132])
  by fmsmga005.fm.intel.com with ESMTP; 02 Sep 2022 02:03:17 -0700
From:   Zhao Liu <zhao1.liu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        "Fabio M . De Francesco" <fmdefrancesco@gmail.com>,
        Zhenyu Wang <zhenyu.z.wang@intel.com>,
        Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH] KVM: SVM: Replace kmap_atomic() with kmap_local_page()
Date:   Fri,  2 Sep 2022 17:08:11 +0800
Message-Id: <20220902090811.2430228-1-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

The use of kmap_atomic() is being deprecated in favor of
kmap_local_page()[1].

In arch/x86/kvm/svm/sev.c, the function sev_clflush_pages() doesn't
need to disable pagefaults and preemption in kmap_atomic(). It can
simply use kmap_local_page() / kunmap_local() that can instead do the
mapping / unmapping regardless of the context.

With kmap_local_page(), the mapping is per thread, CPU local and not
globally visible. Therefore, sev_clflush_pages() is a function where
the use of kmap_local_page() in place of kmap_atomic() is correctly
suited.

Convert the calls of kmap_atomic() / kunmap_atomic() to
kmap_local_page() / kunmap_local().

[1]: https://lore.kernel.org/all/20220813220034.806698-1-ira.weiny@intel.com

Suggested-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Suggested by credits.
        Ira: Referred to his task document and review comments.
        Fabio: Referred to his boiler plate commit message.
---
 arch/x86/kvm/svm/sev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 28064060413a..12747c7bda4e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -465,9 +465,9 @@ static void sev_clflush_pages(struct page *pages[], unsigned long npages)
 		return;
 
 	for (i = 0; i < npages; i++) {
-		page_virtual = kmap_atomic(pages[i]);
+		page_virtual = kmap_local_page(pages[i]);
 		clflush_cache_range(page_virtual, PAGE_SIZE);
-		kunmap_atomic(page_virtual);
+		kunmap_local(page_virtual);
 		cond_resched();
 	}
 }
-- 
2.34.1

