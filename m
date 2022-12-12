Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2BF64A763
	for <lists+kvm@lfdr.de>; Mon, 12 Dec 2022 19:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbiLLSqs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Dec 2022 13:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbiLLSqV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Dec 2022 13:46:21 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B175D1707F;
        Mon, 12 Dec 2022 10:46:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a5h9zj5gCNshBpRSF0T9pNHuTSE5uDmdx8u0CdYcAZOaZ/O7EeL81MPDf8SgKD8Q2OTgUExItZKCGFfcLoLmCuFQ79AM6ZFVB0gr+pHFj5quYdiDTIpGo5HD5DGEXtHi6RdIYO8heKnqqDwTjGVEKSP5ZbzJKwpvSkPAH+pkCrhTDWFjFfFZFTMg+sIHPYMGROUu2xtwxsw5BHE16+gHEJzQgWR1jfXJak9TTrk+kdCqg42bKwhZBq0VCDwVe3MslpKi+r0NVs+9njvqLijG3lChBoe9j4LhZXwUyYzpbP1R37M/oGSAStqIrrhePmLcwSjLrbEgqqGoZdIJthUu+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7iwShFd3sE756yEnHWw8J+QoythC6m6hrL3/uHyMdw=;
 b=lqVt036kOZzmVnhXanvPsPffiACuRRdIyKdGz0FIQqhgTZMQuSZmCSc/YvL2UNLqM4+eICbr3cQt1v9h5ezEMb813cLKykMMIHnQNOwgpw+da8WbPWYO7HjGdexmVAnWVnQXgh1KsCT7kO4dqN43zD6zV/+yTEqEFxuhCbc1VgomRPhjJYELP579sjtxDj5tCXUWOFs6mVSzuNytRAfL+JU4LT4hgOroCYFIJJi/QleRPe+WJZZacQ25gf1a4Do6EAHIvc3e4A5O55VdXBStBQWNYy9qAiTnEnKPwfhnQyprtLnYVPovDA28Ytj3FooaZbo+uPRoK42SGpuHDvbKkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7iwShFd3sE756yEnHWw8J+QoythC6m6hrL3/uHyMdw=;
 b=bT33VUeNXjLZC8gH7l3C+TCi31tTk3w5EkD7nVf4894FURhF7LVfx0SJrn0EJhaXTkbMdn8F26CO80toRT4eENKjjUIJbiDh9U21n7dguayyQ3pUSDqeX5CTshvMvDL0o0/3iVll0cQvuOrYJJhkOtmhVLCTkSDg56Y/1rkp66QqhAPMaQsQQKLoqE124nv8Gza6/qHWwDTR1RMgwrVjyDtKJecJvJ8uQ6BNKIk5ToBpfSCjZ1vR44bdDRINg/Ps0GPiCQBE465qt4oAxe3w+uHAMFqJ+rFRJlFbVMPJWHI0LEanrUVnNcKsG6fH0qpUD62BzbmJhmHvyy0QhTnwVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5340.namprd12.prod.outlook.com (2603:10b6:408:105::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Mon, 12 Dec
 2022 18:46:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5880.019; Mon, 12 Dec 2022
 18:46:05 +0000
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
Subject: [PATCH iommufd v2 4/9] iommufd: Convert to msi_device_has_isolated_msi()
Date:   Mon, 12 Dec 2022 14:45:58 -0400
Message-Id: <4-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
In-Reply-To: <0-v2-10ad79761833+40588-secure_msi_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0087.namprd03.prod.outlook.com
 (2603:10b6:208:329::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5340:EE_
X-MS-Office365-Filtering-Correlation-Id: 901fcca7-5765-4348-6be2-08dadc711fb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aGuslM+y3oUSkXV7gAuKCgDdWeBV2jH6FFv7mK85q48TiySQXTgcnEdHoGQQGkKzhdyDHWd7WlSGGt9AVsgmXUlZpIboA3D/dmKr25WrP+z/nmoTBTpjVPj3Zf96pvHehKL4Lcaf4NtBufNCKGc2BtLz25ppB9XEmUml3tiRekD1XppxdmthkMERS4alzdUSpsCYTOi7dZXdg2jj4Mz+vwdUN/9h7vvK/RViLI3v6iaiCeGrsPrALdG4JFiUH03x/e2XcxS42Vyp1GldcHrPvPiLYnRw/0dqM3l77apTpAPQjS233YXTRi0OZpo6TkiGntw58U2GoMC2GWL2hxQrh+//x8pqHlNHTGRBHT1L3H6VjTL/aqO6EeMMbReUjpybmamAWRxCBl4Z3746qQ5xsxoizRw3+NGZy7oxFyls7XX5evuIhT4MnggB++ryP/1PUL5pV/12NCBN7JiR00iz6+IwQrQAwNn6j1uXUjdSjoJc2WjXCTWENweDu1kV4t7Z1RAso3IL9YmcWU5vOArMiD7wDD2qvYUAsT1Hgd7Fblk1+4wdTsAQspRhVXNCK/jLBSotj5sM/QnlQeFb3gLbxK2TPha33GQE48SWno+NFxaUeuopJXZejWJBqyTzttW4m8r5n6vWdEGpVI8Kvh1Mvbgz+ml4BD/6DJFbFspZZ6X84bIF03c5EMiwsdHa6DyHhQA4/1RruLkARENRidP6OQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(451199015)(2906002)(7416002)(36756003)(66946007)(38100700002)(66476007)(4326008)(8676002)(316002)(86362001)(54906003)(66556008)(4744005)(8936002)(41300700001)(5660300002)(478600001)(6506007)(921005)(6666004)(2616005)(186003)(6512007)(26005)(6486002)(110136005)(83380400001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YtkSuQr1StU4G8NlN30p1kOnEJIm+s0nkqAgmIKKCT4NCg1JhCWvBmPa71W2?=
 =?us-ascii?Q?fM1lCjgP9F/y7xXqHwmkbeHL9+6oS65Rg8qlvFJdfuu5mT9vY8uWGeB9ve3n?=
 =?us-ascii?Q?qQuC4DzyrbZz5bvV/koLzcMSjxJOUGSpHJuS4zelA7nqqVSVN3e9flovXcJ/?=
 =?us-ascii?Q?6AJLiS7ewAGVTpHbzXTTJwnf98kVM5GxdPh1KZAdqAM7wd/fAxnj7H1KvbCo?=
 =?us-ascii?Q?7KobJKqtev2KITMAXki9B4huC84hthERpXhfo2zkXP6IdMqh3VCKJcUvATyf?=
 =?us-ascii?Q?pojVK368exChV/j1iJkAusN94JUgvL7IW/Efv6GF4Rn3ombmG5FO4qAaG5RG?=
 =?us-ascii?Q?1sNdYMcZq3mg2oXqwQ7E0msEDJNhtd4QgEG5wLD0YlYBC/nM8V6b/bsV3har?=
 =?us-ascii?Q?ZFZy9MmB/RtDDW3kWklurHm+N6mBu2s2GkKbfOr/igHmxrOEWFTYEpdPKdNL?=
 =?us-ascii?Q?soZIXOXGQxTRTlsjsOhS0xGJxBWQy83Nju8pxA6fvAJPhXENlnTx83wZMNxL?=
 =?us-ascii?Q?N6Owyz/lJ9S3kAikJDXDxWpKBkaQvVkojjs8wTANMH/jWiZTj5aPgBO8EQwj?=
 =?us-ascii?Q?aituF+TLm3v2w3ursYjgfAbJqxhykFs2EpV2XMZU8GxiLca+RpgSJYAiWiGd?=
 =?us-ascii?Q?M5+cf0ae2gEe2Xfj6T3lUlZ7EbmNI0Z0lEARlZ9n7fgDN0VvF5OWYgumxMhl?=
 =?us-ascii?Q?pGMWKEffKc41yWPiy1o8uDr2dkYZ9+nficbt+Tk3W7WCQcNd7dF97I9JhBiW?=
 =?us-ascii?Q?wKIgJtPFkzKbF1u8TDUHf/hm5YbRYPe3Wa6mOg3paoyfTYbOboWxgINnRYz/?=
 =?us-ascii?Q?76/JmVloiefygrfI/cpI66D2XrV4a8XCb/zJOlxG1QzKIMIGs548s1vWv5yL?=
 =?us-ascii?Q?A5vNDKDDeI/M06ggNn2irqJfRdY5IMJjspd46G4hDyqTibkBY9kHDYUM1poZ?=
 =?us-ascii?Q?kOFwYkTFfvAPKnG8SpNqJXoalZoKyCTNnagj249zW99Tb5egqi4JcOt3LXzl?=
 =?us-ascii?Q?9APbrNMLs8dqVN6GIruOTZ8UUyv+/jXwS0178rLhlhRAugl47x87NjYnLP3r?=
 =?us-ascii?Q?jTvK3zbQ97gZOAlBtNG/rHSlJ2dB6ve9qTLOfUqNQP7RmC55J4ma0g7Havh8?=
 =?us-ascii?Q?UEARnj4LGs7bg2bTfhxPIxOdb8uugDbG7bJ1LaMP2i/SIcdgxYNaiV2dSQaX?=
 =?us-ascii?Q?UXbg99wDlviOdxTyxx7xgw8kCF+K/00hHaxaVXGz733J7c6Sx8ASmAqz4oCp?=
 =?us-ascii?Q?xXS7GySk7NxFYjsP3AdEivOiRPKi1KRxUOrBjV/H1/LnTKCk3X1ZBY5fv+vJ?=
 =?us-ascii?Q?9hr2yy2i9Do573l07jgLk3gO4+eFidmHrWGBrHTLrpYvQwHCIPUSslcOvguY?=
 =?us-ascii?Q?Lx0Ha1n+LkN/qzdkmioPmoV609AjZbCug8iyg77VDC974IKnss8I9ViwWsnu?=
 =?us-ascii?Q?avRiay4X6gUw5+fnooNUXUP4l80d2WwqenFku/rFOGseKmVZQrB3rvABWR65?=
 =?us-ascii?Q?d8MOXH3aF6Dh/apW2Ma81JNAumKxYlz7yOJ/yEjQABO7XUqZjVVMha0vRtN7?=
 =?us-ascii?Q?gXIeInaEFpuMpY1aepI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 901fcca7-5765-4348-6be2-08dadc711fb9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Dec 2022 18:46:04.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NbHXbqpIVrhUkJfy+xPRTAzuwTDq+c8JtcjyPt3r2zGWKMUjet+QbfXXdiVDUXpH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5340
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

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommufd/device.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
index 29ff97f756bc42..3e61cc5e61af8f 100644
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
2.38.1

