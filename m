Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF007532FB
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbjGNHT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235403AbjGNHTQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:19:16 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9345B3C01;
        Fri, 14 Jul 2023 00:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319140; x=1720855140;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=mQjyugDM9ae/+xsV/na3qkdiKTAXgzQ9oL683PGryPA=;
  b=agEYkOCX/ojDMWCLjs+RukhYKku+B/Z4+erbNDbf5ilm1si4H9+5iDij
   +Y1/DEN27kSmOG8V/6+Y6/dfgWXSkCGt2JKb5DIWT2Da/MEZgPtbEmoOR
   T+0enAG2KN3SIkrYrdoIZocWW5zfbaSoVBoucnj/+MSNmytIrk8MazQnD
   JAj1+QZFNdfc6pu7439ZLNe1dMD+SuJZuLdUa7OlvpKv9PYCMZ3fWD10B
   lxT6tt/YGk5giYb/4ZEQ795WleUiOXZjYvkneavw7H1bW91ctVCfzLoNR
   8j2cFBOFIYzMryY22NxThVhlKgOLf6M5dBXmh6fkoIr8Dey3TWYAt1d2Z
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="355349578"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="355349578"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:19:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="757477345"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="757477345"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:18:57 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 05/12] KVM: x86/mmu: zap KVM TDP when noncoherent DMA assignment starts/stops
Date:   Fri, 14 Jul 2023 14:52:23 +0800
Message-Id: <20230714065223.20432-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230714064656.20147-1-yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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

