Return-Path: <kvm+bounces-37795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4220A301DF
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F82A1622FB
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 02:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 409151E5B87;
	Tue, 11 Feb 2025 02:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e9KpnCN2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47741E570D;
	Tue, 11 Feb 2025 02:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242640; cv=none; b=JXSaqz0NHhEn2R9Huiq815vKJM1sNEf+bQ/c1SX/PR5d6pAmjzMwWmW5RPa2fUj8Wj7J17EZma/bk90twyGmCP5KAst6fDkF+Wk40uY2u0UFWK5mYpOq/U3gQQ2BMeeYw0H9NHMGwMHQHCSOQaLfTqtquCGan7lalp2wiEDrvmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242640; c=relaxed/simple;
	bh=8uv2vF1g+LtCY6lVw34O5ITqYQSTv4i/yLE5aV9z7P0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/JXKqNaz9R+QvCrGKLDjYCPeRTZUivRSK5pQxer11BCADZDTLt3KwWFMJ90Jm31+jnketQd0OLHBG6gQKbTaLWDAfHLlh2USGzxL7QedJV0Jgum2p/N0AU6yT2EQexIzKoOp4ljuW7hmXzWWItc/PmzuPSt8excU5Lezn9EuWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e9KpnCN2; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242639; x=1770778639;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8uv2vF1g+LtCY6lVw34O5ITqYQSTv4i/yLE5aV9z7P0=;
  b=e9KpnCN2g5p4wZ11q6owNOHiHgW+BiIM1WdlQhVCqyJSUZljLySTZg0V
   B0108IELElZLq6DK7a3c/v9gtNtmDqzpd/juSLLoFb+5VOeE0anWdjDmC
   PTF004EYhhK3EHTeOYSXnHucF6cpXny1XjH/aRsda1N33iMCCtSXHWFnm
   f1yWGRk1OOQ4w0FHYsudIYc3dsPQPBfkLX108NzqQzvSRUx09tLTRARe6
   fLieqeXN9H3qTGw/1ikQy8uqNw0V8efNmy73WKzjoAAL+VAU45yECwCHd
   qIn7s4iMXGJipuxMTsvBstCCcS/ftJEyi8+AdgPrBOLu4jUnFwFPpKHOu
   w==;
X-CSE-ConnectionGUID: lQk3jic1Tg+1/M7S6UMuUA==
X-CSE-MsgGUID: oiTj8JnBRdmk4QvRzPoLMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612465"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612465"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:19 -0800
X-CSE-ConnectionGUID: hGbs0n8gST6YZFVIoicTcA==
X-CSE-MsgGUID: K8IbR6hTSbqKbW8ctPsCPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355341"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:15 -0800
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
Subject: [PATCH v2 08/17] KVM: TDX: Complete interrupts after TD exit
Date: Tue, 11 Feb 2025 10:58:19 +0800
Message-ID: <20250211025828.3072076-9-binbin.wu@linux.intel.com>
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

Complete NMI injection by updating the status of NMI injection for TDX.

Because TDX virtualizes vAPIC, and non-NMI interrupts are delivered
using posted-interrupt mechanism, KVM only needs to care about NMI
injection.

For VMX, KVM injects an NMI by setting VM_ENTRY_INTR_INFO_FIELD via
vector-event injection mechanism.  For TDX, KVM needs to request TDX
module to inject an NMI into a guest TD vCPU when the vCPU is not
active by setting PEND_NMI field within the TDX vCPU scope metadata
(Trust Domain Virtual Processor State (TDVPS)).  TDX module will attempt
to inject an NMI as soon as possible on TD entry.  KVM can read PEND_NMI
to get the status of NMI injection.  A value of 0 indicates the NMI has
been injected into the guest TD vCPU.

Update KVM's NMI status on TD exit by checking whether a requested NMI
has been injected into the TD.  Reading the PEND_NMI field via SEAMCALL
is expensive so only perform the check if an NMI was requested to inject.
If the read back value is 0, the NMI has been injected, update the NMI
status.  If the read back value is 1, no action needed since the PEND_NMI
is still set.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX interrupts v2:
- No change.

TDX interrupts v1:
- Shortlog "tdexit" -> "TD exit" (Reinette)
- Update change log as following suggested by Reinette with a little
  supplement.
  https://lore.kernel.org/lkml/fe9cec78-36ee-4a20-81df-ec837a45f69f@linux.intel.com/
- Fix comment, "nmi" -> "NMI" and add a missing period. (Reinette)
- Add a comment to explain why no need to request KVM_REQ_EVENT.

v19:
- move tdvps_management_check() to this patch
- typo: complete -> Complete in short log
---
 arch/x86/kvm/vmx/tdx.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index ba9038ac5bf7..9737574b8049 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -803,6 +803,21 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static void tdx_complete_interrupts(struct kvm_vcpu *vcpu)
+{
+	/* Avoid costly SEAMCALL if no NMI was injected. */
+	if (vcpu->arch.nmi_injected) {
+		/*
+		 * No need to request KVM_REQ_EVENT because PEND_NMI is still
+		 * set if NMI re-injection needed.  No other event types need
+		 * to be handled because TDX doesn't support injection of
+		 * exception, SMI or interrupt (via event injection).
+		 */
+		vcpu->arch.nmi_injected = td_management_read8(to_tdx(vcpu),
+							      TD_VCPU_PEND_NMI);
+	}
+}
+
 struct tdx_uret_msr {
 	u32 msr;
 	unsigned int slot;
@@ -985,6 +1000,8 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	if (unlikely(tdx_failed_vmentry(vcpu)))
 		return EXIT_FASTPATH_NONE;
 
+	tdx_complete_interrupts(vcpu);
+
 	return tdx_exit_handlers_fastpath(vcpu);
 }
 
-- 
2.46.0


