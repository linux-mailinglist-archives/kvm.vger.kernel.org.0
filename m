Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5B773A4B5
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 17:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjFVPWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 11:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbjFVPWN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 11:22:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3271FD2;
        Thu, 22 Jun 2023 08:22:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAiTX4UI1j3669kzF2gj3tKN+QGXjqBUxgVPq6kUyTphKSyknuFi5+HSUnEmcdtsMmirn/BoQIolaVW/WaCs17VGd8OiEAZrSK9FiC7HIeSYZxTyit5juQxgWlyfHN589yxm/lxZBHLF1KG10mC4xsvwsfJg2wX53vs7Zxv20XoEBzZqwa4LKe3UKIQfriMBfCT7HGLxUC4w2U0D9zoX35RvMpHvvZtmmqJ+mDr8JslcwLcc4CU2amlI72wJvrA+rB+RJoHMfXdb+j5sF1yjdriY3rda5tDQfCM2er5sAhgJ+zS2ddx6FrQiasVsCLMEQonsRXf6M+krOLwKyzRg1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PSyyYMV8Qt3yyJHY6MecavTMkvU7xyACdUAnFaaruOw=;
 b=RTtsXKIWn70Dx8PSmJuppINDBwRnsTMqkbPmLy2/X+8R0U01Xa2eQ9SwfEDCgnl0H23G/oSxPNMnuhKEmpdwLziWtGRVEgLUGV62CTcPZgTftiuEiunpKCV7XJstvENAnRqSycCnZhBhse745g7348f19rv503DVcsHlRQcNzQglPUDYh//k/4MIWUIXP/YmiTlVt2aMe37ktAylU8pSRBqZ4RDt6c84u3Yr57+qOgEswnYyPX316xoapnx7vPa+fYFfwYmFKfsLrBM0dbf3aqcggvRqOKj6eIgeLM0gZOmh1vF5NmwQ1oH7lp5bK0YzsSKQoJVZcrjTcBVxDKA0wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PSyyYMV8Qt3yyJHY6MecavTMkvU7xyACdUAnFaaruOw=;
 b=jYJqYRdgq56tAk1em/6H6hR4Or1pdlX5Jd4gIIwp7WbzyVGjFLvglaPnO/Q55QWkEl+VSskb2fEVdd9O+4gV0yVKw9pxhIRJyDcgHEPDXphgsIyXHhxbXe2gks0amXaFjx0ivy9/I+sblnHk8TL71c1rVUhrFW39QFfiSRLZg6I87z5Urf8wkvie/WnOx+lVCyezMb1R/1/o3hGX1Ox+oPvzF5BzbvOaZ74mOTV0jOoh8UAt1+rfDiYpz5FAEC3r9spkRGQiQ7r6HM1jow1nHPUo40xH0QFqe/ja05acP0M+pUavRcAcAeXKg39ss/V2ezVi5FD8StbeErpKGeP/Lg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4505.namprd12.prod.outlook.com (2603:10b6:303:5a::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 22 Jun
 2023 15:22:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Thu, 22 Jun 2023
 15:22:07 +0000
Date:   Thu, 22 Jun 2023 12:22:04 -0300
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
Subject: Re: [PATCH v8 08/10] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Message-ID: <ZJRnHO0p+pPgBZdr@nvidia.com>
References: <20230616093042.65094-1-yi.l.liu@intel.com>
 <20230616093042.65094-9-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616093042.65094-9-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR05CA0086.namprd05.prod.outlook.com
 (2603:10b6:a03:332::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4505:EE_
X-MS-Office365-Filtering-Correlation-Id: f126cb1a-2dd9-45c3-4590-08db733470ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w2RumfsEAmAghMFsudr+/3SXK0R2IwC4tawhY2p6gzWxbkC8PM3WK5Ug6sl3ia1HCoS1tMeh7OEp75eOn70U7fV1soFL4cHBHSxFHPcuBIBHcemJrueKING4nbWgPRj8F4Q4vl9YZZI0uW/WOmykz8mcvs/ltHOD4x7w6ssnYvh7kzwHbVj3vMJHhv0YdF1B8W0qsVxEzFfcwOB/H8NGf4I5Z3mzUpx291CUBFbnq/M/gtZ9POPA0Y0oY+w0+zBaq17HMkYq/7ul38InPigtlp/82IId3nbR3eMgbEZTOC/MvVoqbKVFdM1LoE4zumzQAj1IDtSvuPXOzkizEjwAqCi28SPszKplNXSFOfOcJWzO32HcQWYOsTYStwOwurlQOP2vig37QlO0/6V+ckZdg95sxdM/QkdgYHOm/h8wgu+tcneXNxx9wXF54B95qOAEHqtKlwvasSWhj+Ni9mhhzTY+DVG5bsyn5nimUzHLk68SzKXWzoKurZLmetn4zAX3Hykp9nEGIUAqD/tRlSX6AVhGOOmEXKadz9T9OgfnFquIAQxL7n8pG0au24CeN/LlyU/xXDzcpUfTy4usDg2+ePHp8iWK/vbvxRbQE03MyXI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199021)(38100700002)(86362001)(316002)(2616005)(66556008)(66476007)(6916009)(8676002)(41300700001)(8936002)(66946007)(4326008)(7416002)(83380400001)(5660300002)(6506007)(6486002)(6666004)(478600001)(26005)(6512007)(186003)(36756003)(2906002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rCKwYx/QE93rkM/AURpqCnTTVv8JNr9EZPNNMq5/Hv6T40ERvk+z0eZaaNNG?=
 =?us-ascii?Q?3BvamjZEuctoUADslJui937VFFotxFBW9VnkUu0iCaR9RRxscdLIc+mp/9BK?=
 =?us-ascii?Q?ax/4BzPnutkTVtu4koThDaw2E8rjJrlZEWEAB0qbk1Ewh8Qj+917JJs/d8BY?=
 =?us-ascii?Q?k8ckkBfO4wkXEFp/EtntVI+5DHfj6/E6aEKNl+sl568Wo6WgrKF3EIKakT6H?=
 =?us-ascii?Q?F+5ahcPsPmGdjZPax5iyjnI1IGEiOS7SIyrIvFIcTZ+Aop9ZIjI2P6GsyGgS?=
 =?us-ascii?Q?P/bVejVyYqSjHxv68jsmge05LLldO4c2sxaPGui6RwACa7O26G9OdG2dBf7e?=
 =?us-ascii?Q?hefQP0S4d9U1WATToGjtehbLwaWj0x6dndL8EnQai2cDWUBAYu7q8l94PomG?=
 =?us-ascii?Q?XFNt/8uysmCu7fLCdcnBxnOZhh1r/jBv/NhHINPPQfJKEHy7ETrw5yhs2X4e?=
 =?us-ascii?Q?H+m2oYs7LAdTmo4OjVpnCrdZ8BQhjfc6ngw8W/q7Dkl0GvIkL93+ADHq6yL6?=
 =?us-ascii?Q?YEz+MCSW02w1xW+JmweIUm0lYxVtYBWrEgaBLu2Lcm5VF9+AfAdn/OO+2u3j?=
 =?us-ascii?Q?Y25C+Jr0WPv/dmBHsPGWi96NObxlXLymF17wQ6/83/tG6OYEWt4eOy71Y6Ti?=
 =?us-ascii?Q?sJeOmjEFuQDnWiWMPksvpxmGXT5haluncJ89Pv6I4EuQcTHTfLhMCuu+Ipc5?=
 =?us-ascii?Q?cLRJnR8A/6UEQu2bCjDE0rS/hWrvAfTX4j7ednOgvFJtg8x4seyf8CaHpw2/?=
 =?us-ascii?Q?/rVJ24YLuiZAvC29CYvD7mZK2Zjss15mNIDnKUFXpuOvnuZ74KFJxG2QBdNC?=
 =?us-ascii?Q?5JCrj6J/WWcoyquYP+R3KHepYIMlQWO17DmqJv31wJMG6c8IPAZsHPBxKcgG?=
 =?us-ascii?Q?YdsdBmZ80NOtibUn/c3w9ONQd5PHrEW8Zb+oDfcVP8L23KOXFaBjYyBJojze?=
 =?us-ascii?Q?fW/wqJ8xWvxJfGjM6JPrBVJKAGCzSXw+o2LDOooxUrrII7MdL5yLjlEoFFX3?=
 =?us-ascii?Q?cZVo7HQkeleADQZTPrllCMRK6Spnh/rzIfxHgUIQuueC5Ax31OPSXN717EuV?=
 =?us-ascii?Q?tgB51sgAT9G/tlGAabnESIytkwyNHqHmHDEVEGjwT1v93zo3iXg+fEC5nJp0?=
 =?us-ascii?Q?PqIbAi9PNhy9381H7Z/g+5DiJ3/9Bas7st6wD73xuxvmjGBhskDGbfb/1r2l?=
 =?us-ascii?Q?RM0UmtUdLTq68NWQ68LCd85KjtYchl8MILSdwYespC8iddX1Hzl0ZlqvCJiU?=
 =?us-ascii?Q?nSx/Oypo74ZuN5VXMErvrFLdgATP5Vrxn7JtcrFQ3heql86uB8kIT4lpUizB?=
 =?us-ascii?Q?im0gXKjsBlQHPNvhWV9IG+l68HUjwWLlmHOgAoiYD7X0pcMdSsmLcZTRIteR?=
 =?us-ascii?Q?HkazSWtZV6zI2swrZDUyhv4w1ugJq9F3QnVsJzZbBZMLqze21rY+ooiKPDQr?=
 =?us-ascii?Q?95ZzNWr4vVEaSz43Fb2sCXIzFqTKSEXsUCp6nPNa2p4YzEoztYFisVHvMf2G?=
 =?us-ascii?Q?FlEUpZShI1y6BoaQV2Q3b8WzjcMjvJreNOXmEEgYdRGd6KzsaUEg3M3XSTTF?=
 =?us-ascii?Q?mOMF97JanwlnfzzWSWrKE9VOW5mC4XRuKUvWLEOV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f126cb1a-2dd9-45c3-4590-08db733470ae
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 15:22:07.0961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WzBTZEMfMmURCulwy+waT691VAGABUD94PGJx94YYC2ACBqvjuEHKkocu4rlteHF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4505
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 02:30:40AM -0700, Yi Liu wrote:
> This allows VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl use the iommufd_ctx
> of the cdev device to check the ownership of the other affected devices.
> 
> When VFIO_DEVICE_GET_PCI_HOT_RESET_INFO is called on an IOMMUFD managed
> device, the new flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is reported to indicate
> the values returned are IOMMUFD devids rather than group IDs as used when
> accessing vfio devices through the conventional vfio group interface.
> Additionally the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED will be reported
> in this mode if all of the devices affected by the hot-reset are owned by
> either virtue of being directly bound to the same iommufd context as the
> calling device, or implicitly owned via a shared IOMMU group.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/iommufd.c           | 44 ++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_core.c | 54 +++++++++++++++++++++++++++-----
>  include/linux/vfio.h             | 14 +++++++++
>  include/uapi/linux/vfio.h        | 50 ++++++++++++++++++++++++++++-
>  4 files changed, 154 insertions(+), 8 deletions(-)

I would have put patch 9 before this one, but it is OK this way too

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
