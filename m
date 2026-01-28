Return-Path: <kvm+bounces-69332-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aMT0Lsm0eWk0ygEAu9opvQ
	(envelope-from <kvm+bounces-69332-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 08:03:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 479DA9D91B
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 08:03:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EA53A30071E9
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 07:03:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D3AA3271E0;
	Wed, 28 Jan 2026 07:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BeOb9bek";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YOEM4+gn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F36246BC6
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 07:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769583814; cv=pass; b=TFhU54nZjyoK18dtbyXjeq2LjAuqeXlMJJpJ/oPFf9YhitxN3IBJH9kZTWjPqJ0+JA1c6oPtJVXEYFTYkcLcRU25D7OvnxjgnAnoxchi+I/kNoAPjJHdsn8Wu2yCtepybo69kctIX1lr1YTr+w8ThkatALIubd8qXvHLANSbhxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769583814; c=relaxed/simple;
	bh=Cg45hZ0q54h2bhG/P3fSulN0EvcFY+v0s3Ih49jJOI8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ivic6oStgvormg45a7u1k0n3tMMV/mKxsoGB4fRALIa2i5rrlEAfkqclsGo8dzYjV1LNSPGESKttLJId3nPF60jNymx6Jl6pSnFTHeoDBwiS9N6Fhr2RMvZXNTb+oW+XU0b1uIagyQaEbYkzppIgD7WyMfphBp046MnuDymJLYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BeOb9bek; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YOEM4+gn; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769583812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xuKStyX4gBGrd4NIad9hOrKnHqdXGE6jzr0Ewri1egY=;
	b=BeOb9bekh3Cemze6ouJA9pQGfrBwm18cZSccw9bPJSJtxi8UsGg2++WXXvfXatxKz75/Cn
	7FBimmBIbXTEjQTkqAdinu+s541T7bRCzHMIwo/nh3qQumhOG8WJ9pZFFb3dAXi9KnKGNw
	C9dRyZ/QlLE2+scvfL4y2ij7sKO3qE4=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-ZtdU5vHuOQCnecjXbLwFLg-1; Wed, 28 Jan 2026 02:03:30 -0500
X-MC-Unique: ZtdU5vHuOQCnecjXbLwFLg-1
X-Mimecast-MFC-AGG-ID: ZtdU5vHuOQCnecjXbLwFLg_1769583809
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c61334ba4d3so3402504a12.0
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 23:03:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769583807; cv=none;
        d=google.com; s=arc-20240605;
        b=SYXDKmiHd8uBbf2UDCIRDqXqsTRfnwtVBAUs4/y6vt9tdk405YBLvEiXfBC1Ty6Z9X
         f79zUXXcu31ftdVciBQ/zJaP8h63hizTYc0QwYg/8SGaM/s/oFFRF/XgcxLncGWbixph
         qc6OmXEofzEdRE0AvhTfLoeZK5qd6F48ClbDqoQmq0J/Tr7RTxlxviQXH5R0kyDzjO2N
         X3BgruMvm0qhe5SKgnfJwZVgV50ec6xQo/bnginQ9smwZL2rGe0FkWzznxzz/5/CwI1Q
         SXqTszqbG6YhfpiXq0tVAdHnG3QuDesa45W2Mc1JnT/b1gPNWA3RhXa+NAZjoephH87c
         uGsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xuKStyX4gBGrd4NIad9hOrKnHqdXGE6jzr0Ewri1egY=;
        fh=0QzeH0iZIMoE4w0V7bajeKZIsd+EsOXWx9+iK+TmHQU=;
        b=PvnOGZT2YMF6dnta71PV1GqSamZLantvikk2eDMiJXsi+13DVvH53UyI8KxA/1Hzfh
         oebzbJ9oUJxt+NlViioXaBSJ/h3iJANuItXXWo4xOZs/66Hq6EMysomGDv4KSU3rI8YU
         sWLL25B7hrXoHuU9dUbGEbDaYuk0MqSicSDsKfKrkMUZf6ApHMQw9VBMdaYa9cSQobCr
         8HmFFSFt7957Yxp3xKaiuXfctnrdFpKX80NnAkvuRlv1wkLw0gl/zMtDlsZ/buS7NnrL
         i0MBaqFWLPefL1TLEF6qcmtZeaP9YiEriVgHSW4oAa9FBGDa2wKNVmWeHmiyekBpPaSt
         fgcg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769583807; x=1770188607; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xuKStyX4gBGrd4NIad9hOrKnHqdXGE6jzr0Ewri1egY=;
        b=YOEM4+gnJZUk30LUPLwLrlFKtK+Y6MLBmsx6mHfzbvg9tCn2h3cdA3OSsB83ftVhDo
         W7REoM6jGoVG2qv67oUorc6F+RQSCC4C+bXv3dpuQp/UAuUh2K7EekJ9Y0soUYZ4dvUW
         q+rwUOL8PuOBcHe+oueDgExV93EEg+uoRrC6f8w1BqztuVyrsz/hrtZx2dP393PDL0pP
         w9jQqWuTWlxovUmMKkDUIkYZ9Nbla33KFVca6fHxbM55mPWqQ5BrVqJw02SPd4reKGgV
         RQhtn1jTqcSSh0OxbmEWZUOqVGYLv2UJEgnxw7nZeDlOH/oOoZHlD+ekbbTTO4qKFM3k
         ad1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769583807; x=1770188607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xuKStyX4gBGrd4NIad9hOrKnHqdXGE6jzr0Ewri1egY=;
        b=W5pvVKKbHE8YBb0PCT6iNUWjb1IIqyDMriEV4OYhXztDn1iqQS3fG6gO5gT8oPale2
         fuhxkMV27gjPwr54JdQJCbHvUgbUkhTusZb8FHN1G8qQMCrsl2biEUf5L5wCyeAkF34v
         eDuSDyk5tb+tnAHjwPuLJgzRKN5RIv9BS+kDxPP6kmmvwNPB/JyeWFmGp1B5qMHTb5d0
         ERWWyxCug09Cbx8liE+CottA4HQHEX5D0TXGXSnnHH9VFvyv6ZPvoZRlwNNO+RpZTEGb
         M0xRY8dStDrnZ6rNnlq4rpaB97XkQ/VKrOIpjLt0j30MtbVLWN2cQFMGRVAYnEFnIInF
         pt8g==
X-Forwarded-Encrypted: i=1; AJvYcCVge7urq1AkqdbKliqz/yYpma3YnrYr+LRa2e5NLWiyGZgtf/k2dCX4JwJg1zFewK3nq1s=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywynbcxq0ipiNB+498b+hPCT2c1LM722Ew6r0loeiArR/q1IbiT
	6VFXhdPqQ3Pv5YtlJUmzs2v646p1+P+gMxKG3C5C0GQwvm0jSl/Z/+xIUeaTlLR5HD7z6AUZDX+
	XsVKVKOVOrJekbwhasZ9BDF2JKyv8+0cI0EIJIwGMfzGc5gEehbAkPhuZ2a4BAjELI6KTJkqrjt
	epkUpNmNu0hYPtfFUX5S85/jOo4Kmb
X-Gm-Gg: AZuq6aJP0i2UsRiHlwwtgVJh5TpH6KOvoyySsJV87/ZaeG+YJf+J4oKPFA8n0p39rkQ
	Smfgd64avumLDPG7ac+V3w0oIInIcPWZtpZe9D/OysPua0ypDRo8tgvRzCVHK4mPCjRlxGrtGce
	+xhzu7Z/1yHYz0Wtpc9WLHFW50Enro1oZqC07LK1EZluL5c9qU/7RJbO3wt3cnTXbD
X-Received: by 2002:a05:6a21:3388:b0:38d:ee4a:e833 with SMTP id adf61e73a8af0-38ec6549c19mr3702321637.62.1769583806881;
        Tue, 27 Jan 2026 23:03:26 -0800 (PST)
X-Received: by 2002:a05:6a21:3388:b0:38d:ee4a:e833 with SMTP id
 adf61e73a8af0-38ec6549c19mr3702286637.62.1769583806348; Tue, 27 Jan 2026
 23:03:26 -0800 (PST)
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
In-Reply-To: <3a1d6232-efe4-4e79-a196-44794fdc0f33@tu-dortmund.de>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 28 Jan 2026 15:03:11 +0800
X-Gm-Features: AZwV_QhDC_bWR-juret8NZb1IfXLfm23zEjia-LWh6nai9zCNajkiH0ao9SG7CE
Message-ID: <CACGkMEv71kn91FPAUrxJg=YB3+B0MRTgOidMPHjK7Qq0WEhGtw@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69332-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,netdev];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 479DA9D91B
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 12:48=E2=80=AFAM Simon Schippers
<simon.schippers@tu-dortmund.de> wrote:
>
> On 1/23/26 10:54, Simon Schippers wrote:
> > On 1/23/26 04:05, Jason Wang wrote:
> >> On Thu, Jan 22, 2026 at 1:35=E2=80=AFPM Jason Wang <jasowang@redhat.co=
m> wrote:
> >>>
> >>> On Wed, Jan 21, 2026 at 5:33=E2=80=AFPM Simon Schippers
> >>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>
> >>>> On 1/9/26 07:02, Jason Wang wrote:
> >>>>> On Thu, Jan 8, 2026 at 3:41=E2=80=AFPM Simon Schippers
> >>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>
> >>>>>> On 1/8/26 04:38, Jason Wang wrote:
> >>>>>>> On Thu, Jan 8, 2026 at 5:06=E2=80=AFAM Simon Schippers
> >>>>>>> <simon.schippers@tu-dortmund.de> wrote:
> >>>>>>>>
> >>>>>>>> Introduce {tun,tap}_ring_consume() helpers that wrap __ptr_ring_=
consume()
> >>>>>>>> and wake the corresponding netdev subqueue when consuming an ent=
ry frees
> >>>>>>>> space in the underlying ptr_ring.
> >>>>>>>>
> >>>>>>>> Stopping of the netdev queue when the ptr_ring is full will be i=
ntroduced
> >>>>>>>> in an upcoming commit.
> >>>>>>>>
> >>>>>>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>>>>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> >>>>>>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> >>>>>>>> ---
> >>>>>>>>  drivers/net/tap.c | 23 ++++++++++++++++++++++-
> >>>>>>>>  drivers/net/tun.c | 25 +++++++++++++++++++++++--
> >>>>>>>>  2 files changed, 45 insertions(+), 3 deletions(-)
> >>>>>>>>
> >>>>>>>> diff --git a/drivers/net/tap.c b/drivers/net/tap.c
> >>>>>>>> index 1197f245e873..2442cf7ac385 100644
> >>>>>>>> --- a/drivers/net/tap.c
> >>>>>>>> +++ b/drivers/net/tap.c
> >>>>>>>> @@ -753,6 +753,27 @@ static ssize_t tap_put_user(struct tap_queu=
e *q,
> >>>>>>>>         return ret ? ret : total;
> >>>>>>>>  }
> >>>>>>>>
> >>>>>>>> +static void *tap_ring_consume(struct tap_queue *q)
> >>>>>>>> +{
> >>>>>>>> +       struct ptr_ring *ring =3D &q->ring;
> >>>>>>>> +       struct net_device *dev;
> >>>>>>>> +       void *ptr;
> >>>>>>>> +
> >>>>>>>> +       spin_lock(&ring->consumer_lock);
> >>>>>>>> +
> >>>>>>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(rin=
g, 1))) {
> >>>>>>>> +               rcu_read_lock();
> >>>>>>>> +               dev =3D rcu_dereference(q->tap)->dev;
> >>>>>>>> +               netif_wake_subqueue(dev, q->queue_index);
> >>>>>>>> +               rcu_read_unlock();
> >>>>>>>> +       }
> >>>>>>>> +
> >>>>>>>> +       spin_unlock(&ring->consumer_lock);
> >>>>>>>> +
> >>>>>>>> +       return ptr;
> >>>>>>>> +}
> >>>>>>>> +
> >>>>>>>>  static ssize_t tap_do_read(struct tap_queue *q,
> >>>>>>>>                            struct iov_iter *to,
> >>>>>>>>                            int noblock, struct sk_buff *skb)
> >>>>>>>> @@ -774,7 +795,7 @@ static ssize_t tap_do_read(struct tap_queue =
*q,
> >>>>>>>>                                         TASK_INTERRUPTIBLE);
> >>>>>>>>
> >>>>>>>>                 /* Read frames from the queue */
> >>>>>>>> -               skb =3D ptr_ring_consume(&q->ring);
> >>>>>>>> +               skb =3D tap_ring_consume(q);
> >>>>>>>>                 if (skb)
> >>>>>>>>                         break;
> >>>>>>>>                 if (noblock) {
> >>>>>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >>>>>>>> index 8192740357a0..7148f9a844a4 100644
> >>>>>>>> --- a/drivers/net/tun.c
> >>>>>>>> +++ b/drivers/net/tun.c
> >>>>>>>> @@ -2113,13 +2113,34 @@ static ssize_t tun_put_user(struct tun_s=
truct *tun,
> >>>>>>>>         return total;
> >>>>>>>>  }
> >>>>>>>>
> >>>>>>>> +static void *tun_ring_consume(struct tun_file *tfile)
> >>>>>>>> +{
> >>>>>>>> +       struct ptr_ring *ring =3D &tfile->tx_ring;
> >>>>>>>> +       struct net_device *dev;
> >>>>>>>> +       void *ptr;
> >>>>>>>> +
> >>>>>>>> +       spin_lock(&ring->consumer_lock);
> >>>>>>>> +
> >>>>>>>> +       ptr =3D __ptr_ring_consume(ring);
> >>>>>>>> +       if (unlikely(ptr && __ptr_ring_consume_created_space(rin=
g, 1))) {
> >>>>>>>
> >>>>>>> I guess it's the "bug" I mentioned in the previous patch that lea=
ds to
> >>>>>>> the check of __ptr_ring_consume_created_space() here. If it's tru=
e,
> >>>>>>> another call to tweak the current API.
> >>>>>>>
> >>>>>>>> +               rcu_read_lock();
> >>>>>>>> +               dev =3D rcu_dereference(tfile->tun)->dev;
> >>>>>>>> +               netif_wake_subqueue(dev, tfile->queue_index);
> >>>>>>>
> >>>>>>> This would cause the producer TX_SOFTIRQ to run on the same cpu w=
hich
> >>>>>>> I'm not sure is what we want.
> >>>>>>
> >>>>>> What else would you suggest calling to wake the queue?
> >>>>>
> >>>>> I don't have a good method in my mind, just want to point out its i=
mplications.
> >>>>
> >>>> I have to admit I'm a bit stuck at this point, particularly with thi=
s
> >>>> aspect.
> >>>>
> >>>> What is the correct way to pass the producer CPU ID to the consumer?
> >>>> Would it make sense to store smp_processor_id() in the tfile inside
> >>>> tun_net_xmit(), or should it instead be stored in the skb (similar t=
o the
> >>>> XDP bit)? In the latter case, my concern is that this information ma=
y
> >>>> already be significantly outdated by the time it is used.
> >>>>
> >>>> Based on that, my idea would be for the consumer to wake the produce=
r by
> >>>> invoking a new function (e.g., tun_wake_queue()) on the producer CPU=
 via
> >>>> smp_call_function_single().
> >>>> Is this a reasonable approach?
> >>>
> >>> I'm not sure but it would introduce costs like IPI.
> >>>
> >>>>
> >>>> More generally, would triggering TX_SOFTIRQ on the consumer CPU be
> >>>> considered a deal-breaker for the patch set?
> >>>
> >>> It depends on whether or not it has effects on the performance.
> >>> Especially when vhost is pinned.
> >>
> >> I meant we can benchmark to see the impact. For example, pin vhost to
> >> a specific CPU and the try to see the impact of the TX_SOFTIRQ.
> >>
> >> Thanks
> >>
> >
> > I ran benchmarks with vhost pinned to CPU 0 using taskset -p -c 0 ...
> > for both the stock and patched versions. The benchmarks were run with
> > the full patch series applied, since testing only patches 1-3 would not
> > be meaningful - the queue is never stopped in that case, so no
> > TX_SOFTIRQ is triggered.
> >
> > Compared to the non-pinned CPU benchmarks in the cover letter,
> > performance is lower for pktgen with a single thread but higher with
> > four threads. The results show no regression for the patched version,
> > with even slight performance improvements observed:
> >
> > +-------------------------+-----------+----------------+
> > | pktgen benchmarks to    | Stock     | Patched with   |
> > | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
> > | 100M packets            |           |                |
> > | vhost pinned to core 0  |           |                |
> > +-----------+-------------+-----------+----------------+
> > | TAP       | Transmitted | 452 Kpps  | 454 Kpps       |
> > |  +        +-------------+-----------+----------------+
> > | vhost-net | Lost        | 1154 Kpps | 0              |
> > +-----------+-------------+-----------+----------------+
> >
> > +-------------------------+-----------+----------------+
> > | pktgen benchmarks to    | Stock     | Patched with   |
> > | Debian VM, i5 6300HQ,   |           | fq_codel qdisc |
> > | 100M packets            |           |                |
> > | vhost pinned to core 0  |           |                |
> > | *4 threads*             |           |                |
> > +-----------+-------------+-----------+----------------+
> > | TAP       | Transmitted | 71 Kpps   | 79 Kpps        |
> > |  +        +-------------+-----------+----------------+
> > | vhost-net | Lost        | 1527 Kpps | 0              |
> > +-----------+-------------+-----------+----------------+

The PPS seems to be low. I'd suggest using testpmd (rxonly) mode in
the guest or an xdp program that did XDP_DROP in the guest.

> >
> > +------------------------+-------------+----------------+
> > | iperf3 TCP benchmarks  | Stock       | Patched with   |
> > | to Debian VM 120s      |             | fq_codel qdisc |
> > | vhost pinned to core 0 |             |                |
> > +------------------------+-------------+----------------+
> > | TAP                    | 22.0 Gbit/s | 22.0 Gbit/s    |
> > |  +                     |             |                |
> > | vhost-net              |             |                |
> > +------------------------+-------------+----------------+
> >
> > +---------------------------+-------------+----------------+
> > | iperf3 TCP benchmarks     | Stock       | Patched with   |
> > | to Debian VM 120s         |             | fq_codel qdisc |
> > | vhost pinned to core 0    |             |                |
> > | *4 iperf3 client threads* |             |                |
> > +---------------------------+-------------+----------------+
> > | TAP                       | 21.4 Gbit/s | 21.5 Gbit/s    |
> > |  +                        |             |                |
> > | vhost-net                 |             |                |
> > +---------------------------+-------------+----------------+
>
> What are your thoughts on this?
>
> Thanks!
>
>

Thanks


