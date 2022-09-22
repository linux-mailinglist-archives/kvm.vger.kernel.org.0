Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01295E701E
	for <lists+kvm@lfdr.de>; Fri, 23 Sep 2022 01:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230517AbiIVXMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 19:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbiIVXMx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 19:12:53 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CE8112FD5
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 16:12:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5DAEW/SVVSY5bJu+GyRosbRWDzn/TYn7gE8tHeRBkX3nnjQZCF7BkNHFwC0ppjCotn6C8z52lC9A8N09V9nrXeXIfetEicM93jlpzsv+l4nb1XXUupzvNi3rqWhozhlteZqh43zquMmGLTknmWWBNiQY+9b8H73ezjMdTd3ZtRh2adcWobPKIy1lGAibZQHrnpd6cEWN8ta9WuGYP+0/5VHzspZbJJRkUeYRnSBDY2J03BktriG1Cf2eJ1tNJc5X34L9v9oW7QHxB/CBITX0u15Gai9TLqPzoQ5XHkBSg4Naj8plTXv36yMlfNOE9gWu8M6gblENP/LdsKFKHUCtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NGylxG5J33rsNziO7TEuoHCGVQpDGg9Z5WONMfqRh34=;
 b=N9t9rTaD2yG6vO/ofFwZG3GsAnYRsKujUKsTPXW2k1vEbfu8NW3PQWhWbJrgEA93e4pvK9jUJawSOMah3BmyLvszOjGmrAKUm8vK+2Tor+CYUMKtWF8HR2556t155PL7HQqZRfTzMlIchwGHHdLjtgCRiBZuFCgVmzQXa2PGREL6KesosAFaOhVlaHM2hq8Hap6nU9ieASL1K4cGGpZmuX53hwp6zilGjnykwyef3zXtSPdHeifswwkUet17yB/CxnBIlwj7Z26UHgcAf6aGNt2S3UwL4XHOQfNptQueR3G5B2mZHISK92p3WtYFyBMNxkysDRqUmDgIR4Gixs3Xnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NGylxG5J33rsNziO7TEuoHCGVQpDGg9Z5WONMfqRh34=;
 b=CE15vJCK0csk2OjgcvJALFKIkgLaVL1XRGs0O/I7TNDopfLoB1oNyH171jxpnLRgHZFFjcZLdObgDZ41uNoIBp+j4FSjdzRnp4yLLr0gNAx36TWLITDWsPpVdYE0wuVgE1wuvcXozzmQv0NQqVB6/jL6W1ec1MbiSvq1z1kS//cTQv30hkoOtktVfyZ5MikiWLj39INCqewVNoENSXc/rku9cltnN2wb95C3F4d8vfcFRyq1Pvv2hcrND7L4mlLQxT1QOXvoizNO292RstIlLxfkNFkJSBgLqmuAGg0OH7at4sIUc4d6WIFaS/YkdMdWGQhj4SBEQWeSyBER8HRskw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4936.namprd12.prod.outlook.com (2603:10b6:a03:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Thu, 22 Sep
 2022 23:12:50 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::462:7fe:f04f:d0d5%7]) with mapi id 15.20.5654.019; Thu, 22 Sep 2022
 23:12:50 +0000
Date:   Thu, 22 Sep 2022 20:12:49 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Qian Cai <cai@lca.pw>,
        Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH 2/4] vfio: Move the sanity check of the group to
 vfio_create_group()
Message-ID: <Yyzr8Qizg5BHy5yl@nvidia.com>
References: <0-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
 <2-v1-ef00ffecea52+2cb-iommu_group_lifetime_jgg@nvidia.com>
 <20220922131050.7136481f.alex.williamson@redhat.com>
 <Yyy5Lr30A3GuK4Ab@nvidia.com>
 <20220922152338.2a2238fe.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220922152338.2a2238fe.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0358.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::33) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|BY5PR12MB4936:EE_
X-MS-Office365-Filtering-Correlation-Id: c79b8948-4c76-4d25-09f7-08da9ceff7fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+eHHzGakfV/clc2CbttL2ChzTzWNejtKIVt3CWNsSHjbLRRKkpVC0q7qUikYvAaWE3BH7n138WYsPvXsE47mOf0COwsF5gph2IIGuDCGymAYfpkYr/71bAT2BXnMVOT241fYC8y+9u4ou5U2+08wxoEDfu58T0mWEmRJ+/q0kz/YFt66JdRE4ezWmsgUB8zynt25qbiObPVNn9U9pM/qdIPMDrWxsUFgRO+3zFDHo1jBKZpRtYYtJi+EuV0fXf2EyGplCyQ/PfL/VA+opBZPPMv6eJeaX0uuBNSIi1r8+Qn3/Xduo0Wlh8j5nEUebpWLmyCZ8ymEpLBSK4kR5sLFU0LPznWW0UkU5I9iYxhkdIlLWi1CDFpX9mE/bR4ghDF2250Kb1B4Ch8EBQRWU07Bq35UNQAEDp1FB+Yn9yMX3o3fcCDhQnJ+Fqo0+PnvmFdFtc0GiW2r44ECR9eC8XLu8hXBXbK7GQB0CGS7qlPR4/iR4T3RTyXN61w7bPwpD8SjNPCVk7sQ6QMFQtE0RpRZr42hNorUFGtqRRKucL2rF538f2DZgPzJBBAHlSIY497EBhDpBO3rS7lFTeO/BMc3XxlJk4rUUBTDqz7UpAklFPO78gZ02Cjy3uDKU0GUhVVSpxnJKSOAUPCbuIFCC9PG9MoIe/+mSPHuo3FIodqBjkcUKJ9GOizzErqJ6OC4m+rUQ5ZWZHiJRExKA6LBrgpKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199015)(54906003)(6916009)(316002)(66476007)(8676002)(2906002)(41300700001)(186003)(66556008)(2616005)(6486002)(66946007)(4326008)(38100700002)(478600001)(7416002)(86362001)(6512007)(8936002)(5660300002)(4744005)(26005)(36756003)(6506007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IMisncu2o1GMMcLynSjyuQJU0RpFa+mAiU/lLu+sVG5gki2eJxIdKOQ/G3zC?=
 =?us-ascii?Q?42/rCHVhY1CGgoHr+Bsj4745AzC0mxz8aAPHmLfq0j9kNuvwFkJEX95lEK3/?=
 =?us-ascii?Q?/2kj25v0ifyjBo/0xvpq4L1UM9ZlsfqjTJMHDSSUdJAxi26PkCE2mUmJbmYI?=
 =?us-ascii?Q?9aMkWCtEpsw0h5XI6YrUlfuWAulseojCrCOTxKV1sfNyrjlyUgzU4FRuAYNA?=
 =?us-ascii?Q?Mqh8s9qsc7HTBG5vRJM7bhp/JFNBT0ftGBMnt/jSRyld4rniaigRynOVgfaC?=
 =?us-ascii?Q?gbG1/3rkZBu1/H6Ej8wSkienEy2AsMc+XYE6ppwL5lLFWRLKSDvrKCLEUfkA?=
 =?us-ascii?Q?zaYWKzx8/X5Tv62RkkRx/2X5XLubVMUxI3he5lNCsiKhYbKoLguMJEE3732F?=
 =?us-ascii?Q?8/zFRfsqu2esckBQuucdrN3VGSTkBw0uk5nHPaEtgthQGAsrkn22MTIjdM9m?=
 =?us-ascii?Q?goSYvX5zhQVZkO9c2/oQ04W0xugjOal1oiQrh7BftxUDL0FvYDH5f6knBWH2?=
 =?us-ascii?Q?c6gC7GwmIFRK5UkUSm9VaT2zFLYmFTdOSeGNZ8AxrJLDaAHnSMsX6jlxl7vx?=
 =?us-ascii?Q?MelBrIAY0jtQlHiGEXNsbdg1wU/cd+hopwL+ZeFYZvm3VwskCjtR5FaeAshT?=
 =?us-ascii?Q?yBPmK5yTvEwv6PvwTDX+WCwzaL/KriYXScmSKvFKO7PabKZzEg4xJYZskmDP?=
 =?us-ascii?Q?vPlJknwIkdqyDZJDDyKKmra3ycirY+Ba/HZ2r1PQh1hzD5Uhsqi3smcM+goW?=
 =?us-ascii?Q?cGk8V8BTfA/f44hFldTajAfp2oUYiFsqqQLhK3GFowmwV6bSVZ2ne5tPGiLu?=
 =?us-ascii?Q?rWBI/U9BOsIztSzbcKUW1UbN1zS2YGQVrvJR+3xZazCb7FCt7tb8hWtueSb1?=
 =?us-ascii?Q?a0d1/n6EIlZWOmuPrSbd59Eknuec2ZxEpuMwhrCuyA5ojhkYfnkIOQb+qQ7Y?=
 =?us-ascii?Q?V3sYXOX8N6nVECzmld8OFxeM7KZa48F+OgKy4lSR4j5EXcJsSRUDKb8IROvT?=
 =?us-ascii?Q?X0Inz+/Sy+siWGABJjIYhtPfdwCR+lMEAcz1eMabLGSZsIoR9VV4pjTk38Bl?=
 =?us-ascii?Q?6Zk92tRwYUEM1Mc8azfZNnuTseC4wFaxw94/EgZn7AMihtH75VZWJWKKX7Nw?=
 =?us-ascii?Q?9rs745jiUnV7a406/Zv7biYfLmoNSgsCPLSZ+hldRL4kZ2fK5gF46faBxZ1V?=
 =?us-ascii?Q?qlK77V0BjvqfG0aF0oJa6s9NpPKkybs1XQZJxrhANIvj2oU5smUJGs80yjHp?=
 =?us-ascii?Q?pg0DBAQHlY6qcs1CivFBnTty3Cmfxi+gb/3gcvDfmrVWbVcKvcb+jI/0p2+U?=
 =?us-ascii?Q?7DAaKK/X1nGAv4R33km2zYT26brmybVskzj9D7IJzYXnsSyDfcD64bcHFD9V?=
 =?us-ascii?Q?25Kb3DwlWWgq91O/3p1VWpRo42YDRUYx7+Gpj9SVOXwpE1hvVRTmS5hcti0H?=
 =?us-ascii?Q?zBGIM0nyxWp5+vNziSJeDEsgtPTZ3gb1QGAvR9B5kQhsvZmbOS+j4kTJUDjs?=
 =?us-ascii?Q?kEnziM/7ylqsTRCUOOH6fwWR/acyBFfuXxn1kuYI5igt/6bRdvtgzXsfID2o?=
 =?us-ascii?Q?+nu4v+l2TXeFSUjb56Xj1wq6/hyaZNAxRCd6KgQS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c79b8948-4c76-4d25-09f7-08da9ceff7fd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 23:12:49.9581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FiDG2EHXOZkEac9wp4rW0AXUJSqkiqBE7r0BN9FV4FlkB48TuCnwuPMCIJX2Hal4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4936
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 22, 2022 at 03:23:38PM -0600, Alex Williamson wrote:

> Well, we don't really need to have this behavior, we could choose to
> implement the first two patches with the caller holding the
> group_lock.  Only one of the callers needs the duplicate test, no-iommu
> creates its own iommu_group and therefore cannot have an existing
> device.  I think patches 1 & 2 would look like below*, with patch 3
> simply moving the change from vfio_group_get() to refcount_inc() into
> the equivalent place in vfio_group_find_of_alloc().  Thanks,

Yeah, this is nice

I just rebased it onto Kevins series and the reason I did this patch
has evaporated so let me check it again, maybe we don't need it.

Jason
