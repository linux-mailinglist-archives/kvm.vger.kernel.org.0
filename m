Return-Path: <kvm+bounces-9748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58380866DB3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:09:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 127B0285712
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E67EB12FF9E;
	Mon, 26 Feb 2024 08:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GPOfaT4V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C7A12F38A;
	Mon, 26 Feb 2024 08:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936160; cv=none; b=jxGgeVJvBzwI84uTeVRW5yk0PZy1efzQRYTFyHtRLjAYfKQktB+Xb9SkVrIceLnyAwMc8e1xToDERQm56+csCiYf54Gflry8v9nG+nNsJXl4xZ+QZbPXQbbgr2TQsIiaWIsl84Pu0aT798txvhDWk/4RUh+rPm0oCUXtrqNabXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936160; c=relaxed/simple;
	bh=riRqyN0CYgRzjdvvWWc6SvA55IJM4w/WwMYuoEgr/9o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=peq1TJEJF0trjfSrovK5Nk72FNxprdJ26BtkAVPtkqRZe20bp5gdbZFGcWgNDjiiWopE98vO9NGpz5cxbs0D1u2Iec0TewnPRsRMcNcRRumf1UA8U73HrQtgwN4/j2WB+p64P75gv6+4PoSQz4zxO2h/gCmD30vwAbSbAqomn44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GPOfaT4V; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936159; x=1740472159;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=riRqyN0CYgRzjdvvWWc6SvA55IJM4w/WwMYuoEgr/9o=;
  b=GPOfaT4VxkV8Ej8PGWkoCqm+hr6we8qq8ckGhtwEvLUbDAeLoK6t4X1r
   KtXBsAmjSpPDMs6Rx4XhM0jnEEiuWATa52VOmzB8BoUUIyTxkE74WLA3z
   z3tqF/Z/a7lWU/mcluX4EgXSBzIzGZaJINhbK7JJjlqGbVem3pDxlYEv2
   03BJjfkR0AX7BTqF4I6PREwOppHRq+5VWtj2OiieeJ8Mu87vn469aJ6pF
   5oOF/erAkjZkbCZXNUbUeb6+1KWKMBRU350THkh/fBwEF2aax4YjEoORr
   eSv0IhMKr2z3VxzcGDvHj15i3tSJEEKgc8OcWwP7h9UM+qmL1P/BNzNhA
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="20751404"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="20751404"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="6735137"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:11 -0800
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
Subject: [PATCH v19 124/130] KVM: TDX: Add a method to ignore for TDX to ignore hypercall patch
Date: Mon, 26 Feb 2024 00:27:06 -0800
Message-Id: <7191f6856003e5315c72a9dffc53cafd6e529acd.1708933498.git.isaku.yamahata@intel.com>
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

Because guest TD memory is protected, VMM patching guest binary for
hypercall instruction isn't possible.  Add a method to ignore hypercall
patching with a warning.  Note: guest TD kernel needs to be modified to use
TDG.VP.VMCALL for hypercall.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/main.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7c47b02d88d8..fae5a3668361 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -731,6 +731,19 @@ static u32 vt_get_interrupt_shadow(struct kvm_vcpu *vcpu)
 	return vmx_get_interrupt_shadow(vcpu);
 }
 
+static void vt_patch_hypercall(struct kvm_vcpu *vcpu,
+				  unsigned char *hypercall)
+{
+	/*
+	 * Because guest memory is protected, guest can't be patched. TD kernel
+	 * is modified to use TDG.VP.VMCAL for hypercall.
+	 */
+	if (KVM_BUG_ON(is_td_vcpu(vcpu), vcpu->kvm))
+		return;
+
+	vmx_patch_hypercall(vcpu, hypercall);
+}
+
 static void vt_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 {
 	if (is_td_vcpu(vcpu))
@@ -1030,7 +1043,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vt_set_interrupt_shadow,
 	.get_interrupt_shadow = vt_get_interrupt_shadow,
-	.patch_hypercall = vmx_patch_hypercall,
+	.patch_hypercall = vt_patch_hypercall,
 	.inject_irq = vt_inject_irq,
 	.inject_nmi = vt_inject_nmi,
 	.inject_exception = vt_inject_exception,
-- 
2.25.1


