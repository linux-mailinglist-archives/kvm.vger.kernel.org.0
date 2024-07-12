Return-Path: <kvm+bounces-21524-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 90CB492FD9F
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 17:31:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4BE95284726
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 15:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35B481741C8;
	Fri, 12 Jul 2024 15:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dN9DtSHU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDC915ECE1
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 15:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720798294; cv=none; b=azPR8zxjqEIxtZD/sJtqEECE8gCCtiCKmU+WtOmXLsMszQ4o0s7lcUwAJh1jfLxuLN92QppACCUfFEdqDn5e13CKldfCv25OGGRTSspC+dJHp2EO08Fo/LJ4zK1JJ55Nruldso2id3oNIw5BvK8t8vc+L1s3CMwlbYXinZwWaBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720798294; c=relaxed/simple;
	bh=yuUkgSUd6vmj6tHpzYFlSGQESGT/hX3N3hMolRd/53s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qWFn/zvjQ9ACV9TmTzIE4hsaMHr8zHUNcgZ0zzg1BwCbPvG/UjzGZ+ukd3g0f9Q5HIgvn1ZTpu4WF+b/MT/v7nbU4xvHDzBMYQix7nxNht/Wgw46mRDi1Ays3nX/1g7A8N3si44Ly+y8TMV7W07y64zCb/+45zIOwqgWa7wi7CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dN9DtSHU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720798290;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8pYjkzLgzHvy7cWc4vPkKfOHo7WvPjxKqpxHFA0Pgts=;
	b=dN9DtSHUGa3PHa33clfo+lPft1jy2Sni01TfFV9PjgDox5WQ/O13e3+9KwuGW3TM3laZ6u
	B0PokTmMjut04DP/27mteghGc2rwdkemWtPWr6DZw1p2ztNqaDkum6pIQfzPObDR5Ddwh4
	+W6BesMKbHfuWGpeTroxLO4Dujqdt3I=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-qMiyLKo2N_yWKq7nWtoZTw-1; Fri, 12 Jul 2024 11:31:27 -0400
X-MC-Unique: qMiyLKo2N_yWKq7nWtoZTw-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42674318a4eso19780775e9.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 08:31:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720798286; x=1721403086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8pYjkzLgzHvy7cWc4vPkKfOHo7WvPjxKqpxHFA0Pgts=;
        b=BzQp0nSycxfveUCO25f8tZlhGAAfh5D3aZvKiVMPEO2S04ghWZFGfETx6sGKQ8qifc
         MfCYuphH5GYA8/7sy/y5OpxqaySnAPYgU5PZRmALsql8FrA8mDt+BBEL/zpRcwOeRp54
         pVcCfJOhL1lBiLL2E/TARukJtfq6nhH+71oYr0GOqGb9hxVEFOdmj+z/6/xWKVtUCQAX
         2a/SpF2Q2bTAlYedWwTVdDwx/g699ijMBQUDZdspig2eJiGkgI7NI0djQmIy9juJrwmm
         pQkmhGC5JF1z/lxemC/4MCAt/MHnA7QsbtZDh9zgivAc4VCPtrT1DHJTi6lR327+/s3a
         7iRw==
X-Forwarded-Encrypted: i=1; AJvYcCXQmrZqDwKOjcXQb5GS01drpodWM+/6OxRFCrpXJ5KDBWTocjp4hZpa8rTokDRYX+NSawa4i6/aBLyN2XBbKoI5msit
X-Gm-Message-State: AOJu0YzDs898lmgeySu1s7Smq4RnziF0pa0f2UFbiC6zGzGWF2fkKDrE
	a/tByNBwsAR0nlNzVUg41b8h2eA3Eg96Ln1x0XHH8yBtLPxBBweCNbEsXtOO9mkIXC6rSDZXcN4
	1XPoCTxcWu1aEUQoCFc6wGKB52ehJS8O6qIoFbF50kGhMyIOdoqrqtD3EYQd1vGqZR8E6cSyHFE
	2R84sAANaDAff79D3Jz2LKEHqu
X-Received: by 2002:a05:600c:47c7:b0:426:6ed5:fcb with SMTP id 5b1f17b1804b1-426706c62c0mr103472075e9.4.1720798286749;
        Fri, 12 Jul 2024 08:31:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEpwU6rx2/rdjP1qBUZaPIgntGNbKwFTW7FjwPn5/uO82kUiFkIG1Brg/z5ZHfnsc9cT0EpUfc5/AnoXthMn3k=
X-Received: by 2002:a05:600c:47c7:b0:426:6ed5:fcb with SMTP id
 5b1f17b1804b1-426706c62c0mr103471885e9.4.1720798286392; Fri, 12 Jul 2024
 08:31:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710104923.2569660-1-chenhuacai@loongson.cn>
In-Reply-To: <20240710104923.2569660-1-chenhuacai@loongson.cn>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 12 Jul 2024 17:31:15 +0200
Message-ID: <CABgObfZd1ugY4cFygnvFtiO9p3iE1GA3Wn7Avdkajz_9iXVNTQ@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.11
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Huacai Chen <chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 10, 2024 at 12:58=E2=80=AFPM Huacai Chen <chenhuacai@loongson.c=
n> wrote:
>
> The following changes since commit 256abd8e550ce977b728be79a74e1729438b49=
48:
>
>   Linux 6.10-rc7 (2024-07-07 14:23:46 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson=
.git tags/loongarch-kvm-6.11
>
> for you to fetch changes up to 492ac37fa38faf520b5beae44c930063265ee183:
>
>   perf kvm: Add kvm-stat for loongarch64 (2024-07-10 16:50:27 +0800)
>
> ----------------------------------------------------------------
> LoongArch KVM changes for v6.11
>
> 1. Add ParaVirt steal time support.
> 2. Add some VM migration enhancement.
> 3. Add perf kvm-stat support for loongarch.
>
> ----------------------------------------------------------------

Pulled, thanks.

Paolo


