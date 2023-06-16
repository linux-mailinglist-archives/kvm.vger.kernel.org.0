Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 012BB73258C
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 05:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241507AbjFPDBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 23:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239232AbjFPDB3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 23:01:29 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D5A2D5D;
        Thu, 15 Jun 2023 20:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884487; x=1718420487;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=a7dmPZNYlw0iNOFy5IcfL4+fWnLVVuU7MOzfbP4iSGY=;
  b=Ia6WMJWV6tXEYCm5UdM5e2keTCJaQvAMkQMdKdw1x4otOE7w1FpYLfIP
   0jlCj/GrIwfRrHrHGZVZMQSaICC1JmI0TnI43VaVBkyIwz5Ppm04qE0eD
   iD+jnY45hoC+GtHllHeXIH0U0AQMc4k1BMQQj+m6hyF05/ubanXibBzH9
   F7VuTE6Ogr3oMz1rGKClBdW/9mz5aBSfH08sOX11Ys2/nDk7bj4tehavF
   ojOgnpfcMx/Ln0YBEED9xXjOVXPkhTBFrmtHnvQNdVL+vjUAo+wi+Nl2E
   yDrdTS3nn9iXzP8IcoWCTPRD+ednb+TgDVzGvhuM29EvZE+Kq42BopcfF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="348809733"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="348809733"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:01:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="857213580"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="857213580"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:01:24 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 04/11] KVM: x86/mmu: Use KVM honors guest MTRRs helper when update mtrr
Date:   Fri, 16 Jun 2023 10:36:14 +0800
Message-Id: <20230616023614.7261-1-yan.y.zhao@intel.com>
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

Call helper to check if guest MTRRs are honored by KVM MMU before
calculation and zapping.
Guest MTRRs only affect TDP memtypes when TDP honors guest MTRRs, there's
no meaning to do the calculation and zapping otherwise.

Suggested-by: Chao Gao <chao.gao@intel.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mtrr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index 3eb6e7f47e96..a67c28a56417 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -320,7 +320,7 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
 	struct kvm_mtrr *mtrr_state = &vcpu->arch.mtrr_state;
 	gfn_t start, end;
 
-	if (!tdp_enabled || !kvm_arch_has_noncoherent_dma(vcpu->kvm))
+	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
 		return;
 
 	if (!mtrr_is_enabled(mtrr_state) && msr != MSR_MTRRdefType)
-- 
2.17.1

