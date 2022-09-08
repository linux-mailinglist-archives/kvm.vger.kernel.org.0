Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4D915B2A28
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiIHX0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiIHX0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:05 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7501E3D68;
        Thu,  8 Sep 2022 16:26:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679563; x=1694215563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4yHIwH86LwwyESKSGChTujh8Vj2N18i6tKI9EL0jUr4=;
  b=hWj/WLckaVvfPS8PJAkkKNfiTLQ8WqKqjK5bsJjbuxgrPf22FSa7W+0z
   TqLf7ykZmmFP6Xv+CTwv1Iey4UScmaMxvw/o4hlfs4FSU2kfI4M+X18R1
   PRF9Skm/EEZFxNlDVmVdASaXt3SDOrULO7OKHDoZk+KJXIDHTyIuRl55+
   3FG9thx5tjp8WRgGsigSuTRx91o0pzsspLOzpmjWRaNQ7Qec4arW9Dwbl
   QyXtweQprPbwHnhhvYeLLRWYD6pddAauPyOLSX0hUVlavsmuegWrKGykC
   Av+zAx1eCUmhXc7fRKeqcKm7OE8MM5LUyguDLt1O7PZaI+MFmvTvwqPeg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298686970"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298686970"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:03 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863138"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:02 -0700
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
        Huacai Chen <chenhuacai@kernel.org>,
        Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v4 01/26] KVM: x86: Drop kvm_user_return_msr_cpu_online()
Date:   Thu,  8 Sep 2022 16:25:17 -0700
Message-Id: <066b3d43586bab4ae1f6175951c3c7af945f9107.1662679124.git.isaku.yamahata@intel.com>
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

From: Sean Christopherson <seanjc@google.com>

KVM/X86 uses user return notifier to switch MSR for guest or user space.
Snapshot host values on CPU online, change MSR values for guest, and
restore them on returning to user space.  The current code abuses
kvm_arch_hardware_enable() which is called on kvm module initialization or
CPU online.

Remove such the abuse of kvm_arch_hardware_enable() by capturing the host
value on the first change of the MSR value to guest VM instead of CPU
online.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
 arch/x86/kvm/x86.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 205ebdc2b11b..73dccc952dd1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -196,6 +196,7 @@ module_param(eager_page_split, bool, 0644);
 
 struct kvm_user_return_msrs {
 	struct user_return_notifier urn;
+	bool initialized;
 	bool registered;
 	struct kvm_user_return_msr_values {
 		u64 host;
@@ -409,18 +410,20 @@ int kvm_find_user_return_msr(u32 msr)
 }
 EXPORT_SYMBOL_GPL(kvm_find_user_return_msr);
 
-static void kvm_user_return_msr_cpu_online(void)
+static void kvm_user_return_msr_init_cpu(struct kvm_user_return_msrs *msrs)
 {
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
 	u64 value;
 	int i;
 
+	if (msrs->initialized)
+		return;
+
 	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
 		rdmsrl_safe(kvm_uret_msrs_list[i], &value);
 		msrs->values[i].host = value;
 		msrs->values[i].curr = value;
 	}
+	msrs->initialized = true;
 }
 
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
@@ -429,6 +432,8 @@ int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
 	int err;
 
+	kvm_user_return_msr_init_cpu(msrs);
+
 	value = (value & mask) | (msrs->values[slot].host & ~mask);
 	if (value == msrs->values[slot].curr)
 		return 0;
@@ -9212,7 +9217,12 @@ int kvm_arch_init(void *opaque)
 		return -ENOMEM;
 	}
 
-	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
+	/*
+	 * __GFP_ZERO to ensure user_return_msrs.initialized = false.
+	 * See kvm_user_return_msr_init_cpu().
+	 */
+	user_return_msrs = alloc_percpu_gfp(struct kvm_user_return_msrs,
+					    GFP_KERNEL | __GFP_ZERO);
 	if (!user_return_msrs) {
 		printk(KERN_ERR "kvm: failed to allocate percpu kvm_user_return_msrs\n");
 		r = -ENOMEM;
@@ -11836,7 +11846,6 @@ int kvm_arch_hardware_enable(void)
 	u64 max_tsc = 0;
 	bool stable, backwards_tsc = false;
 
-	kvm_user_return_msr_cpu_online();
 	ret = static_call(kvm_x86_hardware_enable)();
 	if (ret != 0)
 		return ret;
-- 
2.25.1

