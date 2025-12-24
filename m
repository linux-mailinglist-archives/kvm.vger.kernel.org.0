Return-Path: <kvm+bounces-66664-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0314ACDB2C6
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 03:26:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 97C6030358F4
	for <lists+kvm@lfdr.de>; Wed, 24 Dec 2025 02:26:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E8A7272813;
	Wed, 24 Dec 2025 02:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cMdCb7jG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9707F279DCA
	for <kvm@vger.kernel.org>; Wed, 24 Dec 2025 02:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766543186; cv=none; b=aPJByiDzyuoR9JkARuLcc8laab5J+YbHMT1zXFsXcZa0Dsn60wKidrycdHZvdw9I18vdjp+H4SbKntfi4NRVBZYi+Hg5ZHyOAmJewAQMD0EVKn76cHrLTzmdihA+7IGM6VB8iu+DeGz48Yt692ojBp7Qu0da00nW28tLl7CD6hA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766543186; c=relaxed/simple;
	bh=fag3FxlJG3ZXO56Q4uis4IXo7o2vEhpJMwuQCgBCfc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pSAXc7F66xNFJRKHTk+bE+7C6WOd1Fru8cfoFU3ptE02sNhYyRXGubBaEgCpeU14qjIjCpi1OPqyKW6jD6DI+hOJnGMyHgnpfwqpunXrLIMiAOSnkHMfMv5Li4sRcQUgYGKI+z9DIyqpov4PrLbwINfTkTN6bBeYH7mhRFggi7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cMdCb7jG; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-45391956bfcso4452928b6e.3
        for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 18:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766543183; x=1767147983; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mn5gdOJNVLCgqxTAZaOj5KghlS4vIZEHYcNf0bwJm28=;
        b=cMdCb7jGNTobfpUWo0SruY8GR1VJ83xM6hgzqLHYr6x5UZf7ZGPHugl69hYZQPgFNc
         s3mzx9/Zwf4ILroPEPsbMb69FwPIeMLAvxfcccQjDAXiOpZQVphodwAyHRPBJM0WydwQ
         b48zxteORTrlnBJHShWRaBGUAV9olldH3EJqlw1lnTRV2P8DyZnP6B1F69afqEgcWOs+
         sr8bgxEBn0W+4r7SYgDjHLUtHTXSw9rRdr0JbvDLpQw/7393lt9SAP9zaDfV3Lig09L8
         rs7TWG2J04YrvRMF+xhKU9jFca7QMNNFlQceRqwU8lGp/HzTckp4FH1xYB54VBkMpYCI
         BDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766543183; x=1767147983;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mn5gdOJNVLCgqxTAZaOj5KghlS4vIZEHYcNf0bwJm28=;
        b=qpoOKu1LEpZ8UbFcEXqzlQMo0BwhWjyUhUiqhaClCalbHJWKRwe5/xR7IKnwnMFUQz
         0lfYe2pjFMRxwqkGbBymf0kUKBcoFrDHtdBjWthIztfH16ne+TWBfm80BHpSDSN3Ys9n
         1ANKiL7P3FgreZLbXl3FdUiyCQ7hmZXGEFTInXBhncq9HAv6+8nG2cUJnoeexBieXuk4
         gpme4EEZJ51UTxlxz6GkKYSWthl97kebF6r5LQELrvIQTj+epOJ/LyoUf1qjSgWhhp+8
         7eDFg8A8BPuZJ63YmJw7Vc8H77480zAhG0+MH6sjqrLdyNvuNvNkccZGJopZcg9sshEW
         DjdA==
X-Forwarded-Encrypted: i=1; AJvYcCXIphoxipl+TIvks7K6Ss/Uia0/8BhwRAuNeuRUjcFuioZ9eZ8h8kZxcxXJ4asNGqb86ys=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnpZEDmfONy51s2kstUt8FOQxmUlsSggYLz6ZxvTlBR5tm4nNj
	Xoj6hFKE4InGm/rVhAIuCJJcxK4OdUoy6508n0fdvQFu1BFWP1+PtwhsqMUcow==
X-Gm-Gg: AY/fxX5aYCjQHqKiP2dVlJo5G9yRrTf251+lYyJJfnnrA+TMcdbaShnrl5F45rfq5M+
	dr8FMuQ8Tbwhkgp1uJtEWagYbPRqLErazQfRCNzmDRvx62zxvrpU+978WF3mnz0OJ9jUPDbGdzv
	n9kukgBrjzwkZugWRzw7gUElxr+Xy0Vs0+pW5PqQcgBiUDQ7aR6DRe6+MFM2zPsSI+lw1vOcQJt
	7SBOwOezeIpTHs65N8qHDNI6/c04hcdMNMBwb1wipi6DJmyvejZvW5lksQDO2Yw0t1omVCxXm0p
	gbMD2S0iU7mupSsl8WbY+sv/vvXTE9Z2Ps/rO2SPrrBNCjr5iImifWsZlC1QnFJW3/rBKHTpxFT
	rofXwyXMif6mhJT/t2Ib7jAVQIfqwFJRB9F610vydPfcIjwgAS11aYc5Z5ej/NLk0Ys1rwK6zh5
	xh1uauhx878uHAxV6SmJACSo5aXj9Rupv4idaIUNnbzLzFkAM=
X-Google-Smtp-Source: AGHT+IGl4lY3C5uaIhAdAeU51l9QnKvRP/mJp5bbTNMXCgmCDrIGHmPARt/rlh3H/cQnB4TIEc9mUg==
X-Received: by 2002:a05:690c:d96:b0:78f:aa6d:48cd with SMTP id 00721157ae682-78fb3d52b45mr134838347b3.0.1766536355576;
        Tue, 23 Dec 2025 16:32:35 -0800 (PST)
Received: from devvm11784.nha0.facebook.com ([2a03:2880:25ff:5f::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb4378372sm59887097b3.12.2025.12.23.16.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 16:32:35 -0800 (PST)
Date: Tue, 23 Dec 2025 16:32:30 -0800
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryan-bt.tan@broadcom.com>,
	Vishnu Dasa <vishnu.dasa@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, netdev@vger.kernel.org,
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kselftest@vger.kernel.org, berrange@redhat.com,
	Sargun Dhillon <sargun@sargun.me>,
	Bobby Eshleman <bobbyeshleman@meta.com>
Subject: Re: [PATCH net-next v12 04/12] vsock: add netns support to virtio
 transports
Message-ID: <aUs0no+ni8/R8/1N@devvm11784.nha0.facebook.com>
References: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
 <20251126-vsock-vmtest-v12-4-257ee21cd5de@meta.com>
 <6cef5a68-375a-4bb6-84f8-fccc00cf7162@redhat.com>
 <aS8oMqafpJxkRKW5@devvm11784.nha0.facebook.com>
 <06b7cfea-d366-44f7-943e-087ead2f25c2@redhat.com>
 <aS9hoOKb7yA5Qgod@devvm11784.nha0.facebook.com>
 <aTw0F6lufR/nT7OY@devvm11784.nha0.facebook.com>
 <uidarlot7opjsuozylevyrlgdpjd32tsi7mwll2lsvce226v24@75sq4jdo5tgv>
 <aUC0Op2trtt3z405@devvm11784.nha0.facebook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUC0Op2trtt3z405@devvm11784.nha0.facebook.com>

On Mon, Dec 15, 2025 at 05:22:02PM -0800, Bobby Eshleman wrote:
> On Mon, Dec 15, 2025 at 03:11:22PM +0100, Stefano Garzarella wrote:
> > On Fri, Dec 12, 2025 at 07:26:15AM -0800, Bobby Eshleman wrote:
> > > On Tue, Dec 02, 2025 at 02:01:04PM -0800, Bobby Eshleman wrote:
> > > > On Tue, Dec 02, 2025 at 09:47:19PM +0100, Paolo Abeni wrote:
> > > > > On 12/2/25 6:56 PM, Bobby Eshleman wrote:
> > > > > > On Tue, Dec 02, 2025 at 11:18:14AM +0100, Paolo Abeni wrote:
> > > > > >> On 11/27/25 8:47 AM, Bobby Eshleman wrote:
> > > > > >>> @@ -674,6 +689,17 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
> > > > > >>>  		goto out;
> > > > > >>>  	}
> > > > > >>>
> > > > > >>> +	net = current->nsproxy->net_ns;
> > > > > >>> +	vsock->net = get_net_track(net, &vsock->ns_tracker, GFP_KERNEL);
> > > > > >>> +
> > > > > >>> +	/* Store the mode of the namespace at the time of creation. If this
> > > > > >>> +	 * namespace later changes from "global" to "local", we want this vsock
> > > > > >>> +	 * to continue operating normally and not suddenly break. For that
> > > > > >>> +	 * reason, we save the mode here and later use it when performing
> > > > > >>> +	 * socket lookups with vsock_net_check_mode() (see vhost_vsock_get()).
> > > > > >>> +	 */
> > > > > >>> +	vsock->net_mode = vsock_net_mode(net);
> > > > > >>
> > > > > >> I'm sorry for the very late feedback. I think that at very least the
> > > > > >> user-space needs a way to query if the given transport is in local or
> > > > > >> global mode, as AFAICS there is no way to tell that when socket creation
> > > > > >> races with mode change.
> > > > > >
> > > > > > Are you thinking something along the lines of sockopt?
> > > > >
> > > > > I'd like to see a way for the user-space to query the socket 'namespace
> > > > > mode'.
> > > > >
> > > > > sockopt could be an option; a possibly better one could be sock_diag. Or
> > > > > you could do both using dumping the info with a shared helper invoked by
> > > > > both code paths, alike what TCP is doing.
> > > > > >> Also I'm a bit uneasy with the model implemented here, as 'local' socket
> > > > > >> may cross netns boundaris and connect to 'local' socket in other netns
> > > > > >> (if I read correctly patch 2/12). That in turns AFAICS break the netns
> > > > > >> isolation.
> > > > > >
> > > > > > Local mode sockets are unable to communicate with local mode (and global
> > > > > > mode too) sockets that are in other namespaces. The key piece of code
> > > > > > for that is vsock_net_check_mode(), where if either modes is local the
> > > > > > namespaces must be the same.
> > > > >
> > > > > Sorry, I likely misread the large comment in patch 2:
> > > > >
> > > > > https://lore.kernel.org/netdev/20251126-vsock-vmtest-v12-2-257ee21cd5de@meta.com/
> > > > >
> > > > > >> Have you considered instead a slightly different model, where the
> > > > > >> local/global model is set in stone at netns creation time - alike what
> > > > > >> /proc/sys/net/ipv4/tcp_child_ehash_entries is doing[1] - and
> > > > > >> inter-netns connectivity is explicitly granted by the admin (I guess
> > > > > >> you will need new transport operations for that)?
> > > > > >>
> > > > > >> /P
> > > > > >>
> > > > > >> [1] tcp allows using per-netns established socket lookup tables - as
> > > > > >> opposed to the default global lookup table (even if match always takes
> > > > > >> in account the netns obviously). The mentioned sysctl specify such
> > > > > >> configuration for the children namespaces, if any.
> > > > > >
> > > > > > I'll save this discussion if the above doesn't resolve your concerns.
> > > > > I still have some concern WRT the dynamic mode change after netns
> > > > > creation. I fear some 'unsolvable' (or very hard to solve) race I can't
> > > > > see now. A tcp_child_ehash_entries-like model will avoid completely the
> > > > > issue, but I understand it would be a significant change over the
> > > > > current status.
> > > > >
> > > > > "Luckily" the merge window is on us and we have some time to discuss. Do
> > > > > you have a specific use-case for the ability to change the netns >
> > > > mode
> > > > > after creation?
> > > > >
> > > > > /P
> > > > 
> > > > I don't think there is a hard requirement that the mode be change-able
> > > > after creation. Though I'd love to avoid such a big change... or at
> > > > least leave unchanged as much of what we've already reviewed as
> > > > possible.
> > > > 
> > > > In the scheme of defining the mode at creation and following the
> > > > tcp_child_ehash_entries-ish model, what I'm imagining is:
> > > > - /proc/sys/net/vsock/child_ns_mode can be set to "local" or "global"
> > > > - /proc/sys/net/vsock/child_ns_mode is not immutable, can change any
> > > >   number of times
> > > > 
> > > > - when a netns is created, the new netns mode is inherited from
> > > >   child_ns_mode, being assigned using something like:
> > > > 
> > > > 	  net->vsock.ns_mode =
> > > > 		get_net_ns_by_pid(current->pid)->child_ns_mode
> > > > 
> > > > - /proc/sys/net/vsock/ns_mode queries the current mode, returning
> > > >   "local" or "global", returning value of net->vsock.ns_mode
> > > > - /proc/sys/net/vsock/ns_mode and net->vsock.ns_mode are immutable and
> > > >   reject writes
> > > > 
> > > > Does that align with what you have in mind?
> > > 
> > > Hey Paolo, I just wanted to sync up on this one. Does the above align
> > > with what you envision?
> > 
> > Hi Bobby, AFAIK Paolo was at LPC, so there could be some delay.
> > 
> > FYI I'll be off from Dec 25 to Jan 6, so if we want to do an RFC in the
> > middle, I'll do my best to take a look before my time off.
> > 
> > Thanks,
> > Stefano

Just sent this out, though I acknowledge its pretty last minute WRT
your time off.

If I don't hear from you before then, have a good holiday!

Best,
Bobby

