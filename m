Return-Path: <kvm+bounces-62558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB57C488E6
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 19:29:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE0CB3B91BC
	for <lists+kvm@lfdr.de>; Mon, 10 Nov 2025 18:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 576153328F6;
	Mon, 10 Nov 2025 18:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b1J/N0Iw"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37523321D7;
	Mon, 10 Nov 2025 18:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762799089; cv=none; b=hTv+eHay6rXzxkIkXYNpoadX47Nm4o1g1EptoMNXnCijQ/9ofYHvFWS65nhx/GCIZvS/+cVzEXrTawGEqzPzb46g+aNnM1xX1ShkJM9Ug1JBxHZ0kztv/xR6bxTtb5X8G5u4D1U0Np0yWorhsNIILkiywv6r1ilvmXZY9rCJchQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762799089; c=relaxed/simple;
	bh=9vN9/9HY8bfnpcKi4t8REEnOTQVjCIro+TT1Dr7KppY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iCj9miOWLoO5f70q/2e6H1omXf+jNDTTAEfzHlIL2m82sYHz0581JwW9kyxCK2BmBOWBAwuhgPJ0YB2yUT1JS1yVPYKJIeqnC82/qIefLJoyU7nK4pbZuHEGkErkWE+9SYFU/K4S7GddKL9EBFwecETgJkVpHpYx7p+QjIsHOco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b1J/N0Iw; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762799088; x=1794335088;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9vN9/9HY8bfnpcKi4t8REEnOTQVjCIro+TT1Dr7KppY=;
  b=b1J/N0IwI2TgTKM4ZJznzzV5WiwYoEZMF5xepiyTrQjFOhyJ4ZSEWdEd
   qpYRJBs+wSGvTQMf/MkhjHibAyZ6P6+aCq6f1Il/p45TVncUrvZOJTfdb
   +3La+UDF4jzoRY2mVa2cZuuJw4M0wI7rkchUwyQWCs+zVKBDba5krIsvr
   NCdkBWxamx/VHo0/Mn8OawCBxOeByxF9ejbXyfFcvhNC0YuIABl+58Z+B
   N33NGW6FLIWCGUji1vgePdJY9N4UzwRgCN9E3KVAKcLYEVn2DuHoGEr1Z
   aTGftjKttw1zMRqb/IQVrTmTpxlkhtLHEmL4n1OnVczZuV47qhDTZ/qfW
   Q==;
X-CSE-ConnectionGUID: M48djxRzSvevGe5wRIdFXA==
X-CSE-MsgGUID: N6JYxRmYSXiCHy8Qrlnmyg==
X-IronPort-AV: E=McAfee;i="6800,10657,11609"; a="76305502"
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="76305502"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2025 10:24:48 -0800
X-CSE-ConnectionGUID: 2QxnF43PTXW32LZ0u1VtHw==
X-CSE-MsgGUID: w1w8SdiiRO+hPuLi14TI+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,294,1754982000"; 
   d="scan'208";a="219396141"
Received: from chang-linux-3.sc.intel.com (HELO chang-linux-3) ([172.25.66.172])
  by orviesa002.jf.intel.com with ESMTP; 10 Nov 2025 10:24:48 -0800
From: "Chang S. Bae" <chang.seok.bae@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: pbonzini@redhat.com,
	seanjc@google.com,
	chao.gao@intel.com,
	zhao1.liu@intel.com,
	chang.seok.bae@intel.com
Subject: [PATCH RFC v1 07/20] KVM: nVMX: Support the extended instruction info field
Date: Mon, 10 Nov 2025 18:01:18 +0000
Message-ID: <20251110180131.28264-8-chang.seok.bae@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251110180131.28264-1-chang.seok.bae@intel.com>
References: <20251110180131.28264-1-chang.seok.bae@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Define the VMCS field offset for the extended instruction information and
handle it for nested VMX.

When EGPRs are available, VMX provides a new 64-bit field to extend the
legacy instruction information, allowing access to the higher register
indices. Then, nested VMX needs to propagate this field between L1 and
L2.

The EGPR checker will be implemented later.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
---
RFC note:
During the draft, I brought up the offset definition initially for
non-nested VMX primarily. Then, I realized the switching helper affects
nVMX code anyway. Due to this dependency, this change is placed first
together with the offset definition.
---
 arch/x86/include/asm/vmx.h | 2 ++
 arch/x86/kvm/vmx/nested.c  | 2 ++
 arch/x86/kvm/vmx/vmcs12.c  | 1 +
 arch/x86/kvm/vmx/vmcs12.h  | 3 ++-
 arch/x86/kvm/vmx/vmx.h     | 2 ++
 5 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
index c85c50019523..ab0684948c56 100644
--- a/arch/x86/include/asm/vmx.h
+++ b/arch/x86/include/asm/vmx.h
@@ -264,6 +264,8 @@ enum vmcs_field {
 	PID_POINTER_TABLE_HIGH		= 0x00002043,
 	GUEST_PHYSICAL_ADDRESS          = 0x00002400,
 	GUEST_PHYSICAL_ADDRESS_HIGH     = 0x00002401,
+	EXTENDED_INSTRUCTION_INFO	= 0x00002406,
+	EXTENDED_INSTRUCTION_INFO_HIGH	= 0x00002407,
 	VMCS_LINK_POINTER               = 0x00002800,
 	VMCS_LINK_POINTER_HIGH          = 0x00002801,
 	GUEST_IA32_DEBUGCTL             = 0x00002802,
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 97ec8e594155..3442610a6b70 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4798,6 +4798,8 @@ static void prepare_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		vmcs12->vm_exit_intr_info = exit_intr_info;
 		vmcs12->vm_exit_instruction_len = exit_insn_len;
 		vmcs12->vmx_instruction_info = vmcs_read32(VMX_INSTRUCTION_INFO);
+		if (vmx_egpr_enabled(vcpu))
+			vmcs12->extended_instruction_info = vmcs_read64(EXTENDED_INSTRUCTION_INFO);
 
 		/*
 		 * According to spec, there's no need to store the guest's
diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
index 4233b5ca9461..ea2b690a419e 100644
--- a/arch/x86/kvm/vmx/vmcs12.c
+++ b/arch/x86/kvm/vmx/vmcs12.c
@@ -53,6 +53,7 @@ const unsigned short vmcs12_field_offsets[] = {
 	FIELD64(XSS_EXIT_BITMAP, xss_exit_bitmap),
 	FIELD64(ENCLS_EXITING_BITMAP, encls_exiting_bitmap),
 	FIELD64(GUEST_PHYSICAL_ADDRESS, guest_physical_address),
+	FIELD64(EXTENDED_INSTRUCTION_INFO, extended_instruction_info),
 	FIELD64(VMCS_LINK_POINTER, vmcs_link_pointer),
 	FIELD64(GUEST_IA32_DEBUGCTL, guest_ia32_debugctl),
 	FIELD64(GUEST_IA32_PAT, guest_ia32_pat),
diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 4ad6b16525b9..2146e45aaade 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -71,7 +71,7 @@ struct __packed vmcs12 {
 	u64 pml_address;
 	u64 encls_exiting_bitmap;
 	u64 tsc_multiplier;
-	u64 padding64[1]; /* room for future expansion */
+	u64 extended_instruction_info;
 	/*
 	 * To allow migration of L1 (complete with its L2 guests) between
 	 * machines of different natural widths (32 or 64 bit), we cannot have
@@ -261,6 +261,7 @@ static inline void vmx_check_vmcs12_offsets(void)
 	CHECK_OFFSET(pml_address, 312);
 	CHECK_OFFSET(encls_exiting_bitmap, 320);
 	CHECK_OFFSET(tsc_multiplier, 328);
+	CHECK_OFFSET(extended_instruction_info, 336);
 	CHECK_OFFSET(cr0_guest_host_mask, 344);
 	CHECK_OFFSET(cr4_guest_host_mask, 352);
 	CHECK_OFFSET(cr0_read_shadow, 360);
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 64a0772c883c..b8da6ebc35dc 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -372,6 +372,8 @@ struct vmx_insn_info {
 	union insn_info info;
 };
 
+static inline bool vmx_egpr_enabled(struct kvm_vcpu *vcpu __maybe_unused) { return false; }
+
 static inline struct vmx_insn_info vmx_get_insn_info(struct kvm_vcpu *vcpu __maybe_unused)
 {
 	struct vmx_insn_info insn;
-- 
2.51.0


