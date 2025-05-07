Return-Path: <kvm+bounces-45676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 23DC5AAD28C
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 03:16:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A8B757A93FF
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 01:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FAA13633F;
	Wed,  7 May 2025 01:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ghv7mB+/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41A0F4E2
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 01:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746580555; cv=none; b=s+dlvkDva5vHXEAnliodpo4dE4KTEt4wSIxkPZEEv7QIkrZ6j4+L5BRTHKDjlGFvj37e3rabCJEbCFGsICWWcciM9jbcB51Qnv1PlZEkD6v7Hx0fawTHOCgwIymje4j2UE9ILX/wioOBNXD2jEKDnUILqvNUh8AlSYqHwPlDXxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746580555; c=relaxed/simple;
	bh=PJGXADhPgftHf4790J6bTo3LvncDFYONRNlduMuQnLQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dPEG7j9iaNRgkvrLIzS4EBKcsCQioFx205UlSp1A7+zX2Xru69iZf+VT08PZvFSH7K2lewSjvEmRtl2jZoiQPFptCA6hWV+N0EThUDB4JwglcfJDcIZCMQlXMy9oHNkM59JiQjHowu6Kgs3YKEsiMdN1Uzg1xOH7JEgnDKqweSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ghv7mB+/; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22e39fbad5fso53585ad.1
        for <kvm@vger.kernel.org>; Tue, 06 May 2025 18:15:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746580553; x=1747185353; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oI9dvuYFSW41PetZu8+C11r8U9aYDixgfsHjUdZoR8Q=;
        b=Ghv7mB+/SjUpHzvJNIUSJUBfDP9d/j42r/qarfES45zUEoFJkNTd90LRgUyCV04Z53
         qq9bSk4pVAhIFJQVVTNBVNZpcf8PZhVg1pOAy/TBpOEzAKUKvf0hjXy8Yau/MM6pid3j
         WtLnatOe8v24pZRsbwrbGHJFxY524lRZJrT1B8hIIHVvERxBlf+O7F7rUO5RI4uwCnfc
         IdzE4tdUUhcBk63XjXmryYfxZ1PD4anlgQ2Se/7OV1HAQj+AWILuuvoC89sRKrgcdOdu
         THXQ+e2sb0eF3c7Et95ljooJPwsaqBpgrreMhYb/VHSM6jGWmslmpnGFg+abhKGM3xD2
         F5vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746580553; x=1747185353;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oI9dvuYFSW41PetZu8+C11r8U9aYDixgfsHjUdZoR8Q=;
        b=nNnK9TtkoKjz3EaS5uCZYFR+7dzEb722DKQfuZOB7soVPj50Gs/oqa1kXRCw0Ye920
         NvNkjU2T+HqL2/GKXVj89hzPsiO95Bihw2H+YRIN6oRAs5uNlKgeMd8niY8wPWxFKA1K
         8GBLk02i+ThSsePbHMKe7iOyP2ibImaj1AtK2kZNYeHaTgkAJ7980SWwmnY9Bs9IRSyV
         1GvCIgPeXqPOg/kr5qLQa3njI4FDQku3bS489fSCkNNbRYkyhp/VeYblRcyZ7bJjPrqC
         WcDUAlG5oXwhbEcF4UEdmGYwkrISokUHFBvpfA0oW1N+pjuRCBcQntxiAks9TaKRJfj4
         k1iA==
X-Forwarded-Encrypted: i=1; AJvYcCW8Cu89qfNrvfaQzqscaV8sXY7DJJTY1sPm3oAXgy/qVhi/3Rn9Y1uyAgqFCvrkNuv3KjY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp6Sf2N15K0EmP05lfVvODhay1JKtbBfz4KBD/GaAVZDphw83g
	ay2+xPjU/p3RgkazckahnXvRGAaNgqthnZ+yriHjKlJJWA1E1RrTY33a72iNCLLARjO5jXOVV+G
	IzS7rttHJF3PpiT7CSB9Edj9qJfJa7J3Nyxir
X-Gm-Gg: ASbGncsr6mp22wEstvuUMyR8eM2lCorxXdiYLr0RWL5euy9eoET9E+N9i+IhRwMFIE0
	N6YJEOm0ECauOmFQobjHcT4eK2g9cY+ThqvYSALsLtt/ID9vzqZLzRoJfY5TUn1tApBcQ3ngz/L
	DZRDBTtf+SCwAvQEwt/zdTstor9gissrDpsoLe2tLOc3R0/2Ob8Vk=
X-Google-Smtp-Source: AGHT+IF64r1XV/UTd8/0ODGcdklsJP9ZXTT9L0J+KnSI3mOMSiLbsNkGeaQ+3WDmuLUAtwcZxubdXugCorUmCh9N7IU=
X-Received: by 2002:a17:903:198d:b0:216:6ecd:8950 with SMTP id
 d9443c01a7336-22e62a2f82dmr714135ad.19.1746580552732; Tue, 06 May 2025
 18:15:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
 <20250502130828.4071412-6-kirill.shutemov@linux.intel.com>
 <55c1c173bfb13d897eaaabcc04f38d010608a7e3.camel@intel.com> <aBqxBmHtpSipnULS@yzhao56-desk.sh.intel.com>
In-Reply-To: <aBqxBmHtpSipnULS@yzhao56-desk.sh.intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Tue, 6 May 2025 18:15:40 -0700
X-Gm-Features: ATxdqUFj6OOGJl4u4NDEeHbj2QFi6gwUbyBFBzHWdPZhV4mq2dQvBXHS3gCPlyY
Message-ID: <CAGtprH9GvBd0QLksKGan0V-RPsbJVPrsZ9PE=PPgHx11x4z1aA@mail.gmail.com>
Subject: Re: [RFC, PATCH 05/12] KVM: TDX: Add tdx_pamt_get()/put() helpers
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>, 
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, 
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 6:04=E2=80=AFPM Yan Zhao <yan.y.zhao@intel.com> wrot=
e:
>
> On Mon, May 05, 2025 at 08:44:26PM +0800, Huang, Kai wrote:
> > On Fri, 2025-05-02 at 16:08 +0300, Kirill A. Shutemov wrote:
> > > +static int tdx_pamt_add(atomic_t *pamt_refcount, unsigned long hpa,
> > > +                   struct list_head *pamt_pages)
> > > +{
> > > +   u64 err;
> > > +
> > > +   hpa =3D ALIGN_DOWN(hpa, SZ_2M);
> > > +
> > > +   spin_lock(&pamt_lock);
> >
> > Just curious, Can the lock be per-2M-range?
> Me too.
> Could we introduce smaller locks each covering a 2M range?
>
> And could we deposit 2 pamt pages per-2M hpa range no matter if it's fina=
lly
> mapped as a huge page or not?
>

Are you suggesting to keep 2 PAMT pages allocated for each private 2M
page even if it's mapped as a hugepage? It will lead to wastage of
memory of 4 MB per 1GB of guest memory range. For large VM sizes that
will amount to high values.

