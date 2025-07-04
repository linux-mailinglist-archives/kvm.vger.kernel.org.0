Return-Path: <kvm+bounces-51591-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D158AF8D0C
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 11:00:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39DBE765A33
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 08:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 888922F6FBE;
	Fri,  4 Jul 2025 08:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ajCsPtFk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927BB2F546D;
	Fri,  4 Jul 2025 08:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751619056; cv=none; b=F6r66b2ySPo7PsN7ZKzhNuNUK4fuo3YSpOVhTQa/b3yo7GAUhHhlncx8B8YS2GO4TTbSFOcC8DmI7z1jD77aCEXwvmI2xOOkfVnr+WuY23Y7rleH3WGJNifnZU3sRwd1KM/vUPFugMxlcsvL+Ey3p+AypneOg5zaZxY8x6kPGgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751619056; c=relaxed/simple;
	bh=9ZQhnOZauBSt7UZD9IRuNYyyzL9Xt5RBe0hhjhp3+H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CBtATE4OM1yaqzi/prvbEVLK3ipeuiUe25m8TpKAWQOAnhqib4+KUkVGeH/cmwwOR7wtlmq00ELBXig1htWmkJx6yQSyO5UwkcIsygh1S62g1NjYmTuO/2clSkm2ecNqKOFwX3vg0qdCWaHo11PMD3RTpHYPjFshftiDVESMqG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ajCsPtFk; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751619054; x=1783155054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9ZQhnOZauBSt7UZD9IRuNYyyzL9Xt5RBe0hhjhp3+H0=;
  b=ajCsPtFkcXLgWUmj+RZshEHQhhp6E/AdJROBrvOXLOWF7/r8C7w/yKAi
   PVPn9F7yylcuAxm9rHz0ic95Q0bEwEcAmkLdO6wpV6rp7cGDaybAUDprW
   BKemuVRxzlPEDsSb3HnWm0e/UDjrcArFkrMsXk5+EXB8c6MVbwk19s2OG
   BbS1uC6xNAvuAK4OsDuZp3TduGQC1SU0Ey2gSB2ple3XXz/PX3078Ubuc
   QD1SdIULwpBlCdgldPC8mpS/nyDBOGyt6Fxd1jlgRGFNhJZeKpCOqEzbO
   IitgzDnzYWRJdjkm1uq8NqrV5Vf8BB/GcRD8A6usBBubnbfXIEazLrwLh
   w==;
X-CSE-ConnectionGUID: GGIonwDXQCmhYIcvaODq9A==
X-CSE-MsgGUID: piuxvDTkQgK00ZoqZ64r9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="79391795"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="79391795"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:46 -0700
X-CSE-ConnectionGUID: t9txymC3QMOMfe7iQZEZ3g==
X-CSE-MsgGUID: Rw0YyGbOTqOmbpPjvc0d5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="154722029"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2025 01:50:47 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	dave.hansen@intel.com
Cc: rick.p.edgecombe@intel.com,
	mlevitsk@redhat.com,
	john.allen@amd.com,
	weijiang.yang@intel.com,
	minipli@grsecurity.net,
	xin@zytor.com,
	Chao Gao <chao.gao@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v11 23/23] KVM: nVMX: Add consistency checks for CET states
Date: Fri,  4 Jul 2025 01:49:54 -0700
Message-ID: <20250704085027.182163-24-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250704085027.182163-1-chao.gao@intel.com>
References: <20250704085027.182163-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce consistency checks for CET states during nested VM-entry.

A VMCS contains both guest and host CET states, each comprising the
IA32_S_CET MSR, SSP, and IA32_INTERRUPT_SSP_TABLE_ADDR MSR. Various
checks are applied to CET states during VM-entry as documented in SDM
Vol3 Chapter "VM ENTRIES". Implement all these checks during nested
VM-entry to emulate the architectural behavior.

In summary, there are three kinds of checks on guest/host CET states
during VM-entry:

A. Checks applied to both guest states and host states:

 * The IA32_S_CET field must not set any reserved bits; bits 10 (SUPPRESS)
   and 11 (TRACKER) cannot both be set.
 * SSP should not have bits 1:0 set.
 * The IA32_INTERRUPT_SSP_TABLE_ADDR field must be canonical.

B. Checks applied to host states only

 * IA32_S_CET MSR and SSP must be canonical if the CPU enters 64-bit mode
   after VM-exit. Otherwise, IA32_S_CET and SSP must have their higher 32
   bits cleared.

C. Checks applied to guest states only:

 * IA32_S_CET MSR and SSP are not required to be canonical (i.e., 63:N-1
   are identical, where N is the CPU's maximum linear-address width). But,
   bits 63:N of SSP must be identical.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 47 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 362e241a2cbb..3d16d97d8dc7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3098,6 +3098,17 @@ static bool is_l1_noncanonical_address_on_vmexit(u64 la, struct vmcs12 *vmcs12)
 	return !__is_canonical_address(la, l1_address_bits_on_exit);
 }
 
+static bool is_valid_cet_state(struct kvm_vcpu *vcpu, u64 s_cet, u64 ssp, u64 ssp_tbl)
+{
+	if (!is_cet_msr_valid(vcpu, s_cet) || !IS_ALIGNED(ssp, 4))
+		return false;
+
+	if (is_noncanonical_msr_address(ssp_tbl, vcpu))
+		return false;
+
+	return true;
+}
+
 static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 				       struct vmcs12 *vmcs12)
 {
@@ -3167,6 +3178,26 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 			return -EINVAL;
 	}
 
+	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_CET_STATE) {
+		if (CC(!is_valid_cet_state(vcpu, vmcs12->host_s_cet, vmcs12->host_ssp,
+					   vmcs12->host_ssp_tbl)))
+			return -EINVAL;
+
+		/*
+		 * IA32_S_CET and SSP must be canonical if the host will
+		 * enter 64-bit mode after VM-exit; otherwise, higher
+		 * 32-bits must be all 0s.
+		 */
+		if (ia32e) {
+			if (CC(is_noncanonical_msr_address(vmcs12->host_s_cet, vcpu)) ||
+			    CC(is_noncanonical_msr_address(vmcs12->host_ssp, vcpu)))
+				return -EINVAL;
+		} else {
+			if (CC(vmcs12->host_s_cet >> 32) || CC(vmcs12->host_ssp >> 32))
+				return -EINVAL;
+		}
+	}
+
 	return 0;
 }
 
@@ -3277,6 +3308,22 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	     CC((vmcs12->guest_bndcfgs & MSR_IA32_BNDCFGS_RSVD))))
 		return -EINVAL;
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
+		if (CC(!is_valid_cet_state(vcpu, vmcs12->guest_s_cet, vmcs12->guest_ssp,
+					   vmcs12->guest_ssp_tbl)))
+			return -EINVAL;
+
+		/*
+		 * Guest SSP must have 63:N bits identical, rather than
+		 * be canonical (i.e., 63:N-1 bits identical), where N is
+		 * the CPU's maximum linear-address width. Similar to
+		 * is_noncanonical_msr_address(), use the host's
+		 * linear-address width.
+		 */
+		if (CC(!__is_canonical_address(vmcs12->guest_ssp, max_host_virt_addr_bits() + 1)))
+			return -EINVAL;
+	}
+
 	if (nested_check_guest_non_reg_state(vmcs12))
 		return -EINVAL;
 
-- 
2.47.1


