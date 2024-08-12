Return-Path: <kvm+bounces-23905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FBC594F9E8
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3BE4B22677
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:52:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98E919EEAF;
	Mon, 12 Aug 2024 22:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TrELjjbz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9297919DF43;
	Mon, 12 Aug 2024 22:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502920; cv=none; b=MzOfdj8g2Ho1OkOy7LYNrw+WydTAUTQZ4ootbuw7D/48tNejm/bf3qtyXWZZK0WZC9mI15a20I8wE4OpWaANPPR8R14X081RG6w/YQp6O7ruKyxnjJHal3AwbryiieGXkN4j8aVk1nEH9wmExi46dwCeFPAUxLxDQLva99IXSRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502920; c=relaxed/simple;
	bh=faCFeMnLwdeP2y5ciEHpYYg4AEHUQfDTUSGo11ATEJ0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JibsbbYc1K3oMDmeutiw3N5vE8XJ1Z5W6CJLLAxSSozWdiFcLSlTGuKa04Vi+2XdNtFQjpK3G7iCMGMhnclENjV1OILC0B+T/Yr5xki1ZJV2VWWrs95K8nQ/wC4bXBI5qT8FjaAIpK1PYBz+jyfmCdfEH2abCKUpMBvFTp8Se2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TrELjjbz; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502918; x=1755038918;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=faCFeMnLwdeP2y5ciEHpYYg4AEHUQfDTUSGo11ATEJ0=;
  b=TrELjjbzVsM2u0sW4JqD42GHkCpfS2pqzgUbYSTCPlbVxnntKXdrDIzT
   PAyjGgfCifuuLU7HZLLGLKqLFLfWSe6a6W2jM5DaA1H2G4RSLn4OfUy81
   eeR+x0IDbVoOdBMBD97VDtUULOvjbYhCB2FNxMkDxee23d+HqFoNOP+pZ
   wAc746gWMD1sG2H8bxLYJ/av2KBZ7MOIS2NdkBVNO8H1fr4h7yM+hQraQ
   Dww5h4+3rDu/lCuS4AKr8l/y7b9nZb9CBOpKK1/nVa02KHP66+irTAGCa
   Pt7CbAWzrro+nP/W+9NCAgJNZDH/AX9SSuKs8m0iED3cKzctNdofnrRNv
   Q==;
X-CSE-ConnectionGUID: YcyvFwqtRiG2sHxycpnmZQ==
X-CSE-MsgGUID: ls5FUr7NTg2Eysiv1C4big==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041399"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041399"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:32 -0700
X-CSE-ConnectionGUID: b1TW5PqMQb6h3fcfEeKgAQ==
X-CSE-MsgGUID: +m02pT79TNWrJq3KcWwAZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008401"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:32 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com
Subject: [PATCH 11/25] KVM: TDX: Report kvm_tdx_caps in KVM_TDX_CAPABILITIES
Date: Mon, 12 Aug 2024 15:48:06 -0700
Message-Id: <20240812224820.34826-12-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

Report raw capabilities of TDX module to userspace isn't so useful
and incorrect, because some of the capabilities might not be supported
by KVM.

Instead, report the KVM capp'ed capbilities to userspace.

Removed the supported_gpaw field. Because CPUID.0x80000008.EAX[23:16] of
KVM_SUPPORTED_CPUID enumerates the 5 level EPT support, i.e., if GPAW52
is supported or not. Note, GPAW48 should be always supported. Thus no
need for explicit enumeration.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - Code change due to previous patches changed to use exported 'struct
   tdx_sysinfo' pointer.
---
 arch/x86/include/uapi/asm/kvm.h | 14 +++----------
 arch/x86/kvm/vmx/tdx.c          | 36 ++++++++-------------------------
 2 files changed, 11 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index c9eb2e2f5559..2e3caa5a58fd 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -961,18 +961,10 @@ struct kvm_tdx_cpuid_config {
 	__u32 edx;
 };
 
-/* supported_gpaw */
-#define TDX_CAP_GPAW_48	(1 << 0)
-#define TDX_CAP_GPAW_52	(1 << 1)
-
 struct kvm_tdx_capabilities {
-	__u64 attrs_fixed0;
-	__u64 attrs_fixed1;
-	__u64 xfam_fixed0;
-	__u64 xfam_fixed1;
-	__u32 supported_gpaw;
-	__u32 padding;
-	__u64 reserved[251];
+	__u64 supported_attrs;
+	__u64 supported_xfam;
+	__u64 reserved[254];
 
 	__u32 nr_cpuid_configs;
 	struct kvm_tdx_cpuid_config cpuid_configs[];
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d89973e554f6..f9faec217ea9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -49,7 +49,7 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
 	struct kvm_tdx_capabilities __user *user_caps;
 	struct kvm_tdx_capabilities *caps = NULL;
-	int i, ret = 0;
+	int ret = 0;
 
 	/* flags is reserved for future use */
 	if (cmd->flags)
@@ -70,39 +70,19 @@ static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 		goto out;
 	}
 
-	*caps = (struct kvm_tdx_capabilities) {
-		.attrs_fixed0 = td_conf->attributes_fixed0,
-		.attrs_fixed1 = td_conf->attributes_fixed1,
-		.xfam_fixed0 = td_conf->xfam_fixed0,
-		.xfam_fixed1 = td_conf->xfam_fixed1,
-		.supported_gpaw = TDX_CAP_GPAW_48 |
-		((kvm_host.maxphyaddr >= 52 &&
-		  cpu_has_vmx_ept_5levels()) ? TDX_CAP_GPAW_52 : 0),
-		.nr_cpuid_configs = td_conf->num_cpuid_config,
-		.padding = 0,
-	};
+	caps->supported_attrs = kvm_tdx_caps->supported_attrs;
+	caps->supported_xfam = kvm_tdx_caps->supported_xfam;
+	caps->nr_cpuid_configs = kvm_tdx_caps->num_cpuid_config;
 
 	if (copy_to_user(user_caps, caps, sizeof(*caps))) {
 		ret = -EFAULT;
 		goto out;
 	}
 
-	for (i = 0; i < td_conf->num_cpuid_config; i++) {
-		struct kvm_tdx_cpuid_config cpuid_config = {
-			.leaf = (u32)td_conf->cpuid_config_leaves[i],
-			.sub_leaf = td_conf->cpuid_config_leaves[i] >> 32,
-			.eax = (u32)td_conf->cpuid_config_values[i].eax_ebx,
-			.ebx = td_conf->cpuid_config_values[i].eax_ebx >> 32,
-			.ecx = (u32)td_conf->cpuid_config_values[i].ecx_edx,
-			.edx = td_conf->cpuid_config_values[i].ecx_edx >> 32,
-		};
-
-		if (copy_to_user(&(user_caps->cpuid_configs[i]), &cpuid_config,
-					sizeof(struct kvm_tdx_cpuid_config))) {
-			ret = -EFAULT;
-			break;
-		}
-	}
+	if (copy_to_user(user_caps->cpuid_configs, &kvm_tdx_caps->cpuid_configs,
+			 kvm_tdx_caps->num_cpuid_config *
+			 sizeof(kvm_tdx_caps->cpuid_configs[0])))
+		ret = -EFAULT;
 
 out:
 	/* kfree() accepts NULL. */
-- 
2.34.1


