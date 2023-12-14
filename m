Return-Path: <kvm+bounces-4471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95EBB812E64
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 12:18:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3C49D1F21BC7
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 11:18:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0ADD3FB18;
	Thu, 14 Dec 2023 11:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eM4GF+Af"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B6C8118
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 03:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702552685;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VaN6TC3I4TNZRPtVPtcTdPQQalk1XpMFkRRRirXd7I0=;
	b=eM4GF+AffIoOz8rhw4PCT04rTw+/brEJvU5WuDsXFBhapFfAFgpGjek3YcIk9W1EoJ70n0
	1c2InCiEN6GNDpmPxNyFr+5wJiF4sX/qjRgFxkxUHBfvmOzjoKR1vUEqgKQcQEO/oO8M2r
	HUIeJS4/uMY2Qb4gyw6a+cK6NNpdbYY=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-JPXXRMqyM4u9f-931DaFCg-1; Thu, 14 Dec 2023 06:18:04 -0500
X-MC-Unique: JPXXRMqyM4u9f-931DaFCg-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-54455e2a5c8so4538008a12.3
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 03:18:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702552683; x=1703157483;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VaN6TC3I4TNZRPtVPtcTdPQQalk1XpMFkRRRirXd7I0=;
        b=r7QB7gRHmwo393dtwtg95/zql2kRGJTuMY0MIui3HxmV/oQ/sX8VM5RQPZTWPjHLOa
         wlIuCOgnMd/siz0ZoKdiso2+zaXmYp7owFR6DD1StHve7bmbVN6bNup769gvYJGnw8Aa
         ggI6J+qcu23/bPtvOxLw9KeeqmFQJTpl1uXDWUL6mxAB/gigiGqPdyP1aAuLjE3TyDA8
         tnCWx6eIkBgnZrTIY4tXeF016PshWRfYnRQ9hN/uFRYKm5AZjiSHRDh+cyafttjtUuMK
         y47xXyZrWkDb0Waf+u4NxLkEtW2hp6CKITPjINy0teBQ1oBYATC3sKPj5wY0XiXzfm/R
         BHcA==
X-Gm-Message-State: AOJu0YyXoYRSKrV9X6zSo+zhHWBl/RtXOsaulzmm3io0T1KLc3VTXzon
	WFx9Q6Ka70c6Ek8LVjAV4qlQ8L98tUuJJGa2xCTDEc5e51VEIhtQCGg5BwHWpHW7iW+ap50HEX0
	/FEhcT5RwQwvR
X-Received: by 2002:a05:6402:2318:b0:551:76e6:afdb with SMTP id l24-20020a056402231800b0055176e6afdbmr2088862eda.77.1702552683019;
        Thu, 14 Dec 2023 03:18:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IExaY3rnjXkKwpudV8D5zjSW1Nso5V7k/Hde8rQ0+0YKYqG4gygBYOpDhXTnB2wvb4N1mYL8Q==
X-Received: by 2002:a05:6402:2318:b0:551:76e6:afdb with SMTP id l24-20020a056402231800b0055176e6afdbmr2088851eda.77.1702552682642;
        Thu, 14 Dec 2023 03:18:02 -0800 (PST)
Received: from redhat.com ([2.52.132.243])
        by smtp.gmail.com with ESMTPSA id dk4-20020a0564021d8400b005522eddd380sm1316992edb.34.2023.12.14.03.17.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 03:18:01 -0800 (PST)
Date: Thu, 14 Dec 2023 06:17:57 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v9 3/4] vsock: update SO_RCVLOWAT setting
 callback
Message-ID: <20231214061738-mutt-send-email-mst@kernel.org>
References: <20231214091947.395892-1-avkrasnov@salutedevices.com>
 <20231214091947.395892-4-avkrasnov@salutedevices.com>
 <20231214052502-mutt-send-email-mst@kernel.org>
 <e0e601a9-6cb2-e484-eb70-f41e7ec69c65@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0e601a9-6cb2-e484-eb70-f41e7ec69c65@salutedevices.com>

On Thu, Dec 14, 2023 at 01:52:50PM +0300, Arseniy Krasnov wrote:
> 
> 
> On 14.12.2023 13:29, Michael S. Tsirkin wrote:
> > On Thu, Dec 14, 2023 at 12:19:46PM +0300, Arseniy Krasnov wrote:
> >> Do not return if transport callback for SO_RCVLOWAT is set (only in
> >> error case). In this case we don't need to set 'sk_rcvlowat' field in
> >> each transport - only in 'vsock_set_rcvlowat()'. Also, if 'sk_rcvlowat'
> >> is now set only in af_vsock.c, change callback name from 'set_rcvlowat'
> >> to 'notify_set_rcvlowat'.
> >>
> >> Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
> >> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
> >> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> > 
> > Maybe squash this with patch 2/4?
> 
> You mean just do 'git squash' without updating commit message manually?
> 
> Thanks, Arseniy

commit message should reflect all that patch does.

> > 
> >> ---
> >>  Changelog:
> >>  v3 -> v4:
> >>   * Rename 'set_rcvlowat' to 'notify_set_rcvlowat'.
> >>   * Commit message updated.
> >>
> >>  include/net/af_vsock.h           | 2 +-
> >>  net/vmw_vsock/af_vsock.c         | 9 +++++++--
> >>  net/vmw_vsock/hyperv_transport.c | 4 ++--
> >>  3 files changed, 10 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
> >> index e302c0e804d0..535701efc1e5 100644
> >> --- a/include/net/af_vsock.h
> >> +++ b/include/net/af_vsock.h
> >> @@ -137,7 +137,6 @@ struct vsock_transport {
> >>  	u64 (*stream_rcvhiwat)(struct vsock_sock *);
> >>  	bool (*stream_is_active)(struct vsock_sock *);
> >>  	bool (*stream_allow)(u32 cid, u32 port);
> >> -	int (*set_rcvlowat)(struct vsock_sock *vsk, int val);
> >>  
> >>  	/* SEQ_PACKET. */
> >>  	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
> >> @@ -168,6 +167,7 @@ struct vsock_transport {
> >>  		struct vsock_transport_send_notify_data *);
> >>  	/* sk_lock held by the caller */
> >>  	void (*notify_buffer_size)(struct vsock_sock *, u64 *);
> >> +	int (*notify_set_rcvlowat)(struct vsock_sock *vsk, int val);
> >>  
> >>  	/* Shutdown. */
> >>  	int (*shutdown)(struct vsock_sock *, int);
> >> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> >> index 816725af281f..54ba7316f808 100644
> >> --- a/net/vmw_vsock/af_vsock.c
> >> +++ b/net/vmw_vsock/af_vsock.c
> >> @@ -2264,8 +2264,13 @@ static int vsock_set_rcvlowat(struct sock *sk, int val)
> >>  
> >>  	transport = vsk->transport;
> >>  
> >> -	if (transport && transport->set_rcvlowat)
> >> -		return transport->set_rcvlowat(vsk, val);
> >> +	if (transport && transport->notify_set_rcvlowat) {
> >> +		int err;
> >> +
> >> +		err = transport->notify_set_rcvlowat(vsk, val);
> >> +		if (err)
> >> +			return err;
> >> +	}
> >>  
> >>  	WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
> >>  	return 0;
> > 
> > 
> > 
> > I would s
> > 
> >> diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
> >> index 7cb1a9d2cdb4..e2157e387217 100644
> >> --- a/net/vmw_vsock/hyperv_transport.c
> >> +++ b/net/vmw_vsock/hyperv_transport.c
> >> @@ -816,7 +816,7 @@ int hvs_notify_send_post_enqueue(struct vsock_sock *vsk, ssize_t written,
> >>  }
> >>  
> >>  static
> >> -int hvs_set_rcvlowat(struct vsock_sock *vsk, int val)
> >> +int hvs_notify_set_rcvlowat(struct vsock_sock *vsk, int val)
> >>  {
> >>  	return -EOPNOTSUPP;
> >>  }
> >> @@ -856,7 +856,7 @@ static struct vsock_transport hvs_transport = {
> >>  	.notify_send_pre_enqueue  = hvs_notify_send_pre_enqueue,
> >>  	.notify_send_post_enqueue = hvs_notify_send_post_enqueue,
> >>  
> >> -	.set_rcvlowat             = hvs_set_rcvlowat
> >> +	.notify_set_rcvlowat      = hvs_notify_set_rcvlowat
> >>  };
> >>  
> >>  static bool hvs_check_transport(struct vsock_sock *vsk)
> >> -- 
> >> 2.25.1
> > 


