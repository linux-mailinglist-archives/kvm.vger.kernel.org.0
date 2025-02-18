Return-Path: <kvm+bounces-38394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0368A390C2
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 03:15:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 323B93B30D6
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 02:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EBA514F117;
	Tue, 18 Feb 2025 02:15:07 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E8214B08E;
	Tue, 18 Feb 2025 02:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739844906; cv=none; b=KNejSEyOgP9kK98NtCiKwz6yMfwD0/FgrZDRL4kSgDus8hecEvczMP+yZWBBkJQnyLd+iOmSnma7qdTAt5PTO1/UGfR00Pj6x9rvoiX9HFWBimcNAsDNIrokJdyw7W1deBtOYkXMNWxGqIbmx7hw9OnucerBYstYL+kMEnWfVyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739844906; c=relaxed/simple;
	bh=chV8zIYYRIDkhq8Wv1kzAHed85FzvaGHNATHGhYlVzU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pw9kxK2PjkYMDSON1pEcpWm9g6eAZIJnBkvqR/W5k6dS4FvGaP+hSo6Gp6q7IKXKTwgyxYSoYXRSVzuSRVjnmtx8xslVCR4nJaExWeifL6heIXHOd9mNXm8A3iBzcT8SyswUiu1oCWMANCirAw7M5PMdQso6JRtSHHGyaKGSI9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4YxjhC6qqpz22vfL;
	Tue, 18 Feb 2025 10:11:55 +0800 (CST)
Received: from kwepemg500006.china.huawei.com (unknown [7.202.181.43])
	by mail.maildlp.com (Postfix) with ESMTPS id D5064140259;
	Tue, 18 Feb 2025 10:14:54 +0800 (CST)
Received: from huawei.com (10.50.165.33) by kwepemg500006.china.huawei.com
 (7.202.181.43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 18 Feb
 2025 10:14:54 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH 0/3] update live migration configuration region
Date: Tue, 18 Feb 2025 10:15:04 +0800
Message-ID: <20250218021507.40740-1-liulongfang@huawei.com>
X-Mailer: git-send-email 2.24.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemg500006.china.huawei.com (7.202.181.43)

On the new hardware platform, the configuration register space
of the live migration function is set on the PF, while on the
old platform, this part is placed on the VF.

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


