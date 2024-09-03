Return-Path: <kvm+bounces-25775-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72E0296A4D7
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 18:50:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30B1D28550C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA9BE18BC3A;
	Tue,  3 Sep 2024 16:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="icPJAgfL"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A993D17A90F
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 16:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725382209; cv=none; b=YkQjIqMnzN3aaNFynlLvHz103neq4kdqMqVmfFHezCfJybulCjDVNSHYdIQ/3rWmiqM+fyrU8hve5pto5W5eIZ2c5lux7H8QhxY4fZKz8c6d1ZgkEuP+ND5jA/QWG12+WurhnmORYTlzpCjfJbFiZmFhM5+R8/mMoaoAgkhuLSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725382209; c=relaxed/simple;
	bh=nqmuOyJXosNjfxFp47rk8c/6P1gHeGLK+0RE43HXhZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R+OUukztYX1DGf67gTwiEIFOpuEqSO35S1WTxsHKyxbCGQg6CsRaURR3niECGP06qHqh+ibH9To510Sz2RXWgIq3GeKCzHf4oldy4IRDa8wZuShCdYAR3pCu0TSgOTW52T1eKeaeD3BPt/LzL0mhyboHwZokG+ESthiY3jjXypA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=icPJAgfL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725382206;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vt3R45yng9MI1JlX9x1QeReU6N6vf5Xvk3elVudJjyU=;
	b=icPJAgfLMzxapCbYLu1AtK41aYKR7kT3Nu6ql62ACzFOkZtdBWEXmfg4AkhxtaOnU/Sad2
	hBQj4g1I/pJAUAHCU5fRQGXHYGPqR/HvFnT/NoLHH1hi0tF6obi9IyprGqMheAoX7hyg2V
	yWNVrR9lSIm5isTFC7e1PE6LQdypibk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-649-TP-YJOIbPcaSJL8L6Di71w-1; Tue, 03 Sep 2024 12:50:05 -0400
X-MC-Unique: TP-YJOIbPcaSJL8L6Di71w-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-42bbff6a0aeso36585445e9.3
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 09:50:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725382204; x=1725987004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vt3R45yng9MI1JlX9x1QeReU6N6vf5Xvk3elVudJjyU=;
        b=Bff7SGxxPBsT6vZ+CIQptlu7Q5oG1cmIispAKOz2iGJBgMHu/S5opNiP2nDECoVGNq
         smVRssqXRcUkDPon8CvNgjuFP84t0dgir4mk/IyH7ym2kys913RJAkIcN2xzSLOi3TRC
         rJQtCrEBlaxzPLYND4EUr2WuMxY2Q4DwtVcOpPxNDYmJwkQaMkh3C7hgFTNJCZvGgICM
         w4STUYt6DORyiX69N3vk86bh97ypvpGYncvEnbarkJMVVb6ebh/Aisb+9h/Pf2wY8FGo
         XuO+Wnc1tfUGacYbwTfapfXF1bkBBfpnFCOf7/KaRe1mirURgW9qpMEyDI19a7Yj5c4o
         7hrw==
X-Gm-Message-State: AOJu0Yx9tjWZzy+PzhwcWWXbc8ORTErPxHtU+cM9OqNZwtb43AuN3fPD
	63qd4mBVm64bs5+nL1KSN4Eu7V75diwXxR5Z8BS2oIZziN3O5NffAoILyZ63BGQVvYgFwWm9O6n
	7fMfzyZoaOX8EEzZRETFS4IlgjWsr4fQJVI2C51hfiXUFLIwjCFrtvuIOd45M3Q+IwRkxxXDjmZ
	ZxaurH4KvFNrz7iJFdJyEmusMDD7hHK2Vwfjaqdw==
X-Received: by 2002:a05:600c:524f:b0:426:6551:3174 with SMTP id 5b1f17b1804b1-42c8de9ddd7mr11449715e9.29.1725382204128;
        Tue, 03 Sep 2024 09:50:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxNjqhzJAIg14CVUQX1gVg2ZwKA4TIQQGzXpxWRObTbG7cqWuModpsnWjHvba+Flu3OYEU8hqc/R6SRI6NG7g=
X-Received: by 2002:a05:600c:524f:b0:426:6551:3174 with SMTP id
 5b1f17b1804b1-42c8de9ddd7mr11449515e9.29.1725382203627; Tue, 03 Sep 2024
 09:50:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240802195120.325560-1-seanjc@google.com> <20240802195120.325560-2-seanjc@google.com>
 <CABgObfYT_X3-Qjb_ouNAGX1OOL2ULT2aEA6SDKessSbJxGZEOQ@mail.gmail.com> <ZtcmtFlX83g7C8Vd@google.com>
In-Reply-To: <ZtcmtFlX83g7C8Vd@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 3 Sep 2024 18:49:50 +0200
Message-ID: <CABgObfbwFPDiRbmVMtQZ9HipiT=4zXRqrE1fd7d44EeHt8b7=A@mail.gmail.com>
Subject: Re: [PATCH 1/5] KVM: x86: Re-enter guest if WRMSR(X2APIC_ICR)
 fastpath is successful
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 5:09=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> On Mon, Sep 02, 2024, Paolo Bonzini wrote:
> > On Fri, Aug 2, 2024 at 9:51=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > > Re-enter the guest in the fastpath if WRMSR emulation for x2APIC's IC=
R is
> > > successful, as no additional work is needed, i.e. there is no code un=
ique
> > > for WRMSR exits between the fastpath and the "!=3D EXIT_FASTPATH_NONE=
" check
> > > in __vmx_handle_exit().
> >
> > What about if you send an IPI to yourself?  Doesn't that return true
> > for kvm_vcpu_exit_request() if posted interrupts are disabled?
>
> Yes, but that doesn't have anything to do with WRMSR itself, as KVM needs=
 to morph
> EXIT_FASTPATH_EXIT_HANDLED =3D> EXIT_FASTPATH_REENTER_GUEST if there's a =
pending
> event that needs requires injection.

The other way round? i.e. treat EXIT_FASTPATH_REENTER_GUEST as
EXIT_FASTPATH_EXIT_HANDLED to go through event injection.

> Given that kvm_x86_ops.sync_pir_to_irr is likely NULL if virtual interrup=
t delivery
> is enabled, the overhead of the trying to re-enter the guest it essential=
ly a few
> cycles, e.g. check vcpu->mode and kvm_request_pending().

No, I wasn't worried about performance. Probably I misread

                if (likely(exit_fastpath !=3D EXIT_FASTPATH_REENTER_GUEST))
                        break;

as something like

                if (likely(exit_fastpath =3D=3D EXIT_FASTPATH_REENTER_GUEST=
))
                        continue;

EXIT_FASTPATH_REENTER_GUEST is exactly what's needed here.

Paolo


