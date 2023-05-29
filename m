Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D47714351
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232318AbjE2EeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232221AbjE2E3X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:29:23 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DFB19AE;
        Sun, 28 May 2023 21:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334337; x=1716870337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4PwL5NbPac5/nE1Cw3zGTEo5Zc0sMlzkdyoVKVQtSTw=;
  b=EQu0lxE/UiRPQotZWX/vBw+Yw+LmHxdf3gNp4Q5Xa/A5UrVfOogXgvNS
   NKXT6F+eFGkRn8qt018XIRSIMq0N1WeDqxVT0MDuoAQdR5zxZoPf8j8Z+
   TUaR2C1Xpn5C06AIS3GjJ3FOMjBRMZ5tvjJQ4EGZd7ruooFXawwKOPJtV
   vNy7Nub0hrTMQtfTu5x/1Dd0eq3t4VOsoFjGqoPFRYVdQloeE/z4ZNwUp
   2g6/5rECBZ4xVEa7Z0bBYw93KxxWiRBJzBnvZ0ztXQZTulP13ThXBVYAf
   ow3Gf6hsob7Tw24BwNLOH83yhGRufNYA8q8tt6z+VVk5azF9UoDRCM4WK
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="356993568"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="356993568"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="830223648"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="830223648"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:57 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 112/113] RFC: KVM: TDX: Make busy with S-EPT on entry bug
Date:   Sun, 28 May 2023 21:20:34 -0700
Message-Id: <f687fe20152fa8bcf67f50213ca322b663c2e45e.1685333728.git.isaku.yamahata@intel.com>
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

TDX module has mitigation against zero-step attacks or single-step attacks.
When the TDX module finds repeated EPT violations on the same guest RIP,
i.e. no advance in guest, it starts to suspect the attack.  The mitigation
logic on the next entry tries to take the lock of S-EPT.  It may result in
an error of TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT.  As KVM shouldn't
spuriously zap private S-EPT so that guest can make progress, KVM
shouldn't cause the TDX module to trigger the mitigation.  Make
(TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT) on entry KVM bug.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
- This patch is RFC because this is only lightly tested and stress test
  isn't done.
---
 arch/x86/kvm/vmx/tdx.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 12d6c9cacf6a..885fb1a7e324 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1702,8 +1702,20 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
 	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
 
-	/* See the comment of tdh_sept_seamcall(). */
-	if (unlikely(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)))
+	/*
+	 * See the comment of tdh_sept_seamcall().
+	 * TDX module has mitigation against zero-step attacks or single-step
+	 * attacks.  When the TDX module finds repeated EPT violations on the
+	 * same guest RIP, i.e. no advance in guest, it starts to suspect the
+	 * attack.  The mitigation logic on the next entry tries to take the
+	 * lock of S-EPT.  It may result in an error of (TDX_OPERAND_BUSY |
+	 * TDX_OPERAND_ID_SEPT).  As KVM shouldn't spuriously zap private S-EPT
+	 * so that guest can make progress, KVM shouldn't cause the TDX module
+	 * to trigger the mitigation.  Make (TDX_OPERAND_BUSY |
+	 * TDX_OPERAND_ID_SEPT) on entry KVM bug.
+	 */
+	if (KVM_BUG_ON(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT),
+		       vcpu->kvm))
 		return 1;
 
 	/*
-- 
2.25.1

