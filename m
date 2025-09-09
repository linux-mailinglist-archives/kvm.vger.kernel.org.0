Return-Path: <kvm+bounces-57084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A9AC5B4A88A
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 11:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 933FD7BC197
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 09:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE95730E855;
	Tue,  9 Sep 2025 09:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QqTA63FR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBBD930DEBD;
	Tue,  9 Sep 2025 09:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757410811; cv=none; b=Opw6vrx/faolncTh7HO9BdiHb3yLGRWfTTfvkXHlpMEnCasw9HtY0Pr/hMzjAYFkcx2DMvMu/qc3ozhNrGFFva7ofU1bYoytlXsVY/r2n00WY4q54ONrc7BFbnEGv1kprwiS9fbxfLc3I4N+N/z87M+hqoeq9JgZ/M1jPQKMHO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757410811; c=relaxed/simple;
	bh=Vt1W25kMMM3KRJ8+sJalaI7G/MYpJOo9TAJkv7Kgokc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9CMOVKhBL0vMZysD2ir8/R0tmfNnTs+qCo8VGmmcMG70ra6gOsaDAJN4aAWpOZDoypeEFs+/Twl487x0OKCyYFKhfwCuOJZw4RXZVBqbgJ+/hralaXpAzHq2STnX7vR817hLDOQxyMS/TJNDRf+XMBvOP8+CNqKYmdrNzWRDXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QqTA63FR; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757410810; x=1788946810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vt1W25kMMM3KRJ8+sJalaI7G/MYpJOo9TAJkv7Kgokc=;
  b=QqTA63FRGsXQTmq+cIGnOcqiHrRdcktz/uXoNPn3NFNeLeidTg/4aomi
   xpj8zxKEmfoVEMCAyYKSFEm50+5v+zlCfMq09i6Jc22GbPdnrpXIsNEYv
   U57pbn4cK35VBYbkkDbf2N7nMI8YQZ4RWqd0pFVjfFjjkAQ7ZZ8O2c7tH
   7RtH74gjoiFRJLGo5YliiMpsfoRE2W2UUAjmeappehJDQKdnsDgeOis+h
   fkWDBpHFudFGbJEsZXea0pi61SR4rwW2MmEaHHAY8xkLoMfjAMPl7WCoV
   V2nmQaskoPf92k677SBoRAdsxauNp9fqgIB2trBcsTJnIoOqgoa6vIPci
   Q==;
X-CSE-ConnectionGUID: XZFIFDIhQhClWPfhZhLm/w==
X-CSE-MsgGUID: k7XPq1Y8QA+AA7NryIKoJA==
X-IronPort-AV: E=McAfee;i="6800,10657,11547"; a="70307342"
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="70307342"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:57 -0700
X-CSE-ConnectionGUID: M+6aGOsLTFCX5BPvzoicrg==
X-CSE-MsgGUID: cCb8a3JJRFiMhXZxXLfUgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,251,1751266800"; 
   d="scan'208";a="172207445"
Received: from unknown (HELO CannotLeaveINTEL.jf.intel.com) ([10.165.54.94])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 02:39:57 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: acme@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@kernel.org,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	namhyung@kernel.org,
	pbonzini@redhat.com,
	prsampat@amd.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	shuah@kernel.org,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com,
	xiaoyao.li@intel.com
Subject: [PATCH v14 20/22] KVM: nVMX: Add consistency checks for CET states
Date: Tue,  9 Sep 2025 02:39:51 -0700
Message-ID: <20250909093953.202028-21-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250909093953.202028-1-chao.gao@intel.com>
References: <20250909093953.202028-1-chao.gao@intel.com>
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

Tested-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: John Allen <john.allen@amd.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/vmx/nested.c | 47 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a73f38d7eea1..edb3b877a0f6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3101,6 +3101,17 @@ static bool is_l1_noncanonical_address_on_vmexit(u64 la, struct vmcs12 *vmcs12)
 	return !__is_canonical_address(la, l1_address_bits_on_exit);
 }
 
+static bool is_valid_cet_state(struct kvm_vcpu *vcpu, u64 s_cet, u64 ssp, u64 ssp_tbl)
+{
+	if (!kvm_is_valid_u_s_cet(vcpu, s_cet) || !IS_ALIGNED(ssp, 4))
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
@@ -3170,6 +3181,26 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
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
 
@@ -3280,6 +3311,22 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
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
2.47.3


