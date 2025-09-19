Return-Path: <kvm+bounces-58230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FDB7B8B7A8
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:33:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39EABA01D1E
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A716E2D8381;
	Fri, 19 Sep 2025 22:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="df4Pb4fN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408CB2D5C6A
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321188; cv=none; b=BO02DRnrRlMKmHpp0KyALTQ5HT3DYsL5g84F1LRDMs8bM0p+XVN7Xq1ZRkIVoGvYGjHHtu0ZMr/t1+HdZb8X5u20J2rdWmaO9QtPorXkN0rSsITIdW43XntPaB6GSOae2zl7Y1hP5j+MNw3pDziCVXldPlxu3j750p+j+kQsJs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321188; c=relaxed/simple;
	bh=MGoqbJuB9sCOizQgDYnMaXG/P8e3uUL1d4ZDtIlGQ04=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QEmuN/vz0h04h8uI7BbefL9cgqxEdtoIdbL9BWEAfFpabb3sWOAEJzZ+sDaxdfmgTkcJHnn8Gue/aslrjMj/XcZGU604diUCO9Dy9a4JwvCe9UsRuPFOiVkCApxx0oLDsDBJEpnLbyr5YGCaHXqdKAIhL5VfiQ9bUL/qRIsbZNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=df4Pb4fN; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-77e7d9ed351so1045183b3a.0
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321186; x=1758925986; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wqYcd9euZlCyN9BS3XgrU5fRkOaykxhfX02wnyNgUOs=;
        b=df4Pb4fN1+5xBwOnUfndrG3L3hSpJctLcp8n5wAXXz6bhRz1verdI56BsjXua+I3DN
         XS/r5MPmSQ/odHbfKz8QWEl1PsmWYjIZpCvauFWayWLWBKMnCt5NLrGldxIzQqFbswxY
         TuwXlXl+cWM7ZmKnQ+HI35xrn8WojK2KTAEmtJPeHWKym0ZDFjIoHnn3wn5nhY7+MEQ7
         af3mLAnaIB7a0ZXbZ9yLUc9H8GOOcGhtql8z2dnFRC0gw1US5TsYlcoqB/ZVGcbfxBge
         bK3RYjgnmWyV8g7YrY6LNBhZhkG+FbO4u0PO2M63gsLcRZGf8rWNkWPPh8ryxC0Ge8NG
         blow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321186; x=1758925986;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wqYcd9euZlCyN9BS3XgrU5fRkOaykxhfX02wnyNgUOs=;
        b=UppF5hKd+YsRwzHOx9cMj/xdbxZn6UVdUdZ1a/FLuuIUsQPV/fJYj8910ZcP417Ntd
         NGUwvDMwdcE85PJ7eSRw5qnqncwD3x4RzavheU+Wda01wXWsNyMEMnVWOiVmXeLwOodU
         gjQ1MmVZeaIdlcdm0M4vqod/6yb41gcxh4R77Dozbsto85OL3YlJCJPB6hLEoiyrPnjz
         VDklXItVQBzxVOJuZGHoUogJL0DVQMrQdMHBXJQi+y06mdKitPMw2tT8LsXll+4BXUYl
         ojHaRdI10qwY/p8bksDJf87yucSUtzwuVpIN704ypaVykg8vPG1I918/lAWLXVsUxyup
         AixA==
X-Gm-Message-State: AOJu0YyGbn6U+AbRbyw4dNOgBAxSa/skyGvZ9YqvOuCXpr85MdrXG5VI
	JobVFsDJCZv7Le6YkjiwiGdmAN+n8NBncm/kluDth0qrEJr9L5fgidCb4M3ni91ilpL6YDCM2yE
	4pwgNsg==
X-Google-Smtp-Source: AGHT+IHa7+GTGOB/OfVBevbILqcp7CNMwVxukhCmqhE5euiMqraGlNNrlrM+jwtI07qDvfdB/ch8vTN5P0k=
X-Received: from pfmm21.prod.google.com ([2002:a05:6a00:2495:b0:77f:1cc1:89eb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1706:b0:774:615b:c8ad
 with SMTP id d2e1a72fcca58-77e4d127eb2mr6222337b3a.9.1758321186510; Fri, 19
 Sep 2025 15:33:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:09 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-3-seanjc@google.com>
Subject: [PATCH v16 02/51] KVM: SEV: Read save fields from GHCB exactly once
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Wrap all reads of GHCB save fields with READ_ONCE() via a KVM-specific
GHCB get() utility to help guard against TOCTOU bugs.  Using READ_ONCE()
doesn't completely prevent such bugs, e.g. doesn't prevent KVM from
redoing get() after checking the initial value, but at least addresses
all potential TOCTOU issues in the current KVM code base.

To prevent unintentional use of the generic helpers, take only @svm for
the kvm_ghcb_get_xxx() helpers and retrieve the ghcb instead of explicitly
passing it in.

Opportunistically reduce the indentation of the macro-defined helpers and
clean up the alignment.

Fixes: 4e15a0ddc3ff ("KVM: SEV: snapshot the GHCB before accessing it")
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 22 +++++++++++-----------
 arch/x86/kvm/svm/svm.h | 25 +++++++++++++++----------
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f046a587ecaf..8d057dbd8a71 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3343,26 +3343,26 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	BUILD_BUG_ON(sizeof(svm->sev_es.valid_bitmap) != sizeof(ghcb->save.valid_bitmap));
 	memcpy(&svm->sev_es.valid_bitmap, &ghcb->save.valid_bitmap, sizeof(ghcb->save.valid_bitmap));
 
-	vcpu->arch.regs[VCPU_REGS_RAX] = kvm_ghcb_get_rax_if_valid(svm, ghcb);
-	vcpu->arch.regs[VCPU_REGS_RBX] = kvm_ghcb_get_rbx_if_valid(svm, ghcb);
-	vcpu->arch.regs[VCPU_REGS_RCX] = kvm_ghcb_get_rcx_if_valid(svm, ghcb);
-	vcpu->arch.regs[VCPU_REGS_RDX] = kvm_ghcb_get_rdx_if_valid(svm, ghcb);
-	vcpu->arch.regs[VCPU_REGS_RSI] = kvm_ghcb_get_rsi_if_valid(svm, ghcb);
+	vcpu->arch.regs[VCPU_REGS_RAX] = kvm_ghcb_get_rax_if_valid(svm);
+	vcpu->arch.regs[VCPU_REGS_RBX] = kvm_ghcb_get_rbx_if_valid(svm);
+	vcpu->arch.regs[VCPU_REGS_RCX] = kvm_ghcb_get_rcx_if_valid(svm);
+	vcpu->arch.regs[VCPU_REGS_RDX] = kvm_ghcb_get_rdx_if_valid(svm);
+	vcpu->arch.regs[VCPU_REGS_RSI] = kvm_ghcb_get_rsi_if_valid(svm);
 
-	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
+	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm);
 
 	if (kvm_ghcb_xcr0_is_valid(svm)) {
-		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+		vcpu->arch.xcr0 = kvm_ghcb_get_xcr0(svm);
 		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 	}
 
 	/* Copy the GHCB exit information into the VMCB fields */
-	exit_code = ghcb_get_sw_exit_code(ghcb);
+	exit_code = kvm_ghcb_get_sw_exit_code(svm);
 	control->exit_code = lower_32_bits(exit_code);
 	control->exit_code_hi = upper_32_bits(exit_code);
-	control->exit_info_1 = ghcb_get_sw_exit_info_1(ghcb);
-	control->exit_info_2 = ghcb_get_sw_exit_info_2(ghcb);
-	svm->sev_es.sw_scratch = kvm_ghcb_get_sw_scratch_if_valid(svm, ghcb);
+	control->exit_info_1 = kvm_ghcb_get_sw_exit_info_1(svm);
+	control->exit_info_2 = kvm_ghcb_get_sw_exit_info_2(svm);
+	svm->sev_es.sw_scratch = kvm_ghcb_get_sw_scratch_if_valid(svm);
 
 	/* Clear the valid entries fields */
 	memset(ghcb->save.valid_bitmap, 0, sizeof(ghcb->save.valid_bitmap));
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d39c0b17988..5365984e82e5 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -913,16 +913,21 @@ void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted,
 void __svm_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted);
 
 #define DEFINE_KVM_GHCB_ACCESSORS(field)						\
-	static __always_inline bool kvm_ghcb_##field##_is_valid(const struct vcpu_svm *svm) \
-	{									\
-		return test_bit(GHCB_BITMAP_IDX(field),				\
-				(unsigned long *)&svm->sev_es.valid_bitmap);	\
-	}									\
-										\
-	static __always_inline u64 kvm_ghcb_get_##field##_if_valid(struct vcpu_svm *svm, struct ghcb *ghcb) \
-	{									\
-		return kvm_ghcb_##field##_is_valid(svm) ? ghcb->save.field : 0;	\
-	}									\
+static __always_inline u64 kvm_ghcb_get_##field(struct vcpu_svm *svm)			\
+{											\
+	return READ_ONCE(svm->sev_es.ghcb->save.field);					\
+}											\
+											\
+static __always_inline bool kvm_ghcb_##field##_is_valid(const struct vcpu_svm *svm)	\
+{											\
+	return test_bit(GHCB_BITMAP_IDX(field),						\
+			(unsigned long *)&svm->sev_es.valid_bitmap);			\
+}											\
+											\
+static __always_inline u64 kvm_ghcb_get_##field##_if_valid(struct vcpu_svm *svm)	\
+{											\
+	return kvm_ghcb_##field##_is_valid(svm) ? kvm_ghcb_get_##field(svm) : 0;	\
+}
 
 DEFINE_KVM_GHCB_ACCESSORS(cpl)
 DEFINE_KVM_GHCB_ACCESSORS(rax)
-- 
2.51.0.470.ga7dc726c21-goog


