Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCD073257D
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 04:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239805AbjFPC5h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 22:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjFPC5f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 22:57:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C045297C;
        Thu, 15 Jun 2023 19:57:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884254; x=1718420254;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=ut2e3J98JDctUs6MMT7+OPH8GV0+N2ela+vuLlRy0YU=;
  b=VLl4mwSK3nWsjmnxllFM8zr+8D5U9sdl83C3d2ytVfcTFAy8qi/trJlf
   oJeHDf3OOglPkPuTuLhjiN1FbIYJUPIQc8EqZD1+QviozFeV7GyXvebjL
   Qiuqj6Us2NMCpHLy/+GhlQ1WJx6oyvpo8cDvVvZr3tYaORregT4xYPcvk
   W2RIjKFWznRK9BEl49GMasnurTqwn3TYAfocb1WlXzHtaS8mTvQsdHMgG
   ZdmaediC5yeLiw64QJhn/Es/qpN7sDurqJQQV3vf+njOIEJs1bOh++cb0
   zuvaXMo6/5vE8xSD+BboIHqH9RYrYB91OXI4S8364Ild4p2/kFGO5/wTW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="387732923"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="387732923"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 19:57:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="802653734"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="802653734"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 19:57:32 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 01/11] KVM: x86/mmu: helpers to return if KVM honors guest MTRRs
Date:   Fri, 16 Jun 2023 10:32:17 +0800
Message-Id: <20230616023217.7081-1-yan.y.zhao@intel.com>
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

Added helpers to check if KVM honors guest MTRRs.
The inner helper __kvm_mmu_honors_guest_mtrrs() is also provided to
outside callers for the purpose of checking if guest MTRRs were honored
before stopping non-coherent DMA.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu.h     |  7 +++++++
 arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 92d5a1924fc1..38bd449226f6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -235,6 +235,13 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
+bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncoherent_dma);
+
+static inline bool kvm_mmu_honors_guest_mtrrs(struct kvm *kvm)
+{
+	return __kvm_mmu_honors_guest_mtrrs(kvm, kvm_arch_has_noncoherent_dma(kvm));
+}
+
 void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end);
 
 int kvm_arch_write_log_dirty(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1e5db621241f..b4f89f015c37 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4516,6 +4516,21 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 }
 #endif
 
+bool __kvm_mmu_honors_guest_mtrrs(struct kvm *kvm, bool vm_has_noncoherent_dma)
+{
+	/*
+	 * If the TDP is enabled, the host MTRRs are ignored by TDP
+	 * (shadow_memtype_mask is non-zero), and the VM has non-coherent DMA
+	 * (DMA doesn't snoop CPU caches), KVM's ABI is to honor the memtype
+	 * from the guest's MTRRs so that guest accesses to memory that is
+	 * DMA'd aren't cached against the guest's wishes.
+	 *
+	 * Note, KVM may still ultimately ignore guest MTRRs for certain PFNs,
+	 * e.g. KVM will force UC memtype for host MMIO.
+	 */
+	return vm_has_noncoherent_dma && tdp_enabled && shadow_memtype_mask;
+}
+
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
 	/*
-- 
2.17.1

