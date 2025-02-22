Return-Path: <kvm+bounces-38952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55CEFA404F9
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:51:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12ABD17A368
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06047206F18;
	Sat, 22 Feb 2025 01:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bSNns/bb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAF52066F0;
	Sat, 22 Feb 2025 01:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188831; cv=none; b=lUbclW48EicGLzSa9RlFk8buvt/cwaYJzO4jItpuj+JFuerk/91e5XrpprHM2X5VmuIp2d0xVXOQXtAMs/VC+gL94myP7pMEbQWfErIOOQn74WaUqzOxSBa5Vf6NhB+EotdxKFW0MVy+7u0IDc9BEzb3xFjU14fdPw2rTMIrUH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188831; c=relaxed/simple;
	bh=Cfwn6HU3e2IFYzi9qNSuEwLhYbdFG/UOhxwbHzWCEVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaKSmVsL1jNkg6VXkXj9EoDWEt5rYnNX/7lJyzYSHuZMoQBzHhoWNdH1KuwZ20txX47Jhofes9VVKUp6UwV0wsk2rTTe2on8nEgi6axlyHR7lodKRmW4dhXt87CJNi+RcL7/EqOwVOuQvyGUTpcZEhV6QJG+upKIz9DGKCqczvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bSNns/bb; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188830; x=1771724830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cfwn6HU3e2IFYzi9qNSuEwLhYbdFG/UOhxwbHzWCEVA=;
  b=bSNns/bb0UmAQq44gR6Z6wijz5YNwZv5cUx75U/t0VdrtqatKnfMp+D5
   vJHmL7QDyB3Hywx0Nhy4SE9K/vFrpiUU2jphTw+EswRE1dTpyjt8Xc2ok
   qB2NTrkmwhM5MLjcMMnSnOHv/rYSLq3lIM/C1m5B4HbJ4w39sKrcNnMfS
   0q/cp7s4sWZYIqialjF725P8xKfY+ADfToEsv/YZ+7+pBlMwnUEuzHG6z
   2MeroM/kfiu2sYEtaI4TP7sDT6EPGu04OKmjGJf7jDyJm2ko3xsYbegTs
   Iisl/rQLO8tYZ67rgPM+dnLPIO/ecHM8bpPRY4GK33Qh1fsSJYTcIJWX7
   g==;
X-CSE-ConnectionGUID: dUi6Ez4IQrCVzsGSBZYE7g==
X-CSE-MsgGUID: TNCx81zFQZm5bxSD13KxMw==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449071"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449071"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:47:10 -0800
X-CSE-ConnectionGUID: akLafAdsQ22WJ4eb07ttfg==
X-CSE-MsgGUID: AmgJIk9JQHCR4mZ2KrncEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621733"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:47:06 -0800
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
Subject: [PATCH v3 14/16] KVM: VMX: Add a helper for NMI handling
Date: Sat, 22 Feb 2025 09:47:55 +0800
Message-ID: <20250222014757.897978-15-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250222014757.897978-1-binbin.wu@linux.intel.com>
References: <20250222014757.897978-1-binbin.wu@linux.intel.com>
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
TDX interrupts v3:
- Fix alignment in wrapped conditional (Sean)

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
index 493d191f348c..1b8b0d46d58b 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -177,4 +177,6 @@ static inline void __vmx_deliver_posted_interrupt(struct kvm_vcpu *vcpu,
 	kvm_vcpu_trigger_posted_interrupt(vcpu, POSTED_INTR_VECTOR);
 }
 
+noinstr void vmx_handle_nmi(struct kvm_vcpu *vcpu);
+
 #endif /* __KVM_X86_VMX_COMMON_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 84f26af888e5..8152560f519a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7218,6 +7218,20 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu,
 	}
 }
 
+noinstr void vmx_handle_nmi(struct kvm_vcpu *vcpu)
+{
+	if ((u16)vmx_get_exit_reason(vcpu).basic != EXIT_REASON_EXCEPTION_NMI ||
+	    !is_nmi(vmx_get_intr_info(vcpu)))
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
@@ -7261,15 +7275,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
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


