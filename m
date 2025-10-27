Return-Path: <kvm+bounces-61191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00EDFC0F6CB
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:46:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 245E9484C3E
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 16:37:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32D4731354E;
	Mon, 27 Oct 2025 16:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dNkIU/Qm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B1A3161BD
	for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 16:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761582771; cv=none; b=qh22OdEpi8VXv6bWR1RBE0Gm5bxRlrjfN0k7g2rDNq4a5//aFZZ2GmbwdC/kCWyK21bVZl3huuap66iNG+DL6IDIzMRXeJfUN7JJS4v7h+DRmgjRPFAh3x3Bz35/r6rIdNmn54TBew+MQvNijEd3xNfeVElBiKnaa/krdfvePV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761582771; c=relaxed/simple;
	bh=TnOakrnRtLMDcV8Ns77mVydNCZhs/gRtET1InUAd8IE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=daZxjJxnNzHEWr//3aH5rLD9Q8cJZCep7/SqjMYy9UwCSKpA2jvGNwAf1nxhIj8evVLrnF/4SYgoL4Qp8FXT3txvrmawOhmqf8fsL/o5QA3T3xh169xNRFct0j/6vbnwQ8h1igexAe86lkl82JqKPtFIhnhJ+G33k4OzWy0z9DA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dNkIU/Qm; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-932e88546a8so2434361241.0
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 09:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761582767; x=1762187567; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TnOakrnRtLMDcV8Ns77mVydNCZhs/gRtET1InUAd8IE=;
        b=dNkIU/QmEpcm2HyrgexaGVxOEhG/TJkpHIfbeombtfkiAQBCiaj/xuqSTJXPuaTlOB
         SpzG30A5CdRKcVRUSXmnlBp35VklWjUcqRBs4wIIv1uzyEjtLPtd1+QMYEvW5OmzMFz/
         hMV0fNM8z9oMYbHskSFuW7yYxctvE/m8SzOMHNs7l5ol8dTj8hwHb7Tm8zVtV+uVLLca
         h+HLBnn5qATH02ksqUYMEOwoszzcJCNRNQkq87fbKMUBEpt5L1d9FWSpxmj3NarDoITL
         vDmeSvSK2AOwAOziX+rK2W03r0aLzXfNTtyUusVL0rNO7kktCvwS7JGtsoV3evc8RIWT
         nhhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761582767; x=1762187567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TnOakrnRtLMDcV8Ns77mVydNCZhs/gRtET1InUAd8IE=;
        b=GjA/vq4IsC26djziS9CVxMGDeJoLECTyWpx+YAt7CFWojdol+tcWEP9UPolBeVZhL3
         Uav1ioqAZItJWKJprqDoHDh3izyHZim7dcKe0NO0EpLcGG0qnb5kNqQIwyBsUZeL8Tqt
         YOcEpBIx9VcYmcATINntFcHERPT0+0cQh8CdG5DI5vTo5J7zdPkaEK+6kBfpu7kS1y/A
         A/HJxb2KTkS47rVqePUAFlPEYXBbPKFUI10ClthxQJXUdpbPXKrcno5incVbARYM7NOH
         Y3gaYc4YdUrtNm9sDPyMvti6/79nLMY2HWOrfH/z4hWyhizP6ZyliKGgKazB79jHmcbr
         H85w==
X-Gm-Message-State: AOJu0Yy0EIeRPFHJNRWAZbhOuOgxJ06cD6ByJwxJLadw0/ubYj2dCfFQ
	PTaDXehQxhju+46Uuv1gvaIApI/5I+9Kl77F8Y8l8fUCeRh+3gBboaco3SsxzbsJ8A4dvXKOySs
	z/f6pJ9WCsumtDqpYiAUzj88X4TacQewca9RViy1p5lSnVNYPsQzJ2d6g
X-Gm-Gg: ASbGnctyGzCmtF8/jS6G+qqlq7DGe/2Ft8HhD8nYmGFa43pDZ8NSuVv5vB6Uycp3gCK
	o0RyyOiiEBPG2aEcN2LO5LQHAOmAEJTEnBL1Kwn4hlnFr8K/G83q98Ms7FPJNPQL6Vme8euuub8
	lfDLz77ZlavoVCcAYhtFWx15gXqMyHTkIAkq+fPnnzB7RJjO4O3s2PTtcn8KuEnEIZhVGIvlzlZ
	3G1QOGTUANwZhr+OGcq8L+23nNzBUciVOgIs9/aQgOJXZYlunIK4f5PRFbJAPDtFFM7mmw=
X-Google-Smtp-Source: AGHT+IHXnfvepXGeW7qZPCtmz5hEeIREM34YMMaK2zLFn3F/OLqY2HLg64GBHNBo1E6OD+RqYxgrz3GBQj87+voxOUw=
X-Received: by 2002:a05:6102:6105:10b0:5db:2168:77bd with SMTP id
 ada2fe7eead31-5db7e069f95mr77611137.2.1761582767337; Mon, 27 Oct 2025
 09:32:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250924141018.80202-1-mngyadam@amazon.de>
In-Reply-To: <20250924141018.80202-1-mngyadam@amazon.de>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Oct 2025 09:32:17 -0700
X-Gm-Features: AWmQ_bnCgLJQdJadHXgZTs11fy3YYiv4J1ib7SVx2-I_tj6H5qXd38RuBwvFIns
Message-ID: <CALzav=cuhzsTu7pZSae_6EpbJ1KWq7Th3Puk2n=TEbWN6LWh-g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] vfio: Add alias region uapi for device feature
To: Mahmoud Adam <mngyadam@amazon.de>
Cc: kvm@vger.kernel.org, jgg@ziepe.ca, kbusch@kernel.org, 
	benh@kernel.crashing.org, David Woodhouse <dwmw@amazon.co.uk>, pravkmr@amazon.de, 
	nagy@khwaternagy.com, linux-kernel@vger.kernel.org, 
	Alex Williamson <alex@shazbot.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 7:11=E2=80=AFAM Mahmoud Adam <mngyadam@amazon.de> w=
rote:
>
> This RFC proposes a new uapi VFIO DEVICE_FEATURE to create per-region
> aliases with selectable attributes, initially enabling write-combine
> (WC) where supported by the underlying region. The goal is to expose a
> UAPI for userspace to request an alias of an existing VFIO region with
> extra flags, then interact with it via a stable alias index through
> existing ioctls and mmap where applicable.

Would it make sense to build this on top of Leon's dma-buf series [1]?
My understanding is that dma-buf can support mmap, so WC could just be
a property attached to a dma-buf fd and passed by userspace via
VFIO_DEVICE_FEATURE_DMA_BUF. Then VFIO wouldn't have to create or
manage region aliases.

Apologies if this has already been discussed, I did not go through all
the past discussion.

[1] https://lore.kernel.org/kvm/72ecaa13864ca346797e342d23a7929562788148.17=
60368250.git.leon@kernel.org/

