Return-Path: <kvm+bounces-31397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 278E09C36EA
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 04:14:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6EFC1F21EF1
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 03:14:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E222149013;
	Mon, 11 Nov 2024 03:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gbdoptPE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0887479CD;
	Mon, 11 Nov 2024 03:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731294840; cv=none; b=HkcUb/1uTXOkBCECACb0IQxmc3nw+xK04rweRRvgezHAaWmO8RdDqKGaOfkaQyQWz6k629N11QOXlIktyO0ZH/VzekkMwdU23FrQEvnI0w7d+aW1HXgmxTIbwcr82/z1hB/TwVPXftqxzGfCtHZZJBvyS91Ag/JxqpMRRlY/8uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731294840; c=relaxed/simple;
	bh=QwxtcQnSjGzd8NANYWxEDGJdZi4pTtnLGIQe9sj9+lE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JPgQ7SRpqzi5lrhf+4BjFz1BHIJ4WedSBZhFqcqKgciRBdoo8VW+jl0CRyMd2882G5q3sKzk4/oHJro01+5sWxaQgMfB5nY4/2bnesEdYTaPwKxpPfgluepFy/0en6iCrE4AC2ku23nNCvpcDDI5zoK248PM3yFe8SQUuwYm7/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gbdoptPE; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-539f72c8fc1so6735886e87.1;
        Sun, 10 Nov 2024 19:13:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731294837; x=1731899637; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AszquRm3rEcjTNQTd7uRs0tgE9n1Q/miIDo52S90X0w=;
        b=gbdoptPEkfYHS4YLCTaT7aRUAKM2P5ihDUlT5XDl6GnCefeTMnjfwK8WSM/ejCM1qw
         0sr54Y0Jjw0r2xicLBic9UXXwKsZXRhtpOYhuAdPrZkLhGE3kUcNzwFxuDbKYjiRugKn
         EH5/CHLs7NqysRl30d7/qQuDRb/u9uJgtwi/Z/uj/LxzW9W36BWDv/eL5llOc7hBZnzK
         mgoi+NEPDgleZvRHwNEXRqLIzcLkSDCzdU3xoKkY2IvXTwenwvF+v9GRzRdj+NcPWcWA
         gY71sPJbb/xLIsbn6PnxzZfP05+hIwupb3XSfAoYXix7HGbHfqDYYVMK2wHvd52tF6Iw
         zGng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731294837; x=1731899637;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AszquRm3rEcjTNQTd7uRs0tgE9n1Q/miIDo52S90X0w=;
        b=JI5WMMYgSl0QmzP6zB7vktdnCjGHNkeF/ucLZiH07TSbsEuMgcG3IytMK9n2oKOr9D
         /oMpFGDLGtjntPsfGSKRpNuMNrvgj03zK9TummR9FAVDM1EAnt4YC+Cv98xrelJg1dr0
         eS8nHNMGuYWCiq4vx53gPFZSwyXIX8DVm9q7NRY0Ar8G2wxE6HoAb3cxFDYMqO0IELbk
         RcLliN4ueNHa9QQQ2vt3/l+1dsQ+tKQ02BTfuv89GmloaUehPf4L1GH4KR4tSxepaF1K
         Xy3FhR+D14Zz9FDPfKibpkmbskwGavUazFRBmirbnnaDh8PodtK04c1+1GYJfED/ORul
         EYQQ==
X-Forwarded-Encrypted: i=1; AJvYcCUGqjEfCFtxJTT9WNrquuvQk1CSCpR7qhbaurmaE6BsU0Xkrpa4mfPDGLKPctE8/kZ2DBmPLKXseU6J5p0=@vger.kernel.org, AJvYcCUGt4CVhfRym3dGKHEHp2JwXEl6Hz2lZLg832KgcGGcfQmdWVgCvOmxsgBx17PaisjVr05iHbMJG3QV@vger.kernel.org, AJvYcCVM8p6wLEqYBww0dLyNXYtyEXKVVvyftoW6DNcb0fugU9LjQFFla/gNg2mKwhG/9EODM7fvW/0g5o5Q@vger.kernel.org, AJvYcCVR7urlYVTn+IJ5lKuiH5pIpIG0h5aese3827643V1w8XmkOXS9EswU+b33ZhZt2HKH1541E33FYap7dVOQ@vger.kernel.org, AJvYcCXBJBJ37nE9p2k7317mo5pSXxuGK/VLn0Ski+fY4I10nr+9PHdCyVaUl9l7J2/uRgCC7S/tUjgiudrTrw==@vger.kernel.org, AJvYcCXeVv3l2xWoQOj5Z2h1Wwrp2ltwUVDftBMPm13OgRKgdrJsLG6IJQZRmNaUjz+nCKgfPtg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZ6qxqyy0laAk7us5SC031A1zPw+q/lRBGsoQZ3YlYzUzRfoYW
	XbBILwrSiIlTUAJ1PCjkmxQTpo2+c6L8Ezqjsfub3UzayBF2hagXyM2Xa9NqOT7ibFqPvOv9Skq
	GTzlYhXIZ5hxmmvbcL1NCKkz7ess=
X-Google-Smtp-Source: AGHT+IGCJWVGSDxh88mmV8TfpUkds1GTcb/SQfLMvdY+xjmMgOtiWhJjm3URTLzGgKvmaZLyg2QvEHBS9bNI0FtRaqQ=
X-Received: by 2002:a05:651c:881:b0:2fb:6465:3183 with SMTP id
 38308e7fff4ca-2ff201e7398mr46022501fa.3.1731294836895; Sun, 10 Nov 2024
 19:13:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731244445.git.leon@kernel.org> <dca3aecdeeaa962c7842bc488378cdf069201d65.1731244445.git.leon@kernel.org>
 <CABCoZhAN-eeu=E5r+ZbZGTNwQta5yUw86sy8e_Je+Yri-+iuoQ@mail.gmail.com> <875xouv5lt.fsf@trenco.lwn.net>
In-Reply-To: <875xouv5lt.fsf@trenco.lwn.net>
From: anish kumar <yesanishhere@gmail.com>
Date: Sun, 10 Nov 2024 19:13:45 -0800
Message-ID: <CABCoZhDpdU0cGu8Ru5Jj+YmnS07cO4k_nbOFT+HkdFkpVo1NYQ@mail.gmail.com>
Subject: Re: [PATCH v3 09/17] docs: core-api: document the IOVA-based API
To: Jonathan Corbet <corbet@lwn.net>
Cc: Leon Romanovsky <leon@kernel.org>, Jens Axboe <axboe@kernel.dk>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	=?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org, Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 10, 2024 at 6:58=E2=80=AFPM Jonathan Corbet <corbet@lwn.net> wr=
ote:
>
> anish kumar <yesanishhere@gmail.com> writes:
>
> > On Sun, Nov 10, 2024 at 5:50=E2=80=AFAM Leon Romanovsky <leon@kernel.or=
g> wrote:
> >>
> >> From: Christoph Hellwig <hch@lst.de>
> >>
> >> Add an explanation of the newly added IOVA-based mapping API.
> >>
> >> Signed-off-by: Christoph Hellwig <hch@lst.de>
> >> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> >> ---
> >>  Documentation/core-api/dma-api.rst | 70 +++++++++++++++++++++++++++++=
+
> >>  1 file changed, 70 insertions(+)
> >>
> >> diff --git a/Documentation/core-api/dma-api.rst b/Documentation/core-a=
pi/dma-api.rst
> >> index 8e3cce3d0a23..61d6f4fe3d88 100644
> >> --- a/Documentation/core-api/dma-api.rst
> >> +++ b/Documentation/core-api/dma-api.rst
> >> @@ -530,6 +530,76 @@ routines, e.g.:::
> >>                 ....
> >>         }
> >>
> >> +Part Ie - IOVA-based DMA mappings
> >> +---------------------------------
> >> +
> >> +These APIs allow a very efficient mapping when using an IOMMU.  They =
are an
> >
> > "They" doesn't sound nice.
> >> +optional path that requires extra code and are only recommended for d=
rivers
> >> +where DMA mapping performance, or the space usage for storing the DMA=
 addresses
> >> +matter.  All the considerations from the previous section apply here =
as well.
> >
> > These APIs provide an efficient mapping when using an IOMMU. However, t=
hey
> > are optional and require additional code. They are recommended primaril=
y for
> > drivers where performance in DMA mapping or the storage space for DMA
> > addresses are critical. All the considerations discussed in the previou=
s section
> > also apply in this case.
> >
> > You can disregard this comment, as anyone reading this paragraph will
> > understand the intended message.
>
> I don't understand the comment, honestly.  You say "they" doesn't "sound
> nice", whatever that means, but your suggestion retains the "they"...?
>
> I'm all for reviews that improve our documentation, but it is
> *incredibly* easy to fall into the trivial bikeshed mode.  I've
> certainly done it myself.  The end result is less documentation as
> people decide, understandably, that it's not worth the pain.  Hopefully
> we can all try to do a bit less of that.
>
> FWIW, I think the paragraph is fine as written.

I completely agree, and that's why I suggested feeling free to disregard
the comment. When I read it, I felt it could be improved, but I
agree=E2=80=94there's no point in overanalyzing it.
>
> Thanks,
>
> jon

