Return-Path: <kvm+bounces-61451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 14E65C1E122
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 02:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7335D347587
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 01:58:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E690D2E264C;
	Thu, 30 Oct 2025 01:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="a3T3SSZo"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6232DBF69;
	Thu, 30 Oct 2025 01:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761789478; cv=none; b=dC6IxQw4UEgJW2ICbWSomjte99RXs3vH7/baYLyOE/3pyY0/DJInpZlaDwZrTQgTQBO4RcooAzRs7IYV8TBXVG3S+Mc3Bn1kXi8/WKHhADsTgdNnL/AJdRD3pduyS6BmoPDa5OUxm5rf4uWwn1vRF4UPotUDjcx9VDvER4h+P9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761789478; c=relaxed/simple;
	bh=2uOKnW0pKvL26iNvB7GQ4XEPhUn2FEw/gkksgunO5Mg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rVJGVXYou9FyaEnQzj0nSKewgfZTGbO1b98O2eqNzZKFfp6PT3/hQkObFAGrLzWYrwW2iG7/S7QLMRgs4b+gOwBISoASpvSmRxdYdQohAWZMRFl7MAzxbwfVPGWiDDPJifuuCc9eKnvzxYy9XS/tloq9uKKtuxDDlqswGVFMecc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=a3T3SSZo; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zwnuXeBVQqXvOjZRpTPcmO5rmI6DRWb7MeDjk6XU674=;
	b=a3T3SSZoGQtcn7VlXgrjgbMWfl5cPqMnb7IygPHgln+PsbQCt+F1/SPpQg/9q7g/WiNG8rsy4
	XiSfb+rLvA9v5lkzblMPwZVOHoJrYti5lvZ1t2/0co8jTBK9GUmCPh2NaydRazEjOkDNnYr+tp5
	V/WPLb7MR7mtO6GBsxAgR20=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4cxnK03HKnzcb0v;
	Thu, 30 Oct 2025 09:56:20 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 923B9180B62;
	Thu, 30 Oct 2025 09:57:45 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 30 Oct
 2025 09:57:44 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
	<jonathan.cameron@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <liulongfang@huawei.com>
Subject: [PATCH v12 0/2] update live migration configuration region
Date: Thu, 30 Oct 2025 09:57:42 +0800
Message-ID: <20251030015744.131771-1-liulongfang@huawei.com>
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

Change v11 -> v12
	Standardize register BIT operations

Change v10 -> v11
	Remove redundant register read/write helper functions

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

 drivers/crypto/hisilicon/qm.c                 |  27 ++++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 130 +++++++++++++-----
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  23 +++-
 include/linux/hisi_acc_qm.h                   |   3 +
 4 files changed, 144 insertions(+), 39 deletions(-)

-- 
2.33.0


