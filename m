Return-Path: <kvm+bounces-72081-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +NNLFfasoGlulgQAu9opvQ
	(envelope-from <kvm+bounces-72081-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 21:28:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B3DC61AF1F2
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 21:28:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32237313FE96
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6838146AF30;
	Thu, 26 Feb 2026 20:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="Ro+ZAfv3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534454657F1;
	Thu, 26 Feb 2026 20:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772137380; cv=none; b=dEeJ4NNVRd3pY6A6YOj3YpqBPEBSpBeDNn7DC2Z8O4KHUoxb+91tLlKacrpbq9xHR+TeYkHxCa9qJFPxaJq86PxnZtFKrW4zJbJm80hVYCfhej+/n9mMFdZ7q9vSrQV6hEwu1Llzqe7/8v66koyi4vlZvZeVFLTSLvuA3R5WlqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772137380; c=relaxed/simple;
	bh=MlcS4+vFl+7wEZk4is3XZG96cVNjikLJ4HsQTnQbgFE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pqOYNhwmiKnhz0RekOooNj8bLcX4DfgjhAsgEn6pN/UPYQnQQsw8MNNgP1iwfHTjrgbiOkwz2KRbSYBR6+pkGrxyU7xDNnR7T6WUCvq1JReTpjU3mTtdDwJ8HppFVeyVmJfmYp0t0b5V0q27ZpKnSkBHZKSY0bO0+sXOLkNf/J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=Ro+ZAfv3; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 61QHgUEc1069359;
	Thu, 26 Feb 2026 12:22:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=l6eVE4IIlQ2xaNQUCFG/n3h8OW7Ucx8dDtjDv6E+Jjs=; b=Ro+ZAfv3aURa
	otkB5+Xl4tOzfJLXIrfoK35UVPYme0qKfjHf3pM/tPaVVMBdNKIRJSxCPkfwwfhv
	9jiU+GP4IHqH6uMUPDODFXpmLWSWIyVrZlI69Kl2wohCL+S2QxOIpSXWMzjJ6SGW
	Lvy42qbnemzbo6LHc2amIBfl43NKaj8WLSsyW2Wl+BlpBG7rWHExCv0Pax1KI5nS
	9Q7Ic1N8pLFsmeeGHbTbWR1AnmSUKRrG0bPemC03HAyA8rSlCthUCusNH6SLXAkZ
	fsxfZgBVz8I01VwFbbiNAJtjYo/P8a3uR1cGGHLEYV5zPJkr1tud1HIstc7SyYrx
	5jVt7c2rAg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 4cjnjmd8xh-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Thu, 26 Feb 2026 12:22:45 -0800 (PST)
Received: from localhost (2620:10d:c085:208::7cb7) by mail.thefacebook.com
 (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.35; Thu, 26 Feb
 2026 20:22:43 +0000
From: Matt Evans <mattev@meta.com>
To: Alex Williamson <alex@shazbot.org>, Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
        Mahmoud Adam
	<mngyadam@amazon.de>,
        David Matlack <dmatlack@google.com>
CC: =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Sumit Semwal
	<sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?=
	<christian.koenig@amd.com>,
        Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal
	<ankita@nvidia.com>,
        Pranjal Shrivastava <praan@google.com>,
        Alistair Popple
	<apopple@nvidia.com>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linaro-mm-sig@lists.linaro.org>,
        <kvm@vger.kernel.org>
Subject: [RFC PATCH 1/7] vfio/pci: Ensure VFIO barmap is set up before creating a DMABUF
Date: Thu, 26 Feb 2026 12:21:57 -0800
Message-ID: <20260226202211.929005-2-mattev@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260226202211.929005-1-mattev@meta.com>
References: <20260226202211.929005-1-mattev@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDE4NiBTYWx0ZWRfX05FulneI4bIg
 +7g+ADgjmslrOy3Y6zyvkpP4uLK92e2XPCJoDVOnXju0UdbaphcqJJQmTBr9lgy3LxvR8R3vCqw
 y94aRZUl5oheUkI6Tujr4n0Sd6Tv5R4PjlAYtiKI9nb8GLdMJWSU2++5gwcVWSkskdKafOx4mLC
 8//zuPVN2h2x6GcSViKmNXhWaSM1Fou7juakmnNJad2qMhA2tJRs3zKyvFvC1ZXNEeSiatXpD5F
 WKXD/Wa7Ay8n/tk803hAgxBdDvzcivwbdZiwWFswENNPYe103iklgQbecmTHhEnCRVDIYaC4EII
 wqjP2ei0KRHJefv0+qchDcr0q/CvVivN2NS/l8QEWZgEDyIfhhCN/uDn5uu4I5HqDDlopth5U3I
 7QfqDH1IVxZib83QyQJO+BWPmhVwqoUyq2KvP1Wu9CNpTM2huXCKTXKmBVK3AjNne+N5O2/0saj
 gKHVaysBOdm+c6SOw8A==
X-Proofpoint-ORIG-GUID: AUPBuU8COn3qwoYaqyntQk0wsBNevAIo
X-Authority-Analysis: v=2.4 cv=B/m0EetM c=1 sm=1 tr=0 ts=69a0ab95 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=TqTIxcMBvpabANa2:21 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VabnemYjAAAA:8
 a=2V9JFKNtuBlljh9624AA:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: AUPBuU8COn3qwoYaqyntQk0wsBNevAIo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_02,2026-02-26_01,2025-10-01_01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[meta.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[meta.com:s=s2048-2025-q2];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	TAGGED_FROM(0.00)[bounces-72081-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mattev@meta.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[meta.com:+];
	RCVD_COUNT_FIVE(0.00)[6];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[meta.com:mid,meta.com:dkim,meta.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B3DC61AF1F2
X-Rspamd-Action: no action

A DMABUF exports access to BAR resources which need to be requested
before the DMABUF is handed out.  Usually the resources are requested
when setting up the barmap when the VFIO device fd is mmap()ed, but
there's no guarantee that happens before a DMABUF is created.

Set up the barmap (and so request resources) in the DMABUF-creation
path.

Fixes: 5d74781ebc86c ("vfio/pci: Add dma-buf export support for MMIO regions")
Signed-off-by: Matt Evans <mattev@meta.com>
---
 drivers/vfio/pci/vfio_pci_dmabuf.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_dmabuf.c b/drivers/vfio/pci/vfio_pci_dmabuf.c
index 4be4a85005cb..46ab64fbeb19 100644
--- a/drivers/vfio/pci/vfio_pci_dmabuf.c
+++ b/drivers/vfio/pci/vfio_pci_dmabuf.c
@@ -258,6 +258,17 @@ int vfio_pci_core_feature_dma_buf(struct vfio_pci_core_device *vdev, u32 flags,
 		goto err_free_priv;
 	}
 
+	/*
+	 * Just like the vfio_pci_core_mmap() path, we need to ensure
+	 * PCI regions have been requested before returning DMABUFs
+	 * that reference them.  It's possible to create a DMABUF for
+	 * a BAR without the BAR having already been mmap()ed.  The
+	 * barmap setup requests the regions for us:
+	 */
+	ret = vfio_pci_core_setup_barmap(vdev, get_dma_buf.region_index);
+	if (ret)
+		goto err_free_phys;
+
 	priv->vdev = vdev;
 	priv->nr_ranges = get_dma_buf.nr_ranges;
 	priv->size = length;
-- 
2.47.3


