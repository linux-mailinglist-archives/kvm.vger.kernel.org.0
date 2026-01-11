Return-Path: <kvm+bounces-67666-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A787D0E9C0
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 11:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E2CF3303D331
	for <lists+kvm@lfdr.de>; Sun, 11 Jan 2026 10:37:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BCA13375C3;
	Sun, 11 Jan 2026 10:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kBXsSPR0"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E572330B2B;
	Sun, 11 Jan 2026 10:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768127848; cv=none; b=COMw0FTvHBO3NBRPRv8SYnCgPhcyccZEXPfYX3S3TlB1iqyYyP8ZDvooJ2scUFlRdBFCO1++zK4+RpR0GEnXaT92++XBBoctrF6+hDemQMj5ZoUxivfR9lA6itr8aZ1jlopkCQNWuYhTLNvWDSDA+VaCDboqaJfA710T8JevyH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768127848; c=relaxed/simple;
	bh=dePt43SNBgAbHvocqy1bmZTj4P+RAF7SlV/MxoRNsvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OfuLkgJtF3K7KXdVxsicHPwQaUKqa2TUWciSj3+gl0mgDCBuRH+O7VYpQs17cn1INcWnvwQ2dNQcpWREyC4VVLCLykCwLEx/2HiUopP1AuRdZv6M6iMWNSlX5RkSM3A3+USnfygWUGe6W+NvbVH7fEbtmgMXstV5+Jjm3rLcsKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kBXsSPR0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B037C4CEF7;
	Sun, 11 Jan 2026 10:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768127847;
	bh=dePt43SNBgAbHvocqy1bmZTj4P+RAF7SlV/MxoRNsvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kBXsSPR0TxXcGmrSTr1m2AYwDDmE5EHlWBhoS8FOTEyEkDrfKeG1oePyXFIC+Wpll
	 kIOV5FuNrm3n0q14QlyOewKPUeY21W3nCSQ1o157RduoUPTdENc0XMS/pWyHM+FRdf
	 yt9EWt2EAR+WzRQplROgnyjUlBLIy9a6ojxgPnKV0EL1veMqA01ApSxMp0M90xowF6
	 3XRMBeWyJoPps7imeBn1XfEL3Vw+sqqspNynLaalStLo0jpu2VPy1gFxeSN67f/sKn
	 y0Zo4qqUpsUJiRdVJK4mE0nA8G8T0j20PNRE/3bRqIwcNEheuxFj9X49mAlEA2Ous1
	 iZvftUZwfKNCw==
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Williamson <alex@shazbot.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	kvm@vger.kernel.org,
	iommu@lists.linux.dev
Subject: [PATCH 3/4] iommufd: Require DMABUF revoke semantics
Date: Sun, 11 Jan 2026 12:37:10 +0200
Message-ID: <20260111-dmabuf-revoke-v1-3-fb4bcc8c259b@nvidia.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com>
References: <20260111-dmabuf-revoke-v1-0-fb4bcc8c259b@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-a6db3
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

IOMMUFD does not support page fault handling, and after a call to
.move_notify() all mappings become invalid. Ensure that the IOMMUFD
DMABUF importer is bound to a revoke‑aware DMABUF exporter (for example,
VFIO).

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/iommu/iommufd/pages.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index dbe51ecb9a20..a233def71be0 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -1451,7 +1451,7 @@ static void iopt_revoke_notify(struct dma_buf_attachment *attach)
 
 static struct dma_buf_attach_ops iopt_dmabuf_attach_revoke_ops = {
 	.allow_peer2peer = true,
-	.move_notify = iopt_revoke_notify,
+	.revoke_notify = iopt_revoke_notify,
 };
 
 /*

-- 
2.52.0


