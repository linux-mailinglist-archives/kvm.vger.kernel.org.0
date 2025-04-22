Return-Path: <kvm+bounces-43853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 01D7BA97890
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 23:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 306754601D7
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 21:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A9DF1F2BA4;
	Tue, 22 Apr 2025 21:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GB7eL9mu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EC71E9915
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 21:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745357459; cv=none; b=uaUli14RiCeUJyycFcdUas5lNKxkqOgvksbttVQwKpACHn2iy82sy7N+lgry1CdiR+UnUzjHGdGGI2KGQXi6nNSmLoeKnQiUKVD3k3cyaE/QhqM9k0xqYrTJX4SD05DSQeDhQHVvU4vqy+lFYVr0z2LoPcOPAhfjKkArBqkcRZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745357459; c=relaxed/simple;
	bh=QgWx/mGTOHW5+7tGU+2WKWru7coX4Xp6cIn7ZGTb7ls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=em3Kjd1aKMj5/sQl1sjoO3GfIyokDfXQzkamlfywrjvwKFctNNEBcOK7P2v+gybpKkdeLdSTw07uPOiXLYsRRjrpHpxwSru67bHRjPf5LfuJ2fVpYTlGoG1lQPK+db3JHbEnZC+yXyaq5YGIDgT++xFI2tL/PvIoSDiLms6hfpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GB7eL9mu; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2240aad70f2so79855ad.0
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 14:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745357457; x=1745962257; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Svf2ygZXkmCy0ML2RTDTzsfPn2nyYFTdu9KxKlqPAMw=;
        b=GB7eL9muGEq2eNRHjsAa5UlA8JCZVgnhmydKuptdQE9PiUvhitHuM6+nHl7k4fP6j0
         I1jbWoTqUSt+FBJJaRSjdH//1cpvP5jqCQBqH6Cegb+j9XcV09M2zJ61iTqdndkB2aAp
         GjZeu9EJk9PDm2NXxkTw13580cEMqXX6LzjP+eNIcgm7B8o1g2Ynh1vfZD+6byvbhdvF
         YobfiM53q1xsDnAryKQdgc/W+m4KICbdn4qvcZ858aOU4Zr5hJDE6mKVvNt+q56YV+Iy
         YrzRZIYrJvekbfs9gUk1fb1ocKhivgNcDljcEx5YFVx3CsDIJ+AOZJgpbo9sfxw/sABW
         bGWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745357457; x=1745962257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Svf2ygZXkmCy0ML2RTDTzsfPn2nyYFTdu9KxKlqPAMw=;
        b=bVwWG0CHnhUt5MD5+JOQB4f/Z28wplkDCGHEvFP7zwESffjv0PkrNo8KUgxKK57DZS
         sN/D4ukP+fwFXnRRtVjlzPbL3hMgH1M04dvevvU9GSBT9RfdgWqPvICbouRY/ZO6Pn5Q
         VJ12yuU++mfYKTNhCA0mmCIdQdmq4L4K8Qy9ygdiXRva8+X9B4lGpzo3WrqFz/Qb22rv
         DU5FnYgmOyzJl8TkkdOQtm4xbzbw0IyepFcZNG7e3Fq4+FLOmcHbNpof63gIQNQv2luY
         2B+JRRnfNUFHhoS9gTnjEv3+DkFAYmmOgXhG+5bMEPGxsHHhWNyvLovkPsnfoZzgfc6j
         Gp4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQo/QYUp8n7OatScBo5tXHkgPTXufY6N0X39ORuKDH01at+Tqy7FTuq7jR80SJ6ggBTXo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxza4VE1eJ7oYYjV0LjBS3U5spoc1nX8IbBdfevnzkb9NHtwxTY
	JWxiR8K+6LOX3BGqYCdaqMPwjG3FBpQds9WqNeDpnHhN/5qm3PSW6ZTpMgVy7uPoCKGcb3NdR4U
	Blq+MypCZPlGVIXuOoiZvYlLCUby6keRejn4j
X-Gm-Gg: ASbGncvGal1zAF3XJv+nQx5QC/uwezmEyfisdP5SsXWeK84Zkw35Z8ROqj0MhKTI5vE
	0Tz9IHEuBXqiZiymIgz5K4KyhFTdzlq1U3qGQrpyGY400fqB+WNgIGpikRP2LE+gU0yKoqO79E3
	u+5FfGSc1ipU/U3zNMoRB5Mmyu85rqMwHGLV4CuXj0p8+PctqvSEMK
X-Google-Smtp-Source: AGHT+IEsxPoKV42ELz4r3PlLIa9B44ITOq/P7IHVyPrE3pHPM2hSBs7ANYJO9Qlwme81VQmpCIMF5XJigErG9Bs9itA=
X-Received: by 2002:a17:903:f8b:b0:21f:3c4a:136f with SMTP id
 d9443c01a7336-22da2c11b3emr916085ad.28.1745357456832; Tue, 22 Apr 2025
 14:30:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417231540.2780723-1-almasrymina@google.com>
 <20250417231540.2780723-8-almasrymina@google.com> <CAEAWyHckGSYEMDqVDT0u7pFCpO9fmXpEDb7-YV87pu+R+ytxOw@mail.gmail.com>
In-Reply-To: <CAEAWyHckGSYEMDqVDT0u7pFCpO9fmXpEDb7-YV87pu+R+ytxOw@mail.gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 22 Apr 2025 14:30:44 -0700
X-Gm-Features: ATxdqUF6FGOZDMaVY4FPxfYTFEWH1OIzJQfd7hMv2NVJ5VM5o9Gd234gao1kzAo
Message-ID: <CAHS8izNZXmG0bi15DpmX2EcococF2swM83Urk19aQBvz=z3nUQ@mail.gmail.com>
Subject: Re: [PATCH net-next v9 7/9] gve: add netmem TX support to GVE DQO-RDA mode
To: Harshitha Ramamurthy <hramamurthy@google.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, 
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, David Ahern <dsahern@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 10:43=E2=80=AFAM Harshitha Ramamurthy
<hramamurthy@google.com> wrote:
>
> On Thu, Apr 17, 2025 at 4:15=E2=80=AFPM Mina Almasry <almasrymina@google.=
com> wrote:
> >
> > Use netmem_dma_*() helpers in gve_tx_dqo.c DQO-RDA paths to
> > enable netmem TX support in that mode.
> >
> > Declare support for netmem TX in GVE DQO-RDA mode.
> >
> > Signed-off-by: Mina Almasry <almasrymina@google.com>
> >
> > ---
> >
> > v4:
> > - New patch
> > ---
> >  drivers/net/ethernet/google/gve/gve_main.c   | 4 ++++
> >  drivers/net/ethernet/google/gve/gve_tx_dqo.c | 8 +++++---
> >  2 files changed, 9 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/e=
thernet/google/gve/gve_main.c
> > index 8aaac9101377..430314225d4d 100644
> > --- a/drivers/net/ethernet/google/gve/gve_main.c
> > +++ b/drivers/net/ethernet/google/gve/gve_main.c
> > @@ -2665,6 +2665,10 @@ static int gve_probe(struct pci_dev *pdev, const=
 struct pci_device_id *ent)
> >
> >         dev_info(&pdev->dev, "GVE version %s\n", gve_version_str);
> >         dev_info(&pdev->dev, "GVE queue format %d\n", (int)priv->queue_=
format);
> > +
> > +       if (!gve_is_gqi(priv) && !gve_is_qpl(priv))
> > +               dev->netmem_tx =3D true;
> > +
>
> a nit: but it would fit in better and be more uniform if this is set
> earlier in the function where other features are set for the
> net_device.
>

Thanks for taking a look. I actually thought about that while trying
to implement this, but AFAIU (correct if wrong), gve_is_gqi and
gve_is_qpl need priv to be initialized, so this feature set must be
performed after gve_init_priv in this function. I suppose this feature
checking maybe can be put before register_netdev. Do you prefer that?


--=20
Thanks,
Mina

