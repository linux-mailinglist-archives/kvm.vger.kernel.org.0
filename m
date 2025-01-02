Return-Path: <kvm+bounces-34462-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8EB99FF5A7
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 04:07:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82344161700
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2025 03:07:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46F59DDD2;
	Thu,  2 Jan 2025 03:07:46 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D647B7E9;
	Thu,  2 Jan 2025 03:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735787265; cv=none; b=MLTEcC50J583DYFUWNmdIh4YBU5efMqfTKCGaQIWiRzY+zdYT0fuBxGcGQAxZEz1TTB6swRdFUjfS1abJS1GCECCDzbs5J6khHG3uPR/MXEAImC6Z5/tZuo4fcfiszAn0dxmX/8DkvZRvvQ3Tzbfu1Mg3ddKlX5X1Vx71R+X6ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735787265; c=relaxed/simple;
	bh=yTpGCSU7kiiUg8HFYnZGpCy/vyEkIhSmYv0sTIBVJM0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Sw5e0QqwN9WiSEis5V82pUs7Hx1ruuN21z9NvKgAgYXPyBuuhS5+gBnXBjyjTyLVZNs7rrw7UUaYbA0yuQSq7tvgkkWnErgtgDNJhyVNAGKLBAOJXLjY8tztzI++DeOc4dO77Orl2c/ZCJkgaPKka6ka/dKzvQ4a7Jevbn3U6S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4YNs4b1bLhzgbBx;
	Thu,  2 Jan 2025 11:04:31 +0800 (CST)
Received: from dggemv704-chm.china.huawei.com (unknown [10.3.19.47])
	by mail.maildlp.com (Postfix) with ESMTPS id D00BE180106;
	Thu,  2 Jan 2025 11:07:33 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 2 Jan 2025 11:07:33 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Jan
 2025 11:07:32 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v3 0/5] bugfix some driver issues
Date: Thu, 2 Jan 2025 11:07:24 +0800
Message-ID: <20250102030729.34115-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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


