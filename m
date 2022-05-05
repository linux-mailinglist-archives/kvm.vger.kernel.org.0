Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C80D51C742
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 20:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383991AbiEESXq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 14:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382880AbiEESTl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 14:19:41 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D9B0443E1;
        Thu,  5 May 2022 11:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651774553; x=1683310553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dqWkE2oXMmA/xSffMn3L9CacObWffok44u2yasFRPjk=;
  b=AL2XsOYxNXAT7CXCx0JPkVLfc+EGCmyGXnDDAsyvZXWqD146S3PV8s9+
   W/gJCdnWzojuNxTAHNj1fTAbcP6lf/7PqN7fRBlOQE7zGErtCeLnmtzxK
   p0ZwYtKucn26WF1F28dj7n7Qg8wvt/LtuZxaNWmBDex0mpE4yCrt7373V
   l5Gye2FGMUiocH8DD+tCm5/lxFwmv+Rg6Y/SSvpnUk/di4SCHKGLROhjG
   eX3A7O/e3So4eXjR1wOjzCA4XfRiOOwO3+7xbo/mv4mOmy6pipeZS+ZKv
   IvixtnMVt2i5TBZZvi3P/RI/JzbvSkBiAzNJ7p+BRqbeqPxKlSRujw+mM
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10338"; a="328746281"
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="328746281"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:46 -0700
X-IronPort-AV: E=Sophos;i="5.91,202,1647327600"; 
   d="scan'208";a="665083290"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2022 11:15:46 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [RFC PATCH v6 044/104] KVM: x86/mmu: Focibly use TDP MMU for TDX
Date:   Thu,  5 May 2022 11:14:38 -0700
Message-Id: <74ed344d1ee81bc378dcd0339278b0c3b7d675e9.1651774250.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651774250.git.isaku.yamahata@intel.com>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

In this patch series, TDX supports only TDP MMU and doesn't support legacy
MMU.  Forcibly use TDP MMU for TDX irrelevant of kernel parameter to
disable TDP MMU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f8c1824d85a5..b8850a0ceb15 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -18,8 +18,13 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	struct workqueue_struct *wq;
 
-	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
-		return 0;
+	/*
+	 *  Because TDX supports only TDP MMU, forcibly use TDP MMU in the case
+	 *  of TDX.
+	 */
+	if (kvm->arch.vm_type != KVM_X86_TDX_VM &&
+		(!tdp_enabled || !READ_ONCE(tdp_mmu_enabled)))
+		return false;
 
 	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
 	if (!wq)
-- 
2.25.1

