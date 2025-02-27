Return-Path: <kvm+bounces-39455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B103A470EF
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:24:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C280E16F671
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3AB21BD03F;
	Thu, 27 Feb 2025 01:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z4+Js9zr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7240214B965;
	Thu, 27 Feb 2025 01:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619186; cv=none; b=XY8annml1qjJ04rGFsS952YYP2a7Xwfg+43trX+TI/OTz6YfNhUOyJJp7rNmqPj5NTdKI/2EsBOWBWp9Ur/kJbx2jlHNfH0AnOYrQ3IQLpODG/HRsXZM2Wc3nojko5iWtN8NW7NYhpgWbJHo/62SEzbSXqSU+9AoRKFOvOpEUAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619186; c=relaxed/simple;
	bh=1FiDmvpnC4DRyC4nO4hfG0+/4Ilohx50+cijVzK/D84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8mOJ0WCGIZ1FrRHFSKBq/nKkTpmTjEfNBLJeuCp3b9uHGoU3c1JOu7aotLcZRaSvHXgl0zrQab3ihilX/6f+v00mud1vRCzPKB1kuhr3gFs/8EcJwbSQlvWZG1LPZyy+sXw5g58F9gWpKyXY+6/8Fs/V/bpeKHpF6c5ELiXPDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z4+Js9zr; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619185; x=1772155185;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1FiDmvpnC4DRyC4nO4hfG0+/4Ilohx50+cijVzK/D84=;
  b=Z4+Js9zr0GbskW+f1BXxNsTd7kYV72fmilMFftevKvUk+zxG8ITwaTzC
   FXfGHuFmQ+yJvts3CfPSm2WUyGoG1RLbNW9wjOAX3mv3CYTXJZaCmElBM
   d9yX48CGcipLaMPCJCvcOqlal3Ry4Pi8AZOoq4uKf7yg+qJcYhaKo3pcc
   emXjjmeU+pOE1eIXBW9io9wGUWZV+xlzrC+RXhS7LP6/oJ0n/Rl8ZPzHY
   7qB5GNRd+RIp7uXrOes5xVb0+Pg36jBE1n59IXF+5mJOKP8dFQpjCHYvP
   EeUJ/UZ2Ah9SONzZBOg8KODE2/Qo2L2kpzXBE6RGB9VqU724DSVCSb4qe
   g==;
X-CSE-ConnectionGUID: HToI0uZgTbmUo8PjBibOJQ==
X-CSE-MsgGUID: F6TwHFvaRX29bFmURnD6xA==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959689"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959689"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:45 -0800
X-CSE-ConnectionGUID: iSPkmwjEQY2LeeHmHd6tNg==
X-CSE-MsgGUID: AC5V+EonQRCorckgj1u9Lw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674928"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:41 -0800
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
Subject: [PATCH v2 17/20] KVM: TDX: Add a method to ignore hypercall patching
Date: Thu, 27 Feb 2025 09:20:18 +0800
Message-ID: <20250227012021.1778144-18-binbin.wu@linux.intel.com>
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

Because guest TD memory is protected, VMM patching guest binary for
hypercall instruction isn't possible.  Add a method to ignore hypercall
patching.  Note: guest TD kernel needs to be modified to use
TDG.VP.VMCALL for hypercall.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- No change.

TDX "the rest" v1:
- Renamed from
  "KVM: TDX: Add a method to ignore for TDX to ignore hypercall patch"
  to "KVM: TDX: Add a method to ignore hypercall patching".
- Dropped KVM_BUG_ON() in vt_patch_hypercall(). (Rick)
- Remove "with a warning" from "Add a method to ignore hypercall
  patching with a warning." in changelog to reflect code change.
---
 arch/x86/kvm/vmx/main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d73ea9ce750d..fa8b5f609666 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -673,6 +673,19 @@ static u32 vt_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 	return vmx_get_interrupt_shadow(vcpu);
 }
 
+static void vt_patch_hypercall(struct kvm_vcpu *vcpu,
+				  unsigned char *hypercall)
+{
+	/*
+	 * Because guest memory is protected, guest can't be patched. TD kernel
+	 * is modified to use TDG.VP.VMCALL for hypercall.
+	 */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_patch_hypercall(vcpu, hypercall);
+}
+
 static void vt_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
 	if (is_td_vcpu(vcpu))
@@ -952,7 +965,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vt_set_interrupt_shadow,
 	.get_interrupt_shadow = vt_get_interrupt_shadow,
-	.patch_hypercall = vmx_patch_hypercall,
+	.patch_hypercall = vt_patch_hypercall,
 	.inject_irq = vt_inject_irq,
 	.inject_nmi = vt_inject_nmi,
 	.inject_exception = vt_inject_exception,
-- 
2.46.0


