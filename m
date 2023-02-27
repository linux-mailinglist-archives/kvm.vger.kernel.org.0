Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F263B6A3C95
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbjB0IZq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjB0IY6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:24:58 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5D91C7F5;
        Mon, 27 Feb 2023 00:24:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486256; x=1709022256;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NQmrs82q67JKccX4iPWUTE8xOSyHlsd2sMxQgdEWU+4=;
  b=Q19FHmn3kvV4hFQ/7hrVJ6MlznIjKSsdvluT8SwGHMlEqgBi3I0fWnff
   302mc5GlszgYTZbfTkE4TYsgJEKulgU+vP995oZ9y83RM5KR2BwzMtzzj
   1kJaU2Qt6nl3TuM7UkAXeJvn8hA65lbyA74UIa60Ht+iJUbSgmGKwNnlX
   DE6O2LuixPoDlCYGwIkmx5EYbswVzcQYkm9EJRi3SoL1sc0dJ6bvZbvmr
   FkkEUGzeFhrLw0QUDw7cm4ezrxDy5CE/I+B8lsGPZDjdOIynQoQ1htGzX
   tg1DCOI3xY44bJoslzr43uP3NpYfmzFShfcwVrSxvXQ2TseXul2hdRHIg
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608788"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608788"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:06 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242148"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242148"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:06 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 029/106] KVM: x86/mmu: Disallow fast page fault on private GPA
Date:   Mon, 27 Feb 2023 00:22:28 -0800
Message-Id: <475bc1d2f93dd2f95eacc0d05eef35fe66c72ab6.1677484918.git.isaku.yamahata@intel.com>
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

TDX requires TDX SEAMCALL to operate Secure EPT instead of direct memory
access and TDX SEAMCALL is heavy operation.  Fast page fault on private GPA
doesn't make sense.  Disallow fast page fault on private GPA.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8955d893d173..aaa485daa4d9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3280,8 +3280,16 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
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
@@ -3391,7 +3399,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	u64 *sptep = NULL;
 	uint retry_count = 0;
 
-	if (!page_fault_can_be_fast(fault))
+	if (!page_fault_can_be_fast(vcpu->kvm, fault))
 		return ret;
 
 	walk_shadow_page_lockless_begin(vcpu);
-- 
2.25.1

