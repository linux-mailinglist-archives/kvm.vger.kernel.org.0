Return-Path: <kvm+bounces-37782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E0C8A301BB
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:54:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C49987A34B6
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522261DFDAB;
	Tue, 11 Feb 2025 02:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ukgm/O5q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10C51DB13A;
	Tue, 11 Feb 2025 02:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242401; cv=none; b=k6zxwAAXNngbKVKk/4FtbKEDJdNUg0AuFDOxEG/knNh6Pwgj4ltCv6EojFNpkW5Wf3+p8yoZQcrGO2XIWATtbHH/c25AdsH+WIX/LyTNMrs6NfCd8tz5iVsP1Ia2vciVWOK8VlTyvg2zDPwHQvaIwMN8eNtEFVNeC69mfpEsnKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242401; c=relaxed/simple;
	bh=ogoIy/jiJ8cy9vidxoi3hYkSe6CCjoWYa2WLQH0sAdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7ygAepKOLwRqYLjKT5gTTPXYPDsJapxvjKPgtw/TY8T9OnaPzPp6Or3ZEg/yxsGqNEmsG0GEVTA7RWYCdIFNXQNNXbBtfifVdGXa/km+ND6+R0jQ5XG4ldinZsTmILVvYT4v/kG8zHkHLYR39xnEgWv+Sw3By0XQO44clDokRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ukgm/O5q; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242401; x=1770778401;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ogoIy/jiJ8cy9vidxoi3hYkSe6CCjoWYa2WLQH0sAdQ=;
  b=Ukgm/O5qlEtmrYLuZdM8BemG8V/EPciGaL4ig83/BZmHgumFFB0yRzae
   5gCurf+fFqca/AhZ5rfdSpkzgMbQ5dZ7i23I1aDRDDF/5I6uqrwfoZcke
   QX6qVX/H7Si9fmKNC14JD6bYNNUEMcM48z7Vb6YCVoCHIpF7PN2vHDwfd
   viwnEtB6lQt/BEe8iLPrF45WL9pTAdd9D85ZPaM4ZTgjPcbpC4h2oiRdU
   QGDj/6REH2j3REWu94O//wG6Y52kbpWqXna6qXKz6Id0nWakiVCZ/8phK
   IdkEpRpF8rl+1O+0wf29tJtz1LiqGUjgo94SK1I6EbZGqr6KqlRWRBYo8
   A==;
X-CSE-ConnectionGUID: a+n3nQjASiGE5e2bPXKQvA==
X-CSE-MsgGUID: +GSErN6AQg2L3Ow5DY7Rag==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43506615"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43506615"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:20 -0800
X-CSE-ConnectionGUID: Ywmm9UHiRci364UKLjY/pQ==
X-CSE-MsgGUID: D2Lb1Y7GSoSclHdJQvL1jQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112236431"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:53:16 -0800
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
Subject: [PATCH v2 4/8] KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL
Date: Tue, 11 Feb 2025 10:54:38 +0800
Message-ID: <20250211025442.3071607-5-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
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
hypercalls.  When R10 is non-zero, it indicates the TDG.VP.VMCALL is
vendor-specific.  KVM uses R10 as KVM hypercall number and R11-R14
as 4 arguments, while the error code is returned in R10.

Morph the TDG.VP.VMCALL with KVM hypercall to EXIT_REASON_VMCALL and
marshall r10~r14 from vp_enter_args to the appropriate x86 registers for
KVM hypercall handling.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
Hypercalls exit to userspace v2:
- Morph the TDG.VP.VMCALL with KVM hypercall to EXIT_REASON_VMCALL.
- Marshall values to the appropriate x86 registers for KVM hypercall
  handling.

Hypercalls exit to userspace v1:
- Renamed from "KVM: TDX: handle KVM hypercall with TDG.VP.VMCALL" to
  "KVM: TDX: Handle KVM hypercall with TDG.VP.VMCALL".
- Update the change log.
- Rebased on Sean's "Prep KVM hypercall handling for TDX" patch set.
  https://lore.kernel.org/kvm/20241128004344.4072099-1-seanjc@google.com
- Use the right register (i.e. R10) to set the return code after returning
  back from userspace.
---
 arch/x86/kvm/vmx/tdx.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 420ee492e919..daa49f2ee2b3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -964,6 +964,23 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	return tdx_exit_handlers_fastpath(vcpu);
 }
 
+static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
+{
+	tdvmcall_set_return_code(vcpu, vcpu->run->hypercall.ret);
+	return 1;
+}
+
+static int tdx_emulate_vmcall(struct kvm_vcpu *vcpu)
+{
+	kvm_rax_write(vcpu, to_tdx(vcpu)->vp_enter_args.r10);
+	kvm_rbx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r11);
+	kvm_rcx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r12);
+	kvm_rdx_write(vcpu, to_tdx(vcpu)->vp_enter_args.r13);
+	kvm_rsi_write(vcpu, to_tdx(vcpu)->vp_enter_args.r14);
+
+	return __kvm_emulate_hypercall(vcpu, 0, complete_hypercall_exit);
+}
+
 static int handle_tdvmcall(struct kvm_vcpu *vcpu)
 {
 	switch (tdvmcall_leaf(vcpu)) {
@@ -1309,6 +1326,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return 0;
 	case EXIT_REASON_TDCALL:
 		return handle_tdvmcall(vcpu);
+	case EXIT_REASON_VMCALL:
+		return tdx_emulate_vmcall(vcpu);
 	default:
 		break;
 	}
-- 
2.46.0


