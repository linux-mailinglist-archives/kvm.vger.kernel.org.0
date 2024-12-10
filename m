Return-Path: <kvm+bounces-33359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD82F9EA3D6
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:50:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E862C2818A9
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:50:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170551D6DD4;
	Tue, 10 Dec 2024 00:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ke8FZ1PP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D591D6DB8;
	Tue, 10 Dec 2024 00:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791707; cv=none; b=p8ohiur4R8moBuYXc2JnLt63wn7f3kcxaWPIWRq7sy2ajMDa92lPb2oDdCl+/x6OjuKUUkoFIZuEkVeOqE13Y7AAgmVb/gSqgxSP0nxEpJBK9ibaM8RxxXepe/XusimAU16E/bT3fHbNz1qKlj3Qcxz2azCQ/4mrGyUCjd6jqGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791707; c=relaxed/simple;
	bh=3FAr91JGgHlr+EI5Okkc7KA7AOh/3MQ8oJ1eubya5lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CeLlkaS8+Ea8gRLNwCGzZXWoafD1UuM4KWa1FPo6T9AGjUQ01aTDkNG3a3mFdhkaaqJMJsA+qi02fYpYEEDyMCbunkFenYCrt/LvDEahsh7941Gne4kMdW6vRYoxRPmVcPNPi+oDfqTwy0cNc+sdH7pjbSNAiMttKd9gSYh+ymE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ke8FZ1PP; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791705; x=1765327705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3FAr91JGgHlr+EI5Okkc7KA7AOh/3MQ8oJ1eubya5lc=;
  b=ke8FZ1PPGLECU9K/8vCdQTIlj98O5I9cUZJQjfELpMd+odWqEIw/wBYd
   PzG9/1r8q6hkfJd6nDRWSjYnzkIik3sDHUjStfr1YuqmOOXiuZSxV5N2W
   zgXJ3E4xdDfsnQuwW2t2Jynz01YOoD7RtYRlRn4E4gnA6o5jKzyR0DY9E
   8DleLNN+4gaVBTv03piBvrmb+WzFvDDi5UGv6/VPsUyyhw2z5on2LkEFK
   ZYujVr4Cz3vdlv4lnvhl6IBl1EVVHgSnH2PqJ310XLVUs8t5WtCJkU4lO
   uCcq9PkmhDQPsZDZpu32nvNYuITf17ObCpIzTaMVqruv4mrN4DS1mUHyo
   A==;
X-CSE-ConnectionGUID: xMof4d6CTNCJcPAG5z9wAw==
X-CSE-MsgGUID: uSTHTZZSScGn23NNbZypxQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793732"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793732"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:25 -0800
X-CSE-ConnectionGUID: FMUVT5oISIiFE8aw8bxf+g==
X-CSE-MsgGUID: a3HxPKJGTNSJgJkL3zBVKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033053"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:21 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 10/18] KVM: TDX: Handle TDG.VP.VMCALL<GetTdVmCallInfo> hypercall
Date: Tue, 10 Dec 2024 08:49:36 +0800
Message-ID: <20241210004946.3718496-11-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
References: <20241210004946.3718496-1-binbin.wu@linux.intel.com>
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
TDX "the rest" breakout:
- Use TDVMCALL_STATUS prefix for TDX call status codes (Binbin)

v19:
- rename TDG_VP_VMCALL_GET_TD_VM_CALL_INFO => TDVMCALL_GET_TD_VM_CALL_INFO
---
 arch/x86/include/asm/shared/tdx.h |  1 +
 arch/x86/kvm/vmx/tdx.c            | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index a602d081cf1c..192ae798b214 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -22,6 +22,7 @@
 #define TDCS_NOTIFY_ENABLES		0x9100000000000010
 
 /* TDX hypercall Leaf IDs */
+#define TDVMCALL_GET_TD_VM_CALL_INFO	0x10000
 #define TDVMCALL_MAP_GPA		0x10001
 #define TDVMCALL_GET_QUOTE		0x10002
 #define TDVMCALL_REPORT_FATAL_ERROR	0x10003
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b5aae9d784f7..413359741085 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1528,6 +1528,20 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int tdx_get_td_vm_call_info(struct kvm_vcpu *vcpu)
+{
+	if (tdvmcall_a0_read(vcpu))
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
+	else {
+		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_SUCCESS);
+		kvm_r11_write(vcpu, 0);
+		tdvmcall_a0_write(vcpu, 0);
+		tdvmcall_a1_write(vcpu, 0);
+		tdvmcall_a2_write(vcpu, 0);
+	}
+	return 1;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	if (tdvmcall_exit_type(vcpu))
@@ -1550,6 +1564,8 @@ static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 		return tdx_emulate_rdmsr(vcpu);
 	case EXIT_REASON_MSR_WRITE:
 		return tdx_emulate_wrmsr(vcpu);
+	case TDVMCALL_GET_TD_VM_CALL_INFO:
+		return tdx_get_td_vm_call_info(vcpu);
 	default:
 		break;
 	}
-- 
2.46.0


