Return-Path: <kvm+bounces-30088-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 349059B6C9E
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 20:05:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E893E282BF0
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 19:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05710219C84;
	Wed, 30 Oct 2024 19:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W1m2c6Xh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7AB2178F3;
	Wed, 30 Oct 2024 19:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730314868; cv=none; b=AoQpKm81IZns6rHOyCyJYjHLqidh6guxtcFnith3T4kP8TKLDakH9buLKuhCQ4jbjo1T1YA8p/k6gNWFxOweE8QDGUbtsR6llDCREJcDF2OUMBOXtVRFA6lRIQbj4Eaf8XVRAH4KCjVbK3Q0AYaFtmUILR0ZBfw0YhY5+lk6QPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730314868; c=relaxed/simple;
	bh=ohGJW98zbzi41fnrs+d0ySgurKfZKhW8uy+/TSjCT/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UU8Mb+GC7uZ89bMBMpbgZrEimxbwXkclFpvw8HkWN5NL1//ZOETppFTx7IuIVQm9siqxxl/+xPh39C6+kq1OuQHv7enK9aaBfiPmQVFz6wlOYRFuCEbPy/AlopxYUBIsBIoIiYw/5XxhzPvZcdO7vxB0L3S0BhSSH1BPyyal/8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W1m2c6Xh; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730314866; x=1761850866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ohGJW98zbzi41fnrs+d0ySgurKfZKhW8uy+/TSjCT/A=;
  b=W1m2c6XhaRnf96lziMJjayZPiEhe74Yr6Ir3x93rcDORZXaEuFokJZyA
   Ll795qbwnSFiNVjVMEs6CwmwC0JPrAps2JKMrW08uZtVmWO0WZBBFbTCs
   I6JdQSFzpMxvWyRY7FXAubwRafstYHSDeI0R4XYvBLlnVNPxAmEhqRPjq
   fVuDeLkkYcQKjlur3kQfxtmYkkOfl9MaXGrD2CeaVPPHV4yilAnZsQxR6
   wb+g1bjuj/tVHb9msW/xPMnKlLmoSo01xUxbluUzlM7o2JYrUjSjmmJqU
   k7oRatpkCRfMCM2dQJ/8n206+mVuOeOoRIwSwfktoY8QUa9l1l4jiWxKH
   Q==;
X-CSE-ConnectionGUID: WzyCXqgHRz+pjlVKWzzlsw==
X-CSE-MsgGUID: 3tllxLS1TcqDS4qWO2QcHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="17678766"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="17678766"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:01:00 -0700
X-CSE-ConnectionGUID: Pm3GizZ1SrOtZ2EIozGNAQ==
X-CSE-MsgGUID: 6zVzmGVARSGu5p0H9JnLuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82499372"
Received: from sramkris-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.186])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 12:00:59 -0700
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
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>
Subject: [PATCH v2 10/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX flush operations
Date: Wed, 30 Oct 2024 12:00:23 -0700
Message-ID: <20241030190039.77971-11-rick.p.edgecombe@intel.com>
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

Intel TDX protects guest VMs from malicious host and certain physical
attacks. The TDX module has the concept of flushing vCPUs. These flushes
include both a flush of the translation caches and also any other state
internal to the TDX module. Before freeing a KeyID, this flush operation
needs to be done. KVM will need to perform the flush on each pCPU
associated with the TD, and also perform a TD scoped operation that checks
if the flush has been done on all vCPU's associated with the TD.

Add a tdh_vp_flush() function to be used to call TDH.VP.FLUSH on each pCPU
associated with the TD during TD teardown. It will also be called when
disabling TDX and during vCPU migration between pCPUs.

Add tdh_mng_vpflushdone() to be used by KVM to call TDH.MNG.VPFLUSHDONE.
KVM will use this during TD teardown to verify that TDH.VP.FLUSH has been
called sufficiently, and advance the state machine that will allow for
reclaiming the TD's KeyID.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Yuan Yao <yuan.yao@intel.com>
---
uAPI breakout v2:
 - Change to use 'u64' as function parameter to prepare to move
   SEAMCALL wrappers to arch/x86. (Kai)
 - Split to separate patch
 - Move SEAMCALL wrappers from KVM to x86 core;
 - Move TDH_xx macros from KVM to x86 core;
 - Re-write log

uAPI breakout v1:
 - Make argument to C wrapper function struct kvm_tdx * or
   struct vcpu_tdx * .(Sean)
 - Drop unused helpers (Kai)
 - Fix bisectability issues in headers (Kai)
 - Updates from seamcall overhaul (Kai)

v19:
 - Update the commit message to match the patch by Yuan
 - Use seamcall() and seamcall_ret() by paolo

v18:
 - removed stub functions for __seamcall{,_ret}()
 - Added Reviewed-by Binbin
 - Make tdx_seamcall() use struct tdx_module_args instead of taking
  each inputs.

---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 20 ++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index a70933ec7808..d093dc4350ac 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -129,6 +129,8 @@ u64 tdh_mng_key_config(u64 tdr);
 u64 tdh_mng_create(u64 tdr, u64 hkid);
 u64 tdh_vp_create(u64 tdr, u64 tdvpr);
 u64 tdh_mng_rd(u64 tdr, u64 field, u64 *data);
+u64 tdh_vp_flush(u64 tdvpr);
+u64 tdh_mng_vpflushdone(u64 tdr);
 u64 tdh_mng_key_freeid(u64 tdr);
 u64 tdh_mng_init(u64 tdr, u64 td_params, u64 *rcx);
 u64 tdh_vp_init(u64 tdvpr, u64 initial_rcx);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 82820422d698..af121a73de80 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1638,6 +1638,26 @@ u64 tdh_mng_rd(u64 tdr, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
+u64 tdh_vp_flush(u64 tdvpr)
+{
+	struct tdx_module_args args = {
+		.rcx = tdvpr,
+	};
+
+	return seamcall(TDH_VP_FLUSH, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_flush);
+
+u64 tdh_mng_vpflushdone(u64 tdr)
+{
+	struct tdx_module_args args = {
+		.rcx = tdr,
+	};
+
+	return seamcall(TDH_MNG_VPFLUSHDONE, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_mng_vpflushdone);
+
 u64 tdh_mng_key_freeid(u64 tdr)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 1915a558c126..a63037036c91 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -23,6 +23,8 @@
 #define TDH_MNG_CREATE			9
 #define TDH_VP_CREATE			10
 #define TDH_MNG_RD			11
+#define TDH_VP_FLUSH			18
+#define TDH_MNG_VPFLUSHDONE		19
 #define TDH_MNG_KEY_FREEID		20
 #define TDH_MNG_INIT			21
 #define TDH_VP_INIT			22
-- 
2.47.0


