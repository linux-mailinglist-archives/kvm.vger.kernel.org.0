Return-Path: <kvm+bounces-67694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E03DD1097B
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 05:43:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E420330719FA
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 04:42:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE07B30DD24;
	Mon, 12 Jan 2026 04:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HMgLth3y";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YQE5Yfco"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE9930ACE3
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 04:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768192949; cv=none; b=awI5r5DUJUqZTEcHIBv7jEPeT3CRMQy9NLV+UVofwHv65xA4eWK36Te+VT4h0hvRsugM0Xi7SU8V4448yLCpNClkx/oXJ3K/3iC4YGl9ru8m2qteScyYaNpbsR1BMEHxx/dQnClpZIQdKmDr9BlcQyeugAz82rwUqF7MI05WWrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768192949; c=relaxed/simple;
	bh=2VltQBFJygJXWBbOcvlhVXQ2y5H6Win1bazyoi6YOU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GL/znl1Wzu7ERxU+uc6huKwIYDR+Yu9LLz2DEn1wvR5FrlQTrDPb9TLrLjRf4ss9U3pLg6z0wSH5ENw0o82iJ10hCmpe6dyNX1tEt53BuBg9uOnZRkt/KVH/363AvPIVEvXvrlCXlKEIGtJ3b6FAY9nMFOfK1pwwjsL8ZnV7+y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HMgLth3y; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YQE5Yfco; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768192945;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eRnCSJo0TmvquSWDDIrpEWk/wUKA+CvYamy20zcpVrg=;
	b=HMgLth3ys4JwuMtzKCUdVeuPMNCq7VXNNwxl937lYaSXBTnRIjCK6+InKAkDMYIk7a+FDA
	1Kf6/yHjkr6yW6QJF0Ydce3lY3/DQHXSq9PjjPZ77vD4qG/nbpU1MWmUzUWt8LtkmfBmrN
	Hpww8KxZNj2IF2m2op8LmRv8pBzqG7E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-4aPtXHRlOpCn6fVzzUkM6g-1; Sun, 11 Jan 2026 23:42:22 -0500
X-MC-Unique: 4aPtXHRlOpCn6fVzzUkM6g-1
X-Mimecast-MFC-AGG-ID: 4aPtXHRlOpCn6fVzzUkM6g_1768192941
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4325aa61c6bso3674585f8f.0
        for <kvm@vger.kernel.org>; Sun, 11 Jan 2026 20:42:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768192941; x=1768797741; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eRnCSJo0TmvquSWDDIrpEWk/wUKA+CvYamy20zcpVrg=;
        b=YQE5YfcoVGsc3kel5AZsPv+5MwoVhhFfz1JXQSX/M9CqPf9Sp5r28AoLrkLxNolKew
         VJvvJOs7OCcjc6DyT3IzQKB6lEe5n71/Gx1e3DBjkfhQQB0NOfp7CkFunWKVMj32/a3b
         n7NohkN93JvaCdb1VWZ3BsLNICjQbm4dREMxBgjJS4NnZ2D2xow+Fc/vuYgbCzUFcjQq
         k9oP2XkTPOBWtLXaMixyiAuh9IbWvoMR1t2kmPKoJxFhRK7/L4ihN2O6DBxM5avfOEVK
         ok1pz+Z2akl5/7aTvDO+vOo2mrPL5uIEmzK4INT9gIceZZR4umPSsAVC9iScz083ZsXG
         GhiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768192941; x=1768797741;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eRnCSJo0TmvquSWDDIrpEWk/wUKA+CvYamy20zcpVrg=;
        b=H/NvPgeB0Xw8JKVBlxm1iTqKjG9GwE4vim+sisApF4XdUkLZGS08D0uOjsIM2VX385
         ZdVxDyPqdEXbj7XmjG/6d6xJ9I4NFMBTCg+vhNw2HSNqMN61+aOu9TZ5YofenVAMuUlR
         A4aSkedYumyXtZLyxw1xlqGwWEtjGnCFr6mui2UCn3KT9lyX3BQ59OV1TywayikMmbGj
         h6u6R2wUo9rXyBDPOeIIGRXO9XSML4iwncJgHfV6QOeB5H9uGuKwa3m3PUj7kLrVzW9Y
         RLNJEfcZ0dGnKbCrRJse0/+j+nVo8fejaBVofPPXeEoy64h59Ac3vSEWtMA81BUM4kvj
         DXYw==
X-Forwarded-Encrypted: i=1; AJvYcCXdSF4GhBA1VW9I+hFZ8qqLMKaNz/mGx/OouxvF4UU7MmxQYl4bNuAgLvOd2iM+sb4pt+w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBNfFSVRv/7qVIf4sFnMM6qWu0+ePqPSTxdg/X89ZAuVig2xJA
	BQ44n0qnXA4LXvYTpdp1fqMrxdsG4ZMZwDAdm6DOeTtpR+HA0rZyhhaRUYFh1GX88TK/xmhZLkU
	m2R1qaiO3cZKkGKx5nG0B60ONyrAZzutMv98YlHkDi9DAhZADbkG4OQ==
X-Gm-Gg: AY/fxX5hK3KMM1zdbHB0VOp0uQb7SYzw8fwsDsMcyyiyOdbt7UM3cP7RFUFMOWYWFCk
	TFEMNU+ie3QoRRD6jiPtQZSuSumRotKOzOFC6bFBiISrgit5bV62ixaIJNde97/yvBNst3jxdbe
	1lia3e3wD+dE0Bbmf4xhNQwwGHzrJ4tRpmlMW11i9TtSyXp0LqR2D1hgxYKfHA6jYLP6g/MnFno
	3xzlNvPGZ+HQ/YW4VDop+xQCLWrl25HjhjYH8ZQy99xJ6dJ3rv+jEdZvFw2PiAuqlW8IqpLoof/
	fKe7R1JnsPmfv+pMTKNmlGOjlvqM4azmNftZosHGmmLclU7zJUozkzJSY0VEx1DtPFYqrdlBTMI
	0CgNJDS/I55ub3TfqzasYzeJUtVH6Zqs=
X-Received: by 2002:a5d:5888:0:b0:42f:edb6:3642 with SMTP id ffacd0b85a97d-432c37767acmr20558546f8f.60.1768192940937;
        Sun, 11 Jan 2026 20:42:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGksWsEOp11E7do7kSJe9rVBAth4jOqGHv4mw3q8StsdQQPY6PxltAQTL2SJSNkU9vJyWdeOw==
X-Received: by 2002:a5d:5888:0:b0:42f:edb6:3642 with SMTP id ffacd0b85a97d-432c37767acmr20558531f8f.60.1768192940549;
        Sun, 11 Jan 2026 20:42:20 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5ff319sm36985010f8f.43.2026.01.11.20.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 20:42:19 -0800 (PST)
Date: Sun, 11 Jan 2026 23:42:16 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: Simon Schippers <simon.schippers@tu-dortmund.de>,
	willemdebruijn.kernel@gmail.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, eperezma@redhat.com, leiyang@redhat.com,
	stephen@networkplumber.org, jon@nutanix.com,
	tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v7 7/9] vhost-net: vhost-net: replace rx_ring
 with tun/tap ring wrappers
Message-ID: <20260111234112-mutt-send-email-mst@kernel.org>
References: <20260107210448.37851-1-simon.schippers@tu-dortmund.de>
 <20260107210448.37851-8-simon.schippers@tu-dortmund.de>
 <CACGkMEtndGm+GX+3Kn5AWTkEc+PK0Fo1=VSZzhgBQoYRQbicQw@mail.gmail.com>
 <5961e982-9c52-4e7a-b1ca-caaf4c4d0291@tu-dortmund.de>
 <CACGkMEsKFcsumyNU6vVgBE4LjYWNb2XQNaThwd9H5eZ+RjSwfQ@mail.gmail.com>
 <0ae9071b-6d76-4336-8aee-d0338eecc6f5@tu-dortmund.de>
 <CACGkMEsC0-d4oS54BHNdFVKS+74P7SdnNHPHe_d0pmo-_86ipg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEsC0-d4oS54BHNdFVKS+74P7SdnNHPHe_d0pmo-_86ipg@mail.gmail.com>

On Mon, Jan 12, 2026 at 10:54:15AM +0800, Jason Wang wrote:
> On Fri, Jan 9, 2026 at 5:57 PM Simon Schippers
> <simon.schippers@tu-dortmund.de> wrote:
> >
> > On 1/9/26 07:04, Jason Wang wrote:
> > > On Thu, Jan 8, 2026 at 3:48 PM Simon Schippers
> > > <simon.schippers@tu-dortmund.de> wrote:
> > >>
> > >> On 1/8/26 05:38, Jason Wang wrote:
> > >>> On Thu, Jan 8, 2026 at 5:06 AM Simon Schippers
> > >>> <simon.schippers@tu-dortmund.de> wrote:
> > >>>>
> > >>>> Replace the direct use of ptr_ring in the vhost-net virtqueue with
> > >>>> tun/tap ring wrapper helpers. Instead of storing an rx_ring pointer,
> > >>>> the virtqueue now stores the interface type (IF_TUN, IF_TAP, or IF_NONE)
> > >>>> and dispatches to the corresponding tun/tap helpers for ring
> > >>>> produce, consume, and unconsume operations.
> > >>>>
> > >>>> Routing ring operations through the tun/tap helpers enables netdev
> > >>>> queue wakeups, which are required for upcoming netdev queue flow
> > >>>> control support shared by tun/tap and vhost-net.
> > >>>>
> > >>>> No functional change is intended beyond switching to the wrapper
> > >>>> helpers.
> > >>>>
> > >>>> Co-developed-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > >>>> Signed-off-by: Tim Gebauer <tim.gebauer@tu-dortmund.de>
> > >>>> Co-developed by: Jon Kohler <jon@nutanix.com>
> > >>>> Signed-off-by: Jon Kohler <jon@nutanix.com>
> > >>>> Signed-off-by: Simon Schippers <simon.schippers@tu-dortmund.de>
> > >>>> ---
> > >>>>  drivers/vhost/net.c | 92 +++++++++++++++++++++++++++++----------------
> > >>>>  1 file changed, 60 insertions(+), 32 deletions(-)
> > >>>>
> > >>>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> > >>>> index 7f886d3dba7d..215556f7cd40 100644
> > >>>> --- a/drivers/vhost/net.c
> > >>>> +++ b/drivers/vhost/net.c
> > >>>> @@ -90,6 +90,12 @@ enum {
> > >>>>         VHOST_NET_VQ_MAX = 2,
> > >>>>  };
> > >>>>
> > >>>> +enum if_type {
> > >>>> +       IF_NONE = 0,
> > >>>> +       IF_TUN = 1,
> > >>>> +       IF_TAP = 2,
> > >>>> +};
> > >>>
> > >>> This looks not elegant, can we simply export objects we want to use to
> > >>> vhost like get_tap_socket()?
> > >>
> > >> No, we cannot do that. We would need access to both the ptr_ring and the
> > >> net_device. However, the net_device is protected by an RCU lock.
> > >>
> > >> That is why {tun,tap}_ring_consume_batched() are used:
> > >> they take the appropriate locks and handle waking the queue.
> > >
> > > How about introducing a callback in the ptr_ring itself, so vhost_net
> > > only need to know about the ptr_ring?
> >
> > That would be great, but I'm not sure whether this should be the
> > responsibility of the ptr_ring.
> >
> > If the ptr_ring were to keep track of the netdev queue, it could handle
> > all the management itself - stopping the queue when full and waking it
> > again once space becomes available.
> >
> > What would be your idea for implementing this?
> 
> During ptr_ring_init() register a callback, the callback will be
> trigger during ptr_ring_consume() or ptr_ring_consume_batched() when
> ptr_ring find there's a space for ptr_ring_produce().
> 
> Thanks

Not sure the perceived elegance is worth the indirect call overhead.
ptr_ring is trying hard to be low overhead.
What this does is not really complex to justify that.
We just need decent documentation.

> >
> > >
> > > Thanks
> > >
> > >>
> > >>>
> > >>> Thanks
> > >>>
> > >>
> > >
> >


