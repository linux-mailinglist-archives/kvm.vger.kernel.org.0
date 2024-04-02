Return-Path: <kvm+bounces-13321-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D6D6A8949FB
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 05:29:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7768FB239AB
	for <lists+kvm@lfdr.de>; Tue,  2 Apr 2024 03:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AF18175A1;
	Tue,  2 Apr 2024 03:29:23 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C891759E;
	Tue,  2 Apr 2024 03:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712028563; cv=none; b=mC/IiEQyhggewA79ZtCjHRYjKJcgD7spYjVFH/VlqhSmVZ3JwI/BT0ov6ypQn+xKfhxB6eh9AwpTvpqUOHSrBhYydDJDrjHTdCx7IR0CxxRWFLIKzbUKiJGH9Hdyupk99PYg/9MAkcVNLtqZT6qptLfqR03zfxdEYjTsasizNsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712028563; c=relaxed/simple;
	bh=djyVy8+fPyGzZPzPF4SjSGy7AW26La7QUjqbjM1zzqc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=SrPzxzmayTmzYzXLV1Yvakv/tBUjZS5027rGlayd5o5DFqTCpPh79bqJxqKMzsWn60TQpOxeFvmUfZrdLAFWR7BMsj2GaZwt7NsCERovyVUOx7zlE8r0i/iXKcS3BC7pRMI7zSj5ihfBPWkMyE9ic+q4GfCApjwMca1XR8Gyv2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4V7tbf6bY5zcbDt;
	Tue,  2 Apr 2024 11:27:10 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 05A45140154;
	Tue,  2 Apr 2024 11:29:18 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Tue, 2 Apr
 2024 11:29:17 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v4 0/4] add debugfs to hisilicon migration driver
Date: Tue, 2 Apr 2024 11:24:28 +0800
Message-ID: <20240402032432.41004-1-liulongfang@huawei.com>
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
 kwepemm600005.china.huawei.com (7.193.23.191)

Add a debugfs function to the hisilicon migration driver in VFIO to
provide intermediate state values and data during device migration.

When the execution of live migration fails, the user can view the
status and data during the migration process separately from the
source and the destination, which is convenient for users to analyze
and locate problems.

Changes v3 -> v4
	Rebased on kernel6.9

Changes v2 -> v3
	Solve debugfs serialization problem.

Changes v1 -> v2
	Solve the racy problem of io_base.

Longfang Liu (4):
  hisi_acc_vfio_pci: extract public functions for container_of
  hisi_acc_vfio_pci: Create subfunction for data reading
  hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
  Documentation: add debugfs description for hisi migration

 .../ABI/testing/debugfs-hisi-migration        |  34 +++
 MAINTAINERS                                   |   1 +
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 281 ++++++++++++++++--
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  14 +
 4 files changed, 298 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration

-- 
2.24.0


