Return-Path: <kvm+bounces-44101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7F2FA9A64E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:39:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E06074662D4
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:39:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98A7D21C160;
	Thu, 24 Apr 2025 08:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QSDER3bN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0190E213240
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745483827; cv=none; b=EJ9QBho3hnouXDNb+QZd1PlM0v8v5thisymlQzGdJjBgt+Zyb2aob7NKw3dni67lT5gQeNfkm3ezvYAdVrrSEdOEEdiDPeTzzDEYEFpPF851mhXiy7DlB2hpGadAyDhnmIeZcbej9oeyZxZopsvPkUTkjS1RHJIFkmYfiUEGiW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745483827; c=relaxed/simple;
	bh=fPeja0QKwMSDRTJx03tZ5pM4veCCSXRBmgYEmRDUSpA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BDY9oAG9veNJwMQc6H6oB4ig8w8W102zeavQTjyql3uoZwJxrIJZen1KolcKgv5O70QsWNiqsyqRIHJiNaj5XQnjp519IFWi7ny+gWHGV1CxEXQBneJ1i8nbj7aj/hLxML1aPcXnJhRGFe9Eat4VFjk+hTvMGAizkQ/7nEEW1LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QSDER3bN; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745483824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6fmlstr9ginyDig4RAQsNh+6aO603AT1tDfj5LgGrKc=;
	b=QSDER3bNjEG3DoJ5cgTOeYkA8DFQwSuzDt++EK4PYruWxb4HhJ66WkTS7XNVUs8bdwf+uG
	2rvdhco54CJ77sDgDMQAbPCyaQadrc6MWhSBUHSI7q2UBc18BgNf/8rMIaEarwLgc6sb1Y
	FTVi2HVWYTPQD2U4WSwYfPEeo4Ods5w=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-465-1ACLkvSnNcu3r9yQpAOHsQ-1; Thu, 24 Apr 2025 04:37:02 -0400
X-MC-Unique: 1ACLkvSnNcu3r9yQpAOHsQ-1
X-Mimecast-MFC-AGG-ID: 1ACLkvSnNcu3r9yQpAOHsQ_1745483821
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-e72b79ffc44so1076162276.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 01:37:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745483821; x=1746088621;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6fmlstr9ginyDig4RAQsNh+6aO603AT1tDfj5LgGrKc=;
        b=D257s01udd1/6nr2SIo4K9lDMSNEUVHoWIdgYzWZ3jeQabshhIgBpw2bEL6QWY27GV
         VDn/tOJp7RfsmTn/Uvs8q1YwwR1X3ddEVN8LdtGFH6KflU5y3qWXdoX+6wwa5bacFy7E
         AxWQzc8xMzfYOwBkza2EvJrdMrDwzCNIwz8zUI125y1BSoozR2cbiZPEDD32qCK4X/FP
         OPTy8xzDrVZQEeJJzbaixN+sSOkFGoOQJi8o9OBRrfDSfAGyZrNWtW61iveEDQ+RwJP6
         u+WxQX5M3nR6CYTi8IAemRr4OISd5X0VXMVyheEJVLdMd9eBOxUmeennkSQmScDyt0f9
         KsnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDub29JM91bvIBtXpPT6pBl0NxhapSXFilMB1LI4Na7gNCO7YyrVqT+kMyzkyVx2oAkak=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzw4r8rGMdwKJMH0+nh+BAOzhGrlSgOjw9eSiVp8KCa6WoYAQPC
	WRmK7UZsiiZdKNVgB9AEUR0C6Gv4Nm0FnTg57Ee/OGeFdFfw6s6CahJgUoV4CzI26oKFdMSukc1
	bplZIJT09sHOusLJIyWsJnS/fVej0O6TNCCbs1obSG3/M6o0qBhaxBulUu0F2agYAsDTcuMmeu+
	ttrGFPAH+TPbgF5Gm2mYK9fM8r
X-Gm-Gg: ASbGncu4Z1OMXdA0dR/2z+ylRdtoIcyDzA5LymINb+tGgJbmZxCgqlZI1mqYOt65hoK
	I+dgwnjfwjfeZjr3lFhXruUC7d2OtAo2TvwaY3ctkeRyvJ+2RpM9ZMsUednkEUCd3+BOoEwk=
X-Received: by 2002:a05:6902:2186:b0:e72:9693:7b36 with SMTP id 3f1490d57ef6-e73036372e0mr2271534276.42.1745483821375;
        Thu, 24 Apr 2025 01:37:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHUfymtjS1vLei+DBOMXzLqv89tvpRz1tTcENml/8LK4mc8Ke+xAHKIP1Qw42phxCq+/NuBAxZdcPmq6bth+u8=
X-Received: by 2002:a05:6902:2186:b0:e72:9693:7b36 with SMTP id
 3f1490d57ef6-e73036372e0mr2271517276.42.1745483821066; Thu, 24 Apr 2025
 01:37:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250421-vsock-linger-v2-0-fe9febd64668@rbox.co>
 <20250421-vsock-linger-v2-1-fe9febd64668@rbox.co> <km2nad6hkdi3ngtho2xexyhhosh4aq37scir2hgxkcfiwes2wd@5dyliiq7cpuh>
 <k47d2h7dwn26eti2p6nv2fupuybabvbexwinvxv7jnfbn6o3ep@cqtbaqlqyfrq>
 <ee09df9b-9804-49de-b43b-99ccd4cbe742@rbox.co> <wnonuiluxgy6ixoioi57lwlixfgcu27kcewv4ajb3k3hihi773@nv3om2t3tsgo>
 <5a4f8925-0e4d-4e4c-9230-6c69af179d3e@rbox.co>
In-Reply-To: <5a4f8925-0e4d-4e4c-9230-6c69af179d3e@rbox.co>
From: Stefano Garzarella <sgarzare@redhat.com>
Date: Thu, 24 Apr 2025 10:36:49 +0200
X-Gm-Features: ATxdqUF_58noK2_e9QPMXCT-pjwdIdBihMopt3yWeIxTGLAFMTKaBY4Kl-orunU
Message-ID: <CAGxU2F6YSwrpV4wXH=mWSgK698sjxfQ=zzXS8tVmo3D84-bBqw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/3] vsock: Linger on unsent data
To: Michal Luczaj <mhal@rbox.co>
Cc: Luigi Leonardi <leonardi@redhat.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 24 Apr 2025 at 09:53, Michal Luczaj <mhal@rbox.co> wrote:
>
> On 4/24/25 09:28, Stefano Garzarella wrote:
> > On Wed, Apr 23, 2025 at 11:06:33PM +0200, Michal Luczaj wrote:
> >> On 4/23/25 18:34, Stefano Garzarella wrote:
> >>> On Wed, Apr 23, 2025 at 05:53:12PM +0200, Luigi Leonardi wrote:
> >>>> Hi Michal,
> >>>>
> >>>> On Mon, Apr 21, 2025 at 11:50:41PM +0200, Michal Luczaj wrote:
> >>>>> Currently vsock's lingering effectively boils down to waiting (or timing
> >>>>> out) until packets are consumed or dropped by the peer; be it by receiving
> >>>>> the data, closing or shutting down the connection.
> >>>>>
> >>>>> To align with the semantics described in the SO_LINGER section of man
> >>>>> socket(7) and to mimic AF_INET's behaviour more closely, change the logic
> >>>>> of a lingering close(): instead of waiting for all data to be handled,
> >>>>> block until data is considered sent from the vsock's transport point of
> >>>>> view. That is until worker picks the packets for processing and decrements
> >>>>> virtio_vsock_sock::bytes_unsent down to 0.
> >>>>>
> >>>>> Note that such lingering is limited to transports that actually implement
> >>>>> vsock_transport::unsent_bytes() callback. This excludes Hyper-V and VMCI,
> >>>>> under which no lingering would be observed.
> >>>>>
> >>>>> The implementation does not adhere strictly to man page's interpretation of
> >>>>> SO_LINGER: shutdown() will not trigger the lingering. This follows AF_INET.
> >>>>>
> >>>>> Signed-off-by: Michal Luczaj <mhal@rbox.co>
> >>>>> ---
> >>>>> net/vmw_vsock/virtio_transport_common.c | 13 +++++++++++--
> >>>>> 1 file changed, 11 insertions(+), 2 deletions(-)
> >>>>>
> >>>>> diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
> >>>>> index 7f7de6d8809655fe522749fbbc9025df71f071bd..aeb7f3794f7cfc251dde878cb44fdcc54814c89c 100644
> >>>>> --- a/net/vmw_vsock/virtio_transport_common.c
> >>>>> +++ b/net/vmw_vsock/virtio_transport_common.c
> >>>>> @@ -1196,12 +1196,21 @@ static void virtio_transport_wait_close(struct sock *sk, long timeout)
> >>>>> {
> >>>>>   if (timeout) {
> >>>>>           DEFINE_WAIT_FUNC(wait, woken_wake_function);
> >>>>> +         ssize_t (*unsent)(struct vsock_sock *vsk);
> >>>>> +         struct vsock_sock *vsk = vsock_sk(sk);
> >>>>> +
> >>>>> +         /* Some transports (Hyper-V, VMCI) do not implement
> >>>>> +          * unsent_bytes. For those, no lingering on close().
> >>>>> +          */
> >>>>> +         unsent = vsk->transport->unsent_bytes;
> >>>>> +         if (!unsent)
> >>>>> +                 return;
> >>>>
> >>>> IIUC if `unsent_bytes` is not implemented, virtio_transport_wait_close
> >>>> basically does nothing. My concern is that we are breaking the
> >>>> userspace due to a change in the behavior: Before this patch, with a
> >>>> vmci/hyper-v transport, this function would wait for SOCK_DONE to be
> >>>> set, but not anymore.
> >>>
> >>> Wait, we are in virtio_transport_common.c, why we are talking about
> >>> Hyper-V and VMCI?
> >>>
> >>> I asked to check `vsk->transport->unsent_bytes` in the v1, because this
> >>> code was part of af_vsock.c, but now we are back to virtio code, so I'm
> >>> confused...
> >>
> >> Might your confusion be because of similar names?
> >
> > In v1 this code IIRC was in af_vsock.c, now you pushed back on virtio
> > common code, so I still don't understand how
> > virtio_transport_wait_close() can be called with vmci or hyper-v
> > transports.
> >
> > Can you provide an example?
>
> You're right, it was me who was confused. VMCI and Hyper-V have their own
> vsock_transport::release callbacks that do not call
> virtio_transport_wait_close().
>
> So VMCI and Hyper-V never lingered anyway?

I think so.

Indeed I was happy with v1, since I think this should be supported by
the vsock core and should not depend on the transport.
But we can do also later.

Stefano

>
> >> vsock_transport::unsent_bytes != virtio_vsock_sock::bytes_unsent
> >>
> >> I agree with Luigi, it is a breaking change for userspace depending on a
> >> non-standard behaviour. What's the protocol here; do it anyway, then see if
> >> anyone complains?
> >>
> >> As for Hyper-V and VMCI losing the "lingering", do we care? And if we do,
> >> take Hyper-V, is it possible to test any changes without access to
> >> proprietary host/hypervisor?
> >>
> >
> > Again, how this code can be called when using vmci or hyper-v
> > transports?
>
> It cannot, you're right.
>
> > If we go back on v1 implementation, I can understand it, but with this
> > version I really don't understand the scenario.
> >
> > Stefano
> >
>


