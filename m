Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE4378013C
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 00:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355817AbjHQWns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 18:43:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355853AbjHQWnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 18:43:47 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B3026B6;
        Thu, 17 Aug 2023 15:43:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcssBo6rmL/Bb6nrwFbQvxF/+JvGOe8EOiOmr9SUNp04dKcapWNDelqoZilPOJaL1qghcai0/Wa06VWfXTh+lFuufo41FR6X0TlT50xWsDF6ez3lfwSe6LH2B6d7sk2RyOstxda7Gj8zqjT9pD6lWXX0I4lcTC0Co0bxjUCjeTsD1WrDyygQujnySHiDRyLWH8uiZPD+4oAfsQOJJT1zYkdeAwkVlAwlo7HubWqbxnvtMB/Z9eqJC6hMk4Qr+gaN/886at+/OX/mktP5UyBJ8YbJkzVYLfhrnlzZyCCaMDExrcUx5+q9jYoI0rSZ0mXH/85ebXaNUIhkF5Knsir7Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HRZdOLzOYB5HEZ1zp9qymqUiR2dV/zoVk2Soc/Gjecw=;
 b=iMq6L6mD0rOVRzaTA1+LRB4LUpnN2VbDIZSQ4We7icCf/8T2Hr39j2MIGaNupHmwrtv/Ma8YaydnIiSEju6AeEhZ8vEKsmBmZKNkRgYAea9mC1yB7ro8s/vVlMa2MKHv7wNDe54bym6uMfF29DpRyIH01mI2p9Aba+8QzZ5dk21Ndcttg9WpIQqdLXJikHENsuE585wfkQcBxhX9ACHEAbrvxTKrzcEXi/mJAYzyiG8ZK0ODsRqhKOT0s0cwsQDKQ5nr4/MgLMFPYYIz59b7COYq3rfDmRbMrWPt7wGddK+vQKxRZ/NHEXuKFO19kjSX6dqT2wpcjPheg05DaPDnLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HRZdOLzOYB5HEZ1zp9qymqUiR2dV/zoVk2Soc/Gjecw=;
 b=IPRdkf/+a+XDh9g67QGm2tXioDcx2rBslk1C9vEmcpoOoPJwNBTAt36IHtn1jVWBJiVhLfpnBWNZfb9Fnl91/euppFxHV4GjyTfPE/SLOUKNrzof5LtArvn3uZ/GmCRzG9HJlISkU7xLO2/braL2iDTeaQ622bH1OZ/iGu8eUuc=
Received: from SN4PR0501CA0122.namprd05.prod.outlook.com
 (2603:10b6:803:42::39) by CH2PR12MB4875.namprd12.prod.outlook.com
 (2603:10b6:610:35::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.31; Thu, 17 Aug
 2023 22:42:41 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:803:42:cafe::60) by SN4PR0501CA0122.outlook.office365.com
 (2603:10b6:803:42::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.14 via Frontend
 Transport; Thu, 17 Aug 2023 22:42:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.14 via Frontend Transport; Thu, 17 Aug 2023 22:42:40 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 17 Aug
 2023 17:42:38 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>
Subject: [PATCH vfio] pds_core: Fix function header descriptions
Date:   Thu, 17 Aug 2023 15:42:12 -0700
Message-ID: <20230817224212.14266-1-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|CH2PR12MB4875:EE_
X-MS-Office365-Filtering-Correlation-Id: 300041e6-489b-4db7-4b90-08db9f7343c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J925YjJ3Inqcrm3zTBJL8JQNSbm0NLF0If1yT5/Qc9WYGAQVRZvEY/ppcwFMpWIzRShhMGHGWrH3tK3/edhTkyAQbhNyAcWlufSli2MOO6Y2NmY2AgFBoLsDi+AIPH6w8Vs3vMgC5PS3fQMfw8zgb7NETloEjzS2mk/uH3Dksbsfp9Y/CyeDeD2NYP/3x+MhqyUqX+trQS9VQRj2TlJCMzUJa4wVs+y6Ze/bX5S6ya0xeoJmErTNMEwsP4Fd7Ga0QZ4E3uJ7fWB15ACezIEqPNP480WgKgETahpyJRATNt+0Z7r5PMga8n55W9oEh4Hy6zJ6jvsu868nx/MXimTEHgCzg+ssdpbC3WKj+7/u6j9zedrA0oCArLhZNE/rZx+gg59Yubtq0g9+S2BfPDqsHxVemnXDkhKjMpU/Rm0ICFW8daiA0qtBh9/d5t/Bi00N54A2t+lIjTxzgr4bc0PztsbqFMc7gCVLZzG1NpYJbIjfbOGdqGNOMFf70qmR79EKEe1luWapcBrOsRmNJasaMlJufvdGck0e6zfN+tR77UON3bcAXzXV+3NXGJN0vAoQdF9hQa8AEFVotS/3Xs3j2Bolz6jzo2l1wZmnKuu3kagrJE9dDlcJckzi5JTYAtRn32rZnkhV2K2zKDF683i1vml9q4TbRbpZ0EWUnB1sKyTljXnl4TiKWu9sqMEbMcnVkkPB8nZyt3TXOpha9l6imejDrcqE6XO64C0De+/ml0hs86WoqQBTnDWrRwvHKBOf
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(39860400002)(396003)(1800799009)(82310400011)(451199024)(186009)(40470700004)(46966006)(36840700001)(6666004)(40460700003)(83380400001)(81166007)(16526019)(336012)(356005)(426003)(26005)(86362001)(82740400003)(36756003)(47076005)(36860700001)(40480700001)(2616005)(1076003)(41300700001)(316002)(2906002)(70586007)(110136005)(54906003)(70206006)(44832011)(5660300002)(8676002)(8936002)(4326008)(478600001)(966005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 22:42:40.9163
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 300041e6-489b-4db7-4b90-08db9f7343c0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4875
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The pds-vfio-pci series made a small interface change to
pds_client_register() and pds_client_unregister(), but forgot to update
the function header descriptions. Fix that.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308180411.OSqJPtMz-lkp@intel.com/
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index 63d28c0a7e08..4ebc8ad87b41 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -8,7 +8,7 @@
 
 /**
  * pds_client_register - Link the client to the firmware
- * @pf_pdev:	ptr to the PF driver struct
+ * @pf:		ptr to the PF driver's private data struct
  * @devname:	name that includes service into, e.g. pds_core.vDPA
  *
  * Return: 0 on success, or
@@ -48,7 +48,7 @@ EXPORT_SYMBOL_GPL(pds_client_register);
 
 /**
  * pds_client_unregister - Unlink the client from the firmware
- * @pf_pdev:	ptr to the PF driver struct
+ * @pf:		ptr to the PF driver's private data struct
  * @client_id:	id returned from pds_client_register()
  *
  * Return: 0 on success, or
-- 
2.17.1

