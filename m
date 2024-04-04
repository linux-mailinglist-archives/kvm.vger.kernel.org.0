Return-Path: <kvm+bounces-13557-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E03D78986F8
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 14:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BB561C25FF6
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 12:16:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B5D127B46;
	Thu,  4 Apr 2024 12:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XF5roaDN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189F4128368
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 12:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712232819; cv=none; b=CsjzXEaKJaikfbHGeFmrHrBgf4IzlN6nZDNfhUpGTpP7FCxhapzqGpLGCavPQHKcRAnpt7NA3L54Lbz9bqEzjJnjaqZLhdlExeqVkP23li4Zefg5DnoKAg1QAc58kQpOph+hWxrK1V5gxITjbyLWZnE2IQDRobOsp9TVDXb9NDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712232819; c=relaxed/simple;
	bh=7xAf+ygwMV3r99R1mwFDCkzbpfqRpwxJdkJFHKExASg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F38aXPRCwbYesOCRGbXHHfRwfDubeekQoZZC7Q+Qxx36V0+bS1sRGRnwgiw82z3RIh+rPVU16p3FCvmT/RhN1ios6hGLNYzQkpHCPIPLHG7+mOdHSUhS2QLFPTWbE8yCwJanwtoXI/Tp5hfnnUU9dM2BSn4vveemubAfRwlAuz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XF5roaDN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712232815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9DnHHv4eKklKivDhbwxt4ouBKVvs3UxwHQpa3/439ek=;
	b=XF5roaDNqdOZkpIBNr0wegvEQKly37Bfu1oE/GZN5n5lI9lJdobg8M8d42jk6nmKfhOjQY
	jW9Ufx6ww0aVfnhnjeVmSk9pzq2tTLY4jK6ThAwSVfHAwTErOfSarjBugNLFIGQ8QYGRjm
	Eo/bBI98/P0EJzZCIDqow/qDsqRRJ1w=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-90-HaVxVlL9NNCcu0Ts8bQajw-1; Thu,
 04 Apr 2024 08:13:31 -0400
X-MC-Unique: HaVxVlL9NNCcu0Ts8bQajw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D96E3806723;
	Thu,  4 Apr 2024 12:13:30 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 677A0492BC6;
	Thu,  4 Apr 2024 12:13:30 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v5 11/17] KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA time
Date: Thu,  4 Apr 2024 08:13:21 -0400
Message-ID: <20240404121327.3107131-12-pbonzini@redhat.com>
In-Reply-To: <20240404121327.3107131-1-pbonzini@redhat.com>
References: <20240404121327.3107131-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

SEV-ES allows passing custom contents for x87, SSE and AVX state into the VMSA.
Allow userspace to do that with the usual KVM_SET_XSAVE API and only mark
FPU contents as confidential after it has been copied and encrypted into
the VMSA.

Since the XSAVE state for AVX is the first, it does not need the
compacted-state handling of get_xsave_addr().  However, there are other
parts of XSAVE state in the VMSA that currently are not handled, and
the validation logic of get_xsave_addr() is pointless to duplicate
in KVM, so move get_xsave_addr() to public FPU API; it is really just
a facility to operate on XSAVE state and does not expose any internal
details of arch/x86/kernel/fpu.

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/fpu/api.h |  3 ++
 arch/x86/kernel/fpu/xstate.c   |  1 +
 arch/x86/kernel/fpu/xstate.h   |  2 --
 arch/x86/kvm/svm/sev.c         | 50 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c         |  8 ------
 5 files changed, 54 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/fpu/api.h b/arch/x86/include/asm/fpu/api.h
index a2be3aefff9f..f86ad3335529 100644
--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -143,6 +143,9 @@ extern void fpstate_clear_xstate_component(struct fpstate *fps, unsigned int xfe
 
 extern u64 xstate_get_guest_group_perm(void);
 
+extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
+
+
 /* KVM specific functions */
 extern bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu);
 extern void fpu_free_guest_fpstate(struct fpu_guest *gfpu);
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 33a214b1a4ce..6d32e415b01e 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -991,6 +991,7 @@ void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr)
 
 	return __raw_xsave_addr(xsave, xfeature_nr);
 }
+EXPORT_SYMBOL_GPL(get_xsave_addr);
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
 
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 19ca623ffa2a..05df04f39628 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -54,8 +54,6 @@ extern int copy_sigframe_from_user_to_xstate(struct task_struct *tsk, const void
 extern void fpu__init_cpu_xstate(void);
 extern void fpu__init_system_xstate(unsigned int legacy_size);
 
-extern void *get_xsave_addr(struct xregs_state *xsave, int xfeature_nr);
-
 static inline u64 xfeatures_mask_supervisor(void)
 {
 	return fpu_kernel_cfg.max_features & XFEATURE_MASK_SUPERVISOR_SUPPORTED;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1512bacd74a9..3517d6736c93 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -23,6 +23,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/fpu/xstate.h>
 #include <asm/debugreg.h>
 
 #include "mmu.h"
@@ -584,6 +585,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
+	struct xregs_state *xsave;
+	const u8 *s;
+	u8 *d;
+	int i;
 
 	/* Check some debug related fields before encrypting the VMSA */
 	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
@@ -626,6 +631,44 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 
 	save->sev_features = sev->vmsa_features;
 
+	/*
+	 * Skip FPU and AVX setup with KVM_SEV_ES_INIT to avoid
+	 * breaking older measurements.
+	 */
+	if (vcpu->kvm->arch.vm_type != KVM_X86_DEFAULT_VM) {
+		xsave = &vcpu->arch.guest_fpu.fpstate->regs.xsave;
+		save->x87_dp = xsave->i387.rdp;
+		save->mxcsr = xsave->i387.mxcsr;
+		save->x87_ftw = xsave->i387.twd;
+		save->x87_fsw = xsave->i387.swd;
+		save->x87_fcw = xsave->i387.cwd;
+		save->x87_fop = xsave->i387.fop;
+		save->x87_ds = 0;
+		save->x87_cs = 0;
+		save->x87_rip = xsave->i387.rip;
+
+		for (i = 0; i < 8; i++) {
+			/*
+			 * The format of the x87 save area is undocumented and
+			 * definitely not what you would expect.  It consists of
+			 * an 8*8 bytes area with bytes 0-7, and an 8*2 bytes
+			 * area with bytes 8-9 of each register.
+			 */
+			d = save->fpreg_x87 + i * 8;
+			s = ((u8 *)xsave->i387.st_space) + i * 16;
+			memcpy(d, s, 8);
+			save->fpreg_x87[64 + i * 2] = s[8];
+			save->fpreg_x87[64 + i * 2 + 1] = s[9];
+		}
+		memcpy(save->fpreg_xmm, xsave->i387.xmm_space, 256);
+
+		s = get_xsave_addr(xsave, XFEATURE_YMM);
+		if (s)
+			memcpy(save->fpreg_ymm, s, 256);
+		else
+			memset(save->fpreg_ymm, 0, 256);
+	}
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
@@ -664,6 +707,13 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
 	if (ret)
 	  return ret;
 
+	/*
+	 * SEV-ES guests maintain an encrypted version of their FPU
+	 * state which is restored and saved on VMRUN and VMEXIT.
+	 * Mark vcpu->arch.guest_fpu->fpstate as scratch so it won't
+	 * do xsave/xrstor on it.
+	 */
+	fpstate_set_confidential(&vcpu->arch.guest_fpu);
 	vcpu->arch.guest_state_protected = true;
 	return 0;
 }
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b0038ece55cb..0f3b59da0d4a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1433,14 +1433,6 @@ static int svm_vcpu_create(struct kvm_vcpu *vcpu)
 		vmsa_page = snp_safe_alloc_page(vcpu);
 		if (!vmsa_page)
 			goto error_free_vmcb_page;
-
-		/*
-		 * SEV-ES guests maintain an encrypted version of their FPU
-		 * state which is restored and saved on VMRUN and VMEXIT.
-		 * Mark vcpu->arch.guest_fpu->fpstate as scratch so it won't
-		 * do xsave/xrstor on it.
-		 */
-		fpstate_set_confidential(&vcpu->arch.guest_fpu);
 	}
 
 	err = avic_init_vcpu(svm);
-- 
2.43.0



