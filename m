Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D8565F4A7
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbjAEThA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235962AbjAETfe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:35:34 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A731417E25;
        Thu,  5 Jan 2023 11:34:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EWbWMxiaRBdPwhiW74kqliRwV4+vs2KvSUlERYEhe3/aIsp4JmjfZWZbDKGlEbTibUPFhkULU25ry/hmS3mP3hCtis1lg4nVw3yIYaA2oJBz90piUB+xkL4eS95yUQIO0bKDmq+3c6FwlwuR15H01JUYi08kwjaZlS3vQVbUXmmp9tOezaiw0ar9a9VjYdHbpJqHmInTv/0gqD2kyQzoU1t2UE9f+neSvyEtd9iSMBtqq+wK12igSGY01NeW2UcedJi6NggEAf4HQNhYaBiexWcMCTFvzBsnI6SrvL302gjgBTRXqzBjSZ/x2WA0Md2WlitnqbSdM9iNyfXPM11W1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hl7XhSH9iz91PAHAZaxI8XUWKANy2bz24h1oI8ozYO8=;
 b=g9KNvDOQ5pTyZXkydgsAq0DTpH0sybr5ERECqw5gfzTk+bD/33eebG599TvGR8qWl8oervkiree5KgwtlT38904pm9PVrf6gkBjjt+RDCbGEjNdCI0P75StuE1ZzTRDc2qBsv8+W4avyAX7G3ceW7JnliaVX3iyZM7mnH0rSbC4bbQXGVNMmhOZXf03uPOju3kjbGiy1KksEkM8hipAtdHgOVC5AM+oPEsywNTcWqjo0aTZWh7fI9KEBu3CIZ9Ik+G5Y/5CMkga6PNwM5VGDLOjzPnIZ/qwsi77wlHQB8aaSpKrO36kwNMIIcJVTN7cSyE+Or9vyFUnnpV3nNqqGAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hl7XhSH9iz91PAHAZaxI8XUWKANy2bz24h1oI8ozYO8=;
 b=S7UFyImZPnUSbv4UxZ6mtfUnqUqVoc2qd0D1Kfa9o5cHoqoMNSJ9gAfBePyh0N63mAQ9WSFTSFztFc8uE5zqCt4rIamtFyxfLPukvle1yckzllHYb1Htt3kySIslIX2TysW5EHQJs1S9mj2N5IyUVn5ikJaxBQfSIAjK/7KXtMzmql/9nejGYb+59B9LV5Knl8Tp/RgOCOi3Cq73V+YvJh1dnLhOeIsaj2GSF4uVnXgfjLgYUtlkBQOYOVVrxNdFu3KCHq29PggAlSu9vZtolI/Ne/7jimPUwpxTF++EHwfnxH59l0jzSoOKP2zlFii9/OCB3vO8P/kevfUnOmwJug==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 19:33:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 19:33:58 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>
Cc:     Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd v3 2/9] iommu: Add iommu_group_has_isolated_msi()
Date:   Thu,  5 Jan 2023 15:33:50 -0400
Message-Id: <2-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0153.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 570b892d-6798-4ee5-7fc4-08daef53ca82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CYsNRxYso3BJkE4NmMpT7tgNYGV2foZenWofQXyhN4ghXnJe92kaNcyL0M5xVid39izBe/LrgnfllFCqpYKIMDgRtEQL4f0qYr2GR0jzQ4Lz/0/PpbFYeztcf6y6UFinR91+/luinGTpcobk9kCGaGTliyA4uBXTkWTXpJKToBoGrou0nykH1LIK0mSx9fBxV3tJ4x0VZj/0JeDu7Pe2Ggsf4fJkp40NGNVh749qAx2Bu3IcraAZb/MiltXOtDDcPC0tkK3yQ/bhhEpdrO8nzxaXs5KB2fOLgKbDXHVu6bz4fmym4tS+Mo/tdyx7zjz5IlOLyEDDht4q/9MJM48AfL7ibQ+iGP5acCYXkYJ0fJ/PnLCz+kyTshRpFZ/Ni48JDk816qeRRYhpehJZMOPEw+2hJuZR41CM9o9RoO8scSQizpPM6/UdpJetesbU/d+kLT1h5XngWN0Dy6TNydVyi+xX0JtyHjZCQQb8LOO4gwo24QVBPQTgRUZE3fcI4HxT6C+9y8rt1WBN7zLacVFOECp/DuWnPRXamDta1gbJjr8WTsb5YGylBPz2xBlEtDsFznk2DOmtFd3tx2MsLUmyRhq/o5VnaHg0R5HHO+nlap8ZiSapjqI3lbQ1agKjvWKFACg7jdwL1vmM95q99M2dOvHQE4ktFQojGM1Z+U4TbokGIj+w4dL0OYeohnFGKOQLYUlFzRUlLZat91HhO1DAqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(6486002)(6512007)(26005)(186003)(6506007)(7416002)(8936002)(83380400001)(478600001)(54906003)(4326008)(316002)(2616005)(66476007)(8676002)(36756003)(66556008)(6666004)(66946007)(41300700001)(38100700002)(5660300002)(2906002)(110136005)(921005)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PgeeihRmc+JVsqWcYHyKOXJf+EvzFk7NWyBzIZ2YNxXF7i3koFFnS9w/QrQW?=
 =?us-ascii?Q?svkOHtejFGsXyq1ENhsFbGJpIsRxu565VWrZCnMA2i+Totb5gpNiANrs038P?=
 =?us-ascii?Q?SZpUIB68XQIWN4l0A9CqBexks6iC9jDbZgrhtT4wkwAib7zoWPA/nNVlfeSf?=
 =?us-ascii?Q?DiVxuugI332M02vezxiuBNb2g/hdo/ja7M1Rx1tDOVPQiP+vbxvClMGLxm4P?=
 =?us-ascii?Q?BFKfYUto+d4Oz0VhBeoCqfc8Teh1aQ6Aglwxa4rvnyDo/UzL8hU9Tc2EStX1?=
 =?us-ascii?Q?0MCDOcXEoGtFBSDK934AcW+ie26grX0CgD0gI+o4hfSg2ZyWDOqSjlfrHZrg?=
 =?us-ascii?Q?KCghZzvBmnZ8FdGZUWj+qlUfdJtdja/XJDZI88B3JhkE5gJQms/OqGGOZroW?=
 =?us-ascii?Q?lxnE+q1p78DXvmnuq8eAHV7Bvlir2D+tfNgVUOwrWihobg2b1IITNIgwj4Ko?=
 =?us-ascii?Q?ry0h8iVj2WBh3Bad8XXAC2HjbbXQPp8i1iqGI9IeMw4M+Y1cF5d9+k0bIWew?=
 =?us-ascii?Q?SuILe0sG6JgL0P9LxF8GCoIKo4MInGaE52SoDCYOuYcFjbQ5TFglivwVKgox?=
 =?us-ascii?Q?x+RYir7wC7cSqOLozl0zRlHnwURH0WzL4ZjUc4VsqrjndY6S+M9MCzKUBQje?=
 =?us-ascii?Q?Zot0R7yY1vWYHglaNXtfBFYvUEE5O9VAEB5r9M3x/hjV0OHhcMBJXelvER1n?=
 =?us-ascii?Q?7fmbYpmldYM3KXDTTXVNjFAGRhnk37Fyj7w3+pefxQdj4lvPD0qRSkkcFgdW?=
 =?us-ascii?Q?IvPU9E7zOuymcz38t61MvIJSo8IIJevbVViYSK2e9hGFK7+Hzotyx1hwWpoo?=
 =?us-ascii?Q?eLFc/VSx0QTl3aDNwAzdYXbbTZxZR2jl8cjK9AX9teDx0VuzvC5/511XIOwC?=
 =?us-ascii?Q?6PO//ilnooqLVz+CMHMKqqIXXxoyUeTIV+Qm4JKHLl4hhuiB8hzlVNo4sNjC?=
 =?us-ascii?Q?ouD1ilAWdTw5octQKPmyFBZpYs6QfH/Cf5jj83BB1TF4l178U9zd7UqjE2LM?=
 =?us-ascii?Q?wENjwEnabT7WqYAswdwKb7aXi67bKfMMXoV2WqXluTNwaZ1y9IXikOUnT6+Z?=
 =?us-ascii?Q?J9UVvWexq+Eys/wgwxeBuqraxKHCl7E8Bn8bscH3+mxAbMFAEu+2MB2sbW11?=
 =?us-ascii?Q?KLNynhqfBCrK9LTUDjApsc+bLymljXsVC/IrtpXM0bLLY609y4Qp0cUZAqer?=
 =?us-ascii?Q?IWoePc5MuqfeQ2nEquBVBJF40Kd2vQYHsuWYw1a3gjSI9AU5XJsl28Z81rqP?=
 =?us-ascii?Q?WTGVUKh4jW0Enrt/rB69EmZvzFUCaiexts8kWiBF1m2IsQdGVs60ahKB1i2z?=
 =?us-ascii?Q?mXDy9QiyOQRUGucoiuJWB44Q2BXFfUHK+r5Sg69B0iRqxoz6pTZtEqCramJA?=
 =?us-ascii?Q?NHUB+AMW3H9a6SOAaJgAwsk8+SplPWWpwxRWerqqwnj1ordCWKYLJR2vbwvU?=
 =?us-ascii?Q?RL8emTgxONJCLLdjHNLw9mPz/oy+oFfoJjdlIfLbcfxzBnFL8jwCjGZ0D3Iz?=
 =?us-ascii?Q?Q6+GkUpRCNbTthW1uYaPIU6s84b8D+C3trUzpy5sWkJ36knZPwjUvxxiBGL6?=
 =?us-ascii?Q?RlrvuS7SmQsFkiWvALJCzzY4bRNuNFfqYsoGdlpt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 570b892d-6798-4ee5-7fc4-08daef53ca82
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:33:58.6782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nitzb4mXnqOtla20wp+bCah4BFaQqJFpxiMd7wEDjrErqthv6OrCon0QddncpqbW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6776
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compute the isolated_msi over all the devices in the IOMMU group because
iommufd and vfio both need to know that the entire group is isolated
before granting access to it.

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu.c | 26 ++++++++++++++++++++++++++
 include/linux/iommu.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index de91dd88705bd3..7f744904e02f4d 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -30,6 +30,7 @@
 #include <linux/cc_platform.h>
 #include <trace/events/iommu.h>
 #include <linux/sched/mm.h>
+#include <linux/msi.h>
 
 #include "dma-iommu.h"
 
@@ -1897,6 +1898,31 @@ bool device_iommu_capable(struct device *dev, enum iommu_cap cap)
 }
 EXPORT_SYMBOL_GPL(device_iommu_capable);
 
+/**
+ * iommu_group_has_isolated_msi() - Compute msi_device_has_isolated_msi()
+ *       for a group
+ * @group: Group to query
+ *
+ * IOMMU groups should not have differing values of
+ * msi_device_has_isolated_msi() for devices in a group. However nothing
+ * directly prevents this, so ensure mistakes don't result in isolation failures
+ * by checking that all the devices are the same.
+ */
+bool iommu_group_has_isolated_msi(struct iommu_group *group)
+{
+	struct group_device *group_dev;
+	bool ret = true;
+
+	mutex_lock(&group->mutex);
+	list_for_each_entry(group_dev, &group->devices, list)
+		ret &= msi_device_has_isolated_msi(group_dev->dev) ||
+		       device_iommu_capable(group_dev->dev,
+					    IOMMU_CAP_INTR_REMAP);
+	mutex_unlock(&group->mutex);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(iommu_group_has_isolated_msi);
+
 /**
  * iommu_set_fault_handler() - set a fault handler for an iommu domain
  * @domain: iommu domain
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 46e1347bfa2286..9b7a9fa5ad28d3 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -455,6 +455,7 @@ static inline const struct iommu_ops *dev_iommu_ops(struct device *dev)
 extern int bus_iommu_probe(struct bus_type *bus);
 extern bool iommu_present(struct bus_type *bus);
 extern bool device_iommu_capable(struct device *dev, enum iommu_cap cap);
+extern bool iommu_group_has_isolated_msi(struct iommu_group *group);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
 extern struct iommu_group *iommu_group_get_by_id(int id);
 extern void iommu_domain_free(struct iommu_domain *domain);
-- 
2.39.0

