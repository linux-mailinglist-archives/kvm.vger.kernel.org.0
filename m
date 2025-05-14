Return-Path: <kvm+bounces-46419-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC20AB6311
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 08:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10A4A19E78BE
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 06:28:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E554B2010F5;
	Wed, 14 May 2025 06:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZXEEWFNB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92531F4177
	for <kvm@vger.kernel.org>; Wed, 14 May 2025 06:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747204094; cv=none; b=hkrJ0tZrIv3wOYyRsduPpn4Sr7fjGAOrVSpxJqBHfQrF+PtdKW9m4v3V30M8KUXpNdahceomVwJiHpbCFqDkaL9Hiz78J94Edyqvx/RXEwNyr1DsRqYIH+yMQ5dzB1JqSasr45cNQkerhpPSZmAF+N7M5qhM1TUziimvkch2KUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747204094; c=relaxed/simple;
	bh=UQ1J5sAQuLUSnUT79u1IDdk8KzumY3Ko6aSIBtrrU9E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bt//CkPRoWeo4IuuamKz7yRIFFehxZTp0cRnHFBoXNRyWOhX7nv/SJRJJviI+IzW4S5tikwg0oc0IqrcUSB6u6Fg0+S9ergrv3g4GjdHTGRWbpovgCF0/F8TnRsR3W9mRAweNnJXj0jESTzc9wZzvx+/XkJ6Z/2Cf8lDs0FxuB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZXEEWFNB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747204089;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hOp4hY0PMAH5wqsNNGlH3vrlg2J5pgcfFuboWc+PXtg=;
	b=ZXEEWFNByiyuDmW7Od58AQoqi7bvGkBC6OXF8MAXL1cYyencZgg/fpR7IkCk/QPACuvpe9
	ljYN9VmQWNK+zU7wj6Oqy1z5MTPfl03/ElQuCIzq9P6CFV6mrnO5Af+8ryPkMZOzy6ElNJ
	MZ+okzQFpXKXooK6iNIxNGUN8JbZzTc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-mdcT3hEdM4-7yhfKYaegXQ-1; Wed, 14 May 2025 02:28:08 -0400
X-MC-Unique: mdcT3hEdM4-7yhfKYaegXQ-1
X-Mimecast-MFC-AGG-ID: mdcT3hEdM4-7yhfKYaegXQ_1747204087
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-30abb33d1d2so10036247a91.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 23:28:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747204087; x=1747808887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hOp4hY0PMAH5wqsNNGlH3vrlg2J5pgcfFuboWc+PXtg=;
        b=nGIGY9G8cWO0negLootXBzGAKmO1KzF3xoNPcmh3bvb0h4N2OgzezDCQluQ87M5aQt
         d52RA2PG4+86pWS7KWYmf7s5cI0BnxLUds0Gm5liax2NSiddyhgNlgqBjp5HWZvm36b3
         p2l2ddGZ4Z6/je/fTonb2sw2fVDK+8qcjNW+rDSGwWjGafANosijc8lBGJ3j7OGdv4j+
         GaYJBzErmeToApAYNZLMUB0adgmzweRBHfPCFAHEoxYWcvQlYeRuJhBd7Arde3NB3U8O
         fZ10S+tBVyV0I8RoFfCXs51e7FdPYgNFAU6/ZAigr+NybtQgxbI37/+sH/wTwYcqUs99
         9PsA==
X-Forwarded-Encrypted: i=1; AJvYcCVDCPFO+JnqRbzrlLtcfn5mRIaym04D1DeCV8LRgdHfpyJ69+LMk//imz0v91kjOi5AgOY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxgF4I/RqVpFWOOgBDUJyWRhwh6Ybdgl8jSfL3mLR0daH3n31//
	xqtbPvpYCGeLBK/lWVRNgXOZ7skVWt4Pdba+NaM3TigZaDK/86EWCBUCrvNf0JJo5yN7HK47jIR
	8BASftDdj2gMYs5/i5vqeiE74LkdBibIIqWiwGHgoPUBpUswBCk5x4o9btrJ0PQ7jnmffZYQck2
	wJBg00g1Ao8B2Eiq5k1uY4Wymn
X-Gm-Gg: ASbGncvlJ+a/t9j+XtapjJFdtC0rM8FhPV7TX15NsgVjio+0ya2DQaRmUg5IDoKPdp2
	l6/RACxDfRsosZi3u9Hs7AMyIT6ss+PrLFwFNxEtcXqTlaGLgCGHfuT08FdKRnMmlI0YC
X-Received: by 2002:a17:90b:3b4a:b0:2ff:6a5f:9b39 with SMTP id 98e67ed59e1d1-30e2e5dcde5mr3933267a91.18.1747204087120;
        Tue, 13 May 2025 23:28:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGa8v+OcSzRWdhZzNcxoBuSbj+/AdqHp+HfAdjjwy0jvkIl0bUIQMv+O4S+pz9KyLi+opmWvTkyIhYe/KrmvWU=
X-Received: by 2002:a17:90b:3b4a:b0:2ff:6a5f:9b39 with SMTP id
 98e67ed59e1d1-30e2e5dcde5mr3933239a91.18.1747204086621; Tue, 13 May 2025
 23:28:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250404145241.1125078-1-jon@nutanix.com> <CACGkMEsFc-URhXBCGZ1=CTMZKcWPf57pYy1TcyKLL=N65u+F0Q@mail.gmail.com>
 <B32E2C5D-25FB-427F-8567-701C152DFDE6@nutanix.com> <CACGkMEucg5mduA-xoyrTRK5nOkdHvUAkG9fH6KpO=HxMVPYONA@mail.gmail.com>
 <CAJaqyWdhLCNs_B0gcxXHut7xufw23HMR6PaO11mqAQFoGkdfXQ@mail.gmail.com> <92470838-2B98-4FC6-8E5B-A8AF14965D4C@nutanix.com>
In-Reply-To: <92470838-2B98-4FC6-8E5B-A8AF14965D4C@nutanix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Wed, 14 May 2025 14:27:55 +0800
X-Gm-Features: AX0GCFvO5_TynaC7ilLiE_zM1DHi8DARvxgXq012o8cd1y0a6sUXeX2xGypEwtA
Message-ID: <CACGkMEugQPYZuL75i7xBGy9vUmkH=6NN1uhi9wuLa4ruebAcew@mail.gmail.com>
Subject: Re: [PATCH] vhost/net: remove zerocopy support
To: Jon Kohler <jon@nutanix.com>
Cc: Eugenio Perez Martin <eperezma@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Brivio <sbrivio@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 1, 2025 at 9:21=E2=80=AFAM Jon Kohler <jon@nutanix.com> wrote:
>
>
>
> > On Apr 16, 2025, at 6:15=E2=80=AFAM, Eugenio Perez Martin <eperezma@red=
hat.com> wrote:
> >
> > !-------------------------------------------------------------------|
> >  CAUTION: External Email
> >
> > |-------------------------------------------------------------------!
> >
> > On Tue, Apr 8, 2025 at 8:28=E2=80=AFAM Jason Wang <jasowang@redhat.com>=
 wrote:
> >>
> >> On Tue, Apr 8, 2025 at 9:18=E2=80=AFAM Jon Kohler <jon@nutanix.com> wr=
ote:
> >>>
> >>>
> >>>
> >>>> On Apr 6, 2025, at 7:14=E2=80=AFPM, Jason Wang <jasowang@redhat.com>=
 wrote:
> >>>>
> >>>> !-------------------------------------------------------------------=
|
> >>>> CAUTION: External Email
> >>>>
> >>>> |-------------------------------------------------------------------=
!
> >>>>
> >>>> On Fri, Apr 4, 2025 at 10:24=E2=80=AFPM Jon Kohler <jon@nutanix.com>=
 wrote:
> >>>>>
> >>>>> Commit 098eadce3c62 ("vhost_net: disable zerocopy by default") disa=
bled
> >>>>> the module parameter for the handle_tx_zerocopy path back in 2019,
> >>>>> nothing that many downstream distributions (e.g., RHEL7 and later) =
had
> >>>>> already done the same.
> >>>>>
> >>>>> Both upstream and downstream disablement suggest this path is rarel=
y
> >>>>> used.
> >>>>>
> >>>>> Testing the module parameter shows that while the path allows packe=
t
> >>>>> forwarding, the zerocopy functionality itself is broken. On outboun=
d
> >>>>> traffic (guest TX -> external), zerocopy SKBs are orphaned by eithe=
r
> >>>>> skb_orphan_frags_rx() (used with the tun driver via tun_net_xmit())
> >>>>
> >>>> This is by design to avoid DOS.
> >>>
> >>> I understand that, but it makes ZC non-functional in general, as ZC f=
ails
> >>> and immediately increments the error counters.
> >>
> >> The main issue is HOL, but zerocopy may still work in some setups that
> >> don't need to care about HOL. One example the macvtap passthrough
> >> mode.
> >>
> >>>
> >>>>
> >>>>> or
> >>>>> skb_orphan_frags() elsewhere in the stack,
> >>>>
> >>>> Basically zerocopy is expected to work for guest -> remote case, so
> >>>> could we still hit skb_orphan_frags() in this case?
> >>>
> >>> Yes, you=E2=80=99d hit that in tun_net_xmit().
> >>
> >> Only for local VM to local VM communication.
>
> Sure, but the tricky bit here is that if you have a mix of VM-VM and VM-e=
xternal
> traffic patterns, any time the error path is hit, the zc error counter wi=
ll go up.
>
> When that happens, ZC will get silently disabled anyhow, so it leads to s=
poradic
> success / non-deterministic performance.

As discussed, the main issue is safety: a malicious VM can refuse to
receive packets which may cause tx to be stuck. So scarfing
performance for safety is the only way to go. If we can find a way to
fix them, it could be relaxed.

>
> >>
> >>> If you punch a hole in that *and* in the
> >>> zc error counter (such that failed ZC doesn=E2=80=99t disable ZC in v=
host), you get ZC
> >>> from vhost; however, the network interrupt handler under net_tx_actio=
n and
> >>> eventually incurs the memcpy under dev_queue_xmit_nit().
> >>
> >> Well, yes, we need a copy if there's a packet socket. But if there's
> >> no network interface taps, we don't need to do the copy here.
> >>
>
> Agreed on the packet socket side. I recently fixed an issue in lldpd [1] =
that prevented
> this specific case; however, there are still other trip wires spread out =
across the
> stack that would need to be addressed.
>
> [1] https://github.com/lldpd/lldpd/commit/622a91144de4ae487ceebdb333863e9=
f660e0717

I see.

>
> >
> > Hi!
> >
> > I need more time diving into the issues. As Jon mentioned, vhost ZC is
> > so little used I didn't have the chance to experiment with this until
> > now :). But yes, I expect to be able to overcome these for pasta, by
> > adapting buffer sizes or modifying code etc.
>
> Another tricky bit here is that it has been disabled both upstream and do=
wnstream
> for so long, the code naturally has a bit of wrench-in-the-engine.
>
> RE Buffer sizes: I tried this as well, because I think on sufficiently fa=
st systems,
> zero copy gets especially interesting in GSO/TSO cases where you have meg=
a
> payloads.

Yes.

>
> I tried playing around with the good copy value such that ZC restricted i=
tself to
> only lets say 32K payloads and above, and while it *does* work (with enou=
gh
> holes punched in), absolute t-put doesn=E2=80=99t actually go up, its jus=
t that CPU utilization
> goes down a pinch. Not a bad thing for certain, but still not great.
>
> In fact, I found that tput actually went down with this path, even with Z=
C occurring
> successfully, as there was still a mix of ZC and non-ZC because you can o=
nly
> have so many pending at any given time before the copy path kicks in agai=
n.

TCP has hursitisc that may try to coalesce more writes into a larger
packet so we might get "worse" throughput when vhost becomes faster.
For example, only my testing environment, qemu, is faster than vhost
single TCP stream testing of netperf.

>
>
> >
> >>>
> >>> This is no more performant, and in fact is actually worse since the t=
ime spent
> >>> waiting on that memcpy to resolve is longer.
> >>>
> >>>>
> >>>>> as vhost_net does not set
> >>>>> SKBFL_DONT_ORPHAN.
> >>
> >> Maybe we can try to set this as vhost-net can hornor ulimit now.
>
> Yea I tried that, and while it helps kick things further down the stack, =
its not actually
> faster in any testing I=E2=80=99ve drummed up.

Can I see the codes?

>
> >>
> >>>>>
> >>>>> Orphaning enforces a memcpy and triggers the completion callback, w=
hich
> >>>>> increments the failed TX counter, effectively disabling zerocopy ag=
ain.
> >>>>>
> >>>>> Even after addressing these issues to prevent SKB orphaning and err=
or
> >>>>> counter increments, performance remains poor. By default, only 64
> >>>>> messages can be zerocopied, which is immediately exhausted by workl=
oads
> >>>>> like iperf, resulting in most messages being memcpy'd anyhow.
> >>>>>
> >>>>> Additionally, memcpy'd messages do not benefit from the XDP batchin=
g
> >>>>> optimizations present in the handle_tx_copy path.
> >>>>>
> >>>>> Given these limitations and the lack of any tangible benefits, remo=
ve
> >>>>> zerocopy entirely to simplify the code base.
> >>>>>
> >>>>> Signed-off-by: Jon Kohler <jon@nutanix.com>
> >>>>
> >>>> Any chance we can fix those issues? Actually, we had a plan to make
> >>>> use of vhost-net and its tx zerocopy (or even implement the rx
> >>>> zerocopy) in pasta.
> >>>
> >>> Happy to take direction and ideas here, but I don=E2=80=99t see a cle=
ar way to fix these
> >>> issues, without dealing with the assertions that skb_orphan_frags_rx =
calls out.
> >>>
> >>> Said another way, I=E2=80=99d be interested in hearing if there is a =
config where ZC in
> >>> current host-net implementation works, as I was driving myself crazy =
trying to
> >>> reverse engineer.
> >>
> >> See above.
> >>
> >>>
> >>> Happy to collaborate if there is something we could do here.
> >>
> >> Great, we can start here by seeking a way to fix the known issues of
> >> the vhost-net zerocopy code.
> >>
> >
> > Happy to help here :).
> >
> > Jon, could you share more details about the orphan problem so I can
> > speed up the help? For example, can you describe the code changes and
> > the code path that would lead to that assertion of
> > skb_orphan_frags_rx?
> >
> > Thanks!
> >
>
> Sorry for the slow response, getting back from holiday and catching up.
>
> When running through tun.c, there are a handful of places where ZC turns =
into
> a full copy, whether that is in the tun code itself, or in the interrupt =
handler when
> tun xmit is running.
>
> For example, tun_net_xmit mandatorily calls skb_orphan_frags_rx. Anything
> with frags will get this memcpy, which are of course the =E2=80=9Cjuicy=
=E2=80=9D targets here as
> they would take up the most memory bandwidth in general. Nasty catch22 :)
>
> There are also plenty of places that call normal skb_orphan_frags, which
> triggers because vhost doesn=E2=80=99t set SKBFL_DONT_ORPHAN. That=E2=80=
=99s an easy
> fix, but still something to think about.
>
> Then there is the issue of packet sockets, which throw a king sized wrenc=
h into
> this. Its slightly insidious, but it isn=E2=80=99t directly apparent that=
 loading some user
> space app nukes zero copy, but it happens.
>
> See my previous comment about LLDPD, where a simply compiler snafu caused
> one socket option to get silently break, and it then ripped out ZC capabi=
lity. Easy
> fix, but its an example of how this can fall over.
>
> Bottom line, I=E2=80=99d *love****** have ZC work, work well and so on. I=
=E2=80=99m open to ideas
> here :) (up to and including both A) fixing it and B) deleting it)

Zerocopy still has its advantages in some specific setups. Maybe a way
to start is to make it work automatically depending on the lower
setups? For example, enable it by default with macvtap.

Thanks

>


