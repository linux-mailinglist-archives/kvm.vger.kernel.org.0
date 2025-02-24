Return-Path: <kvm+bounces-39011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D5558A42956
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:20:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A4B27A81EA
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 17:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F749265617;
	Mon, 24 Feb 2025 17:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X0qlPV1l"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78E9265602
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 17:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740417570; cv=none; b=JEn75PpyKA9U1FhTuem8er2OJDY/xC36fsga1v1G3j6ljNCBtCFGJz6JEBtyabk7EOQTFXUG0lhXRJpCgQKcBjigP69UVDE2WOlK8alb1dUhrVAMBiH8yIbRe7Jkhi0O+481oLjQOKw4yQtxrFfNDFxhgegomX5BqIlmPvx16wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740417570; c=relaxed/simple;
	bh=YkGfGRHPFOGIrjt7CW0/60RcoF2CYhgcQyUVsVMlKsk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=geOg6NhEpOAJiNC5U2F6gX0Vq0vrjNj6NNc03ADjQqWyWt6uUvzAqBmMQmV3m6qgGpXtQY5Fauuehe1zFlM4Zbayo1bqGpkenT3HnIriqnhl0zkUAJviY0SrcY38yRRLcSt29yKnc9AfzfYYUYvIBIV6rxk++8efnVbJ1wL00kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X0qlPV1l; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2212222d4cdso301045ad.0
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 09:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740417568; x=1741022368; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YkGfGRHPFOGIrjt7CW0/60RcoF2CYhgcQyUVsVMlKsk=;
        b=X0qlPV1la16N2wIxMgPlQUNfOJW4/YElrqRWi9AAj1U/B/YeYINNNj5tltvzUDOaHc
         v7YESB7QbhQZKJonqTHW2jiKmaUaNyZBwAHPFwoKwRMspeA7LVc41Yywp8R/qwtZ4R3P
         b6jlKRpfiEd/d+kOk5eRS0QApvdawvMBpJjaL8XIJJTyiRRG5346yIWE0XOc/eABIVNO
         IF5geENcRcU8HdffymqXe5lhtYq4lA7Yo3+xzqcUmTZKejGhSCPxkoew7Xtzd4MyPY7q
         P9+LdiTlIU45uCcWHtgvyLRzqX/HjgbCM6U2nav6EsHM1vu3CroxsH4rNzGfTEKjxHLy
         EMgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740417568; x=1741022368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YkGfGRHPFOGIrjt7CW0/60RcoF2CYhgcQyUVsVMlKsk=;
        b=LC+jZZnfMtiP0Ibbzij8B8eLZk9Och94mPthibBi+cSfQXCgMGE0dndFkVYRxMesIF
         oyaAU+l1RhTeN+TNaUKhmq3OjuGo2FIdfVP0jqzv/8ButvSMW3UC1b+4vzJTm1r+Be4f
         pm2eJmN+P2ZrSE6/zVh0Vffip2J9lMdV90ZWQqrAgIUqndEWYgPFClsCT0T/AdyabJj6
         RYuzcPEmPap0YgWkbAISP3fA0TRbCn5BtHUzgDBwvWiWjMU3+ILHAqAR6T3MZGiWglmS
         RlwlUm1Zfhm72XbG734UsJVdczZLK9nNmuDK+icpRGr0YPHLLTHKcwxYer+tQfiSjzQO
         l/+A==
X-Forwarded-Encrypted: i=1; AJvYcCVoDFmCzE393RfUiy4PKuzSFNaJ1YFkX8joVrVJ9ZUutrJ7mPFXD/YiUFJ377n8fhtb88w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwKCLMW61DxBGrIRYcxdHAPrjmTurOea2xy18aZEJ4pF93xjWfe
	rZjYNfZC2n6/pUB3aMW50rlW+rBrpYuQm7LrcVMOJQkCFvc/+BeDLjorHpakM0v54sYGm+fOFek
	y/QAyNZ7CS+9g0VgfcYQVadHjR2lgjJ7uvnv5
X-Gm-Gg: ASbGnctVsrZ3FRjXYwdfjmTZMhsFF9LFNQPTy/m34gyWdHf4dcEIpqWE145LaqHMyPK
	VxYG44UIBwqZz7gltWwsjSDNxpvGzgohBbnPCmxx+Dc79HkjvESm5ufCaD6ypb4HDKyjnRsMDTL
	mgTa2XKbc=
X-Google-Smtp-Source: AGHT+IHTAwfAEIHfGaanz2ImJIv6TFBo6hJ0pV+jmXwD7kT/u4LNJh///oPwcVt2cEUyOMZ5KobtdpSb6LmndtBex80=
X-Received: by 2002:a17:902:db0f:b0:216:7aaa:4c5f with SMTP id
 d9443c01a7336-22307a2f1ccmr89755ad.3.1740417568009; Mon, 24 Feb 2025 09:19:28
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250222191517.743530-1-almasrymina@google.com>
 <20250222191517.743530-10-almasrymina@google.com> <Z7ypMjORvm99q6L0@mini-arch>
In-Reply-To: <Z7ypMjORvm99q6L0@mini-arch>
From: Mina Almasry <almasrymina@google.com>
Date: Mon, 24 Feb 2025 09:19:13 -0800
X-Gm-Features: AWEUYZkSIiPtvI8VObRXZQvcc3R--20e8PUb_X-ZIgU5euHjlp4NxpuUlOVfZXU
Message-ID: <CAHS8izM9xMqWnJB5Cm=DMMBV1BuUemFjKSv9So8V_xQ8ToTRqA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 9/9] selftests: ncdevmem: Implement devmem TCP TX
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, virtualization@lists.linux.dev, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Jeroen de Borst <jeroendb@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, sdf@fomichev.me, asml.silence@gmail.com, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025 at 9:15=E2=80=AFAM Stanislav Fomichev <stfomichev@gmai=
l.com> wrote:
>
> On 02/22, Mina Almasry wrote:
> > Add support for devmem TX in ncdevmem.
> >
> > This is a combination of the ncdevmem from the devmem TCP series RFCv1
> > which included the TX path, and work by Stan to include the netlink API
> > and refactored on top of his generic memory_provider support.
> >
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> > Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
>
> Acked-by: Stanislav Fomichev <sdf@fomichev.me>
>
> We need exit_wait=3DTrue for check_rx as well, but I'll send this change
> separately.

Yes, I discovered the same thing, and I have that change locally along
with some other fix ups I'm readying up for review in a separate
series.

Thanks for the reviews!

--=20
Thanks,
Mina

