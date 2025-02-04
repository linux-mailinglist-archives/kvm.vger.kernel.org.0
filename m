Return-Path: <kvm+bounces-37253-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2569A27892
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 18:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1C971655B2
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 17:36:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA020216E1B;
	Tue,  4 Feb 2025 17:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d4+rhr9N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839C6215F7F
	for <kvm@vger.kernel.org>; Tue,  4 Feb 2025 17:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738690527; cv=none; b=F+tMJ09V6d9WM+Za3jrO0eDMvAbJQH+/2hNqN2wVzWkqGGey+BLG7mHZs03//Xm6AS4bWROetFkEiI1W3LoebkCTy9+zeWT6RVIrTUXj/Xd09SR5BTGLtFhOPQMRkCw3JltRC1JhaohyVFCn5npTmFOyvBw8DGvbYR952qdPyzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738690527; c=relaxed/simple;
	bh=zCHNKGA6MIC6IBXzZGco0x6H0vkuSlEA7G+5gjB5WwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QkggQFklhHxue/v02sI0xj0Bhm3F7qkZlpCS+xpUlSZklRZbLgrwFCo2LUPyssfTXZ79otZgbdwtky9672wTLAKxhUC1Epai4VbHBVxfnS9Zp4ZAOtRDz5XNgIe4Giw8n94l6I16zyzxst3QRKc5808U5KAulPwFeszvkM9HPlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d4+rhr9N; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-219f6ca9a81so128735ad.1
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2025 09:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738690525; x=1739295325; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84XRGI+7lwmGL6GUPwbtH7AhjEYYUVi2GeiyJJ7VXBw=;
        b=d4+rhr9N7zikIW+KEMZg+mcQTPWn3C3oVbh7IFjp/+E3N9ZO0Vz+GYDjAEb5GoVIDe
         MzagfKV8ddXD5kBdfbj6vBRUbchPhacBWeKxTQL5c9FamSDkBny5X9kPdpOwBzVsvpNS
         wvOzTCnf3rKtYIMtnZbmEbKcZMM7/x6kcTtBWXUbFPSV0zS1pjqmaDthXOzCpqfwp0kT
         3fSZzjsGH1j+XMtop7Q9oBvGHDEv3xBzkZJSLiYAXylwl+UCktgVt/UcHaPDP6AmId3d
         RaXsirVOZLD96J21TOH5q6jPlGIhOPCwhr04nxwfou3hBJKUgJ+PkZjv3MPSv45GRiT9
         6WSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738690525; x=1739295325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=84XRGI+7lwmGL6GUPwbtH7AhjEYYUVi2GeiyJJ7VXBw=;
        b=NCMfnsdkuZZsMIOsR3dHMkYF3O4MsB3+US3HqyNTI7YvCDCKsyt9rH5OIjBdbWRPwQ
         UJDHQvEQ7tPVRnvjRuDsvuDmGWLBmKxQTicz24bbxYZ1PxhhsNovC4MrSWxgd+XBkQO8
         DhhdHDCKokI9fkI8Epl45kg9zG65lqa7jvqC/FC+9HWPqeW6SsOh6LcfiGIXNQGuBpeL
         AceRFCSwcG3oz+NXgk2R7/Ss24OkX097b1iP10JkpB6CZ0pRg0UA2NoGpSu6oo63eIfC
         oJ34xjziOCc4EqVd6fZxkfI2l9z6wBj7Q4y24k1e+dTGGL/B9yOmObydVQlyyH800Odj
         sGtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFN26VZATsxP6MSw4UOH5nkqFkA00i2vSG2NqAVBdz1CL9ckd520dd9F+ads0ugPw+YIw=@vger.kernel.org
X-Gm-Message-State: AOJu0YydzyKONu4OIHI/bBMs7TDnAxVEQDLLFsYguHTqWXd2XfLKCITl
	BTdotN42wDPMiCbUf+hJOB7yolZoKI4jOcvpQv5uGk4lZAZ/j3RlFu3zvNyFwqqQbFFZZ2Q8R8L
	Ryy+AuIxAm8HjpTXWH7vVtBd3U6RZLBM/lnrW
X-Gm-Gg: ASbGncvTFVM4a+5W7NLnpkjqhgbwqvcP3tn8oAQ9viTkQmtd2wS5Ta9nBpRHsLenOU+
	0IPsmYaUtUMq9uSRR3FlgGFcvqc/uQ+snbaVotM4lkpFoNQyxnNi2qaLZn0iB06B8IJkQldW/
X-Google-Smtp-Source: AGHT+IHg8SF867Yy+z2GXbKry2r0iDmWlZunHewA79883dWtyyKDj6PGknuUr+EeJwHqGa1SQwzcF0gj8w2TziRSjaE=
X-Received: by 2002:a17:902:d9ce:b0:215:7ced:9d67 with SMTP id
 d9443c01a7336-21f005bbe36mr3250755ad.24.1738690524517; Tue, 04 Feb 2025
 09:35:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250203223916.1064540-1-almasrymina@google.com>
 <20250203223916.1064540-3-almasrymina@google.com> <c8dd0458-b0a9-4342-a022-487e73542381@redhat.com>
In-Reply-To: <c8dd0458-b0a9-4342-a022-487e73542381@redhat.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 4 Feb 2025 09:35:11 -0800
X-Gm-Features: AWEUYZn1moYHmrXoVYPPn5psMSRlqxODAnsNkR2q6mSq4IS5EB-8iProLqujYec
Message-ID: <CAHS8izOnrWdPPhVaCFT4f3Vz=YkHyJ5KgnAbuxfR5u-ffkbUxA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/6] selftests: ncdevmem: Implement devmem TCP TX
To: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	Donald Hunter <donald.hunter@gmail.com>, Jakub Kicinski <kuba@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, asml.silence@gmail.com, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 4:29=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 2/3/25 11:39 PM, Mina Almasry wrote:
> > Add support for devmem TX in ncdevmem.
> >
> > This is a combination of the ncdevmem from the devmem TCP series RFCv1
> > which included the TX path, and work by Stan to include the netlink API
> > and refactored on top of his generic memory_provider support.
> >
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> > Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
>
> Usually the self-tests are included towards the end of the series, to
> help reviewers building-up on previous patches knowledge.
>

I noticed reviewers like to go over docs + selftests in my previous
series so I thought I'd put them in the beginning. Looks like the
gambit was not welcome. I'll move the selftests to the end. May also
move the docs to the end as is customary as well.

> >  .../selftests/drivers/net/hw/ncdevmem.c       | 300 +++++++++++++++++-
> >  1 file changed, 289 insertions(+), 11 deletions(-)
>
> Why devmem.py is not touched? AFAICS the test currently run ncdevmem
> only in server (rx) mode, so the tx path is not actually exercised ?!?
>

Yeah, to be honest I have a collection of local bash scripts that
invoke ncdevmem in different ways for my testing, and I have docs on
top of ncdevmem.c of how to test; I don't use devmem.py. I was going
to look at adding test cases to devmem.py as a follow up, if it's OK
with you, and Stan offered as well on an earlier revision. If not no
problem, I can address in this series. The only issue is that I have
some legwork to enable devmem.py on my test setup/distro, but the meat
of the tests is already included and passing in this series (when
invoked manually).

--
Thanks,
Mina

