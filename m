Return-Path: <kvm+bounces-64519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 56CBDC860B8
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 17:55:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 129194E8144
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 16:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13BF7329C71;
	Tue, 25 Nov 2025 16:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fFFxi4l2";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oz7s6MO8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936AE329388
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764089692; cv=none; b=bp2h9rfTNGcLJlH/5/1QIXmtZl1pNVQyVBImZbelTtHQsxgzfAoHQSo+pjApn9TSpFqhJxmcPs2LOklxcMZHyb8c/e14tmhL9iLo0UXUXENRQ94SJebfCJFf2emhTRBn4M8Lyv1xqHaghimn2xsaN5kQtCNyrSgS4nyIEyLkTlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764089692; c=relaxed/simple;
	bh=M1xVC7gLm/5kXEcyVn8F+hiOuj4fAZSxatNimx4cXKI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lC9KZQVsx7wGcrWdFovyM1CC1m+hj5mLsmz0RCtvkVtkAnBecH5jseydQa7RK/yfGACyyDQtT79YuXl87OruFrJPFwd4kY8303jFuwf2rnLICQ1wRevQZ1lT++9g3JnuU0pGb6/vtACTHThayS3zPW3wUreFxFJpn7dhgXsF05M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fFFxi4l2; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oz7s6MO8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764089689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VSyjzVF3bRMyEucyth0abh8Rzk8q/nESWV3mm3a9fMs=;
	b=fFFxi4l23WNkNxqEC5CQ8oW189NifcciRlUd0WKkTaIcr76AH+LIsLXol/Vkz/rvCid+i9
	MjlsCxnyo37+HQTKIf33JsJM5C3NxHNi1VbkWOFDi8OM5jlqHPf3v6S97PUV3FzMf1qieI
	mq7uCCckO3iinkohn6GaMHtZYe9QZbo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-ZFVTHA5gMxSQowrBsINLLA-1; Tue, 25 Nov 2025 11:54:46 -0500
X-MC-Unique: ZFVTHA5gMxSQowrBsINLLA-1
X-Mimecast-MFC-AGG-ID: ZFVTHA5gMxSQowrBsINLLA_1764089684
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4775d110fabso50344205e9.1
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 08:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764089683; x=1764694483; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VSyjzVF3bRMyEucyth0abh8Rzk8q/nESWV3mm3a9fMs=;
        b=Oz7s6MO8s4itO6fJyW7LuGeA+YQYLb63NmnVODYfKsSpxbJPrwWcAIyiyC6Nrc0jDq
         hyD24dLZInuSLysOTuSSnRbVOcWH3Ej8UinzdHLOAUzr2XRl0JMoKJEDvJClltBWDJ/5
         dlUEErJThDdC/uNkNn55Tl+URgCHiz/o2x2au9HFFzq+T1Dy6nWluZ22CIqBi/+JkZWg
         KDz0CfJOAmFDNKxePNyfITPTLtf2rfbRNUZW2ISigiWKpTOXWzg+x4P7a3vLRlQdXkA6
         cc6QLRrdKFhJTXn8iETjRQibxktidIGg4Zg2JEOCuXVAis6kPxrRRU61a4AKEAkX+5as
         kKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089683; x=1764694483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VSyjzVF3bRMyEucyth0abh8Rzk8q/nESWV3mm3a9fMs=;
        b=SDfsjrKvy9msuIyRn3PpTZfDCrqhW8fYYMmLXGRsoYlWrY8c/jc3Dci32JHqElNz36
         zLPAY04h1LdeLGmAouH14Mg7Fw7EyJcsoIWVBG1rFgFY43FXULJinfyf7wZVJuCQOHLZ
         9Wnsko9g5cvyp+sQ1YWiC/uUcyDLRXpeQaqgeI1btYW99Uc/nQBihcWq3yG82OzvFM+N
         QT953Mx3ltDoAJbjBmypS2uu2UI0ehQB0YQKVMuL/A8O6qIdI9vhJ6uGJxHb43dtOzjV
         wqiG7qxY5BOOe36ZXGeVnHrtPRbhO81ph0YxqQ+mAr7PAI86ZA9eLBW+0liUWRaogB/M
         78UA==
X-Forwarded-Encrypted: i=1; AJvYcCVZwTAZS122nwZ2fimTFh4zmeI3lQHU8CvIzCH8oyGF7HgxTfAhR+T8ZliBUdEyK9M5WBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbVpan+eq4rJyRPq/HIk5V3Hc+TLhymkw5GlaWHUzCpRpyho0R
	dVGSmokJEs/DHObyThokRFf8tJ4KB/l42pa3zcTGXy5uJb/IIbYmcimjBgvsAJ6WykEt6gfoZWq
	6n2FlOMVd5sO0WF+hUqAF67+9bHe3tIRB6S/BWpHxx6h59uPvA3o4Jw==
X-Gm-Gg: ASbGncueVLmmmUXrIpoxkwK4IGOHwZvta9a0KDGujkJbz8RqiX10AKj6YBrD3rpD6gI
	BjgFhDsVa5hmKGi1MiSvr25GqBnmeU1XIquFb2y+tNRMGru0hCL97pSGIa/RmLVNGislHIYbnCg
	Eo8obxYPWNpThcdlUJl8xu7S2d5afA3A+8EaD1lkHyMMorBXlxnS2crMmPfQM+jpucW3RDRBPft
	P4WZpZ3HKon6tq6SzzdbTu/6fMF4Vj5o8Fi8oZRo9nux20paTu8o6smMf1eEB0i09R2HNnGA9bJ
	jHjWqDZwAdfFF0/L38DnJU9MOAUED6cJWpCbqL99aNMD/BGdTq6R1RcHmiKMeprjsQUpg8nBHgp
	2F3azOa8X3ZEemdg=
X-Received: by 2002:a05:600c:c8c:b0:471:1435:b0ea with SMTP id 5b1f17b1804b1-47904b242eemr43823255e9.24.1764089683431;
        Tue, 25 Nov 2025 08:54:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFI01s5vSZlwPc1XuZyxkfAjV2ILVY5rmqifLiNvt5a+hPHMgV9ZhgyCmVtX0zbnJSE6jyd/w==
X-Received: by 2002:a05:600c:c8c:b0:471:1435:b0ea with SMTP id 5b1f17b1804b1-47904b242eemr43822735e9.24.1764089682896;
        Tue, 25 Nov 2025 08:54:42 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477bf1e86b3sm317496245e9.6.2025.11.25.08.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:54:42 -0800 (PST)
Date: Tue, 25 Nov 2025 11:54:39 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: willemdebruijn.kernel@gmail.com, jasowang@redhat.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
	jon@nutanix.com, tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v6 3/8] tun/tap: add synchronized ring
 produce/consume with queue management
Message-ID: <20251125100655-mutt-send-email-mst@kernel.org>
References: <20251120152914.1127975-1-simon.schippers@tu-dortmund.de>
 <20251120152914.1127975-4-simon.schippers@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120152914.1127975-4-simon.schippers@tu-dortmund.de>

On Thu, Nov 20, 2025 at 04:29:08PM +0100, Simon Schippers wrote:
> Implement new ring buffer produce and consume functions for tun and tap
> drivers that provide lockless producer-consumer synchronization and
> netdev queue management to prevent ptr_ring tail drop and permanent
> starvation.
> 
> - tun_ring_produce(): Produces packets to the ptr_ring with proper memory
>   barriers and proactively stops the netdev queue when the ring is about
>   to become full.
> 
> - __tun_ring_consume() / __tap_ring_consume(): Internal consume functions
>   that check if the netdev queue was stopped due to a full ring, and wake
>   it when space becomes available. Uses memory barriers to ensure proper
>   ordering between producer and consumer.
> 
> - tun_ring_consume() / tap_ring_consume(): Wrapper functions that acquire
>   the consumer lock before calling the internal consume functions.
> 
> Key features:
> - Proactive queue stopping using __ptr_ring_full_next() to stop the queue
>   before it becomes completely full.
> - Not stopping the queue when the ptr_ring is full already, because if
>   the consumer empties all entries in the meantime, stopping the queue
>   would cause permanent starvation.

what is permanent starvation? this comment seems to answer this
question:


	/* Do not stop the netdev queue if the ptr_ring is full already.
	 * The consumer could empty out the ptr_ring in the meantime
	 * without noticing the stopped netdev queue, resulting in a
	 * stopped netdev queue and an empty ptr_ring. In this case the
	 * netdev queue would stay stopped forever.
	 */


why having a single entry in
the ring we never use helpful to address this?




In fact, all your patch does to solve it, is check
netif_tx_queue_stopped on every consumed packet.


I already proposed:

static inline int __ptr_ring_peek_producer(struct ptr_ring *r)
{
        if (unlikely(!r->size) || r->queue[r->producer])
                return -ENOSPC;
        return 0;
}

And with that, why isn't avoiding the race as simple as
just rechecking after stopping the queue?

__ptr_ring_produce();
if (__ptr_ring_peek_producer())
	netif_tx_stop_queue
	if (!__ptr_ring_peek_producer())
		netif_tx_wake_queue(txq);







-- 
MST


