Return-Path: <kvm+bounces-34559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC566A0167E
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 20:06:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1B65A7A1C51
	for <lists+kvm@lfdr.de>; Sat,  4 Jan 2025 19:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6D61D5175;
	Sat,  4 Jan 2025 19:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kD44+Csw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88841A8F61;
	Sat,  4 Jan 2025 19:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736017580; cv=none; b=UZkEs9znT/W6Ij03wOazow4sgoEnqs2NK+y33HzKNHDPMKA8AwXuhes73G8IkzEImB165UCW47sS1305AOAB39yP8J/bPSG9+/U2MWHcwjn6NlmzrZCiR/2FgBFp5230NodgJlSbvO/Ob62RV30N5kn0G1EudLIYJMdjncHjsLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736017580; c=relaxed/simple;
	bh=1MDbs7kBgFOcRSqyfUJD8ynLlivydoMrJtUh7cqEKgc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:Content-Type:
	 MIME-Version; b=riagfneFjR6O86ohO26nRTqZ0aB4vqHHcGdF+HUjRpkAOnip2Kzf3KYCP0HIARV8HYcgaVXYV7pGQ9Yv1GYclOAV83Vou+mKSxOIommA5+PPgFj9RAaLW+J4ICcAcodUVV4VmFWDQpACl1vs5yP9QdZlpz4q2efbPYXzA8wEKxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kD44+Csw; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aa689a37dd4so2105813466b.3;
        Sat, 04 Jan 2025 11:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736017577; x=1736622377; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K9HcD+bpC3rMFg/91MXQZLjlNjY0q1Lmocb7XgBKhy4=;
        b=kD44+CswrGBrKTnW9G94nPQ+LDR0PnCqlc0azjdNbwT0pszv8YTbL7f0btrSnXGMVI
         CDSyDVI1Kce8EYumkRRuEc4QEBKaiVljqzcOrhPvJdXBQCCupfWlmxv69/fhmzZK8qu+
         UFjyVtIU1Nx43BcrXRyegZxhEjs620VBBQ56s7XgPbsA8m2LAOS/fU1hYD2lkULcsZjS
         iTLFT++Y7JfVSbNfIKIhBBrEIgS7OmA7MgfD4lXEHGyq8ORauKyOyLzhvCdsyy0p947J
         jM3HIZk42jjsWytHSSAxPMP3fNB3h/Isj05YoucL78Vbq9jJFseYvZJXBfBGV7YQokIf
         Fs6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736017577; x=1736622377;
        h=mime-version:user-agent:content-transfer-encoding:in-reply-to:date
         :cc:to:from:subject:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=K9HcD+bpC3rMFg/91MXQZLjlNjY0q1Lmocb7XgBKhy4=;
        b=m1HWFdHM7hzEjwOr1Bnd7+a/goowJcOO9v7738owGLc0rvh3++pitn0gFmFJcRVUeI
         Rp5Ext2X1z80Of6Fo1OGV3rk+FxsjOB1il//pgFWdhhCAbLbNlIXX3qI6WFBe4ekqwfK
         udfI7v1jXbDd/iCHRgeuKMnQ3VP1K4bcFo1oFQbeCendE2yiuJXMV5T1WmhTpyn2HSS3
         0KkzJoeVW+h4my0RBs86bOSvAy7kgWJqoAlovd13CasFJJoenM0xhI2GoX/Wme4R7W17
         Lc5cmWop1KSazHe5+heyC3yeMbPivjIZqgtXCybLyD3gOR5pq4wS1FnEy4PvHWCNUcVt
         SRLw==
X-Forwarded-Encrypted: i=1; AJvYcCU8YQaocms3rfixDXjE2+bcEf6Al/pkVR3cTPnJ7l7S3gPHW//GYZY82ecSaWQ43NORjiNPKbhQxask3UC6@vger.kernel.org, AJvYcCUESUHAGSVO5rwnce7a/7vGIAL5StBUz7DhPPZlNHXmgdwgTTiyTRthv60r39wGz+x4Dpw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPh8UtzgqzcR0mWh+uZ5ZR774zdLgaAXOmo5OiwK1XA7O/WVF5
	g06PztV6nj/Nhc5x77Brp6/2IBwsbFwapkB/o0xebXPm3L24iS/z
X-Gm-Gg: ASbGncsrJJ3dmIrnedrj3Rboed4HWgNJHLqNzuFvPPc8blpK+ViMw68hvGsAyf9Vojl
	lk8MExtdapunzuKW1+QBOEjhhiFHvYOhkvUIyOsqsob3rudOuIoNLc8wM4zw1p0q5Gy+P6/XjMa
	NMJRgQR+YSvKhYE4jLxtHRr/zUGtO00+4L3eW6z3g0gn7AR9zyhdKohocNWgXjjQoeF6TjDSO6D
	/GnCaNt7jY0sgwQ9qqoxOxuBNsX/TzvGsAJSt8zIpuOT73eRYSzM/EsdEonYTXQOaHH+1rv55d8
	bne8NIoLl3VYtpZ4s+V26tgLsnuECXW9z8Fd5w==
X-Google-Smtp-Source: AGHT+IF7FRi6/Fa1k2aXZFEKOXUvXaIASk+vEezgzfV/+OPtHo0VltYJpCfRbgZYL+xD+q+BrL1hxA==
X-Received: by 2002:a17:906:9c96:b0:aaf:117c:e929 with SMTP id a640c23a62f3a-aaf117cef2bmr3315138266b.57.1736017576955;
        Sat, 04 Jan 2025 11:06:16 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:5a35:63fc:d663:ba76? ([2001:b07:5d29:f42d:5a35:63fc:d663:ba76])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f074sm21580014a12.25.2025.01.04.11.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2025 11:06:15 -0800 (PST)
Message-ID: <4c49a713c6c13fc0faef039ab5ef6b38090c20f6.camel@gmail.com>
Subject: Re: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest
 messaging init routines
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: nikunj@amd.com
Cc: bp@alien8.de, dave.hansen@linux.intel.com, kvm@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
 pgonda@google.com, seanjc@google.com, tglx@linutronix.de,
 thomas.lendacky@amd.com,  x86@kernel.org
Date: Sat, 04 Jan 2025 20:06:14 +0100
In-Reply-To: <20241203090045.942078-2-nikunj@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On 2024-12-03 at 9:00, Nikunj A Dadhania wrote:

> diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
> index c5b0148b8c0a..3cc741eefd06 100644
> --- a/arch/x86/coco/sev/core.c
> +++ b/arch/x86/coco/sev/core.c
...
> +void snp_msg_free(struct snp_msg_desc *mdesc)
> +{
> +	if (!mdesc)
> +		return;
> +
> +	mdesc->vmpck =3D NULL;
> +	mdesc->os_area_msg_seqno =3D NULL;
> +	kfree(mdesc->ctx);
> +
> +	free_shared_pages(mdesc->response, sizeof(struct
> snp_guest_msg));
> +	free_shared_pages(mdesc->request, sizeof(struct
> snp_guest_msg));
> +	iounmap((__force void __iomem *)mdesc->secrets);
> +	kfree(mdesc);

This is leaking mdesc->certs_data.

