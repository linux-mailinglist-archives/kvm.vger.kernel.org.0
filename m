Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 274D559ABAD
	for <lists+kvm@lfdr.de>; Sat, 20 Aug 2022 08:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244361AbiHTGAv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Aug 2022 02:00:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiHTGAt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Aug 2022 02:00:49 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3A2A2237;
        Fri, 19 Aug 2022 23:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660975248; x=1692511248;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8uxTMc931N62LSyYSZec4Q6h4MH1p09mPLFpxJiMDMs=;
  b=CewhIl6ghhuIdaGvkrFc4OZFbfbIEDYwG4QF6MlW8onpRE+uQEiqXNLf
   g206XtIrrsdHcVnR94dGVJ4pGFKKdBneQwc1SFt89R6kEo6awZ6usb8m+
   g2aXbzOfmvqENu/N6NZC+6Rq3YkDgEeav5Wf+iRf8FaJzYKBlfGUjBQZw
   M5jY12bnFW8kU58OSY6RFtyi54JDHJYO8zQTD/i3PwADUKg67nbMTgwmf
   RDO0nJBU2bUfWtlBAffuZc3ZMQgAf3OAiA42j/Sm8YcsL0H0TB+HA5Q5a
   WESY5/aLZqFdJnAUWAWYm5ylQ+54l4EbFhL7Aeg5zzYw0k3cG5mxIvLo4
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10444"; a="379448966"
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="379448966"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:48 -0700
X-IronPort-AV: E=Sophos;i="5.93,250,1654585200"; 
   d="scan'208";a="668857511"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2022 23:00:48 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Will Deacon <will@kernel.org>
Subject: [RFC PATCH 01/18] KVM: x86: Drop kvm_user_return_msr_cpu_online()
Date:   Fri, 19 Aug 2022 23:00:07 -0700
Message-Id: <9e0f84ece483bfeffe7e0b254363845af910ea84.1660974106.git.isaku.yamahata@intel.com>
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

