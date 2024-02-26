Return-Path: <kvm+bounces-9729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 67201866D75
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:03:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 994D71C232A2
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C47D1292E0;
	Mon, 26 Feb 2024 08:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CGFGMhNd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (unknown [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69681272C0;
	Mon, 26 Feb 2024 08:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936145; cv=none; b=XYDRQTr7w1g0qxXrykQS0H6tNkxtjsVKq6Czr79XNMkEbNo0pbKTICzpym/olO2AiKtbzn4tpv6QMQedd3UDaj+bL6lZaAbfhcclLe2JAP3mEkR9s/WBjWwN/QWmTBH2axJ2/AoFi1c1OTO8IAhc9kg15NA/tNJ6dPYZop27Um0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936145; c=relaxed/simple;
	bh=b3kkpZaI6SioFJ/UllRObAK3OnMZFeZHEri4NH/LxV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BJx/7ZdTfbByRpLXULA7I9dePyXNnXufahE7sPE6VZDMWnIFKJpB9w0QMJeKE5mu3WS/cLpr9+wEAb8PsBpXLFUeJWYNZO71MFcPgk3DBMRwNwwRfSFOPaNl37cSBWaFqtTW9fqtrPUJiKS/XvofzMqUUiSMG3d68eQRrUUM1po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CGFGMhNd; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936144; x=1740472144;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b3kkpZaI6SioFJ/UllRObAK3OnMZFeZHEri4NH/LxV8=;
  b=CGFGMhNdhkR9ceqe2onv0Kq4lcMhvUZUOWwucl0+vR1Cyxlr1lUm4nTq
   2FpGfP0wwcL/EeqPX3ayi5zO5NsuLzeH5+fAjuN9eJ8MkunCOG1DqmNKM
   /1rJ1lpZw/pA7vcbPyuFKM7BcjJr0w4TNYvqAdDyb5BzeotP2QGzRhev3
   Sf+3fevNrIaEJD97xpKDHIfKFSyMOeyYDMrcfiuoOiyi8zlLZeyxHU0/Q
   536J3b//aVRyfsmwUljS/mY55vt6tDCd3v5whjXWJNyPK+hHztVx4hywH
   e4yAJiRVyh9tw5q2zVvNwzaH7PkoIFECnSDwioMpILOT60f9Ew8x/zkVq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751314"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751314"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735055"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:03 -0800
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
Subject: [PATCH v19 105/130] KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL
Date: Mon, 26 Feb 2024 00:26:47 -0800
Message-Id: <ab54980da397e6e9b7b8d6636dc88c11c303364f.1708933498.git.isaku.yamahata@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

The TDX Guest-Host communication interface (GHCI) specification defines
the ABI for the guest TD to issue hypercall.   It reserves vendor specific
arguments for VMM specific use.  Use it as KVM hypercall and handle it.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0be58cd428b3..c8eb47591105 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1008,8 +1008,41 @@ static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
+{
+	unsigned long nr, a0, a1, a2, a3, ret;
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
+	nr = kvm_r10_read(vcpu);
+	a0 = kvm_r11_read(vcpu);
+	a1 = kvm_r12_read(vcpu);
+	a2 = kvm_r13_read(vcpu);
+	a3 = kvm_r14_read(vcpu);
+
+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, true, 0);
+
+	tdvmcall_set_return_code(vcpu, ret);
+
+	if (nr == KVM_HC_MAP_GPA_RANGE && !ret)
+		return 0;
+	return 1;
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
2.25.1


