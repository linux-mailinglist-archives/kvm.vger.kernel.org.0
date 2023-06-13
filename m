Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2726E72E200
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 13:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240964AbjFMLr7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 07:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240443AbjFMLr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 07:47:56 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1897CE47;
        Tue, 13 Jun 2023 04:47:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TZqR1HHXk8UXCV3ceVh4gDVahqpUffvlq5myhS8lgwSsiuswzm0eVwthAGXiRY/RGcewWkhiRPNGfMtfZluCT5pB/L+f7CU9WSMEMTIYx/DwOqHaucZEan5nXJYgS0ixIHIOTMenAty5peH5NFRz2tHKnW2MgQz3ZPuEuNdjtGc5z9ZDG+6GaTKmwKlM2Fg8NCMwREjL7rwWTVwAFfuBEtLw4l6Nsgd/iSP+NGynHxdGO4117vawvyr1fFcGr5LyGhazqqpPyn5gvvxP0WI/3nJ9BiWOYwaVwNgs+MOTI6VAtBnQwwrU+s10NlUx+LKGdWzch+OpTNdtM77GIgPlfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7KbN3pVnROVq6KrEXLSPXfKOiQyvDrr5vOsym3TSVN4=;
 b=G72crbj7mOK1wSYeyy3MQ1fa9rwiVIVK3X/6BlOXenYfMPOVaKEdQLh+FRKe61MkIq1wMJRP3ug20/5Fu7KlWGD4WFBJAx+FDLFOFOSzCz+oj2yvUJQ2rIqJs3bfXwGiVyAhhAsLGXWMi0ZH7MPHsv9nbnUZxkN9Paq96ZoM5BaXikUSku7C+fnftsaNynikOCbC/cTcECNjLnPlFcay/QD8ctHUanDX3eD4ZBJpXy9RhUZS3C0+EPdtezuwGYuzTk4RbSbBXsKIvviQ2FAPBTqXNU+BEHuo0drlLY2PBsCo6AT2M0KDJhTTk3JJHe+I8851llUfyws6y+vxbw0jrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7KbN3pVnROVq6KrEXLSPXfKOiQyvDrr5vOsym3TSVN4=;
 b=ptIfPS74lpJl0MIGg8YX+2OMecmf2ZCooOHdKz0axbaTqzapn3oer3Acn/CRp0HKWg0ayE8vVbe0hMVxhncKXqz6op/jzyP73arPG+1F+biyee6SJucaq4rGpzQqbZcWLIse47RUJuate7NZxyyX5Z9SyzIGwKQFtTG0wmeW3WT5iYIS/jXzVC5O3JRp7fE3HRnc0edjgcLfRbOL9OXxEOMypMeExEUiGxUFnhiYqb8TYIzAZQDQDOzCKJZDstJlknPT1u01se/C3liFiqFopKfM0yC/EbFdYxxL3vRfACfAUO4NeTeLNP8abM1ghFG+i6G9AilZGj6gUfsUqBqofA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6628.namprd12.prod.outlook.com (2603:10b6:208:3a0::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Tue, 13 Jun
 2023 11:47:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 11:47:52 +0000
Date:   Tue, 13 Jun 2023 08:47:51 -0300
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
Subject: Re: [PATCH v7 7/9] vfio: Add helper to search vfio_device in a
 dev_set
Message-ID: <ZIhXZ3eQJfDkis+h@nvidia.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121515.79374-8-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0348.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6628:EE_
X-MS-Office365-Filtering-Correlation-Id: 6655c79a-81d5-41e6-fef3-08db6c040553
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K8YHZlB/lJ5/oUOV+4AOBHlr28PlTZ1Va/UnWGUfZKhqjXSFfVOs6hPhJ1GrspSsQBXLA8S1lwFgq4MMjU6XNQCwnUmivk973O7QXrqPmmXkKTFTFr0M0prB3CnSBZ3Iv102u8CP6JWBwD3JkwjBI6zVF9xMJOj30mzyyN6whySm5vTMBh39pRJnLcth+S6VLBMSfeM+pI54HsSRDr2y5y/4kl57JHSyfr2RLIidVupB6qUs6GLJcFyHc6Lq4zhN5yhD/MtDANG9Pc5uT/VdSw9z+NXseoRGuyPr70i4iQYN0AWHb6VRAGR0V55in5n1s8cdWy7hk+0F3RRb+9arX0US236ygJz3dBU5MPguHhkjyQVTVX7APnMqbZFG1NI6q93OQJz5ErQeKB1J8xNPSfw2opVhAOBdQ83cmtgGLglaGWu88UBVHLNzvQjm5GgB7WObbzo0+79oTOU/ApVh0Xyay3cL4EwtBACnaX0rtNnMeraQY/4Xlvo3Zji1GwbNOm4xEMy8Nf8AQKBdf5y/6U7pf2QoK6Uh/lD8B6J59/u4rh/tqVgzcUXBr7D+sNb3D6WgU2s3FJUym1WIJ1pZ1V3Zjs0vwJYWp4OWW+RSt+M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(451199021)(86362001)(4744005)(2906002)(36756003)(7416002)(2616005)(38100700002)(6486002)(83380400001)(186003)(6506007)(26005)(6512007)(478600001)(66476007)(6916009)(66946007)(66556008)(4326008)(8936002)(8676002)(316002)(5660300002)(41300700001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tpqg78MudL2iQlbgMPUYHO+569+pDeG3bWrSdeoa+icK9lR/4h9/Elb57EEi?=
 =?us-ascii?Q?oWyUoAF4wkPkXV2WIpE2uUAy4vdwwCHz5gx/yrEwH5v+gKTUDICm+ydqQUUe?=
 =?us-ascii?Q?Yi5GviFCioQBFYWGuLlMOO1fjtHNSHaDEMvYzZ1iPYSaCMVURVcP/umyYIKT?=
 =?us-ascii?Q?6NSxFAdNp+bknZdKSfuDn3cAj3spxEM2EF9E+tgpPtwJwzlzPefmYfMjrVgL?=
 =?us-ascii?Q?GGx5bZDlOe9Wy0B5VUF7upwK1PSMGFmN44bcjjm1fwk4SqP37/kva2nY4pxV?=
 =?us-ascii?Q?O9IdoAppQC06kEU/U5cgh5OVVvL0BPqUKpvFinAzU+kwdjEtbUUWEXGOJC1c?=
 =?us-ascii?Q?yRKsSq18uSTQKq981pLuH71hxqZMIcvdQojSi8+stsRRhv2hGsYWDMIyDLen?=
 =?us-ascii?Q?Vh2arIjDgPmlBGLsskJkNdNBhTI9Fq0JofzRpQHl3GoKNISe1cTcLfRLeCiH?=
 =?us-ascii?Q?skjo9SrB5ujhuYv6bncEJgEuMpDaEpXiZ4POScqsKEfx39h0Qnf3giTyTlDa?=
 =?us-ascii?Q?i8qVXrMsazEvufrdQ7aa6ikO+rUVw9/pFhjqllwCUXPBTb2CWHsU4diZacCv?=
 =?us-ascii?Q?7ovCtoV1gtHyfdWO7mIlzKp4fbdzeVeaZteC9Frt11iykjCiBuOHMBxDMgal?=
 =?us-ascii?Q?C9rZyucQ7pdmYPcUqn3878ElIouBRcyn2N8heHaXQfom7j6UbgZC0QBSDDZG?=
 =?us-ascii?Q?g83lXQxv1tW1FyMqatXQEw3JuQ0LWX0L4DwA3he4j2HdJ/vxRYBu/0geQYvP?=
 =?us-ascii?Q?dorQ2wonpsrVCX7U+M5QJPC92+T7ikmOaMjmYNiqnW58HGLAbcFVWMMG29Fb?=
 =?us-ascii?Q?r6iSKJQgk0EUshHtxBu6eELvxQ2dUlIS4qHR6/+r7YyMw0n4r9w3ZhcB5q+l?=
 =?us-ascii?Q?Pnhg7v6BsEzSuD2A5OvqtOYBKIUS3pBHk9PNdn3PbnzlTG9Tsp2Ji/jFyzI6?=
 =?us-ascii?Q?Z1x97kdf7YGIxGuF4241cYbnDvXRwPLyRqwA4ewy5HXFzl1NI8AVzijkF5ck?=
 =?us-ascii?Q?fQFTPMNPe96H4uqbAger+ObVrC9lT9tQH3S9koLQuYsdmN8gZ5ETinjyP8E/?=
 =?us-ascii?Q?J1b6Ve1rvyT2Sh12MbDhimjDK8Ki4kbQuRS3awdGWwwDHOpw9qk2/CFJZg/h?=
 =?us-ascii?Q?c/Hkqqu/oZ8Bx5INsw3Z8laWV6Rr7fEgLF2jE4uLORkJrkry1FUhFVt9YoNP?=
 =?us-ascii?Q?GMFqqnc3FL9JvHHQbMFxt3XD9J9Xo9QKviQKHqdT/0Y7d3V+nfcLsbIVq1Tk?=
 =?us-ascii?Q?w0EIh0tEu1cWtM1O+lHedicj8xCxRofkFV2pjFG5XuLKQtIVs/lezYWcf8nf?=
 =?us-ascii?Q?bRRFAQxnlK6zLKGVmj3kOc7vzqTbXEFReUyXsyIPaKAXgh26xsjyBiup/nHY?=
 =?us-ascii?Q?+tL6CdVYn5VaRw5c0bMGUVhKwuwQsmljanHNF4NC9saCekJigvkwtFANJI2u?=
 =?us-ascii?Q?JXbc0sn6SK3lAyCfPdc/mHZsO5vdhP2SpFny1sg8qUenUzc7p70slNLpbrKF?=
 =?us-ascii?Q?FaOEkDs2Lx+Z8Gtuql+kzviH9eIulf0oSQ8D7QD/Ugzc9ao3KRZYj4umexRk?=
 =?us-ascii?Q?mNcIJEhyr9o2pfbSqvDfW3qC2kyZGuDmIxQopVD1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6655c79a-81d5-41e6-fef3-08db6c040553
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 11:47:52.9240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyKSMEZX2EppCJaZUCiQ00ZwqVuhxNuUMCW8fGupoef5DZ8Hys0NXElpLuNJbTL5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6628
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

On Fri, Jun 02, 2023 at 05:15:13AM -0700, Yi Liu wrote:
> There are drivers that need to search vfio_device within a given dev_set.
> e.g. vfio-pci. So add a helper.
> 
> vfio_pci_is_device_in_set() now returns -EBUSY in commit a882c16a2b7e
> ("vfio/pci: Change vfio_pci_try_bus_reset() to use the dev_set") where
> it was trying to preserve the return of vfio_pci_try_zap_and_vma_lock_cb().
> However, it makes more sense to return -ENODEV.
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c |  6 +-----
>  drivers/vfio/vfio_main.c         | 15 +++++++++++++++
>  include/linux/vfio.h             |  3 +++
>  3 files changed, 19 insertions(+), 5 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
