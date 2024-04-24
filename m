Return-Path: <kvm+bounces-15856-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00DD28B11D3
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 20:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2ED128455E
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 18:15:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9481316E869;
	Wed, 24 Apr 2024 18:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VT/bioXR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A57A16D9DE;
	Wed, 24 Apr 2024 18:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713982489; cv=none; b=S+sQv/c8BuhGYbsRWk1cHmUwYB7SOGr4shr9ZbxxR0OtpTKeK+u1P6Evd5PhMuhprbzDYx+V3QVNYrhVCsZrAsRjHkiG0aqEvwGuwST+HDbxAdzXSVtq5pwwdgDzpLi700KiX1Kt0cm7XfCxLZBLmY9pE60YrxsEJwlCBO5BPmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713982489; c=relaxed/simple;
	bh=kkF0kOmubRaABW0Hf14QsZUk5Z9XWIfvaI1+06NWDic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvGXdUGon7srow/BJ9ONwhHD46OZ2VC0Fo66rHDUG2ywPqY4Axy/uD7Io4paJIqRWZG9gq10sNpRYBvWldAY5awQ128Vh5PMRZVj/7hWn8DLty2lTv2NVyPpdbNWTC7pCPBfcl92yopuy1cVz+Fd9FwZM+IcelpY0vBwY/t6h6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VT/bioXR; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713982488; x=1745518488;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kkF0kOmubRaABW0Hf14QsZUk5Z9XWIfvaI1+06NWDic=;
  b=VT/bioXRfEpqWYyn8QbY6SY5XgZlTbkDuNok+q/MDdgwbn+zxovExB08
   l3xWnAEcDxDHLMGe2ho65VLUij47MUR2QbT6CXf4GB89VvFyLviE85bjH
   7xbSCHDXuRD1+BVdM0Sp3HyJ/7+4hbn49auGFUrzJw2dRUAgeI2+Ga4wf
   gd4yyXlA4tt0gkPY63B6IT5DRrfTOdPKQFPLSDYYWUsmW5IKt65zQnFTZ
   WKIYs+ONXPShIYZ7Rjo731rBcgzSSPcSRfPqFfUbVRnFZ9AND6F7MPKuy
   KyyoLpdo0dAWMgg7gjZ/Tn/lPLIoDpQP94P7C+/4gNz65zp+CJvmPvKMB
   g==;
X-CSE-ConnectionGUID: Qg8ZnJioQYafVr9/be98aA==
X-CSE-MsgGUID: gpsBp6dvTlOB1dQkNH1QdQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11054"; a="9503378"
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="9503378"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:47 -0700
X-CSE-ConnectionGUID: yRuNC9RIQPOiq37fhZbzPg==
X-CSE-MsgGUID: z01KKwbxTIKkzN3BFVKWSQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,226,1708416000"; 
   d="scan'208";a="24683658"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2024 11:14:47 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v4 03/71] KVM: x86/pmu: Switch to new Intel CPU model defines
Date: Wed, 24 Apr 2024 11:14:46 -0700
Message-ID: <20240424181446.41212-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240424181245.41141-1-tony.luck@intel.com>
References: <20240424181245.41141-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New CPU #defines encode vendor and family as well as model.

Signed-off-by: Tony Luck <tony.luck@intel.com>
Acked-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index c397b28e3d1b..2faa67a4bfb6 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -34,16 +34,16 @@ EXPORT_SYMBOL_GPL(kvm_pmu_eventsel);
 
 /* Precise Distribution of Instructions Retired (PDIR) */
 static const struct x86_cpu_id vmx_pebs_pdir_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
-	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_D, NULL),
+	X86_MATCH_VFM(INTEL_ICELAKE_X, NULL),
 	/* Instruction-Accurate PDIR (PDIR++) */
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, NULL),
 	{}
 };
 
 /* Precise Distribution (PDist) */
 static const struct x86_cpu_id vmx_pebs_pdist_cpu[] = {
-	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_VFM(INTEL_SAPPHIRERAPIDS_X, NULL),
 	{}
 };
 
-- 
2.44.0


