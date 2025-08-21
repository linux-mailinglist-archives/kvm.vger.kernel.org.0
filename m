Return-Path: <kvm+bounces-55291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB87B2FACB
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 15:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 67AAE1BA7ED2
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 13:37:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B47CE3570BC;
	Thu, 21 Aug 2025 13:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QGraooO0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCF933EAE7;
	Thu, 21 Aug 2025 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755783131; cv=none; b=j2PEgo9iLPhhsSE92OCAMe7qhpkHzHyuHvIkFUK6sy1S2myBu2MWbTCJS0uh4dwmS1FoDZ1dW80jDfxgIoWDeEPOw/GgqmjnSzHKQCcgnfDLPbipJCAzUK2PqQ3tY0+Oapl7BUcgBDMMg1LOISanHdWv5hc4E9+yBK1asogcZtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755783131; c=relaxed/simple;
	bh=Vt1W25kMMM3KRJ8+sJalaI7G/MYpJOo9TAJkv7Kgokc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GaXyNIcd/8v/vC+W/4o+JE/YA576Yx+LYXycj9Oet44kxTV939Fz1l2tNcMj9f5qfyT8c/HqkdY/ZTwityAD+8+RtkHo7eLLYx3wUGgQvVviKt/d3zFo54HEhtX8MiwrT+xf+kxeSfxDdL8zFVjCjz6f1iVrr+m3QEZOVXseLKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QGraooO0; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755783130; x=1787319130;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Vt1W25kMMM3KRJ8+sJalaI7G/MYpJOo9TAJkv7Kgokc=;
  b=QGraooO0nQAyO2sbrtcs5by9rMNYsrJVwhzZMXRT+JSOFdrOKu4c1NrT
   tN3ykQeTfeGfUzr0bKQmj0TZqP2IfR/ehIZIk57xemcDHgGt894BZao1V
   m5Y6W+PO5OnZ5gkbXDOg/8BQr6/MYU8nFDZwQ+CJ8cqT4aHo+eNEFB+p8
   VSFDDqzEd6qxkIJGqfGKvxX+LyVtoFWSMYMsGPPcFj+jqwFnaLXg86zqX
   B6WdQNdo81emTjuwdt5WEYpH+VOIwVs6u3HagToY2nF3CX8i8YD4uIRKb
   f/GOoLeYGntbWvTEoaeVr2UUulhntq3mwQQB+CI16DG5der1dTNrvWQuh
   A==;
X-CSE-ConnectionGUID: rN7lJrXbSH+wa/pj7T8slQ==
X-CSE-MsgGUID: nPGTJ6/sRiSYB5Da3JDZ7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11529"; a="69446206"
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="69446206"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:32:01 -0700
X-CSE-ConnectionGUID: FnrPIelURaaYHrP+tGgkrA==
X-CSE-MsgGUID: XK1lKooPSl62c1+v7IMWqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,306,1747724400"; 
   d="scan'208";a="199285442"
Received: from 984fee019967.jf.intel.com ([10.165.54.94])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 06:31:59 -0700
From: Chao Gao <chao.gao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: chao.gao@intel.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	john.allen@amd.com,
	mingo@redhat.com,
	minipli@grsecurity.net,
	mlevitsk@redhat.com,
	pbonzini@redhat.com,
	rick.p.edgecombe@intel.com,
	seanjc@google.com,
	tglx@linutronix.de,
	weijiang.yang@intel.com,
	x86@kernel.org,
	xin@zytor.com
Subject: [PATCH v13 19/21] KVM: nVMX: Add consistency checks for CET states
Date: Thu, 21 Aug 2025 06:30:53 -0700
Message-ID: <20250821133132.72322-20-chao.gao@intel.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250821133132.72322-1-chao.gao@intel.com>
References: <20250821133132.72322-1-chao.gao@intel.com>
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


