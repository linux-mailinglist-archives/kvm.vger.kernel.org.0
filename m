Return-Path: <kvm+bounces-31409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8B149C38F2
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 08:20:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A06011F21AE4
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 07:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A2615B115;
	Mon, 11 Nov 2024 07:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L2RmQqTK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B70154BFF;
	Mon, 11 Nov 2024 07:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731309603; cv=none; b=cHr8+TVze2RAQL+nSThBmDcuCVIDVm6ctBE5+ln9QzedQaoWJNOzuMmkqcO7BzcO37rvN3gqkxeVmnEH2egLaOzsL+EI7fwlhnUWIKi2LelCYxhw7CDd/QnqwFDREZ9fpdtJ/JtQ14n+UVhmdOpTVtxDL1eF7kKf3FUyfYkiJoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731309603; c=relaxed/simple;
	bh=2rkhCrabTh+dME1AyXeh+UGUqDM4G2Qwh/eeTBLxHOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q6EhhXROBPwKBZVp6OEEVNVhfBqGX8htN8GO4ndW6ZmmLTb57qc+iM2Iu7QS49Ects0qhrICZaX4ACG2tPU2tzEGdpKA0XsNjv11cRqettA3wVI6gIA+oxg9AXqJyGZjMAHzVjxKcUZ/knhMghyadsmig4bJwMvavss+XIo1Dms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L2RmQqTK; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7f45ab88e7fso467767a12.1;
        Sun, 10 Nov 2024 23:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731309601; x=1731914401; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOmU+DqOTssuNxVDSw47mJh+RLlQKxt2hGA3wP7JifE=;
        b=L2RmQqTK9Wjh02aoHCm+tihh3do5fBjvlJSbNcIiGrPFQtaYDWDY8yALCxaMhTkG4e
         EsrTixWvGiydwQp5LSsvTvIjMFx34pczwzwrKxPJJcVoywalDU89kyRiov6/WDDRRPfp
         QDXg02VzuHLdtRdxN1JUkDfQxBuyyMXYihEgnU6uigADRGFvDG9Gbsbtew7HotBxfop5
         0almtxKQsAsAK3zuLbaFNPvxPlvFOxQeZMObxnoBHXUDLG8Il4z/52h3dp1JZ7pLRKZj
         ftZgbZUZ6MzD+s6bqBhauDTT+P2Jp1uSMdrF49GMxu3GXLyaLtNWWFOoYqaTZs06gUEy
         TvgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731309601; x=1731914401;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WOmU+DqOTssuNxVDSw47mJh+RLlQKxt2hGA3wP7JifE=;
        b=XqcCpmmUEBxWGZqoBnztay4JwghJ3jG9SgFurZ5P75LSsTi/5XLtS+cAWPo8zu4/o+
         rGcARBZrKBB7Fv/6ZppYTCST0iSYGH7xrUo5PeMgp57E+5eBKJVBd0N7z6ambkh9DxEQ
         5AEJHkVrajcRelIg+iBQkYIa9sHODjOuAcFZoITzeHOEJCMLB9qYRzV2rcPyQZOWozTW
         Xw2QOuIiAgXmM3fS75IPfeTTFuWkfrxrsv7PE+UQMpCtvPmjghj6+IAUAi57MLJzB8//
         50XgLhsDm8ROrGeuNmftQ33E7nL9gDRh0N1+UTvn6WftGtJ9oA+khzfHwdvLcn99HWWD
         LfUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUvbZEbbeBSFK+dUQA9GDrfVKQ99W5UeSTp5Udx68OESljjB9JlNlxKimrgg0LMIjwtfZrQSViL9KPkXAM=@vger.kernel.org, AJvYcCW09/ecr8sfSxKyLFXOGiys0X8myX2no7joL1/U2PniEXSFeR2X/KJXwH4UGBTbr6HnmAOb5WA8S3i6@vger.kernel.org, AJvYcCXPPnEU/jd0eDGa1VoJLL1oPQP4NSQg9PyAJWtDC1Ej7D+m0u/cE2x8C0f957tTf1QEeac+lPzWobUA0Q==@vger.kernel.org, AJvYcCXQDw6QO6jlTllfm8aq5DCi27WhpPFJKyhNL3BKZmKxnO48E4ta4hEJXRsp4AHueRbkFuw=@vger.kernel.org, AJvYcCXe3CKp5mxhSW4cxE8DhwWPwhfh/C0MHkq7JViaMDjg7aPlG9qCI12jTejWaXRn79MMg281IHD4dBqI/xVy@vger.kernel.org, AJvYcCXhP9h2PLfzFkxIusU1wAY8aAX0s8EZGsOLNrcvNPHFI4x1uiRtfXoS5p7219+LQK3LCicg1Jak/EMv@vger.kernel.org
X-Gm-Message-State: AOJu0YxJpsF9F2ds85IKGzCGkAFdmO6oUR8bxDoNz50yDuwmZIz9RoLB
	0G5FX+cGFeMIURANWK3p5j947r6u/cFEyVX0AWYGeYBT1fqporW0T8sWDU3klGp+MWttnhisxul
	LtNyL7yycDM1e7U8/v7yEYnVXI+M=
X-Google-Smtp-Source: AGHT+IE2GbhyhHM7VLZoUXFICAIpmggZuUxeUy9Xke7HCQ1ScZ37Bf1N00DNPtc+BrABfZWGfVXnr9FTBKVDLWlkvX0=
X-Received: by 2002:a05:6a20:6a1c:b0:1d8:d880:2069 with SMTP id
 adf61e73a8af0-1dc228395camr18138782637.3.1731309601118; Sun, 10 Nov 2024
 23:20:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1730298502.git.leon@kernel.org> <9515f330b9615de92a1864ab46acbd95e32634b6.1730298502.git.leon@kernel.org>
 <5ea594b3-7451-4553-92c1-2590c8baef20@linux.dev> <20241111063932.GC23992@lst.de>
In-Reply-To: <20241111063932.GC23992@lst.de>
From: Greg Sword <gregsword0@gmail.com>
Date: Mon, 11 Nov 2024 15:19:48 +0800
Message-ID: <CAEz=LcshavSrtGDjhKBPZU9o+5Mr8rPiBPmVL4dxcOmEiqHQSQ@mail.gmail.com>
Subject: Re: [PATCH v1 04/17] dma-mapping: Add check if IOVA can be used
To: Christoph Hellwig <hch@lst.de>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>, Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Leon Romanovsky <leonro@nvidia.com>, 
	Keith Busch <kbusch@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	=?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2024 at 2:39=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Sun, Nov 10, 2024 at 04:09:11PM +0100, Zhu Yanjun wrote:
> >> +
> >> +/*
> >> + * Use the high bit to mark if we used swiotlb for one or more ranges=
.
> >> + */
> >> +#define DMA_IOVA_USE_SWIOTLB                (1ULL << 63)
> >
> > A trivial problem.
> > In the above macro, using BIT_ULL(63) is better?
>
> No, and can people please stop suggesting it?  That macro is so fucking
> pointless that it's revolting,

Why do you hate this macro so much, have you considered the feelings
of the macro author?

>
>

