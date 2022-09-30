Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCD15F08D5
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232295AbiI3KXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbiI3KVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:21:04 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E021E05C9;
        Fri, 30 Sep 2022 03:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664533158; x=1696069158;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HLHgtHqsIjWYwcn8V6phxCpOor1CcaO2v8wpXvHA2G0=;
  b=EdzkZTqqxndF6dltWZKZaA5YIOn3rX099LateAFGlwhBIC6vYs6D30k/
   jB/RjW7uZM5Z6AOdw4Q61PkDIgQN0ovfO4AxXC9PjNYTW5aGri1jG4keh
   RHpw2AwgcRsi9mtPYQ4t0mAjJgJ010f0Uvk5gqPdmgN1wITgORwlQPlse
   hrMxHAuy6ZhN/prfICve5DRuWKqiOpGQDLdAN6OBlq63lwt5oIhe9cBey
   0z/WmixXmLbASdwLxgLtuJZ++SaF8pgI0AoeZPogEGMRX8DevjndmLGQB
   RtEFxM9cyc0E3P6h5dVbqIlo40VuSUcmE2QGORhJ4g8RVVyuxdVRlk0r+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="281870121"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="281870121"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:01 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10485"; a="726807689"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="726807689"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 03:19:01 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v9 057/105] KVM: Add functions to set GFN to private or shared
Date:   Fri, 30 Sep 2022 03:17:51 -0700
Message-Id: <60ecd050492a8dc393e7e2be3a2e8ad8b7856f99.1664530908.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1664530907.git.isaku.yamahata@intel.com>
References: <cover.1664530907.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX KVM support needs to track whether GFN is private or shared.  Introduce
functions to set whether GFN is private or shared and pre-allocate memory
for xarray.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/Kconfig     |  2 +-
 include/linux/kvm_host.h | 17 +++++++++++-
 virt/kvm/kvm_main.c      | 56 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 350a921b15cb..e968ecab4d0a 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -49,7 +49,7 @@ config KVM
 	select SRCU
 	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
-	select HAVE_KVM_PRIVATE_MEM if X86_64
+	select HAVE_KVM_PRIVATE_MEM if KVM_MMU_PRIVATE
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index eca3ca116412..5e11ccbc23af 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2294,9 +2294,20 @@ static inline void kvm_handle_signal_exit(struct kvm_vcpu *vcpu)
 #define KVM_MEM_ATTR_PRIVATE	0x0002
 
 #ifdef __KVM_HAVE_ARCH_UPDATE_MEM_ATTR
+/* memory attr on [start, end) */
+int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end);
+int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end);
 void kvm_arch_update_mem_attr(struct kvm *kvm, unsigned int attr,
 			      gfn_t start, gfn_t end);
 #else
+static inline int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	return -EOPNOTSUPP;
+}
+static inline int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end)
+{
+	return -EOPNOTSUPP;
+}
 static inline void kvm_arch_update_mem_attr(struct kvm *kvm, unsigned int attr,
 					    gfn_t start, gfn_t end)
 {
@@ -2326,7 +2337,11 @@ static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
 {
 	return !xa_load(&kvm->mem_attr_array, gfn);
 }
-
+#else
+static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
+{
+	return false;
+}
 #endif /* CONFIG_HAVE_KVM_PRIVATE_MEM */
 
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 0dbd1734a246..20c46f26691d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1019,6 +1019,62 @@ static inline void kvm_private_mem_unregister(struct kvm_memory_slot *slot)
 	inaccessible_unregister_notifier(slot->private_file, &slot->notifier);
 }
 
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
+	gfn_t gfn;
+	int r;
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
+	WARN_ON_ONCE(start >= end);
+	for (gfn = start; gfn < end; gfn++) {
+		r = xa_err(xa_store(&kvm->mem_attr_array, gfn, entry,
+				    GFP_KERNEL_ACCOUNT));
+		if (r)
+			break;
+	}
+	if (start < gfn)
+		kvm_arch_update_mem_attr(kvm, attr, start, gfn);
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_set_mem_attr);
+
 #else /* !CONFIG_HAVE_KVM_PRIVATE_MEM */
 
 static inline void kvm_private_mem_register(struct kvm_memory_slot *slot)
-- 
2.25.1

