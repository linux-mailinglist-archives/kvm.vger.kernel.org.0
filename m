Return-Path: <kvm+bounces-6626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 672788377EF
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E89D1F23E97
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C198560DEE;
	Mon, 22 Jan 2024 23:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bbgcwRJA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6161B60893;
	Mon, 22 Jan 2024 23:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967742; cv=none; b=AQxim8nPri66vycZs2Rt5YknIVylJqZyAbw3hdahY2k2AHtu8ZiBq2fmQgbS6T0Ssy7moim6fCu++KW08Au//PC8zXvYgzrGVuErqkcasjVCKU+TX2R0of3rJZJK006JnFw2Z4cTq+DTgmqjNn9wGEgur8xZQV82u66QGOU4wkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967742; c=relaxed/simple;
	bh=dUE8DxTtpIopl2l29eWxcZPjexOwf0PC7nhgiUfm1q4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CCZBmEpSsNmKHWy0CUwhiEcs2+3RVszNIhqNGmqXJIpG7Us7sMkpmVAIumSw2ki9N6MQKV+p3fo9/DZwVp7x/UlbleHF9GMRcIs3tNy8Y3KpI2ZOCxOAbe8cUjTRx5pUuNUjyPPw1Wjk6X7XZXHxCC+KYhMmBtmd24YtLBOLpUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bbgcwRJA; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967741; x=1737503741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dUE8DxTtpIopl2l29eWxcZPjexOwf0PC7nhgiUfm1q4=;
  b=bbgcwRJATmbV/+pgqJPws9U4wQQgl5tpUuoGWn8XA+ITfi0TLvO3/pHm
   BAbNuUgCc+PfwEtnH6lY+lxXRyOkX56Xyr61iwtbQVJzzh4RfvYikAoQB
   KXR+ILVqE5x7B0OYQUwwD9f9AecpQ2TvceATO+cL8b1A/YVYugGnpzMuC
   9Vjf50MTcPLHCNOt0v03AyjVjAiIbh8EY7wbcXjdChH/EM9hZEN8BQQQX
   bFJBXZcDbslI5eWPF8a590zuGZXSE0fOdFTpcdDlBAftbQF2TnQ6vakk6
   YWYdxuzQVZv2JLpK6mikVx1wGbDeKsDDZDXatje4es8uHF72HU6uT67JE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217740"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217740"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27817890"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:40 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v18 071/121] KVM: TDX: restore user ret MSRs
Date: Mon, 22 Jan 2024 15:53:47 -0800
Message-Id: <65e96a61c497c78b41fa670e20fbeb3593f56bfe.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index fe818cfde9e7..4685ff6aa5f8 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -585,6 +585,28 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
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
@@ -677,6 +699,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	tdx_vcpu_enter_exit(tdx);
 
+	tdx_user_return_update_cache();
 	tdx_restore_host_xsave_state(vcpu);
 	tdx->host_state_need_restore = true;
 
@@ -1936,6 +1959,26 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
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


