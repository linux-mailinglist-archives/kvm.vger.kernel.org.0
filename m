Return-Path: <kvm+bounces-12467-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0720F88663D
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 06:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 225B6B21A30
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 05:33:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C7CC16430;
	Fri, 22 Mar 2024 05:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PmZdYQsG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 458F614ABA
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 05:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711085468; cv=none; b=HB0wztDFmH0l57YYpi/CYNEzjvm6oPynsYvKo1yeFe9NrPhwSgE6JXag1w7PhnO8QGdWQ2yMaWMsKiCj07S7sYzsA/MvkxeTP+upYQdTPRHc3TQCpOYdqjM7RBHgySK1CGoo/eyG0NUG5yFydeLPO6+MerGaxKPJku6wmSpSUrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711085468; c=relaxed/simple;
	bh=q21Oo2Bry/F1emY/6CL7cFJhoOqCZgnwXMWaEqLUKt4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rQsXv/H5SxQxvzHY/eD0MP+Z3uQC+dzTRrJzwqIDzGBPVe9UCjZgu1K5vHSs0uBsDwzmk20m0mNnX0fslhiWOSmwp1RibDvi1e7Cv6u2HbIT9DzSiqCHZw1D5skmxsJ6Jn7AxFmpzCVzodookqJio7UWirx8IYhf5Ym8fK870es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PmZdYQsG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711085465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zeyqe8RQeD7lvkeazy10PIuuNwicb6A5lKZzL5V9940=;
	b=PmZdYQsGRnZ0hFl7SFhPXEwzzlGwF9201UY3G0fEUvM6YZG2HCTZvPwST2CvqMO6jTfq+V
	btsxb2Ztqdu2fBa0SSEN+n1G1wDd9jMcJnIBKvaQugUGpR6s1IjxlibRx+w6m1ok4GGx5a
	4M/1ovBLqekzolZ/1mePzHnIDdPJh58=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-227-uJFdijhtOqOK9PQq4x_ONw-1; Fri, 22 Mar 2024 01:31:03 -0400
X-MC-Unique: uJFdijhtOqOK9PQq4x_ONw-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-29d7e7c0c7cso1287319a91.3
        for <kvm@vger.kernel.org>; Thu, 21 Mar 2024 22:31:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711085462; x=1711690262;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zeyqe8RQeD7lvkeazy10PIuuNwicb6A5lKZzL5V9940=;
        b=Fcg+A1EFHxq9pAeioobmlXjQzHL5zLzZR3xt616WXA96j5QkE7fMc/HshrWU4rhTo6
         LMVnylWNOuypnx9KKOQq64xMTHHIIgE8qRWBc1sfc/Mu5eqO+GRRfCVaJ3VhCmZwUmIj
         AeFvnrhkmWoxCD43lRNAmS+r2ApzYett1fFMQJyOcC3sX4MfuPHXAsj9RD/gnsvvovK/
         vyLaQ66ZQI/b1XUE1o7q5rBig8SqxnffsYODx+PRkbYYMu6iBbZban/iNR7znOpnWVX6
         E9nBTcCIfKnIqxsT03Tj2X6eoRf5ezKKg96kVK7yJ2adfl4IYgCX/Iz5TpbdeapuD1I3
         Hb2Q==
X-Forwarded-Encrypted: i=1; AJvYcCW/dT6m5Sza4gTny3t78OjFTEatsV0CJ9UcoCur38nW8K5XrJsAxdyPa0RREfcrnLBcGrzaO1QEoyTGqQHv8/un4uDM
X-Gm-Message-State: AOJu0Yy2O2rzl/RpQFo2NDvwuRG8NY7xFGIlutFHcoSNU+rbyxuKltwj
	L+88uk8fRaWk9hdTq3MIDkDNs1Xjn+uYWw/sm63JH1gs1oWSnDwu+VwkQgQFr/h9pFco6Dbbiww
	jOsJbrpdmUNFGaNGc2/1TW6CMS74wxkLadA0gsiu2UDK5mdPNd7+soaPAAgNHhfJ6A0bloZNIN4
	FU2dyheHpXFGUe5tl4cMTX0o7p
X-Received: by 2002:a17:90a:a418:b0:29c:5ba3:890e with SMTP id y24-20020a17090aa41800b0029c5ba3890emr1322052pjp.4.1711085461978;
        Thu, 21 Mar 2024 22:31:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFQB0sfVvGsmkxlkxiev1UO+YVtZ530Wo19MHC05q7NO4RtVeKRKi9QvIqyovGaiEZByXQR8JJUbHlopkLt9Ak=
X-Received: by 2002:a17:90a:a418:b0:29c:5ba3:890e with SMTP id
 y24-20020a17090aa41800b0029c5ba3890emr1322041pjp.4.1711085461672; Thu, 21 Mar
 2024 22:31:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
 <20240319131207.GB1096131@fedora> <CA+9S74jMBbgrxaH2Nit50uDQsHES+e+VHnOXkxnq2TrUFtAQRA@mail.gmail.com>
 <CACGkMEvX2R+wKcH5V45Yd6CkgGhADVbpvfmWsHducN2zCS=OKw@mail.gmail.com> <CA+9S74g5fR=hBxWk1U2TyvW1uPmU3XgJnjw4Owov8LNwLiiOZw@mail.gmail.com>
In-Reply-To: <CA+9S74g5fR=hBxWk1U2TyvW1uPmU3XgJnjw4Owov8LNwLiiOZw@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 22 Mar 2024 13:30:50 +0800
Message-ID: <CACGkMEt4MbyDgdqDGUqQ+0gV-1kmp6CWASDgwMpZnRU8dfPd2Q@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Igor Raits <igor@gooddata.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	Stefano Garzarella <sgarzare@redhat.com>, Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2024 at 5:44=E2=80=AFPM Igor Raits <igor@gooddata.com> wrot=
e:
>
> Hello Jason & others,
>
> On Wed, Mar 20, 2024 at 10:33=E2=80=AFAM Jason Wang <jasowang@redhat.com>=
 wrote:
> >
> > On Tue, Mar 19, 2024 at 9:15=E2=80=AFPM Igor Raits <igor@gooddata.com> =
wrote:
> > >
> > > Hello Stefan,
> > >
> > > On Tue, Mar 19, 2024 at 2:12=E2=80=AFPM Stefan Hajnoczi <stefanha@red=
hat.com> wrote:
> > > >
> > > > On Tue, Mar 19, 2024 at 10:00:08AM +0100, Igor Raits wrote:
> > > > > Hello,
> > > > >
> > > > > We have started to observe kernel crashes on 6.7.y kernels (atm w=
e
> > > > > have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 where w=
e
> > > > > have nodes of cluster it looks stable. Please see stacktrace belo=
w. If
> > > > > you need more information please let me know.
> > > > >
> > > > > We do not have a consistent reproducer but when we put some bigge=
r
> > > > > network load on a VM, the hypervisor's kernel crashes.
> > > > >
> > > > > Help is much appreciated! We are happy to test any patches.
> > > >
> > > > CCing Michael Tsirkin and Jason Wang for vhost_net.
> > > >
> > > > >
> > > > > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
> > > > > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted: G
> > > > >    E      6.7.10-1.gdc.el9.x86_64 #1
> > > >
> > > > Are there any patches in this kernel?
> > >
> > > Only one, unrelated to this part. Removal of pr_err("EEVDF scheduling
> > > fail, picking leftmost\n"); line (reported somewhere few months ago
> > > and it was suggested workaround until proper solution comes).
> >
> > Btw, a bisection would help as well.
>
> In the end it seems like we don't really have "stable" setup, so
> bisection looks to be useless but we did find few things meantime:
>
> 1. On 6.6.9 it crashes either with unexpected GSO type or usercopy:
> Kernel memory exposure attempt detected from SLUB object
> 'skbuff_head_cache'

Do you have a full calltrace for this?

> 2. On 6.7.5, 6.7.10 and 6.8.1 it crashes with RIP:
> 0010:skb_release_data+0xb8/0x1e0

And for this?

> 3. It does NOT crash on 6.8.1 when VM does not have multi-queue setup
>
> Looks like the multi-queue setup (we have 2 interfaces =C3=97 3 virtio
> queues for each) is causing problems as if we set only one queue for
> each interface the issue is gone.
> Maybe there is some race condition in __pfx_vhost_task_fn+0x10/0x10 or
> somewhere around?

I can't tell now, but it seems not because if we have 3 queue pairs we
will have 3 vhost threads.

> We have noticed that there are 3 of such functions
> in the stacktrace that gave us hints about what we could try=E2=80=A6

Let's try to enable SLUB_DEBUG and KASAN to see if we can get
something interesting.

Thanks

>
> >
> > Thanks
> >
>
> Thank you!
>


