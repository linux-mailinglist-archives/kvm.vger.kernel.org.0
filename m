Return-Path: <kvm+bounces-42257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DAC93A76BFF
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 18:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B172D188D97F
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 16:34:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FFE214A66;
	Mon, 31 Mar 2025 16:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UF4MBujQ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305C62147E0
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 16:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743438854; cv=none; b=WCIDdapTZArckn8l4sYtmuKqPGbVE+oL4Dl2pyw8bLNosxduffBkNl+rxCbHcRiWKZlOk7XBH9CtyByP+IyGN1psbdImURMbe2bLMNs0XycVOxduINWE6VaPIOT9SJ8F2tcBk8Pjh9trQ4g9u6vhm/s+3Yf4BME/l9RY1lyVQ+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743438854; c=relaxed/simple;
	bh=LyymiZcnvyCARp+PZ9YDJ/WjZzd+um0odXUXVVG8jWU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=usVS5ekCZ7dJ8fAeCqoE6f6eB2JUwQlEeCveefSZsk+e6EL4FJQ7Z4gI5y0C2HTNV8cBJiPYFaztCi5c2BzHDAhdrHk8aC2R+gA2N559DtlOC89eyRLohkQp4uI04iD+7R6bIUpLKAJ1wcurkeRwhIeNmayKkV+/M99Ex/IsPLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UF4MBujQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743438851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=buRU4hcgPy2p/+OGQ7gQUBzV/bybYL5hkzFKdPTt7bo=;
	b=UF4MBujQ8sYrKPxc2J3IpGdlRIFP2AACCveL1IlsBvhYMcB+u05jWbewIBW8THsrMz1QXr
	R7mnTUYfZ57DFTHIzOV+SOFu8kH4VBjTBsOv2xYzq8jhEjzBOQNqc5WyZbZSynRzfASiN1
	VJS967WZi5sZtc4Y45RZo6AwTmh5d/A=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-dD0ZEN_vONmusNKzEIx4Jg-1; Mon, 31 Mar 2025 12:34:09 -0400
X-MC-Unique: dD0ZEN_vONmusNKzEIx4Jg-1
X-Mimecast-MFC-AGG-ID: dD0ZEN_vONmusNKzEIx4Jg_1743438849
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-43947a0919aso38460565e9.0
        for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 09:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743438848; x=1744043648;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=buRU4hcgPy2p/+OGQ7gQUBzV/bybYL5hkzFKdPTt7bo=;
        b=F4J5dYy2PVROjaPttp6KotlqIOzmAtl+xTy260hVf8iXLVkHtEHwd+74HVIzne/95f
         41jz6F1R8nhhmFSDMbqlXaHcVsGx4RLnNc1+85hcuB8LM/jLAgGXMak6ajbS+2QeHGvG
         qafMU7LlYEgo0pjhVlUUjHp8LtFRlyyzRJVx0Akpv628jvDxuRVmvi7HT6Wl/pzc6zBT
         pPZxSeT0W6Ddr33vcaYWNRf586NsGX+VoiGhNH6R5X+7CG9Lk+pyZfw0tkx7opHV1WKh
         7HndxplgU2hpXcDuVxXY7NHK/LzSN7UfuKGY0U8U++5Uz4kK8XxtfFgd1hMr8ZLkHDRE
         o0fA==
X-Gm-Message-State: AOJu0YyjqAggjJh7IsKeAU5Xan3u+vzUh0gD8nqbO2uX1RY7JuO2/M5U
	cWyJJaO4ArtMq6BWNswXxSAw0RRzlI7s1RSy4KwKDQCA338j8tOVaZLy6ImsUJAnDHqF7XqnpS1
	BAEj9GhkWAPj44hOtv1CEpZbac0VXyTUIdAvTnLoe6Azshkvaew==
X-Gm-Gg: ASbGnctmAFiPh8RiRamZDX8xlrWYHYqHx3xcVa3vv9lVCxLKw43xUyOqNZTulbRHYQk
	esfCaYMt63z+7Oi/M4Lbu1wpnXmQrtHwh43XpEm+wyR73y3Yd8GXUxPiL8E39YIR+Xttzle5D+o
	Q05F7Eyktae+Gkcuu99pBxu0w0+hbfwHZ8t6aQwUeg5BLwIOkA/1YEoY1wVHmY4qOkH4z1Negtg
	RDf51R3dkoqqa8kKUwq5hPIxnccAuEJPxnMrCyEmDGNHTBX6GDHQCwOkCM86aFEH3KLHm29h/uN
	ETFh7MbevA==
X-Received: by 2002:a05:600c:8117:b0:43c:efed:732d with SMTP id 5b1f17b1804b1-43e8e3cf858mr88891425e9.16.1743438848571;
        Mon, 31 Mar 2025 09:34:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRJoF9PNksiJNrRvv1RABMA+H1wRnu+cFNlckFr23sh4bFVTCISuxXvKws13VYTTCpsWyCEA==
X-Received: by 2002:a05:600c:8117:b0:43c:efed:732d with SMTP id 5b1f17b1804b1-43e8e3cf858mr88891065e9.16.1743438848107;
        Mon, 31 Mar 2025 09:34:08 -0700 (PDT)
Received: from redhat.com ([2a0d:6fc0:1517:1000:ea83:8e5f:3302:3575])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d82efeb11sm171403855e9.22.2025.03.31.09.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 09:34:07 -0700 (PDT)
Date: Mon, 31 Mar 2025 12:34:04 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	anton.yakovlev@opensynergy.com, bettyzhou@google.com,
	cong.meng@oracle.com, dtatulea@nvidia.com, eauger@redhat.com,
	eperezma@redhat.com, eric.auger@redhat.com,
	hongyu.ning@linux.intel.com, jasowang@redhat.com,
	jstultz@google.com, kernel-team@android.com, kshk@linux.ibm.com,
	linux-sound@vger.kernel.org, michael.christie@oracle.com,
	mst@redhat.com, perex@perex.cz, sgarzare@redhat.com,
	si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@redhat.com,
	tiwai@suse.com, virtualization@lists.linux.dev,
	wangyufeng@kylinos.cn, wh1sper@zju.edu.cn
Subject: [GIT PULL] virtio: features, fixes, cleanups
Message-ID: <20250331123404-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Mutt-Fcc: =sent

The following changes since commit d082ecbc71e9e0bf49883ee4afd435a77a5101b6:

  Linux 6.14-rc4 (2025-02-23 12:32:57 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 9d8960672d63db4b3b04542f5622748b345c637a:

  vhost-scsi: Reduce response iov mem use (2025-02-25 07:10:46 -0500)

----------------------------------------------------------------
virtio: features, fixes, cleanups

A small number of improvements all over the place:

shutdown has been reworked to reset devices.
virtio fs is now allowed in vduse.
vhost-scsi memory use has been reduced.

cleanups, fixes all over the place.

A couple more fixes are being tested and will be merged after rc1.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eugenio Pérez (1):
      vduse: add virtio_fs to allowed dev id

John Stultz (1):
      sound/virtio: Fix cancel_sync warnings on uninitialized work_structs

Konstantin Shkolnyy (1):
      vdpa/mlx5: Fix mlx5_vdpa_get_config() endianness on big-endian machines

Michael S. Tsirkin (1):
      virtio: break and reset virtio devices on device_shutdown()

Mike Christie (9):
      vhost-scsi: Fix handling of multiple calls to vhost_scsi_set_endpoint
      vhost-scsi: Reduce mem use by moving upages to per queue
      vhost-scsi: Allocate T10 PI structs only when enabled
      vhost-scsi: Add better resource allocation failure handling
      vhost-scsi: Return queue full for page alloc failures during copy
      vhost-scsi: Dynamically allocate scatterlists
      vhost-scsi: Stop duplicating se_cmd fields
      vhost-scsi: Allocate iov_iter used for unaligned copies when needed
      vhost-scsi: Reduce response iov mem use

Si-Wei Liu (1):
      vdpa/mlx5: Fix oversized null mkey longer than 32bit

Yufeng Wang (3):
      tools/virtio: Add DMA_MAPPING_ERROR and sg_dma_len api define for virtio test
      tools: virtio/linux/compiler.h: Add data_race() define.
      tools: virtio/linux/module.h add MODULE_DESCRIPTION() define.

 drivers/vdpa/mlx5/core/mr.c        |   7 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c  |   3 +
 drivers/vdpa/vdpa_user/vduse_dev.c |   1 +
 drivers/vhost/Kconfig              |   1 +
 drivers/vhost/scsi.c               | 549 +++++++++++++++++++++++--------------
 drivers/virtio/virtio.c            |  29 ++
 sound/virtio/virtio_pcm.c          |  21 +-
 tools/virtio/linux/compiler.h      |  25 ++
 tools/virtio/linux/dma-mapping.h   |  13 +
 tools/virtio/linux/module.h        |   7 +
 10 files changed, 439 insertions(+), 217 deletions(-)


