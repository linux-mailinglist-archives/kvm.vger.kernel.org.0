Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09A458BD38
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbiHGWEg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235007AbiHGWDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:03:04 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2219FF5;
        Sun,  7 Aug 2022 15:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909763; x=1691445763;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8LP0DSlhNllsHxUGI5PiVoLspYIH9nx4tPzL+cKLV9g=;
  b=FArodm45NZKZCTCZi8dJlex/HHJkrrA5NBXMoAXBvsMXrem3xu0zw4At
   rjWgsDOWqOkdrh1IaJ78TTaADcOuaQZ0t8Iezz38Ofp5ZlmBMkSaZ0kaa
   QgOrk8CvaSsm7pQnLGd0emwdfM4Ot9Dc65sYL4RHEhr2yhAOzu+awoSYH
   r4dGUbc7qWzvhsumIWSCDsLOeRxX/3T0eZpGyfrBJVKAwjGHq8Tgr3zj2
   WB5X8IgTGgM8EBNDthkSTlhHaTx++GSIE7HBPXu1hpjvytaObyOT4i+MS
   XmhiSKIjVdbu6SQ75Ls+OFuiHU5vSm8+E4ANcv0RIJFjM8+oVsNlqGKoY
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="291695697"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="291695697"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:38 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682625"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:37 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 055/103] KVM: Add functions to track whether GFN is private or shared
Date:   Sun,  7 Aug 2022 15:01:40 -0700
Message-Id: <255c9a699e38112b106c4f3305a5f03d7390799b.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM support needs to track whether GFN is private or shared.  Introduce
CONFIG_HAVE_KVM_PRIVATE_MEM_ATTR to add functions to track whether GFN is
private or shared.  Use xarray to track it for memory efficiency in normal
usage.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Kconfig     |  1 +
 include/linux/kvm_host.h | 16 ++++++++++++
 virt/kvm/Kconfig         |  3 +++
 virt/kvm/kvm_main.c      | 55 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 75 insertions(+)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 5a59abc83179..a77830a3f371 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -48,6 +48,7 @@ config KVM
 	select SRCU
 	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
+	select HAVE_KVM_PRIVATE_MEM_ATTR if KVM_MMU_PRIVATE
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 025251806e70..7bc84ed44e43 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -786,8 +786,24 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM_ATTR
+	struct xarray mem_attr_array;
+#endif
 };
 
+#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM_ATTR
+#define KVM_MEM_ATTR_SHARED    0x1
+#define KVM_MEM_ATTR_PRIVATE   0x2
+
+/* memory attr on [start, end) */
+int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end);
+int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end);
+static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
+{
+	return !xa_load(&kvm->mem_attr_array, gfn);
+}
+#endif
+
 #define kvm_err(fmt, ...) \
 	pr_err("kvm [%i]: " fmt, task_pid_nr(current), ## __VA_ARGS__)
 #define kvm_info(fmt, ...) \
diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
index a8c5c9f06b3c..bef6fc63f99f 100644
--- a/virt/kvm/Kconfig
+++ b/virt/kvm/Kconfig
@@ -72,3 +72,6 @@ config KVM_XFER_TO_GUEST_WORK
 
 config HAVE_KVM_PM_NOTIFIER
        bool
+
+config HAVE_KVM_PRIVATE_MEM_ATTR
+       bool
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 3cc29fdba562..e182161baf00 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -917,6 +917,55 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 
 #endif /* CONFIG_MMU_NOTIFIER && KVM_ARCH_WANT_MMU_NOTIFIER */
 
+#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM_ATTR
+/*
+ * Reserve memory for [start, end) so that the next set oepration won't fail
+ * with -ENOMEM.
+ */
+int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	int r = 0;
+	gfn_t gfn;
+
+	xa_lock(&kvm->mem_attr_array);
+	for (gfn = start; gfn < end; gfn++) {
+		r = __xa_insert(&kvm->mem_attr_array, gfn, NULL, GFP_KERNEL_ACCOUNT);
+		if (r == -EBUSY)
+			r = 0;
+		if (r)
+			break;
+	}
+	xa_unlock(&kvm->mem_attr_array);
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_reserve_mem_attr);
+
+/* Set memory attr for [start, end) */
+int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end)
+{
+	void *entry;
+
+	/* By default, the entry is private. */
+	switch (attr) {
+	case KVM_MEM_ATTR_PRIVATE:
+		entry = NULL;
+		break;
+	case KVM_MEM_ATTR_SHARED:
+		entry = xa_mk_value(KVM_MEM_ATTR_SHARED);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	WARN_ON(start >= end);
+	return xa_err(xa_store_range(&kvm->mem_attr_array, start, end - 1,
+				     entry, GFP_KERNEL_ACCOUNT));
+}
+EXPORT_SYMBOL_GPL(kvm_vm_set_mem_attr);
+#endif /* CONFIG_HAVE_KVM_PRIVATE_MEM_ATTR */
+
 #ifdef CONFIG_HAVE_KVM_PM_NOTIFIER
 static int kvm_pm_notifier_call(struct notifier_block *bl,
 				unsigned long state,
@@ -1141,6 +1190,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	spin_lock_init(&kvm->mn_invalidate_lock);
 	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
 	xa_init(&kvm->vcpu_array);
+#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM_ATTR
+	xa_init(&kvm->mem_attr_array);
+#endif
 
 	INIT_LIST_HEAD(&kvm->gpc_list);
 	spin_lock_init(&kvm->gpc_lock);
@@ -1308,6 +1360,9 @@ static void kvm_destroy_vm(struct kvm *kvm)
 		kvm_free_memslots(kvm, &kvm->__memslots[i][0]);
 		kvm_free_memslots(kvm, &kvm->__memslots[i][1]);
 	}
+#ifdef CONFIG_HAVE_KVM_PRIVATE_MEM_ATTR
+	xa_destroy(&kvm->mem_attr_array);
+#endif
 	cleanup_srcu_struct(&kvm->irq_srcu);
 	cleanup_srcu_struct(&kvm->srcu);
 	kvm_arch_free_vm(kvm);
-- 
2.25.1

