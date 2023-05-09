Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D03296FC8BB
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 16:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbjEIOUM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 10:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbjEIOUK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 10:20:10 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E9430F7;
        Tue,  9 May 2023 07:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683642008; x=1715178008;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=9k7MFPNbtv2QzGAeGYaRb/Sks6eG/baaVVfpJ4EEOVA=;
  b=TAwZ28ZpljasI4j5n1yrYBvKHgIno+0z4VU/hZXSFat3g0CQztoeNLKl
   K7qM1y5QTnIHXi+RLX9rRbKEWCbbr+SpuaqerOm9CpgTskInSMZsyzVi6
   OZ1CG5dpMmPT7fNqSX+ZH8pUBAbrLSXl+PdzVVZO2/ja+Oug7ZgEycyrE
   7wuk9+xlR5z7FqLmYSAxPQJYe5rs/xuAy86pQRmG30eFuvhFnJKNbWouu
   CBwecy9qdq/JgD3ICDVGpPDHcAWIXFf3+RR+bSgCIimFyHI0Mv63CdHE5
   fJaIrL22+Ta/tfDobrtwf5AaaU4s4HfXluSecLq5IFpbDaUX26FS2/eZO
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="329561785"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="329561785"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:17:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10705"; a="823114077"
X-IronPort-AV: E=Sophos;i="5.99,262,1677571200"; 
   d="scan'208";a="823114077"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2023 07:17:24 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v2 4/6] KVM: x86/mmu: Zap all EPT leaf entries according noncoherent DMA count
Date:   Tue,  9 May 2023 21:52:26 +0800
Message-Id: <20230509135226.1780-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230509134825.1523-1-yan.y.zhao@intel.com>
References: <20230509134825.1523-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Zap all EPT leaf entries when noncoherent DMA count goes from 0 to 1, or
from 1 to 0.

When there's no noncoherent DMA device, EPT memory type is
((MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT)

When there're noncoherent DMA devices, EPT memory type needs to honor
guest CR0_CD and MTRR settings.

So, if noncoherent DMA count changes between 0 and 1, EPT leaf entries
need to be zapped to clear stale memory type.

This issue might be hidden when the device is statically assigned with
VFIO adding/removing MMIO regions of the noncoherent DMA devices for
several times during guest boot, and current KVM MMU will call
kvm_mmu_zap_all_fast() on the memslot removal.

But if the device is hot-plugged, or if the guest has mmio_always_on for
the device, the MMIO regions of it may only be added for once, then there's
no path to do the EPT entries zapping to clear stale memory type.

Therefore do the EPT zapping of all leaf entries when present/non-present
state of noncoherent DMA devices changes to ensure stale entries cleaned
away.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/x86.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ed1e3939bd05..48b683a305b3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13145,13 +13145,15 @@ EXPORT_SYMBOL_GPL(kvm_arch_has_assigned_device);
 
 void kvm_arch_register_noncoherent_dma(struct kvm *kvm)
 {
-	atomic_inc(&kvm->arch.noncoherent_dma_count);
+	if (atomic_inc_return(&kvm->arch.noncoherent_dma_count) == 1)
+		kvm_zap_gfn_for_memtype(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
 }
 EXPORT_SYMBOL_GPL(kvm_arch_register_noncoherent_dma);
 
 void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm)
 {
-	atomic_dec(&kvm->arch.noncoherent_dma_count);
+	if (!atomic_dec_return(&kvm->arch.noncoherent_dma_count))
+		kvm_zap_gfn_for_memtype(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
 }
 EXPORT_SYMBOL_GPL(kvm_arch_unregister_noncoherent_dma);
 
-- 
2.17.1

