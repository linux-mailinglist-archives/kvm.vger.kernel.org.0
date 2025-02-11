Return-Path: <kvm+bounces-37802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC83A301EE
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 04:01:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CB0F16A00F
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B601EE005;
	Tue, 11 Feb 2025 02:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FlRJIc/M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70341EDA1F;
	Tue, 11 Feb 2025 02:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242663; cv=none; b=SzPzUJqd2VOlHgU7MpkTr2szali76SzNFSpVI0gtB3RACG2nCv/AUjG8Tgsvi6MFqGFVKKOKu+uZbQTqqS1NFRhbB7MONOUgN+nY7Kli9Sv/jiZIFbWmXPkq/HPBcjm3Pvw4jPg7/y5kF9nWijCW04iuViKRnjpEqsFJ0ZvKQnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242663; c=relaxed/simple;
	bh=FV0WZsrthMaM2qN31sE3aoRmjuGUTSCb2CSEqy469C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giDZF9KD01PxekBk+U4BK3d8Rq+mzsEXXMwmu6QB5TD85F1Q+9NnVQA1K72aUgPXiFqVTYJVcenCxyCvxxvLV2vgN9lXsD2xCHMsEEs9pLRfY9JgyS+yInQrGGcjbYtH3UuEaoRDlsdzZGnAORu0jf76NpHsmlNB9kddG09Q6Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FlRJIc/M; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242662; x=1770778662;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FV0WZsrthMaM2qN31sE3aoRmjuGUTSCb2CSEqy469C8=;
  b=FlRJIc/M+d0uBsqQvslea/f2pXu1aVWbaTG4wnCST1Ba7cmwh1QVogcL
   9SvhjHkBesRIB7KTQgiL5KiEb470F4tzRsyp4Q9ON1Kco8YcWMtk3N86o
   WQonXESFFf4/q3M1k9FKcgEI8ZUQePwFfdrAAowknUO53GsEYtyePZdd0
   0nBfKrNQGVjNqORiqhTOSkpqkIGC4F7453bLrb9V1FZN/VOYYMnXbqxfa
   KbSKJjEy0lK+cWuHyZTK9gcsG6X5FFvb0YAvy+f7sY368AdP8EIIK1O4e
   +lrAhOYXesUdiakZaHtyVTh6gM8jDb1Q17wJese1fNvV0KnVbaL16XoOd
   A==;
X-CSE-ConnectionGUID: UGNq65/NSRSvBRKi70dR8g==
X-CSE-MsgGUID: Dlc5o08VRF64NS5bvwNfyg==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612494"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612494"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:42 -0800
X-CSE-ConnectionGUID: lZM3KiLAQy+oRj/DsCtsjA==
X-CSE-MsgGUID: QfEXnsqiQ6iuiZ9o0lJfZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355383"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:38 -0800
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
Subject: [PATCH v2 15/17] KVM: VMX: Add a helper for NMI handling
Date: Tue, 11 Feb 2025 10:58:26 +0800
Message-ID: <20250211025828.3072076-16-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a helper to handles NMI exit.

TDX handles the NMI exit the same as VMX case.  Add a helper to share the
code with TDX, expose the helper in common.h.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v2:
- Renamed from "KVM: VMX: Move NMI/exception handler to common helper".
- Revert the unnecessary move, because in later patch TDX will reuse
  vmx_handle_exit_irqoff() as handle_exit_irqoff() callback.
- Add the check for NMI to __vmx_handle_nmi() and rename it to vmx_handle_nmi().
- Update change log according to the change.

TDX interrupts v1:
- Update change log with suggestions from (Binbin)
- Move the NMI handling code to common header and add a helper
  __vmx_handle_nmi() for it. (Binbin)
---
 arch/x86/kvm/vmx/common.h |  2 ++
 arch/x86/kvm/vmx/vmx.c    | 24 +++++++++++++++---------
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index f26f7b1acbca..67b16bd8a788 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -180,4 +180,6 @@ static inline void __vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu,
 	kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR);
 }
 
+noinstr void vmx_handle_nmi(struct kvm_vcpu *vcpu);
+
 #endif /* __KVM_X86_VMX_COMMON_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 012649688e46..228a7e51b6a5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7212,6 +7212,20 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu,
 	}
 }
 
+noinstr void vmx_handle_nmi(struct kvm_vcpu *vcpu)
+{
+	if ((u16)vmx_get_exit_reason(vcpu).basic != EXIT_REASON_EXCEPTION_NMI ||
+		!is_nmi(vmx_get_intr_info(vcpu)))
+		return;
+
+	kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
+	if (cpu_feature_enabled(X86_FEATURE_FRED))
+		fred_entry_from_kvm(EVENT_TYPE_NMI, NMI_VECTOR);
+	else
+		vmx_do_nmi_irqoff();
+	kvm_after_interrupt(vcpu);
+}
+
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					unsigned int flags)
 {
@@ -7255,15 +7269,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	if (likely(!vmx_get_exit_reason(vcpu).failed_vmentry))
 		vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
 
-	if ((u16)vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXCEPTION_NMI &&
-	    is_nmi(vmx_get_intr_info(vcpu))) {
-		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
-		if (cpu_feature_enabled(X86_FEATURE_FRED))
-			fred_entry_from_kvm(EVENT_TYPE_NMI, NMI_VECTOR);
-		else
-			vmx_do_nmi_irqoff();
-		kvm_after_interrupt(vcpu);
-	}
+	vmx_handle_nmi(vcpu);
 
 out:
 	guest_state_exit_irqoff();
-- 
2.46.0


