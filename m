Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8A35714310
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjE2E2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbjE2E1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:27:43 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ACE10F0;
        Sun, 28 May 2023 21:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334287; x=1716870287;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0mJ7xBQVzUlFefiTXVK7xQ82iPCF8zX6iU2Owo9ogIk=;
  b=WPTSRMLTaUNN0RxSdgxZJl0JDuXBWKAX75nTu5pXrJgznnlNEVdvbAdp
   2ZwL9Ge9LWwZQ5YIVpqczHLqLjRNaf0nil/sUgz79EMRhFNe7ZAxLhLBI
   z1YiVKLdPvUvsZpIcUFmTV8BlNxVtc1nevWW6at5Nsp7Kpn++6sGI7ENM
   YhCF9qh3KVCBYgpXVfjRetnsrrlhh4231DT69zaQRXGvClbhx0Zb/ezlp
   5CciO53DHoY9KEthSjGj6V9k5BCFNGpREzjV4xQJxUGB0eqP/Jx6H2Vcs
   hS3CI+bahujhIdWdBO8+Dscxua7VrA88mOBZAYK9A8s95mTZJV7mu44LF
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966140"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966140"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784422"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784422"
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
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 067/113] KVM: TDX: restore user ret MSRs
Date:   Sun, 28 May 2023 21:19:49 -0700
Message-Id: <4e265b08510bd20481e7ae910f3dbe3f267132ac.1685333728.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Several user ret MSRs are clobbered on TD exit.  Restore those values on
TD exit and before returning to ring 3.  Because TSX_CTRL requires special
treat, this patch doesn't address it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/tdx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2e76671dabcc..5b5c68a1ece4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -484,6 +484,28 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	 */
 }
 
+struct tdx_uret_msr {
+	u32 msr;
+	unsigned int slot;
+	u64 defval;
+};
+
+static struct tdx_uret_msr tdx_uret_msrs[] = {
+	{.msr = MSR_SYSCALL_MASK, .defval = 0x20200 },
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
@@ -525,6 +547,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(vcpu, tdx);
 
+	tdx_user_return_update_cache();
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
@@ -1651,6 +1674,26 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
 		return -EINVAL;
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
+		 * registered is already false.
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

