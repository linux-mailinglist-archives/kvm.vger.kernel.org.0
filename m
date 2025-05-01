Return-Path: <kvm+bounces-45090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 78DB6AA5F70
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:45:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FB899C3B2B
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 13:44:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C64F91DA62E;
	Thu,  1 May 2025 13:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jRzxo8GC"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C45F199935
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 13:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746107088; cv=none; b=YyYg94AgeNQdGMz4AO3XpfOm0klHbCAOJhAPQz3dHrAlkreUBKra8mOR8VndKiqp4Dh5bIXIKeb2hUWAt8EnMU8YL84EaEtdX16rgozJx71V1vVIo7P4wNrDQvaMzsRuEvjqFWJrQDMiDhSXei/yFVKnAXHTZk9QHjT6ZDINVRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746107088; c=relaxed/simple;
	bh=TW6LWoRqtypIzn7B58qijKmL0w5gLK2466Q2vxKzNkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HrlpecJQ54VVFEGBH0YWjAqdS6KrH9+IyxxcDSj2IwMe00XeJPdgzz+fHEzwz0jdw7EpCPiQWnzwlAjAJnlOwR39aZeKBJn69B21HOAAfO6OEmgiRj3Av2onjysxyc3DMbCrgAFJrH//7w1yNjeLIz6A48JfljnM/oP7Iz9x2dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jRzxo8GC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746107084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6UI0tYMue0gvJhLpVqoCbZ1TmzhnaUoOZcJGxHDR+D8=;
	b=jRzxo8GCUniyTfS9pciDsdBT8Wv8O8gMilVBIjcVd5P/kB+9OHmHrukDURo4BTJ4rEvhu+
	HsLLnon6dutsywzmdqxW+y6H9AfZ3nun0w0EljTvf9Px+l6pQZKOdT5kJrJ5eNCp3yYwDD
	2XGp1vvq2ZTWru4MAd1asE9ScXSFz4A=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-IDE7COfuOrqkwPvNxKBQgw-1; Thu, 01 May 2025 09:44:42 -0400
X-MC-Unique: IDE7COfuOrqkwPvNxKBQgw-1
X-Mimecast-MFC-AGG-ID: IDE7COfuOrqkwPvNxKBQgw_1746107082
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-39130f02631so252491f8f.2
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 06:44:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746107081; x=1746711881;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6UI0tYMue0gvJhLpVqoCbZ1TmzhnaUoOZcJGxHDR+D8=;
        b=uzJM7o49G/lu3ftGwAijZrX/gob1iHhDrXmx6Xt7BSkrqvMCQvDNtwylrKPkKh8IAk
         sYqYKohw2AtkRcTf4GL1IIfGzWG7vJGDTh3IebwkGJFt1yrlZ4jik9rjaRhUnvsvOVVI
         VniXIWBWV3Iup+JqVLYkFJJ5xuINGl/SLNMS6MIxW9vN/+CYzIMTEtM/XPHyCGIuujCl
         6t6L9gAyop2caMr6eTGhDq9TwkIB6+e5OiDrVAfV3ojlj+c0zM1Mat3tdf7oJPqLXgmA
         0kKaw3fj3bqSjkYDIfsyASgrVL5JyO+X42cL8RSY8bzgJeCH8uQiOpEZQ06ZtcX4tpsN
         A4iA==
X-Forwarded-Encrypted: i=1; AJvYcCXYZlFO5k9/xWYwKPfmu1nmkGwXoyrlYUmQnA2WQRSNLv/jame1t362aghQHCc6A/bChUs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLUZlWakravBP8CeiN6M1GmgW5JQq+SWhAE4BHSgetPsBvtF0J
	uuQX06JZEHB7dmqigS/mF6I1Nd5CdL+sIWoLRpRuACFfkVrdFLYEunk3J2cc2HsOH0c3e4VU55+
	FujtjFdwxi8CNUHrPp5PSi4bXTz/aRWym63F5boMI2z73cI1uMQ==
X-Gm-Gg: ASbGncvO89GO6hHf8GJZBLZemhi0lWax72qAy3IcxA51FQ2DMY190WXErMGwopLO5Jc
	cSNPTsr2HOQ4WJ0eur6o+yFhyOLrTCAzjpf+5vqrqBEYe8BY7YytHZ4Hxr6k4O2lcRmX1/yr+fs
	3RKZVYVuvqfrPlvSp8hEKlZz97cpS9X7i1EStJW0IDJ3K/rtwv0ENqcufl8Pd5QRRdCoenu9OzD
	UfNK6RcJbcy/1h6N42f7pFIeBNTZ6jrwGEodAhFq4hFSdvkJmZk8n9bntq8+haXzCa378oxco/V
	9vvSPA==
X-Received: by 2002:a05:6000:1acd:b0:3a0:6ac1:93a1 with SMTP id ffacd0b85a97d-3a09404452amr1721870f8f.7.1746107081632;
        Thu, 01 May 2025 06:44:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGD96yZkZMPIxtx9G7hGbxzu9GrBoqR4jN2AHFouxYn7cwL/a8mhV9pFuiwTxsci9UDPZbEJA==
X-Received: by 2002:a05:6000:1acd:b0:3a0:6ac1:93a1 with SMTP id ffacd0b85a97d-3a09404452amr1721860f8f.7.1746107081298;
        Thu, 01 May 2025 06:44:41 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a095a3e04asm917945f8f.18.2025.05.01.06.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 06:44:40 -0700 (PDT)
Date: Thu, 1 May 2025 09:44:38 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] vhost/net: Defer TX queue re-enable until
 after sendmsg
Message-ID: <20250501094427-mutt-send-email-mst@kernel.org>
References: <20250501020428.1889162-1-jon@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250501020428.1889162-1-jon@nutanix.com>

On Wed, Apr 30, 2025 at 07:04:28PM -0700, Jon Kohler wrote:
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

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> v2->v3: Address MST's comments regarding busyloop_intr
> 	https://patchwork.kernel.org/project/netdevbpf/patch/20250420010518.2842335-1-jon@nutanix.com/
> v1->v2: Move from net to net-next (no changes)
> 	https://patchwork.kernel.org/project/netdevbpf/patch/20250401043230.790419-1-jon@nutanix.com/
> ---
>  drivers/vhost/net.c | 30 +++++++++++++++++++++---------
>  1 file changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index b9b9e9d40951..7cbfc7d718b3 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -755,10 +755,10 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  	int err;
>  	int sent_pkts = 0;
>  	bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
> +	bool busyloop_intr;
>  
>  	do {
> -		bool busyloop_intr = false;
> -
> +		busyloop_intr = false;
>  		if (nvq->done_idx == VHOST_NET_BATCH)
>  			vhost_tx_batch(net, nvq, sock, &msg);
>  
> @@ -769,13 +769,10 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  			break;
>  		/* Nothing new?  Wait for eventfd to tell us they refilled. */
>  		if (head == vq->num) {
> -			if (unlikely(busyloop_intr)) {
> -				vhost_poll_queue(&vq->poll);
> -			} else if (unlikely(vhost_enable_notify(&net->dev,
> -								vq))) {
> -				vhost_disable_notify(&net->dev, vq);
> -				continue;
> -			}
> +			/* Kicks are disabled at this point, break loop and
> +			 * process any remaining batched packets. Queue will
> +			 * be re-enabled afterwards.
> +			 */
>  			break;
>  		}
>  
> @@ -825,7 +822,22 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
>  		++nvq->done_idx;
>  	} while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
>  
> +	/* Kicks are still disabled, dispatch any remaining batched msgs. */
>  	vhost_tx_batch(net, nvq, sock, &msg);
> +
> +	if (unlikely(busyloop_intr))
> +		/* If interrupted while doing busy polling, requeue the
> +		 * handler to be fair handle_rx as well as other tasks
> +		 * waiting on cpu.
> +		 */
> +		vhost_poll_queue(&vq->poll);
> +	else
> +		/* All of our work has been completed; however, before
> +		 * leaving the TX handler, do one last check for work,
> +		 * and requeue handler if necessary. If there is no work,
> +		 * queue will be reenabled.
> +		 */
> +		vhost_net_busy_poll_try_queue(net, vq);
>  }
>  
>  static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> -- 
> 2.43.0


