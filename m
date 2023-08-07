Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C484E7730C3
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 22:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbjHGU63 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 16:58:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjHGU60 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 16:58:26 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018FD10D5;
        Mon,  7 Aug 2023 13:58:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KwIK14RO0kJWHM2xIh9PNCyNLBFdhZzO1S0cF0Ug0e3Mj+iqe8uzQhq2EbTh6hxb/E1iRtxRO3TDBj4iISymsG08OybWfcZQ94bEz5zIbcxmfH26aHmGpM7cPLUaj5m7z/sfXHgqcOihYb6EBIeMIapG6lrihHt5Mh3mr/wCTLYmNboBY+HVzsD+xI2+6TEbYA93zq1douMc4ItV0m6587jGvlalm+qrNSJJrm8qQX5Uz7e6S/FytWRwtlglk6xTTTBYPO177bV37E/w46roAM869aFyPkByZpc7T6pfWvmc1hvgyQ4H3a2cKcvk2SvUfdxzbyAniHPIY/LiPbt1nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHZdwicSkbvgtbhFtvyTFAG8PGTovja85+nGo4T69rY=;
 b=WEtLplblj4uScNDmUWTaX8ldJVSzRTc0vUGGZpAmv8MA8PAKw0+fQ8Bmjt93nT/siZlvSgHfMz8iSn7R+ZBRgf38gof7/DPW04ZTmQDwT/jwd0lc+cmt6VlQqcvW5M+FyucDUD/6cIxm27QgXC+Kdsv4ofnVKasRSyqu4X0rob3ON4BUD/AJ0/37ZInp0puXnTzBM8nY+CCebgrAJspkt7AYdUM7+DnHbqCOie56TSn2TXtlyZkpmwN4Q3kWhEpDfEk1eWxuz85Ku+WsUQ5WOkvN1SaSOAUsh71RaTnCKCvZ2xDNMIOqDW+kT1DO95x/6iLdcSE5vbHolYsmexyZvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHZdwicSkbvgtbhFtvyTFAG8PGTovja85+nGo4T69rY=;
 b=S8MU4HiAi2U6bhLoDm4zWXyUIH47EiyDyqRnbNE6b8m0JbYEgHhH9ry8QsBfyVEx2JNZpiZMPS09JLX5os+qinlDv1YqH24lXGxSw1SbRKNmB3XecxTF3beWRT/TqOYPy/1/ZbSmuKBLAqNcHOvlTGlX10zEp1juyAaVg/G+2hE=
Received: from BY3PR05CA0054.namprd05.prod.outlook.com (2603:10b6:a03:39b::29)
 by PH7PR12MB8595.namprd12.prod.outlook.com (2603:10b6:510:1b5::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.26; Mon, 7 Aug
 2023 20:58:23 +0000
Received: from MWH0EPF000989E6.namprd02.prod.outlook.com
 (2603:10b6:a03:39b:cafe::69) by BY3PR05CA0054.outlook.office365.com
 (2603:10b6:a03:39b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.16 via Frontend
 Transport; Mon, 7 Aug 2023 20:58:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E6.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6652.20 via Frontend Transport; Mon, 7 Aug 2023 20:58:23 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 7 Aug
 2023 15:58:21 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <horms@kernel.org>, <brett.creeley@amd.com>,
        <shannon.nelson@amd.com>
Subject: [PATCH v14 vfio 3/8] pds_core: Require callers of register/unregister to pass PF drvdata
Date:   Mon, 7 Aug 2023 13:57:50 -0700
Message-ID: <20230807205755.29579-4-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230807205755.29579-1-brett.creeley@amd.com>
References: <20230807205755.29579-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E6:EE_|PH7PR12MB8595:EE_
X-MS-Office365-Filtering-Correlation-Id: 180e6f70-5875-4271-9101-08db978909ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d0L7LzOB4qOAHm0/20rbaCC/RkBIz6bwFQ8iDrxckSVUPO48qDn3fA5SUdG7jW3s+g03hptjyyDX6m86+7A1wMJ5S4+qE+Jicyxn7fGtR8grTsqRoTkMY//PQf6rjjxlywJqcO15A23s6Qt5NF4fHMmT5vveELbz3kEHrurQu47fTRkKPeHzxShTUC/AMRNmrvRmVdpnYdCZR55iHrlm1YaJ0GYc91jrIxzccC+hkYC1FlO5JeLjSougV1MF8UXhB1cmeagwtWffEu6xbkHUpe69cLrnvvrUJeAtHZCGelDSmZjbsnNXoG87qohlzyFynitIDz6V9WVpE8LYzJaBQy3Ul6iBadOtAH2muF9wIxCQ3Q6gCmX5BRDcbBqtdYNem8Xp4QRHGwf9WOYipjEsUfYa1OHB8fU6Kw611b6ucnnKmKDAPlOgzl+wwIcqOT6FtpN+XTAT3hb2Yr6yv5lRZu+0GY8nPDhP2kyIPmw5ffh9vKlHZCAkJQITlqiU/CPR5yLIzmxstF5PfIQyppjvOXpF0wsWs8Cbs3P79YQYdYdWO1OjSgFKpFL0XwWOBp03SkXx/ZUFlVJSQCTIWxzKxd2lNqd4a3Lwgz0qivwq0MkMKH5fa3vS9MplBb+rcXPTX9S9efLIbA9eOHtcPF8KMz47LEuhWxEMDYgjBwYICpC8dP2YWCEtDcML+r/JmSucA+K57yhfs7kpgHgynFXsVG4YppLi3XmPt1yxqDE6WSKJkAzh3+V90WNxasi1eh0wC+zgg7n5mt6y4a/drO8fhQ==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199021)(1800799003)(186006)(82310400008)(46966006)(40470700004)(36840700001)(40480700001)(2616005)(40460700003)(6666004)(478600001)(82740400003)(81166007)(26005)(1076003)(36756003)(356005)(41300700001)(86362001)(5660300002)(8936002)(316002)(8676002)(44832011)(54906003)(110136005)(2906002)(4326008)(70586007)(70206006)(16526019)(336012)(83380400001)(47076005)(36860700001)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2023 20:58:23.1186
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 180e6f70-5875-4271-9101-08db978909ba
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: MWH0EPF000989E6.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8595
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Pass a pointer to the PF's private data structure rather than
bouncing in and out of the PF's PCI function address.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c | 20 +++++---------------
 include/linux/pds/pds_common.h             |  6 ++++--
 2 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index 561af8e5b3ea..63d28c0a7e08 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -14,18 +14,13 @@
  * Return: 0 on success, or
  *         negative for error
  */
-int pds_client_register(struct pci_dev *pf_pdev, char *devname)
+int pds_client_register(struct pdsc *pf, char *devname)
 {
 	union pds_core_adminq_comp comp = {};
 	union pds_core_adminq_cmd cmd = {};
-	struct pdsc *pf;
 	int err;
 	u16 ci;
 
-	pf = pci_get_drvdata(pf_pdev);
-	if (pf->state)
-		return -ENXIO;
-
 	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
 	strscpy(cmd.client_reg.devname, devname,
 		sizeof(cmd.client_reg.devname));
@@ -59,17 +54,12 @@ EXPORT_SYMBOL_GPL(pds_client_register);
  * Return: 0 on success, or
  *         negative for error
  */
-int pds_client_unregister(struct pci_dev *pf_pdev, u16 client_id)
+int pds_client_unregister(struct pdsc *pf, u16 client_id)
 {
 	union pds_core_adminq_comp comp = {};
 	union pds_core_adminq_cmd cmd = {};
-	struct pdsc *pf;
 	int err;
 
-	pf = pci_get_drvdata(pf_pdev);
-	if (pf->state)
-		return -ENXIO;
-
 	cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
 	cmd.client_unreg.client_id = cpu_to_le16(client_id);
 
@@ -198,7 +188,7 @@ int pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf)
 
 	padev = pf->vfs[cf->vf_id].padev;
 	if (padev) {
-		pds_client_unregister(pf->pdev, padev->client_id);
+		pds_client_unregister(pf, padev->client_id);
 		auxiliary_device_delete(&padev->aux_dev);
 		auxiliary_device_uninit(&padev->aux_dev);
 		padev->client_id = 0;
@@ -243,7 +233,7 @@ int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
 	 */
 	snprintf(devname, sizeof(devname), "%s.%s.%d",
 		 PDS_CORE_DRV_NAME, pf->viftype_status[vt].name, cf->uid);
-	client_id = pds_client_register(pf->pdev, devname);
+	client_id = pds_client_register(pf, devname);
 	if (client_id < 0) {
 		err = client_id;
 		goto out_unlock;
@@ -252,7 +242,7 @@ int pdsc_auxbus_dev_add(struct pdsc *cf, struct pdsc *pf)
 	padev = pdsc_auxbus_dev_register(cf, pf, client_id,
 					 pf->viftype_status[vt].name);
 	if (IS_ERR(padev)) {
-		pds_client_unregister(pf->pdev, client_id);
+		pds_client_unregister(pf, client_id);
 		err = PTR_ERR(padev);
 		goto out_unlock;
 	}
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 435c8e8161c2..04427dcc0a59 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -41,9 +41,11 @@ enum pds_core_vif_types {
 
 #define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
 
+struct pdsc;
+
 int pdsc_register_notify(struct notifier_block *nb);
 void pdsc_unregister_notify(struct notifier_block *nb);
 void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
-int pds_client_register(struct pci_dev *pf_pdev, char *devname);
-int pds_client_unregister(struct pci_dev *pf_pdev, u16 client_id);
+int pds_client_register(struct pdsc *pf, char *devname);
+int pds_client_unregister(struct pdsc *pf, u16 client_id);
 #endif /* _PDS_COMMON_H_ */
-- 
2.17.1

