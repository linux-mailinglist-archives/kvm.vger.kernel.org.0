Return-Path: <kvm+bounces-48671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 00AE8AD0837
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 20:47:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CF87189CE92
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 18:47:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE92C1EDA16;
	Fri,  6 Jun 2025 18:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fk1cnpfN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C20E1311AC
	for <kvm@vger.kernel.org>; Fri,  6 Jun 2025 18:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749235632; cv=none; b=fFXWG/deZ6zWhr0Lx6oFUGkfB2i/nxG1ED3AghZims/mQ/aD6ifBotWCFLi7dImc1zgKMMsaXdWPG1K6uYPBlLJ9Xk5GWQ3msIXxnSNR6AzW6V/1+c/2Yb2NxppEuN+M5RFhnZaUVWWdW/fKGiVcs0B+LzsPzliOV3Lur13wV5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749235632; c=relaxed/simple;
	bh=VNprBbGInVwNB1dTCHUv4OWQx/EAaGLFCt+mwQEfaOE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SqasTQJwrQ7AgxVBFQp/5W8p0DUo7xlxhj0c8rJk+mCYGpw8vIuR96WeYmVlXeFQd8+W/o9u99myzTvhgCbwSTbOqUQl8plCqqg3KcTP59VMKrqHphQInyRKL8UQNNdSDnHhJDhQH8+TGcriZ6CcsRjc4ACImr7xPfovCymanWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fk1cnpfN; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-747d143117eso1966340b3a.3
        for <kvm@vger.kernel.org>; Fri, 06 Jun 2025 11:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749235630; x=1749840430; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v/ki/VhM37j6zMZpXzHfYjvUHV1vLuZ1aZ5fIvczRkI=;
        b=Fk1cnpfNpT8MFk1+bMzMCR1J8Pe9WSNoQe4p0Z1+IeQvHC8TQtAVhTYGDvkWDZ5nd2
         RrIVef2qzYtWT2loh5yQJG71SpntusRkcNl7KQ4cJjqiVdc5E8FomnbK4iverBjponi5
         EBODWbL6eVJq7HSypWaMsnXRbcZ7C2143V7/kQkKB9A2uiIdFNt2bE8qG/NlBdVrUksN
         MaDCGy4p2SDZy1vnZrVeqaAii+HrOmd+FCtkZNoJ8xbjxUsS6zOnPTQkLnziTSRE6riD
         I5/V2DEWfqh0Xu7S8v/kzQ5DZMf4EHZ7osW4rOxW5n4DutkUriCN917HEwsfl/jnkedQ
         NqRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749235630; x=1749840430;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v/ki/VhM37j6zMZpXzHfYjvUHV1vLuZ1aZ5fIvczRkI=;
        b=nF5vFGOPIbyydXxMB0/fgUQgsDuIS1taLKHZz2QJlYIgsRtl9oR/d34WEesFnHPeP/
         aJX/3eLRZHH/rQYdyRoK21XF5FtCqNetZGqLDlBarshOspyiPO6h5cKZsUdUHwq6eY8n
         P/nSakL7AzP3ZZrK2kHsvACJpTXu4JSb3GvRTmBnJXn4XWAf1a79bLuXftLZWAkbp0nE
         WlhQjDJ4i0DuK8shyNXyGUPhTEUrAlBJjEpNheUoprw4RzslHm6rT3z/Kh2YX2Ke/MW7
         FblAT/MYPUsdDZzPgwBWOxHyQ8t/6mRtlf/6einEDnhSet5s8nM0sRXZo4j5YXnrSopr
         Sg+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWAMd/jTsj7r4s1cn9RPajzf1bet9EFHS3032J8jiINouO+cZp4Dg1GbzpDlnPNIncGze8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjdsCvXM07oZ6rq8iwMRDCHIoUOlWJGewKFJu7deH1jJeK/W2n
	E2gu1vkKaQXk9FwM9ZQxCuJIeXrIswB9qSupF40y4x/+pobNg30kUWUc0trn04MKPtKxwjsQEZf
	mMiPjsQ==
X-Google-Smtp-Source: AGHT+IEZyYuLn2uNfZKIlYtfvQKzZHENqms43RXrZuwTzWFllEW6HqLwXyFTQrSxPPBQBCLq39nRCAnbAsU=
X-Received: from pffk13.prod.google.com ([2002:aa7:88cd:0:b0:746:2acb:bba2])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1882:b0:740:b5f8:ac15
 with SMTP id d2e1a72fcca58-74827e7b394mr5618400b3a.10.1749235629913; Fri, 06
 Jun 2025 11:47:09 -0700 (PDT)
Date: Fri, 6 Jun 2025 11:47:08 -0700
In-Reply-To: <4dd45ddb-5faf-4766-b829-d7e10d3d805f@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
 <20250514071803.209166-8-Neeraj.Upadhyay@amd.com> <20250524121241.GKaDG3uWICZGPubp-k@fat_crate.local>
 <4dd45ddb-5faf-4766-b829-d7e10d3d805f@amd.com>
Message-ID: <aEM3rBrlxHMk6Mct@google.com>
Subject: Re: [RFC PATCH v6 07/32] KVM: x86: apic_test_vector() to common code
From: Sean Christopherson <seanjc@google.com>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	mingo@redhat.com, dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com, 
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com, 
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org, 
	hpa@zytor.com, peterz@infradead.org, pbonzini@redhat.com, kvm@vger.kernel.org, 
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com, naveen.rao@amd.com, 
	francescolavra.fl@gmail.com, tiala@microsoft.com
Content-Type: text/plain; charset="us-ascii"

On Mon, May 26, 2025, Neeraj Upadhyay wrote:
> 
> 
> On 5/24/2025 5:42 PM, Borislav Petkov wrote: 
> > 
> > The previous patch is moving those *_POS() macros to arch/x86/kvm/lapic.c, now
> > this patch is doing rename-during-move to the new macros.
> > 
> > Why can't you simply do the purely mechanical moves first and then do the
> > renames? Didn't I explain it the last time? Or is it still unclear?
> > 
> 
> I thought it was clear to me when you explained last time. However, I did this
> rename-during-move because of below reason. Please correct me if I am wrong here.
> 
> VEC_POS, REG_POS are kvm-internal wrappers for APIC_VECTOR_TO_BIT_NUMBER/
> APIC_VECTOR_TO_REG_OFFSET macros which got defined in patch 01/32. Prior to patch
> 06/32, these macros were defined in kvm-internal header arch/x86/kvm/lapic.h. Using
> VEC_POS, REG_POS kvm-internal macros in x86 common header file (arch/x86/include/asm/apic.h)
> in this patch did not look correct to me and as APIC_VECTOR_TO_BIT_NUMBER/APIC_VECTOR_TO_REG_OFFSET
> are already defined in arch/x86/include/asm/apic.h, I used them.
> 
> Is adding this information in commit log of this patch sufficient or do you have some
> other suggestion for doing this?

I agree that moving VEC_POS/REG_POS to common code would be weird/undesirable,
but I also agree with Boris' underlying point that doing renames as part of code
movement is also undesirable.  And you're doing that all over this series.

So, just one patch at the beginning of the series to replace VEC_POS/REG_POS with
APIC_VECTOR_TO_BIT_NUMBER/APIC_VECTOR_TO_REG_OFFSET, but *only* in the functions
you intended to move out of KVM.  That way you separate code movement and rename
patches.

Actually, looking at the end usage, just drop VEC_POS/REG_POS entirely.  IIRC, I
suggested keeping the shorthand versions for KVM, but I didn't realize there would
literally be two helpers left.  At that point, keeping VEC_POS and REG_POS is
pure stubborness :-)

 1. Rename VEC_POS/REG_POS => APIC_VECTOR_TO_BIT_NUMBER/APIC_VECTOR_TO_REG_OFFSET
 2. Rename all of the KVM helpers you intend to move out of KVM.
 3. Move all of the helpers out of KVM.

That way #1 and #2 are pure KVM changes, and the code review movement is easy to
review because it'll be _just_ code movement.

Actually (redux), we should probably kill off __apic_test_and_set_vector() and
__apic_test_and_clear_vector(), because the _only_ register that's safe to modify
with a non-atomic operation is ISR, because KVM isn't running the vCPU, i.e.
hardware can't service an IRQ or process an EOI for the relevant (virtual) APIC.

So this on top somewhere? (completely untested)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8ecc3e960121..95921e5c3eb2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -104,16 +104,6 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
                apic_test_vector(vector, apic->regs + APIC_IRR);
 }
 
-static inline int __apic_test_and_set_vector(int vec, void *bitmap)
-{
-       return __test_and_set_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
-}
-
-static inline int __apic_test_and_clear_vector(int vec, void *bitmap)
-{
-       return __test_and_clear_bit(VEC_POS(vec), (bitmap) + REG_POS(vec));
-}
-
 __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
 EXPORT_SYMBOL_GPL(kvm_has_noapic_vcpu);
 
@@ -706,9 +696,15 @@ void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec)
 }
 EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
 
+static void *apic_vector_to_isr(int vec, struct kvm_lapic *apic)
+{
+       return apic->regs + APIC_ISR + APIC_VECTOR_TO_REG_OFFSET(vec);
+}
+
 static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 {
-       if (__apic_test_and_set_vector(vec, apic->regs + APIC_ISR))
+       if (__test_and_set_bit(APIC_VECTOR_TO_BIT_NUMBER(vec),
+                              apic_vector_to_isr(vec, apic)))
                return;
 
        /*
@@ -751,7 +747,8 @@ static inline int apic_find_highest_isr(struct kvm_lapic *apic)
 
 static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 {
-       if (!__apic_test_and_clear_vector(vec, apic->regs + APIC_ISR))
+       if (!__test_and_clear_bit(APIC_VECTOR_TO_BIT_NUMBER(vec),
+                                 apic_vector_to_isr(vec, apic)))
                return;
 
        /*


