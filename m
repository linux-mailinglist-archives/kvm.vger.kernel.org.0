Return-Path: <kvm+bounces-39085-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5871FA43533
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 07:28:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E12ED1886CEE
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 06:28:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8418257438;
	Tue, 25 Feb 2025 06:28:00 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0D624EF8E;
	Tue, 25 Feb 2025 06:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740464880; cv=none; b=O19oGM8ZDYwwoLTtOBn0SJRUh9shIV8M4GiHHBgxKWXSzlW6ovfPitbNV42n7NKeUh/6rCjLW+N92hDurb7oERLEkfkV8NTP09DGosUNyZT9piOklE3vswDHa7wEYZJU5AwMJEpHb8epdXTcUEdZrzmlqVaFaCyWK28xYK6WePY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740464880; c=relaxed/simple;
	bh=D+T+cL7zCVF4XlmbURU0leyooQfo+gefrQFWll6WUG4=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RH3vs6N0LHhG19apT5f2WK0JUh+Ol3WU7Cg94zwSeuNZud2L8h5+UXDNXm2nsBp7pV6Igcylj2tM44HxjghUK0eO8LKRqfpJ4ZnhG2AHvRIPv8OcWg2DrOtFw0JFuRbRyUItYeFMpSD2y3NuIuQpNTsxsyebRvVgO7ACcVUWFUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Z26yH4sd2zCs7C;
	Tue, 25 Feb 2025 14:24:23 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id C52D61402CA;
	Tue, 25 Feb 2025 14:27:49 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 25 Feb
 2025 14:27:49 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v4 0/5] bugfix some driver issues
Date: Tue, 25 Feb 2025 14:27:52 +0800
Message-ID: <20250225062757.19692-1-liulongfang@huawei.com>
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

Change v3 -> v4
	Modify version matching scheme

Change v2 -> v3
	Modify the magic digital field segment

Change v1 -> v2
	Add fixes line for patch comment


Longfang Liu (5):
  hisi_acc_vfio_pci: fix XQE dma address error
  hisi_acc_vfio_pci: add eq and aeq interruption restore
  hisi_acc_vfio_pci: bugfix cache write-back issue
  hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
  hisi_acc_vfio_pci: bugfix live migration function without VF device
    driver

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 89 ++++++++++++++++---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    | 14 ++-
 2 files changed, 88 insertions(+), 15 deletions(-)

-- 
2.24.0


