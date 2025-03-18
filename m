Return-Path: <kvm+bounces-41367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F86A66ABF
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 07:46:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F3F93BADFC
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 06:46:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44BDE1DE880;
	Tue, 18 Mar 2025 06:46:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF93342A83;
	Tue, 18 Mar 2025 06:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742280366; cv=none; b=R9TfgJ3bS07PyWxPmGvfmWDhstXZWR/JNpcUHlxPS7Y6ondPKBUuSyo++JyMdWKloOnDLDZQofrP0NjdSKsk/339jL+svOv/RremGpnlao/9LCGWTVfmNQKgy1ixsw3EbMRLC5hFGUUwRISoxzbDeTnw7E3+bC/OdijRiZF3QZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742280366; c=relaxed/simple;
	bh=dKjijQFxN9qw+4+sff8nrcfAL0pIG5BhTsx9yrdxjYA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=W+Jbqbo/JwrbcWiLUA6ATX0WCwID1FORTtwwnJmhuwrwctQ+LiL1XWH0adzIbeTqaQh/dg9CFAVoCXjFEebKTcJAZUjyyGsO8/BusUN08MWB4kKfBUwxhjKyGZ8lMAgJ6J7W8PxzPszQNTEWTIOCdkB3LZe8GoQNI2yo1VpflBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4ZH2LF3K36z1f0QF;
	Tue, 18 Mar 2025 14:41:25 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 12FBC180214;
	Tue, 18 Mar 2025 14:45:55 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 18 Mar
 2025 14:45:54 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v6 0/5] bugfix some driver issues
Date: Tue, 18 Mar 2025 14:45:43 +0800
Message-ID: <20250318064548.59043-1-liulongfang@huawei.com>
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

Longfang Liu (5):
  hisi_acc_vfio_pci: fix XQE dma address error
  hisi_acc_vfio_pci: add eq and aeq interruption restore
  hisi_acc_vfio_pci: bugfix cache write-back issue
  hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
  hisi_acc_vfio_pci: bugfix live migration function without VF device
    driver

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 93 +++++++++++++++----
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    | 14 ++-
 2 files changed, 85 insertions(+), 22 deletions(-)

-- 
2.24.0


