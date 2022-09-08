Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC1E5B2A34
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbiIHX0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiIHX0U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:20 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65635E7FA3;
        Thu,  8 Sep 2022 16:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679569; x=1694215569;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=61DGXVR3NwOa0FQhJYw9VD35jgPmusPgu+hMaBxRsLA=;
  b=TzY+onBAXD1/ZwOf5jOtTpEWRYzUkxfzTrqsgi2GDVFpm6EFEWUH2iR1
   HkdQiQLlZVa+vOCBdhvntlE8XHD7/q72KkaA7DwKuEVU+uyZljSjs2uOj
   NZh00u9aq5FQ+iPX8shNBPUOW0Ww9mSP9GWzpGgeEryJeLWRgR2cyUqC1
   vEmUmylPGH0OhDTuvcAc4cPSTCzMxcbjx6JhDlyqLYG2LF4FaKiEpRF7t
   15648UiwFDgf2OayPKVvj0o2ThSL8sFVgosquGRRt3sZkeB/5eAVA5Yj2
   g78zRQXun2ZkF3OIEf5S/TRKdYO8wnjYBOlnlhLEMGcxbwggseNoRir7F
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298686997"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298686997"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:08 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863191"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:07 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v4 09/26] KVM: Do processor compatibility check on resume
Date:   Thu,  8 Sep 2022 16:25:25 -0700
Message-Id: <1c302387e21e689f103bf954f355cf49f73d1e82.1662679124.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1662679124.git.isaku.yamahata@intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
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
be done.  The resume is called for resuming from S3/S4.  CPUs can be
replaced or the kernel can resume from S4 on a different machine.  So
compatibility check is desirable.

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

