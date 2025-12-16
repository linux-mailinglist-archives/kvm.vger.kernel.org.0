Return-Path: <kvm+bounces-66085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5907CCC4CA2
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 19:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1B098308F7A4
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 17:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79686324703;
	Tue, 16 Dec 2025 17:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="hdTZSRCq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDC12D5922;
	Tue, 16 Dec 2025 17:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.148.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765907976; cv=none; b=B62l5JB7cUMXkdx1ZGiQwJ7NoxfEy1CXkabLpE+viGcYByqZITpkt6/9zt2YmGCVzzjWyXTqvUPulmabAKVfLoO5+BnOLRi63UPGoQxIMil/9HT96seKw3AoREbzKuNTFpsDms7q+hgp7gI7EN4C4UzJQkJEXOHFIA7net2lUOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765907976; c=relaxed/simple;
	bh=NpX2cYgamudQZSSttYEcw79K6PPsUN0dvIDSwahU1PU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=T5HhIlDI5DxlZ2/Gf8X5yu9fJJhxfv5XBhmw0uQMrlUa5aPUrcsnbGowDAv6pRpKOg/0LKi7+8vHdUSrpW0Wctt+3i2uFmnXaYpx2wgvKH8WceArhfu4Xcs5/BESpod8HG7hTe9ZSO15Lf1QIwioLJENl44jsqwEfT6ewjwT2Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b=hdTZSRCq; arc=none smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BGBNYeu2375057;
	Tue, 16 Dec 2025 09:59:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pfpt0220; bh=uKA8UNZEdRzgO8gcqOTTkDa
	DxtJPZsAsk0uuI7FmGKg=; b=hdTZSRCq0OKxvdt4E8Z7YOLcsNgZA33dX4Joah1
	YdS2kSp/j19VbiXt79rzUl9dgBSwlcIEwxnxfGNtXGFrflTJNTQpbhKZGzIwrrGY
	cfvf/NZQT13OLUn9WG07IaZta+kJHmf7w0JO0hnUUUxnTJkWFo6wce0vLNldIfB5
	yL6X0dZXzslsLdeKG5YeqLoRdUgl0C9I4OHKnEOYWonl3oqlIKjjyeGbX7TC83wb
	sBSrwjLRIgdZA77GXfB09ze7x3ETZ7O6ArwpcjPGZCb7ZR+99gQ9mR70Ttd4SEIH
	mbU6qNZAiqzncWeQkUHRjtxvD5wnLNXYB/gW9p6bqK4KpqA==
Received: from dc6wp-exch02.marvell.com ([4.21.29.225])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 4b36gjruta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Dec 2025 09:59:24 -0800 (PST)
Received: from DC6WP-EXCH02.marvell.com (10.76.176.209) by
 DC6WP-EXCH02.marvell.com (10.76.176.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 16 Dec 2025 09:59:36 -0800
Received: from maili.marvell.com (10.69.176.80) by DC6WP-EXCH02.marvell.com
 (10.76.176.209) with Microsoft SMTP Server id 15.2.1544.25 via Frontend
 Transport; Tue, 16 Dec 2025 09:59:36 -0800
Received: from 5810.marvell.com (unknown [10.29.45.105])
	by maili.marvell.com (Postfix) with ESMTP id 836F55B692E;
	Tue, 16 Dec 2025 09:59:19 -0800 (PST)
From: Kommula Shiva Shankar <kshankar@marvell.com>
To: <netdev@vger.kernel.org>, <mst@redhat.com>, <jasowang@redhat.com>
CC: <virtualization@lists.linux.dev>, <eperezma@redhat.com>,
        <kvm@vger.kernel.org>, <jerinj@marvell.com>, <ndabilpuram@marvell.com>,
        <schalla@marvell.com>
Subject: [PATCH net-next ] vdpa: fix caching attributes of MMIO regions by setting them explicitly
Date: Tue, 16 Dec 2025 23:29:18 +0530
Message-ID: <20251216175918.544641-1-kshankar@marvell.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Authority-Analysis: v=2.4 cv=eckwvrEH c=1 sm=1 tr=0 ts=69419dfc cx=c_pps
 a=gIfcoYsirJbf48DBMSPrZA==:117 a=gIfcoYsirJbf48DBMSPrZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=M5GUcnROAAAA:8
 a=crWdm8P_I_FkJ7v9e20A:9 a=OBjm3rFKGHvpk9ecZwUJ:22
X-Proofpoint-GUID: ko9HbogPsc2fxcEwByVLM5SUTp5F3Y3c
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjE2MDE1NCBTYWx0ZWRfXxmI7g2Jx9lEX
 cvLZWtuvEuIcCw17/TpStlaGwGYxHKXP/yW+LPt4kCO+m7EQL4KfGmleWYs3gCsdY6H7piAJARG
 r795ztlOS9YBs6SRjjKup+lxaEZnfCHYjlRH5pYNNPCXcLzzdaH1dVlZyv4fFx1D1wW6/tG9qzP
 meHoF0T9cEuXYk8f56YVxmAz2wagpw99NaArDAnkjlXy1z5AVP7Sf3p44GXteoXVpu1PiKy3AD2
 IoDfwe5BT3/EnSQHirQa9AwniTs6QgdymcEBA2LIcedw3e5AAOrScg1OKCgmlkI3MbpGuxUHzis
 iE+NWRB6OdhStLKi/2cQBKZtxLr2jzTZvU8SInhHfa3t4OC9T83KnUXnuvGZTLwrwzkeblqsf61
 +IHi9KoY2Zek3K16rMIxUZY1ztnTVg==
X-Proofpoint-ORIG-GUID: ko9HbogPsc2fxcEwByVLM5SUTp5F3Y3c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-16_02,2025-12-16_02,2025-10-01_01

Explicitly set non-cached caching attributes for MMIO regions.
Default write-back mode can cause CPU to cache device memory,
causing invalid reads and unpredictable behavior.

Invalid read and write issues were observed on ARM64 when mapping the
notification area to userspace via mmap.

Signed-off-by: Kommula Shiva Shankar <kshankar@marvell.com>
---
 drivers/vhost/vdpa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 05a481e4c385..b0179e8567ab 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1527,6 +1527,7 @@ static int vhost_vdpa_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_end - vma->vm_start != notify.size)
 		return -ENOTSUPP;
 
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
 	vma->vm_ops = &vhost_vdpa_vm_ops;
 	return 0;
-- 
2.48.1


