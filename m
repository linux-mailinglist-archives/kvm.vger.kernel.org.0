Return-Path: <kvm+bounces-33358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58FD39EA3D4
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:50:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37207284BD6
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634DF1D61AF;
	Tue, 10 Dec 2024 00:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iUvAczlz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3AD1D5ADE;
	Tue, 10 Dec 2024 00:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791703; cv=none; b=Dfco3AlKeFUQ9Juj3LN6KNJVNUWXxpuK8Hmunc8yHiKKjWGZvNZY3nYXmbH4h6/zr8J1OBpBV0iAiWM+oWYP/p1ZEgNsZWMFkvTacLvXZI8FFCB0yo6shP8BkKVeh83g1TFUagYML0c3aFK5hRcTv2phAZ5lAj7M19yF817Unxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791703; c=relaxed/simple;
	bh=6TNcsdWCwMI7RV7T6/6/KVAHkwUaJrJW56PM6AigFd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pp36eXIHkvSAWhZ1AMeMvo8i7A7BQiVNikSOh5BLCounLPAGVU0QXy3KH5J+vi6QoGpxU9QC2m2ThVaucjkCbzV2Nk5ldSeWrw+UaCtHQ8CsqQaDb7yrpapAimKfYF59wUL1pD6poTazmnaHWnJO48yK+XE+NGSrsKv07hsS4XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iUvAczlz; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791702; x=1765327702;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6TNcsdWCwMI7RV7T6/6/KVAHkwUaJrJW56PM6AigFd0=;
  b=iUvAczlzJasnlL3yxaQ6B98ndtUTHhbJINsh17ZzB+NBT2QbgPUGAdMd
   I3IRq60Mte2dhSuYPO9PDzGXiHrkN6Kf9NOWlD31dDsvZ3jb8IaLpwSId
   I5ow7F9mcLKeg9PfqauXVYJvwc2ZIjy1sOkKl4IDT4rg04KjRgEGsHyLm
   T2VwMHa50d3JC1EDkG0FYVchrSLNKJQoynRBhPHZ9M8zM3cYNAkqkpkpW
   rwg+GxVzNZ7puvOFcfXc29KI0CZJw9uYSelEaYK6SuWlnYgrqAU5Fu/Y6
   /+K1uXfWDy9VF+TmEOzzoTwwwV131Yfo6JxR/kRBNf1AU7plSKhMXmNkC
   Q==;
X-CSE-ConnectionGUID: 1SIF906yTNyRkOnfKMYKSw==
X-CSE-MsgGUID: 3jkBUaviT0K6J6puXIqKug==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793725"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793725"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:21 -0800
X-CSE-ConnectionGUID: pWyvm5F1T4Synv+KNOgWxg==
X-CSE-MsgGUID: V1AerEyeTBOxunGO53/Yyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033050"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:18 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 09/18] KVM: TDX: Enable guest access to LMCE related MSRs
Date: Tue, 10 Dec 2024 08:49:35 +0800
Message-ID: <20241210004946.3718496-10-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Allow TDX guest to configure LMCE (Local Machine Check Event) by handling
MSR IA32_FEAT_CTL and IA32_MCG_EXT_CTL.

MCE and MCA are advertised via cpuid based on the TDX module spec.  Guest
kernel can access IA32_FEAT_CTL to check whether LMCE is opted-in by the
platform or not.  If LMCE is opted-in by the platform, guest kernel can
access IA32_MCG_EXT_CTL to enable/disable LMCE.

Handle MSR IA32_FEAT_CTL and IA32_MCG_EXT_CTL for TDX guests to avoid
failure when a guest accesses them with TDG.VP.VMCALL<MSR> on #VE.  E.g.,
Linux guest will treat the failure as a #GP(0).

Userspace VMM may not opt-in LMCE by default, e.g., QEMU disables it by
default, "-cpu lmce=on" is needed in QEMU command line to opt-in it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[binbin: rework changelog]
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" breakout:
- Renamed from "KVM: TDX: Handle MSR IA32_FEAT_CTL MSR and IA32_MCG_EXT_CTL"
  to "KVM: TDX: Enable guest access to LMCE related MSRs".
- Update changelog.
- Check reserved bits are not set when set MSR_IA32_MCG_EXT_CTL.
---
 arch/x86/kvm/vmx/tdx.c | 46 +++++++++++++++++++++++++++++++++---------
 1 file changed, 37 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d5343e2ba509..b5aae9d784f7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2036,6 +2036,7 @@ bool tdx_has_emulated_msr(u32 index)
 	case MSR_MISC_FEATURES_ENABLES:
 	case MSR_IA32_APICBASE:
 	case MSR_EFER:
+	case MSR_IA32_FEAT_CTL:
 	case MSR_IA32_MCG_CAP:
 	case MSR_IA32_MCG_STATUS:
 	case MSR_IA32_MCG_CTL:
@@ -2068,26 +2069,53 @@ bool tdx_has_emulated_msr(u32 index)
 
 static bool tdx_is_read_only_msr(u32 index)
 {
-	return  index == MSR_IA32_APICBASE || index == MSR_EFER;
+	return  index == MSR_IA32_APICBASE || index == MSR_EFER ||
+		index == MSR_IA32_FEAT_CTL;
 }
 
 int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
-	if (!tdx_has_emulated_msr(msr->index))
-		return 1;
+	switch (msr->index) {
+	case MSR_IA32_FEAT_CTL:
+		/*
+		 * MCE and MCA are advertised via cpuid. Guest kernel could
+		 * check if LMCE is enabled or not.
+		 */
+		msr->data = FEAT_CTL_LOCKED;
+		if (vcpu->arch.mcg_cap & MCG_LMCE_P)
+			msr->data |= FEAT_CTL_LMCE_ENABLED;
+		return 0;
+	case MSR_IA32_MCG_EXT_CTL:
+		if (!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P))
+			return 1;
+		msr->data = vcpu->arch.mcg_ext_ctl;
+		return 0;
+	default:
+		if (!tdx_has_emulated_msr(msr->index))
+			return 1;
 
-	return kvm_get_msr_common(vcpu, msr);
+		return kvm_get_msr_common(vcpu, msr);
+	}
 }
 
 int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 {
-	if (tdx_is_read_only_msr(msr->index))
-		return 1;
+	switch (msr->index) {
+	case MSR_IA32_MCG_EXT_CTL:
+		if ((!msr->host_initiated && !(vcpu->arch.mcg_cap & MCG_LMCE_P)) ||
+		    (msr->data & ~MCG_EXT_CTL_LMCE_EN))
+			return 1;
+		vcpu->arch.mcg_ext_ctl = msr->data;
+		return 0;
+	default:
+		if (tdx_is_read_only_msr(msr->index))
+			return 1;
 
-	if (!tdx_has_emulated_msr(msr->index))
-		return 1;
+		if (!tdx_has_emulated_msr(msr->index))
+			return 1;
 
-	return kvm_set_msr_common(vcpu, msr);
+		return kvm_set_msr_common(vcpu, msr);
+	}
 }
 
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
-- 
2.46.0


