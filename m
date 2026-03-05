Return-Path: <kvm+bounces-72905-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qDwVAdjBqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72905-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:48:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id BEA8B21676E
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:48:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DCD283063E39
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7445341C2F8;
	Thu,  5 Mar 2026 17:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kBqfmAgT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2BD3EFD2D;
	Thu,  5 Mar 2026 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732683; cv=none; b=sLFgNQ/BDyZlHEURkmwMCYo/teWAXRSAnRvc9S/+Fwxn+7TcbHsHsNWceJwALe07ZYy4cvRKcjaz9mF3sWlPSBOr6LuEX06fa2s0Veu3oY22SQtaoUh4gk8KMZQQt2kaHg1tBL3Fzio1OasbOXwsE5tXZ+R4OVTD3WdL0C3VvE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732683; c=relaxed/simple;
	bh=QdD5jenTwR29sa1dIqsfwFdRih7W65ynbtkxRigqKE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nzDpPpQcKH1zMXgeATwHC9MWn4II8jF9sE8qSfRILquYY//QeFecbKW+Z+ONAmyaGjD1dDwL4QVUfGq/el+CjsZBStvfZmPKKqhWfasedxPhOfF5ANczEe9zSnX9YM9AxEz795PkjexpOpVFWWCZPrFtpEu0PO13VXdwkGE8I7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kBqfmAgT; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732682; x=1804268682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QdD5jenTwR29sa1dIqsfwFdRih7W65ynbtkxRigqKE0=;
  b=kBqfmAgT0WM6I7f2xHY+95KJUE0W1Hcj6idYxJTpHOxjzalqPVPjKCcF
   zj+gh+wKlOTesdRmeHJiTB7/EP4yeL95Tg9IGnxMInK2mvXgZEqAr+3Pt
   LaHENLw++lZNlbcie3RBeLAFnaTi41o0vFJhuLjKLBWgoj1SuNsJSe98u
   No+FQz4F49Xhvclht8g41SstaLd5v2Y6xRTqmdihgvAN1+4a0EyY6Jv/t
   oOGhX3afh4BhKVi43jmWmX0wRPVXaU4Wa70j4UK7P0W7Adflg0PFkIr9L
   9qFMMbPa152eraBjqNksEGKj7xAzLoRYrhxquK0YCsU6z9UqYMtKLrVoq
   Q==;
X-CSE-ConnectionGUID: ill+ReKzRm+rYAvrJgIfkQ==
X-CSE-MsgGUID: qbCJ0v1IRau5+ykTrhjAow==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77701116"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="77701116"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:41 -0800
X-CSE-ConnectionGUID: Ay5G3H1mTzypGVJQUzKJFg==
X-CSE-MsgGUID: RX4o2c5/T+OiqCHEU3FtKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="256647601"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:41 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 19/36] KVM: nVMX: Add check VMCS index for guest timer virtualization
Date: Thu,  5 Mar 2026 09:43:59 -0800
Message-ID: <e5d506038bf26c2e2c9036b6eb8a9704501516f6.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: BEA8B21676E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-72905-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Make vmread/vmwrite to the VMCS fields an error if the guest
MSR_IA32_VMX_PROCBASED_CTLS3 doesn't advertise APIC timer virtualization.
Without this check, test_vmwrite_vmread of the KVM unit test fails.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 14 ++++++++++++++
 arch/x86/kvm/vmx/nested.h |  7 +++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 562b5ffc6433..3cd29b005afe 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5775,6 +5775,14 @@ static bool is_vmcs_field_valid(struct kvm_vcpu *vcpu, unsigned long field)
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
 
@@ -7190,6 +7198,12 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
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
index 1100a8114dd9..d5d624150aca 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -291,6 +291,13 @@ static inline bool nested_cpu_has_encls_exit(struct vmcs12 *vmcs12)
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


