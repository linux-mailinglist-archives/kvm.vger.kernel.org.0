Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A03732590
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 05:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241435AbjFPDDL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 23:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241326AbjFPDC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 23:02:59 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A2F2D4C;
        Thu, 15 Jun 2023 20:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686884575; x=1718420575;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=rpvZF8/E2sO1ceRHFD/Pgi1BwdLKFTmV/M8xCwRXvyg=;
  b=Kc5nxSVobPUSZi6EYjYfYQV2iVc5pCfheydzrAeaXzWVm+BPWondcfzh
   NvoD3GX6SNUxLZVQzxl0V8cN62y9GAav4zkR3qmdY7T1q9W87ndscot4S
   tbto2soFrqTjuKPzSS/geiI++0TY3ATV3hw3UGmt/fjz7qwRcdcJ5Z8nm
   HIxRcDBgmvMXM3OyZzTfpz/ZgOVmIurX8g9u+6siFtTQvGcBXglvyowNM
   PvS1tSFZf3QGbEUHrKR71qNrJv6bgUUdINWzEZ2xkoqkjjhm4Fjc+R/8y
   y7Q0+Vfjk846YDdmwV7JSuI2Y/APAdaEMWvRqC70LPfyNXcd/fUzwQoNb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="361621625"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="361621625"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:02:54 -0700
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="745963368"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="745963368"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 20:02:52 -0700
From:   Yan Zhao <yan.y.zhao@intel.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, chao.gao@intel.com,
        kai.huang@intel.com, robert.hoo.linux@gmail.com,
        Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH v3 06/11] KVM: x86/mmu: move TDP zaps from guest MTRRs update to CR0.CD toggling
Date:   Fri, 16 Jun 2023 10:37:42 +0800
Message-Id: <20230616023742.7379-1-yan.y.zhao@intel.com>
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

