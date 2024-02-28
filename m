Return-Path: <kvm+bounces-10191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 37DF186A6BB
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:43:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E2356288422
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:43:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB687224D0;
	Wed, 28 Feb 2024 02:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PcHXFqab"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7802020DF4
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088122; cv=none; b=IkoDYsztj7R/Lh5h0ov3ZFn+aUUjZmKZIic3XNY7LEBAbPS8GmezL8dvCVs91OV5n4liPnFDXLkDbDDaqD2/p+0Vtg46qZUlz6qQAoblvlTRhRoBrtHzr+tiIAIpBdQ1Bp7TaqfNCm0KdwwS76YGI7CGx+XCZy7hr3S6bkp+SK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088122; c=relaxed/simple;
	bh=fw6fQCaxNyQVmsm0HwKPD91hojXxJNupzj4MzyZI3f0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aWHVdmWIlgGRXtEGIiK5rsxPtYLj69JChoDVcvnCN0bTB7enMaxl94+Z14CSGOrjNgFl0rs/JsqgoRMWbhzg6VTujyz26eCIZjQctc3cXOXYKdTjWF2kaUlJQ0cQJh8P/7YH2LyNRd7tsBPmtIvSw8fVZMPXLFVa/MSZTmzBTds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PcHXFqab; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6e4d0e28cd1so403100b3a.0
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088120; x=1709692920; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=UtgfH5mWUwUleAFxMU19P9nYVxmIT/Ru+pHd1FRZC+Q=;
        b=PcHXFqab6wfr2gPo40/6WpRR5Y4D22zIVOk8I9eZ4ln70tXNUJELztSRICOBRAaDuj
         B4MxQ0dre4sndiDi0+2aXU8XH6Pk4m7El8Zg1xgypt2hku2NWFXt+eUogAFHduBC3OCI
         ZVH7M83YfFE3EkfiFgs7pN4oA2lUUio6ot5V6XZvdTlTvsBYvdACnUzioFkbX88/Etrj
         jUwyIt1tqPPiBb7NvRPwIkQEMhL+7ZZbtBI3ehjguRGd+me4dW7gVxCHGHL7KL7vPcQf
         mnn1ZMea0ahhprXPuqsO9RawAKZ/gP2VIMESDbk/z7QnzFycYKWtPdm50DcN6odKzIXc
         KPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088120; x=1709692920;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UtgfH5mWUwUleAFxMU19P9nYVxmIT/Ru+pHd1FRZC+Q=;
        b=qzVnBbCP7BlzgM3sML8CkfCMfegsY9DNtaPE7KnhlGbGGUaw2MReWO3gCz3ZstxPpm
         IvLWNgfNSgVTRJ6VvB3D6w4mCf7sEMC0VQ2JXqLj1+x2g/ugK8hMn2JnPxFGYlQoHHRn
         tVlLZOOUPp5keSTo72ZQ9QIzjdRkvez8iqnMLhU7ooIHBFF/gbqg6c5x0YyFJKy/01nQ
         ccs3u3srUjV+Rrh80WKGoBM2ok9w8ITcCXH9K/+1vJ+x6VyHLK6ZyPg9S9QxV1wMlp9/
         t/X6xYSJJn0+pLiyvCM+rqD1yobZ0Yr7bAfA7pvDh+R9y8HdtSPwMrd7EWGT5qUX2QFn
         kXEQ==
X-Gm-Message-State: AOJu0Yw3x6fan0KlwdKvz1iUsKKbOg4JJXYO0X9RJuBmpcXIFBbzh7WJ
	CVb7UqxJtvWFFl9j4YgSMGQRi6t1qiGTybk8wmeuEhS2jrdnBZrEsLcGshaHS7XhR2DVu+7hxyx
	WHA==
X-Google-Smtp-Source: AGHT+IGqmp6QkrShsDKaoHDxyQmUjOsMVIaWkQmrr+uLwfys/m2SNtFhLMK3Ci20GlPI6cF86IvueWYbzkU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:4708:b0:6e5:4142:ea1c with SMTP id
 df8-20020a056a00470800b006e54142ea1cmr3775pfb.3.1709088119796; Tue, 27 Feb
 2024 18:41:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:36 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-6-seanjc@google.com>
Subject: [PATCH 05/16] KVM: x86/mmu: Use synthetic page fault error code to
 indicate private faults
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Add and use a synthetic, KVM-defined page fault error code to indicate
whether a fault is to private vs. shared memory.  TDX and SNP have
different mechanisms for reporting private vs. shared, and KVM's
software-protected VMs have no mechanism at all.  Usurp an error code
flag to avoid having to plumb another parameter to kvm_mmu_page_fault()
and friends.

Alternatively, KVM could borrow AMD's PFERR_GUEST_ENC_MASK, i.e. set it
for TDX and software-protected VMs as appropriate, but that would require
*clearing* the flag for SEV and SEV-ES VMs, which support encrypted
memory at the hardware layer, but don't utilize private memory at the
KVM layer.

Opportunistically add a comment to call out that the logic for software-
protected VMs is (and was before this commit) broken for nested MMUs, i.e.
for nested TDP, as the GPA is an L2 GPA.  Punt on trying to play nice with
nested MMUs as there is a _lot_ of functionality that simply doesn't work
for software-protected VMs, e.g. all of the paths where KVM accesses guest
memory need to be updated to be aware of private vs. shared memory.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 11 +++++++++++
 arch/x86/kvm/mmu/mmu.c          | 26 +++++++++++++++++++-------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 3 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1e69743ef0fb..4077c46c61ab 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -267,7 +267,18 @@ enum x86_intercept_stage;
 #define PFERR_GUEST_ENC_MASK	BIT_ULL(34)
 #define PFERR_GUEST_SIZEM_MASK	BIT_ULL(35)
 #define PFERR_GUEST_VMPL_MASK	BIT_ULL(36)
+
+/*
+ * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP checks
+ * when emulating instructions that triggers implicit access.
+ */
 #define PFERR_IMPLICIT_ACCESS	BIT_ULL(48)
+/*
+ * PRIVATE_ACCESS is a KVM-defined flag us to indicate that a fault occurred
+ * when the guest was accessing private memory.
+ */
+#define PFERR_PRIVATE_ACCESS	BIT_ULL(49)
+#define PFERR_SYNTHETIC_MASK	(PFERR_IMPLICIT_ACCESS | PFERR_PRIVATE_ACCESS)
 
 #define PFERR_NESTED_GUEST_PAGE (PFERR_GUEST_PAGE_MASK |	\
 				 PFERR_WRITE_MASK |		\
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 408969ac1291..7807bdcd87e8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5839,19 +5839,31 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	bool direct = vcpu->arch.mmu->root_role.direct;
 
 	/*
-	 * IMPLICIT_ACCESS is a KVM-defined flag used to correctly perform SMAP
-	 * checks when emulating instructions that triggers implicit access.
 	 * WARN if hardware generates a fault with an error code that collides
-	 * with the KVM-defined value.  Clear the flag and continue on, i.e.
-	 * don't terminate the VM, as KVM can't possibly be relying on a flag
-	 * that KVM doesn't know about.
+	 * with KVM-defined sythentic flags.  Clear the flags and continue on,
+	 * i.e. don't terminate the VM, as KVM can't possibly be relying on a
+	 * flag that KVM doesn't know about.
 	 */
-	if (WARN_ON_ONCE(error_code & PFERR_IMPLICIT_ACCESS))
-		error_code &= ~PFERR_IMPLICIT_ACCESS;
+	if (WARN_ON_ONCE(error_code & PFERR_SYNTHETIC_MASK))
+		error_code &= ~PFERR_SYNTHETIC_MASK;
 
 	if (WARN_ON_ONCE(!VALID_PAGE(vcpu->arch.mmu->root.hpa)))
 		return RET_PF_RETRY;
 
+	/*
+	 * Except for reserved faults (emulated MMIO is shared-only), set the
+	 * private flag for software-protected VMs based on the gfn's current
+	 * attributes, which are the source of truth for such VMs.  Note, this
+	 * wrong for nested MMUs as the GPA is an L2 GPA, but KVM doesn't
+	 * currently supported nested virtualization (among many other things)
+	 * for software-protected VMs.
+	 */
+	if (IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) &&
+	    !(error_code & PFERR_RSVD_MASK) &&
+	    vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM &&
+	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(cr2_or_gpa)))
+		error_code |= PFERR_PRIVATE_ACCESS;
+
 	r = RET_PF_INVALID;
 	if (unlikely(error_code & PFERR_RSVD_MASK)) {
 		r = handle_mmio_page_fault(vcpu, cr2_or_gpa, direct);
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1fab1f2359b5..d7c10d338f14 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -306,7 +306,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
 		.req_level = PG_LEVEL_4K,
 		.goal_level = PG_LEVEL_4K,
-		.is_private = kvm_mem_is_private(vcpu->kvm, cr2_or_gpa >> PAGE_SHIFT),
+		.is_private = err & PFERR_PRIVATE_ACCESS,
 	};
 	int r;
 
-- 
2.44.0.278.ge034bb2e1d-goog


