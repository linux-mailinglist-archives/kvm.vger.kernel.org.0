Return-Path: <kvm+bounces-7737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 375BA845C0E
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 16:48:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFEBD1F256BF
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 15:48:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2C5626B3;
	Thu,  1 Feb 2024 15:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C+5MOZYR"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF027626A6
	for <kvm@vger.kernel.org>; Thu,  1 Feb 2024 15:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706802520; cv=none; b=lOUsFTXz7TjI/jHRjAx0QeKQrvb7JuFpaId6OVj4VKAk82ZG2e3HyTD/gX4wRMVDBu9G/+ZOpWOULNxM105foDDXWoBevud8UzgG1zC+8G7HsL3tuBkiasEFqdZHfqxo/JJB89BC79vUpfJ0Ake3no9N57MUqBdFzl7rPAZVFpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706802520; c=relaxed/simple;
	bh=u4eMRdiVQD77B+FhnGkSd3q0aMsF0Up82tvfkFTaYQY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vE21+Ips0pw5O2UYOI5M6SGipB/86qxqvtiFjHK9En1o0pUZ3/v7JaSldz+bwx1gNsNVFFUSVoPgr1cKESWzC8p/cEyGWGfEN5zg1IFhZ6XeflFtuA4/WIvhCazcqhLp2MQdCowPqv9bUNKe0FSDymwOLr8jn1wvOuHVN6lOOcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C+5MOZYR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706802517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JUy0BYrD39GIfiCcfziHo26bl6JbaDYlzmvvdn7klvY=;
	b=C+5MOZYRL5wpSnXGQskH00YMwrhPAC+akP/2cHRcBxdCTjj7/sk15PFKxPp3GQaT+nKTKk
	pqez1c1zowkh96b2usxPetziLOlMMrrA4lZ+IEeH+8XMs//Ifd0HB/x82WAByiUa4wN/xt
	d+KEacc5VHtixViVplQcDKnBYoyNFIw=
Received: from mail-ua1-f69.google.com (mail-ua1-f69.google.com
 [209.85.222.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-9TiCsUSeMoqqCniCclRZOQ-1; Thu, 01 Feb 2024 10:48:36 -0500
X-MC-Unique: 9TiCsUSeMoqqCniCclRZOQ-1
Received: by mail-ua1-f69.google.com with SMTP id a1e0cc1a2514c-7d2d72f7965so574797241.2
        for <kvm@vger.kernel.org>; Thu, 01 Feb 2024 07:48:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706802515; x=1707407315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUy0BYrD39GIfiCcfziHo26bl6JbaDYlzmvvdn7klvY=;
        b=vt+b9x9HA/zQO9hGrtK1Hjolw5s2itLnuEtoZF8qUYH+xCkGHg3gXsBr05zkUgx/w/
         euBwyKH6WVYNB2McVKmWMu2UVcQnHMOuCyqut0DlWR2FJ7PbzyVyzJxsD0ULY/EpgucB
         g7Uj3E0dQQARaBfkw7aXRjtcIRVvK0VhNJGkle9jekG4zaZ34p1tNU25mY8DQ7+6mQL6
         o8cME6XNoYanils1A81QvuUE1sv99gMLjfBNfoXPLKtV7KSvPa+yRnHfQ+1HwZjQ7zHB
         pfPGLngIk/cPXtDjojwUTxE6s6Q1yDrVlDx5xMHZCGA0OYacUY8JdToP5/iIMSurSRgl
         rOew==
X-Gm-Message-State: AOJu0YwOUSJx8eE2zmnStZn5P+T3au09g6kzEmk6pkKYOuUTiHyl1wdM
	n5fOqnN5oSD7OkDQpTdHVPjl0q71Adj33HH9CR6gtbMG/L0zhrpU74UyHJ1dkg7dMcjzeyf00Ji
	iGKukLi6Nh3EKc60ZIq00JIgx2rccV5NJ6UhPXC3s0IS4hLcPLnXROLbn4G2kTyFfum9ajvZ1Fj
	CF4pf7cOP0UUy1N4UlEmeFdi84
X-Received: by 2002:a67:fac5:0:b0:46c:f3fe:4556 with SMTP id g5-20020a67fac5000000b0046cf3fe4556mr1737758vsq.13.1706802515705;
        Thu, 01 Feb 2024 07:48:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFDhVjf+JElyY1WLqEUv9Hx1l5qUK2apiia4uTUVGtGJ2NJ4Sg+VSZKVRPgmbFloNdmnAVo9kLhn8J9ymVn+5E=
X-Received: by 2002:a67:fac5:0:b0:46c:f3fe:4556 with SMTP id
 g5-20020a67fac5000000b0046cf3fe4556mr1737725vsq.13.1706802515324; Thu, 01 Feb
 2024 07:48:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231220151358.2147066-1-nikunj@amd.com> <20231220151358.2147066-11-nikunj@amd.com>
 <CABgObfYwtMQY-E+ENs3z8Ew-Yc7tiXC7PmdvFjPcUeXqOMY8PQ@mail.gmail.com>
In-Reply-To: <CABgObfYwtMQY-E+ENs3z8Ew-Yc7tiXC7PmdvFjPcUeXqOMY8PQ@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 1 Feb 2024 16:48:23 +0100
Message-ID: <CABgObfbdJe2eui7_3eopf_g8u56D_YYzJUf2drbLp=ACGP2=LA@mail.gmail.com>
Subject: Re: [PATCH v7 10/16] x86/sev: Add Secure TSC support for SNP guests
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org, 
	kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de, 
	dave.hansen@linux.intel.com, dionnaglaze@google.com, pgonda@google.com, 
	seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 1, 2024 at 4:46=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> On Wed, Dec 20, 2023 at 4:16=E2=80=AFPM Nikunj A Dadhania <nikunj@amd.com=
> wrote:
>
> > +       /* Setting Secure TSC parameters */
> > +       if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC)) {
> > +               vmsa->tsc_scale =3D snp_tsc_scale;
> > +               vmsa->tsc_offset =3D snp_tsc_offset;
> > +       }
>
> This needs to use guest_cpu_has, otherwise updating the hypervisor or
> processor will change the initial VMSA and any measurement derived
> from there.
>
> In fact, the same issue exists for DEBUG_SWAP and I will shortly post
> a series to allow enabling/disabling DEBUG_SWAP per-VM, so that
> updating the kernel does not break existing measurements.

Nevermind, I keep confusing guest and host-side patches.

/me goes in the corner.

Paolo


