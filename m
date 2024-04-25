Return-Path: <kvm+bounces-15917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C1C28B22A4
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 15:28:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F00C01F21423
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 13:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C428F149C6E;
	Thu, 25 Apr 2024 13:28:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537E4149C43;
	Thu, 25 Apr 2024 13:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051709; cv=none; b=UarMABZ3hLPGoqQF/41BkbCszzWFQJT8RVLU7rXVOg6Ln6yZVBryZDUya+ePRFj5w+ehAzduZKZNJRIT2QGe2ZRpkyzt7lZX7HUuZOg/i04jcuRamaChV7wR5wGTPRznE9t6A/rBOtWMvtMQzJe56fv9UqxteCj6cYiRYcVpwPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051709; c=relaxed/simple;
	bh=s+L/XVUsPhCxc0N5WzQwY2ZxETHyP0BRBjKEYzxXuqo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rEoAYfdLVZ7aYEQdvIeYSPxvflDF6keeS/keMXncpHaNagbcDQunFiNDhSOxByzGS9iZgZRD2TYeNi+rRvC5zZPDzywepwuyceyKS91IPDT6sADNZHDXqjfOHhFb6UgbOvIZ9/z8m0s3cm2SHytxokZ5qlZzBMche2Sq/O7vLf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4VQGnp4YmGzNtQV;
	Thu, 25 Apr 2024 21:25:50 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id 3F843180073;
	Thu, 25 Apr 2024 21:28:23 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Thu, 25 Apr
 2024 21:28:22 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v6 0/5] add debugfs to hisilicon migration driver
Date: Thu, 25 Apr 2024 21:23:17 +0800
Message-ID: <20240425132322.12041-1-liulongfang@huawei.com>
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

Changes v5 -> v6
	Modify log output calling error

Changes v4 -> v5
	Adjust the debugfs file directory

Changes v3 -> v4
	Rebased on kernel6.9

Changes v2 -> v3
	Solve debugfs serialization problem.

Changes v1 -> v2
	Solve the racy problem of io_base. 

Longfang Liu (5):
  hisi_acc_vfio_pci: extract public functions for container_of
  hisi_acc_vfio_pci: modify the register location of the XQC address
  hisi_acc_vfio_pci: create subfunction for data reading
  hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
  Documentation: add debugfs description for hisi migration

 .../ABI/testing/debugfs-hisi-migration        |  27 ++
 MAINTAINERS                                   |   1 +
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 302 ++++++++++++++++--
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  10 +
 4 files changed, 308 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration

-- 
2.24.0


