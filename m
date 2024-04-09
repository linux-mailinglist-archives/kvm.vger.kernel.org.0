Return-Path: <kvm+bounces-14000-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8989689DF13
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 17:30:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BAF0A1C221AD
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 15:30:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51B5C13D636;
	Tue,  9 Apr 2024 15:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CueSECOF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF5F13D601
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 15:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712676392; cv=none; b=gf8BjvIIXCBiCckN9NyD5RF9wv0lQbjoe0li5qO67Mp+AoM3gP4qPCXHSnghkLgLJJB18oQhmYP5xmTpeHW34ByrrO79fzXYJc6YU/xbaaTvw4iVgda/qtDQuCnH7rPWEpByegPbT/Qg4dRezHW+u/HuwNpI/8xeubscmEPIdiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712676392; c=relaxed/simple;
	bh=7AkwAkiGFeXn/tzNgwfDv+w516qHyDpPTUwTkeRV5D0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A0n2lILQd78BgMfNO4wevfbS7/KLiPUr2RJiKH5xbfluLPjeregFYJQIdSsXnb+8+9vPMBkohS/4Yf64BgwoMr97mPSGgA3sOnXkH3YMQzt1sWUHTM3CJT7KP1eQk4Jp+Rtvf8YbB25ch3Yxi8y68iyNPrOmSJdGEmgZ6tfJsO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CueSECOF; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-6180514a5ffso22776007b3.0
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 08:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712676390; x=1713281190; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L6zxjwXhkVdMVC69wPNMLfHGLf1mnpEnNlg9mNA1BZg=;
        b=CueSECOFYYF7LRtpdB09YssCkGviporTFhY3RfbGoSFLLQ6re0HbeQ1mbdGKIN1/Dm
         ei1354ZFavr1myENW5RJYIaXhMF9rpTM84Ekban/rfQoTycGFbavjIMBRklOMvFL6cNT
         aPGGP3vYkfelbF+QgGN7HCqeBniQ+WMPKXSbBotHhUkaU/CWx0AZy4Q63wD1yQWd5x//
         VedxBWd+n1zj/tzYS9spzk1FMRrxat4nu3Ls+5Eh1wH9fFZrhgkSpakC3mzp0fLm4rZW
         rhdFzUrPQrhplLFY27nuJBjOnWJ09Y0agflKsSZD87e/LqFeiTSTvuJ43Dg2jvXMgKUT
         bzgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712676390; x=1713281190;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=L6zxjwXhkVdMVC69wPNMLfHGLf1mnpEnNlg9mNA1BZg=;
        b=HB1yE1J8s7ok2Jz0eSh9UF9hJV1aC1n5iAeyrjR1fTCjFViHOHlNCfAU/1y0TGzNJZ
         Qs6Dt/J5zdRj487us83xUtWD9Vpm3IWeis8Q6M0HXQR9S9adbT8hMVMRmNYdhpDH8vN9
         IjefTzrG9zMy+ADfxLGzPXYa0TuHVNZxa72vDawE2ieQ17vAB8tdqtKR935FfOIuKAxk
         C4mSZcX0HG75PuOCeusJUnUaAHvVwhoWicjY/JNWvoE1gIZo/IyVlIIysht/eQ77miJp
         Ved0heij4jEEtBS8K5eX7H5x0Tc3wficWWMCaiV0h2RbSVFUlI3LhrJqYY3QQyB0sLza
         oLIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWR0Lnhkoo0aLnu0rcGjYUhs4zUfimnBsjQ9kQNL1mFE9CWbmj/1LK2RzOhgZk7IAJxYqgaNjILtbVrXIm3caIONzH2
X-Gm-Message-State: AOJu0Yw4AlItm5WdrUti5MOtgEsh1VQY1X+R9m+yNWM3Dl7Q4jr+DYrf
	Gu8z1dPUPJcpzBYFxQK2v8L1qEGMvrCBXMx4KJunrJmdtpNtcd1DHwRDsDeziK/KA+Is4r9g7Tu
	wyQ==
X-Google-Smtp-Source: AGHT+IHgEVlNGyzPHVr+TYaNurRXSfMtqIJogxKzXj5vEBHwyHEd0/3MyNjcj/APy5cCPp4QIthaKpor6z4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c74d:0:b0:615:1c63:417e with SMTP id
 i13-20020a81c74d000000b006151c63417emr716361ywl.1.1712676390070; Tue, 09 Apr
 2024 08:26:30 -0700 (PDT)
Date: Tue, 9 Apr 2024 08:26:28 -0700
In-Reply-To: <CABgObfZAJ50Z30VzFLdSrQFOEaPxpyFWuvVr1iGogjhs2_+bGA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240404121327.3107131-1-pbonzini@redhat.com> <20240404121327.3107131-8-pbonzini@redhat.com>
 <43d1ade0461868016165e964e2bc97f280aee9d4.camel@intel.com>
 <ZhSYEVCHqSOpVKMh@google.com> <CABgObfZAJ50Z30VzFLdSrQFOEaPxpyFWuvVr1iGogjhs2_+bGA@mail.gmail.com>
Message-ID: <ZhVeJH0DPL89Dg97@google.com>
Subject: Re: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for CoCo features
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 09, 2024, Paolo Bonzini wrote:
> On Tue, Apr 9, 2024 at 3:21=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> > > I'm a little late to this conversation, so hopefully not just complic=
ating
> > > things. But why not deduce has_private_mem and has_protected_state fr=
om the
> > > vm_type during runtime? Like if kvm.arch.vm_type was instead a bit ma=
sk with
> > > the bit position of the KVM_X86_*_VM set, kvm_arch_has_private_mem() =
could
> > > bitwise-and with a compile time mask of vm_types that have primate me=
mory.
> > > This also prevents it from ever transitioning through non-nonsensical=
 states
> > > like vm_type =3D=3D KVM_X86_TDX_VM, but !has_private_memory, so would=
 be a little
> > > more robust.
> >
> > LOL, time is a circle, or something like that.  Paolo actually did this=
 in v2[*],
> > and I objected, vociferously.
>=20
> To be fair, Rick is asking for something much less hideous - just set
>=20
>  kvm->arch.vm_type =3D (1 << vm_type);
>=20
> and then define kvm_has_*(kvm) as !!(kvm->arch.vm_type & SOME_BIT_MASK).
>=20
> And indeed it makes sense as an alternative.

Ah, yeah, I'd be fine with that.=20

> It also feels a little bit more restrictive and the benefit is small, so =
I
> think I'm going to go with this version.

+1

