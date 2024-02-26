Return-Path: <kvm+bounces-9747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A58A866DAE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:08:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD5D11C236CE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:08:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F31112FB05;
	Mon, 26 Feb 2024 08:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hSLTQWfo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (unknown [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E591912EBC9;
	Mon, 26 Feb 2024 08:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936159; cv=none; b=SwR0F63Ihq7Yh44armnywC0qpynOCi1xgAM+BSEtSpgCuxw9hBWoew+VeOezOzPydgmJjXXEgo24tlcGGhr+NgshlL6FwPrJHCw7ynI0QH+AKy/Pu1r37p97TfiqPTb7jr4x3pokuIh5GcdPyTW/nEDl/k5vjC7KGNvgDGJ9MGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936159; c=relaxed/simple;
	bh=m7n7i1eS4On2R241lFqJmq0+vkwcQBjfN5ADiMO6W+o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JiuN+Fyf2t/OP9h62xhwW7pBUy55Akea2xDSp/VJfZDF66hxaA1Mf7IqIp9DKhQgC6MsNj8Zn1A3NgWzHdNMDaQKJMTd7Q7hzqj8B7qJ9R83v1UT32rxX+zFvYlLwumxuafbPuDJbS8FGIY2XxQWtOOi62uPP1rdD9lAEEzD7Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hSLTQWfo; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936157; x=1740472157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m7n7i1eS4On2R241lFqJmq0+vkwcQBjfN5ADiMO6W+o=;
  b=hSLTQWfojQc90/ad0OUazIBxZqbpipGJT4vsEsZ3pmh5yvyf3Twyb8aN
   XC0kXtFBlrNdQgt0HUKxt/88To1/5Os85T3O8EhAZLbTbyTzGk7entFAC
   OgVbu1Cxk0QYcvRLMma6OYBFiLstzpVYAOibZU8m1gQTDYQp0575mUkIL
   CpZc9plHOR2oFxLWRwbsfXfrQX96rw+vrylrYqFLDEmL8nzK3svAdj9Yq
   Q4/v5ZY0TPjlWlGcx+Zmn0WvwxlRmN6ASZZ4PwDmdsclI1sgUEYiWMxEM
   IhrKkzpnLNYoJlC2cNmaSsZVm6zzunUtoOSONzm7EcUCfj+yIjXCjJTRE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751396"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751396"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735128"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:10 -0800
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
Subject: [PATCH v19 122/130] KVM: TDX: Add methods to ignore accesses to TSC
Date: Mon, 26 Feb 2024 00:27:04 -0800
Message-Id: <59ff42a2dd3769de6127fde30c9b2b355a1a4c17.1708933498.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1708933498.git.isaku.yamahata@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDX protects TDX guest TSC state from VMM.  Implement access methods to
ignore guest TSC.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 44 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ec5c0fda92e9..9fcd71999bba 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -834,6 +834,42 @@ static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	return vmx_get_mt_mask(vcpu, gfn, is_mmio);
 }
 
+static u64 vt_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	/* TDX doesn't support L2 guest at the moment. */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
+	return vmx_get_l2_tsc_offset(vcpu);
+}
+
+static u64 vt_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	/* TDX doesn't support L2 guest at the moment. */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return 0;
+
+	return vmx_get_l2_tsc_multiplier(vcpu);
+}
+
+static void vt_write_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	/* In TDX, tsc offset can't be changed. */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_write_tsc_offset(vcpu);
+}
+
+static void vt_write_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	/* In TDX, tsc multiplier can't be changed. */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_write_tsc_multiplier(vcpu);
+}
+
 static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 {
 	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
@@ -1022,10 +1058,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-	.get_l2_tsc_offset = vmx_get_l2_tsc_offset,
-	.get_l2_tsc_multiplier = vmx_get_l2_tsc_multiplier,
-	.write_tsc_offset = vmx_write_tsc_offset,
-	.write_tsc_multiplier = vmx_write_tsc_multiplier,
+	.get_l2_tsc_offset = vt_get_l2_tsc_offset,
+	.get_l2_tsc_multiplier = vt_get_l2_tsc_multiplier,
+	.write_tsc_offset = vt_write_tsc_offset,
+	.write_tsc_multiplier = vt_write_tsc_multiplier,
 
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
-- 
2.25.1


