Return-Path: <kvm+bounces-39452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E40E2A470E9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:22:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9D25F188E140
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:22:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE24C1B0F1B;
	Thu, 27 Feb 2025 01:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="da8GQCWT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98BBB14885D;
	Thu, 27 Feb 2025 01:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619177; cv=none; b=cEKYVzI56LbJjxqLrtFknMws0TLCdBoa8la0D5Ni9h0B/+7gYZZgTNNa5xFE1+YvfgrVWxkp681lKi9qLpDff0lzmfZ5ZgsUVPwCCcbGfq+7iiFe9ofxVrjuA9GCb407IIOi03MTurb8aVUWZey82vXaIov5EltA7v58QQWshCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619177; c=relaxed/simple;
	bh=SUrcgcg5oLsLNX/TkXFvCFnyDw/4Fg8vQrrN66xcXXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ta04gYAY2xnkBYjJkbLTyMReUzPZXzO/oA8teQ+FpB3kmwUOyh/unfFyGy6jNjoZ7T0cC6KwID/tTfEFafFSlROYnEqKX1ymLRIuSgcN0tCQq2RoozWbsD4quF9y/xFle/XArr9E/bH4UfrZJdjZxiN9nY8bqd57QOo+iGM+eJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=da8GQCWT; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619176; x=1772155176;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SUrcgcg5oLsLNX/TkXFvCFnyDw/4Fg8vQrrN66xcXXs=;
  b=da8GQCWTBGcjxJ8myovRGfpLCtD5BC9no9w3fKimOpVBUJ5M8P5dv6np
   SpCHLBwiASVj9wqF0LWjzK93B5rkmDEdQEQ37kyjpjxaRMUNqFGwFf2+B
   Rn+u/pUsQG2QZRIHw8Slg3gFLA+p50QdGfe/Ts+q6OtmCCcgYJDIuBxew
   83PSXGdfuy58moSda52aV3EdJhB13af1A8fd9AtZFcri2FajYgiJo/wGO
   Mzb9h+T0AihKqV/3y/vExK1UzzD5dQ9njckHqJESS60+mfLUHXh7TY72V
   KBPMM6YhFzljkmLQAoRCw62cJXCTK4/fyhcvCCR54ok4ApVVGU2BFCRoS
   A==;
X-CSE-ConnectionGUID: dRjJMhf3TOCzvY5RZ96L/w==
X-CSE-MsgGUID: jFbYD8KbRoKgCyH3R17Qcw==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959654"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959654"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:35 -0800
X-CSE-ConnectionGUID: fQqVmp//Stib7W157oTdkw==
X-CSE-MsgGUID: 1AS+1REqSa2+t6glqUBusA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674917"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:32 -0800
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
Subject: [PATCH v2 14/20] KVM: TDX: Add methods to ignore VMX preemption timer
Date: Thu, 27 Feb 2025 09:20:15 +0800
Message-ID: <20250227012021.1778144-15-binbin.wu@linux.intel.com>
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

TDX doesn't support VMX preemption timer.  Implement access methods for VMM
to ignore VMX preemption timer.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- No change.

TDX "the rest" v1:
- Dropped KVM_BUG_ON() in vt_cancel_hv_timer(). (Rick)
---
 arch/x86/kvm/vmx/main.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 035c3ed263b7..75e7fef7914e 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -786,6 +786,27 @@ static int vt_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
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
@@ -941,8 +962,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
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


