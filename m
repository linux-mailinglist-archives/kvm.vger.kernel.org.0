Return-Path: <kvm+bounces-68839-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OAbDEsaFcWk1IAAAu9opvQ
	(envelope-from <kvm+bounces-68839-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 03:04:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id DDBC260AE8
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 03:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 49BBA407778
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 02:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122A434F256;
	Thu, 22 Jan 2026 02:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="5uf9HgLM"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DF5834E745;
	Thu, 22 Jan 2026 02:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769047336; cv=none; b=JqvxvYtwmkT2mq+mbm32PzvUHGX9XK+0XsfdZrR1SW2jwwpsxjiXkIw9YA/up8IxQ5Rd2UwKlOoY5j3ClCaLtA+2Ln0yDK9aq+UpyfVtfEwLEJedPELY/ppZ0i+LaR1wBACVrW4zIv6WntlPaWxZXAgirqUs8/adQoj1eHhs2r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769047336; c=relaxed/simple;
	bh=dqEmjOPqtK0HIEGgbO0kJ0yiytcq7HuGU+1SDEMRV+k=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=oEGyat/1HbqZjiasksUZnOtDHvpMd9pZnKfXmwrBDrn9dSxMRSfJKRYHE7OfH13HIEpEOMOmCC5POSRwf+JmiJ81o5Yc36pD2BND/tHn+i079mJM4/Zbb9Qceg8P53Rn0TtU5eixMq2JUsxrUV2fI+b7hmZqllWbkK0x2mYNQhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=5uf9HgLM; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CbBNSqJ4VLdw1njxQI2qSZxuAhZjUSY73maoaQJgznY=;
	b=5uf9HgLMXkeGz+kmuSXrWL93P20pun9q6Zifw9gTEY2cwz6LwuiUiG/EeuRyuJ2QcZApc4Y+S
	1IrAV4XQ2JC6EpxHCRMNDeQa6MvvQ/CPn62fk+5M+heeIOkKNNB1hz+W+y2IsF0RdVv9JeHVHV7
	u1ctspmJFf8b3AOLGcriVpY=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dxPNJ5pcTzcZxy;
	Thu, 22 Jan 2026 09:58:08 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 4DE2040539;
	Thu, 22 Jan 2026 10:02:07 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 22 Jan
 2026 10:02:06 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulongfang@huawei.com>
Subject: [PATCH v2 0/4] bugfix some issues under abnormal scenarios. 
Date: Thu, 22 Jan 2026 10:02:01 +0800
Message-ID: <20260122020205.2884497-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
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
X-Spamd-Result: default: False [0.04 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	SUBJECT_ENDS_SPACES(0.50)[];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68839-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[huawei.com,quarantine];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[huawei.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[liulongfang@huawei.com,kvm@vger.kernel.org];
	PRECEDENCE_BULK(0.00)[];
	TO_DN_NONE(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[huawei.com:mid,huawei.com:dkim,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: DDBC260AE8
X-Rspamd-Action: no action

In certain reset scenarios, repeated migration scenarios, and error injection
scenarios, it is essential to ensure that the device driver functions properly.
Issues arising in these scenarios need to be addressed and fixed

Change v1 -> v2
	Fix the reset state handling issue

Longfang Liu (3):
  hisi_acc_vfio_pci: update status after RAS error
  hisi_acc_vfio_pci: resolve duplicate migration states
  hisi_acc_vfio_pci: fix the queue parameter anomaly issue

Weili Qian (1):
  hisi_acc_vfio_pci: fix VF reset timeout issue

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 30 +++++++++++++++++--
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  2 ++
 2 files changed, 29 insertions(+), 3 deletions(-)

-- 
2.33.0


