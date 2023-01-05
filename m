Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECA9F65F498
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 20:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbjAETgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 14:36:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235928AbjAETfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 14:35:11 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181B0EE25;
        Thu,  5 Jan 2023 11:34:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hbls8eYJ9Sn+cYwfukoJ4czWQG0laskXfXp2Qs2q+2ECFBqxCQd9RaEZEhksteksslcd0xZaizFRCwg+QZxDeyTvGpEsoR0qAoYCuY4uH3+FwYvln8x5BehX9IDNHGNUmu/zQo1/tzn4JXSGZNSQ22Kp1+vnXoaJd6eizX9zLg7BliprX/9HrVn537qkYW3R3n3Khr62D1qkd3VbCeLpBNdciuK0BeBPnLk/5tjxADZ2M/NftyXPw5Brma3ETxYG+eVgASxP+qDWWISoDz8s3e773AN+Zu1TtQ2CamskiuPNwKOejpOUdBtRX2eHSHbNrZ0KkggsNVSRm3SBkNR/iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VVZI6MAJ6Q7no8ep2bQlh0Nl9Ee+c9c5pp/n8uIBW78=;
 b=bH7mFa5oQNKhFMV+OOTP2y828qGgq1yJ107tk5N0ZgJaDsHn79BS5V2MEqVMUv1KSFHLb79dQpL6ZOTiaEN4uEJ8G38Pz2QTfV8gdzhhdXfxQx/vtKeEeI3me/WjNsU/C/VAoQY3mc2LhzIZgCYun3deStrxHbRrVoeJbrbh6DhKQyZJs2KJ6kS2yNgRPdRU2CTFnhCLQ15/EDeN3ubjt6I6QDRV7EdHkkXWgAWyp54JFt8kHD8LHER64HJNnQmVvItVTrxOx/212SDFxxFAfRTM5Fa5iYNlb/SUajOJLbMPWR8YLeWuzDP0tpIY5Gx9tVL5Uu/pS55BhLbZ/A7xGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VVZI6MAJ6Q7no8ep2bQlh0Nl9Ee+c9c5pp/n8uIBW78=;
 b=U/Z8uJkCxKVyDSUpdBkJimtHIyoPsJrsxsWEWAgIVsFOC0BfiPGtZKT8CdnANORxthXT5gmPESAnR65TMf5O/z2OhWmce80enpiR5mIhD+knRXCWLWUxe1N6m6ZtXfuOyQyqWqH2l2k6CjAmEnEcYBGWGh2lFREsVBqV2vJ+UiOOLvxdcyev1CmginqVVnwz9OTpnwIQQ3MjnsOCmBMFY2vSZc7vgPEB4DnSdUdy0Mwz0Ym+BzQa8VrhxHzRYIPooxCqP82mOjcyIhlrKiBm/P/JCJU1vZr2vJMIrEM1C6+SWrMda9u6XpgqoItuBnsmaopAgYBbydtEnoYY0z9NBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6776.namprd12.prod.outlook.com (2603:10b6:806:25b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Thu, 5 Jan
 2023 19:34:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Thu, 5 Jan 2023
 19:33:59 +0000
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
Subject: [PATCH iommufd v3 4/9] iommufd: Convert to msi_device_has_isolated_msi()
Date:   Thu,  5 Jan 2023 15:33:52 -0400
Message-Id: <4-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v3-3313bb5dd3a3+10f11-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0152.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6776:EE_
X-MS-Office365-Filtering-Correlation-Id: 693e5836-432d-4c70-2d47-08daef53cab7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7CATumuBUFZ9fs2CBPkpX3dcNp9m+3fpijmmy1fEoycuPlTQ99piY1Z2bxPOLj7WKWLt8WUQ7iexuFmRiNvmEdnxCmIsOuaH0izbwgu/xee2HxtKC08Pdw95loBJP5Xj07ZWYUH4p0vf8ZD21SHTJ3e8NPf/jmA/wCSN3Zc/YtiTS5pUF0xkXdUD0ChVkJmxdeo/icMMpRlfR+KlIzot14mRgG6RxYfHSV3gETwZzmJWbePsaDujjUjVjy6nXMBkpStcZ06LdN6VD6cVfx47xxCOIRcoRUH72/qkDJFOtkT1itD5/byM5K+lke8QiKt5ljN7hMFFKF4eEXHH244RyH9AAaY5KrtVEhfFCnMAI+XtNErN0YiCu6GbBERZJAHkGf4KxVFU/KWP5Urha2oG7CBB/n5ZvFJeRQ4y5f9KT9c9uZ79Lb32GGG/PWSgtKLHkIfSOf6+dT1h8rAkv/T1aBiM136KYc4Rr1k8HHTX25Og5ySLzlJ3fxLJj05lK2ANYJrrzxJDHkSCWUxYHySb4t8sTm0sz38kNrx9lN+Yje/RWVVR/kDnMPaQ/2soKXz0fU6abMPJOfXasvfx8Wj19sqvgO4Yb3o+FZVGfZQ6vlyRt29DkEfNxriABuvh7aLLiDpwBEdUfq73SstPpl6ZDMO9khUp5js7x1SYfGr36j2cEMeJ48E9B3h0gPBJ965gKU+2cgRHq2P0Wl+nR1RhVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(366004)(39860400002)(451199015)(6486002)(6512007)(26005)(186003)(6506007)(7416002)(8936002)(83380400001)(478600001)(54906003)(4326008)(316002)(2616005)(66476007)(8676002)(36756003)(66556008)(6666004)(66946007)(41300700001)(38100700002)(5660300002)(2906002)(110136005)(921005)(86362001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j4mCNIeDdb+20lL6hC3U5XVAVPIppyAJrJlireKkjkpepo/TsC5y8NVyIv/2?=
 =?us-ascii?Q?YkfLSYlqeIBbrZ/f5He7WWMIhq/U4ROLx+AYBzdo9rA4YDVBbCWvt997Q7/t?=
 =?us-ascii?Q?DA/3B1oWz92jJJKTAQGs6MyjLAEqGsJ1eS/V7NhtRi6OOlkXfbG7a9efQ0C8?=
 =?us-ascii?Q?vcJWPllh9VETFlOvV3CpxTZArsw1hX2gNvanQNzsRoGaKaYf5Ymv1+6RI0UZ?=
 =?us-ascii?Q?AcZPp8uJSncVD2p7sJFDrzGE2/P1O6qi0KWtQwbvcHP1J5WnDv3ZGTBf036V?=
 =?us-ascii?Q?9sLIbXu4Vn7e1j6F1J6s3m/tHVihx8N/KaaKrWtpzeMp3ImOwEBemQe7+r7y?=
 =?us-ascii?Q?kVEJR7W0nfHSj9KG/GBTt9mJVUotjaKU6tpVVVFHOWCT4LvapUI1Z6mpEPUS?=
 =?us-ascii?Q?w2Pr60tJWkRnt7E5hk8B1iGCRnnULX5cfbGRxpmcVBcbYVoZRaCdDuCyR8Z2?=
 =?us-ascii?Q?2GX4Bj592cmR5wXj3awq5nqc2xa7hRtf8ICzFjAGgbO8BBxyQCW0OqgEHvIE?=
 =?us-ascii?Q?cDpwwdW0SQQq4x8XjuFELeYd9fKDbtdUIiBmWBWbVVwSTf0/xY1wAnf/oNcZ?=
 =?us-ascii?Q?aa59boIPfCpozhBNRq0DmptULxwg/GP3PfPg7kmkORzJXPV+34FmLGRsEeex?=
 =?us-ascii?Q?AOp4FTyvVJ38dgL2oc9UqposSvnyCT0Puk5i73RaebHVIGo/E9dd1L3jy9tU?=
 =?us-ascii?Q?iDjhmL+PNMGKiSlWLzwv6PQ7e2JvFCkc36/WW72bhoxIkpTtH0w+cfthO1tO?=
 =?us-ascii?Q?nGzoxxrS5880X39U+Y3MfaLPrhd9XOwy+mZfV54AwaT9v2SQ+vK/30rPtDav?=
 =?us-ascii?Q?ztOq4sFr/jcoy0zKKT5e3QrTfss04boUYJc6SKgDf7Uxdms7dymOlcl121hR?=
 =?us-ascii?Q?jB0Ea9Lt0OXDQZLq+5KnwmO44PZBTyiRc7eqaTJhlnqnqvZ+rUs3lHlZYwvy?=
 =?us-ascii?Q?T4Us+8Lbkn/Ibh9UjFlvUh0idelifhTtPIUsbgYaQ9KWMi6vdVxAN/7Cp5hF?=
 =?us-ascii?Q?MXwB5tRATFbZOjsfVSAxlM0p9dGNAtl52PtncdY44j8eiMMxoW959rTjih6Y?=
 =?us-ascii?Q?tY8n5TUfEzF8x0KWDoduRYB/S+twSNQwAnkWAX1ikjadcnVvlICQgnDyhjrU?=
 =?us-ascii?Q?WvXNVT69Y33LR1QIe4BweFZ+NOOYZXcOIwP0vyBtRYG431lL/g2c2KwlVjUv?=
 =?us-ascii?Q?EH4YorgKtJ+L4exhbF7r0rHUhyi93t1ottjtAzLsYKXttVo49PTdqEVpVh8A?=
 =?us-ascii?Q?08E7mZYM1VJt365Y12I9jxtVIyMJeFYTYirDZQ7iNt8i1Iy8t7nuvaPdKswT?=
 =?us-ascii?Q?eEZbmfS1G2rk85DKiH660YIKi59p/EPnmt43Ot/nw4K0UfkFX798AIRZIzzi?=
 =?us-ascii?Q?bIIPPZb5ntVVWZWIctG1/Z9Klndj2EChX4WWoHu+uc/6g2WLKHFeahnAZLC2?=
 =?us-ascii?Q?3UoDzgqrXSN7F/TUveSw6dD2f+r24b7GXigHy5ANxjUhTvWBSWNVvySvucKO?=
 =?us-ascii?Q?0ygVOYfDiNwNeO98qwqI76hHWTghTB/LykBaM/jjQDXFEnICZ4m24x6qV8Ol?=
 =?us-ascii?Q?B9KC6d1roSZnEaddA+slc+QScj6vQSrOhPChuy09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 693e5836-432d-4c70-2d47-08daef53cab7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2023 19:33:59.0079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfCW5t+ocA42iTntVtEogR7oePxLr1vD085wCtEnzfZtyJfyw3xWIfpOQ4kH+5f1
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

Trivially use the new API.

Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/device.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index d81f93a321afcb..9f3b9674d72e81 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -4,7 +4,6 @@
 #include <linux/iommufd.h>
 #include <linux/slab.h>
 #include <linux/iommu.h>
-#include <linux/irqdomain.h>
 
 #include "io_pagetable.h"
 #include "iommufd_private.h"
@@ -169,8 +168,7 @@ static int iommufd_device_setup_msi(struct iommufd_device *idev,
 	 * operation from the device (eg a simple DMA) cannot trigger an
 	 * interrupt outside this iommufd context.
 	 */
-	if (!device_iommu_capable(idev->dev, IOMMU_CAP_INTR_REMAP) &&
-	    !irq_domain_check_msi_remap()) {
+	if (!iommu_group_has_isolated_msi(idev->group)) {
 		if (!allow_unsafe_interrupts)
 			return -EPERM;
 
-- 
2.39.0

