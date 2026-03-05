Return-Path: <kvm+bounces-72899-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UIsgGIrCqWkhEQEAu9opvQ
	(envelope-from <kvm+bounces-72899-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:51:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F3ED8216891
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:51:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E71F309346A
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:45:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B643F23C5;
	Thu,  5 Mar 2026 17:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CeRZ9ycV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678C73EB7F4;
	Thu,  5 Mar 2026 17:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732681; cv=none; b=ldc065gWmqttXQwFZqhTibSps+Olm7oL5jdDHmgTcFLMwGWStmDFhCi7/R8FiwQUXJ8Qd8QU9BX1DD4wKGe3yDjxfLmbQ3LoNAkd4hmYrpE4hf1Holu1JMNY97cmWvrpfO9UMHHbE+/CYVrcwMogJBVagirr51FJKiRnQoGz5fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732681; c=relaxed/simple;
	bh=SVDXXF4WPsle4mwAe9qI2MJAYY6sFp0MwEwxBr4EPjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yb3I+yWNnQg1q9modF6z7DfNjZcpVdkzzSU+P1RlSnBLJL8TnqH4D+7Oy+tQbnwAo4X6Qupk0/kLFa3XxLVfyZr1sJjLTQ6/PFDQjay0T4aipe+ZNuByTKKcd0OdcmouBtjh1Xa5xUrY3kHpsU9X96Y52TWOYuHcou0smuAqzNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CeRZ9ycV; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732678; x=1804268678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SVDXXF4WPsle4mwAe9qI2MJAYY6sFp0MwEwxBr4EPjw=;
  b=CeRZ9ycVi4nta9wM/yBfjUPGOOOZaQiQz8bebgnaFHMUOT8nwIY4ZbX4
   jLHbE11VdxwHqYBA5e3AXty+tJNYgyxUJxIkuZL1i6OcP5Wml2eD9RQ/u
   lqf2ZO2VTRQji7C2wdK7N/IMDOLzHitTUUgZ7TV8h1I/hWgkwoKx2PiMO
   FbtC0KmDTIDniRLwi4iw0skNuM589nt2s3lXkBmefD9wLiUkU6/aQsa4m
   t0Gq2Ar+fThtNGM+6VmiaCcjlPzpVmlMFExHbkeXCPlkYNcOHsmF5GJKY
   d610nOROeki9rFCmq1QhA7y6P4SP7jtSckE1EJZhBL4VZfe2ZiUjHO5qF
   A==;
X-CSE-ConnectionGUID: lWMscCx9RXegsTtivtoCtA==
X-CSE-MsgGUID: wpbZU6kNTxSVrd9MUQo86g==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="73798226"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="73798226"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:38 -0800
X-CSE-ConnectionGUID: kxQeCATPTqWEM9ZrMyyk7g==
X-CSE-MsgGUID: Z9gGzkT2Qj+6etMhwy9fgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="215527262"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:37 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/36] KVM: nVMX: Handle virtual timer vector VMCS field
Date: Thu,  5 Mar 2026 09:43:54 -0800
Message-ID: <a37821c381b3af13cdf97e8c1028c8b528fc8b1a.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: F3ED8216891
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72899-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Support virtual timer vector VMCS field.
Opportunistically add a size check of struct vmcs12.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
Changes:
v1 -> v2:
- update for 5fdf86e7353c ("KVM: nVMX: Disallow access to vmcs12 fields
  that aren't supported by "hardware"") to use cpu_has_vmcs12_field().
---
 arch/x86/kvm/vmx/nested.c             | 6 +++++-
 arch/x86/kvm/vmx/vmcs12.c             | 5 +++++
 arch/x86/kvm/vmx/vmcs12.h             | 2 ++
 arch/x86/kvm/vmx/vmcs_shadow_fields.h | 1 +
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 8bb8734cc690..b7561f8f4565 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2540,7 +2540,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	if (cpu_has_tertiary_exec_ctrls()) {
 		u64 ctls = 0;
 
-		/* guest apic timer virtualization will come */
+		if (nested_cpu_has_guest_apic_timer(vmcs12))
+			ctls |= TERTIARY_EXEC_GUEST_APIC_TIMER;
 
 		tertiary_exec_controls_set(vmx, ctls);
 	}
@@ -2734,6 +2735,9 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_write64(EOI_EXIT_BITMAP3, vmcs12->eoi_exit_bitmap3);
 	}
 
+	if (nested_cpu_has_guest_apic_timer(vmcs12))
+		vmcs_write16(GUEST_APIC_TIMER_VECTOR, vmcs12->virtual_timer_vector);
+
 	/*
 	 * If vmcs12 is configured to save TSC on exit via the auto-store list,
 	 * append the MSR to vmcs02's auto-store list so that KVM effectively
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index e2e2a99c8aa9..dac796fc20f2 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -3,6 +3,8 @@
 
 #include "vmcs12.h"
 
+static_assert(sizeof(struct vmcs12) <= VMCS12_SIZE);
+
 #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
 #define FIELD(number, name)	[ENC_TO_VMCS12_IDX(number)] = VMCS12_OFFSET(name)
 #define FIELD64(number, name)						\
@@ -22,6 +24,7 @@ static const u16 kvm_supported_vmcs12_field_offsets[] __initconst = {
 	FIELD(GUEST_TR_SELECTOR, guest_tr_selector),
 	FIELD(GUEST_INTR_STATUS, guest_intr_status),
 	FIELD(GUEST_PML_INDEX, guest_pml_index),
+	FIELD(GUEST_APIC_TIMER_VECTOR, virtual_timer_vector),
 	FIELD(HOST_ES_SELECTOR, host_es_selector),
 	FIELD(HOST_CS_SELECTOR, host_cs_selector),
 	FIELD(HOST_SS_SELECTOR, host_ss_selector),
@@ -204,6 +207,8 @@ static __init bool cpu_has_vmcs12_field(unsigned int idx)
 	case HOST_SSP:
 	case HOST_INTR_SSP_TABLE:
 		return cpu_has_load_cet_ctrl();
+	case GUEST_APIC_TIMER_VECTOR:
+		return cpu_has_vmx_apic_timer_virt();
 
 	/* KVM always emulates PML and the VMX preemption timer in software. */
 	case GUEST_PML_INDEX:
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index b7d30a2cf23f..7a20d6661da0 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -191,6 +191,7 @@ struct __packed vmcs12 {
 	u16 host_gs_selector;
 	u16 host_tr_selector;
 	u16 guest_pml_index;
+	u16 virtual_timer_vector;
 };
 
 /*
@@ -374,6 +375,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_gs_selector, 992);
 	CHECK_OFFSET(host_tr_selector, 994);
 	CHECK_OFFSET(guest_pml_index, 996);
+	CHECK_OFFSET(virtual_timer_vector, 998);
 }
 
 extern u16 vmcs12_field_offsets[] __ro_after_init;
diff --git a/arch/x86/kvm/vmx/vmcs_shadow_fields.h b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
index cad128d1657b..db1558d11c4c 100644
--- a/arch/x86/kvm/vmx/vmcs_shadow_fields.h
+++ b/arch/x86/kvm/vmx/vmcs_shadow_fields.h
@@ -34,6 +34,7 @@ BUILD_BUG_ON(1)
 /* 16-bits */
 SHADOW_FIELD_RW(GUEST_INTR_STATUS, guest_intr_status)
 SHADOW_FIELD_RW(GUEST_PML_INDEX, guest_pml_index)
+SHADOW_FIELD_RO(GUEST_APIC_TIMER_VECTOR, virtual_timer_vector)
 SHADOW_FIELD_RW(HOST_FS_SELECTOR, host_fs_selector)
 SHADOW_FIELD_RW(HOST_GS_SELECTOR, host_gs_selector)
 
-- 
2.45.2


