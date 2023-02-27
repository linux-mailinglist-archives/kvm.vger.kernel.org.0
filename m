Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 862D06A3CAF
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:26:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjB0I0b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjB0IZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:25:43 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23081DB90;
        Mon, 27 Feb 2023 00:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486263; x=1709022263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pdgoFQm3JRuaMw47/Kh+D9Xlv4eahf93UcQ7oLnvQ+k=;
  b=aaLsea3IAcl381HtOr3qt3li5+kuf7lIL3PKc/JCmJcidqUNZFfvjikw
   MF0tIdEOpTrZ1sSdT7PdA+ITFU8RertCSTRb63vjUzpMagWAVrKkrfv/g
   eHW/Ux6c8jooX+g/0j62wYSNhbqNIr8NFQdAu01vz7TgHkzYj+CSmXoyc
   lPY57OQhQ76OgB+4U1RkD/hmNk5tSDVSPEN4+VwdMLk6gx4KFV3KqTlZP
   WNtuz3o5rAnxmewQ1UPoJ2/hmbo/NgAbb1juTh/QYrq2mmRRyI/eR+LR5
   bLfbCW7aA9lvVR7Iee8CKmDvWEyPbK/+blPr6MOQgXUsIVf/w2uayHkVY
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608823"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608823"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:08 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242183"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242183"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:07 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 039/106] KVM: x86/tdp_mmu: Sprinkle __must_check
Date:   Mon, 27 Feb 2023 00:22:38 -0800
Message-Id: <40c4f479dfab6092dbd0054dea05ec18f719dd40.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDP MMU allows tdp_mmu_set_spte_atomic() and tdp_mmu_zap_spte_atomic() to
return -EBUSY or -EAGAIN error.  The caller must check the return value and
retry.  Sprinkle __must_check to guarantee it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index e17adceec426..03a16f8ee8c7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -628,9 +628,9 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
  *            no side-effects other than setting iter->old_spte to the last
  *            known value of the spte.
  */
-static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
-					  struct tdp_iter *iter,
-					  u64 new_spte)
+static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
+						       struct tdp_iter *iter,
+						       u64 new_spte)
 {
 	u64 *sptep = rcu_dereference(iter->sptep);
 
@@ -658,8 +658,8 @@ static inline int tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	return 0;
 }
 
-static inline int tdp_mmu_zap_spte_atomic(struct kvm *kvm,
-					  struct tdp_iter *iter)
+static inline int __must_check tdp_mmu_zap_spte_atomic(struct kvm *kvm,
+						       struct tdp_iter *iter)
 {
 	int ret;
 
-- 
2.25.1

