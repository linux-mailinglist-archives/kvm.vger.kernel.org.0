Return-Path: <kvm+bounces-69971-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wI46MGhwgWlLGQMAu9opvQ
	(envelope-from <kvm+bounces-69971-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 04:50:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D9B1D4386
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 04:50:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9567B3064E8F
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 03:49:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213C01C28E;
	Tue,  3 Feb 2026 03:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKgmJ1JB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="nbRfdM0b"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 473102F290A
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 03:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770090539; cv=pass; b=LDl/l9iikJVVBlXSAiu8vnCYOqTe5iksyULHG2XidJ3lcFtkdQNIdEGcnPzXZornb3Xp8+kGZL/5OHFpVxX8/URWbM6gzf3JQHW8nCc+Qmld6ntdXbGCLBNc2dDRqySaaMTmI3c//8amaBM9m4inPd3LHadeWPcx6QFAWbPst4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770090539; c=relaxed/simple;
	bh=Ab2Jstto+ny4j1NIR5kZUolDQEjl5APTwBJjwoHUpOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bXRWbigoF+Cbmqh5ZruPK3RatiqzxH6qMRD5NLtu5wQLeMMMbhW3dtQNYBbZNpBY8/UyuR1ixrfDhcwc716x3M6MCVNXW6ErV3TikLz04KF+KQkpCuKEw4djybgNzo4DHFJ7TvmJu9GrzfFdFrSxIonP+BFQDxwCg/yqTnGUnao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XKgmJ1JB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=nbRfdM0b; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770090536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w9Ma1r17hH/la3W1p6fFaX3L2SwJmH0RiR5aM5Sicfk=;
	b=XKgmJ1JBrb3jIQj0xUOSzyochMuo62B9af7SSRrTMT3BKCJ1qMLs1RYOEubeG+vGV8xRVk
	89TqpLtYlcSNwR1hvBFV/NCFgCWhwP9bs48+1MoGlNK1Of71/8O/cwBJdafQnezdx4xnrp
	gH2TBRbA7YMKUAiXJ/pQ+DUASJoru2M=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-UEZArXe4PBS5aUwvpA9BLQ-1; Mon, 02 Feb 2026 22:48:53 -0500
X-MC-Unique: UEZArXe4PBS5aUwvpA9BLQ-1
X-Mimecast-MFC-AGG-ID: UEZArXe4PBS5aUwvpA9BLQ_1770090533
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-34c2f670a06so5382354a91.3
        for <kvm@vger.kernel.org>; Mon, 02 Feb 2026 19:48:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770090532; cv=none;
        d=google.com; s=arc-20240605;
        b=PCidV/LpnPuiI44SDNFNalF3FVhz1drjjdVoekRxNSPDJx5IIfJBfPyO6vbP9HnIen
         SpSk8GVfuXmMnA48PkIydGXXhB+p5D9QDla2f8nyv9xJL5iEVQvt5E8PRKQkMplDH+OV
         Solz6fI+zL8jZ5JwVhTi7GworFCMfBJiH+JRbhitY8Q2fAemeihRWB+YKZN9Cfh8KTDj
         sa3R/hM2v6/2dUEIo+8W3G8agVsOnuBqq1Y7rLa51HFqtxckZkG23tJdeVgeGRDgWARi
         K36IsEV9+ztdxrpM3VeM3Af/YQ3QqFIhO55Se/YlmxARxyCezJQr2z/PmfcW2zYkUZwk
         qzsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w9Ma1r17hH/la3W1p6fFaX3L2SwJmH0RiR5aM5Sicfk=;
        fh=isRslbBnAQmViDjPaRViPK1LINv6fHU0i1lhVnHIL0o=;
        b=BCW7blauEUjXZIJaUmIYdvxV2XA/iFOxKV8XTcFdnHa7hPXw+2gg48bO0ecm+ytSKV
         EYcDMyPt0aqbN9yIZsaSTBzm19/PiCxxAggYS/tsE9sOoTidHNAcy3sB/LJsC0c2l14S
         9WKMZeVuFlkp8Y6de0TMoxBrZzTWZ1zFbiHuQddLOA5U6bvhZD3wOgZJ9kW8QmyN4d6A
         ZmkmVBnHMZ33tTNWTx+3stKy525qdx1uOVxCZ8XHlPL1iusFUs7SBpKL14QKeBKWVNnG
         DT8ugXAdlZHd0Tfw24J/os8tf/CaOdUonR4n0Hzwk4IizUAmPI9l3gk+zrJhqwN8F2th
         x3/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770090532; x=1770695332; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w9Ma1r17hH/la3W1p6fFaX3L2SwJmH0RiR5aM5Sicfk=;
        b=nbRfdM0bgyzURPyIOdE9md+pBNhdCBqJNFHPB8bYkX1cLT4UyWTcEVRB55Li70aO+Y
         SUas7+/x7U11NN0GRtGp+OJZLXbd5SDvwf82Vyxf7v2gD6irYROxLN5VpUBeb9/oZgv2
         GotSYxpNDOYm/A/OuZcg94CGcVi2qWVHBu+kncJdfDs+Srtud0a56d4o4uHHQzmpq5Lu
         KNQ3vuuW1bbbawELSvZGR09hkip3y90S+UXJodpxkSHFTDh6fayVJDxW8VGd7O8m9EJv
         CbdXb2TGFcHk1UjLG81Pj1LHmbHQYtDd5knWFSHRzN9qkEgkeOO57oBSgEL86B/FDKH1
         YshQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770090532; x=1770695332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w9Ma1r17hH/la3W1p6fFaX3L2SwJmH0RiR5aM5Sicfk=;
        b=kkF7rimszQnwYHENnGwJr2dbBfMnQ8xVSTLAGeMWH4QJbdj8eJm+LNT5UvZVu+QoiN
         mXMwgs00KXayVBES/KOGOS6if0IUfrAUGJLqKU969A5nkw+FH60HRV0aRCwU89bH2KBG
         Qj+BsVJFA3Vc1QpfivebYhGSwJXflEFfVQfu8OegSot/VWJtme6vEG+wc4pzv/usbOfc
         HTn+xnuJtOOQboFLpg3kBA/MitEBPpAfT7QemE+KOQpFh8RdHYq9qZYxUJLU+6N26zCM
         7zV0spftQmZbl2R2CT2tuXdXzt+NOF5yHMAeTTnXc1xz7va/48EFfF5HYCdtlvkug8Pb
         5lmw==
X-Forwarded-Encrypted: i=1; AJvYcCU8t9poSvHEauhoYmEU8JfOq3bucUCN4xruLStdPd8ncXSPDYprK3Uvm6xYF5z4ukxxV70=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmQPmQ/GrkWf9z08uwsZ1zC3bkNQ3Xpp2pjM7TXWMWraHuGkgI
	9iMfLNZtqAlLE18le3uGTaDQhTMXpylX64tnwgyvNcf6QtieTztDUTD4TEp0UfFmblxkKau6Deb
	LZzeBCL9U30/4KJmnm5P9MG+a3if9q59ucX7YpZJtCSNii2DMaVPWxXhPLhvUhkGc20CNraoF6p
	lMmirirz+3XmBoXPIwF4xh28yh92oL
X-Gm-Gg: AZuq6aJL72Ffu3VgwW7ChVXFn5hC/CPmvANCudbHr/VbZzxt/jSNX9VkfDgury1evqX
	eoN1E8VG/Q6c9uo5Em6Ih392a2LPhNZsJW2gi25OCxbjhz1uealYoEx/wVctXfqxxOv/aksQc3l
	Dq/u/6g39E9fMtoxLIxD/QyYbeXgxoTKAFZhD6vPbfzB0UlBeB/jdvShTwdvni1EWVdtQ=
X-Received: by 2002:a17:90b:2542:b0:34c:2db6:57a7 with SMTP id 98e67ed59e1d1-3543b2f7db5mr10729549a91.8.1770090532505;
        Mon, 02 Feb 2026 19:48:52 -0800 (PST)
X-Received: by 2002:a17:90b:2542:b0:34c:2db6:57a7 with SMTP id
 98e67ed59e1d1-3543b2f7db5mr10729530a91.8.1770090531977; Mon, 02 Feb 2026
 19:48:51 -0800 (PST)
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
 <CACGkMEv71kn91FPAUrxJg=YB3+B0MRTgOidMPHjK7Qq0WEhGtw@mail.gmail.com>
 <260f48cd-caa1-4684-a235-8e1192722b3a@tu-dortmund.de> <CACGkMEsVMz+vS3KxykYBGXvyt3MZcstnYWUiYJZhLSMoHC5Smw@mail.gmail.com>
 <ba17ba38-9f61-4a10-b375-d0da805e6b73@tu-dortmund.de> <CACGkMEtnLw2b8iDysQzRbXxTj2xbgzKqEZUbhmZz9tXPLTE6Sw@mail.gmail.com>
 <0ebc00ba-35e7-4570-a44f-b0ae634f2316@tu-dortmund.de>
In-Reply-To: <0ebc00ba-35e7-4570-a44f-b0ae634f2316@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 3 Feb 2026 11:48:40 +0800
X-Gm-Features: AZwV_QgBhOcRjgv5wyECAL_F6v-Now5vyuFfLWGnwHp0pRicaJytEMlvsNIh2zU
Message-ID: <CACGkMEsJtE3RehWQ8BaDL2HdFPK=iW+ZaEAN1TekAMWwor5tjQ@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69971-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,netdev];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,pktgen_sample03_burst_single_flow.sh:url,0.0.0.0:email,tu-dortmund.de:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,pktgen_sample02_multiqueue.sh:url]
X-Rspamd-Queue-Id: 2D9B1D4386
X-Rspamd-Action: no action

On Mon, Feb 2, 2026 at 4:19=E2=80=AFAM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> On 1/30/26 02:51, Jason Wang wrote:
> > On Thu, Jan 29, 2026 at 5:25=E2=80=AFPM Simon Schippers
> > <simon.schippers@tu-dortmund.de> wrote:
> >>
> >> On 1/29/26 02:14, Jason Wang wrote:
> >>> On Wed, Jan 28, 2026 at 3:54=E2=80=AFPM Simon Schippers
> >>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>
> >>>> On 1/28/26 08:03, Jason Wang wrote:
> >>>>> On Wed, Jan 28, 2026 at 12:48=E2=80=AFAM Simon Schippers
> >>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>
> >>>>>> On 1/23/26 10:54, Simon Schippers wrote:
> >>>>>>> On 1/23/26 04:05, Jason Wang wrote:
> >>>>>>>> On Thu, Jan 22, 2026 at 1:35=E2=80=AFPM Jason Wang <jasowang@red=
hat.com> wrote:
> >>>>>>>>>
> >>>>>>>>> On Wed, Jan 21, 2026 at 5:33=E2=80=AFPM Simon Schippers
> >>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>>>
> >>>>>>>>>> On 1/9/26 07:02, Jason Wang wrote:
> >>>>>>>>>>> On Thu, Jan 8, 2026 at 3:41=E2=80=AFPM Simon Schippers
> >>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>>>>>
> >>>>>>>>>>>> On 1/8/26 04:38, Jason Wang wrote:
> >>>>>>>>>>>>> On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> >>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr=
_ring_consume()
> >>>>>>>>>>>>>> and wake the corresponding netdev subqueue when consuming =
an entry frees
> >>>>>>>>>>>>>> space in the underlying ptr_ring.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Stopping of the netdev queue when the ptr_ring is full wil=
l be introduced
> >>>>>>>>>>>>>> in an upcoming commit.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>>>>>>>>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>>>>>>>>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmun=
d.de>
> >>>>>>>>>>>>>> ---
> >>>>>>>>>>>>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
> >>>>>>>>>>>>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
> >>>>>>>>>>>>>>  2 files changed, 45 insertions(+), 3 deletions(-)
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> >>>>>>>>>>>>>> index 1197f245e873..2442cf7ac385 100644
> >>>>>>>>>>>>>> --- a/drivers/net/tap.c
> >>>>>>>>>>>>>> +++ b/drivers/net/tap.c
> >>>>>>>>>>>>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct ta=
p_queue *q,
> >>>>>>>>>>>>>>         return ret ? ret : total;
> >>>>>>>>>>>>>>  }
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> +static void *tap_ring_consume(struct tap_queue *q)
> >>>>>>>>>>>>>> +{
> >>>>>>>>>>>>>> +       struct ptr_ring *ring =3D &q->ring;
> >>>>>>>>>>>>>> +       struct net_device *dev;
> >>>>>>>>>>>>>> +       void *ptr;
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_spa=
ce(ring, 1))) {
> >>>>>>>>>>>>>> +               rcu_read_lock();
> >>>>>>>>>>>>>> +               dev =3D rcu_dereference(q->tap)->dev;
> >>>>>>>>>>>>>> +               netif_wake_subqueue(dev, q->queue_index);
> >>>>>>>>>>>>>> +               rcu_read_unlock();
> >>>>>>>>>>>>>> +       }
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>> +       spin_unlock(&ring->consumer_lock);
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>> +       return ptr;
> >>>>>>>>>>>>>> +}
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>  static ssize_t tap_do_read(struct tap_queue *q,
> >>>>>>>>>>>>>>                            struct iov_iter *to,
> >>>>>>>>>>>>>>                            int noblock, struct sk_buff *sk=
b)
> >>>>>>>>>>>>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_=
queue *q,
> >>>>>>>>>>>>>>                                         TASK_INTERRUPTIBLE=
);
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>>                 /* Read frames from the queue */
> >>>>>>>>>>>>>> -               skb =3D ptr_ring_consume(&q->ring);
> >>>>>>>>>>>>>> +               skb =3D tap_ring_consume(q);
> >>>>>>>>>>>>>>                 if (skb)
> >>>>>>>>>>>>>>                         break;
> >>>>>>>>>>>>>>                 if (noblock) {
> >>>>>>>>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>>>>>>>>>>>> index 8192740357a0..7148f9a844a4 100644
> >>>>>>>>>>>>>> --- a/drivers/net/tun.c
> >>>>>>>>>>>>>> +++ b/drivers/net/tun.c
> >>>>>>>>>>>>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct=
 tun_struct *tun,
> >>>>>>>>>>>>>>         return total;
> >>>>>>>>>>>>>>  }
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> +static void *tun_ring_consume(struct tun_file *tfile)
> >>>>>>>>>>>>>> +{
> >>>>>>>>>>>>>> +       struct ptr_ring *ring =3D &tfile->tx_ring;
> >>>>>>>>>>>>>> +       struct net_device *dev;
> >>>>>>>>>>>>>> +       void *ptr;
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
> >>>>>>>>>>>>>> +
> >>>>>>>>>>>>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_spa=
ce(ring, 1))) {
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> I guess it's the "bug" I mentioned in the previous patch th=
at leads to
> >>>>>>>>>>>>> the check of __ptr_ring_consume_created_space() here. If it=
's true,
> >>>>>>>>>>>>> another call to tweak the current API.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>> +               rcu_read_lock();
> >>>>>>>>>>>>>> +               dev =3D rcu_dereference(tfile->tun)->dev;
> >>>>>>>>>>>>>> +               netif_wake_subqueue(dev, tfile->queue_inde=
x);
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> This would cause the producer TX_SOFTIRQ to run on the same=
 cpu which
> >>>>>>>>>>>>> I'm not sure is what we want.
> >>>>>>>>>>>>
> >>>>>>>>>>>> What else would you suggest calling to wake the queue?
> >>>>>>>>>>>
> >>>>>>>>>>> I don't have a good method in my mind, just want to point out=
 its implications.
> >>>>>>>>>>
> >>>>>>>>>> I have to admit I'm a bit stuck at this point, particularly wi=
th this
> >>>>>>>>>> aspect.
> >>>>>>>>>>
> >>>>>>>>>> What is the correct way to pass the producer CPU ID to the con=
sumer?
> >>>>>>>>>> Would it make sense to store smp_processor_id() in the tfile i=
nside
> >>>>>>>>>> tun_net_xmit(), or should it instead be stored in the skb (sim=
ilar to the
> >>>>>>>>>> XDP bit)? In the latter case, my concern is that this informat=
ion may
> >>>>>>>>>> already be significantly outdated by the time it is used.
> >>>>>>>>>>
> >>>>>>>>>> Based on that, my idea would be for the consumer to wake the p=
roducer by
> >>>>>>>>>> invoking a new function (e.g., tun_wake_queue()) on the produc=
er CPU via
> >>>>>>>>>> smp_call_function_single().
> >>>>>>>>>> Is this a reasonable approach?
> >>>>>>>>>
> >>>>>>>>> I'm not sure but it would introduce costs like IPI.
> >>>>>>>>>
> >>>>>>>>>>
> >>>>>>>>>> More generally, would triggering TX_SOFTIRQ on the consumer CP=
U be
> >>>>>>>>>> considered a deal-breaker for the patch set?
> >>>>>>>>>
> >>>>>>>>> It depends on whether or not it has effects on the performance.
> >>>>>>>>> Especially when vhost is pinned.
> >>>>>>>>
> >>>>>>>> I meant we can benchmark to see the impact. For example, pin vho=
st to
> >>>>>>>> a specific CPU and the try to see the impact of the TX_SOFTIRQ.
> >>>>>>>>
> >>>>>>>> Thanks
> >>>>>>>>
> >>>>>>>
> >>>>>>> I ran benchmarks with vhost pinned to CPU 0 using taskset -p -c 0=
 ...
> >>>>>>> for both the stock and patched versions. The benchmarks were run =
with
> >>>>>>> the full patch series applied, since testing only patches 1-3 wou=
ld not
> >>>>>>> be meaningful - the queue is never stopped in that case, so no
> >>>>>>> TX_SOFTIRQ is triggered.
> >>>>>>>
> >>>>>>> Compared to the non-pinned CPU benchmarks in the cover letter,
> >>>>>>> performance is lower for pktgen with a single thread but higher w=
ith
> >>>>>>> four threads. The results show no regression for the patched vers=
ion,
> >>>>>>> with even slight performance improvements observed:
> >>>>>>>
> >>>>>>> +-------------------------+-----------+----------------+
> >>>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
> >>>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
> >>>>>>> | 100M packets            |           |                |
> >>>>>>> | vhost pinned to core 0  |           |                |
> >>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>>> | TAP       | Transmitted | 452 Kpps  | 454 Kpps       |
> >>>>>>> |  +        +-------------+-----------+----------------+
> >>>>>>> | vhost-net | Lost        | 1154 Kpps | 0              |
> >>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>>>
> >>>>>>> +-------------------------+-----------+----------------+
> >>>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
> >>>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
> >>>>>>> | 100M packets            |           |                |
> >>>>>>> | vhost pinned to core 0  |           |                |
> >>>>>>> | *4 threads*             |           |                |
> >>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>>> | TAP       | Transmitted | 71 Kpps   | 79 Kpps        |
> >>>>>>> |  +        +-------------+-----------+----------------+
> >>>>>>> | vhost-net | Lost        | 1527 Kpps | 0              |
> >>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>
> >>>>> The PPS seems to be low. I'd suggest using testpmd (rxonly) mode in
> >>>>> the guest or an xdp program that did XDP_DROP in the guest.
> >>>>
> >>>> I forgot to mention that these PPS values are per thread.
> >>>> So overall we have 71 Kpps * 4 =3D 284 Kpps and 79 Kpps * 4 =3D 326 =
Kpps,
> >>>> respectively. For packet loss, that comes out to 1154 Kpps * 4 =3D
> >>>> 4616 Kpps and 0, respectively.
> >>>>
> >>>> Sorry about that!
> >>>>
> >>>> The pktgen benchmarks with a single thread look fine, right?
> >>>
> >>> Still looks very low. E.g I just have a run of pktgen (using
> >>> pktgen_sample03_burst_single_flow.sh) without a XDP_DROP in the guest=
,
> >>> I can get 1Mpps.
> >>
> >> Keep in mind that I am using an older CPU (i5-6300HQ). For the
> >> single-threaded tests I always used pktgen_sample01_simple.sh, and for
> >> the multi-threaded tests I always used pktgen_sample02_multiqueue.sh.
> >>
> >> Using pktgen_sample03_burst_single_flow.sh as you did fails for me (ev=
en
> >> though the same parameters work fine for sample01 and sample02):
> >>
> >> samples/pktgen/pktgen_sample03_burst_single_flow.sh -i tap0 -m
> >> 52:54:00:12:34:56 -d 10.0.0.2 -n 100000000
> >> /samples/pktgen/functions.sh: line 79: echo: write error: Operation no=
t
> >> supported
> >> ERROR: Write error(1) occurred
> >> cmd: "burst 32 > /proc/net/pktgen/tap0@0"
> >>
> >> ...and I do not know what I am doing wrong, even after looking at
> >> Documentation/networking/pktgen.rst. Every burst size except 1 fails.
> >> Any clues?
> >
> > Please use -b 0, and I'm Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz.
>
> I tried using "-b 0", and while it worked, there was no noticeable
> performance improvement.
>
> >
> > Another thing I can think of is to disable
> >
> > 1) mitigations in both guest and host
> > 2) any kernel debug features in both host and guest
>
> I also rebuilt the kernel with everything disabled under
> "Kernel hacking", but that didn=E2=80=99t make any difference either.
>
> Because of this, I ran "pktgen_sample01_simple.sh" and
> "pktgen_sample02_multiqueue.sh" on my AMD Ryzen 5 5600X system. The
> results were about 374 Kpps with TAP and 1192 Kpps with TAP+vhost_net,
> with very similar performance between the stock and patched kernels.
>
> Personally, I think the low performance is to blame on the hardware.

Let's double confirm this by:

1) make sure pktgen is using 100% CPU
2) Perf doesn't show anything strange for pktgen thread

Thanks

>
> Thanks!
>
> >
> > Thanks
> >
> >>
> >> Thanks!
> >>
> >>>
> >>>>
> >>>> I'll still look into using an XDP program that does XDP_DROP in the
> >>>> guest.
> >>>>
> >>>> Thanks!
> >>>
> >>> Thanks
> >>>
> >>>>
> >>>>>
> >>>>>>>
> >>>>>>> +------------------------+-------------+----------------+
> >>>>>>> | iperf3 TCP benchmarks  | Stock       | Patched with   |
> >>>>>>> | to Debian VM 120s      |             | fq_codel qdisc |
> >>>>>>> | vhost pinned to core 0 |             |                |
> >>>>>>> +------------------------+-------------+----------------+
> >>>>>>> | TAP                    | 22.0 Gbit/s | 22.0 Gbit/s    |
> >>>>>>> |  +                     |             |                |
> >>>>>>> | vhost-net              |             |                |
> >>>>>>> +------------------------+-------------+----------------+
> >>>>>>>
> >>>>>>> +---------------------------+-------------+----------------+
> >>>>>>> | iperf3 TCP benchmarks     | Stock       | Patched with   |
> >>>>>>> | to Debian VM 120s         |             | fq_codel qdisc |
> >>>>>>> | vhost pinned to core 0    |             |                |
> >>>>>>> | *4 iperf3 client threads* |             |                |
> >>>>>>> +---------------------------+-------------+----------------+
> >>>>>>> | TAP                       | 21.4 Gbit/s | 21.5 Gbit/s    |
> >>>>>>> |  +                        |             |                |
> >>>>>>> | vhost-net                 |             |                |
> >>>>>>> +---------------------------+-------------+----------------+
> >>>>>>
> >>>>>> What are your thoughts on this?
> >>>>>>
> >>>>>> Thanks!
> >>>>>>
> >>>>>>
> >>>>>
> >>>>> Thanks
> >>>>>
> >>>>
> >>>
> >>
> >
>


