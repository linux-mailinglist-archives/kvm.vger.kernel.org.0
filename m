Return-Path: <kvm+bounces-55097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 455F2B2D4C9
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 09:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 505DF721F95
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 07:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 091D32D47FD;
	Wed, 20 Aug 2025 07:24:44 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012EDEAD7;
	Wed, 20 Aug 2025 07:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755674683; cv=none; b=T3Kyspd+C9VGZvuLONWv9jsOuZcWS6jK4nJ8bAp0ibNSPg1LWLG9uIcblBne2u5OqFg9iAWXbpE0FIHUSr6wp/GPIFRivqfxo2Umi5TrNcinPoSZlqp1AM7MjWLPFrbUwSRnJMMrRBVSKK8xjNKA1gWTpmn90VdNuqbpOYcD/Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755674683; c=relaxed/simple;
	bh=NJLvfWJIhK5n3OEmDVKLqMMudAo1Ym/HIep8M8aRWsA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=o0KpFxT3CLW/f/Nz64BROcuBxvjlrSNGUcQCdcmnUzlsd4pTa2z/ZXVhkMeaBd6yc68gKqmpJYDlEp0nmVSZD39YLEOy491TSHSlxWOV5BdfuuJtI+ANqeyhw9NN5XNXHzYshFOxUuB6WrdsO6uTXqMnRQZsqlTcw6GWNr4BcJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c6HsV1PWqz2CgGr;
	Wed, 20 Aug 2025 15:20:14 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id E4D2C140279;
	Wed, 20 Aug 2025 15:24:36 +0800 (CST)
Received: from huawei.com (10.90.31.46) by dggpemf500015.china.huawei.com
 (7.185.36.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 15:24:36 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerkolothum@gmail.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v8 0/3] update live migration configuration region
Date: Wed, 20 Aug 2025 15:24:32 +0800
Message-ID: <20250820072435.2854502-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.33.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On the new hardware platform, the configuration register space
of the live migration function is set on the PF, while on the
old platform, this part is placed on the VF.

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

Longfang Liu (3):
  hisi_acc_vfio_pci: update BAR space size
  crypto: hisilicon - qm updates BAR configuration
  hisi_acc_vfio_pci: adapt to new migration configuration

 drivers/crypto/hisilicon/qm.c                 |  27 +++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 205 ++++++++++++------
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  13 ++
 include/linux/hisi_acc_qm.h                   |   3 +
 4 files changed, 187 insertions(+), 61 deletions(-)

-- 
2.33.0


