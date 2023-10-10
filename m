Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9EA7BF60A
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442950AbjJJIfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442901AbjJJIfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25887AF;
        Tue, 10 Oct 2023 01:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926935; x=1728462935;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Oyxf6nVEdFzk2imp0lAzFXWCTZ+GLK4NVgZs/8mH1xk=;
  b=h/TfGsoWI3gXGMBAzsj1D3lcmGNR3wVpm5s3/r2J9cMng+ZVmkde23Zd
   5b1KPFmKjNfuhUtVKUTsNpwzkaP04K+WyN8DrfrV14hmU0699oa+w2sZw
   qy67EJjLwpExlbRBN64vhfkaP6chvlpLLhqzb1um+Cqxb9Fj9c0ZqaWYi
   zReeakMEIBP5nP0ID98LAcQa2EBJsBtbdaL8mNPo9TCnbfp+hkXbvt4qy
   UHx2JyYkeDDxFJqrPuV4HaVm8NYhgOBVBUcwHxFCXZNrIyW3+Bl9RPeTe
   OrFM24RvnUL5ZW07tQAJ8F8U/eczCgZcaEo6Y9lZuXOOyW3IpGCmIAXrC
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="363689798"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="363689798"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="1084687185"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="1084687185"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:33 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 04/12] x86/mce: Move and export inject_mce() from inject.c to core.c
Date:   Tue, 10 Oct 2023 01:35:12 -0700
Message-Id: <a5109244e6ab4e9a03595a2a8daadd01d13ebc3f.1696926843.git.isaku.yamahata@intel.com>
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

X86 MCE support is kernel builtin. CONFIG_X86_MCE=y or n.  The x86 MCE
injection framework can be kernel builtin or kernel module.
CONFIG_X86_MCE_INJECT=y, m, or n. We don't want KVM depend on
CONFIG_X86_MCE_INJECT=y, allow CONFIG_X86_MCE_INJECT=m for KVM mce
injection.

Move the necessary symbols with rename from
arch/x86/kernel/cpu/mce/inject.c to arch/x86/kernel/cpu/mce/core.c and
export symbols for KVM to inject MCE.

Oppertunistically add lockdep_assert_held(&mce_inject_mutex) to show
that injectm is protected by mce_inject_mutex.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/mce.h       | 10 +++++++++
 arch/x86/kernel/cpu/mce/core.c   | 36 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/mce/inject.c | 26 +++--------------------
 3 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 180b1cbfcc4e..459066ecd922 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -265,6 +265,16 @@ int mce_notify_irq(void);
 
 DECLARE_PER_CPU(struct mce, injectm);
 
+#ifdef CONFIG_X86_MCE
+void mce_inject_lock(void);
+void mce_inject_unlock(void);
+void mce_inject(struct mce *m);
+#else
+static inline void mce_inject_lock(void) {}
+static inline void mce_inject_unlock(void) {}
+static inline void mce_inject(struct mce *m) {}
+#endif
+
 /* Disable CMCI/polling for MCA bank claimed by firmware */
 extern void mce_disable_bank(int bank);
 
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 6f35f724cc14..6929c3cad278 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -129,9 +129,45 @@ void mce_setup(struct mce *m)
 	m->ppin = cpu_data(m->extcpu).ppin;
 	m->microcode = boot_cpu_data.microcode;
 }
+EXPORT_SYMBOL_GPL(mce_setup);
 
 DEFINE_PER_CPU(struct mce, injectm);
 EXPORT_PER_CPU_SYMBOL_GPL(injectm);
+static DEFINE_MUTEX(mce_inject_mutex);
+
+void mce_inject_lock(void)
+{
+	mutex_lock(&mce_inject_mutex);
+}
+EXPORT_SYMBOL_GPL(mce_inject_lock);
+
+void mce_inject_unlock(void)
+{
+	mutex_unlock(&mce_inject_mutex);
+}
+EXPORT_SYMBOL_GPL(mce_inject_unlock);
+
+/* Update fake mce registers on current CPU. */
+void mce_inject(struct mce *m)
+{
+	struct mce *i = &per_cpu(injectm, m->extcpu);
+
+	lockdep_assert_held(&mce_inject_mutex);
+
+	/* Make sure no one reads partially written injectm */
+	i->finished = 0;
+	mb();
+	m->finished = 0;
+	/* First set the fields after finished */
+	i->extcpu = m->extcpu;
+	mb();
+	/* Now write record in order, finished last (except above) */
+	memcpy(i, m, sizeof(struct mce));
+	/* Finally activate it */
+	mb();
+	i->finished = 1;
+}
+EXPORT_SYMBOL_GPL(mce_inject);
 
 void mce_log(struct mce *m)
 {
diff --git a/arch/x86/kernel/cpu/mce/inject.c b/arch/x86/kernel/cpu/mce/inject.c
index 88603a6c0afe..ae3efbeb78bd 100644
--- a/arch/x86/kernel/cpu/mce/inject.c
+++ b/arch/x86/kernel/cpu/mce/inject.c
@@ -126,25 +126,6 @@ static void setup_inj_struct(struct mce *m)
 	m->microcode = boot_cpu_data.microcode;
 }
 
-/* Update fake mce registers on current CPU. */
-static void inject_mce(struct mce *m)
-{
-	struct mce *i = &per_cpu(injectm, m->extcpu);
-
-	/* Make sure no one reads partially written injectm */
-	i->finished = 0;
-	mb();
-	m->finished = 0;
-	/* First set the fields after finished */
-	i->extcpu = m->extcpu;
-	mb();
-	/* Now write record in order, finished last (except above) */
-	memcpy(i, m, sizeof(struct mce));
-	/* Finally activate it */
-	mb();
-	i->finished = 1;
-}
-
 static void raise_poll(struct mce *m)
 {
 	unsigned long flags;
@@ -176,7 +157,6 @@ static void raise_exception(struct mce *m, struct pt_regs *pregs)
 }
 
 static cpumask_var_t mce_inject_cpumask;
-static DEFINE_MUTEX(mce_inject_mutex);
 
 static int mce_raise_notify(unsigned int cmd, struct pt_regs *regs)
 {
@@ -245,7 +225,7 @@ static void __maybe_unused raise_mce(struct mce *m)
 {
 	int context = MCJ_CTX(m->inject_flags);
 
-	inject_mce(m);
+	mce_inject(m);
 
 	if (context == MCJ_CTX_RANDOM)
 		return;
@@ -303,9 +283,9 @@ static int mce_inject_raise(struct notifier_block *nb, unsigned long val,
 	if (!m)
 		return NOTIFY_DONE;
 
-	mutex_lock(&mce_inject_mutex);
+	mce_inject_lock();
 	raise_mce(m);
-	mutex_unlock(&mce_inject_mutex);
+	mce_inject_unlock();
 
 	return NOTIFY_DONE;
 }
-- 
2.25.1

