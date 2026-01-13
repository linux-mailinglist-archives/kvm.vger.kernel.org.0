Return-Path: <kvm+bounces-67919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 584C4D1716C
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 08:48:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3384E301A322
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 07:47:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2533191D3;
	Tue, 13 Jan 2026 07:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F/9srFvD";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Jg0dk1WN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8EA318BAE
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 07:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768290425; cv=none; b=bgv6kq9KHLULVI56D/TWL47HH95NWwZYD9+xgAhDhoCkRip37z1F/Ptp471ztK+ALODKJwF6qc4fKRYRxz9Ro4yuECEDCHlsCpPSLPf5VPu8z4FOFfHbb5HkBWyBboCL9WZw7peu4CRqcYSCIdhMwrLgupplGI41A99ETgG2K7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768290425; c=relaxed/simple;
	bh=UAF5AqV5fmYHBM6V12ZExeDyaoxsECrynL/uccTwT80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CaX7lfPSARlDWbksC6FUK2KrAccX7CyM9Qjg7b0eeu9xjreLRsRKu2tpjgBGaNKrkpFGu8ocney0quwhqWvk7uxNHNttoF2aV0CKb+QMNo5QxXg0kx0mge0P/ns79bIa97qBQshbeux9XISlEyz59CiZgOkClolTVY+7HNfv7Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F/9srFvD; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Jg0dk1WN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768290422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZLqUUybaD7tlYRqUfcBJbxPEI8ZYA6NTfdyH3KvYcYk=;
	b=F/9srFvDYowvlejB6HTfvkzGNJqUjhWphcv1Imxb/8gzq4ArOM8aVal0SCtJs7LHBNZB11
	Rtnqhpv/AwDotQZtzrZjBlfo1feY3qsK9mTWB15uMVCVu2QUpU2Bjb+jcCViecKvF8aaBu
	MTSLy5R84inT1Zhh9Cit11XjRrGBG2k=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161-6TBtm94HNYaE4Sb2oVdluQ-1; Tue, 13 Jan 2026 02:47:01 -0500
X-MC-Unique: 6TBtm94HNYaE4Sb2oVdluQ-1
X-Mimecast-MFC-AGG-ID: 6TBtm94HNYaE4Sb2oVdluQ_1768290420
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4776079ada3so72117715e9.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 23:47:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768290420; x=1768895220; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLqUUybaD7tlYRqUfcBJbxPEI8ZYA6NTfdyH3KvYcYk=;
        b=Jg0dk1WN36mOsqLkcJ2YPs66FqiJlGlwtI8vY8SBxoz6iRajMlkDOQ+4WW95qppMl8
         rJETmQzGy2gUwy5smYQP4oH6UEHVg39npJmYTATWx2xC66i2R3UA6b2Khbtff5C6s4lM
         kyCsAeHquOZ20lZsF5eloqnGz8Vo8uRk5AM5DdSLSUJ4rlsZK6wLM0JH8LTgd24pUsmj
         RSz1pKnQfvYIyDcTq1q1aZawuB2cejG+i8cvzWc+EWSJq+7qf4J+Pwe4dJztHzTRqFj2
         Q4baL7uULpM3Rw8n2LUq9O4wUJQzrl013Ep8jDm5HyajM166tOXPj+SLNS9yiTDAkr5S
         IqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768290420; x=1768895220;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZLqUUybaD7tlYRqUfcBJbxPEI8ZYA6NTfdyH3KvYcYk=;
        b=u2HJ2iStqCZvntd1ubWeeP9Z3Rmtx685AQXaxPAGSjvFPGNXzXnaMUQwo9bsEuqLpQ
         ErwVHoB3HUxo9zfGYRpX6H/vHFubxike7OwZxUmUDe/bA2CP5ej2eYWZCgg7vRebLOH4
         9qbh+Q1+3J8inbDx+3DU0EB/eT5FPRnJS3fmXdUIi0WPf55xlVAVHWh9PI+rrBdke9g+
         Y0AvwPrmds8wqqMCpYt+HYiZmZt7PqveYzMYEwCnATml0MrSHGSvgLf/lnKCS0eUHay3
         yEyxGGSO8PJZ8zUx80dDWMlP9d8zcKRbtQ2ctV9NuQbZoXTgGNKUokVj4dol9QNPx5WY
         h7mA==
X-Forwarded-Encrypted: i=1; AJvYcCXITUJ6sVDI6rFvQxUJWbmPJeMbYcTy0gdBsyrQgn5uLoZZsDSWoFEHFBE/IMNkBB47w/M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8UBCTRavCUpcVb7R6wh+LLiCPQ2/OC06jE/xH6R7AcDgW/jyI
	5sgBmcULUyfmESjCk4f+L3G3PDvfcoyCgDKKonwbN/6uW0l9iqMgcOfZKssg0Z3Cax5Eug6wy/v
	7eQt3KeP3mfDldNf/4qkK9dwYmYiU+Jt5St3dz3ONm1MFT0swEs04Pg==
X-Gm-Gg: AY/fxX4Zfw72nSggl+zOtB3Ph8H5XvEKvdGEOyodyys+x7UTtuvxm4h2n8v0pvPOR6T
	0Vk+Eho/2wB/30YnP3gas59G+8drdRxiM4hch/as9HMLqoo0GF1dbQZarTlkvZgX8IvFHPyRMU3
	XqkXvdKIQ+pcqUgVxHnurUa2POgHntEdEuog++6DGXt21vnTSlgY5JtMkD9E+xiM5iepTOd796Y
	StTQq+hnestF8uE5h9jTxAucDN5v27qezC94uY5I3lNrPvQr2wOCMeGKajlBJx8uOWNFpkLAY+m
	c248pRW5TNKwBQqD1iS3/by2OYTFnbM1YRg/04nMglRxagKandsXVl23tu/5gsToTLoS7iwaGZT
	q94Pnco3Bs4Q3Dm6m6oXArPkKNzEeZio=
X-Received: by 2002:a05:600c:3484:b0:46e:7e22:ff6a with SMTP id 5b1f17b1804b1-47d84b1fd4bmr245380855e9.15.1768290419759;
        Mon, 12 Jan 2026 23:46:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEvSNMQrQFrG/2aS7V7uD8HByGcK0PJXoWEI3qRop/CiFvA7kKclL+qqFUyulC9Y6/d4JjGpA==
X-Received: by 2002:a05:600c:3484:b0:46e:7e22:ff6a with SMTP id 5b1f17b1804b1-47d84b1fd4bmr245380335e9.15.1768290419267;
        Mon, 12 Jan 2026 23:46:59 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ed9eb6fbesm9228355e9.4.2026.01.12.23.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 23:46:58 -0800 (PST)
Date: Tue, 13 Jan 2026 02:46:54 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Shuah Khan <shuah@kernel.org>, Long Li <longli@microsoft.com>,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, kvm@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-kselftest@vger.kernel.org,
	berrange@redhat.com, Sargun Dhillon <sargun@sargun.me>,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH RFC net-next v13 02/13] vsock: add netns to vsock core
Message-ID: <20260113024548-mutt-send-email-mst@kernel.org>
References: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
 <20251223-vsock-vmtest-v13-2-9d6db8e7c80b@meta.com>
 <20260111013536-mutt-send-email-mst@kernel.org>
 <aWWFB2K5H5OXGWP8@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWWFB2K5H5OXGWP8@devvm11784.nha0.facebook.com>

On Mon, Jan 12, 2026 at 03:34:31PM -0800, Bobby Eshleman wrote:
> On Sun, Jan 11, 2026 at 01:43:37AM -0500, Michael S. Tsirkin wrote:
> > On Tue, Dec 23, 2025 at 04:28:36PM -0800, Bobby Eshleman wrote:
> > > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > > 
> > > Add netns logic to vsock core. Additionally, modify transport hook
> > > prototypes to be used by later transport-specific patches (e.g.,
> > > *_seqpacket_allow()).
> > > 
> > > Namespaces are supported primarily by changing socket lookup functions
> > > (e.g., vsock_find_connected_socket()) to take into account the socket
> > > namespace and the namespace mode before considering a candidate socket a
> > > "match".
> > > 
> > > This patch also introduces the sysctl /proc/sys/net/vsock/ns_mode to
> > > report the mode and /proc/sys/net/vsock/child_ns_mode to set the mode
> > > for new namespaces.
> > > 
> > > Add netns functionality (initialization, passing to transports, procfs,
> > > etc...) to the af_vsock socket layer. Later patches that add netns
> > > support to transports depend on this patch.
> > > 
> > > dgram_allow(), stream_allow(), and seqpacket_allow() callbacks are
> > > modified to take a vsk in order to perform logic on namespace modes. In
> > > future patches, the net will also be used for socket
> > > lookups in these functions.
> > > 
> > > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > 
> > ...
> > 
> > 
> > >  static int __vsock_bind_connectible(struct vsock_sock *vsk,
> > >  				    struct sockaddr_vm *addr)
> > >  {
> > > +	struct net *net = sock_net(sk_vsock(vsk));
> > >  	static u32 port;
> > >  	struct sockaddr_vm new_addr;
> > >
> > 
> > 
> > Hmm this static port gives me pause. So some port number info leaks
> > between namespaces. I am not saying it's a big security issue
> > and yet ... people expect isolation.
> 
> Probably the easiest solution is making it per-ns, my quick rough draft
> looks like this:

Sounds like a plan.


> diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
> index e2325e2d6ec5..b34d69a22fa8 100644
> --- a/include/net/netns/vsock.h
> +++ b/include/net/netns/vsock.h
> @@ -11,6 +11,10 @@ enum vsock_net_mode {
>  
>  struct netns_vsock {
>  	struct ctl_table_header *sysctl_hdr;
> +
> +	/* protected by the vsock_table_lock in af_vsock.c */
> +	u32 port;
> +
>  	enum vsock_net_mode mode;
>  	enum vsock_net_mode child_ns_mode;
>  };
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 9d614e4a4fa5..cd2a47140134 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -748,11 +748,10 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>  				    struct sockaddr_vm *addr)
>  {
>  	struct net *net = sock_net(sk_vsock(vsk));
> -	static u32 port;
>  	struct sockaddr_vm new_addr;
>  
> -	if (!port)
> -		port = get_random_u32_above(LAST_RESERVED_PORT);
> +	if (!net->vsock.port)
> +		net->vsock.port = get_random_u32_above(LAST_RESERVED_PORT);
>  
>  	vsock_addr_init(&new_addr, addr->svm_cid, addr->svm_port);
>  
> @@ -761,11 +760,11 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
>  		unsigned int i;
>  
>  		for (i = 0; i < MAX_PORT_RETRIES; i++) {
> -			if (port == VMADDR_PORT_ANY ||
> -			    port <= LAST_RESERVED_PORT)
> -				port = LAST_RESERVED_PORT + 1;
> +			if (net->vsock.port == VMADDR_PORT_ANY ||
> +			    net->vsock.port <= LAST_RESERVED_PORT)
> +				net->vsock.port = LAST_RESERVED_PORT + 1;
>  
> -			new_addr.svm_port = port++;
> +			new_addr.svm_port = net->vsock.port++;
>  
>  			if (!__vsock_find_bound_socket_net(&new_addr, net)) {
>  				found = true;
> 
> 
> 
> Not as nice, but not necessarily horrid. WDYT?
> 
> Best,
> Bobby

I wouldn't call static vars "nice". LGTM.


