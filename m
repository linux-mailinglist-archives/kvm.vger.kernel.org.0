Return-Path: <kvm+bounces-35982-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1940EA16B6A
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 12:20:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7707D169B2B
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2025 11:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9FA1DF737;
	Mon, 20 Jan 2025 11:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XummadlH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00441DEFD6
	for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 11:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737372028; cv=none; b=md/SxtIk7oQbJJ+FLsKdB8qXwKRK8ufyc2JfATqZNTDZMIxs4MsLoui/wiVUBhJuUbNCLMJrSoixFCc3TdauREIvVBuBAu7N0JLqU9qlq5YCokgFtOPmxsd2N66olD/AN9+Ged9AWPjcTrwpIZfs8cYucmnWApzy4/rbFrOR9SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737372028; c=relaxed/simple;
	bh=HukkzVgJWy6wIfrwhhW16Kaa45VNmNtSiyTH/3KseCM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s+ZGVdA2Gw46h6HpVxkOV1gS3rY/qg9yWv4obE0x7YvWKkgjaDZYbMDVLObTKnlcXAZZqJURPD0Ny0XGpV9oFcpdQJossOu2czSOcS7k4guFVOyYfSHUfWQwc5Hnz9fkoQ/ce57OYnPIH9qacW5zr2R7Klt9t4TLYOHzz8ZRjkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XummadlH; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-54298ec925bso5208220e87.3
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2025 03:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737372024; x=1737976824; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=508sHaRatzNmV2AC5YDUok9kXq8AxMjNJqX2AsrhRz0=;
        b=XummadlHa0e8irAytWugKv9AtJjYftloGGts94HPaK2057kE7o/kpCX8Tu9kxv569Y
         O1y9hga8FgZf14NSUBtQzI/MJVJJZlvoM6bCp8KfMBlrSIsqknsTAkFe15TeVpSCMSUG
         WWLzhGco5yqv1IlYMTc1A4epT90MkQ7ga2WY//0IMM7pATJvK1Yl6gWGCJdnDn1sd4p2
         72HznhIOE82O9k801gncYGX9GbyT7hgs9w8bEjMgs7SAGarB7WcouQiN8YOfNdPhyzsn
         GuxZ4qXrINRKu/bbKad7E4O1cr3Fd3aTb7OHuMJ79Rk3Q1g3IJ9M5WCgGXegouQhuBCp
         UxeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737372024; x=1737976824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=508sHaRatzNmV2AC5YDUok9kXq8AxMjNJqX2AsrhRz0=;
        b=tdre1FUeLBpCCHjufzXlqaIy9WFiltIpY2OWx4uRNU2iSJvsrUWnSzvea5QjyU1FGH
         Gij2nVIhBdEQnNup5oq1Zb2rzl4LPfS2/cPcq9PyzuzBPSR9Uo88971lRTE3iBuqArPI
         fKSi9z51jjrZrQTOv4bAbGiIlB83x1ufyCfYO8R/6RRV1ualJ/ey6yi/ax+Z6v3VPk7G
         TtJwM8r0tE9zznCdwXnR8ryFu28Bioqjp4cmP+b5JuAhyuLvOv5jX4yr5WiYPN2m8F3v
         CZpuZi30cEOEH9rPTMThnAGce1S8OZdTKnbVcYe7E+PM9rmond7W7CqfJJlI7YgZtrF+
         0hwg==
X-Forwarded-Encrypted: i=1; AJvYcCU73XSW7xTVWvjq8pipQcr2L3nIIVuSSIrODzGFVFTScMe9e3PxQdKMnNBFsdFFcgMNW4A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLvW7OYXLiZ15khIfFaEtFmr0H5bPjV7PdMc61krfIl+x3WV8u
	ZmXunN6eKZnDrMSS9A5hI05zC7f9nBs3g9ieVhrYV/QjVDpHdDq0p40ySgoX/9GTw1ZlB8R7UKP
	meNOPaB2ahM0FHKSvWDS47bBfRbc1fPtXRdBj
X-Gm-Gg: ASbGnctnJ1QorW8BerOG2f999HIDrKQwYNDB9uTLTaD/PhwUAvR6vxtu1/iaLCLVFqH
	NexcMcNnPmog39wPp8rZih2PLq/+O7w8H/x7Kaw1P3CCexjj8vOs=
X-Google-Smtp-Source: AGHT+IG5bUWJMn934aJFLLbqBw2AOkIQsKQjJQf+FW5w2joFGVMUSmQehttNlWkcrmhhT9aHd4c5YEvXBK36xXQTVQg=
X-Received: by 2002:a05:6512:33cf:b0:542:2a0b:cdd4 with SMTP id
 2adb3069b0e04-5439c287e81mr4094208e87.47.1737372023561; Mon, 20 Jan 2025
 03:20:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250116-tun-v3-0-c6b2871e97f7@daynix.com> <20250116-tun-v3-9-c6b2871e97f7@daynix.com>
 <678a21a9388ae_3e503c294f4@willemb.c.googlers.com.notmuch>
 <51f0c6ba-21bc-4fef-a906-5d83ab29b7ff@daynix.com> <CACGkMEuPXDWHErCCdEUB7+Q0NxsAjpSH9uTvOxzuBvNeyw7_Hg@mail.gmail.com>
In-Reply-To: <CACGkMEuPXDWHErCCdEUB7+Q0NxsAjpSH9uTvOxzuBvNeyw7_Hg@mail.gmail.com>
From: Willem de Bruijn <willemb@google.com>
Date: Mon, 20 Jan 2025 12:19:46 +0100
X-Gm-Features: AbW1kvafrr-kRH1qQ-nNk15dryD6rNi5eAueO9Om8WJCSgPSnlELq-Vuki0tXiI
Message-ID: <CA+FuTSec1z7-8nNNc1ZXkzekDrFHPnvYKFf8PNZg89VuwhoWSw@mail.gmail.com>
Subject: Re: [PATCH net v3 9/9] tap: Use tun's vnet-related code
To: Jason Wang <jasowang@redhat.com>
Cc: Akihiko Odaki <akihiko.odaki@daynix.com>, 
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-kselftest@vger.kernel.org, 
	Yuri Benditovich <yuri.benditovich@daynix.com>, Andrew Melnychenko <andrew@daynix.com>, 
	Stephen Hemminger <stephen@networkplumber.org>, gur.stavi@huawei.com, devel@daynix.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2025 at 1:37=E2=80=AFAM Jason Wang <jasowang@redhat.com> wr=
ote:
>
> On Fri, Jan 17, 2025 at 6:35=E2=80=AFPM Akihiko Odaki <akihiko.odaki@dayn=
ix.com> wrote:
> >
> > On 2025/01/17 18:23, Willem de Bruijn wrote:
> > > Akihiko Odaki wrote:
> > >> tun and tap implements the same vnet-related features so reuse the c=
ode.
> > >>
> > >> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> > >> ---
> > >>   drivers/net/Kconfig    |   1 +
> > >>   drivers/net/Makefile   |   6 +-
> > >>   drivers/net/tap.c      | 152 +++++--------------------------------=
------------
> > >>   drivers/net/tun_vnet.c |   5 ++
> > >>   4 files changed, 24 insertions(+), 140 deletions(-)
> > >>
> > >> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> > >> index 1fd5acdc73c6..c420418473fc 100644
> > >> --- a/drivers/net/Kconfig
> > >> +++ b/drivers/net/Kconfig
> > >> @@ -395,6 +395,7 @@ config TUN
> > >>      tristate "Universal TUN/TAP device driver support"
> > >>      depends on INET
> > >>      select CRC32
> > >> +    select TAP
> > >>      help
> > >>        TUN/TAP provides packet reception and transmission for user s=
pace
> > >>        programs.  It can be viewed as a simple Point-to-Point or Eth=
ernet
> > >> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> > >> index bb8eb3053772..2275309a97ee 100644
> > >> --- a/drivers/net/Makefile
> > >> +++ b/drivers/net/Makefile
> > >> @@ -29,9 +29,9 @@ obj-y +=3D mdio/
> > >>   obj-y +=3D pcs/
> > >>   obj-$(CONFIG_RIONET) +=3D rionet.o
> > >>   obj-$(CONFIG_NET_TEAM) +=3D team/
> > >> -obj-$(CONFIG_TUN) +=3D tun-drv.o
> > >> -tun-drv-y :=3D tun.o tun_vnet.o
> > >> -obj-$(CONFIG_TAP) +=3D tap.o
> > >> +obj-$(CONFIG_TUN) +=3D tun.o
> > >
> > > Is reversing the previous changes to tun.ko intentional?
> > >
> > > Perhaps the previous approach with a new CONFIG_TUN_VNET is preferabl=
e
> > > over this. In particular over making TUN select TAP, a new dependency=
.
> >
> > Jason, you also commented about CONFIG_TUN_VNET for the previous
> > version. Do you prefer the old approach, or the new one? (Or if you hav=
e
> > another idea, please tell me.)
>
> Ideally, if we can make TUN select TAP that would be better. But there
> are some subtle differences in the multi queue implementation. We will
> end up with some useless code for TUN unless we can unify the multi
> queue logic. It might not be worth it to change the TUN's multi queue
> logic so having a new file seems to be better.

+1 on deduplicating further. But this series is complex enough. Let's not
expand that.

The latest approach with a separate .o file may have some performance
cost by converting likely inlined code into real function calls.
Another option is to move it all into tun_vnet.h. That also resolves
the Makefile issues.

