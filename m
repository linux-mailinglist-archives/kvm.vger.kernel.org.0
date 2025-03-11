Return-Path: <kvm+bounces-40712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D1E7CA5B58A
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 02:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B8AC1893444
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 01:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3598A1DE4F3;
	Tue, 11 Mar 2025 01:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mx2sP6QE"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E084D1DE4C5
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 01:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741654802; cv=none; b=clu/NmYdJBR6GXU9sRGYJvV4VogTiSQcX/ctRJE4meE5N426bL1kr4qXnBLqgQGJpF0qfJ1MV+R0d5NOR2WJt5S0RV2V4co7+TPEHjumiBurcQO99NiRdy7KMWWyAQVFkrQMk9wbwzjqwdOJRrlmPnfOR+2RnoDyTkC57K+k1gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741654802; c=relaxed/simple;
	bh=Km4o/Cc79mmhwdF+oF0aFF700HfRG8KdNxIhM+VCGqU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OL/sgzJOJQ2Qkp4KhaAFqZLaggRMuos6Y4bYBlUfdLiL0xMYJm9Kpvdpb8CUX8zpiddCloiVTRNWjNcw5ydUuFSvbRH7zQdS7oPGAF4O6+jsj1Iv+y+ZQZQ6x8r0/7TDDAowLcqznORfY2PRUIEKRVaf+OGM+SwTQu3UmGledyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mx2sP6QE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741654800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Km4o/Cc79mmhwdF+oF0aFF700HfRG8KdNxIhM+VCGqU=;
	b=Mx2sP6QEb1Gyk8hZvAtOZPMThk83WPbIJtXr7qte3aRZ09/o+Ht4b4qk4AzTUZ7ysCC3ZC
	IkGZSSs8OKXnjkeGOqgA2gQQ5hEyjUHNpHDcYOCRfO2El1Ks+plt9Y2qZfDHJcVfc18YxL
	6hgWu8Dsu3wokN1UriBXIZ7ItjNqdJY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-BXY6GqZFNg20hXwZGyFH2g-1; Mon, 10 Mar 2025 20:59:57 -0400
X-MC-Unique: BXY6GqZFNg20hXwZGyFH2g-1
X-Mimecast-MFC-AGG-ID: BXY6GqZFNg20hXwZGyFH2g_1741654796
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2fec3e38c2dso13723370a91.2
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 17:59:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741654796; x=1742259596;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Km4o/Cc79mmhwdF+oF0aFF700HfRG8KdNxIhM+VCGqU=;
        b=X5L3k335pJ9lJLSvObKPbN2fVoH56vc9TFV8n8BHwJU2a5Fj5vj1FtHXzHq/HVPpUV
         2fjVfjMSiyK9ihdIXTYijcsTUGy2gvROhYOMRN/GN2fQzRpZH6XqQ03pS2ZI0K6LekUM
         5XfkAGRUPbOeYt4fkzLNudkEWdeJ5TRX/yYrxUDGyi1bKWuVebMh+TVyoROZ2uwQoZh+
         3yNp1rWGXiyY1qAi/o0LBpw+yrWmR3WF1+0N/VWXCXsoccmOsPqcDaevmFoBRDQmm3Qw
         hcWBkFrKLaLdrfYDTsLd58PzqbARCyxSb0cKB9sgXwWcpMeRTBQTxaOKL9TESUmKzHww
         3agg==
X-Forwarded-Encrypted: i=1; AJvYcCUEdU4IWOufnZO60InjFIgd5L+3yDmqVsTuue4MThPtYuwVzbpQ9NGtmRtgRlEPGN1gnls=@vger.kernel.org
X-Gm-Message-State: AOJu0YykPemjrG62FrWBktljJI5cFFkTljU+aeuD5gZ/XIiHFfYLZ/ME
	f0y+TL5TboifDHXrGnFE2aV8fMJRVrSetiqyZaDYsln6j6Iyv5qhDxrbgrSuULDBoJCfVxDbh2U
	RUSCbwpQJcshFL0af1KChK9D7XPsAgmMm6vyy0UpnrqmTAmwEvzuQ+1gxZErz15OgChThXNaLFO
	RpAx/7PpkRH3XitlraEBuP+A05
X-Gm-Gg: ASbGncuhZalGD1woNDoQdLYIP3AgbiaYJ4iY6XhvOvCfCRELvWAVKzXEZDZGGy1bAGw
	Zit28rdxIflEIF4aQbfcHholaX+V8gl3dBuvW3S6c8xaAVO4vxCM+opaempE4P38PYQeBsw==
X-Received: by 2002:a05:6a20:6f88:b0:1f3:3c5d:cd86 with SMTP id adf61e73a8af0-1f544aeda95mr23372510637.11.1741654796476;
        Mon, 10 Mar 2025 17:59:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFAjXRLPP+KLwqouY2d8xVCf5YkchPJTuZnlD8oM2zbnnMfHxkuX6t5KA0j3l2vfmnWt5WtbXtWP67UCxPLOE=
X-Received: by 2002:a05:6a20:6f88:b0:1f3:3c5d:cd86 with SMTP id
 adf61e73a8af0-1f544aeda95mr23372488637.11.1741654796116; Mon, 10 Mar 2025
 17:59:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20200116172428.311437-1-sgarzare@redhat.com> <20200427142518.uwssa6dtasrp3bfc@steredhat>
 <224cdc10-1532-7ddc-f113-676d43d8f322@redhat.com> <20200428160052.o3ihui4262xogyg4@steredhat>
 <Z8edJjqAqAaV3Vkt@devvm6277.cco0.facebook.com> <CACGkMEtTgmFVDU+ftDKEvy31JkV9zLLUv25LrEPKQyzgKiQGSQ@mail.gmail.com>
 <Z89ILjEUU12CuVwk@devvm6277.cco0.facebook.com>
In-Reply-To: <Z89ILjEUU12CuVwk@devvm6277.cco0.facebook.com>
From: Jason Wang <jasowang@redhat.com>
Date: Tue, 11 Mar 2025 08:59:44 +0800
X-Gm-Features: AQ5f1JoCYAYg3sSzAq1y95KxGgfuxvQDmD7hYAz9zEwdTX_uuQgCUXsFfxfhrfk
Message-ID: <CACGkMEskp720d+UKm_aPUtGZC5NzH+mp_YKoY2NQV6_YBbRz9g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] vsock: support network namespace
To: Bobby Eshleman <bobbyeshleman@gmail.com>
Cc: Stefano Garzarella <sgarzare@redhat.com>, davem@davemloft.net, 
	Stefan Hajnoczi <stefanha@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, 
	Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org, 
	virtualization@lists.linux-foundation.org, linux-hyperv@vger.kernel.org, 
	Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2025 at 4:14=E2=80=AFAM Bobby Eshleman <bobbyeshleman@gmail=
.com> wrote:
>
> On Wed, Mar 05, 2025 at 01:46:54PM +0800, Jason Wang wrote:
> > On Wed, Mar 5, 2025 at 8:39=E2=80=AFAM Bobby Eshleman <bobbyeshleman@gm=
ail.com> wrote:
> > >
> > > On Tue, Apr 28, 2020 at 06:00:52PM +0200, Stefano Garzarella wrote:
> > > > On Tue, Apr 28, 2020 at 04:13:22PM +0800, Jason Wang wrote:
> > >
> > > WRT netdev, do we foresee big gains beyond just leveraging the netdev=
's
> > > namespace?
> >
> > It's a leverage of the network subsystem (netdevice, steering, uAPI,
> > tracing, probably a lot of others), not only its namespace. It can
> > avoid duplicating existing mechanisms in a vsock specific way. If we
> > manage to do that, namespace support will be a "byproduct".
> >
> [...]
> >
> > Yes, it can. I think we need to evaluate both approaches (that's why I
> > raise the approach of reusing netdevice). We can hear from others.
> >
>
> I agree it is worth evaluating. If netdev is being considered, then it
> is probably also worth considering your suggestion from a few years back
> to add these capabilities by building vsock on top of virtio-net [1].
>
> [1] https://lore.kernel.org/all/2747ac1f-390e-99f9-b24e-f179af79a9da@redh=
at.com/

Yes. I think having a dedicated netdev might be simpler than reusing
the virito-net.

>
> Considering that the current vsock protocol will only ever be able to
> enjoy a restricted feature set of these other net subsystems due to its
> lack of tolerance for packet loss (e.g., no multiqueue steering, no
> packet scheduling), I wonder if it would be best to a) wait until a user
> requires these capabilities, and b) at that point extend vsock to tolerat=
e
> packet loss (add a seqnum)?

Maybe, a question back to this proposal. What's the plan for the
userspace? For example, do we expect to extend iproute2 and other and
how (e.g having a new vsock dedicated tool)?

>
> > >
> > > Some other thoughts I had: netdev's flow control features would all h=
ave
> > > to be ignored or disabled somehow (I think dev_direct_xmit()?), becau=
se
> > > queueing introduces packet loss and the vsock protocol is unable to
> > > survive packet loss.
> >
> > Or just allow it and then configuring a qdisc that may drop packets
> > could be treated as a misconfiguration.
> >
>
> That is possible, but when I was playing with vsock qdisc the only one
> that worked was pfifo_fast/pfifo, as the others that I tested async drop
> packets.

I guess it should work with qdiscs with TCQ_F_CAN_BYPASS. Or if it
turns out to be hard we can just bypass the qdisc layer as you said.

Thanks

>
> Thanks,
> Bobby
>


