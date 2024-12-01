Return-Path: <kvm+bounces-32793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 601E89DF495
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 04:53:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2BF01635BF
	for <lists+kvm@lfdr.de>; Sun,  1 Dec 2024 03:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1963F9FB;
	Sun,  1 Dec 2024 03:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J7NWc9FG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC567DA6C;
	Sun,  1 Dec 2024 03:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733025130; cv=none; b=Y3b1kDAgyUpE6LYpxDeYPXMqwCTSuupvKpQoFtPFSiKwUWZtX1tBSrjiG/gU5IrtvH/9qD60SBNqN59o5n/gSf1HCCAHXDOdOb9zTZCtgQC2+ZMhtpFxIhvhsS3DmENWkLfTffr+v/LY0dONoW+FkTG7OQsqzUCyqFn0vYZbtx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733025130; c=relaxed/simple;
	bh=oKmFGpwaYPYX2xRtD/D2+9iqTkBry/YGOf7oF2I0Ijg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf47CKBS3COHA+FYGgne8Bgw4SZmXttGbc5CUfZOM/sS5QV84f40rbbOmWSz8TJRX8G0pYKm7JSFkBoIP8e8D777laI9+0PqSngXjTub8NlctGIOxOZEzbIroAJ+jtm+KxXxE1rc1t/rlRGEMJElVb7DAVXGy/usDVPlFKzZb4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J7NWc9FG; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733025128; x=1764561128;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oKmFGpwaYPYX2xRtD/D2+9iqTkBry/YGOf7oF2I0Ijg=;
  b=J7NWc9FG+4t6dWCbi1Jn2dVKT3SOxZTxfMssgSWaEmVZFKx6a3M2vcYO
   1vR6sUzGDpZJESyJcaW8dMptNdFcCwSXtqwwlyuC5YgbbX//RnLSpb6DR
   WpYaewzoqvM9OzfQUKO2vmx06alLbimo7ASuU0YY9tShBTcKOcpzO78SY
   fZ7nQ3qLWJTbbGY5RHI2rsXjCbxtNYFiRhre5RRBVp1gTt1lD+gPCeqwh
   IMg6JZ8+L4Hkh/sTFmyG/rgl+pc4x4bk53+vsM0Nk6zLr4/16VD8Y4nkN
   jhVj93DkWPlUx92dkItJQbDW6z03re5ul/jxCUchY/1X5I8G0Oj5MWPy1
   g==;
X-CSE-ConnectionGUID: j44x9Nk3QjCF9pqUqwmIEA==
X-CSE-MsgGUID: Ti/LWCa7S6qhv7AbUa7Z+A==
X-IronPort-AV: E=McAfee;i="6700,10204,11272"; a="50725105"
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="50725105"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:08 -0800
X-CSE-ConnectionGUID: EMEAzHAOTvyKOk3wFgyJIg==
X-CSE-MsgGUID: QB/iv6xjQDm1kIesk5yytQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,199,1728975600"; 
   d="scan'208";a="93257488"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2024 19:52:05 -0800
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
	michael.roth@amd.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH 3/7] KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL
Date: Sun,  1 Dec 2024 11:53:52 +0800
Message-ID: <20241201035358.2193078-4-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
References: <20241201035358.2193078-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle KVM hypercall for TDX according to TDX Guest-Host Communication
Interface (GHCI) specification.

The TDX GHCI specification defines the ABI for the guest TD to issue
hypercalls.   When R10 is non-zero, it indicates the TDG.VP.VMCALL is
vendor-specific.  KVM uses R10 as KVM hypercall number and R11-R14
as 4 arguments, while the error code is returned in R10.  Follow the
ABI and handle the KVM hypercall for TDX.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
Hypercalls exit to userspace breakout:
- Renamed from "KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL" to
  "KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL".
- Update the change log.
- Rebased on Sean's "Prep KVM hypercall handling for TDX" patch set.
  https://lore.kernel.org/kvm/20241128004344.4072099-1-seanjc@google.com
- Use the right register (i.e. R10) to set the return code after returning
  back from userspace.
---
 arch/x86/kvm/vmx/tdx.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 19fd8a5dabd0..4cc55b120ab0 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -957,8 +957,39 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+
+static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
+{
+	kvm_r10_write(vcpu, vcpu->run->hypercall.ret);
+	return 1;
+}
+
+static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
+{
+	int r;
+
+	/*
+	 * ABI for KVM tdvmcall argument:
+	 * In Guest-Hypervisor Communication Interface(GHCI) specification,
+	 * Non-zero leaf number (R10 != 0) is defined to indicate
+	 * vendor-specific.  KVM uses this for KVM hypercall.  NOTE: KVM
+	 * hypercall number starts from one.  Zero isn't used for KVM hypercall
+	 * number.
+	 *
+	 * R10: KVM hypercall number
+	 * arguments: R11, R12, R13, R14.
+	 */
+	r = __kvm_emulate_hypercall(vcpu, r10, r11, r12, r13, r14, true, 0,
+				    complete_hypercall_exit);
+
+	return r > 0;
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
+	if (tdvmcall_exit_type(vcpu))
+		return tdx_emulate_vmcall(vcpu);
+
 	switch (tdvmcall_leaf(vcpu)) {
 	default:
 		break;
-- 
2.46.0


