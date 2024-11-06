Return-Path: <kvm+bounces-30902-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EABE9BE374
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 11:04:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04CAE285803
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 10:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 212AA2E400;
	Wed,  6 Nov 2024 10:04:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D3B41D9341;
	Wed,  6 Nov 2024 10:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730887467; cv=none; b=bOfewqJQjMCZ8GED4nMKg1lAz3GTg+N3ve9ixqdly9MnksLmBCRuLs3uelberAzsEH53EP5BhVQv08io/uqo90Y9H/hhIfbjmNNtQ8QDqmM8RBFbTh4VAgXT0DP4fDyaDW67a6IV2VzKJp8623GSQO+VdRend7WgqYzlXfb9sx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730887467; c=relaxed/simple;
	bh=+wzOn7yqyZd9iOFvQopl/sxH63ViRLCfuJLJoLINwxU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=j2jvAoRue/npvNGDq0PLvQ+rez2KzAFbCM7us92Wga6ztciAulyvtV5ic6IiWW8k+ijMmGxwVL9UXkh89VGngLKpfPATXob/D6T/kphZYhKLblhjmsR3TJbyyP11pzYtfmluhsUu9uqUHTeoaiIB25kAjvwoVsZazznOJprfXRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Xk13x0wV5zQppn;
	Wed,  6 Nov 2024 18:03:09 +0800 (CST)
Received: from dggemv711-chm.china.huawei.com (unknown [10.1.198.66])
	by mail.maildlp.com (Postfix) with ESMTPS id 40C2318007C;
	Wed,  6 Nov 2024 18:04:16 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 6 Nov 2024 18:04:16 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 6 Nov
 2024 18:04:15 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v13 0/4] debugfs to hisilicon migration driver
Date: Wed, 6 Nov 2024 18:03:39 +0800
Message-ID: <20241106100343.21593-1-liulongfang@huawei.com>
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
 kwepemn100017.china.huawei.com (7.202.194.122)

Add a debugfs function to the hisilicon migration driver in VFIO to
provide intermediate state values and data during device migration.

When the execution of live migration fails, the user can view the
status and data during the migration process separately from the
source and the destination, which is convenient for users to analyze
and locate problems.

Changes v12 -> v13
	Replace seq_printf() with seq_puts()

Changes v11 -> v12
	Update comments and delete unnecessary logs

Changes v10 -> v11
	Update conditions for debugfs registration

Changes v9 -> v10
	Optimize symmetry processing of mutex

Changes v8 -> v9
	Added device enable mutex

Changes v7 -> v8
	Delete unnecessary information

Changes v6 -> v7
	Remove redundant kernel error log printing and
	remove unrelated bugfix code

Changes v5 -> v6
	Modify log output calling error

Changes v4 -> v5
	Adjust the descriptioniptionbugfs file directory

Changes v3 -> v4
	Rebased on kernel6.9

Changes 2 -> v3
	Solve debugfs serialization problem.

Changes v1 -> v2
	Solve the racy problem of io_base.

Longfang Liu (4):
  hisi_acc_vfio_pci: extract public functions for container_of
  hisi_acc_vfio_pci: create subfunction for data reading
  hisi_acc_vfio_pci: register debugfs for hisilicon migration driver
  Documentation: add debugfs description for hisi migration

 .../ABI/testing/debugfs-hisi-migration        |  25 ++
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 266 ++++++++++++++++--
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  18 ++
 3 files changed, 278 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration

-- 
2.24.0


