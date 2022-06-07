Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DEA53E6FC
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbiFFJ6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 05:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233033AbiFFJ6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 05:58:43 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1B41EC52;
        Mon,  6 Jun 2022 02:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654509522; x=1686045522;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CnqY3WLlc8HFY+CvHCMWaMsQzY4zu9VF10JrJlKu66k=;
  b=B/7eRr3apdZjCXt2bDF5EQVi6vQy9VBT/mTbyef2//nCNEkWykDFE3Ls
   l7gJNgfqttckiTvbO99cRXIiEroUr+s6eb/4AfQ73O72uijpfLsezWfwd
   C6Z4FJuDj+tpKLNrE34mQ40Wloa3ottS0517ArPNk+9FvO2oUAGpscIgB
   L22bTN/ZqVt2ebMJlIB216suSJaU4MPojnbSop3Y3pxUpLY83rO4bfXbL
   jEV+D73TgnHkiNq/qOyeBOINmiH7RV8Y3a5fNobV3CJQo4FzBN0dtJhgt
   imR6074x1Hb4EZ1i5E6F+RNyZPtpzjnOgspOG5f6d0JYc+rCLQ3pbVTge
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="258913612"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="258913612"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 02:58:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="682185460"
Received: from q.bj.intel.com ([10.238.154.102])
  by fmsmga002.fm.intel.com with ESMTP; 06 Jun 2022 02:58:34 -0700
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
        "H. Peter Anvin" <hpa@zytor.com>, Ben Gardon <bgardon@google.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: x86/mmu: Check every prev_roots in __kvm_mmu_free_obsolete_roots()
Date:   Mon,  6 Jun 2022 18:59:05 -0600
Message-Id: <20220607005905.2933378-1-shaoqin.huang@intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DATE_IN_FUTURE_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shaoqin Huang <shaoqin.huang@intel.com>

When freeing obsolete previous roots, check prev_roots as intended, not
the current root.

Signed-off-by: Shaoqin Huang <shaoqin.huang@intel.com>
Fixes: 527d5cd7eece ("KVM: x86/mmu: Zap only obsolete roots if a root shadow page is zapped")
---
Changes in v2:
  - Make the commit message more clearer.
  - Fixed the missing idx.

 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f4653688fa6d..e826ee9138fa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5179,7 +5179,7 @@ static void __kvm_mmu_free_obsolete_roots(struct kvm *kvm, struct kvm_mmu *mmu)
 		roots_to_free |= KVM_MMU_ROOT_CURRENT;
 
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
-		if (is_obsolete_root(kvm, mmu->root.hpa))
+		if (is_obsolete_root(kvm, mmu->prev_roots[i].hpa))
 			roots_to_free |= KVM_MMU_ROOT_PREVIOUS(i);
 	}
 
-- 
2.30.2

