Return-Path: <kvm+bounces-10174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E39286A483
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 01:32:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03F85283470
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 00:32:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930D83C30;
	Wed, 28 Feb 2024 00:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FbOFIMaV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2064.outbound.protection.outlook.com [40.107.102.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FC5366;
	Wed, 28 Feb 2024 00:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709080349; cv=fail; b=ggqcG+hn+/Clt+ZxlrDr7hZkJNvWCnQiqvcF9/2PcecYsiN4lEK7r4tSJFiv4kVbyj15PN3pj4JQ2bWT1RacniJOjJF7+Q1Ri0l81S03fjAp2TKh7KyFFB9JP/Q4AZM/haAtSHK+XiiTksXXrJiLS2XLLN2OO/AnLkT4IQCBYXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709080349; c=relaxed/simple;
	bh=oPoogPMOgVO9J09hUOPwpoY2C2JspsY/w5n1c/rOV9E=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mjkI2lMGoSAXsU7n3FGNGTgDdS9/dtkARxITSZrgziOnJ1+/p1+ZspkCKVuSp2PKHtrD/6MjLDNVT6oYeWODYk7gt/+bsG2PxYwYzXT0oSFIkwZio+v+7tUU3iJ4hve6ekhTJuI974CVQsKt7PWwi7zpA9xv69Y94Aoiu+/TAR8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FbOFIMaV; arc=fail smtp.client-ip=40.107.102.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OmSNNugJQmJlqZRZO3MMmG66YJg8YIvO8cY/AGW9mtNHPJwJNnqX6FAx37x70iY8B7F6rz+8D+LGGOFLj1gqdRJ09TMLmiQciLkYCWQi0X/bMGbJ4Budx43iAwnHpVSXqiLL/oBdbxg53C2rpRAWIKKXK5fw7H9ti5FeJSJsp2UmnEkY7pcZWxaAMFwgULhZMNSGh7q8/WiCJ1rfYYtvymf6Tl41lc+9I9olg+K375EvxJbxlYugTsxKwarW1IbSaduy1PafF0D2u3SJ6BrjBrBhjNDppMxsoQgZKeD3ezMLYvPhk17nr+B3yvN4YkWoQw4LdsfyHAxRP3QyFpwc+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ln8tPIl6lFxhh/jrJP1VIgAM4AqeX5LMSgbkjs2lRFc=;
 b=MkvmBtlmIesxt33VqZ65tJmC3Jv7MdvC3p50ia+aLydcVzEGykZsVNcA9TgUjeiYLg8E/T57pb9zGXraRjN2qe3nu+pj6dVaUG+Y5cptHgUljAnoZBv9HKn7Yr3fgbeoETd/PJCPZPBfbDg75EP4/MSUBEOPUkobdJLEkYvc9YErXCqxdXVwVgIuxrtTE7IVqIZ/X0HvNv7MAtqtd1LN7PU98fvO7CQhK5EVX+YS5DRqLsrZumvhmeoAA6NxS5MJ7mHVhg4bFPlPsx5ahvJnEAEP9TLf8UTMY+7+9OAUgjx2V9J+kTCiJSrBL3m+JPeEWBp6iwtiAlZPFwEWO8dDIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ln8tPIl6lFxhh/jrJP1VIgAM4AqeX5LMSgbkjs2lRFc=;
 b=FbOFIMaVB2AHhuBuUdHELXErgssrCOfLQLHYa1qxrmWG4aBvy93KA/GKcUEccnJEwakrhBovGU1PTrwvQQZPybTEFPnubwuoPHh6BmRWlw65EzWXUWmUwT6+nbT2e2KX9QmAE0JteSXdvHdxsJkBzWFBAPZbIwmcfp/Hq9XJASY=
Received: from SJ0PR05CA0051.namprd05.prod.outlook.com (2603:10b6:a03:33f::26)
 by SJ0PR12MB5471.namprd12.prod.outlook.com (2603:10b6:a03:300::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Wed, 28 Feb
 2024 00:32:23 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:a03:33f:cafe::65) by SJ0PR05CA0051.outlook.office365.com
 (2603:10b6:a03:33f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.29 via Frontend
 Transport; Wed, 28 Feb 2024 00:32:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Wed, 28 Feb 2024 00:32:22 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 27 Feb
 2024 18:32:21 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH v2 vfio 0/2] vfio/pds: Fix and simplify resets
Date: Tue, 27 Feb 2024 16:32:03 -0800
Message-ID: <20240228003205.47311-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|SJ0PR12MB5471:EE_
X-MS-Office365-Filtering-Correlation-Id: b2f84a90-0239-4764-2590-08dc37f4bb1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QISUZPfsryPI8IMd4msqwbMucAUGwhQmZ2SOCZp9ZTT5zKAkAFnJKW1+ryAky4qg1GEziVIa5nFgTHZcuhPD8LyVizehU7ULG/wO7Rb6go9e2s3jxojKG7U+z8lCFJiZ7sbJX5ndY1uQZwagUDb93+bO6xgtmjN/KTQiwRxqqydBk0JV2LUQ3fNHoI3GfdyrwjyokF25pRrTxno2nCUR5TegP+ghAxtG0vI0xzseiiTAVsaZp+eVVBPOecjOrxZx6GZ0E6n2qxZFVIng6jTW7INCJvb9CdC5DSKRhFMq32U/h9+85AE949fXD2dMgsr3JG09IKRCFfKuz7QQ93u+0k6LxKteKqpkcWRX4glVDKrR1zsKZY1p4TxmY7Ek88JlVcDGIJjqhD6gMtr5OZD9Cxch2Xh/1ISljXM3nt2SYI7buPd+KPYvgjjJSPjJxDdK+fFwou0o727YcHcqLNnxshXAPuy9AJy3I7UdOrxUEgAO3w+l8q1lCdwmOXVsJCX70fNWil3ymbUbk7rCWFXRd1jdjbw9tDmwy0XW4e1DHtXnUrDWod7/z0CWmMME9KW+GXui+OaSscaVUtQ+pVzlvkyUGLGhiWH1JAyrodUk0h1qzDiROWOWvitJQ0opjNldBIjl3z6btwFnALD2FYOr8zxw1vQAo4LNNiAYuiF9TEz8Qv/f12Fh2RnXBoUfkECs4izD6jHYxoxd0bl9NLVtvpGJobVsHYrRO+CkTPy3k45zdTZc/wiVmX6I9BBp6Sm3
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2024 00:32:22.8977
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b2f84a90-0239-4764-2590-08dc37f4bb1f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5471

This small series contains a fix and readability improvements for
resets.

v2:
- Split single patch into 2 patches
- Improve commit messages

v1:
https://lore.kernel.org/kvm/20240126183225.19193-1-brett.creeley@amd.com/

Brett Creeley (2):
  vfio/pds: Always clear the save/restore FDs on reset
  vfio/pds: Refactor/simplify reset logic

 drivers/vfio/pci/pds/pci_drv.c  |  2 +-
 drivers/vfio/pci/pds/vfio_dev.c | 14 +++++++-------
 drivers/vfio/pci/pds/vfio_dev.h |  7 ++++++-
 3 files changed, 14 insertions(+), 9 deletions(-)

-- 
2.17.1


