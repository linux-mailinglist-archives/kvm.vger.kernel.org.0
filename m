Return-Path: <kvm+bounces-31406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EC85F9C3893
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 07:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82F96B209F2
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 06:43:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAC2157A48;
	Mon, 11 Nov 2024 06:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O6QxBhI0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC318136A;
	Mon, 11 Nov 2024 06:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731307402; cv=none; b=TwiFmNwdh0Nu5MB/tFeS+33hUMLA5qVfh0TYX+2liISorGlrcreL9TdH9dd8sI0yQKfPhpAHOeQ3fcjezvgmNHh7Pepsj1xDue+/jF3MfpQGSnwkxSLpfisBuPXpvW12FtVE1y3tUvXNU78uLANXD9aeH5nljZkyJN0o2/cVBpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731307402; c=relaxed/simple;
	bh=OSWugjKTomfPMjmF51CbHUYzDzMD4jhQH03P9Uh6PXw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lpY53/NFBAkS3CZyHYMI70xmmlhMSdiVLFsiHkHQNnRpvT5PLfXj49N33kDS7vKSDxz3Ja97LwwXVPG6qyrhAGIIHZhBAfGe23fFwhUYS4DgiV+1vFey5K8TlaiKvY4VniJISJb5ezAe24UsE4r/HIwrPghT5j2JER6Oxf54DxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O6QxBhI0; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-539f1292a9bso5031271e87.2;
        Sun, 10 Nov 2024 22:43:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731307397; x=1731912197; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qv7O8dew7I+B9eEJJt0qBNM8IZdD1sLJueFsW4bvsc=;
        b=O6QxBhI0qB3sNjAHdFuUeyBpxfxUxG2hi1ERqYoIRe2jDIGHj+TxuroRoNDech0r1e
         JCq4uvUppYin9VhCiCstiEEg+R7P2mgQfGOXhy2sCqF2wQGUmwHcF4RgVNxWX2Tvu+Lg
         yghFqdu1mQfxOoW33fwIuxwFICEOGOD1PYxsO1udOvw2MZ6l3aA0PXelf0gGzhWs5MxP
         8ktpsClOr/BoKyorc2r1FSO7I0RgJ9db/LWC83n0OyqzSzBD/m60rOIUJ3wdT9zNnj6j
         qkmryFzFOdMezfxFuultGOd1eXi0rxx2/2U97XCcrSbiTP1v2V95GZvAqxe/uQkUXIdy
         pnFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731307397; x=1731912197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9qv7O8dew7I+B9eEJJt0qBNM8IZdD1sLJueFsW4bvsc=;
        b=F6vMUpAFjzidLiyLPFhVOhWkOGZv2/pcmQrJ/6lk+aY3+in8vg2Ze22VsVJu9M/AIz
         cozRc0n8GQHVISlcPdg4KzP9PuHtR5jOVlSRifyqK65JEfCwR+9WKv3Gf1TV8IryqMUC
         +/cSqvzCcCu6hb+S+Z/Pn5dOy3vQ1RUjjIAFwzNMHoollsKA+GtRWSg9jddQgGShj0Ys
         LNNP8ewV47gzbRJV6zrj0V7bYo8ikp1zfQ+5mHPz5Av3M2v1jTDrT7B64BzF/YNXv0fp
         meABr1Mlreu+KVnsx6nd+PNmh/S4bLTyFBfpj26uNy8mhhMrz01LBON90Delew8CtI1H
         k0UQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6jZCZFGEQAWL3nFzRtIkIGrexxYfPkCZu83Qm+8oxxP57QgrHh3jtlYvmMvn9eLHa42SVw7K4tla3kw==@vger.kernel.org, AJvYcCUC4HUVWHOSwcifCoAFzUlhzYb5GfZfieunzqCeLM5uPKhER/dbWBpShSJMqGhlryxA8L0=@vger.kernel.org, AJvYcCUM+3voRGtbI0ATsFqHq/BSZzSypfCOOFhhCSZB1/sPhyI5veUSF/5OW7ErdMovDq+DNxNFa1rhnmk8G+8=@vger.kernel.org, AJvYcCV3dnZ9E8g1x65IPZTxTwwTpze1fsNAWMthQk+CHGvujHqF1JqVvA2t8LRaFLRT6V3hY9LFwk4Ygul+@vger.kernel.org, AJvYcCVmLcZhb6KHEvpFqmguGW0wqKhT6jY3XiEVh0JlsEcLronKCGimJmykw5zLmofndGG1sKqHhMTChfmE@vger.kernel.org, AJvYcCXxLdlStODtTSTZbLWDuE1afFYq1eITI34dChROWk7c5BGoi5FcfemNaJ7ZSP4s5f2Y+X+jfQ7YlXfy9rj0@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0G0f5g4fA56pqPohpyvL8+eKDYbfpO8/Y7f4oxIFuJe5582/S
	DHHQ5twYfkN7FjpchN5RS3KdVnLxbvPjBkvxtHzz6h3aoqMxsrrd8S9bdsbPZCX/PU6Frt/KKgw
	6h0BD1lbZIDRUnF3yqR1Vx3qP33k=
X-Google-Smtp-Source: AGHT+IHutgQAlXklRgMYNRidcA41kXnbJbGiEJGtaB5sYolGWbh343PWRuG4ZkC83mQMH8VsiDxXBWb3iwvgsLPw2Uo=
X-Received: by 2002:a2e:a813:0:b0:2fe:fec7:8adf with SMTP id
 38308e7fff4ca-2ff2029fed5mr47426781fa.38.1731307396466; Sun, 10 Nov 2024
 22:43:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1730298502.git.leon@kernel.org> <881ef0bcf9aa971e995fbdd00776c5140a7b5b3d.1730298502.git.leon@kernel.org>
 <87ttchwmde.fsf@trenco.lwn.net> <20241108200355.GC189042@unreal>
 <87h68hwkk8.fsf@trenco.lwn.net> <20241108202736.GD189042@unreal>
 <20241110104130.GA19265@unreal> <20241111063847.GB23992@lst.de>
In-Reply-To: <20241111063847.GB23992@lst.de>
From: anish kumar <yesanishhere@gmail.com>
Date: Sun, 10 Nov 2024 22:43:05 -0800
Message-ID: <CABCoZhBVWY=aUQtQ5b=mF8hXqpgJw21_jAPf9YvEvdgPf_GALA@mail.gmail.com>
Subject: Re: [PATCH v1 09/17] docs: core-api: document the IOVA-based API
To: Christoph Hellwig <hch@lst.de>
Cc: Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Robin Murphy <robin.murphy@arm.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <kbusch@kernel.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Logan Gunthorpe <logang@deltatee.com>, 
	Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>, Kevin Tian <kevin.tian@intel.com>, 
	Alex Williamson <alex.williamson@redhat.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	=?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-rdma@vger.kernel.org, iommu@lists.linux.dev, 
	linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, 
	kvm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 10, 2024 at 10:39=E2=80=AFPM Christoph Hellwig <hch@lst.de> wro=
te:
>
> On Sun, Nov 10, 2024 at 12:41:30PM +0200, Leon Romanovsky wrote:
> > I tried this today and the output (HTML) in the new section looks
> > so different from the rest of dma-api.rst that I lean to leave
> > the current doc implementation as is.
>
> Yeah.  The whole DMA API documentation shows it's age and could use
> a major revamp, but for now I'd prefer to stick to the way it is done.
>
> If we have any volunteers for bringing it up to standards I'd be glad
> to help with input and review.

Jonathan, if you agree, I can take this up?
>
>

