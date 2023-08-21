Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAA9D7830A2
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 21:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229463AbjHUSyn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 14:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbjHUSyl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 14:54:41 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B28D6197;
        Mon, 21 Aug 2023 11:53:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EPpEbADWFKLFeyI9dRHb/zYSXedoo2Fb2TiXMWWtF5+0tS8iaV7MAYHKEjF8lB64svKDWOY5AaSYL2iufrxEWPianzAkPcdIT7bmVlNLkaQghUFIy2hmKQMaO4b/Osj0B1yYNGDbmMAKBbl+147yFWX6ZobN71I6XL4mq7PSQy/DTpe5xjoJ+Fd5Ms65Bd0rfD8plyMUmZYBADBSDsdxdkeCoh5Qs/q0ijFN40U9K47KmUijlK7r29bwTTHGxsWw6y7kdFkWeZhpZa7lta5ghw7wSFZ5Lhi1iaHgPzFxvVgvpIiM+p9jdfLaW9nnO1EdoCvFlEVVdX22LqT9+lzrMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZsqodBPlHICZeA0Di90ywJwxQrWxoZmk8tO1ZcAUejo=;
 b=R4L/ABSxbBmWlPZblYjUnvcooZCiPcOfPub2iGy0s3bfS2e/QZbHabwGO+sHlv8wQmmk2ZerFZ1u4x6rNmOjxdIjyV2giWU8Qv50Bi+2z9W40nnbA+R/XuckHXYM5cKind1NrH5zcq5pInK9MNcyoQU99Eqfr7df/r4rYtJ56m2E9FGkRU0HY1nS+ANWFvwglIx9RLPdJQmFqxnVAih7htevZzAAY3qgyXhFVJu/37faJ4lUq9NrEAQ1P9K4LzAOU5PBnjbRzOp1ZlOvDlqaIMCo5qBuDwrVf+oQ/Hqwrqc+kM/JrZV30TNS1YTG/YYP8cdF/hmYHRGVVHCBu8tCng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZsqodBPlHICZeA0Di90ywJwxQrWxoZmk8tO1ZcAUejo=;
 b=haUAvzY29dxMw6U1DjBY6+ZoAbP5RaGj2q41o12eRBJFA3wz78CLa9UK3ETFcxl1ayZtQmrZDIwTvtZLij7E7/eVXHSGhrMDO9YzUpbZAT5QNYZQgkLtmzt1iDyEZJnRmLq4ROjz0KxYVOnLps9N79tV1prm1eWv/50MaydJnyE=
Received: from SJ0PR03CA0142.namprd03.prod.outlook.com (2603:10b6:a03:33c::27)
 by DS7PR12MB8345.namprd12.prod.outlook.com (2603:10b6:8:e5::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6699.24; Mon, 21 Aug 2023 18:42:27 +0000
Received: from CO1PEPF000042AC.namprd03.prod.outlook.com
 (2603:10b6:a03:33c:cafe::ab) by SJ0PR03CA0142.outlook.office365.com
 (2603:10b6:a03:33c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.20 via Frontend
 Transport; Mon, 21 Aug 2023 18:42:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AC.mail.protection.outlook.com (10.167.243.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.14 via Frontend Transport; Mon, 21 Aug 2023 18:42:26 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 21 Aug
 2023 13:42:25 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH vfio] vfio/pds: Send type for SUSPEND_STATUS command
Date:   Mon, 21 Aug 2023 11:42:15 -0700
Message-ID: <20230821184215.34564-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AC:EE_|DS7PR12MB8345:EE_
X-MS-Office365-Filtering-Correlation-Id: 38bf6946-1657-4195-50e4-08dba2765e10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LS+EzyWnoEBIxH98tpds5a84eMSKfHQP/EAlmICOZpBoeBY59Ndur7HO26/wr47SqmF3a4hXTXjrr0kfprUY1CIK6CKUwdL/3j2/iLP7K4JNvkWC5eN8VXFvScPuMlq7lrCTIjWjj7tiWdVEUq18EtmUcT67Xjmz0jc4EYZOdodJel6BEx1f6tWcSODYekajz+Ub2R436/5LNPe68oUzFnkLx48QqU7zh4NnyTDp4aktI1xaf38SXOEAntXUKIOy28jCi560NW6oXE/HI1coOlS2vHF5an4e2kA9PA2COOgNqRZWGGX5kMiUNZqqsloAICTYx0dYMGCwUGF39TLBJu83Umdi+HDDES96NLtPXZBe3oI4ALpCuJ+IhxE8ijspa4aU7HRTBfIAkPJ+hJV9BfniZ9TrFZA0hacsopVB9wVksGvvra6xrm/PuUMRVyLUzIgM1AMD/42TFwy9xvBbc8mgFHVYAbTyM2jTEOOeQ3n/H89PUKOGKdb7e/8xLGqFfdbdgspy45648GO0y0DR7NmK98VOt79UJ1kC5jKtlJJN4mqWVG09ejn714/lavGnxGon8MSILK8Vi63WsMUYuVEAjoserVh8WvMvV3CZrHp0j5Nhu7f2nA/1wNGNcHWWxuepxwC7NWC1rnLCdspTQh2Gff/vF4TkPkM7rUVbI0PyZDpKFtqqig3B95nhOTJ+GN1FyTpHsuYI7sE45u/DcX+QWeDHKBVErtSne7qQIV4pR3xSMkYQxgYGfXHUaTCOzX8Tot59MNS+QSQ7b00GEA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(39860400002)(396003)(82310400011)(451199024)(1800799009)(186009)(46966006)(36840700001)(40470700004)(2906002)(83380400001)(40480700001)(15650500001)(5660300002)(44832011)(336012)(426003)(26005)(16526019)(86362001)(36860700001)(47076005)(8676002)(8936002)(2616005)(4326008)(70206006)(316002)(54906003)(70586007)(110136005)(478600001)(356005)(82740400003)(81166007)(6666004)(40460700003)(41300700001)(36756003)(1076003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 18:42:26.9462
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 38bf6946-1657-4195-50e4-08dba2765e10
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000042AC.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8345
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit bb500dbe2ac6 ("vfio/pds: Add VFIO live migration support")
added live migration support for the pds-vfio-pci driver. When
sending the SUSPEND command to the device, the driver sets the
type of suspend (i.e. P2P or FULL). However, the driver isn't
sending the type of suspend for the SUSPEND_STATUS command, which
will result in failures. Fix this by also sending the suspend type
in the SUSPEND_STATUS command.

Fixes: bb500dbe2ac6 ("vfio/pds: Add VFIO live migration support")
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/cmds.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
index b0d88442b091..36463ccc3df9 100644
--- a/drivers/vfio/pci/pds/cmds.c
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -86,12 +86,13 @@ void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
 }
 
 static int
-pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio)
+pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio, u8 type)
 {
 	union pds_core_adminq_cmd cmd = {
 		.lm_suspend_status = {
 			.opcode = PDS_LM_CMD_SUSPEND_STATUS,
 			.vf_id = cpu_to_le16(pds_vfio->vf_id),
+			.type = type,
 		},
 	};
 	struct device *dev = pds_vfio_to_dev(pds_vfio);
@@ -156,7 +157,7 @@ int pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio, u8 type)
 	 * The subsequent suspend status request(s) check if the firmware has
 	 * completed the device suspend process.
 	 */
-	return pds_vfio_suspend_wait_device_cmd(pds_vfio);
+	return pds_vfio_suspend_wait_device_cmd(pds_vfio, type);
 }
 
 int pds_vfio_resume_device_cmd(struct pds_vfio_pci_device *pds_vfio, u8 type)
-- 
2.17.1

