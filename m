Return-Path: <kvm+bounces-71039-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KId3Gp/3jmnbGAEAu9opvQ
	(envelope-from <kvm+bounces-71039-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 11:06:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DCE49134D9F
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 11:06:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0F819305EE98
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 10:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3566134FF59;
	Fri, 13 Feb 2026 10:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XKFPq7fR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="K1Bc2fTa"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0889F31D39F
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770977173; cv=none; b=r0qCGzI0i4UVn+jTHpCrGvWWtlt1m9pq7E7O09YJFkV4KLKcB1xz/eccmlHEGYtMp2stJL0VqcHHfuQEczoQkBxf/40Chl8qoK5AsmzdVtdbKpJ2XiJY+yoe4tSFHkrD4DR+TJmTXybQRwcg8h8Zc7WoggyH9HTnKFtin29eOuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770977173; c=relaxed/simple;
	bh=6mIELK5nNn7Xh+eT/MgDDxWv5iQfYKBRmUxr3AG1+lQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Gg5f7YjqXI1y6otzLKnVpgDfL5JlLoPVhtwzYjwJUOo2ofUwreI3oIdWuWOUAb6QPtS33quV6LBP/X9lcW/SjDBd8lHNOn8LgHKHSc+tXzZFMRZ+/0NERBNfgyDDlHLMbYb14fiDA/BqK+ScUyoy52G3BZQBLXoyp95+sUMJT58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XKFPq7fR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=K1Bc2fTa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770977170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=r1LQlvU779hukNCrleE0cgnZ7I3RlCxW4V1fZnT6UB4=;
	b=XKFPq7fRQ923zeAAUUyNSbvdGIe7x17zQFMJp1txiuSdv4hjzLC0QJ0CxSkADx80ULnhlS
	yaviPOBvi9mo1AVmQ4b1QF1/jup9nQbPOj+xisGY+VizW48aABMaVMByeZ4qR3/WKvvpAj
	0YmqhRfoIlkQO5eYZJM7SdSzNufaDQM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-sgVMfK-4O5OZCEJXzMRpLQ-1; Fri, 13 Feb 2026 05:06:08 -0500
X-MC-Unique: sgVMfK-4O5OZCEJXzMRpLQ-1
X-Mimecast-MFC-AGG-ID: sgVMfK-4O5OZCEJXzMRpLQ_1770977168
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48071615686so6587145e9.1
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 02:06:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770977167; x=1771581967; darn=vger.kernel.org;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r1LQlvU779hukNCrleE0cgnZ7I3RlCxW4V1fZnT6UB4=;
        b=K1Bc2fTa9K0K5/i3vxiR6Ufd6rL9r8JVlsORQBZ2hsVYJAhoyWJcPgd5KJRTCux8vm
         5Bqm5QakOT+SELGK4VpuQdnGqRkXGzg7XWDIGMgMTLVPqBTBWO4rV8fS/KLQg7QV89Lj
         qhP0OHLeJ6ixB5Fxt9VDvsv9Op6ZnqHs8ampv7PoLCQo5KtK96sNKcuEQvqp/FempHMN
         aWr+8M8RpkjhD2K2+I1AINxBwVT0AkvAPG8FjxEKmP1S9Foh6bLKiHAiObK92s7X1iS2
         fg+REfUKOkjavMWFdVRi/Eh5L3YheHpyKYCg4wh5z3RpcQbl7KUAkRay/qptAJze5A0F
         fhSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770977167; x=1771581967;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r1LQlvU779hukNCrleE0cgnZ7I3RlCxW4V1fZnT6UB4=;
        b=VWLati1XvSWrx0giJCK40IqEha9WUHCGc9F7RRC24jMj39udGy8HDTOYtC1bXMbG5j
         SOACxPItqIbATFsxg17mJHT7e7fK1P7V/SOExtaeTuqwaqXu6xrFs+SOrCY7nif+j0dJ
         WTjM+5gkL142BDppe1qME/vA+63211w/RFEa7B0V8O/oiZXIupJSAtcsNDxKz1e1RivT
         xoWT3BXAFN20hND6q8x9NqHkk5l/rxqAYc+yZaraFI9aE4tioRnDiRrx5UcnJvB74dKq
         j74hl3Dm8VEv2+7OdD4CEy4t9rx8GedfJzrxB/4RCZl2fZnMUZxVDYlM2KAQUTmCNnZP
         hDfA==
X-Gm-Message-State: AOJu0Ywvrzqgcf0BZvWoZ7wWyk/d6ER/NAgi+mVGpurN2UaXxigzeD+W
	Q+TjWy+RGTHXyZNn+5u6LAGHDC91o1qSMYS2/RRMlBvV79ThfsXtuMnk71U2i2oVBPRd7hkoSQw
	kYB26Kk2abSVVLOArGOtW51DQU6gMrT2Y/nVHMNH1PfrjJ9EsLYrr7g==
X-Gm-Gg: AZuq6aKm5YoJHarMEN/FizuVLKxw7FI545FYXWoVvGuS/tDJgDQoaxt/Oiadx8ZNSSG
	dGCVX+CIpmKc0eSFlMwfFuHAB9PZMmSJz1ygK7i4rKDoNULxCLK1T2Y9f7sJ6kMlx+HdtLaiG7i
	99F17kRA1pwK//kJxcfs5nvekM8QMtIMZH9iQtBQ4Bt7nz5aOYNSB9P/7cYA15yTtyfeAHB8mHa
	ZYroDbL9s3St9Q5scxji7ebODeI3XAwCv2NRj0u8h+a8/GngAyMIuB0Pr2Q8pReeDcc4tiyZYyd
	5PZVs69M9Uhu5yZjH+8IsnclcMbfnU038a5V9Bl9K35n13nhsExIIb4N3QVLP1/mxu6ytbKYYYz
	pCicZ/Sqway2Qj7hNxJ2sKavFYgpYPpXWHsTm3M5QH/PShw==
X-Received: by 2002:a05:600c:4704:b0:483:3380:ca11 with SMTP id 5b1f17b1804b1-48373a74dccmr18964895e9.33.1770977167369;
        Fri, 13 Feb 2026 02:06:07 -0800 (PST)
X-Received: by 2002:a05:600c:4704:b0:483:3380:ca11 with SMTP id 5b1f17b1804b1-48373a74dccmr18964275e9.33.1770977166842;
        Fri, 13 Feb 2026 02:06:06 -0800 (PST)
Received: from redhat.com (IGLD-80-230-34-155.inter.net.il. [80.230.34.155])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48371a21cbesm20921345e9.5.2026.02.13.02.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 02:06:06 -0800 (PST)
Date: Fri, 13 Feb 2026 05:06:02 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
	bartosz.golaszewski@oss.qualcomm.com, bp@alien8.de,
	eperezma@redhat.com, jasowang@redhat.com, jon@nutanix.com,
	kshankar@marvell.com, leiyang@redhat.com, lulu@redhat.com,
	maobibo@loongson.cn, mst@redhat.com, m.szyprowski@samsung.com,
	seanjc@google.com, sgarzare@redhat.com, stable@vger.kernel.org,
	thomas.weissschuh@linutronix.de, viresh.kumar@linaro.org,
	xiyou.wangcong@gmail.com, zhangdongchuan@eswincomputing.com
Subject: [GIT PULL] virtio,vhost,vdpa: features, fixes
Message-ID: <20260213050602-mutt-send-email-mst@kernel.org>
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
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.linux-foundation.org,arndb.de,oss.qualcomm.com,alien8.de,redhat.com,nutanix.com,marvell.com,loongson.cn,samsung.com,google.com,linutronix.de,linaro.org,gmail.com,eswincomputing.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71039-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[24];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mst@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: DCE49134D9F
X-Rspamd-Action: no action

The following changes since commit d8ee3cfdc89b75dc059dc21c27bef2c1440f67eb:

  vhost/vsock: improve RCU read sections around vhost_vsock_get() (2025-12-24 08:02:57 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to ebcff9dacaf2c1418f8bc927388186d7d3674603:

  vduse: avoid adding implicit padding (2026-02-09 12:21:32 -0500)

----------------------------------------------------------------
virtio,vhost,vdpa: features, fixes

- in order support in virtio core
- multiple address space support in vduse
- fixes, cleanups all over the place, notably
  - dma alignment fixes for non cache coherent systems

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Arnd Bergmann (1):
      vduse: avoid adding implicit padding

Bibo Mao (3):
      crypto: virtio: Add spinlock protection with virtqueue notification
      crypto: virtio: Remove duplicated virtqueue_kick in virtio_crypto_skcipher_crypt_req
      crypto: virtio: Replace package id with numa node id

Cindy Lu (3):
      vdpa/mlx5: update mlx_features with driver state check
      vdpa/mlx5: reuse common function for MAC address updates
      vdpa/mlx5: update MAC address handling in mlx5_vdpa_set_attr()

Eugenio Pérez (13):
      vhost: move vdpa group bound check to vhost_vdpa
      vduse: add v1 API definition
      vduse: add vq group support
      vduse: return internal vq group struct as map token
      vdpa: document set_group_asid thread safety
      vhost: forbid change vq groups ASID if DRIVER_OK is set
      vduse: refactor vdpa_dev_add for goto err handling
      vduse: remove unused vaddr parameter of vduse_domain_free_coherent
      vduse: take out allocations from vduse_dev_alloc_coherent
      vduse: merge tree search logic of IOTLB_GET_FD and IOTLB_GET_INFO ioctls
      vduse: add vq group asid support
      vduse: bump version number
      Documentation: Add documentation for VDUSE Address Space IDs

Jason Wang (19):
      virtio_ring: rename virtqueue_reinit_xxx to virtqueue_reset_xxx()
      virtio_ring: switch to use vring_virtqueue in virtqueue_poll variants
      virtio_ring: unify logic of virtqueue_poll() and more_used()
      virtio_ring: switch to use vring_virtqueue for virtqueue resize variants
      virtio_ring: switch to use vring_virtqueue for virtqueue_kick_prepare variants
      virtio_ring: switch to use vring_virtqueue for virtqueue_add variants
      virtio: switch to use vring_virtqueue for virtqueue_get variants
      virtio_ring: switch to use vring_virtqueue for enable_cb_prepare variants
      virtio_ring: use vring_virtqueue for enable_cb_delayed variants
      virtio_ring: switch to use vring_virtqueue for disable_cb variants
      virtio_ring: switch to use vring_virtqueue for detach_unused_buf variants
      virtio_ring: switch to use unsigned int for virtqueue_poll_packed()
      virtio_ring: introduce virtqueue ops
      virtio_ring: determine descriptor flags at one time
      virtio_ring: factor out core logic of buffer detaching
      virtio_ring: factor out core logic for updating last_used_idx
      virtio_ring: factor out split indirect detaching logic
      virtio_ring: factor out split detaching logic
      virtio_ring: add in order support

Jon Kohler (1):
      vhost: use "checked" versions of get_user() and put_user()

Kommula Shiva Shankar (1):
      vhost: fix caching attributes of MMIO regions by setting them explicitly

Michael S. Tsirkin (16):
      dma-mapping: add __dma_from_device_group_begin()/end()
      docs: dma-api: document __dma_from_device_group_begin()/end()
      dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN
      docs: dma-api: document DMA_ATTR_CPU_CACHE_CLEAN
      dma-debug: track cache clean flag in entries
      virtio: add virtqueue_add_inbuf_cache_clean API
      vsock/virtio: fix DMA alignment for event_list
      vsock/virtio: use virtqueue_add_inbuf_cache_clean for events
      virtio_input: fix DMA alignment for evts
      virtio_scsi: fix DMA cacheline issues for events
      virtio-rng: fix DMA alignment for data buffer
      virtio_input: use virtqueue_add_inbuf_cache_clean for events
      vsock/virtio: reorder fields to reduce padding
      gpio: virtio: fix DMA alignment
      gpio: virtio: reorder fields to reduce struct padding
      checkpatch: special-case cacheline group macros

Thomas Weißschuh (1):
      virtio: uapi: avoid usage of libc types

zhangdongchuan@eswincomputing.com (1):
      virtio_ring: code cleanup in detach_buf_split

 Documentation/core-api/dma-api-howto.rst           |   52 +
 Documentation/core-api/dma-attributes.rst          |    9 +
 Documentation/userspace-api/vduse.rst              |   53 +
 drivers/char/hw_random/virtio-rng.c                |    3 +
 drivers/crypto/virtio/virtio_crypto_common.h       |    2 +-
 drivers/crypto/virtio/virtio_crypto_core.c         |    5 +
 .../crypto/virtio/virtio_crypto_skcipher_algs.c    |    2 -
 drivers/gpio/gpio-virtio.c                         |   15 +-
 drivers/scsi/virtio_scsi.c                         |   17 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  156 +--
 drivers/vdpa/vdpa_sim/vdpa_sim.c                   |    6 -
 drivers/vdpa/vdpa_user/iova_domain.c               |   27 +-
 drivers/vdpa/vdpa_user/iova_domain.h               |    8 +-
 drivers/vdpa/vdpa_user/vduse_dev.c                 |  524 +++++++---
 drivers/vhost/vdpa.c                               |    5 +-
 drivers/vhost/vhost.c                              |    8 +-
 drivers/virtio/virtio_input.c                      |    5 +-
 drivers/virtio/virtio_ring.c                       | 1010 +++++++++++++++-----
 include/linux/dma-mapping.h                        |   20 +
 include/linux/vdpa.h                               |    4 +-
 include/linux/virtio.h                             |   11 +-
 include/uapi/linux/vduse.h                         |   85 +-
 include/uapi/linux/virtio_ring.h                   |    5 +-
 kernel/dma/debug.c                                 |   28 +-
 net/vmw_vsock/virtio_transport.c                   |   19 +-
 scripts/checkpatch.pl                              |    4 +-
 26 files changed, 1567 insertions(+), 516 deletions(-)


