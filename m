Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E16759AB9E
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244591AbiHTGAy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244041AbiHTGAu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:50 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4200A223E;
        Fri, 19 Aug 2022 23:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975249; x=1692511249;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uz16PyoQFhukf/H8M5ipcGMQZYTZukV44jdncTSqdg4=;
  b=i7DsDSbDCAsU0x5fuUJQk69h6mWNHdaGSXf/n7hbUcs1Kmsx9317UaQA
   Y3iv0IprKBxl/bcQ1GcKEsSGtB4PU5me+NGh5ULN3+mOBePcq3G1Sjaut
   3O5c2Jb1RItq8eAGWhPt9EXagWJ4tEwj7a9I4P7Srbx+9yQhMeRGpqV/B
   gJw6ebRt3cvLWcUjrAyN8z9eWKONawJfvRu8PhHXRspD5NOovdECQKUfq
   P0XiMCSefijY4ZGlasH6Gr7BalcU4rmwPvhTIboooxr8gmy52S4frX5Wd
   RV2Mu9dl6wgUCZ78rKR0zOYIrKbXtJ/yiHZfrAvJjqsaTTk1d7H5oqnSO
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448967"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448967"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857514"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 02/18] KVM: x86: Use this_cpu_ptr() instead of per_cpu_ptr(smp_processor_id())
Date:   Fri, 19 Aug 2022 23:00:08 -0700
Message-Id: <e072c819dfae617b4980be9a7baf706867ca602b.1660974106.git.isaku.yamahata@intel.com>
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

convert per_cpu_ptr(smp_processor_id()) to this_cpu_ptr() as trivial
cleanup.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 16104a2f7d8e..7d5fff68befe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -416,8 +416,7 @@ EXPORT_SYMBOL_GPL(kvm_find_user_return_msr);
 
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
 	struct kvm_user_return_msr_values *values = &msrs->values[slot];
 	int err;
 
@@ -449,8 +448,7 @@ EXPORT_SYMBOL_GPL(kvm_set_user_return_msr);
 
 static void drop_user_return_notifiers(void)
 {
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
+	struct kvm_user_return_msrs *msrs = this_cpu_ptr(user_return_msrs);
 
 	if (msrs->registered)
 		kvm_on_user_return(&msrs->urn);
-- 
2.25.1

