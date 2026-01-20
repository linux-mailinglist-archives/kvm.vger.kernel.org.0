Return-Path: <kvm+bounces-68623-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mKa+B+9AcGnXXAAAu9opvQ
	(envelope-from <kvm+bounces-68623-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 03:58:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD0250217
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 03:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 669C28CDF05
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 14:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7E7244BCB8;
	Tue, 20 Jan 2026 14:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ijj/wO77"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B106344BC8F;
	Tue, 20 Jan 2026 14:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768918064; cv=none; b=Gv5P1wgIT73jG2ny/lW5O+4cuGnZVmejezEYP/ph9oQbG4eV4Pbs21ULU4t1zNSwccQhuaAGX2IwRA+fNq8oBYJTySY85mV46hPLLtJAW8j7yYDbGpgDTSWApdbM//65rS/nzuJlze1O0sMtMGpNGS5kWCpNMu2PeUqAI6hFhQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768918064; c=relaxed/simple;
	bh=+j0ekknPQd/d3gRAxiqnNNnfw0hqFAwwAjsZYhI192Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n9IuiPqazEo4QYwDyoPvwMdwEs0KDvUm54u6F38pHnZ4aiIO/PU/VvDeM9NzIz3HUDAx4qw+MBWDG+FsYmeP9ryuFH/Uay7Uf3FWD2JTRVX8VdF6IZMRYISxjCnaaxYrXFTZK8++K81//XqUreY/NEplZulDCXdyE80ATrUVsa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ijj/wO77; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92D6C16AAE;
	Tue, 20 Jan 2026 14:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768918064;
	bh=+j0ekknPQd/d3gRAxiqnNNnfw0hqFAwwAjsZYhI192Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijj/wO771lycS6FKxtpygkeK/BYUHKt2nUSEqMQc/fe3SpJqqJcZ/BWCkpIQHgiev
	 S+Mf1rPln8yu+F+l0oxZG17ZYhJVhUmOOaXGRiQiIBKGtLNc0IgMJWG2CRJYDmkieP
	 5a/VPKZauZJfX0w5M94s+0B+uQ1I4TbxB1ftUo/dLav7fV9nfxwwD7OdKnSh9ZF6iI
	 /6dB5AHN3tBpnq0H+i2vDN0zwB0+7FapFUTpuAq/16it37Dv+DIWjBTSnV+vXDMZEJ
	 wa4KiwHpfHeh/NIPj1cnYuRyh73tj+UYbl1afb2guZsXGQRwLqiccEkTVLl9YVBg3w
	 6Da43ktVUa1LQ==
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
Subject: [PATCH v3 7/7] vfio: Validate dma-buf revocation semantics
Date: Tue, 20 Jan 2026 16:07:07 +0200
Message-ID: <20260120-dmabuf-revoke-v3-7-b7e0b07b8214@nvidia.com>
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
	TAGGED_FROM(0.00)[bounces-68623-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,nvidia.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 9AD0250217
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Leon Romanovsky <leonro@nvidia.com>

Use the new dma_buf_attach_revocable() helper to restrict attachments to
importers that support mapping invalidation.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index 33bc6a1909dd..0c7782a51912 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -31,6 +31,9 @@ static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,
 	if (priv->revoked)
 		return -ENODEV;
 
+	if (!dma_buf_attach_revocable(attachment))
+		return -EOPNOTSUPP;
+
 	return 0;
 }
 

-- 
2.52.0


