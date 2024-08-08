Return-Path: <kvm+bounces-23627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9116494BE64
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 15:17:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E23B28D439
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 13:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C02618E022;
	Thu,  8 Aug 2024 13:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Vx6V86H"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF71018DF77
	for <kvm@vger.kernel.org>; Thu,  8 Aug 2024 13:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723123010; cv=none; b=aeczBvedPH2j3NOEUA7LENoliQ12rbZ/WQymUETt7GV/wAwuhIErN84uWRStJk0a18G/LP17ClK2NIbKcnQGfk0ueCrAiplrH8VGVzWdb3QvqkzqrRuAVBqrDlgPnKuJ+aqEOsVwr4NmS+3mvMDthhahLnc/elxKls1jYOITlug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723123010; c=relaxed/simple;
	bh=SIRHTk+m4P1RNpcxL6rwR5xC8tZQja2BIbrMKp2HGV0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XbhNpKlVvKyap+C9ThE7Uoorq0Dku4W6ubjVp1PumEyudO5sD6a/AGxRXpsW2sXOjmcPiwkcNh+YKKBpXxroYq0hO7qvsqq8Wlv7YsP9QPwck8q7Grb/0KItX7wCX0jqTJBFBtwvgvGKzoy24bw/fJ4MKibdlIMp6G1+9QplF1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Vx6V86H; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70e910f309eso1141155b3a.3
        for <kvm@vger.kernel.org>; Thu, 08 Aug 2024 06:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723123008; x=1723727808; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ep+xfrS41+80V4sejFNz0q3mTB6TQE8jTTfF1Jh5lTI=;
        b=0Vx6V86H118QZzXcLuXx5cYVlvtaxqcOyrEg1LmwlwoYluILVqVhvw4NdH/wOqy9U+
         H5h7eNi89+utF3KtdQa4FTY3sbEnU/T6+qf1gJS4TBXAw7DKi0pfiFGEMIzcFGFPH5TB
         VCZYiJHltvK5E3aBWqhUqBbAmg/3tUkSwqiPN8MGnh4zIMNE4au8CRz6Yb5Tfb9Qt9Ks
         zLLx9xL8arVUeRVArC8q2H1CmGM67bZorbKF9rk1vISHe30dby37R9w7fYgVN08m5lS8
         4ER8KzaWJIwKYgNSWl33nMf6q2En04mPh0ihepoA3Jif2xIofNF8YrG9ceG9gQWcmjJ2
         0xOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723123008; x=1723727808;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ep+xfrS41+80V4sejFNz0q3mTB6TQE8jTTfF1Jh5lTI=;
        b=wJ5SO3O1zn6vufGJ74/O75CVyC5NWszJ12C+2UfhFluV/eAwY6tJFKS0x/RPC3FE6y
         fnqUSInQVJRsUrvT6KLLM2FB4W4P/TCMhhfuauoHY4N5+Goq6sJ1Lyc55bcYwsdB0lS9
         quz75Srjg1TtK08PQfbzmOiPXZorZDmxG/fdR9wlu5lDBY4YRpm2+StGEuJf9Bb3lN8m
         S5APKAoBLzoTHUT5PcLAg6lvNs/lsWuV2Pb/QxaekOl/sdRcnCwv47zZQrMGZ6renhrE
         wvBCUn6k3Fi3wiWIiGMLMq06uBwE3NBmJPld33EiDlHaelZYbEzkkcSInGq6jdWAB1Eq
         hAeg==
X-Forwarded-Encrypted: i=1; AJvYcCWaZQa5hOoK68PQM9cPutWWOzr9xgKIhNmHwJMQ8Aj3v01sEVATqx71ajSZHERr0w1n9e3oUOcBPDBDfgVAOwUoFRsD
X-Gm-Message-State: AOJu0Ywxs9weVTZqWLOXyM6FP72Gk0aIeF/LX4apFKz+gPqo0tV63YCS
	r6WQIGlmpJcax4wmyZXVVJDUqJ4Y8mVx0RLkmkLQ9RV3V7EMEUq0YmAE86fSKppo7dDLyC6e+u0
	Mug==
X-Google-Smtp-Source: AGHT+IHJBsGw5UgR/iugxzmSr+QeSrp5dZN/v/XODES4sTP0wn0G9d+/VHKS2R50We/GZxKaCQexvWJSP70=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d8c:b0:70d:2a24:245d with SMTP id
 d2e1a72fcca58-710cae763e9mr108614b3a.3.1723123007877; Thu, 08 Aug 2024
 06:16:47 -0700 (PDT)
Date: Thu, 8 Aug 2024 06:16:46 -0700
In-Reply-To: <87bk23ql6n.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240726235234.228822-1-seanjc@google.com> <20240726235234.228822-14-seanjc@google.com>
 <87bk23ql6n.fsf@draig.linaro.org>
Message-ID: <ZrTFPhy0e1fFb9vA@google.com>
Subject: Re: [PATCH v12 13/84] KVM: Annotate that all paths in hva_to_pfn()
 might sleep
From: Sean Christopherson <seanjc@google.com>
To: "Alex =?utf-8?Q?Benn=C3=A9e?=" <alex.bennee@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 08, 2024, Alex Benn=C3=A9e wrote:
> Sean Christopherson <seanjc@google.com> writes:
>=20
> > Now that hva_to_pfn() no longer supports being called in atomic context=
,
> > move the might_sleep() annotation from hva_to_pfn_slow() to
> > hva_to_pfn().
>=20
> The commentary for hva_to_pfn_fast disagrees.
>=20
>   /*
>    * The fast path to get the writable pfn which will be stored in @pfn,
>    * true indicates success, otherwise false is returned.  It's also the
>    * only part that runs if we can in atomic context.
>    */
>   static bool hva_to_pfn_fast(struct kvm_follow_pfn *kfp, kvm_pfn_t *pfn)
>=20
> At which point did it loose the ability to run in the atomic context? I
> couldn't work it out from the commits.

It didn't lose the ability per se (calling hva_to_pfn_fast() in atomic cont=
ext
would still be functionally ok), rather the previous patch

  KVM: Drop @atomic param from gfn=3D>pfn and hva=3D>pfn APIs

removed support for doing so in order to simplify hva_to_pfn() as a whole.

