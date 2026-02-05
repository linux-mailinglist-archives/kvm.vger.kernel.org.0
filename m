Return-Path: <kvm+bounces-70290-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yOWVOegVhGkIygMAu9opvQ
	(envelope-from <kvm+bounces-70290-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 05:00:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F375EE717
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 05:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E61AD301840A
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 04:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ABC62EACF9;
	Thu,  5 Feb 2026 03:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZryiSQkR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BEqep7NQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EA72E9749
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 03:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770263995; cv=pass; b=Wlk+5EMnS3u9/2B+x+k21JYAIIwYx4/1IcvGiCEmXaGFt4oB9+9Ap28bsAcBtjgUBhirZwAtZ0JITofcgu/hsgERwuA0vxlC+g0PIX9Ui3oPenA/i539SyMOuhYJfuofSyPFFxtgiW81yy08LqpWfziVkC6EGY3VLO3hzXuFmlU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770263995; c=relaxed/simple;
	bh=bfhphnRA5zer3H1zeiNu4pF41M4BAfyhbX6/oa7Kygc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YRR8BapA1GboD+XBESN13jzxwvI0AUEXGCOWKYgC0/tDOrd51OCVbcSXlsSR9ilEBjlMYdSKZZqi9RZvTuKvS4rECi1OgLfB1xZgoCFA7I9fESWEHq++q/CFIVfpvquOAteiQaxDZeKGcIoBsYKB6UKNehEP7MpobpQStfz4GRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZryiSQkR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BEqep7NQ; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770263994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ljtQzezi2FxbD86kjMOelb1Xz/e3jR0e/78H4lX77ko=;
	b=ZryiSQkRN8BsT42o991INiU1/zex9Lt9xmHXP8uZUE8/gsQbWy491fnL3ArP3dhfw53Qd8
	JCLbxvMLrAdpkPQFfQB7KXErZGi8c74c46Mq4gLUj710J4miE0ig8gCyb2KbZeihWVT8l3
	6Jq/dqk6uI6DrY58a+gHiHc0S66Q/WM=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-qUiCaSL4NPG1Cw0M30nKlA-1; Wed, 04 Feb 2026 22:59:52 -0500
X-MC-Unique: qUiCaSL4NPG1Cw0M30nKlA-1
X-Mimecast-MFC-AGG-ID: qUiCaSL4NPG1Cw0M30nKlA_1770263992
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-353a5c295e4so1270860a91.0
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 19:59:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770263987; cv=none;
        d=google.com; s=arc-20240605;
        b=LEUOcCkGjZMW3Q8YcLGJDNgw1lLvKYZiMz5uVrZoD32Osd7rmja+RDOV/NEG4pgNlh
         fWVRhe3ZkSB6X2GsAxMwDZa52raeO3rpIU+99HZyPXqS0wL5ZAckYS1vehAEixqDSDzj
         hH3t+LWJharljWvS4MdNiechinK5hFb+Ts3gw8cMSzWDWkgwNakTcf+r2ihTGy+wA9/A
         dA9hn8xYXEsImoaH81s8aqUJjsiPnw7FhK2920jkY3kbVO25/9BYvNqfdViL7NYa/WOX
         v4J9XagEwa3nJUdbQtjRpBloQsjdCHtQ4hyGqLaAD2cnI0dQuJLHEZuHVkCQCeGykNz2
         lQqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ljtQzezi2FxbD86kjMOelb1Xz/e3jR0e/78H4lX77ko=;
        fh=8I7u0czdffkUL3GuLLSaoj4+/k9wn8XLfE17WruuSSA=;
        b=IkWZ8TUI2HyyWFaYoIKVVUw30J70MM7gM7tMqprIFsADK9NsWKQL67uktTWCRhn6GL
         DjzuqpYfYok8ffCsCVK7AUrveJgFXGad9mbtF1i+MLl6YcoOTadJKPCT3rvoYycsEPjW
         /gXyEam/tHddU1cPz2xEGVzsAwRrp+MY1ffq4cF5fY7qh/9iLl34pLgnJr+Drziijalj
         NCzXYVVOdqLDm511NwOftIL61HWrEDYxM+/SKUNxUctl54cKS5+8Mj7FodwvWHD2owgj
         ZM2K1ABH87sAn7BDVObQZlOyaYvjYF67T9Wg6u1Q2kKq0+sVTABYn4BDXJkGbUbgDPmd
         Tm3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770263987; x=1770868787; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ljtQzezi2FxbD86kjMOelb1Xz/e3jR0e/78H4lX77ko=;
        b=BEqep7NQu8Q2bdbDpnCH5AFbzr8yg0PiZ6hEc2KIvHKaqPeH1IeTco+mHqQh/QODQ0
         jffpiObdmvI4VtcjRnfrzDnTxPwzCdAUkZVIeQkxAaBxZ6QmNgNbRSRVqoAym3kQwTb7
         Fnc3U/rYXxRgGcljljaW6L7avh3Hep7hC9AXq0wKKHwdZmzSGLZ4y8T75kuY9rFUZ4zg
         M619Ai+tfNl6xxk+GyLLgQZbS9NefKvRGKcF+NhXl94xe/wWO29o8VETMR168nNpwn/0
         QRwXJVd30bsQTjEi2pCofgxCUdSKAzwSQyoN0nH05JdxYuCULWKQWpEfMRJkAtFjEQsk
         8M8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770263987; x=1770868787;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ljtQzezi2FxbD86kjMOelb1Xz/e3jR0e/78H4lX77ko=;
        b=TNrcrAvI9VWICg7nOM3SvQvB/vTKLWJeZDLxECcbKYYrjoiKrQhYY8x/XRag/6aiN7
         /BRFXHcSy08WOOpzsxKp/YE+c3n2DoSFdNPIU0IeGl72G8TMb+Rjl7QWANb3M1mxZrA7
         v+TBMq+z60zgjnOR6lmxoVbQ20FJHmgXDaBCc9KpuBWrVity4iEV9yauWzkxsg/lJt3u
         dM/LBwKrxamu5Hzx+rhwbLqPHlqedimpZsSRzzOFRmaXBv65s7YULU7lbFIlMMXxqwtE
         O3kVOfkfrgseWsm+bXu5vQQ+Qp6PLZv/ctZ/8paqWSTm24uoNZ8c00GcMBxHtVpTNuSQ
         QCCA==
X-Forwarded-Encrypted: i=1; AJvYcCWlUhgJXkypbCjKtyeRTbP8aBzqrcYlzIh9pzViDDnzy5Ak2bfae75rPSkw1AXSgp8sy9o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5A5JWNdTAl3l29CMvTL5SklV9Nvkf7pph9zl2BM2zMlPa9CAb
	p/VOmxctbDhqOD7ZuF8QHXqtlEbhVxjpMJp7HSZnTGtxJdNb3WAWkXWmX++xtRyv+axCKsIdgRz
	2f4x14fV8gdYeEtFFEfQHy4L8Mo4PVeZFn4yj2gtH5q3Ve1ODCRQQKA3F/cl+rN4QNDqjYPJ0ED
	JRY3dXcJPNp0Ex4Pe4Oze9yoJtiARw
X-Gm-Gg: AZuq6aK9dUaD8h7ykUA4s1NToCivVLJL/lp6xmotCYbc1WXmCoVyaquyqOvzRli0gZe
	MK+IA2FCoT40PtePI/beVMxdmM8OthCdAXQpUYxFQpm5iaoEPWeYIMaSuHhX8Fi+tEuIdyr7/+G
	xAXdjxxGbIYTPWfc6ZnfPQFb+geL0s5phDyT66GYP+Dsoibn/SSgY+o8Gsptz1pXPMqQ==
X-Received: by 2002:a17:90b:51c1:b0:340:b501:7b83 with SMTP id 98e67ed59e1d1-3549beb61d0mr1342214a91.10.1770263986578;
        Wed, 04 Feb 2026 19:59:46 -0800 (PST)
X-Received: by 2002:a17:90b:51c1:b0:340:b501:7b83 with SMTP id
 98e67ed59e1d1-3549beb61d0mr1342194a91.10.1770263986077; Wed, 04 Feb 2026
 19:59:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <CACGkMEuSiEcyaeFeZd0=RgNpviJgNvUDq_ctjeMLT5jZTgRkwQ@mail.gmail.com>
 <1e30464c-99ae-441e-bb46-6d0485d494dc@tu-dortmund.de> <CACGkMEtzD3ORJuJcc8VeqwASiGeVFdQmJowsK6PYVEF_Zkcn8Q@mail.gmail.com>
 <afa40345-acbe-42b0-81d1-0a838343792d@tu-dortmund.de> <CACGkMEtxRoavBMTXom8Z=FM-pvu3pHbsuwCs+e450b1B=V7iWA@mail.gmail.com>
 <CACGkMEsJKeEsH=G8H5RzMNHY4g3HNdciMDMhciShawh-9Xb9hg@mail.gmail.com>
 <bc1078e5-65fc-4de6-8475-517f626d8d96@tu-dortmund.de> <3a1d6232-efe4-4e79-a196-44794fdc0f33@tu-dortmund.de>
 <CACGkMEv71kn91FPAUrxJg=YB3+B0MRTgOidMPHjK7Qq0WEhGtw@mail.gmail.com>
 <260f48cd-caa1-4684-a235-8e1192722b3a@tu-dortmund.de> <CACGkMEsVMz+vS3KxykYBGXvyt3MZcstnYWUiYJZhLSMoHC5Smw@mail.gmail.com>
 <ba17ba38-9f61-4a10-b375-d0da805e6b73@tu-dortmund.de> <CACGkMEtnLw2b8iDysQzRbXxTj2xbgzKqEZUbhmZz9tXPLTE6Sw@mail.gmail.com>
 <0ebc00ba-35e7-4570-a44f-b0ae634f2316@tu-dortmund.de> <CACGkMEsJtE3RehWQ8BaDL2HdFPK=iW+ZaEAN1TekAMWwor5tjQ@mail.gmail.com>
 <197573a1-df52-4928-adb9-55a7a4f78839@tu-dortmund.de>
In-Reply-To: <197573a1-df52-4928-adb9-55a7a4f78839@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 5 Feb 2026 11:59:34 +0800
X-Gm-Features: AZwV_QiJtn5H5gbXXSINnNFKoMHH3t5eiT8AX-RzqcNru-kUb1aFsLgKadZkfcw
Message-ID: <CACGkMEveEXky_rTrvRrfi7qix12GG91GfyqnwB6Tu-dnjqAm9A@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70290-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,netdev];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pktgen_sample01_simple.sh:url,0.0.0.0:email,pktgen_sample02_multiqueue.sh:url,pktgen_sample03_burst_single_flow.sh:url,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 3F375EE717
X-Rspamd-Action: no action

On Wed, Feb 4, 2026 at 11:44=E2=80=AFPM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> On 2/3/26 04:48, Jason Wang wrote:
> > On Mon, Feb 2, 2026 at 4:19=E2=80=AFAM Simon Schippers
> > <simon.schippers@tu-dortmund.de> wrote:
> >>
> >> On 1/30/26 02:51, Jason Wang wrote:
> >>> On Thu, Jan 29, 2026 at 5:25=E2=80=AFPM Simon Schippers
> >>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>
> >>>> On 1/29/26 02:14, Jason Wang wrote:
> >>>>> On Wed, Jan 28, 2026 at 3:54=E2=80=AFPM Simon Schippers
> >>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>
> >>>>>> On 1/28/26 08:03, Jason Wang wrote:
> >>>>>>> On Wed, Jan 28, 2026 at 12:48=E2=80=AFAM Simon Schippers
> >>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>
> >>>>>>>> On 1/23/26 10:54, Simon Schippers wrote:
> >>>>>>>>> On 1/23/26 04:05, Jason Wang wrote:
> >>>>>>>>>> On Thu, Jan 22, 2026 at 1:35=E2=80=AFPM Jason Wang <jasowang@r=
edhat.com> wrote:
> >>>>>>>>>>>
> >>>>>>>>>>> On Wed, Jan 21, 2026 at 5:33=E2=80=AFPM Simon Schippers
> >>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>>>>>
> >>>>>>>>>>>> On 1/9/26 07:02, Jason Wang wrote:
> >>>>>>>>>>>>> On Thu, Jan 8, 2026 at 3:41=E2=80=AFPM Simon Schippers
> >>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> On 1/8/26 04:38, Jason Wang wrote:
> >>>>>>>>>>>>>>> On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> >>>>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> Introduce {tun,tap}_ring_consume() helpers that wrap __p=
tr_ring_consume()
> >>>>>>>>>>>>>>>> and wake the corresponding netdev subqueue when consumin=
g an entry frees
> >>>>>>>>>>>>>>>> space in the underlying ptr_ring.
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> Stopping of the netdev queue when the ptr_ring is full w=
ill be introduced
> >>>>>>>>>>>>>>>> in an upcoming commit.
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de=
>
> >>>>>>>>>>>>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>>>>>>>>>>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortm=
und.de>
> >>>>>>>>>>>>>>>> ---
> >>>>>>>>>>>>>>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
> >>>>>>>>>>>>>>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
> >>>>>>>>>>>>>>>>  2 files changed, 45 insertions(+), 3 deletions(-)
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> >>>>>>>>>>>>>>>> index 1197f245e873..2442cf7ac385 100644
> >>>>>>>>>>>>>>>> --- a/drivers/net/tap.c
> >>>>>>>>>>>>>>>> +++ b/drivers/net/tap.c
> >>>>>>>>>>>>>>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct =
tap_queue *q,
> >>>>>>>>>>>>>>>>         return ret ? ret : total;
> >>>>>>>>>>>>>>>>  }
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> +static void *tap_ring_consume(struct tap_queue *q)
> >>>>>>>>>>>>>>>> +{
> >>>>>>>>>>>>>>>> +       struct ptr_ring *ring =3D &q->ring;
> >>>>>>>>>>>>>>>> +       struct net_device *dev;
> >>>>>>>>>>>>>>>> +       void *ptr;
> >>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
> >>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>>>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_s=
pace(ring, 1))) {
> >>>>>>>>>>>>>>>> +               rcu_read_lock();
> >>>>>>>>>>>>>>>> +               dev =3D rcu_dereference(q->tap)->dev;
> >>>>>>>>>>>>>>>> +               netif_wake_subqueue(dev, q->queue_index)=
;
> >>>>>>>>>>>>>>>> +               rcu_read_unlock();
> >>>>>>>>>>>>>>>> +       }
> >>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>> +       spin_unlock(&ring->consumer_lock);
> >>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>> +       return ptr;
> >>>>>>>>>>>>>>>> +}
> >>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>  static ssize_t tap_do_read(struct tap_queue *q,
> >>>>>>>>>>>>>>>>                            struct iov_iter *to,
> >>>>>>>>>>>>>>>>                            int noblock, struct sk_buff *=
skb)
> >>>>>>>>>>>>>>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct ta=
p_queue *q,
> >>>>>>>>>>>>>>>>                                         TASK_INTERRUPTIB=
LE);
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>                 /* Read frames from the queue */
> >>>>>>>>>>>>>>>> -               skb =3D ptr_ring_consume(&q->ring);
> >>>>>>>>>>>>>>>> +               skb =3D tap_ring_consume(q);
> >>>>>>>>>>>>>>>>                 if (skb)
> >>>>>>>>>>>>>>>>                         break;
> >>>>>>>>>>>>>>>>                 if (noblock) {
> >>>>>>>>>>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>>>>>>>>>>>>>> index 8192740357a0..7148f9a844a4 100644
> >>>>>>>>>>>>>>>> --- a/drivers/net/tun.c
> >>>>>>>>>>>>>>>> +++ b/drivers/net/tun.c
> >>>>>>>>>>>>>>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(stru=
ct tun_struct *tun,
> >>>>>>>>>>>>>>>>         return total;
> >>>>>>>>>>>>>>>>  }
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> +static void *tun_ring_consume(struct tun_file *tfile)
> >>>>>>>>>>>>>>>> +{
> >>>>>>>>>>>>>>>> +       struct ptr_ring *ring =3D &tfile->tx_ring;
> >>>>>>>>>>>>>>>> +       struct net_device *dev;
> >>>>>>>>>>>>>>>> +       void *ptr;
> >>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
> >>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>>>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_s=
pace(ring, 1))) {
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> I guess it's the "bug" I mentioned in the previous patch =
that leads to
> >>>>>>>>>>>>>>> the check of __ptr_ring_consume_created_space() here. If =
it's true,
> >>>>>>>>>>>>>>> another call to tweak the current API.
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> +               rcu_read_lock();
> >>>>>>>>>>>>>>>> +               dev =3D rcu_dereference(tfile->tun)->dev=
;
> >>>>>>>>>>>>>>>> +               netif_wake_subqueue(dev, tfile->queue_in=
dex);
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> This would cause the producer TX_SOFTIRQ to run on the sa=
me cpu which
> >>>>>>>>>>>>>>> I'm not sure is what we want.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> What else would you suggest calling to wake the queue?
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> I don't have a good method in my mind, just want to point o=
ut its implications.
> >>>>>>>>>>>>
> >>>>>>>>>>>> I have to admit I'm a bit stuck at this point, particularly =
with this
> >>>>>>>>>>>> aspect.
> >>>>>>>>>>>>
> >>>>>>>>>>>> What is the correct way to pass the producer CPU ID to the c=
onsumer?
> >>>>>>>>>>>> Would it make sense to store smp_processor_id() in the tfile=
 inside
> >>>>>>>>>>>> tun_net_xmit(), or should it instead be stored in the skb (s=
imilar to the
> >>>>>>>>>>>> XDP bit)? In the latter case, my concern is that this inform=
ation may
> >>>>>>>>>>>> already be significantly outdated by the time it is used.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Based on that, my idea would be for the consumer to wake the=
 producer by
> >>>>>>>>>>>> invoking a new function (e.g., tun_wake_queue()) on the prod=
ucer CPU via
> >>>>>>>>>>>> smp_call_function_single().
> >>>>>>>>>>>> Is this a reasonable approach?
> >>>>>>>>>>>
> >>>>>>>>>>> I'm not sure but it would introduce costs like IPI.
> >>>>>>>>>>>
> >>>>>>>>>>>>
> >>>>>>>>>>>> More generally, would triggering TX_SOFTIRQ on the consumer =
CPU be
> >>>>>>>>>>>> considered a deal-breaker for the patch set?
> >>>>>>>>>>>
> >>>>>>>>>>> It depends on whether or not it has effects on the performanc=
e.
> >>>>>>>>>>> Especially when vhost is pinned.
> >>>>>>>>>>
> >>>>>>>>>> I meant we can benchmark to see the impact. For example, pin v=
host to
> >>>>>>>>>> a specific CPU and the try to see the impact of the TX_SOFTIRQ=
.
> >>>>>>>>>>
> >>>>>>>>>> Thanks
> >>>>>>>>>>
> >>>>>>>>>
> >>>>>>>>> I ran benchmarks with vhost pinned to CPU 0 using taskset -p -c=
 0 ...
> >>>>>>>>> for both the stock and patched versions. The benchmarks were ru=
n with
> >>>>>>>>> the full patch series applied, since testing only patches 1-3 w=
ould not
> >>>>>>>>> be meaningful - the queue is never stopped in that case, so no
> >>>>>>>>> TX_SOFTIRQ is triggered.
> >>>>>>>>>
> >>>>>>>>> Compared to the non-pinned CPU benchmarks in the cover letter,
> >>>>>>>>> performance is lower for pktgen with a single thread but higher=
 with
> >>>>>>>>> four threads. The results show no regression for the patched ve=
rsion,
> >>>>>>>>> with even slight performance improvements observed:
> >>>>>>>>>
> >>>>>>>>> +-------------------------+-----------+----------------+
> >>>>>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
> >>>>>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
> >>>>>>>>> | 100M packets            |           |                |
> >>>>>>>>> | vhost pinned to core 0  |           |                |
> >>>>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>>>>> | TAP       | Transmitted | 452 Kpps  | 454 Kpps       |
> >>>>>>>>> |  +        +-------------+-----------+----------------+
> >>>>>>>>> | vhost-net | Lost        | 1154 Kpps | 0              |
> >>>>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>>>>>
> >>>>>>>>> +-------------------------+-----------+----------------+
> >>>>>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
> >>>>>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
> >>>>>>>>> | 100M packets            |           |                |
> >>>>>>>>> | vhost pinned to core 0  |           |                |
> >>>>>>>>> | *4 threads*             |           |                |
> >>>>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>>>>> | TAP       | Transmitted | 71 Kpps   | 79 Kpps        |
> >>>>>>>>> |  +        +-------------+-----------+----------------+
> >>>>>>>>> | vhost-net | Lost        | 1527 Kpps | 0              |
> >>>>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>>>
> >>>>>>> The PPS seems to be low. I'd suggest using testpmd (rxonly) mode =
in
> >>>>>>> the guest or an xdp program that did XDP_DROP in the guest.
> >>>>>>
> >>>>>> I forgot to mention that these PPS values are per thread.
> >>>>>> So overall we have 71 Kpps * 4 =3D 284 Kpps and 79 Kpps * 4 =3D 32=
6 Kpps,
> >>>>>> respectively. For packet loss, that comes out to 1154 Kpps * 4 =3D
> >>>>>> 4616 Kpps and 0, respectively.
> >>>>>>
> >>>>>> Sorry about that!
> >>>>>>
> >>>>>> The pktgen benchmarks with a single thread look fine, right?
> >>>>>
> >>>>> Still looks very low. E.g I just have a run of pktgen (using
> >>>>> pktgen_sample03_burst_single_flow.sh) without a XDP_DROP in the gue=
st,
> >>>>> I can get 1Mpps.
> >>>>
> >>>> Keep in mind that I am using an older CPU (i5-6300HQ). For the
> >>>> single-threaded tests I always used pktgen_sample01_simple.sh, and f=
or
> >>>> the multi-threaded tests I always used pktgen_sample02_multiqueue.sh=
.
> >>>>
> >>>> Using pktgen_sample03_burst_single_flow.sh as you did fails for me (=
even
> >>>> though the same parameters work fine for sample01 and sample02):
> >>>>
> >>>> samples/pktgen/pktgen_sample03_burst_single_flow.sh -i tap0 -m
> >>>> 52:54:00:12:34:56 -d 10.0.0.2 -n 100000000
> >>>> /samples/pktgen/functions.sh: line 79: echo: write error: Operation =
not
> >>>> supported
> >>>> ERROR: Write error(1) occurred
> >>>> cmd: "burst 32 > /proc/net/pktgen/tap0@0"
> >>>>
> >>>> ...and I do not know what I am doing wrong, even after looking at
> >>>> Documentation/networking/pktgen.rst. Every burst size except 1 fails=
.
> >>>> Any clues?
> >>>
> >>> Please use -b 0, and I'm Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz.
> >>
> >> I tried using "-b 0", and while it worked, there was no noticeable
> >> performance improvement.
> >>
> >>>
> >>> Another thing I can think of is to disable
> >>>
> >>> 1) mitigations in both guest and host
> >>> 2) any kernel debug features in both host and guest
> >>
> >> I also rebuilt the kernel with everything disabled under
> >> "Kernel hacking", but that didn=E2=80=99t make any difference either.
> >>
> >> Because of this, I ran "pktgen_sample01_simple.sh" and
> >> "pktgen_sample02_multiqueue.sh" on my AMD Ryzen 5 5600X system. The
> >> results were about 374 Kpps with TAP and 1192 Kpps with TAP+vhost_net,
> >> with very similar performance between the stock and patched kernels.
> >>
> >> Personally, I think the low performance is to blame on the hardware.
> >
> > Let's double confirm this by:
> >
> > 1) make sure pktgen is using 100% CPU
> > 2) Perf doesn't show anything strange for pktgen thread
> >
> > Thanks
> >
>
> I ran pktgen using pktgen_sample01_simple.sh and, in parallel, started a
> 100 second perf stat measurement covering all kpktgend threads.
>
> Across all configurations, a single CPU was fully utilized.
>
> Apart from that, the patched variants show a higher branch frequency and
> a slightly increased number of context switches.
>
>
> The detailed results are provided below:
>
> Processor: Ryzen 5 5600X
>
> pktgen command:
> sudo perf stat samples/pktgen/pktgen_sample01_simple.sh -i tap0 -m
> 52:54:00:12:34:56 -d 10.0.0.2 -n 10000000000
>
> perf stat command:
> sudo perf stat --timeout 100000 -p $(pgrep kpktgend | tr '\n' ,) -o X.txt
>
>
> Results:
> Stock TAP:
>             46.997      context-switches                 #    467,2 cs/se=
c  cs_per_second
>                  0      cpu-migrations                   #      0,0 migra=
tions/sec  migrations_per_second
>                  0      page-faults                      #      0,0 fault=
s/sec  page_faults_per_second
>         100.587,69 msec task-clock                       #      1,0 CPUs =
 CPUs_utilized
>      8.491.586.483      branch-misses                    #     10,9 %  br=
anch_miss_rate         (50,24%)
>     77.734.761.406      branches                         #    772,8 M/sec=
  branch_frequency     (66,85%)
>    382.420.291.585      cpu-cycles                       #      3,8 GHz  =
cycles_frequency       (66,85%)
>    377.612.185.141      instructions                     #      1,0 instr=
uctions  insn_per_cycle  (66,85%)
>     84.012.185.936      stalled-cycles-frontend          #     0,22 front=
end_cycles_idle        (66,35%)
>
>      100,100414494 seconds time elapsed
>
>
> Stock TAP+vhost-net:
>             47.087      context-switches                 #    468,1 cs/se=
c  cs_per_second
>                  0      cpu-migrations                   #      0,0 migra=
tions/sec  migrations_per_second
>                  0      page-faults                      #      0,0 fault=
s/sec  page_faults_per_second
>         100.594,09 msec task-clock                       #      1,0 CPUs =
 CPUs_utilized
>      8.034.703.613      branch-misses                    #     11,1 %  br=
anch_miss_rate         (50,24%)
>     72.477.989.922      branches                         #    720,5 M/sec=
  branch_frequency     (66,86%)
>    382.218.276.832      cpu-cycles                       #      3,8 GHz  =
cycles_frequency       (66,85%)
>    349.555.577.281      instructions                     #      0,9 instr=
uctions  insn_per_cycle  (66,85%)
>     83.917.644.262      stalled-cycles-frontend          #     0,22 front=
end_cycles_idle        (66,35%)
>
>      100,100520402 seconds time elapsed
>
>
> Patched TAP:
>             47.862      context-switches                 #    475,8 cs/se=
c  cs_per_second
>                  0      cpu-migrations                   #      0,0 migra=
tions/sec  migrations_per_second
>                  0      page-faults                      #      0,0 fault=
s/sec  page_faults_per_second
>         100.589,30 msec task-clock                       #      1,0 CPUs =
 CPUs_utilized
>      9.337.258.794      branch-misses                    #      9,4 %  br=
anch_miss_rate         (50,19%)
>     99.518.421.676      branches                         #    989,4 M/sec=
  branch_frequency     (66,85%)
>    382.508.244.894      cpu-cycles                       #      3,8 GHz  =
cycles_frequency       (66,85%)
>    312.582.270.975      instructions                     #      0,8 instr=
uctions  insn_per_cycle  (66,85%)
>     76.338.503.984      stalled-cycles-frontend          #     0,20 front=
end_cycles_idle        (66,39%)
>
>      100,101262454 seconds time elapsed
>
>
> Patched TAP+vhost-net:
>             47.892      context-switches                 #    476,1 cs/se=
c  cs_per_second
>                  0      cpu-migrations                   #      0,0 migra=
tions/sec  migrations_per_second
>                  0      page-faults                      #      0,0 fault=
s/sec  page_faults_per_second
>         100.581,95 msec task-clock                       #      1,0 CPUs =
 CPUs_utilized
>      9.083.588.313      branch-misses                    #     10,1 %  br=
anch_miss_rate         (50,28%)
>     90.300.124.712      branches                         #    897,8 M/sec=
  branch_frequency     (66,85%)
>    382.374.510.376      cpu-cycles                       #      3,8 GHz  =
cycles_frequency       (66,85%)
>    340.089.181.199      instructions                     #      0,9 instr=
uctions  insn_per_cycle  (66,85%)
>     78.151.408.955      stalled-cycles-frontend          #     0,20 front=
end_cycles_idle        (66,31%)
>
>      100,101212911 seconds time elapsed

Thanks for sharing. I have more questions:

1) The number of CPU and vCPUs
2) If you pin vhost or vCPU threads
3) what does perf top looks like or perf top -p $pid_of_vhost

>
> >>
> >> Thanks!
> >>
> >>>
> >>> Thanks
> >>>
> >>>>
> >>>> Thanks!
> >>>>
> >>>>>
> >>>>>>
> >>>>>> I'll still look into using an XDP program that does XDP_DROP in th=
e
> >>>>>> guest.
> >>>>>>
> >>>>>> Thanks!
> >>>>>
> >>>>> Thanks
> >>>>>
> >>>>>>
> >>>>>>>
> >>>>>>>>>
> >>>>>>>>> +------------------------+-------------+----------------+
> >>>>>>>>> | iperf3 TCP benchmarks  | Stock       | Patched with   |
> >>>>>>>>> | to Debian VM 120s      |             | fq_codel qdisc |
> >>>>>>>>> | vhost pinned to core 0 |             |                |
> >>>>>>>>> +------------------------+-------------+----------------+
> >>>>>>>>> | TAP                    | 22.0 Gbit/s | 22.0 Gbit/s    |
> >>>>>>>>> |  +                     |             |                |
> >>>>>>>>> | vhost-net              |             |                |
> >>>>>>>>> +------------------------+-------------+----------------+
> >>>>>>>>>
> >>>>>>>>> +---------------------------+-------------+----------------+
> >>>>>>>>> | iperf3 TCP benchmarks     | Stock       | Patched with   |
> >>>>>>>>> | to Debian VM 120s         |             | fq_codel qdisc |
> >>>>>>>>> | vhost pinned to core 0    |             |                |
> >>>>>>>>> | *4 iperf3 client threads* |             |                |
> >>>>>>>>> +---------------------------+-------------+----------------+
> >>>>>>>>> | TAP                       | 21.4 Gbit/s | 21.5 Gbit/s    |
> >>>>>>>>> |  +                        |             |                |
> >>>>>>>>> | vhost-net                 |             |                |
> >>>>>>>>> +---------------------------+-------------+----------------+
> >>>>>>>>
> >>>>>>>> What are your thoughts on this?
> >>>>>>>>
> >>>>>>>> Thanks!
> >>>>>>>>
> >>>>>>>>
> >>>>>>>
> >>>>>>> Thanks
> >>>>>>>
> >>>>>>
> >>>>>
> >>>>
> >>>
> >>
> >
>


