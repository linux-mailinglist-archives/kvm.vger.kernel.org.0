Return-Path: <kvm+bounces-12763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9CCD88D6FE
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 08:08:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D5A529F421
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 07:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C062E24B4A;
	Wed, 27 Mar 2024 07:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="FlOW8zQ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2A63C3C
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 07:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711523322; cv=none; b=LFYmfp/Jiqxd2WErxPSM8+vbDrZs8/NcO0R4+2W9Y1RWWHEpVBVwsA85RzYZJt+eyvETHYMM/xgt4Q7RC9eSTFmORkMETi/ePKlzbEoUtfsxeeXddz6kMqtc7tfkj3u5lMYpq/mOxBf3hae57XlHQwWoVgP4cM7SLzGOjZMquPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711523322; c=relaxed/simple;
	bh=Wn6VthASsi6YX/AEJNdGx2M0GdMmMPsIEOMzyWB31aM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bm027wHys9id4BhfhTxO4tvqwKFz4avyNA53fz/E47zSRyY+e8lumeVLG8JAvPcU1rZ/WBaPp0Wg2hKPM6/B0PH5L30ydn6tYAh6cmTQblWG9ylEhzV3MJtUMFbdrZzbzkaUtliIDH4fiqqQad4i+Ggd8J4EbqJnUzZXzq9fL8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=FlOW8zQ4; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a466a27d30aso780893066b.1
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 00:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1711523319; x=1712128119; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Kr/grj2aFrmgjnvCKB3dfDy3hkM98fR1JQDyzWYA7Gg=;
        b=FlOW8zQ469nHjjBU372z7kRgBiHiUqtvVRaVvkcKV1jalXc2atAN8biVwws0Jx7EEq
         MTqYT666Do//GWNsayDz8ffRA0DDdx3aUqqn2CUUAm3P4VHk/j6n8d79raIJMEalsB09
         N2HNB0bCEg76rKVs1y8JA/LpP/gz6O78vDhWE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711523319; x=1712128119;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kr/grj2aFrmgjnvCKB3dfDy3hkM98fR1JQDyzWYA7Gg=;
        b=ALqjKmuiZzEXCUI9BqPu5htWcf1z9bp23fJQsuLTm4Q3GXquyNlJOlBTCp21b75iXz
         KNX0/OOTWyrvnMOeSIVWGYLDftfhcT+KIzxhu/T08k4lBzCst+5paN+aLGbQ0ZCLIgxk
         EkeN/oyuSh6uMBt4XJ8OgYPBHICG4s7l1OXv/2HLuJ+0pcnqEbQyv942EGl5pHu/UlUF
         RW8qgOYZr99mF0Hr1YtSnsp+cx215q2qHsffkHIYhVpoxd+x+jXgrFOtYRkZYO6/8HOG
         LJET4d7EAnBeaEEm62E7ClHpaQHnyRqdeZWnWF4IwEcln9YRBk1xpB11pfB+g9NvQgD3
         OoMA==
X-Forwarded-Encrypted: i=1; AJvYcCVQ0jh1tgb8WtOPWTUyKTMmUJxA9/jNZj6IYN1gN3hFjryPmJsxlEyn/zS2ubUO6XuQI+2R07KO4kBbQigrn3NdZh9N
X-Gm-Message-State: AOJu0YwabzxI+V8YnQNJsEJio5TLjxoGRMx+Ich/PX4r4awuQliPr1yJ
	+bWygmJ03P4Hglwclm80nA0WB/mjEwjMrlzfbtL3e3Mab+w0BybNZ9lEM4obx87Ti+TjB9sJ2Ky
	cJOi15EAeTvKT50b/4HTfpjLP0T5s2jslwaC9
X-Google-Smtp-Source: AGHT+IFlC8P+41yCGLG8EGaL8j0ldtNYHzHvCkZ5LUXKS+6DgtAklHx1C+X7kO7W3c4xiXZBXwWJvJL3ZAdaUpUQxko=
X-Received: by 2002:a17:906:d93a:b0:a47:398f:1a06 with SMTP id
 rn26-20020a170906d93a00b00a47398f1a06mr222488ejb.1.1711523318793; Wed, 27 Mar
 2024 00:08:38 -0700 (PDT)
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
 <CA+9S74hUt_aZCrgN3Yx9Y2OZtwHNan7gmbBa1TzBafW6=YLULQ@mail.gmail.com>
 <CA+9S74ia-vUag2QMo6zFL7r+wZyOZVmcpe317RdMbK-rpomn+Q@mail.gmail.com>
 <CA+9S74hs_1Ft9iyXOPU_vF_EFKuoG8LjDpSna0QSPMFnMywd_g@mail.gmail.com>
 <CACGkMEvHiAN7X_QBgihWX6zzEUOxhrV2Nqg1arw1sfYy2A5K0g@mail.gmail.com>
 <CAK8fFZ5j_T1NzoOEfqE1HYhAEhD04smR4OT2bnMEAr+2+6C5RQ@mail.gmail.com> <CACGkMEtUyR3HbBHpQmP5Pm8OePB5pzXtJVJPL-wyH57Ddh1PSA@mail.gmail.com>
In-Reply-To: <CACGkMEtUyR3HbBHpQmP5Pm8OePB5pzXtJVJPL-wyH57Ddh1PSA@mail.gmail.com>
From: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Date: Wed, 27 Mar 2024 08:08:12 +0100
Message-ID: <CAK8fFZ7ocTK2wknT41XdGr2NDXG9C_84fwiRzUUVAySaY-=dpg@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Jason Wang <jasowang@redhat.com>
Cc: Igor Raits <igor@gooddata.com>, Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: multipart/mixed; boundary="0000000000007147b206149f13ba"

--0000000000007147b206149f13ba
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

st 27. 3. 2024 v 4:11 odes=C3=ADlatel Jason Wang <jasowang@redhat.com> naps=
al:
>
> On Tue, Mar 26, 2024 at 9:26=E2=80=AFPM Jaroslav Pulchart
> <jaroslav.pulchart@gooddata.com> wrote:
> >
> > >
> > > On Mon, Mar 25, 2024 at 4:44=E2=80=AFPM Igor Raits <igor@gooddata.com=
> wrote:
> > > >
> > > > Hello,
> > > >
> > > > On Fri, Mar 22, 2024 at 12:19=E2=80=AFPM Igor Raits <igor@gooddata.=
com> wrote:
> > > > >
> > > > > Hi Jason,
> > > > >
> > > > > On Fri, Mar 22, 2024 at 9:39=E2=80=AFAM Igor Raits <igor@gooddata=
.com> wrote:
> > > > > >
> > > > > > Hi Jason,
> > > > > >
> > > > > > On Fri, Mar 22, 2024 at 6:31=E2=80=AFAM Jason Wang <jasowang@re=
dhat.com> wrote:
> > > > > > >
> > > > > > > On Thu, Mar 21, 2024 at 5:44=E2=80=AFPM Igor Raits <igor@good=
data.com> wrote:
> > > > > > > >
> > > > > > > > Hello Jason & others,
> > > > > > > >
> > > > > > > > On Wed, Mar 20, 2024 at 10:33=E2=80=AFAM Jason Wang <jasowa=
ng@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Mar 19, 2024 at 9:15=E2=80=AFPM Igor Raits <igor@=
gooddata.com> wrote:
> > > > > > > > > >
> > > > > > > > > > Hello Stefan,
> > > > > > > > > >
> > > > > > > > > > On Tue, Mar 19, 2024 at 2:12=E2=80=AFPM Stefan Hajnoczi=
 <stefanha@redhat.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Tue, Mar 19, 2024 at 10:00:08AM +0100, Igor Raits =
wrote:
> > > > > > > > > > > > Hello,
> > > > > > > > > > > >
> > > > > > > > > > > > We have started to observe kernel crashes on 6.7.y =
kernels (atm we
> > > > > > > > > > > > have hit the issue 5 times on 6.7.5 and 6.7.10). On=
 6.6.9 where we
> > > > > > > > > > > > have nodes of cluster it looks stable. Please see s=
tacktrace below. If
> > > > > > > > > > > > you need more information please let me know.
> > > > > > > > > > > >
> > > > > > > > > > > > We do not have a consistent reproducer but when we =
put some bigger
> > > > > > > > > > > > network load on a VM, the hypervisor's kernel crash=
es.
> > > > > > > > > > > >
> > > > > > > > > > > > Help is much appreciated! We are happy to test any =
patches.
> > > > > > > > > > >
> > > > > > > > > > > CCing Michael Tsirkin and Jason Wang for vhost_net.
> > > > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP=
 NOPTI
> > > > > > > > > > > > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890=
 Tainted: G
> > > > > > > > > > > >    E      6.7.10-1.gdc.el9.x86_64 #1
> > > > > > > > > > >
> > > > > > > > > > > Are there any patches in this kernel?
> > > > > > > > > >
> > > > > > > > > > Only one, unrelated to this part. Removal of pr_err("EE=
VDF scheduling
> > > > > > > > > > fail, picking leftmost\n"); line (reported somewhere fe=
w months ago
> > > > > > > > > > and it was suggested workaround until proper solution c=
omes).
> > > > > > > > >
> > > > > > > > > Btw, a bisection would help as well.
> > > > > > > >
> > > > > > > > In the end it seems like we don't really have "stable" setu=
p, so
> > > > > > > > bisection looks to be useless but we did find few things me=
antime:
> > > > > > > >
> > > > > > > > 1. On 6.6.9 it crashes either with unexpected GSO type or u=
sercopy:
> > > > > > > > Kernel memory exposure attempt detected from SLUB object
> > > > > > > > 'skbuff_head_cache'
> > > > > > >
> > > > > > > Do you have a full calltrace for this?
> > > > > >
> > > > > > I have shared it in one of the messages in this thread.
> > > > > > https://marc.info/?l=3Dlinux-virtualization&m=3D171085443512001=
&w=3D2
> > > > > >
> > > > > > > > 2. On 6.7.5, 6.7.10 and 6.8.1 it crashes with RIP:
> > > > > > > > 0010:skb_release_data+0xb8/0x1e0
> > > > > > >
> > > > > > > And for this?
> > > > > >
> > > > > > https://marc.info/?l=3Dlinux-netdev&m=3D171083870801761&w=3D2
> > > > > >
> > > > > > > > 3. It does NOT crash on 6.8.1 when VM does not have multi-q=
ueue setup
> > > > > > > >
> > > > > > > > Looks like the multi-queue setup (we have 2 interfaces =C3=
=97 3 virtio
> > > > > > > > queues for each) is causing problems as if we set only one =
queue for
> > > > > > > > each interface the issue is gone.
> > > > > > > > Maybe there is some race condition in __pfx_vhost_task_fn+0=
x10/0x10 or
> > > > > > > > somewhere around?
> > > > > > >
> > > > > > > I can't tell now, but it seems not because if we have 3 queue=
 pairs we
> > > > > > > will have 3 vhost threads.
> > > > > > >
> > > > > > > > We have noticed that there are 3 of such functions
> > > > > > > > in the stacktrace that gave us hints about what we could tr=
y=E2=80=A6
> > > > > > >
> > > > > > > Let's try to enable SLUB_DEBUG and KASAN to see if we can get
> > > > > > > something interesting.
> > > > > >
> > > > > > We were able to reproduce it even with 1 vhost queue... And now=
 we
> > > > > > have slub_debug + kasan so I hopefully have more useful data fo=
r you
> > > > > > now.
> > > > > > I have attached it for better readability.
> > > > >
> > > > > Looks like we have found a "stable" kernel and that is 6.1.32. Th=
e
> > > > > 6.3.y is broken and we are testing 6.2.y now.
> > > > > My guess it would be related to virtio/vsock: replace virtio_vsoc=
k_pkt
> > > > > with sk_buff that was done around that time but we are going to t=
est,
> > > > > bisect and let you know more.
> > > >
> > > > So we have been trying to bisect it but it is basically impossible =
for
> > > > us to do so as the ICE driver was quite broken for most of the rele=
ase
> > > > cycle so we have no networking on 99% of the builds and we can't te=
st
> > > > such a setup.
> > > > More specifically, the bug was introduced between 6.2 and 6.3 but w=
e
> > > > could not get much further. The last good commit we were able to te=
st
> > > > was f18f9845f2f10d3d1fc63e4ad16ee52d2d9292fa and then after 20 comm=
its
> > > > where we had no networking we gave up.
> > > >
> > > > If you have some suspicious commit(s) we could revert - happy to te=
st.
> > >
> > > Here is the is for the change since f18f9845f2f10d3d1fc63e4ad16ee52d2=
d9292fa:
> > >
> > > cbfbfe3aee71 tun: prevent negative ifindex
> > > b2f8323364ab tun: add __exit annotations to module exit func tun_clea=
nup()
> > > 6231e47b6fad tun: avoid high-order page allocation for packet header
> > > 4d016ae42efb Merge git://git.kernel.org/pub/scm/linux/kernel/git/netd=
ev/net
> > > 59eeb2329405 drivers: net: prevent tun_build_skb() to exceed the
> > > packet size limit
> > > 35b1b1fd9638 Merge git://git.kernel.org/pub/scm/linux/kernel/git/netd=
ev/net
> > > ce7c7fef1473 net: tun: change tun_alloc_skb() to allow bigger paged a=
llocations
> > > 9bc3047374d5 net: tun_chr_open(): set sk_uid from current_fsuid()
> > > 82b2bc279467 tun: Fix memory leak for detached NAPI queue.
> > > 6e98b09da931 Merge tag 'net-next-6.4' of
> > > git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> > > de4f5fed3f23 iov_iter: add iter_iovec() helper
> > > 438b406055cd tun: flag the device as supporting FMODE_NOWAIT
> > > de4287336794 Daniel Borkmann says:
> > > a096ccca6e50 tun: tun_chr_open(): correctly initialize socket uid
> > > 66c0e13ad236 drivers: net: turn on XDP features
> > >
> > > The commit that touches the datapath are:
> > >
> > > 6231e47b6fad tun: avoid high-order page allocation for packet header
> > > 59eeb2329405 drivers: net: prevent tun_build_skb() to exceed the
> > > packet size limit
> > > ce7c7fef1473 net: tun: change tun_alloc_skb() to allow bigger paged a=
llocations
> > > 82b2bc279467 tun: Fix memory leak for detached NAPI queue.
> > > de4f5fed3f23 iov_iter: add iter_iovec() helper
> > >
> > > I assume you didn't use NAPI mode, so 82b2bc279467 tun: Fix memory
> > > leak for detached NAPI queue doesn't make sense for us.
> > >
> > > The rest might be the bad commit if it is caused by a change of tun i=
tself.
> > >
> > > btw I vaguely remember KASAN will report who did the allocation and
> > > who did the free. But it seems not in your KASAN log.
> > >
> > > Thanks
> > >
> > > >
> > > > Thanks again.
> > > >
> > >
> >
> > Hello
> >
> > We have one observation. The occurrence of the error depends on the
> > ring buffer size of physical network cards. We have two E810 Intel
> > cards bonded by two interfaces (em1 + p3p2, ice driver) into single
> > bon0. The bond0 is then linux bridged and/or ovs(witched) to VMs via
> > tun interfaces (both switch solutions have the same problem). VMs are
> > qemu-kvm instances and using vhost/virtio-net.
> >
> > We see:
> > 1/ The issue is triggered almost instantaneously when tx/rx ring
> > buffer is set to 2048 (our default)
> > ethtool -G em1 rx 2048 tx 2048
> > ethtool -G p3p1 rx 2048 tx 2048
> >
> > 2/ Similar issue is triggered when the tx/rx ring buffer is set to
> > 4096: the host does not crash immediately, but some trace is shown
> > soon and later it gets into memory pressure and crashes.
>
> This is probably a hint of memory leak somewhere.
>
> > ethtool -G em1 rx 4096 tx 4096
> > ethtool -G p3p1 rx 4096 tx 4096
> > See attached ring_4096.kasan.txt (vanila 6.8.1 with enabled KASAN) and
> > ring_4096.txt (vanila 6.8.1 without kasan)
> >
> > 3/ The system is stable or we just can-not trigger the issue if the
> > ring buffer is >=3D 6144.
> > ethtool -G em1 rx 7120 tx 7120
> > ethtool -G p3p1 rx 7120 tx 7120
> >
> > could it be influenced by a some rate of dropped packets in the ring bu=
ffer?
>
> I can't tell.
>
> Btw, it looks like the logs were cut off. Could we get a full log?

I took it from the server console and was truncated by my copy-paste
issue. Re-attaching the de-truncated log as "ring_4096.log" file.

>
> Thanks
>
> >
> > # for i in em1 p3p1; do ethtool -S ${i} | grep dropped.nic; done
> >      rx_dropped.nic: 158225
> >      rx_dropped.nic: 74285
> >
> > Best,
> > Jaroslav Pulchart
>

--0000000000007147b206149f13ba
Content-Type: text/x-log; charset="US-ASCII"; name="ring_4096.log"
Content-Disposition: attachment; filename="ring_4096.log"
Content-Transfer-Encoding: base64
Content-ID: <f_lu9goby10>
X-Attachment-Id: f_lu9goby10

TWFyIDI1IDExOjIzOjM5IGNtcDAyMjAga2VybmVsOiAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0t
LS0tLS0tLS0tLS0KTWFyIDI1IDExOjIzOjM5IGNtcDAyMjAga2VybmVsOiB2aXJ0X3RvX2NhY2hl
OiBPYmplY3QgaXMgbm90IGEgU2xhYiBwYWdlIQpNYXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJu
ZWw6IFdBUk5JTkc6IENQVTogMzIgUElEOiAxMTA0NCBhdCBtbS9zbHViLmM6NDMyOCBrbWVtX2Nh
Y2hlX2ZyZWUrMHgzMDEvMHgzZDAKTWFyIDI1IDExOjIzOjM5IGNtcDAyMjAga2VybmVsOiBNb2R1
bGVzIGxpbmtlZCBpbjogbXB0Y3BfZGlhZyhFKSB4c2tfZGlhZyhFKSByYXdfZGlhZyhFKSB1bml4
X2RpYWcoRSkgYWZfcGFja2V0X2RpYWcoRSkgbmV0bGlua19kaWFnKEUpIHVkcF9kaWFnKEUpIHRj
cF9kaWFnKEUpIGluZQp0X2RpYWcoRSkgZWJ0X2FycChFKSBuZnRfbWV0YV9icmlkZ2UoRSkgeHRf
Q1QoRSkgeHRfbWFjKEUpIHh0X3NldChFKSB4dF9jb25udHJhY2soRSkgeHRfY29tbWVudChFKSB4
dF9waHlzZGV2KEUpIG5mdF9jb21wYXQoRSkgaXBfc2V0X2hhc2hfbmV0KEUpIGlwX3NldChFKSB2
aG9zdF9uCmV0KEUpIHZob3N0KEUpIHZob3N0X2lvdGxiKEUpIHRhcChFKSB0dW4oRSkgcnBjc2Vj
X2dzc19rcmI1KEUpIGF1dGhfcnBjZ3NzKEUpIG5mc3Y0KEUpIGRuc19yZXNvbHZlcihFKSBuZnMo
RSkgbG9ja2QoRSkgZ3JhY2UoRSkgbmV0ZnMoRSkgbmV0Y29uc29sZShFKSBpYl9jb3JlKEUpIHMK
Y3NpX3RyYW5zcG9ydF9pc2NzaShFKSBuZl90YWJsZXMoRSkgbmZuZXRsaW5rKEUpIHRhcmdldF9j
b3JlX21vZChFKSBtYWN2bGFuKEUpIDgwMjFxKEUpIGdhcnAoRSkgbXJwKEUpIGJvbmRpbmcoRSkg
dGxzKEUpIGJpbmZtdF9taXNjKEUpIGRlbGxfcmJ1KEUpIHN1bnJwYyhFKSBidHJmcwooRSkgeG9y
KEUpIHpzdGRfY29tcHJlc3MoRSkgdmZhdChFKSBmYXQoRSkgZG1fc2VydmljZV90aW1lKEUpIHJh
aWQ2X3BxKEUpIGRtX211bHRpcGF0aChFKSBpcG1pX3NzaWYoRSkgaW50ZWxfcmFwbF9tc3IoRSkg
aW50ZWxfcmFwbF9jb21tb24oRSkgYW1kNjRfZWRhYyhFKSBlZGFjX21jCmVfYW1kKEUpIGt2bV9h
bWQoRSkga3ZtKEUpIGRlbGxfc21iaW9zKEUpIGFjcGlfaXBtaShFKSBpcnFieXBhc3MoRSkgZGNk
YmFzKEUpIHdtaQpfYm1vZihFKSBkZWxsX3dtaV9kZXNjcmlwdG9yKEUpIGlwbWlfc2koRSkgbWdh
ZzIwMChFKSByYXBsKEUpIGkyY19hbGdvX2JpdChFKSBhY3BpX2NwdWZyZXEoRSkgaXBtaV9kZXZp
bnRmKEUpIHB0ZG1hKEUpIGkyY19waWl4NChFKSB3bWkoRSkgazEwdGVtcChFKQpNYXIgMjUgMTE6
MjM6MzkgY21wMDIyMCBrZXJuZWw6IGlwbWlfbXNnaGFuZGxlcihFKSBhY3BpX3Bvd2VyX21ldGVy
KEUpIGZ1c2UoRSkgenJhbShFKSBleHQ0KEUpIG1iY2FjaGUoRSkgamJkMihFKSBkbV9jcnlwdChF
KSBzZF9tb2QoRSkgdDEwX3BpKEUpIHNnKEUpIGNyY3QxMGRpZl9wY2xtdWwoRSkgYWhjaShFKSBj
cmMzMl9wY2xtdWwoRSkgcG9seXZhbF9jbG11bG5pKEUpIGljZShFKSBsaWJhaGNpKEUpIHBvbHl2
YWxfZ2VuZXJpYyhFKSBnaGFzaF9jbG11bG5pX2ludGVsKEUpIHNoYTUxMl9zc3NlMyhFKSBsaWJh
dGEoRSkgbWVnYXJhaWRfc2FzKEUpIGduc3MoRSkgY2NwKEUpIHNwNTEwMF90Y28oRSkgZG1fbWly
cm9yKEUpIGRtX3JlZ2lvbl9oYXNoKEUpIGRtX2xvZyhFKSBkbV9tb2QoRSkgbmZfY29ubnRyYWNr
KEUpIGxpYmNyYzMyYyhFKSBjcmMzMmNfaW50ZWwoRSkgbmZfZGVmcmFnX2lwdjYoRSkgbmZfZGVm
cmFnX2lwdjQoRSkgYnJfbmV0ZmlsdGVyKEUpIGJyaWRnZShFKSBzdHAoRSkgbGxjKEUpCk1hciAy
NSAxMToyMzozOSBjbXAwMjIwIGtlcm5lbDogVW5sb2FkZWQgdGFpbnRlZCBtb2R1bGVzOiBmamVz
KEUpOjIgcGFkbG9ja19hZXMoRSk6MwpNYXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6IENQ
VTogMzIgUElEOiAxMTA0NCBDb21tOiB2aG9zdC0xMDk5OCBUYWludGVkOiBHICAgICAgICAgICAg
RSAgICAgIDYuOC4xLTEuZ2RjLmVsOS54ODZfNjQgIzEKTWFyIDI1IDExOjIzOjM5IGNtcDAyMjAg
a2VybmVsOiBIYXJkd2FyZSBuYW1lOiBEZWxsIEluYy4gUG93ZXJFZGdlIFI3NTI1LzBIM0s3UCwg
QklPUyAyLjE0LjEgMTIvMTcvMjAyMwpNYXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6IFJJ
UDogMDAxMDprbWVtX2NhY2hlX2ZyZWUrMHgzMDEvMHgzZDAKTWFyIDI1IDExOjIzOjM5IGNtcDAy
MjAga2VybmVsOiBDb2RlOiBmZCBmZiBmZiA4MCAzZCAzYSA5ZiBmNSAwMSAwMCAwZiA4NSBiZiBm
ZSBmZiBmZiA0OCBjNyBjNiA1MCA0ZCBhNyA4ZSA0OCBjNyBjNyA0MCA2OSBmZCA4ZSBjNiAwNSAx
ZiA5ZiBmNSAwMSAwMSBlOCAxZiA0NCBkMyBmZiA8MGY+IDBiIGU5IDllIGZlIGZmIGZmIDQ4IDhk
IDQyIGZmIGU5IDYzIGZkIGZmIGZmIDRjIDhkIDY4IGZmIGU5IGUzCk1hciAyNSAxMToyMzozOSBj
bXAwMjIwIGtlcm5lbDogUlNQOiAwMDE4OmZmZmZhYjEyZGU1NWJjODAgRUZMQUdTOiAwMDAxMDI4
MgpNYXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6IFJBWDogMDAwMDAwMDAwMDAwMDAwMCBS
Qlg6IGZmZmY5MWQyYjRkZDk4MDAgUkNYOiAwMDAwMDAwMDAwMDAwMDAwCk1hciAyNSAxMToyMzoz
OSBjbXAwMjIwIGtlcm5lbDogUkRYOiBmZmZmOTFiMjdmY2FkODAwIFJTSTogZmZmZjkxYjI3ZmNh
MGE0MCBSREk6IGZmZmY5MWIyN2ZjYTBhNDAKTWFyIDI1IDExOjIzOjM5IGNtcDAyMjAga2VybmVs
OiBSQlA6IGZmZmZhYjEyZGU1NWJjYzggUjA4OiAwMDAwMDAwMDAwMDAwMDAwIFIwOTogMDAwMDAw
MDBmZmZmN2ZmZgpNYXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6IFIxMDogZmZmZmFiMTJk
ZTU1YmIyMCBSMTE6IGZmZmZmZmZmOGZiZTI5NjggUjEyOiBmZmZmOTFkMzM0ZGQ5ODAwCk1hciAy
NSAxMToyMzozOSBjbXAwMjIwIGtlcm5lbDogUjEzOiAwMDAwMDAwMDAwMDAwMDAwIFIxNDogMDAw
MDAwMDAwMDAwMDAwMSBSMTU6IDAwMDAwMDAwMDAwMDY0ZTQKTWFyIDI1IDExOjIzOjM5IGNtcDAy
MjAga2VybmVsOiBGUzogIDAwMDA3ZjgxN2ZlMzJmODAoMDAwMCkgR1M6ZmZmZjkxYjI3ZmM4MDAw
MCgwMDAwKSBrbmxHUzowMDAwMDAwMDAwMDAwMDAwCk1hciAyNSAxMToyMzozOSBjbXAwMjIwIGtl
cm5lbDogQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAwMDA4MDA1MDAzMwpN
YXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6IENSMjogMDAwMDAwYzFhZDU5YjAwMCBDUjM6
IDAwMDAwMTQwMzVlMjAwMDEgQ1I0OiAwMDAwMDAwMDAwNzcwZWYwCk1hciAyNSAxMToyMzozOSBj
bXAwMjIwIGtlcm5lbDogUEtSVTogNTU1NTU1NTQKTWFyIDI1IDExOjIzOjM5IGNtcDAyMjAga2Vy
bmVsOiBDYWxsIFRyYWNlOgpNYXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6IDxUQVNLPgpN
YXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6ID8gX193YXJuKzB4ODAvMHgxMzAKTWFyIDI1
IDExOjIzOjM5IGNtcDAyMjAga2VybmVsOiA/IGttZW1fY2FjaGVfZnJlZSsweDMwMS8weDNkMApN
YXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6ID8gcmVwb3J0X2J1ZysweDE5NS8weDFhMApN
YXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6ID8gcHJiX3JlYWRfdmFsaWQrMHgxNy8weDIw
Ck1hciAyNSAxMToyMzozOSBjbXAwMjIwIGtlcm5lbDogPyBoYW5kbGVfYnVnKzB4M2MvMHg3MApN
YXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6ID8gZXhjX2ludmFsaWRfb3ArMHgxNC8weDcw
Ck1hciAyNSAxMToyMzozOSBjbXAwMjIwIGtlcm5lbDogPyBhc21fZXhjX2ludmFsaWRfb3ArMHgx
Ni8weDIwCk1hciAyNSAxMToyMzozOSBjbXAwMjIwIGtlcm5lbDogPyBrbWVtX2NhY2hlX2ZyZWUr
MHgzMDEvMHgzZDAKTWFyIDI1IDExOjIzOjM5IGNtcDAyMjAga2VybmVsOiA/IHNrYl9yZWxlYXNl
X2RhdGErMHgxMDcvMHgxZTAKTWFyIDI1IDExOjIzOjM5IGNtcDAyMjAga2VybmVsOiB0dW5fZG9f
cmVhZCsweDY4LzB4MWYwIFt0dW5dCk1hciAyNSAxMToyMzozOSBjbXAwMjIwIGtlcm5lbDogdHVu
X3JlY3Ztc2crMHg3ZS8weDE2MCBbdHVuXQpNYXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6
IGhhbmRsZV9yeCsweDNhYi8weDc1MCBbdmhvc3RfbmV0XQpNYXIgMjUgMTE6MjM6MzkgY21wMDIy
MCBrZXJuZWw6ID8gaW5pdF9udW1hX2JhbGFuY2luZysweGQ3LzB4MWUwCk1hciAyNSAxMToyMzoz
OSBjbXAwMjIwIGtlcm5lbDogdmhvc3Rfd29ya2VyKzB4NDIvMHg3MCBbdmhvc3RdCk1hciAyNSAx
MToyMzozOSBjbXAwMjIwIGtlcm5lbDogdmhvc3RfdGFza19mbisweDRiLzB4YjAKTWFyIDI1IDEx
OjIzOjM5IGNtcDAyMjAga2VybmVsOiA/IGZpbmlzaF90YXNrX3N3aXRjaC5pc3JhLjArMHg4Zi8w
eDJhMApNYXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6ID8gX19wZnhfdmhvc3RfdGFza19m
bisweDEwLzB4MTAKTWFyIDI1IDExOjIzOjM5IGNtcDAyMjAga2VybmVsOiA/IF9fcGZ4X3Zob3N0
X3Rhc2tfZm4rMHgxMC8weDEwCk1hciAyNSAxMToyMzozOSBjbXAwMjIwIGtlcm5lbDogcmV0X2Zy
b21fZm9yaysweDJkLzB4NTAKTWFyIDI1IDExOjIzOjM5IGNtcDAyMjAga2VybmVsOiA/IF9fcGZ4
X3Zob3N0X3Rhc2tfZm4rMHgxMC8weDEwCk1hciAyNSAxMToyMzozOSBjbXAwMjIwIGtlcm5lbDog
cmV0X2Zyb21fZm9ya19hc20rMHgxYi8weDMwCk1hciAyNSAxMToyMzozOSBjbXAwMjIwIGtlcm5l
bDogPC9UQVNLPgpNYXIgMjUgMTE6MjM6MzkgY21wMDIyMCBrZXJuZWw6IC0tLVsgZW5kIHRyYWNl
IDAwMDAwMDAwMDAwMDAwMDAgXS0tLQoK
--0000000000007147b206149f13ba--

