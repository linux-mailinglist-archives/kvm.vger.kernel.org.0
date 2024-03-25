Return-Path: <kvm+bounces-12569-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A617588A1AC
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:23:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BD892A2F72
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 13:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759DA15687A;
	Mon, 25 Mar 2024 10:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="EMN1gPyj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE5F0179FAC
	for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 08:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711356279; cv=none; b=RvUPgdWAwZHHloBGEKDzJ+SC9uYzcTCE5WuWOarab7I0TEmgxikW/YniMF4IOVnPT+iBStNVTP9tChJBuckWuK1Y9hkdlW7l0t/5V/kQaNIbzjTM8KSyfZOd9b5buRsDcsS31AuFMsG4xUxgeDcvWBONaqfAqKo618arbNpSDrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711356279; c=relaxed/simple;
	bh=KlNZqGKcY8wJJqzBqoSqe94osLn2EZS8gGGi0MRJ1/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YcpYyanuIjgsFzH8YWyx7Sh1PNFUY8bgmSBnkR1YMMJDgidB+RUcWGW0ja86R4FThhyuVPpfd+//gn5MZcitEGuQ4sAndCn5bzI+v+dTKYcUlgIaH6fnQktlOfMr00OFgD9Ezu23GqY6eA4ZoP18UT8FyQsT/MzqOc70Y9HN/fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=EMN1gPyj; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2d4515ec3aaso31814141fa.1
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 01:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1711356276; x=1711961076; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+AQnc+S8eeewHWVi7q229L+fZxCbZfHJQPdr0bWKRFA=;
        b=EMN1gPyj3HLA0NFJ77dIOn39zfK9STgDgxUjpl06x9zA+PhdZ9zvr5Ys2KJGzUA/+t
         h86/r1E71EvkidFmppQWz+KkRaoR/CJTw40rHCF3m4vMCqExLSw4ULT8CX5SYvZqoprj
         V1YFiEMACEAa+hx9+6PxWcXWQKiO2f5eMFhu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711356276; x=1711961076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+AQnc+S8eeewHWVi7q229L+fZxCbZfHJQPdr0bWKRFA=;
        b=lB5iXjS0mkPYGuDC2gm0sjtmiXuUV9fImBMqIuP67DzToTOLdct8OiEtFqghROQFZO
         ZBiRKiiBH/9T1DDkYXtkUQR3GoNkvHO8RXywnt/VwaO2+wGdLOm/hgeT7DY1bIYxo/FF
         i5BU5AACo+xd0XD1ZYy1S2yJAbeSal90vjRmZuUXPNZmIwFHaEXH2868lR5szQu1747j
         zOmS+ri16Uli8ytzhu5vjWzslZvC0ibw/u73Q5Z3T+pb/i+9KdWMWOn28aL6t5Yr5l6T
         7GfI7G+MrKsSBo9GN9UMXTq8lNYv0gossWCgjd+/35+x9W3bJuX/ms/yKGnWpqAtwofE
         CSYw==
X-Forwarded-Encrypted: i=1; AJvYcCWgl+Vf6AtPM5hrnaeFK1vNzZmwPjdwYe7iRysXkLoDHjKnrkvDp9Xi2UuDxV2HuqxNIobGgTsan8c4WH+xxH/pVG6I
X-Gm-Message-State: AOJu0YwzS7A7BDHZt33zLIeUSkA8hChpbgFujmKdeiQxIJHTDxHkR0KI
	mFXYNQwjv3Bk8bUhCeFen0TYk9wDKMqy9alFdpti/Rd5TSr2KscgwtHTTpmUwEi9JZWs2UPqmzp
	XlSfb3aD8XoPZ6LERQejEhs9NTeVmbj2B2qaB
X-Google-Smtp-Source: AGHT+IHpPljUYvS/v6zIPdlCSCskC5KA1wMk0ygWW04BfrfXUTs4QbWjBPvQqYu8FjNfMaTN+Ytdl3l03Fm/KfIPCY0=
X-Received: by 2002:a2e:b176:0:b0:2d4:9334:3c11 with SMTP id
 a22-20020a2eb176000000b002d493343c11mr1669978ljm.16.1711356275855; Mon, 25
 Mar 2024 01:44:35 -0700 (PDT)
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
 <CACGkMEt4MbyDgdqDGUqQ+0gV-1kmp6CWASDgwMpZnRU8dfPd2Q@mail.gmail.com>
 <CA+9S74hUt_aZCrgN3Yx9Y2OZtwHNan7gmbBa1TzBafW6=YLULQ@mail.gmail.com> <CA+9S74ia-vUag2QMo6zFL7r+wZyOZVmcpe317RdMbK-rpomn+Q@mail.gmail.com>
In-Reply-To: <CA+9S74ia-vUag2QMo6zFL7r+wZyOZVmcpe317RdMbK-rpomn+Q@mail.gmail.com>
From: Igor Raits <igor@gooddata.com>
Date: Mon, 25 Mar 2024 09:44:23 +0100
Message-ID: <CA+9S74hs_1Ft9iyXOPU_vF_EFKuoG8LjDpSna0QSPMFnMywd_g@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Jason Wang <jasowang@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	Stefano Garzarella <sgarzare@redhat.com>, Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Fri, Mar 22, 2024 at 12:19=E2=80=AFPM Igor Raits <igor@gooddata.com> wro=
te:
>
> Hi Jason,
>
> On Fri, Mar 22, 2024 at 9:39=E2=80=AFAM Igor Raits <igor@gooddata.com> wr=
ote:
> >
> > Hi Jason,
> >
> > On Fri, Mar 22, 2024 at 6:31=E2=80=AFAM Jason Wang <jasowang@redhat.com=
> wrote:
> > >
> > > On Thu, Mar 21, 2024 at 5:44=E2=80=AFPM Igor Raits <igor@gooddata.com=
> wrote:
> > > >
> > > > Hello Jason & others,
> > > >
> > > > On Wed, Mar 20, 2024 at 10:33=E2=80=AFAM Jason Wang <jasowang@redha=
t.com> wrote:
> > > > >
> > > > > On Tue, Mar 19, 2024 at 9:15=E2=80=AFPM Igor Raits <igor@gooddata=
.com> wrote:
> > > > > >
> > > > > > Hello Stefan,
> > > > > >
> > > > > > On Tue, Mar 19, 2024 at 2:12=E2=80=AFPM Stefan Hajnoczi <stefan=
ha@redhat.com> wrote:
> > > > > > >
> > > > > > > On Tue, Mar 19, 2024 at 10:00:08AM +0100, Igor Raits wrote:
> > > > > > > > Hello,
> > > > > > > >
> > > > > > > > We have started to observe kernel crashes on 6.7.y kernels =
(atm we
> > > > > > > > have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9 w=
here we
> > > > > > > > have nodes of cluster it looks stable. Please see stacktrac=
e below. If
> > > > > > > > you need more information please let me know.
> > > > > > > >
> > > > > > > > We do not have a consistent reproducer but when we put some=
 bigger
> > > > > > > > network load on a VM, the hypervisor's kernel crashes.
> > > > > > > >
> > > > > > > > Help is much appreciated! We are happy to test any patches.
> > > > > > >
> > > > > > > CCing Michael Tsirkin and Jason Wang for vhost_net.
> > > > > > >
> > > > > > > >
> > > > > > > > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
> > > > > > > > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tainted=
: G
> > > > > > > >    E      6.7.10-1.gdc.el9.x86_64 #1
> > > > > > >
> > > > > > > Are there any patches in this kernel?
> > > > > >
> > > > > > Only one, unrelated to this part. Removal of pr_err("EEVDF sche=
duling
> > > > > > fail, picking leftmost\n"); line (reported somewhere few months=
 ago
> > > > > > and it was suggested workaround until proper solution comes).
> > > > >
> > > > > Btw, a bisection would help as well.
> > > >
> > > > In the end it seems like we don't really have "stable" setup, so
> > > > bisection looks to be useless but we did find few things meantime:
> > > >
> > > > 1. On 6.6.9 it crashes either with unexpected GSO type or usercopy:
> > > > Kernel memory exposure attempt detected from SLUB object
> > > > 'skbuff_head_cache'
> > >
> > > Do you have a full calltrace for this?
> >
> > I have shared it in one of the messages in this thread.
> > https://marc.info/?l=3Dlinux-virtualization&m=3D171085443512001&w=3D2
> >
> > > > 2. On 6.7.5, 6.7.10 and 6.8.1 it crashes with RIP:
> > > > 0010:skb_release_data+0xb8/0x1e0
> > >
> > > And for this?
> >
> > https://marc.info/?l=3Dlinux-netdev&m=3D171083870801761&w=3D2
> >
> > > > 3. It does NOT crash on 6.8.1 when VM does not have multi-queue set=
up
> > > >
> > > > Looks like the multi-queue setup (we have 2 interfaces =C3=97 3 vir=
tio
> > > > queues for each) is causing problems as if we set only one queue fo=
r
> > > > each interface the issue is gone.
> > > > Maybe there is some race condition in __pfx_vhost_task_fn+0x10/0x10=
 or
> > > > somewhere around?
> > >
> > > I can't tell now, but it seems not because if we have 3 queue pairs w=
e
> > > will have 3 vhost threads.
> > >
> > > > We have noticed that there are 3 of such functions
> > > > in the stacktrace that gave us hints about what we could try=E2=80=
=A6
> > >
> > > Let's try to enable SLUB_DEBUG and KASAN to see if we can get
> > > something interesting.
> >
> > We were able to reproduce it even with 1 vhost queue... And now we
> > have slub_debug + kasan so I hopefully have more useful data for you
> > now.
> > I have attached it for better readability.
>
> Looks like we have found a "stable" kernel and that is 6.1.32. The
> 6.3.y is broken and we are testing 6.2.y now.
> My guess it would be related to virtio/vsock: replace virtio_vsock_pkt
> with sk_buff that was done around that time but we are going to test,
> bisect and let you know more.

So we have been trying to bisect it but it is basically impossible for
us to do so as the ICE driver was quite broken for most of the release
cycle so we have no networking on 99% of the builds and we can't test
such a setup.
More specifically, the bug was introduced between 6.2 and 6.3 but we
could not get much further. The last good commit we were able to test
was f18f9845f2f10d3d1fc63e4ad16ee52d2d9292fa and then after 20 commits
where we had no networking we gave up.

If you have some suspicious commit(s) we could revert - happy to test.

Thanks again.

