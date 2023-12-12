Return-Path: <kvm+bounces-4210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9194D80F20C
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 17:13:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 35130B20D7D
	for <lists+kvm@lfdr.de>; Tue, 12 Dec 2023 16:13:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B5577F0F;
	Tue, 12 Dec 2023 16:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hgzxd/OQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F08FB4
	for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 08:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702397564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=73Y77tPLmgg9X166NzbyHTwHM16bRnjvtwZKK18ICnw=;
	b=Hgzxd/OQDoTAqEFGuGtn6pb0FQA9Hntw8P1TVHspxlLAJ6RGR5Kc5y6HXwksZFPwZeVK2M
	hW6M7KlVoVtAUgchfvdQ0qURhbWSm1EKHQLrweDJ9NiRTnvMjGk2hV768UtIJb0fKHiFFq
	t2COYVU5GPjoLEo/9/MHEUTwyh8BfvY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-LLSMjat7N3qPO0Ywp50BHA-1; Tue, 12 Dec 2023 11:12:41 -0500
X-MC-Unique: LLSMjat7N3qPO0Ywp50BHA-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-33334e370d3so5165562f8f.2
        for <kvm@vger.kernel.org>; Tue, 12 Dec 2023 08:12:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702397560; x=1703002360;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=73Y77tPLmgg9X166NzbyHTwHM16bRnjvtwZKK18ICnw=;
        b=txo510HSDtwFj5dnmQ0pFj8R282M2zuveFwFR0B0bJ7/qhmPoNsijGHa7A0LFZ5sr/
         gVQ6zPzI5kuLYoq8M3eRDsWF3Ia7sIQ3yeULjUw2xO3A2oQEhrvz/Wc+OeurJDr1Rl7Q
         V6Vpa/HAlMpZDRZVgUvrolwFBrtNaqLKT3+Q6vRnW91ELRwJToimgqEkNhFYnBu/UPEO
         DWFO5czbGYqjNlbRPnsEuGCUCHCvPs9df7X6puOreAulRe0s/WVZYHbWXWam06f5WbB7
         FUQzlh8hvdgALkfXpY4SoYvu4ektvG5lmqy4EF5tkUjk30rWPudrF10IGo2Av64OawdM
         lYSA==
X-Gm-Message-State: AOJu0Yz8tWMZ7w/E165c5JePsm4x6FLcAt/LRIoNQr7GuFhij6TsLeyU
	54AKBwr7Kyx4uCC0gsRugzN0EFo6YCpufMU25X/WLjeIok3LdKHGOf0Eiyav9v5+nYv3pybuMhO
	zEm9PkJmOJ80M
X-Received: by 2002:a7b:cc0c:0:b0:40c:3e8c:74fa with SMTP id f12-20020a7bcc0c000000b0040c3e8c74famr3240813wmh.70.1702397559982;
        Tue, 12 Dec 2023 08:12:39 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEyb1/I2wKTLMi+hetTQnpC0FPFzMqzR4AJJQa8dDCJSD0J7Uw3hfcLHdSCE9DDEEdCK5s0fA==
X-Received: by 2002:a7b:cc0c:0:b0:40c:3e8c:74fa with SMTP id f12-20020a7bcc0c000000b0040c3e8c74famr3240796wmh.70.1702397559537;
        Tue, 12 Dec 2023 08:12:39 -0800 (PST)
Received: from redhat.com ([2.52.23.105])
        by smtp.gmail.com with ESMTPSA id j1-20020a5d5641000000b00333dbecdce3sm11134355wrw.62.2023.12.12.08.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 08:12:38 -0800 (PST)
Date: Tue, 12 Dec 2023 11:12:35 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org,
	virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@sberdevices.ru,
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v8 0/4] send credit update during setting
 SO_RCVLOWAT
Message-ID: <20231212111131-mutt-send-email-mst@kernel.org>
References: <20231211211658.2904268-1-avkrasnov@salutedevices.com>
 <20231212105423-mutt-send-email-mst@kernel.org>
 <d27f22f0-0f1e-e1bb-5b13-a524dc6e94d7@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d27f22f0-0f1e-e1bb-5b13-a524dc6e94d7@salutedevices.com>

On Tue, Dec 12, 2023 at 06:59:03PM +0300, Arseniy Krasnov wrote:
> 
> 
> On 12.12.2023 18:54, Michael S. Tsirkin wrote:
> > On Tue, Dec 12, 2023 at 12:16:54AM +0300, Arseniy Krasnov wrote:
> >> Hello,
> >>
> >>                                DESCRIPTION
> >>
> >> This patchset fixes old problem with hungup of both rx/tx sides and adds
> >> test for it. This happens due to non-default SO_RCVLOWAT value and
> >> deferred credit update in virtio/vsock. Link to previous old patchset:
> >> https://lore.kernel.org/netdev/39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru/
> > 
> > 
> > Patchset:
> > 
> > Acked-by: Michael S. Tsirkin <mst@redhat.com>
> 
> Thanks!
> 
> > 
> > 
> > But I worry whether we actually need 3/8 in net not in net-next.
> 
> Because of "Fixes" tag ? I think this problem is not critical and reproducible
> only in special cases, but i'm not familiar with netdev process so good, so I don't
> have strong opinion. I guess @Stefano knows better.
> 
> Thanks, Arseniy

Fixes means "if you have that other commit then you need this commit
too". I think as a minimum you need to rearrange patches to make the
fix go in first. We don't want a regression followed by a fix.

> > 
> > Thanks!
> > 
> >> Here is what happens step by step:
> >>
> >>                                   TEST
> >>
> >>                             INITIAL CONDITIONS
> >>
> >> 1) Vsock buffer size is 128KB.
> >> 2) Maximum packet size is also 64KB as defined in header (yes it is
> >>    hardcoded, just to remind about that value).
> >> 3) SO_RCVLOWAT is default, e.g. 1 byte.
> >>
> >>
> >>                                  STEPS
> >>
> >>             SENDER                              RECEIVER
> >> 1) sends 128KB + 1 byte in a
> >>    single buffer. 128KB will
> >>    be sent, but for 1 byte
> >>    sender will wait for free
> >>    space at peer. Sender goes
> >>    to sleep.
> >>
> >>
> >> 2)                                     reads 64KB, credit update not sent
> >> 3)                                     sets SO_RCVLOWAT to 64KB + 1
> >> 4)                                     poll() -> wait forever, there is
> >>                                        only 64KB available to read.
> >>
> >> So in step 4) receiver also goes to sleep, waiting for enough data or
> >> connection shutdown message from the sender. Idea to fix it is that rx
> >> kicks tx side to continue transmission (and may be close connection)
> >> when rx changes number of bytes to be woken up (e.g. SO_RCVLOWAT) and
> >> this value is bigger than number of available bytes to read.
> >>
> >> I've added small test for this, but not sure as it uses hardcoded value
> >> for maximum packet length, this value is defined in kernel header and
> >> used to control deferred credit update. And as this is not available to
> >> userspace, I can't control test parameters correctly (if one day this
> >> define will be changed - test may become useless). 
> >>
> >> Head for this patchset is:
> >> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=021b0c952f226236f2edf89c737efb9a28d1422d
> >>
> >> Link to v1:
> >> https://lore.kernel.org/netdev/20231108072004.1045669-1-avkrasnov@salutedevices.com/
> >> Link to v2:
> >> https://lore.kernel.org/netdev/20231119204922.2251912-1-avkrasnov@salutedevices.com/
> >> Link to v3:
> >> https://lore.kernel.org/netdev/20231122180510.2297075-1-avkrasnov@salutedevices.com/
> >> Link to v4:
> >> https://lore.kernel.org/netdev/20231129212519.2938875-1-avkrasnov@salutedevices.com/
> >> Link to v5:
> >> https://lore.kernel.org/netdev/20231130130840.253733-1-avkrasnov@salutedevices.com/
> >> Link to v6:
> >> https://lore.kernel.org/netdev/20231205064806.2851305-1-avkrasnov@salutedevices.com/
> >> Link to v7:
> >> https://lore.kernel.org/netdev/20231206211849.2707151-1-avkrasnov@salutedevices.com/
> >>
> >> Changelog:
> >> v1 -> v2:
> >>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
> >>  * New patch is added as 0001 - it removes return from SO_RCVLOWAT set
> >>    callback in 'af_vsock.c' when transport callback is set - with that
> >>    we can set 'sk_rcvlowat' only once in 'af_vsock.c' and in future do
> >>    not copy-paste it to every transport. It was discussed in v1.
> >>  * See per-patch changelog after ---.
> >> v2 -> v3:
> >>  * See changelog after --- in 0003 only (0001 and 0002 still same).
> >> v3 -> v4:
> >>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
> >>  * See per-patch changelog after ---.
> >> v4 -> v5:
> >>  * Change patchset tag 'RFC' -> 'net-next'.
> >>  * See per-patch changelog after ---.
> >> v5 -> v6:
> >>  * New patch 0003 which sends credit update during reading bytes from
> >>    socket.
> >>  * See per-patch changelog after ---.
> >> v6 -> v7:
> >>  * Patchset rebased and tested on new HEAD of net-next (see hash above).
> >>  * See per-patch changelog after ---.
> >> v7 -> v8:
> >>  * See per-patch changelog after ---.
> >>
> >> Arseniy Krasnov (4):
> >>   vsock: update SO_RCVLOWAT setting callback
> >>   virtio/vsock: send credit update during setting SO_RCVLOWAT
> >>   virtio/vsock: fix logic which reduces credit update messages
> >>   vsock/test: two tests to check credit update logic
> >>
> >>  drivers/vhost/vsock.c                   |   1 +
> >>  include/linux/virtio_vsock.h            |   1 +
> >>  include/net/af_vsock.h                  |   2 +-
> >>  net/vmw_vsock/af_vsock.c                |   9 +-
> >>  net/vmw_vsock/hyperv_transport.c        |   4 +-
> >>  net/vmw_vsock/virtio_transport.c        |   1 +
> >>  net/vmw_vsock/virtio_transport_common.c |  43 +++++-
> >>  net/vmw_vsock/vsock_loopback.c          |   1 +
> >>  tools/testing/vsock/vsock_test.c        | 175 ++++++++++++++++++++++++
> >>  9 files changed, 229 insertions(+), 8 deletions(-)
> >>
> >> -- 
> >> 2.25.1
> > 


