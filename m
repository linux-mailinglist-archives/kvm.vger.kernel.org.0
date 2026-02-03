Return-Path: <kvm+bounces-70035-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sGCxCy48gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70035-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:19:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 82E41DD772
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:19:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8FF5D30BF55C
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DCA236E46D;
	Tue,  3 Feb 2026 18:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ib2zTYL3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50ACE1F471F;
	Tue,  3 Feb 2026 18:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142654; cv=none; b=knZjDxorMHD4HgMNnqjCysJ9z1GYEKMewuUCMX6W6LV64PKM0evRKVp1xUyTEmeoN7XTAQhUvVRBPWWOGPf25tOStqPXryPLG5H9rLl1rPKWOTjIklWO7Mew286bYEbc5k4FYo/HUsJsl18snHe0TwSZX4jVXLnypKg5V8CwwKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142654; c=relaxed/simple;
	bh=slCSGj+JBFhyh3GRqC7AbCQMZ+OirmH4eDMYMwIG5gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7+w9MspyOCyVk1y4jv/GdHiKAXTGcCu77K/J0UaeZdaSBRdTHtSa1dVwgzObOxL7xGwRN4Iw1Y8eBd0dtBjqiM6e4zYZ9eNHYGNRj0zCWB3zdazhtRiS0rNbbMm1FMem4/9wP2Lzdurv6CkR7w3QStZOMEkH63E/9rvFMdZXuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ib2zTYL3; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142652; x=1801678652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=slCSGj+JBFhyh3GRqC7AbCQMZ+OirmH4eDMYMwIG5gE=;
  b=ib2zTYL3rx5ji6E7LrSc27E67ek0k2Hb+jbRZGuf29lnI3AXbB/MksvR
   1wTZvOehQlKHz+4fgVBT/kMKzpASXYkrTPogYmVco3WVZ1wbBLuRtQMKF
   8M4DcVeMf19WAChEULIHQb3ZogvMz1C89odcxoB13EXZWsvCOXL9F6PbS
   7bXL7crh/dKX5OklMz2eqgn+eSD2vGJO35HtZ4Ce6Jr63URXN1R2G6YII
   Or4AG3+ZmZ2CqcSfZ8/iur7fOSB7mqFrDv05MkSzirjDcmuNk8r7NueGI
   qUnRh0tesT7XAw4hHk8EAAhUpPp06hB3FdY1pOQxeAchCJlivWtEnsJ9D
   Q==;
X-CSE-ConnectionGUID: LHrkkBPXQMu7on2nh2SmYg==
X-CSE-MsgGUID: gB/OFl4ST8O78+/EnZPc1w==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82433155"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="82433155"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:31 -0800
X-CSE-ConnectionGUID: 38pKlMxpRXa48bcnsyGnrQ==
X-CSE-MsgGUID: /z+fyx4uRkykteJwtIIHqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209727447"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:31 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	Yang Zhong <yang.zhong@linux.intel.com>
Subject: [PATCH 01/32] KVM: VMX: Detect APIC timer virtualization bit
Date: Tue,  3 Feb 2026 10:16:44 -0800
Message-ID: <387a84de1bdf461c895da0a3812ea0cde1434716.1770116050.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1770116050.git.isaku.yamahata@intel.com>
References: <cover.1770116050.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org,linux.intel.com];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70035-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 82E41DD772
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
 arch/x86/include/asm/vmx.h         |  6 ++++++
 arch/x86/include/asm/vmxfeatures.h |  1 +
 arch/x86/kvm/vmx/vmx.c             | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.h             |  1 +
 4 files changed, 18 insertions(+)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c85c50019523..99f853bd8a4c 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -85,6 +85,7 @@
  * Definitions of Tertiary Processor-Based VM-Execution Controls.
  */
 #define TERTIARY_EXEC_IPI_VIRT			VMCS_CONTROL_BIT(IPI_VIRT)
+#define TERTIARY_EXEC_GUEST_APIC_TIMER		VMCS_CONTROL_BIT(GUEST_APIC_TIMER)
 
 #define PIN_BASED_EXT_INTR_MASK                 VMCS_CONTROL_BIT(INTR_EXITING)
 #define PIN_BASED_NMI_EXITING                   VMCS_CONTROL_BIT(NMI_EXITING)
@@ -192,6 +193,7 @@ enum vmcs_field {
 	VIRTUAL_PROCESSOR_ID            = 0x00000000,
 	POSTED_INTR_NV                  = 0x00000002,
 	LAST_PID_POINTER_INDEX		= 0x00000008,
+	GUEST_APIC_TIMER_VECTOR         = 0x0000000a,
 	GUEST_ES_SELECTOR               = 0x00000800,
 	GUEST_CS_SELECTOR               = 0x00000802,
 	GUEST_SS_SELECTOR               = 0x00000804,
@@ -262,6 +264,8 @@ enum vmcs_field {
 	SHARED_EPT_POINTER		= 0x0000203C,
 	PID_POINTER_TABLE		= 0x00002042,
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
+	GUEST_DEADLINE_VIR              = 0x0000204e,
+	GUEST_DEADLINE_VIR_HIGH         = 0x0000204f,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
 	VMCS_LINK_POINTER               = 0x00002800,
@@ -286,6 +290,8 @@ enum vmcs_field {
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
index 6b96f7aea20b..6d0d2d8ebcff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2789,6 +2789,9 @@ static int setup_vmcs_config(struct vmcs_config *vmcs_conf,
 			adjust_vmx_controls64(KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL,
 					      MSR_IA32_VMX_PROCBASED_CTLS3);
 
+	if (!(_cpu_based_2nd_exec_control & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY))
+		_cpu_based_3rd_exec_control &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
+
 	if (adjust_vmx_controls(KVM_REQUIRED_VMX_VM_EXIT_CONTROLS,
 				KVM_OPTIONAL_VMX_VM_EXIT_CONTROLS,
 				MSR_IA32_VMX_EXIT_CTLS,
@@ -4616,6 +4619,13 @@ static u64 vmx_tertiary_exec_control(struct vcpu_vmx *vmx)
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
index bc3ed3145d7e..cb32d0fdf3b8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -584,6 +584,7 @@ static inline u8 vmx_get_rvi(void)
 	 SECONDARY_EXEC_EPT_VIOLATION_VE)
 
 #define KVM_REQUIRED_VMX_TERTIARY_VM_EXEC_CONTROL 0
+/* Once apic timer virtualization supported, add TERTIARY_EXEC_GUEST_APIC_TIMER */
 #define KVM_OPTIONAL_VMX_TERTIARY_VM_EXEC_CONTROL			\
 	(TERTIARY_EXEC_IPI_VIRT)
 
-- 
2.45.2


