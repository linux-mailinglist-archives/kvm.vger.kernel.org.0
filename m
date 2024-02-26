Return-Path: <kvm+bounces-9725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BB4F8866D6D
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 10:01:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7E0C1C22BFB
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 09:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 771C57C0B2;
	Mon, 26 Feb 2024 08:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rx0g048S"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B87F37E784;
	Mon, 26 Feb 2024 08:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708936140; cv=none; b=Q6AkvedfZyF3gSLVFrlqrz6fnmy5LpfMM/GKn0e9sRgxHvehAqMJGuhOGiB8KNoSzw2eMz1S1xscINzs39/51ok08iiA7pZT3ZIf9oAOFDY8VgfyxG/6Ol4K/Ui+Y42DYPUlDIvp4Em9pK0xGxhhiN96LiCLGB71hSBcKiA+tSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708936140; c=relaxed/simple;
	bh=HofWRmC21b/CNK3j4sNmbUeHHzfuSu3ISYfW2FhCHEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=J/nIxPfpMUYqS7bY1/BVYMDck9t8tas+7y6sYULxSIlmk6izkc4BCq9NdMaRYKd4XEpcMUkKvmZ69mG9NELXKLQ1Hy6I8ZERaEDfRdoIXkwyXO3R92PQSF0NYRAayXBz9koVtHx2Zo/3/aDFAQZ9Lpif91EnmmdFi4jXGUtJH9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rx0g048S; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708936139; x=1740472139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HofWRmC21b/CNK3j4sNmbUeHHzfuSu3ISYfW2FhCHEE=;
  b=Rx0g048SdzV9CUVkLkGJ7K6CP+pi2FOeQo8EnHw5E7709er7PFmbeK0J
   15FVtEo+nAEW2pVc3N23rBOJiLHE6H3kTk0WFAmz7y0rujo01Q8iIs562
   zXo/D8z7YfGwUWjOgS/ch3q3FMtE8gGAqZ3WcZ/4P2RAguYGc3IVa89Rf
   iUqlK23j9qm44+31IZeAWfnyrhLGWr6FrtPZXUQC5b5cgqPgE9QxZnyr5
   6utOYZsgpfzJssw9oVPVLkoSIDk5O29mKE204JjJ3CF2ZSbgNmQfhWtIG
   dcO3OZCnBV447xvm8peZskyplJDi7dUZh2Dwxx2e2ZYj+O5jippu3r6tC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10995"; a="3069603"
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="3069603"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,185,1705392000"; 
   d="scan'208";a="11272687"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 00:28:58 -0800
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
Subject: [PATCH v19 101/130] KVM: TDX: handle ept violation/misconfig exit
Date: Mon, 26 Feb 2024 00:26:43 -0800
Message-Id: <f05b978021522d70a259472337e0b53658d47636.1708933498.git.isaku.yamahata@intel.com>
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

On EPT violation, call a common function, __vmx_handle_ept_violation() to
trigger x86 MMU code.  On EPT misconfiguration, exit to ring 3 with
KVM_EXIT_UNKNOWN.  because EPT misconfiguration can't happen as MMIO is
trigged by TDG.VP.VMCALL. No point to set a misconfiguration value for the
fast path.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

---
v14 -> v15:
- use PFERR_GUEST_ENC_MASK to tell the fault is private

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/common.h |  3 +++
 arch/x86/kvm/vmx/tdx.c    | 49 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 632af7a76d0a..027aa4175d2c 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -87,6 +87,9 @@ static inline int __vmx_handle_ept_violation(struct kvm_vcpu *vcpu, gpa_t gpa,
 	error_code |= (exit_qualification & EPT_VIOLATION_GVA_TRANSLATED) != 0 ?
 	       PFERR_GUEST_FINAL_MASK : PFERR_GUEST_PAGE_MASK;
 
+	if (kvm_is_private_gpa(vcpu->kvm, gpa))
+		error_code |= PFERR_GUEST_ENC_MASK;
+
 	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2f68e6f2b53a..0db80fa020d2 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1285,6 +1285,51 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
 }
 
+static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
+{
+	unsigned long exit_qual;
+
+	if (kvm_is_private_gpa(vcpu->kvm, tdexit_gpa(vcpu))) {
+		/*
+		 * Always treat SEPT violations as write faults.  Ignore the
+		 * EXIT_QUALIFICATION reported by TDX-SEAM for SEPT violations.
+		 * TD private pages are always RWX in the SEPT tables,
+		 * i.e. they're always mapped writable.  Just as importantly,
+		 * treating SEPT violations as write faults is necessary to
+		 * avoid COW allocations, which will cause TDAUGPAGE failures
+		 * due to aliasing a single HPA to multiple GPAs.
+		 */
+#define TDX_SEPT_VIOLATION_EXIT_QUAL	EPT_VIOLATION_ACC_WRITE
+		exit_qual = TDX_SEPT_VIOLATION_EXIT_QUAL;
+	} else {
+		exit_qual = tdexit_exit_qual(vcpu);
+		if (exit_qual & EPT_VIOLATION_ACC_INSTR) {
+			pr_warn("kvm: TDX instr fetch to shared GPA = 0x%lx @ RIP = 0x%lx\n",
+				tdexit_gpa(vcpu), kvm_rip_read(vcpu));
+			vcpu->run->exit_reason = KVM_EXIT_EXCEPTION;
+			vcpu->run->ex.exception = PF_VECTOR;
+			vcpu->run->ex.error_code = exit_qual;
+			return 0;
+		}
+	}
+
+	trace_kvm_page_fault(vcpu, tdexit_gpa(vcpu), exit_qual);
+	return __vmx_handle_ept_violation(vcpu, tdexit_gpa(vcpu), exit_qual);
+}
+
+static int tdx_handle_ept_misconfig(struct kvm_vcpu *vcpu)
+{
+	WARN_ON_ONCE(1);
+
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = EXIT_REASON_EPT_MISCONFIG;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+
+	return 0;
+}
+
 int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 {
 	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
@@ -1345,6 +1390,10 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
 	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
 
 	switch (exit_reason.basic) {
+	case EXIT_REASON_EPT_VIOLATION:
+		return tdx_handle_ept_violation(vcpu);
+	case EXIT_REASON_EPT_MISCONFIG:
+		return tdx_handle_ept_misconfig(vcpu);
 	case EXIT_REASON_OTHER_SMI:
 		/*
 		 * If reach here, it's not a Machine Check System Management
-- 
2.25.1


