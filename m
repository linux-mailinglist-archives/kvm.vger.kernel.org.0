Return-Path: <kvm+bounces-48463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FCECACE80D
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 03:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AE901898DE5
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 01:56:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5492F1C6FEC;
	Thu,  5 Jun 2025 01:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e9dn5VPb"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16111B0F23
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 01:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749088546; cv=none; b=fpbETL28e2gwzgaIWIwqfc9q++lT4/9BwhtThf/fThNCAqOENtFVUp7DT2aj3j0eUzk5uUNeNBBOcXQNlY0VQCzTtczlkXsm487W3eIQ0N9DCznLGaEjbT5rK6J2tsZd2qy90gU9N4TMyreV4CcXzmve1OzmrHGc5zxYlULEYbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749088546; c=relaxed/simple;
	bh=+c9Fev8/Meg10Uoay1ZU/kdCAOWZDW9/gdNngKjH6Go=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KHiudpDIrQ1Rkx/O0toS33M5C2FeAZvjb/Kxm4b/UAqggyvP2V0YPdWZjdw3R8ZZjShJMhDcIqWOcAKHO2D1APKd3gCsqy5ZSGkWpxlEe8IiJs3Ur4Y058rQ20AEXm16JxLrdfrHHdzWwy8zCa7ocv2c2IEN8s2WJtC2FdPxrGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e9dn5VPb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749088543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9AwB0rFfcz08HKP4jJKt0w7l+d02ZrCK/l/MYo9cvhM=;
	b=e9dn5VPbZ6cPgXsKMO7iQ7MzNkm1ovj9A6LaFLwiNX1h5NVcXetUqvVfxQI8mBrgNhXKsC
	oUD0FoTkMG4vV7oUtMGvfdLBZiQPLKCr76DNa1y3bbiN7NxvKfuGCf0XMRPWCS9CBmzm0f
	35Ri7rZ9YuSt05kUdm+Eq4JVxYypZoQ=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-9T1qFjQKP_65DFn_VwxuDg-1; Wed, 04 Jun 2025 21:55:42 -0400
X-MC-Unique: 9T1qFjQKP_65DFn_VwxuDg-1
X-Mimecast-MFC-AGG-ID: 9T1qFjQKP_65DFn_VwxuDg_1749088541
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-74292762324so491494b3a.0
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 18:55:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749088541; x=1749693341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9AwB0rFfcz08HKP4jJKt0w7l+d02ZrCK/l/MYo9cvhM=;
        b=ubwWhsm7FzwvNSubryTQuNYTdDXD6B8sxYyo3CS4Fl4/Jo8WOvDvDG2eCDKovnLwTP
         2CnMFdR0pIopwWgMIfHFUzsih/rp7OHl/G0qSLRzmEC4fFRGGJgluHUVj0tKLoW3m8kM
         i/LY6evD+ojJZ28APJlMbT56uWlUUOE2wDWRhAisiMdb7NhkB5JVowuH8iTe1Mn/Rw8R
         8xk+EbkUo3ce84OSMp65tXNGlAeiBtU20Upxd+T52WfHgNE8qzmqDOFaXbiT5Umnrxlz
         N9oJAvq/g4CLuX5xcYF3cHmHu+JuVprRoKFYivVWwUWl/jImhCa/tvfJ4Ac3kif3Jtsg
         CIhQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8yDP5FYTHm/l6UtxSE/B0ce/lzBqFORJN4IJhhf0wKb9kHDkO8ZU7rrkPlgL4Dpk6aAE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9dDdyhRKsiFN3EHlZBZgB6cdKiF5IAcz9AO8tx2B6FeIbWwSv
	MNwNVx/YoQENTwTvTomzZjsGkWuQE1s/aDIzXGPEmo12D5QVjnp4ThlFiOCoIJmW7ZpfhkX61+u
	DEUQ8u1+wRoXERgqL0rDTPnIBwFE5lL8rpezqAykzgG4Q72BJGVC249XqSiYNiT+g0D2e3H9A5r
	ophCd7i8DLKBgT/Q5pMtEJmZeqTdv/
X-Gm-Gg: ASbGncuUdCbTps1VMNhInm1m27l4LgNlqldHku1MIjLUyXTgGB+oFE+bTYozgGpJ/tu
	jr6+O6bTbHubhvs4sa3/tITu1Elgiu6v16PRg14dbMBy3FP7/nLMxSpIuKo4OFkxj3XBy
X-Received: by 2002:a05:6a00:2388:b0:740:9d7c:aeb9 with SMTP id d2e1a72fcca58-7480b4d1082mr6213288b3a.21.1749088541555;
        Wed, 04 Jun 2025 18:55:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFwnJcqWyBWgiV7ZC471A+qE9fAqmmsGEYcyWVU07xTy7Qtf9rwO6aj8PQ3oqhbhbV/So3yIUnkKqxQkvKzki0=
X-Received: by 2002:a05:6a00:2388:b0:740:9d7c:aeb9 with SMTP id
 d2e1a72fcca58-7480b4d1082mr6213256b3a.21.1749088541126; Wed, 04 Jun 2025
 18:55:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250530-rss-v12-0-95d8b348de91@daynix.com> <20250530-rss-v12-3-95d8b348de91@daynix.com>
 <CACGkMEvVf0LrquZcWSv3vp-r44sTj0ZDnjwbwB20N0aU35+vxw@mail.gmail.com> <517d5838-3313-4b31-b96d-d471b062cd1a@daynix.com>
In-Reply-To: <517d5838-3313-4b31-b96d-d471b062cd1a@daynix.com>
From: Jason Wang <jasowang@redhat.com>
Date: Thu, 5 Jun 2025 09:55:29 +0800
X-Gm-Features: AX0GCFurXm0NIffhahLwnERAjW3lh1v_d_xG6UdMjWsQHXxbHYsep8L113YBN6k
Message-ID: <CACGkMEvyaY0rdNTj_jP_4HF5TrCCNeTKZZ8U2LsMikLqyctkzA@mail.gmail.com>
Subject: Re: [PATCH net-next v12 03/10] tun: Allow steering eBPF program to
 fall back
To: Akihiko Odaki <akihiko.odaki@daynix.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, 
	Lei Yang <leiyang@redhat.com>, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 4, 2025 at 3:24=E2=80=AFPM Akihiko Odaki <akihiko.odaki@daynix.=
com> wrote:
>
> On 2025/06/04 10:27, Jason Wang wrote:
> > On Fri, May 30, 2025 at 12:50=E2=80=AFPM Akihiko Odaki <akihiko.odaki@d=
aynix.com> wrote:
> >>
> >> This clarifies a steering eBPF program takes precedence over the other
> >> steering algorithms.
> >
> > Let's give an example on the use case for this.
> >
> >>
> >> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> >> ---
> >>   Documentation/networking/tuntap.rst |  7 +++++++
> >>   drivers/net/tun.c                   | 28 +++++++++++++++++----------=
-
> >>   include/uapi/linux/if_tun.h         |  9 +++++++++
> >>   3 files changed, 33 insertions(+), 11 deletions(-)
> >>
> >> diff --git a/Documentation/networking/tuntap.rst b/Documentation/netwo=
rking/tuntap.rst
> >> index 4d7087f727be..86b4ae8caa8a 100644
> >> --- a/Documentation/networking/tuntap.rst
> >> +++ b/Documentation/networking/tuntap.rst
> >> @@ -206,6 +206,13 @@ enable is true we enable it, otherwise we disable=
 it::
> >>         return ioctl(fd, TUNSETQUEUE, (void *)&ifr);
> >>     }
> >>
> >> +3.4 Reference
> >> +-------------
> >> +
> >> +``linux/if_tun.h`` defines the interface described below:
> >> +
> >> +.. kernel-doc:: include/uapi/linux/if_tun.h
> >> +
> >>   Universal TUN/TAP device driver Frequently Asked Question
> >>   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >>
> >> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> >> index d8f4d3e996a7..9133ab9ed3f5 100644
> >> --- a/drivers/net/tun.c
> >> +++ b/drivers/net/tun.c
> >> @@ -476,21 +476,29 @@ static u16 tun_automq_select_queue(struct tun_st=
ruct *tun, struct sk_buff *skb)
> >>          return txq;
> >>   }
> >>
> >> -static u16 tun_ebpf_select_queue(struct tun_struct *tun, struct sk_bu=
ff *skb)
> >> +static bool tun_ebpf_select_queue(struct tun_struct *tun, struct sk_b=
uff *skb,
> >> +                                 u16 *ret)
> >>   {
> >>          struct tun_prog *prog;
> >>          u32 numqueues;
> >> -       u16 ret =3D 0;
> >> +       u32 prog_ret;
> >> +
> >> +       prog =3D rcu_dereference(tun->steering_prog);
> >> +       if (!prog)
> >> +               return false;
> >>
> >>          numqueues =3D READ_ONCE(tun->numqueues);
> >> -       if (!numqueues)
> >> -               return 0;
> >> +       if (!numqueues) {
> >> +               *ret =3D 0;
> >> +               return true;
> >> +       }
> >>
> >> -       prog =3D rcu_dereference(tun->steering_prog);
> >> -       if (prog)
> >> -               ret =3D bpf_prog_run_clear_cb(prog->prog, skb);
> >> +       prog_ret =3D bpf_prog_run_clear_cb(prog->prog, skb);
> >> +       if (prog_ret =3D=3D TUN_STEERINGEBPF_FALLBACK)
> >> +               return false;
> >
> > This seems to break the uAPI. So I think we need a new ioctl to enable
> > the behaviour
>
> I assumed it is fine to repurpose one of the 32-bit integer values since
> 32-bit integer is too big to specify the queue number, but it may not be
> fine. I don't have a concrete use case either.
>
> Perhaps it is safer to note that TUNSETSTEERINGEBPF takes precedence
> over TUNSETVNETRSS to allow such an extension in the future (but without
> implementing one now).

Yes, that's my original point. Let's start from something that is
simpler and safer.

Thanks


