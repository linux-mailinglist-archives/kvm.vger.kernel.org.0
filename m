Return-Path: <kvm+bounces-12695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C971088C34F
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 14:26:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 375391F34D16
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 13:26:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E62B573518;
	Tue, 26 Mar 2024 13:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="j3qoNsPG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDD46D1CE
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711459585; cv=none; b=WhyTYBnBcJAVN6lyS/lDkkq5j0iQ9Bf9YDC0hdZ70VWyX1W2bD9MZfr7nsq5oQ3jclRHCADEELV4jx6Fz37qca+1T08gwhPplXMsrzTdJk5muv6LUrEmwb0Kla2uCyqkK2Xy4eTp3o7sDwH/eeuzcEw5L4Qi7W1y64R++7/1xjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711459585; c=relaxed/simple;
	bh=7EO04ojzTypjH2v7CJmgZ6/R0sRRFHxIT+rfgbUeHyc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pUFONZB9BLGmD05w8eH4NpBrn9D2EEvm/pSY1CbrbBC7M1m6ME2aF5cIcaNLSKHGU4mFY0cGaIMpBEd65sZ5UnSX9EQf3tfiebZ7aDok8UJuw3RGFJSgRyFVmmUl155aDDHJ3Btp4BUdh/WlGpbVewcMLGsHbxNqFiV7KorSZx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=j3qoNsPG; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2d28051376eso101812841fa.0
        for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 06:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1711459580; x=1712064380; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l7j4GbJ5c1I5JqdtHtnFGH7HrfqFzv/PZoksZMgqKsA=;
        b=j3qoNsPGrPRDu5jubIznmfm7W1CJNwXDUk8lWSBWBrrO42GrPhaM4jJkHOq+k16nAH
         OCD1rLSiB8Vltj071s3qKIHJ7Y4yxjinL040rIK1Qkw32ChiETSXZnN2X0XXTHfkw5K7
         ldbj3OmixQ8POMJWHaqOui5Q7VX81RuTYy0CY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711459580; x=1712064380;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l7j4GbJ5c1I5JqdtHtnFGH7HrfqFzv/PZoksZMgqKsA=;
        b=bIIcjpNgIlKLhEa0+d3jsRmJ+ALttlRYZaD5qfl17rd8jU1RaygoSnbLmfhI04pE34
         QqllLd2hq+CQqGxvyuObOsNPhuRmL7QM44tgrr9Dc553o3VnQRDqWITNjtid2qY7RX0x
         1vpATPxTd9x7+J6kfcRF9MNxIktMKCveQ6LojD44gcbuXrSn6/mERCtlAORBrCluqBnl
         taezZlMk3qv4nFJ2c+8ZtDBFMWHaeeL4ZZgHl+fDJ5IncUULdJxq8VbjYH6m9gNTMH5I
         XyeVI2PV3zopd/BqHXxVUMrZfegHWEFbNBdigZZ0ybYVI+iL6HOHBPE7FtnGz58TV1YO
         DpaA==
X-Forwarded-Encrypted: i=1; AJvYcCUL2QHiJGrVT90aY1vxip5HNaXjvay+/8ynTbu+Gm8mU49u3pbOzK106bwx6sRUnMooaB2Iqzjg64TMOrPn0A0xtTdn
X-Gm-Message-State: AOJu0YzInIOTYIsqcLG+WTnHCtDO8one3LNlMKGJ+WHFBocEEni9QR/f
	Z6iT3DnT/GlvBuH0bac1WN4t9qt7gUVta7HanAvxjsl/39+En3WDWkT0DcZe3HiMpav2rLqxKsk
	IkhGqdKcyrXAcnJhd2IG9SnC6pIFktraxverv
X-Google-Smtp-Source: AGHT+IEClS5PJDGT1t7USuKxHctOc6c/LyuI+6zfC2ZHwmK3IB8Y6PTDb4iFTSkchEaAtbNbK1H0teDe/jaIsTGRqok=
X-Received: by 2002:a2e:9c8f:0:b0:2d5:bfe4:4ebe with SMTP id
 x15-20020a2e9c8f000000b002d5bfe44ebemr8022092lji.30.1711459579578; Tue, 26
 Mar 2024 06:26:19 -0700 (PDT)
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
 <CA+9S74hs_1Ft9iyXOPU_vF_EFKuoG8LjDpSna0QSPMFnMywd_g@mail.gmail.com> <CACGkMEvHiAN7X_QBgihWX6zzEUOxhrV2Nqg1arw1sfYy2A5K0g@mail.gmail.com>
In-Reply-To: <CACGkMEvHiAN7X_QBgihWX6zzEUOxhrV2Nqg1arw1sfYy2A5K0g@mail.gmail.com>
From: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Date: Tue, 26 Mar 2024 14:25:53 +0100
Message-ID: <CAK8fFZ5j_T1NzoOEfqE1HYhAEhD04smR4OT2bnMEAr+2+6C5RQ@mail.gmail.com>
Subject: Re: REGRESSION: RIP: 0010:skb_release_data+0xb8/0x1e0 in vhost/tun
To: Jason Wang <jasowang@redhat.com>
Cc: Igor Raits <igor@gooddata.com>, Stefan Hajnoczi <stefanha@redhat.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	Stefano Garzarella <sgarzare@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Content-Type: multipart/mixed; boundary="0000000000004a926e0614903c93"

--0000000000004a926e0614903c93
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

>
> On Mon, Mar 25, 2024 at 4:44=E2=80=AFPM Igor Raits <igor@gooddata.com> wr=
ote:
> >
> > Hello,
> >
> > On Fri, Mar 22, 2024 at 12:19=E2=80=AFPM Igor Raits <igor@gooddata.com>=
 wrote:
> > >
> > > Hi Jason,
> > >
> > > On Fri, Mar 22, 2024 at 9:39=E2=80=AFAM Igor Raits <igor@gooddata.com=
> wrote:
> > > >
> > > > Hi Jason,
> > > >
> > > > On Fri, Mar 22, 2024 at 6:31=E2=80=AFAM Jason Wang <jasowang@redhat=
.com> wrote:
> > > > >
> > > > > On Thu, Mar 21, 2024 at 5:44=E2=80=AFPM Igor Raits <igor@gooddata=
.com> wrote:
> > > > > >
> > > > > > Hello Jason & others,
> > > > > >
> > > > > > On Wed, Mar 20, 2024 at 10:33=E2=80=AFAM Jason Wang <jasowang@r=
edhat.com> wrote:
> > > > > > >
> > > > > > > On Tue, Mar 19, 2024 at 9:15=E2=80=AFPM Igor Raits <igor@good=
data.com> wrote:
> > > > > > > >
> > > > > > > > Hello Stefan,
> > > > > > > >
> > > > > > > > On Tue, Mar 19, 2024 at 2:12=E2=80=AFPM Stefan Hajnoczi <st=
efanha@redhat.com> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Mar 19, 2024 at 10:00:08AM +0100, Igor Raits wrot=
e:
> > > > > > > > > > Hello,
> > > > > > > > > >
> > > > > > > > > > We have started to observe kernel crashes on 6.7.y kern=
els (atm we
> > > > > > > > > > have hit the issue 5 times on 6.7.5 and 6.7.10). On 6.6=
.9 where we
> > > > > > > > > > have nodes of cluster it looks stable. Please see stack=
trace below. If
> > > > > > > > > > you need more information please let me know.
> > > > > > > > > >
> > > > > > > > > > We do not have a consistent reproducer but when we put =
some bigger
> > > > > > > > > > network load on a VM, the hypervisor's kernel crashes.
> > > > > > > > > >
> > > > > > > > > > Help is much appreciated! We are happy to test any patc=
hes.
> > > > > > > > >
> > > > > > > > > CCing Michael Tsirkin and Jason Wang for vhost_net.
> > > > > > > > >
> > > > > > > > > >
> > > > > > > > > > [62254.167584] stack segment: 0000 [#1] PREEMPT SMP NOP=
TI
> > > > > > > > > > [62254.173450] CPU: 63 PID: 11939 Comm: vhost-11890 Tai=
nted: G
> > > > > > > > > >    E      6.7.10-1.gdc.el9.x86_64 #1
> > > > > > > > >
> > > > > > > > > Are there any patches in this kernel?
> > > > > > > >
> > > > > > > > Only one, unrelated to this part. Removal of pr_err("EEVDF =
scheduling
> > > > > > > > fail, picking leftmost\n"); line (reported somewhere few mo=
nths ago
> > > > > > > > and it was suggested workaround until proper solution comes=
).
> > > > > > >
> > > > > > > Btw, a bisection would help as well.
> > > > > >
> > > > > > In the end it seems like we don't really have "stable" setup, s=
o
> > > > > > bisection looks to be useless but we did find few things meanti=
me:
> > > > > >
> > > > > > 1. On 6.6.9 it crashes either with unexpected GSO type or userc=
opy:
> > > > > > Kernel memory exposure attempt detected from SLUB object
> > > > > > 'skbuff_head_cache'
> > > > >
> > > > > Do you have a full calltrace for this?
> > > >
> > > > I have shared it in one of the messages in this thread.
> > > > https://marc.info/?l=3Dlinux-virtualization&m=3D171085443512001&w=
=3D2
> > > >
> > > > > > 2. On 6.7.5, 6.7.10 and 6.8.1 it crashes with RIP:
> > > > > > 0010:skb_release_data+0xb8/0x1e0
> > > > >
> > > > > And for this?
> > > >
> > > > https://marc.info/?l=3Dlinux-netdev&m=3D171083870801761&w=3D2
> > > >
> > > > > > 3. It does NOT crash on 6.8.1 when VM does not have multi-queue=
 setup
> > > > > >
> > > > > > Looks like the multi-queue setup (we have 2 interfaces =C3=97 3=
 virtio
> > > > > > queues for each) is causing problems as if we set only one queu=
e for
> > > > > > each interface the issue is gone.
> > > > > > Maybe there is some race condition in __pfx_vhost_task_fn+0x10/=
0x10 or
> > > > > > somewhere around?
> > > > >
> > > > > I can't tell now, but it seems not because if we have 3 queue pai=
rs we
> > > > > will have 3 vhost threads.
> > > > >
> > > > > > We have noticed that there are 3 of such functions
> > > > > > in the stacktrace that gave us hints about what we could try=E2=
=80=A6
> > > > >
> > > > > Let's try to enable SLUB_DEBUG and KASAN to see if we can get
> > > > > something interesting.
> > > >
> > > > We were able to reproduce it even with 1 vhost queue... And now we
> > > > have slub_debug + kasan so I hopefully have more useful data for yo=
u
> > > > now.
> > > > I have attached it for better readability.
> > >
> > > Looks like we have found a "stable" kernel and that is 6.1.32. The
> > > 6.3.y is broken and we are testing 6.2.y now.
> > > My guess it would be related to virtio/vsock: replace virtio_vsock_pk=
t
> > > with sk_buff that was done around that time but we are going to test,
> > > bisect and let you know more.
> >
> > So we have been trying to bisect it but it is basically impossible for
> > us to do so as the ICE driver was quite broken for most of the release
> > cycle so we have no networking on 99% of the builds and we can't test
> > such a setup.
> > More specifically, the bug was introduced between 6.2 and 6.3 but we
> > could not get much further. The last good commit we were able to test
> > was f18f9845f2f10d3d1fc63e4ad16ee52d2d9292fa and then after 20 commits
> > where we had no networking we gave up.
> >
> > If you have some suspicious commit(s) we could revert - happy to test.
>
> Here is the is for the change since f18f9845f2f10d3d1fc63e4ad16ee52d2d929=
2fa:
>
> cbfbfe3aee71 tun: prevent negative ifindex
> b2f8323364ab tun: add __exit annotations to module exit func tun_cleanup(=
)
> 6231e47b6fad tun: avoid high-order page allocation for packet header
> 4d016ae42efb Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/n=
et
> 59eeb2329405 drivers: net: prevent tun_build_skb() to exceed the
> packet size limit
> 35b1b1fd9638 Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/n=
et
> ce7c7fef1473 net: tun: change tun_alloc_skb() to allow bigger paged alloc=
ations
> 9bc3047374d5 net: tun_chr_open(): set sk_uid from current_fsuid()
> 82b2bc279467 tun: Fix memory leak for detached NAPI queue.
> 6e98b09da931 Merge tag 'net-next-6.4' of
> git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> de4f5fed3f23 iov_iter: add iter_iovec() helper
> 438b406055cd tun: flag the device as supporting FMODE_NOWAIT
> de4287336794 Daniel Borkmann says:
> a096ccca6e50 tun: tun_chr_open(): correctly initialize socket uid
> 66c0e13ad236 drivers: net: turn on XDP features
>
> The commit that touches the datapath are:
>
> 6231e47b6fad tun: avoid high-order page allocation for packet header
> 59eeb2329405 drivers: net: prevent tun_build_skb() to exceed the
> packet size limit
> ce7c7fef1473 net: tun: change tun_alloc_skb() to allow bigger paged alloc=
ations
> 82b2bc279467 tun: Fix memory leak for detached NAPI queue.
> de4f5fed3f23 iov_iter: add iter_iovec() helper
>
> I assume you didn't use NAPI mode, so 82b2bc279467 tun: Fix memory
> leak for detached NAPI queue doesn't make sense for us.
>
> The rest might be the bad commit if it is caused by a change of tun itsel=
f.
>
> btw I vaguely remember KASAN will report who did the allocation and
> who did the free. But it seems not in your KASAN log.
>
> Thanks
>
> >
> > Thanks again.
> >
>

Hello

We have one observation. The occurrence of the error depends on the
ring buffer size of physical network cards. We have two E810 Intel
cards bonded by two interfaces (em1 + p3p2, ice driver) into single
bon0. The bond0 is then linux bridged and/or ovs(witched) to VMs via
tun interfaces (both switch solutions have the same problem). VMs are
qemu-kvm instances and using vhost/virtio-net.

We see:
1/ The issue is triggered almost instantaneously when tx/rx ring
buffer is set to 2048 (our default)
ethtool -G em1 rx 2048 tx 2048
ethtool -G p3p1 rx 2048 tx 2048

2/ Similar issue is triggered when the tx/rx ring buffer is set to
4096: the host does not crash immediately, but some trace is shown
soon and later it gets into memory pressure and crashes.
ethtool -G em1 rx 4096 tx 4096
ethtool -G p3p1 rx 4096 tx 4096
See attached ring_4096.kasan.txt (vanila 6.8.1 with enabled KASAN) and
ring_4096.txt (vanila 6.8.1 without kasan)

3/ The system is stable or we just can-not trigger the issue if the
ring buffer is >=3D 6144.
ethtool -G em1 rx 7120 tx 7120
ethtool -G p3p1 rx 7120 tx 7120

could it be influenced by a some rate of dropped packets in the ring buffer=
?

# for i in em1 p3p1; do ethtool -S ${i} | grep dropped.nic; done
     rx_dropped.nic: 158225
     rx_dropped.nic: 74285

Best,
Jaroslav Pulchart

--0000000000004a926e0614903c93
Content-Type: text/plain; charset="US-ASCII"; name="ring_4096.kasan.txt"
Content-Disposition: attachment; filename="ring_4096.kasan.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_lu8ellzg1>
X-Attachment-Id: f_lu8ellzg1

WyAxNzA5Ljg5MzE0N10gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09ClsgMTcwOS45MDEwODRdIEJVRzogS0FTQU46IHVzZS1h
ZnRlci1mcmVlIGluIGluZXRfZ3JvX2NvbXBsZXRlKzB4MzUyLzB4M2QwClsgMTcwOS45MDg0Mzdd
IFJlYWQgb2Ygc2l6ZSAyIGF0IGFkZHIgZmZmZjg4YTAyOTczZTBkMCBieSB0YXNrIHN3YXBwZXIv
NDkvMApbIDE3MDkuOTE1Njg0XSAKWyAxNzA5LjkxNzcxNF0gQ1BVOiA0OSBQSUQ6IDAgQ29tbTog
c3dhcHBlci80OSBUYWludGVkOiBHICAgICAgICAgICAgRSAgICAgIDYuOC4xLTEuZ2RjLmVsOS5r
YXNhbi54ODZfNjQgIzEKWyAxNzA5LjkyNzcyN10gSGFyZHdhcmUgbmFtZTogRGVsbCBJbmMuIFBv
d2VyRWRnZSBSNzUyNS8wSDNLN1AsIEJJT1MgMi4xNC4xIDEyLzE3LzIwMjMKWyAxNzA5LjkzNjIy
Nl0gQ2FsbCBUcmFjZToKWyAxNzA5LjkzOTM2NF0gIDxJUlE+ClsgMTcwOS45NDE5MzBdICBkdW1w
X3N0YWNrX2x2bCsweDMzLzB4NTAKWyAxNzA5Ljk0NjEwM10gIHByaW50X2FkZHJlc3NfZGVzY3Jp
cHRpb24uY29uc3Rwcm9wLjArMHgyYy8weDNlMApbIDE3MDkuOTUyNjA4XSAgPyBpbmV0X2dyb19j
b21wbGV0ZSsweDM1Mi8weDNkMApbIDE3MDkuOTU3MzkyXSAgcHJpbnRfcmVwb3J0KzB4YjUvMHgy
NzAKWyAxNzA5Ljk2MTg1MF0gID8ga2FzYW5fYWRkcl90b19zbGFiKzB4OS8weGEwClsgMTcwOS45
NjY0OTZdICBrYXNhbl9yZXBvcnQrMHhhYy8weGUwClsgMTcwOS45NzA1MDFdICA/IGluZXRfZ3Jv
X2NvbXBsZXRlKzB4MzUyLzB4M2QwClsgMTcwOS45NzUzMDBdICBpbmV0X2dyb19jb21wbGV0ZSsw
eDM1Mi8weDNkMApbIDE3MDkuOTc5OTA5XSAgPyBpY2VfYWxsb2NfcnhfYnVmcysweDQzNS8weDg2
MCBbaWNlXQpbIDE3MDkuOTg1MzMxXSAgbmFwaV9ncm9fY29tcGxldGUuY29uc3Rwcm9wLjArMHgz
Y2QvMHg0YzAKWyAxNzA5Ljk5MTA5NF0gIG5hcGlfZ3JvX2ZsdXNoKzB4MWFkLzB4MzcwClsgMTcw
OS45OTU0NTFdICBuYXBpX2NvbXBsZXRlX2RvbmUrMHg0MzMvMHg3MTAKWyAxNzEwLjAwMDI1OV0g
ID8gX19wZnhfbmFwaV9jb21wbGV0ZV9kb25lKzB4MTAvMHgxMApbIDE3MTAuMDA1NTA5XSAgaWNl
X25hcGlfcG9sbCsweDIzZS8weDhiMCBbaWNlXQpbIDE3MTAuMDEwMzkxXSAgPyBfX3BmeF9pY2Vf
bmFwaV9wb2xsKzB4MTAvMHgxMCBbaWNlXQpbIDE3MTAuMDE1NzkwXSAgPyBfX3BmeF9sb2FkX2Jh
bGFuY2UrMHgxMC8weDEwClsgMTcxMC4wMjA1ODddICBfX25hcGlfcG9sbCsweGEyLzB4NTAwClsg
MTcxMC4wMjQ1ODFdICA/IF9yYXdfc3Bpbl90cnlsb2NrKzB4NmUvMHgxMjAKWyAxNzEwLjAyOTI2
N10gIG5ldF9yeF9hY3Rpb24rMHg0MjEvMHhiODAKWyAxNzEwLjAzMzU1MV0gID8gX19wZnhfbmV0
X3J4X2FjdGlvbisweDEwLzB4MTAKWyAxNzEwLjAzODMzMV0gID8gX19wZnhfc2NoZWRfY2xvY2tf
Y3B1KzB4MTAvMHgxMApbIDE3MTAuMDQzMzcyXSAgPyBfcmF3X3NwaW5fbG9jaysweDgxLzB4ZTAK
WyAxNzEwLjA0NzcxMV0gIF9fZG9fc29mdGlycSsweDE5Yi8weDU5NwpbIDE3MTAuMDUxOTc3XSAg
X19pcnFfZXhpdF9yY3UrMHgxMjUvMHgxNzAKWyAxNzEwLjA1NjQ1OV0gIGNvbW1vbl9pbnRlcnJ1
cHQrMHg3ZC8weGEwClsgMTcxMC4wNjA3OTZdICA8L0lSUT4KWyAxNzEwLjA2MzQzMV0gIDxUQVNL
PgpbIDE3MTAuMDY2MDE2XSAgYXNtX2NvbW1vbl9pbnRlcnJ1cHQrMHgyMi8weDQwClsgMTcxMC4w
NzEwOThdIFJJUDogMDAxMDpjcHVpZGxlX2VudGVyX3N0YXRlKzB4MTc2LzB4MzAwClsgMTcxMC4w
NzY2OTRdIENvZGU6IDQ4IDgzIDNjIDAzIDAwIDBmIDg0IDJjIDAxIDAwIDAwIDgzIGU5IDAxIDcz
IGU0IDQ4IDgzIGM0IDE4IDQ0IDg5IGUwIDViIDVkIDQxIDVjIDQxIDVkIDQxIDVlIDQxIDVmIGMz
IGNjIGNjIGNjIGNjIGZiIDQ1IDg1IGU0IDwwZj4gODkgNWYgZmYgZmYgZmYgNGIgOGQgNDQgNmQg
MDAgNDggYzcgNDMgMTggMDAgMDAgMDAgMDAgNDggYzEgZTAKWyAxNzEwLjA5Njg3M10gUlNQOiAw
MDE4OmZmZmY4ODkwMDIwMTdkOTAgRUZMQUdTOiAwMDAwMDIwMgpbIDE3MTAuMTAyNjU3XSBSQVg6
IDAwMDAwMDAwMDAwMDAwMDAgUkJYOiBmZmZmODhiMDAzNjIyODAwIFJDWDogMDAwMDAwMDAwMDAw
MDAxZgpbIDE3MTAuMTEwMzIxXSBSRFg6IDFmZmZmMTEyMDA0Yzg4MjEgUlNJOiAwMDAwMDAwMDAw
MDAwMDMxIFJESTogZmZmZjg4OTAwMjY0NDEwOApbIDE3MTAuMTE3OTgyXSBSQlA6IGZmZmZmZmZm
YjBhNzcxNDAgUjA4OiAwMDAwMDE4ZTFkOTI5YWU1IFIwOTogZmZmZmVkMTIwMDRjN2RmNQpbIDE3
MTAuMTI1NjU4XSBSMTA6IGZmZmY4ODkwMDI2M2VmYWIgUjExOiAwNzFjNzFjNzFjNzFjNzFjIFIx
MjogMDAwMDAwMDAwMDAwMDAwMQpbIDE3MTAuMTMzMzMyXSBSMTM6IDAwMDAwMDAwMDAwMDAwMDEg
UjE0OiAwMDAwMDE4ZTFkOTI5YWU1IFIxNTogMDAwMDAwMDAwMDAwMDAwMApbIDE3MTAuMTQwOTUy
XSAgY3B1aWRsZV9lbnRlcisweDRhLzB4YTAKWyAxNzEwLjE0NTIwOV0gID8gdGlja19ub2h6X2lk
bGVfc3RvcF90aWNrKzB4MTA4LzB4MjkwClsgMTcxMC4xNTA1NTNdICBjcHVpZGxlX2lkbGVfY2Fs
bCsweDE3NC8weDFkMApbIDE3MTAuMTU1MzYwXSAgPyBfX3BmeF9jcHVpZGxlX2lkbGVfY2FsbCsw
eDEwLzB4MTAKWyAxNzEwLjE2MDQzMF0gID8gaXJxdGltZV9hY2NvdW50X3Byb2Nlc3NfdGljaysw
eDFlMS8weDM0MApbIDE3MTAuMTY2MzYwXSAgZG9faWRsZSsweGUxLzB4MTUwClsgMTcxMC4xNzAx
MjddICBjcHVfc3RhcnR1cF9lbnRyeSsweDUxLzB4NjAKWyAxNzEwLjE3NDQ4Ml0gIHN0YXJ0X3Nl
Y29uZGFyeSsweDIwOS8weDI4MApbIDE3MTAuMTc4ODMwXSAgPyBfX3BmeF9zdGFydF9zZWNvbmRh
cnkrMHgxMC8weDEwClsgMTcxMC4xODM3MzJdICA/IHNvZnRfcmVzdGFydF9jcHUrMHgxNS8weDE1
ClsgMTcxMC4xODg1MTBdICBzZWNvbmRhcnlfc3RhcnR1cF82NF9ub192ZXJpZnkrMHgxODQvMHgx
OGIKWyAxNzEwLjE5NDQyNF0gIDwvVEFTSz4KWyAxNzEwLjE5NzA5MF0gClsgMTcxMC4xOTkwOTBd
IFRoZSBidWdneSBhZGRyZXNzIGJlbG9uZ3MgdG8gdGhlIHBoeXNpY2FsIHBhZ2U6ClsgMTcxMC4y
MDUxMzldIHBhZ2U6ZmZmZmVhMDA4MGE1Y2Y4MCByZWZjb3VudDowIG1hcGNvdW50OjAgbWFwcGlu
ZzowMDAwMDAwMDAwMDAwMDAwIGluZGV4OjB4MCBwZm46MHgyMDI5NzNlClsgMTcxMC4yMTUwNTNd
IGZsYWdzOiAweDU3ZmZmZmMwMDAwMDAwKG5vZGU9MXx6b25lPTJ8bGFzdGNwdXBpZD0weDFmZmZm
ZikKWyAxNzEwLjIyMjIxOV0gcGFnZV90eXBlOiAweGZmZmZmZmZmKCkKWyAxNzEwLjIyNjE4Ml0g
cmF3OiAwMDU3ZmZmZmMwMDAwMDAwIGZmZmZlYTAwNDNjOGMxODggZmZmZjg4OTAwMjY0OTY1MCAw
MDAwMDAwMDAwMDAwMDAwClsgMTcxMC4yMzQ0MjVdIHJhdzogMDAwMDAwMDAwMDAwMDAwMCAwMDAw
MDAwMDAwMDAwMDAwIDAwMDAwMDAwZmZmZmZmZmYgMDAwMDAwMDAwMDAwMDAwMApbIDE3MTAuMjQy
Njg3XSBwYWdlIGR1bXBlZCBiZWNhdXNlOiBrYXNhbjogYmFkIGFjY2VzcyBkZXRlY3RlZApbIDE3
MTAuMjQ4ODAxXSAKWyAxNzEwLjI1MDc0OF0gTWVtb3J5IHN0YXRlIGFyb3VuZCB0aGUgYnVnZ3kg
YWRkcmVzczoKWyAxNzEwLjI1NjM3OV0gIGZmZmY4OGEwMjk3M2RmODA6IGZjIGZjIGZjIGZjIGZj
IGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjClsgMTcxMC4yNjQwNjddICBmZmZmODhh
MDI5NzNlMDAwOiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBm
ZgpbIDE3MTAuMjcxNzcxXSA+ZmZmZjg4YTAyOTczZTA4MDogZmYgZmYgZmYgZmYgZmYgZmYgZmYg
ZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYgZmYKWyAxNzEwLjI3OTY3NV0gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF4KWyAxNzEwLjI4NTk3OF0gIGZmZmY4
OGEwMjk3M2UxMDA6IGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZmIGZm
IGZmClsgMTcxMC4yOTM4NzBdICBmZmZmODhhMDI5NzNlMTgwOiBmZiBmZiBmZiBmZiBmZiBmZiBm
ZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZiBmZgpbIDE3MTAuMzAxNTc5XSA9PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KWyAx
NzEwLjMwOTI4Nl0gRGlzYWJsaW5nIGxvY2sgZGVidWdnaW5nIGR1ZSB0byBrZXJuZWwgdGFpbnQK
Li4uClsgMjM2Mi4zMzkwOTBdIGdlbmVyYWwgcHJvdGVjdGlvbiBmYXVsdCwgcHJvYmFibHkgZm9y
IG5vbi1jYW5vbmljYWwgYWRkcmVzcyAweGRmZmZmYzAwMDAwMDg4NWM6IDAwMDAgWyMxXSBQUkVF
TVBUIFNNUCBLQVNBTiBOT1BUSQpbIDIzNjIuMzQ3ODI4XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJl
IF0tLS0tLS0tLS0tLS0KWyAyMzYyLjM1MDQ3NF0gS0FTQU46IHByb2JhYmx5IHVzZXItbWVtb3J5
LWFjY2VzcyBpbiByYW5nZSBbMHgwMDAwMDAwMDAwMDQ0MmUwLTB4MDAwMDAwMDAwMDA0NDJlN10K
WyAyMzYyLjM1NTA5Ml0gV0FSTklORzogQ1BVOiAxOSBQSUQ6IDAgYXQga2VybmVsL3NjaGVkL2Nv
cmUuYzozMzg5IHNldF90YXNrX2NwdSsweDYyZS8weDdjMApbIDIzNjIuMzYzNzg2XSBDUFU6IDIw
IFBJRDogMCBDb21tOiBzd2FwcGVyLzIwIFRhaW50ZWQ6IEcgICAgQiAgICAgICBFICAgICAgNi44
LjEtMS5nZGMuZWw5Lmthc2FuLng4Nl82NCAjMQpbIDIzNjIuMzYzODM5XSBLZXJuZWwgcGFuaWMg
LSBub3Qgc3luY2luZzogc3RhY2stcHJvdGVjdG9yOiBLZXJuZWwgc3RhY2sgaXMgY29ycnVwdGVk
IGluOiBfX3NjaGVkdWxlKzB4MTRmMC8weDE3NjAKCgo=
--0000000000004a926e0614903c93
Content-Type: text/plain; charset="US-ASCII"; name="ring_4096.txt"
Content-Disposition: attachment; filename="ring_4096.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_lu8ellz90>
X-Attachment-Id: f_lu8ellz90

WyAxNDE1LjQ3ODkwM10gVW5sb2FkZWQgdGFpbnRlZCBtb2R1bGVzOiBmamVzKEUpOjIgcGFkbG9j
a19hZXMoRSk6MwpbIDE0MTUuNTI5NTI3XSBDUFU6IDMyIFBJRDogMTEwNDQgQ29tbTogdmhvc3Qt
MTA5OTggVGFpbnRlZDogRyAgICAgICAgICAgIEUgICAgICA2LjguMS0xLmdkYy5lbDkueDg2XzY0
ICMxClsgMTQxNS41MzkxMjRdIEhhcmR3YXJlIG5hbWU6IERlbGwgSW5jLiBQb3dlckVkZ2UgUjc1
MjUvMEgzSzdQLCBCSU9TIDIuMTQuMSAxMi8xNy8yMDIzClsgMTQxNS41NDY5OTVdIFJJUDogMDAx
MDprbWVtX2NhY2hlX2ZyZWUrMHgzMDEvMHgzZDAKWyAxNDE1LjU1MTkyMV0gQ29kZTogZmQgZmYg
ZmYgODAgM2QgM2EgOWYgZjUgMDEgMDAgMGYgODUgYmYgZmUgZmYgZmYgNDggYzcgYzYgNTAgNGQg
YTcgOGUgNDggYzcgYzcgNDAgNjkgZmQgOGUgYzYgMDUgMWYgOWYgZjUgMDEgMDEgZTggMWYgNDQg
ZDMgZmYgPDBmPiAwYiBlOSA5ZSBmZSBmZiBmZiA0OCA4ZCA0MiBmZiBlOSA2MyBmZCBmZiBmZiA0
YyA4ZCA2OCBmZiBlOSBlMwpbIDE0MTUuNTcxMTAzXSBSU1A6IDAwMTg6ZmZmZmFiMTJkZTU1YmM4
MCBFRkxBR1M6IDAwMDEwMjgyClsgMTQxNS41NzY1NDhdIFJBWDogMDAwMDAwMDAwMDAwMDAwMCBS
Qlg6IGZmZmY5MWQyYjRkZDk4MDAgUkNYOiAwMDAwMDAwMDAwMDAwMDAwClsgMTQxNS41ODM5MTRd
IFJEWDogZmZmZjkxYjI3ZmNhZDgwMCBSU0k6IGZmZmY5MWIyN2ZjYTBhNDAgUkRJOiBmZmZmOTFi
MjdmY2EwYTQwClsgMTQxNS41OTEyNjhdIFJCUDogZmZmZmFiMTJkZTU1YmNjOCBSMDg6IDAwMDAw
MDAwMDAwMDAwMDAgUjA5OiAwMDAwMDAwMGZmZmY3ZmZmClsgMTQxNS41OTg2MzFdIFIxMDogZmZm
ZmFiMTJkZTU1YmIyMCBSMTE6IGZmZmZmZmZmOGZiZTI5NjggUjEyOiBmZmZmOTFkMzM0ZGQ5ODAw
ClsgMTQxNS42MDYwNzhdIFIxMzogMDAwMDAwMDAwMDAwMDAwMCBSMTQ6IDAwMDAwMDAwMDAwMDAw
MDEgUjE1OiAwMDAwMDAwMDAwMDA2NGU0ClsgMTQxNS42MTM0NDVdIEZTOiAgMDAwMDdmODE3ZmUz
MmY4MCgwMDAwKSBHUzpmZmZmOTFiMjdmYzgwMDAwKDAwMDApIGtubEdTOjAwMDAwMDAwMDAwMDAw
MDAKWyAxNDE1LjYyMTc2N10gQ1M6ICAwMDEwIERTOiAwMDAwIEVTOiAwMDAwIENSMDogMDAwMDAw
MDA4MDA1MDAzMwpbIDE0MTUuNjI3NzQ3XSBDUjI6IDAwMDAwMGMxYWQ1OWIwMDAgQ1IzOiAwMDAw
MDE0MDM1ZTIwMDAxIENSNDogMDAwMDAwMDAwMDc3MGVmMApbIDE0MTUuNjM1MTIzXSBQS1JVOiA1
NTU1NTU1NApbIDE0MTUuNjM4MDY5XSBDYWxsIFRyYWNlOgpbIDE0MTUuNjQwNzU3XSAgPFRBU0s+
ClsgMTQxNS42NDMwOThdICA/IF9fd2FybisweDgwLzB4MTMwClsgMTQxNS42NDY1NjBdICA/IGtt
ZW1fY2FjaGVfZnJlZSsweDMwMS8weDNkMApbIDE0MTUuNjUwODk0XSAgPyByZXBvcnRfYnVnKzB4
MTk1LzB4MWEwClsgMTQxNS42NTQ3OTNdICA/IHByYl9yZWFkX3ZhbGlkKzB4MTcvMHgyMApbIDE0
MTUuNjU4ODY4XSAgPyBoYW5kbGVfYnVnKzB4M2MvMHg3MApbIDE0MTUuNjYyNTkyXSAgPyBleGNf
aW52YWxpZF9vcCsweDE0LzB4NzAKWyAxNDE1LjY2NjY2NV0gID8gYXNtX2V4Y19pbnZhbGlkX29w
KzB4MTYvMHgyMApbIDE0MTUuNjcxMDg5XSAgPyBrbWVtX2NhY2hlX2ZyZWUrMHgzMDEvMHgzZDAK
WyAxNDE1LjY3NTQxN10gID8gc2tiX3JlbGVhc2VfZGF0YSsweDEwNy8weDFlMApbIDE0MTUuNjc5
ODQzXSAgdHVuX2RvX3JlYWQrMHg2OC8weDFmMCBbdHVuXQpbIDE0MTUuNjg0MTA1XSAgdHVuX3Jl
Y3Ztc2crMHg3ZS8weDE2MCBbdHVuXQpbIDE0MTUuNjg4MzUwXSAgaGFuZGxlX3J4KzB4M2FiLzB4
NzUwIFt2aG9zdF9uZXRdClsgMTQxNS42OTMwMjhdICA/IGluaXRfbnVtYV9iYWxhbmNpbmcrMHhk
Ny8weDFlMApbIDE0MTUuNjk3NjIzXSAgdmhvc3Rfd29ya2VyKzB4NDIvMHg3MCBbdmhvc3RdClsg
MTQxNS43MDIwNDJdICB2aG9zdF90YXNrX2ZuKzB4NGIvMHhiMApbIDE0MTUuNzA1ODU2XSAgPyBm
aW5pc2hfdGFza19zd2l0Y2guaXNyYS4wKzB4OGYvMHgyYTAKWyAxNDE1LjcxMDk2Nl0gID8gX19w
Znhfdmhvc3RfdGFza19mbisweDEwLzB4MTAKWyAxNDE1LjcxNTQ2MF0gID8gX19wZnhfdmhvc3Rf
dGFza19mbisweDEwLzB4MTAKWyAxNDE1LjcxOTk1M10gIHJldF9mcm9tX2ZvcmsrMHgyZC8weDUw
ClsgMTQxNS43MjM3NDBdICA/IF9fcGZ4X3Zob3N0X3Rhc2tfZm4rMHgxMC8weDEwClsgMTQxNS43
MjgyMTVdICByZXRfZnJvbV9mb3JrX2FzbSsweDFiLzB4MzAKWyAxNDE1LjczMjM0N10gIDwvVEFT
Sz4KWyAxNDE1LjczNDczMF0gLS0tWyBlbmQgdHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tCg==
--0000000000004a926e0614903c93--

