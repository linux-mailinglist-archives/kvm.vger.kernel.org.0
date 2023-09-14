Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332037A0DF3
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 21:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241831AbjINTQH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 15:16:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241840AbjINTQG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 15:16:06 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A023326BB;
        Thu, 14 Sep 2023 12:16:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I1Z5Up1XvfsXAr0FpUmk7tvgPXqm/YQZuaRdKC1Z23OAIkfdfXNIO4Gx5OR299GwzhPg9QeI/HJ1LwVwsiRrnSGkMyr90e6JDAgn/JNAYDlry+OOLin65s4DVpm9ZSTRswnmjPX188OM4R1TgXYlI3Wh+R7gq7PLlL/uV+ETS68Htre9vjStkGu02wBgI0zFX7D+uPh6vT53pkxxYZOaJMdzuJG5YvSlyMOo2+GSv9aVd7HsU8ROsw9v15zQDiZlLfeI14pWB5NQvCLaE3zVCPweZt9DY6MxWaPrYvkLd04RPD2imm+SE7/86jeU0s/1ccSr8tcYNr9dJGaEvPEHmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pp3QuZ8rzxJqRmpkeTin7yKP+tcMvozhs31JUFgV0oA=;
 b=RpU2UIeCn2QpCxgdm5s0KU6gLFnseasDIwMeVnMnkTxeaBpGjlhpZ/uV1MWfeH90PF4fo7MZhRPtrfufqIgZKqVnruR99/DrEzQBxU7dkuZPESSJt2IbYYV5PeHV2RbAWKFsd+nZTE932RiBDtga191iytBwMzd22dTSo+YCTcG31EPDiJxLyXLJakZvQcf0jrq98vLHGa1e3BZ1ZBz5r18Vuyx8EFmOJZDNO/Apipr6v5oPPfdNYnnxSVd0jl7h90smWnlK6kvvh2v5sb9j/3T/ZI1CtyhNiuJvWdjG2WJL/qoivuMD2iZpWYOT5ickA8dE2c67Y6kKS6+zeVi3FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=ziepe.ca smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pp3QuZ8rzxJqRmpkeTin7yKP+tcMvozhs31JUFgV0oA=;
 b=Ge3K3Oo6/CmKeP3eYTye3qM7M9a/QQzOttVObW68sjrPyWjeQXKvfVxxKe+gYEqJDGdXvrNjMYYtuWJVvI9fnTVuZBlp5K/Bp1bTyGbo222cJu/GIXBJ4oAjjIf1lIqXSTK6UZsLr3GXMFlP9FGAm3XL/XHqAmh9tj1hdJ7WlDQ=
Received: from SN6PR16CA0037.namprd16.prod.outlook.com (2603:10b6:805:ca::14)
 by DM4PR12MB7575.namprd12.prod.outlook.com (2603:10b6:8:10d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.31; Thu, 14 Sep
 2023 19:15:59 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:805:ca:cafe::3d) by SN6PR16CA0037.outlook.office365.com
 (2603:10b6:805:ca::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20 via Frontend
 Transport; Thu, 14 Sep 2023 19:15:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.19 via Frontend Transport; Thu, 14 Sep 2023 19:15:59 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 14 Sep
 2023 14:15:57 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <jgg@ziepe.ca>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>, <dan.carpenter@linaro.org>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH vfio 3/3] pds/vfio: Fix possible sleep while in atomic context
Date:   Thu, 14 Sep 2023 12:15:40 -0700
Message-ID: <20230914191540.54946-4-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|DM4PR12MB7575:EE_
X-MS-Office365-Filtering-Correlation-Id: bf444e5a-1ba0-4fc1-0ab4-08dbb5570738
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XYU2Dnxcgyu+tiRtTBowcmQfUAPs0KgnXXSuJgc8x95f8HJGP5ulpSRHbhlocYjL9HxjaF4DfvBgjSqRzoI1fgFkUhGWx8SyJswZDNqEtuXqsUsl3jIkUsMlCdacOxk/MaeSu00LmLPStBex4Y7o86+bz9+rEVd9TdPx8XjSJuDxBT6IzQV8ECZ1QJ8mptc0aPdietsLZ4lvc2wXYD5G94FcJ3ue6wYFyrkWUhE2JKOMbPgp7vikQPr3D4ck8giBSnJhlgAy3FmxMKB21OOFmqDgSCcF0+ellISkShaAKEn1LszIRxzvH0PLW+MtiXA1BFGl4WPcVcKrSnkeZJRhSSLvRKgU/MKpRadSCkQ73iSmGDFYnxY+OpJitvm1sPSvaxA20QqO/LPHU+F+PH940HBlBlbcv+9Hu/0hCC6dEk8gDNEJ4x/BbSVoxjXueDytuL4PuFcXM0/LarPtjn5Uz16EjIKfQUnEDNc62+YSzkVuwaHDG05AF00IXBh6ZyNbT0BjH78JjqLIRVtBfmAr3dOtMHnu1Qz55Rbs+9gMTVBDpbMOVnT4Vlx+/WYU5DT/cjWJZWmJCsHhG8t10TCT8lYZJGmwIwKOgvd/8rcPHf47V7wnq6l2QNOWBiLgnfilTu/lkt2QLNEARU2puUQKWGHpxC7EcCGVwOo+duy9q5nQy9f1+rOl+DxxRuZKy4dSarStKuXiSL2uoTL+V4YB3h+U1T93ztOYWoiNrn4WHIuiS3kvPk/uxqKX2JA7Ui7lwgYMzfGLOkDw7OWhO298qQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(39860400002)(396003)(376002)(346002)(82310400011)(451199024)(1800799009)(186009)(46966006)(40470700004)(36840700001)(26005)(16526019)(426003)(40480700001)(316002)(41300700001)(110136005)(44832011)(54906003)(70586007)(70206006)(478600001)(5660300002)(966005)(2906002)(336012)(4326008)(8676002)(8936002)(1076003)(40460700003)(6666004)(36756003)(36860700001)(47076005)(2616005)(86362001)(82740400003)(83380400001)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 19:15:59.0327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf444e5a-1ba0-4fc1-0ab4-08dbb5570738
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7575
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The driver could possibly sleep while in atomic context resulting
in the following call trace while CONFIG_DEBUG_ATOMIC_SLEEP=y is
set:

[  227.229806] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:283
[  227.229818] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 2817, name: bash
[  227.229824] preempt_count: 1, expected: 0
[  227.229827] RCU nest depth: 0, expected: 0
[  227.229832] CPU: 5 PID: 2817 Comm: bash Tainted: G S         OE      6.6.0-rc1-next-20230911 #1
[  227.229839] Hardware name: HPE ProLiant DL360 Gen10/ProLiant DL360 Gen10, BIOS U32 01/23/2021
[  227.229843] Call Trace:
[  227.229848]  <TASK>
[  227.229853]  dump_stack_lvl+0x36/0x50
[  227.229865]  __might_resched+0x123/0x170
[  227.229877]  mutex_lock+0x1e/0x50
[  227.229891]  pds_vfio_put_lm_file+0x1e/0xa0 [pds_vfio_pci]
[  227.229909]  pds_vfio_put_save_file+0x19/0x30 [pds_vfio_pci]
[  227.229923]  pds_vfio_state_mutex_unlock+0x2e/0x80 [pds_vfio_pci]
[  227.229937]  pci_reset_function+0x4b/0x70
[  227.229948]  reset_store+0x5b/0xa0
[  227.229959]  kernfs_fop_write_iter+0x137/0x1d0
[  227.229972]  vfs_write+0x2de/0x410
[  227.229986]  ksys_write+0x5d/0xd0
[  227.229996]  do_syscall_64+0x3b/0x90
[  227.230004]  entry_SYSCALL_64_after_hwframe+0x6e/0xd8
[  227.230017] RIP: 0033:0x7fb202b1fa28
[  227.230023] Code: 89 02 48 c7 c0 ff ff ff ff eb b3 0f 1f 80 00 00 00 00 f3 0f 1e fa 48 8d 05 15 4d 2a 00 8b 00 85 c0 75 17 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 58 c3 0f 1f 80 00 00 00 00 41 54 49 89 d4 55
[  227.230028] RSP: 002b:00007fff6915fbd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[  227.230036] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007fb202b1fa28
[  227.230040] RDX: 0000000000000002 RSI: 000055f3834d5aa0 RDI: 0000000000000001
[  227.230044] RBP: 000055f3834d5aa0 R08: 000000000000000a R09: 00007fb202b7fae0
[  227.230047] R10: 000000000000000a R11: 0000000000000246 R12: 00007fb202dc06e0
[  227.230050] R13: 0000000000000002 R14: 00007fb202dbb860 R15: 0000000000000002
[  227.230056]  </TASK>

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
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/vfio_dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 9db5f2c8f1ea..6e664cb05dd1 100644
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

