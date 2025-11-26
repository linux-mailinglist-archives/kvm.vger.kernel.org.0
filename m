Return-Path: <kvm+bounces-64617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9311C884C4
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 07:41:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 922AC3B317D
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1EC93191A7;
	Wed, 26 Nov 2025 06:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XNWut/te";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="mIRs/abo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323D2313542
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 06:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764139282; cv=none; b=MbeA8EQP65ccMdcRblOWDSnYEKRZOjAeW4wfClIaSeiC0+8iQOWAyx9tGqCrcUIhU8v6pMUnWLyCd68LLlaN1RME11QSNbvV9P9R0psLpw/f5rqWVxZikDCTLoyDm26ZGafkhn83eNND8qAQ0p/hgLo1+B/L2YAjURKHywdGozo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764139282; c=relaxed/simple;
	bh=QGAnoy4Dpq+iZUpFV+/GD9HeagIzEqq8RFCNZfqkZDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f0ve3ei8LFEPyGrUpjt9ql5AeuL5Z3xK/VXSr9h/SvpQCGAyMz7yAVE9TZ5oGb6kRg2XtAgCrAFRu6q+7RYugx/5lnS/xYUzS+HxTniNPYeEkVZLhfNoD/Kg0TQhxfD197naFt8SfvKKomZIMVcjGbymDXdHTuK7ac7fm8cyBjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XNWut/te; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=mIRs/abo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764139279;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2gwbwF5MFgvvyjCvPMrgDXnD+XmnUmUshXklxp3cjS8=;
	b=XNWut/teH4AsGAgssL5cnU/wQpg7pvN80nGZE0FcfGifvYKcTo1CmbipIVWHs64fbh+f9Y
	XpcaTwHaqmf+AWiGXAbByzwGURoqQgQffDyqxj+fVRWs00qYH8Yx+CCuCtVMQ22thMS2vF
	sELG3hjuQ8BZhT5bm41HQclUVg30u20=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-z2uRhJsdOoyuiOfoC2EpRg-1; Wed, 26 Nov 2025 01:41:16 -0500
X-MC-Unique: z2uRhJsdOoyuiOfoC2EpRg-1
X-Mimecast-MFC-AGG-ID: z2uRhJsdOoyuiOfoC2EpRg_1764139276
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-477cf25ceccso23261995e9.0
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 22:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764139275; x=1764744075; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2gwbwF5MFgvvyjCvPMrgDXnD+XmnUmUshXklxp3cjS8=;
        b=mIRs/aboTeN5nYRFd5LJHGmAv6ykfTRvudIstprujRftAISPrMxzpXwC68yzGNYC0F
         iwQ46f/hRdFwiIyuZn8E3TEqxA7RQlQoXTcgjfPS6MPZh7mdw4mTGIe/HmSW1Z/Y2E7B
         unwZAANJRhANOe1v76N7u2sckjr+SMHV1PB57eYW9XEy+dhZbluu3bBp5HVvZcBONUbW
         4eMOjmqVcKUrZqXNYc/zOvQCVQFM6vgToc1GajuvqH2PzbywhOtyXM7LBoGw2UBifeXp
         TnTPYg0B4Poa+1bmOtg8xDturwecvov2R8idtr4Cewtmb3o0q9OTQqHtyv+e3sigEwzV
         DG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764139275; x=1764744075;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2gwbwF5MFgvvyjCvPMrgDXnD+XmnUmUshXklxp3cjS8=;
        b=VGtVzjJpB0P4D8pGfpeSxFWb1Kr2USA7ylMOREiVIFzqhFQlgEM8iI5UjT6DsGda/V
         YykFhINJ3JoTppLcyNmTgAXPFh2dIcPenwzcfkUEJLSeQ5IOOTNyv/76VT/dcVquGqwx
         zf+uVesKxT5tIjfYzp6OOfjWMmCBLpuXF4x3TIcJoqx7urU2EHKsTRB/r6sRawjPTIR5
         05aPJwgJUdO/3nWoUebqPV+FV2NSnmt6VYl2y7h/RN1emQd0B1Ca2XK/C49g0PYisdV6
         f6941waLhX/6MHbkrorzt5JjFuwZGqsB/sJd4t99//DAI6mUbWiUfypd21wRgwMgSEky
         /S/w==
X-Forwarded-Encrypted: i=1; AJvYcCUMcJY0TwDW7F4XVCzt6opcXdrAWsCeEEp61LV4pkxXRFTkeanoWXpXFvxfSk7V1KxVjSM=@vger.kernel.org
X-Gm-Message-State: AOJu0YztTPhBkFB/hNiJMYEbWeg7Ldr0KvUSRM3cyZB1ObMvyjYuzvtb
	GjePdvP+VFBnEjhz3A0fOoUTkLcrF8Wg6JazLUzdcFQeRq4//jXJPFHtl3cxzdsq8F46lPbNXoe
	gDO6j7Gc2y6EIeh2r0xiyjeZeYlDB5zqZL8K5mbfAaqUinybyLSXgRQ==
X-Gm-Gg: ASbGncsPRsrg/zA+qozIRhWIMWyNv4TacrCaTYA/jUxcgJICa2xWSuUE9mpa2nhSgPb
	N3tOr2HgjcaQruKaaWpLMok6jgOB5DIMMBHf/gUHIdDBdO8tAkPdReEUmXYW5oy9X61c/coM4lI
	8SMuCjV/+paGWBsffvdjjYysUa8+M/BjzYRJ/RBwBrl0oPqsEIrIBFCH8NmD6Y2cVwNz4CjEt2s
	Bzd29sZC33KECZXAbin/Ri6oc2ot91nSeVYoYkPv+MFpIxJb/0k20gK8ZWNWx5tDLjVm2yCfLc0
	xjcWpaAxaJtNmlSXs3GTA05KIS4BhM8HX+6KG+WelXVx7HpFtdzN4k8CQIlxoN8O6vcg2Ni8NWI
	wwqeqPIP7wBl7QElGX4DKZ7UYecRK1w==
X-Received: by 2002:a05:600c:474d:b0:477:7c7d:d9b2 with SMTP id 5b1f17b1804b1-47904b290bcmr52060335e9.32.1764139275453;
        Tue, 25 Nov 2025 22:41:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEDoRireQsP5/XG7ok5T657RYeSY0MQ0WBAZuQRYdeqW40JoE8OKq+SygU0m3K5smDQLLeFzw==
X-Received: by 2002:a05:600c:474d:b0:477:7c7d:d9b2 with SMTP id 5b1f17b1804b1-47904b290bcmr52060165e9.32.1764139275010;
        Tue, 25 Nov 2025 22:41:15 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4790adddb4bsm25619865e9.7.2025.11.25.22.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 22:41:14 -0800 (PST)
Date: Wed, 26 Nov 2025 01:41:12 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Message-ID: <20251126012918-mutt-send-email-mst@kernel.org>
References: <20251125180034.1167847-1-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251125180034.1167847-1-jon@nutanix.com>

On Tue, Nov 25, 2025 at 11:00:33AM -0700, Jon Kohler wrote:
> In non-busypoll handle_rx paths, if peek_head_len returns 0, the RX
> loop breaks, the RX wait queue is re-enabled, and vhost_net_signal_used
> is called to flush done_idx and notify the guest if needed.
> 
> However, signaling the guest can take non-trivial time. During this
> window, additional RX payloads may arrive on rx_ring without further
> kicks. These new payloads will sit unprocessed until another kick
> arrives, increasing latency. In high-rate UDP RX workloads, this was
> observed to occur over 20k times per second.
> 
> To minimize this window and improve opportunities to process packets
> promptly, immediately call peek_head_len after signaling. If new packets
> are found, treat it as a busy poll interrupt and requeue handle_rx,
> improving fairness to TX handlers and other pending CPU work. This also
> helps suppress unnecessary thread wakeups, reducing waker CPU demand.
> 
> Signed-off-by: Jon Kohler <jon@nutanix.com>
> ---
>  drivers/vhost/net.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 35ded4330431..04cb5f1dc6e4 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1015,6 +1015,27 @@ static int vhost_net_rx_peek_head_len(struct vhost_net *net, struct sock *sk,
>  	struct vhost_virtqueue *tvq = &tnvq->vq;
>  	int len = peek_head_len(rnvq, sk);
>  
> +	if (!len && rnvq->done_idx) {
> +		/* When idle, flush signal first, which can take some
> +		 * time for ring management and guest notification.
> +		 * Afterwards, check one last time for work, as the ring
> +		 * may have received new work during the notification
> +		 * window.
> +		 */
> +		vhost_net_signal_used(rnvq, *count);
> +		*count = 0;
> +		if (peek_head_len(rnvq, sk)) {
> +			/* More work came in during the notification
> +			 * window. To be fair to the TX handler and other
> +			 * potentially pending work items, pretend like
> +			 * this was a busy poll interruption so that
> +			 * the RX handler will be rescheduled and try
> +			 * again.
> +			 */
> +			*busyloop_intr = true;
> +		}
> +	}
> +
>  	if (!len && rvq->busyloop_timeout) {
>  		/* Flush batched heads first */
>  		vhost_net_signal_used(rnvq, *count);


Looks like this can easily send more interrupts than originally?
How can this be good?

From the description, I would expect the changes to just add another call to
peek_head_len after the existing vhost_net_signal_used.
What am I missing?


> -- 
> 2.43.0


