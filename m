Return-Path: <kvm+bounces-43826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68C6AA96DD8
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 16:04:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7161316312B
	for <lists+kvm@lfdr.de>; Tue, 22 Apr 2025 14:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8F7284B3A;
	Tue, 22 Apr 2025 14:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="diHRM3SS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388462820B8
	for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 14:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745330622; cv=none; b=X0lroTZe7fMvslz3/7+DLW3R19bl8YHefuK797952pS+z4Aw1wj8nX3Gallwsljw4vVQC5OTs4FPGi1cVRsuR1p1RW9oOQxWh6CENNEl295F1Ct4KB5ez5c3oKPByM1Tz9OSK1Uq/gmv90nTH3mugFjvi21h18VQcM66SnpH7ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745330622; c=relaxed/simple;
	bh=DI5wbiqZFhNjcg4g07wsE2rRpyR+Bg6kHqEcrbHze4Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iY4cBDbujO+Nes4MsZboMvTUdbOvh9Zmds2NldWNaozShYXrDh1kkGlpfTFO1dn2JB80MoH9zOv22qbuTgIdrHhbben9l5qxMwRF6E6S6WqK7Z5EVebbN7yCNqcElgyvAm827sQ4pSB35X+VCIJJyGMyS1GKPqIQ7aDLD5ZoC2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=diHRM3SS; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2240aad70f2so182755ad.0
        for <kvm@vger.kernel.org>; Tue, 22 Apr 2025 07:03:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745330620; x=1745935420; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wxtxQ2q5f2CesvMzHl2K/43Dvf+KKs8Sp+BtzyImVRI=;
        b=diHRM3SSYX1rhVTrFh85dMgmHNY8sO2ecyPwPFFxn5sQbKf8uyHGCTCokaasiZyg6F
         VKxRmeoGqd8z3gNfYfdYx9nRIt0sO2m4rZspMiU89vOTce8M36DF/iBjf+yUOw63OKP3
         hITordz6p0dyt9ILX6PjDqmdftBpNagsZ2+9Q43sianlor0YDckrxv6UHr73LrRP40nl
         0RhaPUqvIJhdfxVTKdVpFekbtxJ6p6mBz3v5CgPtgZJFLkFtAW0VeT+gmLV9s0iEgJ0l
         8gyzbdup2vQ5J4dKQketbtzn+Miv5FOylJYS/7yQo/70s3oaoMk8nilN940PIjwG8SKq
         /+mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745330620; x=1745935420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wxtxQ2q5f2CesvMzHl2K/43Dvf+KKs8Sp+BtzyImVRI=;
        b=wor5OlPQ0eoZ7UkaXyVfD/I1yhjQJCnepBLinUL7Te1om/xbTCmIb7UZoqs7rI/HYM
         dd8cY243bJ1IZBuQ3k4+ZWnsrxBsYwQK0LN5zf1Frd5QenGxnoh1tjQn0Oev+buE7SWg
         qbQBabXc6Ze4D2gTDku814KUKg2LYNlzDV+xe7NRSncqOKQLOn46YVdJoAcKz1Tem+k5
         dmp+lTHWRQsSxrIvLl0XMXFppeU1FBNASpRGYz/BWF9xSndLOB5/LSMTfy5bPrGuCpjN
         yp+UU9AS9whWSMo1MOyFiQpI7sX3mngzAwFxzjyYhvC6LQHxT89ACObwl6ROBF6ZfguB
         Ckzg==
X-Forwarded-Encrypted: i=1; AJvYcCXRrg4RaCRXgL2o8vRB+bgIBL0MWXTf1iVphD7FtR9IkxdQOmfFxvoh/DEm4WqWKMif21M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzhhQRn0n811tgLVNWsJkTfe3Cu7FA9mL7ZpmfpjNGG7Dhw3B2l
	m2lkITGmWZoKE4YR72fzhl80RuSBC0PPKAfTcylwdbR4YtIxKRvTwRS/Qbrxe1m8JP8/HxWggAS
	5IhmSDQumfHU4D7p/V2NGz1/7s7Chdmber79O
X-Gm-Gg: ASbGncsyXANGe46MI357heiqJ0pU3Hb8KhiGbI6fAgatIxTz2zAZKwSsVXdq0RixwBO
	MjCCe6XTITFS4xEZLwQIMjr5Dvrw9zwkdOCVy9yTSi+vM7POpL5QcAwMDh9gzt36F9rhF5Hpr48
	f13d6j+lznWJpE8wVTPMoGIKdujHAgVTY60A==
X-Google-Smtp-Source: AGHT+IG0i+651pdR53K0l/n7uIQCSuRiQEGLD3Fi7ND1TmWV2npssXiwnzzo30HBpgP42jyUy2IALw8wxWFt/Kz8RzE=
X-Received: by 2002:a17:902:ebc3:b0:22c:33b4:c2ed with SMTP id
 d9443c01a7336-22c52a93c28mr10089535ad.26.1745330619867; Tue, 22 Apr 2025
 07:03:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250417231540.2780723-1-almasrymina@google.com>
 <20250417231540.2780723-2-almasrymina@google.com> <f7a96367-1bb0-4ed2-8fbf-af7558fccc20@gmail.com>
In-Reply-To: <f7a96367-1bb0-4ed2-8fbf-af7558fccc20@gmail.com>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 22 Apr 2025 07:03:26 -0700
X-Gm-Features: ATxdqUHgiM0jEZwKYWOLJlVXJ7i1N-PNg4kE-n9ns-g62S6RZ7kqQTTDhmeVqPw
Message-ID: <CAHS8izMFxDG5E07ZdqnDH_2D_g1fW8X0M7u3gGyV8efzxDNZbg@mail.gmail.com>
Subject: Re: [PATCH net-next v9 1/9] netmem: add niov->type attribute to
 distinguish different net_iov types
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, io-uring@vger.kernel.org, 
	virtualization@lists.linux.dev, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Donald Hunter <donald.hunter@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	Jeroen de Borst <jeroendb@google.com>, Harshitha Ramamurthy <hramamurthy@google.com>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, 
	David Ahern <dsahern@kernel.org>, Neal Cardwell <ncardwell@google.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	sdf@fomichev.me, dw@davidwei.uk, Jamal Hadi Salim <jhs@mojatatu.com>, 
	Victor Nogueira <victor@mojatatu.com>, Pedro Tammela <pctammela@mojatatu.com>, 
	Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2025 at 1:16=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 4/18/25 00:15, Mina Almasry wrote:
> > Later patches in the series adds TX net_iovs where there is no pp
> > associated, so we can't rely on niov->pp->mp_ops to tell what is the
> > type of the net_iov.
>
> That's fine, but that needs a NULL pp check in io_uring as well,
> specifically in io_zcrx_recv_frag().
>

I think you mean this update in the code:

if (!niov->pp || niov->pp->mp_ops !=3D &io_uring_pp_zc_ops ||
    io_pp_to_ifq(niov->pp) !=3D ifq)
return -EFAULT;

Yes, thanks, will do.

> You can also move it to struct net_iov_area and check niov->owner->type
> instead. It's a safer choice than aliasing with struct page, there is
> no cost as you're loading ->owner anyway (e.g. for
> net_iov_virtual_addr()), and it's better in terms of normalisation /
> not unnecessary duplicating it, assuming we'll never have niovs of
> different types bound to the same struct net_iov_area.
>

Putting it in niov->owner->type is an alternative approach. I don't
see a strong reason to go with one over the other. I'm thinking there
will be fast code paths that want to know the type of the frag or skb
and don't need the owner, so it will be good to save loading another
cacheline. We have more space in struct net_iov than we know what to
do with anyway.


--
Thanks,
Mina

