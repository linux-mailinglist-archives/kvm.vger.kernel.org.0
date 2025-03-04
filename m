Return-Path: <kvm+bounces-40026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C03F5A4DF4A
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 14:32:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D09517920F
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 13:32:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E43E2040B3;
	Tue,  4 Mar 2025 13:32:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96EF1E4A4;
	Tue,  4 Mar 2025 13:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741095122; cv=none; b=Y4yLH4fd8PKjKD5iXNMNrzFYIFmZVKKJduCyDddBvgney0jF0GHiYE8+LIqO9kGGvYUwWoIsy8PVXoIm/ABgs/hjgFrjA24FTOK39RxCZDgl62kdlRv1E78vHnb7okFjFywhDbn1JaVwRIB7mfmFgvQPd9vLfu839qiaSs7t+0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741095122; c=relaxed/simple;
	bh=ofQ+bjt5YPUxI1ymAphLSoreHAIpCLNDhdVDNm8gNcQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=RDmH5O4SIVKuQkvDBFPwZTldFIoe0OLYbRiEEuu9oaCnKKJrgEzdGT+xbzjVRQdiEwj5owEtUPpPy7JxTbmPhJ+TJR0bt4mg/CQlDvv91f7MZBpQM2vkT1UuLIZ7KZXP4EOq6isW7fENY7Dj0HPj/gJnCwvsLfmax3jtphJREoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Z6c1W6hSHz1dyv5;
	Tue,  4 Mar 2025 21:27:43 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id 0D3FF1402E2;
	Tue,  4 Mar 2025 21:31:56 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 4 Mar
 2025 21:31:55 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v3 0/3] update live migration configuration region
Date: Tue, 4 Mar 2025 21:31:55 +0800
Message-ID: <20250304133158.45370-1-liulongfang@huawei.com>
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
 kwepemg500006.china.huawei.com (7.202.181.43)

On the new hardware platform, the configuration register space
of the live migration function is set on the PF, while on the
old platform, this part is placed on the VF.

Change v2 -> v3
	Put the changes of Pre_Copy into another bugfix patchset.

Change v1 -> v2
	Delete the vf_qm_state read operation in Pre_Copy

Longfang Liu (3):
  migration: update BAR space size
  migration: qm updates BAR configuration
  migration: adapt to new migration configuration

 drivers/crypto/hisilicon/qm.c                 |  28 +++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 206 ++++++++++++------
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |   7 +
 3 files changed, 179 insertions(+), 62 deletions(-)

-- 
2.24.0


