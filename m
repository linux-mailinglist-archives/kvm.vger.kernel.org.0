Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1650C79E537
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 12:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233278AbjIMKtU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 06:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239730AbjIMKtQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 06:49:16 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 436491726;
        Wed, 13 Sep 2023 03:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694602152; x=1726138152;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GkBig6IwfAcfP2Qu/zXThXAnAkU33oLrNZahoClMAyU=;
  b=JSvUjgeRlXUPi9D8eYylh5/oBfAem5hmVE0l493FCApHLpgNBjwdDB+z
   Or3BzyABRBaACARZ/EkdG9c2YYUTSA5RHgY9ZAkF5cjnh62Sa/2BaS+vb
   HvKP4rphra3vSMfgnfQgoMndaAw6QK4qnpaNiQpVYCKSSuL/VWDlWCB6g
   WRQ+FEkHTm1e/tB7b76EmkzHVAvyi41x2BnXo0dBNO+V+YTA0L/xiFj/Y
   kHarpa2Fe+pilSsJT9/0jyxtj6EDSsAHmfeEc++/zXWOlc5OMQHd/o5Ey
   Hc36T65zJuXm6lbgeoswH1ABnVKSkSyEosb4dkzoZzx0ACgbIsteJn3pR
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="377537881"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="377537881"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 03:49:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10831"; a="809635588"
X-IronPort-AV: E=Sophos;i="6.02,143,1688454000"; 
   d="scan'208";a="809635588"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 03:49:11 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Subject: [RFC PATCH 3/6] KVM: guest_memfd, x86: MEMORY_FAULT exit with hw poisoned page
Date:   Wed, 13 Sep 2023 03:48:52 -0700
Message-Id: <36f6fae6cd7aaba3b0fc18f10981bbba2c30b979.1694599703.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1694599703.git.isaku.yamahata@intel.com>
References: <cover.1694599703.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

When resolving kvm page fault and hwpoisoned page is given, KVM exit
with HWPOISONED flag so that user space VMM, e.g. qemu, handle it.

- Add a new flag POISON to KVM_EXIT_MEMORY_FAULT to indicate the page is
  poisoned.
- Make kvm_gmem_get_pfn() return hwpoison state by -EHWPOISON when the
  folio is hw-poisoned.
- When page is hw-poisoned on faulting in private gmem, return
  KVM_EXIT_MEMORY_FAULT with HWPOISONED flag.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/mmu.c   | 21 +++++++++++++++------
 include/uapi/linux/kvm.h |  3 ++-
 virt/kvm/guest_mem.c     |  4 +++-
 3 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 05943ccb55a4..5dc9d1fdadca 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4335,19 +4335,24 @@ static inline u8 kvm_max_level_for_order(int order)
 	return PG_LEVEL_4K;
 }
 
-static int kvm_do_memory_fault_exit(struct kvm_vcpu *vcpu,
-				    struct kvm_page_fault *fault)
+static int __kvm_do_memory_fault_exit(struct kvm_vcpu *vcpu,
+				      struct kvm_page_fault *fault, __u64 flags)
 {
 	vcpu->run->exit_reason = KVM_EXIT_MEMORY_FAULT;
 	if (fault->is_private)
-		vcpu->run->memory.flags = KVM_MEMORY_EXIT_FLAG_PRIVATE;
-	else
-		vcpu->run->memory.flags = 0;
+		flags |= KVM_MEMORY_EXIT_FLAG_PRIVATE;
+	vcpu->run->flags = flags;
 	vcpu->run->memory.gpa = fault->gfn << PAGE_SHIFT;
 	vcpu->run->memory.size = PAGE_SIZE;
 	return RET_PF_USER;
 }
 
+static int kvm_do_memory_fault_exit(struct kvm_vcpu *vcpu,
+				    struct kvm_page_fault *fault)
+{
+	return __kvm_do_memory_fault_exit(vcpu, fault, 0);
+}
+
 static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 				   struct kvm_page_fault *fault)
 {
@@ -4358,12 +4363,16 @@ static int kvm_faultin_pfn_private(struct kvm_vcpu *vcpu,
 
 	r = kvm_gmem_get_pfn(vcpu->kvm, fault->slot, fault->gfn, &fault->pfn,
 			     &max_order);
-	if (r)
+	if (r && r != -EHWPOISON)
 		return r;
 
 	fault->max_level = min(kvm_max_level_for_order(max_order),
 			       fault->max_level);
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
+
+	if (r == -EHWPOISON)
+		return __kvm_do_memory_fault_exit(vcpu, fault,
+						  KVM_MEMORY_EXIT_FLAG_HWPOISON);
 	return RET_PF_CONTINUE;
 }
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index eb900344a054..48329cb44415 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -527,7 +527,8 @@ struct kvm_run {
 		} notify;
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
-#define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+#define KVM_MEMORY_EXIT_FLAG_PRIVATE	BIT_ULL(3)
+#define KVM_MEMORY_EXIT_FLAG_HWPOISON	BIT_ULL(4)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index 746e683df589..3678287d7c9d 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -589,6 +589,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 {
 	pgoff_t index = gfn - slot->base_gfn + slot->gmem.pgoff;
 	struct kvm_gmem *gmem;
+	bool hwpoison = false;
 	struct folio *folio;
 	struct page *page;
 	struct file *file;
@@ -610,6 +611,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		return -ENOMEM;
 	}
 
+	hwpoison = folio_test_hwpoison(folio);
 	page = folio_file_page(folio, index);
 
 	*pfn = page_to_pfn(page);
@@ -618,7 +620,7 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	folio_unlock(folio);
 	fput(file);
 
-	return 0;
+	return hwpoison ? -EHWPOISON : 0;
 }
 EXPORT_SYMBOL_GPL(kvm_gmem_get_pfn);
 
-- 
2.25.1

