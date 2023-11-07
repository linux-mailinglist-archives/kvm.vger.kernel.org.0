Return-Path: <kvm+bounces-993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EECE77E42C4
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:07:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7F08282471
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CCD23A26F;
	Tue,  7 Nov 2023 15:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n+aBCbFa"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEAD374FC
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:07 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C1A5BA2;
	Tue,  7 Nov 2023 07:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369319; x=1730905319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FjYtM5RVeAt6DwS0DVP0GicyoumcVKYRPAacFq6P70U=;
  b=n+aBCbFaGaIIGtrobqmehdTqMhbXel4dPHrG9wPbpv368Cr45qhOH6Ep
   uzEvlQiAeDAHX5VdQNTZOzNHYGA6c00HjmKMmnedgqrOK6JtWRBtLtVfq
   qJR+srMExi0gcp3KYBYef5myinwL++VcTFCz6DZcZpy4/Ye4VXsLSzZ/b
   0tclT7At+r3IBblJzd+CLoVkfCIoVVatr27u9wVYV4CBsU8AdzqqWtnOn
   vtpY/tJXWnUOnOBLocXnUGaNXVU7T3oGuHD/ZEVdVqU/tPEy/bOcvWP2Z
   ebSomsZ4GBeKp19shq07dAU6ajopvm0f7h7fagaMNbXJGo1MqH/in/jUW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462568"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462568"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851555"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:23 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 087/116] KVM: TDX: Handle EXIT_REASON_OTHER_SMI with MSMI
Date: Tue,  7 Nov 2023 06:56:53 -0800
Message-Id: <fa4824d69c77f6f02dc8525060812255e7410874.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

When BIOS eMCA MCE-SMI morphing is enabled, the #MC is morphed to MSMI
(Machine Check System Management Interrupt).  Then the SMI causes TD exit
with the read reason of EXIT_REASON_OTHER_SMI with MSMI bit set in the exit
qualification to KVM instead of EXIT_REASON_EXCEPTION_NMI with MC
exception.

Handle EXIT_REASON_OTHER_SMI with MSMI bit set in the exit qualification as
MCE(Machine Check Exception) happened during TD guest running.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/tdx.c      | 40 ++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx_arch.h |  2 ++
 2 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dc600ea7115f..317d8cf7f1cd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -890,6 +890,30 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 						     tdexit_intr_info(vcpu));
 	else if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
 		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
+	else if (unlikely(tdx->exit_reason.non_recoverable ||
+		 tdx->exit_reason.error)) {
+		/*
+		 * The only reason it gets EXIT_REASON_OTHER_SMI is there is an
+		 * #MSMI(Machine Check System Management Interrupt) with
+		 * exit_qualification bit 0 set in TD guest.
+		 * The #MSMI is delivered right after SEAMCALL returns,
+		 * and an #MC is delivered to host kernel after SMI handler
+		 * returns.
+		 *
+		 * The #MC right after SEAMCALL is fixed up and skipped in #MC
+		 * handler because it's an #MC happens in TD guest we cannot
+		 * handle it with host's context.
+		 *
+		 * Call KVM's machine check handler explicitly here.
+		 */
+		if (tdx->exit_reason.basic == EXIT_REASON_OTHER_SMI) {
+			unsigned long exit_qual;
+
+			exit_qual = tdexit_exit_qual(vcpu);
+			if (exit_qual & TD_EXIT_OTHER_SMI_IS_MSMI)
+				kvm_machine_check();
+		}
+	}
 }
 
 static int tdx_handle_exception(struct kvm_vcpu *vcpu)
@@ -1357,6 +1381,11 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 			      exit_reason.full, exit_reason.basic,
 			      to_kvm_tdx(vcpu->kvm)->hkid,
 			      set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
+
+		/*
+		 * tdx_handle_exit_irqoff() handled EXIT_REASON_OTHER_SMI.  It
+		 * must be handled before enabling preemption because it's #MC.
+		 */
 		goto unhandled_exit;
 	}
 
@@ -1395,9 +1424,14 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 		return tdx_handle_ept_misconfig(vcpu);
 	case EXIT_REASON_OTHER_SMI:
 		/*
-		 * If reach here, it's not a Machine Check System Management
-		 * Interrupt(MSMI).  #SMI is delivered and handled right after
-		 * SEAMRET, nothing needs to be done in KVM.
+		 * Unlike VMX, all the SMI in SEAM non-root mode (i.e. when
+		 * TD guest vcpu is running) will cause TD exit to TDX module,
+		 * then SEAMRET to KVM. Once it exits to KVM, SMI is delivered
+		 * and handled right away.
+		 *
+		 * - If it's an Machine Check System Management Interrupt
+		 *   (MSMI), it's handled above due to non_recoverable bit set.
+		 * - If it's not an MSMI, don't need to do anything here.
 		 */
 		return 1;
 	default:
diff --git a/arch/x86/kvm/vmx/tdx_arch.h b/arch/x86/kvm/vmx/tdx_arch.h
index fc9a8898765c..9f93250d22b9 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -47,6 +47,8 @@
 #define TDG_VP_VMCALL_REPORT_FATAL_ERROR		0x10003
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004
 
+#define TD_EXIT_OTHER_SMI_IS_MSMI	BIT(1)
+
 /* TDX control structure (TDR/TDCS/TDVPS) field access codes */
 #define TDX_NON_ARCH			BIT_ULL(63)
 #define TDX_CLASS_SHIFT			56
-- 
2.25.1


