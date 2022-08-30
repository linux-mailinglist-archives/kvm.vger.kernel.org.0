Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A1F5A62B5
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiH3MCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiH3MB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:01:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94525E5892;
        Tue, 30 Aug 2022 05:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860916; x=1693396916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uz16PyoQFhukf/H8M5ipcGMQZYTZukV44jdncTSqdg4=;
  b=LaHzgX5HONWfv61ahX7wnCj6Q+1pZNS0ESF5VHjD/+XIMKA/lJJaG34+
   U/2AgSY7ZldcDo8WpEeyUBR0uBZbhBmsTb4EsH44St6tyfN79R6ZRv1Xb
   pb/eHAwl0iXaREcjo7wzclG6bW6VUiRLgXQXkNmaNjwIbhbh0tmvN/xly
   xQOLIxPUVeOypN3lD3/C2K1Rfod5yc3KcUVyKy86D8zCG8J75/6wuqU/Y
   gJjuwPlFObFAneVVSg3OQsP/yDGbejJySaqm1ZZSfAOAIGcYDBG9xlSiE
   IHKTIfmUkr0A+p9HIgpQ1SHWW05rrykRvC6iX47TuXx7Lt7DxYPKobb/J
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870956"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870956"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469613"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:54 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 02/19] KVM: x86: Use this_cpu_ptr() instead of per_cpu_ptr(smp_processor_id())
Date:   Tue, 30 Aug 2022 05:01:17 -0700
Message-Id: <920dfe48e7255c2224a799386d720f34b4479e1a.1661860550.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1661860550.git.isaku.yamahata@intel.com>
References: <cover.1661860550.git.isaku.yamahata@intel.com>
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

