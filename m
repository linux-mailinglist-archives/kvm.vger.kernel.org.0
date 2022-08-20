Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75AF559AB99
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245231AbiHTGBM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244490AbiHTGAx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:53 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89364A223E;
        Fri, 19 Aug 2022 23:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975252; x=1692511252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iF07MtJ4WwZr9SnrFNX6veyTtKvMyfVQ+1Bb5LokAFM=;
  b=h8EIFz7czho/0F4UB/cLeZTT+CuA2gOAvjNS2Hyxiu8hORB6J4vT+FTu
   3B/nrhX3OdNXY4G7VLB4Qt/pr9DxrklrFTihKcQx2rWiY9RKYxnBAi3K+
   pHF2tJjP3b8jupA4/c1gWHZ/laKNptnv0dnzNb5u8XcFuSm3nndiFzThQ
   /l76Dvx2dtKhfmPB28PGLMHeNaWGtAdQmxfuUkBJbBk5mCyR9xQERuvCr
   l2+xe/debF6Cg3zD8eIEQBdFCyba3VS1hhZoQH9JSZV1Wgk4e6PAAgABt
   E4oQcHpSpMar4Yf5IanXR9XMZU8ISzv3pyoe1HeRs/lcZYkGJWK0HuZ+5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448979"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448979"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:50 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857547"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:50 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 12/18] KVM: Do processor compatibility check on cpu online and resume
Date:   Fri, 19 Aug 2022 23:00:18 -0700
Message-Id: <60f9ec74499c673c474e9d909c2f3176bc6711c3.1660974106.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1660974106.git.isaku.yamahata@intel.com>
References: <cover.1660974106.git.isaku.yamahata@intel.com>
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

So far the processor compatibility check is not done for newly added CPU.
It should be done.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_arch.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 2ed8de0591c9..20971f43df95 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -99,9 +99,15 @@ __weak int kvm_arch_del_vm(int usage_count)
 
 __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 {
-	if (usage_count)
-		return __hardware_enable();
-	return 0;
+	int r;
+
+	if (!usage_count)
+		return 0;
+
+	r = kvm_arch_check_processor_compat();
+	if (r)
+		return r;
+	return __hardware_enable();
 }
 
 __weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
@@ -126,6 +132,10 @@ __weak int kvm_arch_suspend(int usage_count)
 
 __weak void kvm_arch_resume(int usage_count)
 {
-	if (usage_count)
-		(void)__hardware_enable();
+	if (!usage_count)
+		return;
+
+	if (kvm_arch_check_processor_compat())
+		return; /* FIXME: disable KVM */
+	(void)__hardware_enable();
 }
-- 
2.25.1

