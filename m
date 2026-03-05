Return-Path: <kvm+bounces-72887-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UAM9EFzBqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72887-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:46:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7242166F6
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 80136309CCB5
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:44:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 410603E558A;
	Thu,  5 Mar 2026 17:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mKlvqx1M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E913BE146;
	Thu,  5 Mar 2026 17:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732674; cv=none; b=Drj5+OSXK8kOH8SiMenn4+WIXE6wW3ENtaB/r0DxNMvHCTnPCqATq6+kH0LdEdg3fG+fKstl0sT0jZBLZ1R32e70n11/mOnpwLj/dC1AH0t/jSnK+vSjOV9zdjtzILT04gWJPm2aUzJAOIfGNEd4+fN1Dj4hTIogkkZVg/hlyQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732674; c=relaxed/simple;
	bh=zXjCzbLVKWGoKD9CpmDEyJwKzLu+XjEZnAgUQdMsLuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avbGDsiDxZeJ52JLEcRavAGPmPN/2T4dWMv1QAvHDOwMgsR12z9EHXMIUWDcylfR+uXufW0zUZKLl3T6hGYYhCtSB08easX0VmfNDTGN4Xujwa9Ae0VCwra3jWVdW64maY1cDo71BbJmSdzK4o3gHw7i71w4s4pzm3ewB7JYkdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mKlvqx1M; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732673; x=1804268673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zXjCzbLVKWGoKD9CpmDEyJwKzLu+XjEZnAgUQdMsLuA=;
  b=mKlvqx1ML+XKSU1xxBs+DbQmiR9tf/Bp01ArtON8K++uAPV5rxapJWAK
   NDr+S0+iOkPHjPHQutLzOlqvDLzB0gl+VsNxgxBE5dE5cHUa8QTHv/lXW
   EVcPvInTI+aCBeCdOM4mck/tCZrE+m9Gh7+AipmGYB93zzdj6pq5Z4cqH
   SgLa86m0yppUTAogNW7LFFc8NQulMIPXu0bx8EuHZuHFn4r5nxAqVP1DN
   Lqcxa9FK8n4gDeE5bc8mpDVxOrQhG9Wcbs420tbuIJ/f9rNO+zzYV6Rhb
   7XNAIHdDb63FYQMqPMkX4iyMsq02RkOpgx20XqN8bHo+GCABs4onP9+pu
   w==;
X-CSE-ConnectionGUID: FaLoEQr8TxixzGcjAYzaBQ==
X-CSE-MsgGUID: 9Fc5k34/SQmd0irE/dUNxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="73798200"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="73798200"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:33 -0800
X-CSE-ConnectionGUID: eHi2tnhaS3Sk9Sv04u977Q==
X-CSE-MsgGUID: oR6L9rMfS/+YqecgGRgE6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="215527242"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:32 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Yang Zhong <yang.zhong@linux.intel.com>
Subject: [PATCH v2 01/36] KVM: VMX: Detect APIC timer virtualization bit
Date: Thu,  5 Mar 2026 09:43:41 -0800
Message-ID: <2a5757c34954ed3f90db2aec0aab5966f829018e.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CB7242166F6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org,linux.intel.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72887-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[intel.com:+];
	FROM_NO_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Yang Zhong <yang.zhong@linux.intel.com>

Detect the APIC timer virtualization feature by setting the bit (bit 8) in
the tertiary processor-based VM-execution controls.  Additionally, define
the new related VMCS fields necessary for managing this feature.

Do not enable the feature bit in the tertiary VM exec control yet until the
supporting logic is implemented.

Signed-off-by: Yang Zhong <yang.zhong@linux.intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes:
v1 -> v2:
- Change KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL to include apic timer
  virt bit to avoid compile time errors.  Clear the bit when
  adjust_vmx_controls64() is called instead.
---
 arch/x86/include/asm/vmx.h         |  6 ++++++
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/kvm/vmx/vmx.c             | 20 +++++++++++++++++++-
 arch/x86/kvm/vmx/vmx.h             |  3 ++-
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index 37080382df54..a9fe10cf1b4d 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -96,6 +96,7 @@ struct vmcs {
  * Definitions of Tertiary Processor-Based VM-Execution Controls.
  */
 #define TERTIARY_EXEC_IPI_VIRT			VMCS_CONTROL_BIT(IPI_VIRT)
+#define TERTIARY_EXEC_GUEST_APIC_TIMER		VMCS_CONTROL_BIT(GUEST_APIC_TIMER)
 
 #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
 #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
@@ -204,6 +205,7 @@ enum vmcs_field {
 	VIRTUAL_PROCESSOR_ID            = 0x00000000,
 	POSTED_INTR_NV                  = 0x00000002,
 	LAST_PID_POINTER_INDEX		= 0x00000008,
+	GUEST_APIC_TIMER_VECTOR         = 0x0000000a,
 	GUEST_ES_SELECTOR               = 0x00000800,
 	GUEST_CS_SELECTOR               = 0x00000802,
 	GUEST_SS_SELECTOR               = 0x00000804,
@@ -274,6 +276,8 @@ enum vmcs_field {
 	SHARED_EPT_POINTER		= 0x0000203C,
 	PID_POINTER_TABLE		= 0x00002042,
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
+	GUEST_DEADLINE_VIR              = 0x0000204e,
+	GUEST_DEADLINE_VIR_HIGH         = 0x0000204f,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
@@ -298,6 +302,8 @@ enum vmcs_field {
 	GUEST_BNDCFGS_HIGH              = 0x00002813,
 	GUEST_IA32_RTIT_CTL		= 0x00002814,
 	GUEST_IA32_RTIT_CTL_HIGH	= 0x00002815,
+	GUEST_DEADLINE_PHY              = 0x00002830,
+	GUEST_DEADLINE_PHY_HIGH         = 0x00002831,
 	HOST_IA32_PAT			= 0x00002c00,
 	HOST_IA32_PAT_HIGH		= 0x00002c01,
 	HOST_IA32_EFER			= 0x00002c02,
diff --git a/arch/x86/include/asm/vmxfeatures.h b/arch/x86/include/asm/vmxfeatures.h
index 09b1d7e607c1..f2eb4243bae4 100644
--- a/arch/x86/include/asm/vmxfeatures.h
+++ b/arch/x86/include/asm/vmxfeatures.h
@@ -90,4 +90,5 @@
 
 /* Tertiary Processor-Based VM-Execution Controls, word 3 */
 #define VMX_FEATURE_IPI_VIRT		( 3*32+  4) /* "ipi_virt" Enable IPI virtualization */
+#define VMX_FEATURE_GUEST_APIC_TIMER	( 3*32+  8) /* Enable virtual APIC tsc deadline */
 #endif /* _ASM_X86_VMXFEATURES_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 9302c16571cd..4ccb2e42322d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2791,9 +2791,20 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 
 	if (_cpu_based_exec_control & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS)
 		_cpu_based_3rd_exec_control =
-			adjust_vmx_controls64(KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL,
+			adjust_vmx_controls64(KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL
+					      /*
+					       * Disable apic timer
+					       * virtualization until the logic
+					       * is imlemented.
+					       * Once it's supported, add
+					       * TERTIARY_EXEC_GUEST_APIC_TIMER.
+					       */
+					      & ~TERTIARY_EXEC_GUEST_APIC_TIMER,
 					      MSR_IA32_VMX_PROCBASED_CTLS3);
 
+	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY))
+		_cpu_based_3rd_exec_control &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
+
 	if (adjust_vmx_controls(KVM_REQUIRED_VMX_VM_EXIT_CONTROLS,
 				KVM_OPTIONAL_VMX_VM_EXIT_CONTROLS,
 				MSR_IA32_VMX_EXIT_CTLS,
@@ -4636,6 +4647,13 @@ static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
 	if (!enable_ipiv || !kvm_vcpu_apicv_active(&vmx->vcpu))
 		exec_control &= ~TERTIARY_EXEC_IPI_VIRT;
 
+	/*
+	 * APIC timer virtualization is supported only for TSC deadline mode.
+	 * Disable for one-shot/periodic mode.  Dynamically set/clear the bit
+	 * on the guest timer mode change.  Disable on reset state.
+	 */
+	exec_control &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
+
 	return exec_control;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 70bfe81dea54..9a61f6bd8cc0 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -575,7 +575,8 @@ static inline u8 vmx_get_rvi(void)
 
 #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
 #define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
-	(TERTIARY_EXEC_IPI_VIRT)
+	(TERTIARY_EXEC_IPI_VIRT |					\
+	 TERTIARY_EXEC_GUEST_APIC_TIMER)
 
 #define BUILD_CONTROLS_SHADOW(lname, uname, bits)						\
 static inline void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)			\
-- 
2.45.2


