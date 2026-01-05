Return-Path: <kvm+bounces-67037-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 86CC0CF2D4C
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 10:48:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8710C300CA07
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 09:48:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21B9C3375DF;
	Mon,  5 Jan 2026 09:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eAzDpTm6"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40472331A42
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 09:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767606526; cv=none; b=HwGp6twDn5erWxNUiS5IMy49PP7SBCxWSliXKMxJ60MVFDVZmlVQUrFGIoCRlP471C8R58i8DFC14tS9sFgQ9fhGAtRsw3xrnm5lD0pd77zQHapVoOC4NCTp1lyyif6EUl5qV5r2HNfurTUHjBgD5PKDPitQnrXCJo28qTewHWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767606526; c=relaxed/simple;
	bh=6q4rbOvtQc/l6ny7b0UltUYitu5vdZwgjySiMXgs9uA=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P4kNPzMKkteGRv3METii3aaDBfbHqpujG1jdx9ECXea8jTLLXl53rmEi8p79MMm99xQLDjgwVInzcgOsVe+CdfLLHHxMpXabaWtG5sdnydBdx2voO4AfJ7h2qu0oEZfeT/Udf00r449DrI5kLOUOR+pR+LfUocrhksAOzldWtw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eAzDpTm6; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13776C2BCB0
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 09:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767606526;
	bh=6q4rbOvtQc/l6ny7b0UltUYitu5vdZwgjySiMXgs9uA=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc:From;
	b=eAzDpTm6IsHSoLTQjKYOnNkM7nhsjriwphNqFromcWkx2s5IfpLzPnD8QU31MHCPi
	 H4Y2dPEPrEyWkrIAZrDk9z3yxKao8UuHs0xqcuZ00V2Ivs1+Ge1p6KoTX12wqJWw9F
	 HtnXbNfMKpL9Mq/jgCZQq6aQN1UGjHGHuP/g01Yk/QP5sqBekyLcP+Gw3pxurwXhZw
	 9dOi/GIP+rC+pi3vJ3QRFJV01tD5rLNtCZBhnY2Jf79ybywpvTS9HqnSCT9/N0L7mH
	 x4nC/h+O79u2kzZR51KJg604oBulO5eUYpzqMYqh/aKKUwWinj4ttfgDLaKCgayajs
	 zhWePWvoE06Kg==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-37b8aa5adf9so89986011fa.1
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 01:48:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWE9tXHYaLk4uCFF4BycwejgdUaX31WkYhyYa63VBgwQgtni6p/fQpvHKCkpf6kTjiz7go=@vger.kernel.org
X-Gm-Message-State: AOJu0YzpQ47jE8N/5iz63ZbG5vbjKWraNNUgX4YF7Ln8AvH6jap6uTi1
	qUMEzyijCugRqlSHmT/qmUIoFM/rROl/nYqqPCo6dGv58JEmBOP3V04XqQ4igvjt0Mu6j7duDW3
	kvAMyfH6i74Vjr9QZXu8BQydcvE5+3BVLr0EE7ZTpdA==
X-Google-Smtp-Source: AGHT+IGSKxzTqFupha+/kP/9OhPk5CHWYocIBLA8c0aZ781oqxoVi+m5tGX4lmfLkQ2ICgVlTbbSWoJqxN5UEvT+0Ew=
X-Received: by 2002:a05:651c:1546:b0:37b:a664:acde with SMTP id
 38308e7fff4ca-3812161c9bfmr156575261fa.32.1767606524418; Mon, 05 Jan 2026
 01:48:44 -0800 (PST)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 5 Jan 2026 01:48:42 -0800
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 5 Jan 2026 01:48:42 -0800
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <ba7e025a6c84aed012421468d83639e5dae982b0.1767601130.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1767601130.git.mst@redhat.com> <ba7e025a6c84aed012421468d83639e5dae982b0.1767601130.git.mst@redhat.com>
Date: Mon, 5 Jan 2026 01:48:42 -0800
X-Gmail-Original-Message-ID: <CAMRc=MdbGd3Sz+3zV23rqsKYjhy7PMcjMQ5p_Td-Pvq_gVS2Cw@mail.gmail.com>
X-Gm-Features: AQt7F2qC8Cp-OrWRK_Qp1sfgkcgDE0sKs_R5olkkzBcXry5HJu_QhIjQMPa71p0
Message-ID: <CAMRc=MdbGd3Sz+3zV23rqsKYjhy7PMcjMQ5p_Td-Pvq_gVS2Cw@mail.gmail.com>
Subject: Re: [PATCH v2 14/15] gpio: virtio: fix DMA alignment
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Robin Murphy <robin.murphy@arm.com>, Stefano Garzarella <sgarzare@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Petr Tesarik <ptesarik@suse.com>, Leon Romanovsky <leon@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Bartosz Golaszewski <brgl@kernel.org>, linux-doc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-scsi@vger.kernel.org, 
	iommu@lists.linux.dev, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	Viresh Kumar <viresh.kumar@linaro.org>, 
	"Enrico Weigelt, metux IT consult" <info@metux.net>, Viresh Kumar <vireshk@kernel.org>, Linus Walleij <linusw@kernel.org>, 
	linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 5 Jan 2026 09:23:45 +0100, "Michael S. Tsirkin" <mst@redhat.com> said:
> The res and ires buffers in struct virtio_gpio_line and struct
> vgpio_irq_line respectively are used for DMA_FROM_DEVICE via
> virtqueue_add_sgs().  However, within these structs, even though these
> elements are tagged as ____cacheline_aligned, adjacent struct elements
> can share DMA cachelines on platforms where ARCH_DMA_MINALIGN >
> L1_CACHE_BYTES (e.g., arm64 with 128-byte DMA alignment but 64-byte
> cache lines).
>
> The existing ____cacheline_aligned annotation aligns to L1_CACHE_BYTES
> which is not always sufficient for DMA alignment. For example, with
> L1_CACHE_BYTES = 32 and ARCH_DMA_MINALIGN = 128
>   - irq_lines[0].ires at offset 128
>   - irq_lines[1].type at offset 192
> both in same 128-byte DMA cacheline [128-256)
>
> When the device writes to irq_lines[0].ires and the CPU concurrently
> modifies one of irq_lines[1].type/disabled/masked/queued flags,
> corruption can occur on non-cache-coherent platforms.
>
> Fix by using __dma_from_device_group_begin()/end() annotations on the
> DMA buffers. Drop ____cacheline_aligned - it's not required to isolate
> request and response, and keeping them would increase the memory cost.
>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

