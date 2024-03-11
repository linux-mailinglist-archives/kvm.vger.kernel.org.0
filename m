Return-Path: <kvm+bounces-11539-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F148780A3
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 14:29:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 549DB28373C
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 13:29:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4911E3D980;
	Mon, 11 Mar 2024 13:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hEMWtok9"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68F91E87F
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 13:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710163744; cv=none; b=p+a9b4PxyRLf+xlrhAaCVWcsYEKR3DL3MFbO7jN9LKTY/kgDY/asZRSW1SzyNu4pP+zx2EfmNYXZtabPoDqRVpUqAHZ65xEXL5aJwrDrA72Y+8twF22JKHYTEuwln9Wu0WHfPcXNKUqOZVpiB5U6LLIKyBTvQTS8PwTbkYqwgfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710163744; c=relaxed/simple;
	bh=juNaxPjIj2bbDT3lL/m9OOSnyXgqNXPEMqVOqJW3ego=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l7gAAQC7UdU9IuWAcsSM1xrPQ15c1kI0z4quZ95vmuH06RwVLJWZczH/B5SCpTubjGhlM3KY3vAOnXF3tUAE4xtF4NrEhp+2R8N5rJzHfYUz8+3UjpwCLhzbBvnwRQEp4oBZ0uFI9fBlGDrbJHtqDQ5mU2VJrKMoAxM+r+vRuBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hEMWtok9; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710163741;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FrOWhWrfjQsd9LIq/h6+YYfsw9AMsXC8hG+IAKQuQIE=;
	b=hEMWtok9nN/nkjZ6MNV8dBg/db7sdAc/P2eI0gb/nJumMvvbkqg8URWmMtl7QodPNAVVdI
	79997HdKSQmr11mN0PidLtAeL2FMJfldb49oZxPXi8JR3GzOs4oUBLjX5gQIxhH13ePdlZ
	3pfb2dtw8+yxgbsCyfQP+ETAbanEt4E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-561-6-CZSA7EO1ed-YCBhCKrng-1; Mon, 11 Mar 2024 09:28:50 -0400
X-MC-Unique: 6-CZSA7EO1ed-YCBhCKrng-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-40fb505c97aso15555395e9.3
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 06:28:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710163728; x=1710768528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FrOWhWrfjQsd9LIq/h6+YYfsw9AMsXC8hG+IAKQuQIE=;
        b=NKAIL1A6M3DzeldFwk+4Nj5D/EUi9e6fPcWyRo1QDXB84LosxwHns2ASQ/3TvSFlrY
         sGptLS/603HWH3wmOcJk51IrsxXcd8F4624G07Kl9UoOCeRJ+olu9rw+L84K1ilSzH3/
         EdXTkWOfcq/0WWQ90w1GGcfYvTuDSB3fjIiJs1PU2nltUlGYGioOPRpccUBFaDsrPkut
         OrYINdKgeig5vVvMRaPQIOHUEx9LXlhwAnkapxacXWt0EqtzrL1kAnXCKpY1XHfYED5h
         tpHmC6H8j0deWvA+JBXGq+mqMfD8oX0wrH4tYN/+OWoXxAVy3QL9Qvi8ky4AmHCTdRlg
         oxyw==
X-Forwarded-Encrypted: i=1; AJvYcCW51Zwyx28UeJB/v0KcjZJXTnDC+MANzhVREKCqUtjjiVls33jNwwv/gFNNOxQf2maByheIuguO2iKAsZTlOxOS9yVA
X-Gm-Message-State: AOJu0Yzq1ly5ipkEzkZChVDOlnyFyvbnr7RNk/hkCWgFV4HkRmy2LNf5
	vV1D8bbpaInjT9jAt68Hhe8u51SsqfBPcaA6f2y4eZ3h3njD+M319Py4Y8IevXgt6FPuj8dra4m
	YpDLdrN4GSXvN9GDzgLjPkvny+B9nDqvirKS95cpIa5vY9VB9IuCNdwGRU6LDp2t+yxfvFSNweJ
	qfGJ4JTmOeg1F1zBvhWvJ49d0e
X-Received: by 2002:a05:600c:3485:b0:413:3048:5d68 with SMTP id a5-20020a05600c348500b0041330485d68mr241838wmq.20.1710163728708;
        Mon, 11 Mar 2024 06:28:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHTLUOWctNYlGT0yb+cuRyEHrP6pdKm4kmz16/UzCYq1uXQ3daClVE4+eQOzP7/z42bb3U2sPAq36/tvK3pe3E=
X-Received: by 2002:a05:600c:3485:b0:413:3048:5d68 with SMTP id
 a5-20020a05600c348500b0041330485d68mr241825wmq.20.1710163728423; Mon, 11 Mar
 2024 06:28:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240305105233.617131-1-kraxel@redhat.com> <20240305105233.617131-3-kraxel@redhat.com>
 <CABgObfZ13WEHaGNzjy0GVE2EAZ=MHOSNHS_1iTOuBduOt5q_3g@mail.gmail.com> <q6zckxcxwke2kdlootdq3s7m2ctcy7juuv3fsezhpw3nqyewxo@sqku62f25gdc>
In-Reply-To: <q6zckxcxwke2kdlootdq3s7m2ctcy7juuv3fsezhpw3nqyewxo@sqku62f25gdc>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 11 Mar 2024 14:28:35 +0100
Message-ID: <CABgObfZtUKcNH8HF2Sey29c7kfm9HPreyMxzVwtbPHaWYiJcFg@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] kvm: add support for guest physical bits
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: qemu-devel@nongnu.org, Tom Lendacky <thomas.lendacky@amd.com>, 
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2024 at 12:59=E2=80=AFPM Gerd Hoffmann <kraxel@redhat.com> =
wrote:
>
>   Hi,
>
> > > diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> > > index 952174bb6f52..d427218827f6 100644
> > > --- a/target/i386/cpu.h
> > > +++ b/target/i386/cpu.h
> > > +    guest_phys_bits =3D kvm_get_guest_phys_bits(cs->kvm_state);
> > > +    if (guest_phys_bits &&
> > > +        (cpu->guest_phys_bits =3D=3D 0 ||
> > > +         cpu->guest_phys_bits > guest_phys_bits)) {
> > > +        cpu->guest_phys_bits =3D guest_phys_bits;
> > > +    }
> >
> > Like Xiaoyao mentioned, the right place for this is kvm_cpu_realizefn,
> > after host_cpu_realizefn returns. It should also be conditional on
> > cpu->host_phys_bits.
>
> Ok.
>
> > It also makes sense to:
> >
> > - make kvm_get_guest_phys_bits() return bits 7:0 if bits 23:16 are zero
> >
> > - here, set cpu->guest_phys_bits only if it is not equal to
> > cpu->phys_bits (this undoes the previous suggestion, but I think it's
> > cleaner)
>
> Not sure about that.
>
> I think it would be good to have a backward compatibility story.
> Currently neither the kernel nor qemu set guest_phys_bits.  So if the
> firmware finds guest_phys_bits =3D=3D 0 it does not know whenever ...
>
>   (a) kernel or qemu being too old, or
>   (b) no restrictions apply, it is safe to go with phys_bits.
>
> One easy option would be to always let qemu pass through guest_phys_bits
> from the kernel, even in case it is equal to phys_bits.

Ah, I see - you would like to be able to use all 52 bits (instead of
going for a safer 46 or 48) and therefore you need to have nonzero
guest_phys_bits even if it's equal to phys_bits. While on an old
kernel, you would pass forward 0.

> > - add a property in x86_cpu_properties[] to allow configuration with TC=
G.
>
> Was thinking about configuration too.  Not sure it is a good idea to
> add yet another phys-bits config option to the mix of options we already
> have ...

I think it's nice that you can use TCG to test various cases, which
requires a new property.

> In case host_phys_bits=3Dtrue qemu could simply use
> min(kernel guest-phys-bits,host-phys-bits-limit)

Yes, that works.

Paolo

> For the host_phys_bits=3Dfalse case it would probably be best to just
> not set guest_phys_bits.


