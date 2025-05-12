Return-Path: <kvm+bounces-46137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E47AB3023
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 08:55:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A64E918969ED
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 06:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 180D0255F4A;
	Mon, 12 May 2025 06:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="biCdxd8K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF521B0409
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 06:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747032944; cv=none; b=YNJreOtOFov+ux5xJk5cNIEg2ObDipCv3gWc6WwEg27YhVcI9vmHPfT/xkj+ftbCKs3nZ0JaNpP0tF72tty0lPTulZ4a1fA23dEgIp+oI4/3mlvUIGfY4ii5SW+iO/oDdAiuaWDWUsnM2peMw59l04JndnCTmY8HGSKaPfTzjEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747032944; c=relaxed/simple;
	bh=+t9TZ+HZMihMAnut80fSjlGfcSytgJyPsnLmF6rLX90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r1Dq5f+QhbGt7ewkJFoKNtHyK9eZ0hpbBCSyJhsGWCKkYbb0yutI8oVS4wHY77O8RphCHpFHqU9MBhOrIFQwodRTBb00pARywOGnCWwWEiZkgT56hGYDNRub/jhnwL68WE+am++WKTT97/I4HFDGHssttFrZSC8Gs+yN9dVaq+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=biCdxd8K; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-48b7747f881so476581cf.1
        for <kvm@vger.kernel.org>; Sun, 11 May 2025 23:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747032941; x=1747637741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Rdv2Oj6PjxrUDr3Wpxjp8KdpnO28ChM+WBnU2AoMT8=;
        b=biCdxd8KorVjuoLK/BH/xwY1brmQboX+hicn8RCI7WOuY6e/Kv1avf9w3083LKM1FO
         iJ5kBjeDLCFeRgRfipWRDHktOrwE+DNsXK0Oq7ISBSobeKiEUR0inVngUYX6OvpDsUGn
         IBb2hgg9ERxEsqltKOXumkiPDJPSZLz7kYGzqZ4NO/RsuXiCfjkbqnfVBKmw4WTiZbSM
         23ZATY7BcXRwf6nifZScu5ORiju/Lm2F+TUfNGIvdB1JpJJ4lT3OxhAnI+3I7v93NAO9
         8hGz1VS3qWKjfBlvhoiF/gFf2paQmED7NUB0zCNkTuSYx1r+3gAvLDkWX7iLle33B7W/
         pxxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747032941; x=1747637741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Rdv2Oj6PjxrUDr3Wpxjp8KdpnO28ChM+WBnU2AoMT8=;
        b=Q2xuui3mJnI2zbq6jRnRpHcL6UbzKWhoSmZSY2WcJY4swrK5QVoCqcBh1+/sIZjGWn
         uG+5mVbPuUTZxdmdlc6dQuohe0LtIVmnXvqTqpSzJOnoS5Fe5njI+nNlxavBAztQ/04K
         GThEU0t8JokdAQ6tL+7eV0zrJ7brXlRlFNm8HQSAgoqcmOv9jgj+8PPC1WxMNk3OgqwF
         vPs5THfx4KS1fGq1nlKeP2p1EjOT/9rqDpT543ZRy9+csv0QB+HJa7YxbnBeFNzHkSJU
         33DX399UwbwBzsNGSkexW5cczRHU44Zx/a0vKBmfz1P282PlAPh/2mvZsCN61Z0UMTXJ
         iacg==
X-Gm-Message-State: AOJu0Yx0NkAs0cD/4JGw09YUqCPzame1+TVFJcOeXwKDISU341mmggUa
	lwwmSC5HbTJbKlJypT9FxmiI5TDLaPnjPmQzJmv3msI5muEh/726DxntSNTTrvipAyZ5OrTzkRq
	/lKjyFv3fK6jAi+m0sqb9xuALLIDnGgdN8yAv
X-Gm-Gg: ASbGnctNx0osLhWD0JdlB5cFfGS8Sf39uCVsGf4FAxlPAg/avgQAccjVT+qBQR1lgDk
	J+4hZM/pScpTvw9OgMb42UiEH9mWoeZju1dkIWrHfFHx0z5C643bTgPOb2CW2H3BUFKRuGyinjS
	EjD7UnIMFhz9jSNEZBaQpkYigcZ4udN65s6w==
X-Google-Smtp-Source: AGHT+IEarhDwIJUMcttBWOkT6QLvF2r3YAAeuI0EkeH63L769WafbjxmViKBO5z558md6iNmMYdsUZC6wsk6jUXxDSU=
X-Received: by 2002:a05:622a:1393:b0:471:eab0:ef21 with SMTP id
 d75a77b69052e-49462d8cb4bmr6757071cf.13.1747032941422; Sun, 11 May 2025
 23:55:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430165655.605595-1-tabba@google.com> <20250430165655.605595-12-tabba@google.com>
 <CADrL8HWo_u4CPHDkSspiZFCgASw_LoUAYP07pueX5rBEM1yDHQ@mail.gmail.com>
In-Reply-To: <CADrL8HWo_u4CPHDkSspiZFCgASw_LoUAYP07pueX5rBEM1yDHQ@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 12 May 2025 07:55:04 +0100
X-Gm-Features: AX0GCFt4rU-O6hY5WKSeD7VBBC8pFPtj59ol_UZ7zRbYqrd9wb8ofthdjkFl24Y
Message-ID: <CA+EHjTwuXsARpK+zpxh7RodQ6_6_tYxj+Gq4rAg2kYwni1uM3w@mail.gmail.com>
Subject: Re: [PATCH v8 11/13] KVM: arm64: Enable mapping guest_memfd in arm64
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	peterx@redhat.com, pankaj.gupta@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 9 May 2025 at 22:08, James Houghton <jthoughton@google.com> wrote:
>
> On Wed, Apr 30, 2025 at 9:57=E2=80=AFAM Fuad Tabba <tabba@google.com> wro=
te:
> > +#ifdef CONFIG_KVM_GMEM
> > +static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
> > +{
> > +       return IS_ENABLED(CONFIG_KVM_GMEM);
>
> How about just `return true;`? :)

Ack.

Thanks!
/fuad

