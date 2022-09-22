Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7955E6AB5
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiIVSW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231882AbiIVSWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:22:37 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F6750508;
        Thu, 22 Sep 2022 11:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870902; x=1695406902;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HGmt/VHs6fVj/w1+ZNhXhm615xxkOdQNshHUklQnVBE=;
  b=BEk08WiFn0DwUveX1QNOcGIDNSjKzD5Np5v1eAbTaIBP/r9gkelxUxnT
   VzCJP2Z9Fwlf/+3DLQ5ODOUx3YINmhrsa4tg9g9Rb+JyoDrxj9rnHV7Jm
   nxJ3ndQvfDNsBTdB7r82xyrjRhtnHb+3109cvd80YllZq05UKVb+ST4fa
   Kq5syzpRpt6iJfNp/lX6YsGIIEXbUSqWAvDd2rJ00qvljcG8Mv0+xtaY0
   GSk3i7XscB1jg4Bya+RI42BnKdWdeDCHWXirR5a2TUJU4hSlEBPG24wBv
   tbfEoiLQJUwJMf+NM/zErtv2iZcF2A8Tzl/FkX9Tewo3hyXkc24qGOupk
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712886"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712886"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:21 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086745"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:21 -0700
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
Subject: [PATCH v5 15/30] KVM: Add arch hook for cpu offline event
Date:   Thu, 22 Sep 2022 11:20:44 -0700
Message-Id: <1bed181569380dfa3c7bc5c6b3f0acc1de01217e.1663869838.git.isaku.yamahata@intel.com>
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

Factor out the logic on cpu offline event as arch callback.  Later kvm/x86
will override it.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 30 +++++++++++++++++++-----------
 2 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 013b33a19030..f3a79d55ca8c 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1435,6 +1435,7 @@ static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
 int kvm_arch_online_cpu(unsigned int cpu, int usage_count);
+int kvm_arch_offline_cpu(unsigned int cpu, int usage_count);
 int kvm_arch_reboot(int val);
 int kvm_arch_suspend(int usage_count);
 void kvm_arch_resume(int usage_count);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 4c535ae412a7..ad9b8b7d21fa 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1174,6 +1174,21 @@ int __weak kvm_arch_online_cpu(unsigned int cpu, int usage_count)
 	return ret;
 }
 
+int __weak kvm_arch_offline_cpu(unsigned int cpu, int usage_count)
+{
+	if (usage_count) {
+		/*
+		 * arch callback kvm_arch_hardware_disable() assumes that
+		 * preemption is disabled for historical reason.  Disable
+		 * preemption until all arch callbacks are fixed.
+		 */
+		preempt_disable();
+		hardware_disable_nolock(NULL);
+		preempt_enable();
+	}
+	return 0;
+}
+
 int __weak kvm_arch_reboot(int val)
 {
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
@@ -5137,19 +5152,12 @@ static void hardware_disable_nolock(void *junk)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
+	int ret;
+
 	mutex_lock(&kvm_lock);
-	if (kvm_usage_count) {
-		/*
-		 * arch callback kvm_arch_hardware_disable() assumes that
-		 * preemption is disabled for historical reason.  Disable
-		 * preemption until all arch callbacks are fixed.
-		 */
-		preempt_disable();
-		hardware_disable_nolock(NULL);
-		preempt_enable();
-	}
+	ret = kvm_arch_offline_cpu(cpu, kvm_usage_count);
 	mutex_unlock(&kvm_lock);
-	return 0;
+	return ret;
 }
 
 static void kvm_del_vm(void)
-- 
2.25.1

