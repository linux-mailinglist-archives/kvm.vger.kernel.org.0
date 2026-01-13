Return-Path: <kvm+bounces-67934-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 11F09D18C40
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 13:37:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BDB393047688
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 12:34:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5141A349B04;
	Tue, 13 Jan 2026 12:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XkA83JjQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="cvw9nSgj"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202EB214813
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 12:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768307698; cv=none; b=sjpa8BBTVlKmrE5uNR1ekyJncTrtzKtUDNwSBLtMWXp0bSFwYmMd2eldGhKdaiikjfcOFZHEsutGaBsMkFCqP4biPrwZL8I11U+HBQU3cA1a46gJKGK8gj3EubDHOF9HWX4WpOT+B7iJovyQ/9om7ZwLM6Yk9xJI6jukSQznuaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768307698; c=relaxed/simple;
	bh=PQLe5MI17+5XqKdF5jxZ/xxXNVu7gNaeK/xezGimfg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hnPF2HBxtiVCpGOcscXzel1yopXRqgNjowUWoGNbE1evdpzoRLPhYeJAJwsmyzrf7txSWPDNmgO2YN2qaQYn6DH3O7Wn43MkH8Gtc7QnLMlqWTTuW5qLNEoapUZLeNwLSDHwh0BetdtvBuMIiXyEBC4Dd2K+YWIwR+uEX9aNB/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XkA83JjQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=cvw9nSgj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768307696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RMav5ORr40B5ZJ3PX7IVd5/NdRqYgN0BnH9+9JS6Dfg=;
	b=XkA83JjQsDzXiyFgoPua6A1Zs4zU6f7uwgEoOB6GS7MjaQiqCvp3tF3sR1adK5vU1SE5dm
	d3nH3phP1v4tAboj4K8S3kG03ve9nxJcUakdcwPMhe2C1YgsydMFP6/8O+MQ7V0QIZHW4x
	8K5k/wetPXk1Tm7v2AIH1c7qGdmlXd0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-295-QaRxlUhJNmqUgMZ5gq8NPw-1; Tue, 13 Jan 2026 07:34:54 -0500
X-MC-Unique: QaRxlUhJNmqUgMZ5gq8NPw-1
X-Mimecast-MFC-AGG-ID: QaRxlUhJNmqUgMZ5gq8NPw_1768307693
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42fd46385c0so4301362f8f.0
        for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 04:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768307693; x=1768912493; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RMav5ORr40B5ZJ3PX7IVd5/NdRqYgN0BnH9+9JS6Dfg=;
        b=cvw9nSgjYGWxOJOcUxDkNigeOiMd3wYid9pzzj7VaqHVGaEPAkMYY4FzWHO8b98SI6
         rGFym+nnpkucVD6eU/gog+t06jb64EITEELPDpDdJGGfMh40uMY2w+XAqmNK7LzsQtDn
         z9dRVODLBSQEQFl0l1ikblELlk9eFQbWSw2opDX7HcYXU2VrFgWotE/lxP5ZVQcMsrAb
         mO4a9Hu97+OIz5bxh2usvr16NpVLYoVf6xfgEXvPQTlQhetWZl37cRG+OaAwCcHhy2mX
         M4/6Rzcr7ElKTRNR1XglM6uLb1xqWze3ZU5rWZig+oSisy6UF9LG60Y5dunc+cp2+j6w
         tK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768307693; x=1768912493;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RMav5ORr40B5ZJ3PX7IVd5/NdRqYgN0BnH9+9JS6Dfg=;
        b=sFRNmUmDqwAew1wxJVYNWIobkRNvaFiyp697o0EJK7wojkhPY36ve/w8OuHQXnOzXh
         Qv9WyQsO/GZhvp157pxpFrKQGpBFkdWELxYS75RqF+mavC4VhLv4jKPJKCYkb+qh1ML7
         kvQPO/MYcxpzpEngjv8hEERy3zsK4kAblRB5dypqBm/JtUk6tnfXhLNhAuUynaltspk/
         ZpALlQ3KWBAV1eJlzgji8FPo514RcSTPGmC1tPsqcjCfHFvw1CEMeCM1cfNqLYw9cSnd
         ojoYVesX3wfjscEXP2aFWp9DoeK5az8IAiAfGHaL+C0Lad0uRJi9IFVDbQUQsxVZ9E4d
         wuSw==
X-Forwarded-Encrypted: i=1; AJvYcCUz0QV100dv1ktLwEBdqMdg30vQB4x75ei7NcIc4U+sDBX/THWyyUp/JGKv4bpojWzw9Lk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnpHZVI2OGoevai6sPR1z2aVr1IVtpzOt/RNjT4za1o0dc5D/m
	TSD+uRE0vJ4qp9mzMzdKmOwd+PG5Q7zN192n/wdzmx64ViwgH65nZk+hrUkwVs5vA264LWNw+9N
	HmB8fDrnTQuSrNX4wJXW7v2TvuOzy6SOR6I5/pMZmTs3PtTeqP0mkVg==
X-Gm-Gg: AY/fxX6cvkpL3HyJTa6bEgtCLGy9UDNiNwShf6UMq5g55whNsvGW3vxoMT7SQdSOPsO
	QNh9xASpQrfrivz/j0qRGEs5hHt1aC40eWJlJ/MLRUxvihofH1mA2LR/Wyf4mtHWdO5isY8RqfT
	qH4+2XWltL1E01Hagkky4GALMAElyntGARZljhzNyvN/w59NZS+U9426PUB5/VfztqefSJjUqVm
	8XMfllgvu+W2XJeoHMS5l0w8NE3v0SX2o47n4bEoI4YQNUXgPjwSOBdVhH8+QWlVvsg2FA2AMSQ
	L/RwMKgjn+ZidCKU5OGurMY/wgthigTA5BeIXx23twuEIbmh4afLkEt5lIcvmQzR6fy9xen7AGI
	VnQ6VzxYWd6CYPRCG8mra+wOcSo4DXc8=
X-Received: by 2002:a05:6000:1848:b0:42f:bb4a:9989 with SMTP id ffacd0b85a97d-432c3643752mr26574328f8f.28.1768307693363;
        Tue, 13 Jan 2026 04:34:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGdMY63/sGfd2busjL/3EFebfjWWEXx17qrEVF2SlUXV5weYiNb4jjXLaF2lxpqKK8G6ehV1Q==
X-Received: by 2002:a05:6000:1848:b0:42f:bb4a:9989 with SMTP id ffacd0b85a97d-432c3643752mr26574275f8f.28.1768307692882;
        Tue, 13 Jan 2026 04:34:52 -0800 (PST)
Received: from redhat.com (IGLD-80-230-35-22.inter.net.il. [80.230.35.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5fe67csm43944494f8f.40.2026.01.13.04.34.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 04:34:52 -0800 (PST)
Date: Tue, 13 Jan 2026 07:34:48 -0500
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
Message-ID: <20260113073428-mutt-send-email-mst@kernel.org>
References: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
 <20251223-vsock-vmtest-v13-2-9d6db8e7c80b@meta.com>
 <20260111013536-mutt-send-email-mst@kernel.org>
 <aWWFB2K5H5OXGWP8@devvm11784.nha0.facebook.com>
 <aWWXTx6SSNiV3a+v@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWWXTx6SSNiV3a+v@devvm11784.nha0.facebook.com>

On Mon, Jan 12, 2026 at 04:52:31PM -0800, Bobby Eshleman wrote:
> On Mon, Jan 12, 2026 at 03:34:31PM -0800, Bobby Eshleman wrote:
> > On Sun, Jan 11, 2026 at 01:43:37AM -0500, Michael S. Tsirkin wrote:
> > > On Tue, Dec 23, 2025 at 04:28:36PM -0800, Bobby Eshleman wrote:
> > > > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > > > 
> > > > Add netns logic to vsock core. Additionally, modify transport hook
> > > > prototypes to be used by later transport-specific patches (e.g.,
> > > > *_seqpacket_allow()).
> > > > 
> > > > Namespaces are supported primarily by changing socket lookup functions
> > > > (e.g., vsock_find_connected_socket()) to take into account the socket
> > > > namespace and the namespace mode before considering a candidate socket a
> > > > "match".
> > > > 
> > > > This patch also introduces the sysctl /proc/sys/net/vsock/ns_mode to
> > > > report the mode and /proc/sys/net/vsock/child_ns_mode to set the mode
> > > > for new namespaces.
> > > > 
> > > > Add netns functionality (initialization, passing to transports, procfs,
> > > > etc...) to the af_vsock socket layer. Later patches that add netns
> > > > support to transports depend on this patch.
> > > > 
> > > > dgram_allow(), stream_allow(), and seqpacket_allow() callbacks are
> > > > modified to take a vsk in order to perform logic on namespace modes. In
> > > > future patches, the net will also be used for socket
> > > > lookups in these functions.
> > > > 
> > > > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> > > 
> > > ...
> > > 
> > > 
> > > >  static int __vsock_bind_connectible(struct vsock_sock *vsk,
> > > >  				    struct sockaddr_vm *addr)
> > > >  {
> > > > +	struct net *net = sock_net(sk_vsock(vsk));
> > > >  	static u32 port;
> > > >  	struct sockaddr_vm new_addr;
> > > >
> > > 
> > > 
> > > Hmm this static port gives me pause. So some port number info leaks
> > > between namespaces. I am not saying it's a big security issue
> > > and yet ... people expect isolation.
> > 
> > Probably the easiest solution is making it per-ns, my quick rough draft
> > looks like this:
> > 
> > diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
> > index e2325e2d6ec5..b34d69a22fa8 100644
> > --- a/include/net/netns/vsock.h
> > +++ b/include/net/netns/vsock.h
> > @@ -11,6 +11,10 @@ enum vsock_net_mode {
> >  
> >  struct netns_vsock {
> >  	struct ctl_table_header *sysctl_hdr;
> > +
> > +	/* protected by the vsock_table_lock in af_vsock.c */
> > +	u32 port;
> > +
> >  	enum vsock_net_mode mode;
> >  	enum vsock_net_mode child_ns_mode;
> >  };
> > diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> > index 9d614e4a4fa5..cd2a47140134 100644
> > --- a/net/vmw_vsock/af_vsock.c
> > +++ b/net/vmw_vsock/af_vsock.c
> > @@ -748,11 +748,10 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> >  				    struct sockaddr_vm *addr)
> >  {
> >  	struct net *net = sock_net(sk_vsock(vsk));
> > -	static u32 port;
> >  	struct sockaddr_vm new_addr;
> >  
> > -	if (!port)
> > -		port = get_random_u32_above(LAST_RESERVED_PORT);
> > +	if (!net->vsock.port)
> > +		net->vsock.port = get_random_u32_above(LAST_RESERVED_PORT);
> >  
> >  	vsock_addr_init(&new_addr, addr->svm_cid, addr->svm_port);
> >  
> > @@ -761,11 +760,11 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
> >  		unsigned int i;
> >  
> >  		for (i = 0; i < MAX_PORT_RETRIES; i++) {
> > -			if (port == VMADDR_PORT_ANY ||
> > -			    port <= LAST_RESERVED_PORT)
> > -				port = LAST_RESERVED_PORT + 1;
> > +			if (net->vsock.port == VMADDR_PORT_ANY ||
> > +			    net->vsock.port <= LAST_RESERVED_PORT)
> > +				net->vsock.port = LAST_RESERVED_PORT + 1;
> >  
> > -			new_addr.svm_port = port++;
> > +			new_addr.svm_port = net->vsock.port++;
> >  
> >  			if (!__vsock_find_bound_socket_net(&new_addr, net)) {
> >  				found = true;
> > 
> > 
> > 
> 
> Another option being to follow inet's path and use
> siphash_4u32() the way that secure_ipv4_port_ephemeral() does...

Also acceptable.


