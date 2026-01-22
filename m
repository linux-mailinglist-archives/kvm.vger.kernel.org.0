Return-Path: <kvm+bounces-68853-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kGbXLF+3cWmcLgAAu9opvQ
	(envelope-from <kvm+bounces-68853-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:36:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 345376202C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 06:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F12E24E963C
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 05:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3BE477E54;
	Thu, 22 Jan 2026 05:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fIqyA4T4";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MI5R5ep+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC450270EC1
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 05:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769060177; cv=pass; b=K4SbJ965FBFxyc/s+5m9dhMZ8xV86BnP8kfAnAB2LHz+yU4MssW1rC6wbaurwrqgsHccUcFgD1KVRAcYlFBnt4W/TzUsHfdkZqxkNx1qS8Dw4gtYZtuh4OLjbHfUIuDwllWEVW/jXO0FZzN5ONxqzBy9nCqXD7VzfsnTKd+0NoI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769060177; c=relaxed/simple;
	bh=4u7RqhYyUxDdVXDwJ31YEx+CsrnO+8ttQ47Alq+R+iI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S6UEpKU6Or/f+H5W5MLXUjYMVTYj3b9sp1LkL0Bq+knBWn+ZBZD+0lXj1aFPMn35riHbfQI9os1rITFHRVc7gVxDeJajarRtwwcffFv4Cwk+I1XbedzZUk3KlPDefYuGklPU6C8uqp+x2ZATINJNin2blFADRBfNbV6wSRnoA6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fIqyA4T4; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MI5R5ep+; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769060174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ED7l/hs/bCd8Y3NS4tIwlZAqaShpZQlaHK2896w0TZ8=;
	b=fIqyA4T4CTpewq4nU32SX+w7S4XSNv4rpGk2vHByY0H3NTCqb743/ZUmCfaCDEAeo7wfkW
	iCK+DOoBuEbBJ7HSdDlM+rZhBPKIIUjRVuwG6irnXFVoMrU4xGVhge6XO2IiYazGGHOlhs
	qzazjW8MfD8qrrobMwH5HpMi1HY5ufU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-bV5Zef2UNbyvD97QQW5oJg-1; Thu, 22 Jan 2026 00:36:13 -0500
X-MC-Unique: bV5Zef2UNbyvD97QQW5oJg-1
X-Mimecast-MFC-AGG-ID: bV5Zef2UNbyvD97QQW5oJg_1769060172
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34ab459c051so1372339a91.0
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 21:36:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769060170; cv=none;
        d=google.com; s=arc-20240605;
        b=kGrP/lMIJxhwmisT9UN8YRhLcdGx+8FGaOyuwYbsqVOH/XimQzYxKvwdNcLAVYz9tW
         mmNYKYRPQt0Cjel9gnUmnQa3MlIphEijUam9bAl+JJoubUrOGzfwKacO7+N+xnZt+8z4
         J6JI60CSxOwPaDETpEzKRuI66lP/HHuEXDRalzUbzANdWggmqpul3jpZkkmLCmT26gg5
         OXy1RNJL7GZkIvviF4ZYDW5HHAa6GutazYWAk0/h39u5Fq7CXhKp0r8qEmDPshrf/Jx7
         JOVLkZWSDJoz22CyYGMiNxG5t6L54VIXJdIiR2u6K2QehfVXBRRDVSXL1TW3YqXYl4Dt
         VNlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ED7l/hs/bCd8Y3NS4tIwlZAqaShpZQlaHK2896w0TZ8=;
        fh=2D2oD/cKazDZeXpLc2jXGMYpMOsEuE6loqXvLzTBj5o=;
        b=dk6zk/x746Y8m4q4z0lluLJSdfSIvAej7J8V7jm/lUJdjUns5WYjmBXmAEFw74px03
         cmy2v4vfb7BJnbzwbaOizc/G1z+EpJ38/sE6qm3SAgxqvPs/RGlrA5e3aGYBzooQptc0
         +cLPgCeGTDVdcDNUZC8vKWUE30CWzynSccRiSAYjEmW1Od29q5+cMe6IYoVs3UAJ58VF
         nOGFXrMGFo5zXuRDh6LFlknySyPCGmSb8oJOUJJjgnDCuAPJgSyCbvwNXAnXiXuadkA8
         eXmDlNF6ZqABDhSo/kMqNrM9m9+ibTD4/FSu7QvpI1k5my0p42dF9Z66ftBMpuTd5kl/
         nt9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769060170; x=1769664970; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ED7l/hs/bCd8Y3NS4tIwlZAqaShpZQlaHK2896w0TZ8=;
        b=MI5R5ep+9Ete/kj9kq7iHgcTfeX2mpFQZkZrQj0HQ/JtYPBfUMPv52YXtjP6UkToio
         WUzAC+SGrHSZJ8ygRFcutPIweTTPmyWVOn5aIWkahiWQGrY8ujgukDNBuyqkQFtaERpV
         gk5uMIWVKQ9fmcDvlk8Rqilmr70f0lKBA6XvaXCcya/UMGe7Adc0fMRwJLe3eTaPDOFR
         VrHcl0eB8TLYL2zUnrgs7+Q3+jj1lzHh0plL8HqnvpUMH3+OACnm2R5UMLVJMdbg24rw
         asPSVQPl6hRUuPuR/i6fOgggyHbLAIWGyPRVAnuc/T/b8/UvuYj+UJkP8lfJjoIDEBFL
         uBcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769060170; x=1769664970;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ED7l/hs/bCd8Y3NS4tIwlZAqaShpZQlaHK2896w0TZ8=;
        b=XdFHF+213lnHqtxuDkKjtdoyi33/GGDTijOKvbn2pTS8+s7FRKn7gxBi2AwtKkUiJw
         NPhN/09rntVI6C/e95nWuA8gEYzODVK11kj3iaMRB4rJ2pKoZM4QtjwsHuKdLEzV9I1A
         8njoJ44pAlQYTU6f8b5uoUKRIs4xAwaJvXqXVwlxaN1dbPh5NUbxxxp4BbtBMfiXEq+a
         ClolWqfQ0i5x57by/uTcSacr3F8e4qObmFmP37+NnAvdUfbE1x12aB6vwBLaUEkGKtud
         PS/USh6Ai3cTDY0pWC/7Ad0U0cSQ7vAdBX8CnHKDul+JH+n2NHRfHaDHky4TzMBaThmd
         Q8Iw==
X-Forwarded-Encrypted: i=1; AJvYcCUIhcezZAxuZd98LX0wnhbdRi3/r2LNibE3V4pEkYoMQSYDFzmGO407FSSB06sQzjiSRms=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywtqim/NPkNI2B2MWTL/GPxLT4XVk8f7ma+IT1Ecv4hvQqZXhc3
	bHb4X8dr9nYumUMuBej/Rqi72YdGPs+o9QiICMJEO/OSrpoG8qnHsAHT8sKAYCorQgYjHq9VpLp
	AY3vyrzXmr+gmtzTysHE9pYLPZK1/SghtI5CinRcTPjegnkL0PIc95+zImIEYSUcp/Q3XwhhKrp
	Psz/XJLzgio7GcjQ4McRyb6cVfrZbn
X-Gm-Gg: AZuq6aJCm6OK0WCt2K6O4NgkmQeUik/w0jD16Oxr6LOwTHYM4k1qsgBhYd09ZNhSC8T
	aJ5L/p8ym8Yoccju2vMyJbdrByFr6wD2RDeojNYrHFVvqZUDU1Yf/vb85qfMwktkApVN0AeuMzv
	ZExlW8uz9c7+U8U9ZHJxxI0wv47HLTZj/lK+uPDzC1/LHKS7HIRKTcbXYr80iat9i7Tek=
X-Received: by 2002:a17:90b:51:b0:353:41e:1f51 with SMTP id 98e67ed59e1d1-353041e787cmr3670058a91.32.1769060170505;
        Wed, 21 Jan 2026 21:36:10 -0800 (PST)
X-Received: by 2002:a17:90b:51:b0:353:41e:1f51 with SMTP id
 98e67ed59e1d1-353041e787cmr3670034a91.32.1769060170061; Wed, 21 Jan 2026
 21:36:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-4-simon.schippers@tu-dortmund.de> <CACGkMEuSiEcyaeFeZd0=RgNpviJgNvUDq_ctjeMLT5jZTgRkwQ@mail.gmail.com>
 <1e30464c-99ae-441e-bb46-6d0485d494dc@tu-dortmund.de> <CACGkMEtzD3ORJuJcc8VeqwASiGeVFdQmJowsK6PYVEF_Zkcn8Q@mail.gmail.com>
 <afa40345-acbe-42b0-81d1-0a838343792d@tu-dortmund.de>
In-Reply-To: <afa40345-acbe-42b0-81d1-0a838343792d@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 22 Jan 2026 13:35:57 +0800
X-Gm-Features: AZwV_Qj0WIKFoTOn0eU2tLMfUdJil-HIikNxIFlK3wwyEXYRVe6obOMN0rB6aW0
Message-ID: <CACGkMEtxRoavBMTXom8Z=FM-pvu3pHbsuwCs+e450b1B=V7iWA@mail.gmail.com>
Subject: Re: [PATCH net-next v7 3/9] tun/tap: add ptr_ring consume helper with
 netdev queue wakeup
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch, 
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, 
	mst@redhat.com, eperezma@redhat.com, leiyang@redhat.com, 
	stephen@networkplumber.org, jon@nutanix.com, tim.gebauer@tu-dortmund.de, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FREEMAIL_CC(0.00)[gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,redhat.com,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-68853-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[redhat.com,quarantine];
	DKIM_TRACE(0.00)[redhat.com:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jasowang@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm,netdev];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 345376202C
X-Rspamd-Action: no action

On Wed, Jan 21, 2026 at 5:33=E2=80=AFPM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> On 1/9/26 07:02, Jason Wang wrote:
> > On Thu, Jan 8, 2026 at 3:41=E2=80=AFPM Simon Schippers
> > <simon.schippers@tu-dortmund.de> wrote:
> >>
> >> On 1/8/26 04:38, Jason Wang wrote:
> >>> On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> >>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>
> >>>> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_ring_cons=
ume()
> >>>> and wake the corresponding netdev subqueue when consuming an entry f=
rees
> >>>> space in the underlying ptr_ring.
> >>>>
> >>>> Stopping of the netdev queue when the ptr_ring is full will be intro=
duced
> >>>> in an upcoming commit.
> >>>>
> >>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >>>> ---
> >>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
> >>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
> >>>>  2 files changed, 45 insertions(+), 3 deletions(-)
> >>>>
> >>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> >>>> index 1197f245e873..2442cf7ac385 100644
> >>>> --- a/drivers/net/tap.c
> >>>> +++ b/drivers/net/tap.c
> >>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_queue *q=
,
> >>>>         return ret ? ret : total;
> >>>>  }
> >>>>
> >>>> +static void *tap_ring_consume(struct tap_queue *q)
> >>>> +{
> >>>> +       struct ptr_ring *ring =3D &q->ring;
> >>>> +       struct net_device *dev;
> >>>> +       void *ptr;
> >>>> +
> >>>> +       spin_lock(&ring->consumer_lock);
> >>>> +
> >>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1=
))) {
> >>>> +               rcu_read_lock();
> >>>> +               dev =3D rcu_dereference(q->tap)->dev;
> >>>> +               netif_wake_subqueue(dev, q->queue_index);
> >>>> +               rcu_read_unlock();
> >>>> +       }
> >>>> +
> >>>> +       spin_unlock(&ring->consumer_lock);
> >>>> +
> >>>> +       return ptr;
> >>>> +}
> >>>> +
> >>>>  static ssize_t tap_do_read(struct tap_queue *q,
> >>>>                            struct iov_iter *to,
> >>>>                            int noblock, struct sk_buff *skb)
> >>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queue *q,
> >>>>                                         TASK_INTERRUPTIBLE);
> >>>>
> >>>>                 /* Read frames from the queue */
> >>>> -               skb =3D ptr_ring_consume(&q->ring);
> >>>> +               skb =3D tap_ring_consume(q);
> >>>>                 if (skb)
> >>>>                         break;
> >>>>                 if (noblock) {
> >>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>> index 8192740357a0..7148f9a844a4 100644
> >>>> --- a/drivers/net/tun.c
> >>>> +++ b/drivers/net/tun.c
> >>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun_struc=
t *tun,
> >>>>         return total;
> >>>>  }
> >>>>
> >>>> +static void *tun_ring_consume(struct tun_file *tfile)
> >>>> +{
> >>>> +       struct ptr_ring *ring =3D &tfile->tx_ring;
> >>>> +       struct net_device *dev;
> >>>> +       void *ptr;
> >>>> +
> >>>> +       spin_lock(&ring->consumer_lock);
> >>>> +
> >>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring, 1=
))) {
> >>>
> >>> I guess it's the "bug" I mentioned in the previous patch that leads t=
o
> >>> the check of __ptr_ring_consume_created_space() here. If it's true,
> >>> another call to tweak the current API.
> >>>
> >>>> +               rcu_read_lock();
> >>>> +               dev =3D rcu_dereference(tfile->tun)->dev;
> >>>> +               netif_wake_subqueue(dev, tfile->queue_index);
> >>>
> >>> This would cause the producer TX_SOFTIRQ to run on the same cpu which
> >>> I'm not sure is what we want.
> >>
> >> What else would you suggest calling to wake the queue?
> >
> > I don't have a good method in my mind, just want to point out its impli=
cations.
>
> I have to admit I'm a bit stuck at this point, particularly with this
> aspect.
>
> What is the correct way to pass the producer CPU ID to the consumer?
> Would it make sense to store smp_processor_id() in the tfile inside
> tun_net_xmit(), or should it instead be stored in the skb (similar to the
> XDP bit)? In the latter case, my concern is that this information may
> already be significantly outdated by the time it is used.
>
> Based on that, my idea would be for the consumer to wake the producer by
> invoking a new function (e.g., tun_wake_queue()) on the producer CPU via
> smp_call_function_single().
> Is this a reasonable approach?

I'm not sure but it would introduce costs like IPI.

>
> More generally, would triggering TX_SOFTIRQ on the consumer CPU be
> considered a deal-breaker for the patch set?

It depends on whether or not it has effects on the performance.
Especially when vhost is pinned.

Thanks

>
> Thanks!
>
> >
> >>
> >>>
> >>>> +               rcu_read_unlock();
> >>>> +       }
> >>>
> >>> Btw, this function duplicates a lot of logic of tap_ring_consume() we
> >>> should consider to merge the logic.
> >>
> >> Yes, it is largely the same approach, but it would require accessing t=
he
> >> net_device each time.
> >
> > The problem is that, at least for TUN, the socket is loosely coupled
> > with the netdev. It means the netdev can go away while the socket
> > might still exist. That's why vhost only talks to the socket, not the
> > netdev. If we really want to go this way, here, we should at least
> > check the existence of tun->dev first.
> >
> >>
> >>>
> >>>> +
> >>>> +       spin_unlock(&ring->consumer_lock);
> >>>> +
> >>>> +       return ptr;
> >>>> +}
> >>>> +
> >>>>  static void *tun_ring_recv(struct tun_file *tfile, int noblock, int=
 *err)
> >>>>  {
> >>>>         DECLARE_WAITQUEUE(wait, current);
> >>>>         void *ptr =3D NULL;
> >>>>         int error =3D 0;
> >>>>
> >>>> -       ptr =3D ptr_ring_consume(&tfile->tx_ring);
> >>>> +       ptr =3D tun_ring_consume(tfile);
> >>>
> >>> I'm not sure having a separate patch like this may help. For example,
> >>> it will introduce performance regression.
> >>
> >> I ran benchmarks for the whole patch set with noqueue (where the queue=
 is
> >> not stopped to preserve the old behavior), as described in the cover
> >> letter, and observed no performance regression. This leads me to concl=
ude
> >> that there is no performance impact because of this patch when the que=
ue
> >> is not stopped.
> >
> > Have you run a benchmark per patch? Or it might just be because the
> > regression is not obvious. But at least this patch would introduce
> > more atomic operations or it might just because the TUN doesn't
> > support burst so pktgen can't have the best PPS.
> >
> > Thanks
> >
> >
> >>
> >>>
> >>>>         if (ptr)
> >>>>                 goto out;
> >>>>         if (noblock) {
> >>>> @@ -2131,7 +2152,7 @@ static void *tun_ring_recv(struct tun_file *tf=
ile, int noblock, int *err)
> >>>>
> >>>>         while (1) {
> >>>>                 set_current_state(TASK_INTERRUPTIBLE);
> >>>> -               ptr =3D ptr_ring_consume(&tfile->tx_ring);
> >>>> +               ptr =3D tun_ring_consume(tfile);
> >>>>                 if (ptr)
> >>>>                         break;
> >>>>                 if (signal_pending(current)) {
> >>>> --
> >>>> 2.43.0
> >>>>
> >>>
> >>> Thanks
> >>>
> >>
> >
>


