Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4297532F8
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbjGNHSx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbjGNHSf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:18:35 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CCF2D45;
        Fri, 14 Jul 2023 00:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319113; x=1720855113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=9Cr+l5teQ1mq0jHpBaqwW8YXlqIUC0zccTjsvm332ms=;
  b=gLQQifvBnx/FOLCByzBelYmIrWesD5bJZw00LgINXc2Bw9OrlB3LZzCj
   8326Cen8srYzmRQTzgdeqq0drlp1yKGuv9EgcG5+K6mxHnTon63b2tqbP
   Y4RebUAqHUxfAy0AcE2DN9jvWzg9YuZn9tEJymiPwy36MJNWujzv2vVXp
   Bd37RW8a3K+eyzqrk7lX/f+8oUTzCmkT2hQvJ7I5o/h8KV42g6Pila6I8
   s02ZnYqHqWKgRGEuAheEKHVdqBEwrbP3X4H2UQqPYSHrAYOSoD4SnVW25
   dFzmcFBjUOOP/00IDODfs0/TL/nGL6dVVruxXkN2+hb3+1ALxdxXpha5s
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="396222058"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="396222058"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:18:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="716244152"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="716244152"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:18:30 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 04/12] KVM: x86/mmu: Use KVM honors guest MTRRs helper when update mtrr
Date:   Fri, 14 Jul 2023 14:51:56 +0800
Message-Id: <20230714065156.20375-1-yan.y.zhao@intel.com>
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

When guest MTRRs are updated, zap SPTEs and do zap range calcluation if and
only if KVM's MMU is honoring guest MTRRs, which is the only time that KVM
incorporates the guest's MTRR type into the final memtype.

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

