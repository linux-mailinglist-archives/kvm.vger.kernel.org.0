Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0891A55D1D2
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241744AbiF0V4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 17:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241428AbiF0VzK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 17:55:10 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6BFB6332;
        Mon, 27 Jun 2022 14:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656366898; x=1687902898;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tyjTv6Pj07vg3EU6zQKqvLE1RD7lHcTTEeGjBabiGlY=;
  b=VcPwh/r+2d33jBoAAxbWJ+NRTJo9TVIKzS2J2bmLzmrciemu7lulOZKz
   Xe2XE+phqXcqGYjcKartdhPHTxRmXLRgTNDrRnYsKxiHWwwWz5uXF0Iiy
   KCgWr9VqF5lqsGRTZJbweimVp2uVUVSKdmTgLxPPx8+LdEVCvR/LGBH9/
   m+Ra9Lq0J7ZzmVWUK/jy6Rgp+PDfdfnH+5HGfyTAhG0it9zeeJ4Bu/Ffa
   VDD2QgRrW1rpUQfd4VgbvG1Equ+0JoM6/pBX6s/KleqUYJ8NWtDAXYnPg
   qOnEraGtYUm4zSgssCYZnQfxPy7KCubmp2gs9/SU+nkPOsLmkFKqBoYHT
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="281609559"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="281609559"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:53 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="657863574"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 14:54:53 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 043/102] KVM: x86/mmu: Focibly use TDP MMU for TDX
Date:   Mon, 27 Jun 2022 14:53:35 -0700
Message-Id: <c198d2be26aa9a041176826cf86b51a337427783.1656366338.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1656366337.git.isaku.yamahata@intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
index 82f1bfac7ee6..7eb41b176d1e 100644
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

