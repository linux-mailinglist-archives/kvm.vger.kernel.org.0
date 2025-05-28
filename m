Return-Path: <kvm+bounces-47850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AA77AAC62F6
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:27:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E91EC3BCDF2
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 07:27:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE5E24469C;
	Wed, 28 May 2025 07:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UodbTcyN"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C2322ACD3
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 07:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748417253; cv=none; b=r19Id1BYi5YYaQfUcraGpzyAjbpqiLt6d7FH2FJ2HIxOOnUi9sGxzzJmBxS9S1dckNDEM5LezKK/8cDTy9CHO+2XKn86OQi1B8lqWaCNnzDMZiNV+Igl/RpyKHG6uIFLyEB3Mz+RrKJ53kqnE4zSAuEB7rckJJrb2bxX5pv7dv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748417253; c=relaxed/simple;
	bh=4d2Rvh5/049QiSFiG8HqsMtGYGDNAUWELzNpSKTOFQk=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=YoVRumk2VdXHcDoQVoPr4KTCiTIHFEYtSOMoWqslJf5FSBaKkMY5bALp8CqwCqQPb+LXpbXHo720OqEog3+feNJ5jBXTF583iggol5cQdFfmJ15jDAf1i9dingY3qi6A0oEfZ05jfKZdf3dyG3txq9hFzwJkpqbDhy5lREP5NB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UodbTcyN; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748417250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=u7w+oFgheV8aZ4x33cyzyZZ5cNI/GkUhBQCV4X7SdIs=;
	b=UodbTcyNOHCaPYjY0DBJYwqkttxSTSsApqgOAmNC/CeR/j+kL+UioPbCSXxlIzWoVYVfT6
	fT1cwn0woZvXVB6ATugi9XdfPqns5KMOHz4PecUICd10WGMFGLmmmr79dUOwv8Q/nZBZqk
	fTkm0WB3AyjMoLAHU2gpYw7h+ecWnWE=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-wj3zA2w0Ns2k5J9nTkTYVw-1; Wed, 28 May 2025 03:27:29 -0400
X-MC-Unique: wj3zA2w0Ns2k5J9nTkTYVw-1
X-Mimecast-MFC-AGG-ID: wj3zA2w0Ns2k5J9nTkTYVw_1748417248
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-450787c8626so1679325e9.1
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 00:27:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748417248; x=1749022048;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u7w+oFgheV8aZ4x33cyzyZZ5cNI/GkUhBQCV4X7SdIs=;
        b=twpot5HVMYDPdsqlk/VoAo1Z/M5Mpc6nBlEjr72HqOCmQlPzB3fSSr/uAzuMXjCz8D
         eBCXgIOkzZr0f9/7IOH8lajy/WySMUcwhhKRJ8q7u4bxOU35bWjJNoEvAAw/I7d3Hmyk
         HSE5wamZh/oThD6gj2TnNKzuxRLiq1xfA4K8m4ipDFYwJ5e9sb4+ixBWkily/CeRKGxk
         KEx4LO5TOtDOMDOpeVihd1XD1tlzKPhlAtgPsFzm/WYMXRXw1VdWMTejYHpyYPTwlxnB
         1rYA2XewGRzB++A4+TAapsK3psuKUKVi3fG6xn7m20wjceflmPPFY4cEcf2aGm/OYukT
         lDLQ==
X-Gm-Message-State: AOJu0YwrAYB/Z5+9QH3fxfJ9LbB4YHsea7UnbFMThtAQKIEOq/ckGLq+
	g523WGzRtGBrpDBy6FW3QjCsbYjNpWVu+ATfwUeBhKqqGL4kjTQ4nFaHyJPu1Nm/mwK7JYEpT2M
	Yyy/vMXGcB0B9ZOdvDvGwYsrG/dHnN0h85NiWN1hm0vfabcheSEUFCg==
X-Gm-Gg: ASbGnctfGYggFrQQj0Mx0QjDg6uKIZufl9dHahtLFrK57eFfY2tRLBUoVER6wJlcrOD
	9iYoh0OpeEmX1qfWQ0BNn967qtH3EeZSK9fnd78orGHBtBZfqS3xBr9NprHshFilbrMSrqszPRQ
	z45CaWzhlT8cPVIDVT5NXBW31/s8o1u1qRHXXEdjX9e4tb0VPMbhiWiQYbqoMMhrH3ffTTFC9+8
	DrLuntqwOdFYUyAiSdIG91n+Ljd+nLvZuaQ4XJZNPP8BY8Uq5v76kTtk9BPIs0yPl3xIfJBcsLA
	+keDHw==
X-Received: by 2002:a05:600c:4e45:b0:442:f4a3:8c5c with SMTP id 5b1f17b1804b1-44c919e13ddmr185732495e9.10.1748417247877;
        Wed, 28 May 2025 00:27:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEltm4UmhdICUHUpMHmQNZNYzagk6xfrMPG1SMAdHiF25jVtOn4A91e8E91qUEsAR8QkJYhDQ==
X-Received: by 2002:a05:600c:4e45:b0:442:f4a3:8c5c with SMTP id 5b1f17b1804b1-44c919e13ddmr185732135e9.10.1748417247448;
        Wed, 28 May 2025 00:27:27 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450064ae775sm12042235e9.22.2025.05.28.00.27.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 May 2025 00:27:26 -0700 (PDT)
Date: Wed, 28 May 2025 03:27:24 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	alexandre.belloni@bootlin.com, dongli.zhang@oracle.com, hch@lst.de,
	israelr@nvidia.com, kees@kernel.org, leiyang@redhat.com,
	mst@redhat.com, phasta@kernel.org, quic_philber@quicinc.com,
	sami.md.ko@gmail.com, vattunuru@marvell.com
Subject: [GIT PULL] virtio, vhost: features, fixes
Message-ID: <20250528032724-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent

Hi Linus,
There are several bugfixes I'm testing for post rc1 on top of this, but they
are pretty minor.


The following changes since commit a5806cd506af5a7c19bcd596e4708b5c464bfd21:

  Linux 6.15-rc7 (2025-05-18 13:57:29 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 206cc44588f72b49ad4d7e21a7472ab2a72a83df:

  virtio: reject shm region if length is zero (2025-05-28 03:19:03 -0400)

----------------------------------------------------------------
virtio, vhost: features, fixes

A new virtio RTC driver.

vhost scsi now logs write descriptors so migration works.

Some hardening work in virtio core.

An old spec compliance issue fixed in vhost net.

A couple of cleanups, fixes in vringh, virtio-pci, vdpa.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Christoph Hellwig (1):
      vringh: use bvec_kmap_local

Dongli Zhang (5):
      vhost: modify vhost_log_write() for broader users
      vhost-scsi: adjust vhost_scsi_get_desc() to log vring descriptors
      vhost-scsi: log I/O queue write descriptors
      vhost-scsi: log control queue write descriptors
      vhost-scsi: log event queue write descriptors

Israel Rukshin (1):
      virtio-pci: Fix result size returned for the admin command completion

Kees Cook (1):
      vhost: vringh: Use matching allocation type in resize_iovec()

Peter Hilber (4):
      virtio_rtc: Add module and driver core
      virtio_rtc: Add PTP clocks
      virtio_rtc: Add Arm Generic Timer cross-timestamping
      virtio_rtc: Add RTC class driver

Philipp Stanner (1):
      vdpa/octeon_ep: Control PCI dev enabling manually

Sami Uddin (1):
      virtio: reject shm region if length is zero

 MAINTAINERS                              |    7 +
 drivers/vdpa/octeon_ep/octep_vdpa_main.c |   17 +-
 drivers/vhost/scsi.c                     |  190 +++-
 drivers/vhost/vhost.c                    |   28 +-
 drivers/vhost/vringh.c                   |   19 +-
 drivers/virtio/Kconfig                   |   64 ++
 drivers/virtio/Makefile                  |    5 +
 drivers/virtio/virtio_pci_modern.c       |   13 +-
 drivers/virtio/virtio_rtc_arm.c          |   23 +
 drivers/virtio/virtio_rtc_class.c        |  262 ++++++
 drivers/virtio/virtio_rtc_driver.c       | 1407 ++++++++++++++++++++++++++++++
 drivers/virtio/virtio_rtc_internal.h     |  122 +++
 drivers/virtio/virtio_rtc_ptp.c          |  347 ++++++++
 include/linux/virtio_config.h            |    2 +
 include/uapi/linux/virtio_rtc.h          |  237 +++++
 15 files changed, 2707 insertions(+), 36 deletions(-)
 create mode 100644 drivers/virtio/virtio_rtc_arm.c
 create mode 100644 drivers/virtio/virtio_rtc_class.c
 create mode 100644 drivers/virtio/virtio_rtc_driver.c
 create mode 100644 drivers/virtio/virtio_rtc_internal.h
 create mode 100644 drivers/virtio/virtio_rtc_ptp.c
 create mode 100644 include/uapi/linux/virtio_rtc.h


