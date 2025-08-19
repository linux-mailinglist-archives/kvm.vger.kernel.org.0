Return-Path: <kvm+bounces-55012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2878B2C997
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:28:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F95F5C441B
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 16:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D554D25DCEC;
	Tue, 19 Aug 2025 16:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LSIJuam0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35787246BB8;
	Tue, 19 Aug 2025 16:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755620701; cv=none; b=Z2KBRhH9/9rY7B6ake1I07JqbO8sAzu/H6qThN4zO6nUe4aq0YDuoArvH5cP89H93BgqAxDd+cVCct8a/kZ7LZoKPd2Al6LLRDOKuzg9Ie0SC/ndRxPVRPP3c8VWTXnGntBVvniVQn3Qy84D8SHGCyYsBbMNsTYJAl9G2VZFIv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755620701; c=relaxed/simple;
	bh=jlqLeqQhsPrnQlurUx+P6OXPEOxoLS5aWeAi2BjJ/BY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OL5IxRSTByt6HW2m/+U7kag0ySMT8x8BjzEmrIGLkdQVJU9z2/6J4mOwqE3ck62aJ48VR7FdlDhklYh4gS/TLo/1HUYETUk90E+nG0cZGzfKbCjJsvluz7fR3kZc+LDLa3uoDACNlKCxo+ml1CP8zJkAbV9P5ipfYr1OGf1uczA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LSIJuam0; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-55e041f6da0so441012e87.3;
        Tue, 19 Aug 2025 09:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755620697; x=1756225497; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTMNRXOPkPiR6njU3q84W7ATA5znKag4S1zHxATnMkg=;
        b=LSIJuam0PJIf0Am7iTiuUHvNUOjejX6SwD+PCnn4GUkMn+C3cFCAP7NH4LPDPDXO1O
         uK4HfOd7zrOgvzq7BMaar8+7P+DBj7mMp5KvbXhK9gVgWu2gnQ9jMMVXtRaxjBNJ7rSs
         tLMffPq1lpWZYL/K0QCHUZD7kFBV7/g3mqx4HpO2T0oI2P2KJ5e7sPUJGsJBXkyRzqXJ
         nGbtOdEu2umqPtt5t+EjKFpATLrhMEs1Mx1QCSA+rAA82xIQWgSQ7DEPed6X3YQnpOTj
         pWWWVJkCms80btUgK3B6TcU3kMp8ZN+iibDjZjbdXKOuPYhs168KZmUzMUhFeSLHQeAZ
         q+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755620697; x=1756225497;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uTMNRXOPkPiR6njU3q84W7ATA5znKag4S1zHxATnMkg=;
        b=YogeiZ7vEEFHswPsk9Cfexb2wdNuIzwpqslE06OxB7GYxJHxi/kKTSeyMR+hB8Rb6y
         rfM+9z9OJXHGMtY3Lh7Jak9V3MkxAM+xF/W0h1JIe+Ww3Xqy6eGch7jRpXCPsUsrtw6y
         zr273ZJJH8GQ1Iv8zjxRuOPK5L2UH30xX5Y0jkHM+sP7HbY+Ph22wM71MeIABLRQ7Yid
         Ee7jKit69cHFZEVKTi/R5e09N/pKM8Ww9hgmQnS7vp1tQl2ftRVlzNVgt7eKj33fh8om
         vQuVR6CZm5WZ6HLxOEzNEXc/oV2nHq2GTaCza6lwyqOhHh5g7w+JFri9FtxOdvXa0G72
         k76g==
X-Forwarded-Encrypted: i=1; AJvYcCX23gURBem/re5+6BV3rDJ7WJJivq+yr9XJOed9LpuijShBZV4tlCEDrt/BZiMNaKv0Nwn1ky66+V7LgWo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywk8SkGX+2fQXfYsvpecfugarLfJ9aRCgHkEq8r2OhQ3iboShEg
	mHcCBtPxJORyC1cAQk8jKMQnbqmabGIeHdW8FaSZRZZjdIGRjBEC9z2hF/ps95UiktEGrZhCOih
	zlyASZlYlN5Pjjd58va3NCsmaKulToXQ=
X-Gm-Gg: ASbGncvWswJfHu0wwltJNOn9tuXwVj3Lg3cFEroLOaf1m0f8G0qL642yAnJQ0bQ6iiM
	zLXMFsnqIJKJJ1TFYxQU53XzPB65C8RxQ6nV8auc/MP33XE5Oxrb2iLFpYH15DlNqu5uUNyLsft
	tanFsah9Vo05oREWTXgLez28ZA01yTwK0yksYtBjAKlB/jbVO5BZ4WIeBG0URCRRK6ygLvM5JSL
	XkTTaK9iwUaDzKsRg==
X-Google-Smtp-Source: AGHT+IG+GXoleisDOXEQaZTN3k4539S9Z2ZHbd8Y3Rk5hCPSAcWB1lbHKDbngIcEdFSaGBYJF8JZ0UTtdLpr7JMRtaw=
X-Received: by 2002:a05:6512:4202:b0:55b:82e6:6bed with SMTP id
 2adb3069b0e04-55e0082cef8mr731342e87.27.1755620696982; Tue, 19 Aug 2025
 09:24:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807063733.6943-1-ubizjak@gmail.com> <aKSRbjgtp7Nk8-sb@google.com>
In-Reply-To: <aKSRbjgtp7Nk8-sb@google.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Tue, 19 Aug 2025 18:24:45 +0200
X-Gm-Features: Ac12FXyJJSFqGTCZ-PJ4JUV_q-8FggZcZoT7ZykXmGwKATZlRB9jt2RSYkjrkUY
Message-ID: <CAFULd4ZOtj7WZkSSKqLjxCJ-yBr20AYrqzCpxj2K_=XmrX1QZg@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Micro-optimize SPEC_CTRL handling in __vmx_vcpu_run()
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2025 at 5:00=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Aug 07, 2025, Uros Bizjak wrote:
> > Use memory operand in CMP instruction to avoid usage of a
> > temporary register. Use %eax register to hold VMX_spec_ctrl
> > and use it directly in the follow-up WRMSR.
> >
> > The new code saves a few bytes by removing two MOV insns, from:
> >
> >   2d: 48 8b 7c 24 10          mov    0x10(%rsp),%rdi
> >   32: 8b bf 48 18 00 00       mov    0x1848(%rdi),%edi
> >   38: 65 8b 35 00 00 00 00    mov    %gs:0x0(%rip),%esi
> >   3f: 39 fe                   cmp    %edi,%esi
> >   41: 74 0b                   je     4e <...>
> >   43: b9 48 00 00 00          mov    $0x48,%ecx
> >   48: 31 d2                   xor    %edx,%edx
> >   4a: 89 f8                   mov    %edi,%eax
> >   4c: 0f 30                   wrmsr
> >
> > to:
> >
> >   2d: 48 8b 7c 24 10          mov    0x10(%rsp),%rdi
> >   32: 8b 87 48 18 00 00       mov    0x1848(%rdi),%eax
> >   38: 65 3b 05 00 00 00 00    cmp    %gs:0x0(%rip),%eax
> >   3f: 74 09                   je     4a <...>
> >   41: b9 48 00 00 00          mov    $0x48,%ecx
> >   46: 31 d2                   xor    %edx,%edx
> >   48: 0f 30                   wrmsr
> >
> > No functional change intended.
> >
> > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > ---
> >  arch/x86/kvm/vmx/vmenter.S | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > index 0a6cf5bff2aa..c65de5de92ab 100644
> > --- a/arch/x86/kvm/vmx/vmenter.S
> > +++ b/arch/x86/kvm/vmx/vmenter.S
> > @@ -118,13 +118,11 @@ SYM_FUNC_START(__vmx_vcpu_run)
> >        * and vmentry.
> >        */
> >       mov 2*WORD_SIZE(%_ASM_SP), %_ASM_DI
> > -     movl VMX_spec_ctrl(%_ASM_DI), %edi
> > -     movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
> > -     cmp %edi, %esi
> > +     movl VMX_spec_ctrl(%_ASM_DI), %eax
> > +     cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
>
> Huh.  There's a pre-existing bug lurking here, and in the SVM code.  SPEC=
_CTRL
> is an MSR, i.e. a 64-bit value, but the assembly code assumes bits 63:32 =
are always
> zero.

But MSBs are zero, MSR is defined in arch/x86/include/msr-index.h as:

#define MSR_IA32_SPEC_CTRL 0x00000048 /* Speculation Control */

and "movl $..., %eax" zero-extends the value to full 64-bit width.

FWIW, MSR_IA32_SPEC_CTR is handled in the same way in arch/x86/entry/entry.=
S:

movl $MSR_IA32_PRED_CMD, %ecx

So, the insn is OK when MSR fits 32-bits. The insn is a bit smaller, too:

       movl $0x01, %ecx
       movq $0x01, %rcx

assembles to:

  0:   b9 01 00 00 00          mov    $0x1,%ecx
  5:   48 c7 c1 01 00 00 00    mov    $0x1,%rcx

Rest assured that the assembler checks the immediate when 32-bit
registers are involved, e.g.:

mov.s: Assembler messages:
mov.s:1: Warning: 0xaaaaaaaaaa shortened to 0xaaaaaaaa

Uros.

