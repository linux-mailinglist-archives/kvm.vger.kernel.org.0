Return-Path: <kvm+bounces-64575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 333B2C87862
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 00:51:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5FAC34EB4F1
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 23:50:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1F872DF151;
	Tue, 25 Nov 2025 23:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jMQV/RVW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AKy3ZVkK"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2E82F12A7
	for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 23:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764114630; cv=none; b=uiCHgCskzsQI5N0pB0Az1LXgiBecoma/sCjGWlt8KPAk2FI4r1zIEe6338Xk4XbWXI21BCJdb3AOz9Prnqo1rWt4WgbXUH/vwzH9ih8aoutnz8XSB0LWtLw+nQU+EiVor9dkSzeOm0fbiluqVzrLivJN0IRQe4rZoQDxsV6W3LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764114630; c=relaxed/simple;
	bh=VR/QlSFYXfB2XAkyEqk2La815NaXCesg1lVuqP0+cyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kegp4Di4ru6YCy1iOihmYsXn+FI7r6aCcgXFs93i6Gaku0eJr8BaP5prHJSRgGne7yIs0UBTOnjUFJkcwxEjcoKh3u8AB0WK2iuEmED+p5Sw3o7UYyZcYrjhN1V1IiC6SCZi68p45SRUTXAHCw5InIUJDzrPWrqEifx1oYyRh+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jMQV/RVW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AKy3ZVkK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764114627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rIwS7E0jdpZel3anL6UezeiFSzMWSTuk00aa6Qzm+5s=;
	b=jMQV/RVWTdbHi/b6gkUA7hBBNlvuHQDMOiHjbmnWfFrl0ZBRmrl6FK4KSe23UT2jSzE6w9
	5wsjvmEIQqJUrg99I2ib7rDrqZsXyVy/BWk2cKcKs97ou6ydD02Dw0W0pMFnzLuDIumvxq
	CK4emBnp9GlDGSk5sDB+yi2jDe8hcbg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-lxEKwHS0Oimt7XewNbO-CA-1; Tue, 25 Nov 2025 18:50:25 -0500
X-MC-Unique: lxEKwHS0Oimt7XewNbO-CA-1
X-Mimecast-MFC-AGG-ID: lxEKwHS0Oimt7XewNbO-CA_1764114625
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-429ca3e7245so3000366f8f.3
        for <kvm@vger.kernel.org>; Tue, 25 Nov 2025 15:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764114624; x=1764719424; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rIwS7E0jdpZel3anL6UezeiFSzMWSTuk00aa6Qzm+5s=;
        b=AKy3ZVkKL1lF1IVsOpuUpB0EsE1qPUgLKNQJyujF7MBqRno9gF64A/IPOmoqELpIDS
         GU5U2EHwMmk25vGrwPAnmLDGEkCpp5PlbmHbR4pj3Z68FQf1qByvjY8oZxYSdcTigDKu
         4CWmsF67v+s9q5gzNkxbc5Ys/AOjSjYsc9RfZdJufT8BFGuFM8uLxJ+SHazvBhxhoLa7
         CFmDK8k42IMAe6jlCETQtb6MZ1KMjGfMvQsgAZT25D7e5p92sJ9Q1xlmSoUlcjT2id8/
         garHq+bqIcu9IIlTj1EEVYQYFOU1I6aVEs+t8/22e+euL9QJH4Ivf4U7CpichSuYR3pe
         CkxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764114624; x=1764719424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rIwS7E0jdpZel3anL6UezeiFSzMWSTuk00aa6Qzm+5s=;
        b=fEA/ALoZ2fayxmxx614LfjYoN4HzO+yLEIZiBHixht7yZbYU1avZVmNlq5VEd6tYVD
         A6v4vQcvow0nYd0CL4ep2KbKFvxCSB6B6ks9gMNpnEpgG267jHCY5z6WnRnmYOyrGatp
         yrjTQbaeMs5E7DK1svdodejMgE+jMtsHITb7wjqvhSEaAc0mchO5nGwXogy3nO+1jeTP
         NTPW+cAzwwhrWTyHXhRaLyI1WRDmUKmXjO8pOBwF2H9UmHvQKFCkaS7EU4+Rmt4/DdSK
         9DHIED0z5lGgfN7NmQARBRtA2M/RjNLg/nECNPpeO6mwJPa4O1fpBOefY9ybBs7XfreS
         g0RQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4EV/MfcwkvOKjIJ0EnM9rIEOH1yDQf7/xCclZjdetLWOsDVCtBHWm0af8wsQLs9X9/3g=@vger.kernel.org
X-Gm-Message-State: AOJu0YyyLZoHAy4VsVnge9fKINpLOlFOcg5wN59WBBBZ1KXjTwVpXndG
	BlkqguokpTbU8pPXeQaB/QnLYXxYmgDdJN2fUY52wpNnP8sN06ud3ng4qB/JBVyEJyvvK7y+WHV
	rtDqZtHgjheEUZInwbEA68Tm6h2qlZX3zxZl1bdTeD6B0n9i+eGibEjbTbgvwMQ==
X-Gm-Gg: ASbGncsjwjfsZFF5gC7cHFlQE/qK2ZkT9bRik2bq6VTu1JtptVUuPnVC1ZBHlL9zJ8E
	qf7doxykui7nyCoqyqFWi3BJC72NiAejbL4ONf7LfpUTNYh9U1gBjaPv/oVdnxZFAp7mCuBhwoe
	ndW5D3q5wyzx/vengtFLPec/sdTV4yP+RAkBj6+nq9ozFs+rw20FsqCc4FWoIJ6Tgud/9bq0kI2
	nuE8nkD+vz4boz03mCkyAocH+UHgJfg2cIs3o7WFRNC0jRtYD3VBulTtYZU9keWsMAjSkibtd6s
	3LpuVffekgxYD7R+A3STkyN/i98iHeQA7EsIcQGaVXxQ/zER4bciTjm4Pc5yuvaE/Wixj7ugRUK
	whWO/xI7CGg4+vIE5DSe+4cI30QdBBg==
X-Received: by 2002:a05:600c:1c25:b0:46e:4586:57e4 with SMTP id 5b1f17b1804b1-477c114ed70mr261113145e9.24.1764114624356;
        Tue, 25 Nov 2025 15:50:24 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnq4RJlt9m2aS6c4TGKhjJ1S2uVgEkT/HKNHftYudQTJJrbCWeUDlCnlsQl791oaHujLBMkw==
X-Received: by 2002:a05:600c:1c25:b0:46e:4586:57e4 with SMTP id 5b1f17b1804b1-477c114ed70mr261112975e9.24.1764114623865;
        Tue, 25 Nov 2025 15:50:23 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-479052def4bsm26279025e9.13.2025.11.25.15.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:50:23 -0800 (PST)
Date: Tue, 25 Nov 2025 18:50:20 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Message-ID: <20251125184936-mutt-send-email-mst@kernel.org>
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

Given this is supposed to be a performance improvement,
pls include info on the effect this has on performance. Thanks!

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
> -- 
> 2.43.0


