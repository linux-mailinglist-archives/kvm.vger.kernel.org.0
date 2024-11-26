Return-Path: <kvm+bounces-32544-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 264329D9EE1
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 22:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75BABB22B10
	for <lists+kvm@lfdr.de>; Tue, 26 Nov 2024 21:32:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B59041DFD95;
	Tue, 26 Nov 2024 21:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TH+I7DPX"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF8619CC3C
	for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 21:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732656716; cv=none; b=cE41h5puCWvhOqSbi6xWcKRbQbHUJG0OOreVd5OSZNU7y+EH4EUwwKkPEOSOR+zB03ggoBIZvbQcu6/ch0z4Zaumt9VKE6ymQJAYYxl24fkJr6cCN9yEySuQ0DphKXc7IECrEzRdoLkS38izXV4PcVNtG4v3Q5smQQtvIP4Oaq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732656716; c=relaxed/simple;
	bh=8OMHRkiCi97ruiJcLVrr97YdpLfrt/TPA63KIH/nLmc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=nXnffN1szQGil6RcdW4N+ZwzNfUdIkZZxXiGf4OpmKdQErqlaNTXV8qH82tu56+bDY+Ug+QlxCLFxX2oXWtnTl05ecpjC1UFz9eB3PEg/CN//4wiT+iu+Sv9LJSEKznkyGh22VbIZS8iEOrGBo2ihDHihOe4bjN6HjluI+pjsVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TH+I7DPX; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732656713;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=xkqp9/xR3kyxpno6c2H9dhk0sKgUGZ+r9W/EPsgXUW8=;
	b=TH+I7DPXfI/L3L2ujyi1K1Ldz4qWOJbRRIaHA89c0qDBLTeeBtQYbwl+oZo7QQPMC0xTUS
	hi8xwpjV6AbrohHzHV/nMvEI5Z9fJ/9+rByaQGZjYTpVO0Gn8eM9xkW7KNu/RWRD2BTD6W
	hGSD6bl+f8G4iRWbOMtl56XUAmc/y1U=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-7dvoxNjRO7ONLksSojkQww-1; Tue, 26 Nov 2024 16:31:52 -0500
X-MC-Unique: 7dvoxNjRO7ONLksSojkQww-1
X-Mimecast-MFC-AGG-ID: 7dvoxNjRO7ONLksSojkQww
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4349cbf726cso22846145e9.3
        for <kvm@vger.kernel.org>; Tue, 26 Nov 2024 13:31:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732656711; x=1733261511;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xkqp9/xR3kyxpno6c2H9dhk0sKgUGZ+r9W/EPsgXUW8=;
        b=O+ibELEw5gfQDuH9Ajor+540K4qxMnmNbh9LIKiL2uM8MM1pStPuy1DPg2mQtYPsa6
         2FtZGwru9KDOxzMf/k6KUsb9/zlOpau+B0MiFHkUAQWnKOxCZHctcvyset6AfODUGstG
         cj98c9Vahj6+OqD6uYbSEwsYUDnYRGh0mADshtKRvZeBRw0ZDTLbfpOUayALu+IwyKRs
         ZLSG4+A/aCIzyqjOlN8WYKzzHdH492YgSnQo4MMo+kxaUU5gDorf4tNS8ICgHuu53/jj
         Xxdd38Sj6i/WI4GStwj7Vqd6m7yZxxbdjaOz2s26XTNy5n+K8ms9jsmDH6sV2Xo3Rq9n
         mabQ==
X-Gm-Message-State: AOJu0YxEeyzHZuG28nCmWLlbINBF+rq19gog1VV2pdmfjHcB/HSks+5W
	0mInNtQWhD7iHEMoJICeDTwTVJ0o1wdhIjSGWx2Zaqz0CneoKMfZsvU3GQ9O544/YK7MmwkQJyn
	XYrLLmipFSfmnlY0/qTLthye1zmL9ZklLtvBwsMT+Bk8JojjsTg==
X-Gm-Gg: ASbGnctZD5BBvGY3gpHkHywLmOWti2OmocPdGMyLRygp4SqX0rfNozl0McPD86taVMN
	l8wMcNZzsIgQhc2n6TcKUpiQWFytfHbJDgVh/33ArLKMRghFY1rMGuTZLn3xmEHr7bjo51w5OZD
	WzWTP0pOkaKgi2IQ19/bR2q2tTiknIlMB09CmpQQ37pR6BgN6cwfqrr12mJZlVP9emZ3Adx4ffn
	9a6UdDfi0y71+M8EhU5+dvbOSAgM8muOOw+Dy6KEQ==
X-Received: by 2002:a05:600c:5253:b0:434:9da3:602b with SMTP id 5b1f17b1804b1-434a9dbc410mr6492345e9.5.1732656711119;
        Tue, 26 Nov 2024 13:31:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG5nabcDgZfdqXrFryICIVujIiggOe3vuLNf1LLX2fotJEhYc502dQloNv4ULPkl7YTJzP9XA==
X-Received: by 2002:a05:600c:5253:b0:434:9da3:602b with SMTP id 5b1f17b1804b1-434a9dbc410mr6492185e9.5.1732656710752;
        Tue, 26 Nov 2024 13:31:50 -0800 (PST)
Received: from redhat.com ([2a02:14f:1f0:4654:4e59:b33:d0e:9273])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434aa78c202sm90855e9.26.2024.11.26.13.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2024 13:31:49 -0800 (PST)
Date: Tue, 26 Nov 2024 16:31:44 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	colin.i.king@gmail.com, dtatulea@nvidia.com, eperezma@redhat.com,
	huangwenyu1998@gmail.com, jasowang@redhat.com, mgurtovoy@nvidia.com,
	mst@redhat.com, philipchen@chromium.org, si-wei.liu@oracle.com
Subject: [GIT PULL] virtio: features, fixes, cleanups
Message-ID: <20241126163144-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent


I was hoping to get vhost threading compat fixes in but no luck.
A very quiet merge cycle - I guess it's a sign we got a lot merged
last time, and everyone is busy testing. Right, guys?

The following changes since commit 83e445e64f48bdae3f25013e788fcf592f142576:

  vdpa/mlx5: Fix error path during device add (2024-11-07 16:51:16 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 6a39bb15b3d1c355ab198d41f9590379d734f0bb:

  virtio_vdpa: remove redundant check on desc (2024-11-12 18:07:46 -0500)

----------------------------------------------------------------
virtio: features, fixes, cleanups

A small number of improvements all over the place.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Colin Ian King (1):
      virtio_vdpa: remove redundant check on desc

Max Gurtovoy (2):
      virtio_fs: add informative log for new tag discovery
      virtio_fs: store actual queue index in mq_map

Philip Chen (1):
      virtio_pmem: Add freeze/restore callbacks

Si-Wei Liu (2):
      vdpa/mlx5: Fix PA offset with unaligned starting iotlb map
      vdpa/mlx5: Fix suboptimal range on iotlb iteration

Wenyu Huang (1):
      virtio: Make vring_new_virtqueue support packed vring

 drivers/nvdimm/virtio_pmem.c |  24 +++++
 drivers/vdpa/mlx5/core/mr.c  |  12 +--
 drivers/virtio/virtio_ring.c | 227 +++++++++++++++++++++++--------------------
 drivers/virtio/virtio_vdpa.c |   3 +-
 fs/fuse/virtio_fs.c          |  13 +--
 5 files changed, 159 insertions(+), 120 deletions(-)


