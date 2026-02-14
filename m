Return-Path: <kvm+bounces-71103-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oJnEGj0KkWnSegEAu9opvQ
	(envelope-from <kvm+bounces-71103-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 00:50:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C4F4513DC91
	for <lists+kvm@lfdr.de>; Sun, 15 Feb 2026 00:50:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 426B73032CF3
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 23:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF64A2C08A1;
	Sat, 14 Feb 2026 23:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UCSwp0pa";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BefvfBLt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F9728641F
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 23:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771112991; cv=none; b=RzBoAF8a2VhuswcMCB2FuyvFO0K15rftcQGyJNGZq5SiDjlAxDACa6rxJ5oTISkkgk+STkFh8L1+/0jqJKK7Wt0xD9kn07i5T/ira0VCBmb4oEbqwDMOLZf6HAZWn10zoOohNKTQqbzYhQ5bF3E45MozAj3I35TBH90bHgT+H34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771112991; c=relaxed/simple;
	bh=0teZB9CPEF5sbUbIUadXWlFPJ6ba1v4ykNaYGomwB0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQLsmAh0WG3GYsfUNhkt0RWjnHesygcajcgTlYWmiVouXvs++sGMUMh53UzsnrfXiHyH321sguvbcKuc29jarqHxIyjp7qaw94Yai01kW81tv2Mb6TPLVrjfdvztqpxGskwvWPsRV9cx8d9tB/k+JiGQtrfZ83A/SkLoHa0Q1yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UCSwp0pa; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BefvfBLt; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771112989;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oa/MMBMnbn+u985OU8+Ei4K9m3xtsJNKiEfMcHtZPG4=;
	b=UCSwp0pan/TKJosNZiXpVaj96v1p/09BOyWqUSwG58Lf9nVKI+MR864lhl5Ae6a0F/5+J6
	G7CWgt0EfYgjoz2PV8zdzd8w61H3I639H9vysiiEUesh2BS+yEGax1ZXE12moqfyU6it7J
	Edqg9xfKlGwCQSGk5Il9NBwKOWQVli8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-633-_e6ghTHoNNacVv8IfLv7hQ-1; Sat, 14 Feb 2026 18:49:47 -0500
X-MC-Unique: _e6ghTHoNNacVv8IfLv7hQ-1
X-Mimecast-MFC-AGG-ID: _e6ghTHoNNacVv8IfLv7hQ_1771112987
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4836cc0b38eso12845475e9.2
        for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 15:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771112986; x=1771717786; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oa/MMBMnbn+u985OU8+Ei4K9m3xtsJNKiEfMcHtZPG4=;
        b=BefvfBLtvSuHslWNILovI9ZvxBPAu0lLDaB1OOUnP8LIpM9u05fHzr3zbjufiuuZjo
         g2mUA0dh3UCFJmIxiu6zvpB78MGtWelVE/qOy7dXj8mPb6zicz8GQ7YiqdvX+40DQ6K+
         xzoQxxQjM0nvdEbg2yIbb04ePUdMcHFSvthR5PIiX6AwJTzBhhuED0RcGgw6MeJGLNA9
         6hnJiqshnKHzcpp6WKCnCx85TcilPWoPOj5YL9x9JoaTosgzWngkWhETPHFNwUvisgyI
         UHCSzoc9u5v7Rn1Et6neg0iXzkCKzRK+vu5nGbCjenK2l9ATBJk3+eud1mWDorl87nUr
         vrSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771112986; x=1771717786;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oa/MMBMnbn+u985OU8+Ei4K9m3xtsJNKiEfMcHtZPG4=;
        b=eX1U6AM0B7j4/7BxFliE9MTCgnEfHDzwwCVR55cUCh+Hmuzz+D6lS+52oGB0nN6v8E
         5ecaqvTFWm8nazoOBWWLCMiw92QnNUGuaYuKb7gYwChqK9pXqldeuFvhGSWardVeRcNO
         IcnxOiXrLiXZP0qSKSTJMTv1g39oogBQJUkEnhIDHnYVjbnTnrS22g5KTwO/JgdSNnuF
         1E5c9+mTsvVp2uKMZO322LhhZuQfShgga2t5Y7IxSPks55GIjbizYaUM1Zr13vO+hb+Q
         bLYA53Y86Pcy27Iwive1SLBmTqDXuPqq3PGaBq4HnjvBx9IEUT0IM4YVazrDUdyZjKWW
         yzZg==
X-Forwarded-Encrypted: i=1; AJvYcCX9t107yGy2wypZxLjzqWUPBlue1pCLZw9t9eLNpqPHy3eAFw0Fh9OyDoMBzUifI1Ue9es=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUWVxfS0+rH5jXmJH8kEFhBXedeZdnQKKdgieqlhzwqgSJs75L
	IsGlB7FaMo/C8IjYrYuukVAqlSK3HgIfrw2jQJuc5KlMK5fqHTzHNNJKv3dNOB0G6iufCyXzkJi
	qYlP7Tc/Tmzxxi0w6BMXhRV5cjk7FUQ0kqMGcTpHVpdo6juw+8u+tgg==
X-Gm-Gg: AZuq6aJ/V/ZylJ2Nb7BSQJycCJ20qy0vZo6tIXRVnAOew7tDY2I8tS/AGnBPkolUwhE
	2b9hjHfPrH7bmrRrnE/92SHJNWC3R5OsAL+105Bs0vbhfgD/Au2C201aJ0L8u3Jc9hqu+UNFAg2
	bq0jeIIph6lrOyfmGA7Hkwvs7l5qZW1J6B76UngZpj+Hq/TSVm0/OjotA0tZe/Wadp8m2JaoDuW
	e58ZeuY9ilNjQ9E+IHZxwRmqZdoMnT13idCDi6apbgyOWDgDFmoayvUphvfVKFFxb/xwVsFXgHi
	4QdeCoSUHfmC7vTaujMDXZWlL+IS73isRdcwrLTzzRy4Ny6wlDa+4xZ8JJ5Nu6V45DaWfcI80cx
	Q3ms4Gcd7FRazXAsqGdFfQVVrgsYk2pMiw8k9keQOUa18Qw==
X-Received: by 2002:a05:600c:818c:b0:47b:e2a9:2bd7 with SMTP id 5b1f17b1804b1-48373a5d230mr97085725e9.19.1771112986579;
        Sat, 14 Feb 2026 15:49:46 -0800 (PST)
X-Received: by 2002:a05:600c:818c:b0:47b:e2a9:2bd7 with SMTP id 5b1f17b1804b1-48373a5d230mr97085445e9.19.1771112986103;
        Sat, 14 Feb 2026 15:49:46 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796a6b563sm16099143f8f.12.2026.02.14.15.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Feb 2026 15:49:45 -0800 (PST)
Date: Sat, 14 Feb 2026 18:49:42 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Simon Schippers <simon.schippers@tu-dortmund.de>
Cc: Jason Wang <jasowang@redhat.com>, willemdebruijn.kernel@gmail.com,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, eperezma@redhat.com,
	leiyang@redhat.com, stephen@networkplumber.org, jon@nutanix.com,
	tim.gebauer@tu-dortmund.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev
Subject: Re: [PATCH net-next v7 3/9] tun/tap: add ptr_ring consume helper
 with netdev queue wakeup
Message-ID: <20260214184851-mutt-send-email-mst@kernel.org>
References: <CACGkMEsJtE3RehWQ8BaDL2HdFPK=iW+ZaEAN1TekAMWwor5tjQ@mail.gmail.com>
 <197573a1-df52-4928-adb9-55a7a4f78839@tu-dortmund.de>
 <CACGkMEveEXky_rTrvRrfi7qix12GG91GfyqnwB6Tu-dnjqAm9A@mail.gmail.com>
 <0c776172-2f02-47fc-babf-2871adca42cb@tu-dortmund.de>
 <CACGkMEte=LwvkxPh-tesJHLVYQV1YZF4is1Yamokhkzaf5GOWw@mail.gmail.com>
 <205aa139-975d-4092-aa04-a2c570ae43a6@tu-dortmund.de>
 <CACGkMEtRikexX=cJz8zmuvW7mcO7uCFdG7AoHQLOezrsb5nbgQ@mail.gmail.com>
 <59529fd2-2a08-4a89-a853-27198b76f842@tu-dortmund.de>
 <20260214131703-mutt-send-email-mst@kernel.org>
 <1ab166aa-8e9c-4742-a80a-c2fa806218db@tu-dortmund.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ab166aa-8e9c-4742-a80a-c2fa806218db@tu-dortmund.de>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71103-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,lunn.ch,davemloft.net,google.com,kernel.org,networkplumber.org,nutanix.com,tu-dortmund.de,vger.kernel.org,lists.linux.dev];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_RCPT(0.00)[kvm,netdev];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C4F4513DC91
X-Rspamd-Action: no action

On Sat, Feb 14, 2026 at 08:51:53PM +0100, Simon Schippers wrote:
> On 2/14/26 19:18, Michael S. Tsirkin wrote:
> > On Sat, Feb 14, 2026 at 06:13:14PM +0100, Simon Schippers wrote:
> > 
> > ...
> > 
> >> Patched: Waking on __ptr_ring_produce_created_space() is too early. The
> >>          stop/wake cycle occurs too frequently which slows down
> >>          performance as can be seen for TAP.
> >>
> >> Wake on empty variant: Waking on __ptr_ring_empty() is (slightly) too
> >>                        late. The consumer starves because the producer
> >>                        first has to produce packets again. This slows
> >>                        down performance aswell as can be seen for TAP
> >> 		       and TAP+vhost-net (both down ~30-40Kpps).
> >>
> >> I think something inbetween should be used.
> >> The wake should be done as late as possible to have as few
> >> NET_TX_SOFTIRQs as possible but early enough that there are still
> >> consumable packets remaining to not starve the consumer.
> >>
> >> However, I can not think of a proper way to implement this right now.
> >>
> >> Thanks!
> > 
> > What is the difficulty?
> 
> There is no way to tell how many entries are currently in the ring.
> 
> > 
> > Your patches check __ptr_ring_consume_created_space(..., 1).
> 
> Yes, and this returns if either 0 space or a batch size space was
> created.
> (In the current implementation it would be false or true, but as
> discussed earlier this can be changed.)
> 
> > 
> > How about __ptr_ring_consume_created_space(..., 8) then? 16?
> > 
> 
> This would return how much space the last 8/16 consume operations
> created. But in tap_ring_consume() we only consume a single entry.
> 
> Maybe we could avoid __ptr_ring_consume_created_space with this:
> 1. Wait for the queue to stop with netif_tx_queue_stopped()
> 2. Then count the numbers of consumes we did after the queue stopped
> 3. Wake the queue if count >= threshold with threshold >= ring->batch
> 
> I would say that such a threshold could be something like ring->size/2.

OK


