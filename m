Return-Path: <kvm+bounces-14127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E1CD789F9FF
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 16:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9896D1F24EAD
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 14:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6C116F0FA;
	Wed, 10 Apr 2024 14:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m1zFH6LA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2736016F0EB;
	Wed, 10 Apr 2024 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712759741; cv=none; b=DmUSli3ui5wH1SV2t9IClqe7/T9HcdD+XEhKp6UvNZwRum3f+wtKTnRRMk5BbINCvUvTYNFJekof0gi/5Stvm4EF+sOBdcNNN2t+/ZqnflnrsLj2uLtKUdYl2aUoJGFY/r4RbAF2LFNdcIfN/UAxyM4E66s6wa3WafzUaQRSFgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712759741; c=relaxed/simple;
	bh=5il9OHilAi2ANaGv1ruKuj5PaBc3F8Q+mi5GQ5Db0nw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QlZ2b8Ap7rrgAv4tzCaZug7S2o8T4nfnnRILtbmIaU8bOsRcCOxoNd0lExjXWibdcyXQOCmEDohklbCRv9j/bmG/rsspwv+v1HBSpGHnyUdnQoBpc3Pdms6C4tHlIOwJ7WweHjBhmBVw2qmT8UBX7d8HlYlRlhOW2edwRMvJn1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m1zFH6LA; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712759740; x=1744295740;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5il9OHilAi2ANaGv1ruKuj5PaBc3F8Q+mi5GQ5Db0nw=;
  b=m1zFH6LAVERRKLqJIXTlyaFIm729dwYM918lw/FLDjiI3EVs5cNaDObF
   JQS3SWA1SL7DvjjwSHQ9KXvzTJTaDHeejL10dx0wnYFNI1jJnVKe/rulo
   V6+2gjyDTDy9Cs4wJjP9m/LyQYK7eyPk63gQYMntIQruL9s5KG3Iga7Jb
   YOJfCorr4AbiCEw6HENAN1Sagfaku6YodlVDWZDpoGqdE7Yy0mC+lM9VR
   tQcgyhrO4bn0Z9lsHwdJp4+mBvYdEjIJHaxC6pRXOxobFpsYn7jsP8BTw
   5ATJelK2yC+wXxQfKTWo0eVHriSS0w2JJs8EAQmTAPoM+SGkvKnX5hrE4
   Q==;
X-CSE-ConnectionGUID: X/O/8AZKRmabWeR+IF7WHg==
X-CSE-MsgGUID: 1ZcOLAAUS0ehEXrkdchdWw==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="18837800"
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="18837800"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:40 -0700
X-CSE-ConnectionGUID: uErwFPCnTzue+YRZHA60Zg==
X-CSE-MsgGUID: N5S1ITokTmK7h5lrgqyJDQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,190,1708416000"; 
   d="scan'208";a="25095505"
Received: from unknown (HELO spr.sh.intel.com) ([10.239.53.118])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 07:35:35 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: daniel.sneddon@linux.intel.com,
	pawan.kumar.gupta@linux.intel.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sandipan Das <sandipan.das@amd.com>
Subject: [RFC PATCH v3 05/10] x86/bugs: Use Virtual MSRs to request RRSBA_DIS_S
Date: Wed, 10 Apr 2024 22:34:33 +0800
Message-Id: <20240410143446.797262-6-chao.gao@intel.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20240410143446.797262-1-chao.gao@intel.com>
References: <20240410143446.797262-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

On CPUs with RRSBA behavior a guest using retpoline mitigation could
become vulnerable to BHI. On such CPUs, when RSB underflows a RET could
take prediction from BTB. Although these predictions are limited to same
domain, they may be controllable from userspace using BHI.

Alderlake and newer CPUs have RRSBA_DIS_S knob in MSR_SPEC_CTRL to
disable RRSBA behavior. A guest migrating from older CPU may not be
aware of RRSBA_DIS_S. Use MSR_VIRTUAL_MITIGATION_CTRL to request VMM to
deploy RRSBA_DIS_S when retpoline mitigation is in use.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/include/asm/msr-index.h | 6 ++++++
 arch/x86/kernel/cpu/bugs.c       | 7 +++++++
 2 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 18a4081bf5cb..469ab38c0ec8 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1188,6 +1188,7 @@
 
 #define MSR_VIRTUAL_MITIGATION_ENUM		0x50000001
 #define MITI_ENUM_BHB_CLEAR_SEQ_S_SUPPORT	BIT(0)	/* VMM supports BHI_DIS_S */
+#define MITI_ENUM_RETPOLINE_S_SUPPORT		BIT(1)	/* VMM supports RRSBA_DIS_S */
 
 #define MSR_VIRTUAL_MITIGATION_CTRL		0x50000002
 #define MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT	0	/*
@@ -1195,6 +1196,11 @@
 							 * BHI_DIS_S mitigation
 							 */
 #define MITI_CTRL_BHB_CLEAR_SEQ_S_USED		BIT(MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT)
+#define MITI_CTRL_RETPOLINE_S_USED_BIT		1	/*
+							 * Request VMM to deploy
+							 * RRSBA_DIS_S mitigation
+							 */
+#define MITI_CTRL_RETPOLINE_S_USED		BIT(MITI_CTRL_RETPOLINE_S_USED_BIT)
 
 /* AMD-V MSRs */
 #define MSR_VM_CR                       0xc0010114
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index e74e4c51d387..766f4340eddf 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1704,6 +1704,13 @@ void virt_mitigation_ctrl_init(void)
 		else
 			msr_clear_bit(MSR_VIRTUAL_MITIGATION_CTRL, MITI_CTRL_BHB_CLEAR_SEQ_S_USED_BIT);
 	}
+	if (msr_mitigation_enum & MITI_ENUM_RETPOLINE_S_SUPPORT) {
+		/* When retpoline is being used, request RRSBA_DIS_S */
+		if (boot_cpu_has(X86_FEATURE_RETPOLINE))
+			msr_set_bit(MSR_VIRTUAL_MITIGATION_CTRL, MITI_CTRL_RETPOLINE_S_USED_BIT);
+		else
+			msr_clear_bit(MSR_VIRTUAL_MITIGATION_CTRL, MITI_CTRL_RETPOLINE_S_USED_BIT);
+	}
 }
 
 static void __init spectre_v2_select_mitigation(void)
-- 
2.39.3


