Return-Path: <kvm+bounces-69717-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oLOdBJm0fGm7OQIAu9opvQ
	(envelope-from <kvm+bounces-69717-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:39:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A55F5BB36A
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 14:39:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6D9E13016341
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 13:39:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C69D34DCD2;
	Fri, 30 Jan 2026 13:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0ogsA2n"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E94E2EFD91;
	Fri, 30 Jan 2026 13:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769780280; cv=none; b=GnKsQIL1RqC68X/kMxWni90DMsM0gQxppEsGniTlaUIlrzYAI0VW2ujm92tVXIl+UBbiIfuH93DdHS8qus/Tj2nz44CKHtRmp586VGPWnjMDtUM+Lyy1YoUQ+/R0cIbgPgI56bQ4V1LT2zhLiuHSaELzQcF/T9iOBMJyL1dyYyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769780280; c=relaxed/simple;
	bh=xc+xbxZ3oNBD2JuFMoUcoiVyL/l5Ver5G6iPoq8UFrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ERGFrMcVpsATYICOWD7ZKOVHwc7j13VnfSbD0e+0gd15XH6bsCZPl5EZJ2YLl8w1hIJOixO/92PTgX1IAeylPop06e78qRaG/xprruJAlJiDJWn6jx2DF+5a+6JAjf0sZ5MsjsncGEq3xABaEIf6ZIKH505S0O2IBOPv/Q35ArM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0ogsA2n; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775F2C16AAE;
	Fri, 30 Jan 2026 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769780280;
	bh=xc+xbxZ3oNBD2JuFMoUcoiVyL/l5Ver5G6iPoq8UFrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q0ogsA2nGpR8nklaG4pEkRkeI6hb46F+eL/oUPNazRxlwqrUfQORu5NNxJpb6qXeT
	 QlBTP87FQkuQ2AZZvBVJW/eRMaOa4JnMSrMCYPek+tU36FLeT0W+7vWjFjxzuGyupi
	 PZWpL4RGCLcgJcjn9u+0R2hXCx19b5DYP5nTC/arAD7qYxvIR6M/sojIbVmuzmyDhS
	 Scf29wyOvPNUh8uqGVfv9qk0qu182PCsE19BpnhH+flk2j7RfBUNEeB2HWJB6ApKR1
	 /5wguQpJlppcGNx0IjsanCiyy8O3ztNnj5T53ThxeOMye5EwtgnefDKguy20AZAbYM
	 jNlmzujQtm4Rg==
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
	kvm@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v6 8/8] iommufd: Add dma_buf_pin()
Date: Fri, 30 Jan 2026 15:37:24 +0200
Message-ID: <20260130-dmabuf-revoke-v6-8-06278f9b7bf0@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260130-dmabuf-revoke-v6-0-06278f9b7bf0@nvidia.com>
References: <20260130-dmabuf-revoke-v6-0-06278f9b7bf0@nvidia.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,kernel.org,suse.de,intel.com,ziepe.ca,8bytes.org,arm.com,shazbot.org,nvidia.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69717-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[36];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:mid,nvidia.com:email,intel.com:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,amd.com:email]
X-Rspamd-Queue-Id: A55F5BB36A
X-Rspamd-Action: no action

From: Leon Romanovsky <leonro@nvidia.com>

IOMMUFD relies on a private protocol with VFIO, and this always operated
in pinned mode.

Now that VFIO can support pinned importers update IOMMUFD to invoke the
normal dma-buf flow to request pin.

This isn't enough to allow IOMMUFD to work with other exporters, it still
needs a way to get the physical address list which is another series.

IOMMUFD supports the defined revoke semantics. It immediately stops and
fences access to the memory inside it's invalidate_mappings() callback,
and it currently doesn't use scatterlists so doesn't call map/unmap at
all.

It is expected that a future revision can synchronously call unmap from
the move_notify callback as well.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/iommufd/pages.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index 76f900fa1687..a5eb2bc4ef48 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1501,16 +1501,22 @@ static int iopt_map_dmabuf(struct iommufd_ctx *ictx, struct iopt_pages *pages,
 		mutex_unlock(&pages->mutex);
 	}
 
-	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
+	rc = dma_buf_pin(attach);
 	if (rc)
 		goto err_detach;
 
+	rc = sym_vfio_pci_dma_buf_iommufd_map(attach, &pages->dmabuf.phys);
+	if (rc)
+		goto err_unpin;
+
 	dma_resv_unlock(dmabuf->resv);
 
 	/* On success iopt_release_pages() will detach and put the dmabuf. */
 	pages->dmabuf.attach = attach;
 	return 0;
 
+err_unpin:
+	dma_buf_unpin(attach);
 err_detach:
 	dma_resv_unlock(dmabuf->resv);
 	dma_buf_detach(dmabuf, attach);
@@ -1656,6 +1662,7 @@ void iopt_release_pages(struct kref *kref)
 	if (iopt_is_dmabuf(pages) && pages->dmabuf.attach) {
 		struct dma_buf *dmabuf = pages->dmabuf.attach->dmabuf;
 
+		dma_buf_unpin(pages->dmabuf.attach);
 		dma_buf_detach(dmabuf, pages->dmabuf.attach);
 		dma_buf_put(dmabuf);
 		WARN_ON(!list_empty(&pages->dmabuf.tracker));

-- 
2.52.0


