Return-Path: <kvm+bounces-57445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34D6BB559FD
	for <lists+kvm@lfdr.de>; Sat, 13 Sep 2025 01:24:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A6E41C27C5A
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 23:24:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DC9328B7EA;
	Fri, 12 Sep 2025 23:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kGFKMnVB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A63286D4D
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 23:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757719411; cv=none; b=aJ21X+hPTZY73ZfOXoYFa5gy1I5IsnKOLY3qOW9pFL7+tcPvxMAcX+KwBG3t2XgvV3iZW9YmwyCo6wxP6JEM6XZpoHszdd8DhGnuyb1IpvnMeLSTiGWCBJSL4r/vBhP4WJRBt0s6WwmEIYp2GX33iANatZ4elkaHaPfgDariBbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757719411; c=relaxed/simple;
	bh=RfnrgBKDc/OWIfYX9gHpCwT3SRJavCRaCXwq1r24noI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ucx8GKsmKHJ3/aLkoPQ6mIrwQy+eLKBeATB9HqgA83Qdrxso68vo7/IFhkpFUVxQ8bwo5mguNBXa7BSxo+EaC1saH6nDgZneQjnqQnu0UkMwhOTRUJCvvk7ghVottcU3Mbg0/z+DypW2tRecE+cmPpJr7sdR/MXEFZHGNtw49ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kGFKMnVB; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-244582bc5e4so28499715ad.2
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 16:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757719408; x=1758324208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NmaivxQVEFe0XO5/nxLfM/KLjMYMuYOEm/PE5vzh3LQ=;
        b=kGFKMnVBG9T55+Lr2DMRNn948eGl4O62VpI1k432qw0I/F7uqyypA7r2hXP32AXt53
         wCSCbtXzgxjfD8IR7c1rYblZpkGf7r4cy9QqbGeIy34rpR8qNnQG9bmCLV2LaW3sym7u
         iWaQJOI4UkcTXSF89w1ra9Yn6yN6dwWECNqy2ZsCTk8wUiWrxMGPD1u/z9zevipe73Q4
         /rOFaEpbh6j7AqGLmyjg1YN5mIaMcAfxyApv5iPZgXWW7NTo0qkGpbSi3O9+NR8DdpE9
         WisxfH8x+AWafYj4pQ4wTkcyZ0Kbv0kM7tWHYir+mkFaxsiQWmGhTfD+JD3hZ5ibPngM
         EK/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757719408; x=1758324208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NmaivxQVEFe0XO5/nxLfM/KLjMYMuYOEm/PE5vzh3LQ=;
        b=kj8RpcOUdzGzWttR7s8DGDrpI/ictCtRevpp14NmwXeL7Fs3jjHNxguTxFwg+8Iu1R
         KXAE/opn/AgntJUYnwO+uFKrryo/7NvrgQURK8G/6ep6+JlQyHThqtTddy8cfqAGJQZj
         +gi/f4GrEYD0r8QTad/11OCB/STPLL8TyLdXGYJ9/+oCstg7pfQMiHvm3dO7rKSol7gk
         BeoFAxaL82LcfQmTzuzNiXnQctsEojluDnC6jJn84B+zIdmO3ySh2zgv925QsErXdDMp
         cwDWE7pvf0iztAe1IdJ6dGAc8TjZY8bIPpEhpqMHB3wdHK8njM6OZmh7lLBgtouEocSQ
         Sfjg==
X-Gm-Message-State: AOJu0YwGbmVZ5Fetg4O5r2hvS5mnX0+VjEI84L9XlL5c3EoX9ATMFZbI
	j3XJx5AHNzM2vbkmAlMPaT3mMzPNXukHg6F6qyC7JuYx/mNMHg2l2LsmTnzo2rRU6e/uHLs1+jc
	0pi+GEw==
X-Google-Smtp-Source: AGHT+IEtFQQ6WoNpVHIEeKbNxUulKYbOustADM2+6byBPG/dE7g3o+WPUD48P0jF3XjgyBxyABZti1EuuNo=
X-Received: from pjh11.prod.google.com ([2002:a17:90b:3f8b:b0:327:dcfb:4ee1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1986:b0:249:1234:9f7c
 with SMTP id d9443c01a7336-25d2772a4damr41539885ad.60.1757719408305; Fri, 12
 Sep 2025 16:23:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Sep 2025 16:22:40 -0700
In-Reply-To: <20250912232319.429659-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250912232319.429659-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250912232319.429659-3-seanjc@google.com>
Subject: [PATCH v15 02/41] KVM: SEV: Read save fields from GHCB exactly once
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Mathias Krause <minipli@grsecurity.net>, 
	John Allen <john.allen@amd.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

Wrap all reads of GHCB save fields with READ_ONCE() via a KVM-specific
GHCB get() utility to help guard against TOCTOU bugs.  Using READ_ONCE()
doesn't completely prevent such bugs, e.g. doesn't prevent KVM from
redoing get() after checking the initial value, but at least addresses
all potential TOCTOU issues in the current KVM code base.

Opportunistically reduce the indentation of the macro-defined helpers and
clean up the alignment.

Fixes: 4e15a0ddc3ff ("KVM: SEV: snapshot the GHCB before accessing it")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/sev.c |  8 ++++----
 arch/x86/kvm/svm/svm.h | 26 ++++++++++++++++----------
 2 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fe8d148b76c0..37abbda28685 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3304,16 +3304,16 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 	svm->vmcb->save.cpl = kvm_ghcb_get_cpl_if_valid(svm, ghcb);
 
 	if (kvm_ghcb_xcr0_is_valid(svm)) {
-		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+		vcpu->arch.xcr0 = kvm_ghcb_get_xcr0(ghcb);
 		vcpu->arch.cpuid_dynamic_bits_dirty = true;
 	}
 
 	/* Copy the GHCB exit information into the VMCB fields */
-	exit_code = ghcb_get_sw_exit_code(ghcb);
+	exit_code = kvm_ghcb_get_sw_exit_code(ghcb);
 	control->exit_code = lower_32_bits(exit_code);
 	control->exit_code_hi = upper_32_bits(exit_code);
-	control->exit_info_1 = ghcb_get_sw_exit_info_1(ghcb);
-	control->exit_info_2 = ghcb_get_sw_exit_info_2(ghcb);
+	control->exit_info_1 = kvm_ghcb_get_sw_exit_info_1(ghcb);
+	control->exit_info_2 = kvm_ghcb_get_sw_exit_info_2(ghcb);
 	svm->sev_es.sw_scratch = kvm_ghcb_get_sw_scratch_if_valid(svm, ghcb);
 
 	/* Clear the valid entries fields */
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5d39c0b17988..c2316adde3cc 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -913,16 +913,22 @@ void __svm_sev_es_vcpu_run(struct vcpu_svm *svm, bool spec_ctrl_intercepted,
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
+static __always_inline u64 kvm_ghcb_get_##field(struct ghcb *ghcb)			\
+{											\
+	return READ_ONCE(ghcb->save.field);						\
+}											\
+											\
+static __always_inline bool kvm_ghcb_##field##_is_valid(const struct vcpu_svm *svm)	\
+{											\
+	return test_bit(GHCB_BITMAP_IDX(field),						\
+			(unsigned long *)&svm->sev_es.valid_bitmap);			\
+}											\
+											\
+static __always_inline u64 kvm_ghcb_get_##field##_if_valid(struct vcpu_svm *svm,	\
+							   struct ghcb *ghcb)		\
+{											\
+	return kvm_ghcb_##field##_is_valid(svm) ? kvm_ghcb_get_##field(ghcb) : 0;	\
+}
 
 DEFINE_KVM_GHCB_ACCESSORS(cpl)
 DEFINE_KVM_GHCB_ACCESSORS(rax)
-- 
2.51.0.384.g4c02a37b29-goog


