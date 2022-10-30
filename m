Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBE04612818
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiJ3G1V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiJ3GZZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:25:25 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27596222;
        Sat, 29 Oct 2022 23:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111055; x=1698647055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RM3+eWq8eAgKigI5ubM3QJ4p1TJTvjO5HFLkxD5vwu4=;
  b=KfMvq5nYj8PjsTedF3CtxHrYNoTr/THR66KqkINxZcv9zKov3Mj+0wkA
   4U3ApEwwEmgb74Mrod7A/LcER0PKAs6doCShzHj5VUldNrdpQ8FT284q8
   +8DF9QZYpnR1g3iPRmEiRmDlnGhtrIGdOUWQCs+gfpLEgXCh02xuGcwuH
   mLGR2zrtV6yucHychY7B8TEoMAlq2eH7tWAA9oymxB+k41pzy+tXvrmRl
   1YP4o5NhVMwE5giOo6n9/o9a35u4z9XqCQ9Y4siu3fCIqRKXU7ZiEQr3r
   8PaksTDTq/CyJ6PzzB759ka2tMUuEuUUg9ftUjR9diHsDLkQX5sakjbMo
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037173"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037173"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:07 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393039"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393039"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:07 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 060/108] KVM: Add functions to set GFN to private or shared
Date:   Sat, 29 Oct 2022 23:23:01 -0700
Message-Id: <c834432220f04c39a8dfa6ac3838446e6c06c9e9.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
 include/linux/kvm_host.h | 11 ++++++
 virt/kvm/kvm_main.c      | 74 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 85 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index a0b64308d240..fac07886ab39 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2307,9 +2307,20 @@ static inline void kvm_account_pgtable_pages(void *virt, int nr)
 #define KVM_MEM_ATTR_PRIVATE	0x0002
 
 #ifdef __KVM_HAVE_ARCH_UPDATE_MEM_ATTR
+/* memory attr on [start, end) */
+int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end);
+int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end);
 void kvm_arch_update_mem_attr(struct kvm *kvm, struct kvm_memory_slot *slot,
 			      unsigned int attr, gfn_t start, gfn_t end);
 #else
+static inline int kvm_vm_reserve_mem_attr(struct kvm *kvm, gfn_t start, gfn_t end)
+{
+	return -EOPNOTSUPP;
+}
+static inline int kvm_vm_set_mem_attr(struct kvm *kvm, int attr, gfn_t start, gfn_t end)
+{
+	return -EOPNOTSUPP;
+}
 static inline void kvm_arch_update_mem_attr(struct kvm *kvm,
 					    struct kvm_memory_slot *slot,
 					    unsigned int attr,
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 9f82b03a8118..f0e77b65939b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1121,6 +1121,80 @@ static inline void kvm_restrictedmem_unregister(struct kvm_memory_slot *slot)
 					  &slot->notifier);
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
+	int i;
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
+	if (start >= gfn)
+		return r;
+
+	end = gfn;
+	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
+		struct kvm_memslot_iter iter;
+		struct kvm_memory_slot *slot;
+		struct kvm_memslots *slots;
+
+		slots = __kvm_memslots(kvm, i);
+		kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
+			gfn_t s = max(start, slot->base_gfn);
+			gfn_t e = min(end, slot->base_gfn + slot->npages);
+
+			WARN_ON_ONCE(s >= e);
+			kvm_arch_update_mem_attr(kvm, slot, attr, s, e);
+		}
+	}
+
+	return r;
+}
+EXPORT_SYMBOL_GPL(kvm_vm_set_mem_attr);
+
 #else /* !CONFIG_HAVE_KVM_RESTRICTED_MEM */
 
 static inline void kvm_restrictedmem_register(struct kvm_memory_slot *slot)
-- 
2.25.1

