Return-Path: <kvm+bounces-12050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0629E87F40F
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 00:35:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85E561F22C2A
	for <lists+kvm@lfdr.de>; Mon, 18 Mar 2024 23:35:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 008C660263;
	Mon, 18 Mar 2024 23:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CkjIE120"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8897F5FB81
	for <kvm@vger.kernel.org>; Mon, 18 Mar 2024 23:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710804842; cv=none; b=TY1G/3Ete2qtTtAen5Y8ek19xFLRC2dYg4uzNljNEQ6epw/W6P++NuqzyUXCELUq6VLpZZWeOF0MkeNy0xQGgdxj8vHlnvssi8ty9qw4vVSMqNvELJCPT1dK/Rr61MbWBg4ZXCV0LFOiNb/nyOp85FQhtM9wi9swBoM9vUh6byY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710804842; c=relaxed/simple;
	bh=f5SIU7jGBKYZeDEDxnyCVQCwnQsFeWP9DqA5VATU+B4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lX59748KiTDHBK/pq1NAQAoJvPYTmTKAIRFBtZqIUwZR9j129B2EPIUJGnjeLwbbo/U6MKbJTyozsY7V6mcLgrvCUtzYOkJ4+Imp7iqu6GyIw43SCjBBUTdp5+qjgAY90BeJttNA4mE17c6NBSYh9T0ASVTeouiAPpZqxesAMVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CkjIE120; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710804839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uAodwgByXH8Iv5Z5SBxHegbH6XkW9rC6Re6YGEbBOM4=;
	b=CkjIE120lTYHmPDnlArMuyrboPBSryTQsz99FLh9Lqj6EeLPgVhbXMO7IadYc6MiQkVMxS
	7ZZGZXDEtxh96PqIP8ZLSZG/epbGftehZM+cjgY+p4K++0MCkgPYTnPR6ehjtfe1dJNOcC
	nyvqAyUeWYg2ZatsZvZjbYOtyyxzJ3E=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495-9-beKKKMP6-I91wC1LEI9Q-1; Mon,
 18 Mar 2024 19:33:55 -0400
X-MC-Unique: 9-beKKKMP6-I91wC1LEI9Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D0D029AC02A;
	Mon, 18 Mar 2024 23:33:55 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 112AD1121312;
	Mon, 18 Mar 2024 23:33:55 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: michael.roth@amd.com,
	isaku.yamahata@intel.com,
	seanjc@google.com
Subject: [PATCH v4 07/15] KVM: x86: add fields to struct kvm_arch for CoCo features
Date: Mon, 18 Mar 2024 19:33:44 -0400
Message-ID: <20240318233352.2728327-8-pbonzini@redhat.com>
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

Some VM types have characteristics in common; in fact, the only use
of VM types right now is kvm_arch_has_private_mem and it assumes that
_all_ nonzero VM types have private memory.

We will soon introduce a VM type for SEV and SEV-ES VMs, and at that
point we will have two special characteristics of confidential VMs
that depend on the VM type: not just if memory is private, but
also whether guest state is protected.  For the latter we have
kvm->arch.guest_state_protected, which is only set on a fully initialized
VM.

For VM types with protected guest state, we can actually fix a problem in
the SEV-ES implementation, where ioctls to set registers do not cause an
error even if the VM has been initialized and the guest state encrypted.
Make sure that when using VM types that will become an error.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20240209183743.22030-7-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  7 ++-
 arch/x86/kvm/x86.c              | 93 ++++++++++++++++++++++++++-------
 2 files changed, 79 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f6cc7bfb5462..7380877bc9b5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1279,12 +1279,14 @@ enum kvm_apicv_inhibit {
 };
 
 struct kvm_arch {
-	unsigned long vm_type;
 	unsigned long n_used_mmu_pages;
 	unsigned long n_requested_mmu_pages;
 	unsigned long n_max_mmu_pages;
 	unsigned int indirect_shadow_pages;
 	u8 mmu_valid_gen;
+	u8 vm_type;
+	bool has_private_mem;
+	bool has_protected_state;
 	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
 	struct list_head active_mmu_pages;
 	struct list_head zapped_obsolete_pages;
@@ -2153,8 +2155,9 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
+
 #ifdef CONFIG_KVM_PRIVATE_MEM
-#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.vm_type != KVM_X86_DEFAULT_VM)
+#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
 #else
 #define kvm_arch_has_private_mem(kvm) false
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e8253aa8ef5e..98b7979b4698 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5560,11 +5560,15 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
-					     struct kvm_debugregs *dbgregs)
+static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
+					    struct kvm_debugregs *dbgregs)
 {
 	unsigned int i;
 
+	if (vcpu->kvm->arch.has_protected_state &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	memset(dbgregs, 0, sizeof(*dbgregs));
 
 	BUILD_BUG_ON(ARRAY_SIZE(vcpu->arch.db) != ARRAY_SIZE(dbgregs->db));
@@ -5573,6 +5577,7 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 
 	dbgregs->dr6 = vcpu->arch.dr6;
 	dbgregs->dr7 = vcpu->arch.dr7;
+	return 0;
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
@@ -5580,6 +5585,10 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 {
 	unsigned int i;
 
+	if (vcpu->kvm->arch.has_protected_state &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (dbgregs->flags)
 		return -EINVAL;
 
@@ -5600,8 +5609,8 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 }
 
 
-static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
-					  u8 *state, unsigned int size)
+static int kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
+					 u8 *state, unsigned int size)
 {
 	/*
 	 * Only copy state for features that are enabled for the guest.  The
@@ -5619,24 +5628,25 @@ static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
 			     XFEATURE_MASK_FPSSE;
 
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
-		return;
+		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
 
 	fpu_copy_guest_fpstate_to_uabi(&vcpu->arch.guest_fpu, state, size,
 				       supported_xcr0, vcpu->arch.pkru);
+	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
-					 struct kvm_xsave *guest_xsave)
+static int kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
+					struct kvm_xsave *guest_xsave)
 {
-	kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
-				      sizeof(guest_xsave->region));
+	return kvm_vcpu_ioctl_x86_get_xsave2(vcpu, (void *)guest_xsave->region,
+					     sizeof(guest_xsave->region));
 }
 
 static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					struct kvm_xsave *guest_xsave)
 {
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
-		return 0;
+		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
 
 	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu,
 					      guest_xsave->region,
@@ -5644,18 +5654,23 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					      &vcpu->arch.pkru);
 }
 
-static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
-					struct kvm_xcrs *guest_xcrs)
+static int kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
+				       struct kvm_xcrs *guest_xcrs)
 {
+	if (vcpu->kvm->arch.has_protected_state &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (!boot_cpu_has(X86_FEATURE_XSAVE)) {
 		guest_xcrs->nr_xcrs = 0;
-		return;
+		return 0;
 	}
 
 	guest_xcrs->nr_xcrs = 1;
 	guest_xcrs->flags = 0;
 	guest_xcrs->xcrs[0].xcr = XCR_XFEATURE_ENABLED_MASK;
 	guest_xcrs->xcrs[0].value = vcpu->arch.xcr0;
+	return 0;
 }
 
 static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
@@ -5663,6 +5678,10 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
 {
 	int i, r = 0;
 
+	if (vcpu->kvm->arch.has_protected_state &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (!boot_cpu_has(X86_FEATURE_XSAVE))
 		return -EINVAL;
 
@@ -6045,7 +6064,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_DEBUGREGS: {
 		struct kvm_debugregs dbgregs;
 
-		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
+		r = kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
+		if (r < 0)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, &dbgregs,
@@ -6075,7 +6096,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xsave)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
+		r = kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
+		if (r < 0)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xsave, sizeof(struct kvm_xsave)))
@@ -6104,7 +6127,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xsave)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xsave2(vcpu, u.buffer, size);
+		r = kvm_vcpu_ioctl_x86_get_xsave2(vcpu, u.buffer, size);
+		if (r < 0)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xsave, size))
@@ -6120,7 +6145,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xcrs)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
+		r = kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
+		if (r < 0)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xcrs,
@@ -6264,6 +6291,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	}
 #endif
 	case KVM_GET_SREGS2: {
+		r = -EINVAL;
+		if (vcpu->kvm->arch.has_protected_state &&
+		    vcpu->arch.guest_state_protected)
+			goto out;
+
 		u.sregs2 = kzalloc(sizeof(struct kvm_sregs2), GFP_KERNEL);
 		r = -ENOMEM;
 		if (!u.sregs2)
@@ -6276,6 +6308,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_SET_SREGS2: {
+		r = -EINVAL;
+		if (vcpu->kvm->arch.has_protected_state &&
+		    vcpu->arch.guest_state_protected)
+			goto out;
+
 		u.sregs2 = memdup_user(argp, sizeof(struct kvm_sregs2));
 		if (IS_ERR(u.sregs2)) {
 			r = PTR_ERR(u.sregs2);
@@ -11483,6 +11520,10 @@ static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	if (vcpu->kvm->arch.has_protected_state &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__get_regs(vcpu, regs);
 	vcpu_put(vcpu);
@@ -11524,6 +11565,10 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	if (vcpu->kvm->arch.has_protected_state &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__set_regs(vcpu, regs);
 	vcpu_put(vcpu);
@@ -11596,6 +11641,10 @@ static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
+	if (vcpu->kvm->arch.has_protected_state &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__get_sregs(vcpu, sregs);
 	vcpu_put(vcpu);
@@ -11863,6 +11912,10 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 {
 	int ret;
 
+	if (vcpu->kvm->arch.has_protected_state &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	ret = __set_sregs(vcpu, sregs);
 	vcpu_put(vcpu);
@@ -11980,7 +12033,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	struct fxregs_state *fxsave;
 
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
-		return 0;
+		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
 
 	vcpu_load(vcpu);
 
@@ -12003,7 +12056,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 	struct fxregs_state *fxsave;
 
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
-		return 0;
+		return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;
 
 	vcpu_load(vcpu);
 
@@ -12529,6 +12582,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return -EINVAL;
 
 	kvm->arch.vm_type = type;
+	kvm->arch.has_private_mem =
+		(type == KVM_X86_SW_PROTECTED_VM);
 
 	ret = kvm_page_track_init(kvm);
 	if (ret)
-- 
2.43.0



