Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8966A3D3F
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232082AbjB0IcF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbjB0Ial (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:30:41 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35796211D0;
        Mon, 27 Feb 2023 00:27:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486434; x=1709022434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EthrGG6csUFIjQZoAH/8u9QZ4GGSL5vUlX7/MC3Dx0k=;
  b=YwQuYcELaBZx/+AX1P58rsr8peN7ppTDs7wA4gEj/pQOvvxMN/bG/iY1
   rL1iZLe/JP9k8Ezysmgti8JkAQECZbiAKYtEDxDNfz5EBHxUbCbXyJkxi
   Vn40XU9NVaXYyVuacpoRweCvkVVRweoc2Lu0kP2GzyCEQVQeQQd3U0JIE
   ghW9v3gT1IrXXjHZcBeQ9d6HnaEx+fG/Qr1hRYQ66XbKs5mXLPmVmqFC3
   +2HBEHMgCgGKDyo7SCYibYjszbCW0+X6m44eEH2NUaUlwuEJGK+r9iRkV
   5tt2V/eqdpgjtM3pZJG5CLMWIaMLiV+ZMpD1caZl1a7qFxwkrb83kT95H
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317609124"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317609124"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:22 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242462"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242462"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:21 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>
Subject: [PATCH v12 105/106] RFC: KVM: TDX: Make busy with S-EPT on entry bug
Date:   Mon, 27 Feb 2023 00:23:44 -0800
Message-Id: <4ae435eb4a0e1cafcd471c7dd7124a4f0289b7e7.1677484918.git.isaku.yamahata@intel.com>
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
index 292f55efe8f7..846cd4255f49 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1712,8 +1712,20 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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
 
 	if (unlikely(exit_reason.non_recoverable || exit_reason.error)) {
-- 
2.25.1

