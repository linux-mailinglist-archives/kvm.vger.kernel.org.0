Return-Path: <kvm+bounces-35707-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6E2FA1470C
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 01:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDF83188C196
	for <lists+kvm@lfdr.de>; Fri, 17 Jan 2025 00:35:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F8DBA42;
	Fri, 17 Jan 2025 00:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dRrQrdMk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44262A1CA
	for <kvm@vger.kernel.org>; Fri, 17 Jan 2025 00:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737074102; cv=none; b=BnbQsRn0KGNN0rGka43mlRqogKJpVfKiUiOYxGutsWOD0yTBriNmPwTkl9uUHIU3ALQ6oNxgOX5cr42ibCsj7sHYY3LCQQdei1zNlxMFh7YidvMl6/iYS2L7rvG4V0ddjzw6RnUFHkf/t6Ao7Vm08zcQuUYqEgegrAld6Jw/MVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737074102; c=relaxed/simple;
	bh=i+fu4SMiKCiOhqIwNOT0ZXodrO03sEGDTT6rZTLdP3M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H3FcsOAnrVrYRNTUlIug2xOoMu/Ch4kaKqC6z7WaaLY9Vqky1uc43C2yF1pR7DUIE3Qb3SYpy7li/k7YT/pxJMciYtGQ8GZkOgx5luUcnEPFkKmJ7RB8vk7UMyquejQ5SBmR48kuILCtf/Ass0ZWGUGd+hyeb00Ruuw1FejZsWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dRrQrdMk; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ef7fbd99a6so3056944a91.1
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2025 16:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737074100; x=1737678900; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lgWPk9r1v2SNvtYRPaNPBYejiII89EyX0Cotmneutyo=;
        b=dRrQrdMkmebMg7sW8rHLNa1Lgm39z9nAI/dou0f/FBttbU70QKYXZlB/hYQbL57Va4
         UoqRkB2Bje9JUuWhOyhHZ8vRqymKZQO+ttcHfqc64rzonOd48Pif6JtFjglhAlPDb7cY
         cCrbuYdFcIbohJerPBVHV6L8eWmFqaSKn6EvvaxaopziqCvAJZMx7YOCCWqHKLqyT1lx
         z098Ea3hxU1nQb2M9i9XCbxc8v2qPxz905OuNsXuq68E8Jzh0hs9/rK5Pn7lgIBKQBCr
         tW8uP2NsXPIGBGeBDxo2zP/ai3iJjvpiDfwkkFlz9aLSdngoaP/VFE/kra35ewbz+DQN
         zncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737074100; x=1737678900;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lgWPk9r1v2SNvtYRPaNPBYejiII89EyX0Cotmneutyo=;
        b=IaLDznzUm58LU93mBFNM9ifyY3pqibXUaq95SgGTdPAO1HwSries5N02TqfIrKUdfC
         ERzp1LW/Wm57HgM9UDwrnkp1aP/CdhHNl2cydB/Y31mxjZmrhmCCLbVAs2WjO5BxQ4+I
         H3xSb2wCyZ9DVmauzNcc6PM1SZKKkrpi53KFNehKA+MvjiOR71CrLl1EDr6GKD3da281
         CbkoMdwXkImsxEjkYZ9JjJe0IrK4A4NLt4oUKQG34MXp16YsMMyRWS2NLZI2PNdEqDkm
         Oa2b9dNaF6OkzK1JE0x0Kbc0dysLhQqeS7PgGDY3xZbL30n8W72zjLAeS3+1O47o5B9m
         EbyA==
X-Forwarded-Encrypted: i=1; AJvYcCW5UOK9kppiO8hFgrRNUgEWvfldZF1miTAoVMVrGwtsMJ5RVb4eXl+wOC8HPen+zP7F+wk=@vger.kernel.org
X-Gm-Message-State: AOJu0YzzvkpVWYPi6BOQAAtBDUsrpTyKoDf3N5WPaIXt2ceZSGsaxnTS
	t29w9mnhlOVFvmGIvitH+xAg1Df6jpevmv7Jpret0vCzpnJWfOKsNo4iY5eCw+jZgwUn4SCvMqy
	WJQ==
X-Google-Smtp-Source: AGHT+IEF+vCsdB8XWnCOfXc26I8zlnaA9viptBGh60aDQoi6XWzvvwmTgjaaVDKjMyjL3uFjKiqnMv4ZWGQ=
X-Received: from pjbsd7.prod.google.com ([2002:a17:90b:5147:b0:2ef:8d43:14d8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:8a16:b0:2ee:ead6:6213
 with SMTP id 98e67ed59e1d1-2f782ca2bc0mr801570a91.19.1737074100179; Thu, 16
 Jan 2025 16:35:00 -0800 (PST)
Date: Thu, 16 Jan 2025 16:34:58 -0800
In-Reply-To: <CAJD7tkbqxXQVd5s7adVqzdLBP22ef2Gs+R-SxuM7GtmetaWN+Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250116035008.43404-1-yosryahmed@google.com> <CALMp9eQoGsO8KvugXP631tL0kWbrcwMrPR_ErLa9c9-OCg7GaA@mail.gmail.com>
 <CAJD7tkbHARZSUNmoKjax=DHUioP1XBWhf639=7twYC63Dq0vwg@mail.gmail.com>
 <Z4k9seeAK09VAKiz@google.com> <CAJD7tkZQQUqh1GG5RpfYFT4-jK-CV7H+z9p2rTudLsrBe3WgbA@mail.gmail.com>
 <Z4mJpu3MvBeL4d1Q@google.com> <CAJD7tkbqxXQVd5s7adVqzdLBP22ef2Gs+R-SxuM7GtmetaWN+Q@mail.gmail.com>
Message-ID: <Z4mlsr-xJnKxnDKc@google.com>
Subject: Re: [PATCH] KVM: nVMX: Always use TLB_FLUSH_GUEST for nested VM-Enter/VM-Exit
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 16, 2025, Yosry Ahmed wrote:
> On Thu, Jan 16, 2025 at 2:35=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > How about:
> >
> >          * Note, only the hardware TLB entries need to be flushed, as V=
PID is
> >          * fully enabled from L1's perspective, i.e. there's no archite=
ctural
> >          * TLB flush from L1's perspective.
>=20
> I hate to bikeshed, but I want to explicitly call out that we do not
> need to synchronize the MMU.

Why?  Honest question, I want to understand what's unclear.  My hesitation =
to
talk about synchronizing MMUs is that it brings things into play that aren'=
t
super relevant to this specific code, and might even add confusion.  Specif=
ically,
kvm_vcpu_flush_tlb_guest() does NOT synchronize MMUs when EPT/TDP is enable=
d, but
the fact that this path is reachable if and only if EPT is enabled is compl=
etely
coincidental.

E.g. very hypothetically, if KVM used the same EPT root (I already forgot I=
ntel's
new acronym) for L1 and L2, then this would no longer be true:

 * If L0 uses EPT, L1 and L2 run with different EPTP because
 * guest_mode is part of kvm_mmu_page_role. Thus, TLB entries
 * are tagged with different EPTP.

L1 vs. L2 EPT usage would no longer use separate ASID tags, and so KVM woul=
d
need to FLUSH_CURRENT on transitions in most cases, e.g. to purge APICv map=
pings.

The comment above !nested_cpu_has_vpid() talks at length about synchronizin=
g MMUs
because the EPT behavior in particular is subtle and rather unintuitive.  I=
.e.
the comment is much more about NOT using KVM_REQ_MMU_SYNC than it is about =
using
KVM_REQ_TLB_FLUSH_GUEST.

> Maybe this?
>=20
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 2ed454186e59c..a9171909de63d 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1239,6 +1239,11 @@ static void
> nested_vmx_transition_tlb_flush(struct kvm_vcpu *vcpu,
>          * does not have a unique TLB tag (ASID), i.e. EPT is disabled an=
d
>          * KVM was unable to allocate a VPID for L2, flush the current co=
ntext
>          * as the effective ASID is common to both L1 and L2.
> +        *
> +        * Note, only the hardware TLB entries need to be flushed, as VPI=
D is
> +        * fully enabled from L1's perspective, i.e. there's no
> +        * architectural TLB flush from L1's perspective. Hence, synchron=
izing
> +        * the MMU is not required as the mappings are still valid.
>          */
>         if (!nested_has_guest_tlb_tag(vcpu))
>                 kvm_make_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu);

