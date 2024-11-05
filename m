Return-Path: <kvm+bounces-30603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27BA99BC418
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 04:53:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D729E282576
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 03:53:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70BAA18E02B;
	Tue,  5 Nov 2024 03:53:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEADA187325;
	Tue,  5 Nov 2024 03:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730778811; cv=none; b=F3u/375Ygt8jHVHAJmrrutrYKD+17HOydgyoF491yEVlN4kIu3AOLKAlxOVTad1aivXxrbpIp3LKiefz9l12OEJjBgfxZYMUXaFZ7g2v+Bvvvc4kkZ3O/bG46s7bqSx730FuwDiB47s1dY1IrnJzAD4EYJVzcoAx2l8GPWshgNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730778811; c=relaxed/simple;
	bh=gIkLOx+pT82+BszbA3kzTk18rfQpt1znSMdP4SlhtOE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=u2pMtUJdsg1KGViX291p390uDJ0IYGkp9ECxKPU7WZCG18pY7f17sSvomtSQa9a7+xK9I4s1rUYl5/uGFWrniTXwp0dWZwwA7IESoawuIaQzUx1Teo9ZqUwAWQ9i5425zQWpg+CTMxYuwPMCH5DDjavlspR+PG0pfaPEvHqYm5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4XjDs74scNz1T9pH;
	Tue,  5 Nov 2024 11:51:07 +0800 (CST)
Received: from dggemv703-chm.china.huawei.com (unknown [10.3.19.46])
	by mail.maildlp.com (Postfix) with ESMTPS id F381E180105;
	Tue,  5 Nov 2024 11:53:25 +0800 (CST)
Received: from kwepemn100017.china.huawei.com (7.202.194.122) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 11:53:25 +0800
Received: from huawei.com (10.50.165.33) by kwepemn100017.china.huawei.com
 (7.202.194.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 5 Nov
 2024 11:53:25 +0800
From: Longfang Liu <liulongfang@huawei.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@openeuler.org>, <liulongfang@huawei.com>
Subject: [PATCH v12 0/4] debugfs to hisilicon migration driver
Date: Tue, 5 Nov 2024 11:52:50 +0800
Message-ID: <20241105035254.24636-1-liulongfang@huawei.com>
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
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  15 +
 3 files changed, 275 insertions(+), 31 deletions(-)
 create mode 100644 Documentation/ABI/testing/debugfs-hisi-migration

-- 
2.24.0


