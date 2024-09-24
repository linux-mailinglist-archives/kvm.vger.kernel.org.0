Return-Path: <kvm+bounces-27332-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C20B8983FE5
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 10:06:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 846E1285A49
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 08:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F0F14B081;
	Tue, 24 Sep 2024 08:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TerBKfxT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0175954FAD;
	Tue, 24 Sep 2024 08:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727165195; cv=none; b=iuAgNi/wHiX7+LEEYdk8omtMYLSx5c+QdLo22U1DoXkceI+2dVSARAEzod2LvSQMfSHHOJ95nND2pXvGOFIHhJBLEIhDv/TwD3YftYAAKhBI7qzrnwy+F/NTj7dAiEZUTxgKr0wYmqgLAR9L1pejgAcQh/nGf+Xi9ab2jSr8cOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727165195; c=relaxed/simple;
	bh=67LWStMPZnMxEU7ft7DleIniSzRAvyxn70INzRxcYpk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UEFoHx82qb5dYYtc4SZfLjGaoE5010t3O3eMiDmqeXSmEDoNhB04XOebmn3wOVc/waUlD9c0afE8dRUntOpip9SlJld9JUgAuz0LDR9eWVujbhPUIxYFfZafx7n/435Bn1/C+JbZqMDuWlF9kCx+Z5TpqzJpZUBAzhxTbQTmzUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TerBKfxT; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-53653ee23adso4710884e87.3;
        Tue, 24 Sep 2024 01:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727165192; x=1727769992; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=67LWStMPZnMxEU7ft7DleIniSzRAvyxn70INzRxcYpk=;
        b=TerBKfxTXpFpkV61Pjk/5Bu5zJ9eMK3XhastGKqwRnR9VBcHx9WKc3OaZzUPIddmzN
         XWBaNtmy1bp7ORjqbkpjyQQtvJW37U7VoRMy0di9RMMjQWuE+2/XwXOgzf6tdJNNVfPh
         PYxpWwgzNzEwXymtxrPIloaYkP+itGqco1wttDk9ws5aMH/2UbP0uooLyDEznZFxrhWb
         fGFmfY3kLkSw23QPGv7DbRH1YJu7lNy6OTW1OMQIdg/nLXr8mHKTqrNTICE5ieBdOmOu
         23yylq03NKxFtjJJZyFzVS95HBI1lr88Ar/FU4y4afik7rbaViaYk3UR6txaRL6567vY
         LAkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727165192; x=1727769992;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=67LWStMPZnMxEU7ft7DleIniSzRAvyxn70INzRxcYpk=;
        b=U6t4MkgxBA0QZ4AqC5P1bSK2o63ALSrbrM413xJYX7AM9DB/nr4KezUg2AMzzg8Oh1
         xZzogqjZXBVCwnOz+Y2JSH+cQBvPBI65VFFcmr7vTcYo09rXEPLMKH92ahXaiRZIUyyL
         kTNCd7sHMURwjbtn91NTzRf2XyVW6rBj43m0pzBI6qpQ07jUdWXSO+8ux4UHNceH57FP
         MfT+iUcHoJtPUyibBUTIjy1GwD1Li46BxQJwiPj0SmEi2J5W1K4WvTu3p8SH1rNMduJM
         qAGpjON4vncI0PvEsWfKtETwmV8BqrM7P5PgseVVzVGwb0zvv54s+yXSl1T2o5XiTwKT
         DAwQ==
X-Forwarded-Encrypted: i=1; AJvYcCV6aD6o8N4V7mF0lBtO7gIvF3EWZS4kYYc3VHOZFSZuS5Z6sHPIK0L8z6GRxwKWBZCq3Qz5s7WPZw0qgg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIX6nn/7ZmyEt6vRkw6k2hBvQZdCa1hpfEs0SGAcEs6rZ3NL3Q
	R5Pp0wCUUbhXwJQVZ0zmMI4uIsf+qREd9Z1/b/P92lEFOBIGQGlf
X-Google-Smtp-Source: AGHT+IFpJvqO+N2IH2ErjFZSjfDDWuwEBL/xCnRTffHFUto9DtR4BU8zbQbFrI7yUMeGFhw+AYpuyQ==
X-Received: by 2002:a05:6512:33cb:b0:533:711:35be with SMTP id 2adb3069b0e04-536ad17d5e7mr7422996e87.26.1727165191700;
        Tue, 24 Sep 2024 01:06:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:5d29:f42d:9232:6860:60da:f193? ([2001:b07:5d29:f42d:9232:6860:60da:f193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93930f188bsm52548966b.153.2024.09.24.01.06.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 01:06:31 -0700 (PDT)
Message-ID: <f786e134a018004820fd147053e4eae722a6004f.camel@gmail.com>
Subject: Re: [PATCH v2] virtio_blk: implement init_hctx MQ operation
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: Max Gurtovoy <mgurtovoy@nvidia.com>, Marek Szyprowski
 <m.szyprowski@samsung.com>, stefanha@redhat.com,
 virtualization@lists.linux.dev,  mst@redhat.com, axboe@kernel.dk
Cc: kvm@vger.kernel.org, linux-block@vger.kernel.org, oren@nvidia.com
Date: Tue, 24 Sep 2024 10:06:29 +0200
In-Reply-To: <17b866cb-c892-4ebd-bfb9-c97b3b95d67f@nvidia.com>
References: <20240807224129.34237-1-mgurtovoy@nvidia.com>
	 <CGME20240912064617eucas1p1c3191629f76e04111d4b39b15fea350a@eucas1p1.samsung.com>
	 <fb28ea61-4e94-498e-9caa-c8b7786d437a@samsung.com>
	 <b2408b1b-67e7-4935-83b4-1a2850e07374@nvidia.com>
	 <5e051c18-bd96-4543-abeb-4ed245f16f9e@samsung.com>
	 <17b866cb-c892-4ebd-bfb9-c97b3b95d67f@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-09-23 at 01:47 +0300, Max Gurtovoy wrote:
>=20
> On 17/09/2024 17:09, Marek Szyprowski wrote:
> > Hi Max,
> >=20
> > On 17.09.2024 00:06, Max Gurtovoy wrote:
> > > On 12/09/2024 9:46, Marek Szyprowski wrote:
> > > > Dear All,
> > > >=20
> > > > On 08.08.2024 00:41, Max Gurtovoy wrote:
> > > > > Set the driver data of the hardware context (hctx) to point
> > > > > directly to
> > > > > the virtio block queue. This cleanup improves code
> > > > > readability and
> > > > > reduces the number of dereferences in the fast path.
> > > > >=20
> > > > > Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
> > > > > Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
> > > > > ---
> > > > > =C2=A0=C2=A0=C2=A0 drivers/block/virtio_blk.c | 42
> > > > > ++++++++++++++++++++------------------
> > > > > =C2=A0=C2=A0=C2=A0 1 file changed, 22 insertions(+), 20 deletions=
(-)
> > > > This patch landed in recent linux-next as commit 8d04556131c1
> > > > ("virtio_blk: implement init_hctx MQ operation"). In my tests I
> > > > found
> > > > that it introduces a regression in system suspend/resume
> > > > operation. From
> > > > time to time system crashes during suspend/resume cycle.
> > > > Reverting this
> > > > patch on top of next-20240911 fixes this problem.
> > > Could you please provide a detailed explanation of the system
> > > suspend/resume operation and the specific testing methodology
> > > employed?
> > In my tests I just call the 'rtcwake -s10 -mmem' command many times
> > in a
> > loop. I use standard Debian image under QEMU/ARM64. Nothing really
> > special.
>=20
> I run this test on my bare metal x86 server in a loop with fio in the
> background.
>=20
> The test passed.

If your kernel is running on bare metal, it's not using the virtio_blk
driver, is it?

