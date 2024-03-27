Return-Path: <kvm+bounces-12747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9BFE288D4ED
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 04:11:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B00601C238E8
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 03:11:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42E96224F6;
	Wed, 27 Mar 2024 03:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dLl5ebMn"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5678C224CE
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 03:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711509099; cv=none; b=KdJoo6APRfBXxgsXwIRDziQl12+mHyJdNDa9Tbkm8mgd1wy8wqY4IrF4UfIDcEc+qJux1PgRYQ36q4tQeOm13Z5kXnQ85H7vm5tBu0OpQtsz5PnlT3cwZknAY/w1a+DAktKMssXMfh8QTYQHIxrohOBUpk6b5eDNsZfC5vMs34U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711509099; c=relaxed/simple;
	bh=6orz1aw7V5wdQBIbCls73qlkLc/Y53C5olsOslMpVYI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DW7JNDGZB4qEYgLHpONj7ZJ619hGy9zFREoYYQgd/WJKXaEaBoyLIDLWDBMNg3jmEZyIEZQjCZvsQ2Fm7Tjea0QC582WiOwKLEpKsObx6tKOIFwkll2kOEtyDZfB8ZW7T9fJXih3JZjlagvxHP/lz1oOK1ECX/cbG6riPCJ5Ijg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dLl5ebMn; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711509096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=urcyWyF08xmQUzgTmG3QLbx+SDWeNDyaOtq12rZn01E=;
	b=dLl5ebMnvFfXip5I8Ue0LO3LVj9uD6QjKAWdgk824gDgRibuQJINRywhzUPJLgVhCpxfDY
	U6BYWVDgCTEOPlmhYmxlWxbhQDXvvr0C4NYau+O55Rqnh1c1QYpv4wr2YR4cgubKFmEeSS
	c5n+MPXeYAgrOMtTKANlseDtTAFC/l4=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-0WTb2YcbPfugivLsPGXE-A-1; Tue, 26 Mar 2024 23:11:31 -0400
X-MC-Unique: 0WTb2YcbPfugivLsPGXE-A-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5a1d14ca2abso5666906eaf.0
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 20:11:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711509090; x=1712113890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=urcyWyF08xmQUzgTmG3QLbx+SDWeNDyaOtq12rZn01E=;
        b=bkk1vCQQywVlBYaFyxukBTrjL4vlRlvZm+q63PbH5JoyTxO3xavvJCa7Zb51LsLMN5
         +MDWMImqMmgs0nE+BlDKaW+dlr4IvUNQjBJ0/tC+zob3G6e3/a/NRqgaEkqNrL9cO8Rd
         dNdPzy86YuHx0YSsoyHdPZsiJ/xg5Ii4SMlyWfQdbfH14F1ZhBsNaWJqae5JfqzCJ0mc
         P9Tyj+xzaKX8Hd+Ark7srPSLlGqs6HAUzZlY19adcNpKjC9qqH8NZKhrJcekacD3eAFM
         koiTVmJxNP7tRAidmNT0X+YvNg7Ul2DR4gbux4Ficn+hGuNkKq3zu4gqkDg9CLdHfK7s
         BARQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcBXIuZY5BZg0/KXozF9qaAALl8MBsC7NQmu1UUz8CgdY1PVEbrQIjhscE6yyD43hRoBlysAQ9+TiOwvmiOB05wim8
X-Gm-Message-State: AOJu0YyeRiEbtOW0rWWfhfLEHIsFLFU1U1tQSEB4I7dMUXU1VP9qVQ5W
	fZUeDmdylfCgQsEVvlJiImddTtK5otg3ASjyf9tB/5a2k10dyvCoQeScRgd6VflRyl1rZ0HDNKP
	OckqC0n8OckaAxIqiTWppuViEmSBjXojbX59PDIUDv9K+CGe6GEBPtfKM86v+xUQL603wrK7gL7
	7U9+W3Xry3ykumGyQhW/uYqelB
X-Received: by 2002:a05:6358:7584:b0:17b:b559:2ba3 with SMTP id x4-20020a056358758400b0017bb5592ba3mr82723rwf.11.1711509089803;
        Tue, 26 Mar 2024 20:11:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFO38JUEDTdr4HhhvKNkEw2Kv+aGV0Qo9yOQttg7EbNDyITSEF6Evv6AMrQQYE30l6zuy4u3Mo9bgb6y+PqWDw=
X-Received: by 2002:a05:6358:7584:b0:17b:b559:2ba3 with SMTP id
 x4-20020a056358758400b0017bb5592ba3mr82704rwf.11.1711509089470; Tue, 26 Mar
 2024 20:11:29 -0700 (PDT)
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
 <CACGkMEvHiAN7X_QBgihWX6zzEUOxhrV2Nqg1arw1sfYy2A5K0g@mail.gmail.com> <CAK8fFZ5j_T1NzoOEfqE1HYhAEhD04smR4OT2bnMEAr+2+6C5RQ@mail.gmail.com>
In-Reply-To: <CAK8fFZ5j_T1NzoOEfqE1HYhAEhD04smR4OT2bnMEAr+2+6C5RQ@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 27 Mar 2024 11:11:18 +0800
Message-ID: <CACGkMEtUyR3HbBHpQmP5Pm8OePB5pzXtJVJPL-wyH57Ddh1PSA@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Cc: Igor Raits <igor@gooddata.com>, Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 26, 2024 at 9:26=E2=80=AFPM Jaroslav Pulchart
<jaroslav.pulchart@gooddata.com> wrote:
>
> >
> > On Mon, Mar 25, 2024 at 4:44=E2=80=AFPM Igor Raits <igor@gooddata.com> =
wrote:
> > >
> > > Hello,
> > >
> > > On Fri, Mar 22, 2024 at 12:19=E2=80=AFPM Igor Raits <igor@gooddata.co=
m> wrote:
> > > >
> > > > Hi Jason,
> > > >
> > > > On Fri, Mar 22, 2024 at 9:39=E2=80=AFAM Igor Raits <igor@gooddata.c=
om> wrote:
> > > > >
> > > > > Hi Jason,
> > > > >
> > > > > On Fri, Mar 22, 2024 at 6:31=E2=80=AFAM Jason Wang <jasowang@redh=
at.com> wrote:
> > > > > >
> > > > > > On Thu, Mar 21, 2024 at 5:44=E2=80=AFPM Igor Raits <igor@goodda=
ta.com> wrote:
> > > > > > >
> > > > > > > Hello Jason & others,
> > > > > > >
> > > > > > > On Wed, Mar 20, 2024 at 10:33=E2=80=AFAM Jason Wang <jasowang=
@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Tue, Mar 19, 2024 at 9:15=E2=80=AFPM Igor Raits <igor@go=
oddata.com> wrote:
> > > > > > > > >
> > > > > > > > > Hello Stefan,
> > > > > > > > >
> > > > > > > > > On Tue, Mar 19, 2024 at 2:12=E2=80=AFPM Stefan Hajnoczi <=
stefanha@redhat.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Tue, Mar 19, 2024 at 10:00:08AM +0100, Igor Raits wr=
ote:
> > > > > > > > > > > Hello,
> > > > > > > > > > >
> > > > > > > > > > > We have started to observe kernel crashes on 6.7.y ke=
rnels (atm we
> > > > > > > > > > > have hit the issue 5 times on 6.7.5 and 6.7.10). On 6=
.6.9 where we
> > > > > > > > > > > have nodes of cluster it looks stable. Please see sta=
cktrace below. If
> > > > > > > > > > > you need more information please let me know.
> > > > > > > > > > >
> > > > > > > > > > > We do not have a consistent reproducer but when we pu=
t some bigger
> > > > > > > > > > > network load on a VM, the hypervisor's kernel crashes=
.
> > > > > > > > > > >
> > > > > > > > > > > Help is much appreciated! We are happy to test any pa=
tches.
> > > > > > > > > >
> > > > > > > > > > CCing Michael Tsirkin and Jason Wang for vhost_net.
> > > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP N=
OPTI
> > > > > > > > > > > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 T=
ainted: G
> > > > > > > > > > >    E      6.7.10-1.gdc.el9.x86_64 #1
> > > > > > > > > >
> > > > > > > > > > Are there any patches in this kernel?
> > > > > > > > >
> > > > > > > > > Only one, unrelated to this part. Removal of pr_err("EEVD=
F scheduling
> > > > > > > > > fail, picking leftmost\n"); line (reported somewhere few =
months ago
> > > > > > > > > and it was suggested workaround until proper solution com=
es).
> > > > > > > >
> > > > > > > > Btw, a bisection would help as well.
> > > > > > >
> > > > > > > In the end it seems like we don't really have "stable" setup,=
 so
> > > > > > > bisection looks to be useless but we did find few things mean=
time:
> > > > > > >
> > > > > > > 1. On 6.6.9 it crashes either with unexpected GSO type or use=
rcopy:
> > > > > > > Kernel memory exposure attempt detected from SLUB object
> > > > > > > 'skbuff_head_cache'
> > > > > >
> > > > > > Do you have a full calltrace for this?
> > > > >
> > > > > I have shared it in one of the messages in this thread.
> > > > > https://marc.info/?l=3Dlinux-virtualization&m=3D171085443512001&w=
=3D2
> > > > >
> > > > > > > 2. On 6.7.5, 6.7.10 and 6.8.1 it crashes with RIP:
> > > > > > > 0010:skb_release_data+0xb8/0x1e0
> > > > > >
> > > > > > And for this?
> > > > >
> > > > > https://marc.info/?l=3Dlinux-netdev&m=3D171083870801761&w=3D2
> > > > >
> > > > > > > 3. It does NOT crash on 6.8.1 when VM does not have multi-que=
ue setup
> > > > > > >
> > > > > > > Looks like the multi-queue setup (we have 2 interfaces =C3=97=
 3 virtio
> > > > > > > queues for each) is causing problems as if we set only one qu=
eue for
> > > > > > > each interface the issue is gone.
> > > > > > > Maybe there is some race condition in __pfx_vhost_task_fn+0x1=
0/0x10 or
> > > > > > > somewhere around?
> > > > > >
> > > > > > I can't tell now, but it seems not because if we have 3 queue p=
airs we
> > > > > > will have 3 vhost threads.
> > > > > >
> > > > > > > We have noticed that there are 3 of such functions
> > > > > > > in the stacktrace that gave us hints about what we could try=
=E2=80=A6
> > > > > >
> > > > > > Let's try to enable SLUB_DEBUG and KASAN to see if we can get
> > > > > > something interesting.
> > > > >
> > > > > We were able to reproduce it even with 1 vhost queue... And now w=
e
> > > > > have slub_debug + kasan so I hopefully have more useful data for =
you
> > > > > now.
> > > > > I have attached it for better readability.
> > > >
> > > > Looks like we have found a "stable" kernel and that is 6.1.32. The
> > > > 6.3.y is broken and we are testing 6.2.y now.
> > > > My guess it would be related to virtio/vsock: replace virtio_vsock_=
pkt
> > > > with sk_buff that was done around that time but we are going to tes=
t,
> > > > bisect and let you know more.
> > >
> > > So we have been trying to bisect it but it is basically impossible fo=
r
> > > us to do so as the ICE driver was quite broken for most of the releas=
e
> > > cycle so we have no networking on 99% of the builds and we can't test
> > > such a setup.
> > > More specifically, the bug was introduced between 6.2 and 6.3 but we
> > > could not get much further. The last good commit we were able to test
> > > was f18f9845f2f10d3d1fc63e4ad16ee52d2d9292fa and then after 20 commit=
s
> > > where we had no networking we gave up.
> > >
> > > If you have some suspicious commit(s) we could revert - happy to test=
.
> >
> > Here is the is for the change since f18f9845f2f10d3d1fc63e4ad16ee52d2d9=
292fa:
> >
> > cbfbfe3aee71 tun: prevent negative ifindex
> > b2f8323364ab tun: add __exit annotations to module exit func tun_cleanu=
p()
> > 6231e47b6fad tun: avoid high-order page allocation for packet header
> > 4d016ae42efb Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev=
/net
> > 59eeb2329405 drivers: net: prevent tun_build_skb() to exceed the
> > packet size limit
> > 35b1b1fd9638 Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev=
/net
> > ce7c7fef1473 net: tun: change tun_alloc_skb() to allow bigger paged all=
ocations
> > 9bc3047374d5 net: tun_chr_open(): set sk_uid from current_fsuid()
> > 82b2bc279467 tun: Fix memory leak for detached NAPI queue.
> > 6e98b09da931 Merge tag 'net-next-6.4' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> > de4f5fed3f23 iov_iter: add iter_iovec() helper
> > 438b406055cd tun: flag the device as supporting FMODE_NOWAIT
> > de4287336794 Daniel Borkmann says:
> > a096ccca6e50 tun: tun_chr_open(): correctly initialize socket uid
> > 66c0e13ad236 drivers: net: turn on XDP features
> >
> > The commit that touches the datapath are:
> >
> > 6231e47b6fad tun: avoid high-order page allocation for packet header
> > 59eeb2329405 drivers: net: prevent tun_build_skb() to exceed the
> > packet size limit
> > ce7c7fef1473 net: tun: change tun_alloc_skb() to allow bigger paged all=
ocations
> > 82b2bc279467 tun: Fix memory leak for detached NAPI queue.
> > de4f5fed3f23 iov_iter: add iter_iovec() helper
> >
> > I assume you didn't use NAPI mode, so 82b2bc279467 tun: Fix memory
> > leak for detached NAPI queue doesn't make sense for us.
> >
> > The rest might be the bad commit if it is caused by a change of tun its=
elf.
> >
> > btw I vaguely remember KASAN will report who did the allocation and
> > who did the free. But it seems not in your KASAN log.
> >
> > Thanks
> >
> > >
> > > Thanks again.
> > >
> >
>
> Hello
>
> We have one observation. The occurrence of the error depends on the
> ring buffer size of physical network cards. We have two E810 Intel
> cards bonded by two interfaces (em1 + p3p2, ice driver) into single
> bon0. The bond0 is then linux bridged and/or ovs(witched) to VMs via
> tun interfaces (both switch solutions have the same problem). VMs are
> qemu-kvm instances and using vhost/virtio-net.
>
> We see:
> 1/ The issue is triggered almost instantaneously when tx/rx ring
> buffer is set to 2048 (our default)
> ethtool -G em1 rx 2048 tx 2048
> ethtool -G p3p1 rx 2048 tx 2048
>
> 2/ Similar issue is triggered when the tx/rx ring buffer is set to
> 4096: the host does not crash immediately, but some trace is shown
> soon and later it gets into memory pressure and crashes.

This is probably a hint of memory leak somewhere.

> ethtool -G em1 rx 4096 tx 4096
> ethtool -G p3p1 rx 4096 tx 4096
> See attached ring_4096.kasan.txt (vanila 6.8.1 with enabled KASAN) and
> ring_4096.txt (vanila 6.8.1 without kasan)
>
> 3/ The system is stable or we just can-not trigger the issue if the
> ring buffer is >=3D 6144.
> ethtool -G em1 rx 7120 tx 7120
> ethtool -G p3p1 rx 7120 tx 7120
>
> could it be influenced by a some rate of dropped packets in the ring buff=
er?

I can't tell.

Btw, it looks like the logs were cut off. Could we get a full log?

Thanks

>
> # for i in em1 p3p1; do ethtool -S ${i} | grep dropped.nic; done
>      rx_dropped.nic: 158225
>      rx_dropped.nic: 74285
>
> Best,
> Jaroslav Pulchart


