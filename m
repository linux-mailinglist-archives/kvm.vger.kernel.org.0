Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE5875AA0D
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 10:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjGTI5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 04:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjGTIjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 04:39:48 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E647D26B3;
        Thu, 20 Jul 2023 01:39:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nvSBmcOJMZUws4Z6ukb23Fh6o92px4nFt2UYG9ZhBJM2NKuwqXLKaHmGeNk0BxbnmZ8l4bQjX+Ms39xtuNGgPsELtlfNbjkCHpMdbKQkuXiL8/5UWqhPsbcCrnkeFupIW9YV7BNfuaJdeCJSVaBuUzfYhyrJJHl9SWQ6whLkZg2nJ7AMohtn443pd4tFnI6HPxK1hqLs8T1EIEC8OGmTyysFN15yu+mbZ3K9nmyMWyzJfla7SxPuuqexffB80x1v6B8NZfEA+bHpAtN8xTfNSeBmeiwCh80i+6j1iTAH9afX15FMM4i+iOwvdA+jZJ4IIajSsdUcQufHpxOvxtwBAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ppehoSrCgyLFyaJH/ZGUibIGa4K8lHOftxZoQu5p944=;
 b=hlpV1y2aptActkbla/Wo20ejvQYkw5zPb/y4EWi6rsD4HCJeWxbbSxgxoaTDbviyLbzQbjpaUf/z9EQffGIhufGNQprnbsUbbVGH80ZoEDQxKDBctWjFeTVYDKr97DEoha5gG1TIWce686y8GYUoCjIbWSXw5RPDV+g3lXO3fHxlhqL+5Y43lGvRlJBBo/FbsNcyBIIzIE5LXrZRwY9Px7xUz8lQJ2pvJ/o3d9Iz5invOinrMtmeEW9uTb8ykpG1cdi8fUH4HeqCpd6KVLBVSNUuBnbf9+0l+FxqheqGd4zTRhVOFaeRY3is12AyNjt8hQpyQSLspj1EKMRk4Cpucw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ppehoSrCgyLFyaJH/ZGUibIGa4K8lHOftxZoQu5p944=;
 b=bTkPNhibWjcJI2W+dadrFK6opdVBohDuMRqf/o/60Y2E6Np1/xohYJNtpj9ePv2X0XsnbCY6CnrL7wUN5/EJ20MIpYvbMn9q2QKuj3IQS/I66D0MmpAQLQV7L6ocNexTkieQ81NeVd97LBQOfpvVu/4c7BMTorotvfg1eknwkPB3fKDL/naZKzC3JTxjSvgNo/Xd1OE6wevDju1jRnKDIu2k8GMXuUDfZkNq/vGj6V/Uck3twj8RL4Ks7b+FhZo/gpI/IOAgfrE+WJqfjknaVOlh5E+9tYx3gOJxATOyWYTWF+oQQ40hfwr0PZypexlH3bb2dEvuSzvVqmd5BRpk5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by PH8PR12MB7025.namprd12.prod.outlook.com (2603:10b6:510:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.24; Thu, 20 Jul
 2023 08:39:45 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::cd5e:7e33:c2c9:fb74]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::cd5e:7e33:c2c9:fb74%7]) with mapi id 15.20.6609.025; Thu, 20 Jul 2023
 08:39:45 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     akpm@linux-foundation.org
Cc:     ajd@linux.ibm.com, catalin.marinas@arm.com, fbarrat@linux.ibm.com,
        iommu@lists.linux.dev, jgg@ziepe.ca, jhubbard@nvidia.com,
        kevin.tian@intel.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, nicolinc@nvidia.com, npiggin@gmail.com,
        robin.murphy@arm.com, seanjc@google.com, will@kernel.org,
        x86@kernel.org, zhi.wang.linux@gmail.com, sj@kernel.org,
        Alistair Popple <apopple@nvidia.com>
Subject: [PATCH v3 1/5] arm64/smmu: Use TLBI ASID when invalidating entire range
Date:   Thu, 20 Jul 2023 18:39:23 +1000
Message-Id: <082390057ec33969c81d49d35aa3024d7082b0bd.1689842332.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.b24362332ec6099bc8db4e8e06a67545c653291d.1689842332.git-series.apopple@nvidia.com>
References: <cover.b24362332ec6099bc8db4e8e06a67545c653291d.1689842332.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY2PR01CA0037.ausprd01.prod.outlook.com
 (2603:10c6:1:15::25) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|PH8PR12MB7025:EE_
X-MS-Office365-Filtering-Correlation-Id: 71a9a0f8-e298-4619-4932-08db88fcde88
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sVneCM/Dg9K30ylAW9TjIHNkuAsJ203YUZ7CqFkNHefMCTPdPuDCbA4YbzfTu0TtSxzvGupAkt5UD1ipoKHA8r/Zzngusdu2FqhYyGMNwfNvtXOS4rw052nGXRa6UNQev/m0IGXkhAgoRHYzcl+l9c/YqLIYogfz5qHJ43WsxrEdJqwh62qFAnDPxdeXhNOSQ5iuSATUXXliBo/wp6UqonTzxNu63hX6bR16PsTatvU2wXdT21WehheEX93VUqwNfDVbgYu7vGg+VqSZUrHtWbfAbJ28LhR/ZBTvsN/SVz2laNVVHuBmxWWQXi+AOysfan1pIhUzQtAvTZWzvL6ieY7/vapsBn2R+Twi7ixmz31m0UXfxKvBq0SIg/Ld3sX5tN97UpX6YbkA/8KS7z16RTH+hMhXLbavOJAc1srVjD9saeBeY8lv42RLiChF5NQBqzwRdu/oRECQEUE3egSZqlLb5D6bZ+sTmNBZpk4p6V+Q9aoXvCjt4LFpzIejfHkj+W12UZikkXLQef+48L1uqxIraG59Xh3c0dgPxy4vcfLGpqLrRqXi4ZMRYXcBjCpm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199021)(36756003)(86362001)(66899021)(38100700002)(186003)(7416002)(478600001)(6506007)(6666004)(26005)(41300700001)(66476007)(66946007)(4326008)(66556008)(6916009)(5660300002)(316002)(2616005)(8936002)(8676002)(83380400001)(6512007)(107886003)(6486002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wHqiF3NjiI1Qkb+tt4ASongrf64ybb7hwVxTMrmfxWbMKjtOa2gzUg/zOxyC?=
 =?us-ascii?Q?E9yWQdGIM2GzB1EeaZjb7QFk2GbrHJ1ZZi2My7vxoeIAFbrTWSnKMPvdTPmM?=
 =?us-ascii?Q?QxptRc+6JvAjyhjZsUNXT2/XxawZr3XBRBds9oWQT7D7XMRuBE3vhzWscKw/?=
 =?us-ascii?Q?zMN//uxEhFDa7ea47crbdM4L8W6x9w6bj+JZqxnbvFaeEq+40Vvw83trLfg3?=
 =?us-ascii?Q?6tfXip4X8dVfYeil40bpW1J3d0R+ql9Xwf3YFv4oiIVmkVqNl9i6xXWOu8De?=
 =?us-ascii?Q?YSnmuG3+CP5adYj9RShjZPwM+F3sGmUX4YHvpVpnNz3yr9tcWAYojt+DlhiB?=
 =?us-ascii?Q?kYblPjju2Mae9zbHarWvCpeQzKlM4MCYh3rlNJkQSA44eD4hnPcWNXc949BB?=
 =?us-ascii?Q?ZO5BKRKCqeV2S9GyLLTI0ghXvTT8vm2pydaXHBmg3EcBHAVnniuVDMTyXLVR?=
 =?us-ascii?Q?epDwLOk6S2IbrgPbaig1LacV+aNqqB5Vm/Y/d0LlM/BGWg3KZlj0lzzHaIGQ?=
 =?us-ascii?Q?S8lYxH8RnuT+U3SUX90WjfLl6vDCXbzsoZEc1P9Ujy3g/Aeo1msDc8p75ziF?=
 =?us-ascii?Q?SlfrJHUCP8yZlP8gnhBIuwMVNyqYfytuiJKTRRXu7urCgPnwTvHewCE+QfYt?=
 =?us-ascii?Q?mY4xASg5G1vfx6cOlwjtAowOyIBBEZLABnUSm5XYz+rrTCrMfuAW4x0+KYhr?=
 =?us-ascii?Q?giPK4F0JcWOjlvIP4AzFOzzv7/4jolQEjpXXLD4vFYK6jKROZ2qA4BFri1LT?=
 =?us-ascii?Q?Pc+AXG1fCQbnWG8QeijB02PNrG4shPdOmiUjHGw/rpJ59cn5d9uSHj+b9Hvy?=
 =?us-ascii?Q?em05ckGhBWw4Te56m7ppztOGayCQBVSuKcCYdMvjvXzzsugpaP8gsfxsUUDx?=
 =?us-ascii?Q?bckNee55QwmnAdlCtza7/yVFACGRXHHhHymAl56/qMtOa4LL4MuqQQDnXdCC?=
 =?us-ascii?Q?OM8Rn7QOLlEj3+w4XMq3rFChlkCORVnijr4ZBOvFZF1BJxJGmZtraPANgMwf?=
 =?us-ascii?Q?pEX6PzpIzN5xhvhCP+sduDXub48z4hV1m4E2xYGWv39HtmZOjpNHLMDtOyxA?=
 =?us-ascii?Q?IgmSXX9HfzUSFRZrzyKxdAvhYD8N12VRhKX6GBYEmUEuMVzrkSTWR2oC7gC2?=
 =?us-ascii?Q?obSInYRS/2hcaDCP/U2TgfPnwEz0xIybeTrveoALFkhYsBzxBrYsUASTsOvR?=
 =?us-ascii?Q?ZuzfI4vVJIU4iaSFdmbiCq2BeTYrr/VtQ+5KCiGWIO2aQzzhNritYO+20Hkd?=
 =?us-ascii?Q?1ACnCsHCJZsuoT+WKkK/ad2jez2RCA0iCeOl0se1qu27vHqoaOqQo6zcr88Y?=
 =?us-ascii?Q?u7RrYxKA48lARIY2atKMGpmEX6whW67Ofr0sGdR2gPnK9boiIrBu93yYoaln?=
 =?us-ascii?Q?rYfdDTMMZfidYH9wfZwqjV1g8dOUofZ0eHOjmpLwit0HMmLgAJBumOovkESu?=
 =?us-ascii?Q?Pu2dyiEOq9AztKM3ym2tZqewmXXQDl8HBC6Cxe5Ni6baHRXYcGxS59r9v7fh?=
 =?us-ascii?Q?PTVK2IzjwZpTmen0fubLGbrZkGx/vHVOieO0d0URNim14XkWf6QEsZGCIu0R?=
 =?us-ascii?Q?40kKsrPjbG4I1BBHI0YNIUduI2oY98exf6aQhAV4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71a9a0f8-e298-4619-4932-08db88fcde88
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2023 08:39:45.0950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y2+mhUVdw3pCz9hk3flwamV5KGK7+RznL33Ef24k9BsQxxw/OyhIqEiwNWShtqX//oMjIhuPWSa1MgCQx7kicg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7025
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ARM SMMU has a specific command for invalidating the TLB for an
entire ASID. Currently this is used for the IO_PGTABLE API but not for
ATS when called from the MMU notifier.

The current implementation of notifiers does not attempt to invalidate
such a large address range, instead walking each VMA and invalidating
each range individually during mmap removal. However in future SMMU
TLB invalidations are going to be sent as part of the normal
flush_tlb_*() kernel calls. To better deal with that add handling to
use TLBI ASID when invalidating the entire address space.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index a5a63b1..2a19784 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -200,10 +200,20 @@ static void arm_smmu_mm_invalidate_range(struct mmu_notifier *mn,
 	 * range. So do a simple translation here by calculating size correctly.
 	 */
 	size = end - start;
+	if (size == ULONG_MAX)
+		size = 0;
+
+	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM)) {
+		if (!size)
+			arm_smmu_tlb_inv_asid(smmu_domain->smmu,
+					      smmu_mn->cd->asid);
+		else
+			arm_smmu_tlb_inv_range_asid(start, size,
+						    smmu_mn->cd->asid,
+						    PAGE_SIZE, false,
+						    smmu_domain);
+	}
 
-	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM))
-		arm_smmu_tlb_inv_range_asid(start, size, smmu_mn->cd->asid,
-					    PAGE_SIZE, false, smmu_domain);
 	arm_smmu_atc_inv_domain(smmu_domain, mm->pasid, start, size);
 }
 
-- 
git-series 0.9.1
