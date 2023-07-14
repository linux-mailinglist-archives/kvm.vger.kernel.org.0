Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD88753EA6
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 17:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbjGNPT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 11:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbjGNPTY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 11:19:24 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54021BD4;
        Fri, 14 Jul 2023 08:19:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QfiWddCO1At8MKMV8kewBrwq78iCOOZboVshkqYuYxQGJu8VJKIfFZcwuFrPQyifj4s7xdTQ3PMDopQI77dDSIPQenMtaM4s/dpSOfpN8V5LBeDdfkLx2Q7uMj5//NliiIPNwIf5yjxaekryHxxQKt2C4eyJxMPTnKKs7qzW4z/E0QcbWolOMSIHyaJq4aJoYuHFm/zUeFUNePC2NoEAsrDCht84WY3j9TQdlQuMnFyHg1M7FlBoMUaUV+dZ8HxXN4U9UQT1m1aJrBHIEqNtK4XFKEhveCnQB6xUouN9pH+BtVIhiSXqfAFkMyYXi01u6DS1pfAJzk5FPwRrG9b1Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N/VsvEF7EBRdmbk2hBVWxuOIX8JSHiiqxj4hF9hhTAg=;
 b=Z7JXXB+me3p/GeVuH5of7H6WAiDNYusJpnuiLy3QWvwlI2CID+qUyEgBU3qTEN7njNGVSULgeOg7Az72JUN1eL7I4DLImAeP8LyvC3ZhoYRNVtVfFbA+thcbcbfG4FkSKHjbtYRwbbx7SjGoS4GbgkS4nxOH4DARJlUHLwqTIoD/sd8K/pJmvV5bfCh3PIO/SIfAKr6eK2zyjLrqZ0XifoF7MpaWfTCfgK5VgpD20s1SV3zTUQSNsqme4PVd+aQPRFVeEQFeXTS3r5+hMd++aj8FSJpa7dhr8r0obGqO4iyjamxPZEAdCgOg9xPM58MsM2Kfg3a+bxnWaCM/aiBNUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N/VsvEF7EBRdmbk2hBVWxuOIX8JSHiiqxj4hF9hhTAg=;
 b=DWpD2txafApmCLs+u43Tb6vEqfBPYIIhCX7u6m1vc7Dd9DhNCS4VnIkB+Q3JOS3GfKGiuYbFtwGwOHTVGw8ZOzkhxwsm+iMPJkSp8X4ZgGw51c90aLaALxn6gOD+JozJohYbpwUtOqDRvAQcJjw4lsk2D1x6iNAATqjK73hmlT5dzj7ZqO4CnlDhw+JKGjDZhHSp+oq2nbI8vhLG0FWEWIjX+3ScacowWTRyGulJfzFCT1qQaMw1iGdbOwv/UU2y/YVKI/RUlsMiXYvj38Tu1ZPYwgZ0CP51tvaLslN1PLNJIdC1uwZyp34hSuLOhEd6Jo8WcAbnaxOdRynl0j9jlw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4895.namprd12.prod.outlook.com (2603:10b6:5:1bc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 15:19:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55%4]) with mapi id 15.20.6565.028; Fri, 14 Jul 2023
 15:19:17 +0000
Date:   Fri, 14 Jul 2023 12:19:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v14 26/26] docs: vfio: Add vfio device cdev description
Message-ID: <ZLFnccon7OQU1KGS@nvidia.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
 <20230711025928.6438-27-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711025928.6438-27-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR13CA0191.namprd13.prod.outlook.com
 (2603:10b6:a03:2c3::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4895:EE_
X-MS-Office365-Filtering-Correlation-Id: e871837c-0f61-4a1b-35e0-08db847db04d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7GSh10zOUia+syOR5pGb2W9HLgZ14l8OI+ymKmyflZkinHjq1bmD/vgbbA4D3oWLTEcuQkT/7Umr5D0rL3MpcHmOlc0Ztt++VTbOuXG6pwWmC7eU5i70IENfeFlafHPBOU/lE9NnKh65mr1s6CqQv8FpNpdXB3h0ntuBCuNEsCauQY+ZChu0vcwIFLjVeCTQJf5xRv6kV/WzLayM3/P3Z70pwjTRE0iEI3mzI2+Xv3pE8wIQA4uJ9YiDAIOhhcw0HUVgtDDtR1xJzPxtECAoqgkEbSMbU2/RC9YDbzIyq4u9WEwLwJ0dHALD8B6btB1HCLIc3qH8RFYgbd9XkzdgNEUZb/tBGVcWYBFjBvnnSlg9IxgKNqkFSxr6i/tw+jWBpiPEOW8onRSeYezIpOImbUvl6NTG7S/OZRc11nEQskt/d+MNr5EaGY771arPsPJ0WRC2gcq/tLh4k331wAwlMMIWICHeduInQd3LoJqaHfQo330J96rn/DNnwov/CZBcVIOQbDGzR75aWqQU6pQO89R1KXynQyAC65eGI9cSztYoVgyzBrDj1VdYlWJeeZe7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199021)(86362001)(36756003)(38100700002)(478600001)(2906002)(6486002)(6666004)(4744005)(6506007)(26005)(6512007)(6916009)(8676002)(8936002)(316002)(41300700001)(7416002)(66946007)(66556008)(5660300002)(4326008)(66476007)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zReVlQp4wq/7cKs5bm5kxmXBZDEzRVCU678X3zXqrgWhDqPDqyNd/ohEc/rz?=
 =?us-ascii?Q?bUdELDn+IjBKHJ8k4c0IMC2lD57nonw7HXN45IjAYrAdzHMBD7cn/TrgePvW?=
 =?us-ascii?Q?QgcZORnds75PCL1UvhaMmzi7IOw1H65asTteSfkQbzcX69J4gj8HHCvfW7af?=
 =?us-ascii?Q?4cf+/Rdb92i08l/MOl5WMJm7WZ0l5q7Uv6THqum0g62A4dThjBb4LH/TqvP1?=
 =?us-ascii?Q?EgnEjtS/H5aXjKmT69cxK/Eaif/OS3seYRqN/wBWwh/bZX4aD9IZPFW2+Wwn?=
 =?us-ascii?Q?KTyi+iJ7kK66Hr1goWX9/j7f702QfY0ybkGWBDbwL+z8sx6AgtBT2+LgbwFJ?=
 =?us-ascii?Q?gC48WtMZu8SCFLxiU3WsjTmMI7xBWD/r6MOY2QMSC9zqVJlnFz4yrbVKcP4E?=
 =?us-ascii?Q?1GzhTvA+jSoxdI84AOB6YPfGNsY09gyihs2pIMRFZkE64MYprIhYmTXG/lOo?=
 =?us-ascii?Q?VTf13rSEnv4hI2CE4natuuwejVBz40PT90hoCHZHO6Um2chyZHkFAnfMNXK6?=
 =?us-ascii?Q?XGYxC5R/yjdVW7pea9MESuxEjRj7vq1fCNRF15zSEpSlWWbEGPfLVCWyKTn5?=
 =?us-ascii?Q?mmhQCTWNSspzK1wAdqQkcI2GJse4ryzCN+QkY2gYbnPSwTQHtk8Yj+PkK9VC?=
 =?us-ascii?Q?rWDo+n1485j0NElbdLmAM7lVbpHi0r4IUMIBk+PhdK+9IVxLxegN9qeek8Mi?=
 =?us-ascii?Q?QkOd6C7cLiXHMOYxSluw/D59fP+nJsP7gZpTbRFncMiUKWg75Ht6INC5Y9s3?=
 =?us-ascii?Q?aXEJnoY4syfV4tAVUCnOlVfehrp6vOAU1FPj8gEaLwRYzWu1DQzsvqecdOws?=
 =?us-ascii?Q?u1xrchJeUxwja22w4FQ/Aq/SYfK0OTjwibU5S9hWBph1QmMu+QklsVgHvM7K?=
 =?us-ascii?Q?Li7TWFqmyZ8EWjWbI/yT1hEtdnNXGa2er/8I4jzZ+XcCiBdJNnZleaAPkChS?=
 =?us-ascii?Q?x5g14olbzvFm3JAs9jwUHINO1lVpoT7b3C1BiqtKP6cD7HS4WrfQ3OcVxuQg?=
 =?us-ascii?Q?Or9cVBz1P0aCusSN7RxRAQYWY5GZoy9OJStjTe2eBEY7FcEbgGDxB6DlAW1I?=
 =?us-ascii?Q?Oz7qC3EOkdfsybpZ4zLxym7dz9VrkLHKvqcau5VKVoBa/5jBQYmAUIyk94uz?=
 =?us-ascii?Q?wgC5h4UVR3m3RaIbhralKG1AFTX8le3N0MIeDpgY/bxc/TSWJ11HXi4hQKVB?=
 =?us-ascii?Q?735z8/Lvzt6IuBRWOsN7GmLYYPZktl3XHqOFt2fMTLONxlytMS2Eag+22c7p?=
 =?us-ascii?Q?w4DFsxaPKvR9uzxe1lsw2bHkOq6vopmBjVOGWkMhU50AhGRWmv8lBtxVKXe2?=
 =?us-ascii?Q?sLxLQTD2e3iQcxRXr9AgdcDKzFIrtNQKTXXJhCXWb2BT1PuATCCt5oFTCGv1?=
 =?us-ascii?Q?dDyNrg6YVdFV84waIePoBgYjI3NjTLpU4WzgNkYHir6igZOaWDzH8jNetLoG?=
 =?us-ascii?Q?ePhinwhKhncMnqMmAwxpCo7XHERw5mWRb26/p/+FamEIretxEbH1QYb1MFjh?=
 =?us-ascii?Q?BTiz9jolerncQ7ZIE5/pauBvsLLW7kIE7SAvkecupdSY7IrM8H5n1bx7fQD0?=
 =?us-ascii?Q?OmdrlhVTIR3asyil3JZlvgtZo8moWfooSKd+ZGN3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e871837c-0f61-4a1b-35e0-08db847db04d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 15:19:16.9397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MguMjqH86bmIGK8OnaNnwlocr8pGp8LQKJfct/jXSWPKhrrkyWnv4mMwNVQfHsXx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4895
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

On Mon, Jul 10, 2023 at 07:59:28PM -0700, Yi Liu wrote:
> This gives notes for userspace applications on device cdev usage.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  Documentation/driver-api/vfio.rst | 139 ++++++++++++++++++++++++++++++
>  1 file changed, 139 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
