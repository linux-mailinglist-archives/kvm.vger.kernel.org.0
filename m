Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6E8F7BF60B
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442962AbjJJIf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442916AbjJJIfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4631EA4;
        Tue, 10 Oct 2023 01:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926937; x=1728462937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TulaiyUaTkWindo/LLjGvgcL1lDIYfNLfoQuJ8JmFgY=;
  b=O5d76+aeMKzgP6UP84leojsKUaAxAutmpKIo61UnHfRwwyXnFwvAuvbZ
   WywDWBtI9/hrMzAAQXQrK8HJfyCnMdWNjJWSvxObVvG6Nzhli5Ixz0LEJ
   E8HOFxvr/NaYUSBfBLbNPDW4s7ZXeZ53A3KBOJ7d9FNq5ZSd+lPkY4e/L
   wgiRYPXRLIFKXHG1ymlOuDdjmVmx58zlqrurByQJqP33vZ1qoldysnc03
   EB5zDu38ZJEpxtsO6lPJVQlWi8Z+h5ElQE9ff3XRpu7MFOTCJagMfN04m
   ZmFVoyf/brC4doETi3az7BHAllpZKamLeRkHM3ka2nAkHG6oCrJdQmYp1
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="363689830"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="363689830"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="1084687200"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="1084687200"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:35 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 08/12] x86/mce: Define a notifier chain for mce injector
Date:   Tue, 10 Oct 2023 01:35:16 -0700
Message-Id: <0fd1649eb24b9757c299a89e34444630924bd2e0.1696926843.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1696926843.git.isaku.yamahata@intel.com>
References: <cover.1696926843.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

To test KVM mechine check injection path, KVM wants to trigger machine
check on its own.  Not on writing to debugfs bank file of x86 mce injector.

Because KVM doesn't want to depend on x86 MCE injector, define notifier
chain in the x86 MCE core and make the x86 MCE injector to register the
notifier chain to decouple the MCE injector and its user.  This follows how
dev-mcelog does.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/mce.h       |  6 ++++++
 arch/x86/kernel/cpu/mce/core.c   | 20 ++++++++++++++++++++
 arch/x86/kernel/cpu/mce/inject.c | 18 ++++++++++++++++++
 3 files changed, 44 insertions(+)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 459066ecd922..1a832a207b6a 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -269,10 +269,16 @@ DECLARE_PER_CPU(struct mce, injectm);
 void mce_inject_lock(void);
 void mce_inject_unlock(void);
 void mce_inject(struct mce *m);
+void mce_register_atomic_injector_chain(struct notifier_block *nb);
+void mce_unregister_atomic_injector_chain(struct notifier_block *nb);
+void mce_call_atomic_injector_chain(unsigned long cpu);
 #else
 static inline void mce_inject_lock(void) {}
 static inline void mce_inject_unlock(void) {}
 static inline void mce_inject(struct mce *m) {}
+static inline void mce_register_atomic_injector_chain(struct notifier_block *nb) {}
+static inline void mce_unregister_atomic_injector_chain(struct notifier_block *nb) {}
+static inline void mce_call_atomic_injector_chain(unsigned long cpu) {}
 #endif
 
 /* Disable CMCI/polling for MCA bank claimed by firmware */
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 6929c3cad278..9a6b04be7404 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -169,6 +169,26 @@ void mce_inject(struct mce *m)
 }
 EXPORT_SYMBOL_GPL(mce_inject);
 
+static ATOMIC_NOTIFIER_HEAD(mce_atomic_injector_chain);
+
+void mce_register_atomic_injector_chain(struct notifier_block *nb)
+{
+	atomic_notifier_chain_register(&mce_atomic_injector_chain, nb);
+}
+EXPORT_SYMBOL_GPL(mce_register_atomic_injector_chain);
+
+void mce_unregister_atomic_injector_chain(struct notifier_block *nb)
+{
+	atomic_notifier_chain_unregister(&mce_atomic_injector_chain, nb);
+}
+EXPORT_SYMBOL_GPL(mce_unregister_atomic_injector_chain);
+
+void mce_call_atomic_injector_chain(unsigned long cpu)
+{
+	atomic_notifier_call_chain(&mce_atomic_injector_chain, cpu, NULL);
+}
+EXPORT_SYMBOL_GPL(mce_call_atomic_injector_chain);
+
 void mce_log(struct mce *m)
 {
 	if (!mce_gen_pool_add(m))
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 43d896a89648..5dac4dcb25aa 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -303,8 +303,24 @@ static int fadvise_inject_addr(struct notifier_block *nb, unsigned long val,
 
 static struct notifier_block fadvise_nb = {
 	.notifier_call	= fadvise_inject_addr,
+};
+
+static int mce_atomic_injector(struct notifier_block *nb, unsigned long val,
+			       void *data)
+{
+	lockdep_assert_preemption_disabled();
+
+	i_mce.extcpu = val;
+	mce_inject(&i_mce);
+	setup_inj_struct(&i_mce);
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block atomic_injector_nb = {
+	.notifier_call = mce_atomic_injector,
+};
+
 /*
  * Caller needs to be make sure this cpu doesn't disappear
  * from under us, i.e.: get_cpu/put_cpu.
@@ -796,6 +812,7 @@ static int __init inject_init(void)
 	register_nmi_handler(NMI_LOCAL, mce_raise_notify, 0, "mce_notify");
 	mce_register_injector_chain(&inject_nb);
 	fadvise_register_mce_injector_chain(&fadvise_nb);
+	mce_register_atomic_injector_chain(&atomic_injector_nb);
 
 	setup_inj_struct(&i_mce);
 
@@ -807,6 +824,7 @@ static int __init inject_init(void)
 static void __exit inject_exit(void)
 {
 
+	mce_unregister_atomic_injector_chain(&atomic_injector_nb);
 	fadvise_unregister_mce_injector_chain(&fadvise_nb);
 	mce_unregister_injector_chain(&inject_nb);
 	unregister_nmi_handler(NMI_LOCAL, "mce_notify");
-- 
2.25.1

