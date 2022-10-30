Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A83F612842
	for <lists+kvm@lfdr.de>; Sun, 30 Oct 2022 07:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiJ3G3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Oct 2022 02:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiJ3G2J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Oct 2022 02:28:09 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 050DA2E3;
        Sat, 29 Oct 2022 23:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667111076; x=1698647076;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PjzSXtmy1uhV89CrB2ZyHwBrD7+QbM0oUfMOi99hUlI=;
  b=hLGVNUJkTgTBMlALNx6+KiR6a6h6xOx/FBTg7KSTFPCJcbhMu8lPqsi1
   NRxrAs9ogqNhdwTOBw9NleMOpLcmFSHS2f76YGjqkSFUx/zqXEYusN4u+
   mwaJm/NBHBJhO1OOXQ6x0lSf6B3/qLjKDKABOJHJuVUR7Zey7v6shkETA
   9klpkOitTMX602XmDFKfDrS1z3IU5l4OVJsDrKbvSb19jKSWOwxnMgqoY
   ivdzSaU+cgSCyInGrFCklSk53meyCH5cThZoYNCsqzsBLlbTtImSA7Boc
   LXSA7WKwJnBcMKTN8k4VFQIoNir9MwpW5uU0jPN+omVal0bZ7Vi2+zF9f
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="395037185"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="395037185"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:09 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10515"; a="878393076"
X-IronPort-AV: E=Sophos;i="5.95,225,1661842800"; 
   d="scan'208";a="878393076"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2022 23:24:09 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v10 072/108] KVM: TDX: restore user ret MSRs
Date:   Sat, 29 Oct 2022 23:23:13 -0700
Message-Id: <3260994f3d9a036795c81bf06842558afabeeef7.1667110240.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667110240.git.isaku.yamahata@intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Several user ret MSRs are clobbered on TD exit.  Restore those values on
TD exit and before returning to ring 3.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3ec465cbaeef..f35ccf2b502d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -456,6 +456,28 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -495,6 +517,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
+	tdx_user_return_update_cache();
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
@@ -1558,6 +1581,26 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 		return -ENODEV;
 	}
 
+	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
+		/*
+		 * Here it checks if MSRs (tdx_uret_msrs) can be saved/restored
+		 * before returning to user space.
+		 *
+		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
+		 * because the registration is done at vcpu runtime by
+		 * kvm_set_user_return_msr().
+		 * Here is setting up cpu feature before running vcpu,
+		 * registered is alreays false.
+		 */
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

