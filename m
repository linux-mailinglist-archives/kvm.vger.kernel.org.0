Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CFCB4CDF55
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:01:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbiCDUca (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiCDUcV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:32:21 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55C551E6EBE;
        Fri,  4 Mar 2022 12:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646425891; x=1677961891;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NWtwA1Mcge7E6YZfOv6akPgOyt4W/fs13Ve2SrnZD4s=;
  b=aisMNkai4wZygW8qFw8hFiDluu5Y5cThwv2dkx/TCu7PM/HIzmmRtQmt
   /WngeN7MSiKwdlG3r1ygS1yauO4Bl9TJCFfWL01umbwHqf0SqFUKSm2Tm
   XmmZ0u3W/7ILpBqtT3KLmPBl6v+F+6Dd/m+YRDT06kiWMCBSVZFh2FWHE
   8aJv6Rp4cyPoRvERHvN7E4sFEvoiy/TvboSGVKz+hou8ISzEJfBZG9D2A
   MUQF7fCJCP3S72J7H8s+DTQ2PS/vxut7p8BTRixWGF5TmzyoMhqygLZJI
   MK2drXq+aDl5YNSkPTGdcMQbeIAQpA5MyLp4TusI5JRFVhziLHL8qRw03
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="251624266"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="251624266"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:33 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344466"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:33 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 068/104] KVM: TDX: restore user ret MSRs
Date:   Fri,  4 Mar 2022 11:49:24 -0800
Message-Id: <7c421339d5b2bd5d2e29f79ac1cdf5d269c5cf96.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Several user ret MSRs are clobbered on TD exit.  Restore those values on
TD exit and before returning to ring 3.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 54be5be1a06c..c1366aac7d96 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -550,6 +550,28 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->kvm->vm_bugged = true;
 }
 
+struct tdx_uret_msr {
+	u32 msr;
+	unsigned int slot;
+	u64 defval;
+};
+
+static struct tdx_uret_msr tdx_uret_msrs[] = {
+	{.msr = MSR_SYSCALL_MASK,},
+	{.msr = MSR_STAR,},
+	{.msr = MSR_LSTAR,},
+	{.msr = MSR_TSC_AUX,},
+};
+
+static void tdx_user_return_update_cache(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
+		kvm_user_return_update_cache(tdx_uret_msrs[i].slot,
+					     tdx_uret_msrs[i].defval);
+}
+
 static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
@@ -589,6 +611,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
+	tdx_user_return_update_cache();
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
@@ -1371,6 +1394,16 @@ static int __init __tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 	if (WARN_ON_ONCE(x86_ops->tlb_remote_flush))
 		return -EIO;
 
+	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
+		tdx_uret_msrs[i].slot = kvm_find_user_return_msr(tdx_uret_msrs[i].msr);
+		if (tdx_uret_msrs[i].slot == -1) {
+			/* If any MSR isn't supported, it is a KVM bug */
+			pr_err("MSR %x isn't included by kvm_find_user_return_msr\n",
+				tdx_uret_msrs[i].msr);
+			return -EIO;
+		}
+	}
+
 	max_pkgs = topology_max_packages();
 	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
 				   GFP_KERNEL);
-- 
2.25.1

