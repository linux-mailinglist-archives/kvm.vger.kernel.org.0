Return-Path: <kvm+bounces-55884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 381C7B384CD
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 16:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 2B62A4E37B7
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 14:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22E2A35A281;
	Wed, 27 Aug 2025 14:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gypvLYy2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEDF1E008B
	for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 14:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756304416; cv=none; b=bWxo97EsQV3I0RTFUac/G2qbYLKSW2AkGPrrx3l4ZOivE+LoJZGnYefn+HrPpiVujaYzWH26dGfkMJ/UWb9AVfkO9PqbL8q2s9nztu+J2h/1+Xbha+eojxYAAX3Vh/z4PdleH4nX4m9LUmJ9EksQNny7sn0nkiXCT3Jyd5qcnEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756304416; c=relaxed/simple;
	bh=HHk2BSgl9+A5isTV0Es7jKwwEf6+byROFUjgpG/p04U=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=u/w5IeP+x4qIM7EQ1RRvucdh8NQH9bKor4g59JiH0SQt/K404VBkxMMy3lvkbIUj1W4Nx3Xd5fGA74k/uR2msCtv8vpEY2s8yEKcxdV6j3oWHnCnst2k8P09IDuTMTWcJZqnpWMClx+rzG8c3jsAsr9s5jD/vET5uVNoTEG47P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gypvLYy2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756304413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=opDJ3bmxpJeKk5jilIGi+lkf0qL9GQCfD0EA1RSLjbc=;
	b=gypvLYy2y4OcW7fzO8GTv29fC8f/LPTmXJE8cntwPydXqUST5AcQpUFjlXkAQNvkO3jOIN
	tF2h8zltWq6oWawF1NEqpCOv66eHkhplXRqu4huMRQIXTvRzdyALOrIWuk2wRuW7wLdRkI
	cfFNdrlaimzosrHp+/B59jmV4OmNIoY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-FcXpaOZjOLWWhhpFS0BWQg-1; Wed, 27 Aug 2025 10:20:11 -0400
X-MC-Unique: FcXpaOZjOLWWhhpFS0BWQg-1
X-Mimecast-MFC-AGG-ID: FcXpaOZjOLWWhhpFS0BWQg_1756304410
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b05d31cso35074755e9.1
        for <kvm@vger.kernel.org>; Wed, 27 Aug 2025 07:20:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756304410; x=1756909210;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=opDJ3bmxpJeKk5jilIGi+lkf0qL9GQCfD0EA1RSLjbc=;
        b=h6oRDrsDhNU4pTwMlF5W2JRwsP2W1HoE5SY8+ZPsG8AJdbg9YLqzPlhrrsDpqdovFt
         YyROvPGrwXGESkGzxMRBIIjXGU5H7VuUQLN61Tfclk8sEdKPPZ6f1YRzXX3XPWBhQkdW
         r2tRLNNQL5mZ/cQS3KdGN4Cs2UhHRbUV2THHZH2gvnp84VlmhF4+v6v7Yg/WhunvAxNL
         em0KF8myhb/lYbsBCGg30TdGKXhQJF8XIklv5+Sz9X+xvG6xOL6JTr8zxh2ntCtVTdH8
         99hYRPf1JQBqlaJK/JOBzyFHWbeH2W4GOtrEcr41T80xOFewCk2a7J2216/SV83sCmo9
         +k7Q==
X-Gm-Message-State: AOJu0YxWOCX0JUhg9jn4tAnDbUg2DI6NkzyUHqTKxc+kb2g9WLL/A85M
	wD/XZriWfli3BavceQ4g5/hmWiHrKCL6IM4WkWdhlEvbixYQR6FvOzDYkZ2zCcU2OJTeMkV1kw6
	Ir+1M2rqNsgMmEE5GkFG/N/tSg5gnWBwc3F8ZYIAQfoMVt4y5hVTP6Q==
X-Gm-Gg: ASbGnctq05VqWLUXduCyiUulaChGpMAK97XMST0RovLZkHkUGLk3gnOffTj+PfSndSW
	Z388jGhS01ryscUUhcXWk2VHVVW5zHsMmREG6+P7AZY4Ja5Ls+TArxPq75zANq6UOB7Mie0ETN/
	iPGxXsrQnzKeIexTbunX0qpvJF4zk//wORjIkeTu0DJcRKZ46HRyIO2AoRz0WLgJd4QhJYcJb/a
	F+05T+bKz4LmK3B+uTDFZt3Kq2WaLIaL+DuHdhOR5RGxkm8X+wiMSvUrq7wE/mWLkJn94ho+2Dk
	aIfR/++u7QpR/zfB5NewmMl4w08PwmY=
X-Received: by 2002:a05:600c:4746:b0:459:d494:faf9 with SMTP id 5b1f17b1804b1-45b517a0bacmr187068595e9.10.1756304409954;
        Wed, 27 Aug 2025 07:20:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHFKNOtqoYfcFfl5BN6DYFKW7ddCHHcODDT/GXLs1RNGvAT7ubO6RW2Y1yIY5L1Dbp0HoJT5Q==
X-Received: by 2002:a05:600c:4746:b0:459:d494:faf9 with SMTP id 5b1f17b1804b1-45b517a0bacmr187068355e9.10.1756304409549;
        Wed, 27 Aug 2025 07:20:09 -0700 (PDT)
Received: from redhat.com ([185.137.39.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f3125ccsm32582585e9.19.2025.08.27.07.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 07:20:09 -0700 (PDT)
Date: Wed, 27 Aug 2025 10:20:04 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	arbn@yandex-team.com, igor.torrente@collabora.com,
	junnan01.wu@samsung.com, kniv@yandex-team.ru, leiyang@redhat.com,
	liming.wu@jaguarmicro.com, mst@redhat.com, namhyung@kernel.org,
	stable@vger.kernel.org, ying01.gao@samsung.com,
	ying123.xu@samsung.com
Subject: [GIT PULL] virtio,vhost: fixes
Message-ID: <20250827102004-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

The following changes since commit 1b237f190eb3d36f52dffe07a40b5eb210280e00:

  Linux 6.17-rc3 (2025-08-24 12:04:12 -0400)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 45d8ef6322b8a828d3b1e2cfb8893e2ff882cb23:

  virtio_net: adjust the execution order of function `virtnet_close` during freeze (2025-08-26 03:38:20 -0400)

----------------------------------------------------------------
virtio,vhost: fixes

More small fixes. Most notably this fixes a messed up ioctl #,
and a regression in shmem affecting drm users.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Igor Torrente (1):
      Revert "virtio: reject shm region if length is zero"

Junnan Wu (1):
      virtio_net: adjust the execution order of function `virtnet_close` during freeze

Liming Wu (1):
      virtio_pci: Fix misleading comment for queue vector

Namhyung Kim (1):
      vhost: Fix ioctl # for VHOST_[GS]ET_FORK_FROM_OWNER

Nikolay Kuratov (1):
      vhost/net: Protect ubufs with rcu read lock in vhost_net_ubuf_put()

Ying Gao (1):
      virtio_input: Improve freeze handling

 drivers/net/virtio_net.c               | 7 ++++---
 drivers/vhost/net.c                    | 9 +++++++--
 drivers/virtio/virtio_input.c          | 4 ++++
 drivers/virtio/virtio_pci_legacy_dev.c | 4 ++--
 drivers/virtio/virtio_pci_modern_dev.c | 4 ++--
 include/linux/virtio_config.h          | 2 --
 include/uapi/linux/vhost.h             | 4 ++--
 7 files changed, 21 insertions(+), 13 deletions(-)


