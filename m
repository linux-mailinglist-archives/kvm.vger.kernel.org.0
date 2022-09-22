Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE055E6AB7
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 20:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiIVSWo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 14:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232468AbiIVSVu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 14:21:50 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B4E10B5B6;
        Thu, 22 Sep 2022 11:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663870900; x=1695406900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9rqrAWK9z6uKisn3U+yyVK3Y97E5qWOYWWtQX0dgrOg=;
  b=hw/MK0eeUvQm6vun7I72QfsNU1h0EY1a5ZMsFWZtL5w/DKNkxuCG3Qxi
   nQ0pWqDjT9E+e80T8Ti+z1UKoPmBL96ie6QBKC8NiHq6rqdWwQye2eVU4
   oqLqwXu4aGcAt4LD3lIhGzYHbCP5hohI7IKqJJQdcMVFF/cUCVP5DlX91
   J2p/9Bos9qO+orKjsP9ikPwa2E/df6pVd4G/oM4vRjPoJluo33t/dKiEv
   KdHepnKvnx0lRLqgKjQust8HX7gweEvSjR5auyRQbOhcjUtGuMdDVkiII
   5t8fpu4gAxvd3NvdW00Ay7uri90hnQ2ZEMuJ0nK4hVA1qAF7CovJEUAYl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="326712884"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="326712884"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:21 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653086737"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 11:21:20 -0700
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
Subject: [PATCH v5 14/30] KVM: Add arch hook for cpu online event
Date:   Thu, 22 Sep 2022 11:20:43 -0700
Message-Id: <ae4b7178d1f6c95bcf0895f27d8939af514a1af2.1663869838.git.isaku.yamahata@intel.com>
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

Factor out the logic on cpu hotplug event as arch callback.  Later kvm/x86
will override it.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 58 +++++++++++++++++++++++-----------------
 2 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1adbf74e3047..013b33a19030 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1434,6 +1434,7 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 static inline void kvm_create_vcpu_debugfs(struct kvm_vcpu *vcpu) {}
 #endif
 
+int kvm_arch_online_cpu(unsigned int cpu, int usage_count);
 int kvm_arch_reboot(int val);
 int kvm_arch_suspend(int usage_count);
 void kvm_arch_resume(int usage_count);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1270f88c2a1e..4c535ae412a7 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1142,6 +1142,38 @@ int __weak kvm_arch_del_vm(int usage_count)
 	return 0;
 }
 
+int __weak kvm_arch_online_cpu(unsigned int cpu, int usage_count)
+{
+	int ret = 0;
+
+	ret = kvm_arch_check_processor_compat();
+	if (ret)
+		return ret;
+
+	/*
+	 * Abort the CPU online process if hardware virtualization cannot
+	 * be enabled. Otherwise running VMs would encounter unrecoverable
+	 * errors when scheduled to this CPU.
+	 */
+	if (usage_count) {
+		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
+
+		/*
+		 * arch callback kvm_arch_hardware_eanble() assumes that
+		 * preemption is disabled for historical reason.  Disable
+		 * preemption until all arch callbacks are fixed.
+		 */
+		preempt_disable();
+		hardware_enable_nolock(NULL);
+		preempt_enable();
+		if (atomic_read(&hardware_enable_failed)) {
+			atomic_set(&hardware_enable_failed, 0);
+			ret = -EIO;
+		}
+	}
+	return ret;
+}
+
 int __weak kvm_arch_reboot(int val)
 {
 	on_each_cpu(hardware_disable_nolock, NULL, 1);
@@ -5085,32 +5117,8 @@ static int kvm_online_cpu(unsigned int cpu)
 {
 	int ret;
 
-	ret = kvm_arch_check_processor_compat();
-	if (ret)
-		return ret;
-
 	mutex_lock(&kvm_lock);
-	/*
-	 * Abort the CPU online process if hardware virtualization cannot
-	 * be enabled. Otherwise running VMs would encounter unrecoverable
-	 * errors when scheduled to this CPU.
-	 */
-	if (kvm_usage_count) {
-		WARN_ON_ONCE(atomic_read(&hardware_enable_failed));
-
-		/*
-		 * arch callback kvm_arch_hardware_eanble() assumes that
-		 * preemption is disabled for historical reason.  Disable
-		 * preemption until all arch callbacks are fixed.
-		 */
-		preempt_disable();
-		hardware_enable_nolock(NULL);
-		preempt_enable();
-		if (atomic_read(&hardware_enable_failed)) {
-			atomic_set(&hardware_enable_failed, 0);
-			ret = -EIO;
-		}
-	}
+	ret = kvm_arch_online_cpu(cpu, kvm_usage_count);
 	mutex_unlock(&kvm_lock);
 	return ret;
 }
-- 
2.25.1

