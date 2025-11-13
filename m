Return-Path: <kvm+bounces-62958-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8820DC54EBB
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 01:37:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5EC5E4E2001
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 00:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3715E14D29B;
	Thu, 13 Nov 2025 00:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="viNgrp3B"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8E318E3F
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 00:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762994119; cv=none; b=QlDZh/kxYLiAZQ/vRivv6c5lDmGyGPTeGKRlNtEeZDwqSrlJFGWwb7kG5odBEdBdmHwrCnKeD1O19dM+uR+jaUwD2q2468NzBUraZ+r2LlU71jAlfgzJm+7baDiVNGz5HKUtIrEgsS6O1qlHTGh7crI8Pbyuwtpykl9A+kj5g8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762994119; c=relaxed/simple;
	bh=pqaWapcSx1fG/eg63jrW4womW8bqwrPCzR9rpSBWqUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SulFgJFc0UnUcbbYY0XuKq4ipeWr+32u2KlF+MnOvp9l5nmKQMY9vOKCV5gtXrkcmPirpKCxKFVhyX14a9nwYTUVGmcparbVd/8Xm/qPyBujvkemzuscOlelZUVAseypHzbsIqTUyeiZYOagg3SVYlUaedFfKMTe72+kRN+1aFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=viNgrp3B; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5957c929a5eso290206e87.1
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 16:35:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762994116; x=1763598916; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tkmP58eOOzM61HVymH4b01vkY2iRcbp7BM0yKv/+Lgg=;
        b=viNgrp3BaPYr7S6e0enLdqUp6skcvv3zmFX8C2ErAvx9kB+AOwOgXfPam6Yy0i9wf/
         n/Jde2Of5BoduLoucZUhHRoS4meM79cwQQmj/kHvgmimr853dri4T+2AzdHQpqxeEZbE
         mXn2GTv9oMWw/nCp2AIOI6I6ktZz5F16NLxy9K4vUi2Bp4ZWfPd6IAPRzkVeDLWCug/B
         zXWJgGR7IDtnfmcj0Np9B1DR/ZZnyfmCmRlMTNrisZFRUu8qJ1IAyTs47MOT/xlX4FKc
         QqXxr9hrNahE2eHpSytr3qH3R5U8nANCsgs7YquxpCFiQWTkgP+1Lau2OassQS4K/jBZ
         zdAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762994116; x=1763598916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tkmP58eOOzM61HVymH4b01vkY2iRcbp7BM0yKv/+Lgg=;
        b=RDRyBvM6+FUjqtW/gzlpi8ZrrG8sviGYEkC0CoFrgIoxmba2YfmRi9Oq5Mn5I6tqwY
         nTazfjtyxWUvHGui0XxlGm/WIy0sXf20J1yi6hUDH5/Qsk8AYRbFC6YlgO5zcXbVLrHd
         LHfkuaVQTiZsuALB4TArR93jYLXs54l28xqZICVX65xOtluhHbnA1E9dfiNt4z/MRD4w
         mUGE6KgVIy2yw2rJPQbHG0Lrl2PnizpHztieULY49Lb54jrIsNFbfu12NTLQJN8+NbqQ
         5a70kNsnDhALOT0wAxuq++TbPcc+GHOzZgF2OgZA45f0z4re75Vzqk2mBKixor3S12mR
         dNlw==
X-Forwarded-Encrypted: i=1; AJvYcCXlCDiHeGWdBGw84JU858F2ZFLG5TkmpnaEu0pVfjdiiL3qbDC4zaceKA9i97LaUw4PU6Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZWWxVCxs9Tqy/q0UqTRxLZ8KA97TDIwj/8nKOunop+Yagljzo
	zhrMRI7dBXsMfpTj7YGutwdfPVLwwIYJOVL368xg80RefwwVSxyG2OFJ2zz/l/rb871Vax+ksT2
	5C0syf0p+edocAvvaE2ZPDaduG15zvm50iTQ/86Kh
X-Gm-Gg: ASbGncuR7hOD+Pjw75DCmF//qltZdkMyc6zHOBQlhF+Mn1p15RINBD4V0gnWNVIo33R
	8SfqBlKsfkIGmGEqjCUN1dwLLUQu0cMmioko3wSTV+Ue/Y4jRQi3qjAY1XQqfoErI276wwD/WNJ
	9oBr0W89jhZEE17TDC1uxFTvJ4iWHyRPVHj7zyL74SkcYq7ZsAkjXLl2jHt8MPUzGV156R92Y2j
	w15V+556h4+WX3lsMXTgDLKfE903OH2UY7ugPPNlrRYr4T6ziCVdGfZdOFfj5H8B3g+Cjs=
X-Google-Smtp-Source: AGHT+IHS/Kzh0J9JYNHr2D3ULKDt78ThxpCQIIKEBGFx1+HIJhZiigh8difVsCMYmuVEig16Ad6HrnNP542iimGxtQI=
X-Received: by 2002:a05:6512:2c90:b0:595:78e2:fbe9 with SMTP id
 2adb3069b0e04-59578e2fdc4mr1629903e87.4.1762994115701; Wed, 12 Nov 2025
 16:35:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251112192232.442761-1-dmatlack@google.com> <20251112192232.442761-19-dmatlack@google.com>
 <aRUQAg1kNVzfKkuv@devgpu015.cco6.facebook.com>
In-Reply-To: <aRUQAg1kNVzfKkuv@devgpu015.cco6.facebook.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 12 Nov 2025 16:34:47 -0800
X-Gm-Features: AWmQ_blBM6dOH1o_M6QHhvqvhltx_Al5yFrg6jKCV2WNKsSpZRUCPCb5OssgibQ
Message-ID: <CALzav=e3ZQsVEGmRFAZ1dmMg+SVkBpEzgzpUMJw3LSA6NZJw1Q@mail.gmail.com>
Subject: Re: [PATCH v2 18/18] vfio: selftests: Add vfio_pci_device_init_perf_test
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Alex Williamson <alex@shazbot.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Vipin Sharma <vipinsh@google.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2025 at 2:54=E2=80=AFPM Alex Mastro <amastro@fb.com> wrote:
>
> On Wed, Nov 12, 2025 at 07:22:32PM +0000, David Matlack wrote:
> > +static s64 to_ns(struct timespec ts)
> > +{
> > +     return (s64)ts.tv_nsec + 1000000000LL * (s64)ts.tv_sec;
> > +}
> > +
> > +static struct timespec to_timespec(s64 ns)
> > +{
> > +     struct timespec ts =3D {
> > +             .tv_nsec =3D ns % 1000000000LL,
> > +             .tv_sec =3D ns / 1000000000LL,
>
> nit - I think you can get NSEC_PER_SEC from #include <linux/time64.h>

Thanks for the tip. I'll include that in v3.

>
> Otherwise LGTM
>
> Reviewed-by: Alex Mastro <amastro@fb.com>

