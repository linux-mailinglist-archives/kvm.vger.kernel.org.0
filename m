Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F06F658B87
	for <lists+kvm@lfdr.de>; Thu, 29 Dec 2022 11:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbiL2KQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Dec 2022 05:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiL2KNp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Dec 2022 05:13:45 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D871260D
        for <kvm@vger.kernel.org>; Thu, 29 Dec 2022 02:08:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtXx5G9Rrb3XSpzBY7B/43lD/E1GctgbEZSwiia08r+eJsnBZxU1kEeLsR5EFltQ0KC4JRd/AeFb8fUjFZ14bEA36FnhDorO2Y8OBbfoAApGwLFy4y6POK4Ruc25QXuGOg9x6Ni55I/u2rq7Pc/swChsJosaKrcpk00ONSIih+VKdaag2H0MSZwIzH3bUIuR8fTbMFEQkP6TQfqz/Rwb3d1iGeUO5rgAGB4zmRmw8M2W/HAbdIhm1mHY4ipMdnCSI48ih/YTUB0Cd7B0t59R/8yGNTbhY3lXnpH6wDg/osDXk1vpkRxBkpHx0v/2IosYAPhkpGXrSz+067EXMmdxnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4oJOaRRrzNvtr8kjofNopJWbe597DxfGmksah0Zx548=;
 b=NyNUF/G8J43gY4W9pNwIf3bYP+CU/qLvquU/WNuVSim4HHnEjKRYPVSOMJZj4dYSaKRK97lUsRk2HL9mq84hoL/JoAqt0C2rGVM//3iEsH43+EwnNqF9KG2OMvgXEHHqQ3s9GN9NaqBvHKnVM9ClKToop034OvYEpzijhBeo/bXftIbozhW1Gn7/m/3lOklYOHfcRQ+ySRpNAeDmj2IiVHIr0+1lxsWczTcRoELDwVkm5Z0fy2iJQKBekmv/UuQoRNrvGr2OCc1SmcMFNhYodZbYrcrLC34kDo50LGF8chlPa5yh13lg/c+p4qctPt5X35qUFsw88k1MZ3cBUxrxpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4oJOaRRrzNvtr8kjofNopJWbe597DxfGmksah0Zx548=;
 b=dgaLsd+E35XKZRigYWToAvUKA3YsdFspJDsCYN/6xYy5XzdxuHTbxO8sowmfz6KsqO2wqXGiCMNfoE2iAe47isj41Pq/uylQGZZuVDNWOGvUgs6cIq6hDSkslGcomNohLdNVyGPYkZWRdq5CrtsI/6bqrG7F2sIvs8MKYNCCBkABAATcKIYdSSlkIIL7GsGGPCynj6Qtqwp5W6Ps2QDB4UcZzS4liYaZ+FUVGJQKHoyi4VSnQkakUJdqdsybI2ANFR+uYGOuL7yIA8EarrsJK4xMq8acetZ6vCTHDYyt6F74IAm9LjzbEVwY/KRH6CijntCToGLUrF/CB3XP6wFfTQ==
Received: from BN1PR13CA0030.namprd13.prod.outlook.com (2603:10b6:408:e2::35)
 by MN2PR12MB4221.namprd12.prod.outlook.com (2603:10b6:208:1d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Thu, 29 Dec
 2022 10:08:41 +0000
Received: from BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::c8) by BN1PR13CA0030.outlook.office365.com
 (2603:10b6:408:e2::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5966.17 via Frontend
 Transport; Thu, 29 Dec 2022 10:08:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT005.mail.protection.outlook.com (10.13.176.69) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5966.18 via Frontend Transport; Thu, 29 Dec 2022 10:08:41 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:31 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 29 Dec
 2022 02:08:31 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.36 via Frontend Transport; Thu, 29 Dec
 2022 02:08:27 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
        <joao.m.martins@oracle.com>, <leonro@nvidia.com>,
        <diana.craciun@oss.nxp.com>, <eric.auger@redhat.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH vfio 4/6] vfio/hisi: Use GFP_KERNEL_ACCOUNT for userspace persistent allocations
Date:   Thu, 29 Dec 2022 12:07:32 +0200
Message-ID: <20221229100734.224388-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20221229100734.224388-1-yishaih@nvidia.com>
References: <20221229100734.224388-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT005:EE_|MN2PR12MB4221:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab6674c-75ec-482e-bd32-08dae984a95e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /KnRhZ71JZnCPzpViQ8U9cuoWIRlbCsJmzmZqpAnMgJHtH165I196QJMIzub3Z79+1Md9n7F5ux+MUfUTUTp5SBB15FLuY62/y6FJmq3zARE0Jy1Mswa3+pfq37/h2uNo73p7nLzTI+x/Z8df3Yj50MlxzZdAULSy4ELY0FzhNT4++9UPKnU5NBjcDlaI9UoiE6Yo13iIwuRRZHYoeqv3GdG1MpJah237gk7cwfE14lqdJkDeFVYq5U/uCIIjbePZehZ2tYVWs0M9diX8yRGe/ENQCDgjDAKDkB3Yrz/GtA5z3UkOeQIeRXGFpMUaDojLsi72hgj0QHasKLdTJa2RRWYhTpGF5kgfdwRLaJazAtusqQuJ34eX4nF1gVF9pVn3ubw359TxZIhCzsh/C/jc3uUZMSUU9gHoedPFBq01gH+HsmIcZYGDYkY2GtZwMDMy3RBtg66MMlwMDQfnT3VzYSk+L3VnXUpEOrSGVnW2CaaWYy7t9G91i4/HgPv89X/goG9qHGI5h4YvLAzyC5uNbcKaNdiSTEl1tU6bx+/LD7QMTmygfHkoFPW6ExalHBGuq9PYOOlNcn7ldTlbWyxLlHRgSWSdWjUQHTU1rakzyom8iFSfsG1s/lUtAjaIO9b29AYrzTdaTVW2q9VMgwvfdjcCJCeboCSIfPu1TTDHg7ZPbsJhCsNIlLlCrGFbo8aZ1eAKtxjwA+NT1vEBh5b+g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199015)(40470700004)(46966006)(36840700001)(82310400005)(36756003)(41300700001)(5660300002)(8936002)(70206006)(4326008)(8676002)(70586007)(86362001)(40480700001)(2906002)(336012)(6636002)(54906003)(356005)(7636003)(7696005)(110136005)(36860700001)(316002)(82740400003)(478600001)(47076005)(83380400001)(1076003)(186003)(40460700003)(426003)(26005)(2616005)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2022 10:08:41.0828
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab6674c-75ec-482e-bd32-08dae984a95e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4221
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use GFP_KERNEL_ACCOUNT for userspace persistent allocations.

The GFP_KERNEL_ACCOUNT option lets the memory allocator know that this
is untrusted allocation triggered from userspace and should be a subject
of kmem accountingis, and as such it is controlled by the cgroup
mechanism.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 0bba3b05c6c7..a117eaf21c14 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -744,7 +744,7 @@ hisi_acc_vf_pci_resume(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 {
 	struct hisi_acc_vf_migration_file *migf;
 
-	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
 	if (!migf)
 		return ERR_PTR(-ENOMEM);
 
@@ -863,7 +863,7 @@ hisi_acc_open_saving_migf(struct hisi_acc_vf_core_device *hisi_acc_vdev)
 	struct hisi_acc_vf_migration_file *migf;
 	int ret;
 
-	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL_ACCOUNT);
 	if (!migf)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.18.1

