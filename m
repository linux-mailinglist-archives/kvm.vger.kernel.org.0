Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A25485B2A3D
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 01:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiIHX0x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 19:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiIHX0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 19:26:30 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F23B108700;
        Thu,  8 Sep 2022 16:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662679573; x=1694215573;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SfxQxRIB04avwvu2iwgntHu0fjCQdA4+XwdzGmceViY=;
  b=keujRBCiVgyBYgCDYowImaC9YlsPnyLcqimz8uJ0RTJulNtAc/hpbNoo
   ghsrGgdYX4p9w81U9cmVOr/BMO3l3lZQwluW4EBnsqZ3pJP1BuM1lH2T0
   nfaYzWfhu9vKIuLyEnuJ367kU20kKaWPuprJzryITivKfr2SVR68Ve8fu
   +6+pMrhTm+sOqInSEdamX+FFLkFNZj2SgZ9ke1aQNqqdxsNREw9Bt6Zgl
   8zRK5Ad2FcoAywDjJzWx7DLtQWTwl94K/KcOClVWvX98gC0/MMZHmf4aG
   tF5m/zDSwSycCHHwIAgn1+oZ5ai0GRulApDHF/J9aGingEuO+9XHJHsXM
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10464"; a="298687014"
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="298687014"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="610863237"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2022 16:26:10 -0700
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
Subject: [PATCH v4 15/26] KVM: kvm_arch.c: Remove _nolock post fix
Date:   Thu,  8 Sep 2022 16:25:31 -0700
Message-Id: <c3f1840c3e41a4496de14ae22b8a9bce79dc7a53.1662679124.git.isaku.yamahata@intel.com>
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

Now all related callbacks are called under kvm_lock, no point for _nolock
post fix.  Remove _nolock post fix for readability with shorter function
names.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_arch.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 32befdbf7d6e..4fe16e8ef2e5 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -20,7 +20,7 @@ __weak int kvm_arch_post_init_vm(struct kvm *kvm)
 	return 0;
 }
 
-static void hardware_enable_nolock(void *caller_name)
+static void hardware_enable(void *caller_name)
 {
 	int cpu = raw_smp_processor_id();
 	int r;
@@ -42,7 +42,7 @@ static void hardware_enable_nolock(void *caller_name)
 	}
 }
 
-static void hardware_disable_nolock(void *junk)
+static void hardware_disable(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 
@@ -56,7 +56,7 @@ static void hardware_disable_nolock(void *junk)
 
 __weak void kvm_arch_pre_hardware_unsetup(void)
 {
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 }
 
 /*
@@ -71,7 +71,7 @@ __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 		return 0;
 
 	atomic_set(&hardware_enable_failed, 0);
-	on_each_cpu(hardware_enable_nolock, (void *)__func__, 1);
+	on_each_cpu(hardware_enable, (void *)__func__, 1);
 
 	if (atomic_read(&hardware_enable_failed)) {
 		r = -EBUSY;
@@ -81,7 +81,7 @@ __weak int kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 	r = kvm_arch_post_init_vm(kvm);
 err:
 	if (r)
-		on_each_cpu(hardware_disable_nolock, NULL, 1);
+		on_each_cpu(hardware_disable, NULL, 1);
 	return r;
 }
 
@@ -90,7 +90,7 @@ __weak int kvm_arch_del_vm(int usage_count)
 	if (usage_count)
 		return 0;
 
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 	return 0;
 }
 
@@ -116,7 +116,7 @@ __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 		 * preemption until all arch callbacks are fixed.
 		 */
 		preempt_disable();
-		hardware_enable_nolock((void *)__func__);
+		hardware_enable((void *)__func__);
 		preempt_enable();
 		if (atomic_read(&hardware_enable_failed)) {
 			atomic_set(&hardware_enable_failed, 0);
@@ -135,7 +135,7 @@ __weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
 		 * preemption until all arch callbacks are fixed.
 		 */
 		preempt_disable();
-		hardware_disable_nolock(NULL);
+		hardware_disable(NULL);
 		preempt_enable();
 	}
 	return 0;
@@ -143,7 +143,7 @@ __weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
 
 __weak int kvm_arch_reboot(int val)
 {
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 	return NOTIFY_OK;
 }
 
@@ -151,7 +151,7 @@ __weak int kvm_arch_suspend(int usage_count)
 {
 	if (usage_count) {
 		preempt_disable();
-		hardware_disable_nolock(NULL);
+		hardware_disable(NULL);
 		preempt_enable();
 	}
 	return 0;
@@ -168,7 +168,7 @@ __weak void kvm_arch_resume(int usage_count)
 
 	if (usage_count) {
 		preempt_disable();
-		hardware_enable_nolock((void *)__func__);
+		hardware_enable((void *)__func__);
 		preempt_enable();
 	}
 }
-- 
2.25.1

