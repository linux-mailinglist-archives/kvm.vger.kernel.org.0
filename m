Return-Path: <kvm+bounces-14523-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A108A2E06
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 14:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E584283E33
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 12:15:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A2C856444;
	Fri, 12 Apr 2024 12:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WIVLGs8H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE57E56450
	for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 12:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712924116; cv=none; b=cCqTkuTl/aytcm53p2Y6v9FaL9Mw6PhwZU0ZY9li9XHDc5kXwOMn7zGgvnEnQKApLYe49/QXUGBLiI+jhUs9iqlj5ZM7m9zdYKoRwC/jhw9fpxZWqouE+71WZcHAAWAGsQEsYTCjsHf4sfa4LnSiWU1uEf2fomG738CavEcVKvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712924116; c=relaxed/simple;
	bh=jMgsflWuaYWNYa9dlh0cqvvdrhZy9tcBnp+Jx8l3B5U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q4OPP0+locfMLBUwKCWqKHKgjpjrGh/OOCR40mH7RHjMFqNodCJeW3GCAMAEtuOKy6+qvXl6BMr4o6A2Bwz38t4XMbRpM1V/dibSoysLAnV641aGONtoSS0tcvj0YvQLvxss0LkpYPr9DFVBhwWDYq5M40D7aOfzkJ05RrG+cVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WIVLGs8H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712924113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kbg/AnMCE3YNGZKUUT6bVQZJO+XQvmdhDaWbX3/3Wzc=;
	b=WIVLGs8Hw0HDya4Ua+1GWTJbf6IxEG45+jDaf+PAg5SppvjYTPp2N8UxyQbqhPRpofcICr
	F64/NIZ2Q8TmKBYUO0+abw6+mHxu85BPN9ZqLabXGRe6cGI0/hqcKbkDf72+qT+2qXiYz6
	iM5XQJgxCxLZZ4vLxJmTY2GRLCvkm5I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-6DKbjlsLOSu1oFMU-9L1xA-1; Fri, 12 Apr 2024 08:15:12 -0400
X-MC-Unique: 6DKbjlsLOSu1oFMU-9L1xA-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-417f13871ddso3378755e9.2
        for <kvm@vger.kernel.org>; Fri, 12 Apr 2024 05:15:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712924111; x=1713528911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Kbg/AnMCE3YNGZKUUT6bVQZJO+XQvmdhDaWbX3/3Wzc=;
        b=B/ClI7qhy+lStrcE9UUL88mbI9Tjx1Ttp2eqjKWIg+63Sd48uWsK/dOYdwqmBPhzHa
         rC2IHfyZhG6HCwy1YqxxVaf8cFz+v6u7Hvx07/3+dLHH71W6N9klvZsKAq6H4apIog3d
         mTwqrBTKMjqsKKeNcs3ZJVtRwZkdIsp0BmBpTMwetfZeiCdz90Tvj5BOdhAC8yKVCRIO
         j6L+ueXKhAlh7ig29nGHGPcS3RG9+cLOAU8dNsnEpTvlERWVJM4m9bDVgfmeTZeLgCkA
         2BxPvxzutx0Q/XoLVv0FbR0nDGRdj1lmuTAJL5rWwkCjpWCnRJXy8K8knJUi91Vhwr5k
         8TOQ==
X-Gm-Message-State: AOJu0YwzYnj6wRnZkmenNtbt1ZHdEBTYZhiRgQxXCjpNqqwmJ6cjZ4l5
	q0QO+8ZYCw1u8Zo7ug9kzfBoGuFj6suRJCzpEDRmOtDWa3NK0b5hoLqzygnO1GBCkKOV+uuqPTq
	tv5AxCQXo+ls9L2gW7eHWwilIC0PcTOOhImjCk65J9BrW1516ThqQK5LlxBfLi+AP4EjjqbwcAh
	LalwHAlBmdRoVYWeDEpthIEC0FUscp2chj
X-Received: by 2002:adf:f984:0:b0:343:90be:f8b5 with SMTP id f4-20020adff984000000b0034390bef8b5mr1811576wrr.36.1712924111092;
        Fri, 12 Apr 2024 05:15:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0f/Lal1JjP9dKNlIEcj9MMuXsHp5r8ZbKIS/SX6F6aPygKHGgkqTo1ZIYnBysCL3cQkaQ5/QML9YKp4gg4WQ=
X-Received: by 2002:adf:f984:0:b0:343:90be:f8b5 with SMTP id
 f4-20020adff984000000b0034390bef8b5mr1811562wrr.36.1712924110759; Fri, 12 Apr
 2024 05:15:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240412133407.3364cda3@canb.auug.org.au> <20240412133516.0286f480@canb.auug.org.au>
In-Reply-To: <20240412133516.0286f480@canb.auug.org.au>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 12 Apr 2024 14:14:59 +0200
Message-ID: <CABgObfb0Sm8z8u2269+oiR57fxAgh74JURDRrEebhFAaPNKqGA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the kvm tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: KVM <kvm@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	Linux Next Mailing List <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 12, 2024 at 5:35=E2=80=AFAM Stephen Rothwell <sfr@canb.auug.org=
.au> wrote:
> On Fri, 12 Apr 2024 13:34:07 +1000 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the kvm tree, today's linux-next build (arm
> > multi_v7_defconfig) failed like this:
> >
> > kernel/events/uprobes.c: In function '__replace_page':
> > kernel/events/uprobes.c:160:35: error: storage size of 'range' isn't kn=
own
> >   160 |         struct mmu_notifier_range range;
> >       |                                   ^~~~~
> > kernel/events/uprobes.c:162:9: error: implicit declaration of function =
'mmu_notifier_range_init' [-Werror=3Dimplicit-function-declaration]
> >   162 |         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm=
, addr,
> >       |         ^~~~~~~~~~~~~~~~~~~~~~~
> > kernel/events/uprobes.c:162:41: error: 'MMU_NOTIFY_CLEAR' undeclared (f=
irst use in this function)
> >   162 |         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm=
, addr,
> >       |                                         ^~~~~~~~~~~~~~~~
> > kernel/events/uprobes.c:162:41: note: each undeclared identifier is rep=
orted only once for each function it appears in
> > kernel/events/uprobes.c:175:9: error: implicit declaration of function =
'mmu_notifier_invalidate_range_start' [-Werror=3Dimplicit-function-declarat=
ion]
> >   175 |         mmu_notifier_invalidate_range_start(&range);
> >       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > kernel/events/uprobes.c:208:9: error: implicit declaration of function =
'mmu_notifier_invalidate_range_end' [-Werror=3Dimplicit-function-declaratio=
n]
> >   208 |         mmu_notifier_invalidate_range_end(&range);
> >       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > kernel/events/uprobes.c:160:35: warning: unused variable 'range' [-Wunu=
sed-variable]
> >   160 |         struct mmu_notifier_range range;
> >       |                                   ^~~~~
> > cc1: some warnings being treated as errors
> >
> > Caused by commit
> >
> >   b06d4c260e93 ("mm: replace set_pte_at_notify() with just set_pte_at()=
")
> >
> > I have applied the following patial revert for today.
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 12 Apr 2024 13:27:20 +1000
> Subject: [PATCH] fix up for "mm: replace set_pte_at_notify() with just
>  set_pte_at()"
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  kernel/events/uprobes.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index f4523b95c945..1215bc299390 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -18,6 +18,7 @@
>  #include <linux/sched/coredump.h>
>  #include <linux/export.h>
>  #include <linux/rmap.h>                /* anon_vma_prepare */
> +#include <linux/mmu_notifier.h>
>  #include <linux/swap.h>                /* folio_free_swap */
>  #include <linux/ptrace.h>      /* user_enable_single_step */
>  #include <linux/kdebug.h>      /* notifier mechanism */
> --
> 2.43.0

Fixed, thanks and sorry for messing up.

Paolo


