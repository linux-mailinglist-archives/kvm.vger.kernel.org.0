Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6D36B69D1
	for <lists+kvm@lfdr.de>; Sun, 12 Mar 2023 19:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbjCLSHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Mar 2023 14:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbjCLSFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Mar 2023 14:05:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32401521CC;
        Sun, 12 Mar 2023 11:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678644080; x=1710180080;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VIPx1RHWDVqaqcc5r1WiXZcpi7D/sWrbLLs3e0/kfIA=;
  b=YxHvdFkIqFqITkw8qewrJfklj+fmEWqW37wcFwnDEkcoY+PcVPgJuqXA
   hFGK4Rs7xA7MJSinvq6FMtOyThfQqXP/ZtzaoGQeO8CVGGrpqXMd7sl4k
   ZBEh9uCv8hWCjuYc+ujYtOWXG84O1hBAoA7OuJDGzvd6C24qNR1rMxoLW
   G9fCn15o5g15CHDFknYyCX1+jCapZkStGMbap3DBh4FjGJjs6Lnno1OgP
   6S0xxLxHNYNuxNZ5DfLD4K0FDw473P0zRYfXVNjtKiz2RMyCGa6OvaQXE
   N6rhg3n9xd3bejiLA2ed7OsPPaa0wJjHDqkUHzXThrg2aYrkC8T2XDWf7
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="316660152"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="316660152"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10647"; a="742596875"
X-IronPort-AV: E=Sophos;i="5.98,254,1673942400"; 
   d="scan'208";a="742596875"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2023 10:58:18 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v13 112/113] RFC: KVM: TDX: Make busy with S-EPT on entry bug
Date:   Sun, 12 Mar 2023 10:57:16 -0700
Message-Id: <13a767dcac55d2df9a8b747be178452399d5d3b4.1678643052.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1678643051.git.isaku.yamahata@intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 8e392bc3330b..b668f06bbb64 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1670,8 +1670,20 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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
 
 	if (unlikely(exit_reason.full == TDX_SEAMCALL_UD)) {
-- 
2.25.1

