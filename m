Return-Path: <kvm+bounces-69047-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CKLBKgIbdWl8AwEAu9opvQ
	(envelope-from <kvm+bounces-69047-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 20:18:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CCED7EB38
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 20:18:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id BC22930655CB
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 19:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594C228000F;
	Sat, 24 Jan 2026 19:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p8Yk9jFb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1A229ACC5;
	Sat, 24 Jan 2026 19:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769282095; cv=none; b=nijca4xivLEJDiUHrLwvlaUqcz5erRDzJiDg4JY6AUrb1zjB2srVhGyRmE3T4z1Ou6eHlqha8m99lL6AK6KxsKrpulXUAthe2s6+yRTEL4WFWrRTn92R/gYMEq/GPfpRzYz7YxLq1J5ckVzTh6gsJXnbFzr0q9FNBT/eRi/LIio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769282095; c=relaxed/simple;
	bh=ZAhBWQ9XFr/KbbGQtxFPHe8TZYY61uV781lHGVJNn00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oegCdque01cyosydBhCNCm7fNBsnHHahxLNG2UVI3MIecjbxieJa9vUR6bwSUBCtGB5DXpVl/54jQxlwDfL0fiKIQ1mh9jOjuA1oMKFm0Axa+Ge7mQlegRqOdF8LP3z40b3qkkb7YfdBZpSit2Jxzjzx5FSjR7qw8xHSLr0To8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p8Yk9jFb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B3FC116D0;
	Sat, 24 Jan 2026 19:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769282095;
	bh=ZAhBWQ9XFr/KbbGQtxFPHe8TZYY61uV781lHGVJNn00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8Yk9jFbuPgdBAJdiD2++/6m3pBQNASF4m18EuEQn2ATJXYxQcDbQ6c5K+BYLFaHw
	 5dqBsJtroxkcEPPIGTKMbJ8e3MTW1sWwWcSIhzek65O/bMnwmoLsS53JMuXBf/3Lhd
	 bob3wRYYdLusVLGnYKulU5MzZB0yEE/DukXmA3zJpchXKK+xuoV8flsIT0iC/xYIH7
	 9YUoOYIG865UGTix2RzRokPuu/CCrjCtfJW7HytTT5xuwOh64fYmj0HljAKP30QwCK
	 qes3gQRPBakJps7+4w/rOUSG5hlH+zQg0kyqumfJeCYvg7yiES4PqaAVyAZwDvcMh0
	 Oj4Gp3c5qORlQ==
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
Subject: [PATCH v5 3/8] dma-buf: Always build with DMABUF_MOVE_NOTIFY
Date: Sat, 24 Jan 2026 21:14:15 +0200
Message-ID: <20260124-dmabuf-revoke-v5-3-f98fca917e96@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-47773
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69047-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[35];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,nvidia.com:mid,nvidia.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6CCED7EB38
X-Rspamd-Action: no action

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
 drivers/dma-buf/dma-buf.c                   |  3 +--
 drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c | 10 +++-------
 drivers/gpu/drm/amd/amdkfd/Kconfig          |  2 +-
 drivers/gpu/drm/xe/tests/xe_dma_buf.c       |  3 +--
 drivers/gpu/drm/xe/xe_dma_buf.c             | 12 ++++--------
 6 files changed, 10 insertions(+), 32 deletions(-)

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
index e12db540c413..cd68c1c0bfd7 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -847,8 +847,7 @@ static bool
 dma_buf_pin_on_map(struct dma_buf_attachment *attach)
 {
 	return attach->dmabuf->ops->pin &&
-		(!dma_buf_attachment_is_dynamic(attach) ||
-		 !IS_ENABLED(CONFIG_DMABUF_MOVE_NOTIFY));
+	       !dma_buf_attachment_is_dynamic(attach);
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
index cd4944ceb047..b7f85b8653cf 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_dma_buf.c
@@ -133,13 +133,9 @@ static int amdgpu_dma_buf_pin(struct dma_buf_attachment *attach)
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


