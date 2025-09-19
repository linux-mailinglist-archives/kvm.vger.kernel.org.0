Return-Path: <kvm+bounces-58267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A3AFB8B881
	for <lists+kvm@lfdr.de>; Sat, 20 Sep 2025 00:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E03DA03203
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 22:43:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5962E315D42;
	Fri, 19 Sep 2025 22:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cTgbiLit"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB25230EF9F
	for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 22:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758321257; cv=none; b=iIAOPFimc6e0bYgUF2CIV97b1oI31HPrFQ8Apo/PjUewLnffzBojFMJZQKKZ47+T9W/hdl4ISM9Vhb9wNr4cneJnGP5zVkUrTn2GLcInKZ8Aba/4F+81ixxutTHyLC8yMHjOQoSiAACB9zB5IQzS6nRnaaWGQv4EKhwz1XoXkM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758321257; c=relaxed/simple;
	bh=8PRqVNvtJzh+ZpaClWIkz+QMaHPq9nVT+VsmB/6rcek=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KX2Y09POmKXoExSWzT2NSY2VKlO/yotoKbBYBtSDGBxsjZ5kPc6UUp9BbHDR7gIJEvFpQ3HxYI9mB2fWvPaAM5HbnJS6CHiC0ssI4e/Uz4DGG81XV2ilxW5PSExfkv7+YWLduUHsgdl1wQU7AxLN4NLE167C2yKXAnSD22xmmGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cTgbiLit; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32ee62ed6beso3497056a91.2
        for <kvm@vger.kernel.org>; Fri, 19 Sep 2025 15:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758321255; x=1758926055; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Lmjv7m743ORHFla75w2cvbk6s7USbNyWaxznp0sV74A=;
        b=cTgbiLitZ7g+53RLVWZSfDXiMZuXesT4yCX7/B9C/71ceUsjT7uWmSy00fr9A7tKje
         bCoefRa70RN46ww9SigiH6yaqJT+5S7qU4Y3XuxKg3VHXOGZO/WcX2Dak+bGsROEVZHF
         hZjiMQL27sy/48ugi0DEFVimk8DfoB59SGkgpbpVDL34iMu1qNIGDpoNUZSE3oRw1Sme
         0qZJz6RKwCHDswEfi8pXg5kGgRUfO4qfdMdCk7jUADf7jLlO6yN8LDhmMaVwGUDvVY8r
         MPFM+yrR6mlTN2wi5lAb2gKzifRIuHzG7CNPXGtbaiDnM0W3SDWlD0bEa0mk6p+IYvyB
         Jnzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758321255; x=1758926055;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lmjv7m743ORHFla75w2cvbk6s7USbNyWaxznp0sV74A=;
        b=gtxqxi7Du91OATLamH/nPqKOUkY0V+4JJKbEnTyKF1Ic2Fo8J1SsKjbUqJiytcpfr1
         ioiRIaIDVDTxADMGZA7aJO1mgrx1NGdj4igE0fUU/JnOEphTHJNbv7gZx5skYea5qA2M
         2ezLShTELI515308UEIBNGdHOAEHyu9s6B4AXPNkhbRHd9i4gxLqDcD9cexuG8boZgUr
         pdnRnG0gEQ6LtzcYqCL+0CBBFPPQn0eIlin/2SRPlgpYlwBhR1enNloj5wkwHnTsMJt3
         iYl9PcamRYzGa/eXZcgX5cwsk/gGPoxMkugSTBVZpqdCQJWnJMhTFICapZlhTmPDmBeP
         /Mlg==
X-Gm-Message-State: AOJu0YytfphPi6sMadnSFLyic05aPJnFYrQjjNcDC+V0DSfWWoihhbLB
	jpAI/QjsA7ci1JL1jwz2aAO5fJj1sUTNYkYDBm3eOAP0ekvePjfM68nSPX8egI8j35RVGYfQrQ8
	Aj0sZuA==
X-Google-Smtp-Source: AGHT+IHQvz8EQEYC+3Q2dR14cDca69hLVvd5EVswQ5O/zITiUduAJL+HAN0BvQ56Qn7wIX3EDQJtXUXduMQ=
X-Received: from pjbnc16.prod.google.com ([2002:a17:90b:37d0:b0:32e:c154:c2f6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b48:b0:24b:bbf2:4791
 with SMTP id d9443c01a7336-269ba511bd3mr67840065ad.39.1758321255488; Fri, 19
 Sep 2025 15:34:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 19 Sep 2025 15:32:46 -0700
In-Reply-To: <20250919223258.1604852-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250919223258.1604852-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
Message-ID: <20250919223258.1604852-40-seanjc@google.com>
Subject: [PATCH v16 39/51] KVM: SEV: Synchronize MSR_IA32_XSS from the GHCB
 when it's valid
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"

Synchronize XSS from the GHCB to KVM's internal tracking if the guest
marks XSS as valid on a #VMGEXIT.  Like XCR0, KVM needs an up-to-date copy
of XSS in order to compute the required XSTATE size when emulating
CPUID.0xD.0x1 for the guest.

Treat the incoming XSS change as an emulated write, i.e. validatate the
guest-provided value, to avoid letting the guest load garbage into KVM's
tracking.  Simply ignore bad values, as either the guest managed to get an
unsupported value into hardware, or the guest is misbehaving and providing
pure garbage.  In either case, KVM can't fix the broken guest.

Explicitly allow access to XSS at all times, as KVM needs to ensure its
copy of XSS stays up-to-date.  E.g. KVM supports migration of SEV-ES guests
and so needs to allow the host to save/restore XSS, otherwise a guest
that *knows* its XSS hasn't change could get stale/bad CPUID emulation if
the guest doesn't provide XSS in the GHCB on every exit.  This creates a
hypothetical problem where a guest could request emulation of RDMSR or
WRMSR on XSS, but arguably that's not even a problem, e.g. it would be
entirely reasonable for a guest to request "emulation" as a way to inform
the hypervisor that its XSS value has been modified.

Note, emulating the change as an MSR write also takes care of side effects,
e.g. marking dynamic CPUID bits as dirty.

Suggested-by: John Allen <john.allen@amd.com>
base-commit: 14298d819d5a6b7180a4089e7d2121ca3551dc6c
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c | 3 +++
 arch/x86/kvm/svm/svm.c | 4 ++--
 arch/x86/kvm/svm/svm.h | 1 +
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 85e84bb1a368..94d9acc94c9a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3354,6 +3354,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	if (kvm_ghcb_xcr0_is_valid(svm))
 		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(svm));
 
+	if (kvm_ghcb_xss_is_valid(svm))
+		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(svm));
+
 	/* Copy the GHCB exit information into the VMCB fields */
 	exit_code = kvm_ghcb_get_sw_exit_code(svm);
 	control->exit_code = lower_32_bits(exit_code);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cabe1950b160..d48bf20c865b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2721,8 +2721,8 @@ static int svm_get_feature_msr(u32 msr, u64 *data)
 static bool sev_es_prevent_msr_access(struct kvm_vcpu *vcpu,
 				      struct msr_data *msr_info)
 {
-	return sev_es_guest(vcpu->kvm) &&
-	       vcpu->arch.guest_state_protected &&
+	return sev_es_guest(vcpu->kvm) && vcpu->arch.guest_state_protected &&
+	       msr_info->index != MSR_IA32_XSS &&
 	       !msr_write_intercepted(vcpu, msr_info->index);
 }
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index e072f91045b5..a6a1daa3fc89 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -941,5 +941,6 @@ DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_KVM_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_KVM_GHCB_ACCESSORS(sw_scratch)
 DEFINE_KVM_GHCB_ACCESSORS(xcr0)
+DEFINE_KVM_GHCB_ACCESSORS(xss)
 
 #endif
-- 
2.51.0.470.ga7dc726c21-goog


