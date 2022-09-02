Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3E85AA5A6
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235080AbiIBCSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbiIBCSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:15 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209116CF59;
        Thu,  1 Sep 2022 19:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085095; x=1693621095;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b8Gkotu1oF+eteg3mUfjPVxXSgZtRSB21FKu4x1CZl8=;
  b=eDzSKpxytjmBcdbwUefflQrdzUc9uxL54FeIiwYInd56F5NvkxdFMKZL
   zkIJCK5ecNTwvFPmBBR3MR4GIV0Cn+cFU8ZW+hdNFwsNaKppfgNLYA6Pw
   4IhYbhGWQmI9y0AvM5ojMTkmNyhtG2gPlgDriZ/8Rq9tJMAbsy+gzFj07
   HjlWwJNX8ZvubdwpqAbaCWIWmJSNDIMMzQNb9pv2LEc/bwkOh2XHIfTTF
   ogNmNqZYuYKdnbY85JpugvzdkkIvSUc8w5junICyALd2IbZVd/52VEXMz
   jLiAxOlIqMO4LV/QI+CH21EdVGgSyaLj8VInyzT8++0nfv1S7JC84+8Qn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297157844"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297157844"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608835622"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:14 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v3 09/22] KVM: Do processor compatibility check on resume
Date:   Thu,  1 Sep 2022 19:17:44 -0700
Message-Id: <b5bf18656469f667d1015cc1d62e5caba2f56e96.1662084396.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662084396.git.isaku.yamahata@intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

So far the processor compatibility check is not done on resume. It should
be done.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0ac00c711384..fc55447c4dba 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5715,6 +5715,13 @@ static int kvm_suspend(void)
 
 static void kvm_resume(void)
 {
+	if (kvm_arch_check_processor_compat())
+		/*
+		 * No warning here because kvm_arch_check_processor_compat()
+		 * would have warned with more information.
+		 */
+		return; /* FIXME: disable KVM */
+
 	if (kvm_usage_count) {
 		lockdep_assert_not_held(&kvm_count_lock);
 		hardware_enable_nolock((void *)__func__);
-- 
2.25.1

