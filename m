Return-Path: <kvm+bounces-6969-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8BE83B872
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:45:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B081F283C74
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:45:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C7379E2;
	Thu, 25 Jan 2024 03:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WwZaKobw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E2E6FC3
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706154313; cv=none; b=nePmgcfAC63myF7RnISMgfCxWHQD1IDfrgzHiEe/bQRKzkFACkNAqiuI8O4bM3zuEkKP0xdFWPhgcqCkAOXEbYB9cerHwINejyankGZ+J+70042IqjBb/GNHgv5VKzat+qqGloJotvs0i2y3udYOITgwgpR7w/UhX3QrhqgrqIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706154313; c=relaxed/simple;
	bh=vLrTDc4Xoy5bYh/zxDyVoWC8mEokvcqct9ta/iT40Nk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RFqQ0g5TQzDPCRXO6VRzti1sPrbj55W3rFfhKDRY149J7vcwYi7mM0EYnVyyAIKqQGojf6C+WdJAYoycT2amqRWlIiDuhws0pKP3JIfr3r8jk77Bch0hIZBogdox565CtvUKetfgDSPyMaturBU8LmSoFSY7Hz/NsNf2HPRIDQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WwZaKobw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706154310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oTLyEhCAK8CZLpP4xZtHuONSiITSgynu6b1Omr3hZKk=;
	b=WwZaKobw/rJl09pNRx/Op+DG3lgmk/q2pluDS1w9qlkfelSZS97OWrvfqAaVzNF5Tv2rSo
	kIsEl8Or9ULY1QKPjEHTjr25AmtenAx8a18hBTFmoy8F6Yve/BKcczfDPYShDx06vfseVu
	/8IV1GPHNangib5tWuGpEFisGTvU2ok=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-5oF_AczLO0OHJgl9wTVhyw-1; Wed, 24 Jan 2024 22:45:08 -0500
X-MC-Unique: 5oF_AczLO0OHJgl9wTVhyw-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-29034f18db9so6052709a91.1
        for <kvm@vger.kernel.org>; Wed, 24 Jan 2024 19:45:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706154307; x=1706759107;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oTLyEhCAK8CZLpP4xZtHuONSiITSgynu6b1Omr3hZKk=;
        b=CeWuvpy9/g0IbiIdehBLYFlM9JIH/5cBnCtG1G5M6+7RFZgEiKq2VFz3rgqXuIlpf2
         7zlaTSq+uMLcsJd2K5oj5tVjLVHbnvqqlADLj7JfxHTJ8Vllg7b/sdMcJbZEi6ERJzHi
         ZoM6Rd47b0xlXqzXL0K+/eF9RfKujplLZGUCjz4wVdy2oQJI+WQvt/iyr0BUfdh2XK/v
         Yy0TDVMRsuGs9ofStye7d19ha5OTj/j4Yuvdct+HOtNOKxQ72GsWuRpiB/x90BZSp0kN
         P9DVvoDFzuCZcReqLxHG/aWt2uXUv1DhNhh2izeTfK/qbpWY2nbNTwD3dllCOjsxiS8X
         H7dA==
X-Gm-Message-State: AOJu0Yzu3Fst7pQKNGHE7jzmRQ0FqNrl+MGcbBGtWntH36N8RRRjUsyO
	O6xPog3fyeJbHbE9s14YmnRZXkEpaJOlVvFDEajrZog0V8CrSc5uHW3+QB6aG3hFk0jm/5DXScw
	ZAu7xi05pH02WP5jSM92ftHCCEx1JDGIXuZZ4OUWHEudhNUywn+h2jvzvBALckvBmorozx63rws
	Wol7uV4rdiSfLtd7kGm52woUVI
X-Received: by 2002:a17:90a:408d:b0:28e:aaaa:34e9 with SMTP id l13-20020a17090a408d00b0028eaaaa34e9mr182537pjg.51.1706154307065;
        Wed, 24 Jan 2024 19:45:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGbu1lzip0SCxOTcwvrv+rvbb49TS9A60SGDUkl5bo+jQA2c3GzM5bva6U9MdT+5KDma5bqFN0iWxHPq/rqtek=
X-Received: by 2002:a17:90a:408d:b0:28e:aaaa:34e9 with SMTP id
 l13-20020a17090a408d00b0028eaaaa34e9mr182523pjg.51.1706154306654; Wed, 24 Jan
 2024 19:45:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1706089075-16084-1-git-send-email-wangyunjian@huawei.com> <65b15f6ba776f_22a8cb29487@willemb.c.googlers.com.notmuch>
In-Reply-To: <65b15f6ba776f_22a8cb29487@willemb.c.googlers.com.notmuch>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 25 Jan 2024 11:44:55 +0800
Message-ID: <CACGkMEtdi=MKedNh1foupjqJW3EouhUp4iwsj1t3v=nNQ=VvBw@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] tun: AF_XDP Rx zero-copy support
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Yunjian Wang <wangyunjian@huawei.com>, mst@redhat.com, kuba@kernel.org, 
	davem@davemloft.net, magnus.karlsson@intel.com, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, xudingke@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 25, 2024 at 3:05=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> Yunjian Wang wrote:
> > Now the zero-copy feature of AF_XDP socket is supported by some
> > drivers, which can reduce CPU utilization on the xdp program.
> > This patch set allows tun to support AF_XDP Rx zero-copy feature.
> >
> > This patch tries to address this by:
> > - Use peek_len to consume a xsk->desc and get xsk->desc length.
> > - When the tun support AF_XDP Rx zero-copy, the vq's array maybe empty.
> > So add a check for empty vq's array in vhost_net_buf_produce().
> > - add XDP_SETUP_XSK_POOL and ndo_xsk_wakeup callback support
> > - add tun_put_user_desc function to copy the Rx data to VM
> >
> > Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
>
> I don't fully understand the higher level design of this feature yet.
>
> But some initial comments at the code level.
>
> > ---
> >  drivers/net/tun.c   | 165 +++++++++++++++++++++++++++++++++++++++++++-
> >  drivers/vhost/net.c |  18 +++--
> >  2 files changed, 176 insertions(+), 7 deletions(-)
> >

[...]

> >  struct tun_page {
> > @@ -208,6 +21
> >
> > diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > index f2ed7167c848..a1f143ad2341 100644
> > --- a/drivers/vhost/net.c
> > +++ b/drivers/vhost/net.c
>
> For virtio maintainer: is it okay to have tun and vhost/net changes in
> the same patch, or is it better to split them?

It's better to split, but as you comment below, if it must be done in
one patch we need to explain why.

>
> > @@ -169,9 +169,10 @@ static int vhost_net_buf_is_empty(struct vhost_net=
_buf *rxq)
> >
> >  static void *vhost_net_buf_consume(struct vhost_net_buf *rxq)
> >  {
> > -     void *ret =3D vhost_net_buf_get_ptr(rxq);
> > -     ++rxq->head;
> > -     return ret;
> > +     if (rxq->tail =3D=3D rxq->head)
> > +             return NULL;
> > +
> > +     return rxq->queue[rxq->head++];
>
> Why this change?

Thanks


