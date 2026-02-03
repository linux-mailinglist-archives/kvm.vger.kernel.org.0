Return-Path: <kvm+bounces-70049-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aB1uB8M8gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70049-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:21:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 763BFDD7E7
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:21:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D12D930D2C14
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB4003E8C71;
	Tue,  3 Feb 2026 18:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VAqHUdBc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D4B3D9029;
	Tue,  3 Feb 2026 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142667; cv=none; b=EldO/zI4K0kbSWeRyYCDq2vgaZY8EAhz2WO1Tn0KpmkDbcoYtXERxD0YjgBBQujE9dylEShl5XEg/1PUv1F3/+ZWcD5AbQCr6C1jYMYDYI3/tpV7JZQ1i8JCd502tltkCD25RDyqKhuqpitZB0ONwpu/drrd9LJCPjmdtxLF37Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142667; c=relaxed/simple;
	bh=px+gf9CycIrN2SRb7cWFwlLMe1ewXZI2g90WSPrwj7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g9FJ+HlFv7kfIZouoYYPj9u+ZG14hIrAaEJNydaVn3nZmJtArf1saFa/EpUThMeR231SZ3BWl2MCulS9rQ5oZqXaxpQRP2v3DgE5PQH/EAQlIVbivDfWZv/8VFytHtCEMDlh/wUqcdtObdV+sQUaz/FVtNxz+6JLvBbrnvD5MNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VAqHUdBc; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142666; x=1801678666;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=px+gf9CycIrN2SRb7cWFwlLMe1ewXZI2g90WSPrwj7s=;
  b=VAqHUdBcKcI/kvaS/5JqpHdPUmv8yHloPbrOsROMNRQVwcOs0gCZfP0F
   utm4peSxcBhCExhhY8CdMhJZuvuuHvrN6/dKLVuZEuJKaGyZUwvyWmNeq
   gQQcZahhmq7oYPXV9+vSHmKbGKXxAeP2cMFNbd3Vdmxhjc0TfdOPtpSk5
   lwRVCeh7Ax9+dZb+A9VZEfPyfs20vSlefsoZ8vQK8VFEx7cp5Xn/ImDo1
   WFYPx8TDMqnu7bj5znU4EJNt49An7GFwCWizZ+9BBr0KrZwjd0HRaS/G5
   Z8begdY8o9XGzl7eRR+TvVwGik1cuVS5GyVT53qFRFfpTjUvSY87xGW5G
   g==;
X-CSE-ConnectionGUID: MHTgx4+oRTiWNVQvnIpTAg==
X-CSE-MsgGUID: Sl5GRDBURpiui6vLfgpUvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745823"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745823"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:44 -0800
X-CSE-ConnectionGUID: W7yY16fLS7qbPpRzmzGmuw==
X-CSE-MsgGUID: FtFY+x9hT1OXLV/050JKtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605498"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:43 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH 17/32] KVM: nVMX: Add check vmread/vmwrite on tertiary control
Date: Tue,  3 Feb 2026 10:17:00 -0800
Message-ID: <610a83212de7a5e598e45a4d80d3409ac693ffb6.1770116051.git.isaku.yamahata@intel.com>
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
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70049-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 763BFDD7E7
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Make the access to the tertiary processor-based VM control an error if the
guest VMX true processor-based controls don't report it.

Without this patch, the KVM unit test_vmread_vmwrite() fails because
vmread()/vmwrite() can succeeds with the index beyond
MSR_IA32_VMX_VMCS_ENUM when the tertiary processor-based VM-executing
controls aren't advertised to the guest.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 20 ++++++++++++++++++++
 arch/x86/kvm/vmx/nested.h |  5 +++++
 2 files changed, 25 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c8b42c880300..d6ae62e70560 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5794,6 +5794,16 @@ static int handle_vmresume(struct kvm_vcpu *vcpu)
 	return nested_vmx_run(vcpu, false);
 }
 
+static bool is_vmcs_field_valid(struct kvm_vcpu *vcpu, unsigned long field)
+{
+	if (!nested_cpu_supports_tertiary_ctls(vcpu) &&
+	    (field == TERTIARY_VM_EXEC_CONTROL ||
+	     field == TERTIARY_VM_EXEC_CONTROL_HIGH))
+		return false;
+
+	return true;
+}
+
 static int handle_vmread(struct kvm_vcpu *vcpu)
 {
 	struct vmcs12 *vmcs12 = is_guest_mode(vcpu) ? get_shadow_vmcs12(vcpu)
@@ -5824,6 +5834,9 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
 		     get_vmcs12(vcpu)->vmcs_link_pointer == INVALID_GPA))
 			return nested_vmx_failInvalid(vcpu);
 
+		if (!is_vmcs_field_valid(vcpu, field))
+			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+
 		offset = get_vmcs12_field_offset(field);
 		if (offset < 0)
 			return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
@@ -5948,6 +5961,9 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
 
 	field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));
 
+	if (!is_vmcs_field_valid(vcpu, field))
+		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
+
 	offset = get_vmcs12_field_offset(field);
 	if (offset < 0)
 		return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
@@ -7196,6 +7212,10 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 			kvm_state->hdr.vmx.preemption_timer_deadline;
 	}
 
+	if (!nested_cpu_supports_tertiary_ctls(vcpu) &&
+	    vmcs12->tertiary_vm_exec_control)
+		goto error_guest_mode;
+
 	if (nested_vmx_check_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_host_state(vcpu, vmcs12) ||
 	    nested_vmx_check_guest_state(vcpu, vmcs12, &ignored))
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 9ca1df72e228..07c0f112e37e 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -158,6 +158,11 @@ static inline bool __nested_cpu_supports_tertiary_ctls(struct nested_vmx_msrs *m
 	return msrs->procbased_ctls_high & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
 }
 
+static inline bool nested_cpu_supports_tertiary_ctls(struct kvm_vcpu *vcpu)
+{
+	return __nested_cpu_supports_tertiary_ctls(&to_vmx(vcpu)->nested.msrs);
+}
+
 static inline bool nested_cpu_has(struct vmcs12 *vmcs12, u32 bit)
 {
 	return vmcs12->cpu_based_vm_exec_control & bit;
-- 
2.45.2


