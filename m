Return-Path: <kvm+bounces-26739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1DCA976DDE
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 17:37:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F2D2282935
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 15:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D00FB1BA27E;
	Thu, 12 Sep 2024 15:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EAYjBf6i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BA053365
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 15:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726155443; cv=none; b=gQbvTo9DebtBJ8AZzjwQJ7hwrdxHL8Wcp06t3gbQLmHy1yKX/u7iTTfxMqQ3gC8YrCxMEZZUqUiye88mSm62bkNrFeuAB7METrFHFfPgv1mPLMLjKclUgrmT/PA6twiA0nD3eU69TYAfHpVYOW07diTeSRGaz3RUTvFlI+S4CRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726155443; c=relaxed/simple;
	bh=cEEKZ0yc4WxAK5OYKnZTo8Ykusk2IEEUB/2uepHjovg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZYsSUSY85wzQxQHLvCyrOEf2NIEl+eu74w0EffiKto1ilU7G12jJx76G0359/F6ehwEvrQzfyAbnlIas27vNAESF/fefUY9DcQEbiM1I64FrPTs9i/JjrnjAW2g3nVVOiKes2u+irbJeTzY5+WLG5XUVzs49zWlM8JpHSQlTF/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EAYjBf6i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726155440;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5cJBcvCFq/HwgNdpAfecYvxM1im2ig/oEquJyq/fPvU=;
	b=EAYjBf6i0yDjr43tjMjYAoedq1UiuD9hBSKmmi7CVucDx048Op4pkxfABr23j42uEM3L2Q
	ZhiAub1D80OSq2k+r6racXsA3d8E2gMyEYy1IhgY3oXFAtVEBSlz62gyY2jIOxi1TyAhe1
	O3Gy4juuG4Lxk5l4wglrTlhWgt1vUVk=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-J2pJcBopNmiYx2TssqulUA-1; Thu, 12 Sep 2024 11:37:19 -0400
X-MC-Unique: J2pJcBopNmiYx2TssqulUA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-374cbbaf315so612438f8f.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 08:37:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726155437; x=1726760237;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5cJBcvCFq/HwgNdpAfecYvxM1im2ig/oEquJyq/fPvU=;
        b=Q/32H6rH8B8LvT+FpE8+TCycdAQIjty/0o6oevV7nz0ddwKMV9+6A242AS/AO5xmLM
         oPrlbr+YGHtdL2pJ/g5dqbkkGbR/NZ2MBV1ZptwudyeOdxf2fMUvQmE9EVN9apyfN7YE
         kOJeYZyUv1w1DrKr92LWtyq1dLl1WhkSA3n1ZDJqkT+iafeOO9Xlm2Eer5TNEvXaubFW
         dDTGryoUuHwgDOGen7pwjClFGD412PSpeFyyr62qWQFGOFEbN316id2CEbi/MTAfziEv
         cBPEixu1UWLy1YerpgZ7796Ou0YQPT5fWwg01qMRveOR1YX326DX0ztSCAC4JohLZ8K4
         KOyw==
X-Forwarded-Encrypted: i=1; AJvYcCVrRnLHNNu4qzdJwBwHZJbvCLlJU2N9jNj4tvsmHzpbqmk42yo96AegBcC3OCahh4jLDCQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHVsLH9nPatCiNi4emcBHZOPPIjADbkaiHfFZNZGyId5w/CsDP
	LuGWmjKq3hWn+6LzxWR/yYgyKkHrmiaG1Z6L2OpNCuDdjh7LXbUVVi9KKFzk/+Skkp63XVWW3cE
	dvFhXdThb9mVakL4G8EnK9TnDAQGPdwuPQEi4ChNxSRuGCvBpL4Opk38pVvg7wtWJva6+9ZuNZo
	QNJn1og4WdZ3STzsQEaNLI2AeCkGDtc6CtwKgQzg==
X-Received: by 2002:a5d:6582:0:b0:374:c21a:9dd4 with SMTP id ffacd0b85a97d-378c27f920bmr2091232f8f.20.1726155437491;
        Thu, 12 Sep 2024 08:37:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDr/ETXhSBCXnBltJraH9uNK9CYjqEQeHbXIVHj5zFg6GxTqVGpOUbIg4B2kFrRn8OL1sx4Q+tZG5NOcHa4bk=
X-Received: by 2002:a5d:6582:0:b0:374:c21a:9dd4 with SMTP id
 ffacd0b85a97d-378c27f920bmr2091200f8f.20.1726155436928; Thu, 12 Sep 2024
 08:37:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-26-rick.p.edgecombe@intel.com> <05cf3e20-6508-48c3-9e4c-9f2a2a719012@redhat.com>
 <cd236026-0bc9-424c-8d49-6bdc9daf5743@intel.com> <CABgObfbyd-a_bD-3fKmF3jVgrTiCDa3SHmrmugRji8BB-vs5GA@mail.gmail.com>
 <c2b1da5ac7641b1c9ff80dc288f0420e7aa43950.camel@intel.com>
In-Reply-To: <c2b1da5ac7641b1c9ff80dc288f0420e7aa43950.camel@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 12 Sep 2024 17:37:04 +0200
Message-ID: <CABgObfaobJ=G18JO9Jx6-K2mhZ2saVyLY-tHOgab1cJupOe-0Q@mail.gmail.com>
Subject: Re: [PATCH 25/25] KVM: x86: Add CPUID bits missing from KVM_GET_SUPPORTED_CPUID
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2024 at 5:08=E2=80=AFPM Edgecombe, Rick P
<rick.p.edgecombe@intel.com> wrote:
> > KVM can have a TDX-specific version of KVM_GET_SUPPORTED_CPUID, so
> > that we can keep a variant of the "get supported bits and pass them
> > to KVM_SET_CPUID2" logic, but that's it.
>
> Can you clarify what you mean here when you say TDX-specific version of
> KVM_GET_SUPPORTED_CPUID?
>
> We have two things kind of like that implemented in this series:
> 1. KVM_TDX_GET_CPUID, which returns the CPUID bits actually set in the TD
> 2. KVM_TDX_CAPABILITIES, which returns CPUID bits that TDX module allows =
full
> control over (i.e. what we have been calling directly configurable CPUID =
bits)
>
> KVM_TDX_GET_CPUID->KVM_SET_CPUID2 kind of works like
> KVM_GET_SUPPORTED_CPUID->KVM_SET_CPUID2, so I think that is what you mean=
, but
> just want to confirm.

Yes, that's correct.

> We can't get the needed information (fixed bits, etc) to create a TDX
> KVM_GET_SUPPORTED_CPUID today from the TDX module, so we would have to en=
code it
> into KVM. This was NAKed by Sean at some point. We have started looking i=
nto
> exposing the needed info in the TDX module, but it is just starting.

I think a bare minimum of this API is needed (adding HYPERVISOR,
and masking TDX-supported features against what KVM supports).
It's too much of a fundamental step in KVM's configuration API.

I am not sure if there are other fixed-1 bits than HYPERVISOR as of
today.  But in any case, if the TDX module breaks it unilaterally by
adding more fixed-1 bits, that's a problem for Intel not for KVM.

On the other hand is KVM_TDX_CAPABILITIES even needed?  If userspace
can replace that with hardcoded logic or info from the infamous JSON
file, that would work.

Paolo


