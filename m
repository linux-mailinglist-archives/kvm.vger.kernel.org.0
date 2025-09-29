Return-Path: <kvm+bounces-58962-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A8C8BA87B7
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 10:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E670F16DFCD
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 08:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E4D2C031B;
	Mon, 29 Sep 2025 08:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ApA8atjp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF347277C81
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 08:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759136295; cv=none; b=UmcGEPvudVG1F9h+q2DWtQIyjFwza7hf14wjgqAjHYLGt8JnIue96dQVvb2taVYFqtrtOilnZ0jXY0AvpOQ3SdHSsioi1vS8y0c9GNJdntImoA786+CupI4Fbjl/qo2HSuhzyHGnspAfniTtdMKuXuCIiYo7vVMKNk8hdqti/is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759136295; c=relaxed/simple;
	bh=UxYAnoFueouxczgLGVUtAZzpt8pDexW25waY5k4GVYo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FhVHFTvT4qAbKaIN2qkqh3aE+YXxtLXQPsLpudnBBvjtYIJINakm/bdPuZQ1LWxJQB6Cso3SeEhMHqLRC2833XolCPVBho5jwGdJH6UjGfay916UYBsUPva8g5KCAVjWPlK+NxSierKgz/k2CRwPCaQJBPIzutKVLyYsHlgJAsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ApA8atjp; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4df3fabe9c2so435201cf.1
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 01:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759136293; x=1759741093; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SVirVdNngbz7qT0OdVsaXj3cZwI83nCwoCmm21kfuVY=;
        b=ApA8atjpdDv8CFEGDKsJFV/5Z4CaB5lD2BuuG9fKP9f+ZywvCtf++HYOY+NARt3ivt
         h7u5yGO2YW+W+arRtk6dYFqB1OdwPLZuMb3gJ+J62kkqJAKa6FIQPD7avmR/NocGPHBk
         kmw/iGTwqmllTnzSRehwXvjP7hSK0BIsnhzn4DT5tTtlX3bSQRl61tuRhf4NNQzJtmW3
         +JE1GuMmjXjrq1liInjhba/KdSHG6MnowL2oLFQ06Yc3Z+jmrIiapK0dq7jTfUyaL9hI
         4j0D/VBMPh0etxkjLaw7WyzRafXl1UaIGroljR+FvvAf/kB196kSgb0980D/xO9OMlWG
         iKnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759136293; x=1759741093;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SVirVdNngbz7qT0OdVsaXj3cZwI83nCwoCmm21kfuVY=;
        b=cNHJQEBSD0A1WxkCFs2I9oSHQmSHh+zrsbAXLLc+y6zr0Rl+ih7U5hNE/CbHGXmiSh
         hR8Rn0ZLckXSk9BCR7wsIb0FUV8bkKUaxzdsOaZj3oMdivuJNdwiAcBLPONh5j+YME11
         TxghiT1XGtAcaJrD4CMwY2NK9SBHcPohnqFQe4V944xo5tGTplkmTq7nIQ6Y4YBidK44
         fyniuvZE0XaIeIIaUJtdmzfZHAvWuO7SoOR32RO+0dbHxBiN4MOGToGD7jOF8/63s4p7
         YW1agx0icDfaw6RKJAq7rSgTp2hxnP9+haKqhLQHtHfKn2T9OzDwwmUjYZMhHXAIhMsk
         tYIw==
X-Forwarded-Encrypted: i=1; AJvYcCX4x9emDaXDJfTM2qBENVwWvyAp+Vzlu+McrevQdY6ya7pQ8MN5UHt/3DRQlQkFBZNHF88=@vger.kernel.org
X-Gm-Message-State: AOJu0YwN8/3hUhd71kDndSzZaKfAvUFXsxy8eXaEv1LZD7ZT4DTNJB7c
	R7Di3rCbAbSTZ71WaJZOydsKZULdCNZt3hlfU+zc1hOqnAtuxlY5/ii5vdO0hxrlPR5xD5LXcIA
	v+3b+PbMCv0/j8qvC32iOoGj3vlxTU/RL87wcRFVX
X-Gm-Gg: ASbGncu/3Sz2GEFnDfiehi1oy2QhNLo20SxFOyzjDKrrveXccUQLOHuC1ktEC3omaL5
	pg9muSfGp7pQHbsMnlkG9hISuuAdArQxzRpU5DmuQJeXM6ySMWMPm5dQxw8K+FP1kPwCnAAwzSv
	4mEBDM3hlzTvmvMnFebZElr6fk7okHOcOoRGODyk/U9V8XdP3JM+90qQkW+3ST7sqdOiXVuRk4q
	uHL/ZemrT8kMes=
X-Google-Smtp-Source: AGHT+IHbEV9ksmjzrZnsJKVk6RpSSor355OveF0HymKllyVVgMcfBArBEsZqVcgG0tSED+bzPxBkkzbN5xHYFgYtqBk=
X-Received: by 2002:a05:622a:1211:b0:4cb:2536:ed4b with SMTP id
 d75a77b69052e-4e258d167e3mr256211cf.3.1759136292264; Mon, 29 Sep 2025
 01:58:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-2-seanjc@google.com>
 <7ce29e23-aea9-4d4d-b686-3b7a752e0276@redhat.com>
In-Reply-To: <7ce29e23-aea9-4d4d-b686-3b7a752e0276@redhat.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 29 Sep 2025 09:57:35 +0100
X-Gm-Features: AS18NWAQi4Q7SHFPIL6_HIa2rzJqQn18m7uBGl2npRCTxGGr68iLY9x7nDg26nc
Message-ID: <CA+EHjTzO_tkOD1C--qqk1eotwf+-2DSDUqk=szzPTN7mHJLQ_g@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
To: David Hildenbrand <david@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi David.

On Mon, 29 Sept 2025 at 09:38, David Hildenbrand <david@redhat.com> wrote:
>
> On 26.09.25 18:31, Sean Christopherson wrote:
> > Add a guest_memfd flag to allow userspace to state that the underlying
> > memory should be configured to be shared by default, and reject user pa=
ge
> > faults if the guest_memfd instance's memory isn't shared by default.
> > Because KVM doesn't yet support in-place private<=3D>shared conversions=
, all
> > guest_memfd memory effectively follows the default state.
>
> I recall we discussed exactly that in the past (e.g., on April 17) in the=
 call:
>
> "Current plan:
>   * guest_memfd creation flag to specify =E2=80=9Call memory starts as sh=
ared=E2=80=9D
>     * Compatible with the old behavior where all memory started as privat=
e
>     * Initially, only these can be mmap (no in-place conversion)
> "
>
> >
> > Alternatively, KVM could deduce the default state based on MMAP, which =
for
> > all intents and purposes is what KVM currently does.  However, implicit=
ly
> > deriving the default state based on MMAP will result in a messy ABI whe=
n
> > support for in-place conversions is added.
>
> I don't recall the details, but I faintly remember that we discussed late=
r that with
> mmap support, the default will be shared for now, and that no other flag =
would be
> required for the time being.
>
> We could always add a "DEFAULT_PRIVATE" flag when we realize that we woul=
d have
> to change the default later.

I remember discussing this. For many confidential computing usecases,
e.g., pKVM and TDX, it would make more sense for the default case to
be private, since it's the more common state, and the initial state.
It also makes sense since sharing is usually triggered by the guest.
Ensuring that the initial state is private reduces the changes of the
VMM forgetting to convert the memory to being private later on,
potentially exposing all guest memory from the get go.

I think it makes sense to clarify things now. Especially since with
memory attributes, the default attribute is
KVM_MEMORY_ATTRIBUTE_SHARED, which adds even more confusion.

Cheers,
/fuad



>
> Ackerley might remember more details.
>
> --
> Cheers
>
> David / dhildenb
>

