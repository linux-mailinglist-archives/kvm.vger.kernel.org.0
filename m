Return-Path: <kvm+bounces-23899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B01694F9DA
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:49:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9F4B282728
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7DB819CD0E;
	Mon, 12 Aug 2024 22:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g5vsVRUt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FA319AD94;
	Mon, 12 Aug 2024 22:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502915; cv=none; b=Fb6P1h7uIQKDTvH9VnKIphxjzlze4vT+TsTE3s/WMIWywex5Ck8sRKAB2e7YkikEDt4Sd22G9IDk2PJuQhK6VayS2fGyshQyUPblSN3CHOSHqm7SUsawiXU+HqlbJRvrKdXfu7mKXHbinD+gmgU8ZzU3fDfLAPvZtsNyxZRIoWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502915; c=relaxed/simple;
	bh=VT61EAOEqeW+bKLIJKXCdw1CBLyvciFpNO6T7mZ4HlA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g8EVUieiytb4Mg/QpxVQwPJqPj/knELiXpMgjq2Hx9dUMpVX5MGZwJ24SJKsxdN9yavsW7c3ofMdK45GaHMAjXHKJNx0dGBMs3ckF6nlYokDxGh51ruo/sPlfeRPLDVaccIhOoscSl3emysm0vWThapWqnbaePHumPjLUC2s9N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g5vsVRUt; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502913; x=1755038913;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VT61EAOEqeW+bKLIJKXCdw1CBLyvciFpNO6T7mZ4HlA=;
  b=g5vsVRUtnre2WpH9S8mssYXLH9En9XwMuSEXVLd84YiZ8sg5nvkwl4up
   8mSUBBLLyS9nes9AYAklkUTkOklxJ1iJh+jfpKLYLuZ5NlVD1fLaebko+
   Tn2cYKoQi+2hNMu86n5glrhV+vp0XQFU9GDa7PK5VqLZEAciAWE1yTMEm
   R7kXQeTTFs3tAhJh8op6CLaitfxrUBQfNIv0yFzpD1FYQ6XapG+hlcQwJ
   xz/YED4WdvYWP91St0rH7IdHMVkEHk6l8iI48LO5OUDjiqRqldmNdKgsj
   iS1qrktD4Dfu1SmgZ0K2Tf/nCMjDpWwWGdAv/X8bPBC7TH7xne+bbC0nF
   Q==;
X-CSE-ConnectionGUID: /lWNKRrLQqO8dELR37VNyQ==
X-CSE-MsgGUID: RTVlqtBMQgSdkE8BB9dm9Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041352"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041352"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:29 -0700
X-CSE-ConnectionGUID: CDc8z0VuRoWMRQKexj6BbA==
X-CSE-MsgGUID: +hwN9Uu7Si2edeKMx6kh/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008352"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:28 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH 05/25] KVM: TDX: Add helper functions to print TDX SEAMCALL error
Date: Mon, 12 Aug 2024 15:48:00 -0700
Message-Id: <20240812224820.34826-6-rick.p.edgecombe@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add helper functions to print out errors from the TDX module in a uniform
manner.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
uAPI breakout v1:
- Update for the wrapper functions for SEAMCALLs. (Sean)
- Reorder header file include to adjust argument change of the C wrapper.
- Fix bisectability issues in headers (Kai)
- Updates from seamcall overhaul (Kai)

v19:
- dropped unnecessary include <asm/tdx.h>

v18:
- Added Reviewed-by Binbin.
---
 arch/x86/kvm/vmx/tdx_ops.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx_ops.h b/arch/x86/kvm/vmx/tdx_ops.h
index a9b9ad15f6a8..3f64c871a3f2 100644
--- a/arch/x86/kvm/vmx/tdx_ops.h
+++ b/arch/x86/kvm/vmx/tdx_ops.h
@@ -16,6 +16,21 @@
 
 #include "x86.h"
 
+#define pr_tdx_error(__fn, __err)	\
+	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx\n", #__fn, __err)
+
+#define pr_tdx_error_N(__fn, __err, __fmt, ...)		\
+	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx, " __fmt, #__fn, __err,  __VA_ARGS__)
+
+#define pr_tdx_error_1(__fn, __err, __rcx)		\
+	pr_tdx_error_N(__fn, __err, "rcx 0x%llx\n", __rcx)
+
+#define pr_tdx_error_2(__fn, __err, __rcx, __rdx)	\
+	pr_tdx_error_N(__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)
+
+#define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8)	\
+	pr_tdx_error_N(__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
+
 static inline u64 tdh_mng_addcx(struct kvm_tdx *kvm_tdx, hpa_t addr)
 {
 	struct tdx_module_args in = {
-- 
2.34.1


