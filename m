Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8746D1382
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjC3XpH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbjC3XpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:45:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B364AC148;
        Thu, 30 Mar 2023 16:45:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WqfCkFqn0Q+4XP7QTRe7mw3ZcIjmp0JUIWJ7tkNxPMrCBXZo3Mxd3eoVUPzVmSyG0cMBjRK4+jthlax5Uh3J2scpNp7x5voMjIE6drkSB4+bXPxeNqe37zI/MUrBqwHIE/vBsuD+/YUy8dji95/6fM2wvxaXy+EW8Fv/0FN/4vAQt7YvqTmYP0O4I0u/TGr+MiqsrBu8AMf2DVUBJ/VaKqfgbPOosnJtEr6QRhaYRBXd6zO8ZhNqh3RrO1U6wI04XC11NhcGoc0ppTc2JPevGEcwsJCSJoUa2PkoCm4NpH9eQDPLVsz4Zqy72oxXELWZ7iQIs/soEn12jqGyOwmbqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQthBn0Qt9O+d4lzAGvfu+8BHZcTlM6ClEknMKou9ms=;
 b=iGqslW2XXPgw08xW2DVhBDBQJkUztVwP9Cd2t4sHBmRoTbjG2oypwvl+q7y55I6U1TE8ZBfASJhJI16b/GMD0+1w1P6Kx2oUmWRuHAoAG3ieSUzjPD349Z8Q2+crJpVaq3foGPWz155E0ESJsO+sybiQD+K/Y7iYadhj9/4NAKeJ4w38yt/Fys79dd1AX7dPgdoHrPr1w7TJeU5Abv783xXBM++k2O7O0qXoYa67CDPn0Gpxd+/NYHEp6ra09YE3g/1eLdsGc0Wlgt8W4c7cfwC/ZrNpG2+J4KRDw7YwfNgJjdU3o+6TL0cqIsSMMD1PMDz6IDFE7ga82N+jy4uyeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQthBn0Qt9O+d4lzAGvfu+8BHZcTlM6ClEknMKou9ms=;
 b=nzOn8fq2awKMEpDHgSuA99KwNSRoO/3A00c6S1YEr6ukW7m9exwjR45azKol9MV7pU6CYkDvtvUtgtJCrulyv8eU2oh9pcyKIQ7ydlKSueYtVmtC80+3FLcqEw6GKvbgkez5EC9vDwwLu+TzM43mlQ/UKCf2mnnXlJnkotX0eS14hoZIzb2+fWbEqlrzZYIqJc683mQBCqCVHu+cbWPcvsC+/nB1uPQL/opx8It6oOlm+1BHT4lHUgKA/iamYwHyO65q5rEbFbCJOROC7lIRshXVAhXjrr6Jct0zJ+9L4r7axJCxLJRdijWde9tqkNFvO5CihBBTnr2Ofqv3K58UsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB7822.namprd12.prod.outlook.com (2603:10b6:a03:4ca::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 23:45:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 23:45:00 +0000
Date:   Thu, 30 Mar 2023 20:44:59 -0300
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
        yanting.jiang@intel.com
Subject: Re: [PATCH v2 04/10] vfio-iommufd: Add helper to retrieve
 iommufd_ctx and devid for vfio_device
Message-ID: <ZCYe+7oaXHkvjzxp@nvidia.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
 <20230327093458.44939-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327093458.44939-5-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR11CA0022.namprd11.prod.outlook.com
 (2603:10b6:208:23b::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB7822:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d5be989-8329-4249-b971-08db3178c6c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qTmvB4p1PVroIFYwibYoEAEZEC6GGz4Gtp8w+IWvfTm+BqzcM1pPXzYokx8JDtVKuBGitVBDeGOT8eOsIVEH95dyKy1bi/quBQdaHBLIEGkttLixeX8+/T0niqZsBP+gvi+BsnDO55RtCmTd678MnpvjgrJdHjAwCe5oKxDVWVMyQan3aRYmnAJE94qmSETCtCcXZfc7dx7/OGiCjDND3CkruAr/MdVYbWz5mqo2FIhObx918jbkG9rWY7oa+Lnr2H6lIZuJs3umv+WR5eVGDwEuGHa6684Nz6kej6epSnC8aQrJTE2/9hH66+d4pMUXdYII4ns5EiiX1Rj6zwS2Y5JAuW8XebesXrpj4VvMIAGCb1VwJdTukMkZ57Yz9PV5iCEhaaqZzDl1ngTpXbL3VkRCsYhmpyADEL30vyvxXdsCoX4tbzWhF+5ld2f0/wE+07txxyL97rcfG+D/huHdvZmHj+DAwiF2pCZcnqhQO5CuyScZ37V0YUd+rxkEH0vE2h58f2AnyGMMJbpaBL6aH6VTbs2ga7VIflZB89WbqgoQ8bEkq1mM4lU80Tz/79Jd1tBjHcaCpSo1wTNtLW9NUNZe0mkP3WKWJdbY1pJnqc4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(376002)(396003)(136003)(451199021)(6486002)(186003)(478600001)(66946007)(66476007)(316002)(8676002)(4326008)(66556008)(6916009)(26005)(2616005)(6512007)(6506007)(7416002)(41300700001)(4744005)(5660300002)(2906002)(38100700002)(8936002)(86362001)(36756003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iURdQ49KZKt1iihY1qvA6amO/ZBoQDqoOZPAF5m5bNaIWT0+SURhSZSVT6U1?=
 =?us-ascii?Q?j0k599E0PpPHXIG9MiOz8rx/2qKXbpbknZJvcNQ96ot1F/hsuwiDRANGuiII?=
 =?us-ascii?Q?Tp5QXEx0zwx/2fg9iIy8EYsMUxwWWVNhytukzVAblItgiQUYqD5eOC4TFKUq?=
 =?us-ascii?Q?t03SkP0boMiN3PoK9W2i/o75+cgxGsV/ttqm0whanw5cRCg9cgLTG9H4pbNz?=
 =?us-ascii?Q?668vYAzTqrIbzusMBo3fwjIkIUm38lsxYx+s88bRQMJmAMZ0GpOJoysRBtJS?=
 =?us-ascii?Q?HRxUXInKTlrlA4DdiSkUdZD9JlEEGP3ATlLtEGh9hhN3zab7XvCMeRwGwFgz?=
 =?us-ascii?Q?YUui5mWsot/XnKOS4yK2Gk+wxpDn3Fs/QJjZozboT2+2oUWjEhpmrPl2xR3c?=
 =?us-ascii?Q?ulxiKFApmyh9EX9zftASTKC9fJHknB8v382O/tzIVeeZrPIKFbmhYXO7UcXY?=
 =?us-ascii?Q?srpnE9NQlHr7embbt/m08x3UvBHwSmOzfmcWnnCEB4KQquCQJuf8hKg97xCF?=
 =?us-ascii?Q?TXt7Cg3brXF/J/8Sk37pb4JGOXuHl7OgO6JuHDu7UQ/dABYxTJlK0iWacia2?=
 =?us-ascii?Q?p+aKCTiIBH6bDObQ7q+xf0RWNzID3r2PRVeFUNX5JHAFSHG/uZ0DrMNaLris?=
 =?us-ascii?Q?SA+pFzl858lJvxOIK8G7jtBXKvCZsghBCXCR4RHmiSwDRd6dSwqb0V98r+fk?=
 =?us-ascii?Q?cETux0/mDBVYyFC5FVZ4bKPuaxREiFXjaCSbxGxIS9s4EYRck8UEBrlnsNPu?=
 =?us-ascii?Q?MR4HTl+oBJYkZhbwXGCZqEaMYZLDAbxms67W+POpU06GxySEHWhrDQjVjlL3?=
 =?us-ascii?Q?B+dvK51rdSI+JrfLd/M1qnGUnLlCtKTcF/N3Akr4F5w/npLrfG5VducbZGhD?=
 =?us-ascii?Q?CvpEVK4bED/WHNDWKTrwJKL9yeN4rIbQNu3AwxOwi6UKPCSayPL0TtBnHOTC?=
 =?us-ascii?Q?f5mwcdeI7eqclT5N9X1iBLH9i/pF25nV63wNTK6VEWAb6x0pUMcPxEyTcHZs?=
 =?us-ascii?Q?LGh/3bqbUjAqoZUnrzCsxtgRD32YPKhsv3WyomK0PvJaCaWExYTjVei2X6Dm?=
 =?us-ascii?Q?rf3/fa4warR9paYVzCQ9Jph3rRC7KpOxFZB0baRgQLexx8NUQRUQZcwIgP0I?=
 =?us-ascii?Q?yqLRVMXKJ3YQpx90INxF2NrhNE69lz+F9wVc7/+vxGsHv1B7oYwh7qTZ9Z6/?=
 =?us-ascii?Q?xMud5AHQ8ZrXxacttzeoVij2LfX/96HbGKGQKRICqbOngKsR90l+VSHxPuOX?=
 =?us-ascii?Q?Tfjq82uIKv4VAsoFdghlIhN9co2IHuKOnwKXfRmhQo63jTSnKQJDxWXRCJeH?=
 =?us-ascii?Q?BwsXazDhD5dLKhUiltiF1+4/knG+3CxTC64NPpGAFl4pADl5uBJZNz8HYWAZ?=
 =?us-ascii?Q?6/T/5J3F430yh1d6upQUKO8hj0xsYq3Lq7Xwz43DZFZ1RQq9dcjEYWoqGmzG?=
 =?us-ascii?Q?fIfziX4KhvCZB6K2wO4G1rCM0PXxcZEpdRaKTj8FQD2lfKszzhpNdfoEe3RR?=
 =?us-ascii?Q?u5dNaE3ffc6uWrnKM+Nw+q1Nzvx6/MZn693qcZr97vkA/nFuK0UCLzHw0XD3?=
 =?us-ascii?Q?TNie231jxVR2dwL3a5H7FdoXgduQOHMSaDsB1utm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d5be989-8329-4249-b971-08db3178c6c0
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:45:00.4818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5TKSxd+6ZhdU/ypWKKAR6ERyCdqCl+q6vfa33TbvcFTK76P0I15NO7pMyrnFSxVg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7822
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:34:52AM -0700, Yi Liu wrote:
> This is needed by the vfio pci driver to report affected devices in the
> hot reset for a given device.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/device.c | 12 ++++++++++++
>  drivers/vfio/iommufd.c         | 16 ++++++++++++++++
>  include/linux/iommufd.h        |  3 +++
>  include/linux/vfio.h           | 13 +++++++++++++
>  4 files changed, 44 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
