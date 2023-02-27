Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F466A3CB3
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbjB0I0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjB0IZ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:25:59 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F601CF45;
        Mon, 27 Feb 2023 00:24:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486268; x=1709022268;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8S92uRGEDTJGnSHCFrEvDnFy25uhgD3zt+1Ujpc9p0Q=;
  b=OEi709ICY85xc26WC5b9NDGfpV4HQlAQaaO2mvqiWgNgxJzlBQMfKWKR
   HBzzfK2tcJkaXuvyVjVD24YI7Gih7NMolnGMNklXeDrrZQuGUA2J7YCBf
   Oe3gvO/9Ol7M0TPL4ZyTIti2OazpVeEdQTEMlyed004rMWpnYR1NeHr7k
   Cq+2GYtT85FRtcUNufs0TCDXnzx6JirYVnSmxZ3wFj2m/85fhC7uzbBXV
   ltFVwk1ILf8oQh9MIm6X/WgiudPBNE65AsOSy5qN+Q0YiLaEeoZD1a37s
   ygNlV5fO1oOsPWTD5dXGmx1DRUDBDlVEqk16GwGmjklh/ejvatkck5/8I
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608841"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608841"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:10 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242195"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242195"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:08 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v12 042/106] KVM: x86/mmu: Disallow dirty logging for x86 TDX
Date:   Mon, 27 Feb 2023 00:22:41 -0800
Message-Id: <40b8dbc590de6b75a0778d3fd3d5781848a642ef.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX doesn't support dirty logging.  Report dirty logging isn't supported so
that device model, for example qemu, can properly handle it.  Silently
ignore on dirty logging on private GFNs of TDX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c     |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c | 36 +++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c         |  8 ++++++++
 include/linux/kvm_host.h   |  1 +
 virt/kvm/kvm_main.c        | 10 +++++++++-
 5 files changed, 56 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 621ac8ea54d6..6421f92e618e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6690,6 +6690,9 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
 		sp = sptep_to_sp(sptep);
 
+		/* Private page dirty logging is not supported yet. */
+		KVM_BUG_ON(is_private_sptep(sptep), kvm);
+
 		/*
 		 * We cannot do huge page mapping for indirect shadow pages,
 		 * which are found on the last rmap (level = 1) when not using
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 106e858ee39a..573f38e472f3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1476,9 +1476,27 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
 	 * into this helper allow blocking; it'd be dead, wasteful code.
 	 */
 	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
+		gfn_t start;
+		gfn_t end;
+
+		/*
+		 * For now, operation on private GPA, e.g. dirty page logging,
+		 * isn't supported yet.
+		 */
+		if (is_private_sp(root))
+			continue;
+
 		rcu_read_lock();
 
-		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
+		/*
+		 * For TDX shared mapping, set GFN shared bit to the range,
+		 * so the handler() doesn't need to set it, to avoid duplicated
+		 * code in multiple handler()s.
+		 */
+		start = kvm_gfn_shared(kvm, range->start);
+		end = kvm_gfn_shared(kvm, range->end);
+
+		tdp_root_for_each_leaf_pte(iter, root, start, end)
 			ret |= handler(kvm, &iter, range);
 
 		rcu_read_unlock();
@@ -1961,6 +1979,13 @@ void kvm_tdp_mmu_clear_dirty_pt_masked(struct kvm *kvm,
 	struct kvm_mmu_page *root;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
+	/*
+	 * First TDX generation doesn't support clearing dirty bit,
+	 * since there's no secure EPT API to support it.  For now silently
+	 * ignore KVM_CLEAR_DIRTY_LOG.
+	 */
+	if (!kvm_arch_dirty_log_supported(kvm))
+		return;
 	for_each_tdp_mmu_root(kvm, root, slot->as_id)
 		clear_dirty_pt_masked(kvm, root, gfn, mask, wrprot);
 }
@@ -2080,6 +2105,15 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 	bool spte_set = false;
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	/*
+	 * First TDX generation doesn't support write protecting private
+	 * mappings, silently ignore the request.  KVM_GET_DIRTY_LOG etc
+	 * can reach here, no warning.
+	 */
+	if (!kvm_arch_dirty_log_supported(kvm))
+		return false;
+
 	for_each_tdp_mmu_root(kvm, root, slot->as_id)
 		spte_set |= write_protect_gfn(kvm, root, gfn, min_level);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b5b51342c9a9..89ee421e0cbf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12549,6 +12549,9 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	u32 new_flags = new ? new->flags : 0;
 	bool log_dirty_pages = new_flags & KVM_MEM_LOG_DIRTY_PAGES;
 
+	if (!kvm_arch_dirty_log_supported(kvm) && log_dirty_pages)
+		return;
+
 	/*
 	 * Update CPU dirty logging if dirty logging is being toggled.  This
 	 * applies to all operations.
@@ -13521,6 +13524,11 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+bool kvm_arch_dirty_log_supported(struct kvm *kvm)
+{
+	return kvm->arch.vm_type != KVM_X86_PROTECTED_VM;
+}
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 5e4bf78025e3..04debfe30572 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1495,6 +1495,7 @@ bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 int kvm_arch_create_vm_debugfs(struct kvm *kvm);
+bool kvm_arch_dirty_log_supported(struct kvm *kvm);
 
 #ifndef __KVM_HAVE_ARCH_VM_ALLOC
 /*
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 42f01d0d6a49..e9f8225f3406 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1700,10 +1700,18 @@ static void kvm_replace_memslot(struct kvm *kvm,
 	}
 }
 
+bool __weak kvm_arch_dirty_log_supported(struct kvm *kvm)
+{
+	return true;
+}
+
 static int check_memory_region_flags(struct kvm *kvm,
 				     const struct kvm_userspace_memory_region2 *mem)
 {
-	u32 valid_flags = KVM_MEM_LOG_DIRTY_PAGES;
+	u32 valid_flags = 0;
+
+	if (kvm_arch_dirty_log_supported(kvm))
+		valid_flags |= KVM_MEM_LOG_DIRTY_PAGES;
 
 	if (kvm_arch_has_private_mem(kvm))
 		valid_flags |= KVM_MEM_PRIVATE;
-- 
2.25.1

