Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E49137C60C7
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 01:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376551AbjJKXBi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 19:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376516AbjJKXBf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 19:01:35 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B1F9D;
        Wed, 11 Oct 2023 16:01:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8KWL5/DhdtExv4nD4D+YrsDl0PxKzsuHfsxhW7a+/KjmWXhq12w68WGxxKlEgM+M4xK8tz85wRKDdRSjKRFSd1a8pZPdCURnQjCzXa+XB6Ktgdyyso4Y9sgOsc+pAMl1lAsL1qyKDRJq8aX7k/dm/sNgd6gx2n05roH/R88EkT6bxYJ69seRPSvjhfeU74Yxh7dvIUDGCYlQdDo1egACDlBv1Iu3+kYHokEnOH8BOy5hhs6EYsIohdoj1k2Al23ZYRRHPl9UwYVvlCtC5Pd/L9mgJs51Cec+lmKBF3Ioa44WcgBimWDKiuDapFcif04laM9+ekZ8LFwF6mvcJBWmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K43OMtLi3SL2eBNzFpi18AFLkQEj3+mlb2T7C6faEBM=;
 b=dOAH31c6/llOlrHRS+VdgPX+RnUwJNqgGiBsxeZb5MnQBnqqg9+eziWuawWgMnWDnInIj9VbsKar+quanbJIbetShL1CebdNq04Li55VMFWZ0nmwM+8wDsppkqb+uhhbR280ZmvewsM5dX2gcf9vXx8hcJ1duq9MYOBQSoX4kkQ4sSopkwIL72VxFVT5iVEQc7BUfsjXZaKZ9lw9SpTL237GZvZW8nRV9zIjjJ6XWCHbpGmNyppXgcm6rYGuXCplIYGkjVgd6FOksBULEj9SJl0MiHHBykx6Iuh2hHHfmx+oAvcN6WULh1Fb2CnYALWJ3Hgd0CyaE1BMsUDAs20Aww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K43OMtLi3SL2eBNzFpi18AFLkQEj3+mlb2T7C6faEBM=;
 b=T3gNIIb5vz1dTQ7Y4C9R2fetLzCOl/cTN1s4+49aJEg0joICEEDeCsNxs6TtSL1KdHUbaeZFv6pKKUC6aVAnw542dtad4mAINkraYbg6ogN0zUiXmWBf7uJqOeGL6jWMAKFT4n+SElIPVfL/cBx97w3SRLPSSWKq0wek4SHotME=
Received: from CY5PR15CA0139.namprd15.prod.outlook.com (2603:10b6:930:67::7)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38; Wed, 11 Oct
 2023 23:01:29 +0000
Received: from CY4PEPF0000EDD4.namprd03.prod.outlook.com
 (2603:10b6:930:67:cafe::12) by CY5PR15CA0139.outlook.office365.com
 (2603:10b6:930:67::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38 via Frontend
 Transport; Wed, 11 Oct 2023 23:01:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD4.mail.protection.outlook.com (10.167.241.208) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Wed, 11 Oct 2023 23:01:29 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 11 Oct
 2023 18:01:28 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v2 vfio 1/3] pds/vfio: Fix spinlock bad magic BUG
Date:   Wed, 11 Oct 2023 16:01:13 -0700
Message-ID: <20231011230115.35719-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20231011230115.35719-1-brett.creeley@amd.com>
References: <20231011230115.35719-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD4:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: c9150eea-63ed-4dea-039d-08dbcaae014b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yssbilc0eP1bR31IebWZbTWXwLj4KXogyjsLwZH4atxjhlNZSIJbtQEGWAZG0X6gyrp/E078vbBp0dFGZTwtRazOsdPbj2oIU/+gi6Uw0hW8MqnoVX4+j+U5V1uYrilQkJOz2Sqiht4obp1K5XkJ3vqYz1I77Nx65XROLI1qtUGqchjn0lvnC/mV7mHOA0nNkbnxL/noj+5Fhqm+WTIxStYzDgkpu8h13VAM6ynTQcZ/wP0GkvbPd3Swr2JIW/2CJEKc74SSp9jaiB16jh++atPdauv5ygXJ8kALpMlhuYaP9oO2zqWNxO7Ct0FUCCEQIDD4bEkIqlYB23U6jrtFYZ3vUqLNem9bBFNGJRoZNmLGjiDjFNpSSJ/02dCTErcw9sVr5MZql2UVObNoKtgpZWn5Fz9q3om+27jdASqPqw6PR6F0D5PhZVjNbNpr8LNNR858d2X8rpAS8NDMdujlNNYfYZ2RbZXRrW6E6E/cjNi/YYpns1ShO8njj4GwN3MhZnas3suXZnWAjoqI9Lwne3MSka5dfjhVsmrypvy1x+U7lIpVuh+LV0w9HQvLiFDE2F2SV5dwweDWU7rYM2lD82vAhEtHx1MpVtgO5Xq52z6qCb273iW90tYjLyo9xCrMmprqQMC7b1IxNxU7/OP32ZxbPQwKz3nIdcELBNl67CUpUGqvIvMrCay+jCm0tOpQdSITYMHqFmcs7c5tkajfFnR7FgdsNI9o86siKbarXeDEdFrwOJ08FeHEBKTTJwa9/R38HpcXUvX30BUKSGqf1g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(39860400002)(136003)(230922051799003)(64100799003)(451199024)(82310400011)(1800799009)(186009)(46966006)(36840700001)(40470700004)(36756003)(86362001)(81166007)(356005)(41300700001)(478600001)(40480700001)(82740400003)(8936002)(44832011)(4326008)(2906002)(5660300002)(8676002)(6666004)(1076003)(336012)(83380400001)(426003)(47076005)(40460700003)(70206006)(54906003)(70586007)(316002)(26005)(36860700001)(2616005)(16526019)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2023 23:01:29.6776
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c9150eea-63ed-4dea-039d-08dbcaae014b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EDD4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following BUG was found when running on a kernel with
CONFIG_DEBUG_SPINLOCK=y set:

BUG: spinlock bad magic on CPU#2, bash/2481
 lock: 0xffff8d6052a88f50, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
Call Trace:
 <TASK>
 dump_stack_lvl+0x36/0x50
 do_raw_spin_lock+0x79/0xc0
 pds_vfio_reset+0x1d/0x60 [pds_vfio_pci]
 pci_reset_function+0x4b/0x70
 reset_store+0x5b/0xa0
 kernfs_fop_write_iter+0x137/0x1d0
 vfs_write+0x2de/0x410
 ksys_write+0x5d/0xd0
 do_syscall_64+0x3b/0x90
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

As shown, the .magic: 00000000, does not match the expected value. This
is because spin_lock_init() is never called for the reset_lock. Fix
this by calling spin_lock_init(&pds_vfio->reset_lock) when initializing
the device.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/vfio_dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 649b18ee394b..c351f588fa13 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -155,6 +155,8 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 
 	pds_vfio->vf_id = vf_id;
 
+	spin_lock_init(&pds_vfio->reset_lock);
+
 	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
 	vdev->mig_ops = &pds_vfio_lm_ops;
 	vdev->log_ops = &pds_vfio_log_ops;
-- 
2.17.1

