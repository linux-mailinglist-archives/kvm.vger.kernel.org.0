Return-Path: <kvm+bounces-9727-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D8A3866D70
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:02:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE5401C230C5
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17B561272D5;
	Mon, 26 Feb 2024 08:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aOfQTXDF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D827F7C4;
	Mon, 26 Feb 2024 08:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936143; cv=none; b=tWpyEOVSNLPLqTvqgPA89U9+8SlzmqqXCZMmkRc8sAaoTUDaDOBBLp4tvTq29PfhcU0kp7g3RiHBhjhR3wYIC4Q8K7IA+GwyOj8S06UTc+JToHqoXqZodc9XahDqvhjS7i0Hgzr5ZVkRLtHWfHH+owJEsAFRXfwhLtFUxg3vxZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936143; c=relaxed/simple;
	bh=fS118DZC+NULTK6MvdkrJc4IgmIpKMeLepk4rQeITHQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EqaWcEGgDa2VBGgyd3nOO8osbGXSxnY3s5zzsKvQHWBoQvAnZPqgIOAxD35bgloOVMpRNrk1ega0ZIg+TGG2mdBGmhbqQjm91aJ50RIxVpQCIQDr2lV3Kl1Rw0aBYV6MUVJNvo/fOnbUp8LtvMI5R9jWU7H7JnplogOhawLQ538=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aOfQTXDF; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936142; x=1740472142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fS118DZC+NULTK6MvdkrJc4IgmIpKMeLepk4rQeITHQ=;
  b=aOfQTXDFLwcxAcV6ikHjzHTTErTMnOlBJRm2o+6W44RlmXCc9ba2lcLc
   vHz2khciwe9TvAPv/u9A36odUWtUu3OyMsoqJnaiybO/D5cxxo00QeosY
   tVW0ByhUzpdjCBA4zn8V6ue5P8ycdZ4q+EEyLrbZNPo1pGzXo4gRY25Oo
   NUF+OQER7wVnMfYhNrECYul7arc2ntxiT4hDQGaUBCpBBvVHwjSBv9PQk
   jqjsefDZg07SNj9bBybxUUMcUtQjMzU5mMvx/s8NEDHvTS656IDFEakvD
   LF6y9ZijIJPZoRcIKZdJ5vIFl95hF1go505cAIs2Z0gQE7vBZpoOK5Unf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069613"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069613"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272700"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:29:01 -0800
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
Subject: [PATCH v19 103/130] KVM: TDX: Handle EXIT_REASON_OTHER_SMI with MSMI
Date: Mon, 26 Feb 2024 00:26:45 -0800
Message-Id: <4a96a33c01b547f6e89ecf40224c80afa59c6aa4.1708933498.git.isaku.yamahata@intel.com>
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
index bdd74682b474..117c2315f087 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -916,6 +916,30 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
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
@@ -1381,6 +1405,11 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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
 
@@ -1419,9 +1448,14 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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
index efc3c61c14ab..87ef22e9cd49 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -42,6 +42,8 @@
 #define TDH_VP_WR			43
 #define TDH_SYS_LP_SHUTDOWN		44
 
+#define TD_EXIT_OTHER_SMI_IS_MSMI	BIT(1)
+
 /* TDX control structure (TDR/TDCS/TDVPS) field access codes */
 #define TDX_NON_ARCH			BIT_ULL(63)
 #define TDX_CLASS_SHIFT			56
-- 
2.25.1


