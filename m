Return-Path: <kvm+bounces-40705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E284A5A5B2
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 22:09:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A539C1884C6B
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 21:09:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E82E91D7994;
	Mon, 10 Mar 2025 21:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HOlds9A5"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592851DE2DF
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741640940; cv=none; b=f3rP2So2QixPJRo4MHT2s3Ti8l8mJapTADo3Wy4CVSufJHn8sIuo5x/M7z8bkyXyngYzBAWFuDEoR3XlQYlT5SNMWp09r7NVOg9ndLFufekzoPMc7MBUP+i6D71i9APQexf8ySmX4xU6STmC3i9UAoumWhZvboCVIs4XK7hfcg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741640940; c=relaxed/simple;
	bh=L2wq15UItCiN04BIyCvZmtzf97dq/7ag+fNk4WjCasg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d7FiAM9WaMeOPHffB/yJLNedoWK7kmo411IP1c2qtXZC/oAV7hSFv/BphT5benE2qqerCpu6AVhzr9/BH70BPf/Z2TyI/AtVttAGxGl2zyHurIOUPBmiV7YYnd9wIaAekgbsTNADrDJreHrts2L/MiNnBFLHiBWMhJa1cRm04RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HOlds9A5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741640937;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SvMGLxhh+ZiXjvBM74tRFWSSYebdSD0/MkQ6jTYRHSk=;
	b=HOlds9A5bASAcMBNZCJqbGRv42xG6Kqg8b4kre40+Sswdnax/eZO1nLSzgi0rmcTdLeDr6
	PzNFJGdfbT3ouwGV5+tD29lx9EL1G9gfolDp1LDfbQu6F4MYgye7vLTyuQp8QxbZaCXNAo
	ONIz7g8TwKS7s/do7Y+5T+6F8K/U0XQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-470-vVjNr17qMySHniBsd-8Luw-1; Mon, 10 Mar 2025 17:08:56 -0400
X-MC-Unique: vVjNr17qMySHniBsd-8Luw-1
X-Mimecast-MFC-AGG-ID: vVjNr17qMySHniBsd-8Luw_1741640935
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d43405d1baso3290255ab.0
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 14:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741640935; x=1742245735;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SvMGLxhh+ZiXjvBM74tRFWSSYebdSD0/MkQ6jTYRHSk=;
        b=f1602t+jp5GtktXEK15QY98mcinYRjWPxdgeOvjZBr8eH5q0tUkA4JpjLW30ijWebb
         CvMGyoP0YfSfbIOfK4PNlbRT57dX8qMG5cm8xEHUoTib/cGGYaf0ka49osO7owmZoIvr
         7tGFy3o5ngcoTngmRxW1x/VpiwFgl6VZ61wEn2AWzT+eNbqnFjMFmk4ssTfxq9ZK5dHS
         oV/C+VRu9JfAOGeac0i6vvir7QEQvIt1bBio9rfyiMydqeXeHHD0XRPWxMX14F2ssxBP
         jm/uwPEPWNzumZ159m/rPdBv9ZYAKkacm200D4Ms7F6tLmncODz0wQ6tzuHr4O+TioBk
         2nCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVECa+wBf25Xw/i4/GYauyXkLYaiA1erkSjr/pcSWH60RcY2MEGmIOyAaslLbNAkBlJMvY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDR1J3dyFaayM7nIADQnC7fZ11DvSxG6iYFDUtqHhHY2L0wtiY
	9j06NwOxOAl8eu7X5Bm3B5k92dbU69oWFh+G9nwm+/qLe29/5CsSYnVuWK+1SXApFZ8XGDCZpEb
	VWCt7BN3kst+quTadWS13M7KxtFBqqVt1ZOswNCZtTagwEiow/Q==
X-Gm-Gg: ASbGncv3UroUHb7nB4uYvl9NOKHlfwZvkUCLPBTmapjMGh7bdSbe11bBEbckgZ0vgsE
	zrN7Rf2ckCDXFaXOd4V4sA51JIUas1uy2jDFnQeLMacsdh3cx+8TAKkjUQdhGNjGqjGpx87sqJf
	ozCd4Sxz5iqIQ7OvGPYKxzf5WC1CLX55es6EtNLe2/2fKGsCYc88gFYqxDegWxqdjq+9gHAryAn
	CSY7JyqqMc6zr5baHftR/IwGZm3A5rNg53A/x5xfy2C7a/sP6XLFU7m4dUw/ZmkbYjPTCWr9tdA
	BHf6r4Rgu0En/hJNVak=
X-Received: by 2002:a05:6e02:1a24:b0:3d4:3d13:e5fc with SMTP id e9e14a558f8ab-3d46899f135mr3923675ab.5.1741640935361;
        Mon, 10 Mar 2025 14:08:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmNDJ2pRGpp9uY0mu1cCccVjJS8JHYTtTcVWJbMxUlnrc80/38LgZSUF0a1GBpMv/1LQn6Cw==
X-Received: by 2002:a05:6e02:1a24:b0:3d4:3d13:e5fc with SMTP id e9e14a558f8ab-3d46899f135mr3923535ab.5.1741640935057;
        Mon, 10 Mar 2025 14:08:55 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f21552b5d5sm2031142173.77.2025.03.10.14.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 14:08:53 -0700 (PDT)
Date: Mon, 10 Mar 2025 15:08:50 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <jgg@nvidia.com>, <mst@redhat.com>, <jasowang@redhat.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <israelr@nvidia.com>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <maorg@nvidia.com>
Subject: Re: [PATCH V1 vfio] vfio/virtio: Enable support for virtio-block
 live migration
Message-ID: <20250310150850.5d61a387.alex.williamson@redhat.com>
In-Reply-To: <20250302162723.82578-1-yishaih@nvidia.com>
References: <20250302162723.82578-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 2 Mar 2025 18:27:23 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> With a functional and tested backend for virtio-block live migration,
> add the virtio-block device ID to the pci_device_id table.
> 
> Currently, the driver supports legacy IO functionality only for
> virtio-net, and it is accounted for in specific parts of the code.
> 
> To enforce this limitation, an explicit check for virtio-net, has been
> added in virtiovf_support_legacy_io(). Once a backend implements legacy
> IO functionality for virtio-block, the necessary support will be added
> to the driver, and this additional check should be removed.
> 
> The module description was updated accordingly.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
> Changes from V0:
> https://lore.kernel.org/kvm/20250227155444.57354e74.alex.williamson@redhat.com/T/
> 
> - Replace "NET,BLOCK" with "NET and BLOCK" for readability, as was
>   suggested by Alex.
> - Make the tristate summary more generic as was suggeted by Kevin and
>   Alex.
> - Add Kevin Tian Reviewed-by clause.
> 
>  drivers/vfio/pci/virtio/Kconfig     | 6 +++---
>  drivers/vfio/pci/virtio/legacy_io.c | 4 +++-
>  drivers/vfio/pci/virtio/main.c      | 5 +++--
>  3 files changed, 9 insertions(+), 6 deletions(-)

Applied to vfio next branch for v6.15.  Thanks,

Alex


