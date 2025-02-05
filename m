Return-Path: <kvm+bounces-37397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A8F3A29A6D
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 20:53:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03EC5164042
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 19:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5ACD211291;
	Wed,  5 Feb 2025 19:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uFqmbNS0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F0EDF5C
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 19:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738785223; cv=none; b=OoOCzr1Nm4Xs/nxwX/hvZrt7GE+9+7VJKEPWgJF4NspWft4tYydK1prNQa7Qeph35LNEFZ3ASRpo64lQWMwdAx1c4lgzAg2fYRCzqueqfZ3XI+NZJ8jsnxE9xTSRMyU2z9P+AGjW1/ZwqmqgexOnKC8WGbmcmapFBHy7OVC4vso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738785223; c=relaxed/simple;
	bh=6q5v84lcktHrl3Z/XuzQ2h/3k5A/dQfZvkx4mZLUD3I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WTWzTu4ZqKG1WvTpabYfwilrMkY5zliAi12suxCgHuL7P7uSrDdESCnM8LEudxJ5qHJqJqK7SIb6tj5JuerFC+PvW4F9TM1nyGw9+2OG/icoh0h2WUrZrHtHbhG44WAsSTpXup8lbdSC/nJlM+FyLzfV2G7km3KJ22VXsF1gieM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uFqmbNS0; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21625b4f978so24425ad.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 11:53:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738785221; x=1739390021; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6q5v84lcktHrl3Z/XuzQ2h/3k5A/dQfZvkx4mZLUD3I=;
        b=uFqmbNS0aBRnuo9pIv0WlRbfYcyfLCZgY3fhAFoYmNRMInar7ONTMyWfrwIkc1o7Tu
         h/NNa5g8HMGIKel+KVJG+yqOExkoR0MXGAcvEWi5OElTbZVVa6GJ43In2ZXxNYEPdotq
         etguEabJ4EeAKgyL4y4RQ0WuNhvShkm/Zo7zDY4m1GjCqkwTiQLy0Jv9sObNcQ0uA+DA
         KdbhALjjkfSubZV5ENAirfaLKmMu5+CCXre1AqVY+e/09ztZMNm970g/tCTnmM9d9tEc
         QTzh7NbdC0EsuH3LEukcps4R6JpRPT1fNoAOylP+0Vq0tAcx2+AjhY1aXtI1sF/yyNOW
         kUqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738785221; x=1739390021;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6q5v84lcktHrl3Z/XuzQ2h/3k5A/dQfZvkx4mZLUD3I=;
        b=iqshDTIKQkEVF+c0BDPG5vY7XXsT8D7xsgQFzGVGeSvUyJMmy0ke8FQxydl3Wu0zDs
         7/+2IUKY5qn3ypPIU0vKNuTRYm30ba+W88iPHcYDg/QqrUsS1GjH9gZGqiaJXMll/bWX
         lTZAX1t/7uUu/AqGn7WUuoQDVu3y/x1QO4IymIBuXf6NI2FOcs0S0YoGNSG6F5eTvKG4
         7AonFh9Mfy5VAssxuZGkIFOt8aCjnfqj4dqNFyS3qj9YqlrMXTxog/8z27Y+RYSLxFY4
         osuKtRcsXDtp3VZPJ1dN9rOqwXo1SpXh70f3yK3TzxruNFwLJmCQqP4Xn/B8aTxR1yN9
         bTdQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1zfJXgxAbER5Fz3ZByTzaxo9PSebH8uUjXHw1RvEE1ObSSvNMhLF5EXwfxYLczQ6WFzU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNpDdClxg6fYYFw1k8H2/cRc8OP5Fgg0P73MxzLYSurzr7Zobk
	D9TWYODVGHvEHVgfMZPvl6fVHXtq7He6zVLRCOW3wGliMqTUuo8MJAgaSSU490xhXkm3zOZoaPr
	xbBjOlQqS2ZTOJ3b3+iup8VzXiOWjg3H7poEY
X-Gm-Gg: ASbGncufrb+DNDAthjaeVUWYg8k4+Z0qVdk+URaYr8k48qCKvlbzz8mwMEZU5behWTW
	cCFL1IEH1x9gZRCIjAFfgX5O5UzRA3MxmPCQskVKYRm05duNxJJ0HyGdcDgPGn3gCijcPGwC4
X-Google-Smtp-Source: AGHT+IFDcob/TSEuYMXb3hSVO++9mpu4Se8Bnl44BpJBOAaoFodhFrUGSu2xVB4BmBZwjRYxoARZ3TUatoE/oCz5blg=
X-Received: by 2002:a17:902:a9c3:b0:21a:87e8:3897 with SMTP id
 d9443c01a7336-21f3022831bmr337775ad.4.1738785220998; Wed, 05 Feb 2025
 11:53:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250203223916.1064540-1-almasrymina@google.com>
 <a97c4278-ea08-4693-a394-8654f1168fea@redhat.com> <CAHS8izNZrKVXSXxL3JG3BuZdho2OQZp=nhLuVCrLZjJD1R0EPg@mail.gmail.com>
 <Z6JXFRUobi-w73D0@mini-arch> <60550f27-ea6a-4165-8eaa-a730d02a5ddc@redhat.com>
 <CAHS8izMkfQpUQQLAkyfn8=YkGS1MhPN4DXbxFM6jzCKLAVhM2A@mail.gmail.com>
 <Z6JtVUtsZL6cxsTO@mini-arch> <20250204180605.268609c9@kernel.org>
In-Reply-To: <20250204180605.268609c9@kernel.org>
From: Mina Almasry <almasrymina@google.com>
Date: Wed, 5 Feb 2025 11:53:28 -0800
X-Gm-Features: AWEUYZmMVG6gb-GClyYhPSsDJYW5WzEYrdAHF0Dz0FhMB9-YcVD_emeIkz00f9E
Message-ID: <CAHS8izNPxqUHNcE-mtnLSMEpD+xH9yNCxEAkvn01dLekkuvT_Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/6] Device memory TCP TX
To: Jakub Kicinski <kuba@kernel.org>
Cc: Stanislav Fomichev <stfomichev@gmail.com>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	Donald Hunter <donald.hunter@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, asml.silence@gmail.com, dw@davidwei.uk, 
	Jamal Hadi Salim <jhs@mojatatu.com>, Victor Nogueira <victor@mojatatu.com>, 
	Pedro Tammela <pctammela@mojatatu.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 6:06=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Tue, 4 Feb 2025 11:41:09 -0800 Stanislav Fomichev wrote:
> > > > Don't we need some way for the device to opt-in (or opt-out) and av=
oid
> > > > such issues?
> > > >
> > >
> > > Yeah, I think likely the driver needs to declare support (i.e. it's
> > > not using dma-mapping API with dma-buf addresses).
> >
> > netif_skb_features/ndo_features_check seems like a good fit?
>
> validate_xmit_skb()

I was thinking I'd check dev->features during the dmabuf tx binding
and check the binding completely if the feature is not supported. I'm
guessing another check in validate_xmit_skb() is needed anyway for
cases such as forwarding at what not?

--=20
Thanks,
Mina

