Return-Path: <kvm+bounces-57416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 24FCDB55392
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:30:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D56F17BF0B
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:30:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9CAF3128AF;
	Fri, 12 Sep 2025 15:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fejmX1cB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280B63090FB
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 15:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757691023; cv=none; b=DsMGWvtprahGl7pyLDb/rafYfBi6ohaNWnxo5vE/037s4kMcQ/yctoEKPEJyo1x7fy3I2EIX9MH7EA9CSlrMGZl+u21pnxN67F0ay77uRF0zfKdS1yhaxYEl0ShLTAIprtj5jxDqDzz3+aizVP/uHmUASBrOMNY381v0e2Ag5sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757691023; c=relaxed/simple;
	bh=xG0xQio8EPzsul4Ghf8rz0UL2N3MlY4xJdVEYnW3vwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=loHTQkj+bXtRK8gQdoRXOzbrgehIhsMa4Z0R93cMQS4b6G1VBboHY8RGbGvAZCt0P2lFoeteeRihElKO23m3UelgMV4C9DXOtbIZ155giU/t4WXUjELmL1i7zWtKnfXrBE4VYu8NmALDj+AGucgrDO91WD8NX2Gxg8AO9x+/D7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fejmX1cB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757691020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=P1U2VojtPokeUk+tdxQA3A5MwzgzqZJ7HiBkhr5RCN8=;
	b=fejmX1cBqkzun5uJyEGLHjXSM49MfWVISG6NvgqVjQbISgE2/Qmp7pzkMYtspEcopwtCH9
	q1nBMLUEOdvGwaq7DUY4+9+TPUN5C4hU+uMnLlWNSBh1W/xRQBeufBuG1btEaVG21bNyYH
	pjMAutAQ4XV8Ga80TW7hiiwVtX1sIUo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-102-3p_OIJHrOLaCbvB8JlHZTA-1; Fri, 12 Sep 2025 11:30:18 -0400
X-MC-Unique: 3p_OIJHrOLaCbvB8JlHZTA-1
X-Mimecast-MFC-AGG-ID: 3p_OIJHrOLaCbvB8JlHZTA_1757691017
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45de13167aaso19679215e9.1
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 08:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757691017; x=1758295817;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P1U2VojtPokeUk+tdxQA3A5MwzgzqZJ7HiBkhr5RCN8=;
        b=NA85fTS1PYBCN+O4ZPBOb0FLDWhVGR5pDFtpQoW4+W0Kgwvkp4JnH779nB6JoQKSc/
         Vlysnrvyw6NJff9F4uzd8FtqXrejAA3VcxrvA/+RMPZFYg/sBejT+o9oI4ERlsxxrFww
         KBl3VJCvF+vqrPQKUE/FbYUQxUWN+6hZNLRHTDrvezNNjSanizRobMbQolBNsj+nbHy0
         VbKPdC8fJ75B+xvLFo8VfTlphsnw973yWolmUwUxqH1kObKtkvweewIixdz/cFKXqWzp
         5gFz3o43NU8LK+GHoCgnM+Ry4EeeHiaprNsZxOKFsh/AVTFLlGnLJoIFRSlY/QEW+wZs
         9SFw==
X-Forwarded-Encrypted: i=1; AJvYcCW5pglUJiDM5OrSZJh0mFCIozL1UFqYTcrFrzXZMnqqXfYRai4AKmj6qefjs9GME2wXbvI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhR+v1hL47oyjYl2YbENQLnv8g3sE9cdKa+jio2SJKtLTvl705
	R+OcVtkL2kmwPgkaQLVxl+vW9vvdw0VqmJ9ix/CpRdNfhviwT6jeIICQfCxPBfwTRCgKLt81KoS
	1eAqwJZGXvPXKmYbBIfrbOJ5N5gXsDgFptT5lNTdK99A9Q8hfX/wEEQ==
X-Gm-Gg: ASbGncvdA0hlLpNU0x9j3XLMMaG9L5Z0NltV1R6/X1sHmLR9yQIA/VZvQRm9bjYQZ0k
	WbTsafv3VEofMMaQuUbEpcinpKw2BTZfhpeoI3mBDpKj/DdUxHQbAk4WsfMq/3qa/iizJswxdlm
	s09fABVM8VQCf/xyidx8j+yxTF/slgVMdGhjAXmIL6JnMRSevHY8ll0jKkEKJ3V2N6KDIvmzaWQ
	xZza/GBdHG08hhDBTIit48mCC62BwHcCWd/Qzib13VR0mtdHm57K7/L3UT94JtVlJupi4o7a4OV
	Q+6E611SahdQBorY9ePkwKWNTzaaPt4Zm8Q=
X-Received: by 2002:a05:600c:c4aa:b0:45d:f7f9:9ac7 with SMTP id 5b1f17b1804b1-45f211c4cf0mr42590705e9.6.1757691017201;
        Fri, 12 Sep 2025 08:30:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHuVm8pd2LL97DReTjaXXQ9ger3Xdm5br919kQs5cKISKVwPT+FYYKJCNez4asltdGHaL4cTA==
X-Received: by 2002:a05:600c:c4aa:b0:45d:f7f9:9ac7 with SMTP id 5b1f17b1804b1-45f211c4cf0mr42590345e9.6.1757691016755;
        Fri, 12 Sep 2025 08:30:16 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73e7:4d00:2294:2331:c6cf:2fde])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e015bf73csm34789585e9.11.2025.09.12.08.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:30:16 -0700 (PDT)
Date: Fri, 12 Sep 2025 11:30:12 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Jason Wang <jasowang@redhat.com>,
	"eperezma@redhat.com" <eperezma@redhat.com>,
	"jonah.palmer@oracle.com" <jonah.palmer@oracle.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
Message-ID: <20250912112726-mutt-send-email-mst@kernel.org>
References: <20250912082658.2262-1-jasowang@redhat.com>
 <20250912082658.2262-2-jasowang@redhat.com>
 <20250912044523-mutt-send-email-mst@kernel.org>
 <63426904-881F-4725-96F5-3343389ED170@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63426904-881F-4725-96F5-3343389ED170@nutanix.com>

On Fri, Sep 12, 2025 at 03:24:42PM +0000, Jon Kohler wrote:
> 
> 
> > On Sep 12, 2025, at 4:50 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > 
> > !-------------------------------------------------------------------|
> >  CAUTION: External Email
> > 
> > |-------------------------------------------------------------------!
> > 
> > On Fri, Sep 12, 2025 at 04:26:58PM +0800, Jason Wang wrote:
> >> Commit 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after
> >> sendmsg") tries to defer the notification enabling by moving the logic
> >> out of the loop after the vhost_tx_batch() when nothing new is
> >> spotted. This will bring side effects as the new logic would be reused
> >> for several other error conditions.
> >> 
> >> One example is the IOTLB: when there's an IOTLB miss, get_tx_bufs()
> >> might return -EAGAIN and exit the loop and see there's still available
> >> buffers, so it will queue the tx work again until userspace feed the
> >> IOTLB entry correctly. This will slowdown the tx processing and may
> >> trigger the TX watchdog in the guest.
> > 
> > It's not that it might.
> > Pls clarify that it *has been reported* to do exactly that,
> > and add a link to the report.
> > 
> > 
> >> Fixing this by stick the notificaiton enabling logic inside the loop
> >> when nothing new is spotted and flush the batched before.
> >> 
> >> Reported-by: Jon Kohler <jon@nutanix.com>
> >> Cc: stable@vger.kernel.org
> >> Fixes: 8c2e6b26ffe2 ("vhost/net: Defer TX queue re-enable until after sendmsg")
> >> Signed-off-by: Jason Wang <jasowang@redhat.com>
> > 
> > So this is mostly a revert, but with
> >                     vhost_tx_batch(net, nvq, sock, &msg);
> > added in to avoid regressing performance.
> > 
> > If you do not want to structure it like this (revert+optimization),
> > then pls make that clear in the message.
> > 
> > 
> >> ---
> >> drivers/vhost/net.c | 33 +++++++++++++--------------------
> >> 1 file changed, 13 insertions(+), 20 deletions(-)
> >> 
> >> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> >> index 16e39f3ab956..3611b7537932 100644
> >> --- a/drivers/vhost/net.c
> >> +++ b/drivers/vhost/net.c
> >> @@ -765,11 +765,11 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> >> int err;
> >> int sent_pkts = 0;
> >> bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
> >> - bool busyloop_intr;
> >> bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
> >> 
> >> do {
> >> - busyloop_intr = false;
> >> + bool busyloop_intr = false;
> >> +
> >> if (nvq->done_idx == VHOST_NET_BATCH)
> >> vhost_tx_batch(net, nvq, sock, &msg);
> >> 
> >> @@ -780,10 +780,18 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> >> break;
> >> /* Nothing new?  Wait for eventfd to tell us they refilled. */
> >> if (head == vq->num) {
> >> - /* Kicks are disabled at this point, break loop and
> >> - * process any remaining batched packets. Queue will
> >> - * be re-enabled afterwards.
> >> + /* Flush batched packets before enabling
> >> + * virqtueue notification to reduce
> >> + * unnecssary virtqueue kicks.
> > 
> > typos: virtqueue, unnecessary
> > 
> >> */
> >> + vhost_tx_batch(net, nvq, sock, &msg);
> >> + if (unlikely(busyloop_intr)) {
> >> + vhost_poll_queue(&vq->poll);
> >> + } else if (unlikely(vhost_enable_notify(&net->dev,
> >> + vq))) {
> >> + vhost_disable_notify(&net->dev, vq);
> >> + continue;
> >> + }
> >> break;
> >> }
> 
> See my comment below, but how about something like this?
>  		if (head == vq->num) {
> 			/* Flush batched packets before enabling
> 			 * virtqueue notification to reduce
> 			 * unnecessary virtqueue kicks.
> 			 */
> 			vhost_tx_batch(net, nvq, sock, &msg);
> 			if (unlikely(busyloop_intr))
> 				/* If interrupted while doing busy polling,
> 				 * requeue the handler to be fair handle_rx
> 				 * as well as other tasks waiting on cpu.
> 				 */
> 				vhost_poll_queue(&vq->poll);
> 			else
> 				/* All of our work has been completed;
> 				 * however, before leaving the TX handler,
> 				 * do one last check for work, and requeue
> 				 * handler if necessary. If there is no work,
> 				 * queue will be reenabled.
> 				 */
> 				vhost_net_busy_poll_try_queue(net, vq);


I mean it's functionally equivalent, but vhost_net_busy_poll_try_queue 
checks the avail ring again and we just checked it.
Why is this a good idea?
This happens on good path so I dislike unnecessary work like this.


>  			break;
>  		}
> 
> 
> >> 
> >> @@ -839,22 +847,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> >> ++nvq->done_idx;
> >> } while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
> >> 
> >> - /* Kicks are still disabled, dispatch any remaining batched msgs. */
> >> vhost_tx_batch(net, nvq, sock, &msg);
> >> -
> >> - if (unlikely(busyloop_intr))
> >> - /* If interrupted while doing busy polling, requeue the
> >> - * handler to be fair handle_rx as well as other tasks
> >> - * waiting on cpu.
> >> - */
> >> - vhost_poll_queue(&vq->poll);
> >> - else
> >> - /* All of our work has been completed; however, before
> >> - * leaving the TX handler, do one last check for work,
> >> - * and requeue handler if necessary. If there is no work,
> >> - * queue will be reenabled.
> >> - */
> >> - vhost_net_busy_poll_try_queue(net, vq);
> 
> Note: the use of vhost_net_busy_poll_try_queue was intentional in my
> patch as it was checking to see both conditionals.
> 
> Can we simply hoist my logic up instead?
> 
> >> }
> >> 
> >> static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
> >> -- 
> >> 2.34.1
> > 
> 
> Tested-by: Jon Kohler <jon@nutanix.com <mailto:jon@nutanix.com>>
> 
> Tried this out on a 6.16 host / guest that locked up with iotlb miss loop,
> applied this patch and all was well. 


