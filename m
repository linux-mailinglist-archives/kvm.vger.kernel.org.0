Return-Path: <kvm+bounces-52462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A2EB05634
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 11:22:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CEEA4A27CE
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:21:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E756D2D661A;
	Tue, 15 Jul 2025 09:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nLjHAb9I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46B52D63FD;
	Tue, 15 Jul 2025 09:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752571293; cv=none; b=Y2k0Em3DMZknOVgGC9feANtX9SMLmRbN0bXk/JlTBlOrtuJAzJiNK5y59vdvvO9hg+OLb3utnux/NY7+FnSJEAATxO8tqUu5ZBTE0jZ5NQ3SrTlGtUYFMlRvFp1vKDcW8DYjicK0eypilIgzpFi+8GjX0aPdHcfsSplnyMXe4rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752571293; c=relaxed/simple;
	bh=Yhdrbsi3xuNdiYEULNrhlmxNwKvVco8Ee/2zWHgoN20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO4SVndgEhhVk+icfkAtXb34RbeDat9h61AZ++f3tAaN+zlayFKoVMpLltRidp5vs8x3tgEdK7Poj7UL8t6xeEaK6NvjqmOKZPl1NWlWGKRWuZPityXPQNfYGdryLTQV7Ci+nYd44RUiusCjwWgF6IH3ZKfIHbBKmnp2hb8DQHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nLjHAb9I; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752571292; x=1784107292;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Yhdrbsi3xuNdiYEULNrhlmxNwKvVco8Ee/2zWHgoN20=;
  b=nLjHAb9ISnMroBnAyNa7YXP9qvMP8UIoDZMpvIME1E76CiXsuKpyW/2L
   mG+9IVwezj9PKKHqhqO6/WtXtc1/Zu0xXcUZ9WQlSz5HX/k6pu7XEWLFN
   HeP8hXhyrCEL0onAHojuoYN5+//BgVgrBKyXOM1mvC3avRv5PNcMmbGsh
   eekEVFko+lNzzLAD0TDpMCJnSrNhW5bi47/3OC1o+cwFHAy+bCfrmJZA/
   3dX885WKEeqgwlcKjzw//7O8/5BPTNP5G5tPtJ5LSRmgVinPtJPhXXiJ7
   2yrXKtjRbqvw3FvpXRRwR60TRRrYC2RkbjQ9H8dc9iGUAJskBVXA7UoGC
   g==;
X-CSE-ConnectionGUID: JnJg2x9FQvuugYPxe2hAKg==
X-CSE-MsgGUID: UNAKeIwsROSQqNutu0U+dA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54003326"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="54003326"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 02:21:31 -0700
X-CSE-ConnectionGUID: OK7oovUBQhCxcMhG+1povw==
X-CSE-MsgGUID: lU6ChvMNQV68E7Vha6HFew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="188183684"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa001.fm.intel.com with ESMTP; 15 Jul 2025 02:21:25 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: "Kirill A. Shutemov" <kas@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	binbin.wu@linux.intel.com,
	yan.y.zhao@intel.com,
	reinette.chatre@intel.com,
	adrian.hunter@intel.com,
	tony.lindgren@intel.com,
	xiaoyao.li@intel.com
Subject: [PATCH v3 1/4] x86/tdx: Fix the typo in TDX_ATTR_MIGRTABLE
Date: Tue, 15 Jul 2025 17:13:09 +0800
Message-ID: <20250715091312.563773-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250715091312.563773-1-xiaoyao.li@intel.com>
References: <20250715091312.563773-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TD scoped TDCS attributes are defined by bit positions. In the guest
side of the TDX code, the 'tdx_attributes' string array holds pretty
print names for these attributes, which are generated via macros and
defines. Today these pretty print names are only used to print the
attribute names to dmesg.

Unfortunately there is a typo in the define for the migratable bit.
Change the defines TDX_ATTR_MIGRTABLE* to TDX_ATTR_MIGRATABLE*. Update
the sole user, the tdx_attributes array, to use the fixed name.

Since these defines control the string printed to dmesg, the change is
user visible. But the risk of breakage is almost zero since it is not
exposed in any interface expected to be consumed programmatically.

Fixes: 564ea84c8c14 ("x86/tdx: Dump attributes and TD_CTLS on boot")
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v3:
 - Use the rewritten changelog from Rick.

Changes in v2:
 - Add the impact of the change in the commit message. (provided by Rick)
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


