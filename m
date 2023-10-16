Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466BB7CAFBF
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234005AbjJPQiC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbjJPQhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:37:36 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D1A83C0;
        Mon, 16 Oct 2023 09:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697473398; x=1729009398;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B72YDEO70rKyCktJVODQJPRxRRKceKPZ5dkJZRqrFkA=;
  b=ChweWF400kKXogUbCsz/6iO2/3nfrcalzm3xrKzrfkdj9R4aM8sNJ7HC
   0nOiTdoou5aFqcO4MIKVF+C6Msy/ooumSWx2q5ly4elB1xmH/3iSI5Fjz
   mMVo2qlgrsYeBqHxMzj8jyd5QvY1tg+klifW0JgR5bu5AvIlo2tb4w2Xw
   dQ7nzqiBYYlaShDXg/XxnO+9AQ1trhkSkEwcgmazxzFUPHmXAN1qfFeYz
   Qxm1TbyKg/q02BfYvDAHo0nQybqJjTv/mvnMyBwwVBhrXhVXoFx/L/uas
   3vp6a8RjJ8yVOapqvBTAaJui1gqOm5hPM2mAxueiKMZPo9qLj7jXSOw0X
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="471793226"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="471793226"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:21:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10865"; a="899569280"
X-IronPort-AV: E=Sophos;i="6.03,229,1694761200"; 
   d="scan'208";a="899569280"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2023 09:19:18 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [RFC PATCH v5 16/16] KVM: TDX: Allow 2MB large page for TD GUEST
Date:   Mon, 16 Oct 2023 09:21:07 -0700
Message-Id: <f3a9274df79b4e2462b69c93a92388bc70c425f1.1697473009.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1697473009.git.isaku.yamahata@intel.com>
References: <cover.1697473009.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Xiaoyao Li <xiaoyao.li@intel.com>

Now that everything is there to support 2MB page for TD guest.  Because TDX
module TDH.MEM.PAGE.AUG supports 4KB page and 2MB page, set struct
kvm_arch.tdp_max_page_level to 2MB page level.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 9 ++-------
 arch/x86/kvm/vmx/tdx.c     | 4 ++--
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index cac48881c5f1..4158ca4612fa 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1687,14 +1687,9 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
-		if (is_shadow_present_pte(iter.old_spte)) {
-			/*
-			 * TODO: large page support.
-			 * Doesn't support large page for TDX now
-			 */
-			KVM_BUG_ON(is_private_sptep(iter.sptep), vcpu->kvm);
+		if (is_shadow_present_pte(iter.old_spte))
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
-		} else
+		else
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
 
 		/*
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2627dcf240cc..648bd2636ff3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -565,8 +565,8 @@ int tdx_vm_init(struct kvm *kvm)
 	 */
 	kvm_mmu_set_mmio_spte_value(kvm, 0);
 
-	/* TODO: Enable 2mb and 1gb large page support. */
-	kvm->arch.tdp_max_page_level = PG_LEVEL_4K;
+	/* TDH.MEM.PAGE.AUG supports up to 2MB page. */
+	kvm->arch.tdp_max_page_level = PG_LEVEL_2M;
 
 	/*
 	 * This function initializes only KVM software construct.  It doesn't
-- 
2.25.1

