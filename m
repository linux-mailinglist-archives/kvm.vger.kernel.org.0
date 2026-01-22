Return-Path: <kvm+bounces-68843-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YG3KCKKGcWk1IAAAu9opvQ
	(envelope-from <kvm+bounces-68843-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 03:08:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B53F560B77
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 03:08:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7BA7B447442
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 02:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B2B3148DA;
	Thu, 22 Jan 2026 02:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="H5t3NMSy"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A0327E045;
	Thu, 22 Jan 2026 02:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769047461; cv=none; b=bjEacR0JEQ6AyMQPm56h3XCRHKlH1Xgpa4srG4DEH12sFGjOzCUeDWuKpNQus0BfaI8NG8m+phKGojwlECYhq6IO65CSj+YsfvvTg2XJAHkUtrE263ocUlItn5J0xGj+uP/wqhZpCX6LEwubkbBqRQ2rFGMsB/J5GuDIpBehi6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769047461; c=relaxed/simple;
	bh=xqzP7gAB/INyvRS6jUS+n5deBZbgLYREzvQIcAOfv+0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C0dypvVCOaEH68XbOs/wZOSc6QwSDdJGLco0YksHs5oaXxk+N8QKgfthgXbGj+EohQyr5MeA8Q4L8qC3vl/ydJb5P8eD7AuiWhmbtpiu78yy6/fy2/ZC4M0ObNuvV7q1VTDrMGnsyf2wmrSzmGQhAdCtUFy0jxYpI1ESy24BnU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=H5t3NMSy; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=A/y88TE+BcSK9wV70vu1iD14mtgz2MdDmaDBOt2ZnNo=;
	b=H5t3NMSyHkBrBZKjyApUXjpIsORx9qJuJLnBZpthkwH8xzprM+t/ftWyChQAuywh+rGLcbAvH
	e4AGXDmYxO1YTMTfOw/xxVJvc181HfEfD94bOOMf2Gru64yTaGyoq5rIaObtHYHVEQeCTia369/
	gARgBh0Jq04GIWlYHQwMCZc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dxPQc3mhRz1T4hP;
	Thu, 22 Jan 2026 10:00:08 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 3345140569;
	Thu, 22 Jan 2026 10:04:12 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 Jan
 2026 10:04:11 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH v2 4/4] hisi_acc_vfio_pci: fix the queue parameter anomaly issue
Date: Thu, 22 Jan 2026 10:02:05 +0800
Message-ID: <20260122020205.2884497-5-liulongfang@huawei.com>
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
	TAGGED_FROM(0.00)[bounces-68843-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[huawei.com,quarantine];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	TAGGED_RCPT(0.00)[kvm];
	FROM_NEQ_ENVFROM(0.00)[liulongfang@huawei.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TO_DN_NONE(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns,huawei.com:email,huawei.com:dkim,huawei.com:mid]
X-Rspamd-Queue-Id: B53F560B77
X-Rspamd-Action: no action

When the number of QPs initialized by the device, as read via vft, is zero,
it indicates either an abnormal device configuration or an abnormal read
result.
Returning 0 directly in this case would allow the live migration operation
to complete successfully, leading to incorrect parameter configuration after
migration and preventing the service from recovering normal functionality.
Therefore, in such situations, an error should be returned to roll back the
live migration operation.

Signed-off-by: Longfang Liu <liulongfang@huawei.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 483381189579..e61df3fe0db9 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -426,7 +426,7 @@ static int vf_qm_check_match(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	ret = qm_get_vft(vf_qm, &vf_qm->qp_base);
 	if (ret <= 0) {
 		dev_err(dev, "failed to get vft qp nums\n");
-		return ret;
+		return ret < 0 ? ret : -EINVAL;
 	}
 
 	if (ret != vf_data->qp_num) {
-- 
2.33.0


