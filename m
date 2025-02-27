Return-Path: <kvm+bounces-39449-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F580A470E4
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C8B27AAFC8
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 270491AA79C;
	Thu, 27 Feb 2025 01:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QUDCEqIp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9B61A83E6;
	Thu, 27 Feb 2025 01:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619167; cv=none; b=tPKlJSy9b++Q4ccAD6OxjwHl1iS67cHH92BLenAnxMh1HcQBG9AQHoDbT8TppCUF0wEzNq7McUk1BgZyiDIAFWpqSv0bDkBX/cVIgIS79kfZe3dsOODGKJdwUGjG54Akwz+JOmCRYUYzqmB1kjApe3kMGfa25pu4qnrrYk2gM+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619167; c=relaxed/simple;
	bh=lEHEJBGNv7Z2ZmoEjKOLCQwWgl97DVj2RsejJ+To+VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Us2Zu++9kTazA37qvQ4CN76i4+jo1IH8T0nnFat3E+e5mtCIjMdyoTTcRJctT5HqDmVvUW4BOxEi863vbtRYoWGZpkNi0tP18BTNcVv6hwdVz1Fk4EQ7R+QXivKaqP3pbrQLtLE8EVnOrkopemvo+2akwhZBk7w3gfEd9UYLxpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QUDCEqIp; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619166; x=1772155166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lEHEJBGNv7Z2ZmoEjKOLCQwWgl97DVj2RsejJ+To+VM=;
  b=QUDCEqIp/ikRVel9mP3PC9NFNZfl54C8yW/R+lMF9mvBF4jj49DiFTEn
   BxWgmVPLC4AziWf+nV5N7q9T8AU5lWUKLFJfavhPxrY2LZgDyU6URtNgT
   oEnR2WDYmxheDwf+SwalwNVPCJpf1gqkIElzPLkfFABRWE+KCa+31yq8b
   7JgSqbo8JQZTvLN7gzp6CoqYDGiJfx4f9wf4R4RRcC/GLm9qVDNrCfCEd
   ovQFvxjsDNAhWLtRX0zk3qqzp+gBAiJDiPfRGPHaKolfbULZFh1SaaTqA
   aDTdknvyMLXT/CWkMnqaRlg8g3G3FZRhaPrewO38VjU6AiM2QxUgEUs7o
   w==;
X-CSE-ConnectionGUID: kJFl6CeoSiib36MIWREWMw==
X-CSE-MsgGUID: XPizCEjnQ1mIE1KbWPCoQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959632"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959632"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:26 -0800
X-CSE-ConnectionGUID: +OlgE+0bRomnfoTj7CiJwg==
X-CSE-MsgGUID: cm2TS4g5Q1KaSsnlAxP6Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674906"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:22 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 11/20] KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
Date: Thu, 27 Feb 2025 09:20:12 +0800
Message-ID: <20250227012021.1778144-12-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement TDG.VP.VMCALL<GetTdVmCallInfo> hypercall.  If the input value is
zero, return success code and zero in output registers.

TDG.VP.VMCALL<GetTdVmCallInfo> hypercall is a subleaf of TDG.VP.VMCALL to
enumerate which TDG.VP.VMCALL sub leaves are supported.  This hypercall is
for future enhancement of the Guest-Host-Communication Interface (GHCI)
specification.  The GHCI version of 344426-001US defines it to require
input R12 to be zero and to return zero in output registers, R11, R12, R13,
and R14 so that guest TD enumerates no enhancement.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- Use vp_enter_args directly instead of helpers.
- Skip setting return code as TDVMCALL_STATUS_SUCCESS.
- Skip setting tdx->vp_enter_args.r12 to 0 because it already is 0.

TDX "the rest" v1:
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)

v19:
- rename TDG_VP_VMCALL_GET_TD_VM_CALL_INFO => TDVMCALL_GET_TD_VM_CALL_INFO
---
 arch/x86/include/asm/shared/tdx.h |  1 +
 arch/x86/kvm/vmx/tdx.c            | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index f23657350d28..606d93a1cbac 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -67,6 +67,7 @@
 #define TD_CTLS_LOCK			BIT_ULL(TD_CTLS_LOCK_BIT)
 
 /* TDX hypercall Leaf IDs */
+#define TDVMCALL_GET_TD_VM_CALL_INFO	0x10000
 #define TDVMCALL_MAP_GPA		0x10001
 #define TDVMCALL_GET_QUOTE		0x10002
 #define TDVMCALL_REPORT_FATAL_ERROR	0x10003
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 76764bf5ba29..dbc9fffcbc26 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1422,6 +1422,20 @@ static int tdx_emulate_mmio(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	if (tdx->vp_enter_args.r12)
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+	else {
+		tdx->vp_enter_args.r11 = 0;
+		tdx->vp_enter_args.r13 = 0;
+		tdx->vp_enter_args.r14 = 0;
+	}
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
@@ -1429,6 +1443,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_map_gpa(vcpu);
 	case TDVMCALL_REPORT_FATAL_ERROR:
 		return tdx_report_fatal_error(vcpu);
+	case TDVMCALL_GET_TD_VM_CALL_INFO:
+		return tdx_get_td_vm_call_info(vcpu);
 	default:
 		break;
 	}
-- 
2.46.0


