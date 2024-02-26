Return-Path: <kvm+bounces-9630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A293D866C3B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:30:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D3AD01C22BE9
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 08:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C46D03D0D2;
	Mon, 26 Feb 2024 08:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JIn5nBfu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770DD208AD;
	Mon, 26 Feb 2024 08:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936061; cv=none; b=TvKFBMS8gAanr5Loqh81RTnJcDCORJTSqNhR0TV9r76xkSpZVU9zJoypK6htLEQhA1+MHkG7T743oKJxsIowx+e3ebfRmnsOtaDX7MtWUWi4dIGV0+OrhcR5Cm5JaBVqME8ShgGQSJqVw+iuk7bESYT66gDa763Lh0VFBPvmS3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936061; c=relaxed/simple;
	bh=JAOPGYcP6NR00jGXljrBqWwP9YIKeIJlQyj51gG7x+s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AkJqxFpVph5xcN3ImwLvKNV82WOs+Nt4SUWQ2VSyNgLqP8V0JQC3+2OlUcaYipePCEdydc1Wifit2p5hqaHUC9OlWvhpZYKZUatGexQVNQTJ9ayOeacFH5vaKuPTNxGUX2pZsLnH/uRCpr4kLx8M8OyK5n6+k0+GSlaMD4/Py0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JIn5nBfu; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936060; x=1740472060;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JAOPGYcP6NR00jGXljrBqWwP9YIKeIJlQyj51gG7x+s=;
  b=JIn5nBfu5PewrwzahWS7hgWb5eb7LyKk1wWSMwEPl32jYCn05mbXtZ8d
   uEXeOQTlQatHAjgkWjC61e6R6HloEt4R0VfDUlFw2hvcWBajLHI8pazVt
   cP4PN0EGRZcVm/JZNrHmyPZCMBka/LGFsfIM5C3JMtLdmjJrH6E+Paxhx
   ZI1EugzO1HqqnCIwPGJC1M+/KccOZHKThG7ydXtls0tfn9svDKspr2OFi
   HWsit3nKZbWu0FzCDzeK4CW4dTNIS2cOeeIwtx5eBtrmwGYl18Qe77gRP
   umG3PdJup3m2IZrDdadjJ0w+syN2076bTFVGkOR+ZN0yGybh3udmaNHro
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3340716"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3340716"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="7020085"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:27:38 -0800
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
	tina.zhang@intel.com
Subject: [PATCH v19 006/130] x86/virt/tdx: Export TDX KeyID information
Date: Mon, 26 Feb 2024 00:25:08 -0800
Message-Id: <0e77a714e4ee2936218bf7a0ae6811f7bae27432.1708933498.git.isaku.yamahata@intel.com>
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
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/tdx.h  |  5 +++++
 arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 709b9483f9e4..16be3a1e4916 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -88,6 +88,11 @@ static inline long tdx_kvm_hypercall(unsigned int nr, unsigned long p1,
 #endif /* CONFIG_INTEL_TDX_GUEST && CONFIG_KVM_GUEST */
 
 #ifdef CONFIG_INTEL_TDX_HOST
+
+extern u32 tdx_global_keyid;
+extern u32 tdx_guest_keyid_start;
+extern u32 tdx_nr_guest_keyids;
+
 u64 __seamcall(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_ret(u64 fn, struct tdx_module_args *args);
 u64 __seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index dc21310776ab..d2b8f079a637 100644
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
2.25.1


