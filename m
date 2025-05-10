Return-Path: <kvm+bounces-46107-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA629AB2218
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 10:13:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AABF4A838E
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 08:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CAA41E9B37;
	Sat, 10 May 2025 08:13:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D0F1DFDA1;
	Sat, 10 May 2025 08:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746864803; cv=none; b=KRHh6SvC7qc5pBgpeG7WpjLKVigBRRnbxPxzWH3xhjkVPnVIcMlCDyqmNwvM3ZdP/JI5XjV9jcfPrj6l9PbhDHCKdAFpjq0E4wEsPjrx/yrQYOPu+BvTE7FDgpVjXLMCnrpuNKvMZImXEtfQ7WgSOl4qtWCSmqBhHnTSszQQbQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746864803; c=relaxed/simple;
	bh=S467IL2al7IcCPUj4hfHZzYZN2jJjDv3J69qQJP9vog=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FrAinkZXCjDqc7K02Z8BsRXgz1BLh3xzEy5fZSBD9mXZehcmrsQXQNNMTHTcYKvTikBS8Tehp2S8WrcjefhIX1hPBOAV9unRac7RSiT1sQ/UWyTZqnhJ/tJEqeqRx6LP6ctG2VLd492wgYYlQajSW94EGZvBWmLQuMHjrT7OllY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4ZvdrC2kBFzQwNw;
	Sat, 10 May 2025 16:11:55 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 1E70F180489;
	Sat, 10 May 2025 16:13:13 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 10 May
 2025 16:13:12 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v8 2/6] hisi_acc_vfio_pci: add eq and aeq interruption restore
Date: Sat, 10 May 2025 16:11:51 +0800
Message-ID: <20250510081155.55840-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20250510081155.55840-1-liulongfang@huawei.com>
References: <20250510081155.55840-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemg500006.china.huawei.com (7.202.181.43)

In order to ensure that the task packets of the accelerator
device are not lost during the migration process, it is necessary
to send an EQ and AEQ command to the device after the live migration
is completed and to update the completion position of the task queue.

Let the device recheck the completed tasks data and if there are
uncollected packets, device resend a task completion interrupt
to the software.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 304dbdfa0e95..80217aea5475 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -470,6 +470,19 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	return 0;
 }
 
+static void vf_qm_xeqc_save(struct hisi_qm *qm,
+			    struct hisi_acc_vf_migration_file *migf)
+{
+	struct acc_vf_data *vf_data = &migf->vf_data;
+	u16 eq_head, aeq_head;
+
+	eq_head = vf_data->qm_eqc_dw[0] & 0xFFFF;
+	qm_db(qm, 0, QM_DOORBELL_CMD_EQ, eq_head, 0);
+
+	aeq_head = vf_data->qm_aeqc_dw[0] & 0xFFFF;
+	qm_db(qm, 0, QM_DOORBELL_CMD_AEQ, aeq_head, 0);
+}
+
 static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 			   struct hisi_acc_vf_migration_file *migf)
 {
@@ -578,6 +591,9 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 		return -EINVAL;
 
 	migf->total_length = sizeof(struct acc_vf_data);
+	/* Save eqc and aeqc interrupt information */
+	vf_qm_xeqc_save(vf_qm, migf);
+
 	return 0;
 }
 
-- 
2.24.0


