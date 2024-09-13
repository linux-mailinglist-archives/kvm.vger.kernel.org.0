Return-Path: <kvm+bounces-26793-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 34F31977CCD
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 12:02:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEF0C1F284F5
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 10:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9976B1D88A4;
	Fri, 13 Sep 2024 10:01:42 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048E41D86F1;
	Fri, 13 Sep 2024 10:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726221702; cv=none; b=aHu32qF4Fv+OflpnBrGuZ5n0unfjALyU1kNTcbRAMCvnjeUtTOspH56awWIac7NYIbmYhWvzT5zRq7bKAl5c8El3DKK7/G3UZu1W/7YZoK3xquHLevXlEx1NjrI8lOFG3PF1QIofwy9z+CXhpJNLvG+zwGEHyzSU91hQFg5w+MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726221702; c=relaxed/simple;
	bh=YYvpzTPY2m18FxCbhJH/7tdTgRuRWqPZn75ucKrhD/E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=cvIEbzytYskA7bpOUNPB3pGqkDV7M6KpSdiDvUQe/ANQbQb2QUCBqKGmxeqjMByq1+8F/Qol14e+PaWDMPBeMh1KsUzRZtPjq9926PHvpK95wUHkTfeRMasg8oTEDt2BjbdGA+/+O7tsC6L1JCNp+jt0IkKNocIbJrzSvhZohKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4X4qZT4Hmzz2CpWB;
	Fri, 13 Sep 2024 18:01:05 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 766951A016C;
	Fri, 13 Sep 2024 18:01:37 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 13 Sep
 2024 18:01:36 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v9 0/4] debugfs to hisilicon migration driver
Date: Fri, 13 Sep 2024 17:54:58 +0800
Message-ID: <20240913095502.22940-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600005.china.huawei.com (7.193.23.191)

Add a debugfs function to the hisilicon migration driver in VFIO to
provide intermediate state values and data during device migration.

When the execution of live migration fails, the user can view the
status and data during the migration process separately from the
source and the destination, which is convenient for users to analyze
and locate problems.

Changes v8 -> v9
	Added device enable mutex

Changes v7 -> v8
	Delete unnecessary information

Changes v6 -> v7
	Remove redundant kernel error log printing and
	remove unrelated bugfix code

Changes v5 -> v6
	Modify log output calling error

Changes v4 -> v5
	Adjust the descriptioniptionbugfs file directory

Changes v3 -> v4
	Rebased on kernel6.9

Changes 2 -> v3
	Solve debugfs serialization problem.

Changes v1 -> v2
	Solve the racy problem of io_base.

Longfang Liu (4):
  hisi_acc_vfio_pci: extract public functions for container_of
  hisi_acc_vfio_pci: create subfunction for data reading
  hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
  Documentation: add debugfs description for hisi migration

 .../ABI/testing/debugfs-hisi-migration        |  25 ++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 279 ++++++++++++++++--
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
 3 files changed, 280 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration

-- 
2.24.0


