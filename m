Return-Path: <kvm+bounces-70051-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6HP/AzQ9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70051-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:23:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E9432DD841
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:23:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id C3E2E301D25B
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 634733E9598;
	Tue,  3 Feb 2026 18:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ea2/arQb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F9A36E473;
	Tue,  3 Feb 2026 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142668; cv=none; b=mYrdFtZRq6c9SSrUaK6R/DgR0H9H2sQ19UNll4CMmqj1IqpGhLCt4QZM0a7+eHgzmI38Pp/v6TQCT0xC0g2ckoY+oDauG4FL8bMP8wS4aBLE1cLkenxMQkT0w4sM9CjQFOcYzjP/hNbK8qElJlTc9QDKGEhx1Ptn3j/jxSOhhyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142668; c=relaxed/simple;
	bh=16MA10iAEBEjY/zIcYesOhSOwM/Zu2zd4qCPUxxxgCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djxi2aTWJJDc5MHVj3mKbLWj/WKe1CLtLd9lnqS3fIIKpeSwsBvciAMUkTN2aTKxjFIfFM7lyQ1DV2g81RWR1Nx90m90cF9Rqgi2uJ+5eapOhpFhS6+yHnsF6wtXbaaXv9GAJ+3sH8mlnBbTF/GrhYhBZlFVrBQS1USgHM/AYy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ea2/arQb; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142667; x=1801678667;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=16MA10iAEBEjY/zIcYesOhSOwM/Zu2zd4qCPUxxxgCo=;
  b=Ea2/arQbLtRjA3175wG3qo1n6rrr2oSzRGRqix21dwwR9YKpb/6LJmLa
   G8n3+ymCag7nF/W4YZGSsuKkAAViHvpLc81S6aFeMJBKssn78caugmWLY
   y0LMdYYFjl9zRIble+0mpYsGmwas8OC2zjVuWPiVmINb9GV9Z18zJ5i8P
   skkqehfd+ivJ99TKlZeclMBEDpwKP9oFC8igtwb5UMwpEn9htOpZ+5831
   b9KyNOwtA9N1Cj0BRJUvb0ITM5ZnQzZeJE09slIzKktvEy1fcajXdjItI
   DCN5t/huBC6+v8Ur/QFByj+n4qPz4QwMKJcJxOEkBhDsqd10DiF0dI4m7
   w==;
X-CSE-ConnectionGUID: s+qQy+OVT1+jg6o+k+CCPg==
X-CSE-MsgGUID: VPN1EBFuQ2uE0RRa5FVGQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745828"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745828"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:44 -0800
X-CSE-ConnectionGUID: OpeYDVIUSSi+eX7pc5IQOA==
X-CSE-MsgGUID: 9hRHuqUdQ4WDgeUKpiB/bQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605505"
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
Subject: [PATCH 18/32] KVM: nVMX: Add check VMCS index for guest timer virtualization
Date: Tue,  3 Feb 2026 10:17:01 -0800
Message-ID: <01a8714db6af834214a3811c4d4b727371264964.1770116051.git.isaku.yamahata@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70051-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E9432DD841
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Make vmread/vmwrite to the VMCS fields an error if the guest
MSR_IA32_VMX_PROCBASED_CTLS3 doesn't advertise APIC timer virtualization.
Without this check, test_vmwrite_vmread of the KVM unit test fails.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 14 ++++++++++++++
 arch/x86/kvm/vmx/nested.h |  7 +++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d6ae62e70560..a940f1d9ee83 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5801,6 +5801,14 @@ static bool is_vmcs_field_valid(struct kvm_vcpu *vcpu, unsigned long field)
 	     field == TERTIARY_VM_EXEC_CONTROL_HIGH))
 		return false;
 
+	if (!nested_cpu_supports_guest_apic_timer(vcpu) &&
+	    (field == GUEST_APIC_TIMER_VECTOR ||
+	     field == GUEST_DEADLINE_VIR ||
+	     field == GUEST_DEADLINE_VIR_HIGH ||
+	     field == GUEST_DEADLINE_PHY ||
+	     field == GUEST_DEADLINE_PHY_HIGH))
+		return false;
+
 	return true;
 }
 
@@ -7216,6 +7224,12 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	    vmcs12->tertiary_vm_exec_control)
 		goto error_guest_mode;
 
+	if (!nested_cpu_supports_guest_apic_timer(vcpu) &&
+	    (vmcs12->virtual_timer_vector ||
+	     vmcs12->guest_deadline ||
+	     vmcs12->guest_deadline_shadow))
+		goto error_guest_mode;
+
 	if (nested_vmx_check_controls(vcpu, vmcs12) ||
 	    nested_vmx_check_host_state(vcpu, vmcs12) ||
 	    nested_vmx_check_guest_state(vcpu, vmcs12, &ignored))
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 07c0f112e37e..d84ed234a8d6 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -286,6 +286,13 @@ static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
 	return nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING);
 }
 
+static inline bool nested_cpu_supports_guest_apic_timer(struct kvm_vcpu *vcpu)
+{
+	return nested_cpu_supports_tertiary_ctls(vcpu) &&
+		to_vmx(vcpu)->nested.msrs.tertiary_ctls &
+		TERTIARY_EXEC_GUEST_APIC_TIMER;
+}
+
 static inline bool nested_cpu_has_guest_apic_timer(struct vmcs12 *vmcs12)
 {
 	return nested_cpu_has3(vmcs12, TERTIARY_EXEC_GUEST_APIC_TIMER);
-- 
2.45.2


