Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 229D958BD98
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 00:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbiHGWHU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 7 Aug 2022 18:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237072AbiHGWFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 7 Aug 2022 18:05:12 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C29B7DA;
        Sun,  7 Aug 2022 15:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659909781; x=1691445781;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lKCVk5eYfArj0BKao6F/kBoR6PoZK+1iJmdh6WDEfmI=;
  b=hEMpLkhDCkZMW5BYXalAMfLy7FuKFNQxQxC75mM7p/tNDUmp7FgnYJOY
   FaMdwizye2t87oUgcIaTBQopBv+V6vR8qdG79zFlgnAzsRH6bvnhvU6xw
   OQDjP8p9WGpDyJpn6wnxShTXx5aEB+vFMkQnuURP88pxIroiF9nOcJO4D
   CIa8inXxCWe+iDoEVuYJaWo0NqixO/yygovHdMP1iIqL5I30c/ZJArr44
   ZlBkUXuQ7IK88/9wsp28keKE8X7HVbsIRHl03wQQ1ngJVLIVSx8+oY9uu
   CfEpZDzo4cDrH86zGk4XxFLRN1O85X3h8jFu8HSYbLhV1FpGZjNj7tNjA
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10432"; a="289224127"
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="289224127"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:35 -0700
X-IronPort-AV: E=Sophos;i="5.93,220,1654585200"; 
   d="scan'208";a="663682570"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2022 15:02:35 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: [PATCH v8 040/103] KVM: x86/mmu: Require TDP MMU for TDX
Date:   Sun,  7 Aug 2022 15:01:25 -0700
Message-Id: <38ed5eb0302a4b7e47844e2546694da8093927d0.1659854790.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1659854790.git.isaku.yamahata@intel.com>
References: <cover.1659854790.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Require the TDP MMU for guest TDs, the so called "shadow" MMU does not
support mapping guest private memory, i.e. does not support Secure-EPT.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ce69535754ff..823c1ef807eb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -18,8 +18,12 @@ int kvm_mmu_init_tdp_mmu(struct kvm *kvm)
 {
 	struct workqueue_struct *wq;
 
+	/*
+	 * Because only the TDP MMU supports TDX, require the TDP MMU for guest
+	 * TDs.
+	 */
 	if (!tdp_enabled || !READ_ONCE(tdp_mmu_enabled))
-		return 0;
+		return kvm->arch.vm_type == KVM_X86_TDX_VM ? -EOPNOTSUPP : 0;
 
 	wq = alloc_workqueue("kvm", WQ_UNBOUND|WQ_MEM_RECLAIM|WQ_CPU_INTENSIVE, 0);
 	if (!wq)
-- 
2.25.1

