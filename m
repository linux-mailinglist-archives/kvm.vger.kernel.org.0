Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD10667B6F
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240741AbjALQmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240033AbjALQhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:37:55 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753D21A041;
        Thu, 12 Jan 2023 08:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673541240; x=1705077240;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vHDC6E78sPwFGr8uBvPmdYmQt3+1YE26ziCVOvn3tsw=;
  b=eXG3cv9iNhYxSHL25qFTsFF27saiwz7VMwDdL+AOUUsA7/u61zt9+ji/
   cJhS2p9cifR3lVHM7pyVRbW43pPCLVrKhb5n/fyY1cE+XVuy7GmwhVEMY
   6briz7aR9BVk6qoFFjnlSh4b/DLxZfuxTlqEn2ov1s/glastf+qqHGoG3
   ZaNhOxp/8zqDLogzoDSd/vBszXyeh6vQ9zANv2zHKJ+HN545I1tdxLvmq
   1sqi9Tj1Or1t1ngrFU/2KF8N/dC8itzy97nKYr6B1hfDXFuiWuu85RRE3
   bm1ZzWXfgH6uWg/mSm5WXPBfos7APRH6KTcVkT1qU64uUiWur+/JEvq4Q
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="323811815"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="323811815"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:25 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721151745"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="721151745"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 08:33:25 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v11 034/113] KVM: x86/mmu: Disallow fast page fault on private GPA
Date:   Thu, 12 Jan 2023 08:31:42 -0800
Message-Id: <0cf30eea792ea75e09e2794b91ca041e1c1e68db.1673539699.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1673539699.git.isaku.yamahata@intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX requires TDX SEAMCALL to operate Secure EPT instead of direct memory
access and TDX SEAMCALL is heavy operation.  Fast page fault on private GPA
doesn't make sense.  Disallow fast page fault on private GPA.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8d3d7deebdd0..5b111a325434 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3273,8 +3273,16 @@ static int handle_abnormal_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fau
 	return RET_PF_CONTINUE;
 }
 
-static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
+static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault)
 {
+	/*
+	 * TDX private mapping doesn't support fast page fault because the EPT
+	 * entry is read/written with TDX SEAMCALLs instead of direct memory
+	 * access.
+	 */
+	if (kvm_is_private_gpa(kvm, fault->addr))
+		return false;
+
 	/*
 	 * Page faults with reserved bits set, i.e. faults on MMIO SPTEs, only
 	 * reach the common page fault handler if the SPTE has an invalid MMIO
@@ -3384,7 +3392,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	u64 *sptep = NULL;
 	uint retry_count = 0;
 
-	if (!page_fault_can_be_fast(fault))
+	if (!page_fault_can_be_fast(vcpu->kvm, fault))
 		return ret;
 
 	walk_shadow_page_lockless_begin(vcpu);
-- 
2.25.1

