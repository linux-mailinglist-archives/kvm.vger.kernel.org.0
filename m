Return-Path: <kvm+bounces-37804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CFAEA301F1
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 04:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91100188CECB
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 266151EE7DF;
	Tue, 11 Feb 2025 02:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SLBctGEX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44361D6194;
	Tue, 11 Feb 2025 02:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242670; cv=none; b=fPAZIOxKRqDooBQTpniH48817zcT56+kRFHjPeSjuQCPOMoMMfUeMKo7/I8zyQ+qCC+41f+2plRx6t+59sPyukI7KQWV5efejhg7PfFMKE3MnwYuIzI0KGmaGX1r5lcvirnCYUpUDoUDtlBIgQ6IFAljGCD3X6q7oSkLzHunntY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242670; c=relaxed/simple;
	bh=vudZ5K3IFaxeq9DTI8OWx6fBV6DjJ5H44UBi6vmR0w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4SeX/KCRAUSLC56/Bijgy6BY3pogr4FoBuzWeBrBlUxqRgRfP/clPjJ6m5kfjuonLe2CeQkkyrra5wuDHXQ0Y+4pdtDI2qPLZSFJkQP7v8ZREYhBZvcBbBFamBV/9SQmN/nRZDi2VMIG1xw+feTL2U0j1cFdSIktHO8ZGTT4ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SLBctGEX; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242669; x=1770778669;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vudZ5K3IFaxeq9DTI8OWx6fBV6DjJ5H44UBi6vmR0w8=;
  b=SLBctGEXTFg9Ke8BXc6EDPoO31N5dbaGR/wZVHEEhttl+Htk2Ai71Gs3
   tJ/UkCALF1sLHQ9NqOvLnWS/13kVCxcRbhjU2Nh3EHEHCYYf9lu0bAnXP
   x+LtbfcSVPoEegIP1foDirs6+ycfGjoJmghWcjiMWcrSJPWEMbsUc9Wwu
   7SMk0Ll2ooRmzdA9IjTezq0Px7ZCHA2wCUxoKlwYZWeF8To0vlCLqBA3n
   Q8ue2mWzohJt3ARv7pVN7W/Shn+hNWCRLnQmleJ8Sokl1xwVwr9KO/5Z1
   Z05glJqpLZ+vLV4oJVI3AvrXc+LIen2JElZicmc7IEifjpS6WnYWgzYQs
   A==;
X-CSE-ConnectionGUID: nKyrvNnxS2u0jYRjw63a1w==
X-CSE-MsgGUID: 1IyNgffTSI27FABaS+APHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612502"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612502"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:49 -0800
X-CSE-ConnectionGUID: xMl9xGgZSTavRs7yvTlPoA==
X-CSE-MsgGUID: hjOFcWqxR0eXv/5pjR94Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355389"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:45 -0800
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
Subject: [PATCH v2 17/17] KVM: TDX: Handle EXIT_REASON_OTHER_SMI
Date: Tue, 11 Feb 2025 10:58:28 +0800
Message-ID: <20250211025828.3072076-18-binbin.wu@linux.intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Handle VM exit caused by "other SMI" for TDX, by returning back to
userspace for Machine Check System Management Interrupt (MSMI) case or
ignoring it and resume vCPU for non-MSMI case.

For VMX, SMM transition can happen in both VMX non-root mode and VMX
root mode.  Unlike VMX, in SEAM root mode (TDX module), all interrupts
are blocked. If an SMI occurs in SEAM non-root mode (TD guest), the SMI
causes VM exit to TDX module, then SEAMRET to KVM. Once it exits to KVM,
SMI is delivered and handled by kernel handler right away.

An SMI can be "I/O SMI" or "other SMI".  For TDX, there will be no I/O SMI
because I/O instructions inside TDX guest trigger #VE and TDX guest needs
to use TDVMCALL to request VMM to do I/O emulation.

For "other SMI", there are two cases:
- MSMI case.  When BIOS eMCA MCE-SMI morphing is enabled, the #MC occurs in
  TDX guest will be delivered as an MSMI.  It causes an
  EXIT_REASON_OTHER_SMI VM exit with MSMI (bit 0) set in the exit
  qualification.  On VM exit, TDX module checks whether the "other SMI" is
  caused by an MSMI or not.  If so, TDX module marks TD as fatal,
  preventing further TD entries, and then completes the TD exit flow to KVM
  with the TDH.VP.ENTER outputs indicating TDX_NON_RECOVERABLE_TD.  After
  TD exit, the MSMI is delivered and eventually handled by the kernel
  machine check handler (7911f145de5f x86/mce: Implement recovery for
  errors in TDX/SEAM non-root mode), i.e., the memory page is marked as
  poisoned and it won't be freed to the free list when the TDX guest is
  terminated.  Since the TDX guest is dead, follow other non-recoverable
  cases, exit to userspace.
- For non-MSMI case, KVM doesn't need to do anything, just continue TDX
  vCPU execution.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX interrupts v2:
 - No change.

TDX interrupts v1:
 - Squashed "KVM: TDX: Handle EXIT_REASON_OTHER_SMI" and
   "KVM: TDX: Handle EXIT_REASON_OTHER_SMI with MSMI". (Chao)
 - Rewrite the changelog.
 - Remove the explicit call of kvm_machine_check() because the MSMI can
   be handled by host #MC handler.
 - Update comments according to the code change.
---
 arch/x86/include/uapi/asm/vmx.h |  1 +
 arch/x86/kvm/vmx/tdx.c          | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vmx.h
index 6a9f268a2d2c..f0f4a4cf84a7 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -34,6 +34,7 @@
 #define EXIT_REASON_TRIPLE_FAULT        2
 #define EXIT_REASON_INIT_SIGNAL			3
 #define EXIT_REASON_SIPI_SIGNAL         4
+#define EXIT_REASON_OTHER_SMI           6
 
 #define EXIT_REASON_INTERRUPT_WINDOW    7
 #define EXIT_REASON_NMI_WINDOW          8
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2fa7ba465d10..f7b8b52c5a76 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1750,6 +1750,27 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return tdx_emulate_io(vcpu);
 	case EXIT_REASON_EPT_MISCONFIG:
 		return tdx_emulate_mmio(vcpu);
+	case EXIT_REASON_OTHER_SMI:
+		/*
+		 * Unlike VMX, SMI in SEAM non-root mode (i.e. when
+		 * TD guest vCPU is running) will cause VM exit to TDX module,
+		 * then SEAMRET to KVM.  Once it exits to KVM, SMI is delivered
+		 * and handled by kernel handler right away.
+		 *
+		 * The Other SMI exit can also be caused by the SEAM non-root
+		 * machine check delivered via Machine Check System Management
+		 * Interrupt (MSMI), but it has already been handled by the
+		 * kernel machine check handler, i.e., the memory page has been
+		 * marked as poisoned and it won't be freed to the free list
+		 * when the TDX guest is terminated (the TDX module marks the
+		 * guest as dead and prevent it from further running when
+		 * machine check happens in SEAM non-root).
+		 *
+		 * - A MSMI will not reach here, it's handled as non_recoverable
+		 *   case above.
+		 * - If it's not an MSMI, no need to do anything here.
+		 */
+		return 1;
 	default:
 		break;
 	}
-- 
2.46.0


