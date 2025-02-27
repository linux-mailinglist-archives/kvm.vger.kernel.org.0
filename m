Return-Path: <kvm+bounces-39453-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BCB3A470F0
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:24:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF7EE7A5176
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FC3A1B3952;
	Thu, 27 Feb 2025 01:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j+HpiFm6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FFF1B21B4;
	Thu, 27 Feb 2025 01:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619180; cv=none; b=iu1dlNHK2AFi9RMKTW71VIsL5s93intz+BE2p1EoI43Y4YzgzKg1vXNjE+vCY5yQAcXFfsj46JT3+2wSCxnOfToqx3Uxt9NqPLYZxAhecawXKKY5CvTtAo/9O1kMCNb1GptM0E35zPWBW4g3AB15g30hquQWyZxnGTVTrHaHj/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619180; c=relaxed/simple;
	bh=pVYU29wbge2aVLiMpQm4eg0isUm9O54M4ws6Q27APC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xlz/nDuZnv9i/UIXOU0Ujjs5EAE2vOQkr1iaRiOfIm7ik0MMP8RhK3GKFk6lMrReA2MTwXVC/lpxxofihzdJxDmF3K1Qrxly9qF5cAgdi5DbTZCy9WMNRGhZ5Lav2KSvL91ZIa9yF9qyYkZmgb1BMkp0eKNRm467SN8DRu3qBvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j+HpiFm6; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619179; x=1772155179;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pVYU29wbge2aVLiMpQm4eg0isUm9O54M4ws6Q27APC8=;
  b=j+HpiFm6L317UN6Sc06JUZgSliK5eu1k0Ca3351Xgp0X1GENYTR3ZNfR
   13YidBTLx2ItiJ/PS7drsAJRSHi+OB70f9s/YHvhkIZGajvZYbLl0aQIX
   dVz2Lm3jy4OZhOd/P1LwmF2ucqOP4CNYqjG7lOxlf4Kd5wgMjklpeJ1Ka
   YREGhEea3ueYo33LDLzWOQTsDxlw0zvs5ninxNUi+bk3ef7sYWmn1h4Ki
   IQA2uYP4KX65netuEhiuhB1yVQlztkIMXqMr9zmotBniqYeo33MI3Q9Vb
   C4rDM84MeooNE0erCejjsIJ9e1NB7e9nX98Yr7aEPwX2jSyZsu23d5x2d
   w==;
X-CSE-ConnectionGUID: 2D1yOiLIQza/HQ10SWXJYw==
X-CSE-MsgGUID: LfslKYtDSMOjGcWXU1d6fw==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959667"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959667"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:39 -0800
X-CSE-ConnectionGUID: DuHM7DIRS9yW1xpL5/TXvQ==
X-CSE-MsgGUID: PM5BR6GrQOqJNSmSQQdX7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674920"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:35 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 15/20] KVM: TDX: Add methods to ignore accesses to TSC
Date: Thu, 27 Feb 2025 09:20:16 +0800
Message-ID: <20250227012021.1778144-16-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
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
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- No change.

TDX "the rest" v1:
- Dropped KVM_BUG_ON() in vt_get_l2_tsc_offset(). (Rick)
---
 arch/x86/kvm/vmx/main.c | 44 +++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 75e7fef7914e..554975f053ff 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -786,6 +786,42 @@ static int vt_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 	return vmx_set_identity_map_addr(kvm, ident_addr);
 }
 
+static u64 vt_get_l2_tsc_offset(struct kvm_vcpu *vcpu)
+{
+	/* TDX doesn't support L2 guest at the moment. */
+	if (is_td_vcpu(vcpu))
+		return 0;
+
+	return vmx_get_l2_tsc_offset(vcpu);
+}
+
+static u64 vt_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu)
+{
+	/* TDX doesn't support L2 guest at the moment. */
+	if (is_td_vcpu(vcpu))
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
 #ifdef CONFIG_X86_64
 static int vt_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 			      bool *expired)
@@ -944,10 +980,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
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
2.46.0


