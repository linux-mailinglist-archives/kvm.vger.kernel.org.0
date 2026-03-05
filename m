Return-Path: <kvm+bounces-72898-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kP1EKHXCqWnNDQEAu9opvQ
	(envelope-from <kvm+bounces-72898-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:50:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 42EDB216869
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:50:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 82F9231C5BED
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A5093EF0B9;
	Thu,  5 Mar 2026 17:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MFiCFOwz"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8064D3EB7F8;
	Thu,  5 Mar 2026 17:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732680; cv=none; b=XbJnsuemjx5+9avoZakLeinIuQPsYysqkfGlBL8Na19V8rgiOKoBfVhnjpMNw9OaHubL+vHuN1kMaVIv+nNrfLbaQdBB404rZRj2xEeMBWpfTHlEb6a9mNM5T/gDJFb12inBovqTxNSX+D6xS/OERIIUPJXN/oXg7HYSkbG87oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732680; c=relaxed/simple;
	bh=eT6RD0SBGKCyF9wMnFs4nMq6bepuJAhSEWVNSCsxUn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsWZT/q+/nvdOSoOSVgCGUUHtnKB7ZWYYwCe0G2UAldRmdCMJ3krAMeq4XFWDKnvMd9WR0osfKo8XTy0FewccgJOfpkBqbUYJImbFR5O9UAaMzDsmw72gwhqS1aEUdFLuR2Zyvctd3IJe4phGM/oSdbMLsWsJWuu1t5KevYCyxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MFiCFOwz; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732678; x=1804268678;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eT6RD0SBGKCyF9wMnFs4nMq6bepuJAhSEWVNSCsxUn8=;
  b=MFiCFOwzOR5Ux+rjEsHGE1xozaQQ3Vluimtqa093mUizMuCWd8b1x16X
   Ks9yurXkMKLYeetrM4ytug/3sbfbnZRaVVcxMHnsXpKdPqT+SNrEOP88+
   aIYWYRwYUrNAqExJBx9d0h84ZddMy47UnJRcqjL/TNQ4G3dOtfsR+jVfJ
   z4uY9WlORv06fm3ShHao+aktWFL1VUNbBHK731o0YgP8IqOn/EoX7dvbZ
   ZQMkAmqkJ4dFtfAd0g4t5KyYbTAab/QGZAEgReHsmCkZXAAG1mDBc0dA6
   HNRWePWj2Rc2z6Bn/STANg0+HNGAp1EDm6sJ4c9yY2jsgTmXmH7Xsp8r3
   Q==;
X-CSE-ConnectionGUID: 9B6Y1ljBQ4yIKiY6EshUQA==
X-CSE-MsgGUID: qFVkyImLTtWX0KCn5LtrbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="73798230"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="73798230"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:38 -0800
X-CSE-ConnectionGUID: k7MJz65HR/WGiH8UQmJWwA==
X-CSE-MsgGUID: X8pU8Gw4TZGHbK7c+fJROw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="215527265"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:38 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 15/36] KVM: VMX: Make vmx_calc_deadline_l1_to_host() non-static
Date: Thu,  5 Mar 2026 09:43:55 -0800
Message-ID: <59869f2d4dd95c00df4f78083509d39fc275ba3e.1772732517.git.isaku.yamahata@intel.com>
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
X-Rspamd-Queue-Id: 42EDB216869
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
	TAGGED_FROM(0.00)[bounces-72898-lists,kvm=lfdr.de];
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

Remove static from vmx_calc_deadline_l1_to_host() and declare it in vmx.h.

As nVMX APIC timer virtualization will use vmx_calc_deadline_l1_to_host(),
make it available to nested.c.  Make u64_shl_div_u64() usable for X86_32
as vmx_calc_deadline_l1_to_host() is used for both X86_32 and X86_64.
Without this change, ARCH=i386 fails to compile.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 41 ++++++++++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.h |  2 ++
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 25f31103cb21..bac3f33f7d73 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8318,25 +8318,32 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
 	return X86EMUL_INTERCEPTED;
 }
 
-#ifdef CONFIG_X86_64
 /* (a << shift) / divisor, return 1 if overflow otherwise 0 */
 static inline int u64_shl_div_u64(u64 a, unsigned int shift,
 				  u64 divisor, u64 *result)
 {
-	u64 low = a << shift, high = a >> (64 - shift);
+	u64 high = a >> (64 - shift);
+#ifdef CONFIG_X86_64
+	u64 low = a << shift;
+#endif
 
 	/* To avoid the overflow on divq */
 	if (high >= divisor)
 		return 1;
 
+#ifdef CONFIG_X86_64
 	/* Low hold the result, high hold rem which is discarded */
 	asm("divq %2\n\t" : "=a" (low), "=d" (high) :
 	    "rm" (divisor), "0" (low), "1" (high));
 	*result = low;
+#else
+	*result = mul_u64_u64_div_u64(a, 1ULL << shift, divisor);
+#endif
 
 	return 0;
 }
 
+#ifdef CONFIG_X86_64
 int vmx_set_hv_timer(struct kvm_vcpu *vcpu, u64 guest_deadline_tsc,
 		     bool *expired)
 {
@@ -8414,7 +8421,21 @@ void vmx_cancel_apic_virt_timer(struct kvm_vcpu *vcpu)
 	tertiary_exec_controls_clearbit(to_vmx(vcpu), TERTIARY_EXEC_GUEST_APIC_TIMER);
 }
 
-static u64 vmx_calc_deadline_l1_to_host(struct kvm_vcpu *vcpu, u64 l1_tsc)
+void vmx_set_guest_tsc_deadline_virt(struct kvm_vcpu *vcpu,
+				     u64 guest_deadline_virt)
+{
+	vmcs_write64(GUEST_DEADLINE_VIR, guest_deadline_virt);
+	vmcs_write64(GUEST_DEADLINE_PHY,
+		     vmx_calc_deadline_l1_to_host(vcpu, guest_deadline_virt));
+}
+
+u64 vmx_get_guest_tsc_deadline_virt(struct kvm_vcpu *vcpu)
+{
+	return vmcs_read64(GUEST_DEADLINE_VIR);
+}
+#endif
+
+u64 vmx_calc_deadline_l1_to_host(struct kvm_vcpu *vcpu, u64 l1_tsc)
 {
 	u64 host_tsc_now = rdtsc();
 	u64 l1_tsc_now = kvm_read_l1_tsc(vcpu, host_tsc_now);
@@ -8454,20 +8475,6 @@ static u64 vmx_calc_deadline_l1_to_host(struct kvm_vcpu *vcpu, u64 l1_tsc)
 	return host_tsc;
 }
 
-void vmx_set_guest_tsc_deadline_virt(struct kvm_vcpu *vcpu,
-				     u64 guest_deadline_virt)
-{
-	vmcs_write64(GUEST_DEADLINE_VIR, guest_deadline_virt);
-	vmcs_write64(GUEST_DEADLINE_PHY,
-		     vmx_calc_deadline_l1_to_host(vcpu, guest_deadline_virt));
-}
-
-u64 vmx_get_guest_tsc_deadline_virt(struct kvm_vcpu *vcpu)
-{
-	return vmcs_read64(GUEST_DEADLINE_VIR);
-}
-#endif
-
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9a61f6bd8cc0..6f1caf3ef5b7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -394,6 +394,8 @@ static inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
+u64 vmx_calc_deadline_l1_to_host(struct kvm_vcpu *vcpu, u64 l1_tsc);
+
 gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
-- 
2.45.2


