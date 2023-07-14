Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39DFF7532EE
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbjGNHR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235221AbjGNHRu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:17:50 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9049126B3;
        Fri, 14 Jul 2023 00:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319069; x=1720855069;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=ut2e3J98JDctUs6MMT7+OPH8GV0+N2ela+vuLlRy0YU=;
  b=YndcM5mn3lBZKgh+LzVexAQHPVUIrMy0yPzV8Y+ZJ984DB1+ZbgWnBeK
   CJmgltDgKzDYgSqh7vXXh/2vur7DpnZA3rZsFV6VO4WQR2Qwg8rML8oNK
   xOTu9J9VDNyvXaGTbbwQzNFruaTeHhVnCJtqyjisbZOfzOeuqG9AVcNIh
   3VzCy7MsIJo8aWdWbHXCymuc7Om3npoXKonmgPmkBx5jaMZl+Y2LcxAte
   RUJDi+Kfe0ACzHnNOOlHoK/irI/OmnJW406nvdj3eSue4dcPduv9wO4BD
   r5JlEVwBFDVreMms+9dPal+LmaF1BCcpd/tP7ImwTwqnvH3urOUiXbN+A
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="396221566"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="396221566"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:16:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="1052955616"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="1052955616"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:16:46 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 01/12] KVM: x86/mmu: helpers to return if KVM honors guest MTRRs
Date:   Fri, 14 Jul 2023 14:50:06 +0800
Message-Id: <20230714065006.20201-1-yan.y.zhao@intel.com>
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

