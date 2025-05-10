Return-Path: <kvm+bounces-46105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28367AB2214
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 10:12:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 665871897413
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 08:12:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31D221E9B30;
	Sat, 10 May 2025 08:12:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D251DB366;
	Sat, 10 May 2025 08:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746864744; cv=none; b=So/0WtRHp+Fk0haeJN26AeY7PYaySij1846LT/pMvVVRjJpnXMaB9ZEsE5d/IPJUF4ABY9N7LmzPqhxQF65hLZNYW2Jh/tGtEfRcVlNTedFQFjiM3cWbWPsHowSbAg515q06ycX54XLcm+IVTEWbEsV0gZ2ub9E8apwbYaqMuCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746864744; c=relaxed/simple;
	bh=7a5jAE9L1qPHQVDgU2/H/eM7Q2jBIpnueXnjzuUFcAs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cxwVhj6L+ujmk+8JdNBiVJ84xnJYS4eu7ZxWX3i8g3Y3k2R8oJWIe5pN0QvU5HqWYF80bvkGHsAEOBMU+OkuMPEJADJFzqTbgILrz3Yfa2/XVnRTh3PeHQ9fJAOQ0WLxCtZ4bqtRZ3VmCdvXyhKqPJVW5jNa46S8IOMMeN2ahJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Zvdpy11Pxz13KxG;
	Sat, 10 May 2025 16:10:50 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 148EB180489;
	Sat, 10 May 2025 16:12:11 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Sat, 10 May
 2025 16:12:10 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v8 0/6] bugfix some driver issues
Date: Sat, 10 May 2025 16:11:49 +0800
Message-ID: <20250510081155.55840-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemg500006.china.huawei.com (7.202.181.43)

As the test scenarios for the live migration function become
more and more extensive. Some previously undiscovered driver
issues were found.
Update and fix through this patchset.

Change v7 -> v8
	Handle the return value of sub-functions.

Change v6 -> v7
	Update function return values.

Change v5 -> v6
	Remove redundant vf_qm_state status checks.

Change v4 -> v5
	Update version matching strategy

Change v3 -> v4
	Modify version matching scheme

Change v2 -> v3
	Modify the magic digital field segment

Change v1 -> v2
	Add fixes line for patch comment

Longfang Liu (6):
  hisi_acc_vfio_pci: fix XQE dma address error
  hisi_acc_vfio_pci: add eq and aeq interruption restore
  hisi_acc_vfio_pci: bugfix cache write-back issue
  hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
  hisi_acc_vfio_pci: bugfix live migration function without VF device
    driver
  hisi_acc_vfio_pci: update function return values.

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 121 +++++++++++++-----
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  14 +-
 2 files changed, 101 insertions(+), 34 deletions(-)

-- 
2.24.0


