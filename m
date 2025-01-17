Return-Path: <kvm+bounces-35709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DD95A14721
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 01:54:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EB7A16AC79
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 00:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784FC25A65E;
	Fri, 17 Jan 2025 00:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3E7qzQbk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2354D25A651
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 00:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737075243; cv=none; b=P9L7eH26gMRdGcN7VSoxAP3h7brJGZfjxv9zOxhAp0FTAnALkUeANKmyM30ffFRE5IQng078Z/WPl5bRk1syrm8jPSY4jdRLSpi/IceZ6dcnZ661qrqkDehvjAgaLHANdtW6d01czFMDm0okCd32dNb6rNo/bmMoTzdFNOUt2a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737075243; c=relaxed/simple;
	bh=nEvu+RJlYMta4LLnv7Ivi6RL0Xh/LnZRzD0/8jYQ9rM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DL+5cNqBjxVbGhDXglszxxS6kLrdPhSf6IWEYrZU0n16NbJQZ2NU7bnLWjt+6uq3cnN699R63ynGMFDRUTAnsXx55I6LNwvlUP3Yjk09G6Zv+QKpnGm+ibf34CaFS4driFtQShmmzOOVdEZsZIMQIgVkPnnpZ/F4UWmQXRGA70g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3E7qzQbk; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6dd5c544813so17729946d6.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 16:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737075241; x=1737680041; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4WSBz9Q9l3Yk/OuyDuMnXxpOW6khXlgNXDVr3XjCu5M=;
        b=3E7qzQbkLDFcATqjiRiRj3uElQlVWO2IMxNVEtdqDUaxMIvcfe6O0PD+9333K1iVoX
         xFal8AIKPyn9FLPesm5iiN3eaYPXJryEUEcDRQ/YadsGrpcwjvB2jFsFmTe2+SWYS7re
         4dw1fi58AAR7ks0G/lrlrxjNxI/aS0VdSnxsb2fsU7gm2UKy32vLB1ADDlNePMQS/UNq
         fMePd7PqJlaTeHmhZ/CwurGGkdCfADDweYzyJtgyqMJqvppYms2UlSlEigo4VeeezOYe
         ckkAl2rstMgZ9yDFXpLDAQ/CrT6NUt1wo6YID6ULH/jKYw6oP/ytBdbt2XzpucULOcj3
         eWBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737075241; x=1737680041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4WSBz9Q9l3Yk/OuyDuMnXxpOW6khXlgNXDVr3XjCu5M=;
        b=DPPi3UTwR0Sw7n8fkof1DtGTwGATx497IXILJ/4ZpW6fgzhbhb+aXIYAq4guw/xQSF
         EcD2ekGUJkPYAJ7pzU0mK6oe80IJvq5V2gcJhtw7qGPjQwZjDi8m1UG87lxwfpb/WHVl
         Gw2xyk894cBG2z6Gnj4+LfZIR8gt8GDVMnJsquAmBDAv2/KK7Tokvrteja6+lF4YUwJd
         H+76WOlfIbNaEuBdaf+basAV5bJM6s+orEBEJeQZeJ5zDOlaxVPNXNS9sNNHuAbZDIkE
         ++a344sye6ui/XBIOJINNXmt9ZnjyDL62xnP++9NbhDU0xowT8xuoPscLOCAbfu63TrB
         E4cw==
X-Forwarded-Encrypted: i=1; AJvYcCUL+/8OhnJ65WPXltLGPCHH91il1sEsgkxbbwZMbl6k3158lnOdbqG3pG6aTYTV7bJeyEw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxe1w6TM5c8qoSBptrnsWINhwn69/HAcyanFSkTLXcd6GxuqjQC
	1aBaCtN8soCAxmEe5b2yNTc9Xmaamj1ChQY/59XvNePVSkI0MFqcxpE4oi2p9H//Z+ZImf8uAKw
	mk3srEtOBlwXfgPO2novgjU+NlrM6pSpH8owU
X-Gm-Gg: ASbGnctpGIwKGDK1lpBzNfwqsZGsnV+iBmQnMfg7B0ayaZxQb9wY2ALiE9X+P4LJcHp
	CbsxGMonc4GJdS18tUDbwNUCimREH1baLkmM=
X-Google-Smtp-Source: AGHT+IEnCHL1tFgdLJaj5SjMzVOuYSlEg2sX+N9kEAsqAZWeR73Qx+EKl01CON9Zol/U7m6Ej1yjEvin4fEV665jsJE=
X-Received: by 2002:a05:6214:caf:b0:6e0:86ab:4b46 with SMTP id
 6a1803df08f44-6e1b220e1cdmr14099456d6.31.1737075240875; Thu, 16 Jan 2025
 16:54:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116035008.43404-1-yosryahmed@google.com> <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
 <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com>
 <Z4k9seeAK09VAKiz@google.com> <CAJD7tkZQQUqh1GG5RpfYFT4-jK-CV7H+z9p2rTudLsrBe3WgbA@mail.gmail.com>
 <Z4mJpu3MvBeL4d1Q@google.com> <CAJD7tkbqxXQVd5s7adVqzdLBP22ef2Gs+R-SxuM7GtmetaWN+Q@mail.gmail.com>
 <Z4mlsr-xJnKxnDKc@google.com>
In-Reply-To: <Z4mlsr-xJnKxnDKc@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 16 Jan 2025 16:53:24 -0800
X-Gm-Features: AbW1kvbMykqPB09tGCAbhPKmQg47K9MzmDuNgYIvqDvXOLMlVVyT7vUlYluuVHo
Message-ID: <CAJD7tkahmyjXvwKO2=EfQRWu_BHPJ-8+eSEteZH5TGG3+jHtWw@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025 at 4:35=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> > On Thu, Jan 16, 2025 at 2:35=E2=80=AFPM Sean Christopherson <seanjc@goo=
gle.com> wrote:
> > > How about:
> > >
> > >          * Note, only the hardware TLB entries need to be flushed, as=
 VPID is
> > >          * fully enabled from L1's perspective, i.e. there's no archi=
tectural
> > >          * TLB flush from L1's perspective.
> >
> > I hate to bikeshed, but I want to explicitly call out that we do not
> > need to synchronize the MMU.
>
> Why?  Honest question, I want to understand what's unclear.  My hesitatio=
n to
> talk about synchronizing MMUs is that it brings things into play that are=
n't
> super relevant to this specific code, and might even add confusion.  Spec=
ifically,
> kvm_vcpu_flush_tlb_guest() does NOT synchronize MMUs when EPT/TDP is enab=
led, but
> the fact that this path is reachable if and only if EPT is enabled is com=
pletely
> coincidental.

Personally, the main thing that was unclear to me and I wanted to add
a comment to clarify was why we use KVM_REQ_TLB_FLUSH_GUEST in the
first two cases but KVM_REQ_TLB_FLUSH_CURRENT in the last one.

Here's my understanding:

In the first case (i.e. !nested_cpu_has_vpid(vmcs12)), the flush is
architecturally required from L1's perspective to we need to flush
guest-generated TLB entries (and potentially synchronize KVM's MMU).

In the second case, KVM does not track the history of VPID12, so the
flush *may* be architecturally required from L1's perspective, so we
do the same thing.

In the last case though, the flush is NOT architecturally required
from L1's perspective, it's just an artifact of KVM's potential
failure to allocate a dedicated VPID for L2 despite L1 asking for it.

So ultimately, I don't want to specifically call out synchronizing
MMUs, as much as I want to call out why this case uses
KVM_REQ_TLB_FLUSH_CURRENT and not KVM_REQ_TLB_FLUSH_GUEST like the
others. I only suggested calling out the MMU synchronization since
it's effectively the only difference between the two in this case.

I am open to any wording you think is best. I am also fine with just
dropping this completely, definitely not the hill to die on :)

>
> E.g. very hypothetically, if KVM used the same EPT root (I already forgot=
 Intel's
> new acronym) for L1 and L2, then this would no longer be true:
>
>  * If L0 uses EPT, L1 and L2 run with different EPTP because
>  * guest_mode is part of kvm_mmu_page_role. Thus, TLB entries
>  * are tagged with different EPTP.
>
> L1 vs. L2 EPT usage would no longer use separate ASID tags, and so KVM wo=
uld
> need to FLUSH_CURRENT on transitions in most cases, e.g. to purge APICv m=
appings.
>
> The comment above !nested_cpu_has_vpid() talks at length about synchroniz=
ing MMUs
> because the EPT behavior in particular is subtle and rather unintuitive. =
 I.e.
> the comment is much more about NOT using KVM_REQ_MMU_SYNC than it is abou=
t using
> KVM_REQ_TLB_FLUSH_GUEST.

