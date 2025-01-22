Return-Path: <kvm+bounces-36291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F5C9A19916
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 20:16:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FCD216724D
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 19:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7ED2D216395;
	Wed, 22 Jan 2025 19:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NNw3eXTK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088B4215F63
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 19:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737573371; cv=none; b=P0U9nvPgZ7vod2WIBOFHWqQ1reRDgH+bkBtOLN40AI0BzzYzDMTbJifxPJf9VYzAbNqUlqwgyJ8QryV3hmcZwONRyu9AL3HcPX327i71uVrE0uC3zqEYBha70V/FDGu/UE7INpt1wkgZI+Lxojykp+F95weVBU2g6qczKGZm5dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737573371; c=relaxed/simple;
	bh=AoJK4yfnGA/8owCG5jeXKws/H5a+EzCdrCVhYF/N8/s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UsfFI6uKc1ZjfghYMVMANJ0ojnF6cD4U7M9oAJB4QTRZcv6S0G6g3Un/ecOOX4JW42kP9x5KG1ldxRG3/b6Dh4Lkznes+IWM+L878/jHM6JFyTEFxKKvbPPoCy3gNmmkY3iWiT7enL0zq5dN+X0R9JZEJjoNfJRX1Apkrmjl8MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NNw3eXTK; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7b9ad0e84e6so6397985a.0
        for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 11:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737573369; x=1738178169; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mw8N6M+g73G0CxGuLWhQB8g6TPTQ3LDCqWl27wLUoU4=;
        b=NNw3eXTKKSAeX957TsWirVIgTJB7ffv6UE4PUNpfpTt4mX7SdMSBJe6iRS2hlrZ9Ix
         VJB8mCqc1cxqLfbuL5WGiK/eTKvE+QPmUuw/gBsKhZ0yqojPIB67b0puEnNo5lv1IsqG
         ye+TrNFP5zOM7NutqGzf4e1PcV+/kloZGDERn6JmwxDMXbVP4qVDSt99OzKQge9hQFmH
         fgqiaSmAiIf97uyRJ8Vo3mQTGaXIOsahkW1LYJ1JLQfHo/iJ/+WkM5wVRh9DD1V1Pooc
         na8bSefh4mc7xY9WfchVkjT9RFth8W1M7/4M4mv51xgGxTnhcncRdUzFsFlCBn+iJtKa
         8aIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737573369; x=1738178169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mw8N6M+g73G0CxGuLWhQB8g6TPTQ3LDCqWl27wLUoU4=;
        b=jNdTrrPv2pjgo4VBVSSjMd+lTIsjpm8jE9aAaRK0ggtpTr02MCFD+sXPkyQQObfnnX
         zn285KYnamTu5z0ySgaq5tbHioixauorBKb5YNcv3+10Ws7EQedyoL2NjoSrJIlNztwm
         lZ6zScCobD/ihL4jTMFwjMWG8uCJU+BXJhPlc9+xAt9B6LMkubKXAOUc3MgeK4vWGrM1
         ot80sUZzYJgN5TM7PkOEdFUrtWvRvqyAdkOqojaxPrv4ZaQon+1YW1PSePBFkW5OF/99
         P2VipwbpRHjd7Zlfklx6UZamzFRDBt2+LZER0KrAszxip35Mjaw3/L9GisYRF0nu1BwT
         oMTw==
X-Forwarded-Encrypted: i=1; AJvYcCU6AgiMFnRYZ8TSbuDYMkjAdvDyvBrGR52Y/NXca1y5MEW6DLAbMsp6mlvJS42JeQEkDr8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyI1Y9TPxYY9Gi2LTQMFfZMiNBshnb/77Ajv2NkbhmbOQicnGN0
	I7TsO6DuuIfYWsuGB4YYEucw4vatB3bI0Xh+Ko2ign72cttXjsK3s1SHYPT8GI+zJ+2nNnSchl5
	w+TdtoytnwZnETMTLp5CijY6KCpIghlK9XEh4
X-Gm-Gg: ASbGncvnX9EvYkvem+AUTLa1AZqxThCwqFgstCaSHAYfuD72T+S4EdMu66t0Hkc3hDt
	r8bODoeH4ONftrLVYndUp/Hy4aCK6h37NtORVRfIlfON1ISJq
X-Google-Smtp-Source: AGHT+IG6GYTLlDCDB+u80pniFR51qz2svefDMS2LRNOaIgs37f1d+UNxGAD58XQrR3VPol0dntvJPqR9F8vkUCuuyH0=
X-Received: by 2002:a05:6214:e47:b0:6d8:d79c:1cbd with SMTP id
 6a1803df08f44-6e1b21761e3mr347850236d6.15.1737573368717; Wed, 22 Jan 2025
 11:16:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
 <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com>
 <Z4k9seeAK09VAKiz@google.com> <CAJD7tkZQQUqh1GG5RpfYFT4-jK-CV7H+z9p2rTudLsrBe3WgbA@mail.gmail.com>
 <Z4mJpu3MvBeL4d1Q@google.com> <CAJD7tkbqxXQVd5s7adVqzdLBP22ef2Gs+R-SxuM7GtmetaWN+Q@mail.gmail.com>
 <Z4mlsr-xJnKxnDKc@google.com> <CAJD7tkahmyjXvwKO2=EfQRWu_BHPJ-8+eSEteZH5TGG3+jHtWw@mail.gmail.com>
 <Z4qbDBduEYWEwjkS@google.com> <CAJD7tkaa1cqUeUUKNdQADBqXH-G9h=5Liv+wj=5gitgbdO9Tsw@mail.gmail.com>
 <Z4rv0jzFILtUxK4q@google.com>
In-Reply-To: <Z4rv0jzFILtUxK4q@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Wed, 22 Jan 2025 11:15:32 -0800
X-Gm-Features: AWEUYZlzQsIyRzB5WqM-mv6DZodKld68Ws4NLsqK3CUX8pyeSjGlH2DlyQh9rEU
Message-ID: <CAJD7tkZLr7NUcO3JFRQQaB09XH8M+pQN2ALta2dTf7+xEZZFGQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
To: Sean Christopherson <seanjc@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2025 at 4:03=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Fri, Jan 17, 2025, Yosry Ahmed wrote:
> > On Fri, Jan 17, 2025 at 10:01=E2=80=AFAM Sean Christopherson <seanjc@go=
ogle.com> wrote:
> > > Yep.  I suspect the issue is lack of documentation for TLB_FLUSH_GUES=
T and
> > > TLB_FLUSH_CURRENT.  I'm not entirely sure where it would be best to d=
ocument
> > > them.  I guess maybe where they are #defined?
> >
> > I guess at the #define we can just mention that they result in calling
> > kvm_vcpu_flush_tlb_{guest/current}() before entering the guest, if
> > anything.
>
> Yeah, a "See xx for details" redirect is probably the best option.
>
> > The specific documentation about what they do could be above the
> > functions themselves, and describing the potential MMU sync is
> > naturally part of documenting kvm_vcpu_flush_tlb_guest() (kinda
> > already there).
> >
> > The flush_tlb_guest() callback is documented in kvm_host.h, but not
> > flush_tlb_current(). I was going to suggest just documenting that. But
> > kvm_vcpu_flush_tlb_guest() does not only call flush_tlb_guest(), but
> > it also potentially synchronizes the MMU. So only documenting the
> > callbacks does not paint a full picture.
> >
> > FTR, I initially confused myself because all kvm_vcpu_flush_tlb_*()
> > functions are more-or-less thin wrappers around the per-vendor
> > callbacks -- except kvm_vcpu_flush_tlb_guest().
> >
> > >
> > > TLB_FLUSH_GUEST is used when a flush of the guest's TLB, from the gue=
st's
> > > perspective, is architecturally required.  The one oddity with TLB_FL=
USH_GUEST
> > > is that it does NOT include guest-physical mappings, i.e. TLB entries=
 that are
> > > associated with an EPT root.
> >
> > The way I think about this is how it's documented above the per-vendor
> > callback. It flushes translations created by the guest. The guest does
> > not (directly) create guest-physical translations, only linear and
> > combined translations.
>
> That's not accurate either.  When L1 is using nested TDP, it does create =
guest-
> physical translations.

Ah yes, I missed that.

> The lack of any form of handling in TLB_FLUSH_GUEST is
> a reflection of two things: EPT is weird, and nested SVM doesn't yet supp=
ort
> precise flushing on transitions, i.e. nested NPT handling is missing beca=
use KVM
> unconditionally flushes and synchronizes.

Even for nested NPT, we shouldn't flush/synchronize the guest-physical
mappings unless L1 specifies that in VMCB12. So I suspect
TLB_FLUSH_GUEST will remain ignorant to nested guest-physical mappings
anyway.

>
> EPT is "weird" because the _only_ time guest-physical translations are fl=
ushed
> is when the "wrong" KVM MMU is loaded.  The only way to flush guest-physi=
cal
> translations (short of RESET :-D) is via INVEPT, and INVEPT is a root-onl=
y (VMX
> terminology) instruction, i.e. can only be executed by L1.  And because L=
1 can't
> itself be using EPT[*], INVEPT can never target/flush the current context

I think you meant L0 here.

>
> Furthermore, INVEPT isn't strictly tied to a VMCS, e.g. deferring the emu=
lated
> flush until the next time KVM runs a vmcs12 isn't viable. Rather than add
> dedicated tracking, KVM simply unloads the roots and lets the normal root
> "allocation" handle the flush+sync the next time the vCPU uses the associ=
ated MMU.

I think you are referring to what you mentioned to me offline, that
INVEPT could be affecting more than one cached root in KVM's MMU, not
just the loaded root when running VMCS12, which is why we cannot defer
synchronizing or unloading the roots.

>
> Nested NPT is different, as there is no INVNPT.  Instead, there's the ASI=
D itself
> and a flushing control, both of which are properties of the VMCB.  As a r=
esult,
> NPT TLB flushes that are initiated by a hypervisor always take effect at =
VMRUN,
> e.g. by bumping the ASID, or via the dedicated flushing control.
>
> So when proper handling of TLB flushing on nested SVM transition comes al=
ong, I
> do expect that either kvm_vcpu_flush_tlb_guest() will grow.  Or maybe we'=
ll add
> yet another TLB_FLUSH_XXX flavor :-)

I think kvm_vcpu_flush_tlb_guest() should remain ignorant because it's
used for a lot of operations flushing the TLB on behalf of the guest,
which should not flush nested guest-physical translations. Anyway, I
am trying to come up with a PoC for the "proper handling", so we'll
see how that turns out :)

>
> One thing that could be helpful would be to document that KVM doesn't use
> TLB_FLUSH_GUEST to handle INVEPT, and so there's no need to sync nested T=
DP MMUs.

I think what to document may become clearer when the nSVM
implementation comes along.

>
> [*] Even in a deprivileged scenario like pKVM, the guest kernel would bec=
ome L2
>     from KVM's perspective.

