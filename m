Return-Path: <kvm+bounces-67849-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF74D15D42
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:35:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 62B53305DDAD
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 23:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B14AF29D29D;
	Mon, 12 Jan 2026 23:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GLsM2Q0v"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B12329D277
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 23:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768260876; cv=none; b=DOHfiSjyGT1OMPzSUsKlt81QSvqHd2qQDW4mf2AUermdXq6lPP6xhEMDME/+bVYX+RT2Q0cMTRc0K0fp2K7XPEhLD+RGjJ8VROd4p8+mNJl4wg2pZ6FT2apUP7L6EV+DjKVTF7M3hUv/OiWvT7PFCqQyDeNvGBHfEndb9QzkTUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768260876; c=relaxed/simple;
	bh=ciALBiXpEllKNFFriaJFGexCh1jC8WmBZIOo2yR764A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NDvZLlAlmu63XOmG3iS/ejo2TDA+5E4k7Hl1jUoFOqOkhI1XmGOrkNeH+XEX0zJdZLFvGiL4E8kzOw8JKTXE2pI0mCOjjcRMbrLNb3Azr1Qso0AUh/zwqXH/3E6RVb9l3iS7NqBVw+Pe8ED4JutPT+0ok3f39A1OeqDx2z7VeG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GLsM2Q0v; arc=none smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-78fb6c7874cso76624907b3.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 15:34:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768260873; x=1768865673; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lU3GpweyZ8RZOMAzOI1qx6iERtUR7NcEkRCk8jZG9C4=;
        b=GLsM2Q0vk2Ks1InFDU1aFAEOW3ml3VNM9MPHGwUKpiJk0yG09otzeKJzwx4w/9goq7
         jo3fNI85FbzAVRmFLtt4ki8HFOUAGMRd6iYvuwBhn1lvG8+lq/POhLuzSooUzN/MfvJ6
         pB720rbU4eLMxBKnD33+SKhGK7A7vpVunyg+n05qSwXyww6TX/J9SdAPdfL+MQuVWwqJ
         nIO0QDTvsFr4yI6oJW3exxkP2wPuwefKXH7M0DRY2lJeepeE+Bcc+g/EujrtWyozG0QE
         q/FjwbmotSJZzAsn42J7rQvb1W++aoewfBc3JaOFoyIqgc7nI8PDPCGUGrHEoshcQQH3
         exPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768260873; x=1768865673;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lU3GpweyZ8RZOMAzOI1qx6iERtUR7NcEkRCk8jZG9C4=;
        b=ndNCOdoQCGMpwqPRxYyLrA+EyDIgF7ooaEl/oJhxR2uDy+Jg7sLutuUA4eR5bBJsix
         fwpf+m3tF26L8s0qqfTocurdLsAQxB+f43Sz4AvtlBgY5e9E/ECoKqiZ7jQYYlDaqcWA
         z30vTyvpO4VXyBOH9dXobpsB9dMOO8P0cvhK/iTfEtQR+OqGotgoDsIHpkEfcESp0Fwy
         uuJyQSPY9p6WG4/+ssTRWidSBswi+EwuflFMC8FKB+LGmXLVH7bZpo8NG05zrF5zZ/xN
         GMD375pv4U8nYi8KmPU8fVENjsrsInvErrzf2vlWiskMDrd4FEUbm5x/TlHgjWqyUCno
         UJRA==
X-Forwarded-Encrypted: i=1; AJvYcCXvgoNlwNI88cR6DQmjVeBj1VaXlHgVa/7bLrf3vZxF7inhXDLdofjj2eyHbECO7dWp1eY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvVTmbwR3y1O33nc/MLOfcfJ2QUNVGMFX0VAEdbH/ZQ2J4yh0O
	/AnXi67oFs5aXDhmkKMANC3uCo73jr7yY7LAX2P4rHLUF3NrYVjIxw4x
X-Gm-Gg: AY/fxX7SiJaYObONP/cTLgBWoN/pmmegI9ZSsuDJ5gu2eVa62Geyd5Dfb5ETL0E0v9b
	8MOfRunTYMZcscoQqCn+hb97erB+OzOzZuFo/z5FwaA8fWqCTMGZSnU00CHtDEdA+yBtiYrsmCj
	/nA73Cv+UrJDEfaRLTR8RV+Gzo7js846ACuA4Z3KQoqRdKMKLPP9DP5DY8zJl1h2HObp/f7u1vU
	P3fguusJCznWT9kCnb3xu8YT7Eua3xIdHJm1QLe25ny++p6sQOHyX+W40WRLTPxFyUAUiySdfyn
	xGCSIvptbVFJ0hBa6CK4IYzpqHMcVsiNIh2jo9VCTBhBgSnvbZhhZN611fV3sd8HXC1LcGVMvpO
	oXa98LlhSNvElG/lnkjwEKOPLwqN6FkLeUp9LW9H0cTIA99iDYYrsVwwzv2t0HnMLxGuUU3qpQM
	IoAfwv67hjaWmPwXaLL3LkbFCg00syPsWD7g==
X-Google-Smtp-Source: AGHT+IFhnnLo9DObqpMPdGqLw+yvW/DLOUbdTMJjsPRgCKmDKj2orYWmy7Hu/cmK9w1YD06BNt4rZg==
X-Received: by 2002:a53:c0c9:0:b0:63f:9928:3f85 with SMTP id 956f58d0204a3-64716c61192mr12174478d50.62.1768260873367;
        Mon, 12 Jan 2026 15:34:33 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:9::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6470d80d2c2sm8665513d50.8.2026.01.12.15.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 15:34:33 -0800 (PST)
Date: Mon, 12 Jan 2026 15:34:31 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
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
Message-ID: <aWWFB2K5H5OXGWP8@devvm11784.nha0.facebook.com>
References: <20251223-vsock-vmtest-v13-0-9d6db8e7c80b@meta.com>
 <20251223-vsock-vmtest-v13-2-9d6db8e7c80b@meta.com>
 <20260111013536-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260111013536-mutt-send-email-mst@kernel.org>

On Sun, Jan 11, 2026 at 01:43:37AM -0500, Michael S. Tsirkin wrote:
> On Tue, Dec 23, 2025 at 04:28:36PM -0800, Bobby Eshleman wrote:
> > From: Bobby Eshleman <bobbyeshleman@meta.com>
> > 
> > Add netns logic to vsock core. Additionally, modify transport hook
> > prototypes to be used by later transport-specific patches (e.g.,
> > *_seqpacket_allow()).
> > 
> > Namespaces are supported primarily by changing socket lookup functions
> > (e.g., vsock_find_connected_socket()) to take into account the socket
> > namespace and the namespace mode before considering a candidate socket a
> > "match".
> > 
> > This patch also introduces the sysctl /proc/sys/net/vsock/ns_mode to
> > report the mode and /proc/sys/net/vsock/child_ns_mode to set the mode
> > for new namespaces.
> > 
> > Add netns functionality (initialization, passing to transports, procfs,
> > etc...) to the af_vsock socket layer. Later patches that add netns
> > support to transports depend on this patch.
> > 
> > dgram_allow(), stream_allow(), and seqpacket_allow() callbacks are
> > modified to take a vsk in order to perform logic on namespace modes. In
> > future patches, the net will also be used for socket
> > lookups in these functions.
> > 
> > Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
> 
> ...
> 
> 
> >  static int __vsock_bind_connectible(struct vsock_sock *vsk,
> >  				    struct sockaddr_vm *addr)
> >  {
> > +	struct net *net = sock_net(sk_vsock(vsk));
> >  	static u32 port;
> >  	struct sockaddr_vm new_addr;
> >
> 
> 
> Hmm this static port gives me pause. So some port number info leaks
> between namespaces. I am not saying it's a big security issue
> and yet ... people expect isolation.

Probably the easiest solution is making it per-ns, my quick rough draft
looks like this:

diff --git a/include/net/netns/vsock.h b/include/net/netns/vsock.h
index e2325e2d6ec5..b34d69a22fa8 100644
--- a/include/net/netns/vsock.h
+++ b/include/net/netns/vsock.h
@@ -11,6 +11,10 @@ enum vsock_net_mode {
 
 struct netns_vsock {
 	struct ctl_table_header *sysctl_hdr;
+
+	/* protected by the vsock_table_lock in af_vsock.c */
+	u32 port;
+
 	enum vsock_net_mode mode;
 	enum vsock_net_mode child_ns_mode;
 };
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9d614e4a4fa5..cd2a47140134 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -748,11 +748,10 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 				    struct sockaddr_vm *addr)
 {
 	struct net *net = sock_net(sk_vsock(vsk));
-	static u32 port;
 	struct sockaddr_vm new_addr;
 
-	if (!port)
-		port = get_random_u32_above(LAST_RESERVED_PORT);
+	if (!net->vsock.port)
+		net->vsock.port = get_random_u32_above(LAST_RESERVED_PORT);
 
 	vsock_addr_init(&new_addr, addr->svm_cid, addr->svm_port);
 
@@ -761,11 +760,11 @@ static int __vsock_bind_connectible(struct vsock_sock *vsk,
 		unsigned int i;
 
 		for (i = 0; i < MAX_PORT_RETRIES; i++) {
-			if (port == VMADDR_PORT_ANY ||
-			    port <= LAST_RESERVED_PORT)
-				port = LAST_RESERVED_PORT + 1;
+			if (net->vsock.port == VMADDR_PORT_ANY ||
+			    net->vsock.port <= LAST_RESERVED_PORT)
+				net->vsock.port = LAST_RESERVED_PORT + 1;
 
-			new_addr.svm_port = port++;
+			new_addr.svm_port = net->vsock.port++;
 
 			if (!__vsock_find_bound_socket_net(&new_addr, net)) {
 				found = true;



Not as nice, but not necessarily horrid. WDYT?

Best,
Bobby

