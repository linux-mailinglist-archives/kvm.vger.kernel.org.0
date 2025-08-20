Return-Path: <kvm+bounces-55122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3D05B2DBAF
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 13:51:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ED3A686C83
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 11:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C392E5B30;
	Wed, 20 Aug 2025 11:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHDENDM6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8442219E8D;
	Wed, 20 Aug 2025 11:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755690668; cv=none; b=G4RHrN7Tdc6tu9wa+teo3wxlYlkjr6/8BcFdJgtB8txvy/iMkHGbXvErT8n4exJFOfw/itblm86sDTN9U5NjFyz5h9JvbDcXObduZYtPKa6MVCvS2gb0THyATiIHPVggZp6cnRx9E01w3iHR0gJyYyEWMve+ZoI6zq2JqJCVBY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755690668; c=relaxed/simple;
	bh=mM1t4tfBPBFWnKH3sCszk6wmzScBVr0bXGadJJjXe1g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cD7/DbRV9IOAbwxhYUB49Tqfwam0jcOEr55Pzu2kDPYViy1VWUfe/VLxnAcV/HZkSwsH/D2iu6bXDA/21u+OTL37iG1RJLriJv+zKv4E8BRDvjf4zZ2RXqwGvCeDcra+/be8cOON/HI5d1C0TKZH0EmFB6MxFcbtrOair6nfCGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FHDENDM6; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-333f9160c2dso50160591fa.2;
        Wed, 20 Aug 2025 04:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755690665; x=1756295465; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j8CUPaKjoMF0bQe6qKjXP3wiRTAOWVeiWWdsn2QC5Fk=;
        b=FHDENDM6CmFzIhQdPw3FM6J3sp9difSEQegoyL3J8Z152ZmUdYjziYOwfd7RwghAii
         A91UnjBJkMdSM+Bf44Lb24HyoOz0rairFzaZr8nB1V5Lj4DFnWjLb5zHAqjh/P1IM7uB
         OFUxou48FEygKCmzXfNljoezY9yFQ86EvAza9A4fayBBG+IZCkQ8Dves8MzgZFZG4PFi
         7FnNuxwfBmPBx+/7kagVou4MjJwfxvm501pG2Vm/VSC4v9Oferjy6EvkfseynZcfyWbz
         79cHB1aJu3k2cwA6eMXUxcuCGhWDZ7PYU8UFtKaq1ADitLZULplpplimXFMm++UhnCGR
         2Ajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755690665; x=1756295465;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j8CUPaKjoMF0bQe6qKjXP3wiRTAOWVeiWWdsn2QC5Fk=;
        b=Q4FmyP1iJDIHHuCGSzeAznynPVyJGzzuYuXFG3tvTCBe48rCBg5Q67bvw0vGC0EFu2
         gwWdYnP0lw4NZeil6gt8ftpLG0BYapg63q6IPfiMYaHsbvaawQVVjvAB3F8B44qlcp5x
         2/Z4D3sqKDrw2fRq1CGMD4sIbr49GmoobXlw62RetZ45G0dyxhA5bOBbs16MOROYojXX
         JtFwM6y/82xAi92rFPrVMXuIL7DfyV2eP2b643Xxv0hxD44+67u4JC66tQ8frm9xTJKB
         xMc5M4EVXq02wkcMpydqEWmBIiuekaI0tIdN5Trrl0+URq16IfjsAh/1+fJKHDBgjt9m
         e0/g==
X-Forwarded-Encrypted: i=1; AJvYcCV654sFlmQ7iDomKcWFvAdYkCEK70Zp9vi1bvtT/ur3EZEbSixQiJo88ZIqNP+DV5i62OJhCAciDoU6JNU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtjhKGxSLvJtTJLtiCN/bWPMIxnz9Oh6KDDmjIut6QWO1bNyPL
	HIA//a1ymNhbheEvhb5StRrDSIR4vtwd7tdyU7g/pa+sfHZZiKnK0v1TY/RxH/UuqfnuBhNxIHc
	Xa0gDrsLSxOHv5m863zz6f+oSvZkbN0A=
X-Gm-Gg: ASbGnctyPTCK+0vsgRRzprH6srRHfTaeK76oZL0G7Isjky2JCL32y95Kadkc/GDW66y
	dToX03nHq2xmFVvGiVsmfZqWOb9BHFbyzK4ocsF5VUOtkSRCEh3SLEQ0tZADHRt8ny1q6kqe39o
	k/Z8aoOr8s2sFxxlvyRQaCzfB9fNZjE62AL047s6AMSzeFvtcjZBH6KY/GcA1bb+eqTdRSd6Erm
	tSF80SvTJCP18mq8Q==
X-Google-Smtp-Source: AGHT+IEjk8aFwViddVeiYetn1F0nqi4gOMp5iMBaGUAKHDxfVcJ9sF+IXMSTX4bDTMAifJvyt1LlSRxW/lO+GSyujlo=
X-Received: by 2002:a05:651c:20da:20b0:32a:6e77:3e57 with SMTP id
 38308e7fff4ca-3353bd0b03fmr4214141fa.21.1755690664554; Wed, 20 Aug 2025
 04:51:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250807063733.6943-1-ubizjak@gmail.com> <aKSRbjgtp7Nk8-sb@google.com>
 <CAFULd4ZOtj7WZkSSKqLjxCJ-yBr20AYrqzCpxj2K_=XmrX1QZg@mail.gmail.com>
 <aKTI1WOJAKDnkRyu@google.com> <CAFULd4ZR6TPVqq5TXToR-0HbX5oM=NEdw126kcDe5LNDdxZ++w@mail.gmail.com>
In-Reply-To: <CAFULd4ZR6TPVqq5TXToR-0HbX5oM=NEdw126kcDe5LNDdxZ++w@mail.gmail.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Wed, 20 Aug 2025 13:50:52 +0200
X-Gm-Features: Ac12FXwM4r0VM4PeYtOjk4oVkgcC5l0WbOqOjYiF6Ll4i4RcFoh7XZhbMDYvS_8
Message-ID: <CAFULd4Y6W0hJbA8Ki2yB60537mC8+ohXyUgxD+HuKDQhq7zGmA@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Micro-optimize SPEC_CTRL handling in __vmx_vcpu_run()
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: multipart/mixed; boundary="000000000000658f3f063cca963c"

--000000000000658f3f063cca963c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 8:10=E2=80=AFAM Uros Bizjak <ubizjak@gmail.com> wro=
te:
>
> On Tue, Aug 19, 2025 at 8:56=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Tue, Aug 19, 2025, Uros Bizjak wrote:
> > > > >   2d: 48 8b 7c 24 10          mov    0x10(%rsp),%rdi
> > > > >   32: 8b 87 48 18 00 00       mov    0x1848(%rdi),%eax
> > > > >   38: 65 3b 05 00 00 00 00    cmp    %gs:0x0(%rip),%eax
> > > > >   3f: 74 09                   je     4a <...>
> > > > >   41: b9 48 00 00 00          mov    $0x48,%ecx
> > > > >   46: 31 d2                   xor    %edx,%edx
> > > > >   48: 0f 30                   wrmsr
> > > > >
> > > > > No functional change intended.
> > > > >
> > > > > Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> > > > > Cc: Sean Christopherson <seanjc@google.com>
> > > > > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > > > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > > > Cc: Ingo Molnar <mingo@kernel.org>
> > > > > Cc: Borislav Petkov <bp@alien8.de>
> > > > > Cc: Dave Hansen <dave.hansen@linux.intel.com>
> > > > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > > > ---
> > > > >  arch/x86/kvm/vmx/vmenter.S | 6 ++----
> > > > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > > >
> > > > > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmente=
r.S
> > > > > index 0a6cf5bff2aa..c65de5de92ab 100644
> > > > > --- a/arch/x86/kvm/vmx/vmenter.S
> > > > > +++ b/arch/x86/kvm/vmx/vmenter.S
> > > > > @@ -118,13 +118,11 @@ SYM_FUNC_START(__vmx_vcpu_run)
> > > > >        * and vmentry.
> > > > >        */
> > > > >       mov 2*WORD_SIZE(%_ASM_SP), %_ASM_DI
> > > > > -     movl VMX_spec_ctrl(%_ASM_DI), %edi
> > > > > -     movl PER_CPU_VAR(x86_spec_ctrl_current), %esi
> > > > > -     cmp %edi, %esi
> > > > > +     movl VMX_spec_ctrl(%_ASM_DI), %eax
> > > > > +     cmp PER_CPU_VAR(x86_spec_ctrl_current), %eax
> > > >
> > > > Huh.  There's a pre-existing bug lurking here, and in the SVM code.=
  SPEC_CTRL
> > > > is an MSR, i.e. a 64-bit value, but the assembly code assumes bits =
63:32 are always
> > > > zero.
> > >
> > > But MSBs are zero, MSR is defined in arch/x86/include/msr-index.h as:
> > >
> > > #define MSR_IA32_SPEC_CTRL 0x00000048 /* Speculation Control */
> > >
> > > and "movl $..., %eax" zero-extends the value to full 64-bit width.
> > >
> > > FWIW, MSR_IA32_SPEC_CTR is handled in the same way in arch/x86/entry/=
entry.S:
> > >
> > > movl $MSR_IA32_PRED_CMD, %ecx
> >
> > That's the MSR index, not the value.  I'm pointing out that:
> >
> >         movl VMX_spec_ctrl(%_ASM_DI), %edi              <=3D=3D drops v=
mx->spec_ctrl[63:32]
> >         movl PER_CPU_VAR(x86_spec_ctrl_current), %esi   <=3D=3D drop x8=
6_spec_ctrl_current[63:32]
> >         cmp %edi, %esi                                  <=3D=3D can get=
 false negatives
> >         je .Lspec_ctrl_done
> >         mov $MSR_IA32_SPEC_CTRL, %ecx
> >         xor %edx, %edx                                  <=3D=3D can clo=
bber guest value
> >         mov %edi, %eax
> >         wrmsr
> >
> > The bug is _currently_ benign because neither KVM nor the kernel suppor=
t setting
> > any of bits 63:32, but it's still a bug that needs to be fixed.
>
> Oh, I see it. Let me try to fix it in a new patch.

VMX patch is at [1]. SVM patch is a bit more involved, because new
32-bit code needs to clobber one additional register. The SVM patch is
attached to this message, but while I compile tested it, I have no
means of testing it with runtime tests. Can you please put it through
your torture tests?

[1] https://lore.kernel.org/lkml/20250820100007.356761-1-ubizjak@gmail.com/

Uros.

--000000000000658f3f063cca963c
Content-Type: text/plain; charset="US-ASCII"; name="svm-vmenter.diff.txt"
Content-Disposition: attachment; filename="svm-vmenter.diff.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mejwvf7s0>
X-Attachment-Id: f_mejwvf7s0

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9zdm0vdm1lbnRlci5TIGIvYXJjaC94ODYva3ZtL3N2
bS92bWVudGVyLlMKaW5kZXggMjM1YzRhZjZiNjkyLi5hMWI5ZjJhYzcxM2MgMTAwNjQ0Ci0tLSBh
L2FyY2gveDg2L2t2bS9zdm0vdm1lbnRlci5TCisrKyBiL2FyY2gveDg2L2t2bS9zdm0vdm1lbnRl
ci5TCkBAIC01MiwxMSArNTIsMjMgQEAKIAkgKiB0aGVyZSBtdXN0IG5vdCBiZSBhbnkgcmV0dXJu
cyBvciBpbmRpcmVjdCBicmFuY2hlcyBiZXR3ZWVuIHRoaXMgY29kZQogCSAqIGFuZCB2bWVudHJ5
LgogCSAqLwotCW1vdmwgU1ZNX3NwZWNfY3RybCglX0FTTV9ESSksICVlYXgKLQljbXAgUEVSX0NQ
VV9WQVIoeDg2X3NwZWNfY3RybF9jdXJyZW50KSwgJWVheAorI2lmZGVmIENPTkZJR19YODZfNjQK
Kwltb3YgU1ZNX3NwZWNfY3RybCglcmRpKSwgJXJkeAorCWNtcCBQRVJfQ1BVX1ZBUih4ODZfc3Bl
Y19jdHJsX2N1cnJlbnQpLCAlcmR4CisJamUgODAxYgorCW1vdmwgJWVkeCwgJWVheAorCXNociAk
MzIsICVyZHgKKyNlbHNlCisJbW92IFNWTV9zcGVjX2N0cmwoJWVkaSksICVlYXgKKwltb3YgUEVS
X0NQVV9WQVIoeDg2X3NwZWNfY3RybF9jdXJyZW50KSwgJWVjeAorCXhvciAlZWF4LCAlZWN4CisJ
bW92IFNWTV9zcGVjX2N0cmwgKyA0KCVlZGkpLCAlZWR4CisJbW92IFBFUl9DUFVfVkFSKHg4Nl9z
cGVjX2N0cmxfY3VycmVudCArIDQpLCAlZXNpCisJeG9yICVlZHgsICVlc2kKKwlvciAlZXNpLCAl
ZWN4CiAJamUgODAxYgorI2VuZGlmCiAJbW92ICRNU1JfSUEzMl9TUEVDX0NUUkwsICVlY3gKLQl4
b3IgJWVkeCwgJWVkeAogCXdybXNyCiAJam1wIDgwMWIKIC5lbmRtCkBAIC04MCwxNCArOTIsMzEg
QEAKIAljbXBiICQwLCBcc3BlY19jdHJsX2ludGVyY2VwdGVkCiAJam56IDk5OGYKIAlyZG1zcgot
CW1vdmwgJWVheCwgU1ZNX3NwZWNfY3RybCglX0FTTV9ESSkKKyNpZmRlZiBDT05GSUdfWDg2XzY0
CisJc2hsICQzMiwgJXJkeAorCW9yICVyYXgsICVyZHgKKwltb3YgJXJkeCwgU1ZNX3NwZWNfY3Ry
bCglcmRpKQogOTk4OgotCiAJLyogTm93IHJlc3RvcmUgdGhlIGhvc3QgdmFsdWUgb2YgdGhlIE1T
UiBpZiBkaWZmZXJlbnQgZnJvbSB0aGUgZ3Vlc3Qncy4gICovCi0JbW92bCBQRVJfQ1BVX1ZBUih4
ODZfc3BlY19jdHJsX2N1cnJlbnQpLCAlZWF4Ci0JY21wIFNWTV9zcGVjX2N0cmwoJV9BU01fREkp
LCAlZWF4CisJbW92IFNWTV9zcGVjX2N0cmwoJXJkaSksICVyZHgKKwljbXAgUEVSX0NQVV9WQVIo
eDg2X3NwZWNfY3RybF9jdXJyZW50KSwgJXJkeAogCWplIDkwMWIKLQl4b3IgJWVkeCwgJWVkeAor
CW1vdmwgJWVkeCwgJWVheAorCXNociAkMzIsICVyZHgKKyNlbHNlCisJbW92ICVlYXgsIFNWTV9z
cGVjX2N0cmwoJWVkaSkKKwltb3YgJWVkeCwgU1ZNX3NwZWNfY3RybCArIDQoJWVkaSkKKzk5ODoK
KwkvKiBOb3cgcmVzdG9yZSB0aGUgaG9zdCB2YWx1ZSBvZiB0aGUgTVNSIGlmIGRpZmZlcmVudCBm
cm9tIHRoZSBndWVzdCdzLiAgKi8KKwltb3YgU1ZNX3NwZWNfY3RybCglZWRpKSwgJWVheAorCW1v
diBQRVJfQ1BVX1ZBUih4ODZfc3BlY19jdHJsX2N1cnJlbnQpLCAlZXNpCisJeG9yICVlYXgsICVl
c2kKKwltb3YgU1ZNX3NwZWNfY3RybCArIDQoJWVkaSksICVlZHgKKwltb3YgUEVSX0NQVV9WQVIo
eDg2X3NwZWNfY3RybF9jdXJyZW50ICsgNCksICVlZGkKKwl4b3IgJWVkeCwgJWVkaQorCW9yICVl
ZGksICVlc2kKKwlqZSA5MDFiCisjZW5kaWYKIAl3cm1zcgogCWptcCA5MDFiCiAuZW5kbQo=
--000000000000658f3f063cca963c--

