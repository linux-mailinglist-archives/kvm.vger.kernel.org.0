Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9867A0DEF
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 21:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241798AbjINTQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 15:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241731AbjINTQD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 15:16:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1ECA26B3;
        Thu, 14 Sep 2023 12:15:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJsh3fj+bLvs86UoTr6P08712Y5S9BtOHcEwFXxbzbIsLjE0nH6VAJ9ZZiy/dxPoRCOw2M0A2WrJT6MzpoHc8e2+Pjp7hQfMB5wvd9r0joDj9PsyYRlI3kLS/DM1+aVs5F1HrgREfSlG1Fb+kDF83h7h3hjKZuLSYy8t6kiUFOoaHnjIaU5dcIzxk/gLF29sjokllAwycDiH3uBaaL9t4Gpj9po+kO+Qpxg6CIH0sIchU4nFBY3kOmBYn2Nv7JDoIU1dFmTA1bfTTtiJaqZ4MQ1vDgIFuJ4hF8sJYdrAOz89W1ho+MSWrbat/7W0DfrAvgh4DXe0wn5jlkpPrEvDdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NG7Jyj8R8P2UlL7YSF1hhHIULyx5NwgQGf+S9OQuyHI=;
 b=QflN4crE7tUjfC5eK4IdQJfVXpGlcclJ+lXynJCMI4hYzyATJBRcg7GUB5Vfni4UgA/NdtG2dgVQJeUiTX3AyOdjze0vfFPkv8YtUkOvR7m+C+WaBjBcI1mW4umTi7THNILhJk4qTp/VJAiomBxfffLtKcdIwzgkGhPepd2EF0+FfH3wZigNwfYecaO13/aoiUdMP4QW4zofCPJBW2keGoi8xnt6pG0CJmJitk4UsoC0ZKzRa36mIy8rReBGx99O1yuIFRn6mPua2bd/P/Y9FvIYI3On53GJzZP7E7SptwSd08NCpdZeywAOHIFLJFDVsHzxkwmBPsQgpOfxz186mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NG7Jyj8R8P2UlL7YSF1hhHIULyx5NwgQGf+S9OQuyHI=;
 b=F8ExpzR5BWKWs6YryP6jFQDcaQfV4RGp6aZC+f50aeJ5KRFvpZx4N8DduvVUoqF+2r7H+otm1h7jqE/8iDcSwMLaXQV9tQtnuqGWqGDIsAVah8apOODxPj5XdiGwaFsgJdPmPnMlrV+Dk6rbbx/SSB28Xu3XVMYZ2vOxCKSMWvQ=
Received: from SN7PR18CA0003.namprd18.prod.outlook.com (2603:10b6:806:f3::23)
 by BL1PR12MB5240.namprd12.prod.outlook.com (2603:10b6:208:319::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Thu, 14 Sep
 2023 19:15:55 +0000
Received: from SN1PEPF0002636C.namprd02.prod.outlook.com
 (2603:10b6:806:f3:cafe::74) by SN7PR18CA0003.outlook.office365.com
 (2603:10b6:806:f3::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20 via Frontend
 Transport; Thu, 14 Sep 2023 19:15:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636C.mail.protection.outlook.com (10.167.241.137) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Thu, 14 Sep 2023 19:15:54 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 14 Sep
 2023 14:15:53 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH vfio 1/3] pds/vfio: Fix spinlock bad magic BUG
Date:   Thu, 14 Sep 2023 12:15:38 -0700
Message-ID: <20230914191540.54946-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230914191540.54946-1-brett.creeley@amd.com>
References: <20230914191540.54946-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636C:EE_|BL1PR12MB5240:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e988d62-59f0-4c17-bfae-08dbb55704b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hEIC0XHe7ol3BRzRMyLW0cUEqTso4OXPTGBPC83wIpCmSt5T3eOiOaOkZOpJXW2zPGc+wEQbe2v+cs72dh2zF3tMaKSH7/ew/oN9PLTG6SQhjP7tQz3OOqyxYgnp3WfmBoKjdUowEs+3Z5I0h6m0VDdGVqMQWdbTZ2sNK921q6gl51AN4kxd6wEga22u9FZtVaCBxv075ifkaB3DQR4NcOKbHa+7apq4ktiiqlnW1GfAA0+BiSKgaPs5XlTFqh0GRzRJIYa0LleaLDPqdZTrip3Qzb0qu2rEhi9JOXVpkkMPN7T/gCEEpGolXLGtnaoyD+HZpO1gfpN5a+nyPb/6HuIsnNw+JS5TYTjtVuiTeUCOEAllfDzbn3PXUS5+uxC5X/sumF0L7umtQBGEZ93S9XxR1k+SYeFpryoGMJ5LKlqSEybbCs0vMN6vMJV65lrT5JwZ1rVpThx1YzFgXOVs4vj2gOGJ+/P8M0MfsnvKBRk9cGQuLh0ZkHvMyZq8c69w63B0KyBH77xr/BfRRGY9w4Vwq6VVB2X4HeqDXPhBMrJliIPn2JLtkHZjAoJsthlOjID/zSiXiJlxerFNHib0GhvyO/Kkti8I/ssN3/mWShaxWS4Adw7gBL8mWj5Xf6HrsUBZMg3Y+Q3EB2SPAamAiU2+0N44eWSx9ZKrRtPh/K5Hyh5/Hl5m+3KCZPKqfpxcYzvY46yI93n0SBnM5WeVL99NEtUHZvSJqP0AF14LWcE0mOWI0qbE6oE5QClc5Ezjlqv9sJktQMG43a4FyI9rsg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(396003)(136003)(346002)(82310400011)(186009)(1800799009)(451199024)(40470700004)(46966006)(36840700001)(40460700003)(5660300002)(26005)(16526019)(8936002)(8676002)(2616005)(4326008)(1076003)(2906002)(83380400001)(86362001)(81166007)(356005)(82740400003)(36860700001)(47076005)(36756003)(426003)(336012)(40480700001)(44832011)(6666004)(110136005)(54906003)(70206006)(70586007)(478600001)(41300700001)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 19:15:54.8587
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e988d62-59f0-4c17-bfae-08dbb55704b8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002636C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5240
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following BUG was found when running on a kernel with
CONFIG_DEBUG_SPINLOCK=y set:

[  675.116953] BUG: spinlock bad magic on CPU#2, bash/2481
[  675.116966]  lock: 0xffff8d6052a88f50, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[  675.116978] CPU: 2 PID: 2481 Comm: bash Tainted: G S                 6.6.0-rc1-next-20230911 #1
[  675.116986] Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 01/23/2021
[  675.116991] Call Trace:
[  675.116997]  <TASK>
[  675.117002]  dump_stack_lvl+0x36/0x50
[  675.117014]  do_raw_spin_lock+0x79/0xc0
[  675.117032]  pds_vfio_reset+0x1d/0x60 [pds_vfio_pci]
[  675.117049]  pci_reset_function+0x4b/0x70
[  675.117061]  reset_store+0x5b/0xa0
[  675.117074]  kernfs_fop_write_iter+0x137/0x1d0
[  675.117087]  vfs_write+0x2de/0x410
[  675.117101]  ksys_write+0x5d/0xd0
[  675.117111]  do_syscall_64+0x3b/0x90
[  675.117122]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[  675.117135] RIP: 0033:0x7f9ebbd1fa28
[  675.117141] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 15 4d 2a 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
[  675.117148] RSP: 002b:00007ffdff410728 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  675.117156] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f9ebbd1fa28
[  675.117161] RDX: 0000000000000002 RSI: 000055ffc5fdf7c0 RDI: 0000000000000001
[  675.117166] RBP: 000055ffc5fdf7c0 R08: 000000000000000a R09: 00007f9ebbd7fae0
[  675.117170] R10: 000000000000000a R11: 0000000000000246 R12: 00007f9ebbfc06e0
[  675.117174] R13: 0000000000000002 R14: 00007f9ebbfbb860 R15: 0000000000000002
[  675.117180]  </TASK>

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
index b46174f5eb09..147a543a7c39 100644
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

