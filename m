Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FF1623AC4
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 05:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232532AbiKJEE3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 23:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiKJEE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 23:04:26 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5A1E1B799;
        Wed,  9 Nov 2022 20:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668053066; x=1699589066;
  h=from:to:cc:subject:date:message-id;
  bh=IuypqxgY8qtYaoRik5R/iYUQhD+/hT5Hbcf2oINORCk=;
  b=FO5QaFx2dA3nsAdBm1u3jmi2B6gwGF+TjJl2lq0N+mOThpwSK7NaVcwF
   9Craev6kABzVujymSTTW+ipL6wYkLvvr3NlgN1WQgmJiW9pHQVsCVD+tC
   L34lZ99rKGaRS0MB8q8RsT+2af6Do5pYMnTxocfk7bpmZfGjEwBLsi2cW
   U2WtFZF8cq+Vb0645XMRT92shL37i2g4+26TYdpwA9/CXrX0t3e3G28L0
   NFvV0mTDdxhxiGXGeLf8mZxPycJD2jqC1dQ9IoeBgmpw9VCQ4Qcx1GChH
   1UAqQMeR8OpC9szTHsZwXOfXquB11BWZgpjPi7LLFLpcQ7toQmxOKGsIo
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="312334022"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="312334022"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 20:04:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="811889757"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="811889757"
Received: from yzhao56-desk.sh.intel.com ([10.238.200.254])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 20:04:23 -0800
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH] KVM: x86/mmu: avoid accidentally go to shadow path for 0 count tdp root
Date:   Thu, 10 Nov 2022 11:41:22 +0800
Message-Id: <20221110034122.9892-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm mmu uses "if (is_tdp_mmu(vcpu->arch.mmu))" to choose between tdp mmu
and shadow path.
If a root is a tdp mmu page while its root_count is 0, it's not valid to
go to the shadow path.

So, return true and add a warn on zero root count.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index c163f7cc23ca..58b4881654a9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -74,6 +74,7 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
 {
 	struct kvm_mmu_page *sp;
 	hpa_t hpa = mmu->root.hpa;
+	bool is_tdp;
 
 	if (WARN_ON(!VALID_PAGE(hpa)))
 		return false;
@@ -84,7 +85,10 @@ static inline bool is_tdp_mmu(struct kvm_mmu *mmu)
 	 * pae_root page, not a shadow page.
 	 */
 	sp = to_shadow_page(hpa);
-	return sp && is_tdp_mmu_page(sp) && sp->root_count;
+	is_tdp = sp && is_tdp_mmu_page(sp);
+	WARN_ON(is_tdp && !refcount_read(&sp->tdp_mmu_root_count));
+
+	return is_tdp;
 }
 #else
 static inline int kvm_mmu_init_tdp_mmu(struct kvm *kvm) { return 0; }
-- 
2.17.1

