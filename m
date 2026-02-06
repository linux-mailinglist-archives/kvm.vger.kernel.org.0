Return-Path: <kvm+bounces-70404-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6Lt1GHBfhWmfAgQAu9opvQ
	(envelope-from <kvm+bounces-70404-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 04:26:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AB39BF9B9C
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 04:26:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 762893047520
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 03:22:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB7E8330640;
	Fri,  6 Feb 2026 03:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ca7IhMRJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jdI4Broe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A184F330329
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 03:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770348122; cv=pass; b=qU8LsX6N2BoFE2ItxD+9gghzOIWYYmqZDKqHZJD9piVsJT/redUgd4eObjR9Df7Di8C7BYL+fnaJzxD7LT/f8Mu/eyfgpkzHes37yCpJt/VeBS9DVgIyBbsTewuJMPSVudClI5fP5B8NjQMYPyFNHPItjKAghKM+9KjUOknKUyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770348122; c=relaxed/simple;
	bh=lZZW9Vii1VFpI4TDAMDWIaqryqjNDiZqJ7sty/QtAcI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=arR7unumOI7j3ub2XHkB0wMywiOdz4PHPX0LzkKAyE5jin1iKY5JL1BeOFSgyeSrUiGb9lxEM9jNqR5rbWJqajFyUw7TqTGpbbBSxP94Npzpj4shMKT6tiD/7gDKXkciD1tSdLF07zD7UrMGGE8WOUI70/USoGQ462oeHnH9qMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ca7IhMRJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jdI4Broe; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770348120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M99Mi95Zasa6bhoPuEBTbJnUVbxC5rglrURO50gNl2A=;
	b=ca7IhMRJpNJUs7s3v5+0LtNtDEbLNc9MqoEZDlL+kkzF9/pq8J508lsAjm1dhstzMpPV7s
	8MhF1qzfvrPGRBbbUrgqy8p0fN1tW+KhQb2M/bVo+MtkEBz7cXhmyIEmOjsv5MCqpOGfkv
	wqWQwq6Bycb1zzI5bxUwX+UMB2hxLUw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-452-Q4qgMeCgPxSoLiu2-zmR1Q-1; Thu, 05 Feb 2026 22:21:59 -0500
X-MC-Unique: Q4qgMeCgPxSoLiu2-zmR1Q-1
X-Mimecast-MFC-AGG-ID: Q4qgMeCgPxSoLiu2-zmR1Q_1770348118
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a13cd9a784so2271695ad.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 19:21:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770348116; cv=none;
        d=google.com; s=arc-20240605;
        b=ZhE70AVPzrqkr0z3P4O3Zo6ujGRdQaHz2nqRj8hxVrV1EufZTHpMZmSS77fX5+CRES
         MukCfD8Njj9my4cIAIxNIXHQBk4qx42Rs1yqChS9aEGBYUx8ONqJGQ7DH+oKkLNYaGTf
         Ig8L06FvJtQvS8o+fvb6WTFWLyJ2D1VDTPygCD5TZ74tvG2OJl9prjcNXMxsZOKJV7yO
         vYCPiPYtkuN1Zr+1SK5OipddO1CnzqbhyjMIFnWU79g8Ws5q1Ov60lKdHtapX63gFZl5
         ql1KNpL20MlWwF6mif3tEYpLEstzAmFfHHwVctMKikI7r1tYmoaUiYt+BWNYTJhD3GrE
         dG6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M99Mi95Zasa6bhoPuEBTbJnUVbxC5rglrURO50gNl2A=;
        fh=nYJZfxo+SNqwANCobX2Hy84UH6MzyorSegm1h7Mtcg8=;
        b=B/js8tH14gOeaxGF7a2xo43RHR/spqxyhSX1IYYxAwsEqA9epOB2X/tOULQrUGpWkY
         6iXmWUH7OFTJkCqoJV6ytt/I6EwUXl98EL1Jv9byH19bFlxyX0RT7yLtuEpcsqXEU7Gj
         lGGVeCaRH7y27lsfmISkgQ6brbUlpJJ02XSM7ZyT0z7HbUvNcgkIvvqJHJ8271nKGjkP
         reqtO1x0LWJ3G40pEVU/YRR0ZGNDhP9ukqOd5qjj3bgpsEYXWAdCkHX4MLkJ+zSnwtDm
         /se2oLKtpfgo48lSSgMwkYpE64ojw3wYILXbncMvwKvCpcyML0ZYodAEXoziSi46nuc4
         CXmQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770348116; x=1770952916; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M99Mi95Zasa6bhoPuEBTbJnUVbxC5rglrURO50gNl2A=;
        b=jdI4BroerBtjIXnfHivnMIa4X7eWN0/POg66FjSBL/Q7OXolFhvzQ9skrP80Z10V5i
         HZpCvmlIn5ifTFz7QQJcy9UMFip1iOqM7UQD/36KvATltAS/hh46sj72VB+96bn1QpBd
         53wU2SRYKKagdkELziN/kOToxce/z8ZkpKrsB8yPfN0VVnd23RBdwyjJTJAJCqZFGhKR
         Zj4EmaQ8PcoB527wt9eBr2EmQZPkIxkvKz0q7J5+ZxLG3C00R8f8xXfe6bq6Jyoe4vg7
         BKdI0m0/pUV4T5jF6XvyyNEg4NehhOENAF1RGr8L7wSpeB6kHo9JRyvg+9ASPU4T8Yvv
         Bxrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770348116; x=1770952916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M99Mi95Zasa6bhoPuEBTbJnUVbxC5rglrURO50gNl2A=;
        b=DRBRJoA+Sfm+09SM+qjOKgnuLvUiSQo9+4Fxz6ou/U80YD12FAZf/BthCaSH8pYbXR
         xftqT5rH+Vt2M32A7rxlDS4JpTtX87ujx2y6i7rvO0PY1RB4TP/Ts0kOXZg/WGV/KjYC
         xZVL0aR7tZ3v9gHAoR44nkZYnGrjsNLXeRJgK6hdkcEqLiDlKeub5PWN+3ZnnBN8C0i/
         kf9E1Dd4aC0oMVuow1BJWA3mG6rr9hYBaYQCPx1EHJifhy8yYM61jTQku9GtwSiX/+Rb
         bvBOY8BboC8gP3XqDAlqBdT4i8SBd6PP8UIEdNPPmIbdbTN+uEnhzOcYo2KPDEZVWSJk
         96pQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDM/hsOyXm0CeCsLeWEvb9v+XKKFMOGlPF3hCVCqDsqEA7ZnK1mSePmEPI7g+G6PTWjEA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPi1HxA7OLOswPnFdQPjrziHvN3EEzq5j+WqBQGMwNNkNjSwea
	Zjd3HubE1724jdu+J1awiaa/sJ5A/Gj+U7f6IKsIAad77RksasteTd7faCmpzRW3VAaUzW5c/Az
	oEKj9rvXn7cfYbipV4MNKWv2WtSOOoWsVPu56fUMwjRf7oN+0RakPHMuMTyVq407kDvsSLgjsWw
	d+X46rGAnR6qiqV/irgPlBaLQyM9EH
X-Gm-Gg: AZuq6aIdYU5SlQ1Ulw2oZWddWaaU8ly9AibVmMqHrPbDD9z6+pQSwiflL3LgAHQT974
	wDmJITOyAnJ6AfjB0iyUJlVbW1NTBfcwV/8+F1eLAEWR/W3aMTEkJSKn+rpSMABlp/qlB/Rjzm2
	sPb/InfpJIzEXc8h8xKkwKBOJiEpSl58e7ZxpTpcPGgEAZPhSId8mxt4x5q67DUZfmnw==
X-Received: by 2002:a17:902:ecd2:b0:29d:9f5a:e0d1 with SMTP id d9443c01a7336-2a9516c183cmr14970635ad.27.1770348116102;
        Thu, 05 Feb 2026 19:21:56 -0800 (PST)
X-Received: by 2002:a17:902:ecd2:b0:29d:9f5a:e0d1 with SMTP id
 d9443c01a7336-2a9516c183cmr14970275ad.27.1770348115508; Thu, 05 Feb 2026
 19:21:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <CACGkMEtzD3ORJuJcc8VeqwASiGeVFdQmJowsK6PYVEF_Zkcn8Q@mail.gmail.com>
 <afa40345-acbe-42b0-81d1-0a838343792d@tu-dortmund.de> <CACGkMEtxRoavBMTXom8Z=FM-pvu3pHbsuwCs+e450b1B=V7iWA@mail.gmail.com>
 <CACGkMEsJKeEsH=G8H5RzMNHY4g3HNdciMDMhciShawh-9Xb9hg@mail.gmail.com>
 <bc1078e5-65fc-4de6-8475-517f626d8d96@tu-dortmund.de> <3a1d6232-efe4-4e79-a196-44794fdc0f33@tu-dortmund.de>
 <CACGkMEv71kn91FPAUrxJg=YB3+B0MRTgOidMPHjK7Qq0WEhGtw@mail.gmail.com>
 <260f48cd-caa1-4684-a235-8e1192722b3a@tu-dortmund.de> <CACGkMEsVMz+vS3KxykYBGXvyt3MZcstnYWUiYJZhLSMoHC5Smw@mail.gmail.com>
 <ba17ba38-9f61-4a10-b375-d0da805e6b73@tu-dortmund.de> <CACGkMEtnLw2b8iDysQzRbXxTj2xbgzKqEZUbhmZz9tXPLTE6Sw@mail.gmail.com>
 <0ebc00ba-35e7-4570-a44f-b0ae634f2316@tu-dortmund.de> <CACGkMEsJtE3RehWQ8BaDL2HdFPK=iW+ZaEAN1TekAMWwor5tjQ@mail.gmail.com>
 <197573a1-df52-4928-adb9-55a7a4f78839@tu-dortmund.de> <CACGkMEveEXky_rTrvRrfi7qix12GG91GfyqnwB6Tu-dnjqAm9A@mail.gmail.com>
 <0c776172-2f02-47fc-babf-2871adca42cb@tu-dortmund.de>
In-Reply-To: <0c776172-2f02-47fc-babf-2871adca42cb@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 6 Feb 2026 11:21:43 +0800
X-Gm-Features: AZwV_QhOOvxaUaSKQoSsZxYqMN518rDjxRQhhRg2CKYw_iMZKX9o_lAS42RxkDg
Message-ID: <CACGkMEte=LwvkxPh-tesJHLVYQV1YZF4is1Yamokhkzaf5GOWw@mail.gmail.com>
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
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,redhat.com,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	TAGGED_FROM(0.00)[bounces-70404-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jasowang@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_PROHIBIT(0.00)[0.0.0.0:email];
	TAGGED_RCPT(0.00)[kvm,netdev];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,pktgen_sample02_multiqueue.sh:url,pktgen_sample01_simple.sh:url,tu-dortmund.de:email]
X-Rspamd-Queue-Id: AB39BF9B9C
X-Rspamd-Action: no action

On Fri, Feb 6, 2026 at 6:28=E2=80=AFAM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> On 2/5/26 04:59, Jason Wang wrote:
> > On Wed, Feb 4, 2026 at 11:44=E2=80=AFPM Simon Schippers
> > <simon.schippers@tu-dortmund.de> wrote:
> >>
> >> On 2/3/26 04:48, Jason Wang wrote:
> >>> On Mon, Feb 2, 2026 at 4:19=E2=80=AFAM Simon Schippers
> >>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>
> >>>> On 1/30/26 02:51, Jason Wang wrote:
> >>>>> On Thu, Jan 29, 2026 at 5:25=E2=80=AFPM Simon Schippers
> >>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>
> >>>>>> On 1/29/26 02:14, Jason Wang wrote:
> >>>>>>> On Wed, Jan 28, 2026 at 3:54=E2=80=AFPM Simon Schippers
> >>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>
> >>>>>>>> On 1/28/26 08:03, Jason Wang wrote:
> >>>>>>>>> On Wed, Jan 28, 2026 at 12:48=E2=80=AFAM Simon Schippers
> >>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>>>
> >>>>>>>>>> On 1/23/26 10:54, Simon Schippers wrote:
> >>>>>>>>>>> On 1/23/26 04:05, Jason Wang wrote:
> >>>>>>>>>>>> On Thu, Jan 22, 2026 at 1:35=E2=80=AFPM Jason Wang <jasowang=
@redhat.com> wrote:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> On Wed, Jan 21, 2026 at 5:33=E2=80=AFPM Simon Schippers
> >>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> On 1/9/26 07:02, Jason Wang wrote:
> >>>>>>>>>>>>>>> On Thu, Jan 8, 2026 at 3:41=E2=80=AFPM Simon Schippers
> >>>>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> On 1/8/26 04:38, Jason Wang wrote:
> >>>>>>>>>>>>>>>>> On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> >>>>>>>>>>>>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>> Introduce {tun,tap}_ring_consume() helpers that wrap _=
_ptr_ring_consume()
> >>>>>>>>>>>>>>>>>> and wake the corresponding netdev subqueue when consum=
ing an entry frees
> >>>>>>>>>>>>>>>>>> space in the underlying ptr_ring.
> >>>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>> Stopping of the netdev queue when the ptr_ring is full=
 will be introduced
> >>>>>>>>>>>>>>>>>> in an upcoming commit.
> >>>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.=
de>
> >>>>>>>>>>>>>>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de=
>
> >>>>>>>>>>>>>>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dor=
tmund.de>
> >>>>>>>>>>>>>>>>>> ---
> >>>>>>>>>>>>>>>>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
> >>>>>>>>>>>>>>>>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
> >>>>>>>>>>>>>>>>>>  2 files changed, 45 insertions(+), 3 deletions(-)
> >>>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> >>>>>>>>>>>>>>>>>> index 1197f245e873..2442cf7ac385 100644
> >>>>>>>>>>>>>>>>>> --- a/drivers/net/tap.c
> >>>>>>>>>>>>>>>>>> +++ b/drivers/net/tap.c
> >>>>>>>>>>>>>>>>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struc=
t tap_queue *q,
> >>>>>>>>>>>>>>>>>>         return ret ? ret : total;
> >>>>>>>>>>>>>>>>>>  }
> >>>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>> +static void *tap_ring_consume(struct tap_queue *q)
> >>>>>>>>>>>>>>>>>> +{
> >>>>>>>>>>>>>>>>>> +       struct ptr_ring *ring =3D &q->ring;
> >>>>>>>>>>>>>>>>>> +       struct net_device *dev;
> >>>>>>>>>>>>>>>>>> +       void *ptr;
> >>>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
> >>>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>>>>>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created=
_space(ring, 1))) {
> >>>>>>>>>>>>>>>>>> +               rcu_read_lock();
> >>>>>>>>>>>>>>>>>> +               dev =3D rcu_dereference(q->tap)->dev;
> >>>>>>>>>>>>>>>>>> +               netif_wake_subqueue(dev, q->queue_inde=
x);
> >>>>>>>>>>>>>>>>>> +               rcu_read_unlock();
> >>>>>>>>>>>>>>>>>> +       }
> >>>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>>> +       spin_unlock(&ring->consumer_lock);
> >>>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>>> +       return ptr;
> >>>>>>>>>>>>>>>>>> +}
> >>>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>>>  static ssize_t tap_do_read(struct tap_queue *q,
> >>>>>>>>>>>>>>>>>>                            struct iov_iter *to,
> >>>>>>>>>>>>>>>>>>                            int noblock, struct sk_buff=
 *skb)
> >>>>>>>>>>>>>>>>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct =
tap_queue *q,
> >>>>>>>>>>>>>>>>>>                                         TASK_INTERRUPT=
IBLE);
> >>>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>>                 /* Read frames from the queue */
> >>>>>>>>>>>>>>>>>> -               skb =3D ptr_ring_consume(&q->ring);
> >>>>>>>>>>>>>>>>>> +               skb =3D tap_ring_consume(q);
> >>>>>>>>>>>>>>>>>>                 if (skb)
> >>>>>>>>>>>>>>>>>>                         break;
> >>>>>>>>>>>>>>>>>>                 if (noblock) {
> >>>>>>>>>>>>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>>>>>>>>>>>>>>>> index 8192740357a0..7148f9a844a4 100644
> >>>>>>>>>>>>>>>>>> --- a/drivers/net/tun.c
> >>>>>>>>>>>>>>>>>> +++ b/drivers/net/tun.c
> >>>>>>>>>>>>>>>>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(st=
ruct tun_struct *tun,
> >>>>>>>>>>>>>>>>>>         return total;
> >>>>>>>>>>>>>>>>>>  }
> >>>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>> +static void *tun_ring_consume(struct tun_file *tfile)
> >>>>>>>>>>>>>>>>>> +{
> >>>>>>>>>>>>>>>>>> +       struct ptr_ring *ring =3D &tfile->tx_ring;
> >>>>>>>>>>>>>>>>>> +       struct net_device *dev;
> >>>>>>>>>>>>>>>>>> +       void *ptr;
> >>>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>>> +       spin_lock(&ring->consumer_lock);
> >>>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>>>>>>>>>>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created=
_space(ring, 1))) {
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> I guess it's the "bug" I mentioned in the previous patc=
h that leads to
> >>>>>>>>>>>>>>>>> the check of __ptr_ring_consume_created_space() here. I=
f it's true,
> >>>>>>>>>>>>>>>>> another call to tweak the current API.
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>> +               rcu_read_lock();
> >>>>>>>>>>>>>>>>>> +               dev =3D rcu_dereference(tfile->tun)->d=
ev;
> >>>>>>>>>>>>>>>>>> +               netif_wake_subqueue(dev, tfile->queue_=
index);
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> This would cause the producer TX_SOFTIRQ to run on the =
same cpu which
> >>>>>>>>>>>>>>>>> I'm not sure is what we want.
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> What else would you suggest calling to wake the queue?
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> I don't have a good method in my mind, just want to point=
 out its implications.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> I have to admit I'm a bit stuck at this point, particularl=
y with this
> >>>>>>>>>>>>>> aspect.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> What is the correct way to pass the producer CPU ID to the=
 consumer?
> >>>>>>>>>>>>>> Would it make sense to store smp_processor_id() in the tfi=
le inside
> >>>>>>>>>>>>>> tun_net_xmit(), or should it instead be stored in the skb =
(similar to the
> >>>>>>>>>>>>>> XDP bit)? In the latter case, my concern is that this info=
rmation may
> >>>>>>>>>>>>>> already be significantly outdated by the time it is used.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Based on that, my idea would be for the consumer to wake t=
he producer by
> >>>>>>>>>>>>>> invoking a new function (e.g., tun_wake_queue()) on the pr=
oducer CPU via
> >>>>>>>>>>>>>> smp_call_function_single().
> >>>>>>>>>>>>>> Is this a reasonable approach?
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> I'm not sure but it would introduce costs like IPI.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> More generally, would triggering TX_SOFTIRQ on the consume=
r CPU be
> >>>>>>>>>>>>>> considered a deal-breaker for the patch set?
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> It depends on whether or not it has effects on the performa=
nce.
> >>>>>>>>>>>>> Especially when vhost is pinned.
> >>>>>>>>>>>>
> >>>>>>>>>>>> I meant we can benchmark to see the impact. For example, pin=
 vhost to
> >>>>>>>>>>>> a specific CPU and the try to see the impact of the TX_SOFTI=
RQ.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Thanks
> >>>>>>>>>>>>
> >>>>>>>>>>>
> >>>>>>>>>>> I ran benchmarks with vhost pinned to CPU 0 using taskset -p =
-c 0 ...
> >>>>>>>>>>> for both the stock and patched versions. The benchmarks were =
run with
> >>>>>>>>>>> the full patch series applied, since testing only patches 1-3=
 would not
> >>>>>>>>>>> be meaningful - the queue is never stopped in that case, so n=
o
> >>>>>>>>>>> TX_SOFTIRQ is triggered.
> >>>>>>>>>>>
> >>>>>>>>>>> Compared to the non-pinned CPU benchmarks in the cover letter=
,
> >>>>>>>>>>> performance is lower for pktgen with a single thread but high=
er with
> >>>>>>>>>>> four threads. The results show no regression for the patched =
version,
> >>>>>>>>>>> with even slight performance improvements observed:
> >>>>>>>>>>>
> >>>>>>>>>>> +-------------------------+-----------+----------------+
> >>>>>>>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
> >>>>>>>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
> >>>>>>>>>>> | 100M packets            |           |                |
> >>>>>>>>>>> | vhost pinned to core 0  |           |                |
> >>>>>>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>>>>>>> | TAP       | Transmitted | 452 Kpps  | 454 Kpps       |
> >>>>>>>>>>> |  +        +-------------+-----------+----------------+
> >>>>>>>>>>> | vhost-net | Lost        | 1154 Kpps | 0              |
> >>>>>>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>>>>>>>
> >>>>>>>>>>> +-------------------------+-----------+----------------+
> >>>>>>>>>>> | pktgen benchmarks to    | Stock     | Patched with   |
> >>>>>>>>>>> | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
> >>>>>>>>>>> | 100M packets            |           |                |
> >>>>>>>>>>> | vhost pinned to core 0  |           |                |
> >>>>>>>>>>> | *4 threads*             |           |                |
> >>>>>>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>>>>>>> | TAP       | Transmitted | 71 Kpps   | 79 Kpps        |
> >>>>>>>>>>> |  +        +-------------+-----------+----------------+
> >>>>>>>>>>> | vhost-net | Lost        | 1527 Kpps | 0              |
> >>>>>>>>>>> +-----------+-------------+-----------+----------------+
> >>>>>>>>>
> >>>>>>>>> The PPS seems to be low. I'd suggest using testpmd (rxonly) mod=
e in
> >>>>>>>>> the guest or an xdp program that did XDP_DROP in the guest.
> >>>>>>>>
> >>>>>>>> I forgot to mention that these PPS values are per thread.
> >>>>>>>> So overall we have 71 Kpps * 4 =3D 284 Kpps and 79 Kpps * 4 =3D =
326 Kpps,
> >>>>>>>> respectively. For packet loss, that comes out to 1154 Kpps * 4 =
=3D
> >>>>>>>> 4616 Kpps and 0, respectively.
> >>>>>>>>
> >>>>>>>> Sorry about that!
> >>>>>>>>
> >>>>>>>> The pktgen benchmarks with a single thread look fine, right?
> >>>>>>>
> >>>>>>> Still looks very low. E.g I just have a run of pktgen (using
> >>>>>>> pktgen_sample03_burst_single_flow.sh) without a XDP_DROP in the g=
uest,
> >>>>>>> I can get 1Mpps.
> >>>>>>
> >>>>>> Keep in mind that I am using an older CPU (i5-6300HQ). For the
> >>>>>> single-threaded tests I always used pktgen_sample01_simple.sh, and=
 for
> >>>>>> the multi-threaded tests I always used pktgen_sample02_multiqueue.=
sh.
> >>>>>>
> >>>>>> Using pktgen_sample03_burst_single_flow.sh as you did fails for me=
 (even
> >>>>>> though the same parameters work fine for sample01 and sample02):
> >>>>>>
> >>>>>> samples/pktgen/pktgen_sample03_burst_single_flow.sh -i tap0 -m
> >>>>>> 52:54:00:12:34:56 -d 10.0.0.2 -n 100000000
> >>>>>> /samples/pktgen/functions.sh: line 79: echo: write error: Operatio=
n not
> >>>>>> supported
> >>>>>> ERROR: Write error(1) occurred
> >>>>>> cmd: "burst 32 > /proc/net/pktgen/tap0@0"
> >>>>>>
> >>>>>> ...and I do not know what I am doing wrong, even after looking at
> >>>>>> Documentation/networking/pktgen.rst. Every burst size except 1 fai=
ls.
> >>>>>> Any clues?
> >>>>>
> >>>>> Please use -b 0, and I'm Intel(R) Core(TM) i7-8650U CPU @ 1.90GHz.
> >>>>
> >>>> I tried using "-b 0", and while it worked, there was no noticeable
> >>>> performance improvement.
> >>>>
> >>>>>
> >>>>> Another thing I can think of is to disable
> >>>>>
> >>>>> 1) mitigations in both guest and host
> >>>>> 2) any kernel debug features in both host and guest
> >>>>
> >>>> I also rebuilt the kernel with everything disabled under
> >>>> "Kernel hacking", but that didn=E2=80=99t make any difference either=
.
> >>>>
> >>>> Because of this, I ran "pktgen_sample01_simple.sh" and
> >>>> "pktgen_sample02_multiqueue.sh" on my AMD Ryzen 5 5600X system. The
> >>>> results were about 374 Kpps with TAP and 1192 Kpps with TAP+vhost_ne=
t,
> >>>> with very similar performance between the stock and patched kernels.
> >>>>
> >>>> Personally, I think the low performance is to blame on the hardware.
> >>>
> >>> Let's double confirm this by:
> >>>
> >>> 1) make sure pktgen is using 100% CPU
> >>> 2) Perf doesn't show anything strange for pktgen thread
> >>>
> >>> Thanks
> >>>
> >>
> >> I ran pktgen using pktgen_sample01_simple.sh and, in parallel, started=
 a
> >> 100 second perf stat measurement covering all kpktgend threads.
> >>
> >> Across all configurations, a single CPU was fully utilized.
> >>
> >> Apart from that, the patched variants show a higher branch frequency a=
nd
> >> a slightly increased number of context switches.
> >>
> >>
> >> The detailed results are provided below:
> >>
> >> Processor: Ryzen 5 5600X
> >>
> >> pktgen command:
> >> sudo perf stat samples/pktgen/pktgen_sample01_simple.sh -i tap0 -m
> >> 52:54:00:12:34:56 -d 10.0.0.2 -n 10000000000
> >>
> >> perf stat command:
> >> sudo perf stat --timeout 100000 -p $(pgrep kpktgend | tr '\n' ,) -o X.=
txt
> >>
> >>
> >> Results:
> >> Stock TAP:
> >>             46.997      context-switches                 #    467,2 cs=
/sec  cs_per_second
> >>                  0      cpu-migrations                   #      0,0 mi=
grations/sec  migrations_per_second
> >>                  0      page-faults                      #      0,0 fa=
ults/sec  page_faults_per_second
> >>         100.587,69 msec task-clock                       #      1,0 CP=
Us  CPUs_utilized
> >>      8.491.586.483      branch-misses                    #     10,9 % =
 branch_miss_rate         (50,24%)
> >>     77.734.761.406      branches                         #    772,8 M/=
sec  branch_frequency     (66,85%)
> >>    382.420.291.585      cpu-cycles                       #      3,8 GH=
z  cycles_frequency       (66,85%)
> >>    377.612.185.141      instructions                     #      1,0 in=
structions  insn_per_cycle  (66,85%)
> >>     84.012.185.936      stalled-cycles-frontend          #     0,22 fr=
ontend_cycles_idle        (66,35%)
> >>
> >>      100,100414494 seconds time elapsed
> >>
> >>
> >> Stock TAP+vhost-net:
> >>             47.087      context-switches                 #    468,1 cs=
/sec  cs_per_second
> >>                  0      cpu-migrations                   #      0,0 mi=
grations/sec  migrations_per_second
> >>                  0      page-faults                      #      0,0 fa=
ults/sec  page_faults_per_second
> >>         100.594,09 msec task-clock                       #      1,0 CP=
Us  CPUs_utilized
> >>      8.034.703.613      branch-misses                    #     11,1 % =
 branch_miss_rate         (50,24%)
> >>     72.477.989.922      branches                         #    720,5 M/=
sec  branch_frequency     (66,86%)
> >>    382.218.276.832      cpu-cycles                       #      3,8 GH=
z  cycles_frequency       (66,85%)
> >>    349.555.577.281      instructions                     #      0,9 in=
structions  insn_per_cycle  (66,85%)
> >>     83.917.644.262      stalled-cycles-frontend          #     0,22 fr=
ontend_cycles_idle        (66,35%)
> >>
> >>      100,100520402 seconds time elapsed
> >>
> >>
> >> Patched TAP:
> >>             47.862      context-switches                 #    475,8 cs=
/sec  cs_per_second
> >>                  0      cpu-migrations                   #      0,0 mi=
grations/sec  migrations_per_second
> >>                  0      page-faults                      #      0,0 fa=
ults/sec  page_faults_per_second
> >>         100.589,30 msec task-clock                       #      1,0 CP=
Us  CPUs_utilized
> >>      9.337.258.794      branch-misses                    #      9,4 % =
 branch_miss_rate         (50,19%)
> >>     99.518.421.676      branches                         #    989,4 M/=
sec  branch_frequency     (66,85%)
> >>    382.508.244.894      cpu-cycles                       #      3,8 GH=
z  cycles_frequency       (66,85%)
> >>    312.582.270.975      instructions                     #      0,8 in=
structions  insn_per_cycle  (66,85%)
> >>     76.338.503.984      stalled-cycles-frontend          #     0,20 fr=
ontend_cycles_idle        (66,39%)
> >>
> >>      100,101262454 seconds time elapsed
> >>
> >>
> >> Patched TAP+vhost-net:
> >>             47.892      context-switches                 #    476,1 cs=
/sec  cs_per_second
> >>                  0      cpu-migrations                   #      0,0 mi=
grations/sec  migrations_per_second
> >>                  0      page-faults                      #      0,0 fa=
ults/sec  page_faults_per_second
> >>         100.581,95 msec task-clock                       #      1,0 CP=
Us  CPUs_utilized
> >>      9.083.588.313      branch-misses                    #     10,1 % =
 branch_miss_rate         (50,28%)
> >>     90.300.124.712      branches                         #    897,8 M/=
sec  branch_frequency     (66,85%)
> >>    382.374.510.376      cpu-cycles                       #      3,8 GH=
z  cycles_frequency       (66,85%)
> >>    340.089.181.199      instructions                     #      0,9 in=
structions  insn_per_cycle  (66,85%)
> >>     78.151.408.955      stalled-cycles-frontend          #     0,20 fr=
ontend_cycles_idle        (66,31%)
> >>
> >>      100,101212911 seconds time elapsed
> >
> > Thanks for sharing. I have more questions:
> >
> > 1) The number of CPU and vCPUs
>
> qemu runs with a single core. And my host system is now a Ryzen 5 5600x
> with 6 cores, 12 threads.
> This is my command for TAP+vhost-net:
>
> sudo qemu-system-x86_64 -hda debian.qcow2
> -netdev tap,id=3Dmynet0,ifname=3Dtap0,script=3Dno,downscript=3Dno,vhost=
=3Don
> -device virtio-net-pci,netdev=3Dmynet0 -m 1024 -enable-kvm
>
> For TAP only it is the same but without vhost=3Don.
>
> > 2) If you pin vhost or vCPU threads
>
> Not in the previous shown benchmark. I pinned vhost in other benchmarks
> but since there is only minor PPS difference I omitted for the sake of
> simplicity.
>
> > 3) what does perf top looks like or perf top -p $pid_of_vhost
>
> The perf reports for the pid_of_vhost from pktgen_sample01_simple.sh
> with TAP+vhost-net (not pinned, pktgen single queue, fq_codel) are shown
> below. I can not see a huge difference between stock and patched.
>
> Also I included perf reports from the pktgen_pids. I find them more
> intersting because tun_net_xmit shows less overhead for the patched.
> I assume that is due to the stopped netdev queue.
>
> I have now benchmarked pretty much all possible combinations (with a
> script) of TAP/TAP+vhost-net, single/multi-queue pktgen, vhost
> pinned/not pinned, with/without -b 0, fq_codel/noqueue... All of that
> with perf records..
> I could share them if you want but I feel this is getting out of hand.
>
>
> Stock:
> sudo perf record -p "$vhost_pid"
> ...
> # Overhead  Command          Shared Object               Symbol
> # ........  ...............  ..........................  ................=
..........................
> #
>      5.97%  vhost-4874       [kernel.kallsyms]           [k] _copy_to_ite=
r
>      2.68%  vhost-4874       [kernel.kallsyms]           [k] tun_do_read
>      2.23%  vhost-4874       [kernel.kallsyms]           [k] native_write=
_msr
>      1.93%  vhost-4874       [kernel.kallsyms]           [k] __check_obje=
ct_size

Let's disable CONFIG_HARDENED_USERCOPY and retry.

>      1.61%  vhost-4874       [kernel.kallsyms]           [k] __slab_free.=
isra.0
>      1.56%  vhost-4874       [kernel.kallsyms]           [k] __get_user_n=
ocheck_2
>      1.54%  vhost-4874       [kernel.kallsyms]           [k] iov_iter_zer=
o
>      1.45%  vhost-4874       [kernel.kallsyms]           [k] kmem_cache_f=
ree
>      1.43%  vhost-4874       [kernel.kallsyms]           [k] tun_recvmsg
>      1.24%  vhost-4874       [kernel.kallsyms]           [k] sk_skb_reaso=
n_drop
>      1.12%  vhost-4874       [kernel.kallsyms]           [k] srso_alias_s=
afe_ret
>      1.07%  vhost-4874       [kernel.kallsyms]           [k] native_read_=
msr
>      0.76%  vhost-4874       [kernel.kallsyms]           [k] simple_copy_=
to_iter
>      0.75%  vhost-4874       [kernel.kallsyms]           [k] srso_alias_r=
eturn_thunk
>      0.69%  vhost-4874       [vhost]                     [k] 0x0000000000=
002e70
>      0.59%  vhost-4874       [kernel.kallsyms]           [k] skb_release_=
data
>      0.59%  vhost-4874       [kernel.kallsyms]           [k] __skb_datagr=
am_iter
>      0.53%  vhost-4874       [vhost]                     [k] 0x0000000000=
002e5f
>      0.51%  vhost-4874       [kernel.kallsyms]           [k] slab_update_=
freelist.isra.0
>      0.46%  vhost-4874       [kernel.kallsyms]           [k] kfree_skbmem
>      0.44%  vhost-4874       [kernel.kallsyms]           [k] skb_copy_dat=
agram_iter
>      0.43%  vhost-4874       [kernel.kallsyms]           [k] skb_free_hea=
d
>      0.37%  qemu-system-x86  [unknown]                   [k] 0xffffffffba=
898b1b
>      0.35%  vhost-4874       [vhost]                     [k] 0x0000000000=
002e6b
>      0.33%  vhost-4874       [vhost_net]                 [k] 0x0000000000=
00357d
>      0.28%  vhost-4874       [kernel.kallsyms]           [k] __check_heap=
_object
>      0.27%  vhost-4874       [vhost_net]                 [k] 0x0000000000=
0035f3
>      0.26%  vhost-4874       [vhost_net]                 [k] 0x0000000000=
0030f6
>      0.26%  vhost-4874       [kernel.kallsyms]           [k] __virt_addr_=
valid
>      0.24%  vhost-4874       [kernel.kallsyms]           [k] iov_iter_adv=
ance
>      0.22%  vhost-4874       [kernel.kallsyms]           [k] perf_event_u=
pdate_userpage
>      0.22%  vhost-4874       [kernel.kallsyms]           [k] check_stack_=
object
>      0.19%  qemu-system-x86  [unknown]                   [k] 0xffffffffba=
2a68cd
>      0.19%  vhost-4874       [kernel.kallsyms]           [k] dequeue_enti=
ties
>      0.19%  vhost-4874       [vhost_net]                 [k] 0x0000000000=
003237
>      0.18%  vhost-4874       [vhost_net]                 [k] 0x0000000000=
003550
>      0.18%  vhost-4874       [kernel.kallsyms]           [k] x86_pmu_del
>      0.18%  vhost-4874       [vhost_net]                 [k] 0x0000000000=
0034a0
>      0.17%  vhost-4874       [kernel.kallsyms]           [k] x86_pmu_disa=
ble_all
>      0.16%  vhost-4874       [vhost_net]                 [k] 0x0000000000=
003523
>      0.16%  vhost-4874       [kernel.kallsyms]           [k] amd_pmu_addr=
_offset
> ...
>
>
> sudo perf record -p "$kpktgend_pids":
> ...
> # Overhead  Command      Shared Object      Symbol
> # ........  ...........  .................  .............................=
..................
> #
>     10.98%  kpktgend_0   [kernel.kallsyms]  [k] tun_net_xmit
>     10.45%  kpktgend_0   [kernel.kallsyms]  [k] memset
>      8.40%  kpktgend_0   [kernel.kallsyms]  [k] __alloc_skb
>      6.31%  kpktgend_0   [kernel.kallsyms]  [k] kmem_cache_alloc_node_nop=
rof
>      3.13%  kpktgend_0   [kernel.kallsyms]  [k] srso_alias_safe_ret
>      2.40%  kpktgend_0   [kernel.kallsyms]  [k] sk_skb_reason_drop
>      2.11%  kpktgend_0   [kernel.kallsyms]  [k] srso_alias_return_thunk

This is a hint that SRSO migitaion is enabled.

Have you disabled CPU_MITIGATIONS via either Kconfig or kernel command
line (mitigations =3D off) for both host and guest?

Thanks


