Return-Path: <kvm+bounces-36304-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A0B95A19B41
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 00:01:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 296473A5A6B
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 23:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 415F61CAA89;
	Wed, 22 Jan 2025 23:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ioy/gUm7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61491B6CE0
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 23:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737586868; cv=none; b=naUs7cZZETGvYlq7tvDOZ1AP4JQUiIu0sQh5fLTui3R080yxK7uKnO0y+WXGsborQ4gm+IA+Lk6ZjBpc52goQbcnSZbc8zDEhL3OXUb2xxvL3CvNXxVd/3Kb9fvtYL23xWDIkff+8OcqiUdmlWSLE9cvLhI5X+eLHnDQ3DLFEMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737586868; c=relaxed/simple;
	bh=M5YOlErWyRmk4gcxAJRoR3xsw94O/Zk8fUwEu+DlD3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mlJF8Vc07bVJxtFbzEyfg2poYZvB01biEHpXFCquaIlWsoL/jc6BFqhja46ty8m7zsaha68l2/A6YsXQRQK52zWkO6+e/wRUivO/rrAvBggkS3Whl433djDVIV14Chhl/fe/oNK0jvH9SSw3TcDoOOjJyXEApIRUNa7bXrhOeuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ioy/gUm7; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso50740366b.3
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 15:01:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737586865; x=1738191665; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HU57mY86avTKthWjN678c/+Lc+m00xsAn+Hs0sFBtLM=;
        b=ioy/gUm7v8mN/KUF+h/gKs+yrjUmg+WWBcq89IdtaFUvPsG+AvxhWQ3SaMHi6wHoIJ
         g+VfnQ/PYPkA0l8QQ4FzIX4Rnqgx1mpu4yVtSoG3/UIqwdx8lUXnVbrJSmnf91objHn0
         fwgHSNfJ3ZqDPsQjt5rd5LA3GYt+dlBczrrPhm1lB3KFnj+7+zq+OW4IKru8lvahx6uP
         gj7b/GldzYDP7vDetpn/twoxEvTTUs4AqhNAJBc4wJfsfjPJmX+E9fqo2GmPXc5vVLqN
         KHBSglhJPTHbPxr7qGh4rWpKtzHbGzOCZxmd+Z7VsAAvp6JaqEgtW5iPuhlK6NQ8XoXe
         clNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737586865; x=1738191665;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HU57mY86avTKthWjN678c/+Lc+m00xsAn+Hs0sFBtLM=;
        b=ivuf9FWj3b4VTS6wrW9WwLlzw6Q4XvEpPegpkDUO5sAu4SXteccU4gXqOK9A/3saTg
         3K1jnzun04mZu3mw/OndwIi82xmED8sivzvul3uxliD6fLYNt1grhQwI3t3q193HJnWQ
         6YnL570DMDz4+aXzusIq0le7F5b2sfqnVeElZGDsQs4G8VSpaY5v3NcpSkh728Jtkyoo
         34D7vxCYx5RmmvdEb3ScEy1A5yN4uDDOrIIgQKXbbGGVIXDr7wkjQBGH13l0vWVZEFEl
         HpwlmKaNB9B9BlTd4ENS7wrPzx6ZNr2wEKnQIkr+AnklsiETfwqEgoXShAbA+eu6VoK8
         RKGg==
X-Forwarded-Encrypted: i=1; AJvYcCVt7qH+3HI0YYlt3vTinK9GCEnfYPYn2ZvkCBiWEz0u1K68Nc3pMrqXfCE2t5Ah8WT/SEM=@vger.kernel.org
X-Gm-Message-State: AOJu0YylNTCQH1Qqu+o+PkTLHjw/pJ/14Ihh9O2jvcBYkhJGTjlW0BU6
	lQb4RbSudP/vgZpPaQlce62bjmyB43+2ijnBwXTrLdutMvS2ZUGra3X0WUOcqR3FTLfk7ydxo/V
	A2EE50l4ozPFggDtvy8zhiY7ZX2mn06lDRnk=
X-Gm-Gg: ASbGnctt/OBE+W+i+Oh/hfBH+P8dEafdwg0gXDfgCVajvYlsSF89GKX0b/bKJXx3Maw
	fgXtboR7AsAa9Ftr7Cg0CD82WyKr2uiVrVCj3C4MnWpDCiOjd/dyvyZkedb1Ga35fcWOOV4h7HG
	tZW/2y
X-Google-Smtp-Source: AGHT+IEbSpSBSGFgJcdYDkdibJbo6Fmc0OT3yeoOXjeX49KOjWQwycx9/VjzuXKHAPa2PDRwvMeZ08LBdZ8vz+9t56w=
X-Received: by 2002:a17:907:7fa8:b0:aaf:123a:e4f0 with SMTP id
 a640c23a62f3a-ab38b0b6886mr2415353466b.6.1737586864836; Wed, 22 Jan 2025
 15:01:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANDhNCq5_F3HfFYABqFGCA1bPd_+xgNj-iDQhH4tDk+wi8iZZg@mail.gmail.com>
 <Z5FVfe9RwVNr2PGI@google.com>
In-Reply-To: <Z5FVfe9RwVNr2PGI@google.com>
From: John Stultz <jstultz@google.com>
Date: Wed, 22 Jan 2025 15:00:52 -0800
X-Gm-Features: AbW1kvbH8YJJWPZisCIR2JptDHKLICl79ZzQw4_UgMs-rj3s46-01HCEQ2a08Hs
Message-ID: <CANDhNCogn0KogQ6HQJ0+XDwoT4QQFGmqfvTJmtmi65bo=zK=9w@mail.gmail.com>
Subject: Re: BUG: Occasional unexpected DR6 value seen with nested
 virtualization on x86
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Peter Zijlstra <peterz@infradead.org>, Frederic Weisbecker <fweisbec@gmail.com>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Jim Mattson <jmattson@google.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>, 
	kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2025 at 12:55=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> On Tue, Jan 21, 2025, John Stultz wrote:
> > Now, here's where it is odd. I could *not* reproduce the problem on
> > bare metal hardware, *nor* could I reproduce the problem in a virtual
> > environment.  I can *only* reproduce the problem with nested
> > virtualization (running the VM inside a VM).
> >
> > I have reproduced this on my intel i12 NUC using the same v6.12 kernel
> > on metal + virt + nested environments.  It also reproduced on the NUC
> > with v5.15 (metal) + v6.1 (virt) + v6.1(nested).
>
> Huh.  This isn't actually a nested virtualization bug.  It's a flaw in KV=
M's
> fastpath handling.  But hitting it in a non-nested setup is practically i=
mpossible
> because it requires the "kernel" running the test to have interrupts enab=
led
> (rules out the ptrace test), a source of interrupts (rules out KVM-Unit-T=
est),
> window of a handful of instructions (or a weird guest).
>

...[trimmed the very impressive details I'll pretend I understand :) ]...

> But I'm leaning toward going straight for a more complete fix.  My only h=
esitation
> is adding a dedicated .set_dr6() hook, as there's probably more code in V=
MX and
> SVM that can (should?) be moved out of .vcpu_run(), i.e. we could probabl=
y add a
> .pre_vcpu_run() hook to handle everything.   However, even if we added a =
pre-run
> hook, I think I'd still prefer to keep the KVM_DEBUGREG_WONT_EXIT logic i=
n one
> place (modulo the SVM behavior :-/).
>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  1 +
>  arch/x86/kvm/svm/svm.c             |  5 ++---
>  arch/x86/kvm/vmx/main.c            |  1 +
>  arch/x86/kvm/vmx/vmx.c             | 10 ++++++----
>  arch/x86/kvm/vmx/x86_ops.h         |  1 +
>  arch/x86/kvm/x86.c                 |  3 +++
>  7 files changed, 15 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kv=
m-x86-ops.h
> index 7b4536ff3834..5459bc48cfd1 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -48,6 +48,7 @@ KVM_X86_OP(set_idt)
>  KVM_X86_OP(get_gdt)
>  KVM_X86_OP(set_gdt)
>  KVM_X86_OP(sync_dirty_debug_regs)
> +KVM_X86_OP(set_dr6)
>  KVM_X86_OP(set_dr7)
>  KVM_X86_OP(cache_reg)
>  KVM_X86_OP(get_rflags)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 5193c3dfbce1..21d247176858 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1685,6 +1685,7 @@ struct kvm_x86_ops {
>         void (*get_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
>         void (*set_gdt)(struct kvm_vcpu *vcpu, struct desc_ptr *dt);
>         void (*sync_dirty_debug_regs)(struct kvm_vcpu *vcpu);
> +       void (*set_dr6)(struct kvm_vcpu *vcpu, unsigned long value);
>         void (*set_dr7)(struct kvm_vcpu *vcpu, unsigned long value);
>         void (*cache_reg)(struct kvm_vcpu *vcpu, enum kvm_reg reg);
>         unsigned long (*get_rflags)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 7640a84e554a..9d2033d64cfb 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -4247,9 +4247,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kv=
m_vcpu *vcpu,
>          * Run with all-zero DR6 unless needed, so that we can get the ex=
act cause
>          * of a #DB.
>          */
> -       if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))
> -               svm_set_dr6(svm, vcpu->arch.dr6);
> -       else
> +       if (likely(!(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT))=
)
>                 svm_set_dr6(svm, DR6_ACTIVE_LOW);
>
>         clgi();
> @@ -5043,6 +5041,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata =
=3D {
>         .set_idt =3D svm_set_idt,
>         .get_gdt =3D svm_get_gdt,
>         .set_gdt =3D svm_set_gdt,
> +       .set_dr6 =3D svm_set_dr6,


Just fyi, to get this to build (svm_set_dr6 takes a *svm not a *vcpu)
I needed to create a little wrapper to get the types right:

static void svm_set_dr6_vcpu(struct kvm_vcpu *vcpu, unsigned long value)
{
       struct vcpu_svm *svm =3D to_svm(vcpu);
       svm_set_dr6(svm, value);
}

But otherwise, this looks like it has fixed the issue! I've not been
able to trip a failure with the bionic ptrace test, nor with the debug
test in kvm-unit-tests, both running in loops for several minutes.

Tested-by: John Stultz <jstultz@google.com>

Thank you so much for the fast fix here!
-john

