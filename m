Return-Path: <kvm+bounces-35575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 10773A12855
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 17:13:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DB38161775
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 16:12:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1BE41D88AD;
	Wed, 15 Jan 2025 16:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AHn4Z6uR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082941D89E9
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 16:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736957383; cv=none; b=kCs9418OZeCxNQHF6AXj4IikI/WA5kYrwXYA3RBrpdIOKOSEYgDDxgEXY4NXIwBmxdBSEZxY7HF9EzMtno+rst/pAynjfdaWgdp2l0GQVg3nwjH5CUlVOmGYR+aFGDbOMGkRo7njkDWmAEJuL3gmNbMDAb7c80nbp4JzG81VIpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736957383; c=relaxed/simple;
	bh=5MXTcQ+7PQsOOGVqPdJMbA71qT+MfGOkCZ8huD7nrcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sOcg/BQvWU13YF32DONfAVB+DGv0KYcGolRQ5Skp4WBcCftn6MGT7JE/iNTcDHZkmi2JtI28YsIPKrpGKPMfyTTBvxtlSLco5SlOl2AZ4I6n19N4i98LI2JP+rven28VeBqEnxK8it4xWTDaXpWAYO3qbpuE3edQd4HWIGdxNi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AHn4Z6uR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736957380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=85tEz9BUIMwULFs12i4DbBRzZWw0rq0TiaJBrDLlk2g=;
	b=AHn4Z6uRIpqvaNJVhBT0ntNovCG9DJtxe0qW7GVwzBCn8WO1+dLJzKSQ5xd7WzbU6o+LHa
	gK11A5jIFJn4K0Lu4/QtiupI9rAfuBKbEvZ2XA0sbRvGw/IlMC1z36nDggi6MYWSSmkNQi
	RZ0LJiIhtptr/0W0Shc7iVujXIdrb+U=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-146-40RpI6tsMgSpmBQ0fh87ow-1; Wed,
 15 Jan 2025 11:09:36 -0500
X-MC-Unique: 40RpI6tsMgSpmBQ0fh87ow-1
X-Mimecast-MFC-AGG-ID: 40RpI6tsMgSpmBQ0fh87ow
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 87EB4195606A;
	Wed, 15 Jan 2025 16:09:34 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 744303003FD1;
	Wed, 15 Jan 2025 16:09:33 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	rick.p.edgecombe@intel.com,
	dave.hansen@linux.intel.com,
	yan.y.zhao@intel.com,
	Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v3 12/14] x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest
Date: Wed, 15 Jan 2025 11:09:10 -0500
Message-ID: <20250115160912.617654-13-pbonzini@redhat.com>
In-Reply-To: <20250115160912.617654-1-pbonzini@redhat.com>
References: <20250115160912.617654-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

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

Add tdh_vp_enter() to wrap the SEAMCALL invocation of TDH.VP.ENTER.

TDH.VP.ENTER is different from other SEAMCALLS in several ways:
 - it may take some time to return as the guest executes
 - it uses more arguments
 - after it returns some host state may need to be restored

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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/tdx.h  | 1 +
 arch/x86/virt/vmx/tdx/tdx.c | 8 ++++++++
 arch/x86/virt/vmx/tdx/tdx.h | 1 +
 3 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 0c89afffdac4..6531b69a53ac 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -154,6 +154,7 @@ static inline int pg_level_to_tdx_sept_level(enum pg_level level)
         return level - 1;
 }
 
+u64 tdh_vp_enter(struct tdx_vp *vp, struct tdx_module_args *args);
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
 u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 55851a0591d2..bb6f8ef9661e 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1479,6 +1479,14 @@ static void tdx_clflush_page(struct page *page)
 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
 }
 
+u64 tdh_vp_enter(struct tdx_vp *td, struct tdx_module_args *args)
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
index 64932450aba3..b71b375b10c0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -15,6 +15,7 @@
 /*
  * TDX module SEAMCALL leaf functions
  */
+#define TDH_VP_ENTER			0
 #define TDH_MNG_ADDCX			1
 #define TDH_MEM_PAGE_ADD		2
 #define TDH_MEM_SEPT_ADD		3
-- 
2.43.5



