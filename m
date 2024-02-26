Return-Path: <kvm+bounces-9625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B80866C2F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8689D1F24275
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:28:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461F51F605;
	Mon, 26 Feb 2024 08:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HzQYTdDz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A43A1DA3F;
	Mon, 26 Feb 2024 08:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936057; cv=none; b=DBRIxIiCZ/xZa3c+dbSNWWcCO+SNPCkNKv9yyzNCgdHFJe/K/LSxbP4nHngBpl9K69LjJ7xyd34wbxkL2H+thDQ+e2gyAwqsCjEqmFfmPLWo3HaOyeQweIvryIHazXsY1V+T9q7k4a0EyaKW4X8FxBjChc9pNU1JnL05kq7se3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936057; c=relaxed/simple;
	bh=w4lY8P57h5k6ODIw2ePbR3iDGqUeK20stwm2wWMGTNQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SGd9ir5hsXH8d/PcqEDgpwjgLW08nK9feJhBcrpRMEBezT4xvYIOke3PDh57lmTKJgYVChkZ0IImTGLqTBi/trivctplD5gHuJZwIjvfEFrFgCHwfe5yeziXY5ckIMzhOEyCKT3S0Tgzf6sCdWQpDN6u4l9t4K/EWx1h1cfK9EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HzQYTdDz; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936056; x=1740472056;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w4lY8P57h5k6ODIw2ePbR3iDGqUeK20stwm2wWMGTNQ=;
  b=HzQYTdDz1vU34CU77d53Ae1ZlSJLHE/pHMokY5oREH05Tr2Rq1WkHf5W
   b6n3rpcLCFsIYFAFKMSlTqlqz7vkOwM1L3ag1Tqa8cfgfUuJ9ZTM/PvNQ
   gVkLr+DCLi/T4ylRUOI+T30jCGVjgD3MJTOgBV2JBVrOmOxx7zeV1xVeM
   Ud2mBuwTJPx7dTVOORBjRTnYQ6/J5STDpQITkXCFKaJqr3RPQvP+EGczE
   EvNFDl64H+p8z7LuiS0vcOxBx3/W100ax6Mc+lqtj7AjTWuf8gBAZ2EbY
   Hdjz7Wa40zBOIOOknW9GdVKvqVF88mdTytMSjaMSQm9liAeD/3rRQECiT
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3340694"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3340694"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="7020034"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:33 -0800
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
	tina.zhang@intel.com,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v19 001/130] x86/virt/tdx: Rename _offset to _member for TD_SYSINFO_MAP() macro
Date: Mon, 26 Feb 2024 00:25:03 -0800
Message-Id: <eab766ea1477d87a5985039e8fbe81ec5a45bac9.1708933498.git.isaku.yamahata@intel.com>
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

From: Kai Huang <kai.huang@intel.com>

TD_SYSINFO_MAP() macro actually takes the member of the 'struct
tdx_tdmr_sysinfo' as the second argument and uses the offsetof() to
calculate the offset for that member.

Rename the macro argument _offset to _member to reflect this.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 4d6826a76f78..2aee64d2f27f 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -297,9 +297,9 @@ struct field_mapping {
 	int offset;
 };
 
-#define TD_SYSINFO_MAP(_field_id, _offset) \
+#define TD_SYSINFO_MAP(_field_id, _member) \
 	{ .field_id = MD_FIELD_ID_##_field_id,	   \
-	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _offset) }
+	  .offset   = offsetof(struct tdx_tdmr_sysinfo, _member) }
 
 /* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
 static const struct field_mapping fields[] = {
-- 
2.25.1


