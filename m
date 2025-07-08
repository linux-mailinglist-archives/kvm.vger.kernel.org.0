Return-Path: <kvm+bounces-51745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A4FE7AFC51A
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:11:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 409B87A20B7
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 08:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F7832BCF6F;
	Tue,  8 Jul 2025 08:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R6JKbm3z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245FD29E0F4;
	Tue,  8 Jul 2025 08:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751962273; cv=none; b=bWJCZbH8jPBZ/8Ak6C47QCSHeDIwolvcwhAIYEl8BeS61a+rA/HT1kUqcIvnLkpIHR9BLYHU9qasUNmpXSHyu/CG5XG9YFk4HussuhujSykhxqHPvsV92lKYGCMqli9azz0wpaaoVslmDFIOaLjNia47FZJjmdtcFaB4syWCLBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751962273; c=relaxed/simple;
	bh=2KBI/He/+9WaeB5e2qZq2toSVw6Z840hdBFA1BSC5CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvVOcNf9yM1EC7ZPeH9HVQw2NVG8WPrK9bKC/nCbgbrUzRh5gJanjs7bVkaZ0iDdWuIvly+giikKj6WmaYFVyfHW+PD+2ysU2srAZolmsHe3paYotNehBq84hW+vkaZ6zDp42HdhRHiXsCiQwK4GftXi8lS3IEAfRaZ8uZ75U5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R6JKbm3z; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751962272; x=1783498272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2KBI/He/+9WaeB5e2qZq2toSVw6Z840hdBFA1BSC5CI=;
  b=R6JKbm3zBizx+mbm+HduKZIZfOdzS7sBxuSvaO4nYCWnpDQqFXjMn970
   hoIGOQyyS+6M1wlminWaTiQc3RYD3jwd5Wax7DhbJy0hz59Wgn83T8dYE
   46tBbzZ8Uav8qAPaV9HFX/Ra6wenxAqlY5w1XJkF0R40Qe7RW8VC1p8IG
   SVZMZZB9ddFMjE6m/OwZaRhDBZwy6St/GiEztMyV8ABaXrCiOG8j7XduA
   oCT53IRPqQqW9IyVcD0dbEuTFogHbSdZiD+JUyyR/IyEDY7YXCzGRYSaB
   lxzBxX++Q81bUgoIh9JdPY46EMVusmC660g/0N8pcsLxdBz3FUbiRjdzz
   g==;
X-CSE-ConnectionGUID: eBpEiNJlTuqxuFujXe6J/w==
X-CSE-MsgGUID: MTmvZA1LSVma7U81HOfBuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="65543219"
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="65543219"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 01:11:11 -0700
X-CSE-ConnectionGUID: CpwIvPRvQW2/kfAwrIRbVg==
X-CSE-MsgGUID: HwxByaVjTrugqPCqFKxbVw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="161076600"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 Jul 2025 01:11:07 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	rick.p.edgecombe@intel.com,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com
Subject: [PATCH 1/2] x86/tdx: Fix the typo of TDX_ATTR_MIGRTABLE
Date: Tue,  8 Jul 2025 16:03:13 +0800
Message-ID: <20250708080314.43081-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250708080314.43081-1-xiaoyao.li@intel.com>
References: <20250708080314.43081-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the typo of TDX_ATTR_MIGRTABLE to TDX_ATTR_MIGRATABLE.

Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/coco/tdx/debug.c         | 2 +-
 arch/x86/include/asm/shared/tdx.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/coco/tdx/debug.c b/arch/x86/coco/tdx/debug.c
index cef847c8bb67..28990c2ab0a1 100644
--- a/arch/x86/coco/tdx/debug.c
+++ b/arch/x86/coco/tdx/debug.c
@@ -17,7 +17,7 @@ static __initdata const char *tdx_attributes[] = {
 	DEF_TDX_ATTR_NAME(ICSSD),
 	DEF_TDX_ATTR_NAME(LASS),
 	DEF_TDX_ATTR_NAME(SEPT_VE_DISABLE),
-	DEF_TDX_ATTR_NAME(MIGRTABLE),
+	DEF_TDX_ATTR_NAME(MIGRATABLE),
 	DEF_TDX_ATTR_NAME(PKS),
 	DEF_TDX_ATTR_NAME(KL),
 	DEF_TDX_ATTR_NAME(TPA),
diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 8bc074c8d7c6..11f3cf30b1ac 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -35,8 +35,8 @@
 #define TDX_ATTR_LASS			BIT_ULL(TDX_ATTR_LASS_BIT)
 #define TDX_ATTR_SEPT_VE_DISABLE_BIT	28
 #define TDX_ATTR_SEPT_VE_DISABLE	BIT_ULL(TDX_ATTR_SEPT_VE_DISABLE_BIT)
-#define TDX_ATTR_MIGRTABLE_BIT		29
-#define TDX_ATTR_MIGRTABLE		BIT_ULL(TDX_ATTR_MIGRTABLE_BIT)
+#define TDX_ATTR_MIGRATABLE_BIT		29
+#define TDX_ATTR_MIGRATABLE		BIT_ULL(TDX_ATTR_MIGRATABLE_BIT)
 #define TDX_ATTR_PKS_BIT		30
 #define TDX_ATTR_PKS			BIT_ULL(TDX_ATTR_PKS_BIT)
 #define TDX_ATTR_KL_BIT			31
-- 
2.43.0


