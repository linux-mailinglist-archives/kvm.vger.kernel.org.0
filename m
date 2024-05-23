Return-Path: <kvm+bounces-18052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD578CD640
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 16:55:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22B9C1F214A5
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275284690;
	Thu, 23 May 2024 14:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C7pdPEal"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B8EAD27
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 14:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716476101; cv=none; b=G0bLvyOMJ2TVUOK7GbWvgxGOqjDQyR1Kae4H/3lf4NzC7j10RrPhM0l3+lCiF9ORhfqiLoba3uLCkli6XL7PhNE2J+8rLUJlVlt14T6nKvCA6on4tYraEQmxGKOoS73t2EfJefsVUBj4FV1njoXQAyHTj5kdgVjFYjPtTvS8ezo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716476101; c=relaxed/simple;
	bh=IXR7S6Gc+F3sudLsZ8LWQ+6UJawqmAovn5NH00L+sI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IXLBZ60TEvOwO5pvSeUue6g3AZnbMcpGBz8ioDdOWiTgYhJ4lMuwCqYQ29X5mGX809GSIYcubpRYPaRyu46y5Jtqd9jYFHMmYCCc4oozQ6+8XfEhl7LwQR7SauwgLD/wkni9oB5fNwa6jfCXyg3FmoBIyJXk7JGh++P8crNYQBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C7pdPEal; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716476099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=F/IspulZ7ogp/9/Ev8vDQ4CFOVYGCYWHCfNnAnEppwY=;
	b=C7pdPEalU/POUZLOd81MGyp+EFCxmZ2hN8TdKNdIjmQL3HANam0tHKMcu2KaFY0CHfBsIf
	nwBEUQdZVvbxeEy53/J1ECUKGxDWkhQlNOcOgbtcYUMJDrLAbtG87fDoxXuIyndiQqAUuB
	vnpHjV4X3UOXLbfz+Y9fWFb1+Rvt9w8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-189-iXo0KZVvPS-yrWWsbTzECw-1; Thu, 23 May 2024 10:54:57 -0400
X-MC-Unique: iXo0KZVvPS-yrWWsbTzECw-1
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-2e262d63c70so13472561fa.3
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 07:54:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716476096; x=1717080896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F/IspulZ7ogp/9/Ev8vDQ4CFOVYGCYWHCfNnAnEppwY=;
        b=YXxGpHPDneXC96u/6LpVe4iY5ydfAMm1Bo8LFAV3q47YtgtSBna0xGkZ+zfxEh4jO/
         ZhqxT2OxFl2rOkrbZyUOWJsllz0Blyi4A2cmacTMO4w4K5eptNqDUju7UqZQ0ZsrEo+v
         IgyW9yXFfYi+YwAEPjg1DLEGdTUH4SQwULauuEIbv/m/QRl7vlu3FKdegblK+WJi+1K/
         BiqTRjshRzopQENEW1zUiUFm5lAOycMbHg7uzquC0LDqumMZ1YA9qU2Gd4qCtBQ4Og16
         8W5nuQXU+cW5A2rrKovir9EQjAJomDVFXa8ECZkNT5M9Ev+wxXfpkYuSYOXdeCTqPSty
         xovQ==
X-Forwarded-Encrypted: i=1; AJvYcCW92QlE3oh5aCJ7mWELSftrqFsUiBSZKNv4wEQV8U5/Mx6PiAcZxlulJVsRzzyUeH9m1+Sl8olTkfE7xi4RIlJjHEni
X-Gm-Message-State: AOJu0YyvPZ2AlGqRODJEiaqXw9lSz2EFNQPr877HbmMCuS3yMtXIYJoy
	jUPjeVrmD3JgY7nFwK6Tb1jMEN1q6wRACu0gL+RTrKRlUo4UjLb9r7m498dvo7x03R4vHqYKpY9
	zjF0uMqklGQKyVAAIoTNwWftYyd5p6QdN220XVcgTvRo6YSbFLA==
X-Received: by 2002:a2e:9042:0:b0:2e5:4e76:42df with SMTP id 38308e7fff4ca-2e94953fb10mr43723571fa.33.1716476096207;
        Thu, 23 May 2024 07:54:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGC0bLoBdXb54NPxLQ4coOeZyHZBFadFkv6sukQZSvxP4AKs7iWObQtZZHt9eGMKoAkua8+hQ==
X-Received: by 2002:a2e:9042:0:b0:2e5:4e76:42df with SMTP id 38308e7fff4ca-2e94953fb10mr43723241fa.33.1716476095561;
        Thu, 23 May 2024 07:54:55 -0700 (PDT)
Received: from redhat.com ([2.52.29.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a5cdeacb2casm1095429066b.67.2024.05.23.07.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 07:54:55 -0700 (PDT)
Date: Thu, 23 May 2024 10:54:40 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Xuewei Niu <niuxuewei97@gmail.com>
Cc: stefanha@redhat.com, sgarzare@redhat.com, davem@davemloft.net,
	kvm@vger.kernel.org, virtualization@lists.linux.dev,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Xuewei Niu <niuxuewei.nxw@antgroup.com>
Subject: Re: [RFC PATCH 0/5] vsock/virtio: Add support for multi-devices
Message-ID: <20240523104010-mutt-send-email-mst@kernel.org>
References: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240517144607.2595798-1-niuxuewei.nxw@antgroup.com>

On Fri, May 17, 2024 at 10:46:02PM +0800, Xuewei Niu wrote:
>  include/linux/virtio_vsock.h            |   2 +-
>  include/net/af_vsock.h                  |  25 ++-
>  include/uapi/linux/virtio_vsock.h       |   1 +
>  include/uapi/linux/vm_sockets.h         |  14 ++
>  net/vmw_vsock/af_vsock.c                | 116 +++++++++--
>  net/vmw_vsock/virtio_transport.c        | 255 ++++++++++++++++++------
>  net/vmw_vsock/virtio_transport_common.c |  16 +-
>  net/vmw_vsock/vsock_loopback.c          |   4 +-
>  8 files changed, 352 insertions(+), 81 deletions(-)

As any change to virtio device/driver interface, this has to
go through the virtio TC. Please subscribe at
virtio-comment+subscribe@lists.linux.dev and then
contact the TC at virtio-comment@lists.linux.dev

You will likely eventually need to write a spec draft document, too.

-- 
MST


