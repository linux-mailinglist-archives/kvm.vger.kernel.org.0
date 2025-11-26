Return-Path: <kvm+bounces-64631-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 470F3C88C82
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:57:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2B3054E11E2
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:57:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1C6B31A81A;
	Wed, 26 Nov 2025 08:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bcZdu+6j";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="frzyIn6U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BA6280CF6
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 08:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764147418; cv=none; b=T0B8E4aGrh2LIdpzsfzrnV2rBoVJm5+FIOD1iQDEWColjmqnoOliJBHTuF5rNpQ4DmlC4+DduyYrrXZhdTI2HXsIhuTDQisECo3nbWDAO/u4fhZldWrV+ixsqKw2YviaeXJfBulOB+etuPfLv3HGXn6OMuXsYoQ1HOYAiIxAlfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764147418; c=relaxed/simple;
	bh=6t9MHJvf6sqh5JX+QcZaEOpVyD9pO0GspMuqeY837mk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lim9CkWmoDbUdXTJGx7Iz7cpHck1qM5tZqRt3oNJOUGnvekn0TpYI+E+VZwIKo8MCwO1rm/9c3RFeLfx7NTOOLylP2mzaR7yTH/kKIjKx7iPxYn1iURAMZkIpMr1VJ1dDRnaCe2k01sBGVvCh0iUo/SFuLxzHQ0XdDIQGpVHqEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bcZdu+6j; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=frzyIn6U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764147416;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kip/JEcZ74T1Ftt4LkCGX9wwyy/CfbbaxlGjsxIU+gQ=;
	b=bcZdu+6jDkGblo3ux+/ZnH17VCKYFdVEmKH4baCKMVn9orSUKIQx34Zgmq5uhHsjebXN9u
	kRL1QZ4vJ71nnfVxl5bzJa2pnWsynBOPjN20vpiP6ynm50UiVl3tZVTFv8vryyDJgr7OdX
	hjGV6ur+wwUkjIGC7Z6/mtMZnIzrzr0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-odRLXEOkML-StjPlOtBXqw-1; Wed, 26 Nov 2025 03:56:54 -0500
X-MC-Unique: odRLXEOkML-StjPlOtBXqw-1
X-Mimecast-MFC-AGG-ID: odRLXEOkML-StjPlOtBXqw_1764147413
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42b5556d80bso4621649f8f.2
        for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 00:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764147413; x=1764752213; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kip/JEcZ74T1Ftt4LkCGX9wwyy/CfbbaxlGjsxIU+gQ=;
        b=frzyIn6UexhXgRlFCvi2fHovtHaKZKZPxbi7dA2mPhg90aTv/5zudEhdAF0mKA6FXG
         kKdRM3MfrR1bpVwpTXxBfgWkfFHoktUrWfhjIXhIzHJMxE2oXijp3KA4042mAEfSCY3A
         JWzvP+p7/BeLTxizlqdk9YvdE8wSROGorTgsTTN2bxNqtnRN1m9iRRh8qWMpoIWgvP0S
         VT517winOgSqGsLqP6dRXWp2DFkBaevGh9G+QoAH78DRoazCX+lDGouiwnYIimbSpNLY
         wAGoA/8VM79gb6yM/9jHPf2fIAHhMsyjLq+oGsVjGMGXP5pVrrvXuYKdIqjmVVOdTmmL
         8EMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764147413; x=1764752213;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kip/JEcZ74T1Ftt4LkCGX9wwyy/CfbbaxlGjsxIU+gQ=;
        b=OTBKWm5C9kM4rinBmSDhRtru2U1pATwFaSLoaEQbaXwtJJuAvWlkL6gh80IVqD94lb
         OurfU3HwCrOlqfqU3aesV2DWsFFl8zbyf+bRBHn8Bki6/J8bSHEshawqNeXXnrqI6ypQ
         EbgqrRWgDhsVCIXbExDFmPJuwnqMtjlg6VPV5MwjO3+o7HcWcfY5i/PSUfQvIog2toly
         O0cfKoLgLTAuPFDnHlY6HQWghNbizMpsw08pSogd0jSq81S05YaWjmItv+WybiyOGD3+
         5XQjfm03QvMkxf1ymj3x3diCQFxcUZwZLL8X+H5aMKKGNNO0/M/TzWan1U4U0PDJwejK
         eGcw==
X-Forwarded-Encrypted: i=1; AJvYcCXbhh1eO6E7lPQlJqlD5OpUsYugL8nCSuRCoQvAb+I2CTXLEEutH2eqFnsTq6kMAAlXG0A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz76W+bLLuiICzzQn8ndYb0w9RzoDW9nOK0bf5kOJGKiG79pd4O
	Gs3thEwGjPLCNCMR6ntf34I/a5kc87MVMutEJuLEtebGs76RaGQ18ExLKfBtP3kzfe0CwMi5XC/
	cWABmGbsRjXmYiUTuFUNAqlZTK4O215J8vwvb5NVjumodP32IlhMRRw==
X-Gm-Gg: ASbGncsiP0RTIlj8XjXhRVVLTq5qGb5Ddf+JNvAXYwRAWykGJbQgYIAKm3P2n0K8qsB
	4Q4zOHTMxptjuEsS2PXUJwiDb173Qf23IFmBDJ6UXIRwIPTCdF4tE3PqJD2wvDlw6W8cPutpOWm
	nsqzNAS6aKVvR+dMfn7FlZoff8XM5QPYArSBqSEGkSoNOVsnGpzQtH6KVwwnyn/DA7cPxj4dDeq
	ACRzdjel4QjOo2YbfQ2+lX3W9leRS1PBy6L/3GyJwhtgKbur8TbP8dI40SMH2lhRj+SgHrOTxeb
	jNV3rf7ncA1cmGWRgBSUhD3a7tj6Z5LYwwjlw7mQ9tyL/d1pkHYmCJ7/Rby59tGf4Ss/QSBMxBF
	ZXdYqKSIA9lKF1xK3MdS5gENTTA52dg==
X-Received: by 2002:a05:6000:26cf:b0:429:d66b:507f with SMTP id ffacd0b85a97d-42e0f34f9a3mr6307241f8f.48.1764147413174;
        Wed, 26 Nov 2025 00:56:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGHNNJ+IsPSYIWyu2oPIp2uYsK6e3LWHa7plQXIOftsh9/qPOW1IRQVxpm4kwwQqwDr9WWQeQ==
X-Received: by 2002:a05:6000:26cf:b0:429:d66b:507f with SMTP id ffacd0b85a97d-42e0f34f9a3mr6307216f8f.48.1764147412671;
        Wed, 26 Nov 2025 00:56:52 -0800 (PST)
Received: from redhat.com (IGLD-80-230-39-63.inter.net.il. [80.230.39.63])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fa3592sm37810702f8f.21.2025.11.26.00.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 00:56:52 -0800 (PST)
Date: Wed, 26 Nov 2025 03:56:49 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] vhost/net: check peek_head_len after signal to
 guest to avoid delays
Message-ID: <20251126035449-mutt-send-email-mst@kernel.org>
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


I also wonder why don't we assign len here.
I get the point about being fair to TX but it's not
indefinite poll, just a single peek ...

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


