Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2282732582
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 05:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241248AbjFPDAO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 23:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjFPC7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 22:59:48 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D16D2953;
        Thu, 15 Jun 2023 19:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884388; x=1718420388;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=nOdi2KVC4OwTsVt3a1I9Bdhj8qUZvzNWXLp63uGaNfw=;
  b=D7u16eJR0Pi7k+mPyq5IjSsihPjvex7ZG8JibahMQZsI7pzJpXeSpko3
   bGUFtVdrUYhD6TkeFQS+wcVhJN/UAXwQGC5bIyX9gzI2vCKKgUXRkEoZa
   F9Ftez1U2h+wXRXLnvNZgL+V0ZZlv6hO+8IhpKuJqOu/0HVhbx62ummYL
   Hv0/s+HMSmfZ8e2LDvN6ggz77t+0TFzocepskCq0RC3efyHBtdk2yMlea
   1zepPptz0WJwnVb62AIVvuN56hxejbhR6PM7ZVg0jOdS4R2lkcytckA0b
   ry5VGvH0qTEHtA89HkGOb2L5wGEqs3WRPhKviy+POL/pS4A+eC4weeI/b
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="359104326"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="359104326"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 19:59:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="690036199"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="690036199"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 19:59:45 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 02/11] KVM: x86/mmu: Use KVM honors guest MTRRs helper in kvm_tdp_page_fault()
Date:   Fri, 16 Jun 2023 10:34:35 +0800
Message-Id: <20230616023435.7142-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230616023101.7019-1-yan.y.zhao@intel.com>
References: <20230616023101.7019-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

