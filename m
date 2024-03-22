Return-Path: <kvm+bounces-12482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16759886B36
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 12:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C11AC285710
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 11:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB573F9C5;
	Fri, 22 Mar 2024 11:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="S9tZLIyF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 981233F9CB
	for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711106413; cv=none; b=bL2WJayjI8BhnQ6RT5NFpljQbNUYwmoFexByfgSvYDupd6WzxTcg0yvQrIIPLvKOSzwDr5Uw3XiJbX8VdXDLu/yuNlWPbz5UqQfpHwePRr+iUJNIFBBoAn9neskK/0V1L5R0qdl8M14hcH/kXIY3asJ1jEd7798V0oMGP8nNyYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711106413; c=relaxed/simple;
	bh=Dc1VXE9yH2PnZcGdcCavMP4IzoG/6X0QQBcgmuwQZpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SLBuEcJYV4XyAACuO9npBChZW4IHlchfKebbBsSV/VC/zjOhONHK1jDqTCxn+eX7fcO6gFE543rCYJRvy5YJgQGDCaH2xPtbUCH0I8K7CuiVfCrjtigEaQ7kygxMmJRmed6+lUhDLVKNyxFGvKNdiWJwtP27uvImFif4FjtQtfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=S9tZLIyF; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2d52e65d4a8so27642191fa.0
        for <kvm@vger.kernel.org>; Fri, 22 Mar 2024 04:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1711106409; x=1711711209; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b8Z2cPio152grV1Iquho6qxXho3Ihem2O1xD4vwJq7w=;
        b=S9tZLIyFstIgTFDEee22A8izkJsXyBOsfVQmbrbRWiwsp/WoxxomFuUt5gxiYFQHYH
         dhZJnVyT7ZXrp/szD9BcfG6ye/yxnEobkAXyuPodMRon08mhvcOO929gcNvSomgLKdSu
         YKoDmq3+ayU+oB9BsZtkaFrClsi4cyu7GsXf8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711106409; x=1711711209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b8Z2cPio152grV1Iquho6qxXho3Ihem2O1xD4vwJq7w=;
        b=ZztLvWqUUamePtxVAJ2Ep+WztXCJal57oxk5NzjAjqhP7+RTP/sNtNwHLWvyRwimte
         2ziAfncztq/rmh52ed2GXkM8COSkdV6TVg1s68EXoydXHuJnplcp94BkLZMeuZF0gJPt
         8i8iPTY5TP60Of2mTZsppCPqhwk9hk7nVU/KoqF0LIQTeyirySjr3jKM/z86zc/0lYrG
         XwcA5i6+fRIdfmzbXl8EG0FmUTtOemX2msILEgmkPSb5b76q7qPUa46gjwH8eoFJB1aB
         7+CSmuBVu8UqyfMNN150SSQcV1IKaheMLuRy5weBjUhjImOVNqZQDb/bLYxXeLUzvc54
         MicQ==
X-Forwarded-Encrypted: i=1; AJvYcCX0Tbk5+kqn2ncXcCsufcrnJpQMW/IPwpsqL8t1EJj4Yh0O6JZC+4aoIp7p+lUM8depCjVg7St/UNdge4dSyuy8K8vx
X-Gm-Message-State: AOJu0Yw+cY7zVwh1nlZ2dl3IofO36JWa4E5sA9PFai91FvlPAsmKWTVt
	gfh4yrMVWZiOBkDtquS8RIDNoEvOfEJV/TjE23vB613YEntG3yzceaE5Ps5vpIL/U1Lm2bUc3Vv
	fnMQ6X1Hg9LsPrv/pVWRJ3LgWQKToqo7x3KZkJbZtVNm7gJfTHg==
X-Google-Smtp-Source: AGHT+IE5B/6o5n4TIUzWoHJA0LUv6jqqQxDzWAjlw9/W/j757fLkHrcsphOrz4YqKMe0il4fcrriHnRTf6nOt7T/eGA=
X-Received: by 2002:a2e:9b48:0:b0:2d2:b840:1c78 with SMTP id
 o8-20020a2e9b48000000b002d2b8401c78mr1383212ljj.48.1711106408602; Fri, 22 Mar
 2024 04:20:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CA+9S74hbTMxckB=HgRiqL6b8ChZMQfJ6-K9y_GQ0ZDiWkev_vA@mail.gmail.com>
 <20240319131207.GB1096131@fedora> <CA+9S74jMBbgrxaH2Nit50uDQsHES+e+VHnOXkxnq2TrUFtAQRA@mail.gmail.com>
 <CACGkMEvX2R+wKcH5V45Yd6CkgGhADVbpvfmWsHducN2zCS=OKw@mail.gmail.com>
 <CA+9S74g5fR=hBxWk1U2TyvW1uPmU3XgJnjw4Owov8LNwLiiOZw@mail.gmail.com>
 <CACGkMEt4MbyDgdqDGUqQ+0gV-1kmp6CWASDgwMpZnRU8dfPd2Q@mail.gmail.com> <CA+9S74hUt_aZCrgN3Yx9Y2OZtwHNan7gmbBa1TzBafW6=YLULQ@mail.gmail.com>
In-Reply-To: <CA+9S74hUt_aZCrgN3Yx9Y2OZtwHNan7gmbBa1TzBafW6=YLULQ@mail.gmail.com>
From: Igor Raits <igor@gooddata.com>
Date: Fri, 22 Mar 2024 12:19:57 +0100
Message-ID: <CA+9S74ia-vUag2QMo6zFL7r+wZyOZVmcpe317RdMbK-rpomn+Q@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Jason Wang <jasowang@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	Stefano Garzarella <sgarzare@redhat.com>, Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Fri, Mar 22, 2024 at 9:39=E2=80=AFAM Igor Raits <igor@gooddata.com> wrot=
e:
>
> Hi Jason,
>
> On Fri, Mar 22, 2024 at 6:31=E2=80=AFAM Jason Wang <jasowang@redhat.com> =
wrote:
> >
> > On Thu, Mar 21, 2024 at 5:44=E2=80=AFPM Igor Raits <igor@gooddata.com> =
wrote:
> > >
> > > Hello Jason & others,
> > >
> > > On Wed, Mar 20, 2024 at 10:33=E2=80=AFAM Jason Wang <jasowang@redhat.=
com> wrote:
> > > >
> > > > On Tue, Mar 19, 2024 at 9:15=E2=80=AFPM Igor Raits <igor@gooddata.c=
om> wrote:
> > > > >
> > > > > Hello Stefan,
> > > > >
> > > > > On Tue, Mar 19, 2024 at 2:12=E2=80=AFPM Stefan Hajnoczi <stefanha=
@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Mar 19, 2024 at 10:00:08AM +0100, Igor Raits wrote:
> > > > > > > Hello,
> > > > > > >
> > > > > > > We have started to observe kernel crashes on 6.7.y kernels (a=
tm we
> > > > > > > have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 whe=
re we
> > > > > > > have nodes of cluster it looks stable. Please see stacktrace =
below. If
> > > > > > > you need more information please let me know.
> > > > > > >
> > > > > > > We do not have a consistent reproducer but when we put some b=
igger
> > > > > > > network load on a VM, the hypervisor's kernel crashes.
> > > > > > >
> > > > > > > Help is much appreciated! We are happy to test any patches.
> > > > > >
> > > > > > CCing Michael Tsirkin and Jason Wang for vhost_net.
> > > > > >
> > > > > > >
> > > > > > > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
> > > > > > > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted: =
G
> > > > > > >    E      6.7.10-1.gdc.el9.x86_64 #1
> > > > > >
> > > > > > Are there any patches in this kernel?
> > > > >
> > > > > Only one, unrelated to this part. Removal of pr_err("EEVDF schedu=
ling
> > > > > fail, picking leftmost\n"); line (reported somewhere few months a=
go
> > > > > and it was suggested workaround until proper solution comes).
> > > >
> > > > Btw, a bisection would help as well.
> > >
> > > In the end it seems like we don't really have "stable" setup, so
> > > bisection looks to be useless but we did find few things meantime:
> > >
> > > 1. On 6.6.9 it crashes either with unexpected GSO type or usercopy:
> > > Kernel memory exposure attempt detected from SLUB object
> > > 'skbuff_head_cache'
> >
> > Do you have a full calltrace for this?
>
> I have shared it in one of the messages in this thread.
> https://marc.info/?l=3Dlinux-virtualization&m=3D171085443512001&w=3D2
>
> > > 2. On 6.7.5, 6.7.10 and 6.8.1 it crashes with RIP:
> > > 0010:skb_release_data+0xb8/0x1e0
> >
> > And for this?
>
> https://marc.info/?l=3Dlinux-netdev&m=3D171083870801761&w=3D2
>
> > > 3. It does NOT crash on 6.8.1 when VM does not have multi-queue setup
> > >
> > > Looks like the multi-queue setup (we have 2 interfaces =C3=97 3 virti=
o
> > > queues for each) is causing problems as if we set only one queue for
> > > each interface the issue is gone.
> > > Maybe there is some race condition in __pfx_vhost_task_fn+0x10/0x10 o=
r
> > > somewhere around?
> >
> > I can't tell now, but it seems not because if we have 3 queue pairs we
> > will have 3 vhost threads.
> >
> > > We have noticed that there are 3 of such functions
> > > in the stacktrace that gave us hints about what we could try=E2=80=A6
> >
> > Let's try to enable SLUB_DEBUG and KASAN to see if we can get
> > something interesting.
>
> We were able to reproduce it even with 1 vhost queue... And now we
> have slub_debug + kasan so I hopefully have more useful data for you
> now.
> I have attached it for better readability.

Looks like we have found a "stable" kernel and that is 6.1.32. The
6.3.y is broken and we are testing 6.2.y now.
My guess it would be related to virtio/vsock: replace virtio_vsock_pkt
with sk_buff that was done around that time but we are going to test,
bisect and let you know more.

