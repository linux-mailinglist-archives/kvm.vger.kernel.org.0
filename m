Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC3C5ED8C8
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 11:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiI1JW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 05:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233644AbiI1JWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 05:22:54 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EEF7AC39C;
        Wed, 28 Sep 2022 02:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664356973; x=1695892973;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LboepUjmxKb4jCu41mnETf1wIRYGxkuhefbkTgfmYdc=;
  b=KXyyB/rXIQAcDxEt2/PoNm8eb2xzIKs/hx/bugKwxKf0S0FNSQmkCoCX
   TV6CfMmSKQvFhxVDCVZT/DPbiMX3BvONaRWfIsLvQZMTlAxhIFciV7osL
   cYppHLEXnoPAZh0uu/jHqkdW05FXwKGrllDAhob8HpPCE7qxA0qM6WCNO
   Xa+3lK8vx8sT7qXIWfI9XTF91zf6Il+suxgVEzbobfZ4DQA+Np1qoIeHk
   E4x1Ry9+1u5Pg65GPwIK3WE8odV0lrX/W+hYfvQRACdbvCLh/2vSL6hdr
   5+2kr4bot43s9xaUcKQT2LEILEtu3RytZOtZFteNzQYOi+VUwxSu+hiUE
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="284685090"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="284685090"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Sep 2022 02:22:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="572967241"
X-IronPort-AV: E=Sophos;i="5.93,351,1654585200"; 
   d="scan'208";a="572967241"
Received: from liuzhao-optiplex-7080.sh.intel.com ([10.239.160.132])
  by orsmga003.jf.intel.com with ESMTP; 28 Sep 2022 02:22:49 -0700
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
        Zhao Liu <zhao1.liu@intel.com>,
        Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v2] KVM: SVM: Replace kmap_atomic() with kmap_local_page()
Date:   Wed, 28 Sep 2022 17:27:48 +0800
Message-Id: <20220928092748.463631-1-zhao1.liu@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Zhao Liu <zhao1.liu@intel.com>

The use of kmap_atomic() is being deprecated in favor of
kmap_local_page()[1].

The main difference between kmap_atomic() and kmap_local_page() is the
latter allows pagefaults and preemption.

There're 2 reasons we can use kmap_local_page() here:
1. SEV is 64-bit only and kmap_locla_page() doesn't disable migration in
this case, but here the function clflush_cache_range() uses CLFLUSHOPT
instruction to flush, and on x86 CLFLUSHOPT is not CPU-local and flushes
the page out of the entire cache hierarchy on all CPUs (APM volume 3,
chapter 3, CLFLUSHOPT). So there's no need to disable preemption to ensure
CPU-local.
2. clflush_cache_range() doesn't need to disable pagefault and the mapping
is still valid even if sleeps. This is also true for sched out/in when
preempted.

In addition, though kmap_local_page() is a thin wrapper around
page_address() on 64-bit, kmap_local_page() should still be used here in
preference to page_address() since page_address() isn't suitable to be used
in a generic function (like sev_clflush_pages()) where the page passed in
is not easy to determine the source of allocation. Keeping the kmap* API in
place means it can be used for things other than highmem mappings[2].

Therefore, sev_clflush_pages() is a function that should use
kmap_local_page() in place of kmap_atomic().

Convert the calls of kmap_atomic() / kunmap_atomic() to kmap_local_page() /
kunmap_local().

[1]: https://lore.kernel.org/all/20220813220034.806698-1-ira.weiny@intel.com
[2]: https://lore.kernel.org/lkml/5d667258-b58b-3d28-3609-e7914c99b31b@intel.com/

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Suggested-by: Ira Weiny <ira.weiny@intel.com>
Suggested-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
---
Suggested by credits:
  Dave: Referred to his explanation about cache flush and usage of
        page_address().
  Ira: Referred to his task document, review comments and explanation about
       cache flush.
  Fabio: Referred to his boiler plate commit message.
---
Changes since v1:
  * Add the explanation of global cache flush for sev_clflush_pages() in commit
    message.
  * Add the explanation why not use page_address() directly.
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

