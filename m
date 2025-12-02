Return-Path: <kvm+bounces-65171-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 72D3AC9CDDD
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 21:07:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 407434E11BB
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 20:07:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744E92F1FD1;
	Tue,  2 Dec 2025 20:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g9WCTS6X";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="X69a2Sp+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8A72E0B77
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 20:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764706050; cv=none; b=HNOJ3SnQmzuDVQUCCvfN9SfWL4TPr3lCufvE4yv+5sIjfzeMnEg+F03Oy3tnwGAXmur1VGoZ9eKRseD8DlltoJDquUC22phg06REocgmkczUZEmRHq9uTZ3KyCiJr626bFfcxBMaru7FsRjM8WqrsIhqWuhlqq6Jm6Vr+RZ6Glg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764706050; c=relaxed/simple;
	bh=oPYqW5SQfExXpPRUP0ZxO9mJN6N4rIx6CnioC/GrhKE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=knIBpw2AaX6toAiHJ8mMJQQIAYY52GaSpWUZ9nJEsSKVUQrn5KhhWVXCGDX8AKAubgya0iJNGFZI7ICFqgtiCInrRvYzDbQmasxaKSegyn+17ZXXXhltdIlP51UmFA/WVAVIWpcVo6e+bJ63L0LSsWm8oYPyjl3Ohx7jE8kINMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g9WCTS6X; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=X69a2Sp+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764706048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=4LOaJkYRfgWql4tAMEDx+EG8hV3Vr+6Q+ye5vso+PWc=;
	b=g9WCTS6XuS2E0xmR1sQqsZqLvqF84o/eAYPzc07fEffo9HYiLM6rd66hVKdP1K4VRCLn6e
	svMn/6poF3yCKwgPae/O5VfN+AHE/8hvIpB5swbFmrYFrvnEdyTL3v0Y8dA9V2VwkZe2V6
	+TEaCVLmhKagST+GKJ6cBl8vkcA39b4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-x1c8dp72OyCFO9R9tKH0DQ-1; Tue, 02 Dec 2025 15:07:26 -0500
X-MC-Unique: x1c8dp72OyCFO9R9tKH0DQ-1
X-Mimecast-MFC-AGG-ID: x1c8dp72OyCFO9R9tKH0DQ_1764706045
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4775f51ce36so44959685e9.1
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 12:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764706045; x=1765310845; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4LOaJkYRfgWql4tAMEDx+EG8hV3Vr+6Q+ye5vso+PWc=;
        b=X69a2Sp+YZaT9W5G2v72MxhvkoX+kumNUKmGbmL1VqTnA1i80gTWCWptP/mZN0hyD+
         hvQt2VzJwZ8l3jBlegL/jzJJ9JNkmuDSfop5GLkBe95guxychNITLYR8h2LREnK8rnRz
         IuUJ/wE4gJg4dYWl5856fT38ZMGy9SdKnpvcZK2z+xPJ7YtHAjM4iDdemzDLZz+kC/4U
         ctltbKg3jw2d2Qk6WGf28KZsjGp11QfZEIpQ8xouxTEe/XIYT5Ct6ivlkZF4bcR3UrqH
         WFzqKPvMRtrX2FFammA61qNyKqqM9VVHzYqUHVBGfNpnckHTNv/oS4PVjRpZb8YqtMyJ
         euAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764706045; x=1765310845;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4LOaJkYRfgWql4tAMEDx+EG8hV3Vr+6Q+ye5vso+PWc=;
        b=IH08yXnhITRaS/r1mx1UXGMUA00RYzR1nydMpd65ef/ePFtzmsmH3aIiZkBng/35ql
         QRYt5oQ9Hzwruu/joztsB42ttYP8RsLh5FYzTM2adSaMPRTK4IGEQis4yGq/oE5Ws6Nj
         1HqSFu02rPBAvlMHX2s5//pebUAgTsFti93Juiol1Kl5T2KodKP+FC/j+1DcyIyKWUrc
         skEF0KXWODwDOiK241hXawWqJ7E9g1mP7EhR6S9hZox0TVjlGdnGzzIFG2YKpQQaUkuj
         WzxTwNUYVuh5aT7P8NVEra++Gq9PgdiP2LJXWh9+38ghNKn+DTbeQh0p7kQXM2dRIA6V
         1ozQ==
X-Gm-Message-State: AOJu0YzuEO+x1E3imD4kJEdjgcpcfR5PgSaAKImDTo3pIICvOpUnGvOb
	kdlLZ5EFeu5+nfLPTvaY+ntYIzRg9UuY4jIQfZKFdBK0sycaABONvg7EFoKGv0sV3Y3TvDP+j1w
	Gbhe+F1IdenCAa6X/4231MOjwRYxtMtVdX54pxK3xjSG0cgq6a3UIIA==
X-Gm-Gg: ASbGncsDT6bd7XpBjUVWAlerttHa4KrhHJya1OTWKr/+Mc+t6ZwwKvo5T6VermcuwhF
	JpwD+7YmrdY7Mn/166hfuaMm8ezDtYBRgboWLUyewAC2HLngRAwEtpGw8+hQ7ECdSYOB8PK5Ttp
	ZBxVOIPMqZtVUUKESGZOy0Bg2/O3OssuMvdRN+nKTmSXoYjS00XlhaMzl5C1NelBbXt7bveLF8X
	bTBFzZyorB3iV/LuiFRixCiBwo617/rR0pRr9QcCD67iP0LRG7MSQDBRvj9vV18/YxUuJYoUl6x
	Cf9sm5F7KlCJ4/NKWYWdjnmDQ1jiVKiE+xYpB5etjO7Xcm/AqkdvGlRHi85mV3o0x3DhTSgrEQs
	kNN+h1RBea50IiYKPHLfrfTku+eJPxY0Q
X-Received: by 2002:a05:600c:5249:b0:477:9d54:58d7 with SMTP id 5b1f17b1804b1-4792a4aac08mr9281205e9.29.1764706045298;
        Tue, 02 Dec 2025 12:07:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE/agkXQ9hhx2CuGFlZ3EgTBLncuqp3bFvjDrGsXOBisReyUeJGrkEIqlYMZDfX1+cLbK1Uhw==
X-Received: by 2002:a05:600c:5249:b0:477:9d54:58d7 with SMTP id 5b1f17b1804b1-4792a4aac08mr9280895e9.29.1764706044801;
        Tue, 02 Dec 2025 12:07:24 -0800 (PST)
Received: from redhat.com (IGLD-80-230-38-228.inter.net.il. [80.230.38.228])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a8c5fdesm5614095e9.10.2025.12.02.12.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 12:07:24 -0800 (PST)
Date: Tue, 2 Dec 2025 15:07:21 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alex.williamson@redhat.com, alok.a.tiwari@oracle.com,
	jasowang@redhat.com, kriish.sharma2006@gmail.com,
	linmq006@gmail.com, marco.crivellari@suse.com,
	michael.christie@oracle.com, mst@redhat.com, pabeni@redhat.com,
	stable@vger.kernel.org, yishaih@nvidia.com
Subject: [GIT PULL] virtio,vhost: fixes, cleanups
Message-ID: <20251202150721-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

get_user/put_user change didn't spend time in next and
seems a bit too risky to rush. I'm keeping it in my tree
and we'll get it in the next cycle.


The following changes since commit ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d:

  Linux 6.18-rc7 (2025-11-23 14:53:16 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 205dd7a5d6ad6f4c8e8fcd3c3b95a7c0e7067fee:

  virtio_pci: drop kernel.h (2025-11-30 18:02:43 -0500)

----------------------------------------------------------------
virtio,vhost: fixes, cleanups

Just a bunch of fixes and cleanups, mostly very simple. Several
features are merged through net-next this time around.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Alok Tiwari (3):
      virtio_vdpa: fix misleading return in void function
      vdpa/mlx5: Fix incorrect error code reporting in query_virtqueues
      vdpa/pds: use %pe for ERR_PTR() in event handler registration

Kriish Sharma (1):
      virtio: fix kernel-doc for mapping/free_coherent functions

Marco Crivellari (2):
      virtio_balloon: add WQ_PERCPU to alloc_workqueue users
      vduse: add WQ_PERCPU to alloc_workqueue users

Miaoqian Lin (1):
      virtio: vdpa: Fix reference count leak in octep_sriov_enable()

Michael S. Tsirkin (11):
      virtio: fix typo in virtio_device_ready() comment
      virtio: fix whitespace in virtio_config_ops
      virtio: fix grammar in virtio_queue_info docs
      virtio: fix grammar in virtio_map_ops docs
      virtio: standardize Returns documentation style
      virtio: fix virtqueue_set_affinity() docs
      virtio: fix map ops comment
      virtio: clean up features qword/dword terms
      vhost/test: add test specific macro for features
      vhost: switch to arrays of feature bits
      virtio_pci: drop kernel.h

Mike Christie (1):
      vhost: Fix kthread worker cgroup failure handling

 drivers/vdpa/mlx5/net/mlx5_vnet.c        |  2 +-
 drivers/vdpa/octeon_ep/octep_vdpa_main.c |  1 +
 drivers/vdpa/pds/vdpa_dev.c              |  2 +-
 drivers/vdpa/vdpa_user/vduse_dev.c       |  3 ++-
 drivers/vhost/net.c                      | 29 +++++++++++-----------
 drivers/vhost/scsi.c                     |  9 ++++---
 drivers/vhost/test.c                     | 10 ++++++--
 drivers/vhost/vhost.c                    |  4 ++-
 drivers/vhost/vhost.h                    | 42 ++++++++++++++++++++++++++------
 drivers/vhost/vsock.c                    | 10 +++++---
 drivers/virtio/virtio.c                  | 12 ++++-----
 drivers/virtio/virtio_balloon.c          |  3 ++-
 drivers/virtio/virtio_debug.c            | 10 ++++----
 drivers/virtio/virtio_pci_modern_dev.c   |  6 ++---
 drivers/virtio/virtio_ring.c             |  7 +++---
 drivers/virtio/virtio_vdpa.c             |  2 +-
 include/linux/virtio.h                   |  2 +-
 include/linux/virtio_config.h            | 24 +++++++++---------
 include/linux/virtio_features.h          | 29 +++++++++++-----------
 include/linux/virtio_pci_modern.h        |  8 +++---
 include/uapi/linux/virtio_pci.h          |  2 +-
 21 files changed, 131 insertions(+), 86 deletions(-)


