Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C0679F087
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 19:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjIMRnD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 13:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjIMRnC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 13:43:02 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2043.outbound.protection.outlook.com [40.107.102.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BE5A8;
        Wed, 13 Sep 2023 10:42:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Py8K+w609xhe/93kV6gH7k4d38/pDZZJ6fAOgfyGcv317dXpmlrRXM3T/zNtsGrwHxomVpB+neLtYtsl1EJ1nSDRidam+1edULUDJ6KeoNalrXJdbXP4OE70IhrT4amXIPKQqZCqWrFlh9FmzVszaodclPjO8eDTb1PptD895xkr/cnIncg/CYjHWHSGaNicSbUXyH1HBLh/pmsLTrCdMPuxU4iHR9qhSyaEq0d9QKVmuAquraV1ZKkI1hxsuaEs7CB24c7xbhkiQHihFISkGJw8cDSsI6rK5rre59d+S66OD4SNsvFim1sXoo4CoZxmj5yAE7pNWGPDq08/Ip2JtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jWgyKQJ4caRRlfYsa9YoXwd0Ul0Y2uRZloM1iQSlmQ=;
 b=brw1djUICJwfgtpPwiJZAnCRzIrBnDw/f029NEVC66vBO5JUyozwaSAUT3G7EMze0YNnrhNTDDGDiCmUkENXIQzVBbB3Zi8BYXk5zMBZIRzzuP48WyFq9aZ7xurvNmkEa38IkRmXNYznUIuVRu4w2JWZN8R8Y7ZNF0zIQV0jy0NifAbNfYRDaK1ccGMr6kr7H9v5jkatyvynCUz1KCH/hTqt/8w1vb0oifteT1aEEFb6/btJrX1br3e7p2dKgzWZOAtsYZ0XwM+/xJOb3q4t0FbNyGX3SAS407KBVWhPTT2P3AdntOao0bdVOGOEFu8EM2QJb4EDF475s3GxVCFFyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jWgyKQJ4caRRlfYsa9YoXwd0Ul0Y2uRZloM1iQSlmQ=;
 b=htiMkrCuxAzwfA2/zPVA8DtOQ7ovC+X05kIgfiWxn8OVnKSSkLDYIlG5IMyq2SvW4dsuhhzw1hMllMneO+hQBYGnRPTUj6U65X+wJz8ZP0CI3Ju8QhiqfspHOBooGA88srDZ1AT5Gpr9DcR4exaie1Niz83VXQ60Quat3CY0jNw=
Received: from BLAPR05CA0028.namprd05.prod.outlook.com (2603:10b6:208:335::9)
 by PH8PR12MB6674.namprd12.prod.outlook.com (2603:10b6:510:1c1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.34; Wed, 13 Sep
 2023 17:42:55 +0000
Received: from BL02EPF0001A106.namprd05.prod.outlook.com
 (2603:10b6:208:335:cafe::75) by BLAPR05CA0028.outlook.office365.com
 (2603:10b6:208:335::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20 via Frontend
 Transport; Wed, 13 Sep 2023 17:42:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A106.mail.protection.outlook.com (10.167.241.139) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Wed, 13 Sep 2023 17:42:55 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 13 Sep
 2023 12:42:51 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH vfio] pds/vfio: Fix possible sleep while in atomic context
Date:   Wed, 13 Sep 2023 10:42:38 -0700
Message-ID: <20230913174238.72205-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF0001A106:EE_|PH8PR12MB6674:EE_
X-MS-Office365-Filtering-Correlation-Id: b4d3941d-002e-4d1e-4b9c-08dbb480dcaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4oqFGH88JCPAd/362LtxQyTR+XmYISEnK2W/BJXhHh+pSrYosSNEI/2kw5+Fq5j478aeoZcFzde1T246yIP++oykGgJ5phgYEAjBDQa7LOwJ9K3SVsKa1pXJ8jRgLlKFmc2HOZVOh9yA3fpXnYN0qNWEDuqllcsvHqLuyigXtFxrpc0QrB4LSNVUcE6I2AaW6pqxT+C+yp+fqIHo4on5061dnsqz7rypgfRW0BfOKitSBGxtuZkUSsWzwz8y8mfiVt3AfLyHxVIVws1sXmzzfXZK53JW5Yuow4P8XP8mJGSlwSTsK9q/8kXUKb6G+TYKhsfxYUXpI+5Em76hwi+DyndX2GCk2xWX02widho0CGBv5T8yHWc2lp+EQa2k9pgUirIxhFFzCdIo9fjjt5XL4paGVSXyzdKIir62e47Y07HoHPOrriwC17jO9WC3GOLED9ALTgYVVijoo0YV8anqiEz4W2C5Ibg/yUASvnfY+G/4fmEZEbZaUQ/6cLRkdYIYd83/wZMlPvy2/2NpJWqcWZVIrSwJ1eZXFfyFvDislBEguc4ruf8QTi+KV0ReZKyhgvKpdxtMC/fUfh4ya87rxyQJ0CkRv1KZS03XF0mWXv/9yb8TjHOH9ZGcpk+aG7OfhCpSLvEgcS1oZU+k0CmlBv7z/4VuMv/aIARCYBVFUZNY4rsPAScrVRucQ2VbvZMWsQF1lY16ATBHtnTmR7jjZzK31ToX120fbaOl/dgWYlJ45JseIgnz5nCDZ6RLy4eb1J3VqHUWEJiCtC6JleaUmA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(346002)(39860400002)(136003)(376002)(82310400011)(186009)(451199024)(1800799009)(40470700004)(46966006)(36840700001)(41300700001)(110136005)(6666004)(2906002)(478600001)(966005)(83380400001)(5660300002)(426003)(1076003)(70586007)(44832011)(336012)(54906003)(26005)(70206006)(16526019)(8936002)(316002)(8676002)(40460700003)(4326008)(82740400003)(86362001)(36756003)(40480700001)(47076005)(36860700001)(81166007)(2616005)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2023 17:42:55.3549
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b4d3941d-002e-4d1e-4b9c-08dbb480dcaa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A106.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6674
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The driver could possibly sleep while in atomic context resulting
in the following call trace while CONFIG_DEBUG_ATOMIC_SLEEP=y is
set:

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


This can happen if pds_vfio_put_restore_file() and/or
pds_vfio_put_save_file() grab the mutex_lock(&lm_file->lock)
while the spin_lock(&pds_vfio->reset_lock) is held, which can
happen during while calling pds_vfio_state_mutex_unlock().

Fix this by releasing the spin_unlock(&pds_vfio->reset_lock) before
calling pds_vfio_put_restore_file() and pds_vfio_put_save_file() and
re-acquiring spin_lock(&pds_vfio->reset_lock) after the previously
mentioned functions are called to protect setting the subsequent
state/deferred reset settings.

The only possible concerns are other threads that may call
pds_vfio_put_restore_file() and/or pds_vfio_put_save_file(). However,
those paths are already protected by the state mutex_lock().

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/kvm/1f9bc27b-3de9-4891-9687-ba2820c1b390@moroto.mountain/
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 drivers/vfio/pci/pds/vfio_dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index b46174f5eb09..0807d163f83e 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -33,8 +33,10 @@ void pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 	if (pds_vfio->deferred_reset) {
 		pds_vfio->deferred_reset = false;
 		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
+			spin_unlock(&pds_vfio->reset_lock);
 			pds_vfio_put_restore_file(pds_vfio);
 			pds_vfio_put_save_file(pds_vfio);
+			spin_lock(&pds_vfio->reset_lock);
 			pds_vfio_dirty_disable(pds_vfio, false);
 		}
 		pds_vfio->state = pds_vfio->deferred_reset_state;
-- 
2.17.1

