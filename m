Return-Path: <kvm+bounces-2329-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 660177F50CE
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 20:37:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 05EC4B21116
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 19:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3454D4EB4D;
	Wed, 22 Nov 2023 19:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kJk93R2p"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50475D53;
	Wed, 22 Nov 2023 11:37:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gFKyYYJuxGrkN7SqlQWMI/+F4dkHrWor4fd96GzcIm45c4kwEtZRmX6g6OEsmPoZZSCHi/rllgEoLfoTPsba4Qt3pLvZhZiUmG5aSrDt2oYnv5g8OlkAfXQnXb/2TJq85CEVUmPCzpOqI4S8289+IkrjxKgj3l7wF7Y2Cz8AhvVuEcoCYIz87LtGQPgE6WiUezU9xIfnWnCbgKX3EPZRpm5KhmSv+77lbd7nIOfHoRS3GZOKIIcqZ2eH/DT5pDJMsWF8NVi+w06DLGHdv12gY/w9bzhQArmHqlC1FB3ce+ixNfkiwlo8PNALm8NLJz2IVRtID72AMxGMWbMs/mjnAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kmF0om9zYBwVM59etenXl2X+XseBqdAxdMopiVpHAnw=;
 b=NeVn/HOSnP52h/+p/8whZyX8EuHo0tgONduzoPLRqHQmz+Yn4a2gjgbFwmj+l6o0IXbzO6dzCZ3CawF73gqQyf3ZcYQQXIcwkNEoeFGX6nJ9ayEi1ZK2r2OvZ/mjByA/inlJwuRucxPAlJjxVHiRcfK6sptO4DOc9ZTMabcuN5BoDn2f60WBxmooIKk6/koBR2fePh4HlQvhwCAhN65UOnwW+qrOBzRb+7Ro3J8d6C3Fj2ikJR3oc4ytd7GI3sLYSa29s4YSVdaEIC+d1rc3UUyI0IP+SQpb3K+U8N++MKCuxJ3pZZkjHY8ElLPysi6uLR46owbXeD0E7L+fhKgp+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kmF0om9zYBwVM59etenXl2X+XseBqdAxdMopiVpHAnw=;
 b=kJk93R2pSsS/Mr8wJFoiOcmgS2KBNqnnS+x4gDG51f9T/AxkRpqB+Tq1QqVVbSfI1LepHtLu4FKkIQQi6otRRfd1SWjQg9awZ14pKept8fJRBUJjBQcOxkteTGr6jas8JL8rBlOIaoqvb9fMw6k6Pu94+/PK1llrFE6nE52Z3OA=
Received: from BY5PR16CA0011.namprd16.prod.outlook.com (2603:10b6:a03:1a0::24)
 by SA0PR12MB4351.namprd12.prod.outlook.com (2603:10b6:806:71::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.18; Wed, 22 Nov
 2023 19:37:00 +0000
Received: from MWH0EPF000989EC.namprd02.prod.outlook.com
 (2603:10b6:a03:1a0:cafe::84) by BY5PR16CA0011.outlook.office365.com
 (2603:10b6:a03:1a0::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.18 via Frontend
 Transport; Wed, 22 Nov 2023 19:37:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989EC.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7025.12 via Frontend Transport; Wed, 22 Nov 2023 19:37:00 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 22 Nov
 2023 13:36:54 -0600
From: Brett Creeley <brett.creeley@amd.com>
To: <jgg@ziepe.ca>, <yishaih@nvidia.com>, <liulongfang@huawei.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<alex.williamson@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio 0/2] hisi_acc_vfio_pci: locking updates
Date: Wed, 22 Nov 2023 11:36:32 -0800
Message-ID: <20231122193634.27250-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989EC:EE_|SA0PR12MB4351:EE_
X-MS-Office365-Filtering-Correlation-Id: a9226c59-114c-4272-2f0b-08dbeb92656e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BQT96WrgB69m2zaLkxGYthRON0lt/xLVeblZoqxN0tChSCUM0h+OEycgshKRk/dd5bZO6K45ykRpUIyrFzD8i5a2bdX6Yx+e6Ok8Eb/LA0XuDkeMEr+FNKQJgom5SS1AMXMk0aOKThUeNbbnx+5+IblJfqTniVY9XLLrs5R/q1joCqYzUuOKuHfNeg3D6Ooe57vliqiQ4IAJ3uAIZ3XPoerngmU5rA5IFshukizypiStyu1wbV3aDDh+y3Xw6ujJSkH1SK6yxqYT+TMYaQfD31GILLZ3Gp9Qk9K+5VWWviVwACFRaW9X8CJtIbNhqIySgtFifhKun9DVumk8+d8xrDaApKaBKTm7/JIiGYYej5w59F4qkgthzWGCj6p3e5r+I3PtrSljeDXXiirAoks5MQNTYs/X/cbE1fNCdBsWvtZZ2+WprRvN8lOnznMFNnZ3sD7xY0ophloeQcBQuGpKPX135YlVVB3l9ZeOatqt7BkhoBzElZSdGMOuQh5n23LBl34Hw+U6KeocqotHmarLqklLeP6ZJJLas2dBdT7zDmLudCvlHABmg0qfl2IuJDBZJiA3wainEQCX4ErKgcfv5K8K0SwzAe/tg2RMcjCSFgQbR0inp+GJ/v/mDKTCjdDyN+w3z2Ujjy+60kyh77998T7xiVMViflnTAD7uTXCfET9kuFoPtDZ6r8UWL9Gbkorv9ZWx5nI5P/Eokb7/UbTNprp9dX7MmLnDxvNsTnZt7xlKR1rg8z9KD95eV4vJm8TApX6fNKUZLFiXP3mIw3B9w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(230922051799003)(451199024)(186009)(64100799003)(82310400011)(1800799012)(46966006)(36840700001)(40470700004)(40460700003)(1076003)(16526019)(36860700001)(336012)(26005)(83380400001)(2616005)(6666004)(8676002)(47076005)(4326008)(8936002)(41300700001)(2906002)(44832011)(4744005)(5660300002)(15650500001)(966005)(478600001)(316002)(426003)(54906003)(110136005)(70206006)(70586007)(86362001)(82740400003)(36756003)(81166007)(356005)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2023 19:37:00.0810
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9226c59-114c-4272-2f0b-08dbeb92656e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989EC.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4351

The vfio/pds series for locking updates/fixes in the following link
made some changes that can also be done for other vendor's vfio
drivers. Specifically, changing the reset lock from a spinlock to mutex
and also calling mutex_destroy() in the vfio device release callback.

https://lore.kernel.org/kvm/20231122192532.25791-1-brett.creeley@amd.com/

So, this series makes these changes in order to remain separate from
the vfio/pds series linked above.

Note, that I don't have the required hardware to test on this vendor's
hardware, so help would be appreciated.

Brett Creeley (2):
  hisi_acc_vfio_pci: Change reset_lock to mutex_lock
  hisi_acc_vfio_pci: Destroy the [state|reset]_mutex on release

 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 25 +++++++++++++------
 .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  3 +--
 2 files changed, 19 insertions(+), 9 deletions(-)

-- 
2.17.1


