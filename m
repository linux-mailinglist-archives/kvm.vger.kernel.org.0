Return-Path: <kvm+bounces-70046-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oIeRI1c9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70046-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:24:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E9E6DD866
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B56D1318498F
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:19:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F183D9053;
	Tue,  3 Feb 2026 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TrPz3Tic"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE41E3D6692;
	Tue,  3 Feb 2026 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142665; cv=none; b=ebNimNrn0bth8F0DqSLgkaikER1JtKbxFsRSiRe+3TViq7PC5KVtBcWP/KjfanQOToN5V85F1nyshWUm3CIv1fzxibNRqoou4Ay9Y3LmjudTutPl3yMd+to2AcWVEIwvY+qWn8fhq+IsHEEIQwwfkNp2Nx/vcFPRrcVPwTgNKr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142665; c=relaxed/simple;
	bh=lay6C04NpMEaRDmWEt9cg+qeeEi4r9NeoST7W3hXgnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4ygADAGpLEiI2L3Cb+DABN80O2m0KGzFjNEDgIJW0hKcIJmCn+kr/mkWtJG2n89ERv0gORaiZwoPHIRU2NKwaWL/2ZjVGPTy1kLuOEbgP/qJpb5lLzIRGN5jlGYhQ20RIaRdALQQkOt5iZKROfsxiz3stEIujmRPM2rwos6/bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TrPz3Tic; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142664; x=1801678664;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lay6C04NpMEaRDmWEt9cg+qeeEi4r9NeoST7W3hXgnE=;
  b=TrPz3TiczwWeG8zn6azTTn9jypRcJZIuepq0AgTI2IuKYyGfDEfEP4VR
   Zc9kbDTYiMMpKa1Jwkq3sPNnm6cQHrOyD4L7pK0H7yr5+JyqqBmPa11+X
   T64Hh8MUSFtCzQXpzPYOT6JjFZ3Q0RHyLAkNBShnKr+dEBt8WXBWyhLN8
   /fLh0szNii26hkLRaPKXO6uVN69R/1Qu6mq3VsA7WoZjITGVQ/4KfwSEh
   Tx20nbnUz7LBt77v0lCZlkqkIxxaMcIvnavra5GCqVZr7Gu84achFViyi
   BP6MehpdqPKuK9yOBRXJL34HuWBJHXz+71AwAlKWPVWPKlUnQf0+Cx3mD
   A==;
X-CSE-ConnectionGUID: nakI1TOtSbq7vvrPweHNuA==
X-CSE-MsgGUID: v7Yp3wshSZOTKDGdNMzVxQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745806"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745806"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:42 -0800
X-CSE-ConnectionGUID: YWZoxF6LTBW36s5Sr2mW/w==
X-CSE-MsgGUID: EJd6BUxASYuNw1Bxptu99w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605485"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:41 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 13/32] KVM: nVMX: Handle virtual timer vector VMCS field
Date: Tue,  3 Feb 2026 10:16:56 -0800
Message-ID: <cde898b77379481886f7abb2b78dd32bba0b2ba1.1770116051.git.isaku.yamahata@intel.com>
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
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70046-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0E9E6DD866
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Support virtual timer vector VMCS field.
Opportunistically add a size check of struct vmcs12.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/nested.c             | 15 ++++++++++++++-
 arch/x86/kvm/vmx/vmcs12.c             |  3 +++
 arch/x86/kvm/vmx/vmcs12.h             |  2 ++
 arch/x86/kvm/vmx/vmcs_shadow_fields.h |  1 +
 4 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 191317479d5e..5829562145a7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -86,6 +86,15 @@ static void init_vmcs_shadow_fields(void)
 			pr_err("Missing field from shadow_read_only_field %x\n",
 			       field + 1);
 
+		switch (field) {
+		case GUEST_APIC_TIMER_VECTOR:
+			if (!cpu_has_vmx_apic_timer_virt())
+				continue;
+			break;
+		default:
+			break;
+		}
+
 		clear_bit(field, vmx_vmread_bitmap);
 		if (field & 1)
 #ifdef CONFIG_X86_64
@@ -2539,7 +2548,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	if (cpu_has_tertiary_exec_ctrls()) {
 		u64 ctls = 0;
 
-		/* guest apic timer virtualization will come */
+		if (nested_cpu_has_guest_apic_timer(vmcs12))
+			ctls |= TERTIARY_EXEC_GUEST_APIC_TIMER;
 
 		tertiary_exec_controls_set(vmx, ctls);
 	}
@@ -2733,6 +2743,9 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 		vmcs_write64(EOI_EXIT_BITMAP3, vmcs12->eoi_exit_bitmap3);
 	}
 
+	if (nested_cpu_has_guest_apic_timer(vmcs12))
+		vmcs_write16(GUEST_APIC_TIMER_VECTOR, vmcs12->virtual_timer_vector);
+
 	/*
 	 * Make sure the msr_autostore list is up to date before we set the
 	 * count in the vmcs02.
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 2a21864a020a..3842ee1ddabf 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -3,6 +3,8 @@
 
 #include "vmcs12.h"
 
+static_assert(sizeof(struct vmcs12) <= VMCS12_SIZE);
+
 #define VMCS12_OFFSET(x) offsetof(struct vmcs12, x)
 #define FIELD(number, name)	[ROL16(number, 6)] = VMCS12_OFFSET(name)
 #define FIELD64(number, name)						\
@@ -22,6 +24,7 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD(GUEST_TR_SELECTOR, guest_tr_selector),
 	FIELD(GUEST_INTR_STATUS, guest_intr_status),
 	FIELD(GUEST_PML_INDEX, guest_pml_index),
+	FIELD(GUEST_APIC_TIMER_VECTOR, virtual_timer_vector),
 	FIELD(HOST_ES_SELECTOR, host_es_selector),
 	FIELD(HOST_CS_SELECTOR, host_cs_selector),
 	FIELD(HOST_SS_SELECTOR, host_ss_selector),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index db1f86a48343..d8e09de44f2a 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -191,6 +191,7 @@ struct __packed vmcs12 {
 	u16 host_gs_selector;
 	u16 host_tr_selector;
 	u16 guest_pml_index;
+	u16 virtual_timer_vector;
 };
 
 /*
@@ -373,6 +374,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(host_gs_selector, 992);
 	CHECK_OFFSET(host_tr_selector, 994);
 	CHECK_OFFSET(guest_pml_index, 996);
+	CHECK_OFFSET(virtual_timer_vector, 998);
 }
 
 extern const unsigned short vmcs12_field_offsets[];
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


