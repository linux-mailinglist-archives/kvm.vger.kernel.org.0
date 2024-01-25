Return-Path: <kvm+bounces-6977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BD4583BB1E
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 09:00:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A0E65B21F4E
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 07:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C36171A2;
	Thu, 25 Jan 2024 07:59:48 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A2B13AC4;
	Thu, 25 Jan 2024 07:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706169588; cv=none; b=AAQTba262fiqRPavrCLkf4eRCcqszSqnjCJn85CmtAEEtqTnXi5rQ2ioXJ3jDH10HjsrN3tIF5xlRU/6QYpeBUgysZrObMQ1qlhCCc5tGHOpqLERiBzOhrLH5avJBH8ijWteHwb6Hd+DpvXw0dcWhwFyVw2EWXX4bNaNhD/NzI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706169588; c=relaxed/simple;
	bh=eVkxV/i3yWPBEbBpzYDTdGKfRQo1+og3/EJd45UlmLs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=O0lstjrwK0RDpkrhJ6k4pXZvQWLQCf4uQ6Nm4I9AflhuEs/sKbHq+UsrDaV+sV60uqoXeGI7Xo1vzcKQnTJwPBwFeby3He7T6FcQAFWMlKXo+6qQc47ok6sm0oh4ZoTR0DhSjmZVthU43Y0xFsXD/C5s7e6ZqWLC/mA7ervhHOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4TLCqS2H2Cz1Q8Cn;
	Thu, 25 Jan 2024 15:57:56 +0800 (CST)
Received: from kwepemm600005.china.huawei.com (unknown [7.193.23.191])
	by mail.maildlp.com (Postfix) with ESMTPS id AEF081A016F;
	Thu, 25 Jan 2024 15:59:26 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemm600005.china.huawei.com
 (7.193.23.191) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 25 Jan
 2024 15:59:26 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH 0/3] add debugfs to hisilicon migration driver
Date: Thu, 25 Jan 2024 15:55:22 +0800
Message-ID: <20240125075525.42168-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600005.china.huawei.com (7.193.23.191)

Add a debugfs function to the hisilicon migration driver in VFIO to
provide intermediate state values and data during device migration.

When the execution of live migration fails, the user can view the
status and data during the migration process separately from the
source and the destination, which is convenient for users to analyze
and locate problems.

Longfang Liu (3):
  hisi_acc_vfio_pci: extract public functions for container_of
  hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
  Documentation: add debugfs description for hisi migration

 .../ABI/testing/debugfs-hisi-migration        |  34 +++
 MAINTAINERS                                   |   1 +
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 211 +++++++++++++++++-
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   5 +
 4 files changed, 241 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration

-- 
2.24.0


