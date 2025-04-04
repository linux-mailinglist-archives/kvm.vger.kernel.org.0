Return-Path: <kvm+bounces-42626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C6D82A7B8A2
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 10:15:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A5A3178FC6
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 08:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3C419D886;
	Fri,  4 Apr 2025 08:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aiFVolRo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786C7191F6A
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 08:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743754503; cv=none; b=sqmZjgE1OukMkl0MhSGjXXIT8RjgcLh3rhNSRIFyOqUU8GnxvlFqxg4Tcu5ehp0MDKYdsE+/1R/aAmVW1G0xR945Fmj1hQHtEnEPLk5DQsT6Ns4ww1qOr5QEFi4hNMr4b6aK0hPXOnd3ZygNGZdniqk8Nf08Q4CkVWW9yAe6jtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743754503; c=relaxed/simple;
	bh=AuER94I0UTEjzFOjOSgVJU84xZwyeesTDx/OyQrBbzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NfiyOc+xFzwN//5r4WK0E12Ly4g+yvtBuYUSOpKwzN1qiFILE+Z90h74SoIE17zmU8BSukNq8RvLg2bQC6UZBl2tSD/xyA7NyRY+fg/jX77WtykwqiCXcFN+clhJ60tWwBMJYufZ2TuJFeIbQd3nyq4kcd1fOELac4A9pJQQZfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aiFVolRo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743754500;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kQ6LXxwBQfr8ph0usRujiqrcsoU2uzBJal5na1Y3wac=;
	b=aiFVolRo8rrzkvRVsseBp/L9RTA6mhI4j7+5GoszguIp1SjqYTdUhIB04Sn4gtTJzjH/Xi
	K7zHI/0oMTNNCGh7FAISJgDSPQdTl0Uh4V0Uubd/haokq3onG+mQJDddoAfzwPTgEvuYIv
	GtxlbFwYIxG8io8tCeLVn1t3kEdE7yw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-pta_rBJYO1GOoNumOi9vCw-1; Fri, 04 Apr 2025 04:14:57 -0400
X-MC-Unique: pta_rBJYO1GOoNumOi9vCw-1
X-Mimecast-MFC-AGG-ID: pta_rBJYO1GOoNumOi9vCw_1743754496
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3913f546dfdso1010338f8f.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 01:14:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743754496; x=1744359296;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQ6LXxwBQfr8ph0usRujiqrcsoU2uzBJal5na1Y3wac=;
        b=AYt2iuPHg63l67/CyOkq/R1tyr/rkSg02JqOuM7CTNZcjKyRiki+Ce7Vg0Yi8QlIsj
         cHPolCJOlIaJkhAvkapF/4hcfJ5TN3s4ngzD/x7zEIyzv69LwWjpkiB9ES+0EC1z2Arf
         OPDk0RtuLcqSo+pHU3QUDbftwZaEFT9D2UcA1QOgF3YdgSwy2nYXRJuwkv/W3P/s0J8O
         o6GjxaSzEG4Biw40+K+PRDZXMz3oaaFuQcs2VyI0RZPkmgrP5dP7CntsOIro5cc54tY/
         5dtY2IbLyv69CMsx2BPz4GcRSWhPDBURyaENr9rGDcQxkB0DT2IMi9sWgj2qPIrKbbzF
         MY5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVoZJLQmXZdGaIgQBtAie5qxW9ZhKXFQs0APKwN4IFwxrM0QSNxaJg9qiSwucEHPv5tr4c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWH41ou9SsrW6M22Xr1QrFXFBtlwHu/3TGHVeak/7yJ27vuq7S
	h8U5AwHr0Zb3uWtZ5I3fWC+KiP8sxUdLdQeZK7F8pivCUNkg6HbduRgk4PGQ894H+GpIgtHasdX
	UjmUpCfh1j9ufKC6UJnO4gKI3chUQfcCVAuEIPVjjTExYFdTAaw==
X-Gm-Gg: ASbGncvjQlYAx79PmCWYXsnF7kInpvOuKHUDqveoR05uguviqvoqkkAcI0QrUoJ6hLS
	VZH3TDqT/yiUZxCJwqXmauNFMxOKbzdgjkjke/O/7mo7pFfRwl23IqO++/JsemnEBX0fs85wiYq
	rziMuCkVE/s3fCFSmEGADFqIsYS9eAjtsZerZFl1Pds7h0ove+0OJDjEMgusEJt22iDJVGbZ6tZ
	kCFuNPwGNj+yzQ0ntaPg/lxtxJmNbickh4c/7y6VrMOsOzs7VxdC9IfnhzKR6/guNFWsuyDSit2
	HCr4UtgFLg==
X-Received: by 2002:a5d:5d13:0:b0:38d:eb33:79c2 with SMTP id ffacd0b85a97d-39cb35aed51mr1485127f8f.32.1743754495866;
        Fri, 04 Apr 2025 01:14:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+Vj4KGL4IGFJsWlV8HmZkBJfzGwgl/hz7tDn67gaKw13cLzScEH8EztFdEVpDbeUUKsnsgA==
X-Received: by 2002:a5d:5d13:0:b0:38d:eb33:79c2 with SMTP id ffacd0b85a97d-39cb35aed51mr1485105f8f.32.1743754495425;
        Fri, 04 Apr 2025 01:14:55 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c3020dacfsm3754344f8f.72.2025.04.04.01.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 01:14:54 -0700 (PDT)
Date: Fri, 4 Apr 2025 04:14:51 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, netdev@vger.kernel.org,
	Stefano Garzarella <sgarzare@redhat.com>,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kvm@vger.kernel.org, Asias He <asias@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S . Miller" <davem@davemloft.net>, nh-open-source@amazon.com
Subject: Re: [PATCH v2] vsock/virtio: Remove queued_replies pushback logic
Message-ID: <20250404041050-mutt-send-email-mst@kernel.org>
References: <20250401201349.23867-1-graf@amazon.com>
 <20250402161424.GA305204@fedora>
 <20250403073111-mutt-send-email-mst@kernel.org>
 <32ca5221-5b25-4bfd-acd7-9eebae8c3635@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32ca5221-5b25-4bfd-acd7-9eebae8c3635@amazon.com>

On Fri, Apr 04, 2025 at 10:04:38AM +0200, Alexander Graf wrote:
> 
> On 03.04.25 14:21, Michael S. Tsirkin wrote:
> > On Wed, Apr 02, 2025 at 12:14:24PM -0400, Stefan Hajnoczi wrote:
> > > On Tue, Apr 01, 2025 at 08:13:49PM +0000, Alexander Graf wrote:
> > > > Ever since the introduction of the virtio vsock driver, it included
> > > > pushback logic that blocks it from taking any new RX packets until the
> > > > TX queue backlog becomes shallower than the virtqueue size.
> > > > 
> > > > This logic works fine when you connect a user space application on the
> > > > hypervisor with a virtio-vsock target, because the guest will stop
> > > > receiving data until the host pulled all outstanding data from the VM.
> > > > 
> > > > With Nitro Enclaves however, we connect 2 VMs directly via vsock:
> > > > 
> > > >    Parent      Enclave
> > > > 
> > > >      RX -------- TX
> > > >      TX -------- RX
> > > > 
> > > > This means we now have 2 virtio-vsock backends that both have the pushback
> > > > logic. If the parent's TX queue runs full at the same time as the
> > > > Enclave's, both virtio-vsock drivers fall into the pushback path and
> > > > no longer accept RX traffic. However, that RX traffic is TX traffic on
> > > > the other side which blocks that driver from making any forward
> > > > progress. We're now in a deadlock.
> > > > 
> > > > To resolve this, let's remove that pushback logic altogether and rely on
> > > > higher levels (like credits) to ensure we do not consume unbounded
> > > > memory.
> > > The reason for queued_replies is that rx packet processing may emit tx
> > > packets. Therefore tx virtqueue space is required in order to process
> > > the rx virtqueue.
> > > 
> > > queued_replies puts a bound on the amount of tx packets that can be
> > > queued in memory so the other side cannot consume unlimited memory. Once
> > > that bound has been reached, rx processing stops until the other side
> > > frees up tx virtqueue space.
> > > 
> > > It's been a while since I looked at this problem, so I don't have a
> > > solution ready. In fact, last time I thought about it I wondered if the
> > > design of virtio-vsock fundamentally suffers from deadlocks.
> > > 
> > > I don't think removing queued_replies is possible without a replacement
> > > for the bounded memory and virtqueue exhaustion issue though. Credits
> > > are not a solution - they are about socket buffer space, not about
> > > virtqueue space, which includes control packets that are not accounted
> > > by socket buffer space.
> > 
> > Hmm.
> > Actually, let's think which packets require a response.
> > 
> > VIRTIO_VSOCK_OP_REQUEST
> > VIRTIO_VSOCK_OP_SHUTDOWN
> > VIRTIO_VSOCK_OP_CREDIT_REQUEST
> > 
> > 
> > the response to these always reports a state of an existing socket.
> > and, only one type of response is relevant for each socket.
> > 
> > So here's my suggestion:
> > stop queueing replies on the vsock device, instead,
> > simply store the response on the socket, and create a list of sockets
> > that have replies to be transmitted
> > 
> > 
> > WDYT?
> 
> 
> Wouldn't that create the same problem again? The socket will eventually push
> back any new data that it can take because its FIFO is full. At that point,
> the "other side" could still have a queue full of requests on exactly that
> socket that need to get processed. We can now not pull those packets off the
> virtio queue, because we can not enqueue responses.

Either I don't understand what you wrote or I did not explain myself
clearly. 

In this idea there needs to be a single response enqueued
like this in the socket, because, no more than one ever needs to
be outstanding per socket.

For example, until VIRTIO_VSOCK_OP_REQUEST
is responded to, the socket is not active and does not need to
send anything.


> 
> But that means now the one queue is blocked from making forward progress,
> because we are applying back pressure. And that means everything can grind
> to a halt and we have the same deadlock this patch is trying to fix.
> 
> I don't see how we can possibly guarantee a lossless data channel over a
> tiny wire (single, fixed size, in order virtio ring) while also guaranteeing
> bounded memory usage. One of the constraints need to go: Either we are no
> longer lossless or we effectively allow unbounded memory usage.
> 
> 
> Alex


