Return-Path: <kvm+bounces-7194-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41C2383E1A4
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 19:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C15981F2653F
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 18:37:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C362231C;
	Fri, 26 Jan 2024 18:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GeG0yy9q"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B351EF1E
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 18:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706294225; cv=none; b=Fy48tkN57E2Mu1bcKdqI0/AgEUYWWja6oHPFe+vNDKgNXdacxd6kzOGjTZLKRUIp+TWZF54+Ukkw9IibruMfnIcT4mlZFE1Uz9sU82PazaziBSvTA9m9HQQAds+X92WYDiiid3ZuWwxBpfGfbcm54DT7pXQH8yrERiZbc58HKqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706294225; c=relaxed/simple;
	bh=S1fRMeft88UCS9XJ3ihj3GA2+mAls0h3Pf4XzLDD89s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XATwYFRjpHH7eF4xPjUnhqYp0EvSuhBlN0pmKqNpBwuTDJT2k5QFy6/zhKTauQ1T2XD/WAnk6UUGTTmYa2D8jXlmFX0aq0AXWbGaWZ6cRIiI5+se3SFkKPRL5/XWc5/rIbytoe0IgRUuNOWsjJ8pMDsl6RddXMRU2BAt76A7bZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GeG0yy9q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706294222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YtidRzgIyGrU6IJcvdjLJw1+3TfGvDrbdoaLpd1wvgI=;
	b=GeG0yy9qvFzjkeJ24cH+gmuM+Bxr1JiWEKyILd0Yeo8xnXiOLeOMrmpmVcL1mfSkXsOvnI
	ezPjeAxfUF9a7cpTIZofSqvdigy7oAZlal4EgiCA/lx3PZ4CVyCk/2ddWTpp4ds9oREL4H
	+zavk5Zo9QAbuGeHHWHPTNJqjUhrvmg=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-tw8dRDp9Neu44ikodSgU0g-1; Fri, 26 Jan 2024 13:37:01 -0500
X-MC-Unique: tw8dRDp9Neu44ikodSgU0g-1
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-466ec6d33bcso200805137.3
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 10:37:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706294220; x=1706899020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YtidRzgIyGrU6IJcvdjLJw1+3TfGvDrbdoaLpd1wvgI=;
        b=RXBbaWkd67W0CuQxlrv7NJQz6DSmIqjznOqDYIee3oxrR0CsSy2gBoXtzrX/5mGlxL
         CQkBkiXK8yG8nvU5pi3Y6p5NhsRQpA41AMUTZssuBCPoTA9s+gcrlzBV4DAfj+U8fn4i
         OPZBrT8oYVpSQWjBUEU6PDIISVkc5lQVUlr/junu+S3lRWy1cw6f9AlRUrc76C63y4v+
         xBWdZzL4ue1TbN9xfa6E9812KbBIKBsy3nfsbtawFnnwtkDnumUh7HNqYCzckcB/VNYQ
         naW1NaYOM+XjaKy60VPlvY+IYyke8C1AFX+IBUWJt0J8rMp95mKCudiInddB4kpLoEL2
         YDvw==
X-Gm-Message-State: AOJu0Yws+6bQV9Jz/3qP/M7jvf8lIM7MBUv+TQaaMDW+OVrD2BRgB4Ev
	DPnDjGm9dyNMm7xa/3JlRAjPWp8M2LCD6vXYsD6+Wd9r8jZhbpzFjbe8xcFNVN3I0BQHi3XeyXT
	0BJMJc/tmlRnUtcDSFDYZ5WKrMfAWpDVwp569Yuz/mzOMivkB35J5mFBo6c8PwgH8uTqg6KaDxZ
	M75nlhXr9tlHQwpnDQxG9b7aAD
X-Received: by 2002:a67:ebd4:0:b0:46b:1408:bbad with SMTP id y20-20020a67ebd4000000b0046b1408bbadmr198422vso.14.1706294220517;
        Fri, 26 Jan 2024 10:37:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHEeg7aOHdJJCfQQbPMee0o+6vpKuc0K0Nk3OoMbEjhiU4ZqbmHCHJWBpLEKUXk5wz5VWKDRBo7LPYo1lJnIDk=
X-Received: by 2002:a67:ebd4:0:b0:46b:1408:bbad with SMTP id
 y20-20020a67ebd4000000b0046b1408bbadmr198415vso.14.1706294220297; Fri, 26 Jan
 2024 10:37:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b83ab45c5e239e5d148b0ae7750133a67ac9575c.1706127425.git.maciej.szmigiero@oracle.com>
In-Reply-To: <b83ab45c5e239e5d148b0ae7750133a67ac9575c.1706127425.git.maciej.szmigiero@oracle.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 26 Jan 2024 19:36:48 +0100
Message-ID: <CABgObfZ1YzigovNEiYF7pbmRxv-SUzEFqnpaQZ4GT_hDssm65g@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Give a hint when Win2016 might fail to boot due
 to XSAVES erratum
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc: Sean Christopherson <seanjc@google.com>, Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 24, 2024 at 9:18=E2=80=AFPM Maciej S. Szmigiero
<mail@maciej.szmigiero.name> wrote:
> +static void kvm_hv_xsaves_xsavec_maybe_warn_unlocked(struct kvm_vcpu *vc=
pu)

Calling this function "unlocked" is confusing (others would say
"locked" is confusing instead). The double-underscore convention is
more common.

> +{
> +       struct kvm *kvm =3D vcpu->kvm;
> +       struct kvm_hv *hv =3D to_kvm_hv(kvm);
> +
> +       if (hv->xsaves_xsavec_warned)
> +               return;
> +
> +       if (!vcpu->arch.hyperv_enabled)
> +               return;

I think these two should be in kvm_hv_xsaves_xsavec_maybe_warn(),
though the former needs to be checked again under the lock.

> +       if ((hv->hv_guest_os_id & KVM_HV_WIN2016_GUEST_ID_MASK) !=3D
> +           KVM_HV_WIN2016_GUEST_ID)
> +               return;

At this point there is no need to return. You can set
xsaves_xsavec_warned and save the checks in the future.

> +       /* UP configurations aren't affected */
> +       if (atomic_read(&kvm->online_vcpus) < 2)
> +               return;
> +
> +       if (boot_cpu_has(X86_FEATURE_XSAVES) ||
> +           !guest_cpuid_has(vcpu, X86_FEATURE_XSAVEC))
> +               return;

boot_cpu_has can also be done first to cull the whole check.

> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 27e23714e960..db0a2c40d749 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1782,6 +1782,10 @@ static int set_efer
>        if ((efer ^ old_efer) & KVM_MMU_EFER_ROLE_BITS)
>                kvm_mmu_reset_context(vcpu);
>
> +       if (guest_cpuid_is_amd_or_hygon(vcpu) &&
> +           efer & EFER_SVME)
> +               kvm_hv_xsaves_xsavec_maybe_warn(vcpu);
> +
>        return 0;
> }

Checking guest_cpuid_is_amd_or_hygon() is relatively expensive, it
should be done after "efer & EFER_SVME" but really the bug can happen
just as well on Intel as far as I understand? It's just less likely
due to the AMD erratum.

I'll send a v2.

Paolo


