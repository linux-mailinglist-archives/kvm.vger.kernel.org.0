Return-Path: <kvm+bounces-38954-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B184A404FD
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 02:51:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B5D617D8CF
	for <lists+kvm@lfdr.de>; Sat, 22 Feb 2025 01:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB811207A03;
	Sat, 22 Feb 2025 01:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cHplnZpb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9500E20766A;
	Sat, 22 Feb 2025 01:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740188838; cv=none; b=QuLuHIKyvFErmRsFA51J8D7ijq7me4VhgbXTG+rYABIcWPqu9+g/Qq552QZX82yjrF5nIH/9uj246oEqmAKhnoUfujE6SBkPgpzt8Ui/PEv007M3UGIoRCRGpaiBJR3vrGXkW+KP6KluIZVqByzb9KcFMDMTa7nKCYhkOMGVMGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740188838; c=relaxed/simple;
	bh=J2sIVb+E0KESOFxsXNIk/sv4uLCGBRMwRyAKo+HWNqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AdPMsyHUpOSRKLZ6Liv0yy29B6J5VQm2wTG8J7Qt1L+32KWfXRN5yGEeG+KTIP41NCqm5lFugUHnXA90ezGHiPiuf3Wpmz2xRK6ZHengz0mxnuBnPNCNIAvr97L6dkX/jBJfsEvtRC7kK8EBe9LCKhMBBTgiqRZjIY7kPoxV2pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cHplnZpb; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740188837; x=1771724837;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J2sIVb+E0KESOFxsXNIk/sv4uLCGBRMwRyAKo+HWNqo=;
  b=cHplnZpb6FOZQmDw6b0iGtcg7qjjBLaFygWCYOh3pJNHzS6902lbmT8/
   7b0+t2MnnSlSz1yeEdBzi5ldECZabFfZldcqVIblV5SfDVhOSmX/Uwy14
   eLm481gyt3GxdtCFgI2rciffBC59zGRxn2jrqytiPx3/qmzF5mHHmcd8K
   +EAqgT704DVPI16GhCBoTnkdz/r9e+THqy375CU2UIq3g1daxPvtYYZIM
   uyTjATDxhYlEftQvVYQ6nFck4nGslLT7fqPbWbBQ+3bxN3lqt66BvNKNm
   fdsedUhEirXw+7DTc9W/i34s7hFiUcu4X1aSB80vQRNPAR5pobcGmqJBU
   w==;
X-CSE-ConnectionGUID: fe6iK7X2T8i1QYVjbMomtg==
X-CSE-MsgGUID: KsCZSZBQTCKZHPXUPyrUBg==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="52449079"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="52449079"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:47:16 -0800
X-CSE-ConnectionGUID: RGnKI1A0SIKwNi07XZ22uQ==
X-CSE-MsgGUID: vyikwM8nSL2IS5vjzSzT0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,306,1732608000"; 
   d="scan'208";a="120621747"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2025 17:47:13 -0800
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
Subject: [PATCH v3 16/16] KVM: TDX: Handle EXIT_REASON_OTHER_SMI
Date: Sat, 22 Feb 2025 09:47:57 +0800
Message-ID: <20250222014757.897978-17-binbin.wu@linux.intel.com>
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
TDX interrupts v3:
 - No change.

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
index 2eed02dec17b..ea5b26872e68 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1747,6 +1747,27 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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


