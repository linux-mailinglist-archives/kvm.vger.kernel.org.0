Return-Path: <kvm+bounces-47100-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 462F7ABD468
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 12:20:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 952D48A5601
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 10:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D560826A0FD;
	Tue, 20 May 2025 10:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I+m3IaZE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6826D25D1F9
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 10:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747736424; cv=none; b=r3D2m2l1FeuDpdR7TCMYH98lq3lxrqcu+u9d8nlkIv61k4UjLea0GvZ7ZSWO6GRbvHxGM3+xy0VGF95fxSDjRtqOag8kyH0dLNGJ/68bqtinSb4R4vb+dbgdDUm9nKNK1tr8l2X5tH3aSkZC2rbRENwPAkMq48QzJ0J43WP8O0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747736424; c=relaxed/simple;
	bh=VLqZKYVWp3pwRQ8Qv/+9FpUNa5lx7oCx3DjjfaM1bAY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uRi14at8ox9dEg0kfw3Hy0FJ1LqQXPFdKBJAo1OSldQhfYI+oVvGp+Lb4cQs3qH7qMcHDgIrkFtcx9937S07eqY3dUD/jUws0RBN9Tdkjj4Yihns0auobFx2MhQpkENmkzZNvJBZp3aUxXVauEX1qpfC0XHGGOKPJ6yaeYhauxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=I+m3IaZE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747736421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VLqZKYVWp3pwRQ8Qv/+9FpUNa5lx7oCx3DjjfaM1bAY=;
	b=I+m3IaZE9Q9WifGMyCWGTTlW2v2+UHmoWxNja/m1oB/busTyX1E8NenU1a0HzjKVN173Sc
	FAnpu1B3TY+hza3S/0emQ3h/iNUDoC6a8xFCR7lHYqbOf5WBMzCZB36j5frZpmWW6P5HKF
	TVY2FsGz68RYgodMptPW35lazHgE60g=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-eFENWP3YO0G3SAf73hCaeA-1; Tue, 20 May 2025 06:20:20 -0400
X-MC-Unique: eFENWP3YO0G3SAf73hCaeA-1
X-Mimecast-MFC-AGG-ID: eFENWP3YO0G3SAf73hCaeA_1747736419
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-708b13627abso90103837b3.2
        for <kvm@vger.kernel.org>; Tue, 20 May 2025 03:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747736419; x=1748341219;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VLqZKYVWp3pwRQ8Qv/+9FpUNa5lx7oCx3DjjfaM1bAY=;
        b=K+y0EhAjF2ro/f+fT7IQLLRvIkooT4ZvuM1zDQ0/PxtFwPtXVe/VRh/CKPuWpH2mPb
         uDHaahFOKJrNqOvxMQ/i2Tg5dKOlldnoM1gG84LgTRFC1eRaJZCE+zOX/td22mdD9XNM
         EHBdq8RB7ntlPdjBIZHr2MJtKsKZbrdu4Kv3uCXAe82ReXRFFkmMmIUQNmR8mWJTAr2M
         0mYkKeeKMPhTC4+WlbOdJxOw5lJ1tjDB0oN+dnyZS/UsK9fDQnM3TLgEPAqVfnmIjc8V
         Zd8T0LNNK2miv0PAV+JkbqwxMl6WdSnkF0l0/3WNYxKa++HWMsMHJslCCV6FstSL4NS8
         j5qw==
X-Forwarded-Encrypted: i=1; AJvYcCVP/HvD2HtGzR6Jiy57Mg+DbggEasx5FG92yrh7+9UnUpWeSREVodEqLs/3frUgsHQO2VM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/qMMacVkdWbAnOmpJ9BadRnrBxLjY3UV+ArD6WzaRD9XJdfWa
	aSR9gYbmJug2in+SzoWMuxxH24zTxU8wFB2Vvwy+iNGQVULnBcRbRzTN7+3RqEtGyS8lCjxVutY
	5MqDpOjR2HoUx7CmhXCp+jNirBDhgG0O8mWauK+WShxvPz/jrVMrGB9vOhPMEF6VEQypHojNeZ5
	F+SW96qPKG5/IpXFOqlH5EGHnOmWMc
X-Gm-Gg: ASbGnculVsQnci96BMcXsUdPwKul/ctnBY4gOsgaApDVyYTtcTto9S8mQZBWrhme4S4
	I/x1F8vHfixUsWOU7ZzkjvEx7Ev/LBtjdunp85CVqTwu5kEvAm7EPzKUAr5yuUuM1eE0=
X-Received: by 2002:a05:690c:89:b0:708:a265:93ab with SMTP id 00721157ae682-70ca7bc940dmr238507027b3.38.1747736419539;
        Tue, 20 May 2025 03:20:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIrLhXuLV+dgl+6nHQXYzcxdnRi1KlUM2uZdWnr9UwnY+2xxpw/9FIq+WSPvcUphoTIc9kxZUnbcKv5l5kBws=
X-Received: by 2002:a05:690c:89:b0:708:a265:93ab with SMTP id
 00721157ae682-70ca7bc940dmr238506537b3.38.1747736418973; Tue, 20 May 2025
 03:20:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co>
 <20250501-vsock-linger-v4-3-beabbd8a0847@rbox.co> <g5wemyogxthe43rkigufv7p5wrkegbdxbleujlsrk45dmbmm4l@qdynsbqfjwbk>
 <CAGxU2F59O7QK2Q7TeaP6GU9wHrDMTpcO94TKz72UQndXfgNLVA@mail.gmail.com>
 <ff959c3e-4c47-4f93-8ab8-32446bb0e0d0@rbox.co> <CAGxU2F77OT5_Pd6EUF1QcvPDC38e-nuhfwKmPSTau262Eey5vQ@mail.gmail.com>
 <720f6986-8b32-4d00-b309-66a6f0c1ca40@rbox.co> <37c5ymzjhr3pivvx6sygsdqmrr72solzqltwhcsiyvvc3iagiy@3vc3rbxrbcab>
 <CAGxU2F4ue9UxZd1_wB2D=Oww6W9r7kTBPVjjbnm24Lywz+0wSA@mail.gmail.com>
In-Reply-To: <CAGxU2F4ue9UxZd1_wB2D=Oww6W9r7kTBPVjjbnm24Lywz+0wSA@mail.gmail.com>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Tue, 20 May 2025 12:20:07 +0200
X-Gm-Features: AX0GCFvEf5TKMk_xJuszzqQAjXr1gJnrN_usz3ZZR_hOZflwpYSEOq0n4Sep-9Y
Message-ID: <CAGxU2F7z-Fj4-_154KeYYb6YeBe1uZCc52Nq0afYAR0ViVv0Ug@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/3] vsock/test: Expand linger test to ensure
 close() does not misbehave
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 20 May 2025 at 11:01, Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> On Tue, 20 May 2025 at 10:54, Stefano Garzarella <sgarzare@redhat.com> wrote:
> >
> > On Mon, May 12, 2025 at 02:23:12PM +0200, Michal Luczaj wrote:
> > >On 5/7/25 10:26, Stefano Garzarella wrote:
> > >> On Wed, 7 May 2025 at 00:47, Michal Luczaj <mhal@rbox.co> wrote:
> > >>>
> > >>> On 5/6/25 11:46, Stefano Garzarella wrote:
> > >>>> On Tue, 6 May 2025 at 11:43, Stefano Garzarella <sgarzare@redhat.com> wrote:
> > >>>>>
> > >>>>> On Thu, May 01, 2025 at 10:05:24AM +0200, Michal Luczaj wrote:
> > >>>>>> There was an issue with SO_LINGER: instead of blocking until all queued
> > >>>>>> messages for the socket have been successfully sent (or the linger timeout
> > >>>>>> has been reached), close() would block until packets were handled by the
> > >>>>>> peer.
> > >>>>>
> > >>>>> This is a new behaviour that only new kernels will follow, so I think
> > >>>>> it is better to add a new test instead of extending a pre-existing test
> > >>>>> that we described as "SOCK_STREAM SO_LINGER null-ptr-deref".
> > >>>>>
> > >>>>> The old test should continue to check the null-ptr-deref also for old
> > >>>>> kernels, while the new test will check the new behaviour, so we can skip
> > >>>>> the new test while testing an old kernel.
> > >>>
> > >>> Right, I'll split it.
> > >>>
> > >>>> I also saw that we don't have any test to verify that actually the
> > >>>> lingering is working, should we add it since we are touching it?
> > >>>
> > >>> Yeah, I agree we should. Do you have any suggestion how this could be done
> > >>> reliably?
> > >>
> > >> Can we play with SO_VM_SOCKETS_BUFFER_SIZE like in credit-update tests?
> > >>
> > >> One peer can set it (e.g. to 1k), accept the connection, but without
> > >> read anything. The other peer can set the linger timeout, send more
> > >> bytes than the buffer size set by the receiver.
> > >> At this point the extra bytes should stay on the sender socket buffer,
> > >> so we can do the close() and it should time out, and we can check if
> > >> it happens.
> > >>
> > >> WDYT?
> > >
> > >Haven't we discussed this approach in [1]? I've reported that I can't make
> >
> > Sorry, I forgot. What was the conclusion? Why this can't work?
> >
> > >it work. But maybe I'm misunderstanding something, please see the code
> > >below.
> >
> > What I should check in the code below?
>
> Okay, I see the send() is blocking (please next time explain better
> the issue, etc.)
>
> I don't want to block this series, so feel free to investigate that
> later if we have a way to test it. If I'll find some time, I'll try to
> check if we have a way.

I've tried to take a look, and no, there's no easy way except to
somehow slow down the receiver, but I don't think we have a reliable
way to do that, so I can't think of anything for now. Let's skip it
(I'll try to remember ;-)

Thanks,
Stefano


