Return-Path: <kvm+bounces-69449-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AAvcHaG0emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69449-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:15:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E9D9AA8AF
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:15:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9F27430241BD
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D21C318EF2;
	Thu, 29 Jan 2026 01:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ToxVmRlK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qoyi5bwc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276A5314B6A
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649298; cv=pass; b=qdfHIZsp0GDek/ADrEzjBlrXFFAZ2gI/6Oymyq57kLJjN6ezKfvoTb0glbvUR4bwxLh3zyOGskdNRzHdKxUSvhbX9fi0Bww/8U9BXP9EzmomebUlT7ouSm9Yw68Obgdd4EKoRMd7fxfbyESuqvR2aCOZIFF5HwgWvuE65pmjrX4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649298; c=relaxed/simple;
	bh=+IbLxvhwPxFYFSa1tzHStRrP5YAWBXPRpwrDnDNPDG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uK2Wfm4yFHXmxkaczS1d16qCQ4/jdNCL18itjqxHPSX+l54dkD2CeDY1G0NrtY1Em3ZtQHmvuk6p7NxSVHuY+1LFigbO1K1x4OP5h7q0++pVjnNEBYxzI+EvMJ/jlL4Xv8j3ntPMlS3OSFo8+yy3M3piFZwXmaJ3U+HVClIGu4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ToxVmRlK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qoyi5bwc; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769649296;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AAyqH6SmWuOGsCC3JIASR5UfDF9EMKXo/TpQLggZqgQ=;
	b=ToxVmRlKuXxXOuz4tVOQd1+5oOPxFom/we0tmU7HHDDZzCmgoYH6QSw+PwXuPYOMr80azU
	2O6sSPgAIvflMldHKgvA6mNzMm0CrfXf9hNf9KbO6ZaNziXZ8WvPxr87yVwezWlAJ1Td++
	+rkgZHQQkKC8nzIbwv1NjhAKOR1ipVI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-251-OynxbBAENsic2_ui3KjVOg-1; Wed, 28 Jan 2026 20:14:54 -0500
X-MC-Unique: OynxbBAENsic2_ui3KjVOg-1
X-Mimecast-MFC-AGG-ID: OynxbBAENsic2_ui3KjVOg_1769649294
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-34c2f670a06so493385a91.3
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:14:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769649291; cv=none;
        d=google.com; s=arc-20240605;
        b=EUlVypfx7znviNbIv3Zv+2u9bnni1aJcp7NbEp5RHQXxB/NPAL7NtVtA2URFCIcMKW
         gVn54DpB+uILoF90q4GpaCtQrHL/v/pnIUeqOkHl8oOJk4x8fvHz+WvvzZAcVl8D5/U1
         s/Sk2PPVP/fpvauiD+xJli0XRSQfDOpcu8AlWzdEntSPzmZZ0aMcXCq2ifgmlixEZk1L
         ZMVKlcVc7PAmZ3xbfwVczPQzEvdLzgSz9XpCe7MtSLxjdb9R4fRI0+0nBxc4MmtoIRG/
         zp7gSu2bRh1CLM8zuofCddX19H1S5JuSoCCXHHCLnsAqo+nIMGelTJox8y4IlvZjWEEp
         yKPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AAyqH6SmWuOGsCC3JIASR5UfDF9EMKXo/TpQLggZqgQ=;
        fh=CFs/kYfJEaQaDm+gE2OOvT+U06uxjdraDtuvpf82/TE=;
        b=KMV9+X+lcHSx16EmeWTkIxeqdYb5atsmI1XDKckjZs3HwvVKsjNhqvTrmlUc0Dc6CM
         +R8L/hhJclFXu+YZaT9SwwnJ+slhk8I3qrk6naKLrlW1U2RKpkiRR54bBinep2mMvbdb
         N6n58IVTQtcC3m+VVZl1QbDAI6INbnL7X+A+iO7unJt334FmHDlP9df6ss+clEmLqcNY
         sBKACxYqQFnRrMccMM7ir7oEEqzxDc2s22bpiAiss6FS9ThVgXRAxVwTNvLPcDufGBrC
         nbGDFMvU7XtkPH0cRxTXNHo5WL7UhzM+RPfPpPDd0uVP4hmLiN2XWsPrpQGVykv9GOm5
         diIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769649291; x=1770254091; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AAyqH6SmWuOGsCC3JIASR5UfDF9EMKXo/TpQLggZqgQ=;
        b=qoyi5bwcMQZQnwjdq1SN3Dn2LeoL1NjLlr27tyCs+75/yQ9+N90/oFJGRzhqnNVQTy
         dt+nKDD/03dZ63yzk34CTNW+Hz83LnDiUduD8V5m2uPmfbwSKayyMFuDeczRrIxyxdRJ
         uzuJlAUI3kvqBSh8/+3pB0X5K9Lr+SUy4uHyccYQ5HhLGf8iVYy+7Lg7TyfNyfQQsu2W
         8bbir+3Jr7ECMJqm8RmOr6moDXuglTQ3g6+iUAJENCqqVHBeCyllWjaR1A+WP4JYa844
         YC8Rx1SxyOuUrzviHZhG+nciBipiakSj1Q6TnJ7l++7Db3HHM1Bsk0lcHaosAo+5Kg6o
         4k+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649291; x=1770254091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AAyqH6SmWuOGsCC3JIASR5UfDF9EMKXo/TpQLggZqgQ=;
        b=B+NIbKSTH7+wISeMxoDmzGj6e8aXrYmSLZSq1C8jay1ootUodWjvHdO6VNo+3cif13
         +py/puoGJBPOvVtWiY0Iw6u9pzsoTc6jHxatpBU6CkuEBaLToD2Ck8eAvJcg3BMSDtaV
         FFDRKoPndK4EM3rtXkseWkj7T78sT+C8/XuKobHuMnk5O6U78IPhm1gAdKkCKcEsD57d
         DfaZXJdN1WPeYsmMgJ1juZwo3t0WHDYaxbjkGX/p7th/lTGCMAmvAvSfVvZPlLRDjs7f
         VcIjOo+kGre9iMjBQppUt3GYdic/5xwFm8XkbMDFoF3WsgNYF1QfR3t0UfvNXiUh9WSK
         B59Q==
X-Forwarded-Encrypted: i=1; AJvYcCUyXzjXj5Z84HWgB641i6IwKJYLCDL0IGBoeqtwaX5kAEOUX8M/szUryBgX6TueTfBQVc4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz48fD2+LZVQ/siP0s2E78Ok6PZprb6FOOB8FXpQmtXvAYIuym
	z10jIq32YmZgXVIzeqYtyinba57EXpsJxmG4KrFMdClB4x6/02aJ87TVKiWuqKU/Xe81TLtaOop
	Pmy0jXp7usO33Yz8D56fB7Tsg+VV6QeFhckbiClC0JJ6paDjX+Kdm+Ky3cNcKpTw6jDUfYofMyy
	FF+XHB4IMzXxm+ZWk3665rAFpWtorokhMgYhUlOqM=
X-Gm-Gg: AZuq6aLeRKcE9Uv8J11RfhL7cz22XEIEJXFgDFLvxPuzfX40aK9nRMl3zocAzS7ithO
	FB7zCy8vlYfue4llWRQIl/zN/Qj6A/wWXkT2UFIKVOfeY4wIu313w+PbdgCqxztzB3sJuG36V9t
	rt6/E+hB3FZdkofZsmgOfDiAbEh8vl85TxfQHJHjLAjxNNjHV1aojCpIktnjmmTuy3
X-Received: by 2002:a17:90b:2705:b0:340:d06d:ea73 with SMTP id 98e67ed59e1d1-353fed74b1bmr6200876a91.19.1769649291245;
        Wed, 28 Jan 2026 17:14:51 -0800 (PST)
X-Received: by 2002:a17:90b:2705:b0:340:d06d:ea73 with SMTP id
 98e67ed59e1d1-353fed74b1bmr6200859a91.19.1769649290732; Wed, 28 Jan 2026
 17:14:50 -0800 (PST)
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
 <CACGkMEsJKeEsH=G8H5RzMNHY4g3HNdciMDMhciShawh-9Xb9hg@mail.gmail.com>
 <bc1078e5-65fc-4de6-8475-517f626d8d96@tu-dortmund.de> <3a1d6232-efe4-4e79-a196-44794fdc0f33@tu-dortmund.de>
 <CACGkMEv71kn91FPAUrxJg=YB3+B0MRTgOidMPHjK7Qq0WEhGtw@mail.gmail.com> <260f48cd-caa1-4684-a235-8e1192722b3a@tu-dortmund.de>
In-Reply-To: <260f48cd-caa1-4684-a235-8e1192722b3a@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 29 Jan 2026 09:14:38 +0800
X-Gm-Features: AZwV_QhChibP1TQksxzISzzBmI4bS7flGPohL5vfvndiNnozn5EJ93__Ix-8njI
Message-ID: <CACGkMEsVMz+vS3KxykYBGXvyt3MZcstnYWUiYJZhLSMoHC5Smw@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69449-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm,netdev];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,pktgen_sample03_burst_single_flow.sh:url]
X-Rspamd-Queue-Id: 2E9D9AA8AF
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 3:54=E2=80=AFPM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> On 1/28/26 08:03, Jason Wang wrote:
> > On Wed, Jan 28, 2026 at 12:48=E2=80=AFAM Simon Schippers
> > <simon.schippers@tu-dortmund.de> wrote:
> >>
> >> On 1/23/26 10:54, Simon Schippers wrote:
> >>> On 1/23/26 04:05, Jason Wang wrote:
> >>>> On Thu, Jan 22, 2026 at 1:35=E2=80=AFPM Jason Wang <jasowang@redhat.=
com> wrote:
> >>>>>
> >>>>> On Wed, Jan 21, 2026 at 5:33=E2=80=AFPM Simon Schippers
> >>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>
> >>>>>> On 1/9/26 07:02, Jason Wang wrote:
> >>>>>>> On Thu, Jan 8, 2026 at 3:41=E2=80=AFPM Simon Schippers
> >>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>
> >>>>>>>> On 1/8/26 04:38, Jason Wang wrote:
> >>>>>>>>> On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> >>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>>>
> >>>>>>>>>> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_rin=
g_consume()
> >>>>>>>>>> and wake the corresponding netdev subqueue when consuming an e=
ntry frees
> >>>>>>>>>> space in the underlying ptr_ring.
> >>>>>>>>>>
> >>>>>>>>>> Stopping of the netdev queue when the ptr_ring is full will be=
 introduced
> >>>>>>>>>> in an upcoming commit.
> >>>>>>>>>>
> >>>>>>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>>>>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>>>>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de=
>
> >>>>>>>>>> ---
> >>>>>>>>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
> >>>>>>>>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
> >>>>>>>>>>  2 files changed, 45 insertions(+), 3 deletions(-)
> >>>>>>>>>>
> >>>>>>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> >>>>>>>>>> index 1197f245e873..2442cf7ac385 100644
> >>>>>>>>>> --- a/drivers/net/tap.c
> >>>>>>>>>> +++ b/drivers/net/tap.c
> >>>>>>>>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_qu=
eue *q,
> >>>>>>>>>>         return ret ? ret : total;
> >>>>>>>>>>  }
> >>>>>>>>>>
> >>>>>>>>>> +static void *tap_ring_consume(struct tap_queue *q)
> >>>>>>>>>> +{
> >>>>>>>>>> +       struct ptr_ring *ring =3D &q->ring;
> >>>>>>>>>> +       struct net_device *dev;
> >>>>>>>>>> +       void *ptr;
> >>>>>>>>>> +
> >>>>>>>>>> +       spin_lock(&ring->consumer_lock);
> >>>>>>>>>> +
> >>>>>>>>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(r=
ing, 1))) {
> >>>>>>>>>> +               rcu_read_lock();
> >>>>>>>>>> +               dev =3D rcu_dereference(q->tap)->dev;
> >>>>>>>>>> +               netif_wake_subqueue(dev, q->queue_index);
> >>>>>>>>>> +               rcu_read_unlock();
> >>>>>>>>>> +       }
> >>>>>>>>>> +
> >>>>>>>>>> +       spin_unlock(&ring->consumer_lock);
> >>>>>>>>>> +
> >>>>>>>>>> +       return ptr;
> >>>>>>>>>> +}
> >>>>>>>>>> +
> >>>>>>>>>>  static ssize_t tap_do_read(struct tap_queue *q,
> >>>>>>>>>>                            struct iov_iter *to,
> >>>>>>>>>>                            int noblock, struct sk_buff *skb)
> >>>>>>>>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queu=
e *q,
> >>>>>>>>>>                                         TASK_INTERRUPTIBLE);
> >>>>>>>>>>
> >>>>>>>>>>                 /* Read frames from the queue */
> >>>>>>>>>> -               skb =3D ptr_ring_consume(&q->ring);
> >>>>>>>>>> +               skb =3D tap_ring_consume(q);
> >>>>>>>>>>                 if (skb)
> >>>>>>>>>>                         break;
> >>>>>>>>>>                 if (noblock) {
> >>>>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>>>>>>>> index 8192740357a0..7148f9a844a4 100644
> >>>>>>>>>> --- a/drivers/net/tun.c
> >>>>>>>>>> +++ b/drivers/net/tun.c
> >>>>>>>>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun=
_struct *tun,
> >>>>>>>>>>         return total;
> >>>>>>>>>>  }
> >>>>>>>>>>
> >>>>>>>>>> +static void *tun_ring_consume(struct tun_file *tfile)
> >>>>>>>>>> +{
> >>>>>>>>>> +       struct ptr_ring *ring =3D &tfile->tx_ring;
> >>>>>>>>>> +       struct net_device *dev;
> >>>>>>>>>> +       void *ptr;
> >>>>>>>>>> +
> >>>>>>>>>> +       spin_lock(&ring->consumer_lock);
> >>>>>>>>>> +
> >>>>>>>>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(r=
ing, 1))) {
> >>>>>>>>>
> >>>>>>>>> I guess it's the "bug" I mentioned in the previous patch that l=
eads to
> >>>>>>>>> the check of __ptr_ring_consume_created_space() here. If it's t=
rue,
> >>>>>>>>> another call to tweak the current API.
> >>>>>>>>>
> >>>>>>>>>> +               rcu_read_lock();
> >>>>>>>>>> +               dev =3D rcu_dereference(tfile->tun)->dev;
> >>>>>>>>>> +               netif_wake_subqueue(dev, tfile->queue_index);
> >>>>>>>>>
> >>>>>>>>> This would cause the producer TX_SOFTIRQ to run on the same cpu=
 which
> >>>>>>>>> I'm not sure is what we want.
> >>>>>>>>
> >>>>>>>> What else would you suggest calling to wake the queue?
> >>>>>>>
> >>>>>>> I don't have a good method in my mind, just want to point out its=
 implications.
> >>>>>>
> >>>>>> I have to admit I'm a bit stuck at this point, particularly with t=
his
> >>>>>> aspect.
> >>>>>>
> >>>>>> What is the correct way to pass the producer CPU ID to the consume=
r?
> >>>>>> Would it make sense to store smp_processor_id() in the tfile insid=
e
> >>>>>> tun_net_xmit(), or should it instead be stored in the skb (similar=
 to the
> >>>>>> XDP bit)? In the latter case, my concern is that this information =
may
> >>>>>> already be significantly outdated by the time it is used.
> >>>>>>
> >>>>>> Based on that, my idea would be for the consumer to wake the produ=
cer by
> >>>>>> invoking a new function (e.g., tun_wake_queue()) on the producer C=
PU via
> >>>>>> smp_call_function_single().
> >>>>>> Is this a reasonable approach?
> >>>>>
> >>>>> I'm not sure but it would introduce costs like IPI.
> >>>>>
> >>>>>>
> >>>>>> More generally, would triggering TX_SOFTIRQ on the consumer CPU be
> >>>>>> considered a deal-breaker for the patch set?
> >>>>>
> >>>>> It depends on whether or not it has effects on the performance.
> >>>>> Especially when vhost is pinned.
> >>>>
> >>>> I meant we can benchmark to see the impact. For example, pin vhost t=
o
> >>>> a specific CPU and the try to see the impact of the TX_SOFTIRQ.
> >>>>
> >>>> Thanks
> >>>>
> >>>
> >>> I ran benchmarks with vhost pinned to CPU 0 using taskset -p -c 0 ...
> >>> for both the stock and patched versions. The benchmarks were run with
> >>> the full patch series applied, since testing only patches 1-3 would n=
ot
> >>> be meaningful - the queue is never stopped in that case, so no
> >>> TX_SOFTIRQ is triggered.
> >>>
> >>> Compared to the non-pinned CPU benchmarks in the cover letter,
> >>> performance is lower for pktgen with a single thread but higher with
> >>> four threads. The results show no regression for the patched version,
> >>> with even slight performance improvements observed:
> >>>
> >>> +-------------------------+-----------+----------------+
> >>> | pktgen benchmarks to    | Stock     | Patched with   |
> >>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
> >>> | 100M packets            |           |                |
> >>> | vhost pinned to core 0  |           |                |
> >>> +-----------+-------------+-----------+----------------+
> >>> | TAP       | Transmitted | 452 Kpps  | 454 Kpps       |
> >>> |  +        +-------------+-----------+----------------+
> >>> | vhost-net | Lost        | 1154 Kpps | 0              |
> >>> +-----------+-------------+-----------+----------------+
> >>>
> >>> +-------------------------+-----------+----------------+
> >>> | pktgen benchmarks to    | Stock     | Patched with   |
> >>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
> >>> | 100M packets            |           |                |
> >>> | vhost pinned to core 0  |           |                |
> >>> | *4 threads*             |           |                |
> >>> +-----------+-------------+-----------+----------------+
> >>> | TAP       | Transmitted | 71 Kpps   | 79 Kpps        |
> >>> |  +        +-------------+-----------+----------------+
> >>> | vhost-net | Lost        | 1527 Kpps | 0              |
> >>> +-----------+-------------+-----------+----------------+
> >
> > The PPS seems to be low. I'd suggest using testpmd (rxonly) mode in
> > the guest or an xdp program that did XDP_DROP in the guest.
>
> I forgot to mention that these PPS values are per thread.
> So overall we have 71 Kpps * 4 =3D 284 Kpps and 79 Kpps * 4 =3D 326 Kpps,
> respectively. For packet loss, that comes out to 1154 Kpps * 4 =3D
> 4616 Kpps and 0, respectively.
>
> Sorry about that!
>
> The pktgen benchmarks with a single thread look fine, right?

Still looks very low. E.g I just have a run of pktgen (using
pktgen_sample03_burst_single_flow.sh) without a XDP_DROP in the guest,
I can get 1Mpps.

>
> I'll still look into using an XDP program that does XDP_DROP in the
> guest.
>
> Thanks!

Thanks

>
> >
> >>>
> >>> +------------------------+-------------+----------------+
> >>> | iperf3 TCP benchmarks  | Stock       | Patched with   |
> >>> | to Debian VM 120s      |             | fq_codel qdisc |
> >>> | vhost pinned to core 0 |             |                |
> >>> +------------------------+-------------+----------------+
> >>> | TAP                    | 22.0 Gbit/s | 22.0 Gbit/s    |
> >>> |  +                     |             |                |
> >>> | vhost-net              |             |                |
> >>> +------------------------+-------------+----------------+
> >>>
> >>> +---------------------------+-------------+----------------+
> >>> | iperf3 TCP benchmarks     | Stock       | Patched with   |
> >>> | to Debian VM 120s         |             | fq_codel qdisc |
> >>> | vhost pinned to core 0    |             |                |
> >>> | *4 iperf3 client threads* |             |                |
> >>> +---------------------------+-------------+----------------+
> >>> | TAP                       | 21.4 Gbit/s | 21.5 Gbit/s    |
> >>> |  +                        |             |                |
> >>> | vhost-net                 |             |                |
> >>> +---------------------------+-------------+----------------+
> >>
> >> What are your thoughts on this?
> >>
> >> Thanks!
> >>
> >>
> >
> > Thanks
> >
>


