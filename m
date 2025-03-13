Return-Path: <kvm+bounces-40898-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24FE8A5ECC9
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 08:20:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ADF16171513
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 07:20:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4691FCCE2;
	Thu, 13 Mar 2025 07:20:26 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6DA1FC7EC;
	Thu, 13 Mar 2025 07:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741850425; cv=none; b=ThUwS2jPBHBkj2qXM1WrClA5HcDAQRh31HGrtkW6ODM+PHO0X4olCYpjK86+ZzL3E2iS9HuOxoVuo1pO7YfWlfYliS9tzohhRmw4dFkQcLtPItdEnMbhZmmGi7M+e0SeLUZjbK+D259cDI+eUfVH/goBINl8Odn4d8ydUFLWey0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741850425; c=relaxed/simple;
	bh=onhJ+nONIJs1EuDIxEdIje8LeS5+gvvtViDW3yW6veo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bJzOGLJ7YZuYRa0sOeYNKd5DIuDRXQXvo5YAGwdTjdBYojAJsgcd+sIdBO1ugFi3IuwdWa6cd/qPIxFJGNI+ROtC2HZqrDHDFZZutKBIq46hQXXaGaY+j8+zHQn4lRsY9RDvqiE0gAQfa3mEWNiHFY9kZ3rN7VQXhjuLp/uQDfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZCzPN21GKz1R6XP;
	Thu, 13 Mar 2025 15:18:32 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id C7AE61A016C;
	Thu, 13 Mar 2025 15:20:13 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 13 Mar
 2025 15:20:13 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v5 0/5]  bugfix some driver issues
Date: Thu, 13 Mar 2025 15:20:05 +0800
Message-ID: <20250313072010.57199-1-liulongfang@huawei.com>
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
 kwepemg500006.china.huawei.com (7.202.181.43)

As the test scenarios for the live migration function become
more and more extensive. Some previously undiscovered driver
issues were found.
Update and fix through this patchset.

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

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 97 +++++++++++++++----
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    | 14 ++-
 2 files changed, 89 insertions(+), 22 deletions(-)

-- 
2.24.0


