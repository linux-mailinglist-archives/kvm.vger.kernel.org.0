Return-Path: <kvm+bounces-33200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E93C9E6A64
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 10:36:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26FF91885158
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2024 09:36:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FD371F4727;
	Fri,  6 Dec 2024 09:34:19 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8D01DFE2B;
	Fri,  6 Dec 2024 09:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733477659; cv=none; b=inXEYLQDvjVZSe+NSBqjk1+VeH5Gyt8RX+pGOveE150NiymprmHJ6+hTkcvRHR1ZFFtN3eEkxfR9osmT8FMEYBFaLOKqqyHkXpgq654qD4TmZ76f10mszpE4LU3+ylYTh9c8S5z63RH8d80cIkuuuHk5FwfzeVlaCjcLqZtkQYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733477659; c=relaxed/simple;
	bh=yTpGCSU7kiiUg8HFYnZGpCy/vyEkIhSmYv0sTIBVJM0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CKHpIl/3xX9X3GMLSg/viLVmXbjzEZ1CGw31uQwne6ujIb8xZqq6HOo6dRO/MpTlvBlF48wMHwfzL1oF1H2nSdzEmZ2Yu5qFeZ7urUKSYrBIBQ2ybAy3FHUw5enDE+IINZ9KZa5H5BuHRQwwr1iz0GvP0OV74kmPoY2B9cQ2puc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Y4Qxv0qRJz1kvP5;
	Fri,  6 Dec 2024 17:31:47 +0800 (CST)
Received: from dggemv703-chm.china.huawei.com (unknown [10.3.19.46])
	by mail.maildlp.com (Postfix) with ESMTPS id 47AE9180044;
	Fri,  6 Dec 2024 17:34:06 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Dec 2024 17:34:06 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 6 Dec
 2024 17:34:05 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH 0/5] bugfix some driver issues
Date: Fri, 6 Dec 2024 17:33:07 +0800
Message-ID: <20241206093312.57588-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemn100017.china.huawei.com (7.202.194.122)

As the test scenarios for the live migration function become
more and more extensive. Some previously undiscovered driver
issues were found.
Update and fix through this patchset.

Longfang Liu (5):
  hisi_acc_vfio_pci: fix XQE dma address error
  hisi_acc_vfio_pci: add eq and aeq interruption restore
  hisi_acc_vfio_pci: bugfix cache write-back issue
  hisi_acc_vfio_pci: bugfix the problem of uninstalling driver
  hisi_acc_vfio_pci: bugfix live migration function without VF device
    driver

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 83 ++++++++++++++++---
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  9 +-
 2 files changed, 78 insertions(+), 14 deletions(-)

-- 
2.24.0


