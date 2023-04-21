Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54FDC6EAABC
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 14:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbjDUMqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 08:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232142AbjDUMqR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 08:46:17 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2073.outbound.protection.outlook.com [40.107.93.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213871BFE
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 05:45:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3jcNVlqwsHBgU0wa1jBtzOoo9P8UFOb9qN/AACDz158kM6yumWitGc525HfgJZqDEboNuzVrd7B6qThNSr48Q6VdX8iHqlTgiO9T0Xz8LT4ildZ3uKaqleYYnSHKihhLIt0sBBIfB3t6l9EBlhSlZmDK+9g5LKOmKP/NCeMUiZ22jKqMy53iMdn7ZUlDqiuAoHlE8wNoXl6aGuay7X0Kzmg83gndNlNt3UAlwhVYofYv4pPTB8zP08oydqmtRG59bJHp5vyJMVs5VWZzlF5UXkoyRNLd0SwItp9V/ATNRsiPnzTpzSET13obKdC77SMQVwpPRGV8qFkF9EmsePV3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oOok4VxGRkz5bol4C0fW6Hq/oKlUA9GLEHcEMUCGKY0=;
 b=RrvRix+lr8FJfpY/8RSm0iNuSKvJEEbjk4d69ZP6OfsKv9bWVtxIFG7E+TbArvlRgCUCMJDq0WYaIE1PCQmI9tF4Msqd+loAI34vh3NHWcWbfpglKD1NaXoorHPf2gIP+jPxSJQkkCA/9rhmbws0kiIJMtxUCqm1+U2HodQ7ilhg5ZO93dN864849dTdSTziXa+O0bqOJBMRJNGtsDXwe7i7gWMKRg1uSoTO8KDCiR24XOsEkoDswHz03JJOwYJwWlz9sA+49ciQ/3jAiIEjtt6cbK1EhqlA+/OllmscxXK/igB0yfSKspZag+0UABnAFbT/znubYHERZr07rBkevg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oOok4VxGRkz5bol4C0fW6Hq/oKlUA9GLEHcEMUCGKY0=;
 b=sQX2M/Rbu4Npu0kbHPf8RhUAwokbfwBtkIzw9X48y1IIKcVBd348ixVVkqB7PUO7QGA1m7PuxN5p2m+RaZU56QVXGe4tZkllSlIBzJZsRNBmHdfKs/PqvQhb7ijyi9zE1rROoggmmWA23cq8N9s1GtPP1fE6MK+8sZ6rXPVO1cBpJKP2Q1U4eEw/dfFQJyiJWLgq6pVYrLdfUiNpy5d8VQH3j0Uk5k0+JCyWq5Bn4WQjP9JT/xx92jdji9jK5+bV+tfR/lwMTjy/GQDQrSViPmnM/B8G7ZI0iRZgeZtymAh1fLfR0uQK8AvEfjL7ojpjGPEvRnMRCZcSdhNnm3QW2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5504.namprd12.prod.outlook.com (2603:10b6:a03:3ad::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 12:45:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Fri, 21 Apr 2023
 12:45:41 +0000
Date:   Fri, 21 Apr 2023 09:45:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <ZEKFdJ6yXoyFiHY+@nvidia.com>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <ZEJ73s/2M4Rd5r/X@nvidia.com>
 <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0aa4a107-57d0-6e5b-46e5-86dbe5b3087f@arm.com>
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5504:EE_
X-MS-Office365-Filtering-Correlation-Id: ff855301-8bde-4e70-e227-08db426650df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ztZWRGAxBzOfoKBujX/r8KXbhLuzvap7zo99GEGhLOMWggP0p0YdKX2f3jVF0tu0fcdQIX9ItZ1H43gMgeEViMLiDuX9I3eh06s0O/rztKDFnzO8a8wxdh3VBCgwXwisWHkv2pJV7Jf3bgUBm5b3jWvvWi+uhn9/iW26cpOHWTqNbIRcBOgmCHNtUw0iSIq9JICCCFcjNBOQ50kqMRM7JHkAFX50TJMhQ9k31y3FdtvQZFv8TF1A6MBkYLrluP3OiLsuBoa2NHaFj7zkfJKT5I4lI7VVJDfQ29xGOBjqEk6afExrAR3inGAyl/G9nPI/t6xu4Yi+Pm3b/YMELWMpkzhy1iX78Z1DAk5wO05lmsn7O8QIh2VN7ltn/YEiWHj3k5VGHVWhHoRwha6wfBkB7uWOnaYYlPktHEojwuq2uw1Iq6MO9Nh/whbrb3ZRg0vuPN5rmZzGYNkC0EWnkAIKaiPwz1CR3je3JWXQLv4/Jghc8cIx4QACM4HUX0kYLGte0UiEWVEW3I8cjXlDqPznuBZVogIlYuT91SsE6LLZ3+MHclbiiJhRLppjNXY3fiZ7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199021)(54906003)(83380400001)(478600001)(2616005)(6506007)(6486002)(6512007)(26005)(66476007)(6916009)(66556008)(41300700001)(66946007)(4326008)(316002)(186003)(5660300002)(38100700002)(8676002)(2906002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OnWAG3GsKbaGGSlmKA+e9NR/mYGl4XdyaHATy/LaFewGQ+gPHbxlggvqlKnY?=
 =?us-ascii?Q?Eugazop8pCS0W6x4xY0VPxLTSDPJghGLS9DojUcDxDGOWObqwXohDaRqVCJJ?=
 =?us-ascii?Q?qxrTxfnI/+i6iZ0c/ropiq1ayIn7L86DEqgfKNTt451dOY5ZgguLl7O+Pm15?=
 =?us-ascii?Q?zVEPmjIMZyVjc83Vc2YbvcMdhh69RX0n6/dfEInBWCODboFnCaSqNmcb4mKX?=
 =?us-ascii?Q?aj3PlGsRtkqzxlvmq037g+Nkz5slyIO3wwIOqyFTNguK4RUDKpp15SO1IzFh?=
 =?us-ascii?Q?Qzs0CO5ZzAcOIeX+xYe/TMXVpUZ9XnI3I9+0higeNLNwQKizqKnB67vu0CNV?=
 =?us-ascii?Q?ovGArjfYhFYQAj0rhtCHFAwctatZhRs4E28tsF853JXJdFsS9oMK1ufIzqZh?=
 =?us-ascii?Q?ByMtVlVd4nl5hZGtOpZOPD0HrX2WSPNaQcQf4wWyUrYkvTfNcS045N1ArUnA?=
 =?us-ascii?Q?CAdj8jtLNYan9chlyURYyrjvK9K4+HmHbicDJA6idxX8apc+IuQsGEbx6ep7?=
 =?us-ascii?Q?XFpUKnfZSiDrqoG9+ZwG4Hh1OTeaNnsTQliML5dxoDShaACq/G4hfXTxjxzZ?=
 =?us-ascii?Q?U7rFdqtcydratPku4tcEBxB1c3+rzhvYoK7mHmm1nm4s0DzuyTQ+/w7ObIjQ?=
 =?us-ascii?Q?/ze7EP+QW5QkaousxL5zJDngqqUQ/FQLFLPsK5vMEA7xSnpSCLmsctFyfuXO?=
 =?us-ascii?Q?tMXYb6eF09YnKxctlc4Xqx+ryocrWZp4hGeM2W19FCg9J4HSkjxqnWuZHeZK?=
 =?us-ascii?Q?DylkY45H/KNYL5P4lCtbzpGTBUbLXwpljIku0uOAach1tgn3w8NXQnEqx0xs?=
 =?us-ascii?Q?YMG/JwgZ4zxDIk5cidyEgNJhq+29YZRbwFSaRD/wdUuM5e8NpFa2aa6omGut?=
 =?us-ascii?Q?DjSx82ANg6Bi2caeXaf33gvkJLde8qRf22//EwKBL+OSg23aYrqahW8w0nnk?=
 =?us-ascii?Q?XW3RRp3Vp+zXzZ8cyJI0bCcG/dGmoq21GMs/yE5m2u+TdTxdIzOSpBBYjrCk?=
 =?us-ascii?Q?mnI8EpHznP/ISfLO0Wq4uGx+X3AMUE+QPwDu0pLdk6uTWJypI6nejJmnvhwn?=
 =?us-ascii?Q?Y4P1sd1kZMNIgW1gx44L/udPQ8iuOPhQncb3Bnnl2kqc2NfrZay2ibUWVzrO?=
 =?us-ascii?Q?uspziWWCBm6pFXYOU3qZm1YCHgNVdeW5jQGLvL0zQr5YK7tDLTEW56XOlhvH?=
 =?us-ascii?Q?MjPiskm5V9xU4uQtGmMiRTSdV5BoBcKIWY8Q4aqwxggccWdnRrSzo9GGeT0B?=
 =?us-ascii?Q?dLz5kdSup6U6ZFivd1sX/kw29kvBYSFnWsLPl4mQJutpZfb5HRvUs0DDe3g8?=
 =?us-ascii?Q?rNm9BwtSvKbPLFjpL1mmrG/KLblpztO1jBl3obGWbkPD5zD3tNyvwKs9r2Lw?=
 =?us-ascii?Q?42PRWQYM61NRI6ILCZooyJ9KeqFwjj6GFJZpD17b4X8KRupgC0ZSYbnYVza5?=
 =?us-ascii?Q?4P/0KOrKmyCYrzeJZ8RN6gN4d0wjN5pKBNnxqv7BQR4hFR+PFLZrn4YC6MEm?=
 =?us-ascii?Q?3X/HJqcfDQ63kzL61thqr0lwpIRVIQ3eVq43f/HHde/GsoTWXW51ritO1tXS?=
 =?us-ascii?Q?RoJ3wO3Nq1iJ4s5VgsGZauqNpZ7Lg1Yi1yXQ0M2+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff855301-8bde-4e70-e227-08db426650df
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 12:45:41.6011
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VJbtAUrRqqa5+NCV6L0DwjMZ3Y9z/iOPxsGsHvk78dBzmJ4E1YPwi3fmObHiGASz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5504
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 21, 2023 at 01:29:46PM +0100, Robin Murphy wrote:

> Can you clarify why something other than IOMMU_RESV_SW_MSI would be
> needed?

We need iommufd to setup a 1:1 map for the reserved space.

So, of the reserved spaces we have these:

	/* Memory regions which must be mapped 1:1 at all times */
	IOMMU_RESV_DIRECT,

           Block iommufd

	/*
	 * Memory regions which are advertised to be 1:1 but are
	 * commonly considered relaxable in some conditions,
	 * for instance in device assignment use case (USB, Graphics)
	 */
	IOMMU_RESV_DIRECT_RELAXABLE,

           iommufd ignores this one

	/* Arbitrary "never map this or give it to a device" address ranges */
	IOMMU_RESV_RESERVED,

	   iommufd prevents using this IOVA range

	/* Hardware MSI region (untranslated) */
	IOMMU_RESV_MSI,

	   iommufd treats this the same as IOMMU_RESV_RESERVED

	/* Software-managed MSI translation window */
	IOMMU_RESV_SW_MSI,

	   iommufd treats this the same as IOMMU_RESV_RESERVED, also
	   it passes the start to iommu_get_msi_cookie() which
	   eventually maps something, but not 1:1.

I don't think it is a compatible change for IOMMU_RESV_SW_MSI to also
mean 1:1 map?

On baremetal we have no idea what the platform put under that
hardcoded address?

On VM we don't use the iommu_get_msi_cookie() flow because the GIC in
the VM pretends it doesn't have an ITS page?  (did I get that right?)

> MSI regions already represent "safe" direct mappings, either as an inherent
> property of the hardware, or with an actual mapping maintained by software.
> Also RELAXABLE is meant to imply that it is only needed until a driver takes
> over the device, which at face value doesn't make much sense for interrupts.

I used "relxable" to suggest it is safe for userspace.

> We'll still need to set this when the default domain type is identity too -
> see the diff I posted (the other parts below I merely implied).

Right, I missed that!

I suggest like this to avoid the double loop:

@@ -1037,9 +1037,6 @@ static int iommu_create_device_direct_mappings(struct iom>
        unsigned long pg_size;
        int ret = 0;
 
-       if (!iommu_is_dma_domain(domain))
-               return 0;
-
        BUG_ON(!domain->pgsize_bitmap);
 
        pg_size = 1UL << __ffs(domain->pgsize_bitmap);
@@ -1052,13 +1049,18 @@ static int iommu_create_device_direct_mappings(struct i>
                dma_addr_t start, end, addr;
                size_t map_size = 0;
 
-               start = ALIGN(entry->start, pg_size);
-               end   = ALIGN(entry->start + entry->length, pg_size);
-
                if (entry->type != IOMMU_RESV_DIRECT &&
                    entry->type != IOMMU_RESV_DIRECT_RELAXABLE)
                        continue;
 
+               if (entry->type == IOMMU_RESV_DIRECT)
+                       dev->iommu->requires_direct = 1;
+
+               if (!iommu_is_dma_domain(domain))
+                       continue;
+
+               start = ALIGN(entry->start, pg_size);
+               end   = ALIGN(entry->start + entry->length, pg_size);
                for (addr = start; addr <= end; addr += pg_size) {
                        phys_addr_t phys_addr;

Jason
