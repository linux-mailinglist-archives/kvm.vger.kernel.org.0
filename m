Return-Path: <kvm+bounces-10289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE1B86B5C2
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 18:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE4FF1C22376
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 17:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B83C03FBBF;
	Wed, 28 Feb 2024 17:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QqtEKj4h"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E416EEEA
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 17:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709140846; cv=none; b=ApyD/+hfAKmk6RLxssb9AoZEsdUcQB+p5GQBPx21XIEq+dtyWQs/tQ08Qel/MfGaMR3gCBS7MAcfLrRu1PMxL9IjK5Yni52binXjgfzR1Ma4/iNAJNWznIUcwzbieEjJvwqRL78lBu571W6g7f6iU4LrKgSx7xuAdYu/mRKO7yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709140846; c=relaxed/simple;
	bh=n0exr615nC5EZEeM0EsZy8UeaK59EIm1bYINM1HeqaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ha84W8n0bqwasG0VT3o3d5YXBCMoNK6tKI6gTjnsk4Y3j3Be+EltWjAptwkB/TuJOEM2uvQKX1+k4S5kvkBw6TghvIEorwJ+pncsyklNYMy3jTuK+dQRKTWMxaoElRsGI8O0C2PhVzFXYpJ0bpjuo5XSJc0V2Zi65Qij7OlWyxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QqtEKj4h; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709140843;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dycmzOR3/TdQOeG/y2ISWS/eLdq44stW8h6+F3A1yk8=;
	b=QqtEKj4h9Z8AEbJoB6APSD97K4WKVx5NS+ZXmJ3Mbk2wSAIqjpZCrJJ8gbitR72AxyZaJH
	uY9olGFe9GG+8bC2ZfrQeYuTLmx3XWvlooxBFe5NygdFTd9l6XEHLle0lT19QOA1PE8a0f
	L5Ocf4pWgiQuW0QDe/QLbS3U+L8vvoY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-IHJVgw0rN6ea0m6nJ0JkXA-1; Wed, 28 Feb 2024 12:20:41 -0500
X-MC-Unique: IHJVgw0rN6ea0m6nJ0JkXA-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33d8b4175dbso10629f8f.0
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 09:20:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709140840; x=1709745640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dycmzOR3/TdQOeG/y2ISWS/eLdq44stW8h6+F3A1yk8=;
        b=LOAyUJm6DVswgxZue1dQHkVJpL5UkUBtQlXSWhIbs/3yWAOxbnMmQVMM4lqkyXuzIl
         8aD1uChLO1H/Lo63zd2dtNd3NSOXbWXqBKcUeAsn4QT8YWgCnVgvmDbYr/GsMTJn3ALH
         aKiLOwH2lvWUmVP7iZYrQOTQ8L4NpByCxl+DtllecEAb8SS8cvLP2E4XdHHH5Odxw+1a
         jw9+1V5bMxW6mdwIunAu55z1EDqKFWzmJ2cXh1BfDgObzRf4CJ3Lbhk+CJ4yjE/vRfZm
         hO8g7IfqXPXF16Q53BgoWbB73Kz2fGvBL2/c5bE0Bo8ye8y2a7LOcBv2Jz93bRwAH7NS
         JNQA==
X-Forwarded-Encrypted: i=1; AJvYcCXIcWOn6vW9Y76NZUrlnbt5lgRfwRSZ/QDNjDk773pvq3NymitDshLqupcpLici5HkV9JSYNfEFsuZg5UDeF/1XqgrI
X-Gm-Message-State: AOJu0YxCrekNKtAG48jyfcr1AAYbIsoXQoKdBoqQbvLe5iACYlbhQFVr
	LTfKxfvFgFmyprybuPuZWQK/AaRXtuKQ+2TkSDDhwN07J0X8R+oWX3eGFdPCvHnGcSM3MuZfVcG
	e30IeEolojepUVTDMOD/X/LDlkFzh+sSJCtU5llbi9z0W/h0YPspQZ9mWYzdjZcWiqiI43cqSBc
	dXrFfPW5X4XMDclLArSpl4Y8Vd
X-Received: by 2002:a5d:4f08:0:b0:33d:52f:a2a8 with SMTP id c8-20020a5d4f08000000b0033d052fa2a8mr132879wru.61.1709140840237;
        Wed, 28 Feb 2024 09:20:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGrJxfnFvdAvyPZHwu1Poyv4u42Rgqf2slyitZ0GtBvFbjP6kttzzRXOZulX4AgXNXT/citq9hS8BivlWCOl4c=
X-Received: by 2002:a5d:4f08:0:b0:33d:52f:a2a8 with SMTP id
 c8-20020a5d4f08000000b0033d052fa2a8mr132869wru.61.1709140839873; Wed, 28 Feb
 2024 09:20:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <Zd6LK7RpZZ8t-5CY@google.com>
 <CABgObfYpRJnDdQrxp=OgjhbT9A+LHK36MHjMvzcQJsHAmfX++w@mail.gmail.com> <Zd9hrfJ5xRI6HeZp@google.com>
In-Reply-To: <Zd9hrfJ5xRI6HeZp@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 28 Feb 2024 18:20:27 +0100
Message-ID: <CABgObfaPRpEnndHwkZpOZ=JOZjJPyh2KXYLh5ZGMFMSboZqj9w@mail.gmail.com>
Subject: Re: [PATCH 00/21] TDX/SNP part 1 of n, for 6.9
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com, thomas.lendacky@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 5:39=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> > > This doesn't work.  The ENC flag gets set on any SNP *capable* CPU, w=
hich results
> > > in false positives for SEV and SEV-ES guests[*].
> >
> > You didn't look at the patch did you? :)
>
> Guilty, sort of.  I looked (and tested) the patch from the TDX series, bu=
t I didn't
> look at what you postd.  But it's a moot point, because now I did look at=
 what you
> posted, and it's still broken :-)
>
> > It does check for has_private_mem (alternatively I could have dropped t=
he bit
> > in SVM code for SEV and SEV-ES guests).
>
> The problem isn't with *KVM* setting the bit, it's with *hardware* settin=
g the
> bit for SEV and SEV-ES guests.  That results in this:
>
>   .is_private =3D vcpu->kvm->arch.has_private_mem && (err & PFERR_GUEST_E=
NC_MASK),
>
> marking the fault as private.  Which, in a vacuum, isn't technically wron=
g, since
> from hardware's perspective the vCPU access was "private".  But from KVM'=
s
> perspective, SEV and SEV-ES guests don't have private memory

vcpu->kvm->arch.has_private_mem is the flag from the SEV VM types
series. It's false on SEV and SEV-ES VMs, therefore fault->is_private
is going to be false as well. Is it ENOCOFFEE for you or ENODINNER for
me? :)

Paolo

> And because the flag only gets set on SNP capable hardware (in my limited=
 testing
> of a whole two systems), running the same VM on different hardware would =
result
> in faults being marked private on one system, but not the other.  Which m=
eans that
> KVM can't rely on the flag being set for SEV or SEV-ES guests, i.e. we ca=
n't
> retroactively enforce anything (not to mention that that might break exis=
ting VMs).
>


