Return-Path: <kvm+bounces-60283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C080BE7A8A
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:25:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 856621AA4ED9
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 09:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70EAD32D0D0;
	Fri, 17 Oct 2025 09:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="V+lYhG4y"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FBC32B98A;
	Fri, 17 Oct 2025 09:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760692267; cv=none; b=ZU6kIDN5U+Ye2c8BfF7gFioHwweq5AFfkNRMmtFsJm2pHlMiAZN2CmRwT4DMRCYhIWWpXqF9zjnZse/uWkigTg5FtJp/0p/CQ+d8oDKrn1RBJVGQVbE/AnYdvGe4koBbmsBZcTtRtgDzdQwBiFs/tgC9lfmbPnIBGmyP2J1z9Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760692267; c=relaxed/simple;
	bh=uX+GASuLuXdcy98l9VtSRnkG0T1yGIuezd1cY2p8vJE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Njd2v5kDJGFWejzCTb4nR0PcX6GegCOI9+NZTojN1XOE66ga2/WTMChg2/pYJkrLVxUifs5AVAaaeBQ88nZIuQ98vAh8+XahzpWa7atok9fku51yDapAe1rDjYNExX8KZ3XEUlgeNq46daqOs2PcIFr1nAAX8yNULYNva7GvfIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=V+lYhG4y; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=nwIY8VT5ELVzdpIQ6L+OccZgP3vvhBOaoM9GMr5gkQQ=;
	b=V+lYhG4y8E2DJEj37hNmDHxq+tK2vtSGgCEjOvu15zC2Fnzr+ZdKcTTSQliqFvePXWBGh5Lbm
	+dPPcshUsjioh4SclzmFGMD8rKIaXuvQe88n8nhBblQ/3JTmF5O7xeJfPb6ICDdTxu2hD8XTR/I
	mw9RqlY8jOsqa+D152nbC1o=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cnzYK2f8XzcZxv;
	Fri, 17 Oct 2025 17:09:57 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 5B3C2180B69;
	Fri, 17 Oct 2025 17:10:59 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 17 Oct
 2025 17:10:58 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
	<jonathan.cameron@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
	<liulongfang@huawei.com>
Subject: [PATCH v10 0/2] update live migration configuration region
Date: Fri, 17 Oct 2025 17:10:55 +0800
Message-ID: <20251017091057.3770403-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On the new hardware platform, the configuration register space
of the live migration function is set on the PF, while on the
old platform, this part is placed on the VF.

Change v9 -> v10
	Update the name of the configuration mode

Change v8 -> v9
	Update the version name for driver matching

Change v7 -> v8
	Resolve hardware compatibility issues.

Change v6 -> v7
	Update the comment of the live migration configuration scheme.

Change v5 -> v6
	Update VF device properties

Change v4 -> v5
	Remove BAR length alignment

Change v3 -> v4
	Rebase on kernel 6.15

Change v2 -> v3
	Put the changes of Pre_Copy into another bugfix patchset.

Change v1 -> v2
	Delete the vf_qm_state read operation in Pre_Copy

Longfang Liu (2):
  crypto: hisilicon - qm updates BAR configuration
  hisi_acc_vfio_pci: adapt to new migration configuration

 drivers/crypto/hisilicon/qm.c                 |  27 +++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 205 ++++++++++++------
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  21 ++
 include/linux/hisi_acc_qm.h                   |   3 +
 4 files changed, 195 insertions(+), 61 deletions(-)

-- 
2.33.0


