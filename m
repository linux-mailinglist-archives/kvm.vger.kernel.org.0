Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1B475BB38
	for <lists+kvm@lfdr.de>; Fri, 21 Jul 2023 01:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbjGTXdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 19:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjGTXdP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 19:33:15 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8B12727;
        Thu, 20 Jul 2023 16:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689895994; x=1721431994;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rvpwGTo756PNEl2wWmMC9MHOKfm+GNxe+wwXhyK+d9U=;
  b=S0JZ1TabYQeEafQWRORBX639g3kz84njEPF4qo9f/w8SBpSFdIe12Anq
   X0jxde/oncS/Ajp+piq/119+l3v3uJwOtfmZzaHpJ46xb8rnLoqBUy51U
   e7nW5kJCqvdtYrTUJcuHsT61o+KuZo9CeiSIDD4FE1tX7emZebExxTvcL
   Q2W6A+KqYWZfxMkO496pehB0ygpeze84vuh8a2bwIx1OTP2kGFWXYLt7g
   N5myOEfqDFoKXiOfByOOcmCl8rtcNs4+kbqZ+orzVtE2KF8Q62IrkETij
   G9WHwGR9bhcRpF6rKSJB60vZTuy3QKwvk+SgCZUFhZxMIphk5GoHS4LRm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="364355935"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="364355935"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10777"; a="727891793"
X-IronPort-AV: E=Sophos;i="6.01,220,1684825200"; 
   d="scan'208";a="727891793"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2023 16:33:11 -0700
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
        Yuan Yao <yuan.yao@linux.intel.com>
Subject: [RFC PATCH v4 05/10] KVM: Add new members to struct kvm_gfn_range to operate on
Date:   Thu, 20 Jul 2023 16:32:51 -0700
Message-Id: <e88a03977db376745a37d246d8c58b9493186dd8.1689893403.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1689893403.git.isaku.yamahata@intel.com>
References: <cover.1689893403.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX needs to know which mapping to operate on.  Shared-EPT vs. Secure-EPT.
The following sequence to convert the GPA to private doesn't work for TDX
because the page can already be private.

1) Update memory attributes to private in memory attributes xarray
2) Zap the GPA range irrespective of private-or-shared.
   Even if the page is already private, zap the entry.
3) EPT violation on the GPA
4) Populate the GPA as private
   The page is zeroed, and the guest has to accept the page again.

In step 2, TDX wants to zap only shared pages and skip private ones.

Add new members to strut kvm_gfn_range to indicate which mapping
(private-vs-shared) to operate on.  only_private and only_shared.  Update
mmu notifier, set memory attributes ioctl or KVM gmem callback to
initialize them.

- If operating on a file to back shared pages, zap shared pages only.
  It's the mmu notifier.
  (only_private, only_shared) = (false, true)

- If operating a file to back private pages, zap private pages only.
  It's the KVM gmem.
  (only_private, only_shared) = (true, false)

- If setting memory attributes, vendor callback checks new attributes
  and make decisions.
  SNP would do nothing and handle it later with gmem callback
  TDX callback would do as follows.
  When it converts pages to shared, zap private pages only.
  When it converts pages to private, zap shared pages only.
  (only_private, only_shared) = (false, false)

- If operating on both backing files, zap both private and shared pages.
  This is when destructing guest.
  (only_private, only_shared) = (true, true)

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
Changes v3 -> v4:
- rebased v11 kvm gmem.

Changes v2 -> v3:
- Drop the KVM_GFN_RANGE flags
- Updated struct kvm_gfn_range
- Change kvm_arch_set_memory_attributes() to return bool for flush
- Added set_memory_attributes x86 op for vendor backends
- Refined commit message to describe TDX care concretely

Changes v1 -> v2:
- consolidate KVM_GFN_RANGE_FLAGS_GMEM_{PUNCH_HOLE, RELEASE} into
  KVM_GFN_RANGE_FLAGS_GMEM.
- Update the commit message to describe TDX more.  Drop SEV_SNP.
---
 include/linux/kvm_host.h | 2 ++
 virt/kvm/guest_mem.c     | 2 ++
 virt/kvm/kvm_main.c      | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 091bc89ae805..ce4d91585368 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -268,6 +268,8 @@ struct kvm_gfn_range {
 		u64 raw;
 	} arg;
 	bool may_block;
+	bool only_private;
+	bool only_shared;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
index 384671a55b41..ac185c776cda 100644
--- a/virt/kvm/guest_mem.c
+++ b/virt/kvm/guest_mem.c
@@ -105,6 +105,8 @@ static void kvm_gmem_invalidate_begin(struct kvm_gmem *gmem, pgoff_t start,
 			.end = slot->base_gfn + min(pgoff + slot->npages, end) - pgoff,
 			.slot = slot,
 			.may_block = true,
+			.only_private = true,
+			.only_shared = false,
 		};
 
 		flush |= kvm_mmu_unmap_gfn_range(kvm, &gfn_range);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ee331cf8ba54..4e2a2463ab19 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -603,6 +603,8 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 			 */
 			gfn_range.arg.raw = range->arg.raw;
 			gfn_range.may_block = range->may_block;
+			gfn_range.only_private = false;
+			gfn_range.only_shared = true;
 
 			/*
 			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
@@ -2405,6 +2407,8 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 
 	gfn_range.arg.raw = range->arg.raw;
 	gfn_range.may_block = range->may_block;
+	gfn_range.only_private = false;
+	gfn_range.only_shared = false;
 
 	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
 		slots = __kvm_memslots(kvm, i);
-- 
2.25.1

