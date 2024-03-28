Return-Path: <kvm+bounces-12982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C0D988F9C6
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 09:12:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1641729995F
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 08:12:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DEEE42A88;
	Thu, 28 Mar 2024 08:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Sz3KYgQ7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9292441C62
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 08:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711613548; cv=none; b=iuIUGwA+y9Exd/1YnG/gRY5uattMRDB2kCBQnm+LFm1o3MopOGbrLJ4b1QMLJ7ff74jg/ng2vjAccqZqLfhnpzS2g5zMLI2IW/J08ZDRN6oE7QslfctvuOgH48mIUNLcbhkTDa2xm0DVJKByc9QsE5YwabZQK/tT2mTZYvBFnUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711613548; c=relaxed/simple;
	bh=gb6MKVyB1Z8XbC5BzK8Z2vs4Yz7PgGAmQ7D3YG5+8D4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G+BfOHscyuZ2igH05lxX3lzAcujyKp9h5soV+DHW9hRJ/a75037zWm/ByLXFgAwjO1UdRCPIaaAy6JNFc6v5b3sU2Nn0X6yytVpw+VfNIrUGuac92JrNlhbT4SOvPn42MfpEDkUZq/A84WxaZ3KdMcdit9s9pV8An2bwLWvXjE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Sz3KYgQ7; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-56c2b4850d2so754436a12.2
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 01:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1711613545; x=1712218345; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j7rvoFRBKxf0yE7YY8RQnWrAo8fviROdMGC4hs1RKLE=;
        b=Sz3KYgQ7g2JZNBQ1+wrfP7/MNRWdJ1TLoLN0kDTWwxQJns/xx7qtHS8+RHVteDUra1
         91PA8T1WqO8BM/9GPZlLWzwfwmKkqHAdhjUoDjvxes+GqDGjRuHpHXmbPp14286YGU8z
         xC1KHBeE2ww9fOnIpkNxzvuJ+8FvbOcIQawEJQzB3Kec7DoF1vzDpHMbusiLFhsNGGuy
         kmxeVBZ1Um/oZCoQDGxo+7m2pjFqCJHpeCOSz7YhpvR9BoukfdE/jYPdHP7L4IlBiBFR
         9hi8JY19fw9CzJmBUqI9UtcXg/tZcBnooD3FuKRbe8clRRwXYo74fguza3ngLXD9tJfQ
         faog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711613545; x=1712218345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j7rvoFRBKxf0yE7YY8RQnWrAo8fviROdMGC4hs1RKLE=;
        b=CH1fqCriQ9Jlpjih5Aj4O9pFyVCKLpM+y7A3cxmKBQMwPNaQeYZTulr561TrsHhPJh
         Up4ziCz4sejX/U77n/oYUYeOYogdqi9hxjI5X/ZucjmIV+C/H0vKdvdlZMwGTBgEf/N+
         Usjejig1SAo7FkFcgIw3ffWuulD9ROhLE9ev/OIX7VL1rGX6K0hcnWf5GkKelZeno6w0
         1Bb8UB7p+6Aov8ja1mwm6jDBSA8IYcNyBjomR0pJd6ydqG/2BnPLbgtRbTiTLqlwtAvG
         VQQM9kQjXyl7kn2MtaB9KnoIYqJS/HzIK17GoHSUlFZQPCNAjnzZnNV8/pPxAlJqkN6Z
         D7ZA==
X-Forwarded-Encrypted: i=1; AJvYcCVPUFSAAl4/nFQnCDCG/FpUU6JdYWoln/b4XMoXKy+LbgRxoxUutERaUEAizrXnmmW0Z/7oAJdgUrTPuDotXzOE9fYF
X-Gm-Message-State: AOJu0Yw0Mu1RcY+rCUQ3MP2CKQEUsUD0KlTtanKIirA34uNi0W318fUM
	vBTrrtoMBSzN1rxstJGmOH7xfcWnOHomZYZZeVad0iUEdXRp7f3LkP8lFn5Q8Y5dPJ3xXaIMdak
	/1ioWCkih30PaymwbOD2W7tOK4nhf5BqSKYX4DA==
X-Google-Smtp-Source: AGHT+IFhAfd17DEM8g97DoHFH/S7dRUsoNxHZs84UzKZHQqH0hGnUpb1JsLJhLdhVjny84cLIFvqAV6Qd+lOthHSzAA=
X-Received: by 2002:a50:c318:0:b0:56c:d64:26b2 with SMTP id
 a24-20020a50c318000000b0056c0d6426b2mr1397511edb.9.1711613544772; Thu, 28 Mar
 2024 01:12:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240327231826.1725488-1-andrew@daynix.com> <CACGkMEuW8jLvje0_oqCT=-ih9JEgxOrWRsvjvfwQXw=OWT_RtQ@mail.gmail.com>
In-Reply-To: <CACGkMEuW8jLvje0_oqCT=-ih9JEgxOrWRsvjvfwQXw=OWT_RtQ@mail.gmail.com>
From: Andrew Melnichenko <andrew@daynix.com>
Date: Thu, 28 Mar 2024 09:46:36 +0200
Message-ID: <CABcq3pFRookhQ8a8Sf9ri2ONOhHME9mXBMUZEOG1eGkJvAxQNw@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] vhost: Added pad cleanup if vnet_hdr is not present.
To: Jason Wang <jasowang@redhat.com>
Cc: mst@redhat.com, ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net, 
	kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com, 
	kvm@vger.kernel.org, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	yuri.benditovich@daynix.com, yan@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks, I'll look into it.

On Thu, Mar 28, 2024 at 6:03=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Thu, Mar 28, 2024 at 7:44=E2=80=AFAM Andrew Melnychenko <andrew@daynix=
.com> wrote:
> >
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
> > From security point of view, wrong values on field used later
> > tap's tap_get_user_xdp() and will affect skb gso and options.
> > Later the header(and data in headroom) should not be used by the stack.
> > Using custom socket as a backend to vhost_net can reveal some data
> > in the vnet_hdr, although it would require kernel access to implement.
> >
> > The issue happens because the value of sock_len in virtqueue is 0.
> > That value is set at vhost_net_set_features() with
> > VHOST_NET_F_VIRTIO_NET_HDR, also it's set to zero at device open()
> > and reset() routine.
> > So, currently, to trigger the issue, we need to set up qemu with
> > vhost=3Don,vnet_hdr=3Doff, or do not configure vhost in the custom prog=
ram.
> >
> > Signed-off-by: Andrew Melnychenko <andrew@daynix.com>
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> It seems it has been merged by Michael.
>
> Thanks
>
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
> >         hdr =3D buf;
> >         gso =3D &hdr->gso;
> >
> > +       if (!sock_hlen)
> > +               memset(buf, 0, pad);
> > +
> >         if ((gso->flags & VIRTIO_NET_HDR_F_NEEDS_CSUM) &&
> >             vhost16_to_cpu(vq, gso->csum_start) +
> >             vhost16_to_cpu(vq, gso->csum_offset) + 2 >
> > --
> > 2.43.0
> >
>

