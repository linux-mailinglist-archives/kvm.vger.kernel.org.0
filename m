Return-Path: <kvm+bounces-30092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8EB49B6CAA
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:07:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A28A282FA1
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:06:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF17621B45E;
	Wed, 30 Oct 2024 19:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F7UuW2Vp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26A9219CB2;
	Wed, 30 Oct 2024 19:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314872; cv=none; b=Fvdg9CGx7AQfD9S4FI0nr5V8U7K8l1H2lb71ch8lYuagvLGLYrnNTW2CU9H/jsTyFs8psnVWJnkffdYSNIHLrVPSvIk1cLNJcTCvGsdU7sye7aiFMIfLspGZgVA+JqbOimCvYawsgJnXYo70ywTCeDVZt4DI0v4mMDpobq27Yds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314872; c=relaxed/simple;
	bh=V3368ffDx785RJyNPxRJG2meb/Ss18eCYKbchJoTgJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NedfzlotqbKe2Zswif/9WQetJ0pvRHt2Gv6uJ8PZDVSovsAEf1AYbnS8w9ZvqZIyh2DHGeHX/aXwbL6O+hJhjK2LJgek3gF4iwog4fKfxZwcBJqIr0UlS8dFyjM+s3hQ1PgDOZgss5m3DZtwFrfNtQKkoBuCm3OelPB9CtP6B6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F7UuW2Vp; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314870; x=1761850870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V3368ffDx785RJyNPxRJG2meb/Ss18eCYKbchJoTgJk=;
  b=F7UuW2VpdoTpzKnyxplm0AjR992ovYxqN7foPFPdQGRIhPYq813kRvIx
   dwaRbWD+Uz/ebprAtOdHNS2nfvPMHfUz+Ynhdm73i3t2qUQryb3zggBgl
   4Yf5cB4NNvxPVsPMFi9P6wHwxc/LjopPondwbfZDMvgDXr/lv1GkE2qVU
   PyFyYb+qdbIVV4NFBq0OT8pO8yLMXR14wvUiQyyGHvGxy+zS3D4gKwoGP
   cxQ4vmD/DVmy5cuflNxhf7HDK4gajqUgXUvuX+75yaMnHpWbN1MGe0k+B
   q8LYqWtV4JhW/xHJ7Dnz7MCLcmiQBzikilTXnyyOjCGwdM863ps4SUhSU
   A==;
X-CSE-ConnectionGUID: CLGx0q+sQP6b0zINHONxHw==
X-CSE-MsgGUID: ghMi/JvjQQSIMg7rRRlFtg==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678791"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678791"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:03 -0700
X-CSE-ConnectionGUID: tMYuWgStRVq3CBNULN/6Pg==
X-CSE-MsgGUID: CgUoCdcGS5O1a0XLRRDC+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499406"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:02 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	yan.y.zhao@intel.com,
	isaku.yamahata@gmail.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	reinette.chatre@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v2 14/25] KVM: TDX: Add helper functions to print TDX SEAMCALL error
Date: Wed, 30 Oct 2024 12:00:27 -0700
Message-ID: <20241030190039.77971-15-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
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
Co-developed-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Tony Lindgren <tony.lindgren@linux.intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
uAPI breakout v2:
 - Stringify the error codes, use ____pr_tdx_error_N() naming (Isaku, Kai)

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
 arch/x86/kvm/vmx/tdx.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f2830ff2af1d..60b577379a9a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -7,6 +7,21 @@
 #undef pr_fmt
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#define pr_tdx_error(__fn, __err)	\
+	pr_err_ratelimited("SEAMCALL %s failed: 0x%llx\n", #__fn, __err)
+
+#define __pr_tdx_error_N(__fn_str, __err, __fmt, ...)		\
+	pr_err_ratelimited("SEAMCALL " __fn_str " failed: 0x%llx, " __fmt,  __err,  __VA_ARGS__)
+
+#define pr_tdx_error_1(__fn, __err, __rcx)		\
+	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx\n", __rcx)
+
+#define pr_tdx_error_2(__fn, __err, __rcx, __rdx)	\
+	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx\n", __rcx, __rdx)
+
+#define pr_tdx_error_3(__fn, __err, __rcx, __rdx, __r8)	\
+	__pr_tdx_error_N(#__fn, __err, "rcx 0x%llx, rdx 0x%llx, r8 0x%llx\n", __rcx, __rdx, __r8)
+
 bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
 
-- 
2.47.0


