Return-Path: <kvm+bounces-31577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E3269C4FB6
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:43:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1C3501F27337
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 07:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75CB121262B;
	Tue, 12 Nov 2024 07:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I3tVCzXO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE2720B807;
	Tue, 12 Nov 2024 07:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731397192; cv=none; b=DwJkmn3LSLQ0vCt0/IPnbnP/9j2SWZW2qRFJwCRctJ3uBOjOoajX+KCXnUNhG4AKjFd//gw8Jej7+gnpmaepk8/bOmQRddLUIdr/WV2Yy+RvH+qmHsOe9W+Gt8Aaj/6kHH3b3NMwXIVq/QTO988x9dy/6OMO3iZ7WhIWhYEmjpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731397192; c=relaxed/simple;
	bh=UG5Ify1ngckIVJ9ozXP8b7ZYwtgvy0VLcrhVx+XnxfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWdELj+RhMFGTUIkaxyQat5mMDiilQY4F8/ylTITpyAjwSXFHabKZmt777uzwvCKmqBEO7H5YEgx97Y2g8Ccg2pxoRknVH2RwZs9V1Vyjs6xBe01iA6YGwtE6P4rWno7kEfLBHGryQ76vBQJwCN9CDgabctaAEF+7KPSQy53Meg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I3tVCzXO; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731397191; x=1762933191;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UG5Ify1ngckIVJ9ozXP8b7ZYwtgvy0VLcrhVx+XnxfY=;
  b=I3tVCzXOK3Qb3e1PWxe48sK7WvYbPvMY8OAL0JGk7DlfiBCDnBVpyVAA
   k30/5SlfriEdG4Ifo1wsT1p52pCsFFUAQBZMNthpEtYhj+uyJeP18+18c
   wnacf+CV0DsxYt88lc2LHf+sAQ5KWpYBBp4IbWPzFHZnjimBY6KeFDeFd
   tu7Jp/ZWzsHJL1p93lSurgEVFm9gZRQzA+o2WhFekVIYgc26ho3RpJMBm
   eNoObpHat4voBigW+XjB/CCwAUUNaMJUKtCFM9vpt9fIcLiTIBofFQXUt
   pzUCldwZI8jeQTvrkum3xaSMTRoJA/73hCgAZFT+GxMArFxh3+a8hNm2k
   Q==;
X-CSE-ConnectionGUID: Evq5/bccTgyXME2CW+XmwQ==
X-CSE-MsgGUID: zOpew0D1TK6IVI6YkTfEGA==
X-IronPort-AV: E=McAfee;i="6700,10204,11253"; a="31311359"
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="31311359"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:39:51 -0800
X-CSE-ConnectionGUID: HQlcwpURR3CEYzXUos1FiQ==
X-CSE-MsgGUID: 84t+DI5kQ6Sl6U0bQYdqPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="124830472"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2024 23:39:47 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	nik.borisov@suse.com,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 14/24] KVM: TDX: Require TDP MMU and mmio caching for TDX
Date: Tue, 12 Nov 2024 15:37:20 +0800
Message-ID: <20241112073720.22186-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20241112073327.21979-1-yan.y.zhao@intel.com>
References: <20241112073327.21979-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Disable TDX support when TDP MMU or mmio caching aren't supported.

As TDP MMU is becoming main stream than the legacy MMU, the legacy MMU
support for TDX isn't implemented.

TDX requires KVM mmio caching. Without mmio caching, KVM will go to MMIO
emulation without installing SPTEs for MMIOs. However, TDX guest is
protected and KVM would meet errors when trying to emulate MMIOs for TDX
guest during instruction decoding. So, TDX guest relies on SPTEs being
installed for MMIOs, which are with no RWX bits and with VE suppress bit
unset, to inject VE to TDX guest. The TDX guest would then issue TDVMCALL
in the VE handler to perform instruction decoding and have host do MMIO
emulation.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX MMU part 2 v2:
 - Added Paolo's rb.

TDX MMU part 2 v1:
 - Addressed Binbin's comment by massaging Isaku's updated comments and
   adding more explanations about instroducing mmio caching.
 - Addressed Sean's comments of v19 according to Isaku's update but
   kept the warning for MOVDIR64B.
 - Move code change in tdx_hardware_setup() to __tdx_bringup() since the
   former has been removed.
---
 arch/x86/kvm/mmu/mmu.c  | 1 +
 arch/x86/kvm/vmx/main.c | 1 +
 arch/x86/kvm/vmx/tdx.c  | 8 +++-----
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3a338df541c1..e2f75c8145fd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -110,6 +110,7 @@ static bool __ro_after_init tdp_mmu_allowed;
 #ifdef CONFIG_X86_64
 bool __read_mostly tdp_mmu_enabled = true;
 module_param_named(tdp_mmu, tdp_mmu_enabled, bool, 0444);
+EXPORT_SYMBOL_GPL(tdp_mmu_enabled);
 #endif
 
 static int max_huge_page_level __read_mostly;
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 3c292b4a063a..a34c0bebe1c3 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -3,6 +3,7 @@
 
 #include "x86_ops.h"
 #include "vmx.h"
+#include "mmu.h"
 #include "nested.h"
 #include "pmu.h"
 #include "posted_intr.h"
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 38369cafc175..8832f76e4a22 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1412,16 +1412,14 @@ static int __init __tdx_bringup(void)
 	const struct tdx_sys_info_td_conf *td_conf;
 	int r;
 
+	if (!tdp_mmu_enabled || !enable_mmio_caching)
+		return -EOPNOTSUPP;
+
 	if (!cpu_feature_enabled(X86_FEATURE_MOVDIR64B)) {
 		pr_warn("MOVDIR64B is reqiured for TDX\n");
 		return -EOPNOTSUPP;
 	}
 
-	if (!enable_ept) {
-		pr_err("Cannot enable TDX with EPT disabled.\n");
-		return -EINVAL;
-	}
-
 	/*
 	 * Enabling TDX requires enabling hardware virtualization first,
 	 * as making SEAMCALLs requires CPU being in post-VMXON state.
-- 
2.43.2


