Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE2FD6F9E9A
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 06:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232470AbjEHEMN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 00:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232217AbjEHEMK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 00:12:10 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFB94227;
        Sun,  7 May 2023 21:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683519129; x=1715055129;
  h=from:to:cc:subject:date:message-id;
  bh=zT05ulhlCsDMX6ubQhxzo5A+qEruyiIbSgQaS9PNcCc=;
  b=ClcI07Tej/VhD/Cjcn6HM1aBxmRSnkj1+r4NrEzPf8XKel5yoRTEQ3W9
   T/NiGUuZL4i5QDAt7O80rfoVSX+zJv0Txa3fYPz60XayIfUoN8sLgZ/hw
   ukW/mFvU4tqKcOsXUNCvuAbaN1waS4jGvqPNsO7uKX4+eGZup8xGF4s3O
   UdEbM35Ugu7Y2VJocSsxWdOCLJLbluElXk3mkwnc4zvInGIRst4XYCaz+
   WvtwC/dz3ppfSHjUNWplXHuBvvLAH2nvlEq63vDB2dpaFmSHud07z8tHC
   7lKboIzkZrmxVGSEPTdKVBtQtMIsXjfZU4CfzZ40A8UP8RQ22+tLWCI7V
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="415110258"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="415110258"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2023 21:12:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="731146970"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="731146970"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2023 21:12:04 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] KVM: x86: Zap all TDP leaf entries according noncoherent DMA count
Date:   Mon,  8 May 2023 11:47:00 +0800
Message-Id: <20230508034700.7686-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zap all TDP leaf entries when noncoherent DMA count goes from 0 to !0, or
from !0 to 0.

When there's no noncoherent DMA device, EPT memory type is
((MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT)

When there're noncoherent DMA devices, EPT memory type needs to honor
guest CR0_CD and MTRR settings.

So, if noncoherent DMA count changes between 0 and !0, EPT leaf entries
need to be zapped to clear stale memory type.

This issue might be hidden when VFIO adding/removing MMIO regions of the
noncoherent DMA devices on device attaching/de-attaching because
usually the MMIO regions will be disabled/enabled for several times during
guest PCI probing. And in KVM, TDP entries are all zapped on memslot
removal.

However, this issue may appear when kvm_mmu_zap_all_fast() is not called
before KVM slot removal, e.g. as for TDX, only leaf entries for the
memslot to be removed is zapped.

static void kvm_mmu_invalidate_zap_pages_in_memslot(struct kvm *kvm,
                        struct kvm_memory_slot *slot,
                        struct kvm_page_track_notifier_node *node)
{
        if (kvm_gfn_shared_mask(kvm))
                /*
                 * Secure-EPT requires to release PTs from the leaf.  The
                 * optimization to zap root PT first with child PT doesn't
                 * work.
                 */
                kvm_mmu_zap_memslot(kvm, slot);
        else
                kvm_mmu_zap_all_fast(kvm);
}

And even without TDX's case, in some extreme conditions if MMIO regions
are not disabled during device attaching, e.g. if guest does not cause
the MMIO region disabling in QEMU.
Then TDP zap will not be called and wrong EPT memory type might be
retained.

So, do the TDP zapping of all leaf entries when present/non-present state
of noncoherent DMA devices changes to ensure stale entries cleaned away.
And as this is not a frequent operation, the extra zap should be fine.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/x86.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e7f78fe79b32..99a825722d95 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13145,13 +13145,15 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
 
 void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
 {
-	atomic_inc(&kvm->arch.noncoherent_dma_count);
+	if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1)
+		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
 }
 EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);
 
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
 {
-	atomic_dec(&kvm->arch.noncoherent_dma_count);
+	if (!atomic_dec_return(&kvm->arch.noncoherent_dma_count))
+		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
 }
 EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);
 
-- 
2.17.1

