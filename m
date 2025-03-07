Return-Path: <kvm+bounces-40435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7870DA57375
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:21:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FC463B672E
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2569258CC8;
	Fri,  7 Mar 2025 21:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hPeUaWrh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC7B2580C4
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741382466; cv=none; b=pELmo80ff1zSFdB04Ylv4AdX75fm+wpiQgQZv41t5sHbvXhxoHRCNjSqtt/qeHFlXqOtxz9xbfK6jn4f8zyfbRQQorgKfvz1uKwz/Cu/5WcEcfQ5H5i3ToJJIr51tBTQD3ep/NMpDIvMzwbAscAZO5SvZSwmu31swkjs1wA0Kmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741382466; c=relaxed/simple;
	bh=KLSWK+0nFTX3A4FGOm6zQbasmKz+Q+jTU207U+8wBsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YjBFBrMm6xEYObh7BgQcoxZQVuvYK4Y7GV4eWTQIzBScvr5K0r9FrbcQF4nvRfh2off3+7Z2j5C3pqHq5o9VxG1SRRW9Z9+R7h0wB3voz+JSUFaM3p18eb3LDZnp9vC7O5GtW33jqyZLNZUQi94CmgU6axttwvDsAXLihPM6c9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hPeUaWrh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741382464;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BdUYHK3kFRDv1XqfyXkuPJuoGvjHXHc4FX5XQ4wfDfo=;
	b=hPeUaWrhmcjv3Ucb7HnBaG5KZnglznPwlPqnlWeVi6lkz0+gGHoMbzoZ01D0K+yexr4yUX
	f/FY/oLrokaZwGrwEwL6LiP+8vLlRhwxqPkJvbk2DOM0TJ92QyMfAQDNWtWBnynKA4NqwX
	BlZJjsaicm78KK6kUa43MyNC3apbBHA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-KD3cUvK5PUCrAODa9FBP4Q-1; Fri,
 07 Mar 2025 16:20:59 -0500
X-MC-Unique: KD3cUvK5PUCrAODa9FBP4Q-1
X-Mimecast-MFC-AGG-ID: KD3cUvK5PUCrAODa9FBP4Q_1741382457
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 50FCC1800257;
	Fri,  7 Mar 2025 21:20:57 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CABD11956095;
	Fri,  7 Mar 2025 21:20:55 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	adrian.hunter@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v3 01/10] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest
Date: Fri,  7 Mar 2025 16:20:43 -0500
Message-ID: <20250307212053.2948340-2-pbonzini@redhat.com>
In-Reply-To: <20250307212053.2948340-1-pbonzini@redhat.com>
References: <20250307212053.2948340-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

From: Kai Huang <kai.huang@intel.com>

Intel TDX protects guest VM's from malicious host and certain physical
attacks.  TDX introduces a new operation mode, Secure Arbitration Mode
(SEAM) to isolate and protect guest VM's.  A TDX guest VM runs in SEAM and,
unlike VMX, direct control and interaction with the guest by the host VMM
is not possible.  Instead, Intel TDX Module, which also runs in SEAM,
provides a SEAMCALL API.

The SEAMCALL that provides the ability to enter a guest is TDH.VP.ENTER.
The TDX Module processes TDH.VP.ENTER, and enters the guest via VMX
VMLAUNCH/VMRESUME instructions.  When a guest VM-exit requires host VMM
interaction, the TDH.VP.ENTER SEAMCALL returns to the host VMM (KVM).

Add tdh_vp_enter() to wrap the SEAMCALL invocation of TDH.VP.ENTER;
tdh_vp_enter() needs to be noinstr because VM entry in KVM is noinstr
as well, which is for two reasons:
* marking the area as CT_STATE_GUEST via guest_state_enter_irqoff() and
  guest_state_exit_irqoff()
* IRET must be avoided between VM-exit and NMI handling, in order to
  avoid prematurely releasing the NMI inhibit.

TDH.VP.ENTER is different from other SEAMCALLs in several ways: it
uses more arguments, and after it returns some host state may need to be
restored.  Therefore tdh_vp_enter() uses __seamcall_saved_ret() instead of
__seamcall_ret(); since it is the only caller of __seamcall_saved_ret(),
it can be made noinstr also.

TDH.VP.ENTER arguments are passed through General Purpose Registers (GPRs).
For the special case of the TD guest invoking TDG.VP.VMCALL, nearly any GPR
can be used, as well as XMM0 to XMM15. Notably, RBP is not used, and Linux
mandates the TDX Module feature NO_RBP_MOD, which is enforced elsewhere.
Additionally, XMM registers are not required for the existing Guest
Hypervisor Communication Interface and are handled by existing KVM code
should they be modified by the guest.

There are 2 input formats and 5 output formats for TDH.VP.ENTER arguments.
Input #1 : Initial entry or following a previous async. TD Exit
Input #2 : Following a previous TDCALL(TDG.VP.VMCALL)
Output #1 : On Error (No TD Entry)
Output #2 : Async. Exits with a VMX Architectural Exit Reason
Output #3 : Async. Exits with a non-VMX TD Exit Status
Output #4 : Async. Exits with Cross-TD Exit Details
Output #5 : On TDCALL(TDG.VP.VMCALL)

Currently, to keep things simple, the wrapper function does not attempt
to support different formats, and just passes all the GPRs that could be
used.  The GPR values are held by KVM in the area set aside for guest
GPRs.  KVM code uses the guest GPR area (vcpu->arch.regs[]) to set up for
or process results of tdh_vp_enter().

Therefore changing tdh_vp_enter() to use more complex argument formats
would also alter the way KVM code interacts with tdh_vp_enter().

Signed-off-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Message-ID: <20241121201448.36170-2-adrian.hunter@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h       | 1 +
 arch/x86/virt/vmx/tdx/seamcall.S | 3 +++
 arch/x86/virt/vmx/tdx/tdx.c      | 8 ++++++++
 arch/x86/virt/vmx/tdx/tdx.h      | 1 +
 4 files changed, 13 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index e38e7558c02f..bb4a3bc26219 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -165,6 +165,7 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
         return level - 1;
 }
 
+u64 tdh_vp_enter(struct tdx_vp *vp, struct tdx_module_args *args);
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
 u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
diff --git a/arch/x86/virt/vmx/tdx/seamcall.S b/arch/x86/virt/vmx/tdx/seamcall.S
index 5b1f2286aea9..6854c52c374b 100644
--- a/arch/x86/virt/vmx/tdx/seamcall.S
+++ b/arch/x86/virt/vmx/tdx/seamcall.S
@@ -41,6 +41,9 @@ SYM_FUNC_START(__seamcall_ret)
 	TDX_MODULE_CALL host=1 ret=1
 SYM_FUNC_END(__seamcall_ret)
 
+/* KVM requires non-instrumentable __seamcall_saved_ret() for TDH.VP.ENTER */
+.section .noinstr.text, "ax"
+
 /*
  * __seamcall_saved_ret() - Host-side interface functions to SEAM software
  * (the P-SEAMLDR or the TDX module), with saving output registers to the
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 8eaaf31a4187..f5e2a937c1e7 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1517,6 +1517,14 @@ static void tdx_clflush_page(struct page *page)
 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
 }
 
+noinstr u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
+{
+	args->rcx = tdx_tdvpr_pa(td);
+
+	return __seamcall_saved_ret(TDH_VP_ENTER, args);
+}
+EXPORT_SYMBOL_GPL(tdh_vp_enter);
+
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index ed7152f81a6d..82bb82be8567 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -14,6 +14,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_VP_ENTER			0
 #define TDH_MNG_ADDCX			1
 #define TDH_MEM_PAGE_ADD		2
 #define TDH_MEM_SEPT_ADD		3
-- 
2.43.5



