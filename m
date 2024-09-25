Return-Path: <kvm+bounces-27394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B3037984F6E
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 02:19:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41E711F24501
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 00:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBEC6D520;
	Wed, 25 Sep 2024 00:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HCxS3GlL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3286FC8D1
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 00:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727223540; cv=none; b=CHbUbFgtd1qt2mTG9Gedi2J+DXWX5BOKzy7s3/TFS5xlOAPgnc1JwOHgWhWv3lk9Z0yKmgjN45KMeC8/MqpLWPWuX/AulvuABKxMZINP5qxMFKQuZLfdAYxchFOQSwu8b5q/xqDFGECS8NYvKGTp7rUo4LNB2v509w1z7KX+PKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727223540; c=relaxed/simple;
	bh=Yv16jQk7rEGBbw8xL1Oe3JyYoI/jGzct9FQFpNOnJ2g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lM2wrdg3MFVOuJBfpZprj+AsMHU4wEPIciVIn5YR9NQOx3kvyJsjSED+C/RxnCzAxJgwgiAeqPB2UaipE+HtZ0MQ/jI5AHJqYHZr1Fajx/NhY9m2Nz/Gk8FdZo4RX3O7r7acHt1BeXOK8NbwyZbb1WxPOalr6pYX3Yfw+AuMz4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HCxS3GlL; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a910860e4dcso401705466b.3
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 17:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727223536; x=1727828336; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Yv16jQk7rEGBbw8xL1Oe3JyYoI/jGzct9FQFpNOnJ2g=;
        b=HCxS3GlL9IopEjyZNgZ3iqTV33nMHRUYHCDSEcmSy5/4Z7gioJklktqQNoB4T554jN
         nYNfUP6DMmO8QEQeIaDG0qCkuC0zpQhd7QNNRwHlRsBxpem60usAXY+mpOp1MQmG28+4
         xFqqp1oEsUt8RcRzFPA1oP3O7D0BnlyVxWKzB69Ea+ws3PtP5K246qDaKut6vkXosa0E
         4ONNe950YSeapHVjCSUBzUdP+khswQ3jZKXEDYJk2VnARksZS+Z0HcHLKVbSqWqgXh/J
         yggVaYBKCXlZ3acxW9MrofB9OoUT9QFvjiXDkvWx5vmAse6kHv0H9YmcB1AAB3QdbsyE
         y+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727223536; x=1727828336;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yv16jQk7rEGBbw8xL1Oe3JyYoI/jGzct9FQFpNOnJ2g=;
        b=RHmicDU72XOLggkO8RSD5/7nRSZFB/SCrRxgYRkLd3VyuKEsAfMhZdbDMZw1Q6g7Kh
         qLYFZlo0ZDiR5m+RFFK85s4inXfzaa5+oUsvIKzDbFvE7jmSYKMxHd5SsUTPqGpVXYcI
         pMZSI+KtyeJqOs7JWEiOKKNap3M2flbfjtxt3nPGpM9bNy11GBeIjm1vws0jDT1YhnBh
         QlmUFGQ4liO9Jo7fJllJTzwxcCwx6c0JNUtT/JgagT5eEdMHkCQDocDzN3KrzyXcSIh1
         3rOCFW/ssGDwhekrJ21i+8P9TBouZxlLuVUF+OjRXDyStk31nq5Yxdg3FfiyuCF/SUcK
         6yJg==
X-Forwarded-Encrypted: i=1; AJvYcCUz2ql1T+rrS4ZQMu23zHBSTs1mkjkKZhWt5s3V/49KmBxiN7DLiwjm3iKV81wfgizzMTs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiQeoqYnoCwDUrVE4n0yZmiPUx6aMO1yXQJ0uxQZ4WzEDtblz5
	xvjLbGve8EKijtam6GjsyQVRoZgZDahLQamuWXXMRp8qs+M5L6EXDSXFCWrfUFkmw0UdvEJaFMP
	SIND0k6C6aE7FKjWT/8cf1vDhmuM=
X-Google-Smtp-Source: AGHT+IEt67eLPjMCYEnb/Hd0k2bBqedjSfc1C1Ro09JNvTH+9QxA6VQ96hJjaslvRI44SDV9U2WgAsDL1SM/NUINiL0=
X-Received: by 2002:a17:907:d2da:b0:a86:80b7:4743 with SMTP id
 a640c23a62f3a-a93a036904emr82742866b.24.1727223536062; Tue, 24 Sep 2024
 17:18:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240922124951.1946072-1-zhiw@nvidia.com> <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com> <ZvHwzzp2F71W8TAs@pollux.localdomain>
 <20240924164151.GJ9417@nvidia.com> <ZvMZisyZFO888N0E@cassiopeiae>
 <CAPM=9twKGFV8SA165QufaGUev0tnuHABAi0TMvDQSfa7PJfZaQ@mail.gmail.com> <20240924234737.GO9417@nvidia.com>
In-Reply-To: <20240924234737.GO9417@nvidia.com>
From: Dave Airlie <airlied@gmail.com>
Date: Wed, 25 Sep 2024 10:18:44 +1000
Message-ID: <CAPM=9tx+uU=uceg=Zr4N9=Y28j8kHnBVD+J9sf9xkfJ1xtTXEA@mail.gmail.com>
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Danilo Krummrich <dakr@kernel.org>, Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org, 
	nouveau@lists.freedesktop.org, alex.williamson@redhat.com, 
	kevin.tian@intel.com, daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com, 
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com, 
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> Well, no, I am calling a core driver to be the very minimal parts that
> are actually shared between vfio and drm. It should definitely not
> include key parts you want to work on in rust, like the command
> marshaling.

Unfortunately not, the fw ABI is the unsolved problem, rust is our
best solution.

>
> I expect there is more work to do in order to make this kind of split,
> but this is what I'm thinking/expecting.
>
> > > But the whole point of Nova is to replace the NVKM parts of Nouveau, since
> > > that's where the problems we want to solve reside in.
> >
> > Just to re-emphasise for Jason who might not be as across this stuff,
> >
> > NVKM replacement with rust is the main reason for the nova project,
> > 100% the driving force for nova is the unstable NVIDIA firmware API.
> > The ability to use rust proc-macros to hide the NVIDIA instability
> > instead of trying to do it in C by either generators or abusing C
> > macros (which I don't think are sufficient).
>
> I would not include any of this in the very core most driver. My
> thinking is informed by what we've done in RDMA, particularly mlx5
> which has a pretty thin PCI driver and each of the drivers stacked on
> top form their own command buffers directly. The PCI driver primarily
> just does some device bootup, command execution and interrupts because
> those are all shared by the subsystem drivers.
>
> We have a lot of experiance now building these kinds of
> multi-subsystem structures and this pattern works very well.
>
> So, broadly, build your rust proc macros on the DRM Nova driver and
> call a core function to submit a command buffer to the device and get
> back a response.
>
> VFIO will make it's command buffers with C and call the same core
> function.
>
> > I think the idea of a nova drm and nova core driver architecture is
> > acceptable to most of us, but long term trying to main a nouveau based
> > nvkm is definitely not acceptable due to the unstable firmware APIs.
>
> ? nova core, meaning nova rust, meaning vfio depends on rust, doesn't
> seem acceptable ? We need to keep rust isolated to DRM for the
> foreseeable future. Just need to find a separation that can do that.

That isn't going to happen, if we start with that as the default
positioning it won't get us very far.

The core has to be rust, because NVIDIA has an unstable firmware API.
The unstable firmware API isn't some command marshalling, it's deep
down into the depths of it, like memory sizing requirements, base
message queue layout and encoding, firmware init procedures. These are
all changeable at any time with no regard for upstream development, so
upstream development needs to be insulated from these as much as
possible. Using rust provides that insulation layer. The unstable ABI
isn't a solvable problem in the short term, using rust is the
maintainable answer.

Now there are maybe some on/off ramps we can use here that might
provide some solutions to bridge the gap. Using rust in the kernel has
various levels, which we currently tie into one place, but if we
consider different longer term progressions it might be possible to
start with some rust that is easier to backport than other rust might
be etc.

Strategies for moving nvkm core from C to rust in steps, or along a
sliding scale of fws supported could be open for discussion.

The end result though is to have nova core and nova drm in rust, that
is the decision upstream made 6-12 months ago, I don't see any of the
initial reasons for using rust have been invalidated or removed that
warrant revisiting that decision.

Dave.

