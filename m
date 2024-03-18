Return-Path: <kvm+bounces-12051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B2DA87F410
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:35:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B65ACB22636
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 186746026E;
	Mon, 18 Mar 2024 23:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SOvoByI6"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06565FB87
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804842; cv=none; b=dZ23iH9GvJ3ew+/FUYgzHIlobuEW7oSqZPuNXBNQhOHMpBSBFhlQ7oQ4JUH+zND25AOiYoDpeqvO9aGHBuH9AFNvc+xrwoIynA5wZEklXqwwZ7mzDfM3TnZ9v0Uaa/Dq9xEBrBIkWw0bp3WualES38Mamf7TXVZ1cl5H5VRbfWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804842; c=relaxed/simple;
	bh=jLcoi7zE5QSS80ZwyAXc4jlri3jsbZrb1e1ZtpRxnYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ze4sqedFQqTwL1pXBYiQdFaFwT9aCLsbot8EW7U8hdUnQ6yUBLurR459gVWRqoyiYLUGg2fNo1A3FuKJBvmLzQuUEp7uBgZEFY9DZnwCnrZ09JHnSyKfHf4vjKEOBI4eS/MEhwJoTSNhV3S+8BoGdJrT6HaDcD+/7sqa2aZEflM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SOvoByI6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dQHdTKTQOIIeaqiYACYjYRMH7JuUmjEveuzX2gmYeaw=;
	b=SOvoByI6EVcuSx0vIYHy/FHRfKV8ktEK4/p9gvl0aQjTt16OFPJKDSx2oSQlmMjnaqCgWz
	WXsdRcAvdcnt0JlSvImdTUXHJnGXDFovvGfiC0CHwhUuqgL6jYIl2dh97Q7+hhixZMextL
	kDJHzBrZnLCbdGb6HOlAa5eBeSXh/a8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-RnZAdXmZOOemgd9_5Zamsw-1; Mon, 18 Mar 2024 19:33:56 -0400
X-MC-Unique: RnZAdXmZOOemgd9_5Zamsw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9F879848B51;
	Mon, 18 Mar 2024 23:33:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 73F631121312;
	Mon, 18 Mar 2024 23:33:55 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v4 09/15] KVM: SEV: sync FPU and AVX state at LAUNCH_UPDATE_VMSA time
Date: Mon, 18 Mar 2024 19:33:46 -0400
Message-ID: <20240318233352.2728327-10-pbonzini@redhat.com>
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

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

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/fpu/api.h |  3 +++
 arch/x86/kernel/fpu/xstate.h   |  2 --
 arch/x86/kvm/svm/sev.c         | 36 ++++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c         |  8 --------
 4 files changed, 39 insertions(+), 10 deletions(-)

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
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 3518fb26d06b..4ff910545451 100644
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
index a8300646a280..800e836a69fb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -23,6 +23,7 @@
 #include <asm/pkru.h>
 #include <asm/trapnr.h>
 #include <asm/fpu/xcr.h>
+#include <asm/fpu/xstate.h>
 #include <asm/debugreg.h>
 
 #include "mmu.h"
@@ -577,6 +578,10 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
 	struct sev_es_save_area *save = svm->sev_es.vmsa;
+	struct xregs_state *xsave;
+	const u8 *s;
+	u8 *d;
+	int i;
 
 	/* Check some debug related fields before encrypting the VMSA */
 	if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_1))
@@ -619,6 +624,30 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
 
 	save->sev_features = sev->vmsa_features;
 
+	xsave = &vcpu->arch.guest_fpu.fpstate->regs.xsave;
+	save->x87_dp = xsave->i387.rdp;
+	save->mxcsr = xsave->i387.mxcsr;
+	save->x87_ftw = xsave->i387.twd;
+	save->x87_fsw = xsave->i387.swd;
+	save->x87_fcw = xsave->i387.cwd;
+	save->x87_fop = xsave->i387.fop;
+	save->x87_ds = 0;
+	save->x87_cs = 0;
+	save->x87_rip = xsave->i387.rip;
+
+	for (i = 0; i < 8; i++) {
+		d = save->fpreg_x87 + i * 10;
+		s = ((u8 *)xsave->i387.st_space) + i * 16;
+		memcpy(d, s, 10);
+	}
+	memcpy(save->fpreg_xmm, xsave->i387.xmm_space, 256);
+
+	s = get_xsave_addr(xsave, XFEATURE_YMM);
+	if (s)
+		memcpy(save->fpreg_ymm, s, 256);
+	else
+		memset(save->fpreg_ymm, 0, 256);
+
 	pr_debug("Virtual Machine Save Area (VMSA):\n");
 	print_hex_dump_debug("", DUMP_PREFIX_NONE, 16, 1, save, sizeof(*save), false);
 
@@ -657,6 +686,13 @@ static int __sev_launch_update_vmsa(struct kvm *kvm, struct kvm_vcpu *vcpu,
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
index c22e87ebf0de..03108055a7b0 100644
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



