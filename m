Return-Path: <kvm+bounces-61388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ACA7C1A654
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 13:53:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4CE305628A3
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 12:42:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E7C38559D;
	Wed, 29 Oct 2025 12:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="olTgXqnM"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE905384BB9;
	Wed, 29 Oct 2025 12:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761740695; cv=none; b=ndKCP8fhE0u+NT/Ss2T4TRqyv80zlRvOq7uYVsJl59M3uDvTqw81+TdCN0f4253zfuRpw5y19K4yYohAmsrxLlpOgTWSPw8pvIG59qzAj4kweRvBQi0us9wzDXVZoBSLwDV3hQMkrX3uoCgG95/IixM6gfDAARQ/qJltV8ZU0dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761740695; c=relaxed/simple;
	bh=XXazqw1/B9sLvyDlqZLxT7pqMUGIvix64FSJwWDy7Qw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CTEwHRV4r79siZ6EftTqbrmgfbIKH19JpLgI8fcbnEdXemoF1yipowwWuYo2JGP/+1GKVWUQG13PIproJV4ZE1kxoTNNjBvN7n0csuDYObGO30jmjordQRWvThzCKbdndsRTNuYGd99iNvISo504aWW0hT5niIV6QK3M30nD4XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=olTgXqnM; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1c+cUeWcniI1cM22MDNXVBwhkZbXBiAGip2TJjJCAmk=;
	b=olTgXqnMYdlvWwp63Lse+mUgcXVqrZlsI+8mKFg2Fj40Hk7RCQOsXTFRg3Dba0AU5eo9Trogf
	fTW36GoZqkJGxYsd/6FIsmDmO+CM/bT3h2W4bnhRIaqQnACHtQFZlsg9t1KkoHG/qWIJw+lgkg7
	YEfMX/XHm3mK/9oI+xsOy1I=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cxRHx2szWz1prLt;
	Wed, 29 Oct 2025 20:24:13 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id C1BCA14027A;
	Wed, 29 Oct 2025 20:24:42 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 29 Oct
 2025 20:24:42 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<herbert@gondor.apana.org.au>, <shameerkolothum@gmail.com>,
	<jonathan.cameron@huawei.com>
CC: <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
	<liulongfang@huawei.com>
Subject: [PATCH v11 0/2] update live migration configuration region
Date: Wed, 29 Oct 2025 20:24:39 +0800
Message-ID: <20251029122441.3063127-1-liulongfang@huawei.com>
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


