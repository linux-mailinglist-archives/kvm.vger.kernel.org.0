Return-Path: <kvm+bounces-21907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21C459371B7
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 03:02:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 396F21C20E72
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 01:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79E6D4A3F;
	Fri, 19 Jul 2024 01:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TCCITDoZ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4445680
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 01:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721350936; cv=none; b=owe/tlZCzGRtFY1AZOPg4/Q6EIjvuCNqvsp4SyBTiFP8xae85e1xwi/hFE4gPWJ8gYyzhrAxXtsobFKFtjdxzQ0EUXLpuefHId2k0+9uq92wfkl0t/CKt9N8W75M14TYCeHAiO9Wmbc2ii55JFiP8jllCB1jqpU8RtIWCYuorNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721350936; c=relaxed/simple;
	bh=egPWD6SvkPUOxMbhJVXX/ZmlFwvqOXO8b8h7S1FD3o8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ndjDfe4zFOobUYsclLZL9NpL1+ukEE/D7ZYntormOwVGe6pFkHmjXJ9LobZ81mH92O5GkBT/thXMtVF3xKiMaoHfA/LEwi6jcDcc+c1RtLYygkpr6EJb3jEUt00JaKrQZ9KVFY9CXRJJQ0Io8+W95FAw+OSv6iNQTlQBbv3YQfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TCCITDoZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721350932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Juhk1rxXqcv0LvjBmmBek/yRx3F0GQ+A2PArt9J+ciU=;
	b=TCCITDoZZAxLWUR9fMipuChb0Whecd3AzOb5ksAB4z2aEZdkvNPK3oOGxKl/a0TL0TVMww
	85x6BJ95FH6VpeqcXptRj1r12hUE5IDkulXiUwT099V/HZjgqkXCUNSGur+IBwjwtjruag
	Bm7rqN9LXQYRSwiUCStLRc2QZTeRnDE=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-GJvo7p2nP7ihXt_BfHB_gQ-1; Thu, 18 Jul 2024 21:02:11 -0400
X-MC-Unique: GJvo7p2nP7ihXt_BfHB_gQ-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-70b09456066so367641b3a.0
        for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 18:02:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721350930; x=1721955730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Juhk1rxXqcv0LvjBmmBek/yRx3F0GQ+A2PArt9J+ciU=;
        b=jfpNzNOKiXZC70mxmoV9QyqxXB/GmXQqem1qqy0+aQHutsV2mZCNSeQYyQ9KwJG1Qs
         FK3aF4QwDYcwOeIzFALcWkWH2YGSYcFSOu2pTzqae1/1PWhz7dMet+w4L9+lUzA7JUbd
         5zfaMvqnVOoLxw7wN6u7z0ReP2uecJJljpn0pc3K2p7cZe077ixhjrIEpt91RbEs0x32
         gRrugmgZFH0JSLTfdP1jBfhW+M52D7FuMW+rWHmHLqy/z1hswjJmFnRsOGYNVPCGBXkb
         avCrBwc3omV8Z0koJiJSDkV4xHiXpiYq/GABWBjXS/3IzvOlIcFqgPvasB7AzOanlp2u
         1BRw==
X-Forwarded-Encrypted: i=1; AJvYcCVMFP7pNNPHbkW0EV537csa1hMUXaYErDKl7thFHcLfMH1+UOS5G60FgU8865BFf3hSMMC5vP51fsgi2aVH7L+bweHt
X-Gm-Message-State: AOJu0YzuY31Rp2J0TQvxCg99eAyOCh6d4844o2riuJnbi+RjY1kSTS3/
	Q9kNRnLLkkFEYFcDf6liSErZyVMRFEM9BuguPF8bo3L1l7NnYiSSxSgu0L07fy0Ib7ety2AfFf4
	0UL8aNqYzk0MR0mBpMJwTKCYrGSiIBCPcRBPbJGHQbdhdWLvAMgEG+T2GNN6f5h6S1n5xNqZ9VN
	YOSW1h9KBj6AbYc1rWt1a8THdA
X-Received: by 2002:a05:6a21:39a:b0:1c0:f529:af05 with SMTP id adf61e73a8af0-1c3fdd4d914mr6793183637.43.1721350930338;
        Thu, 18 Jul 2024 18:02:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEIRWijrC51r9BOXUiE6Aug7hDC6Lr0jyTkTo6KMrQRu/t6/fcr6+L8+BQ4wl7rzCezfYFnYOWyCyo72nnIjgU=
X-Received: by 2002:a05:6a21:39a:b0:1c0:f529:af05 with SMTP id
 adf61e73a8af0-1c3fdd4d914mr6793160637.43.1721350929827; Thu, 18 Jul 2024
 18:02:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240717053034-mutt-send-email-mst@kernel.org>
 <CACGkMEura9v43QtBmWSd1+E_jpEUeXf+u5UmUzP1HT5vZOw3NA@mail.gmail.com> <20240718152712-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240718152712-mutt-send-email-mst@kernel.org>
From: Jason Wang <jasowang@redhat.com>
Date: Fri, 19 Jul 2024 09:01:58 +0800
Message-ID: <CACGkMEtTVmKYMdvjzE753+czmEcts4caG859_jW7nHQt7ATgkw@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: features, fixes, cleanups
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, aha310510@gmail.com, arefev@swemel.ru, 
	arseny.krasnov@kaspersky.com, davem@davemloft.net, dtatulea@nvidia.com, 
	eperezma@redhat.com, glider@google.com, iii@linux.ibm.com, jiri@nvidia.com, 
	jiri@resnulli.us, kuba@kernel.org, lingshan.zhu@intel.com, 
	ndabilpuram@marvell.com, pgootzen@nvidia.com, pizhenwei@bytedance.com, 
	quic_jjohnson@quicinc.com, schalla@marvell.com, stefanha@redhat.com, 
	sthotton@marvell.com, syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com, 
	vattunuru@marvell.com, will@kernel.org, xuanzhuo@linux.alibaba.com, 
	yskelg@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 19, 2024 at 3:28=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Thu, Jul 18, 2024 at 08:52:28AM +0800, Jason Wang wrote:
> > On Wed, Jul 17, 2024 at 5:30=E2=80=AFPM Michael S. Tsirkin <mst@redhat.=
com> wrote:
> > >
> > > This is relatively small.
> > > I had to drop a buggy commit in the middle so some hashes
> > > changed from what was in linux-next.
> > > Deferred admin vq scalability fix to after rc2 as a minor issue was
> > > found with it recently, but the infrastructure for it
> > > is there now.
> > >
> > > The following changes since commit e9d22f7a6655941fc8b2b942ed354ec780=
936b3e:
> > >
> > >   Merge tag 'linux_kselftest-fixes-6.10-rc7' of git://git.kernel.org/=
pub/scm/linux/kernel/git/shuah/linux-kselftest (2024-07-02 13:53:24 -0700)
> > >
> > > are available in the Git repository at:
> > >
> > >   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/=
for_linus
> > >
> > > for you to fetch changes up to 6c85d6b653caeba2ef982925703cbb4f2b3b31=
63:
> > >
> > >   virtio: rename virtio_find_vqs_info() to virtio_find_vqs() (2024-07=
-17 05:20:58 -0400)
> > >
> > > ----------------------------------------------------------------
> > > virtio: features, fixes, cleanups
> > >
> > > Several new features here:
> > >
> > > - Virtio find vqs API has been reworked
> > >   (required to fix the scalability issue we have with
> > >    adminq, which I hope to merge later in the cycle)
> > >
> > > - vDPA driver for Marvell OCTEON
> > >
> > > - virtio fs performance improvement
> > >
> > > - mlx5 migration speedups
> > >
> > > Fixes, cleanups all over the place.
> > >
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > >
> >
> > It looks like this one is missing?
> >
> > https://lore.kernel.org/kvm/20240701033159.18133-1-jasowang@redhat.com/=
T/
> >
> > Thanks
>
> It's not included in the full but it's a bugfix and it's subtel enough
> that I decided it's best to merge later, in particular when I'm not on
> vacation ;)

Understood.

Thanks

>
> --
> MST
>


