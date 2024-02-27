Return-Path: <kvm+bounces-10036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F0667868BA3
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 10:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 885FFB28529
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 09:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D16135A73;
	Tue, 27 Feb 2024 09:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="JqADrn89"
X-Original-To: kvm@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DD754BCB;
	Tue, 27 Feb 2024 09:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709024772; cv=none; b=QOp70s7GBRmkNmrVF4rAKGuIosEIHk+TGXWUP24hZk+QDPwoLECcXQz8K4jx8Ffn6+sywi6kCVEUiMQtV4r9hIoCV2ZNGsDd07KJiCDN/2+orUjUZuoI1+61metPXwD6SvMvmfrXKdOR57q28RAg5maPRpxFvXGbWfamk6jDcDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709024772; c=relaxed/simple;
	bh=n4VE9YfSvDIgD5KVbQqRs4ZGP82u4xjDxIlsieejVz4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ij9pbTeMrzla55NEdro8t2qys/3eOI8Mcgiqt+WSHhSYqFf+VxSYnO37T2J1L2Ke61o4V7ju5pYe0Rp6WJNDfYhIBsI3eOhZrb5bIzHSbcwN8IriMFbSRcgG7hfR/CsxfP71MyVK6o4oWC0VenJESWpdyWB3SG4O6qnVVu5sxnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=JqADrn89; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1709024766;
	bh=n4VE9YfSvDIgD5KVbQqRs4ZGP82u4xjDxIlsieejVz4=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=JqADrn89IhcLGCkDQse9CAsivTzeTpWqNi0BkB12AARvNB9Y//2PvHkUkEAWj2zvy
	 l9ycw/8QiO6Nz84Hgc7HfAAwxap21qsUy9++sygPatH60Gnd3nk4leC9xPvPgJi4gS
	 El6VWagVC4pI98hDQ5D5gRxr7ouMvb07ydhRUby8=
Received: from [192.168.124.4] (unknown [113.200.174.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 6A10A66AF5;
	Tue, 27 Feb 2024 04:06:03 -0500 (EST)
Message-ID: <f1ba53fd2a99949187ca392c6d4488d3d5aeaf88.camel@xry111.site>
Subject: Re: [PATCH v5 3/6] LoongArch: KVM: Add cpucfg area for kvm
 hypervisor
From: Xi Ruoyao <xry111@xry111.site>
To: maobibo <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>, 
	Huacai Chen <chenhuacai@kernel.org>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, Juergen Gross <jgross@suse.com>,
  Paolo Bonzini <pbonzini@redhat.com>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org,  virtualization@lists.linux.dev,
 kvm@vger.kernel.org
Date: Tue, 27 Feb 2024 17:05:59 +0800
In-Reply-To: <fc05cf09-bf53-158a-3cc9-eff6f06a220a@loongson.cn>
References: <20240222032803.2177856-1-maobibo@loongson.cn>
	 <20240222032803.2177856-4-maobibo@loongson.cn>
	 <CAAhV-H5eqXMqTYVb6cAVqOsDNcEDeP9HzaMKw69KFQeVaAYEdA@mail.gmail.com>
	 <d1a6c424-b710-74d6-29f6-e0d8e597e1fb@loongson.cn>
	 <CAAhV-H7p114hWUVrYRfKiBX3teG8sG7xmEW-Q-QT3i+xdLqDEA@mail.gmail.com>
	 <06647e4a-0027-9c9f-f3bd-cd525d37b6d8@loongson.cn>
	 <85781278-f3e9-4755-8715-3b9ff714fb20@app.fastmail.com>
	 <0d428e30-07a8-5a91-a20c-c2469adbf613@loongson.cn>
	 <09c5af9b-cc79-4cf2-84f7-276bb188754a@app.fastmail.com>
	 <fc05cf09-bf53-158a-3cc9-eff6f06a220a@loongson.cn>
Autocrypt: addr=xry111@xry111.site; prefer-encrypt=mutual;
 keydata=mDMEYnkdPhYJKwYBBAHaRw8BAQdAsY+HvJs3EVKpwIu2gN89cQT/pnrbQtlvd6Yfq7egugi0HlhpIFJ1b3lhbyA8eHJ5MTExQHhyeTExMS5zaXRlPoiTBBMWCgA7FiEEkdD1djAfkk197dzorKrSDhnnEOMFAmJ5HT4CGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQrKrSDhnnEOPHFgD8D9vUToTd1MF5bng9uPJq5y3DfpcxDp+LD3joA3U2TmwA/jZtN9xLH7CGDHeClKZK/ZYELotWfJsqRcthOIGjsdAPuDgEYnkdPhIKKwYBBAGXVQEFAQEHQG+HnNiPZseiBkzYBHwq/nN638o0NPwgYwH70wlKMZhRAwEIB4h4BBgWCgAgFiEEkdD1djAfkk197dzorKrSDhnnEOMFAmJ5HT4CGwwACgkQrKrSDhnnEOPjXgD/euD64cxwqDIqckUaisT3VCst11RcnO5iRHm6meNIwj0BALLmWplyi7beKrOlqKfuZtCLbiAPywGfCNg8LOTt4iMD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2024-02-27 at 15:09 +0800, maobibo wrote:

> It is difficult to find an area unused by HW for CSR method since the=20
> small CSR ID range.

We may use IOCSR instead.  In kernel/cpu-probe.c there are already some
IOCSR reads.

> It is difficult to find an area unused by HW for CSR method since the=20
> small CSR ID range. However it is easy for cpucfg. Here I doubt whether=
=20
> you really know about LoongArch LVZ.

It's unfair to accuse the others for not knowing about LVZ considering
the lack of public documentation.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

