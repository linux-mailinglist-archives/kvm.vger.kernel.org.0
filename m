Return-Path: <kvm+bounces-47353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B578BAC069B
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 10:08:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6A084E0E91
	for <lists+kvm@lfdr.de>; Thu, 22 May 2025 08:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48186262FF2;
	Thu, 22 May 2025 08:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MoMu+Nxt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACBA726157E
	for <kvm@vger.kernel.org>; Thu, 22 May 2025 08:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747901294; cv=none; b=nzWROVc+LsN0rdsRqkZTu7eNJubqL36P/WHM8xCq/VQZnfmNzLO8qO5NcM09GGzAeOStD31932oh44JqQg+Khyid7sE5e0LktUIwN9hnzHnt/z9tJAaOAenqLJ4qCDeseI/U/3c1WHlQMa/5cgT8dApy8I1gouPVgcyK2Ig3T6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747901294; c=relaxed/simple;
	bh=EX5kmSVBRAEXjNP2+5QT/wObVkwCn7KBTPH2XSu0cww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VMTuO6abHTLAktAu7p7MclL1zGA6yX+bHbk54OZjrjFrMxjfIGnwfSG9+e91HyuLcmDGaZZxYqsdUh0nDIKttl82xJdAdX/VOrfeqnDa3M6Zax6LexoCxBoxqYQq+zFFX5xSdLThJNQVpjaVZfS7bRMMNff/+dedLQZcxf1aH2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MoMu+Nxt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747901291;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v4Wd+YCxX35LZrCoOEx8nIlaA1xFBFeFa5Cgo0fIeyo=;
	b=MoMu+Nxt0igH4ftuPMxDzFqwHydL8oeRKOxQPx1ot2iUBLc5Gzow94zHgNsqhJreNojH50
	d38geBDugG2pQWaC8pxnzm2Mt0kEXtjRQDmUZGogVEbywj/MQGKUuwfFk7fUHaKlXy62DB
	X1atUYa5nFUJpoUea8QLkExsEyuQJVI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-344-wpkoArDnMJuuyArv1Fc1Xg-1; Thu, 22 May 2025 04:08:10 -0400
X-MC-Unique: wpkoArDnMJuuyArv1Fc1Xg-1
X-Mimecast-MFC-AGG-ID: wpkoArDnMJuuyArv1Fc1Xg_1747901289
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43cf44b66f7so49029765e9.1
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 01:08:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747901289; x=1748506089;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v4Wd+YCxX35LZrCoOEx8nIlaA1xFBFeFa5Cgo0fIeyo=;
        b=R+Avz+jPknX5oW3o+S6gGZkjwuaS7BhX8tErFCTf42nE3youC18Ajvn5m/+nrtWi4Y
         +cQz63x8Cn0q1B30+mEpLlEE/PNJfaUSoO+2IxhiQOQC+HX7RgrT/rwuTHSVFgLfUkGX
         z/XadS1J3/LAGxgBPfTJjbuUlT13MCX47w7JQGOsdAtFraw48g9T18+i8hx39ySnppuR
         AtAl2VoGcG5Ow+jl26pTFn83iXs9GxDwAmJZ55u9Rzy09oEZ3KkYv7uIgen2IJ+v/Xia
         StKdFV/EAl1u0QDtASFT/hhc6SBM5u7LuHMbGBwpWTw/BjOOPwqha3b84hT1/OMCbQWt
         zY0w==
X-Forwarded-Encrypted: i=1; AJvYcCV6A5Me//PB/qL1+Bblku9w4K0g80cudqQot3zshcAyLdkpcAoEKi4Y4YPfUGys2ECQgXw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWmqp5w2z8Xy95ifO+jqMueiJ7PcMZGil/A+eXIO3seDv5e1Vb
	5J1uEHTNd2jEqVFLx2O0UuYIqoFBHbIO4XfKyhsI25vmhuBZ2pMJDDMiaqgHg24b/6TzD0bRzmx
	fPqbF+tvbZmz1hOgpxTvYn61ndrrUtAGeEGXjeJpToe48o1dXcnPBfw==
X-Gm-Gg: ASbGnctiheB7nBJpuZQuKUhz346z9Ut0av2Smz4qZhYsIJyfApWd6he5BbSH+D+abdC
	QDN9JhveZeJm/QnEYRfP8kbOdz9CzAgcJb2aiys38c67p+FHuZXZWNaQ3KIbTuoEC8IxzY5ug5n
	+QGAGrIGKAczhSkThmFda1OtkEPhE6I9g1IZH3d745EutlZCedNYqlx1lUpgEp52OszB0pg5CK0
	VUlPHAEUKc9k5SUq+rDuA3pnnDTMrr06/TByhotULkkl8p15Ui5CagH5Zmx6JXZxWoNU09IqOCl
	VVhnQAaOMkRp26oTtwnH7ne1YQq9D3CX/+B1MqHe+7ZOtLTHIYkcXojGWeI8
X-Received: by 2002:a05:6000:2384:b0:3a3:6843:497f with SMTP id ffacd0b85a97d-3a368434b4emr17223468f8f.2.1747901288984;
        Thu, 22 May 2025 01:08:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGB40eN1djVba1zLi/ieq+7/sYLnQly/oH/G63SZEMaHuLSaV/Sn473qGuURKSe2USXv485dA==
X-Received: by 2002:a05:6000:2384:b0:3a3:6843:497f with SMTP id ffacd0b85a97d-3a368434b4emr17223414f8f.2.1747901288395;
        Thu, 22 May 2025 01:08:08 -0700 (PDT)
Received: from sgarzare-redhat (host-82-53-134-35.retail.telecomitalia.it. [82.53.134.35])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f6b295e7sm94333515e9.2.2025.05.22.01.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 May 2025 01:08:07 -0700 (PDT)
Date: Thu, 22 May 2025 10:08:03 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: Michal Luczaj <mhal@rbox.co>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, virtualization@lists.linux.dev, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH net-next v6 0/5] vsock: SOCK_LINGER rework
Message-ID: <kqm3bdj66qkziz27xsy6k6rnyminleqvebgqoudmufa424jlzm@khnzut7q4nqq>
References: <20250522-vsock-linger-v6-0-2ad00b0e447e@rbox.co>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250522-vsock-linger-v6-0-2ad00b0e447e@rbox.co>

On Thu, May 22, 2025 at 01:18:20AM +0200, Michal Luczaj wrote:
>Change vsock's lingerning to wait on close() until all data is sent, i.e.
>until workers picked all the packets for processing.

Thanks for the series and the patience :-)

LGTM! There should be my R-b for all patches.

Thanks,
Stefano

>
>Changes in v6:
>- Make vsock_wait_sent() return bool, parametrize enable_so_linger() with
>  timeout, don't open code DIV_ROUND_UP [Stefano]
>- Link to v5: https://lore.kernel.org/r/20250521-vsock-linger-v5-0-94827860d1d6@rbox.co
>
>Changes in v5:
>- Move unsent_bytes fetching logic to utils.c
>- Add a helper for enabling SO_LINGER
>- Accommodate for close() taking a long time for reasons unrelated to
>  lingering
>- Separate and redo the testcase [Stefano]
>- Enrich the comment [Stefano]
>- Link to v4: https://lore.kernel.org/r/20250501-vsock-linger-v4-0-beabbd8a0847@rbox.co
>
>Changes in v4:
>- While in virtio, stick to virtio_transport_unsent_bytes() [Stefano]
>- Squash the indentation reduction [Stefano]
>- Pull SOCK_LINGER check into vsock_linger() [Stefano]
>- Don't explicitly pass sk->sk_lingertime [Stefano]
>- Link to v3: https://lore.kernel.org/r/20250430-vsock-linger-v3-0-ddbe73b53457@rbox.co
>
>Changes in v3:
>- Set "vsock/virtio" topic where appropriate
>- Do not claim that Hyper-V and VMCI ever lingered [Stefano]
>- Move lingering to af_vsock core [Stefano]
>- Link to v2: https://lore.kernel.org/r/20250421-vsock-linger-v2-0-fe9febd64668@rbox.co
>
>Changes in v2:
>- Comment that some transports do not implement unsent_bytes [Stefano]
>- Reduce the indentation of virtio_transport_wait_close() [Stefano]
>- Do not linger on shutdown(), expand the commit messages [Paolo]
>- Link to v1: https://lore.kernel.org/r/20250407-vsock-linger-v1-0-1458038e3492@rbox.co
>
>Changes in v1:
>- Do not assume `unsent_bytes()` is implemented by all transports [Stefano]
>- Link to v0: https://lore.kernel.org/netdev/df2d51fd-03e7-477f-8aea-938446f47864@rbox.co/
>
>Signed-off-by: Michal Luczaj <mhal@rbox.co>
>---
>Michal Luczaj (5):
>      vsock/virtio: Linger on unsent data
>      vsock: Move lingering logic to af_vsock core
>      vsock/test: Introduce vsock_wait_sent() helper
>      vsock/test: Introduce enable_so_linger() helper
>      vsock/test: Add test for an unexpectedly lingering close()
>
> include/net/af_vsock.h                  |  1 +
> net/vmw_vsock/af_vsock.c                | 33 +++++++++++++
> net/vmw_vsock/virtio_transport_common.c | 21 +--------
> tools/testing/vsock/util.c              | 38 +++++++++++++++
> tools/testing/vsock/util.h              |  2 +
> tools/testing/vsock/vsock_test.c        | 83 +++++++++++++++++++++++----------
> 6 files changed, 134 insertions(+), 44 deletions(-)
>---
>base-commit: f44092606a3f153bb7e6b277006b1f4a5b914cfc
>change-id: 20250304-vsock-linger-9026e5f9986c
>
>Best regards,
>-- 
>Michal Luczaj <mhal@rbox.co>
>


