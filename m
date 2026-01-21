Return-Path: <kvm+bounces-68745-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KNX0A/8LcWmPcQAAu9opvQ
	(envelope-from <kvm+bounces-68745-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 18:25:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D68B5A7BB
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 18:25:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 35325A0C6B9
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 15:51:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C980361654;
	Wed, 21 Jan 2026 15:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="joNgUbiQ"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3B71E22E9;
	Wed, 21 Jan 2026 15:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769010312; cv=none; b=eV1poGmf/ZPCMUSi5USchb9vxZKd4LOx23VeDOfuxezN9y7LhMfKTEqsV7o+lPSvFbSfoIyX/KBLV6WDAyWSXMmcYzrnQTReRESRmWw77+iY7LwRGudFeuFX2vzr4IIqSRoGOkFfD70JbCjvDta5BNns2X8QK2OMX49MBVxzvGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769010312; c=relaxed/simple;
	bh=EeKQ6zSaJnyAFeB3cJ8aa28FFQoX0zryimYfy1amUHs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=UVrLKb1m8hn1Sz1vgMFYny/Xos1gQ78h+nBKc+4kgZqYuAVm6Rt/1lVOyEXYRFPVLwP3+RjtHYxTbiZgPKn7togmcLjidtDvu8shtbgZYDFTrhF+1Qt0FBnqvFtOlLDBFVZq5A/9UTYWd3GKdWgZip3kXgfc1j0QNCCCIrLLubE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=joNgUbiQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BAF9C4CEF1;
	Wed, 21 Jan 2026 15:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769010311;
	bh=EeKQ6zSaJnyAFeB3cJ8aa28FFQoX0zryimYfy1amUHs=;
	h=From:To:Cc:Subject:Date:From;
	b=joNgUbiQAV60eXiV/8c0Y2pPkAjsqXvOFw6DVKQxizK6etRiX/nrCZqNmrHnLmd5I
	 Zdj6wfABA3m5KV7vLkMTTjv12OUkhhxZRUub33/Brz/K8QFlhERqIjKFsRdqSJWdJR
	 10jdm+UkdCJ2q2CCxfVvvuY+YbWOR2VKIPJFgaHD21qzTXGFfbuP6dvNNpzAi0DiW7
	 /lpMmp8pQ3JUoFLdO4dYbXjdyHayar7GnBx9ZbQYJdkhyVByvyecSAVxbacvaZFPyt
	 2TaTzbpAii2JDCqIzPmb+Ybr6UmRn+mTRjRiJyrDoZtloe+nwH8juLAcatyj+gFLyE
	 qnyDVOpuutVIQ==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex@shazbot.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH vfio-rc] vfio: Prevent from pinned DMABUF importers to attach to VFIO DMABUF
Date: Wed, 21 Jan 2026 17:45:02 +0200
Message-ID: <20260121-vfio-add-pin-v1-1-4e04916b17f1@nvidia.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20260121-vfio-add-pin-2229148da56e
X-Mailer: b4 0.15-dev-47773
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-1.96 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	TAGGED_FROM(0.00)[bounces-68745-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leon@kernel.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,nvidia.com:mid,dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 8D68B5A7BB
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Leon Romanovsky <leonro@nvidia.com>=0D
=0D
Some pinned importers, such as non-ODP RDMA ones, cannot invalidate their=0D
mappings and therefore must be prevented from attaching to this exporter.=0D
=0D
Fixes: 5d74781ebc86 ("vfio/pci: Add dma-buf export support for MMIO regions=
")=0D
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>=0D
---=0D
This is an outcome of this discussion about revoke functionality.=0D
https://lore.kernel.org/all/20260121134712.GZ961572@ziepe.ca=0D
=0D
Thanks=0D
---=0D
 drivers/vfio/pci/vfio_pci_dmabuf.c | 12 ++++++++++++=0D
 1 file changed, 12 insertions(+)=0D
=0D
diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci=
_dmabuf.c=0D
index d4d0f7d08c53..4be4a85005cb 100644=0D
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c=0D
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c=0D
@@ -20,6 +20,16 @@ struct vfio_pci_dma_buf {=0D
 	u8 revoked : 1;=0D
 };=0D
 =0D
+static int vfio_pci_dma_buf_pin(struct dma_buf_attachment *attachment)=0D
+{=0D
+	return -EOPNOTSUPP;=0D
+}=0D
+=0D
+static void vfio_pci_dma_buf_unpin(struct dma_buf_attachment *attachment)=
=0D
+{=0D
+	/* Do nothing */=0D
+}=0D
+=0D
 static int vfio_pci_dma_buf_attach(struct dma_buf *dmabuf,=0D
 				   struct dma_buf_attachment *attachment)=0D
 {=0D
@@ -76,6 +86,8 @@ static void vfio_pci_dma_buf_release(struct dma_buf *dmab=
uf)=0D
 }=0D
 =0D
 static const struct dma_buf_ops vfio_pci_dmabuf_ops =3D {=0D
+	.pin =3D vfio_pci_dma_buf_pin,=0D
+	.unpin =3D vfio_pci_dma_buf_unpin,=0D
 	.attach =3D vfio_pci_dma_buf_attach,=0D
 	.map_dma_buf =3D vfio_pci_dma_buf_map,=0D
 	.unmap_dma_buf =3D vfio_pci_dma_buf_unmap,=0D
=0D
---=0D
base-commit: acf44a2361b8d6356b71a970ab016065b5123b0e=0D
change-id: 20260121-vfio-add-pin-2229148da56e=0D
=0D
Best regards,=0D
--  =0D
Leon Romanovsky <leonro@nvidia.com>=0D
=0D

