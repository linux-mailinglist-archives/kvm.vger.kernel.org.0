Return-Path: <kvm+bounces-66708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5CDCDEC5B
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 15:50:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7E9763004416
	for <lists+kvm@lfdr.de>; Fri, 26 Dec 2025 14:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B309A194A76;
	Fri, 26 Dec 2025 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WTAFdQBN";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hJvbHwa8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F17219EB
	for <kvm@vger.kernel.org>; Fri, 26 Dec 2025 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766760648; cv=none; b=Qk8yKX6R51E4wOZhaHbvGEHW0CfZb2ZNMUkkXqxXFs/8uG2G2QlXL1Tmnkf7Vv0A2QfZVJQOquk0M2EfKNCuJipyyIc8iMjtBOjrQiEc1cR9hOQuz8Hc2aLIhOTxQ4vQyOcEHeyWxYWCzfI4qgBWD2VRQ5wavNUSsprk20O0B/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766760648; c=relaxed/simple;
	bh=PKXRGzbxh1OlfF0T9/TV4KDNz94u0vtq7bXgSU6XVJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KRXTXnT1OKU/R4oNMIXKZwTLI9+LYSapd3pnOlYa9lzMJIcCTDeUwiwYTo486MY6xr9TGiUA8FX+ydOvzzLtr3uD1our3gcg9fVU8bXAq5EL1XUSWg935kDX7PbpvithEHiMpPCTI2in3C/tXIZVOC3lbEuSeTL8IXphjOzwldM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WTAFdQBN; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hJvbHwa8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766760646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7KQs8vvsCuYX4f4WNDWRFaCkEzOPPZG4H4J2HYQGAcg=;
	b=WTAFdQBN3oCJlv/bsrTK5NZb1/c/0bstaYlGeCFAjwNQ/FEPJ6+clqRtnkTYJUUV7PLk7J
	HTclUQWLRaVfnRPGY4G6bhSWrkZMYwg21QWrA7wAlB/mThpRN1g3S+YCf3VXiOVvfkbiI2
	u5FJGgOtWMaURp0UJ0LfyVVf72VwJ18=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-L2dlSmEePUSEZwhXwkYmiQ-1; Fri, 26 Dec 2025 09:50:44 -0500
X-MC-Unique: L2dlSmEePUSEZwhXwkYmiQ-1
X-Mimecast-MFC-AGG-ID: L2dlSmEePUSEZwhXwkYmiQ_1766760644
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-430ffa9fccaso5820413f8f.1
        for <kvm@vger.kernel.org>; Fri, 26 Dec 2025 06:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766760643; x=1767365443; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7KQs8vvsCuYX4f4WNDWRFaCkEzOPPZG4H4J2HYQGAcg=;
        b=hJvbHwa8799PBmwVOaM7bXW0c3KVddDUR7e4R5OuikJxn6hBT7RUWFohqIH9v1pPJy
         PY2MA8sxSPDrGBkZhaCbXBUUNx2N3o8N64d3qIALdKsFMCmUANXAGB9vaoVdMnx8nkFj
         vEInM1eG82QFqFO3d5BD0WBOIMvIokA0l5i/MOHhJH5FJmo66lH9NI0VroFuCNB8YDen
         fT11EuZ1T5obyw3DWWCTaju9c1j1GD9/SDNZwOnlRnBH33C4AEl4zV/BPJDgr0OWUF+Y
         yfkSmp7NipJkR3/pFUYj94LX/Op0Gd00oFylx7EucAsBiXjMCnIBSp0Jjw2aMUephgjo
         cQzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766760643; x=1767365443;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7KQs8vvsCuYX4f4WNDWRFaCkEzOPPZG4H4J2HYQGAcg=;
        b=uDezCTH0o9kIpe7xaWXruRaalzZPVvIXcUlyJYFtnI7jvmpD5Gv5I1ur/uieSVjFIs
         YGkmDFcDsHcEWBGW5cZX1asksLEEBUPIqKCd5KfMBJY1IkufjadX21xTHvyZ5P7vSkHn
         62rc4Y+uXClKaYHiAy+LF61zvctL8fxOcEvA8q5wrUMHuY/eiZwtjUgKzuzLt25Omde2
         PUFKywBXh/zxDn/oBeVDR0vgUVeH2TEszu+4dp2rTmB7apctGSoa1m2+/vkuos5nj1Vv
         E81b4I7B8mZkKy0JpAX+gAFvZhxuf2pkhePCnuv5rmdgrsZhmfVDuHHloUTKredSFQcY
         DlrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvDsZS1bi3eW5nHarULKYYuADI9mtnVP0CA8UpOjcJrvexhxGI/WTeEKJLORb7TRIp6V8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzFP2eLZBPIVGJUe3Bys/jaspdM7JBoOV7f5mNhoncwnasopjSl
	mXZcKwPrrKfKBRdeUKlmPOFcIqxsQegYZB1c1GqUpc7HNQGAg//Y45c8nvbXLjUvdhlNzeBBZl4
	b5k8cxgt6lMH8Ws38JP2HXKiH9aRchbyK7nKrjIjW215Iywde16pgfA==
X-Gm-Gg: AY/fxX46pH7ho0sO/J6Fq7CTXu1/l6vjV5s8a85iHog7pL5AEFc5+PZqq2BVx/PhUZp
	86Z1WMKrnDzTKdNY2P02YgRaFRotO6YTTxdAXzc5C8K7lcwtDrxZxrKfvbdMCobG8m8IkzRAFLO
	GeRpLFO9SVzXDtMMcAdhdgKxqeDIrncF9/suUc1DtgTkqM7Z9GAsEAxWFI96FRQvagAXqJqKVGs
	p7rcjGPc2T+cOVCNspomQk//UdqATUbTDBfrhrJfUf+94QFvY5HS4GaGHWUGvXvrXPrmB+9+xf3
	pT15T1gxJYX5h2HvuRXf/n3uweQXPnh8gvt4Juq3vKD7MoDlDrVpnJZUzk67KBNw9TDKMo8dOyG
	ygk3QEf9Rk6ke5VvQujKgUMIokp46I5Wlxg==
X-Received: by 2002:a5d:4e46:0:b0:430:fe22:5f1c with SMTP id ffacd0b85a97d-4324e703af5mr20129796f8f.59.1766760643537;
        Fri, 26 Dec 2025 06:50:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGMQ5W8XwHXEz0VCwLYh7DYgtWB1N+w4NhUInEUeh59gqlc2IFDP3VMltMmESqxQ1YzyY8Evg==
X-Received: by 2002:a5d:4e46:0:b0:430:fe22:5f1c with SMTP id ffacd0b85a97d-4324e703af5mr20129768f8f.59.1766760643060;
        Fri, 26 Dec 2025 06:50:43 -0800 (PST)
Received: from redhat.com (IGLD-80-230-31-118.inter.net.il. [80.230.31.118])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4324eaa46c0sm46411703f8f.34.2025.12.26.06.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Dec 2025 06:50:42 -0800 (PST)
Date: Fri, 26 Dec 2025 09:50:39 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Message-ID: <20251226094933-mutt-send-email-mst@kernel.org>
References: <20251125180034.1167847-1-jon@nutanix.com>
 <20251125184936-mutt-send-email-mst@kernel.org>
 <4F24DF4D-7F5F-4BFC-B535-57C1AD66762D@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4F24DF4D-7F5F-4BFC-B535-57C1AD66762D@nutanix.com>

On Wed, Nov 26, 2025 at 04:49:11PM +0000, Jon Kohler wrote:
> 
> 
> > On Nov 25, 2025, at 6:50 PM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > 
> > !-------------------------------------------------------------------|
> >  CAUTION: External Email
> > 
> > |-------------------------------------------------------------------!
> > 
> > On Tue, Nov 25, 2025 at 11:00:33AM -0700, Jon Kohler wrote:
> >> In non-busypoll handle_rx paths, if peek_head_len returns 0, the RX
> >> loop breaks, the RX wait queue is re-enabled, and vhost_net_signal_used
> >> is called to flush done_idx and notify the guest if needed.
> >> 
> >> However, signaling the guest can take non-trivial time. During this
> >> window, additional RX payloads may arrive on rx_ring without further
> >> kicks. These new payloads will sit unprocessed until another kick
> >> arrives, increasing latency. In high-rate UDP RX workloads, this was
> >> observed to occur over 20k times per second.
> >> 
> >> To minimize this window and improve opportunities to process packets
> >> promptly, immediately call peek_head_len after signaling. If new packets
> >> are found, treat it as a busy poll interrupt and requeue handle_rx,
> >> improving fairness to TX handlers and other pending CPU work. This also
> >> helps suppress unnecessary thread wakeups, reducing waker CPU demand.
> >> 
> >> Signed-off-by: Jon Kohler <jon@nutanix.com>
> > 
> > Given this is supposed to be a performance improvement,
> > pls include info on the effect this has on performance. Thanks!
> 
> I had already mentioned we’re avoiding ~20k schedulers/IPIs in that
> example, but I can add more detail. Let’s resolve the other parts of
> the thread first and go from there?


the discussion seems to have died down.
I suggest reposting with perf data you have
(which test, how much improvement, what cpu usage)
collected in the commit log.

thanks!

> > 
> >> ---
> >> drivers/vhost/net.c | 21 +++++++++++++++++++++
> >> 1 file changed, 21 insertions(+)
> >> 
> >> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> >> index 35ded4330431..04cb5f1dc6e4 100644
> >> --- a/drivers/vhost/net.c
> >> +++ b/drivers/vhost/net.c
> >> @@ -1015,6 +1015,27 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
> >> struct vhost_virtqueue *tvq = &tnvq->vq;
> >> int len = peek_head_len(rnvq, sk);
> >> 
> >> + if (!len && rnvq->done_idx) {
> >> + /* When idle, flush signal first, which can take some
> >> + * time for ring management and guest notification.
> >> + * Afterwards, check one last time for work, as the ring
> >> + * may have received new work during the notification
> >> + * window.
> >> + */
> >> + vhost_net_signal_used(rnvq, *count);
> >> + *count = 0;
> >> + if (peek_head_len(rnvq, sk)) {
> >> + /* More work came in during the notification
> >> + * window. To be fair to the TX handler and other
> >> + * potentially pending work items, pretend like
> >> + * this was a busy poll interruption so that
> >> + * the RX handler will be rescheduled and try
> >> + * again.
> >> + */
> >> + *busyloop_intr = true;
> >> + }
> >> + }
> >> +
> >> if (!len && rvq->busyloop_timeout) {
> >> /* Flush batched heads first */
> >> vhost_net_signal_used(rnvq, *count);
> >> -- 
> >> 2.43.0
> > 
> 


