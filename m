Return-Path: <kvm+bounces-65212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F651C9F41B
	for <lists+kvm@lfdr.de>; Wed, 03 Dec 2025 15:16:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1A953A2F4D
	for <lists+kvm@lfdr.de>; Wed,  3 Dec 2025 14:16:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449802FBDF3;
	Wed,  3 Dec 2025 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eAGWakgM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="jTHMGuLM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9D41B983F
	for <kvm@vger.kernel.org>; Wed,  3 Dec 2025 14:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764771384; cv=none; b=Pc2jp7cZAdk2d/QjdKGRnbERbSiQuEMe4b3L+ipOCgmXVO6RJG0x1L0ki5dgepfL+kVm1X+4jE6YmiAkvGc/MyXRtBstRdGFSSOFGGgScciZ9uXUfsUfmQsRzxRMpMXMeK9rHx0cAj2UtMwLuo+qQ3g0ideqCbZTIe4+05uqH2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764771384; c=relaxed/simple;
	bh=S/P/cNG8N0lBHrNlEfCWLS5Dg2sft4fFl6BKjXwHzq0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=duVBbKSb3ApxeA8bkDIj753oBUop7HCCBq9rEsk9klaP48vynOxMmQGM9m5LqV5I+V6YcQVXA3p5SmyoNxRhzgU4Vp03duslUzf0u/tj3V/DSQilHHqxLVT3D2knBxTNsqo0jUJ7/ORi7uhj9t8ZpkTyQDu7XR3+nndsCpXkCHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eAGWakgM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=jTHMGuLM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764771380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m6MmnBAj0sXBLiUH9SOIpXTvoEYpfaN7w1YH+RlAfVY=;
	b=eAGWakgMNw1UYQUJ/IR9uU36OMik/qMbP1wH3ZYuNa33yb7E18i1QD0U/UgG7vRnIwgxx6
	FQyxUzLvic9pmEaHr3ZOKqEFbPAies6tkVtsjquzj+4xgyGrL4LBv+Y1EBlC6yvUrlxfKN
	K/ITtm+rQUXXexxOTL3M+aOOX54hBEs=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-477-Xx5RYgfjP9KJhHo917d_ug-1; Wed, 03 Dec 2025 09:16:19 -0500
X-MC-Unique: Xx5RYgfjP9KJhHo917d_ug-1
X-Mimecast-MFC-AGG-ID: Xx5RYgfjP9KJhHo917d_ug_1764771379
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-297ddb3c707so52968505ad.2
        for <kvm@vger.kernel.org>; Wed, 03 Dec 2025 06:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764771378; x=1765376178; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m6MmnBAj0sXBLiUH9SOIpXTvoEYpfaN7w1YH+RlAfVY=;
        b=jTHMGuLMidyXspau9WNznJuiIYXr9NSJnvLwNL1eXj8VsWYkzq8uxO0VCD2Kj3tXVx
         EafPwBarOHeUd7Qx9at5LUVi5Ts++4Q2S7NpOfVF/f1vehiWqB4yIAb2Vao3CzyUq4b8
         BQEdMwYBu+Y81jvKZ2b5Yu0xZKmyzs1njI8tgh91VWvC5KOzrpamZugJADH6US2APv6+
         3g3jQxpSKtw7I7DW1q5ATH9M76h+yHYQDc+/lazgNEObhIBHG5/OypM64CpSa2Y7DwMm
         Ilh5gcOWj8PBVCb5s8XtBjGTmDp6qme9ln3iSjdBhkWtHN6wYngRQiUGRAgMaO3mKCel
         qFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764771378; x=1765376178;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m6MmnBAj0sXBLiUH9SOIpXTvoEYpfaN7w1YH+RlAfVY=;
        b=LZ7k5C/bax5nahGnZOq7UG+oSnnA3crf+E4GN7kLId17QM5F6raGsmf3cIRSyxc+v8
         tjIYbWMs9T4lctYsxfQ/dkhhDxTHw/9ZRmANOeBs+pLr7SWZnCzx0ZybyBu4Cmg1g0rQ
         tPkZ25G778irJzbhhfLjJCOIal8+WWaWiOJEv6GquDp2VEZB1uK1tbVt6R5OJ1uPr7lg
         fo7t7ypD4GnZ6ZOqssfoSWPCcg6UlJkltyVZzykjkHitLjsOboh5e3uk5QEpUhX2mM7+
         rBx0gnniEX5SWeLkXOINuM5EJItHo7z7Dq+j2Zu1T+BnSkK2/0o5PqZvlisgjmRXgO7n
         cuyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMF92gaJ7GoMQnMiQdLG2+EckfTfFUYS4r3im0PEj0HWfHIoyGnF40eMJIT88l5llfoKA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx26qlnXW1aLZwF4sfceOhzuIDxi3JTL6Gjq77cQEceGW+nSqKI
	8ZDN2lWJf3jvjIZWk1BSOLrDvtxsv6C+kIie7FnfNAOrEuxP2xRzcxzX+qgiSMPFef7jMSe0wLM
	UZDKQx+6gTEOQo9Li4Xw/zM0nuATA4mWEOcnL01wksiBuKweDq6SjeNGbquFiskKxUFno28IGdC
	XCajgaQA7vwNbLDIvQQYKf1qj+naIh
X-Gm-Gg: ASbGncsSz8Kyhs7fwV4ietlShl0SiBfzXbXjyHdIIZtBCC2MKgGTsU/rw0QL1tJvB4U
	SPFAXeF2xxYdxnX10uhYwUH+k/xG5qracwWWsuj9nEnUQ1YyARK9ZNY7aCOkBrRUl2GFgg8C5gG
	yqJRAAiNlIQF3k9W+NKouZqdMokWvnd+POKESftQuch7G5+pYbTj3Hg9ij1RGijDmR
X-Received: by 2002:a17:902:c94f:b0:297:f0a8:e84c with SMTP id d9443c01a7336-29d684115bdmr32640015ad.52.1764771378482;
        Wed, 03 Dec 2025 06:16:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFrf4N37GhQAQz44/2vwe63Ab5H+6VDgov2x0HTUYas2MPFLA+zHDJSMoG1KnWS0PCZs11D1TbOfUh6IETwAs4=
X-Received: by 2002:a17:902:c94f:b0:297:f0a8:e84c with SMTP id
 d9443c01a7336-29d684115bdmr32639565ad.52.1764771377945; Wed, 03 Dec 2025
 06:16:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251126-vsock-vmtest-v12-0-257ee21cd5de@meta.com>
 <20251126-vsock-vmtest-v12-4-257ee21cd5de@meta.com> <6cef5a68-375a-4bb6-84f8-fccc00cf7162@redhat.com>
 <aS8oMqafpJxkRKW5@devvm11784.nha0.facebook.com> <06b7cfea-d366-44f7-943e-087ead2f25c2@redhat.com>
 <aS9hoOKb7yA5Qgod@devvm11784.nha0.facebook.com>
In-Reply-To: <aS9hoOKb7yA5Qgod@devvm11784.nha0.facebook.com>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Wed, 3 Dec 2025 15:16:06 +0100
X-Gm-Features: AWmQ_bmkUIFoQHWLakcGQ6CqBOgVjHz_GT5mK5TsKMjW9_hXYBmzRcS2k1f0tSo
Message-ID: <CAGxU2F55uUPb7s9NwxRgU62Kxp8CS7YFkr_wXDHsE1Qd0-OJKw@mail.gmail.com>
Subject: Re: [PATCH net-next v12 04/12] vsock: add netns support to virtio transports
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, "K. Y. Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Bryan Tan <bryan-bt.tan@broadcom.com>, 
	Vishnu Dasa <vishnu.dasa@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, berrange@redhat.com, 
	Sargun Dhillon <sargun@sargun.me>, Bobby Eshleman <bobbyeshleman@meta.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 2 Dec 2025 at 23:01, Bobby Eshleman <bobbyeshleman@gmail.com> wrote:
>
> On Tue, Dec 02, 2025 at 09:47:19PM +0100, Paolo Abeni wrote:
> > On 12/2/25 6:56 PM, Bobby Eshleman wrote:
> > > On Tue, Dec 02, 2025 at 11:18:14AM +0100, Paolo Abeni wrote:
> > >> On 11/27/25 8:47 AM, Bobby Eshleman wrote:
> > >>> @@ -674,6 +689,17 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
> > >>>           goto out;
> > >>>   }
> > >>>
> > >>> + net = current->nsproxy->net_ns;
> > >>> + vsock->net = get_net_track(net, &vsock->ns_tracker, GFP_KERNEL);
> > >>> +
> > >>> + /* Store the mode of the namespace at the time of creation. If this
> > >>> +  * namespace later changes from "global" to "local", we want this vsock
> > >>> +  * to continue operating normally and not suddenly break. For that
> > >>> +  * reason, we save the mode here and later use it when performing
> > >>> +  * socket lookups with vsock_net_check_mode() (see vhost_vsock_get()).
> > >>> +  */
> > >>> + vsock->net_mode = vsock_net_mode(net);
> > >>
> > >> I'm sorry for the very late feedback. I think that at very least the
> > >> user-space needs a way to query if the given transport is in local or
> > >> global mode, as AFAICS there is no way to tell that when socket creation
> > >> races with mode change.
> > >
> > > Are you thinking something along the lines of sockopt?
> >
> > I'd like to see a way for the user-space to query the socket 'namespace
> > mode'.
> >
> > sockopt could be an option; a possibly better one could be sock_diag. Or
> > you could do both using dumping the info with a shared helper invoked by
> > both code paths, alike what TCP is doing.
> > >> Also I'm a bit uneasy with the model implemented here, as 'local' socket
> > >> may cross netns boundaris and connect to 'local' socket in other netns
> > >> (if I read correctly patch 2/12). That in turns AFAICS break the netns
> > >> isolation.
> > >
> > > Local mode sockets are unable to communicate with local mode (and global
> > > mode too) sockets that are in other namespaces. The key piece of code
> > > for that is vsock_net_check_mode(), where if either modes is local the
> > > namespaces must be the same.
> >
> > Sorry, I likely misread the large comment in patch 2:
> >
> > https://lore.kernel.org/netdev/20251126-vsock-vmtest-v12-2-257ee21cd5de@meta.com/
> >
> > >> Have you considered instead a slightly different model, where the
> > >> local/global model is set in stone at netns creation time - alike what
> > >> /proc/sys/net/ipv4/tcp_child_ehash_entries is doing[1] - and
> > >> inter-netns connectivity is explicitly granted by the admin (I guess
> > >> you will need new transport operations for that)?
> > >>
> > >> /P
> > >>
> > >> [1] tcp allows using per-netns established socket lookup tables - as
> > >> opposed to the default global lookup table (even if match always takes
> > >> in account the netns obviously). The mentioned sysctl specify such
> > >> configuration for the children namespaces, if any.
> > >
> > > I'll save this discussion if the above doesn't resolve your concerns.
> > I still have some concern WRT the dynamic mode change after netns
> > creation. I fear some 'unsolvable' (or very hard to solve) race I can't
> > see now. A tcp_child_ehash_entries-like model will avoid completely the
> > issue, but I understand it would be a significant change over the
> > current status.
> >
> > "Luckily" the merge window is on us and we have some time to discuss. Do
> > you have a specific use-case for the ability to change the netns mode
> > after creation?
> >
> > /P
>
> I don't think there is a hard requirement that the mode be change-able
> after creation. Though I'd love to avoid such a big change... or at
> least leave unchanged as much of what we've already reviewed as
> possible.

I think the big part is done, IIUC this should just be a change to the
uAPI and maybe simplify what we have a little (e.g., avoid saving the
mode each socket had when it was created).

>
> In the scheme of defining the mode at creation and following the
> tcp_child_ehash_entries-ish model, what I'm imagining is:
> - /proc/sys/net/vsock/child_ns_mode can be set to "local" or "global"
> - /proc/sys/net/vsock/child_ns_mode is not immutable, can change any
>   number of times
>
> - when a netns is created, the new netns mode is inherited from
>   child_ns_mode, being assigned using something like:
>
>           net->vsock.ns_mode =
>                 get_net_ns_by_pid(current->pid)->child_ns_mode
>
> - /proc/sys/net/vsock/ns_mode queries the current mode, returning
>   "local" or "global", returning value of net->vsock.ns_mode
> - /proc/sys/net/vsock/ns_mode and net->vsock.ns_mode are immutable and
>   reject writes
>
> Does that align with what you have in mind?
>
> Stefano, what are your thoughts?

If we can avoid having sockets in a namespace that can be both global
and local, perhaps it makes a lot of sense to make this change.

My only concern is that there is still a small window where the mode
can change, but we are sure that only one is picked during creation
and then within the namespace this can be easily checked and give us
the assurance that all sockets comply with it, right?

Thanks,
Stefano


