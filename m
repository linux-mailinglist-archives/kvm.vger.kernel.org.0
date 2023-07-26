Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28B97637B0
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 15:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbjGZNfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 09:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbjGZNfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 09:35:11 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2081.outbound.protection.outlook.com [40.107.102.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 449E4172E;
        Wed, 26 Jul 2023 06:35:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBp64wciSwXL3x+3w08OAGJUXTnPI2G5V9om9s1rT4l8Zjh/nSL256t2RJIAILqvkwmDrNjVedgB7sJ7qumIs3hMriy7ogw8P+NDfj+gfgTW8G8hfmK6Oee7+gQViR7G8IC5LLfArB3ApJDxdgFznTpwim1TSgSS57/3uK0gTB40g504j8TQHK4XUwujxtbaJqTpRvuxCFhLUqE5sEgyQvmQUX6Hmfp2r8PxMTXs/IT70KAWPta9dHOGca5bZ8ytLJvrjppAK4s8DXzlxnOCUwNfJqPFSnw2+1I/XLU3eHS6VHndrTRNq69vuH6pJocGtZMnAWP9NW5XsSEqf6uB4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XPqRzSsEPHumIe2cBUoZ7hzergtu5ALtiCQyFKsdWG0=;
 b=YQfnbt9o/dV/2JZcLrLevDUceYxPQcGB2fyO4tgkhi6t2F75KFWPTYBlOdVmLbGRmLuCWPh4yL0ClnsN07/HXuxGYTtYfTi/qVGaxvTVefUjrydqT6BifYZKa8HKcm+aAT6LkE7BAfgotLpXy43YSpXfrR4nnealUE/dMDEsg7jCcPEGUD6HT8r/nY4uQAbA8XmuAQtvR0D4HCcE7KTpMsjcqr/npVPrAF3RyjCkP9JPo2IAvgLzgHkfy96EgI8hl4Bd4U6eDHvegZFMmI/1hukv5I0Q8v7kJouxQmnuGl/5xzZqqvhFZlmnnQwkG19P1/6eajObZudgRVsOlrT3Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XPqRzSsEPHumIe2cBUoZ7hzergtu5ALtiCQyFKsdWG0=;
 b=uHSA9rTorFohI58q/8SkUBFpF67NbjQH5G68kG/3ouNkOFJIxKUBE94yZmDFAjOa6Kwutunk5eZy/49iFVuBnNUcL37mqVxwmOd+YBDJNihOVsBGgFXDaIcaS5dNBQv/0R2pSxzkZiPM9zK6Wiyb7sZ8RT6yRipvtytbGVlSa2c/rTm26KnvR1zWf2ewFuXYi2VMmtNo7NbpT5XDfTyBVH4kdRb3saIE3Mtj6KEhPD3czxm4mFOPvPajNZSXJa7ZqmQ3RUVqiXaqYRRvdyJP6QOOl6D94iDjyMxU+NbAYkLTF1c53Ra1EJkndHL/LAdAe75ozc8kSR400/zbX45jxA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH3PR12MB8188.namprd12.prod.outlook.com (2603:10b6:610:120::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.29; Wed, 26 Jul
 2023 13:35:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::5111:16e8:5afe:1da1%6]) with mapi id 15.20.6631.026; Wed, 26 Jul 2023
 13:35:07 +0000
Date:   Wed, 26 Jul 2023 10:35:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        simon.horman@corigine.com, shannon.nelson@amd.com
Subject: Re: [PATCH v13 vfio 0/7] pds-vfio-pci driver
Message-ID: <ZMEhCrZDNLSrWP/5@nvidia.com>
References: <20230725214025.9288-1-brett.creeley@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725214025.9288-1-brett.creeley@amd.com>
X-ClientProxiedBy: BL0PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:208:91::39) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH3PR12MB8188:EE_
X-MS-Office365-Filtering-Correlation-Id: fd54593a-9646-4acc-117c-08db8ddd203a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z6Lbc6dgD7fYLBbDq0Z6MZ50yp3B95hOCWEvIzTnZ5t7KvDx7VhAsP/2ojIZtNWqioYFGFVrRSL4MENfGTpr2SoM62te+//qUNrT/I68K5F40ms+Pmr/b7DoGHOlDWLnn5EkrKC77yFwY7AOqYTIMLKw4G4QLh0FNgcZjFswfZXEksc92lhw4TntURr5HubHsT1lEjJkgCwB+NE6CjKVLmC7vr1dfnCSyH0zoljeWxoXAKgvhOLS5U3843Lde2uVm+EFIxkzv6nHfxKZF1zj1Kit1OQHd1jcooQmUw9iVXYvzoTCQzgn5mEIWdvAzpZKcIZhovoB3nzc4Cud3spGuEY2iCTqfsCk6RxBwIHhuc8fogkukaBHPBX/aIKa+lcwjpYkptDgF2bJ2tDRlY/bKn+RpUvKqW3EDwYV89Q9Pe2cKFSjDs33LkA9v0fW3VUNVh2DLqrSUq6+3rPWylDvofVr+osZwIvgMkkARCkUuZjjDCoJR40fsOoabbCO9oUZ3G+2a+ednrHY0iC/CBqnA7wbL2lUIM4BDjrRlnyLLn4oR0ucYeUECcFxPSJo4q9h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(366004)(346002)(396003)(39860400002)(451199021)(316002)(6506007)(26005)(8936002)(8676002)(41300700001)(478600001)(66556008)(6916009)(66946007)(6512007)(66476007)(4326008)(6486002)(38100700002)(36756003)(4744005)(2616005)(2906002)(83380400001)(86362001)(186003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?big3acHRHyyaNywdk3GadSbJXZINBiKs1PSFrvoMEd3wzS24DKOjqqwSreJL?=
 =?us-ascii?Q?Q/INvB56N5QhW4+V42WA0ShdWod7pRdZSVa5CKOtq2Z02pS1WsJcewokFKUU?=
 =?us-ascii?Q?iSpJQvCDSy+aAAg20V3G0jfAsE2asR2wLzoksY7po9IeIg8V7mosX7Zacg1+?=
 =?us-ascii?Q?MEEn3Av2jX3pMqcuu+xjvHnW4a5UBGivCNiKRp7oLeVGba8sjZrY3TgjyVaX?=
 =?us-ascii?Q?EE45s+UtUsmRlVRkk8a1NijKpr27Jx3R3ME9em8BX7sg2hEXwQyrFgLi1sBz?=
 =?us-ascii?Q?C4Ynv6BLmfB6as16jMk9xKHeCFiBguOsahd9XyuWz3pMLQDAyHm4vUhHus8S?=
 =?us-ascii?Q?fjVb07mEIserAgj7rNd2xW0fYvJVAvOAdd0MAeG1ATJklRB54tf6a1pIfGf+?=
 =?us-ascii?Q?I+M/2Yiljy5aNhF+jPpqkI2uz8Mo+ObicYX9BnLOHYzwGAcMMu5AelTpNeL3?=
 =?us-ascii?Q?lqCiIZnqp8RzAGzR8PluuIM/EE2VVmoFv6/V6pTj8gEyJxnZdlzQHDNXeIF9?=
 =?us-ascii?Q?PSnmFLOJ7qjdb1mSV7TJEC86Yh1qjUcz6cjaT6VinkLtM2AkvohSAiIFeMOD?=
 =?us-ascii?Q?SIIauf90tU9HhF0SiI4iRRI25xDSiYnsDL39ezHei65T/ujLeTAV84d4t42Z?=
 =?us-ascii?Q?a07CI2iep+FW9YSRUai87NBpSjAiCu3ttRVdMhNL09fIzzphmbgb3dBg8Il9?=
 =?us-ascii?Q?wC40r+OCawSSGt0D/cSZgesc29t4bhDuNmlJe45vhA+qwcX8LHx9mantBVa/?=
 =?us-ascii?Q?OJ677TeYpPU0vjhN9fJzNLONwVTTLUgnf4L8HJtNW/g31yrEEZNNyExUD1u2?=
 =?us-ascii?Q?HAGZU/txPB2a11SHzytUREfY+oHSWREmXHwgkVCZuKfpQUILm5kfrbCQmfL6?=
 =?us-ascii?Q?QobB13Y6NUIzThJgL3xWpRlSWZYLoltzUQ7FMl6LiwNkv/xXPQzBxFOMAe+8?=
 =?us-ascii?Q?DJJ3ZlDu4VkGzb2SGqUagvqdONqGsWNbvgZvvaPwrhQbdPMW+jRQV5ceFNda?=
 =?us-ascii?Q?ZHYq+ooxoR7b7m5nsHn/iTX0VBJRXewUQ5v/Ylt0+BxzhDdCBCRwk00p4dP0?=
 =?us-ascii?Q?mUpGEscuPYVAWMR1geKbrqWN2e8RONF2GhhosciELgDjiSxcPp61R2Ac7jRw?=
 =?us-ascii?Q?+boXxGUqmLhLeD3yLHCX7HVlF0M5jcVmBbchHDsev+dmJV2V38Rlkv8689A3?=
 =?us-ascii?Q?otohSb/CuuznBRRaB8B2GJjm8Zmvy3Q5AerkoPVYzbXTbEBT1zyWL5g2dxA/?=
 =?us-ascii?Q?MBaAOn03ZrYGrCt74SGaMWeGxlJXlPRgqGS8qZn7DIl0cBF8b/4xb5ds2uFP?=
 =?us-ascii?Q?KUW9yOrHXezG0KH0vFeiYOlMHRaNFiYUmqb0HwSOIXbKs75jUD81xTQvPXae?=
 =?us-ascii?Q?CA+qLFpySCJoBlJNFaNIYC1NBNS0vU+FgdlrEo+EuTNT/N/HJjjzb/vKq0TB?=
 =?us-ascii?Q?nV/TUPVN3XJRWYZHQ6UE3nxaZrQef8j9RTPHBeeJzoOdp/Xiss6r5pD+oIPy?=
 =?us-ascii?Q?f/18x/JgPKDWqZMopTo/Pn/cn1tIzpiqwiyF1aWInRE6dPW2IG+vTNxXpm2i?=
 =?us-ascii?Q?PtgWt2BzBJaf/8jotzHhO3hc1KS0R7yX4HkLgI8Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd54593a-9646-4acc-117c-08db8ddd203a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2023 13:35:07.2715
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zUXjwBifyNXHPgnRfpTJugWHEg22+0RSC6xVZ0xszyACduXpz5T19UJMiPoyvzV/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8188
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 02:40:18PM -0700, Brett Creeley wrote:

> Note: This series is based on the latest linux-next tree. I did not base
> it on the Alex Williamson's vfio/next because it has not yet pulled in
> the latest changes which include the pds_vdpa driver. The pds_vdpa
> driver has conflicts with the pds-vfio-pci driver that needed to be
> resolved, which is why this series is based on the latest linux-next
> tree.

This is not the right way to handle this, Alex cannot apply a series
against linux-next.

If you can't make a shared branch and the conflicts are too
significant to forward to Linus then you have to wait for the next
cycle.

Jason
