Return-Path: <kvm+bounces-40437-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F11E8A57378
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:21:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29AE617847C
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B2E258CF3;
	Fri,  7 Mar 2025 21:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NXLinDQH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282982580DE
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 21:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741382467; cv=none; b=jGBOpVeczZAbtj8Oy6+2YMZbqeAXNJ8hmaD5hrVP3lGCXfPNoJK/YJ4jbwJtPIEs4IB8vzPEafxOsaflmd4zOuqXt9Wvdwm/la9/+vh61uRJMO7wHKfbE12OuasxwXXdbSU+CPyeaSfxxaJfnuWdU8u5sA8oCYDZHtMzywEvFgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741382467; c=relaxed/simple;
	bh=ZuHZ/gG5p7GPOHAajcG1JFGORGioDR7TtTf+w0KtSTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=idRQ3OZOjuC3DDL+5QiDPEnmfJBZsR9TZ1n9ydm01Lzyc7szeUxv8bUey4B10RnE/0NpOqVxclineec2xk/08/8Ey6Ft0Q1QTXl9frvqNt9VBAXRtbUEF9eywzW3vMQ1D9CYuYv293zbsGBasdZGmv6hWliI3uSmhP/WjU+XG1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NXLinDQH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741382465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sENX17c+4j9BaquXczSrQNIxX4Hf7LYfOKMOzcse7Sg=;
	b=NXLinDQHEmU9xKAEQn4arnxEfnX9Zz7m/eytRtE62wZw5TBRGvskJhveeGpGPJ9l1xIDJZ
	P+aIxUNgplnkS2vFFLlkSMnz5C9cimXtDlhmjKSOdOO0bzlnVH72zL8/0xrI1EHT+EIWWW
	KhQJx6wvbB8k5Pgf6dCmvc3IRJ/CHvc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-EAvWfwGHNMG5gXTUks_IXQ-1; Fri,
 07 Mar 2025 16:21:01 -0500
X-MC-Unique: EAvWfwGHNMG5gXTUks_IXQ-1
X-Mimecast-MFC-AGG-ID: EAvWfwGHNMG5gXTUks_IXQ_1741382460
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F8A7180AF4D;
	Fri,  7 Mar 2025 21:21:00 +0000 (UTC)
Received: from virtlab1023.lab.eng.rdu2.redhat.com (virtlab1023.lab.eng.rdu2.redhat.com [10.8.1.187])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 392BE1956095;
	Fri,  7 Mar 2025 21:20:59 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: xiaoyao.li@intel.com,
	adrian.hunter@intel.com,
	seanjc@google.com,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 03/10] KVM: TDX: Implement TDX vcpu enter/exit path
Date: Fri,  7 Mar 2025 16:20:45 -0500
Message-ID: <20250307212053.2948340-4-pbonzini@redhat.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement callbacks to enter/exit a TDX VCPU by calling tdh_vp_enter().
Ensure the TDX VCPU is in a correct state to run.

Do not pass arguments from/to vcpu->arch.regs[] unconditionally. Instead,
marshall state to/from the appropriate x86 registers only when needed,
i.e., to handle some TDVMCALL sub-leaves following KVM's ABI to leverage
the existing code.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Message-ID: <20250129095902.16391-6-adrian.hunter@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c    | 20 ++++++++++--
 arch/x86/kvm/vmx/tdx.c     | 62 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h     |  3 ++
 arch/x86/kvm/vmx/x86_ops.h |  7 +++++
 4 files changed, 90 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 36b6343a011e..037590fc05e9 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -145,6 +145,22 @@ static void vt_update_cpu_dirty_logging(struct kvm_vcpu *vcpu)
 	vmx_update_cpu_dirty_logging(vcpu);
 }
 
+static int vt_vcpu_pre_run(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_pre_run(vcpu);
+
+	return vmx_vcpu_pre_run(vcpu);
+}
+
+static fastpath_t vt_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_run(vcpu, force_immediate_exit);
+
+	return vmx_vcpu_run(vcpu, force_immediate_exit);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu)) {
@@ -285,8 +301,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.flush_tlb_gva = vt_flush_tlb_gva,
 	.flush_tlb_guest = vt_flush_tlb_guest,
 
-	.vcpu_pre_run = vmx_vcpu_pre_run,
-	.vcpu_run = vmx_vcpu_run,
+	.vcpu_pre_run = vt_vcpu_pre_run,
+	.vcpu_run = vt_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 47857603e2a4..f50565f45b6a 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -12,6 +12,8 @@
 #include "vmx.h"
 #include "mmu/spte.h"
 #include "common.h"
+#include <trace/events/kvm.h>
+#include "trace.h"
 
 #pragma GCC poison to_vmx
 
@@ -655,6 +657,66 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
 }
 
+int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu)
+{
+	if (unlikely(to_tdx(vcpu)->state != VCPU_TD_STATE_INITIALIZED ||
+		     to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE))
+		return -EINVAL;
+
+	return 1;
+}
+
+static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	guest_state_enter_irqoff();
+
+	tdx->vp_enter_ret = tdh_vp_enter(&tdx->vp, &tdx->vp_enter_args);
+
+	guest_state_exit_irqoff();
+}
+
+#define TDX_REGS_AVAIL_SET	(BIT_ULL(VCPU_EXREG_EXIT_INFO_1) | \
+				 BIT_ULL(VCPU_EXREG_EXIT_INFO_2) | \
+				 BIT_ULL(VCPU_REGS_RAX) | \
+				 BIT_ULL(VCPU_REGS_RBX) | \
+				 BIT_ULL(VCPU_REGS_RCX) | \
+				 BIT_ULL(VCPU_REGS_RDX) | \
+				 BIT_ULL(VCPU_REGS_RBP) | \
+				 BIT_ULL(VCPU_REGS_RSI) | \
+				 BIT_ULL(VCPU_REGS_RDI) | \
+				 BIT_ULL(VCPU_REGS_R8) | \
+				 BIT_ULL(VCPU_REGS_R9) | \
+				 BIT_ULL(VCPU_REGS_R10) | \
+				 BIT_ULL(VCPU_REGS_R11) | \
+				 BIT_ULL(VCPU_REGS_R12) | \
+				 BIT_ULL(VCPU_REGS_R13) | \
+				 BIT_ULL(VCPU_REGS_R14) | \
+				 BIT_ULL(VCPU_REGS_R15))
+
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+{
+	/*
+	 * force_immediate_exit requires vCPU entering for events injection with
+	 * an immediately exit followed. But The TDX module doesn't guarantee
+	 * entry, it's already possible for KVM to _think_ it completely entry
+	 * to the guest without actually having done so.
+	 * Since KVM never needs to force an immediate exit for TDX, and can't
+	 * do direct injection, just warn on force_immediate_exit.
+	 */
+	WARN_ON_ONCE(force_immediate_exit);
+
+	trace_kvm_entry(vcpu, force_immediate_exit);
+
+	tdx_vcpu_enter_exit(vcpu);
+
+	vcpu->arch.regs_avail &= TDX_REGS_AVAIL_SET;
+
+	trace_kvm_exit(vcpu, KVM_ISA_VMX);
+
+	return EXIT_FASTPATH_NONE;
+}
 
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 11b3cc96c529..6eb24bbacccc 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -47,11 +47,14 @@ enum vcpu_tdx_state {
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 	struct vcpu_vt vt;
+	struct tdx_module_args vp_enter_args;
 
 	struct tdx_vp vp;
 
 	struct list_head cpu_list;
 
+	u64 vp_enter_ret;
+
 	enum vcpu_tdx_state state;
 };
 
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index f47d739051cf..578c26d3aec4 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -131,6 +131,8 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
 int tdx_vcpu_create(struct kvm_vcpu *vcpu);
 void tdx_vcpu_free(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
+int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu);
+fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -157,6 +159,11 @@ static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOP
 static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
 static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
+static inline int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
+static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
+{
+	return EXIT_FASTPATH_NONE;
+}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.43.5



