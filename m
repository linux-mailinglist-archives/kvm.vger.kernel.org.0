Return-Path: <kvm+bounces-65064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 22AE4C9A121
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 06:24:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AB239346436
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 05:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4342F6934;
	Tue,  2 Dec 2025 05:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ABVtFQCx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4755B2BE02D;
	Tue,  2 Dec 2025 05:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764653063; cv=none; b=b8MSLFplQU74oiRgBLTjpfpwqscgofn6ZSgsghhEEu8Fw/OWlxqAb2IMde/SUFlblqlB7zaqXQn+y4xlnQ8XKe8+cZSDLSZjCb7nzWSpAur1CCdzGJpnkz9yAMlukpQGhNQEaJ3L3nfozwLIYkWSue5UOxDFZ6qA1fT/mishTDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764653063; c=relaxed/simple;
	bh=wiBckAWV96SNiwkvHWDY1PwWuaniEJfOqlpJvVlQuAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GyH/LUCiXqPVWVOF9yRjmP9enq4pRUWIL41a0/nIXJArK6qs5pCY56xFXf2wnbQnnQwQCoK/SK9HOTi6tY9M9cRTx7/GARZeJRAVPK+OIEeSZFPd5OzaiULuIY3rVKx3KYxqDA0IAsu5GB7J4NIrtaDOk4hJVpj3OVPjF4d7BTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ABVtFQCx; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764653061; x=1796189061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wiBckAWV96SNiwkvHWDY1PwWuaniEJfOqlpJvVlQuAU=;
  b=ABVtFQCxvehpHEMGKSYQp1hqWYJTsoy+hTMEtxi2IYipB56s52JNNO3q
   IsOqfXQf/G4oATLrzQlCE9//Ki02F9Ja5Af/6WlfxOFj5oXand+uaQEXI
   eZRmGAVxzQau7oB+5scB3LGdZWS3rXBGgH/I77RDboJ2QTJb2G3ax4Nou
   z74ZJG7PFd/fwI7sA8cFSRhMyEhzNni1V7hbq1dvFpe/JM1pSZ/FWEA7V
   06nutAhywePLrzeiQ88s7LSu1POdW8Np8Gre7T+Owx9KOMZXAMVViuTKY
   mFis/myhDYDPrLWcT8mgBfUTXFGDQFYoMBDfzZloGcOQxvFxbVGjdfsFR
   Q==;
X-CSE-ConnectionGUID: lD65vMY8Tv6+/EkWBhUKdQ==
X-CSE-MsgGUID: P/N1Dz6MSGOzRiTc+QCtqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="76929817"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="76929817"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 21:24:15 -0800
X-CSE-ConnectionGUID: lrhr8EogTWiPpKyzC1w9Uw==
X-CSE-MsgGUID: H4nXtRgxTT6O5+1R8PpZKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="199399236"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa005.jf.intel.com with ESMTP; 01 Dec 2025 21:24:13 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: x86@kernel.org,
	dave.hansen@linux.intel.com,
	kas@kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	rick.p.edgecombe@intel.com,
	dan.j.williams@intel.com,
	baolu.lu@linux.intel.com,
	yilun.xu@linux.intel.com,
	yilun.xu@intel.com,
	zhenzhong.duan@intel.com,
	kvm@vger.kernel.org,
	adrian.hunter@intel.com
Subject: [PATCH 1/6] x86/virt/tdx: Move bit definitions of TDX_FEATURES0 to public header
Date: Tue,  2 Dec 2025 13:08:39 +0800
Message-Id: <20251202050844.2520762-2-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
References: <20251202050844.2520762-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move bit definitions of TDX_FEATURES0 to TDX core public header.

Kernel users get TDX_FEATURES0 bitmap via tdx_get_sysinfo(). It is
reasonable to also public the definitions of each bit. TDX Connect (a
new TDX feature to enable Trusted I/O virtualization) will add new bits
and check them in separate kernel modules.

Take the opportunity to change its type to BIT_ULL since TDX_FEATURES0
is explicitly defined as 64-bit in both TDX Module Specification and
TDX core code.

Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
---
 arch/x86/include/asm/tdx.h  | 4 ++++
 arch/x86/virt/vmx/tdx/tdx.h | 3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 6b338d7f01b7..96565f6b69b9 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -148,6 +148,10 @@ static __always_inline u64 sc_retry(sc_func_t func, u64 fn,
 int tdx_cpu_enable(void);
 int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
+
+/* Bit definitions of TDX_FEATURES0 metadata field */
+#define TDX_FEATURES0_NO_RBP_MOD	BIT_ULL(18)
+
 const struct tdx_sys_info *tdx_get_sysinfo(void);
 
 int tdx_guest_keyid_alloc(void);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 82bb82be8567..c641b4632826 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -84,9 +84,6 @@ struct tdmr_info {
 	DECLARE_FLEX_ARRAY(struct tdmr_reserved_area, reserved_areas);
 } __packed __aligned(TDMR_INFO_ALIGNMENT);
 
-/* Bit definitions of TDX_FEATURES0 metadata field */
-#define TDX_FEATURES0_NO_RBP_MOD	BIT(18)
-
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
-- 
2.25.1


