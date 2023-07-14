Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C75C7532FD
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 09:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbjGNHTv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 03:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbjGNHTr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 03:19:47 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696722733;
        Fri, 14 Jul 2023 00:19:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689319173; x=1720855173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=rpvZF8/E2sO1ceRHFD/Pgi1BwdLKFTmV/M8xCwRXvyg=;
  b=Ho4VMUKqqZw9Cb/OYdvyxSTZsqmqhRnZxXuBzbAQYtNvrJz9cT18Y0mx
   A64CWUazmozlNr5X8Kb3nqC0UYSLFlRwXiBy73D+WdrAzlZ6PjFrvuEs9
   bPUsj+Cv2+IzO9Jn4bX0K0Ff9bgpVDalXfc1zVw3gY7W2Etxi1q2M45Oc
   qWOe0zbdIJCm7LZsSCR1K78MHS2doSKLCyxoSK/5QhsAEAGSoVDyipNWf
   S2J4sc2ei7Eg1j9f7iBz09+epOlWV2Dyt6t+55oumJf6J9/GkOSVHcuSD
   pc5MCH7KJVOP3A1hEXIzHz7gpDIfBesl2nGOrdLbf/JpUWSkujl5mDV5Y
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="350283288"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="350283288"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:19:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10770"; a="968900802"
X-IronPort-AV: E=Sophos;i="6.01,204,1684825200"; 
   d="scan'208";a="968900802"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2023 00:19:30 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        yuan.yao@linux.intel.com, Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v4 06/12] KVM: x86/mmu: move TDP zaps from guest MTRRs update to CR0.CD toggling
Date:   Fri, 14 Jul 2023 14:52:56 +0800
Message-Id: <20230714065256.20492-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230714064656.20147-1-yan.y.zhao@intel.com>
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If guest MTRRs are honored, always zap TDP when CR0.CD toggles and don't do
it if guest MTRRs are updated under CR0.CD=1.

This is because CR0.CD=1 takes precedence over guest MTRRs to decide TDP
memory types, TDP memtypes are not changed if guest MTRRs update under
CR0.CD=1.

Instead, always do the TDP zapping when CR0.CD toggles, because even with
the quirk KVM_X86_QUIRK_CD_NW_CLEARED, TDP memory types may change after
guest CR0.CD toggles.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mtrr.c | 3 +++
 arch/x86/kvm/x86.c  | 3 +--
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index a67c28a56417..3ce58734ad22 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -323,6 +323,9 @@ static void update_mtrr(struct kvm_vcpu *vcpu, u32 msr)
 	if (!kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
 		return;
 
+	if (kvm_is_cr0_bit_set(vcpu, X86_CR0_CD))
+		return;
+
 	if (!mtrr_is_enabled(mtrr_state) && msr != MSR_MTRRdefType)
 		return;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ac9548efa76f..32cc8bfaa5f1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -942,8 +942,7 @@ void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0, unsigned lon
 		kvm_mmu_reset_context(vcpu);
 
 	if (((cr0 ^ old_cr0) & X86_CR0_CD) &&
-	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm) &&
-	    !kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_CD_NW_CLEARED))
+	    kvm_mmu_honors_guest_mtrrs(vcpu->kvm))
 		kvm_zap_gfn_range(vcpu->kvm, 0, ~0ULL);
 }
 EXPORT_SYMBOL_GPL(kvm_post_set_cr0);
-- 
2.17.1

