Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3F5762678
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbjGYWYX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbjGYWWT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:22:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E304C3A;
        Tue, 25 Jul 2023 15:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323465; x=1721859465;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OBXugoeG43vdHjZJrGLYTbh1iSwz4x9BVpSGJUSumzA=;
  b=YlBRuxUWchhJ3vQRm49EZySMhox0lJ+MpGbRgRjDW0AT7U3nRlQAZebd
   8+xndJfEB3s45Cp/5/2vwV+0bGZOnOUeCv0HKDwqFmx6HAbHSjMWnUH6T
   l5Asy/iX1ZcC6l4x6/hmL2XNTbZnpEf8evruWWxK60rO2Vb1+94q+DTM2
   V89vOSvvR7CT8hOlQQZ+pL4UV9R8AS+oBS5UJLwVoa12qwrJvXdHo91Bo
   +jv4FAOWtqagUFwl0jri34E+qBXzUpLB1ulmWibCO9myps4aKsCHwmZky
   H9e4lrphMs2U2m9uHxaR0Lhu9LqRGXz67wqjn8gRNGHBeczZ+74yD7CVO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882661"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882661"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001868"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001868"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:59 -0700
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
        Yao Yuan <yuan.yao@intel.com>
Subject: [PATCH v15 084/115] KVM: TDX: Handle vmentry failure for INTEL TD guest
Date:   Tue, 25 Jul 2023 15:14:35 -0700
Message-Id: <4e1b23fd3a7d4ccb3543d5420b15741d0bd63499.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 865d7ae30813..0dfd6ea07aa0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1171,6 +1171,28 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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

