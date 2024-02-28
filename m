Return-Path: <kvm+bounces-10290-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2976986B60B
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 18:33:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BFA0A1F26872
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 17:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1BA015A498;
	Wed, 28 Feb 2024 17:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ep7bkA7Z"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDBE3FBB7
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709141574; cv=none; b=rJBotPFed7obFHLuSr55FypnjQtuwQKWV2cpW1tc1IKui2x5IqeiUiOIu8aTIDlTuQ5hOMxjs5DNbfMmCOq2XsmB/8Cl1/rG9JjYJKCZAVBHrsFuV1TOj9JN2hre9kcm6RD8aj439rJ3zNOk/o0JTUEq1bUb2ABeoGjc68U3r9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709141574; c=relaxed/simple;
	bh=fYS13N9NZSFLqL5gwUsUap5mM8K5OiN8syZJhBDVxbs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uYgnHrD9zxeHlvWzT4+CR3jumPq4P2yotpNSWkvvSz/CWiI+1g3J1fDTKPbUpnT5L3furfdx+Y9NJ+tOYhfJ35lNnVLuerIN7T2dUnwqb+yG8EdQVvAuzeBecS560gZxOyongAnTV3zOxX5nGJXv84BHso9A7Tb9AjiwydkUuco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ep7bkA7Z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709141572;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SmXoF31qoxcztznnZL7H+L5aSF9s4S/rqGoBb/y1mxw=;
	b=Ep7bkA7Zc1sQDi5iYfdeq19RitBLcCk2VSYXxV8PvwnkJDeHF3F/hU9wRSy4xt5Q29kcr3
	fKAD8OCt8fuQts7oSLPyBRCyhDKHDgJcYkxI1MwuV0LRw7XassJeomM3xQckpy4FU+5RaK
	JpGKtOlgK2qxZA6560PwHToSKMfEtmw=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-266-XL3BMfGvPMuIk5GoifmxuQ-1; Wed, 28 Feb 2024 12:32:50 -0500
X-MC-Unique: XL3BMfGvPMuIk5GoifmxuQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-412b7721ad0so2334475e9.2
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 09:32:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709141569; x=1709746369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SmXoF31qoxcztznnZL7H+L5aSF9s4S/rqGoBb/y1mxw=;
        b=AVKsh1mVgA657vHYczabaM6QJgz4PWPHc3YP5AcRdj7R5QkcP1UlACk2P8jC6BMYcv
         SL4QIYfufVw1+W8tg7bdY1iKkxTbzoSesZd4ROvvLEv8lLdxjUy8zAdV4AZo9RONGm2w
         mWn21/47CUeC4xFvWIKOwfZHOehM+Niw0PLW6bYyQpys5aF8rcuLOMwTwgLFQXQzi5Qg
         PDG4J1k5hmjfdOnW9kTaQYEOB+cv++yTd1YCtq7J9iMdVKr2lleAJoQZh/CEd1g1Weax
         bIF7kKZMfpVIPLVivoIFRb/IXRum5McC7UaxK5tvp99oyEdytUVb9tOj2vB+hWDryAsm
         ENDA==
X-Forwarded-Encrypted: i=1; AJvYcCXUPcNUJ7pyXMP5xWK20Cz3qIUlWVxkVTKmfaT3wva78EZ9+YM3sKPF5jsAOvHe3ISUtp8RQgi8nxsEFBfVr3tCNhIT
X-Gm-Message-State: AOJu0YxZGfNio9mpMcam/kq8pwcoj6eBDaPRZuyPOTRtY2o9B8r9cUKN
	3KAc1I78DrwREsI4dfyaKp034tewTEeTml6pDoGZsfiWXnEtit+M8oiBB6VMxhkXHIVL3sJ84M6
	1Yi1boORTngNG17wuWtGS2+9wz6cpcLIfgiD/JO9nLm8h76ZasZ37GzoGLKg5Eju/XCS25Txc+x
	dc/UQ+kfHhAuRXAp8wsKUWYdAh
X-Received: by 2002:adf:e488:0:b0:33e:202:277a with SMTP id i8-20020adfe488000000b0033e0202277amr164347wrm.46.1709141569075;
        Wed, 28 Feb 2024 09:32:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxcghLhChHEAIG27LGbO9eqn7L5dVgSGoWWA3BJFwSP4LoUv8zzPOjUYDW9wZ+F93WhzORVl0bdNLPnNOtaFg=
X-Received: by 2002:adf:e488:0:b0:33e:202:277a with SMTP id
 i8-20020adfe488000000b0033e0202277amr164333wrm.46.1709141568784; Wed, 28 Feb
 2024 09:32:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227232100.478238-1-pbonzini@redhat.com> <20240227232100.478238-11-pbonzini@redhat.com>
 <Zd6T06Qghvutp8Qw@google.com>
In-Reply-To: <Zd6T06Qghvutp8Qw@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 28 Feb 2024 18:32:37 +0100
Message-ID: <CABgObfaPodSSzArO99Hkn=vpGotO1wZ-0dZKEZHx9EqLZ7M_XQ@mail.gmail.com>
Subject: Re: [PATCH 10/21] KVM: SEV: Use a VMSA physical address variable for
 populating VMCB
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	isaku.yamahata@intel.com, thomas.lendacky@amd.com, 
	Ashish Kalra <ashish.kalra@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 3:00=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Feb 27, 2024, Paolo Bonzini wrote:
> > From: Tom Lendacky <thomas.lendacky@amd.com>
> >
> > In preparation to support SEV-SNP AP Creation, use a variable that hold=
s
> > the VMSA physical address rather than converting the virtual address.
> > This will allow SEV-SNP AP Creation to set the new physical address tha=
t
> > will be used should the vCPU reset path be taken.
>
> No, this patch belongs in the SNP series.  The hanlding of vmsa_pa is bro=
ken
> (KVM leaks the page set by the guest; I need to follow-up in the SNP seri=
es).
> On top of that, I detest duplicat variables, and I don't like that KVM ke=
eps its
> original VMSA (kernel allocation) after the guest creates its own.
>
> I can't possibly imagine why this needs to be pulled in early.  There's n=
o way
> TDX needs this, and while this patch is _small_, the functional change it=
 leads
> to is not.

Well, the point of this series (and there will be more if you agree)
is exactly to ask "why not" in a way that is more manageable than
through the huge TDX and SNP series. My reading of the above is that
you believe this is small enough that it can even be merged with "KVM:
SEV: Support SEV-SNP AP Creation NAE event" (with fixes), which I
don't disagree with.

Otherwise, if the approach was good there's no reason _not_ to get it
in early. It's just a refactoring.

Talking in general: I think I agree about keeping the gmem parts in a
kvm-coco-queue branch (and in the meanwhile involving the mm people if
mm/filemap.c changes are needed). #VE too, probably, but what I
_really_ want to avoid is that these series (the plural is not a typo)
become a new bottleneck for everybody. Basically these are meant to be
a "these seem good to go to me, please confirm or deny" between
comaintainers more than a real patch posting; having an extra branch
is extra protection against screwups but we should be mindful that
force pushes are painful for everyone.

If you think I'm misguided, please do speak out or feel free to ask me
to talk on voice.

Paolo


