Return-Path: <kvm+bounces-33362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C5A7E9EA3DB
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 01:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B20EF188A1DD
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:51:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B34D1F63ED;
	Tue, 10 Dec 2024 00:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KzfkqQvi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEC61D968E;
	Tue, 10 Dec 2024 00:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733791718; cv=none; b=Km975na3hUvgg8j26UU0RGYYVVjq2L+FlZMQTHLcM/P6uglJXklsFOZc6n3ss1NO8WqYdZZg0Gz+ow0SIGd8+iTxLILU94J74q53cp3nOLEg1PfUAqFRKiB+DslxmDi80zjYkEC7o2GDCbVwpftn4ncYs2Gebe0LKxYpz3CM3D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733791718; c=relaxed/simple;
	bh=abkJj1S2ONcjiOqFLrz1o9/veYrxrEpPuYVVFZmUZMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=It7Wv9qxdv031s6pTvV5h39Tx/ABMQQk5pxPOI2MWi55ILwMy7ucsmIBSjaOL43+/uhil+cZHOkMYNvqcHyizBtugwM8NU7qLDfORmIYu4cEoNYzt0tW/33+8i51xncMAJBWlEqiTML3jCPT/cjcvS5xYTCuO+3UpFAQabeq0VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KzfkqQvi; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733791716; x=1765327716;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=abkJj1S2ONcjiOqFLrz1o9/veYrxrEpPuYVVFZmUZMA=;
  b=KzfkqQviz2CMx92tHJBCpq9JSJVRyAFiNDLZoNQUjNmQzRTeaIe1YS2r
   cxCArLUgiOr4iRyP83aA7cp6A7RQTCt0/YvuZqcxMl75gcKByrsTPylAX
   nbk3B1n0fC2PKMQVdMzdu5RfwWNT2iOH7CH9QYKeZN2UmZXuOONpzmNZK
   J+eLYltGcVVfjwRnZK/RKEsSuzWBSpvizX9XU8QClsg5XjJEVCzovgU6c
   ENYoihyqqqK+HYu3r6IV4gW0HfJBIZvezLcBSp6ECsz/SfQcyJWfzprrx
   arU8Arfs/rZFpuXPVQBzrWbr2VneQ4aGr9HpO2n1aqtNyi83SD9zY1mc3
   g==;
X-CSE-ConnectionGUID: htfJSwhCTzm3blk9cfnxfA==
X-CSE-MsgGUID: 1IZK7dRjRra00IFlb/BMEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11281"; a="44793762"
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="44793762"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:36 -0800
X-CSE-ConnectionGUID: IIyDdVHQQti7O3djBBLcAw==
X-CSE-MsgGUID: ddFBGUKPRlWC+nXAWLG4uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,220,1728975600"; 
   d="scan'208";a="96033077"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2024 16:48:32 -0800
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
Subject: [PATCH 13/18] KVM: TDX: Add methods to ignore VMX preemption timer
Date: Tue, 10 Dec 2024 08:49:39 +0800
Message-ID: <20241210004946.3718496-14-binbin.wu@linux.intel.com>
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

TDX doesn't support VMX preemption timer.  Implement access methods for VMM
to ignore VMX preemption timer.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" breakout:
- Dropped KVM_BUG_ON() in vt_cancel_hv_timer(). (Rick)
---
 arch/x86/kvm/vmx/main.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index c97d0540a385..4a9b176b8a36 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -757,6 +757,27 @@ static int vt_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
 	return vmx_set_identity_map_addr(kvm, ident_addr);
 }
 
+#ifdef CONFIG_X86_64
+static int vt_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
+			      bool *expired)
+{
+	/* VMX-preemption timer isn't available for TDX. */
+	if (is_td_vcpu(vcpu))
+		return -EINVAL;
+
+	return vmx_set_hv_timer(vcpu, guest_deadline_tsc, expired);
+}
+
+static void vt_cancel_hv_timer(struct kvm_vcpu *vcpu)
+{
+	/* VMX-preemption timer can't be set.  See vt_set_hv_timer(). */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_cancel_hv_timer(vcpu);
+}
+#endif
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -912,8 +933,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.pi_start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
-	.set_hv_timer = vmx_set_hv_timer,
-	.cancel_hv_timer = vmx_cancel_hv_timer,
+	.set_hv_timer = vt_set_hv_timer,
+	.cancel_hv_timer = vt_cancel_hv_timer,
 #endif
 
 	.setup_mce = vmx_setup_mce,
-- 
2.46.0


