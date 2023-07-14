Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB0B7532F0
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbjGNHSZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:18:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234484AbjGNHSY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:18:24 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA622722;
        Fri, 14 Jul 2023 00:18:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319104; x=1720855104;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=nOdi2KVC4OwTsVt3a1I9Bdhj8qUZvzNWXLp63uGaNfw=;
  b=U1raypuwcmokLsKtOEHtQPxn2QVjLS/EdsRal2C3weCpEe1h7bdyLci9
   tvhElaVvLZ6xp+yOk3IRCUdIz6nzacF8MlzRg2PfQDaC0j4pquv2/IeWz
   +sOoeIbGP3XrInwv/4tqAEuke+jDDwVWAsTv7RQoUrDM1dqgdXm9ntXYB
   ul73TKny2q+bOG8ZRQ3CgRz8WzuHhiIN8N2ri2ocNDoXWAkTRgA89NeTJ
   U2HkH8v5ef9afjpm6NXq9VflEQ+BVeN06Fd+OZdokjuhYbaCQurVKg3VA
   hR4+coXpWO2/f/VoLXcsISAnAX4ZksWtjiuGkGgz7MBh2zt/En/IyIzGV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="396221903"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="396221903"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:17:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="751940812"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="751940812"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:17:16 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 02/12] KVM: x86/mmu: Use KVM honors guest MTRRs helper in kvm_tdp_page_fault()
Date:   Fri, 14 Jul 2023 14:50:43 +0800
Message-Id: <20230714065043.20258-1-yan.y.zhao@intel.com>
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

Let kvm_tdp_page_fault() use helper function kvm_mmu_honors_guest_mtrrs()
to decide if it needs to consult guest MTRR to check GFN range consistency.

No functional change intended.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b4f89f015c37..7f52bbe013b3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4536,16 +4536,9 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	/*
 	 * If the guest's MTRRs may be used to compute the "real" memtype,
 	 * restrict the mapping level to ensure KVM uses a consistent memtype
-	 * across the entire mapping.  If the host MTRRs are ignored by TDP
-	 * (shadow_memtype_mask is non-zero), and the VM has non-coherent DMA
-	 * (DMA doesn't snoop CPU caches), KVM's ABI is to honor the memtype
-	 * from the guest's MTRRs so that guest accesses to memory that is
-	 * DMA'd aren't cached against the guest's wishes.
-	 *
-	 * Note, KVM may still ultimately ignore guest MTRRs for certain PFNs,
-	 * e.g. KVM will force UC memtype for host MMIO.
+	 * across the entire mapping.
 	 */
-	if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
+	if (kvm_mmu_honors_guest_mtrrs(vcpu->kvm)) {
 		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
 			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
 			gfn_t base = gfn_round_for_level(fault->gfn,
-- 
2.17.1

