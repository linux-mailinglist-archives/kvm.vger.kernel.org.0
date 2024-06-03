Return-Path: <kvm+bounces-18691-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E9B58D8AFA
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 22:38:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ADD4A1F25000
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 20:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF7EB13BAC3;
	Mon,  3 Jun 2024 20:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cyfWXK4q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE75313B582
	for <kvm@vger.kernel.org>; Mon,  3 Jun 2024 20:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717447115; cv=none; b=cbvnvUmw0F/l1+/DJbPFv0tQ/teXOEdPW5w0397ts4f0GtaHLjlE6rXO3kwFvyPwm6XlJsZTvTfzkvEO6xYbf6Pm6fGiLlBH9AXQpkcZd/Cdpz3uxIOdeoHRM7onb21Wwlgpbm4uwP9DZ8ZxiE18rH/HZJxDJSTweQSBveRB49A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717447115; c=relaxed/simple;
	bh=nOajvElT2YxRSgkUc7uVk4PH7rZHafyM7iXn3jIYzKs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DeYL61Vx9zoDutdYmnHJjwa5DBHsP641w7mRcOQ2ButadkEzr9dxfMj6aO4MugCTcWQ7WZWk9s0eRb3FlKJYWGWndP7JEMNdPUgb20WE26clYzHHuBGctkP+aZeVdl8SBJjfpn1daeo56EccpvH/8j08AqQiUtBnkiCUDL8VpPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cyfWXK4q; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-1f682e70799so7393545ad.1
        for <kvm@vger.kernel.org>; Mon, 03 Jun 2024 13:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717447113; x=1718051913; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XO5yZdhwE2fDtj4hYaOddgQwqaOtsUzsgmBHSrtqiuw=;
        b=cyfWXK4qp6dry/mYPzxtFdlZALtIbi1ldCrYVnFDDMFQ/bwDXefEB57jEfIP0Qqh9o
         6jIhgYfxNCaSZ93iWvofZQAyF9nuK7CoJC2iC+XiCMTUexnQ6FGY9MO0xtiVya+wsVju
         80/VbOCL+3PkzHqQr0NRB8SfsQca8Qr5C2HR18qmXy4yF1grCNHSZmvoMs9kMLpQl33a
         WJ9iPQdKU6WIoRNyo/6Z1ScNNmHoz3CJ0LXhchX3+ZlmPgJaYo9PtHgTxVTLSdfcIuf1
         mwD+1gpbGdq7TNR0AHxgr/bHdRhr1T4zjwTcazmwCIfsCw3MrpA6JCfKH1um/TLn+WMl
         Hu+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717447113; x=1718051913;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XO5yZdhwE2fDtj4hYaOddgQwqaOtsUzsgmBHSrtqiuw=;
        b=NTX4cMsMIjIsITTE1vFnlO2fpiis9F43tlPPN045L0LS0zKAn53vPfja6kooHqNyP2
         b3tDZvernEj1ZF9T4uDB0YapVMaF3Gc1rX5UO7gAVFrtKyJ7l9CmjCUCVFfttoa3oPo9
         S+e3haCDUwo1r/bepGa/5whW12qnzC9cSSwssvfJ0nnN63PI4fEjmgM1G7cRLh0kF8eH
         JRZHu2twgr2LcKXccw6NrANCAZkw/M52PUM2wvsicA5SKD3xbAve26qk8cF6PDkmNkVy
         PCUmfhaUjr8awPfUyCh/wvltdx2fTtlzQPLUSIOhZJUdPr17V/Oegy9yMzK7V6ZDabDf
         8Ytw==
X-Forwarded-Encrypted: i=1; AJvYcCVrvd/CZ06o4nU7F9IClU4brG4po/rBxZvLf0fGNW2Wi4FaheoJ1sJm0qDdGQWVHO/6K86VVPRWR5rJDw0MlTMccwU/
X-Gm-Message-State: AOJu0YzqyQ65XtmpUZtLEwCTeFCSoZwb1LkYxBHcmt0wGse7Zs96tnGh
	fazQ3B6A/TQ+/OwcXYt23E2IJz56fS7xtuS6FtI+4oT4gYDASydPm7GweTIVjL/D0ZxCTdikhtA
	m9g==
X-Google-Smtp-Source: AGHT+IExdolKE/hY98W+ja0EGqBrXw6wGDQhTRxEkbZVRfK2Y4yJSHL+gAUKdUpiFhN7lu/Fxb6BAhUIS8Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:124a:b0:1f6:d4b:3507 with SMTP id
 d9443c01a7336-1f6370c132dmr287075ad.13.1717447112817; Mon, 03 Jun 2024
 13:38:32 -0700 (PDT)
Date: Mon, 3 Jun 2024 13:38:31 -0700
In-Reply-To: <CABgObfY5athiQKdV8LQt3b=yKEgydOXRdfXeLz1C8Ho=ZrqOaQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <98ad0dab3a2c66834e50e6d465dcae47dd80758b.1717436464.git.babu.moger@amd.com>
 <Zl4DQauIgkrjuBjg@google.com> <CABgObfY5athiQKdV8LQt3b=yKEgydOXRdfXeLz1C8Ho=ZrqOaQ@mail.gmail.com>
Message-ID: <Zl4px2yauHdvDUbR@google.com>
Subject: Re: [PATCH] KVM: Fix Undefined Behavior Sanitizer(UBSAN) error
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Babu Moger <babu.moger@amd.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 03, 2024, Paolo Bonzini wrote:
> On Mon, Jun 3, 2024 at 7:54=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > > However, VM boots up fine without any issues and operational.
>=20
> Yes, the caller uses kvm_handle_hva_range() as if it returned void.
>=20
> > Ah, the "break" will only break out of the memslot loop, it won't break=
 out of
> > the address space loop.  Stupid SMM.
> >
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index b312d0cbe60b..70f5a39f8302 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -651,7 +651,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hv=
a_range(struct kvm *kvm,
> >                                         range->on_lock(kvm);
> >
> >                                 if (IS_KVM_NULL_FN(range->handler))
> > -                                       break;
> > +                                       goto mmu_unlock;
> >                         }
> >                         r.ret |=3D range->handler(kvm, &gfn_range);
> >                 }
> > @@ -660,6 +660,7 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hv=
a_range(struct kvm *kvm,
> >         if (range->flush_on_ret && r.ret)
> >                 kvm_flush_remote_tlbs(kvm);
> >
> > +mmu_unlock:
> >         if (r.found_memslot)
> >                 KVM_MMU_UNLOCK(kvm);
>=20
> Yep. If you want to just reply with Signed-off-by I'll mix the
> original commit message and your patch.

Signed-off-by: Sean Christopherson <seanjc@google.com>

