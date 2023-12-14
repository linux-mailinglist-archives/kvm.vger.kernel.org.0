Return-Path: <kvm+bounces-4460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACC70812C3E
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 10:56:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE2C11C21518
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 09:56:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC82638DC6;
	Thu, 14 Dec 2023 09:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Yagx8o6O"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ECA8106
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 01:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702547774;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/tkL8YLXBdtuh1lhYs0W2zJGNUrEl73DXiA9GWiR3Xc=;
	b=Yagx8o6OikMINwIq3qxQBSoNrcZlY+uGSN99PVI/cWREyimdBK/GIaCh5YS+dm08g81MJn
	+qmzCNDedgP/9k2brURSCi2M79e0iW5CjYud5HfB5DRLt3RHawv6MPSNUrZ6A8eqJom0ug
	SQOfEtJdb55+qrh1uYtKx9i72v8ARTQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-632-kYv4bcUkNSyFyTdzxvuzGg-1; Thu, 14 Dec 2023 04:56:13 -0500
X-MC-Unique: kYv4bcUkNSyFyTdzxvuzGg-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-333405020f3so5947572f8f.1
        for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 01:56:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702547772; x=1703152572;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/tkL8YLXBdtuh1lhYs0W2zJGNUrEl73DXiA9GWiR3Xc=;
        b=fT1syg62UXKyriRkzNUqwrDL8F0UIzd1GRTbcuq6x+4iXXg256VwnPV5JbZVbDZZqF
         Cfr89hRoYX9h5MmVg/t+2DocRbCf7/DDiiK1eScS/FUAO6RZq9u8hrIOjnGsZW8eiMgh
         9u1wmJgu1PxTBteKRSV1um8oDLMRHFty7JqROIZ+VEmV3VokLFGscYNkwF1I5Bg4h5kw
         Naielhnh/Qs2PSyvGOBt6qR734eKnXPlGNT8vUG3XuUN1QiIGR8rut5bBNBCu5OB+ia/
         wgvVIyMB0rz7hUARmYaKXL6Q7yR9Ni9ve3zAyWWKyM8nYNz54A3dvseWsL2D0NN/RaJr
         Vt5w==
X-Gm-Message-State: AOJu0YzX8aIYGEmD6DdxYkAUQ9LiWKH7PHFvnoKpdhdF/5PZFKWY+y0U
	DqqRXnrPTYWP8frRWGGU/aRoAjAbNZgibJZzuhdiIHKrlMFzUocrW6mBfAl3l7jccvWIcd9DaVP
	PpRNqeILpmoEdmXOk6scOjis=
X-Received: by 2002:a5d:614a:0:b0:336:9f9:6df with SMTP id y10-20020a5d614a000000b0033609f906dfmr5151066wrt.5.1702547771646;
        Thu, 14 Dec 2023 01:56:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEiakjz1ILbcnOG+FrF8iuBB/YhiQdiiOV88jj7k12GPoMjsxf1aAqx1tuBwIkVtWxpFGD4+Q==
X-Received: by 2002:a5d:614a:0:b0:336:9f9:6df with SMTP id y10-20020a5d614a000000b0033609f906dfmr5151053wrt.5.1702547771279;
        Thu, 14 Dec 2023 01:56:11 -0800 (PST)
Received: from sgarzare-redhat ([5.11.101.217])
        by smtp.gmail.com with ESMTPSA id c15-20020adfe74f000000b0033335644478sm15617053wrn.114.2023.12.14.01.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Dec 2023 01:56:10 -0800 (PST)
Date: Thu, 14 Dec 2023 10:56:04 +0100
From: Stefano Garzarella <sgarzare@redhat.com>
To: Arseniy Krasnov <avkrasnov@salutedevices.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Bobby Eshleman <bobby.eshleman@bytedance.com>, kvm@vger.kernel.org, virtualization@lists.linux-foundation.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@sberdevices.ru, 
	oxffffaa@gmail.com
Subject: Re: [PATCH net-next v9 0/4] send credit update during setting
 SO_RCVLOWAT
Message-ID: <4qaygyv6sw4qip6gnu2dirw7d7r3f3cmmh3qctnznda3rslzug@r2cyub6rjw6h>
References: <20231214091947.395892-1-avkrasnov@salutedevices.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20231214091947.395892-1-avkrasnov@salutedevices.com>

On Thu, Dec 14, 2023 at 12:19:43PM +0300, Arseniy Krasnov wrote:
>Hello,
>
>                               DESCRIPTION
>
>This patchset fixes old problem with hungup of both rx/tx sides and adds
>test for it. This happens due to non-default SO_RCVLOWAT value and
>deferred credit update in virtio/vsock. Link to previous old patchset:
>https://lore.kernel.org/netdev/39b2e9fd-601b-189d-39a9-914e5574524c@sberdevices.ru/
>
>Here is what happens step by step:
>
>                                  TEST
>
>                            INITIAL CONDITIONS
>
>1) Vsock buffer size is 128KB.
>2) Maximum packet size is also 64KB as defined in header (yes it is
>   hardcoded, just to remind about that value).
>3) SO_RCVLOWAT is default, e.g. 1 byte.
>
>
>                                 STEPS
>
>            SENDER                              RECEIVER
>1) sends 128KB + 1 byte in a
>   single buffer. 128KB will
>   be sent, but for 1 byte
>   sender will wait for free
>   space at peer. Sender goes
>   to sleep.
>
>
>2)                                     reads 64KB, credit update not sent
>3)                                     sets SO_RCVLOWAT to 64KB + 1
>4)                                     poll() -> wait forever, there is
>                                       only 64KB available to read.
>
>So in step 4) receiver also goes to sleep, waiting for enough data or
>connection shutdown message from the sender. Idea to fix it is that rx
>kicks tx side to continue transmission (and may be close connection)
>when rx changes number of bytes to be woken up (e.g. SO_RCVLOWAT) and
>this value is bigger than number of available bytes to read.
>
>I've added small test for this, but not sure as it uses hardcoded value
>for maximum packet length, this value is defined in kernel header and
>used to control deferred credit update. And as this is not available to
>userspace, I can't control test parameters correctly (if one day this
>define will be changed - test may become useless).
>
>Head for this patchset is:
>https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=9bab51bd662be4c3ebb18a28879981d69f3ef15a
>
>Link to v1:
>https://lore.kernel.org/netdev/20231108072004.1045669-1-avkrasnov@salutedevices.com/
>Link to v2:
>https://lore.kernel.org/netdev/20231119204922.2251912-1-avkrasnov@salutedevices.com/
>Link to v3:
>https://lore.kernel.org/netdev/20231122180510.2297075-1-avkrasnov@salutedevices.com/
>Link to v4:
>https://lore.kernel.org/netdev/20231129212519.2938875-1-avkrasnov@salutedevices.com/
>Link to v5:
>https://lore.kernel.org/netdev/20231130130840.253733-1-avkrasnov@salutedevices.com/
>Link to v6:
>https://lore.kernel.org/netdev/20231205064806.2851305-1-avkrasnov@salutedevices.com/
>Link to v7:
>https://lore.kernel.org/netdev/20231206211849.2707151-1-avkrasnov@salutedevices.com/
>Link to v8:
>https://lore.kernel.org/netdev/20231211211658.2904268-1-avkrasnov@salutedevices.com/
>
>Changelog:
>v1 -> v2:
> * Patchset rebased and tested on new HEAD of net-next (see hash above).
> * New patch is added as 0001 - it removes return from SO_RCVLOWAT set
>   callback in 'af_vsock.c' when transport callback is set - with that
>   we can set 'sk_rcvlowat' only once in 'af_vsock.c' and in future do
>   not copy-paste it to every transport. It was discussed in v1.
> * See per-patch changelog after ---.
>v2 -> v3:
> * See changelog after --- in 0003 only (0001 and 0002 still same).
>v3 -> v4:
> * Patchset rebased and tested on new HEAD of net-next (see hash above).
> * See per-patch changelog after ---.
>v4 -> v5:
> * Change patchset tag 'RFC' -> 'net-next'.
> * See per-patch changelog after ---.
>v5 -> v6:
> * New patch 0003 which sends credit update during reading bytes from
>   socket.
> * See per-patch changelog after ---.
>v6 -> v7:
> * Patchset rebased and tested on new HEAD of net-next (see hash above).
> * See per-patch changelog after ---.
>v7 -> v8:
> * See per-patch changelog after ---.
>v8 -> v9:
> * Patchset rebased and tested on new HEAD of net-next (see hash above).
> * Add 'Fixes' tag for the current 0002.
> * Reorder patches by moving two fixes first.
>
>Arseniy Krasnov (4):
>  virtio/vsock: fix logic which reduces credit update messages
>  virtio/vsock: send credit update during setting SO_RCVLOWAT
>  vsock: update SO_RCVLOWAT setting callback
>  vsock/test: two tests to check credit update logic

This order will break the bisectability, since now patch 2 will not
build if patch 3 is not applied.

So you need to implement in patch 2 `set_rcvlowat` and in patch 3
updated it to `notify_set_rcvlowat`, otherwise we always need to
backport patch 3 in stable branches, that should be applied before
patch 2.

You have 2 options:
a. move patch 3 before patch 2 without changing the code
b. change patch 2 to use `set_rcvlowat` and updated that code in patch 3

I don't have a strong opinion, but I slightly prefer option a. BTW that
forces us to backport more patches on stable branches, so I'm fine with
option b as well.

That said:
Nacked-by: Stefano Garzarella <sgarzare@redhat.com>


