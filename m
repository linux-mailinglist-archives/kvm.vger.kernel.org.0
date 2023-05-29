Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9C8714312
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjE2E2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbjE2E1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:27:51 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577C71703;
        Sun, 28 May 2023 21:24:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334293; x=1716870293;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=LjWkX9F7REZVvnqNtpWOCBvIsIKlBV/YinSlFWZjBKQ=;
  b=JyAz0S5f3YzFw5oGY47Rary9ErUekLsWUZbP6JXX2k1yZXrV73bVjbJO
   byBKTx+ZYjOabHSmZftNY6jcoWUvtwxVAaBRRco/m6Kok8v5eL9j4IXZK
   +7loQj4KD1aiGuLMFM32r/A13K2LcXBDUqJao8yEWK283VsTImEc1zX3R
   zxCsTtgJBS8tOr95AEpmHA2diKh/HoIrSx4LNvyn01/V/u8nmcFSSmKi8
   KLjlbKDgb9BXgWj9w1fIfINAJtsXSAqFgjS/NoMNYo4nwftmhuhDM1Mdr
   CcxXE57fqjIAvR0nNhooi4Uq3QftcRU7VMpRFzOQenA6n3VBzhM7B+Z2s
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966147"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966147"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784428"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784428"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:26 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        Yang Weijiang <weijiang.yang@intel.com>
Subject: [PATCH v14 068/113] KVM: TDX: Add TSX_CTRL msr into uret_msrs list
Date:   Sun, 28 May 2023 21:19:50 -0700
Message-Id: <df3e1aaf9a3cc28f7e237905b63be7613aac4400.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yang Weijiang <weijiang.yang@intel.com>

TDX module resets the TSX_CTRL MSR to 0 at TD exit if TSX is enabled for
TD. Or it preserves the TSX_CTRL MSR if TSX is disabled for TD.  VMM can
rely on uret_msrs mechanism to defer the reload of host value until exiting
to user space.

Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 35 +++++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h |  8 ++++++++
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5b5c68a1ece4..29aa53d530ca 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -496,14 +496,21 @@ static struct tdx_uret_msr tdx_uret_msrs[] = {
 	{.msr = MSR_LSTAR,},
 	{.msr = MSR_TSC_AUX,},
 };
+static unsigned int tdx_uret_tsx_ctrl_slot;
 
-static void tdx_user_return_update_cache(void)
+static void tdx_user_return_update_cache(struct kvm_vcpu *vcpu)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
 		kvm_user_return_update_cache(tdx_uret_msrs[i].slot,
 					     tdx_uret_msrs[i].defval);
+	/*
+	 * TSX_CTRL is reset to 0 if guest TSX is supported. Otherwise
+	 * preserved.
+	 */
+	if (to_kvm_tdx(vcpu->kvm)->tsx_supported)
+		kvm_user_return_update_cache(tdx_uret_tsx_ctrl_slot, 0);
 }
 
 static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
@@ -547,7 +554,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
-	tdx_user_return_update_cache();
+	tdx_user_return_update_cache(vcpu);
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
@@ -1021,6 +1028,24 @@ static int setup_tdparams_xfam(struct kvm_cpuid2 *cpuid, struct td_params *td_pa
 	return 0;
 }
 
+static bool tdparams_tsx_supported(struct kvm_cpuid2 *cpuid)
+{
+	const struct kvm_cpuid_entry2 *entry;
+	u64 mask;
+	u32 ebx;
+
+	entry = kvm_find_cpuid_entry2(cpuid, 0x7, 0);
+	if (entry)
+		ebx = entry->ebx;
+	else
+		ebx = 0;
+
+	mask = __feature_bit(X86_FEATURE_HLE) | __feature_bit(X86_FEATURE_RTM);
+	if (ebx & mask)
+		return true;
+	return false;
+}
+
 static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 			struct kvm_tdx_init_vm *init_vm)
 {
@@ -1064,6 +1089,7 @@ static int setup_tdparams(struct kvm *kvm, struct td_params *td_params,
 	MEMCPY_SAME_SIZE(td_params->mrowner, init_vm->mrowner);
 	MEMCPY_SAME_SIZE(td_params->mrownerconfig, init_vm->mrownerconfig);
 
+	to_kvm_tdx(kvm)->tsx_supported = tdparams_tsx_supported(cpuid);
 	return 0;
 }
 
@@ -1693,6 +1719,11 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 			return -EIO;
 		}
 	}
+	tdx_uret_tsx_ctrl_slot = kvm_find_user_return_msr(MSR_IA32_TSX_CTRL);
+	if (WARN_ON_ONCE(tdx_uret_tsx_ctrl_slot == -1)) {
+		pr_err("MSR_IA32_TSX_CTRL isn't included by kvm_find_user_return_msr\n");
+		return -EIO;
+	}
 
 	max_pkgs = topology_max_packages();
 	tdx_mng_key_config_lock = kcalloc(max_pkgs, sizeof(*tdx_mng_key_config_lock),
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index cd50d366b7ee..6ce362c70e26 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -17,6 +17,14 @@ struct kvm_tdx {
 	u64 xfam;
 	int hkid;
 
+	/*
+	 * Used on each TD-exit, see tdx_user_return_update_cache().
+	 * TSX_CTRL value on TD exit
+	 * - set 0     if guest TSX enabled
+	 * - preserved if guest TSX disabled
+	 */
+	u64 tsx_supported;
+
 	hpa_t source_pa;
 
 	bool finalized;
-- 
2.25.1

