Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77E846A3D0A
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:29:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbjB0I3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:29:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjB0I3A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:29:00 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9933C1F92B;
        Mon, 27 Feb 2023 00:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486345; x=1709022345;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ov5DgyTrv7L7li/EvdiDpXo3AQar4ALCRKLAlmlcPEo=;
  b=BqysAO8B7QLTTBzJijRb6KUtu5oOglEus3NiE2Y95FkvXxnT1ih+Mje/
   pyy+aIF3PKEF1R7qWcdSspBboGAIv1VNALhECJ34wrtbV58/37tNBp3d1
   gO7t7qHg+1d52TvfrqCSX5yZ5ipZr3GDkX/en4ZO9Sx/7ZGQW4J7HFFQt
   R3nrsKXCUIQLdbaCjhvsUSrLyAq1R621scL0989UVNqFJI0gBYve6dTtr
   01fgYNqqgT5hmwIVAPwzn2Ux+hK1XHjRF2zP5RV9db1anHA0wQU0Sff2b
   8kjCzmzn5kTCSjD8c3VrizxYxTJXOYKZ9oya+KxOw3qyMzfsLnU79uvJT
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317609008"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317609008"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:17 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242356"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242356"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:16 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Yao Yuan <yuan.yao@intel.com>
Subject: [PATCH v12 077/106] KVM: TDX: Handle vmentry failure for INTEL TD guest
Date:   Mon, 27 Feb 2023 00:23:16 -0800
Message-Id: <1de5d5d4e406c4103aec47ccdb4ecf2a826a73be.1677484918.git.isaku.yamahata@intel.com>
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

From: Yao Yuan <yuan.yao@intel.com>

TDX module passes control back to VMM if it failed to vmentry for a TD, use
same exit reason to notify user space, align with VMX.
If VMM corrupted TD VMCS, machine check during entry can happens.  vm exit
reason will be EXIT_REASON_MCE_DURING_VMENTRY.  If VMM corrupted TD VMCS
with debug TD by TDH.VP.WR, the exit reason would be
EXIT_REASON_INVALID_STATE or EXIT_REASON_MSR_LOAD_FAIL.

Signed-off-by: Yao Yuan <yuan.yao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1218896d8ba4..36c5a0b6e452 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1138,6 +1138,28 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		goto unhandled_exit;
 	}
 
+	/*
+	 * When TDX module saw VMEXIT_REASON_FAILED_VMENTER_MC etc, TDH.VP.ENTER
+	 * returns with TDX_SUCCESS | exit_reason with failed_vmentry = 1.
+	 * Because TDX module maintains TD VMCS correctness, usually vmentry
+	 * failure shouldn't happen.  In some corner cases it can happen.  For
+	 * example
+	 * - machine check during entry: EXIT_REASON_MCE_DURING_VMENTRY
+	 * - TDH.VP.WR with debug TD.  VMM can corrupt TD VMCS
+	 *   - EXIT_REASON_INVALID_STATE
+	 *   - EXIT_REASON_MSR_LOAD_FAIL
+	 */
+	if (unlikely(exit_reason.failed_vmentry)) {
+		pr_err("TDExit: exit_reason 0x%016llx qualification=%016lx ext_qualification=%016lx\n",
+		       exit_reason.full, tdexit_exit_qual(vcpu), tdexit_ext_exit_qual(vcpu));
+		vcpu->run->exit_reason = KVM_EXIT_FAIL_ENTRY;
+		vcpu->run->fail_entry.hardware_entry_failure_reason
+			= exit_reason.full;
+		vcpu->run->fail_entry.cpu = vcpu->arch.last_vmentry_cpu;
+
+		return 0;
+	}
+
 	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
 
 	switch (exit_reason.basic) {
-- 
2.25.1

