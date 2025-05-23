Return-Path: <kvm+bounces-47541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F120EAC2050
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:58:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B1E37B7079
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 09:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3117227BA9;
	Fri, 23 May 2025 09:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lU5B3ALj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9418D226D08;
	Fri, 23 May 2025 09:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747994029; cv=none; b=iNasifbLtHfArCXxmk/0Tud30RrAAe8b6sHdt6xkw7B8QJaS9zuMBYHQ/zQ/p2Z+8A0BqgkUUwqlQmpADlYXCZ7PYzPHGvMlqHVTDkXAHtnRUf4hY6SwXahZT0tN2+jAvarZu3U/3kHFWPSdwAGrqmbjSHBWa/0hJtKhoShfWHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747994029; c=relaxed/simple;
	bh=1m8EIlm1cRb4xIyW10yQKIUYeauJTU6kBjI91qIj5dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGau7tPibgPPcuQUvame5SNismk+lqwbQNdBNdKsvwU9oFZPvjpXKn/TJTzmdhCNOwRBpEu6t0uYyDlAczSbpeZwS/sHt9YV2wM6CxYOKQ20cnhpTug1vKeC2a71B7v9Va71epzOyjipnTnFnBOfYt1aVggepqybzyMC5rjwUnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lU5B3ALj; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747994027; x=1779530027;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1m8EIlm1cRb4xIyW10yQKIUYeauJTU6kBjI91qIj5dw=;
  b=lU5B3ALjAQzndRLofJjb2S5wgsJ9LzExfKR5JHcD7dXD+sVVk4tt6dHJ
   EhKYJyv6e+13VBZaYBolled4FkmMbd6Cc6UocjFNVCmyp6GJT1pTSOy2u
   q0gBnGu8TBz9pLRVmcxq7MNUKDfl5K07UvYPDWjn4uxh0dfJSw1O4f/cO
   X0BVYUG1UsFho+rW/u4VwuYWYWKM5IplUYUsvSrQGv2vjFDhRX+lWWt+C
   2i/0wnk9CIk0f5Ob/BRD29GhZfzNukQGkZ1oSOzOCdIt2YB7WfTw2gTK0
   OIwelavs9MLUHKVtwp6SkV/4xWyjsEEcYsVJPfRM6d6mhrkybfoUd9Qyy
   w==;
X-CSE-ConnectionGUID: NOuA4EceS/KyAZBfoGL7Jg==
X-CSE-MsgGUID: NTprloCFRaKgYVEHQlJYRw==
X-IronPort-AV: E=McAfee;i="6700,10204,11441"; a="75444141"
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="75444141"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:47 -0700
X-CSE-ConnectionGUID: VqDtvH2ERuu8+4xtxItzog==
X-CSE-MsgGUID: s7KpNDfuQXeJ235mYDcYCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,308,1739865600"; 
   d="scan'208";a="164315057"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2025 02:53:46 -0700
From: Chao Gao <chao.gao@intel.com>
To: linux-coco@lists.linux.dev,
	x86@kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	pbonzini@redhat.com,
	eddie.dong@intel.com,
	kirill.shutemov@intel.com,
	dave.hansen@intel.com,
	dan.j.williams@intel.com,
	kai.huang@intel.com,
	isaku.yamahata@intel.com,
	elena.reshetova@intel.com,
	rick.p.edgecombe@intel.com,
	Chao Gao <chao.gao@intel.com>,
	Farrah Chen <farrah.chen@intel.com>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 06/20] x86/virt/seamldr: Add a helper to read P-SEAMLDR information
Date: Fri, 23 May 2025 02:52:29 -0700
Message-ID: <20250523095322.88774-7-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250523095322.88774-1-chao.gao@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper function to retrieve P-SEAMLDR information, including its
version and features, using the dedicated P_SEAMLDR_INFO API. This is in
preparation for exposing this information to userspace. Userspace will
utilize the version number to verify the compatibility of TDX modules
with the P-SEAMLDR

Signed-off-by: Chao Gao <chao.gao@intel.com>
Tested-by: Farrah Chen <farrah.chen@intel.com>
---
 arch/x86/virt/vmx/tdx/seamldr.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/virt/vmx/tdx/seamldr.c b/arch/x86/virt/vmx/tdx/seamldr.c
index a252f1ae3483..c2771323729c 100644
--- a/arch/x86/virt/vmx/tdx/seamldr.c
+++ b/arch/x86/virt/vmx/tdx/seamldr.c
@@ -11,7 +11,26 @@
 #include "tdx.h"
 #include "../vmx.h"
 
-static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
+ /* P-SEAMLDR SEAMCALL leaf function */
+#define P_SEAMLDR_INFO			0x8000000000000000
+
+struct seamldr_info {
+	u32	version;
+	u32	attributes;
+	u32	vendor_id;
+	u32	build_date;
+	u16	build_num;
+	u16	minor_version;
+	u16	major_version;
+	u16	update_version;
+	u8	reserved0[4];
+	u32	num_remaining_updates;
+	u8	reserved1[224];
+} __packed;
+
+static struct seamldr_info seamldr_info __aligned(256);
+
+static inline int seamldr_call(u64 fn, struct tdx_module_args *args)
 {
 	u64 vmcs;
 	int ret;
@@ -42,3 +61,10 @@ static __maybe_unused int seamldr_call(u64 fn, struct tdx_module_args *args)
 
 	return ret;
 }
+
+static __maybe_unused int get_seamldr_info(void)
+{
+	struct tdx_module_args args = { .rcx = __pa(&seamldr_info) };
+
+	return seamldr_call(P_SEAMLDR_INFO, &args);
+}
-- 
2.47.1


