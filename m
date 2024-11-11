Return-Path: <kvm+bounces-31477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E2679C3FDF
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 14:51:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 14778B216BC
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2024 13:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C620A19E99B;
	Mon, 11 Nov 2024 13:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fj2HyuxV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BBD19E826
	for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 13:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731333089; cv=none; b=tfKZc601iesd10h9BK/yaInq4kC2Ah6kWBZLQqRZZEZ79nIGsq5lzSG1dMCE/7Hv+9BbLA4K9BXL2acOtEa7ieauYPnGTbr5vTidKwd8Dwtyql5pOwuXCbEedvW61ugGppyP6PLpWu3RqTjgWp69L5b23tOwuxp2rttiq6IUEJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731333089; c=relaxed/simple;
	bh=Czawgg0eHQCiBa/n9H4yWNVg6iyINBKzS2rt+c5jO0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=r1eyIbtIZtXINBtPUBc7Yk6e35BzO+tupMgqbrTKHbiiUblW1QbZPfPD0Ldd73zMo4uYruzaQFFy7bZNunPKWrQ3PF4+Ld1OhjYAI+XHei0xTBJPuNIKyObVZWHh5wkREI4kendPA3WLGzBPPt+yw2yix3ILIMc2COmXEfQwwDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Fj2HyuxV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731333086;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=SDgcf2zjsNemccSJG3/V1OaS/z5L3BgNHfGxAIvuYes=;
	b=Fj2HyuxVpTOTDiOZPipEQbR/Pc/77JoLVSW3rDJjYqBpN5Wppwyq/DT2pPJq5ZM3z7SUP9
	Il1orSi9GctydGtyjFjEbI5kzE4l9+oIJtdWYUTcCfKGMkauDs0Gy4sOYRJOFcaru2z9bk
	EjZk5gIe9AFdzjTctTDNu/wbkrvXWCQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-83-h1q7f4bcOHKT5_fjKgQDoA-1; Mon, 11 Nov 2024 08:51:24 -0500
X-MC-Unique: h1q7f4bcOHKT5_fjKgQDoA-1
X-Mimecast-MFC-AGG-ID: h1q7f4bcOHKT5_fjKgQDoA
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43157e3521dso32237955e9.1
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2024 05:51:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731333084; x=1731937884;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDgcf2zjsNemccSJG3/V1OaS/z5L3BgNHfGxAIvuYes=;
        b=tDtYDUr+K/IUo5kh/G9zCtzENmyjXdQWgwfyeCHz4tzwbOiIOofVyaNElaIzXGdNk2
         75b+HEi6c0qZIaeyGj1R4ZaffDVtcqtr2D6V9B5QWT74QFVtkziOxNoywSeEf/3rGboj
         rfoDSPcgLsx76acdx8p0i1rWdokIJnUAlQAyMxiDZXUMi8AtKObxFwr4PZ/RK37HrHtg
         9ovsamWrbt/hFbabac3oeqhJm+QuEuXotGK0IWaIR02ZgjrpFFR1leqZ1g+LOovYBz4a
         oLqxRq//cYp0GIiSEpzJjRsd0Eam0dgiGQ7YemLiDdImgvbAMaBrmJzOS43i3F/aImvP
         G80w==
X-Gm-Message-State: AOJu0YxU+hveqMd3vFQzuMMO9SViyJ4vkK8zl5ndrM3IMUIEpl477LIa
	//+SSUDLerBXYmKXxJ2lqItgdvvtajPmaWgE2iYPo7Yk1LhGpxwPvx6eXBNZRvqcIFQWEv78rJR
	qWKjA4qTZbRNNXRibe1StvVwR+/aeq9eh2eSG5SBlMg8uR2A7jA==
X-Received: by 2002:a05:600c:524d:b0:431:5465:807b with SMTP id 5b1f17b1804b1-432b751dcc3mr97623695e9.32.1731333083670;
        Mon, 11 Nov 2024 05:51:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGdl1MVOk6cXvoplWf4kpAyP0Q0PfmfJirwFRy6M9tNvfOSuKn0TM0JJ3TMSOe/6ZyakDUOBA==
X-Received: by 2002:a05:600c:524d:b0:431:5465:807b with SMTP id 5b1f17b1804b1-432b751dcc3mr97611965e9.32.1731333055694;
        Mon, 11 Nov 2024 05:50:55 -0800 (PST)
Received: from redhat.com ([2a02:14f:17a:7c39:766b:279:9fac:c5c8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432bc468d94sm68340235e9.0.2024.11.11.05.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 05:50:54 -0800 (PST)
Date: Mon, 11 Nov 2024 08:50:50 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	angus.chen@jaguarmicro.com, christophe.jaillet@wanadoo.fr,
	cvam0000@gmail.com, dtatulea@nvidia.com, eperezma@redhat.com,
	feliu@nvidia.com, gregkh@linuxfoundation.org, jasowang@redhat.com,
	jiri@nvidia.com, lege.wang@jaguarmicro.com, lingshan.zhu@kernel.org,
	mst@redhat.com, pstanner@redhat.com, qwerty@theori.io,
	v4bel@theori.io, yuancan@huawei.com
Subject: [GIT PULL] virtio: bugfixes
Message-ID: <20241111085050-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

The following changes since commit 59b723cd2adbac2a34fc8e12c74ae26ae45bf230:

  Linux 6.12-rc6 (2024-11-03 14:05:52 -1000)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 83e445e64f48bdae3f25013e788fcf592f142576:

  vdpa/mlx5: Fix error path during device add (2024-11-07 16:51:16 -0500)

----------------------------------------------------------------
virtio: bugfixes

Several small bugfixes all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Dragos Tatulea (1):
      vdpa/mlx5: Fix error path during device add

Feng Liu (1):
      virtio_pci: Fix admin vq cleanup by using correct info pointer

Hyunwoo Kim (1):
      vsock/virtio: Initialization of the dangling pointer occurring in vsk->trans

Philipp Stanner (1):
      vdpa: solidrun: Fix UB bug with devres

Shivam Chaudhary (1):
      Fix typo in vringh_test.c

Xiaoguang Wang (1):
      vp_vdpa: fix id_table array not null terminated error

Yuan Can (1):
      vDPA/ifcvf: Fix pci_read_config_byte() return code handling

 drivers/vdpa/ifcvf/ifcvf_base.c         |  2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c       | 21 +++++----------------
 drivers/vdpa/solidrun/snet_main.c       | 14 ++++++++++----
 drivers/vdpa/virtio_pci/vp_vdpa.c       | 10 +++++++---
 drivers/virtio/virtio_pci_common.c      | 24 ++++++++++++++++++------
 drivers/virtio/virtio_pci_common.h      |  1 +
 drivers/virtio/virtio_pci_modern.c      | 12 +-----------
 net/vmw_vsock/virtio_transport_common.c |  1 +
 tools/virtio/vringh_test.c              |  2 +-
 9 files changed, 45 insertions(+), 42 deletions(-)


