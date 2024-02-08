Return-Path: <kvm+bounces-8327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD3384DD0E
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 10:35:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 629621C26607
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 09:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6502D6D1A3;
	Thu,  8 Feb 2024 09:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="25vftL2u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C85679F3
	for <kvm@vger.kernel.org>; Thu,  8 Feb 2024 09:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707384909; cv=none; b=Bw8inFmqC+1omkrFiX7PVJipLlo37ok8wdYgiYrdgVJaG57FEGSxy3dEAH7jZyDVBZQHgNKlsMKWe3aa4nz/VH9TrwwMJbxnABdCjFIcf3Lqbvvz+fw4dfATwyDDd0aKCiGaru7KnWAhiZHHadw9Hmr8jDXuX0c/jgTQzbhc6jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707384909; c=relaxed/simple;
	bh=PL4bURsXss2T7/h04cdjZreNU22ZlKTVyPSJ+8zE40c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EBNIx8zVp+HwTL24HR1ZYyyJc7z+Hk5baaLkENy80/EwiIyrZjuBTilU7h9fIoqAKxlpHxu8k9KC1acGbx5UhAoj9I7bZZC3bCINJLPO+4HlIeNpleK+oAKtyggnv8lbQhlIZUEDmiegq9I1J42N1PB0y5XBubRtRx1X7FXKQfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=25vftL2u; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5114c05806eso2386594e87.1
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 01:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1707384906; x=1707989706; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8o7bUDuGuu2YaKsxQ+9DhHSbmvO5ysjRunyhwVyAC5o=;
        b=25vftL2u489vuD0qEkL8zYrgDNocyALeu8iRRrS+EBV5H/Wa76XA2SWCZywpvkFrss
         21dGwNjDQAH/O+mhYIyHadweU7te0FolLEhuJuOnDAg8rws4eJGGgelDxHWsnh0qEo8y
         mU8iyuL8Q0R5EBEDPte5a9eO0QBUt8jM0zQLh0hSKecymXyofWTAouvOJmlxz8uGwhb1
         Z6yo3Z+H6aIAX6RQzSEbXfhlQ7CXtgZLTeWTBs99K7smDKBk0l0/4g6NlFmt3RCp2u94
         yYGAWzILL8qRa4OcIxCBIMiDdchAX58Hm/NVU/wPAL2hNjYjznL8UNYsyBP8m7uY/D9t
         Vcdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707384906; x=1707989706;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8o7bUDuGuu2YaKsxQ+9DhHSbmvO5ysjRunyhwVyAC5o=;
        b=vPO16CT0kGuwc34GLMwCP2PFKS1PBwGW4IGoDIvpJ0vIMWaLPkCT7hNMEqywYuYiQe
         ZgAQsHjaq31FRI3t9A7perQaioLmDz4FQw5u1v3xlCpj9VgArKN8R2tSttSHn3gDMoqq
         UaDNrxQvjSMe3rXeh8VRBZZ9k6dsHfxy361yrZtogLp9J249UNWU+CJ7mxzsItILH0dq
         8MTz07hnBCgahueXaXuOmlVHFQvWuFfOixabmCKb0NR896H5pTzzaNWS/PoyEZNuH9dj
         DG8bXCeFTdsRK9kpFzTRG51NYl3QXQoWCd9z//0Tu4LBJPyvUlrIy5UW9XCDjLUcKwQm
         qhRw==
X-Gm-Message-State: AOJu0YzD6to/TdBE2pxL8hUVvC+EuxUpjwbEj7AHVhnHnmZrnIaoctbj
	gi69sI7ZbV863sv+smTRfsyCmErVVaSdPzAjHh5m3Nadaw3KQesT7eIDH637AX8CbUnaFy0dnD+
	umXFMUx7viFUVKF4tAE8vdzEKfKTW/aKYMFLJLg==
X-Google-Smtp-Source: AGHT+IEoQSQjo9erO6Il084RgQafaf4DUGfU2yCLEOnMeOlg/r958bA/YMsX95xq7vDLb2BC2YRvJwvjNWwiPA+eBhc=
X-Received: by 2002:a05:6512:3c88:b0:50d:f81e:6872 with SMTP id
 h8-20020a0565123c8800b0050df81e6872mr8479864lfv.10.1707384905935; Thu, 08 Feb
 2024 01:35:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240115194840.1183077-1-andrew@daynix.com> <20240115172837-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240115172837-mutt-send-email-mst@kernel.org>
From: Yuri Benditovich <yuri.benditovich@daynix.com>
Date: Thu, 8 Feb 2024 11:34:53 +0200
Message-ID: <CAOEp5OfKUs+Q+Nq3YywYR=oihSw8Nr=jYSC6a7CN1MTMzJVtHQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] vhost: Added pad cleanup if vnet_hdr is not present.
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Andrew Melnychenko <andrew@daynix.com>, jasowang@redhat.com, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yan@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Just polite ping

On Tue, Jan 16, 2024 at 12:32=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com=
> wrote:
>
> On Mon, Jan 15, 2024 at 09:48:40PM +0200, Andrew Melnychenko wrote:
> > When the Qemu launched with vhost but without tap vnet_hdr,
> > vhost tries to copy vnet_hdr from socket iter with size 0
> > to the page that may contain some trash.
> > That trash can be interpreted as unpredictable values for
> > vnet_hdr.
> > That leads to dropping some packets and in some cases to
> > stalling vhost routine when the vhost_net tries to process
> > packets and fails in a loop.
> >
> > Qemu options:
> >   -netdev tap,vhost=3Don,vnet_hdr=3Doff,...
> >
> > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
> > ---
> >  drivers/vhost/net.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index f2ed7167c848..57411ac2d08b 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
> > @@ -735,6 +735,9 @@ static int vhost_net_build_xdp(struct vhost_net_vir=
tqueue *nvq,
> >       hdr =3D buf;
> >       gso =3D &hdr->gso;
> >
> > +     if (!sock_hlen)
> > +             memset(buf, 0, pad);
> > +
> >       if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
> >           vhost16_to_cpu(vq, gso->csum_start) +
> >           vhost16_to_cpu(vq, gso->csum_offset) + 2 >
>
>
> Hmm need to analyse it to make sure there are no cases where we leak
> some data to guest here in case where sock_hlen is set ...
> > --
> > 2.43.0
>

