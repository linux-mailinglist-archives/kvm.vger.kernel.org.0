Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263D05E6AC4
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiIVSXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiIVSWn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:22:43 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E54B10B5AB;
        Thu, 22 Sep 2022 11:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870917; x=1695406917;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L8+RR+UhC+idmPkn74NT4bHxkU564YnpQS2qQj/GxDE=;
  b=LOkl5siZfVR9UJpxPiSSPgnqEbyFtWEv3T+irwy9q/BfXbyNYMTNz+s8
   2dg7KjbA0WbmYBcSu2ikU5+CmaZUtxM1znIjOLOh2Bwa+9ceFVZtKTu68
   6pkaQUn/3WJ5JBywl2A6WFFsxYww4EK9Znb9iVUpS1xlz27CVy9dXQNN4
   xG2l4YDxli1NNcTF/emxIGep8lnEaKkzopeyFlwI3ylRyYmIidpZIR+dd
   n1tyz38K7YPgB5bU8TzJE6Wt86+suZaRCYZVr+A2ZljlSP3xDRHOCA2cv
   Mp4ugpy0+Pwy64rjGQ7jUeEnAj7ZCjaZj4h7leq4zMOW34rEYYt4mGUsg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712900"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712900"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:23 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086775"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:22 -0700
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
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 18/30] KVM: kvm_arch.c: Remove _nolock post fix
Date:   Thu, 22 Sep 2022 11:20:47 -0700
Message-Id: <f51f97c19593571481cd1072bd240bb5ec4c6faf.1663869838.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1663869838.git.isaku.yamahata@intel.com>
References: <cover.1663869838.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Chao Gao <chao.gao@intel.com>
---
 virt/kvm/kvm_arch.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/virt/kvm/kvm_arch.c b/virt/kvm/kvm_arch.c
index bcf8b74144e3..e6bf9de18cba 100644
--- a/virt/kvm/kvm_arch.c
+++ b/virt/kvm/kvm_arch.c
@@ -24,7 +24,7 @@ int __weak kvm_arch_post_init_vm(struct kvm *kvm)
 	return 0;
 }
 
-static void hardware_enable_nolock(void *junk)
+static void hardware_enable(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 	int r;
@@ -46,7 +46,7 @@ static void hardware_enable_nolock(void *junk)
 	}
 }
 
-static void hardware_disable_nolock(void *junk)
+static void hardware_disable(void *junk)
 {
 	int cpu = raw_smp_processor_id();
 
@@ -70,7 +70,7 @@ int __weak kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 		return 0;
 
 	atomic_set(&hardware_enable_failed, 0);
-	on_each_cpu(hardware_enable_nolock, NULL, 1);
+	on_each_cpu(hardware_enable, NULL, 1);
 
 	if (atomic_read(&hardware_enable_failed)) {
 		r = -EBUSY;
@@ -80,7 +80,7 @@ int __weak kvm_arch_add_vm(struct kvm *kvm, int usage_count)
 	r = kvm_arch_post_init_vm(kvm);
 err:
 	if (r)
-		on_each_cpu(hardware_disable_nolock, NULL, 1);
+		on_each_cpu(hardware_disable, NULL, 1);
 	return r;
 }
 
@@ -89,7 +89,7 @@ int __weak kvm_arch_del_vm(int usage_count)
 	if (usage_count)
 		return 0;
 
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 	return 0;
 }
 
@@ -115,7 +115,7 @@ int __weak kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 		 * preemption until all arch callbacks are fixed.
 		 */
 		preempt_disable();
-		hardware_enable_nolock(NULL);
+		hardware_enable(NULL);
 		preempt_enable();
 		if (atomic_read(&hardware_enable_failed)) {
 			atomic_set(&hardware_enable_failed, 0);
@@ -134,7 +134,7 @@ int __weak kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
 		 * preemption until all arch callbacks are fixed.
 		 */
 		preempt_disable();
-		hardware_disable_nolock(NULL);
+		hardware_disable(NULL);
 		preempt_enable();
 	}
 	return 0;
@@ -142,7 +142,7 @@ int __weak kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
 
 int __weak kvm_arch_reboot(int val)
 {
-	on_each_cpu(hardware_disable_nolock, NULL, 1);
+	on_each_cpu(hardware_disable, NULL, 1);
 	return NOTIFY_OK;
 }
 
@@ -153,12 +153,12 @@ int __weak kvm_arch_suspend(int usage_count)
 		 * Because kvm_suspend() is called with interrupt disabled,  no
 		 * need to disable preemption.
 		 */
-		hardware_disable_nolock(NULL);
+		hardware_disable(NULL);
 	return 0;
 }
 
 void __weak kvm_arch_resume(int usage_count)
 {
 	if (usage_count)
-		hardware_enable_nolock(NULL);
+		hardware_enable(NULL);
 }
-- 
2.25.1

