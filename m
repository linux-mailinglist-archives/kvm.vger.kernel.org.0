Return-Path: <kvm+bounces-43416-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ADAC8A8B68C
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 12:16:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34A693A7EC9
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 10:16:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1484D2459DF;
	Wed, 16 Apr 2025 10:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="btdDQsaM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF37238177
	for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 10:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744798589; cv=none; b=EkfJLEDVctirTINQzUzKkwYCwPYjZ5JYHBzLn7rlaQS82KCrtMRPzG0/XiZqZ0s/DIBTiYJgaA13h2/uCXcxLlC2Pdvo/F6NwiF8ubL/n/V3dMAsIVGb6fjoGFgIKCm6sz1JH8HHaB8EcZI6MfJKWiDEQkd18Tvm1PhV/OyqoHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744798589; c=relaxed/simple;
	bh=LR5XHJIsv4KSkncTHnzjZxFzOCeJ57mh3HG+NkOwuJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WR4/d+juPVQ/uBPIlx66FUgIwbAdrQYn2vRpHNdPbnwK3EOlETgUCDFgqwfbqTaOtofNuo7Wj8iHZS0STDDCYHzX2v7KdjkBcawaPdr6wK5JWaHlMmQb+XZcj8ePIMwvWKTVy4uvp0ffG3aM8PE6SphliUKmzS6rs5COTWPZyc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=btdDQsaM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744798586;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DyNtBtrm5YLzS/2qKU4Cviogs091o5wq6s+fDtuLR4s=;
	b=btdDQsaM47XOm7K32M/toCA9tZQCddngDcst1e5ecPMNjFOWY+ia1Yd1za/hLO+EApINu7
	+18Qznz1TKXQKvo2vGMsS/Li8D8e+4Mz7OyeqISSVFwWeNXXZ4X8c0FRXebp/6I/jZsOpi
	eck3LFK/G/e8nvRKMBxuAuKedCRTd8Y=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-197-CV0uFXklMdaQFd0jrxGGfA-1; Wed, 16 Apr 2025 06:16:24 -0400
X-MC-Unique: CV0uFXklMdaQFd0jrxGGfA-1
X-Mimecast-MFC-AGG-ID: CV0uFXklMdaQFd0jrxGGfA_1744798584
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-306b51e30ffso5699704a91.1
        for <kvm@vger.kernel.org>; Wed, 16 Apr 2025 03:16:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744798584; x=1745403384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DyNtBtrm5YLzS/2qKU4Cviogs091o5wq6s+fDtuLR4s=;
        b=Gb/wE0VG1ENJ5eLIiSophNeX73Wh24/WfoXszqcWr+O76GztfBeQJJTSIvQ4aveZyg
         TF+oVwTu0bqaYKSRSiLBQR5xs27Xroy2Sr356wfWRNnGxhudFqjYfrSvnDc1BzJyaOjg
         KG89+bwqHNdlb/QA+SFIV8R5SLuHfsQy2m39mMRLZ6JwfUJBNoXN7XObTY9muGpRf7x/
         vBVLRpo7W6RU6eMxESOifqMTg5JQiZouWV4B5RUpvGG13KuRTETiYOTHg5jVA9uKYATu
         I1ZOHPJwKQD22phv39LYfIA36Al1ctChyYLghuP89waTN6nZFFbRuzOM9bJa5G4AxTpl
         XX9A==
X-Forwarded-Encrypted: i=1; AJvYcCVryXIQZKReECOolsKixwu75Cb0Mm+rJ31kynp+GTvozhSY4Aj71cDpD5Q8sHUlERneO1Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/5r6dh0N3SKbNFdImfX1ZFnK1axezraejjCxGjX2Tr5VLQyu2
	DMJEL6S7dDFWGlDUp3SI5+8JfnuPaedtyxfzoB08Uo8UGQ8TzGI4m7pkxBU491CergE+aiJa/qk
	0ck8eBkv8zNuF7nd991Npp+92KGqCp8unlbnv5dJt1FaiLVQWC4moQFfKsk42kjMOfEQK8H7tol
	3K0pN9N2RhBwuEp9LF2Y33dbhM
X-Gm-Gg: ASbGnctiYzDJ0VQFulJq/QESZroLkcCgzinZBQvFBOtzibOZESjGB2fBsWv2qfYXT3M
	Azb02YljmzoHpAOmipPzIxmt2UCYnYoDNLXaHn2QkIW8d5cbMoqBlkENy37nUU9j3xc8=
X-Received: by 2002:a17:90b:548d:b0:2ff:6488:e01c with SMTP id 98e67ed59e1d1-3086416ec3emr2001432a91.29.1744798583594;
        Wed, 16 Apr 2025 03:16:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5B8+MIOMuQKL/Q5Vh62fe3WjdrGJl1cNAbpCB38cbA9+YtL9G5ILgxGaQgBlKd18KrUdkzh0QkQQPJug9YUo=
X-Received: by 2002:a17:90b:548d:b0:2ff:6488:e01c with SMTP id
 98e67ed59e1d1-3086416ec3emr2001387a91.29.1744798583226; Wed, 16 Apr 2025
 03:16:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250404145241.1125078-1-jon@nutanix.com> <CACGkMEsFc-URhXBCGZ1=CTMZKcWPf57pYy1TcyKLL=N65u+F0Q@mail.gmail.com>
 <B32E2C5D-25FB-427F-8567-701C152DFDE6@nutanix.com> <CACGkMEucg5mduA-xoyrTRK5nOkdHvUAkG9fH6KpO=HxMVPYONA@mail.gmail.com>
In-Reply-To: <CACGkMEucg5mduA-xoyrTRK5nOkdHvUAkG9fH6KpO=HxMVPYONA@mail.gmail.com>
From: Eugenio Perez Martin <eperezma@redhat.com>
Date: Wed, 16 Apr 2025 12:15:46 +0200
X-Gm-Features: ATxdqUHCH-V7i7CU2wT16iuVXDT1SGacdB6YBRKLTHXg-jyKPzbjSDLkTwgL2pg
Message-ID: <CAJaqyWdhLCNs_B0gcxXHut7xufw23HMR6PaO11mqAQFoGkdfXQ@mail.gmail.com>
Subject: Re: [PATCH] vhost/net: remove zerocopy support
To: Jason Wang <jasowang@redhat.com>
Cc: Jon Kohler <jon@nutanix.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Stefano Brivio <sbrivio@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 8, 2025 at 8:28=E2=80=AFAM Jason Wang <jasowang@redhat.com> wro=
te:
>
> On Tue, Apr 8, 2025 at 9:18=E2=80=AFAM Jon Kohler <jon@nutanix.com> wrote=
:
> >
> >
> >
> > > On Apr 6, 2025, at 7:14=E2=80=AFPM, Jason Wang <jasowang@redhat.com> =
wrote:
> > >
> > > !-------------------------------------------------------------------|
> > >  CAUTION: External Email
> > >
> > > |-------------------------------------------------------------------!
> > >
> > > On Fri, Apr 4, 2025 at 10:24=E2=80=AFPM Jon Kohler <jon@nutanix.com> =
wrote:
> > >>
> > >> Commit 098eadce3c62 ("vhost_net: disable zerocopy by default") disab=
led
> > >> the module parameter for the handle_tx_zerocopy path back in 2019,
> > >> nothing that many downstream distributions (e.g., RHEL7 and later) h=
ad
> > >> already done the same.
> > >>
> > >> Both upstream and downstream disablement suggest this path is rarely
> > >> used.
> > >>
> > >> Testing the module parameter shows that while the path allows packet
> > >> forwarding, the zerocopy functionality itself is broken. On outbound
> > >> traffic (guest TX -> external), zerocopy SKBs are orphaned by either
> > >> skb_orphan_frags_rx() (used with the tun driver via tun_net_xmit())
> > >
> > > This is by design to avoid DOS.
> >
> > I understand that, but it makes ZC non-functional in general, as ZC fai=
ls
> > and immediately increments the error counters.
>
> The main issue is HOL, but zerocopy may still work in some setups that
> don't need to care about HOL. One example the macvtap passthrough
> mode.
>
> >
> > >
> > >> or
> > >> skb_orphan_frags() elsewhere in the stack,
> > >
> > > Basically zerocopy is expected to work for guest -> remote case, so
> > > could we still hit skb_orphan_frags() in this case?
> >
> > Yes, you=E2=80=99d hit that in tun_net_xmit().
>
> Only for local VM to local VM communication.
>
> > If you punch a hole in that *and* in the
> > zc error counter (such that failed ZC doesn=E2=80=99t disable ZC in vho=
st), you get ZC
> > from vhost; however, the network interrupt handler under net_tx_action =
and
> > eventually incurs the memcpy under dev_queue_xmit_nit().
>
> Well, yes, we need a copy if there's a packet socket. But if there's
> no network interface taps, we don't need to do the copy here.
>

Hi!

I need more time diving into the issues. As Jon mentioned, vhost ZC is
so little used I didn't have the chance to experiment with this until
now :). But yes, I expect to be able to overcome these for pasta, by
adapting buffer sizes or modifying code etc.

> >
> > This is no more performant, and in fact is actually worse since the tim=
e spent
> > waiting on that memcpy to resolve is longer.
> >
> > >
> > >> as vhost_net does not set
> > >> SKBFL_DONT_ORPHAN.
>
> Maybe we can try to set this as vhost-net can hornor ulimit now.
>
> > >>
> > >> Orphaning enforces a memcpy and triggers the completion callback, wh=
ich
> > >> increments the failed TX counter, effectively disabling zerocopy aga=
in.
> > >>
> > >> Even after addressing these issues to prevent SKB orphaning and erro=
r
> > >> counter increments, performance remains poor. By default, only 64
> > >> messages can be zerocopied, which is immediately exhausted by worklo=
ads
> > >> like iperf, resulting in most messages being memcpy'd anyhow.
> > >>
> > >> Additionally, memcpy'd messages do not benefit from the XDP batching
> > >> optimizations present in the handle_tx_copy path.
> > >>
> > >> Given these limitations and the lack of any tangible benefits, remov=
e
> > >> zerocopy entirely to simplify the code base.
> > >>
> > >> Signed-off-by: Jon Kohler <jon@nutanix.com>
> > >
> > > Any chance we can fix those issues? Actually, we had a plan to make
> > > use of vhost-net and its tx zerocopy (or even implement the rx
> > > zerocopy) in pasta.
> >
> > Happy to take direction and ideas here, but I don=E2=80=99t see a clear=
 way to fix these
> > issues, without dealing with the assertions that skb_orphan_frags_rx ca=
lls out.
> >
> > Said another way, I=E2=80=99d be interested in hearing if there is a co=
nfig where ZC in
> > current host-net implementation works, as I was driving myself crazy tr=
ying to
> > reverse engineer.
>
> See above.
>
> >
> > Happy to collaborate if there is something we could do here.
>
> Great, we can start here by seeking a way to fix the known issues of
> the vhost-net zerocopy code.
>

Happy to help here :).

Jon, could you share more details about the orphan problem so I can
speed up the help? For example, can you describe the code changes and
the code path that would lead to that assertion of
skb_orphan_frags_rx?

Thanks!


