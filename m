Return-Path: <kvm+bounces-70047-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wLg1BmU9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70047-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:24:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 82037DD86D
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:24:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3800730692F7
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:19:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9DC53DA7C4;
	Tue,  3 Feb 2026 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MBvL2Ua9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FE33D7D63;
	Tue,  3 Feb 2026 18:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142665; cv=none; b=XzZn+pdfIL4DDRFtxtbgVhMr0BQYIWHIOTvlTM0L57n8qytMolTs/8qRSMcLALhdNSZ6VVrqmOU/629CCLfExXtSiH7TKWjsc56z0LgtoQKeDkyvs62Yk+gTbxw/bzuirzCLwMUKgbTW3sPENvMWc3gnot7IhzWGI5r6J4ldqQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142665; c=relaxed/simple;
	bh=9XI7vB+0OJRjYggT6bE/btEJW/0e/kC1khjIdnkgrRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZO/6bjEA1aBgiXBPdiwHZLCGTSNLWOLDTJBmXG2thowNkwlvUE1//mEdMIKZzdiE1bzO6kqCVj4/9mDu8fie0utQ0mkOnPJE3ysaTpmCVshBilXkyDojJAa2qub2chJcKyH7Ky/YWBjpug66sGOLiGmIH7eK7g8DjoyOy3Qm72M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MBvL2Ua9; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142665; x=1801678665;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9XI7vB+0OJRjYggT6bE/btEJW/0e/kC1khjIdnkgrRc=;
  b=MBvL2Ua9Yk1BInlgt+YWY26OnQNg3N1CplfcNCPJg+ElNpCE9vhCsx8e
   a/ufl1Rg2LSacMEJMDYHgimP5+j8Yk9hccjII61e+gNCm+31BzFJm8OmJ
   ZURCaPlfZqbyoivSrhDwLaevXGKyrlbscr2JxcS7Zs7r4hjOG3FZi9OW/
   NYWhgMnAMpbALowUaCEeyX1Yebgu2oOx7vieZlFWhC1uBnrp/jwYAuH60
   x+9Mm6hz+2/Iz3eqJSGUWquAvDZMSioY3PceduOuEHtVfi0Wa/mYYB1en
   YOFO/83f0LxWvHNWYpvCgj6Ty967C4eBCj6Mpnx950PWfVSx8t/oaexxH
   Q==;
X-CSE-ConnectionGUID: DfXAEdEpSKi77E2yxDA7pA==
X-CSE-MsgGUID: YFDwxr65RfC2TXAo90dwfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="88745810"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="88745810"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:42 -0800
X-CSE-ConnectionGUID: Zfh5TzQVTgK6R48jzLbj6A==
X-CSE-MsgGUID: 4zEi82FJSUOUGp+5STScvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209605488"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:42 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 14/32] KVM: VMX: Make vmx_calc_deadline_l1_to_host() non-static
Date: Tue,  3 Feb 2026 10:16:57 -0800
Message-ID: <e1925ecd6e282f11efdd53e4de8ce759098135e2.1770116051.git.isaku.yamahata@intel.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70047-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NO_DN(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email,intel.com:dkim,intel.com:mid]
X-Rspamd-Queue-Id: 82037DD86D
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Remove static from vmx_calc_deadline_l1_to_host() and declare in vmx.h.

As nVMX APIC timer virtualization will use vmx_calc_deadline_l1_to_host(),
make it available to nested.c.  Make u64_shl_div_u64() usable for X86_32
that vmx_calc_deadline_l1_to_host() uses for both X86_32 and X86_64.
Without this change, ARCH=i386 fails to compile.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 41 ++++++++++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.h |  2 ++
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index dc6b6659a093..41c94f5194f6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8218,25 +8218,32 @@ int vmx_check_intercept(struct kvm_vcpu *vcpu,
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
@@ -8314,7 +8321,21 @@ void vmx_cancel_apic_virt_timer(struct kvm_vcpu *vcpu)
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
@@ -8354,20 +8375,6 @@ static u64 vmx_calc_deadline_l1_to_host(struct kvm_vcpu *vcpu, u64 l1_tsc)
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
index cb32d0fdf3b8..28625a2d17bd 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -405,6 +405,8 @@ static inline void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu,
 u64 vmx_get_l2_tsc_offset(struct kvm_vcpu *vcpu);
 u64 vmx_get_l2_tsc_multiplier(struct kvm_vcpu *vcpu);
 
+u64 vmx_calc_deadline_l1_to_host(struct kvm_vcpu *vcpu, u64 l1_tsc);
+
 gva_t vmx_get_untagged_addr(struct kvm_vcpu *vcpu, gva_t gva, unsigned int flags);
 
 void vmx_update_cpu_dirty_logging(struct kvm_vcpu *vcpu);
-- 
2.45.2


