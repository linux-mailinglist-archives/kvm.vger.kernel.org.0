Return-Path: <kvm+bounces-44180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A98A9B0E3
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:31:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 195A94A2F18
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA26B27FD64;
	Thu, 24 Apr 2025 14:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hYAV3m/t"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F3127F757
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504687; cv=none; b=mrA6CgOqusLVlaoFIrjyd+fsBe7zm1ec5f7klsuAubblSEM+F3g6zeu8YuUzIayUIma2tVQgByTj8gfaD4Svuy5187OJilM04ImJcdUgUXMg7E7r19/bQdlh835ZyPzTp9OPgxjJv18dRzc2Ap6CgbOCt7MoBPJscMruI81QGEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504687; c=relaxed/simple;
	bh=ITEJU5E+U8k3jYhXGW3lQ1NkLPi5MlRGY624NYpem6s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MymuWxWuAxnLCEB8BldfT8yXyKGoj0cbNdqCmREV8DbtxMPJr8UM+Yc6VACinJOLOTSpOrrrXZFHS81SlUwb5WlQ0ArJ6iyPKptdS8r75QM00xrU+4ABi33mJgyO+csPtAoLBRGxJFPU9BvMVa8WYjfpW9T/u0NFzFtO+2TqNV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hYAV3m/t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745504683;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nV8jVW/8nt8ZwTGGNIL9yTSPGZZ29xDmvRWgbdJwWX4=;
	b=hYAV3m/tTTF4hSkMk7HJveaFSX2IExNylsv0ymZn+HnLT1t1vPwaT+L9iSvxV0RkH/yJCc
	+FJLfMHVAXno2OXXmyMEpqThBRTFOJKzr9E5jLk/WDFyhD4VYNHVyxdGlQuX3p1hxzUyTd
	vQVt2xAtTdnwjFvkdy5Xs46IM02HVK8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-278-6cEdlnULOFq7C9o7vWIkrg-1; Thu, 24 Apr 2025 10:24:42 -0400
X-MC-Unique: 6cEdlnULOFq7C9o7vWIkrg-1
X-Mimecast-MFC-AGG-ID: 6cEdlnULOFq7C9o7vWIkrg_1745504681
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3912fc9861cso385634f8f.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:24:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504681; x=1746109481;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nV8jVW/8nt8ZwTGGNIL9yTSPGZZ29xDmvRWgbdJwWX4=;
        b=pJboLI5KNi1baIcrliQFJOZub1iYDNyNfT+Ud6k5ewxv/yq4U7C/Xmcy8CHXvelfFI
         wjcWeTCdHL1G4O5b41IQrNwFTI1Kayo6y/vqNnvqr6KZuH4fHu3oMI8/H3wQ1ywOBsLj
         40+itAPeQFOJZNV4ALGENSaS6o82XLPStf5JMGLbWj4Q5NjCyyLQHT8edS7LAz/oddG+
         3hAOXrzf2Qstt4kN2qiqlvKdlec3nwZKeUVf+zGyCKrwQBHS5EA2DJra9Xz+hoNe9wz+
         JQjfqy11hJn49AeX5nMR59WC6wBjIYFoHOmTfUaYT3B6Jdy6CJewn34Y/i3fSOoy4YN/
         0POA==
X-Forwarded-Encrypted: i=1; AJvYcCXGSiIf9Vb5oAIn5XfrmI67rA+aD5rtY/5uWo8e3ctuZRfBhQr3WhjCR8R/k6erHprIj3A=@vger.kernel.org
X-Gm-Message-State: AOJu0YyuF8dYeSza74Zx0DOa+1rjTIKJ3Ko6ZtS7DxiKhS5MSH1nri06
	EKBeXIA6QIIzV+BvtpWAFCSqyENYKbO18cFxqFPnlFNB+xkQJhT9Gu7qoIIl2k1Z8onhQ0W8der
	RnjpYg1lnjJqFxC7L/pGijjOtuHdmBP0BEozWOkEU29xq4gxerA==
X-Gm-Gg: ASbGnctkLSbomsfsMXZdkH4/iN5QLMX/3kl/HAut/gF3Lzcxi2eoDM8DQlWGA8c8Q9n
	+k1PG1xHfKEk3S72cj8rvlsHseNEycBqRU6s7HB0CYorL8Kc1Vqinelc5S9cW3OVCo0488Zqt5c
	aav5+Hm015DmL38dmVcPFvvup70+UtS1lScrIXtSyKCsNlPL+Km1H0muBjFeunAG4JtiinYwHCk
	t3eVnRvvMV+3E4fpK4pKjnuzs1unryFJqSTbIi41//BD3XhjCuYgvbIPJxNISgIKjgJukCrZCj1
	e22E8w==
X-Received: by 2002:a05:6000:240a:b0:39a:ca0b:e7c7 with SMTP id ffacd0b85a97d-3a06cfaba23mr2493034f8f.36.1745504681011;
        Thu, 24 Apr 2025 07:24:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEwBzD5hh+2Z62EditO+ortaghgO8pvR6NguSzN5/Fukq1qShODNoWcevMtBiQSBYPeBcmOdg==
X-Received: by 2002:a05:6000:240a:b0:39a:ca0b:e7c7 with SMTP id ffacd0b85a97d-3a06cfaba23mr2493006f8f.36.1745504680461;
        Thu, 24 Apr 2025 07:24:40 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a7ff8sm2347237f8f.13.2025.04.24.07.24.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:24:39 -0700 (PDT)
Date: Thu, 24 Apr 2025 10:24:37 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jon Kohler <jon@nutanix.com>
Cc: Paolo Abeni <pabeni@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] vhost/net: Defer TX queue re-enable until
 after sendmsg
Message-ID: <20250424102351-mutt-send-email-mst@kernel.org>
References: <20250420010518.2842335-1-jon@nutanix.com>
 <a0894275-6b23-4cff-9e36-a635f776c403@redhat.com>
 <20250424080749-mutt-send-email-mst@kernel.org>
 <1CE89B73-B236-464A-8781-13E083AFB924@nutanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1CE89B73-B236-464A-8781-13E083AFB924@nutanix.com>

On Thu, Apr 24, 2025 at 01:53:34PM +0000, Jon Kohler wrote:
> 
> 
> > On Apr 24, 2025, at 8:11 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > 
> > !-------------------------------------------------------------------|
> >  CAUTION: External Email
> > 
> > |-------------------------------------------------------------------!
> > 
> > On Thu, Apr 24, 2025 at 01:48:53PM +0200, Paolo Abeni wrote:
> >> On 4/20/25 3:05 AM, Jon Kohler wrote:
> >>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> >>> index b9b9e9d40951..9b04025eea66 100644
> >>> --- a/drivers/vhost/net.c
> >>> +++ b/drivers/vhost/net.c
> >>> @@ -769,13 +769,17 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> >>> break;
> >>> /* Nothing new?  Wait for eventfd to tell us they refilled. */
> >>> if (head == vq->num) {
> >>> + /* If interrupted while doing busy polling, requeue
> >>> + * the handler to be fair handle_rx as well as other
> >>> + * tasks waiting on cpu
> >>> + */
> >>> if (unlikely(busyloop_intr)) {
> >>> vhost_poll_queue(&vq->poll);
> >>> - } else if (unlikely(vhost_enable_notify(&net->dev,
> >>> - vq))) {
> >>> - vhost_disable_notify(&net->dev, vq);
> >>> - continue;
> >>> }
> >>> + /* Kicks are disabled at this point, break loop and
> >>> + * process any remaining batched packets. Queue will
> >>> + * be re-enabled afterwards.
> >>> + */
> >>> break;
> >>> }
> >> 
> >> It's not clear to me why the zerocopy path does not need a similar change.
> > 
> > It can have one, it's just that Jon has a separate patch to drop
> > it completely. A commit log comment mentioning this would be a good
> > idea, yes.
> 
> Yea, the utility of the ZC side is a head scratcher for me, I can’t get it to work
> well to save my life. I’ve got a separate thread I need to respond to Eugenio
> on, will try to circle back on that next week.
> 
> The reason this one works so well is that the last batch in the copy path can
> take a non-trivial amount of time, so it opens up the guest to a real saw tooth
> pattern. Getting rid of that, and all that comes with it (exits, stalls, etc), just
> pays off.
> 
> > 
> >>> @@ -825,7 +829,14 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
> >>> ++nvq->done_idx;
> >>> } while (likely(!vhost_exceeds_weight(vq, ++sent_pkts, total_len)));
> >>> 
> >>> + /* Kicks are still disabled, dispatch any remaining batched msgs. */
> >>> vhost_tx_batch(net, nvq, sock, &msg);
> >>> +
> >>> + /* All of our work has been completed; however, before leaving the
> >>> + * TX handler, do one last check for work, and requeue handler if
> >>> + * necessary. If there is no work, queue will be reenabled.
> >>> + */
> >>> + vhost_net_busy_poll_try_queue(net, vq);
> >> 
> >> This will call vhost_poll_queue() regardless of the 'busyloop_intr' flag
> >> value, while AFAICS prior to this patch vhost_poll_queue() is only
> >> performed with busyloop_intr == true. Why don't we need to take care of
> >> such flag here?
> > 
> > Hmm I agree this is worth trying, a free if possibly small performance
> > gain, why not. Jon want to try?
> 
> I mentioned in the commit msg that the reason we’re doing this is to be
> fair to handle_rx. If my read of vhost_net_busy_poll_try_queue is correct,
> we would only call vhost_poll_queue iff:
> 1. The TX ring is not empty, in which case we want to run handle_tx again
> 2. When we go to reenable kicks, it returns non-zero, which means we
> should run handle_tx again anyhow
> 
> In the ring is truly empty, and we can re-enable kicks with no drama, we
> would not run vhost_poll_queue.
> 
> That said, I think what you’re saying here is, we should check the busy
> flag and *not* try vhost_net_busy_poll_try_queue, right?

yes

> If so, great, I did
> that in an internal version of this patch; however, it adds another conditional
> which for the vast majority of users is not going to add any value (I think)
> 
> Happy to dig deeper, either on this change series, or a follow up?

it just seems like a more conservate thing to do, given we already did
this in the past.

> > 
> > 
> >> @Michael: I assume you prefer that this patch will go through the
> >> net-next tree, right?
> >> 
> >> Thanks,
> >> 
> >> Paolo
> > 
> > I don't mind and this seems to be what Jon wants.
> > I could queue it too, but extra review  it gets in the net tree is good.
> 
> My apologies, I thought all non-bug fixes had to go thru net-next,
> which is why I sent the v2 to net-next; however if you want to queue
> right away, I’m good with either. Its a fairly well contained patch with
> a huge upside :) 
> 
> > 
> > -- 
> > MST
> > 
> 


