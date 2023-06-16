Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC7C732587
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 05:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233953AbjFPDBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 23:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241279AbjFPDBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 23:01:07 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30B32D57;
        Thu, 15 Jun 2023 20:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884457; x=1718420457;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=fDH9F5ik6wgWY9hy79+dGA7B1WWmfkgvQ9/kTzs5dJw=;
  b=M41zP/EcGdC1LY0p8tdEJLrlcBz8q2oN1r1awh4D0Oue60KXHJgH4yBS
   V9i++zVBKRasHTcMSGh72nReqELBLnVLt4nK3bahxkA0xFiik75hY/cAS
   Lp7JZU274sN/MfvbHm2SVLWTRzjHvz/lfIcpI05S48tIVblAeKfFB97Ew
   whsD/sQQcFpIt9DNq+V7FBvBZxDMsq9VdM6JKrNSvG/FvLRsCLacZzo4R
   ZyPTy3I83wpQtbgBf4yoFXHj8JwsqNATg6lGPHRzkzdWRk9SWxUoV5qKK
   TTIkaa/DVK5SZcaKpBTwGlxYtaJIrT6CYCRPqpvTKr8gFKzYrVw9LUNBL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="425031714"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="425031714"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:00:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="706914642"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="706914642"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:00:33 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 03/11] KVM: x86/mmu: Use KVM honors guest MTRRs helper when CR0.CD toggles
Date:   Fri, 16 Jun 2023 10:35:24 +0800
Message-Id: <20230616023524.7203-1-yan.y.zhao@intel.com>
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

Call helper to check if guest MTRRs are honored by KVM MMU before zapping,
as values of guest CR0.CD will only affect memory types of KVM TDP when
guest MTRRs are honored.

Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9e7186864542..6693daeb5686 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -942,7 +942,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 		kvm_mmu_reset_context(vcpu);
 
 	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
-	    kvm_arch_has_noncoherent_dma(vcpu->kvm) &&
+	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm) &&
 	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
 		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
 }
-- 
2.17.1

