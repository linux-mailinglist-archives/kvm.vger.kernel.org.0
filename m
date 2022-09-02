Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E4A5AA5B2
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbiIBCSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbiIBCS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:18:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA6EEAA4E7;
        Thu,  1 Sep 2022 19:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662085098; x=1693621098;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/wt16wqaMrCzDPJUUPAY9+ovSGCvECZTKTK8vT2TyXU=;
  b=Oe+QV1A3pmWX+5xOUn0A+M0+ZArpPr8Fm6k4eSOFkc8tnB/liEmM56mw
   ZXuazmPvklbohprWOocegsxmf/7yplOy7UWjfKu7j0Gk+rFO2jFd3uA+e
   +9xhVUpzg7VKi7I0dQ01ISYq+hB90aGR1zdXSVNzQzxYh0fhl5dsBNJT3
   wNMXErltyKxdUIbHDxXW3Gn11F8FpcSPwdb1MS4yVPhQofVtqcscKsbs0
   1sEjBfaHr76c3COCh2fg+8lL76/fMPaEH3rO3ZtdiMc2nHI1ZqRBdSaQX
   u66aEC85lS8T57Is19/wkGbZyTCrFnm+634HNC3165d1l4NNCsN1B3qR5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="297157855"
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="297157855"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,281,1654585200"; 
   d="scan'208";a="608835651"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2022 19:18:18 -0700
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
Subject: [PATCH v3 15/22] KVM: kvm_arch.c: Remove _nolock post fix
Date:   Thu,  1 Sep 2022 19:17:50 -0700
Message-Id: <588af134e4830ce74d3d77eb45ec1e147d5e0aa3.1662084396.git.isaku.yamahata@intel.com>
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

Now all related callbacks are called under kvm_lock, no point for _nolock
post fix.  Remove _nolock post fix for readability with shorter function
names.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 virt/kvm/kvm_arch.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index 0648d4463d9e..de39d0127584 100644
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
 
@@ -110,7 +110,7 @@ __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 	if (usage_count) {
 		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
 
-		hardware_enable_nolock((void *)__func__);
+		hardware_enable((void *)__func__);
 		if (atomic_read(&hardware_enable_failed)) {
 			atomic_set(&hardware_enable_failed, 0);
 			ret = -EIO;
@@ -122,20 +122,20 @@ __weak int kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 __weak int kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
 {
 	if (usage_count)
-		hardware_disable_nolock(NULL);
+		hardware_disable(NULL);
 	return 0;
 }
 
 __weak int kvm_arch_reboot(int val)
 {
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 	return NOTIFY_OK;
 }
 
 __weak int kvm_arch_suspend(int usage_count)
 {
 	if (usage_count)
-		hardware_disable_nolock(NULL);
+		hardware_disable(NULL);
 	return 0;
 }
 
@@ -149,5 +149,5 @@ __weak void kvm_arch_resume(int usage_count)
 		return; /* FIXME: disable KVM */
 
 	if (usage_count)
-		hardware_enable_nolock((void *)__func__);
+		hardware_enable((void *)__func__);
 }
-- 
2.25.1

