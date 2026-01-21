Return-Path: <kvm+bounces-68713-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJkZMB7RcGkOaAAAu9opvQ
	(envelope-from <kvm+bounces-68713-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 14:14:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5667E57659
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 14:14:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EF6336032EE
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 13:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 852C148122F;
	Wed, 21 Jan 2026 12:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ea+Q3WRy"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F1F3ED13B;
	Wed, 21 Jan 2026 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769000373; cv=none; b=lV0wPn5EJC+ujqSG4paPuZvY11805r/sY12nA5wj9ipma3GmBR9LnWP38H44gstBh9FYOa9+H6BxYKtPRCS/DvOTHvdm1CvcEfAq0L1ti5J0U88/ftTriieSrd/oyC+Qzky2BAlOpIxUZ93TAMxUiLLC3slmsfGbi2YyEpOCucs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769000373; c=relaxed/simple;
	bh=W2rPiTt7POS+Rymv7il/JSlLvJ76kJZLP7yqkB/gfmg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iS8lUvrSg3QnviAf8nlSbTmpJ+rlj/nIfEtgo+a2zEPDX1QPAfVpO4oZ9AfzsMskggwb+dZiMzkA9cioIGvwkB+MQlEDgL9iHqZYPD8033drQh4XPE+lzZPO/Zrs6vIAx7HmAhrbkryXZRwdGdarPNYukkQ9YHSd0RZF9Ns4eow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ea+Q3WRy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D538C116D0;
	Wed, 21 Jan 2026 12:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769000371;
	bh=W2rPiTt7POS+Rymv7il/JSlLvJ76kJZLP7yqkB/gfmg=;
	h=From:To:Cc:Subject:Date:From;
	b=ea+Q3WRy2FiSABNW/9niK0WvNzge7rD9suFwk6d+tPTgwv1TkWt7BR+E2wfmOMHf2
	 ONEsHZtzbyMk1AKsw72wPiI7hPZhQxXp5six5NvXYka1th0ZVIwrnAdzPAW2twSds8
	 QpxPuHqYtogOogTCKwpgZSLmPCaaqqWRWeMwVcwVjqnAvrzJjg9SC3URCKimztvVhF
	 uPOUaJ4u9gE7n8uZscmt/pBR+v/5Q/NfqWYwhX2P58PXSDXOM8lgDZFVkaZ8Nk+qvC
	 0hUbFns2SLdm1dXiEzn/ldfyOZFRdxS4+KEVqwLK/2qDt7X8TYnDDxTQZHn6gzpcxB
	 WRF/6hUo4kf2Q==
From: Leon Romanovsky <leon@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	virtualization@lists.linux.dev,
	intel-xe@lists.freedesktop.org,
	linux-rdma@vger.kernel.org,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v4 0/8] dma-buf: Use revoke mechanism to invalidate shared buffers
Date: Wed, 21 Jan 2026 14:59:08 +0200
Message-ID: <20260121-dmabuf-revoke-v4-0-d311cbc8633d@nvidia.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20251221-dmabuf-revoke-b90ef16e4236
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68713-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,msgid.link:url,nvidia.com:email,nvidia.com:mid]
X-Rspamd-Queue-Id: 5667E57659
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Changelog:
v4:
 * Changed DMA_RESV_USAGE_KERNEL to DMA_RESV_USAGE_BOOKKEEP.
 * Made .invalidate_mapping() truly optional.
 * Added patch which renames dma_buf_move_notify() to be
   dma_buf_invalidate_mappings().
 * Restored dma_buf_attachment_is_dynamic() function.
v3: https://lore.kernel.org/all/20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com/
 * Used Jason's wordings for commits and cover letter.
 * Removed IOMMUFD patch.
 * Renamed dma_buf_attachment_is_revoke() to be dma_buf_attach_revocable().
 * Added patch to remove CONFIG_DMABUF_MOVE_NOTIFY.
 * Added Reviewed-by tags.
 * Called to dma_resv_wait_timeout() after dma_buf_move_notify() in VFIO.
 * Added dma_buf_attach_revocable() check to VFIO DMABUF attach function.
 * Slightly changed commit messages.
v2: https://patch.msgid.link/20260118-dmabuf-revoke-v2-0-a03bb27c0875@nvidia.com
 * Changed series to document the revoke semantics instead of
   implementing it.
v1: https://patch.msgid.link/20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com

-------------------------------------------------------------------------
This series documents a dma-buf “revoke” mechanism: to allow a dma-buf
exporter to explicitly invalidate (“kill”) a shared buffer after it has
been distributed to importers, so that further CPU and device access is
prevented and importers reliably observe failure.

The change in this series is to properly document and use existing core
“revoked” state on the dma-buf object and a corresponding exporter-triggered
revoke operation.

dma-buf has quietly allowed calling move_notify on pinned dma-bufs, even
though legacy importers using dma_buf_attach() would simply ignore
these calls.

RDMA saw this and needed to use allow_peer2peer=true, so implemented a
new-style pinned importer with an explicitly non-working move_notify()
callback.

This has been tolerable because the existing exporters are thought to
only call move_notify() on a pinned DMABUF under RAS events and we
have been willing to tolerate the UAF that results by allowing the
importer to continue to use the mapping in this rare case.

VFIO wants to implement a pin supporting exporter that will issue a
revoking move_notify() around FLRs and a few other user triggerable
operations. Since this is much more common we are not willing to
tolerate the security UAF caused by interworking with non-move_notify()
supporting drivers. Thus till now VFIO has required dynamic importers,
even though it never actually moves the buffer location.

To allow VFIO to work with pinned importers, according to how dma-buf
was intended, we need to allow VFIO to detect if an importer is legacy
or RDMA and does not actually implement move_notify().

In theory all exporters that call move_notify() on pinned dma-buf's
should call this function, however that would break a number of widely
used NIC/GPU flows. Thus for now do not spread this further than VFIO
until we can understand how much of RDMA can implement the full
semantic.

In the process clarify how move_notify is intended to be used with
pinned dma-bufs.

Thanks

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Leon Romanovsky (8):
      dma-buf: Rename .move_notify() callback to a clearer identifier
      dma-buf: Rename dma_buf_move_notify() to dma_buf_invalidate_mappings()
      dma-buf: Always build with DMABUF_MOVE_NOTIFY
      dma-buf: Make .invalidate_mapping() truly optional
      dma-buf: Add check function for revoke semantics
      iommufd: Pin dma-buf importer for revoke semantics
      vfio: Wait for dma-buf invalidation to complete
      vfio: Validate dma-buf revocation semantics

 drivers/dma-buf/Kconfig                     | 12 -------
 drivers/dma-buf/dma-buf.c                   | 53 ++++++++++++++++++++++-------
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 14 +++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_object.c  |  2 +-
 drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
 drivers/gpu/drm/virtio/virtgpu_prime.c      |  2 +-
 drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  7 ++--
 drivers/gpu/drm/xe/xe_bo.c                  |  2 +-
 drivers/gpu/drm/xe/xe_dma_buf.c             | 14 +++-----
 drivers/infiniband/core/umem_dmabuf.c       | 13 -------
 drivers/infiniband/hw/mlx5/mr.c             |  2 +-
 drivers/iommu/iommufd/pages.c               | 11 ++++--
 drivers/iommu/iommufd/selftest.c            |  2 +-
 drivers/vfio/pci/vfio_pci_dmabuf.c          | 13 +++++--
 include/linux/dma-buf.h                     |  9 ++---
 15 files changed, 84 insertions(+), 74 deletions(-)
---
base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
change-id: 20251221-dmabuf-revoke-b90ef16e4236

Best regards,
--  
Leon Romanovsky <leonro@nvidia.com>


