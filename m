Return-Path: <kvm+bounces-56910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77007B463B8
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:35:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F403D7A9EEF
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 19:33:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADABD27FD49;
	Fri,  5 Sep 2025 19:35:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b="HTYXz0D5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CD027B337
	for <kvm@vger.kernel.org>; Fri,  5 Sep 2025 19:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757100903; cv=none; b=uOlGRWXtqJ0aNGMjIJ8JtguVgZFUeKkUAHSKWICIoE6tfvod+JR0ca0EAFeFO/8xFevIarm55zHJTPgt2f7uqVgT2n+gOnJTXMFxjkYMyQb6TpfQYUKHfiKUu4FLdrLfQ2Ynf6ij++JZnxeNuWx8DxRxeGpbIs4OkIdbxwugzfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757100903; c=relaxed/simple;
	bh=Rvh7ciEHXfbDCfD3pPj8ITD6aqCcBeE2e4ML36hIwPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N7PLIsa9vYYkwHTkWgvhP769AU9BAPGhhCcVhTB4Sg9lW06hXvAL2TYZ2lnRB0n0SBbL0+f3CtzjvKRXLpdCGf2wuY80kM5OSWwyTzhqfh91v03MsN/MANkAn0Ew8C49c9jAHkD3j4aponxWL5dNYZgqFnFKOEdFO6yWBxcyibo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc.com header.i=@rivosinc.com header.b=HTYXz0D5; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4c29d2ea05so2567962a12.0
        for <kvm@vger.kernel.org>; Fri, 05 Sep 2025 12:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1757100901; x=1757705701; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f9FAMAwKb9GlFbqFePz07zPDAIQCDZGG7K5Xfr8FjoY=;
        b=HTYXz0D5n3RJV9jFHxbbMOvZiXrwbZs7v24wt02xOQn+hyFZd1zYqFJ8g7O7J6ujBY
         5SXH2UR/p78yQEjh8+G2EI5eF18jPn+OTZGhT8iFtD+VygbwWsgtdjIj70e7rRhg+QGB
         Jf19VloVJPcf0NQKztSH46h+52AXJTkCrMKjcGL3iJkoMnukxlJ26jwLWjyNW0JUdkr4
         EJrKZNP1Mwpf10qkCu2fzBV3KubJmzJk2ewum1ws/W6OXWBTh82wL78ulQC/tJHfQOnV
         Pgo1CissXP64EC6/4YROCZtUWxKO+kK+NrgDf7Mm/XaeO+EL5OUMydl2FayamaeasTwZ
         UYtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757100901; x=1757705701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f9FAMAwKb9GlFbqFePz07zPDAIQCDZGG7K5Xfr8FjoY=;
        b=PcBv3/cp3EScUlMDOcLz7S3dioUtPtbF7BL8txyxP4qtFXzDXR2lmzTGO/3PFCMC4M
         VyXm0l8Y3t6colUOaEUZnu4/Hl0hQsh3oOmAkjvxsgVTWZ9fD3rALXxJMobeu2hP/CTe
         b2t+oZbYv0nPT9rSypLw2JiB2xr1q8rIfQUt6SHrVjqeOb71LdoW7VB+oYfS+mpBBigv
         1MGiSIaks2+fb3k5wYAWKKa3SNyPzGO1ZEAsprnW/SULkgJDu2U4DUlY9KiAxwx5Wv3X
         CCm6bzM5km61DT9aIX2aVdBMc/cvWB8hoaxWjpM4XEseKEA8NpbYJFso+6ihWQ6J3irH
         dx9g==
X-Forwarded-Encrypted: i=1; AJvYcCVI208tqAl5xAsrJ+Sjc9jkYmzKDEmPi/tRfOkmBW8gGnbxZnuW+QGqyU110Mit7g0+Txs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlFQ1c3fpPaEgogjrwYryooA/YkGzJ3zWuW0/i7aucaAceuIxd
	93CthrGQsr9qum9YWG8jiyNG1o+/jTbxvra6Hlwcyi95DlxkQaiWCO7saRH2ncrEIoiLSXeZTT2
	Jz7VP2RqoDg97V6L1YoxDzq0BkT5CdVPa5s1KeJfdEA==
X-Gm-Gg: ASbGncuC6jMn0xjsCTDxzBMyk6WbKSr0LG2EVxpbcF8vhwguOiWucQXMCGLLZCh03VH
	WoWegj+8lAcbBtmVF5/9mJBuVAItzEAQMbjTBnpAxQBkj4K6m18ul4EQAGWWd2h7O9wmVRsCJxc
	IiZnOa7mPz8b5R5x6zuZUs/L6FW8zmZHDXhee7SxC7CrMj4hwgjFrvM4VWG+KWRTY6D3za3GGiv
	VSVwaWYTyJx0e/zcc7cbjbp1zhypw==
X-Google-Smtp-Source: AGHT+IHqWqyZqFIuzyIZvE/SUKQfYYN6g516wmc4GuFbgQsfUPht0NsXKsfItF2EyucT/HQ/Jt/iNNsDf0c9xrLH2sg=
X-Received: by 2002:a17:90b:3c44:b0:32b:6223:262 with SMTP id
 98e67ed59e1d1-32bbcb945aemr5935479a91.3.1757100901459; Fri, 05 Sep 2025
 12:35:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250829-pmu_event_info-v5-0-9dca26139a33@rivosinc.com>
 <20250829-pmu_event_info-v5-6-9dca26139a33@rivosinc.com> <aLIR3deQPxVI2VrE@google.com>
 <CAHBxVyHFkNtFdX-vciPvYnTOH=GXvHVW7hjFrLA4MFr9wqWVvQ@mail.gmail.com> <aLqd9bKB6ucarR3e@google.com>
In-Reply-To: <aLqd9bKB6ucarR3e@google.com>
From: Atish Kumar Patra <atishp@rivosinc.com>
Date: Fri, 5 Sep 2025 12:34:48 -0700
X-Gm-Features: Ac12FXzDuYbaevvtu1cjWIBdIgE-JZvhAwCG0_v0qb1Ic8gyKF3DjAY5IEIX5wM
Message-ID: <CAHBxVyE7Tp97GfbH=deaA7gqWQXByno3O3OHbHDJCJ=J7FUQvw@mail.gmail.com>
Subject: Re: [PATCH v5 6/9] KVM: Add a helper function to check if a gpa is in
 writable memselot
To: Sean Christopherson <seanjc@google.com>
Cc: Anup Patel <anup@brainfault.org>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Mayuresh Chitale <mchitale@ventanamicro.com>, 
	linux-riscv@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 5, 2025 at 1:23=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Wed, Sep 03, 2025, Atish Kumar Patra wrote:
> > On Fri, Aug 29, 2025 at 1:47=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > >
> > > On Fri, Aug 29, 2025, Atish Patra wrote:
> > > > +static inline bool kvm_is_gpa_in_writable_memslot(struct kvm *kvm,=
 gpa_t gpa)
> > > > +{
> > > > +     bool writable;
> > > > +     unsigned long hva =3D gfn_to_hva_prot(kvm, gpa_to_gfn(gpa), &=
writable);
> > > > +
> > > > +     return !kvm_is_error_hva(hva) && writable;
> > >
> > > I don't hate this API, but I don't love it either.  Because knowing t=
hat the
> > > _memslot_ is writable doesn't mean all that much.  E.g. in this usage=
:
> > >
> > >         hva =3D kvm_vcpu_gfn_to_hva_prot(vcpu, shmem >> PAGE_SHIFT, &=
writable);
> > >         if (kvm_is_error_hva(hva) || !writable)
> > >                 return SBI_ERR_INVALID_ADDRESS;
> > >
> > >         ret =3D kvm_vcpu_write_guest(vcpu, shmem, &zero_sta, sizeof(z=
ero_sta));
> > >         if (ret)
> > >                 return SBI_ERR_FAILURE;
> > >
> > > the error code returned to the guest will be different if the memslot=
 is read-only
> > > versus if the VMA is read-only (or not even mapped!).  Unless every r=
ead-only
> > > memslot is explicitly communicated as such to the guest, I don't see =
how the guest
> > > can *know* that a memslot is read-only, so returning INVALID_ADDRESS =
in that case
> > > but not when the underlying VMA isn't writable seems odd.
> > >
> > > It's also entirely possible the memslot could be replaced with a read=
-only memslot
> > > after the check, or vice versa, i.e. become writable after being reje=
cted.  Is it
> > > *really* a problem to return FAILURE if the guest attempts to setup s=
teal-time in
> > > a read-only memslot?  I.e. why not do this and call it good?
> > >
> >
> > Reposting the response as gmail converted my previous response as
> > html. Sorry for the spam.
> >
> > From a functionality pov, that should be fine. However, we have
> > explicit error conditions for read only memory defined in the SBI STA
> > specification[1].
> > Technically, we will violate the spec if we return FAILURE instead of
> > INVALID_ADDRESS for read only memslot.
>
> But KVM is already violating the spec, as kvm_vcpu_write_guest() redoes t=
he
> memslot lookup and so could encounter a read-only memslot (if it races wi=
th
> a memslot update), and because the underlying memory could be read-only e=
ven if
> the memslot is writable.
>

Ahh. Thanks for clarifying that.

> Why not simply return SBI_ERR_INVALID_ADDRESS on kvm_vcpu_write_guest() f=
ailure?
> The only downside of that is KVM will also return SBI_ERR_INVALID_ADDRESS=
 if the
> userspace mapping is completely missing, but AFAICT that doesn't seem to =
be an
> outright spec violation.

Yes. That's correct. That can still be considered as invalid address.
I will revise the patch according to this.
Thanks for the suggestions.

