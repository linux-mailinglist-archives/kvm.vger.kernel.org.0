Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8780C7A0DF1
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 21:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241898AbjINTQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 15:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241838AbjINTQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 15:16:06 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2085.outbound.protection.outlook.com [40.107.101.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0555526BC;
        Thu, 14 Sep 2023 12:16:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEr/KN3tm7qEknDJjLO7AKq1oAoTysUwjw4kj6pT+9IR4gcbNKqkn/e2+dgnmqtY6CjfU7eNdYCVW/RlNn7Po2pI4Iu+pn6goD/HiJ0PJIIkjevX2SQBkXtcfgYLsjwZj6UOYxoHHAXhxkB1dgaw+Aod4A2mqmp9TL3HZj7SKBsFoIfDz3frn4gOSeZ33dl4GJLZq6q8MxB7WMJ+EqtSKmeSm+lppj0YpP68bpY34gbpeuMaSnifPIXXNrNNCrV8nZaDbPgejYBNbqXBW9hjZS5zuiSUkEcgml0vj+Ys6a5wDBAJhp32xFnTZzdOe2pIdAyiufAs4pKHjo4im3zH/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GT8A/jR6oeASNo8i5J/kdagx5lvvur+pmWDzd3FILDw=;
 b=TOZ/mDKUy4ap22XqW4pF9e94vixWNukmCZawAddFKgRs6OSnEgOtgQ7LCiC8PgflnjEyFPsZgI9cSzEglXAl5SCkJs9ZyPiZ7VXi7Ya88djR5kHTSulPqssWalDFY3O2QpNY776f9/ow7M7ZGTiwr8chBP0hDt1aamcYLfZkMKUN8TJM+GC2iOrCrbTx8TryCWJ5mD1gkCbTsYsI4mGtnQDWAycd4p1y+2SQH+idy0ABMce9lxEoV55leIi3kIbDONGeUERW6k2tlq/MMCg7CAlJbVZomT+LQlY1S/PiFbRb4xEnFJmCqEPkzC5urD/yy3idOFTuHK3pMMUIl0PQeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GT8A/jR6oeASNo8i5J/kdagx5lvvur+pmWDzd3FILDw=;
 b=CFHjA8SF89Q83ueGtSlneSO021FBOLJX+/8dDKl6P1hSrYJkl+szboyoIOQnfhDYgR0Fsd4+C7HKIJmT82HmIlegqvpfNdZWZkD74PRGhAEGTGXLpWJOz8FxLWTq1rJFIDM4maC8LabHgvdP7/Yp/guIdOQrY+X5KLF3f3FvyQQ=
Received: from SN6PR16CA0053.namprd16.prod.outlook.com (2603:10b6:805:ca::30)
 by MW3PR12MB4569.namprd12.prod.outlook.com (2603:10b6:303:57::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Thu, 14 Sep
 2023 19:15:58 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:805:ca:cafe::99) by SN6PR16CA0053.outlook.office365.com
 (2603:10b6:805:ca::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21 via Frontend
 Transport; Thu, 14 Sep 2023 19:15:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.19 via Frontend Transport; Thu, 14 Sep 2023 19:15:58 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 14 Sep
 2023 14:15:55 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH vfio 2/3] pds/vfio: Fix mutex lock->magic != lock warning
Date:   Thu, 14 Sep 2023 12:15:39 -0700
Message-ID: <20230914191540.54946-3-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|MW3PR12MB4569:EE_
X-MS-Office365-Filtering-Correlation-Id: 12e20de4-aaaa-4dc2-c25a-08dbb55706ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HBiLJxniyV8IMp3ZgaBo7UPfUCZdFvZJY4r+rd9fQnEV8Rtq+Pbvxa5UsSg+ct387DM0xDhCOtJsHF20Efy3sK+UkUD1MWae5rDthtR1/BV7gmMlROUs1u1xj/t/2qMZywFa74ZyjZifTvq96fBXYBooBSim7N+h5BbPM0Xsx3lZY7n/cwJ+3PzeQ1feDhVf3o+7296CdsPsUjpgnuVtoLel6rMIGqPkit3bx3TtHUv+4u9wX7Dl4MV48O4C3KAV+JsWW1j/Q+3jMU5eJKVYtrbweJyPobvSCEmUhh6SAyGnTr3kCuSVqgzMXN3ZLjJbnxMKhSXyOkSqypLufPLdHVtACv43A07ZuB1GdalALWZn8H3wX7c7WRm3N0Sow4CHp0clGduLK0TjbmXFAlM2ONn0u0EiHp1fd7gJJfvjYXlfwR7x7OUW9siz+17dFNUsh8F0PdnW7YOTvTkQd1hs0JP2NB5tqld0ehZhrQwc18r04zXb/FT7c+kEJJLZnIC/Eipw8dxJmbKVvZz91bLBGfKF/bL1AKWXYihVad39D4gGqtjsm30tQ1CIxZGFLCGIJQqyRma3FgIImUUDd23kKp3VEy5e7ZKl1Mjaitpx1POLPrVIe5dM+8Wf8laUNeoUsTrWApn58jz4RJVnOY/rMyz19zw1O68q3VaJsV9RHy5yWXzttzhV5+gGIN1sFfaxcRO7tWmO3L1WDE4x7tWHhxwpN7O9MyOvsyjjPLgkaFjPK71UN9YDC0K0oYRo+oTyFlXBTNXAg+bWJCaWaNmKvA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(396003)(39860400002)(136003)(376002)(1800799009)(451199024)(186009)(82310400011)(36840700001)(46966006)(40470700004)(36860700001)(40460700003)(2906002)(47076005)(36756003)(86362001)(82740400003)(81166007)(40480700001)(356005)(4326008)(8936002)(1076003)(8676002)(16526019)(5660300002)(26005)(54906003)(70586007)(110136005)(316002)(2616005)(70206006)(6666004)(41300700001)(45080400002)(478600001)(83380400001)(44832011)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 19:15:58.1265
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 12e20de4-aaaa-4dc2-c25a-08dbb55706ad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4569
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following BUG was found when running on a kernel with
CONFIG_DEBUG_MUTEXES=y set:

[  502.794510] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[  502.794519] WARNING: CPU: 16 PID: 2571 at kernel/locking/mutex.c:1085 mutex_trylock+0x10d/0x120
[  502.794537] Modules linked in: pds_vfio_pci(OE) pds_core xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nft_compat
nf_nat_tftp nf_conntrack_tftp bridge stp llc nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4
nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink
intel_rapl_msr intel_rapl_common isst_if_common nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel rapl mei_me ses intel_cstate ipmi_ssif sunrpc enclosure mei nvme
intel_uncore nvme_core hpwdt hpilo ioatdma acpi_tad acpi_ipmi pcspkr lpc_ich intel_pch_thermal acpi_power_meter ipmi_si xfs
libcrc32c sd_mod t10_pi crc64_rocksoft crc64 sg mgag200 drm_kms_helper drm_shmem_helper crc32c_intel serio_raw igb smartpqi
dca drm scsi_transport_sas i2c_algo_bit ionic wmi dm_mirror dm_region_hash dm_log dm_mod ipmi_devintf ipmi_msghandler
fuse [last unloaded: pds_core]
[  502.794673] CPU: 16 PID: 2571 Comm: bash Tainted: G S         OE      6.6.0-rc1-next-20230911 #1
[  502.794676] Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 01/23/2021
[  502.794678] RIP: 0010:mutex_trylock+0x10d/0x120
[  502.794681] Code: ff 85 c0 0f 84 40 ff ff ff 8b 3d f2 35 eb 00 85 ff 0f 85 32 ff ff ff 48 c7 c6 47 ff d3 bc 48 c7 c7 80 69 d3 bc e8 33 c7 4a ff <0f> 0b e9 18 ff ff ff b8 01 00 00 00 e9 5c ff ff ff 66 90 90 90 90
[  502.794684] RSP: 0018:ffffabadc750fda8 EFLAGS: 00010282
[  502.794686] RAX: 0000000000000000 RBX: ffff930000451000 RCX: 0000000000000027
[  502.794688] RDX: 0000000000000027 RSI: ffffabadc750fca0 RDI: ffff930f7f920948
[  502.794690] RBP: ffff930000451708 R08: 0000000000000000 R09: c0000000ffff7fff
[  502.794692] R10: 0000000000000001 R11: ffffabadc750fc40 R12: 0000000000000000
[  502.794694] R13: fffffffffffffff2 R14: ffffabadc750fea0 R15: ffff92ffc85dc520
[  502.794695] FS:  00007f3d8e322740(0000) GS:ffff930f7f900000(0000) knlGS:0000000000000000
[  502.794697] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  502.794698] CR2: 000055cc4f6d9310 CR3: 0000000109894005 CR4: 00000000007706e0
[  502.794700] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  502.794701] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  502.794703] PKRU: 55555554
[  502.794704] Call Trace:
[  502.794707]  <TASK>
[  502.794710]  ? __warn+0x85/0x140
[  502.794718]  ? mutex_trylock+0x10d/0x120
[  502.794720]  ? report_bug+0xfc/0x1e0
[  502.794727]  ? handle_bug+0x3f/0x70
[  502.794732]  ? exc_invalid_op+0x17/0x70
[  502.794735]  ? asm_exc_invalid_op+0x1a/0x20
[  502.794742]  ? mutex_trylock+0x10d/0x120
[  502.794744]  ? mutex_trylock+0x10d/0x120
[  502.794748]  pds_vfio_reset+0x3a/0x60 [pds_vfio_pci]
[  502.794756]  pci_reset_function+0x4b/0x70
[  502.794763]  reset_store+0x5b/0xa0
[  502.794770]  kernfs_fop_write_iter+0x137/0x1d0
[  502.794776]  vfs_write+0x2de/0x410
[  502.794784]  ksys_write+0x5d/0xd0
[  502.794787]  do_syscall_64+0x3b/0x90
[  502.794790]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[  502.794794] RIP: 0033:0x7f3d8d51fa28
[  502.794796] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 15 4d 2a 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
[  502.794799] RSP: 002b:00007ffc7b6c76f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  502.794801] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f3d8d51fa28
[  502.794803] RDX: 0000000000000002 RSI: 000055cc4f742aa0 RDI: 0000000000000001
[  502.794804] RBP: 000055cc4f742aa0 R08: 000000000000000a R09: 00007f3d8d57fae0
[  502.794805] R10: 000000000000000a R11: 0000000000000246 R12: 00007f3d8d7c06e0
[  502.794807] R13: 0000000000000002 R14: 00007f3d8d7bb860 R15: 0000000000000002
[  502.794809]  </TASK>

As shown, lock->magic != lock. This is because
mutex_init(&pds_vfio->state_mutex) is called in the VFIO open path. So,
if a reset is initiated before the VFIO device is opened the mutex will
have never been initialized. Fix this by calling
mutex_init(&pds_vfio->state_mutex) in the VFIO init path.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/vfio_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 147a543a7c39..9db5f2c8f1ea 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -155,6 +155,7 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 
 	pds_vfio->vf_id = vf_id;
 
+	mutex_init(&pds_vfio->state_mutex);
 	spin_lock_init(&pds_vfio->reset_lock);
 
 	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
@@ -181,7 +182,6 @@ static int pds_vfio_open_device(struct vfio_device *vdev)
 	if (err)
 		return err;
 
-	mutex_init(&pds_vfio->state_mutex);
 	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
 	pds_vfio->deferred_reset_state = VFIO_DEVICE_STATE_RUNNING;
 
-- 
2.17.1

