Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A416D13B3
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjC3Xuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbjC3XuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:50:18 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2047.outbound.protection.outlook.com [40.107.101.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F08CA31;
        Thu, 30 Mar 2023 16:50:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nv/cn+pLdcmtr4aVxuFBF2KtcrSmXnSogd8mVbRjv7KTqEuEiPtCj8RvVy1Bxl1dPJUx+NWlu89aonzTihstPzUN2Yv9MCNZ9YD54D5cdfGml9xVPVLDEQdt+G63NxSwp7wW6YkdBFqv1GDBpGLKEBqs3MMlcceGd12IB6Ecrq+p4ho31zOl3y3i+zqCeRlUtrIJWwOIsEqKFCoLN5j7l24mIbtUTTCVlS2VZCgoGopXfF1E777MHCGSBbZyZmjE1StSSPRIObThNLf6OHewr5+NvSu25twmsXNo10Gt5pUYuUx37EnXMEl1s295Sn4Q/qluvTY6bw6jn208Oa6bfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sXHTVDqduInQLz7/tTWJXWEUc6DVTs7FhvVB2ys8mGc=;
 b=blRbJuxAzlVjd/jO37MOxTXkse8pZukCLTHiEIIBAkLK1D3vhMRAUQpXk7EatzJ8Za/jwcAcTfE/vnCvkxfbJAr/8PM/zthOoKUQuR3djAMJ96/MOVm3mFm6EHzhIPFJt/IGWAwnrgOvGPoqACdsSVU3NmNp+/vNOLFNuNcavEzuVFpJCXzve/ZFQzSNgCivpG3B/QKY7XLnW3Rv7NBa1uhDYJmNE1SyF4FDUDMo0KZQtgMAPA7+hgpiG6aGyZdn+h8DN7o2SXPwR9VEkTb5MU95nCGS6voNEKD5yRPb/Mh4WpUDhpRcTX38BlxV0HkJCjmLlLQJCYbz8MHSqu6WEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXHTVDqduInQLz7/tTWJXWEUc6DVTs7FhvVB2ys8mGc=;
 b=AVwK8W0lzwxg8EHdJxF+4PNr1wrPH995V2NA+xsxot5HX0iOmZu7FCOf3MCh9h5YTZ4xxSe+PEU7+gGd5b9DrGqgfaTBGKD8d8wLVNJGOg2qGilXs7XSfOSjQRZID18zcgZAIm3kWnEQqG8v+f0j6lP5g9WSQGUbkdR+GK3DlNzh+RH1s1iUlvDG1DZ4BGjzGrE2amf1qrKqERiPCosCiRf++RwQ5nUCYRS3YHwLaCjVEAXopNxKSKF4GgrZ2FYV/AT+RIkNYgm23kJXdnDRBfc8MRoq8MKn1v1nT2KQ1yYlBiUUN8xDilZ323h5CDbcpEp2V2zTj2807bdG73n75w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7889.namprd12.prod.outlook.com (2603:10b6:510:27f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 23:50:01 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 23:50:01 +0000
Date:   Thu, 30 Mar 2023 20:50:00 -0300
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
Subject: Re: [PATCH v2 09/10] vfio/pci: Accept device fd in
 VFIO_DEVICE_PCI_HOT_RESET ioctl
Message-ID: <ZCYgKCxCo0wNKzAo@nvidia.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
 <20230327093458.44939-10-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327093458.44939-10-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR16CA0064.namprd16.prod.outlook.com
 (2603:10b6:208:234::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7889:EE_
X-MS-Office365-Filtering-Correlation-Id: 83980403-d9c6-4542-4d22-08db317979f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0zC1t6gOvE31fiuNHMMVhQiXkDW+XXsUPfryOc5bQwKIVzSTZ7HZltV8mTdF9dTFyRUHCymRpKdpH++5+ikhl2XYXFkRGGqJoMk2vAe8QWp6OPDpB0KGkM1E2U28U5bo0Lv2m4rstDPiJU0XdbqQujWavmsKzEQOFGTQshsI/WzT6k04rEOYLHSpbqflB2FIUzICCQbMQXiOeqbIP9q0sXhVaULTJEzzEMJjYeC/ccTUeLZbfuNePBvIRrdoba5koylNXTWEcWZ0WpTVq61wmGdS3DDQ+j5HzBj+L3nVgowKXG71pi+AT+JpSeb+AP233f8H1Sb06uVOgYdPVn+A1hqJ7P4UCSy7b/EgzoTho92YECCsAPbVyqRzoskjDF0c2HRYzW92OSXMEzjVa+xCcVYfCVn1+Q7v2XcD4stjY7fuoYnXy3T1QPNUfBrdc9X5RBWxITXJ4+7KBmXaL7UruQ3qwUPc5q9Abo1YmQTgBUUYIpP9/2UjlBh+HIR2NUJy7UvQJL6BlGX1eWpk25fMYl37uRq4nKT+cR6ur2A6rwC2KtvOyajcRtCCQMKNRVzS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(451199021)(83380400001)(8936002)(6486002)(2616005)(4744005)(7416002)(5660300002)(2906002)(38100700002)(36756003)(41300700001)(8676002)(6916009)(4326008)(186003)(66476007)(66946007)(66556008)(86362001)(6512007)(6506007)(26005)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zGMAnjXlwLsbxMRUcGMqK0HKinWhCYdjhLek9JXj7pWgCo9sn6EbbTdrhezW?=
 =?us-ascii?Q?ci6yNIg6jWng1QwXJUrHSaKV6LeoZNjH0gKAYqR6VQNnUdM/3PxCL5f+aHTB?=
 =?us-ascii?Q?iURlIvbRI/3347WgThGB5oPAfWQcfhHVBnHrHLE/e/l5w9ybdkizsrlkxANO?=
 =?us-ascii?Q?9/luW/f+g0jc/wM+J+wrmAYQeXmCaBkMI9/K/24pfyfzp7AqplinuHTQdF/t?=
 =?us-ascii?Q?MNLWLQD6gnMYPQHoInMKHClDNZOpKLH3wqIAtl4rdI7ku+FyNVJeCKpC93tZ?=
 =?us-ascii?Q?/7XFipoSIDzyh7MmmqcBMr1KXXysd/HJ6r9lDNanvNH966smPrawVRKBtX7z?=
 =?us-ascii?Q?CCsv8vAoL4XG3jczfD1l+CGA65/0R7xaEbBQZesOdoRzpAis2PCtBoK8iJPz?=
 =?us-ascii?Q?hmyBmteap3Ae7KQ1S3C0a+jm3tARyKl48DIfRIF9EMZ/QYISK6+l3JWrU+1T?=
 =?us-ascii?Q?pReulXCcrrf6UkfTA5O+gbQ+hwzLaY1tO5Ov40NbfpGdP3zcuxvl39p768Gw?=
 =?us-ascii?Q?JuixrJZQ7Ux/e/o67bdMrgO2dyFalX9lSfTC6qs00gFwCNTvH4Jv13jySASI?=
 =?us-ascii?Q?puVEi3+tKVGzqxIAAYFddNtO9+mtoxgVzkdXsm2xVnA+XJuW16wuF5xH5OKH?=
 =?us-ascii?Q?eolaV8t3mXdxfakgYBBBVQxqYZTvKaMxj2q8bwg1YHnFoHR3qDpSfT4ImuKa?=
 =?us-ascii?Q?5YVR6nX1mh195HHsdpVkbW0atKxCQQJW5FMJs43VLt16oNltHbPOlutTnk1Q?=
 =?us-ascii?Q?iDnpUh3GsZDKhTLvcr6wyws/6GBvrrXcBKwKqHzbR5Hy/cRG3F/xJ053TLUt?=
 =?us-ascii?Q?tCuDHZOjRlrfnFgPz0nPtP7aalJqQ7kNW+BfRGmnkr63GglR/7PDYZ2z6a2m?=
 =?us-ascii?Q?KaXFJXLITGTOQex3GWGGeiiJ2fhgthzmep0Sxu3M0A5qnvEzKw+boq5ilQJe?=
 =?us-ascii?Q?WxsL+EykISxFcgTgOjNrZMt/ICxpGOly7ffo/v5qOB0WE2lJJqGyUIfG8vOp?=
 =?us-ascii?Q?SyjcazKezxlg1kSUKa+o/3mg9yHBvyT9XGLU8fGvChzwVdyQqQcmRM/1DvBT?=
 =?us-ascii?Q?O90pCWM4i4VxFELj9n+Teqd0F3V8SrdDLCp8CMXgJirJ/W4gftFkFo8yNNgh?=
 =?us-ascii?Q?tzuqaD4yGuK51+oihL0NgBAtn58cbxVhgg9BdkxA977nMmCrPKlqRHJXT3/6?=
 =?us-ascii?Q?7sBgyoXMiz1KjHCSP52zGYWoY+T+xjXjipDNzwD2HS6YSqQHb0XPrCdqKRIK?=
 =?us-ascii?Q?Ad+Q1TGQuClYrh2S3LHSnPOKIPB1qlGMMZ7rJQo0Wpdrr5NIaQieiBhFtQx+?=
 =?us-ascii?Q?9VKyUNeeQdXCuaceofpl+FaQiEdyZ0RLQO9EO3ES3G31gbBFshc/4PeLXitb?=
 =?us-ascii?Q?gOpqI/5rqKuDQOdYakpJxLXp9cZ30vhER5kUXh/4ZiVdBHpXMgnwS66x32ts?=
 =?us-ascii?Q?So5TGAARv9wJL7CYfy7xZCecw1ecPxnIx6Iyl0LwDMTIy0g7VyBH1kw5iaTJ?=
 =?us-ascii?Q?0bq4YjQUtl65gRPHuDRGA8HfTSOshyEnXLu5ox9d3i/Mv4W/QAdqalnf0UCd?=
 =?us-ascii?Q?Coup7pd0eh6L7EVH2DyY/wh7DZPmx16MX3RHehSH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83980403-d9c6-4542-4d22-08db317979f6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:50:01.1451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dv9V/x/1V/5I30vT0M3IFZj+7KAv4key3EnMiwNmWQex7Kmsr7jggdbGU0WagZ0A
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7889
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:34:57AM -0700, Yi Liu wrote:
> Now user can also provide an array of device fds as a 3rd method to verify
> the reset ownership. It's not useful at this point when the device fds are
> acquired via group fds. But it's necessary when moving to device cdev which
> allows the user to directly acquire device fds by skipping group. In that
> case this method can be used as a last resort when the preferred iommufd
> verification doesn't work, e.g. in noiommu usages.
> 
> Clarify it in uAPI.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 9 +++++----
>  include/uapi/linux/vfio.h        | 3 ++-
>  2 files changed, 7 insertions(+), 5 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
