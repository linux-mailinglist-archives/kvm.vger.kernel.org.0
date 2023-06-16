Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A95573258E
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 05:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239202AbjFPDCu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 23:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241505AbjFPDCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 23:02:34 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF672D4C;
        Thu, 15 Jun 2023 20:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884541; x=1718420541;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=mQjyugDM9ae/+xsV/na3qkdiKTAXgzQ9oL683PGryPA=;
  b=UXVqXD2tI9XLBeR26o/oTh7rmsvzXwV9xse9p+8HHkFxLjpkwzspqw1l
   NcCPL5TuDRh8OA9Td07yzA0FHlg/VRAxis1E0Ke8dvjyXyP8yby+u2T0W
   8xZovVbcitfFju+5ltpmHyEHo/JTC9ndpALc1wGghyDyIxHEMsJsTGQcR
   oJ4bWyVZU26Jjtk5rDz5mv7jlgJVTN7QPJpjtThTrt5mZeblDMgTdOdtI
   G6pIKavuEUNhlKcfzwFQzv3/5IH1+hNzdRFUJUyjmMmoBPjbar5JdsKBO
   oe9d0kJZLJDxCQd7Le/s42oRCqdreMQ+askczP8yXxOu4zPeyyH8ywhD/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="348809867"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="348809867"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:02:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="857213767"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="857213767"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:02:18 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 05/11] KVM: x86/mmu: zap KVM TDP when noncoherent DMA assignment starts/stops
Date:   Fri, 16 Jun 2023 10:37:09 +0800
Message-Id: <20230616023709.7318-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230616023101.7019-1-yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zap KVM TDP when noncoherent DMA assignment starts (noncoherent dma count
transitions from 0 to 1) or stops (noncoherent dma count transistions
from 1 to 0). Before the zap, test if guest MTRR is to be honored after
the assignment starts or was honored before the assignment stops.

When there's no noncoherent DMA device, EPT memory type is
((MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT)

When there're noncoherent DMA devices, EPT memory type needs to honor
guest CR0.CD and MTRR settings.

So, if noncoherent DMA count transitions between 0 and 1, EPT leaf entries
need to be zapped to clear stale memory type.

This issue might be hidden when the device is statically assigned with
VFIO adding/removing MMIO regions of the noncoherent DMA devices for
several times during guest boot, and current KVM MMU will call
kvm_mmu_zap_all_fast() on the memslot removal.

But if the device is hot-plugged, or if the guest has mmio_always_on for
the device, the MMIO regions of it may only be added for once, then there's
no path to do the EPT entries zapping to clear stale memory type.

Therefore do the EPT zapping when noncoherent assignment starts/stops to
ensure stale entries cleaned away.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/x86.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6693daeb5686..ac9548efa76f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13164,15 +13164,31 @@ bool noinstr kvm_arch_has_assigned_device(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
 
+static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
+{
+	/*
+	 * Non-coherent DMA assignement and de-assignment will affect
+	 * whether KVM honors guest MTRRs and cause changes in memtypes
+	 * in TDP.
+	 * So, specify the second parameter as true here to indicate
+	 * non-coherent DMAs are/were involved and TDP zap might be
+	 * necessary.
+	 */
+	if (__kvm_mmu_honors_guest_mtrrs(kvm, true))
+		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
+}
+
 void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
 {
-	atomic_inc(&kvm->arch.noncoherent_dma_count);
+	if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1)
+		kvm_noncoherent_dma_assignment_start_or_stop(kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);
 
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
 {
-	atomic_dec(&kvm->arch.noncoherent_dma_count);
+	if (!atomic_dec_return(&kvm->arch.noncoherent_dma_count))
+		kvm_noncoherent_dma_assignment_start_or_stop(kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);
 
-- 
2.17.1

