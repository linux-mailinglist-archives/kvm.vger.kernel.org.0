Return-Path: <kvm+bounces-6661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFD48837844
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 01:11:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 898242924E0
	for <lists+kvm@lfdr.de>; Tue, 23 Jan 2024 00:11:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468E36D1CE;
	Mon, 22 Jan 2024 23:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VVJdcN6l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654E067E89;
	Mon, 22 Jan 2024 23:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705967759; cv=none; b=umlkwDDMdYgMiwJmR8ADGi8cHHsZ/RYLsPpg8pOvy2hibTbPx9f45LpEWoMRIwckfpArVVMOu7A7lD4qP0NWMleYYDPlfsOn71GGNXVrgLdR5rTh0ygnlIcZfyQ8ZQFu7z2aWe9zFuxUWF5fBHRE5kbTt+aybKqKp/ucfilXWCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705967759; c=relaxed/simple;
	bh=af4hefTXIcTt83y/kL3t9mlpV+MNfoFaJcRJv0peIHY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q8EY4fis8iaeN9nrmgxt/87s00snvJYOCtI7ZYao44hfHeyd3VUJ/klsH4DxkBn7A0Chr5sski1fcT7/1QOdPxVh9pijW3ri/b0Mlrun951560Ij8snUB/1nzC0SwY4s8kIU72HdJEcLBPyuhLOf3qunU2RsjiCMkbZmvYwQj/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VVJdcN6l; arc=none smtp.client-ip=192.55.52.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705967757; x=1737503757;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=af4hefTXIcTt83y/kL3t9mlpV+MNfoFaJcRJv0peIHY=;
  b=VVJdcN6lq58q5hbqN5Pl/zvlNJU/mUOsd97Gvuh3IGU1eDBCukdwB0G2
   TI/7h/mh7v3nd1/6uNKUgeK9GTSO5rIxqYVbqeoITtkOfafC8F7Cy3nuM
   WbIVwRKBMnqjJjKvpU5f82bq7qTjqXQiPS6M7SFsd+D0VGlTgwQd5YYLu
   bOQft0cF5OVATresnbPxVY248gIDtQqgtjwnAHGANw2EfGqiWn6xhjLYN
   6Ak53M1OQqBhr2Y6kYNS2OYE+Ob6jo2UZBTQrCN5rbthFkm8/VNkj9OtU
   l59sMs8dyEa7OQPIEJzcKiNyTyOneavuGAlKwoOYN/O2Z++r6Qr+x2xvH
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10961"; a="400217838"
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="400217838"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,212,1701158400"; 
   d="scan'208";a="27817958"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2024 15:55:49 -0800
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
Subject: [PATCH v18 092/121] KVM: TDX: Handle EXIT_REASON_OTHER_SMI with MSMI
Date: Mon, 22 Jan 2024 15:54:08 -0800
Message-Id: <65503991df7537528b43ba145abf2f9e6284aea8.1705965635.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1705965634.git.isaku.yamahata@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
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
index fb3f6819e97a..7176f732b0eb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -966,6 +966,30 @@ void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
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
@@ -1426,6 +1450,11 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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
 
@@ -1464,9 +1493,14 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
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
index eb11618366b7..0207cce72b27 100644
--- a/arch/x86/kvm/vmx/tdx_arch.h
+++ b/arch/x86/kvm/vmx/tdx_arch.h
@@ -48,6 +48,8 @@
 #define TDG_VP_VMCALL_REPORT_FATAL_ERROR		0x10003
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT	0x10004
 
+#define TD_EXIT_OTHER_SMI_IS_MSMI	BIT(1)
+
 /* TDX control structure (TDR/TDCS/TDVPS) field access codes */
 #define TDX_NON_ARCH			BIT_ULL(63)
 #define TDX_CLASS_SHIFT			56
-- 
2.25.1


