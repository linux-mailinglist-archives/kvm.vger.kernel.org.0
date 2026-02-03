Return-Path: <kvm+bounces-70044-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uCsLIDk9gmmVQgMAu9opvQ
	(envelope-from <kvm+bounces-70044-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:23:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 085C6DD849
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 19:23:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D9654317AF20
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 18:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371753D9036;
	Tue,  3 Feb 2026 18:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a1kAqIa4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EEC83D6687;
	Tue,  3 Feb 2026 18:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770142665; cv=none; b=NVwMAjv81J/hrS/w+xBEaiPAsZcEvTebHRs6gXqqki6AiFT99+5Nmt9M7Mh2dBta1iyf9nQhcEGLZ7GAxU/N/CnOgBGuicIIIpfO/kiLdD/Eg428BK4xRRC1fVG3/qSlGZulQ1pr8gRlpJVOuTghT6BZgGm3pGEwDnVqd0A7lDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770142665; c=relaxed/simple;
	bh=BeDOchtE/6gFBkGg5vQffPr5YjORRd2s8W+KTY2b1Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3mHy1znEeUhUlD6DrwL2LN2IFtBGL13w7FcPDFORs1NyjF2CIt4/G6QGELRG8Epskt7Uw3wlT5ArtEIqf5Baytcb/1CbbOuhzBJGoKKGWWQRx+k5eSmekDa920bbw9/ZXF07EZdwfXFv1O6sI4o4ATxgealvbbYtjMVV18qamI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a1kAqIa4; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770142663; x=1801678663;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BeDOchtE/6gFBkGg5vQffPr5YjORRd2s8W+KTY2b1Zg=;
  b=a1kAqIa4PgKvNsGZWl1zE4tFcwsGs5YHT/FjKuG/5aESLFwr3gcztha5
   blv/eipuHU4yeCgpARiutxArFxMpQfmzw9djpbh7J0NcB1udOyaR42I53
   h4uQHuOcT8QRAv61YRsfCgUA0aD/AkihW0SNtcMQvQTDPJPAEGa9yyvL9
   BRqAVkZUDUx23WeZqxUnHpEsIw9UD+Rj38AtQthyhPzWmDkHmJrVVa4wo
   O9m38fnsqRBFPax8JvM5y7Bq3YQLaY+3D8Suy4VrOvfN6Gcw4ncITSiKV
   3g48wkRRi9IpbVeND2+K5kBMJq+JJknR2IDHVPhZYiInA81aMQqylTbOQ
   g==;
X-CSE-ConnectionGUID: u+x050k5S9KygOBuTFn3IA==
X-CSE-MsgGUID: 1g6YhQUpTN2GZc1pmcmFNQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11691"; a="82433193"
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="82433193"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:43 -0800
X-CSE-ConnectionGUID: M229sq89QK65pF7tZSFxuA==
X-CSE-MsgGUID: bWyK3jdrTmC3d8Lh5SO4kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,271,1763452800"; 
   d="scan'208";a="209727508"
Received: from khuang2-desk.gar.corp.intel.com (HELO localhost) ([10.124.221.188])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 10:17:40 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/32] KVM: nVMX: Pass struct msr_data to VMX MSRs emulation
Date: Tue,  3 Feb 2026 10:16:52 -0800
Message-ID: <3d79f3816536abb0e81a19aac60bb5a213b67803.1770116051.git.isaku.yamahata@intel.com>
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
	TAGGED_FROM(0.00)[bounces-70044-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 085C6DD849
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Pass struct msr_data, which has host_initiated member in addition to
msr_index and data to vmx_set/get_vmx_msr().

Processor-based tertiary control access depends on which initiated the
operation, the host or the guest. For host-initiated access (KVM_GET_MSRS,
KVM_SET_MSRS), if the host supports processor-based tertiary controls,
allow access.  If guest-initiated access (emulation for guest rdmsr/wrmsr),
allow/disallow based on guest tertiary controls is advertised to the guest
(guest processor-based control high &
CPU_BASED_ACTIVATE_TERTIARY_CONTROLS).  Prepare to add the check.

No functional change intended.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/nested.c |  9 +++++++--
 arch/x86/kvm/vmx/nested.h |  4 ++--
 arch/x86/kvm/vmx/vmx.c    | 18 ++++++++++++++----
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 77521e37cfc6..b1b8f0c88ca5 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1479,9 +1479,11 @@ static int vmx_restore_fixed0_msr(struct vcpu_vmx *vmx, u32 msr_index, u64 data)
  *
  * Returns 0 on success, non-0 otherwise.
  */
-int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
+int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	u32 msr_index = msr_info->index;
+	u64 data = msr_info->data;
 
 	/*
 	 * Don't allow changes to the VMX capability MSRs while the vCPU
@@ -1544,8 +1546,11 @@ int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data)
 }
 
 /* Returns 0 on success, non-0 otherwise. */
-int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata)
+int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, struct msr_data *msr_info)
 {
+	u32 msr_index = msr_info->index;
+	u64 *pdata = &msr_info->data;
+
 	switch (msr_index) {
 	case MSR_IA32_VMX_BASIC:
 		*pdata = msrs->basic;
diff --git a/arch/x86/kvm/vmx/nested.h b/arch/x86/kvm/vmx/nested.h
index 983484d42ebf..f51d7cac8a58 100644
--- a/arch/x86/kvm/vmx/nested.h
+++ b/arch/x86/kvm/vmx/nested.h
@@ -47,8 +47,8 @@ static inline void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 }
 
 void nested_sync_vmcs12_to_shadow(struct kvm_vcpu *vcpu);
-int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, u32 msr_index, u64 data);
-int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, u32 msr_index, u64 *pdata);
+int vmx_set_vmx_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+int vmx_get_vmx_msr(struct nested_vmx_msrs *msrs, struct msr_data *msr);
 int get_vmx_mem_address(struct kvm_vcpu *vcpu, unsigned long exit_qualification,
 			u32 vmx_instruction_info, bool wr, int len, gva_t *ret);
 void nested_mark_vmcs12_pages_dirty(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c625c46658dc..dc6b6659a093 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2065,11 +2065,22 @@ static inline bool is_vmx_feature_control_msr_valid(struct vcpu_vmx *vmx,
 
 int vmx_get_feature_msr(u32 msr, u64 *data)
 {
+	struct msr_data msr_info;
+	int r;
+
 	switch (msr) {
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!nested)
 			return 1;
-		return vmx_get_vmx_msr(&vmcs_config.nested, msr, data);
+
+		msr_info = (struct msr_data) {
+			.index = msr,
+			.host_initiated = true,
+		};
+		r = vmx_get_vmx_msr(&vmcs_config.nested, &msr_info);
+		if (!r)
+			*data = msr_info.data;
+		return r;
 	default:
 		return KVM_MSR_RET_UNSUPPORTED;
 	}
@@ -2154,8 +2165,7 @@ int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
 			return 1;
-		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
-				    &msr_info->data))
+		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info))
 			return 1;
 #ifdef CONFIG_KVM_HYPERV
 		/*
@@ -2482,7 +2492,7 @@ int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1; /* they are read-only */
 		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
 			return 1;
-		return vmx_set_vmx_msr(vcpu, msr_index, data);
+		return vmx_set_vmx_msr(vcpu, msr_info);
 	case MSR_IA32_RTIT_CTL:
 		if (!vmx_pt_mode_is_host_guest() ||
 			vmx_rtit_ctl_check(vcpu, data) ||
-- 
2.45.2


