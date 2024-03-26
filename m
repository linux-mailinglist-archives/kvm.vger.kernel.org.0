Return-Path: <kvm+bounces-12656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C6B188B982
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 05:47:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14EFF1F35276
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 04:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB9974C00;
	Tue, 26 Mar 2024 04:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H+sjZjW4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4B333FD
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 04:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711428419; cv=none; b=eM1KYZrUXt/ULjhOJx7rYpZRZtVraw/gBuCTvNk5dsy9bneoxx95HfeNA25iDajV522wThgB3H74aDS/pMBAs+wC7Z/21sayzKOiHjWvB6k430wRDNvwpAfcmN672bJmmUhvh2zjB9pjfTB1dyoThTk1HeR7GS9zI+dW+9lnG58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711428419; c=relaxed/simple;
	bh=I0hBgUkJ6VetAVQzfY2/W0v2jZI+GcguK0+glpr0W/g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=taLwPXdaYH4rGWZsKNzSHX1D+N+0ZSuKBBMGRhQzwr28ieD4r1eomeUaamHn70gRc3mY/o2+pV5xr5XhP4HGYxISW4y6ML2D74/+OxWM9q6Cf1IluBF0Hcb65O8ZFmKaAKE5g1Y97khWfwphHQ3OUZdPVR5rywNsKkTr9DL0YTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H+sjZjW4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711428417;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lGXaQ3GVVuKxjOu0MEIZIl+iuzlQBISaMUUEdgRTSrA=;
	b=H+sjZjW4LhkSub7kyHRdi84xApaOdpk4nY1gHCyixMjSZspqiOXwLgt+gUBJVaiJq4UNax
	Z441wHq0avWfamdHuVerG9x5mwCk8PwRiL928u5QgvRUoBaPUfC2kHUToJraptHI1GMt4f
	163dOrOnVuDS5VFH9ADjZgi5E2N/c5c=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-328-Fl_-X2u7NOq3934FFLrdRQ-1; Tue, 26 Mar 2024 00:46:55 -0400
X-MC-Unique: Fl_-X2u7NOq3934FFLrdRQ-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1e0b3a4c2e4so13606625ad.0
        for <kvm@vger.kernel.org>; Mon, 25 Mar 2024 21:46:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711428413; x=1712033213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lGXaQ3GVVuKxjOu0MEIZIl+iuzlQBISaMUUEdgRTSrA=;
        b=pspfSygqsBJZmqttf5x7Jbnr/HZLgtnZYtoIVZgmpH0Y1Rcfejm+c09Y69HIdvQlO6
         t41JGim+Wr4vtGwTWNg8xJStTfSi3x8fpm7Vpa+w8YsF3k9g3CPGPa95OymAYzIP1suo
         Tz0jLsUHLelYl08Dsdef8L2+GUzjC0BVtY/gBpjQrnAsLQFunbGpjUF5wkd7Q4C2mVpi
         d87RsHDSDPkXIeOJcd8jR7f8alDZw8AWMKm9TajOaftyHJht6MBPPN121ZjfcXfiFubv
         7g2T9+wK8jfvmlpuI88ttUV5OL6/Ao78WY80ypOker0jSaNvmPIA6CyPab/WWdvAVt4Y
         elvg==
X-Forwarded-Encrypted: i=1; AJvYcCUR09XPiv7w0RT6eeH72+5a6bM+QUOGbD8Z059QD7WONnhH95/wBhYsnWBn3qzGi5+MYNZib7saiFurdq+SLBRInxiM
X-Gm-Message-State: AOJu0Yx7URWRgIThqCxqZH+Y0ctUIBVS7QTl/1Q7C+samgyPOxN3V0OR
	nSyxEG84tIIgphu+9C0Ha76m2IdkbUEwjJWkiFQKHs4G3xoktkhKSd5eck72eI6zz2U1/TC/tr5
	6FUSP6eQsDGOhGigYISGZ5SS0IvSiucxvQJhxyGbd6b7sq/T0P9YuU2dphMRTlv3H74D8JS9A2x
	/peJzamxrNmtpLRt/KcNkluINV
X-Received: by 2002:a17:902:d489:b0:1e0:c37d:cfb5 with SMTP id c9-20020a170902d48900b001e0c37dcfb5mr4165150plg.22.1711428412631;
        Mon, 25 Mar 2024 21:46:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyZmO2cvV4Hypg7KgUhp4pGLbalivRgNQTcdIDlFTO7Rsww9A745kpUDRmzlVRxVoxlFRU8bCaHOEWYUelx6c=
X-Received: by 2002:a17:902:d489:b0:1e0:c37d:cfb5 with SMTP id
 c9-20020a170902d48900b001e0c37dcfb5mr4165133plg.22.1711428412276; Mon, 25 Mar
 2024 21:46:52 -0700 (PDT)
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
 <CA+9S74ia-vUag2QMo6zFL7r+wZyOZVmcpe317RdMbK-rpomn+Q@mail.gmail.com> <CA+9S74hs_1Ft9iyXOPU_vF_EFKuoG8LjDpSna0QSPMFnMywd_g@mail.gmail.com>
In-Reply-To: <CA+9S74hs_1Ft9iyXOPU_vF_EFKuoG8LjDpSna0QSPMFnMywd_g@mail.gmail.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 26 Mar 2024 12:46:41 +0800
Message-ID: <CACGkMEvHiAN7X_QBgihWX6zzEUOxhrV2Nqg1arw1sfYy2A5K0g@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Igor Raits <igor@gooddata.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	Stefano Garzarella <sgarzare@redhat.com>, Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 25, 2024 at 4:44=E2=80=AFPM Igor Raits <igor@gooddata.com> wrot=
e:
>
> Hello,
>
> On Fri, Mar 22, 2024 at 12:19=E2=80=AFPM Igor Raits <igor@gooddata.com> w=
rote:
> >
> > Hi Jason,
> >
> > On Fri, Mar 22, 2024 at 9:39=E2=80=AFAM Igor Raits <igor@gooddata.com> =
wrote:
> > >
> > > Hi Jason,
> > >
> > > On Fri, Mar 22, 2024 at 6:31=E2=80=AFAM Jason Wang <jasowang@redhat.c=
om> wrote:
> > > >
> > > > On Thu, Mar 21, 2024 at 5:44=E2=80=AFPM Igor Raits <igor@gooddata.c=
om> wrote:
> > > > >
> > > > > Hello Jason & others,
> > > > >
> > > > > On Wed, Mar 20, 2024 at 10:33=E2=80=AFAM Jason Wang <jasowang@red=
hat.com> wrote:
> > > > > >
> > > > > > On Tue, Mar 19, 2024 at 9:15=E2=80=AFPM Igor Raits <igor@goodda=
ta.com> wrote:
> > > > > > >
> > > > > > > Hello Stefan,
> > > > > > >
> > > > > > > On Tue, Mar 19, 2024 at 2:12=E2=80=AFPM Stefan Hajnoczi <stef=
anha@redhat.com> wrote:
> > > > > > > >
> > > > > > > > On Tue, Mar 19, 2024 at 10:00:08AM +0100, Igor Raits wrote:
> > > > > > > > > Hello,
> > > > > > > > >
> > > > > > > > > We have started to observe kernel crashes on 6.7.y kernel=
s (atm we
> > > > > > > > > have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6.9=
 where we
> > > > > > > > > have nodes of cluster it looks stable. Please see stacktr=
ace below. If
> > > > > > > > > you need more information please let me know.
> > > > > > > > >
> > > > > > > > > We do not have a consistent reproducer but when we put so=
me bigger
> > > > > > > > > network load on a VM, the hypervisor's kernel crashes.
> > > > > > > > >
> > > > > > > > > Help is much appreciated! We are happy to test any patche=
s.
> > > > > > > >
> > > > > > > > CCing Michael Tsirkin and Jason Wang for vhost_net.
> > > > > > > >
> > > > > > > > >
> > > > > > > > > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOPTI
> > > > > > > > > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Taint=
ed: G
> > > > > > > > >    E      6.7.10-1.gdc.el9.x86_64 #1
> > > > > > > >
> > > > > > > > Are there any patches in this kernel?
> > > > > > >
> > > > > > > Only one, unrelated to this part. Removal of pr_err("EEVDF sc=
heduling
> > > > > > > fail, picking leftmost\n"); line (reported somewhere few mont=
hs ago
> > > > > > > and it was suggested workaround until proper solution comes).
> > > > > >
> > > > > > Btw, a bisection would help as well.
> > > > >
> > > > > In the end it seems like we don't really have "stable" setup, so
> > > > > bisection looks to be useless but we did find few things meantime=
:
> > > > >
> > > > > 1. On 6.6.9 it crashes either with unexpected GSO type or usercop=
y:
> > > > > Kernel memory exposure attempt detected from SLUB object
> > > > > 'skbuff_head_cache'
> > > >
> > > > Do you have a full calltrace for this?
> > >
> > > I have shared it in one of the messages in this thread.
> > > https://marc.info/?l=3Dlinux-virtualization&m=3D171085443512001&w=3D2
> > >
> > > > > 2. On 6.7.5, 6.7.10 and 6.8.1 it crashes with RIP:
> > > > > 0010:skb_release_data+0xb8/0x1e0
> > > >
> > > > And for this?
> > >
> > > https://marc.info/?l=3Dlinux-netdev&m=3D171083870801761&w=3D2
> > >
> > > > > 3. It does NOT crash on 6.8.1 when VM does not have multi-queue s=
etup
> > > > >
> > > > > Looks like the multi-queue setup (we have 2 interfaces =C3=97 3 v=
irtio
> > > > > queues for each) is causing problems as if we set only one queue =
for
> > > > > each interface the issue is gone.
> > > > > Maybe there is some race condition in __pfx_vhost_task_fn+0x10/0x=
10 or
> > > > > somewhere around?
> > > >
> > > > I can't tell now, but it seems not because if we have 3 queue pairs=
 we
> > > > will have 3 vhost threads.
> > > >
> > > > > We have noticed that there are 3 of such functions
> > > > > in the stacktrace that gave us hints about what we could try=E2=
=80=A6
> > > >
> > > > Let's try to enable SLUB_DEBUG and KASAN to see if we can get
> > > > something interesting.
> > >
> > > We were able to reproduce it even with 1 vhost queue... And now we
> > > have slub_debug + kasan so I hopefully have more useful data for you
> > > now.
> > > I have attached it for better readability.
> >
> > Looks like we have found a "stable" kernel and that is 6.1.32. The
> > 6.3.y is broken and we are testing 6.2.y now.
> > My guess it would be related to virtio/vsock: replace virtio_vsock_pkt
> > with sk_buff that was done around that time but we are going to test,
> > bisect and let you know more.
>
> So we have been trying to bisect it but it is basically impossible for
> us to do so as the ICE driver was quite broken for most of the release
> cycle so we have no networking on 99% of the builds and we can't test
> such a setup.
> More specifically, the bug was introduced between 6.2 and 6.3 but we
> could not get much further. The last good commit we were able to test
> was f18f9845f2f10d3d1fc63e4ad16ee52d2d9292fa and then after 20 commits
> where we had no networking we gave up.
>
> If you have some suspicious commit(s) we could revert - happy to test.

Here is the is for the change since f18f9845f2f10d3d1fc63e4ad16ee52d2d9292f=
a:

cbfbfe3aee71 tun: prevent negative ifindex
b2f8323364ab tun: add __exit annotations to module exit func tun_cleanup()
6231e47b6fad tun: avoid high-order page allocation for packet header
4d016ae42efb Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
59eeb2329405 drivers: net: prevent tun_build_skb() to exceed the
packet size limit
35b1b1fd9638 Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net
ce7c7fef1473 net: tun: change tun_alloc_skb() to allow bigger paged allocat=
ions
9bc3047374d5 net: tun_chr_open(): set sk_uid from current_fsuid()
82b2bc279467 tun: Fix memory leak for detached NAPI queue.
6e98b09da931 Merge tag 'net-next-6.4' of
git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
de4f5fed3f23 iov_iter: add iter_iovec() helper
438b406055cd tun: flag the device as supporting FMODE_NOWAIT
de4287336794 Daniel Borkmann says:
a096ccca6e50 tun: tun_chr_open(): correctly initialize socket uid
66c0e13ad236 drivers: net: turn on XDP features

The commit that touches the datapath are:

6231e47b6fad tun: avoid high-order page allocation for packet header
59eeb2329405 drivers: net: prevent tun_build_skb() to exceed the
packet size limit
ce7c7fef1473 net: tun: change tun_alloc_skb() to allow bigger paged allocat=
ions
82b2bc279467 tun: Fix memory leak for detached NAPI queue.
de4f5fed3f23 iov_iter: add iter_iovec() helper

I assume you didn't use NAPI mode, so 82b2bc279467 tun: Fix memory
leak for detached NAPI queue doesn't make sense for us.

The rest might be the bad commit if it is caused by a change of tun itself.

btw I vaguely remember KASAN will report who did the allocation and
who did the free. But it seems not in your KASAN log.

Thanks

>
> Thanks again.
>


