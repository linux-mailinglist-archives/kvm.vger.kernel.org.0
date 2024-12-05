Return-Path: <kvm+bounces-33105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20E339E4C95
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 04:17:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D905D28543D
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 03:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A141865E3;
	Thu,  5 Dec 2024 03:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TxZjqz+r"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68C638C
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 03:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733368653; cv=none; b=DtQOcMnhpSbtHEs9WMbbzkA0GdwRWDY6d5o9vF6pOeFB3rMJEJorccKXumK8nDGlG1eS6QLt9DNhuj3vmlDposon8eso6TxeUAT9wM4a2YK64UuVxiKmvpyrJ9bIlPs9wN16m9tdwxAzE8IAvZF+Ik1+zzz/bhZJGp5q2eRPZ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733368653; c=relaxed/simple;
	bh=susYPnH3Yv1/zHab5Iyy1xQYlrshTdf8WI8O2VXq5MY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BRn8G/gII2RjuP1dA8XVEMcJuGkOAHLPh3zbjOc88Ru3/dtq3kPIsWZi7EwprkHUKLCPKZ4ik8M90+hIo7ZCbiT87BP6iAQz4uAA1L+h2HdZgPuqo71ubbAJBdd/7j8IfhcI42Y+6cMVsbJ3H3VVwwHSMoiH0mPr3HIKwTnbTIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TxZjqz+r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733368650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Bhckxccz4GTrLACIbDzMbWTAT6H/lKna2Su/0DPa8Mk=;
	b=TxZjqz+ryXhuYOuCGyHpyWp7dX+UwvTGKOE8uYyIgR8Qj/bjjlDtrHl6GIJWjW6MokWRnq
	EGa1DZTaBJVtFog/KQSD450hjUjAm4UG8eByiJwZdULH2OAV4VdkyTp82/K6v3e8ZL+zI/
	FfVMEz2zfyDKJauD3xdeRBIuyGb46sE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-497-oygiQAZDMjW9Mjwz4k6zWg-1; Wed,
 04 Dec 2024 22:17:27 -0500
X-MC-Unique: oygiQAZDMjW9Mjwz4k6zWg-1
X-Mimecast-MFC-AGG-ID: oygiQAZDMjW9Mjwz4k6zWg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4F791954ADC;
	Thu,  5 Dec 2024 03:17:25 +0000 (UTC)
Received: from yicui-thinkpadt14sgen2i.raycom.csb (unknown [10.66.93.14])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CD31F1956094;
	Thu,  5 Dec 2024 03:17:20 +0000 (UTC)
From: Yingshun Cui <yicui@redhat.com>
To: yishaih@nvidia.com
Cc: kvm@vger.kernel.org,
	kevin.tian@intel.com,
	joao.m.martins@oracle.com,
	maorg@nvidia.com,
	galshalom@nvidia.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	zhenyzha@redhat.com
Subject: Fwd: [PATCH] vfio/mlx5: Align the page tracking max message size with the device capability
Date: Thu,  5 Dec 2024 11:13:15 +0800
Message-ID: <20241125113249.155127-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

[PATCH] vfio/mlx5: Align the page tracking max message size with the device capability

Test on 4k and 64k basic page size aarch64
Migrated VM with mlx5_vfio_pci VF with no errors.
The patch works well on my Grace-hopper host.
The test results are as expected. 

Tested-by: Yingshun Cui <yicui@redhat.com>

On Mon, Nov 25, 2024 at 13:32=E2=80=AFAM Yishai Hadas <yishaih@nvidia.com> wrote=
>
>Align the page tracking maximum message size with the device's
>capability instead of relying on PAGE_SIZE.
>
>This adjustment resolves a mismatch on systems where PAGE_SIZE is 64K,
>but the firmware only supports a maximum message size of 4K.
>
>Now that we rely on the device's capability for max_message_size, we
>must account for potential future increases in its value.
>
>Key considerations include:
>- Supporting message sizes that exceed a single system page (e.g., an 8K
>  message on a 4K system).
>- Ensuring the RQ size is adjusted to accommodate at least 4
>  WQEs/messages, in line with the device specification.
>
>The above has been addressed as part of the patch.
>
>Fixes: 79c3cf279926 ("vfio/mlx5: Init QP based resources for dirty tracking")
>Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>---
> drivers/vfio/pci/mlx5/cmd.c | 47 +++++++++++++++++++++++++++----------
> 1 file changed, 35 insertions(+), 12 deletions(-)
>
>diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
>index 7527e277c898..a61d303d9b6a 100644
>--- a/drivers/vfio/pci/mlx5/cmd.c
>+++ b/drivers/vfio/pci/mlx5/cmd.c
>@@ -1517,7 +1517,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
> 	struct mlx5_vhca_qp *host_qp;
> 	struct mlx5_vhca_qp *fw_qp;
> 	struct mlx5_core_dev *mdev;
>-	u32 max_msg_size = PAGE_SIZE;
>+	u32 log_max_msg_size;
>+	u32 max_msg_size;
> 	u64 rq_size = SZ_2M;
> 	u32 max_recv_wr;
> 	int err;
>@@ -1534,6 +1535,12 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
> 	}
> 
> 	mdev = mvdev->mdev;
>+	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
>+	max_msg_size = (1ULL << log_max_msg_size);
>+	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
>+	if (rq_size < 4 * max_msg_size)
>+		rq_size = 4 * max_msg_size;
>+
> 	memset(tracker, 0, sizeof(*tracker));
> 	tracker->uar = mlx5_get_uars_page(mdev);
> 	if (IS_ERR(tracker->uar)) {
>@@ -1623,25 +1630,41 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
> {
> 	u32 entry_size = MLX5_ST_SZ_BYTES(page_track_report_entry);
> 	u32 nent = size / entry_size;
>+	u32 nent_in_page;
>+	u32 nent_to_set;
> 	struct page *page;
>+	void *page_start;
>+	u32 page_offset;
>+	u32 page_index;
>+	u32 buf_offset;
> 	u64 addr;
> 	u64 *buf;
> 	int i;
> 
>-	if (WARN_ON(index >= qp->recv_buf.npages ||
>+	buf_offset = index * qp->max_msg_size;
>+	if (WARN_ON(buf_offset + size >= qp->recv_buf.npages * PAGE_SIZE ||
> 		    (nent > qp->max_msg_size / entry_size)))
> 		return;
> 
>-	page = qp->recv_buf.page_list[index];
>-	buf = kmap_local_page(page);
>-	for (i = 0; i < nent; i++) {
>-		addr = MLX5_GET(page_track_report_entry, buf + i,
>-				dirty_address_low);
>-		addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
>-				      dirty_address_high) << 32;
>-		iova_bitmap_set(dirty, addr, qp->tracked_page_size);
>-	}
>-	kunmap_local(buf);
>+	do {
>+		page_index = buf_offset / PAGE_SIZE;
>+		page_offset = buf_offset % PAGE_SIZE;
>+		nent_in_page = (PAGE_SIZE - page_offset) / entry_size;
>+		page = qp->recv_buf.page_list[page_index];
>+		page_start = kmap_local_page(page);
>+		buf = page_start + page_offset;
>+		nent_to_set = min(nent, nent_in_page);
>+		for (i = 0; i < nent_to_set; i++) {
>+			addr = MLX5_GET(page_track_report_entry, buf + i,
>+					dirty_address_low);
>+			addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
>+					      dirty_address_high) << 32;
>+			iova_bitmap_set(dirty, addr, qp->tracked_page_size);
>+		}
>+		kunmap_local(page_start);
>+		buf_offset += (nent_to_set * entry_size);
>+		nent -= nent_to_set;
>+	} while (nent);
> }
> 
> static void
>-- 
>2.18.1
>


