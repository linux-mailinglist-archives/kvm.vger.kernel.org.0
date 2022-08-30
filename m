Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEAF5A62AA
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 14:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiH3MCA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 08:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiH3MB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 08:01:57 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B75E396B;
        Tue, 30 Aug 2022 05:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661860916; x=1693396916;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8uxTMc931N62LSyYSZec4Q6h4MH1p09mPLFpxJiMDMs=;
  b=htcnDZrp5URoAp8QDKtTiQlZGHq+fQPV+dU3Bx7JEQ/t8b+LavSICrd/
   3OovxlfgIAIWL4RZNAMdSCibnj+eIxcMlHrhSzO4SehOz0bgR5YneNWkp
   Qrg0muydE+tdWciBQKT9oBM0IVI7hHudpnX88CqYarGsFU+J9C16dzWRI
   v9A/sJCjJZLpl9J56RUawsHyLRSHrPfpyQDeaHjTwYcjcvg/CoCmB3Hz0
   FpW5kPH1vQ/nPdpiLj8aNl2m0z7JuME/h8t2BkDuv5LgUy+HKpY6NkHoM
   bhQ/KeZdG3M/gYx1E3gI/vYFVe36galuyZWjSL/mmzxNtLSwZsxOEq0jK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="356870954"
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="356870954"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:54 -0700
X-IronPort-AV: E=Sophos;i="5.93,274,1654585200"; 
   d="scan'208";a="787469608"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 05:01:54 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2 01/19] KVM: x86: Drop kvm_user_return_msr_cpu_online()
Date:   Tue, 30 Aug 2022 05:01:16 -0700
Message-Id: <f63a395ead4204d44cab3b734c99b07f54c38463.1661860550.git.isaku.yamahata@intel.com>
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

KVM/X86 uses user return notifier to switch MSR for guest or user space.
Snapshot host values on CPU online, change MSR values for guest, and
restore them on returning to user space.  The current code abuses
kvm_arch_hardware_enable() which is called on kvm module initialization or
CPU online.

Remove such the abuse of kvm_arch_hardware_enable by capturing the host
value on the first change of the MSR value to guest VM instead of CPU
online.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/x86.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 205ebdc2b11b..16104a2f7d8e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -200,6 +200,7 @@ struct kvm_user_return_msrs {
 	struct kvm_user_return_msr_values {
 		u64 host;
 		u64 curr;
+		bool initialized;
 	} values[KVM_MAX_NR_USER_RETURN_MSRS];
 };
 
@@ -363,6 +364,10 @@ static void kvm_on_user_return(struct user_return_notifier *urn)
 	local_irq_restore(flags);
 	for (slot = 0; slot < kvm_nr_uret_msrs; ++slot) {
 		values = &msrs->values[slot];
+		/*
+		 * No need to check values->initialized because host = curr = 0
+		 * by __GFP_ZERO when !values->initialized.
+		 */
 		if (values->host != values->curr) {
 			wrmsrl(kvm_uret_msrs_list[slot], values->host);
 			values->curr = values->host;
@@ -409,34 +414,30 @@ int kvm_find_user_return_msr(u32 msr)
 }
 EXPORT_SYMBOL_GPL(kvm_find_user_return_msr);
 
-static void kvm_user_return_msr_cpu_online(void)
-{
-	unsigned int cpu = smp_processor_id();
-	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
-	u64 value;
-	int i;
-
-	for (i = 0; i < kvm_nr_uret_msrs; ++i) {
-		rdmsrl_safe(kvm_uret_msrs_list[i], &value);
-		msrs->values[i].host = value;
-		msrs->values[i].curr = value;
-	}
-}
-
 int kvm_set_user_return_msr(unsigned slot, u64 value, u64 mask)
 {
 	unsigned int cpu = smp_processor_id();
 	struct kvm_user_return_msrs *msrs = per_cpu_ptr(user_return_msrs, cpu);
+	struct kvm_user_return_msr_values *values = &msrs->values[slot];
 	int err;
 
-	value = (value & mask) | (msrs->values[slot].host & ~mask);
-	if (value == msrs->values[slot].curr)
+	if (unlikely(!values->initialized)) {
+		u64 host_value;
+
+		rdmsrl_safe(kvm_uret_msrs_list[slot], &host_value);
+		values->host = host_value;
+		values->curr = host_value;
+		values->initialized = true;
+	}
+
+	value = (value & mask) | (values->host & ~mask);
+	if (value == values->curr)
 		return 0;
 	err = wrmsrl_safe(kvm_uret_msrs_list[slot], value);
 	if (err)
 		return 1;
 
-	msrs->values[slot].curr = value;
+	values->curr = value;
 	if (!msrs->registered) {
 		msrs->urn.on_user_return = kvm_on_user_return;
 		user_return_notifier_register(&msrs->urn);
@@ -9212,7 +9213,12 @@ int kvm_arch_init(void *opaque)
 		return -ENOMEM;
 	}
 
-	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
+	/*
+	 * __GFP_ZERO to ensure user_return_msrs.values[].{host, curr} match.
+	 * See kvm_on_user_return()
+	 */
+	user_return_msrs = alloc_percpu_gfp(struct kvm_user_return_msrs,
+					    GFP_KERNEL | __GFP_ZERO);
 	if (!user_return_msrs) {
 		printk(KERN_ERR "kvm: failed to allocate percpu kvm_user_return_msrs\n");
 		r = -ENOMEM;
@@ -11836,7 +11842,6 @@ int kvm_arch_hardware_enable(void)
 	u64 max_tsc = 0;
 	bool stable, backwards_tsc = false;
 
-	kvm_user_return_msr_cpu_online();
 	ret = static_call(kvm_x86_hardware_enable)();
 	if (ret != 0)
 		return ret;
-- 
2.25.1

