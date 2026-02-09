Return-Path: <kvm+bounces-70582-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uLwZK9aBiWkg+QQAu9opvQ
	(envelope-from <kvm+bounces-70582-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 07:42:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EEC910C301
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 07:42:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4022930066B2
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 06:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1348C318B96;
	Mon,  9 Feb 2026 06:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AcIp51Zd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SL2/9lAP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088502EBBB3
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 06:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770619334; cv=pass; b=GjD/z2QZKMIDeBN72hF5YDODCCIyM0x5c6Ap5CoB5Yk6yeq7ngcfx05aUwWeKg+sii+4B5IMMxfHV/DIqiS7E9m8U2VbjRZacruCOc34+A24R1wSOQgFvkbyCHAKqoSax2G5FeYQsNEljHpFyt9uipPrxA4ZHKUg3yBEByZ16wI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770619334; c=relaxed/simple;
	bh=O8cJ6Kj90NvIyQjjqT95QHWqU8SDK+V3+SP8mwmcVYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lux7NHfQjkaXMHHvuONxzrLBqJEUU+/9h77pzwN0s3adwFkfL7eQetay32Q00rb8R64j2cGkPftTZRx8uDx8K+/RkobEjBeH5RQOAFwXTy5oVOTpoLEBYDRdlpTvhldAtW1GZi25rN8A/VLH0IhWHcQ5bXYh88eD6B2Pky0qPIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AcIp51Zd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SL2/9lAP; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770619333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+rAEkP/ENKOKGthOaBA1iQpwk+zp5uugkrzm6gZ8wcU=;
	b=AcIp51ZdvrrSeSz2lLcTJPB35s38Mze4+WmTjAMRhySO8xZ+l4KGYThx8QzW3nQD/5QlcR
	0lO+Zscqy0VOUAo5xrz7uVji6R8Z4XQr1YaTx1VI6Sc5r6Sq1w3kUzzNq9YMljXZNO4i5u
	swUIRdua0OsCSywz7wqLDbURzq8OgR8=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-aa763GclPf2Iu4kssNZkNg-1; Mon, 09 Feb 2026 01:42:11 -0500
X-MC-Unique: aa763GclPf2Iu4kssNZkNg-1
X-Mimecast-MFC-AGG-ID: aa763GclPf2Iu4kssNZkNg_1770619331
Received: by mail-vs1-f72.google.com with SMTP id ada2fe7eead31-5fa75a19f21so10633849137.1
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 22:42:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770619331; cv=none;
        d=google.com; s=arc-20240605;
        b=dOjowAT/Ll0ZKWSWDTtqgZ2G8fYb8sRP5BKVA70Do861KArxnUFXJ1oCtHWtj9hsQH
         i+TcR+4dVMULWG13sXS3tJLaG+12X4ECDBoVWOmbv4vQq0ByJyW6bUj/oXFvOoPFaIg5
         S5UORj/2+sYe0TL29zhIPLIr9jskiIJBuripyxZl6txFdr/yJJtbMGvV2TffO1aA8wVs
         Zxo4li17c6C5Bzkp1V4wYrcoCxPYr9u3icXXiY42WKHX+lCuNF/7UA91Qi+IANrTs7K7
         sAba5cEcLeskI2byR5piutadAvyW0YpbTaGHwKIvUEJJbG7TiyW8pARHyphKpfocEzQL
         odKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+rAEkP/ENKOKGthOaBA1iQpwk+zp5uugkrzm6gZ8wcU=;
        fh=PaeNc6+BMbmFjapG1tXZ/5tKRZTBOg8jrqAv/CX7iNs=;
        b=SkSPPfQq3NPh183/a0mMatEfOP7rWZGHW1S2R9o9akTJbRbTRAup+LGEZivY7zlbhw
         YqPRPUWJ58OuT4T9pcZwj0xX61lhoF4LU22/QwkFD/3n6xXREpDtQ3fy/5OrydcxPUQm
         gvzcfe31RLeI45qfeW1x2Nxl1x51ZRm97IrdUR9KbBojhLAcnPLE2l9r/3KDWb7TaCRj
         6kVev497SbpOUvPPc9i/gy0tsbasJPRlEylhrBBo495JlpEjuHeOfE7kW5N2NB+zUoi2
         iKW3h92o3sO8en3D430X+VIp4QgyQkl8Iw5bXOjUhf//AetwnAlnEjEGUamiJ9mkeQ+Q
         zdOg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770619331; x=1771224131; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+rAEkP/ENKOKGthOaBA1iQpwk+zp5uugkrzm6gZ8wcU=;
        b=SL2/9lAPYkmcyzw1pHxouL+AgTG+qAmi6/pDxi4Zp1UqjlVHm23AKzp2D/7IXLe26U
         +XKwu5uyuqso08OiAoStwDyIN0IVjwBeJA1quEh97fldnKC427Qoy1dwkHph318NaApd
         BqWbiAkh80AdEAcD6IfGYCRbK2Ka5I9QI2j2wogf2yOfXqPQUAblIyZrXbeL8ZvXWDLa
         faXEuaZfwe8Ry2eO/Dd9u3DalOYnqFrmKwa0/Y58AdwWBaTjo+4yBd2h8EQyW5lZ50zi
         1z9MIIQrThBYytgwOREuMaezsKCRGCouLArJciHEZ/LXb8kVMSA78nSdaXw+d9JzOm88
         celA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770619331; x=1771224131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+rAEkP/ENKOKGthOaBA1iQpwk+zp5uugkrzm6gZ8wcU=;
        b=AWyIuvN/E6PpOSE5GNq0GztiSR6U/b/h1CXUBAG022EKVgfWR/jJmFB2WyhcSB3Pww
         v33hettGbXUEH6nVLTrVNLwhgJgXzogTW2vqE1k3vyVjQsYNc/ZFp+WKUll/zMS8j1gf
         CzTd3aYB6Vs3tB2XwvrEnOGahq9Jj34c5fQ7vgkBWGAj5Kwcj8EOcn/7BR/vmhM7HE/a
         rxeisQO01LgHS6fOpht133USAlzQEdXy+YsjNT5n5eE9D4SQFh/lzPKx2m6T+yV1lcqg
         Qt1uHbOs7DqCD6TBfrnu7abH9go6ZJ9UO217fOUTZjsGRjB4aetrf1LTD/5MVCKiDKMa
         /CSw==
X-Forwarded-Encrypted: i=1; AJvYcCWNVDJgaRQpMrLqYlGmDgsY9IPpC16+j6bJyfxHjYzhf4AcD/edE/uzsZu44YjNjEeoqS8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKmRVLy8CqOfmQcMk3KJd9ouWal9O/kYt3YNGOadIVM8JAczTq
	wrV8knJCiRNiCnr21HOxEhCCXhkptKXGE5wjpiDlWJ2QLERtFAZgW1ZQvNo5wO9hYCIlLs3Ysa2
	dWkkjrg0T4krEQRr5GTkkE2Y30exGSfuYvoX2Yx41AktgubpuLY6HiA7OWYnOOEbjVszApPdnAf
	Bi7HSavJuUhi7mXy/FMGvou8keRnVJ
X-Gm-Gg: AZuq6aKTVbNS4JxS5M8UbhzIIROydX1OGhrNlcqBQjwEyg8yGxNdZcI4pPqTQeVxZET
	jEXGbNkhqFtX6M6f9yBJM45btVrc27/3V2KW8u69N6Z8opx6tIfA/+QJDGFtC+rhG50Yjn9ilfk
	Y6/HZUF/bTYUMCrEIdw8xZV3xf42pJvf5barkbm7IOYy9BoHt0w0jJ+OsP53XIXFMZN70=
X-Received: by 2002:a05:6102:5108:b0:5ef:af68:e6bd with SMTP id ada2fe7eead31-5fae76bedd7mr2971616137.2.1770619331275;
        Sun, 08 Feb 2026 22:42:11 -0800 (PST)
X-Received: by 2002:a05:6102:5108:b0:5ef:af68:e6bd with SMTP id
 ada2fe7eead31-5fae76bedd7mr2971613137.2.1770619330991; Sun, 08 Feb 2026
 22:42:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260208143441.2177372-1-lulu@redhat.com> <20260208143441.2177372-2-lulu@redhat.com>
 <20260208123029-mutt-send-email-mst@kernel.org>
In-Reply-To: <20260208123029-mutt-send-email-mst@kernel.org>
From: Cindy Lu <lulu@redhat.com>
Date: Mon, 9 Feb 2026 14:41:27 +0800
X-Gm-Features: AZwV_Qiz8bHINy5XI2QvLVezbxk6iTbCBvt72uLxPgwE6Zaly7hURPFi-VGLC_8
Message-ID: <CACLfguX6o5Uj4SKsPAsX53wjuNtvCxsCgK5AzfffHpdt1NrZNQ@mail.gmail.com>
Subject: Re: [RFC 1/3] uapi: vhost: add vhost-net netfilter offload API
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: jasowang@redhat.com, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70582-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lulu@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.994];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 8EEC910C301
X-Rspamd-Action: no action

s

On Mon, Feb 9, 2026 at 1:32=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com> =
wrote:
>
> On Sun, Feb 08, 2026 at 10:32:22PM +0800, Cindy Lu wrote:
> > Add VHOST_NET_SET_FILTER ioctl and the filter socket protocol used for
> > vhost-net filter offload.
> >
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
> > ---
> >  include/uapi/linux/vhost.h | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/include/uapi/linux/vhost.h b/include/uapi/linux/vhost.h
> > index c57674a6aa0d..d9a0ca7a3df0 100644
> > --- a/include/uapi/linux/vhost.h
> > +++ b/include/uapi/linux/vhost.h
> > @@ -131,6 +131,26 @@
> >   * device.  This can be used to stop the ring (e.g. for migration). */
> >  #define VHOST_NET_SET_BACKEND _IOW(VHOST_VIRTIO, 0x30, struct vhost_vr=
ing_file)
> >
> > +/* VHOST_NET filter offload (kernel vhost-net dataplane through QEMU n=
etfilter) */
> > +struct vhost_net_filter {
> > +     __s32 fd;
> > +};
> > +
> > +enum {
> > +     VHOST_NET_FILTER_MSG_REQUEST =3D 1,
> > +};
> > +
> > +#define VHOST_NET_FILTER_DIRECTION_TX 1
> > +
> > +struct vhost_net_filter_msg {
> > +     __u16 type;
> > +     __u16 direction;
> > +     __u32 len;
> > +};
> > +
> > +
> > +#define VHOST_NET_SET_FILTER _IOW(VHOST_VIRTIO, 0x31, struct vhost_net=
_filter)
> > +
> >  /* VHOST_SCSI specific defines */
>
> can we get some info on what this is supposed to be doing, pls?
> it belongs here where userspace devs can find it, not hidden
> in code.
>
Hi Michael
We plan to add a new feature to support zero packet loss during live
migration, so we=E2=80=99re introducing this new UAPI. Thanks, I'll add mor=
e
information here.
Thanks
Cindy
>
> >
> >  #define VHOST_SCSI_SET_ENDPOINT _IOW(VHOST_VIRTIO, 0x40, struct vhost_=
scsi_target)
> > --
> > 2.52.0
>


