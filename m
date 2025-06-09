Return-Path: <kvm+bounces-48747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 292E8AD2560
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 20:16:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC23D16CBD3
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 18:16:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2992121CC6C;
	Mon,  9 Jun 2025 18:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y40lXtWW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12C11BD9F0
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749492984; cv=none; b=TD0gJcQW9hDVJqmIVgHl1onkzKLs6EYyeEupJjfpxkfMcsFY9MZW7TD7xtr3uKKTLZbHp9XyykvTA5n7YmR+k4hdOOb4Z1YCOtuN/MEFfsDLDce8RagxKzAwxXaxH73Ig3fPyj1FbXC3YfHuZ5XhcAabI0Arvl6M4fo+Oj4wSsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749492984; c=relaxed/simple;
	bh=8vWO7A5v+6MgdxNh6sQBELz44kj7FxuJmbGyTiB7w2Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ax79r657/hM0YSnrEz70alFbxE0qGtT7qMSJ45ZsJg+6ao6Cy5Kqbr9j4P4a7jwXnKjLVjW/dISJBK0p0QbAHFSvKcZsOXCy2IQOOXAasJ2+VagTzMqmjLD0t9CHz8SVrt4J5mRopCm8kUseDgIV8JhWy3Po1dZ3qJ+9bQhvVtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y40lXtWW; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6000791e832so1537a12.1
        for <kvm@vger.kernel.org>; Mon, 09 Jun 2025 11:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749492981; x=1750097781; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oYkxLjn61b2SghFSVNz+hqS3VSd2oI4dmt4pvSqHM8U=;
        b=y40lXtWWQY9qBRoNUzJl48Cx36zYDxgbLXl7wnyhDLY44q9fVDxMUau9LoSnHeKKkr
         4LU8t64Zq7/lGa22ssKrzcv3jEvyoa3EK8mD1uuR7GNG4hl7buYhy0QMlIvOKTTfHGNq
         nn6Q36MSqoskcg8WRaaLc5d1cRU4CY4xGXwes6qyXSeA+5Uq3w2399Fg8/i8IbvWQ5wD
         LGoBsMigCGrdcB+x/MZKsIo82zjOxzcaMNsof9i43EMIWeC1j3w+jLWj6FLeJ5zDtpgO
         4I6aQAHNoY76M6Xq9LVJ0cFz6M6USXxrPxquU3tH2sbOKtR6pkoGfPHgwQaEJnwk0Tjk
         ItxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749492981; x=1750097781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oYkxLjn61b2SghFSVNz+hqS3VSd2oI4dmt4pvSqHM8U=;
        b=JaokpZ8knUrTRoebcxcjGKpMSQeKQY56T9MLRxX8Kxj7Do70bQTNn7lww0px3WH2xk
         8LyjQAR3SMO8+cB4+TFvfrDg9s7aZsGi+9H6UDrs0gGZa+3mjDV4kXRLVpZCWA2MYau5
         PVFtiSABmkAvaCy/PPtXydU+Fo0UfnLz48zPY7jc1MvaxdQLHMyjb64EuSOiKUPZxeKx
         jLPhbQUKSKuzec4HQQy02UNFry4AIPvads/VSgPKC+ofRmL3Dznrotocbb6eTF6FYADK
         Z/mhYHsVjFih8vNbY9Vuu4/RLdPj6BqYZXcUWWk3uzhpI4vGrhEFy4br3Otejj/g/5xL
         esHw==
X-Forwarded-Encrypted: i=1; AJvYcCVY5R0tnQHWROV0LOB+CdWhXYAPg254hpDjPXVNgCSM5be4w6yydiAFQtOXWY//yW6KgOY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBtB9pOL6X+nK4P+Tqc+cxoided3zP6XzSIKEFakds7tmGsWo4
	/C2oKjOcA0eVEA83OfnmXBQ2IOwK9jpnOxOz8ppyeqFJ2kTxacZNeRp7x2isrNlUFRsotiQTf83
	Z4Ha/+Ph2NnfpmS+Wy7yhKdmZXwEOQlP4yKPanYLW
X-Gm-Gg: ASbGnctzCSLOHJ9dl+kbnlX1DbK7P4wkxxlcwGB9ZhMTRK+qmGSh01xtyI0uGlzt+k5
	I7whlCtrBj5y94OAJDMZmeL1MgOuS1wj+nBzHdBPC4Fk52kD/8WO/0JMfxt50Z4EEdA8yaTAJ8T
	mN5vjEJEkXMOW6O9OsHZtqEK+E9mW87F4gWjh15ncIf3o=
X-Google-Smtp-Source: AGHT+IGl1GhUW5I8KeyIhe30RLYNUE0AclIq68sDRcY3/pkUWT0ma5zJRYH9NIn4KxCiDUzu5GNxbNFmNL+XbWxUW78=
X-Received: by 2002:a50:d756:0:b0:608:203f:196f with SMTP id
 4fb4d7f45d1cf-608203f1a64mr4016a12.3.1749492980731; Mon, 09 Jun 2025 11:16:20
 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20211207095230.53437-1-jiangshanlai@gmail.com>
 <51bb6e75-4f0a-e544-d2e4-ff23c5aa2f49@redhat.com> <4a66adfa-fc10-4668-9986-55f6cf231988@zytor.com>
 <aEbuSmAf4aAHztwC@google.com>
In-Reply-To: <aEbuSmAf4aAHztwC@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 9 Jun 2025 11:16:08 -0700
X-Gm-Features: AX0GCFsJwyV-ZLeMzaw3jddTz_eVE6C2E36fVcqLczw7JomWy3wX466MFUhrcy4
Message-ID: <CALMp9eSA0u5+_dPA7-M4oZgqt4sv-qez4fMuZ6S5X4rUp=33xQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Raise #GP when clearing CR0_PG in 64 bit mode
To: Sean Christopherson <seanjc@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Lai Jiangshan <jiangshanlai@gmail.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Lai Jiangshan <laijs@linux.alibaba.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Joerg Roedel <joro@8bytes.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 9, 2025 at 7:23=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Fri, Jun 06, 2025, H. Peter Anvin wrote:
> > On 2021-12-09 09:55, Paolo Bonzini wrote:
> > > On 12/7/21 10:52, Lai Jiangshan wrote:
> > > > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > > >
> > > > In the SDM:
> > > > If the logical processor is in 64-bit mode or if CR4.PCIDE =3D 1, a=
n
> > > > attempt to clear CR0.PG causes a general-protection exception (#GP)=
.
> > > > Software should transition to compatibility mode and clear CR4.PCID=
E
> > > > before attempting to disable paging.
> > > >
> > > > Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> > > > ---
> > > >   arch/x86/kvm/x86.c | 3 ++-
> > > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > index 00f5b2b82909..78c40ac3b197 100644
> > > > --- a/arch/x86/kvm/x86.c
> > > > +++ b/arch/x86/kvm/x86.c
> > > > @@ -906,7 +906,8 @@ int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned
> > > > long cr0)
> > > >           !load_pdptrs(vcpu, kvm_read_cr3(vcpu)))
> > > >           return 1;
> > > > -    if (!(cr0 & X86_CR0_PG) && kvm_read_cr4_bits(vcpu, X86_CR4_PCI=
DE))
> > > > +    if (!(cr0 & X86_CR0_PG) &&
> > > > +        (is_64_bit_mode(vcpu) || kvm_read_cr4_bits(vcpu,
> > > > X86_CR4_PCIDE)))
> > > >           return 1;
> > > >       static_call(kvm_x86_set_cr0)(vcpu, cr0);
> > > >

Isn't this redundant with the "if (cs_l)" check above?

> > > Queued, thanks.
> > >
> >
> > Have you actually checked to see what real CPUs do in this case?
>
> I have now, and EMR at least behaves as the SDM describes.  Why do you as=
k?
>
>
> kvm_intel: Clearing CR0.PG faulted (vector =3D 13)
>
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f79604bc0127..f90ad464ab7e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -8637,6 +8637,23 @@ void vmx_exit(void)
>         kvm_x86_vendor_exit();
>  }
>
> +static noinline void vmx_disable_paging(void)
> +{
> +       unsigned long cr0 =3D native_read_cr0();
> +       long vector =3D -1;
> +
> +       asm volatile("1: mov %1, %%cr0\n\t"
> +                    "   mov %2, %%cr0\n\t"
> +                    "2:"
> +                    _ASM_EXTABLE_FAULT(1b, 2b)
> +                    : "+a" (vector)
> +                    : "r" (cr0 & ~X86_CR0_PG), "r" (cr0)
> +                    : "cc", "memory" );
> +
> +       pr_warn("Clearing CR0.PG %s (vector =3D %ld)\n",
> +               vector < 0 ? "succeeded" : "faulted", vector);
> +}
> +
>  int __init vmx_init(void)
>  {
>         int r, cpu;
> @@ -8644,6 +8661,8 @@ int __init vmx_init(void)
>         if (!kvm_is_vmx_supported())
>                 return -EOPNOTSUPP;
>
> +       vmx_disable_paging();
> +
>         /*
>          * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's not=
hing
>          * to unwind if a later step fails.
>

