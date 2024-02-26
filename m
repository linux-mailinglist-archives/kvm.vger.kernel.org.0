Return-Path: <kvm+bounces-9744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7331866DA9
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:08:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 038921C234B0
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:08:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D34812F36C;
	Mon, 26 Feb 2024 08:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UIza5fJt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328C712D75C;
	Mon, 26 Feb 2024 08:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936157; cv=none; b=HAYSw9L3xvvtn7J/Ty0JyqmgPGDUs0VxPc4x7hsypVZqFEFI2m02hY/83WXW/X/lin6f9oBUFPTBa/Rthgj3URsZHGlXwiYs7Pwjra4MFOFOaCmxknruNHvREg55I17S62241UJwOBKSZn3VhaGspJceTo7PwOlwoUtDjr9temc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936157; c=relaxed/simple;
	bh=0yh1shLe8hwMZzN1bzwtQ5WkdmEz/o+wucegI0YBDwc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HfExOVqAdJY5zDQPlZgVoCZMekCNM1rTmMMu2H0oZmTC+ySJan8ZIH2r0OQFzOZd0z/wpJ966RlmXYSzlxW37iaX+gIVbLqpa/YsN4w1llo7BAuHXgZdVkrsJ+1oXccyy60+rmoggVp4oZ3gr0ctWVQEuOraywVAhkjccQB3B/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UIza5fJt; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936155; x=1740472155;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0yh1shLe8hwMZzN1bzwtQ5WkdmEz/o+wucegI0YBDwc=;
  b=UIza5fJtF+MSSSNWEh+XJEcn10Yx+Unzbgm57cTWtbhiQQe/fmj4Q6r0
   IFPYOpRu9f+t1l+SIY5TmM4FdgNH8DTBCuLEU+0Sfr2VgrNqBt7wuNDwy
   REo/m09TP3ydaojs3gvZu+M6vQhAmHA9FZEObN4AYwf9MLLbbMqgVQ1qi
   lmTq6eyYJAg0oDvBSizYNEzo62MXw7XMuiiV2Kh5AZhEnBQTJ9HzWdb9q
   BC7OeSGs980gUoIxyKheOiyXETtW/J5VOfoQS7DdwW7d6+b/DxfIpLccD
   2d3cj0NqHypbx6shOuEuCp4yDCQzVTJFnuZ9QIGhVfgko2aqlNORMrIHp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751391"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751391"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735123"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:10 -0800
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
Subject: [PATCH v19 121/130] KVM: TDX: Add methods to ignore VMX preemption timer
Date: Mon, 26 Feb 2024 00:27:03 -0800
Message-Id: <30cd8696d4c6ab2e909b9ded93049ab217c713f8.1708933498.git.isaku.yamahata@intel.com>
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

TDX doesn't support VMX preemption timer.  Implement access methods for VMM
to ignore VMX preemption timer.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 991bfdecaed2..ec5c0fda92e9 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -842,6 +842,27 @@ static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 	vmx_update_cpu_dirty_logging(vcpu);
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
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
+	vmx_cancel_hv_timer(vcpu);
+}
+#endif
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -1024,8 +1045,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.pi_start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
-	.set_hv_timer = vmx_set_hv_timer,
-	.cancel_hv_timer = vmx_cancel_hv_timer,
+	.set_hv_timer = vt_set_hv_timer,
+	.cancel_hv_timer = vt_cancel_hv_timer,
 #endif
 
 	.setup_mce = vmx_setup_mce,
-- 
2.25.1


