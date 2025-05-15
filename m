Return-Path: <kvm+bounces-46649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCF76AB7F55
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 09:53:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 677728C4F83
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 07:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8493283FD6;
	Thu, 15 May 2025 07:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YhwdZu4/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C704427FD45
	for <kvm@vger.kernel.org>; Thu, 15 May 2025 07:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747295576; cv=none; b=gxOtVy68ac1zU0oHCwGirQcUcmulCpyePXOAxSFCmez+EtXD7gDM51xkz1ajwP93e149fS9WLKM6BAZDk4CYrSWzcxlXRScnitTNUvm3idA4qABvI62JZy9ZyiMMHzT6cF71dfMg7/uh8M2r6tmyqG2xvnFszzI2POldgy3mZy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747295576; c=relaxed/simple;
	bh=eb+wlR6VhvXrZxjAcmXbXZfUEYlOr+TaIdA3h+BHceE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LOn3GUiuYGZGeqV/kMN7mw6txAFeRz44dPBtvujiXlmRh1RVytnCkJA1yTjN9D0E3ivrLpsCdTKNXzooh8we+9olBMY9qQEmYio0lzBoqtzMR648R48HU9o8/J7iyUp5+5Pog09K0msIfC/5U1lb6gzl8z8JrqIHsoanG0+fLzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YhwdZu4/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747295573;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eb+wlR6VhvXrZxjAcmXbXZfUEYlOr+TaIdA3h+BHceE=;
	b=YhwdZu4/1qF5iy412CBwW36rUBrVdtMM+mCLXyQwyWPvBcQx6hUD0KIs56V2aHc3QqcnC9
	bdu+s9M84Ha5LTwYaDUEsIXRRLbRUWdBheNjcCFJmIsVjFGSq+RicBzbOzCP5OgsmToUht
	iu9N9Lg5pKunJe6lG7klkx6Rh20yFfI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-llz34qRIOkeErqAZ9MbH2Q-1; Thu, 15 May 2025 03:52:51 -0400
X-MC-Unique: llz34qRIOkeErqAZ9MbH2Q-1
X-Mimecast-MFC-AGG-ID: llz34qRIOkeErqAZ9MbH2Q_1747295571
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-30c1c4a8274so768884a91.2
        for <kvm@vger.kernel.org>; Thu, 15 May 2025 00:52:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747295570; x=1747900370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eb+wlR6VhvXrZxjAcmXbXZfUEYlOr+TaIdA3h+BHceE=;
        b=bjuKVUlb8MJcdv8I62PRT27tu3G135b65v1JGfJJcN/YFbjfKguSr9/zK+5vVBJ9Kw
         1dN9zrD/a5JF0zNaxocv4mp4Rso7g8ic3WZjOKAXYumxByked8ZTXvi5FRvA5xLq3xeB
         FAmN7p5AUJsIcNFH613KA0VfYz8fkA8gnh4iNqlejNLmDlH7uMAx+Lh6r47qjpFRr48d
         mfa/fQkZHIaYUk1X/0+Xl9AlXs/zK7HyrPlIOUbg5b83qxM/UbCjfJBK+hEXjRmqkFGK
         Oi9mXUqsg9XLRjr4BPof99+6k4iQ1w6eS0ZYkYp4z9ijZP7sp4gyVwPHG4beXyzmQsKo
         X7NA==
X-Forwarded-Encrypted: i=1; AJvYcCXFYwkenxWwE0t/YIjOrHKidMVa+2JraIR2MqONknEdckh4IzHBM3JCIIgfBGXcB6BJAhg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzSlLbEKetTk+dMneBJQWxDmpufOQJWsJm9U7aaTZFfb1Z2lCrG
	y0CjBHxgTkzje8LQEky7Sdj0/q+0R1kvz9ey0lAEfmlEsxjET/nTOQ+gfLqULgvL7o6rhlJxcvy
	4wBJqgfDULRqULK6NuLZr46jSGHasmRom0rtwq4X3oHMFqVZO4T0N3e8R0XebWktJ4NVvYCDh/h
	uxXQqEkHjAlcIFFRKx38R1IxBx
X-Gm-Gg: ASbGncsoU0jxiygG3KeHdqc0SjCVvlh+mq1LOmeSdqCFtNRuFafcNXacitfWYrWxXhu
	sc/NW27O/oh6jue59DbUw9I9bnm7fWXAHStpRmImZbeu1zqahujxeBBaUfAya5t2aDXwd
X-Received: by 2002:a17:90b:5748:b0:30e:5c7f:5d26 with SMTP id 98e67ed59e1d1-30e5c7f5e1cmr1092165a91.24.1747295570395;
        Thu, 15 May 2025 00:52:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEPfseK+eDrNin6aeBitCZZLriHMOdldIb61D6rL2kRvicPYUO6lNTIgEIIN2iOKGqmJOl/hc7b+UCsh2aPCts=
X-Received: by 2002:a17:90b:5748:b0:30e:5c7f:5d26 with SMTP id
 98e67ed59e1d1-30e5c7f5e1cmr1092136a91.24.1747295569920; Thu, 15 May 2025
 00:52:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250404145241.1125078-1-jon@nutanix.com> <CACGkMEsFc-URhXBCGZ1=CTMZKcWPf57pYy1TcyKLL=N65u+F0Q@mail.gmail.com>
 <B32E2C5D-25FB-427F-8567-701C152DFDE6@nutanix.com> <CACGkMEucg5mduA-xoyrTRK5nOkdHvUAkG9fH6KpO=HxMVPYONA@mail.gmail.com>
 <CAJaqyWdhLCNs_B0gcxXHut7xufw23HMR6PaO11mqAQFoGkdfXQ@mail.gmail.com>
 <92470838-2B98-4FC6-8E5B-A8AF14965D4C@nutanix.com> <A2A66437-60B2-491E-96F7-CD302E90452F@nutanix.com>
In-Reply-To: <A2A66437-60B2-491E-96F7-CD302E90452F@nutanix.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Thu, 15 May 2025 09:52:12 +0200
X-Gm-Features: AX0GCFvxwoG_KF2kIsCofHB3OnMAdD648vC3tjuloR2Wyw6ADVoQtW7FrhQDNsw
Message-ID: <CAJaqyWcNNFRnFmmkEHhOPGWAL05P1EO1ebMJY8+YUC0jxyq3hg@mail.gmail.com>
Subject: Re: [PATCH] vhost/net: remove zerocopy support
To: Jon Kohler <jon@nutanix.com>
Cc: Jason Wang <jasowang@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Brivio <sbrivio@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2025 at 5:21=E2=80=AFPM Jon Kohler <jon@nutanix.com> wrote:
>
>
>
> > On Apr 30, 2025, at 9:21=E2=80=AFPM, Jon Kohler <jon@nutanix.com> wrote=
:
> >
> >
> >
> >> On Apr 16, 2025, at 6:15=E2=80=AFAM, Eugenio Perez Martin <eperezma@re=
dhat.com> wrote:
> >>
> >> !-------------------------------------------------------------------|
> >> CAUTION: External Email
> >>
> >> |-------------------------------------------------------------------!
> >>
> >> On Tue, Apr 8, 2025 at 8:28=E2=80=AFAM Jason Wang <jasowang@redhat.com=
> wrote:
> >>>
> >>> On Tue, Apr 8, 2025 at 9:18=E2=80=AFAM Jon Kohler <jon@nutanix.com> w=
rote:
> >>>>
> >>>>
> >>>>
> >>>>> On Apr 6, 2025, at 7:14=E2=80=AFPM, Jason Wang <jasowang@redhat.com=
> wrote:
> >>>>>
> >>>>> !------------------------------------------------------------------=
-|
> >>>>> CAUTION: External Email
> >>>>>
> >>>>> |------------------------------------------------------------------=
-!
> >>>>>
> >>>>> On Fri, Apr 4, 2025 at 10:24=E2=80=AFPM Jon Kohler <jon@nutanix.com=
> wrote:
> >>>>>>
> >>>>>> Commit 098eadce3c62 ("vhost_net: disable zerocopy by default") dis=
abled
> >>>>>> the module parameter for the handle_tx_zerocopy path back in 2019,
> >>>>>> nothing that many downstream distributions (e.g., RHEL7 and later)=
 had
> >>>>>> already done the same.
> >>>>>>
> >>>>>> Both upstream and downstream disablement suggest this path is rare=
ly
> >>>>>> used.
> >>>>>>
> >>>>>> Testing the module parameter shows that while the path allows pack=
et
> >>>>>> forwarding, the zerocopy functionality itself is broken. On outbou=
nd
> >>>>>> traffic (guest TX -> external), zerocopy SKBs are orphaned by eith=
er
> >>>>>> skb_orphan_frags_rx() (used with the tun driver via tun_net_xmit()=
)
> >>>>>
> >>>>> This is by design to avoid DOS.
> >>>>
> >>>> I understand that, but it makes ZC non-functional in general, as ZC =
fails
> >>>> and immediately increments the error counters.
> >>>
> >>> The main issue is HOL, but zerocopy may still work in some setups tha=
t
> >>> don't need to care about HOL. One example the macvtap passthrough
> >>> mode.
> >>>
> >>>>
> >>>>>
> >>>>>> or
> >>>>>> skb_orphan_frags() elsewhere in the stack,
> >>>>>
> >>>>> Basically zerocopy is expected to work for guest -> remote case, so
> >>>>> could we still hit skb_orphan_frags() in this case?
> >>>>
> >>>> Yes, you=E2=80=99d hit that in tun_net_xmit().
> >>>
> >>> Only for local VM to local VM communication.
> >
> > Sure, but the tricky bit here is that if you have a mix of VM-VM and VM=
-external
> > traffic patterns, any time the error path is hit, the zc error counter =
will go up.
> >
> > When that happens, ZC will get silently disabled anyhow, so it leads to=
 sporadic
> > success / non-deterministic performance.
> >
> >>>
> >>>> If you punch a hole in that *and* in the
> >>>> zc error counter (such that failed ZC doesn=E2=80=99t disable ZC in =
vhost), you get ZC
> >>>> from vhost; however, the network interrupt handler under net_tx_acti=
on and
> >>>> eventually incurs the memcpy under dev_queue_xmit_nit().
> >>>
> >>> Well, yes, we need a copy if there's a packet socket. But if there's
> >>> no network interface taps, we don't need to do the copy here.
> >>>
> >
> > Agreed on the packet socket side. I recently fixed an issue in lldpd [1=
] that prevented
> > this specific case; however, there are still other trip wires spread ou=
t across the
> > stack that would need to be addressed.
> >
> > [1] https://github.com/lldpd/lldpd/commit/622a91144de4ae487ceebdb333863=
e9f660e0717
> >
> >>
> >> Hi!
> >>
> >> I need more time diving into the issues. As Jon mentioned, vhost ZC is
> >> so little used I didn't have the chance to experiment with this until
> >> now :). But yes, I expect to be able to overcome these for pasta, by
> >> adapting buffer sizes or modifying code etc.
> >
> > Another tricky bit here is that it has been disabled both upstream and =
downstream
> > for so long, the code naturally has a bit of wrench-in-the-engine.
> >
> > RE Buffer sizes: I tried this as well, because I think on sufficiently =
fast systems,
> > zero copy gets especially interesting in GSO/TSO cases where you have m=
ega
> > payloads.
> >
> > I tried playing around with the good copy value such that ZC restricted=
 itself to
> > only lets say 32K payloads and above, and while it *does* work (with en=
ough
> > holes punched in), absolute t-put doesn=E2=80=99t actually go up, its j=
ust that CPU utilization
> > goes down a pinch. Not a bad thing for certain, but still not great.
> >
> > In fact, I found that tput actually went down with this path, even with=
 ZC occurring
> > successfully, as there was still a mix of ZC and non-ZC because you can=
 only
> > have so many pending at any given time before the copy path kicks in ag=
ain.
> >
> >
> >>
> >>>>
> >>>> This is no more performant, and in fact is actually worse since the =
time spent
> >>>> waiting on that memcpy to resolve is longer.
> >>>>
> >>>>>
> >>>>>> as vhost_net does not set
> >>>>>> SKBFL_DONT_ORPHAN.
> >>>
> >>> Maybe we can try to set this as vhost-net can hornor ulimit now.
> >
> > Yea I tried that, and while it helps kick things further down the stack=
, its not actually
> > faster in any testing I=E2=80=99ve drummed up.
> >
> >>>
> >>>>>>
> >>>>>> Orphaning enforces a memcpy and triggers the completion callback, =
which
> >>>>>> increments the failed TX counter, effectively disabling zerocopy a=
gain.
> >>>>>>
> >>>>>> Even after addressing these issues to prevent SKB orphaning and er=
ror
> >>>>>> counter increments, performance remains poor. By default, only 64
> >>>>>> messages can be zerocopied, which is immediately exhausted by work=
loads
> >>>>>> like iperf, resulting in most messages being memcpy'd anyhow.
> >>>>>>
> >>>>>> Additionally, memcpy'd messages do not benefit from the XDP batchi=
ng
> >>>>>> optimizations present in the handle_tx_copy path.
> >>>>>>
> >>>>>> Given these limitations and the lack of any tangible benefits, rem=
ove
> >>>>>> zerocopy entirely to simplify the code base.
> >>>>>>
> >>>>>> Signed-off-by: Jon Kohler <jon@nutanix.com>
> >>>>>
> >>>>> Any chance we can fix those issues? Actually, we had a plan to make
> >>>>> use of vhost-net and its tx zerocopy (or even implement the rx
> >>>>> zerocopy) in pasta.
> >>>>
> >>>> Happy to take direction and ideas here, but I don=E2=80=99t see a cl=
ear way to fix these
> >>>> issues, without dealing with the assertions that skb_orphan_frags_rx=
 calls out.
> >>>>
> >>>> Said another way, I=E2=80=99d be interested in hearing if there is a=
 config where ZC in
> >>>> current host-net implementation works, as I was driving myself crazy=
 trying to
> >>>> reverse engineer.
> >>>
> >>> See above.
> >>>
> >>>>
> >>>> Happy to collaborate if there is something we could do here.
> >>>
> >>> Great, we can start here by seeking a way to fix the known issues of
> >>> the vhost-net zerocopy code.
> >>>
> >>
> >> Happy to help here :).
> >>
> >> Jon, could you share more details about the orphan problem so I can
> >> speed up the help? For example, can you describe the code changes and
> >> the code path that would lead to that assertion of
> >> skb_orphan_frags_rx?
> >>
> >> Thanks!
> >>
> >
> > Sorry for the slow response, getting back from holiday and catching up.
> >
> > When running through tun.c, there are a handful of places where ZC turn=
s into
> > a full copy, whether that is in the tun code itself, or in the interrup=
t handler when
> > tun xmit is running.
> >
> > For example, tun_net_xmit mandatorily calls skb_orphan_frags_rx. Anythi=
ng
> > with frags will get this memcpy, which are of course the =E2=80=9Cjuicy=
=E2=80=9D targets here as
> > they would take up the most memory bandwidth in general. Nasty catch22 =
:)
> >
> > There are also plenty of places that call normal skb_orphan_frags, whic=
h
> > triggers because vhost doesn=E2=80=99t set SKBFL_DONT_ORPHAN. That=E2=
=80=99s an easy
> > fix, but still something to think about.
> >
> > Then there is the issue of packet sockets, which throw a king sized wre=
nch into
> > this. Its slightly insidious, but it isn=E2=80=99t directly apparent th=
at loading some user
> > space app nukes zero copy, but it happens.
> >
> > See my previous comment about LLDPD, where a simply compiler snafu caus=
ed
> > one socket option to get silently break, and it then ripped out ZC capa=
bility. Easy
> > fix, but its an example of how this can fall over.
> >
> > Bottom line, I=E2=80=99d *love****** have ZC work, work well and so on.=
 I=E2=80=99m open to ideas
> > here :) (up to and including both A) fixing it and B) deleting it)
>
> Hey Eugenio - wondering if you had a chance to check out my notes on this=
?
>

Sorry I thought I was going to have the code ready by now :). I'll
need more time to go through the items.


