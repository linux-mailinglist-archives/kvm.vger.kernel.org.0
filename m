Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7D653024A
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 12:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242884AbiEVKI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 06:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiEVKIz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 06:08:55 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063683EB86;
        Sun, 22 May 2022 03:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653214135; x=1684750135;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+ldVfAkI63e7T9H9+Tu6rkR3XDiV/+stA3qHNtz8ShU=;
  b=fqMcbs48cA3u/tkSq0h0hOc/tsat7AIBWsHThBL2I3/Mte54HeMaXpXe
   K+ovU99hntEQEHj50yvPvfSryz40huKAtsNRrSlbyT4HkfP3w1PLVpmTu
   8FDIFop5Bltlh9FI2lSRA9djUsfzq7K3W2QfLrZNQRzUEZe5Uygm+W+P0
   9IqRpo6uPsvSM+fcr5opM8HtiMD9XVknclTxM7/zDyyqFbgyC3elICCFZ
   wjxLx59jCQKtaQw1bndoDnQsXqB6gbv/NBnsMe95aplRu6JL3U/yhCumX
   EFzbb+B/yyzfZV8JiVzmqGiH4BOMSeHb6Z7zvNpJpPecfg1Cf+/58R6bh
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10354"; a="272956338"
X-IronPort-AV: E=Sophos;i="5.91,244,1647327600"; 
   d="scan'208";a="272956338"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2022 03:08:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,244,1647327600"; 
   d="scan'208";a="628872786"
Received: from q.bj.intel.com ([10.238.154.102])
  by fmsmga008.fm.intel.com with ESMTP; 22 May 2022 03:08:50 -0700
From:   shaoqin.huang@intel.com
To:     pbonzini@redhat.com
Cc:     Shaoqin Huang <shaoqin.huang@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86/mmu: Check every prev_roots in __kvm_mmu_free_obsolete_roots()
Date:   Sun, 22 May 2022 19:09:48 -0600
Message-Id: <20220523010948.2018342-1-shaoqin.huang@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shaoqin Huang <shaoqin.huang@intel.com>

Iterate every prev_roots and only zap obsoleted roots.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 45e1573f8f1d..22803916a609 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5168,7 +5168,7 @@ static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 		roots_to_free |= KVM_MMU_ROOT_CURRENT;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
-		if (is_obsolete_root(kvm, mmu->root.hpa))
+		if (is_obsolete_root(kvm, mmu->prev_roots.hpa))
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 
-- 
2.30.2

