Return-Path: <kvm+bounces-46942-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 09973ABB1C4
	for <lists+kvm@lfdr.de>; Sun, 18 May 2025 23:39:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 051067A4040
	for <lists+kvm@lfdr.de>; Sun, 18 May 2025 21:37:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A683524F;
	Sun, 18 May 2025 21:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UZr1rOfb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1081917E3
	for <kvm@vger.kernel.org>; Sun, 18 May 2025 21:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747604313; cv=none; b=s0xTXWspjwdxoHfNSxDDceTbaIsxxLPj6rsnYbFqguRxLOeafyRHB6WpQzCqrSmWWDzlOKl8XutKdtOuQssG52qDocxoTmvGNoWjFeg2xEpKyGyyxBI4Rb34xHDJ1ESfzMpRmWpPyLvfWn6QKHRc+g3cE6ic40MaAMuuFPbFjkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747604313; c=relaxed/simple;
	bh=IY5YxUgfeivoNaGKuPIC9nYUq6Yn5iTNzaXtAmgFxWA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oP0zkn6+9ZXG2NOXvEFbQiYW3SrWVmyxrXgpx61hGVzsnJeKBkdSbY3JiMEL3Xwgr8La/5lzVlrN2fqUhKJy7BBoGD+njExhRjiWPi+kw23ZLJG7BmPR4e5R55FRmcwe+tQdUx/OFEs4s61KXmSrtIXMk64iEEo2fD06YtVirPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UZr1rOfb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747604310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2DxfFVVppWL2QDoeVADckrWoeG/v7XssiZgeHgdT/vk=;
	b=UZr1rOfboB5AypuAyhh5MGYPeKBw3dKb1JLCbgJ1lA4sqMyrK72mKUngXF3K3to380hlfl
	jEkE54ecCs3MvSVBMdbk3m8BSdbNln/8nXISQ+zaVT4W9uF825e3BGy44ePaLyq0hyJZl5
	Qcgq8EQszsXSpHlzRcPN14cgGfp6PJ4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-653-dcZNlur-OL6qRxJvol31Kg-1; Sun, 18 May 2025 17:38:28 -0400
X-MC-Unique: dcZNlur-OL6qRxJvol31Kg-1
X-Mimecast-MFC-AGG-ID: dcZNlur-OL6qRxJvol31Kg_1747604308
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43d209dc2d3so23465215e9.3
        for <kvm@vger.kernel.org>; Sun, 18 May 2025 14:38:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747604307; x=1748209107;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DxfFVVppWL2QDoeVADckrWoeG/v7XssiZgeHgdT/vk=;
        b=qz4KxMqvfzLk2Yqo/R+A64XdMPcD1Y09hFxFK1bEJqB3h1tqSV9ynf+7kyLoipkFb7
         2PyJMZ84eLP6w638POoU7jriyIsYpvGULteEB9nUADXMtIkmjrdvrXGnZGnbb9CUPjRM
         PlWZUY7MH8aS/XyEcyV364e7dzL4hYpxUVUvnJRgioiqpFu1Ih6mgFHnn49BxXHlYngg
         TS7VSIYD8MRQqifjCAeem4pqlCkIjxLY6GaD8f2c7u51v1Ply8+pH3ZUjnDi/argUpsA
         58ZBgHcMQbpgS2mwvVMSrcdFFLzvNt1Ou9+ZIJoctR4AOz/UL4RGCNRlOcp9vMhHlVb/
         b6tA==
X-Forwarded-Encrypted: i=1; AJvYcCUmusHIF3wmVqWxh1+XQjiyok/a+fRaT3+/J6RfMwKUzOa4GUl33H5bh3jNAw8gJ7o9Xck=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOKJW2bXvepCE+uX7mHFgtGKe34opR+fcvsvMwvwNHD3rZMKTA
	aHZFCy3rXYAHnkKRR2v7xkUEKTNAY4NbVEPuOGBBOp1rMwUSH4h25B2LJWfDEGsYCEhOnMEnH3f
	JkO3REbo2/fadBJAoG8qAuG6cMeQSIZbpn+5p7/TmojMpSt6ZQpqziA==
X-Gm-Gg: ASbGncv88qpvsFlxTd7b0WlHHPDPaEf2/FyiTOKngNXKyvEmFzToS0AU6mH2e0IQboP
	8IbNe+qe3tj+uDHW0cywZueFivfdRwEhFUrYatWFQ+dkT1DMOxstQGJSjcjoDJ+Cz3hDEEMvmM9
	EDOojricXtRUeJrH38gRXLcNPQl4x9doWHrhPIIzLJBd7wmZP4NYVH5cGTz4l2uexdsInlRvlDm
	lr5VF7J9WrzM7zKmkwdSc+qI3Y6EQHAN8z7pRRT0lGgAOXy6RA5I1y6ZgUpVO37Spp+XOSrnBGI
	xlxhbw==
X-Received: by 2002:a05:6000:2a4:b0:3a0:b5ec:f05f with SMTP id ffacd0b85a97d-3a35c84bd9emr9695875f8f.39.1747604307623;
        Sun, 18 May 2025 14:38:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPvcQqiUdzhpUsTAuhZDZDZTf1fjEgpPyr6jPbRPZ5J04iBfqTi3ZNActvJ+NaYfNQu9hbkw==
X-Received: by 2002:a05:6000:2a4:b0:3a0:b5ec:f05f with SMTP id ffacd0b85a97d-3a35c84bd9emr9695869f8f.39.1747604307288;
        Sun, 18 May 2025 14:38:27 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442eb85bb20sm131025615e9.0.2025.05.18.14.38.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 May 2025 14:38:26 -0700 (PDT)
Date: Sun, 18 May 2025 17:38:23 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Message-ID: <20250518173756-mutt-send-email-mst@kernel.org>
References: <20250420010518.2842335-1-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250420010518.2842335-1-jon@nutanix.com>

On Sat, Apr 19, 2025 at 06:05:18PM -0700, Jon Kohler wrote:
> In handle_tx_copy, TX batching processes packets below ~PAGE_SIZE and
> batches up to 64 messages before calling sock->sendmsg.
> 
> Currently, when there are no more messages on the ring to dequeue,
> handle_tx_copy re-enables kicks on the ring *before* firing off the
> batch sendmsg. However, sock->sendmsg incurs a non-zero delay,
> especially if it needs to wake up a thread (e.g., another vhost worker).
> 
> If the guest submits additional messages immediately after the last ring
> check and disablement, it triggers an EPT_MISCONFIG vmexit to attempt to
> kick the vhost worker. This may happen while the worker is still
> processing the sendmsg, leading to wasteful exit(s).
> 
> This is particularly problematic for single-threaded guest submission
> threads, as they must exit, wait for the exit to be processed
> (potentially involving a TTWU), and then resume.
> 
> In scenarios like a constant stream of UDP messages, this results in a
> sawtooth pattern where the submitter frequently vmexits, and the
> vhost-net worker alternates between sleeping and waking.
> 
> A common solution is to configure vhost-net busy polling via userspace
> (e.g., qemu poll-us). However, treating the sendmsg as the "busy"
> period by keeping kicks disabled during the final sendmsg and
> performing one additional ring check afterward provides a significant
> performance improvement without any excess busy poll cycles.
> 
> If messages are found in the ring after the final sendmsg, requeue the
> TX handler. This ensures fairness for the RX handler and allows
> vhost_run_work_list to cond_resched() as needed.
> 
> Test Case
>     TX VM: taskset -c 2 iperf3  -c rx-ip-here -t 60 -p 5200 -b 0 -u -i 5
>     RX VM: taskset -c 2 iperf3 -s -p 5200 -D
>     6.12.0, each worker backed by tun interface with IFF_NAPI setup.
>     Note: TCP side is largely unchanged as that was copy bound
> 
> 6.12.0 unpatched
>     EPT_MISCONFIG/second: 5411
>     Datagrams/second: ~382k
>     Interval         Transfer     Bitrate         Lost/Total Datagrams
>     0.00-30.00  sec  15.5 GBytes  4.43 Gbits/sec  0/11481630 (0%)  sender
> 
> 6.12.0 patched
>     EPT_MISCONFIG/second: 58 (~93x reduction)
>     Datagrams/second: ~650k  (~1.7x increase)
>     Interval         Transfer     Bitrate         Lost/Total Datagrams
>     0.00-30.00  sec  26.4 GBytes  7.55 Gbits/sec  0/19554720 (0%)  sender
> 
> Acked-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Jon Kohler <jon@nutanix.com>


Jon what are we doing with this patch? you still looking into
some feedback?

> ---
>  drivers/vhost/net.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index b9b9e9d40951..9b04025eea66 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -769,13 +769,17 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  			break;
>  		/* Nothing new?  Wait for eventfd to tell us they refilled. */
>  		if (head == vq->num) {
> +			/* If interrupted while doing busy polling, requeue
> +			 * the handler to be fair handle_rx as well as other
> +			 * tasks waiting on cpu
> +			 */
>  			if (unlikely(busyloop_intr)) {
>  				vhost_poll_queue(&vq->poll);
> -			} else if (unlikely(vhost_enable_notify(&net->dev,
> -								vq))) {
> -				vhost_disable_notify(&net->dev, vq);
> -				continue;
>  			}
> +			/* Kicks are disabled at this point, break loop and
> +			 * process any remaining batched packets. Queue will
> +			 * be re-enabled afterwards.
> +			 */
>  			break;
>  		}
>  
> @@ -825,7 +829,14 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  		++nvq->done_idx;
>  	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
>  
> +	/* Kicks are still disabled, dispatch any remaining batched msgs. */
>  	vhost_tx_batch(net, nvq, sock, &msg);
> +
> +	/* All of our work has been completed; however, before leaving the
> +	 * TX handler, do one last check for work, and requeue handler if
> +	 * necessary. If there is no work, queue will be reenabled.
> +	 */
> +	vhost_net_busy_poll_try_queue(net, vq);
>  }
>  
>  static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> -- 
> 2.43.0


