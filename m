Return-Path: <kvm+bounces-19343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E489041AE
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 18:52:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D461E289F66
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 16:52:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C09E50A62;
	Tue, 11 Jun 2024 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YNu+MZQc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7248F41A84
	for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 16:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718124641; cv=none; b=lzqai19Cekgv6UJKxl+YyELvWInMdj9qXB5A3VSoRkvgsRt/8OXs0cUHJmtkjYD7lf4YhhOj2NTBmLK86/MiNDz1hBdWOgC+BGMfL5jlLep6taJWBsCULiwzv2fcTzJEEAwz0mRM5ZwVJJXRX4NnLkOAZ4woDYbu3ZSdYkxq/kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718124641; c=relaxed/simple;
	bh=ud1eQBnt2jG1UKvvjxzK8+sntVYqlePqwphUbWfbcqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GjvBOcA0mCc9m2ZBwnhRZWRQrzoEbnM10W01qvDsGOgwJNVwgNhws+3vnVnVjoNTTHX3Eb+KNV49ciSpkXlT2N89iNgarwuOwpmztTzi5V0ZHal+zCS7/ar/UcwmHU3vspWw4Cj0vAOQpiBTEPoGPP4Iif0M28/LXCL1diMVUB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YNu+MZQc; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4405dffca81so224321cf.1
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 09:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718124637; x=1718729437; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ud1eQBnt2jG1UKvvjxzK8+sntVYqlePqwphUbWfbcqQ=;
        b=YNu+MZQcgIrm0zCG3Jv14XK1IEdrEhrZAZ0xQyOSVwkVruaIvgvxITwe1gzMr+h3bq
         tAIkglRY9ZZSywqkFFzpyWYAOd+6JiY4bFTKwIq4MDjscU7mn9ldDtva2JYzK6f3G0s6
         dbCKw29LXoB0f1WiHSXwOPE0pY+7fzC2jiUfg782JRh12i+azV8VwlyFIWDLivBcYwb3
         XT3YueKhACKth9Lz6eCmUpw282X99EaVRmhDOi3ROQDx8F9EloquYpeM9Yc0bVOBJeRG
         WZTrKOEAq/f0xsQI3aHud0FP5nhz2i02aGuoI62i0HK1K/ii1jMkDCmdInIIJhqlg0Ws
         AncA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718124637; x=1718729437;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ud1eQBnt2jG1UKvvjxzK8+sntVYqlePqwphUbWfbcqQ=;
        b=Nkah0yBMvQfiRS0jECjDUqbps8PhKdRpPngExF2oUxETHbCBwEabxxQyma/Mk3X+iB
         YaTZnidrJgghEkhRo+I5X3lBMj2IOSIpUMhKGnvWMj6xXSAOLkwNt1QMjng2pBYgU0a0
         ptDqqG6J2+8KMhxo30YPVqoHGDryts6vv7JtPvGRo9h4yFMuv95/vCgwWQL46DkCtTyN
         m2xMulu9ZZXttU3k6zGcp6EIwPQQvI+SRyEVqPmyWLzlTHp1/dTGDhPX6dXwiYxbQrZ8
         kafD6FbmjdLJD71pIJGS/TQmypC+auc5E1NoRNEwrZMLuK9tSOCSawn2MZeIFeyg7KGf
         od0g==
X-Forwarded-Encrypted: i=1; AJvYcCW5WznofigIpi3hfHrOhRrOWKd0+pvQtiwjZlVk5Z5eFXh7BmhEFRnzsmQCsSpmb8WHNukKpxWvrmQjSZ9MBSLAyiI3
X-Gm-Message-State: AOJu0YxjafsA9Nd/CFGzeNQ6gqra6qjIkuYatbqU5Ib0gcACHRgIV2T/
	W9nKnCDEg6Hor9zUHoP3Itrb1yZjBdNdGKBfhr65j65VqSjs6O+fFo4JfUQlX7w8x3TW7N0SKEr
	oy+JSGysPJm1EEUz+VSwSYf9e4wwlez6pwVbR
X-Google-Smtp-Source: AGHT+IFTRKU/IN2oUvb5h39ozwdgDveDjgoFuty1h8DKtr2zokbWin06W/kJ4wicF03AaijkmKBkMyI8RF9KtoZUsSE=
X-Received: by 2002:a05:622a:6103:b0:43e:3833:c5e3 with SMTP id
 d75a77b69052e-44146f10983mr2981601cf.11.1718124637169; Tue, 11 Jun 2024
 09:50:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240611002145.2078921-1-jthoughton@google.com>
 <20240611002145.2078921-5-jthoughton@google.com> <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
In-Reply-To: <CAOUHufYGqbd45shZkGCpqeTV9wcBDUoo3iw1SKiDeFLmrP0+=w@mail.gmail.com>
From: James Houghton <jthoughton@google.com>
Date: Tue, 11 Jun 2024 09:49:59 -0700
Message-ID: <CADrL8HVHcKSW3hiHzKTit07gzo36jtCZCnM9ZpueyifgNdGggw@mail.gmail.com>
Subject: Re: [PATCH v5 4/9] mm: Add test_clear_young_fast_only MMU notifier
To: Yu Zhao <yuzhao@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 10:34=E2=80=AFPM Yu Zhao <yuzhao@google.com> wrote:
>
> On Mon, Jun 10, 2024 at 6:22=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> >
> > This new notifier is for multi-gen LRU specifically
>
> Let me call it out before others do: we can't be this self-serving.
>
> > as it wants to be
> > able to get and clear age information from secondary MMUs only if it ca=
n
> > be done "fast".
> >
> > By having this notifier specifically created for MGLRU, what "fast"
> > means comes down to what is "fast" enough to improve MGLRU's ability to
> > reclaim most of the time.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
>
> If we'd like this to pass other MM reviewers, especially the MMU
> notifier maintainers, we'd need to design a generic API that can
> benefit all the *existing* users: idle page tracking [1], DAMON [2]
> and MGLRU.
>
> Also I personally prefer to extend the existing callbacks by adding
> new parameters, and on top of that, I'd try to consolidate the
> existing callbacks -- it'd be less of a hard sell if my changes result
> in less code, not more.
>
> (v2 did all these, btw.)

I think consolidating the callbacks is cleanest, like you had it in
v2. I really wasn't sure about this change honestly, but it was my
attempt to incorporate feedback like this[3] from v4. I'll consolidate
the callbacks like you had in v2.

Instead of the bitmap like you had, I imagine we'll have some kind of
flags argument that has bits like MMU_NOTIFIER_YOUNG_CLEAR,
MMU_NOTIFIER_YOUNG_FAST_ONLY, and other ones as they come up. Does
that sound ok?

Do idle page tracking and DAMON need this new "fast-only" notifier? Or
do they benefit from a generic API in other ways? Sorry if I missed
this from some other mail.

I've got feedback saying that tying the definition of "fast" to MGLRU
specifically is helpful. So instead of MMU_NOTIFIER_YOUNG_FAST_ONLY,
maybe MMU_NOTIFIER_YOUNG_LRU_GEN_FAST to mean "do fast-for-MGLRU
notifier". It sounds like you'd prefer the more generic one.

Thanks for the feedback -- I don't want to keep this series lingering
on the list, so I'll try and get newer versions out sooner rather than
later.

[3]: https://lore.kernel.org/linux-mm/Zl5LqcusZ88QOGQY@google.com/

>
> [1] https://docs.kernel.org/admin-guide/mm/idle_page_tracking.html
> [2] https://www.kernel.org/doc/html/latest/mm/damon/index.html

