Return-Path: <kvm+bounces-12772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5D3088D983
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 09:53:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E91C61C27526
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 08:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E441B364AE;
	Wed, 27 Mar 2024 08:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T3NsXA9n"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5B336138
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 08:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711529608; cv=none; b=rhsXD08RA1/+Kg5J9BNeFXI+spL/geGsk2msGnJ97WllAaqK2vQzjxGzHf0nH0BTjx3ygyxTAsfFuiWKBiP2+/N9znR7cyQ11EIPLv+N3SyKC77owi8qCXvEvexnpH3/4rWVK0T7rKc8eT/+3TxGp7wY2R0t+vAkIJOw0JS4ci8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711529608; c=relaxed/simple;
	bh=OWQs6E2Su6j6pa4a880YT99/COxnrXF7PP9hTIt6qTM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r9fF0S4FSQWtc0xnCZomC3mP6dPi41I09gydWM7497/qor6xaBlEdeudRSqy/MfVHyaQfHzGzGQNEHGmR5/Pq8iB3h9hHS1P48KA1ZSnna7mWR0QjfsaUKLO8pX+P+9uFLV3OTvKsZzoWiIFmA0w/KCAF4cIj5FB/ujrtaeA9a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T3NsXA9n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711529603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6cf4cCnC+qe5Ypk9TgMBbXSUglge44MnVLQOMvYgo2s=;
	b=T3NsXA9n67Scrjn/yMWvvjpHnxVSPs0hUlg8SrqWC0XvOytaA2Ewz0WpvLEQHpzO0t5SFm
	95dqc1LOdhFrGQXea7FQkP5r7BlVSAcYYqWmW7LbDDn9fzEQHriNNKkX+gH4VkOcT7HTy5
	6HmH+qGBb1Aa1zCf+wAvxp92olJVzuU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-oscGKvV-PIWxMrXVdWSVUw-1; Wed, 27 Mar 2024 04:53:21 -0400
X-MC-Unique: oscGKvV-PIWxMrXVdWSVUw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-41485831b2dso25875985e9.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 01:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711529600; x=1712134400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6cf4cCnC+qe5Ypk9TgMBbXSUglge44MnVLQOMvYgo2s=;
        b=o7vUbb+kQFGgm+OFR5RSpyVUVlZxIE25cmZuGrsdAo+dcLNH0Xzo8BJukmB3TaZbdl
         hGxs/gIgZafqwayDx0EfD5z9bLGgUeDXedkupyH6JC9XCK9XzjmM5e6l5QG9SW8mxlYy
         UoI2ZvyA6m4O4EAGbNcsvS2qWhN+dm3U2EVnaS44BaIP/nEFC3aQXAuIwXe9F4M9YSAK
         ngZzXrSgUURIza9bvx/9zIuWXEfGIt2bciqZMPyNcGq7ei16me00vMwZFt9O0DykBzEr
         KsN57DHb064WXB3q2PNKZtekwetE89aUlEFlkb/f9owy1r2hj22zWO2jUZpmUSaMFWYL
         RMUA==
X-Forwarded-Encrypted: i=1; AJvYcCUHnrsQ94ODbjdbk06t7wsh9JOxYbf3tBAC7QYok75bcD9wXYvDiQFAh3ZBJrdFnDA3YAvNcKrkUOCNhcb8SL2SECNj
X-Gm-Message-State: AOJu0Yx2yR81XiTSNuguSlqiUTqm8rXC/Y7Uc+M36po+vF6o+TrEkEHP
	cfWtXPB/t4TiDo2zrgItVHGfd0V9aU1BCuUnpCjmfEfCOuVUTvQOiTGKwSfcSaiXXFA5HPSQH5y
	MAsPHhVs6EWLIRd5ZjzxJdoHe8hptqNM//ZBcVegUYQHgUwRAP/vhHT7FwpB9588Aj2FJ4fgKik
	LXDqLeANzDmIsol97cwRIH6Pec
X-Received: by 2002:a05:600c:314c:b0:413:2873:937 with SMTP id h12-20020a05600c314c00b0041328730937mr1618761wmo.35.1711529600225;
        Wed, 27 Mar 2024 01:53:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH2L75qsx6232S4O6zkODYRiFhAacXms15IMaam2sxmCRP+hNFo9OXoiwvyuX8V+YgKxAvXF7hp/iZ0qLkDXnc=
X-Received: by 2002:a05:600c:314c:b0:413:2873:937 with SMTP id
 h12-20020a05600c314c00b0041328730937mr1618749wmo.35.1711529599914; Wed, 27
 Mar 2024 01:53:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240318155336.156197-1-kraxel@redhat.com> <20240318155336.156197-2-kraxel@redhat.com>
 <54e8b518-2bea-4a5b-a75a-4fd45535c6fa@intel.com>
In-Reply-To: <54e8b518-2bea-4a5b-a75a-4fd45535c6fa@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 27 Mar 2024 09:53:07 +0100
Message-ID: <CABgObfZ5GpnoFwfbMNbPoWceifO0hiqu7LePvZFWLNOwCRvC1Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kvm: add support for guest physical bits
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>, qemu-devel@nongnu.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2024 at 3:45=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
> If users pass configuration like "-cpu
> qemu64,phys-bits=3D52,host-phys-bits-limit=3D45", the cpu->guest_phys_bit=
s
> will be set to 45. I think this is not what we want, though the usage
> seems insane.
>
> We can guard it as
>
>   if (cpu->host_phys_bits && cpu->host_phys_bits_limit &&
>       cpu->guest_phys_bits > cpu->host_phys_bits_limt)
> {
> }

> Simpler, we can guard with cpu->phys_bits like below, because
> cpu->host_phys_bits_limit is used to guard cpu->phys_bits in
> host_cpu_realizefn()
>
>   if (cpu->guest_phys_bits > cpu->phys_bits) {
>         cpu->guest_phys_bits =3D cpu->phys_bits;
> }
>
>
> with this resolved,
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

[oops sorry - I noticed now that this email was never sent, so I am
sending it for archival]

There are more issues:

1) for compatibility with older machine types, the GuestPhysAddrSize
should remain 0. One possibility is to have "-1" as "accelerator
default" and "0" as "show it as zero in CPUID".

2) a "guest-phys-bits is not user-configurable in 32 bit" error is
probably a good idea just like it does for cpu->phys_bits

3) I think the order of the patches makes more sense if the property
is added first and KVM is adjusted second.

I'll post a v5 myself (mostly because it has to include the creation
of 9.1 machine types).

Paolo

> > +    }
> > +}
> > +
> >   static bool kvm_cpu_realizefn(CPUState *cs, Error **errp)
> >   {
> >       X86CPU *cpu =3D X86_CPU(cs);
> >       CPUX86State *env =3D &cpu->env;
> > +    bool ret;
> >
> >       /*
> >        * The realize order is important, since x86_cpu_realize() checks=
 if
> > @@ -50,7 +73,13 @@ static bool kvm_cpu_realizefn(CPUState *cs, Error **=
errp)
> >                                                      MSR_IA32_UCODE_REV=
);
> >           }
> >       }
> > -    return host_cpu_realizefn(cs, errp);
> > +    ret =3D host_cpu_realizefn(cs, errp);
> > +    if (!ret) {
> > +        return ret;
> > +    }
> > +
> > +    kvm_set_guest_phys_bits(cs);
> > +    return true;
> >   }
> >
> >   static bool lmce_supported(void)
>Ther


