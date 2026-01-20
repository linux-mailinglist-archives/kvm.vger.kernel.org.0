Return-Path: <kvm+bounces-68617-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6H5qH2Ckb2n0DgAAu9opvQ
	(envelope-from <kvm+bounces-68617-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 16:50:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4367F46BC3
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 16:50:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B00E060C44B
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 14:12:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 399A6441039;
	Tue, 20 Jan 2026 14:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRlTBMJh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1964A43E9F7;
	Tue, 20 Jan 2026 14:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918042; cv=none; b=BBHqB3fI3D/KiyrGw4IU8zJYELM7IPBcsYCY6AlTmLabXmTaUBC7SW6NQVe4MNKgDhBNYDxqZqBe9CJ6EYrUoDaMbdr8AD+dFRQHH50WlvIfY9cpQF00dJK8EouR6sGnUCrFF5QfbiUHW9sBOm6Q5z85YkqfW2razqcO1vRU4D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918042; c=relaxed/simple;
	bh=1hYHYQMvghzNsWmwvxu8DztgpWMwQVcDwD8L4qNzSFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NSBH4ltsCXKtOlm5JBnIQFqt46NiQpIFrK70Itd0YgKAhXhXhvNC9Ax6VsPtXfTGUjKRfWiK5olV4KEwOaUNX37pn6jevORjIcIQ3z3+FlLyQimif6T3zdjtXkJJ/Q58MM7gc2/vJ3wZutQaByUNrZg8XfOu5ogLW5fwwGNwLIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRlTBMJh; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A9D2C16AAE;
	Tue, 20 Jan 2026 14:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768918041;
	bh=1hYHYQMvghzNsWmwvxu8DztgpWMwQVcDwD8L4qNzSFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRlTBMJhHmgjJfRLZFugcge3ItgdIDWL7IepDxcq9jS7Pmnp9SZe/HWs+cDKDZB+i
	 nUuCzOMeJsQabH0oG1eBHIfmwy8tJG8zd24hjV2hNiliRYS6FxL7SYQPI7x1u1pNr5
	 8b6JRNtS+TuokQxelcA/64PVpwWACS1LR1/bVtpwCRop0qeh1af5mf3HH/L5MrOkuU
	 bFvU+NmThWYFuWapDRNns9vD/Y9C7Je8c45M3BkGXWJDMuFNJOlIIEupIvm2wVMJL9
	 b8KmKjJBBFnQTnREVzTzXg4iSZjjRf/LJq3Mbcvh2ZOG6w0gdKBicov3TKvpb497a+
	 oevri4eLFs6HQ==
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
Subject: [PATCH v3 2/7] dma-buf: Always build with DMABUF_MOVE_NOTIFY
Date: Tue, 20 Jan 2026 16:07:02 +0200
Message-ID: <20260120-dmabuf-revoke-v3-2-b7e0b07b8214@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
References: <20260120-dmabuf-revoke-v3-0-b7e0b07b8214@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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
	TAGGED_FROM(0.00)[bounces-68617-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,nvidia.com:mid,amd.com:email,ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 4367F46BC3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Leon Romanovsky <leonro@nvidia.com>

DMABUF_MOVE_NOTIFY was introduced in 2018 and has been marked as
experimental and disabled by default ever since. Six years later,
all new importers implement this callback.

It is therefore reasonable to drop CONFIG_DMABUF_MOVE_NOTIFY and
always build DMABUF with support for it enabled.

Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/dma-buf/Kconfig                     | 12 ------------
 drivers/dma-buf/dma-buf.c                   | 12 ++----------
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 10 +++-------
 drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
 drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  3 +--
 drivers/gpu/drm/xe/xe_dma_buf.c             | 12 ++++--------
 6 files changed, 11 insertions(+), 40 deletions(-)

diff --git a/drivers/dma-buf/Kconfig b/drivers/dma-buf/Kconfig
index b46eb8a552d7..84d5e9b24e20 100644
--- a/drivers/dma-buf/Kconfig
+++ b/drivers/dma-buf/Kconfig
@@ -40,18 +40,6 @@ config UDMABUF
 	  A driver to let userspace turn memfd regions into dma-bufs.
 	  Qemu can use this to create host dmabufs for guest framebuffers.
 
-config DMABUF_MOVE_NOTIFY
-	bool "Move notify between drivers (EXPERIMENTAL)"
-	default n
-	depends on DMA_SHARED_BUFFER
-	help
-	  Don't pin buffers if the dynamic DMA-buf interface is available on
-	  both the exporter as well as the importer. This fixes a security
-	  problem where userspace is able to pin unrestricted amounts of memory
-	  through DMA-buf.
-	  This is marked experimental because we don't yet have a consistent
-	  execution context and memory management between drivers.
-
 config DMABUF_DEBUG
 	bool "DMA-BUF debug checks"
 	depends on DMA_SHARED_BUFFER
diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 59cc647bf40e..cd3b60ce4863 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -837,18 +837,10 @@ static void mangle_sg_table(struct sg_table *sg_table)
 
 }
 
-static inline bool
-dma_buf_attachment_is_dynamic(struct dma_buf_attachment *attach)
-{
-	return !!attach->importer_ops;
-}
-
 static bool
 dma_buf_pin_on_map(struct dma_buf_attachment *attach)
 {
-	return attach->dmabuf->ops->pin &&
-		(!dma_buf_attachment_is_dynamic(attach) ||
-		 !IS_ENABLED(CONFIG_DMABUF_MOVE_NOTIFY));
+	return attach->dmabuf->ops->pin && !attach->importer_ops;
 }
 
 /**
@@ -1124,7 +1116,7 @@ struct sg_table *dma_buf_map_attachment(struct dma_buf_attachment *attach,
 	/*
 	 * Importers with static attachments don't wait for fences.
 	 */
-	if (!dma_buf_attachment_is_dynamic(attach)) {
+	if (!attach->importer_ops) {
 		ret = dma_resv_wait_timeout(attach->dmabuf->resv,
 					    DMA_RESV_USAGE_KERNEL, true,
 					    MAX_SCHEDULE_TIMEOUT);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index 863454148b28..349215549e8f 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -145,13 +145,9 @@ static int amdgpu_dma_buf_pin(struct dma_buf_attachment *attach)
 	 * notifiers are disabled, only allow pinning in VRAM when move
 	 * notiers are enabled.
 	 */
-	if (!IS_ENABLED(CONFIG_DMABUF_MOVE_NOTIFY)) {
-		domains &= ~AMDGPU_GEM_DOMAIN_VRAM;
-	} else {
-		list_for_each_entry(attach, &dmabuf->attachments, node)
-			if (!attach->peer2peer)
-				domains &= ~AMDGPU_GEM_DOMAIN_VRAM;
-	}
+	list_for_each_entry(attach, &dmabuf->attachments, node)
+		if (!attach->peer2peer)
+			domains &= ~AMDGPU_GEM_DOMAIN_VRAM;
 
 	if (domains & AMDGPU_GEM_DOMAIN_VRAM)
 		bo->flags |= AMDGPU_GEM_CREATE_CPU_ACCESS_REQUIRED;
diff --git a/drivers/gpu/drm/amd/amdkfd/Kconfig b/drivers/gpu/drm/amd/amdkfd/Kconfig
index 16e12c9913f9..a5d7467c2f34 100644
--- a/drivers/gpu/drm/amd/amdkfd/Kconfig
+++ b/drivers/gpu/drm/amd/amdkfd/Kconfig
@@ -27,7 +27,7 @@ config HSA_AMD_SVM
 
 config HSA_AMD_P2P
 	bool "HSA kernel driver support for peer-to-peer for AMD GPU devices"
-	depends on HSA_AMD && PCI_P2PDMA && DMABUF_MOVE_NOTIFY
+	depends on HSA_AMD && PCI_P2PDMA
 	help
 	  Enable peer-to-peer (P2P) communication between AMD GPUs over
 	  the PCIe bus. This can improve performance of multi-GPU compute
diff --git a/drivers/gpu/drm/xe/tests/xe_dma_buf.c b/drivers/gpu/drm/xe/tests/xe_dma_buf.c
index 1f2cca5c2f81..c107687ef3c0 100644
--- a/drivers/gpu/drm/xe/tests/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/tests/xe_dma_buf.c
@@ -22,8 +22,7 @@ static bool p2p_enabled(struct dma_buf_test_params *params)
 
 static bool is_dynamic(struct dma_buf_test_params *params)
 {
-	return IS_ENABLED(CONFIG_DMABUF_MOVE_NOTIFY) && params->attach_ops &&
-		params->attach_ops->invalidate_mappings;
+	return params->attach_ops && params->attach_ops->invalidate_mappings;
 }
 
 static void check_residency(struct kunit *test, struct xe_bo *exported,
diff --git a/drivers/gpu/drm/xe/xe_dma_buf.c b/drivers/gpu/drm/xe/xe_dma_buf.c
index 1b9cd043e517..ea370cd373e9 100644
--- a/drivers/gpu/drm/xe/xe_dma_buf.c
+++ b/drivers/gpu/drm/xe/xe_dma_buf.c
@@ -56,14 +56,10 @@ static int xe_dma_buf_pin(struct dma_buf_attachment *attach)
 	bool allow_vram = true;
 	int ret;
 
-	if (!IS_ENABLED(CONFIG_DMABUF_MOVE_NOTIFY)) {
-		allow_vram = false;
-	} else {
-		list_for_each_entry(attach, &dmabuf->attachments, node) {
-			if (!attach->peer2peer) {
-				allow_vram = false;
-				break;
-			}
+	list_for_each_entry(attach, &dmabuf->attachments, node) {
+		if (!attach->peer2peer) {
+			allow_vram = false;
+			break;
 		}
 	}
 

-- 
2.52.0


