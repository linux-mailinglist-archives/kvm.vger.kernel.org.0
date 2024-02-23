Return-Path: <kvm+bounces-9511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0522D860FA0
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 11:41:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6B09286F34
	for <lists+kvm@lfdr.de>; Fri, 23 Feb 2024 10:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 734477AE7A;
	Fri, 23 Feb 2024 10:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dOJv1Pug"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED1C5C902
	for <kvm@vger.kernel.org>; Fri, 23 Feb 2024 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708684817; cv=none; b=KQLFnyIoRN+xaml+i/whPn7kJVbjsd3eweE/PtPffr3V2kO9UzSrahackh4GJrQS9Ls3k3Oc7h2lH5b8sR+Q+0WbLt0mqzH0LAAQgiFzcU/7qwhJRD2qzCLenl6GTCe3kLiI18VHBHLjc4IbcFP4FB7o4MZ4ihRHhooILHhwRTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708684817; c=relaxed/simple;
	bh=nm6HmMAMwcxtL6M/ucjCqqkXa6rYzYNN1kjIvE8f8Nc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lZIJS7m1J37L9nmyAiqWUpvSsznkDjocXc2PZxGY65YTFXD0O+VBJLhxFcTCIjjctZ+FCXkuWDzVq8hWeSLoX2igmhAFSSKyzxKbzlRG1zeMPO0xMxVgvK6Ei3PY2tQF7iop1ciEK1Z7Vp+3f7E+EOpigyjfmiZ/skiMiK33Kaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dOJv1Pug; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708684814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XBUurJHQMU7qtqFTOu3PnVuwnrzZsBu/4n1xTWVo+Pw=;
	b=dOJv1PugcdhrIQrYMsfQPCgIgbZ1pXMkK+9k2lqtz9ovAmRnkjPvKqizbTe1+jDKVJpMw5
	SplKf/ryGf9ptORhOQKgnPJUU00igJyf/+NpF2tqXd8aBTThVXUpMEmscn7PTtKSjpxGHq
	NQ+R/zFGP8rOQc5OYktjt+CjROgpkUY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-AyKdURBfOxCjSi5iXyl_iw-1; Fri, 23 Feb 2024 05:40:12 -0500
X-MC-Unique: AyKdURBfOxCjSi5iXyl_iw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3E8888CF74;
	Fri, 23 Feb 2024 10:40:11 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9908D112132A;
	Fri, 23 Feb 2024 10:40:11 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: seanjc@google.com,
	michael.roth@amd.com,
	aik@amd.com
Subject: [PATCH v2 07/11] KVM: x86: define standard behavior for bits 0/1 of VM type
Date: Fri, 23 Feb 2024 05:40:05 -0500
Message-Id: <20240223104009.632194-8-pbonzini@redhat.com>
In-Reply-To: <20240223104009.632194-1-pbonzini@redhat.com>
References: <20240223104009.632194-1-pbonzini@redhat.com>
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
_all_ VM types have private memory.

So, let the low bits specify the characteristics of the VM type.  As
of we have two special things: whether memory is private, and whether
guest state is protected.  The latter is similar to
kvm->arch.guest_state_protected, but the latter is only set on a fully
initialized VM.  If both are set, ioctls to set registers will cause
an error---SEV-ES did not do so, which is a problematic API.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <20240209183743.22030-7-pbonzini@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  9 +++-
 arch/x86/kvm/x86.c              | 93 +++++++++++++++++++++++++++------
 2 files changed, 85 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 0bcd9ae16097..15db2697863c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2135,8 +2135,15 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
 
+
+/* Low bits of VM types provide confidential computing capabilities.  */
+#define __KVM_X86_PRIVATE_MEM_TYPE	1
+#define __KVM_X86_PROTECTED_STATE_TYPE	2
+#define __KVM_X86_VM_TYPE_FEATURES	3
+static_assert((KVM_X86_SW_PROTECTED_VM & __KVM_X86_VM_TYPE_FEATURES) == __KVM_X86_PRIVATE_MEM_TYPE);
+
 #ifdef CONFIG_KVM_PRIVATE_MEM
-#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.vm_type != KVM_X86_DEFAULT_VM)
+#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.vm_type & __KVM_X86_PRIVATE_MEM_TYPE)
 #else
 #define kvm_arch_has_private_mem(kvm) false
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8746530930d5..e634e5b67516 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5526,21 +5526,30 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
-static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
-					     struct kvm_debugregs *dbgregs)
+static int kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
+					    struct kvm_debugregs *dbgregs)
 {
 	unsigned long val;
 
+	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	memset(dbgregs, 0, sizeof(*dbgregs));
 	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
 	kvm_get_dr(vcpu, 6, &val);
 	dbgregs->dr6 = val;
 	dbgregs->dr7 = vcpu->arch.dr7;
+	return 0;
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 					    struct kvm_debugregs *dbgregs)
 {
+	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (dbgregs->flags)
 		return -EINVAL;
 
@@ -5559,9 +5568,13 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 }
 
 
-static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
-					  u8 *state, unsigned int size)
+static int kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
+					 u8 *state, unsigned int size)
 {
+	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
+	    fpstate_is_confidential(&vcpu->arch.guest_fpu))
+		return -EINVAL;
+
 	/*
 	 * Only copy state for features that are enabled for the guest.  The
 	 * state itself isn't problematic, but setting bits in the header for
@@ -5578,22 +5591,27 @@ static void kvm_vcpu_ioctl_x86_get_xsave2(struct kvm_vcpu *vcpu,
 			     XFEATURE_MASK_FPSSE;
 
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
-		return;
+		return 0;
 
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
+	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
+	    fpstate_is_confidential(&vcpu->arch.guest_fpu))
+		return -EINVAL;
+
 	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
 		return 0;
 
@@ -5603,18 +5621,23 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 					      &vcpu->arch.pkru);
 }
 
-static void kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
-					struct kvm_xcrs *guest_xcrs)
+static int kvm_vcpu_ioctl_x86_get_xcrs(struct kvm_vcpu *vcpu,
+				       struct kvm_xcrs *guest_xcrs)
 {
+	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
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
@@ -5622,6 +5645,10 @@ static int kvm_vcpu_ioctl_x86_set_xcrs(struct kvm_vcpu *vcpu,
 {
 	int i, r = 0;
 
+	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	if (!boot_cpu_has(X86_FEATURE_XSAVE))
 		return -EINVAL;
 
@@ -6010,7 +6037,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	case KVM_GET_DEBUGREGS: {
 		struct kvm_debugregs dbgregs;
 
-		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
+		r = kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
+		if (r < 0)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, &dbgregs,
@@ -6040,7 +6069,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xsave)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
+		r = kvm_vcpu_ioctl_x86_get_xsave(vcpu, u.xsave);
+		if (r < 0)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xsave, sizeof(struct kvm_xsave)))
@@ -6069,7 +6100,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xsave)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xsave2(vcpu, u.buffer, size);
+		r = kvm_vcpu_ioctl_x86_get_xsave2(vcpu, u.buffer, size);
+		if (r < 0)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xsave, size))
@@ -6085,7 +6118,9 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		if (!u.xcrs)
 			break;
 
-		kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
+		r = kvm_vcpu_ioctl_x86_get_xcrs(vcpu, u.xcrs);
+		if (r < 0)
+			break;
 
 		r = -EFAULT;
 		if (copy_to_user(argp, u.xcrs,
@@ -6229,6 +6264,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	}
 #endif
 	case KVM_GET_SREGS2: {
+		r = -EINVAL;
+		if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
+		    vcpu->arch.guest_state_protected)
+			goto out;
+
 		u.sregs2 = kzalloc(sizeof(struct kvm_sregs2), GFP_KERNEL);
 		r = -ENOMEM;
 		if (!u.sregs2)
@@ -6241,6 +6281,11 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		break;
 	}
 	case KVM_SET_SREGS2: {
+		r = -EINVAL;
+		if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
+		    vcpu->arch.guest_state_protected)
+			goto out;
+
 		u.sregs2 = memdup_user(argp, sizeof(struct kvm_sregs2));
 		if (IS_ERR(u.sregs2)) {
 			r = PTR_ERR(u.sregs2);
@@ -11466,6 +11511,10 @@ static void __get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__get_regs(vcpu, regs);
 	vcpu_put(vcpu);
@@ -11507,6 +11556,10 @@ static void __set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 
 int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 {
+	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__set_regs(vcpu, regs);
 	vcpu_put(vcpu);
@@ -11579,6 +11632,10 @@ static void __get_sregs2(struct kvm_vcpu *vcpu, struct kvm_sregs2 *sregs2)
 int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
 				  struct kvm_sregs *sregs)
 {
+	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	__get_sregs(vcpu, sregs);
 	vcpu_put(vcpu);
@@ -11846,6 +11903,10 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 {
 	int ret;
 
+	if ((vcpu->kvm->arch.vm_type & __KVM_X86_PROTECTED_STATE_TYPE) &&
+	    vcpu->arch.guest_state_protected)
+		return -EINVAL;
+
 	vcpu_load(vcpu);
 	ret = __set_sregs(vcpu, sregs);
 	vcpu_put(vcpu);
-- 
2.39.1



