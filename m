Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B602C64773C
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 21:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiLHU0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 15:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiLHU0n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 15:26:43 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD3F84273;
        Thu,  8 Dec 2022 12:26:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5RTCC54wSxI2ob6clQeHTFiwUuR8+/t2TOulbPGG0BF02+S4Dk6H3cvoWsXihWJEWFFbNrjqGciSp0mlzqCIKvt+zsa8nxxkuQVtzZGxTPd2hLKFZbvR/DcTrXizwoyX9+JhUDWfBp1fZSMJNsE+HESKReAw+49RwHOS/e+2Po35W5pMwfil84xaUh1zOdtMzkbNd/3doqSAHN8pTahjaQvI9/gozL1uvYg0e3pOYOxapvucOxofANPZ6qhUZk/Nr0z5UbIoxrO4DdQ62Rtt2fwqFTfeLrufNEmEnjjaiWzGUr3GWhdIpxfz+ivL7D6lQmP2TDREOmZICc5ThPWeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lVEVSu2H2ch5IjJ5JCuae7o65vB6IPfDsbdAtTujXiw=;
 b=h21HSidkrI4h/rx6TbX4zjgvnulOyaaw7QsefPuISOZ3gOHFyfJ3jVE8V6+MmUFL1jHj0PmsX44C10fCNL/eonjqp5rJHIzsy74sL6Zqt8fPyjw2X+e3/HCWIWOzTEkav36RaobpWe2M4k7rKHSu8FG6ZKuD07LOsF2q25de8EjBPf6znBkn5QQmRyf6qBbyNrz3Ir85Xd2Lgi3wD5PQX5tOeBTwAoQQ0gLiVPn8hlhr79THmL/5obEknYx7bpj3bZJtYqH0954VOU0bXTNpsDq9TnpDwiHjla8BroQNdDy4qK3d21xcAAAQL9DGdJqdaGg2Saf8De8er159anbMvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lVEVSu2H2ch5IjJ5JCuae7o65vB6IPfDsbdAtTujXiw=;
 b=l+1r8vgvWd1KwWTyggdRkR+XhvCHQ7u/cBEgmPIZQWVx7kIcYktfIXVg3kULeIof5NdD9TVu4HEPF6GEXkGR4yYJuqJkSwbQxhAOBajD97uBu7udJWdWaHBorzIUld9r0SyNinhbY0TodLR16OJjWdvX4378PRqxp8gyGi7xg5199rb71XE/0PxlOgSmhxw6fZxpJBwypgDQfs9Q8rWSnWFSHEgF5oi8/bTg/X8guAt6FxdQvq44NdBPDiu8FPuwh5/FRN45bUmYsTbU0+UAN30BC/AzWpff78S1OXaADlkgjLuROYfHhliY5hU9lMUUvcgprJAP++qHOh/Ki+532Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6966.namprd12.prod.outlook.com (2603:10b6:a03:449::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 20:26:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 20:26:40 +0000
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
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
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
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH iommufd 4/9] iommufd: Convert to msi_device_has_secure_msi()
Date:   Thu,  8 Dec 2022 16:26:31 -0400
Message-Id: <4-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0046.prod.exchangelabs.com
 (2603:10b6:208:25::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6966:EE_
X-MS-Office365-Filtering-Correlation-Id: eda8c252-1b9f-4871-adc4-08dad95a8254
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A0fic8T8GTI5ylUa2ML+0j12yulrOHkF/MCcvc8aB6E6WQdgYopyPuXULsWMwa1bwpHAKWL7Mex+pk9jmdxCGyUCha2cTwoai7VGIL7+zELJSFbw4UUb+WC88EZnT/PxgJ+Pg0e+IQ/21PujilJKgGe1kGSHwjZzIsBi3xygqpmaEbeN7Tx6zXJYB9x7KwnF2vqJmyzj0kARequPJ29PuDQrdzv7Cd+pFR38yUMjmM5VPlZ9824DGYO6RpDhFrGAmsvOHYBOXbB5ERWr6k1AD0qOkk+voTO1Pdku9v1sXUyUMxVcMD9wZEmlmo3GIdjLZ872OjNicPlIj1eE9KQv7btgeLnUF/+mVQFoLxq9vWUYq5dJDnr7WlSTP4v6sTHaoWLyPIAy2yn5vjjH7BED5t3Z06aMJhfT0Vt5qFqp0x2gFKdHzZdJNiNP1GGRE9qxKBBQ1glwenFzLK8YOX4pF3US6JMx3Y7AjBtrR8xqPmQzk2Bt2dekh7W86vgYMNUuSoxBqghYWoacytDkAe6+wzcLpsp6k3krue84pPXhZ/vqTiLQqMmKXtf8KF1CCCcIRd8PLtzxMAlbQVzMAWigA3Tj5At3Hd3rTVqT1RqrlbcrZcKLGgdn0oDteW1f47uhx929tps/I4epyfqnhUBtCdJ7RiNO0X7D2Fv2himoFFn4q7c/j3nNJkr7R7Iq8uQkKigO0fqCAh5wPwgrPs3P8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(366004)(136003)(451199015)(38100700002)(36756003)(86362001)(5660300002)(921005)(41300700001)(4326008)(2906002)(8936002)(66556008)(7416002)(83380400001)(4744005)(66946007)(316002)(66476007)(54906003)(6486002)(110136005)(2616005)(478600001)(8676002)(186003)(6506007)(6666004)(26005)(6512007)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ci+xMP32N5DaeFErUF5Wv44llDZ9ZAYJplxdbpRBMqir5rih/qjYfSSzaZqQ?=
 =?us-ascii?Q?2q7miR5Sl4nN99lw4Qja+YAGJA5J/1jqfj2fejNbiSJlAyMYMxGDmPxjpZkr?=
 =?us-ascii?Q?j6djcyjh8yR1sevuGCBHcKzEh4Xw7R1aKT71CQfX7DB3Tv2U5Yd+aQg7hbFw?=
 =?us-ascii?Q?ptiS4v2KFAvZB5YNuUptAFXae+ABNS3678t4TLd8X8YW2J6/BfIElvhewNXi?=
 =?us-ascii?Q?ey6ljQvetMzNxRK6XkmArR0tFxWhdiFp2So3yhoX4cjfvYS7CmRI8UfZ5A5Q?=
 =?us-ascii?Q?EJdWsWfVBXLZjLL8FZyU19vs9ZtP4laO3cBsUJdDteqdz6Ce/8CHQ9me2mow?=
 =?us-ascii?Q?iUJoReTQ/G7+JAaVEdKdB1uCbn6Qn0o5srpf3htMWBMKlHoB1/vsMi21jTjG?=
 =?us-ascii?Q?cRLnpJUQcYbwi4UZ9SvhZixweOvBu7tI2qwk5rcMAoBsFql/3wQ9U3U+Zpto?=
 =?us-ascii?Q?JsySls/cgwfXriujZxDqyOjyroyAAC2VSGXbYmPvgx9rhGIGDjUHNPaLnfbs?=
 =?us-ascii?Q?BagCRYDKHptGhYE13pKg+N2LbNPWqR9sXP1nW6f4hYJOQybBynWN1ShMVDmT?=
 =?us-ascii?Q?BO9foAA52p7+1VI+YpbvUxPzK2IIhI1gfjdWU29eG6+nf7nUtGvs2ZLaWrIM?=
 =?us-ascii?Q?U5wmiJnolQ1QEQinCaNr4gqBimWYgOz5ouYbl0esdKJh91yP1OeYPP/OehAB?=
 =?us-ascii?Q?OZDmNw6Oei0hbjGMCFEADVkU+31RdtrHzm/fT1kRQt6rbaEeEnUPYqqRLK0m?=
 =?us-ascii?Q?P884ty7VHvRWS3yUgjowXdY84mve1c06+k5BN1t8USDhZBEwarfpKAB/UIxh?=
 =?us-ascii?Q?SFpTKM3JD02Z0HyLKQiwY9iRtuyL8xgr8Jprn0Xn+8581CNBl3I28nRG2L82?=
 =?us-ascii?Q?95y/5xnTlJ6O8LKapIO3m7BXd9T1utT8e8e33d0T2j9oQVrdXB1bLC3euetz?=
 =?us-ascii?Q?kdwrM0Ie+Zs0kvc4b5F3KJ9cf3sZVeWG/h6aISAKluIxUFMVla4UAwJtc7AS?=
 =?us-ascii?Q?n4TR8dbrcvdlwBNn28uYRK4bD2nuJg4YIVnAcTl+evcforw+NmbHqKBJzr0Y?=
 =?us-ascii?Q?uTJJ0c/DazpXjwZVYHUQAs0H3hdgGWYKHQAg4LH93IuAnSf4/GygXGSTj4D6?=
 =?us-ascii?Q?v6ySQrnbbm++hM3x8vRKPX43niSz89/MaZrVxT/Vcyz6hCGo8w9cEI83ItS2?=
 =?us-ascii?Q?v6PzaBPGV4+t+OureUF0LJO9T3r7/cst31so1QT/fh08VkBGTpHVqYwYbHFq?=
 =?us-ascii?Q?eRn0T0FCTFF4J2sYBFSuKDjd8LHZ12dvm634tmotyvtuOwGtOPXuR7K6pLyQ?=
 =?us-ascii?Q?e/QPm1GwZDsLD6KjCw+2OcXJLIJkD0KFqlujtkcdQIcQu/kl3xF4cuRwpOIw?=
 =?us-ascii?Q?qXpb386udyU3FIG9CMQFP6NLfJYbwL5FWS8io5YJzzvX4aqspFAlv0eM97ZB?=
 =?us-ascii?Q?sKxWG8e/HbVTYqimmUWWyE99/0AxhoUBbos5Jhd/rtqRzjh9aQDelLzy4Xch?=
 =?us-ascii?Q?ZEGnHF2Y9ojyBhBxpR1ysUqSLr5u4ui54Lpf2jzcunFv1iLtVFMxWnfXy/vA?=
 =?us-ascii?Q?KSK5nzTM5bavksZiNAbaujhBdMtNVmHzu+wOuu+4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eda8c252-1b9f-4871-adc4-08dad95a8254
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 20:26:38.5405
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0IZr/U1IYK1BvdSCm3YH7uBdK/E87S7oQtP3sH9KfuNjhK2NIZ1YeVDy6tLECSx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6966
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

iommufd already has a struct device, so trivial conversion.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 29ff97f756bc42..13ad737d50b18c 100644
--- a/drivers/iommu/iommufd/device.c
+++ b/drivers/iommu/iommufd/device.c
@@ -4,7 +4,7 @@
 #include <linux/iommufd.h>
 #include <linux/slab.h>
 #include <linux/iommu.h>
-#include <linux/irqdomain.h>
+#include <linux/msi.h>
 
 #include "io_pagetable.h"
 #include "iommufd_private.h"
@@ -170,7 +170,7 @@ static int iommufd_device_setup_msi(struct iommufd_device *idev,
 	 * interrupt outside this iommufd context.
 	 */
 	if (!device_iommu_capable(idev->dev, IOMMU_CAP_INTR_REMAP) &&
-	    !irq_domain_check_msi_remap()) {
+	    !msi_device_has_secure_msi(idev->dev)) {
 		if (!allow_unsafe_interrupts)
 			return -EPERM;
 
-- 
2.38.1

