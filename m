Return-Path: <kvm+bounces-23900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EE81594F9DB
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:50:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A04A1F22B7C
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:50:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A138A19D078;
	Mon, 12 Aug 2024 22:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P9XROs6P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D4919ADBE;
	Mon, 12 Aug 2024 22:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502915; cv=none; b=r4C/doqC+UIzmuFMJ7shK01ROPzQpqgHh9imr834GsRorze/wDUK+JSVE1Ogjo0Cglkt2+s3yP950Iqb8u5ASW9SlpmvQzxsp6Oo0mnhBGeaKwBM6DmHDJfggJLGTSVM0/CZANoJZk/3FwWVHKqxnaBTi6aZZjtWC/+h2PBzDzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502915; c=relaxed/simple;
	bh=Aa0gvO6cAMnN8Becpb5toQUl9zgCOERQkYWJR9wRO2k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qR43YRwIcQMBg+OS75FV+LFx/FYD6a5jPeJPDsG1Huoe02EHtjYF2G7Y958cNHdln42xGGfpER5KCUHr0tIwS1ODFh9NPRWTgGRtg14DRAnVPNQKNvfMBsmNnjZdO41Dq0uuQyZcWJH2B96tVfWld1+7hzZ4iR2vI6ly88S4Gmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P9XROs6P; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502914; x=1755038914;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Aa0gvO6cAMnN8Becpb5toQUl9zgCOERQkYWJR9wRO2k=;
  b=P9XROs6PgZam1ffjYKPdpR+PCcMu9wYycBDCnmphyF3XCA539HmBZdf/
   yc2P0g6mEFh8Kc3KMVGA1eaBkIQ3HK7YbFm3LaWJ7XJPv8nW6nbf94I7B
   fzOK6rTMQcSrHOAFs70883HBQEsH2JSzJvO7PWXgXNbc1/uitx8f8Nh0m
   5i8U8v7zIE4Q1Kcvv+5lCnB3zY89WE2qfKo8JvbxBxexNoFgseFy7fOgV
   wgHLApOXTt9vpxsfwfLFyiklV9kAVL9pDMoKDLt9eNu5UccBxpDMkmaa4
   ndmO8kIj3vCWS3YVwDC0HDFcFb3wdZhhtfKpg/lxDaiTZKtyh/Fj5n1oN
   g==;
X-CSE-ConnectionGUID: Kd3/HCQfRGiSNsuiwoX5Ww==
X-CSE-MsgGUID: tEnlHu2SRK6S/obgOkx/Zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041360"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041360"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:29 -0700
X-CSE-ConnectionGUID: /OYfftySRbGn/UY7hpPNMA==
X-CSE-MsgGUID: R7WjzlVjSvKSUI9RKYjVgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008360"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:29 -0700
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
Subject: [PATCH 06/25] x86/virt/tdx: Export TDX KeyID information
Date: Mon, 12 Aug 2024 15:48:01 -0700
Message-Id: <20240812224820.34826-7-rick.p.edgecombe@intel.com>
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

From: Kai Huang <kai.huang@intel.com>

Each TDX guest must be protected by its own unique TDX KeyID.  KVM will
need to tell the TDX module the unique KeyID for a TDX guest when KVM
creates it.

Export the TDX KeyID range that can be used by TDX guests for KVM to
use.  KVM can then manage these KeyIDs and assign one for each TDX guest
when it is created.

Each TDX guest has a root control structure called "Trust Domain Root"
(TDR).  Unlike the rest of the TDX guest, the TDR is protected by the
TDX global KeyID.  When tearing down the TDR, KVM will need to pass the
TDX global KeyID explicitly to the TDX module to flush cache associated
to the TDR.

Also export the TDX global KeyID for KVM to tear down the TDR.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - New patch
---
 arch/x86/include/asm/tdx.h  |  4 ++++
 arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 56c3a5512c22..8e0eef4f74f5 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -176,6 +176,10 @@ struct tdx_sysinfo {
 
 const struct tdx_sysinfo *tdx_get_sysinfo(void);
 
+extern u32 tdx_global_keyid;
+extern u32 tdx_guest_keyid_start;
+extern u32 tdx_nr_guest_keyids;
+
 u64 __seamcall(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 478d894f46a2..96640cfb1830 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -39,9 +39,14 @@
 #include <asm/mce.h>
 #include "tdx.h"
 
-static u32 tdx_global_keyid __ro_after_init;
-static u32 tdx_guest_keyid_start __ro_after_init;
-static u32 tdx_nr_guest_keyids __ro_after_init;
+u32 tdx_global_keyid __ro_after_init;
+EXPORT_SYMBOL_GPL(tdx_global_keyid);
+
+u32 tdx_guest_keyid_start __ro_after_init;
+EXPORT_SYMBOL_GPL(tdx_guest_keyid_start);
+
+u32 tdx_nr_guest_keyids __ro_after_init;
+EXPORT_SYMBOL_GPL(tdx_nr_guest_keyids);
 
 static DEFINE_PER_CPU(bool, tdx_lp_initialized);
 
-- 
2.34.1


