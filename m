Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6969714358
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232401AbjE2Eef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbjE2E3B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:29:01 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F5E199C;
        Sun, 28 May 2023 21:25:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334325; x=1716870325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=58NDj2goq9yqIbEbRdLYrs8oCByn7UZBJiVRhHhY/2E=;
  b=gFiVRWHxqd8nLUF7+8bnGpdhgr9S6JyIu8crzK0yf0AhO6bRmjFIULDX
   FlLktP+xxwuvW2TBN5XsTDI61bijQrCPSD83JolnbNeRWmia0bI9QmFwW
   qkpqsiJElwwd3yLpPC4eSO+bcUeCObzQOwPLcnIIFLFLkBVTyh/h2TPeE
   /l1KA6yuMb//r5n3NjucfRGurVn0NYuvS9pXsFACMrfpQktcf3S8/EOAT
   HvJA6JJdE+GtPmSonytQ9geDpTlLaxRkUri5OBw7XQMWv9p+5em2xXHbR
   +JUfhl0/8DnfPF41Iutn7U+RRXRhTGuCYwqSxQwSzkmVPWb3+6KKWWUA6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="356993523"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="356993523"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="830223578"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="830223578"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:51 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 105/113] KVM: TDX: Add methods to ignore accesses to TSC
Date:   Sun, 28 May 2023 21:20:27 -0700
Message-Id: <51d07cabb3ff9c386b78273b0774d8acfc37d378.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX protects TDX guest TSC state from VMM.  Implement access methods to
ignore guest TSC.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 44 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index da963f305170..166bf274e597 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -827,6 +827,42 @@ static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
 }
 
+static u64 vt_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	/* TDX doesn't support L2 guest at the moment. */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
+	return vmx_get_l2_tsc_offset(vcpu);
+}
+
+static u64 vt_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	/* TDX doesn't support L2 guest at the moment. */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
+	return vmx_get_l2_tsc_multiplier(vcpu);
+}
+
+static void vt_write_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
+{
+	/* In TDX, tsc offset can't be changed. */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_write_tsc_offset(vcpu, offset);
+}
+
+static void vt_write_tsc_multiplier(struct kvm_vcpu *vcpu, u64 multiplier)
+{
+	/* In TDX, tsc multiplier can't be changed. */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_write_tsc_multiplier(vcpu, multiplier);
+}
+
 static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 {
 	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
@@ -985,10 +1021,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
-	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
-	.write_tsc_offset = vmx_write_tsc_offset,
-	.write_tsc_multiplier = vmx_write_tsc_multiplier,
+	.get_l2_tsc_offset = vt_get_l2_tsc_offset,
+	.get_l2_tsc_multiplier = vt_get_l2_tsc_multiplier,
+	.write_tsc_offset = vt_write_tsc_offset,
+	.write_tsc_multiplier = vt_write_tsc_multiplier,
 
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
-- 
2.25.1

