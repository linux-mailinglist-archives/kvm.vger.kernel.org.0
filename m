Return-Path: <kvm+bounces-68947-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KJG+AJHlcmlzrAAAu9opvQ
	(envelope-from <kvm+bounces-68947-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 04:05:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 236846FE69
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 04:05:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 468E2300602D
	for <lists+kvm@lfdr.de>; Fri, 23 Jan 2026 03:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5588837E2EF;
	Fri, 23 Jan 2026 03:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PpNA8Ero";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="SESdrP1P"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48152D0C92
	for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 03:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769137532; cv=pass; b=ZgDGoDYu7f7/kkgMb/y8eU8TARBP0YdIlHGM22Inx0XXkzx+v+xwmkQS10eBxh2cy63cov4QJuAsdo9dG+G4Ss08D3AvfqUUcuBmDZs1iH4+TtHElT0h2vejoWCz9yjiO0NFbZFl0Km+edOTcojBmK6yGEdDTcEDhclcIDYissU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769137532; c=relaxed/simple;
	bh=aHgjChBg5ZuuLmXn1MuuJOyiw447ndFIGhoil8tVmQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EHTko0m+HHbHPy0B11VwyCt+efMifFPvVXC3uUoC9c61J0QcqxFwYhirwioDXl1UZN9xDPibj1XhwAJQa3PRIzXQLPs2HW2R2YBmnKBMZBu/QUZ1ZEtMOCDCx+DbbCJNIOzVVdQexqgLDiS/naBPtsLSViBfoo0NQX2EsHKWhAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PpNA8Ero; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=SESdrP1P; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769137516;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jlpwSkdal7tGYPivZ2DxNYklI4++k5PPeAgE7brzBDw=;
	b=PpNA8EroxEQF89y2EaVijPJTQT/QuiiaXlpQYqhRukQHdWacR4G2An1enNloL6elzeZmB0
	qwYEQS/GzpnqukfjNPMOvSvBz9q3879vefkFCe0KORb+chgVL0mPwipkyHDutkhiWIkQNb
	lvmTF4+czLFhWkecfBA1dqf0IcKVvko=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-ppJU65qZPjaPv95mde2m9w-1; Thu, 22 Jan 2026 22:05:14 -0500
X-MC-Unique: ppJU65qZPjaPv95mde2m9w-1
X-Mimecast-MFC-AGG-ID: ppJU65qZPjaPv95mde2m9w_1769137513
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2a07fa318fdso14073075ad.0
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 19:05:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769137513; cv=none;
        d=google.com; s=arc-20240605;
        b=a4c+OT6hnFwt6p69JxkakxgaG7O+LEj+UNumVwYBnHAnocz9khEUDK7khmCu29adm0
         aYPpcAJzjQtadSTitpJTuZAdfo01Gagt/ffsr5KEtQK5oxncX1zH5zIOsFZsl2zx9ok8
         kvU+niMzZqX3c7O4gnjCCVWpH8JqnkFfyDZJFTgP039AkK987P0uMFBdQbc+YQgYyMky
         R/IY828uhLocvpBJp8uvu5PAJQvEO/km5iYBnjHKm2QEd2NnlLG0YhryrHi3liRyuigJ
         /0/o6YwacOPFUZxU/MLYHDujzkNjWB27ZfAPfmfY4o47YRqkw8ypD99hmRiV7uOI/KYt
         sw5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jlpwSkdal7tGYPivZ2DxNYklI4++k5PPeAgE7brzBDw=;
        fh=mm89btZrckWYmOpfXvi6mV5faaqYIW//2nAiD89cDJE=;
        b=WaHe0rKt0PVx/O9tKnI4EprkOcEoefJ1ebtfIXQ+1QORM0fR0U9RgLWEoBs1yY/0x8
         Xz8zZoUCu5TVm6r0pY86IHAjC+ez03oHtcsjI2i+xwjSAexU6Y6EU4v1GyOiLdb6azjp
         JkYrsCAOYL2cm6YPa4shzS2wBvjytyrIWFj1qwBa5xEzvOEslgHMO74Qnt66/cOsjLkg
         PZwjWGPc7OHWGnxaF6CAduKHgSkkstTr35Jk1n2JWBk7gyWRUrvFMH+KYPhfLdnr9G4t
         JcLdmwcMVS1D5S3piwuykW3mFarIL4ilxB38ORNYsWJvPeT5ypp59J0i/7kIOrjl4w6l
         dIrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769137513; x=1769742313; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jlpwSkdal7tGYPivZ2DxNYklI4++k5PPeAgE7brzBDw=;
        b=SESdrP1PrdU8OnLntpzShjknAxBmHMp+xk9wfTUVYpVr2L1sjazvwmXM3RdGvOeqV1
         UvgHpDMcrDnP/cqQry+G8Mdr50juggRsB4GC5jlpI355tSGhPNFLm/nPG2vsx8SyKJiK
         0guMyp/Flhdn6EB7QKNOJiU+WRGFjZ1LwZgYPgQDKB5oVGYfc+BiqN89VboS6j3w2BYs
         B1PhlwELxVRbh+QIqtJ9GkkY62MeVNbttLYOEU9jTdX+kwApIvzCGm5f9OBPO1noCWBX
         O4ZukmHDParuIa6nh21u3JN5+ipwnhJE9CQwWVMYN3iNfsKca0eJsXa8NHRrXmHpWHDc
         EV/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769137513; x=1769742313;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jlpwSkdal7tGYPivZ2DxNYklI4++k5PPeAgE7brzBDw=;
        b=FjLCRm0K4erfOz/Qsfv8tR3xGR5tm2tIB4Wm99n1kBeIE+e/vG5QsJX8rdx++Al0mS
         3sJ6eCkk2E0QBXTG71U4XiUhY2//8zCQ4Kt6wKUUz2YEi2gDl0b32TTRzhhBu02Ln9Vn
         KY75ajpuez3wyY1HcScpwx18dqu24rHnIMOdHKNX59qBAcO5CeQ+oYFWVJtACzWcJ4c9
         nBE8pbkn0XxoBwzCBJc3O+/5ySJlsBlCnYeVb5bztwFJijh87r9YUr+Q6kucDWVcQEgl
         rw9jhNy9/IDPSfh8OogTztu7aRSmjABo6C/3qA4KaaKYKsqIg24qNj6qCAr8vo3/eIjg
         OilQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeVB/aLmhQAkH3WT3g1ZYCAI7/ijSt+GRdzmum7VtFMx/psZqjagn+1jTaW+kowUyR3aY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyoNd7mqEsi8w3/+q5eFjLDQ6L5osrGnFK2q/6/VvN6H+0Hao7u
	ZMeVrr8ROE0QtMmM1tnBfjL8Qho4lqIZ8FTIvWLoCbdiQvGpBCiChhFNXKzat4Wqo/6xnTskJkG
	ZeszdjtfZ/uG6y5xf1uE0bCF6rsQCNPt7jfpyWRTVZe55J568ddLGpnchNcDW0UBpMnBf5Vc/1+
	AXkwqCz5NYEvy/WLazcUjEBYZ+mcLtJ41XBeWU
X-Gm-Gg: AZuq6aJz37D6ZObZYnl8imydzu2vfhdU1nuEQrYaZy4RPzpPPEz6tt/hBZLarN2wKp6
	13I1tZADyL0HR9WNbLqa760dcAc4RWvlNLvLsRxM9TbDWKMYpZKBWMGsNgRPxuw/2TApxXkvzyv
	tleUm9BYBO0gZ1xlXn75IiyIBj6BjtkXWm5XWHm3S7Yhcx4OJw8UkcwkKgFZcdA+/8GQA=
X-Received: by 2002:a17:902:f745:b0:2a7:afca:fd1d with SMTP id d9443c01a7336-2a7fe57ddc8mr14979965ad.14.1769137512991;
        Thu, 22 Jan 2026 19:05:12 -0800 (PST)
X-Received: by 2002:a17:902:f745:b0:2a7:afca:fd1d with SMTP id
 d9443c01a7336-2a7fe57ddc8mr14979705ad.14.1769137512538; Thu, 22 Jan 2026
 19:05:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-4-simon.schippers@tu-dortmund.de> <CACGkMEuSiEcyaeFeZd0=RgNpviJgNvUDq_ctjeMLT5jZTgRkwQ@mail.gmail.com>
 <1e30464c-99ae-441e-bb46-6d0485d494dc@tu-dortmund.de> <CACGkMEtzD3ORJuJcc8VeqwASiGeVFdQmJowsK6PYVEF_Zkcn8Q@mail.gmail.com>
 <afa40345-acbe-42b0-81d1-0a838343792d@tu-dortmund.de> <CACGkMEtxRoavBMTXom8Z=FM-pvu3pHbsuwCs+e450b1B=V7iWA@mail.gmail.com>
In-Reply-To: <CACGkMEtxRoavBMTXom8Z=FM-pvu3pHbsuwCs+e450b1B=V7iWA@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 23 Jan 2026 11:05:01 +0800
X-Gm-Features: AZwV_QhfJpNa-qyRW4HkPU0pltcsmh5NSX3tjMBQH3mbBHwnwdX2N3ZeHrsOtZM
Message-ID: <CACGkMEsJKeEsH=G8H5RzMNHY4g3HNdciMDMhciShawh-9Xb9hg@mail.gmail.com>
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
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68947-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,redhat.com,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jasowang@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	NEURAL_HAM(-0.00)[-0.987];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm,netdev];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tu-dortmund.de:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 236846FE69
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 1:35=E2=80=AFPM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Wed, Jan 21, 2026 at 5:33=E2=80=AFPM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
> >
> > On 1/9/26 07:02, Jason Wang wrote:
> > > On Thu, Jan 8, 2026 at 3:41=E2=80=AFPM Simon Schippers
> > > <simon.schippers@tu-dortmund.de> wrote:
> > >>
> > >> On 1/8/26 04:38, Jason Wang wrote:
> > >>> On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> > >>> <simon.schippers@tu-dortmund.de> wrote:
> > >>>>
> > >>>> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_ring_co=
nsume()
> > >>>> and wake the corresponding netdev subqueue when consuming an entry=
 frees
> > >>>> space in the underlying ptr_ring.
> > >>>>
> > >>>> Stopping of the netdev queue when the ptr_ring is full will be int=
roduced
> > >>>> in an upcoming commit.
> > >>>>
> > >>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > >>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > >>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> > >>>> ---
> > >>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
> > >>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
> > >>>>  2 files changed, 45 insertions(+), 3 deletions(-)
> > >>>>
> > >>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> > >>>> index 1197f245e873..2442cf7ac385 100644
> > >>>> --- a/drivers/net/tap.c
> > >>>> +++ b/drivers/net/tap.c
> > >>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_queue =
*q,
> > >>>>         return ret ? ret : total;
> > >>>>  }
> > >>>>
> > >>>> +static void *tap_ring_consume(struct tap_queue *q)
> > >>>> +{
> > >>>> +       struct ptr_ring *ring =3D &q->ring;
> > >>>> +       struct net_device *dev;
> > >>>> +       void *ptr;
> > >>>> +
> > >>>> +       spin_lock(&ring->consumer_lock);
> > >>>> +
> > >>>> +       ptr =3D __ptr_ring_consume(ring);
> > >>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring,=
 1))) {
> > >>>> +               rcu_read_lock();
> > >>>> +               dev =3D rcu_dereference(q->tap)->dev;
> > >>>> +               netif_wake_subqueue(dev, q->queue_index);
> > >>>> +               rcu_read_unlock();
> > >>>> +       }
> > >>>> +
> > >>>> +       spin_unlock(&ring->consumer_lock);
> > >>>> +
> > >>>> +       return ptr;
> > >>>> +}
> > >>>> +
> > >>>>  static ssize_t tap_do_read(struct tap_queue *q,
> > >>>>                            struct iov_iter *to,
> > >>>>                            int noblock, struct sk_buff *skb)
> > >>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queue *q=
,
> > >>>>                                         TASK_INTERRUPTIBLE);
> > >>>>
> > >>>>                 /* Read frames from the queue */
> > >>>> -               skb =3D ptr_ring_consume(&q->ring);
> > >>>> +               skb =3D tap_ring_consume(q);
> > >>>>                 if (skb)
> > >>>>                         break;
> > >>>>                 if (noblock) {
> > >>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> > >>>> index 8192740357a0..7148f9a844a4 100644
> > >>>> --- a/drivers/net/tun.c
> > >>>> +++ b/drivers/net/tun.c
> > >>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun_str=
uct *tun,
> > >>>>         return total;
> > >>>>  }
> > >>>>
> > >>>> +static void *tun_ring_consume(struct tun_file *tfile)
> > >>>> +{
> > >>>> +       struct ptr_ring *ring =3D &tfile->tx_ring;
> > >>>> +       struct net_device *dev;
> > >>>> +       void *ptr;
> > >>>> +
> > >>>> +       spin_lock(&ring->consumer_lock);
> > >>>> +
> > >>>> +       ptr =3D __ptr_ring_consume(ring);
> > >>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(ring,=
 1))) {
> > >>>
> > >>> I guess it's the "bug" I mentioned in the previous patch that leads=
 to
> > >>> the check of __ptr_ring_consume_created_space() here. If it's true,
> > >>> another call to tweak the current API.
> > >>>
> > >>>> +               rcu_read_lock();
> > >>>> +               dev =3D rcu_dereference(tfile->tun)->dev;
> > >>>> +               netif_wake_subqueue(dev, tfile->queue_index);
> > >>>
> > >>> This would cause the producer TX_SOFTIRQ to run on the same cpu whi=
ch
> > >>> I'm not sure is what we want.
> > >>
> > >> What else would you suggest calling to wake the queue?
> > >
> > > I don't have a good method in my mind, just want to point out its imp=
lications.
> >
> > I have to admit I'm a bit stuck at this point, particularly with this
> > aspect.
> >
> > What is the correct way to pass the producer CPU ID to the consumer?
> > Would it make sense to store smp_processor_id() in the tfile inside
> > tun_net_xmit(), or should it instead be stored in the skb (similar to t=
he
> > XDP bit)? In the latter case, my concern is that this information may
> > already be significantly outdated by the time it is used.
> >
> > Based on that, my idea would be for the consumer to wake the producer b=
y
> > invoking a new function (e.g., tun_wake_queue()) on the producer CPU vi=
a
> > smp_call_function_single().
> > Is this a reasonable approach?
>
> I'm not sure but it would introduce costs like IPI.
>
> >
> > More generally, would triggering TX_SOFTIRQ on the consumer CPU be
> > considered a deal-breaker for the patch set?
>
> It depends on whether or not it has effects on the performance.
> Especially when vhost is pinned.

I meant we can benchmark to see the impact. For example, pin vhost to
a specific CPU and the try to see the impact of the TX_SOFTIRQ.

Thanks


