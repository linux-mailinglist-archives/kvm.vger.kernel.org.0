Return-Path: <kvm+bounces-62959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32628C54EBE
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 01:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE9973A8D75
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 00:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1882155389;
	Thu, 13 Nov 2025 00:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cVLW2eG/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBB41E868
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 00:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762994243; cv=none; b=sXGLBq4Q2zpn9/7rQ5y44LD5VN6DuZBkDvk88gUOe87U76Wt1GObnshJXHczI5jwinMm3ib+iY/reVt0bx7/6OcaQFGgM7SLAa9mFVp4j+FP0rMugCZtPG8pX8c+jZJO3+ybspCgAGNZ439cC2mwiS6FJMu2KRx7YgAn/uN2rq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762994243; c=relaxed/simple;
	bh=gQAFEkuis6MxG6DQ2tXr7tvJKT50Xpw9bu5kwP7LPfM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ddv6MA8TT8aXtNcZVWmVypsUelqVyGwSBhSdFXl/nNkP9NP/PDw5d7vLTGTg7rstgKNSXEKZ4yAbbwMN+r9vb67OykWSe3C2oJUG5AyDchEQLhBH6GCNW5GwQxRh58o/9QpEWFrZYSHmHx3BzBj2ai9snqQx0eudUT3qk5CulPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cVLW2eG/; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5930f751531so189823e87.3
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 16:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762994240; x=1763599040; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gQAFEkuis6MxG6DQ2tXr7tvJKT50Xpw9bu5kwP7LPfM=;
        b=cVLW2eG/gPr1sJMBKzZEY21OMPLNeE6ftCtoZGHFrgcHGQMGOmRzQwNKGGJstI1jGa
         Gg6Hv5kPDIeXEeO8S4KLCDmgwMymhkrsr+tePT1TYm12oOLrpQUaMdy41Xv7IODsHaBw
         jjAhtP4CWpRn7sqY7/yBtNDygBBUn/od2EdUKJ54dbbYnV6oJSWwo/r2ZxUTe4umFmp1
         HuRpJvZNBLZKXi5egl/3aUzoLFntjduxNVHuLz5MAgQ7T4Zmiwz8Qe1syrNpqiYkWyJn
         t0y2vp2sgvULVGYQ/k5JNQWy6YWdm1qWIQOeI+2bdT+QL7pGtDdMfADQPU/asLIz0jjX
         72NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762994240; x=1763599040;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gQAFEkuis6MxG6DQ2tXr7tvJKT50Xpw9bu5kwP7LPfM=;
        b=L5Wnz1qizwnL9RvoyCWeLmnJxUSBUBHczC+sKCWWkFZZ7Hl2eywofVJWY4lYpu0LoE
         It7QTiLGujcvgXuj/JhyTbd4HOr7J865La5yw+L37KmLS86wxgbqmfIWbkPhFIPD2MMt
         hgOb3hTSZ5xLgy6CE3udNsvs9HfzvUQF0dVclcrBJ7Ybz1oEZf3cNTxpMfC+XtTWHKcS
         NLK8htrUnov4lqB//BgGncjgmKPa2XCJV3gJAh+sV9mQnApY31EkrBTvTpRGfjdvn4/+
         0yjgoAm67onzIk4QgNzAR1NfnCxgYX5fYX7klnmDi9ZuedNpR9deQOCs0wCc6khMstij
         Ccvw==
X-Forwarded-Encrypted: i=1; AJvYcCXzjh3u75Es2WtwhQ+PJOkTrsDwfX0SvZHS02R8jAG+PqLjG9rFm3kMY+9Z1VvvzTIe970=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCMZVTnIkjeF5Wa4sQFyuoBIkomHzZ94qpMzbBjG17zMYGnIz2
	BOXvyjlgeQuMI0yEVA/YyfPHkNxXdUuGO/ofn706x665AU+lHtqBuMHhCbW8J9uBKrzBwVpBeQx
	3RQqiJ8/ThOdY+vFGZ/BPkB8Hj7JmRtB6hUosMtKO
X-Gm-Gg: ASbGncsQWUXVC9stwT4/rEOt1XOUr6zYIuJX5HA6oWZP3EjYyq3oZRItVKfDX8YQHNI
	yXz8fH4kGbbc05xqPv2aYQGzjd/Kk4BwDC28me/QWlTb1hjoADCR2Igy/EiBx9I8LP40qSyEE5I
	fT2wCKjLOmktjqudo2XwdjQpVooR1Bzg5olOB+Dc2UV30C+G5G2Xq2iNtTXaOGFCfU8+Hd3fYpq
	r3Ss9KpvEk1m+TDmSB3z1SEISeUUURhz82rjPlFudH+mtpEznlD2RQ94hODB3UD840Pc/M=
X-Google-Smtp-Source: AGHT+IES/CJsPbrAgyWQnLon15KjjafWzvib+JwHwpBetgA1Zmgy6sN5eKJD/4qlHX/bLU4ksRV0aZSNvBB5EL/4rWs=
X-Received: by 2002:a05:6512:3d17:b0:595:7daf:9425 with SMTP id
 2adb3069b0e04-5957daf9557mr931008e87.28.1762994239481; Wed, 12 Nov 2025
 16:37:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251112192232.442761-1-dmatlack@google.com> <aRUFGHPe+EXao10B@devgpu015.cco6.facebook.com>
In-Reply-To: <aRUFGHPe+EXao10B@devgpu015.cco6.facebook.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 12 Nov 2025 16:36:51 -0800
X-Gm-Features: AWmQ_bk8b8m7l1BLL99RYzxjgrX9eX0t8GUscVQicIffm6eZO-IaDbPjTlCoDjg
Message-ID: <CALzav=fYCutTptee2+9ZDYChxDGFUaOytSwmf4qZhFTRSGRGNw@mail.gmail.com>
Subject: Re: [PATCH v2 00/18] vfio: selftests: Support for multi-device tests
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, Alex Williamson <alex@shazbot.org>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Raghavendra Rao Ananta <rananta@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 12, 2025 at 2:07=E2=80=AFPM Alex Mastro <amastro@fb.com> wrote:
>
> On Wed, Nov 12, 2025 at 07:22:14PM +0000, David Matlack wrote:
> > This series adds support for tests that use multiple devices, and adds
> > one new test, vfio_pci_device_init_perf_test, which measures parallel
> > device initialization time to demonstrate the improvement from commit
> > e908f58b6beb ("vfio/pci: Separate SR-IOV VF dev_set").
>
> The new test runs and passes for me.
>
> Tested-by: Alex Mastro <amastro@fb.com>

Thanks for testing!

