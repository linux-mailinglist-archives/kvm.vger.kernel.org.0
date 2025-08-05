Return-Path: <kvm+bounces-54059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42126B1BB61
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 22:23:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F06E5628087
	for <lists+kvm@lfdr.de>; Tue,  5 Aug 2025 20:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610EC29B8E4;
	Tue,  5 Aug 2025 20:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hzesSLPF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D0329B233
	for <kvm@vger.kernel.org>; Tue,  5 Aug 2025 20:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754425360; cv=none; b=UgOsOKjieMl40N1n8b/3jDgwGHA3uCwOGKkdZPXumQmJ94KZSDPHPOWhNTtdEu+Fp6dmkTXSLrq+jHeFsyNeRxH5qBQRPzeDj6lZZqzLPR17KzXMldpY4bdlMwtWKx5JDozxduk5bdPxVh5NchsSob8KybneoBID6ZMRBmuQP2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754425360; c=relaxed/simple;
	bh=rTnxiA9BL1R+vaD/CWOthhuM8IHT8+JClqid5Etct5A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AbbTzrgea1uXHVdSKNN3hSd+iT2IBeEqJJ9pMVez0Bqfk+s6k60uY5jw5eX9imDNgdxldu0jqOC5tyHttR3DyqAZ47batXaMjWpxYO+uMP+ymzzhXFkEb6of3DJ5GzIYeDrVnOw0a2ueRbEjFNoWxmnszug1sGDT6L/7xdi2Ezc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hzesSLPF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f2dd307d4so4799471a91.0
        for <kvm@vger.kernel.org>; Tue, 05 Aug 2025 13:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754425357; x=1755030157; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=bqiEzQGi8mPmHzSR/9HBKbVJLrw+PmQtKxfKFOFslu4=;
        b=hzesSLPFbtp0yU5Uh1NxvWqqSSXWE+TJhdtdubaQJQQaFLpiinDyuyimn+BYM5hBCD
         CE2lNGowqDZuFwlZ/gBsvCmsAqZ1c7hUDsj5PWEmXHvYfA9Sv9ReY6+T8c01CE+z2gr5
         eZ1iAack61oGh+c9jJG1wHdMPA8FPvGduDYXmsBFA2ekoy0Rrh/oewvodQtBTK6Ju0zj
         Oy6HelWGUMwY/5ce2VRLKMJ0cD7gpCdf/GiRkvYlR5bGZd6ME8D5OLE6632AfMtgatqI
         OY8TTTkF+URIkLLYaTA4zBRXBspJ+PDomk8gWiCiGk6+qW/8Awqmk9DFMGqELHcypNtP
         6T8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754425357; x=1755030157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bqiEzQGi8mPmHzSR/9HBKbVJLrw+PmQtKxfKFOFslu4=;
        b=fqcEdJ8swJV2TjqCWykFXFZolO+/P9azqVMlfbCPVyDJADj2CBgfSc4Sryk/1IOjnF
         GdVpP1BSed89IQF6YxeAxlN6jgftbP0LtH7esZPr849/zCN462qR9pJna+PAQK5xJmRl
         2MAF5PfXwT+/UcSOabanrJfzJo97i3BRSA9f950Dhq89dYihl36I7TUzcO2kDoyXI0qC
         im4pWkUnk7vQA/r7rZPq/JmvB2cmp1DfNKKipHaxJuzLPsKTF2pJsJA1wfB8T2vyy1En
         kbjlc04rwv9EeP5Bz2nTPee2sLpdTF1XGFYBQuRW299C1iEnHOXQAZa6qTmmQMqQuPjj
         j95g==
X-Gm-Message-State: AOJu0YwwumodluqpvtQ0uNH9dv4rzQkC6izy2WpOWOejl/32WIZj6w6z
	FtialUVUzz/YI0tVrgQpkf8Gcof7XT8wX6vbkCWELiP5oXPURRm3LhvzNc+LnFxVhJh4N2919n0
	DEI3elA==
X-Google-Smtp-Source: AGHT+IFILYSMpLJvLjPNe3eD/i5kVt2v2zs3TiIlk4/4dpwGW4POJnyGbIMrZP0UDa71HgdkxAiFrPcIk/g=
X-Received: from pjbsg8.prod.google.com ([2002:a17:90b:5208:b0:31f:4696:ea9c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:528d:b0:312:e91c:e340
 with SMTP id 98e67ed59e1d1-32167580273mr94334a91.35.1754425357421; Tue, 05
 Aug 2025 13:22:37 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  5 Aug 2025 13:22:23 -0700
In-Reply-To: <20250805202224.1475590-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805202224.1475590-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.565.gc32cd1483b-goog
Message-ID: <20250805202224.1475590-6-seanjc@google.com>
Subject: [PATCH v3 5/6] KVM: VMX: Support the immediate form of WRMSRNS in the
 VM-Exit fastpath
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Borislav Petkov <bp@alien8.de>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

From: Xin Li <xin@zytor.com>

Add support for handling "WRMSRNS with an immediate" VM-Exits in KVM's
fastpath.  On Intel, all writes to the x2APIC ICR and to the TSC Deadline
MSR are non-serializing, i.e. it's highly likely guest kernels will switch
to using WRMSRNS when possible.  And in general, any MSR written via
WRMSRNS is probably worth handling in the fastpath, as the entire point of
WRMSRNS is to shave cycles in hot paths.

Signed-off-by: Xin Li (Intel) <xin@zytor.com>
[sean: rewrite changelog, split rename to separate patch]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c |  3 +++
 arch/x86/kvm/x86.c     | 17 +++++++++++++----
 arch/x86/kvm/x86.h     |  1 +
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44423d5f0e27..a3f0d458be9d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7192,6 +7192,9 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu,
 	switch (vmx_get_exit_reason(vcpu).basic) {
 	case EXIT_REASON_MSR_WRITE:
 		return handle_fastpath_wrmsr(vcpu);
+	case EXIT_REASON_MSR_WRITE_IMM:
+		return handle_fastpath_wrmsr_imm(vcpu, vmx_get_exit_qual(vcpu),
+						 vmx_get_msr_imm_reg(vcpu));
 	case EXIT_REASON_PREEMPTION_TIMER:
 		return handle_fastpath_preemption_timer(vcpu, force_immediate_exit);
 	case EXIT_REASON_HLT:
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 79c3074dbd60..68b95ab4b23f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2177,11 +2177,8 @@ static inline bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu)
 	       kvm_request_pending(vcpu) || xfer_to_guest_mode_work_pending();
 }
 
-fastpath_t handle_fastpath_wrmsr(struct kvm_vcpu *vcpu)
+static fastpath_t __handle_fastpath_wrmsr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
 {
-	u64 data = kvm_read_edx_eax(vcpu);
-	u32 msr = kvm_rcx_read(vcpu);
-
 	switch (msr) {
 	case APIC_BASE_MSR + (APIC_ICR >> 4):
 		if (!lapic_in_kernel(vcpu) || !apic_x2apic_mode(vcpu->arch.apic) ||
@@ -2202,8 +2199,20 @@ fastpath_t handle_fastpath_wrmsr(struct kvm_vcpu *vcpu)
 
 	return EXIT_FASTPATH_REENTER_GUEST;
 }
+
+fastpath_t handle_fastpath_wrmsr(struct kvm_vcpu *vcpu)
+{
+	return __handle_fastpath_wrmsr(vcpu, kvm_rcx_read(vcpu),
+				       kvm_read_edx_eax(vcpu));
+}
 EXPORT_SYMBOL_GPL(handle_fastpath_wrmsr);
 
+fastpath_t handle_fastpath_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg)
+{
+	return __handle_fastpath_wrmsr(vcpu, msr, kvm_register_read(vcpu, reg));
+}
+EXPORT_SYMBOL_GPL(handle_fastpath_wrmsr_imm);
+
 /*
  * Adapt set_msr() to msr_io()'s calling convention
  */
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 2dab9c9d6199..eb3088684e8a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -438,6 +438,7 @@ int x86_decode_emulated_instruction(struct kvm_vcpu *vcpu, int emulation_type,
 int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 			    int emulation_type, void *insn, int insn_len);
 fastpath_t handle_fastpath_wrmsr(struct kvm_vcpu *vcpu);
+fastpath_t handle_fastpath_wrmsr_imm(struct kvm_vcpu *vcpu, u32 msr, int reg);
 fastpath_t handle_fastpath_hlt(struct kvm_vcpu *vcpu);
 fastpath_t handle_fastpath_invd(struct kvm_vcpu *vcpu);
 
-- 
2.50.1.565.gc32cd1483b-goog


