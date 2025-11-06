Return-Path: <kvm+bounces-62222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4522DC3C877
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:42:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6504C4F3D6E
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0B0C35028B;
	Thu,  6 Nov 2025 16:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FgfXQ2Ep"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974433314CB
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762446814; cv=none; b=fVYPVcfU+LgnFlT6qXTrdH2KPBZ2xTsE2JaY1dPmU7vRMHXz0EHbTbVWliil8CEh4FYx40U+SY7G6//aGBeNwhT9sEGxJaOFNxrGm2aSHqeCBhWyTistibxp4SKVVFIR1RBqq8KSE6HvHYycE5vXdkHcdYQ7JXzY2NImKgPdXE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762446814; c=relaxed/simple;
	bh=5ihuDeqsYQ0psikMxLSzF19AqAAShlKz6wsIdUFp4WU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SJ/osCy5mMRSNMlXSk1x8U84YT9ZpZHqnCGjgq9Wpz3vqG+0UcQeZRn5UnZyZtHTNzu/llPuXalRaxqqjaUQgWB8MAPLkywoazkhtFnXCc73UhL6JhVBB+MsxiRWTQjqXWDcFRWLJbm03l1MuLcBDrdJHFq0ROShJy5l+34NHzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FgfXQ2Ep; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ed6ca52a0bso328291cf.1
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 08:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762446811; x=1763051611; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnZy7OiPe/kS2Rv9Wy12Swhc5j0bx/uxDP7H3ZzWM20=;
        b=FgfXQ2EpMNBcci4CetxscIG0V4Mueb5shGFITySLZIDUOMsdvqtJYJeuI5X9cF7MAq
         wHTcxIfnENX63Wa192zliRtYQmYTJ4mj+wltbT3IzEUCq0BiXIFESuXWRId9y5nZojar
         ICrRMNI259tYOi7krTRtN9u/ijN9ICe4G7y4uCe759kw7qDuXnt7HKcsmBJX6BiqmPzw
         Xzqckd6WDV4tm3GdfBKY0w2xowNPYkbhxxdHfZr1UTCIq1AgMkvLJBvZTjYNbFRScF0J
         CIqGyl3+tzpUi8hhP6SASjyqklTrt9Kv8HxIziE2NUVaKxGXZ/XaXQAfPn6m0QUCqWxL
         1tKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762446811; x=1763051611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lnZy7OiPe/kS2Rv9Wy12Swhc5j0bx/uxDP7H3ZzWM20=;
        b=RovsRSsEL3FYqJdjTeQrqL/K1KC9WNDnjO5Ret3s38jYWIEfn6Jin3NxskBeas+wuc
         2WFmZov0FbqurtEemW4jTebDteR7qqO1C81+ZuwQzBoB0hBGHaecP6+dr5JvhRwjwgPl
         u/Zgmxfk9kqTOvqDApI6X18PMyaAFmsj0E7HnHqnVniL653mVXKEqsd5IsTGtffpU1Y0
         kuKZ0cKUcsk87vv20QyR1lZwt3kE2IDthtr714es0ItH5+vFbGF49hDBTAOZy6/LMXzY
         XUjvcWCv9RpMe32YgvR1Gj9ldyDJnlsr8afxTGXNQtVE40ASjq1Cf1vOdBKSSzSIsgQD
         wx+A==
X-Forwarded-Encrypted: i=1; AJvYcCUuw3/OaaWiWd/3WgME8hb/CeCnWXqUt4SQ87a2p+yfLF63LHXVH+NRjHtgrfDt/pZBEJU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPe7ZuVIDL3nlIS3U3+jRHwXJIGIBSf8coY0ilaDnFcd55fLZQ
	GzJygVGno6MDEGSEnt7kTeGQbLXjzg+qGUJy5q+hswEP3pty+wjqwtWZOCsW6iTAt941WZSZRY5
	USR4txhKYl16ZjNCn8auqMFt9U9cMp/rVWbfg1XlL
X-Gm-Gg: ASbGnctcADZpGra3Az20uV8JcALpjVqmxUUEcaTsP/yaxTdxgjKxtp2rKxKtbJ+BbSO
	72RF4ceWZ37f8rIWkzit7DMnwtTPoLsn2FV+z6xdQR54eu7qo8HzfWk7MUb3K0xeR+2RvVsgQkE
	e/66/45Yoq78V3wLj7O6qJSy1xBAgdVxd4Wf+OJXEBidpGHDcOtL4nqW/SMDdpY4e5MN5PavcBT
	l/cyl/ovJH+H7/yDfg1jgymdZNgJl0kSkTbGMhNr4aHE49HllakCMPUjetQ
X-Google-Smtp-Source: AGHT+IHkFFTqQuW3CEPcoZzja9ixONknh7QDVB4aPSigXJPx2frRev2iHo0yg8eQxo4ySjq4nFKmcGplZ7r9pitYqzM=
X-Received: by 2002:a05:622a:60a:b0:4ed:341a:5499 with SMTP id
 d75a77b69052e-4ed82bc69e1mr6700211cf.11.1762446811408; Thu, 06 Nov 2025
 08:33:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251104003536.3601931-1-rananta@google.com> <20251104003536.3601931-2-rananta@google.com>
 <aQvjQDwU3f0crccT@google.com> <aQvn1b9sspmbYQVo@google.com>
In-Reply-To: <aQvn1b9sspmbYQVo@google.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Thu, 6 Nov 2025 22:03:19 +0530
X-Gm-Features: AWmQ_bkGLaUZfEme6FxbIW7ZkiI0Va_bGW9y5wLoRjtgBHqe9dY7AfVYeS3floE
Message-ID: <CAJHc60z5wX7My+2TYGjV4DYYWow=v9XQH8EQNP+WVQdq2LoxXg@mail.gmail.com>
Subject: Re: [PATCH 1/4] vfio: selftests: Add support for passing vf_token in
 device init
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@redhat.com>, 
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 5:42=E2=80=AFAM David Matlack <dmatlack@google.com> =
wrote:
>
> On 2025-11-05 11:52 PM, David Matlack wrote:
> > On 2025-11-04 12:35 AM, Raghavendra Rao Ananta wrote:
> >
> > > -struct vfio_pci_device *vfio_pci_device_init(const char *bdf, const =
char *iommu_mode);
> > > +struct vfio_pci_device *vfio_pci_device_init(const char *bdf,
> > > +                                         const char *iommu_mode,
> > > +                                         const char *vf_token);
> >
> > Vipin is also looking at adding an optional parameter to
> > vfio_pci_device_init():
> > https://lore.kernel.org/kvm/20251018000713.677779-20-vipinsh@google.com=
/
> >
> > I am wondering if we should support an options struct for such
> > parameters. e.g. something like this
>
> Wait, patch 4 doesn't even use vfio_pci_device_init(). Do we need this
> commit? It seems like we just need some of the inner functions to have
> support for vf_token.

Gah, that's my bad. I changed the approach later but forgot to revert
the API. I'll fix it in v2.

