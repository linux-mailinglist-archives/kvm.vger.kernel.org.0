Return-Path: <kvm+bounces-6574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 123AB8377DE
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:55:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD7A028AF3F
	for <lists+kvm@lfdr.de>; Mon, 22 Jan 2024 23:55:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82DC14E1D5;
	Mon, 22 Jan 2024 23:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Js+Iq/2j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3DDB4EB21;
	Mon, 22 Jan 2024 23:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967693; cv=none; b=YNVULrTDr55/QBQvT8xz0ZcA8lR/q1DlyLtlgEpIpsvsCBfTVUbScglvbkS11VEhZowreqt1Xx8Qks7TpjNG9kke3PukN8QDB5aT4C20wF5OL6LJvZip/PnmYRH5ukHWtPKKK18tXroLbszSPweo+o/Dgw2gYJoC196jP4qNY8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967693; c=relaxed/simple;
	bh=r0icCN8cfZn9gqLB7aghLa1jbIjGM9Ec4AN41iKqPAU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gEcEdtsrKFSSEEyRBv+w/6wYG+bNcVaNjDANypYa0LsXQy94kdA53IO6doUpoRpXHcB/e85hRzReZmp5mkFw53qHDpf4SIEc8pYNGPS7baLYBR09Mt0q6Vk5+dFUcD+7ashlVgsETO/X1HwkPzCtpyihStcQxr6i1OXDaDKHs6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Js+Iq/2j; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967692; x=1737503692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r0icCN8cfZn9gqLB7aghLa1jbIjGM9Ec4AN41iKqPAU=;
  b=Js+Iq/2juYrpLhph6mBbqEHuPVM2TIVZRT6ZXSGlXD9Y42STWuOE+ZkP
   kHEPopOaC5Zlvc12enk1N1uhhdP7kiRq/0O8W72484reebWxV3DHFfmKn
   XcUVewzX6wLLAvwwPAaekMzZPGqq6/bneKRa5Q/GJGz4isbWxV6TAI1lC
   cOdb8piEbgvai/dK1SvFyUx+4jLwzis7AUSJtqCsjuEJESE6sm6G8XfPE
   vmraaF7Hrqg6ABVjCaL8aTvHgY6xjDLnDsRxpqggIPgLUgzCmu9ztVev/
   ntCZA9xSOGPw2m1zsv04htkxEtq10t+UXxu2AxAO/MSdu1CWYuNQ4QJgB
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="1217789"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1217789"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="1350086"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:54:50 -0800
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
Subject: [PATCH v18 001/121] x86/virt/tdx: Export TDX KeyID information
Date: Mon, 22 Jan 2024 15:52:37 -0800
Message-Id: <fed47cd35b32ee66f7ec55bdda6ccab12c139e85.1705965634.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
---
 arch/x86/include/asm/tdx.h  |  5 +++++
 arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 4595fbe4639b..4e219fc2e8ee 100644
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
index 06fbd0b9ea29..14e068ee2640 100644
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


