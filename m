Return-Path: <kvm+bounces-68841-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4HP3CUSGcWk1IAAAu9opvQ
	(envelope-from <kvm+bounces-68841-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 03:07:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0C260B35
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 03:06:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id A02303E0C39
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 02:03:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6263101BD;
	Thu, 22 Jan 2026 02:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="pUPaEj7p"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D57F22A7E4;
	Thu, 22 Jan 2026 02:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769047395; cv=none; b=XBQTe86oRx4XRl0UyGH1ZcCHz3dBBgbd9yII4kaMc8quyqhjUP5FMtFa31+fEzV5d4hETj58VmP0t/eGlzG9hCE5PdOiLQOkHu5Pzuvx1uV/L9oUkk7S5mEY2Q1Xmuzpyw3Goj8gsNFna+Lq/N2AkKUDxhIeapY1HI4M3wxONC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769047395; c=relaxed/simple;
	bh=2xRimkzSn0A7i1JdGJrEEJqEm3LpS9E0IJWQysscSPM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f7moqyxiE9AJ7Trp0cPjikaoPnj2a83SkwUg8cMg9zVgAdZ8lVEphOMnnr2cu5YDCOxAN6dp13o6tHpd1WDrOGklF/5uBrsTQKdDIfWCAE7nVzya1BA85l0ax+CrAaYPPkIvo9qFUOGmJo+fl2Hy6RVStVnyUoNO3ffevS/OWkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=pUPaEj7p; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qC9EldMj8NO7SywXgi+osd3WYvH56InKn4LlSeQwKG0=;
	b=pUPaEj7pCIYHqpvdUyRgPgpo0aA8exoyLd/MRFhFRMxtE7t7NyAVyFWL520bD6msyre5ISgaY
	9D7ChTWsb4mQ9WtFDq+8VE+254gnCqnsNbKmjwX0GyFaIlBhNhhp/nkoVf3BGT65jQqR6RHGT9o
	c7D2R7LkiCQX9g45zBHFRqo=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4dxPQ74GpBz1prKl;
	Thu, 22 Jan 2026 09:59:43 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id B95D240569;
	Thu, 22 Jan 2026 10:03:09 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 Jan
 2026 10:03:09 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH v2 2/4] hisi_acc_vfio_pci: update status after RAS error
Date: Thu, 22 Jan 2026 10:02:03 +0800
Message-ID: <20260122020205.2884497-3-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260122020205.2884497-1-liulongfang@huawei.com>
References: <20260122020205.2884497-1-liulongfang@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500015.china.huawei.com (7.185.36.143)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[huawei.com:+];
	TAGGED_FROM(0.00)[bounces-68841-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[huawei.com,quarantine];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[liulongfang@huawei.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:email,huawei.com:dkim,huawei.com:mid,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: BC0C260B35
X-Rspamd-Action: no action

After a RAS error occurs on the accelerator device, the accelerator
device will be reset. The live migration state will be abnormal
after reset, and the original state needs to be restored during
the reset process.
Therefore, reset processing needs to be performed in a live
migration scenario.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index d1e8053640a9..c69caef2e910 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1215,8 +1215,7 @@ static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 	if (hisi_acc_vdev->set_reset_flag)
 		clear_bit(QM_RESETTING, &qm->misc_ctl);
 
-	if (hisi_acc_vdev->core_device.vdev.migration_flags !=
-				VFIO_MIGRATION_STOP_COPY)
+	if (!hisi_acc_vdev->core_device.vdev.mig_ops)
 		return;
 
 	mutex_lock(&hisi_acc_vdev->state_mutex);
-- 
2.33.0


