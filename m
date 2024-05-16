Return-Path: <kvm+bounces-17522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C85F8C7279
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 10:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CD751F21934
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 08:10:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 545E712DDAF;
	Thu, 16 May 2024 08:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z79csfdq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F0480C03
	for <kvm@vger.kernel.org>; Thu, 16 May 2024 08:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715847012; cv=none; b=YBf42j2fqVnm+2OKgSFL5cyD9rPwFWY8nEp3BJCe9zys//GDQedXyByELQQ4etJgLA4qOUmzNgg0Dmtao2DUZ4VEyJsK1u2T7a2hui6MGcvteP/cvpvLvU5WAJiSZscAAHse2HmIC0lroQ9bunDvbm530YXMRcvIvLrpU1wWxdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715847012; c=relaxed/simple;
	bh=k4p6BZBD6f8DVa1WslyLTAjRuEA4N0NOBDUZFqG9OjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a+/VqCe52ZPAztAAPHZrKX2ufxbofzaXlDcIFM1Lv/Y+jI5ovwJ5tnhXvuVv8hHVyr93Z6JrPUN6XZqz/XdZ7I+jHVRu1db9fTPQjihRcO4GgzUhQwWfo4LViecrWzGPTExyRwYh/OiB73rPpxQDkKuZzi7H++EV+D0hbi/dbtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z79csfdq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715847009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RA+jepTOChJ7+snqX+5DRaDKCp4RJQjDydrDRBP3COs=;
	b=Z79csfdqLPvF4Y7CV217LrDZMOGa6JrdAKDpAwJ54oRUVq/t1QnOeY3cHq/ccQwy3Ipv/i
	wCxFhwt8aHUBE+VZOCd6igtq/2z4FeHcY6CxVM/GBkN5npewZXAXoZbeDxYnEAzEMS2rte
	hcvgGOArQ8+ckiXp0FmYLR3EvurN5mY=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-597-ratCVvTOOQeFDr3-FqMrvw-1; Thu, 16 May 2024 04:10:03 -0400
X-MC-Unique: ratCVvTOOQeFDr3-FqMrvw-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-a55709e5254so326810666b.3
        for <kvm@vger.kernel.org>; Thu, 16 May 2024 01:10:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715847002; x=1716451802;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RA+jepTOChJ7+snqX+5DRaDKCp4RJQjDydrDRBP3COs=;
        b=Cx7Pe1uP3+Si53g8NzMuLhF1qYKQoYL7V/BY7h4TeTzQzTeFW1N/2z44XKnThxdRfK
         V63pvwxjKTEe/aw0Mpn0CJv42jLUEB5xIBcuj4KI3Zkjud7TxzebeKalHj3RgOZWs2cS
         trZRmtSpYtb4ySlNHmvkZdqyfRaFkKGIDnalTpAyFZqMN4yS2Oip5frdUsGXJNRDyiCE
         nuG9op36ae35MDATVJINPJ6XJvIgetQNdm6meMJGStl/PKp5qFKFZNNyDQVmKGL0AHSM
         b3o0vYeX3XvRFFWjzBrX6UdUMbeloBG8UEb+ZAVTiYrvXioq0hpX6ccUcdUa1UZtALX9
         R/eg==
X-Forwarded-Encrypted: i=1; AJvYcCVacB0maY750Wo7PVuFJIAFw+Da3/g4YfkKyClC8giuO25q06FHNpmLhi3L+JKNS60bl1dhW8QxzILzpp/Qjqy/Kd56
X-Gm-Message-State: AOJu0YxV1PjOfQPOoW4nWr15xCQ/6ng6pF7+/kg1pTl+AhM1bqMLBW9o
	EwqRMei5Zm+ckbbRnZqq+FH7+UUMyKuohc46OGX4Y+YpDkdc9YUu0QbAdQ6cPYXi3lmUOnjIP3q
	TV2WEWXJtx6lYIkNtuNOn8pe2vcJDrz3Yjz0MYJA8zrA/Z87M3g==
X-Received: by 2002:a17:906:37d6:b0:a55:9dec:355f with SMTP id a640c23a62f3a-a5a2d676774mr1102992666b.70.1715847002082;
        Thu, 16 May 2024 01:10:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDQyscwxbqGC7a+Epkh0Xcy/QL4T1fDS/fLANmDq3+Ubkm9JOf+n6UBt4e0RPv0Wj5wD462A==
X-Received: by 2002:a17:906:37d6:b0:a55:9dec:355f with SMTP id a640c23a62f3a-a5a2d676774mr1102990066b.70.1715847001507;
        Thu, 16 May 2024 01:10:01 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-77.business.telecomitalia.it. [87.12.25.77])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5a17b01598sm963957166b.178.2024.05.16.01.10.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 01:10:00 -0700 (PDT)
Date: Thu, 16 May 2024 10:09:56 +0200
From: Stefano Garzarella <sgarzare@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com, Jeongjun Park <aha310510@gmail.com>, 
	Arseny Krasnov <arseny.krasnov@kaspersky.com>, "David S . Miller" <davem@davemloft.net>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, kvm@vger.kernel.org, virtualization@lists.linux.dev, 
	netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: always initialize seqpacket_allow
Message-ID: <mci7jdezdtzgoxj7zgecf4zyvxk6jixy4jgcwwoxegzkjqqqtx@7zoborovztcs>
References: <bcc17a060d93b198d8a17a9b87b593f41337ee28.1715785488.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <bcc17a060d93b198d8a17a9b87b593f41337ee28.1715785488.git.mst@redhat.com>

On Wed, May 15, 2024 at 11:05:43AM GMT, Michael S. Tsirkin wrote:
>There are two issues around seqpacket_allow:
>1. seqpacket_allow is not initialized when socket is
>   created. Thus if features are never set, it will be
>   read uninitialized.
>2. if VIRTIO_VSOCK_F_SEQPACKET is set and then cleared,
>   then seqpacket_allow will not be cleared appropriately
>   (existing apps I know about don't usually do this but
>    it's legal and there's no way to be sure no one relies
>    on this).
>
>To fix:
>	- initialize seqpacket_allow after allocation
>	- set it unconditionally in set_features
>
>Reported-by: syzbot+6c21aeb59d0e82eb2782@syzkaller.appspotmail.com
>Reported-by: Jeongjun Park <aha310510@gmail.com>
>Fixes: ced7b713711f ("vhost/vsock: support SEQPACKET for transport").
>Cc: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>Cc: David S. Miller <davem@davemloft.net>
>Cc: Stefan Hajnoczi <stefanha@redhat.com>
>Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>Acked-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>Tested-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
>
>---
>
>
>Reposting now it's been tested.
>
> drivers/vhost/vsock.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)

Thanks for fixing this issue!

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>


