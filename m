Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA166CED71
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 17:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjC2Puj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 11:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjC2Pu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 11:50:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2067.outbound.protection.outlook.com [40.107.223.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6285588;
        Wed, 29 Mar 2023 08:50:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6t9uA/MNn4SiiBX6L1M/0EthIDkzhyRFeYiHy/srnTTIKo2H/x3391Wq3sQ0uTjtzprlTUJBOSOzdNbgrYci8z97MC9wZDOq6PCXCC8Yekg31KUhlex5QKPIp8jAti4Naudgc5lPqXfv/J7XkLEvObkt9eFK8/Y84PDnMcEP+PCY2xFJGOUFxq7CcaFj4kJy2pKc4/buHbGr2I4oU/xTvOX8m2bLL44BG6i3r4WlkO6I7crH3u7COXmiCU3LOBGISt+FwVVXanliCgt4DrAqNKWoQRr2Y6CnrmYJIfzZI6mAqr1yw4lBRBRMt5KDTexkmyiCanU88KbzCaw5Db5uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPOLYbEqcYDsEOTSRJtYfUZlmjD1Sb3sZ4dnIovUxno=;
 b=HiOP+IbCNmlS8SO/ES2r0BxZwjtMTxw4CuD5HryXhpiclOEAMRcvUEuLP1jWI1dY1uMkEig+t4/l11t+FnG2Yas3AXtOaG73AjssUQh7thjwJ2IqfbtabR6kcsyhMMa/NQmLnXy+MX94CocbvnyxgPkX9tJL/ue4c7tnYH4vtfLv1mUMTmRQrT7Vjxnk7XUtmZ0UNF/DBvRskYK4E8iEg+RmevZAMGm3v0+pNLbO/EiecFmHN12awhkef0XPWT8B0gb0/tdDj3IDwCVvVspPDRq+4btwRsvOz9YjmnvQe21xHcJ6pPl6j41dPNt9TKnQiSfjr2YqLHntibdNmvMxnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPOLYbEqcYDsEOTSRJtYfUZlmjD1Sb3sZ4dnIovUxno=;
 b=sadJg+dhCFlPEKQsc2oM4yULSPTy2N6Z95Zj5aLw7h8cgwTtUJyrhC9zRHZR0FSj2+6c9P5yhxjRX8Yx4moKoSzCoFCTgns+m91IknlcXl9SLBo1CfCDalriP+arvEcbug1IMkCoIeYW1vWEDDuasMg30AvDBV6sEOGABmSD/OoJCT4wy2XpNLn5JuPfC/H8g/iaxsxpGtYXBX+9I3zZoEIq/DOxciWucw1OMxr/eJFAWP/x6ukmVse0SQhf7vFq4j1xbB68lpOZw832aUOxl/gHIqxG9/VOkLj/r3o3UFmAAzsJv3/ySPiLfWmmZ9tIQeTqCx8ARrgLJ7rOrXuswg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4433.namprd12.prod.outlook.com (2603:10b6:5:2a1::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 15:50:21 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Wed, 29 Mar 2023
 15:50:21 +0000
Date:   Wed, 29 Mar 2023 12:50:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <ZCReOXsLsuS/J8TC@nvidia.com>
References: <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20230328082536.5400da67.alex.williamson@redhat.com>
 <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328084616.3361a293.alex.williamson@redhat.com>
 <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328091801.13de042a.alex.williamson@redhat.com>
 <DS0PR11MB752903CE3D5906FE21146364C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328100027.3b843b91.alex.williamson@redhat.com>
 <DS0PR11MB7529C12E086DAB619FF9AFF0C3899@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52762E789B9C1D8021F54ECC8C899@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SJ0P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4433:EE_
X-MS-Office365-Filtering-Correlation-Id: a5e294c9-7686-45e6-6f5b-08db306d4d1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Alv3mWsTeVDK/GwdsQQKl+/lDloat07TWcp5obHTOdmb9ixefXvTXZQ73ew7av1sJUNtCalmAUzVDd2XyFOoExXx4xa4yqs6HUCcxhXQFt6dURIEb7MFsHEqlNFYEvtYRJQaelbiDWkm6Xi5xbQk92Ginbqhq4C1Jcar0AciodK98ODkkf9CFj5qdct4HAET6wYo6ZcxvgBwbjK0aJILyjIgHuN5pNpr0ylMmFSdeqZIxwOSYg5dlaGdDGY+RJiq7xwhk0mXUhT5cZi8ke81/90/kIprtd+IE0cahCiW6xHfvERA2zyObUkVB/yv9deXuNNIeml8pco8miVda2BzZNR7+Mpw+QbMz1HRBs5WudmGiAiAuV3uFQQatr6MOQbDE20m2uHWQqvqpv0GFFpWzuKFjHHEP4Cb0gd04b4rDiNDYCgR5ttLw/eb1SUJE+L+G5Yiz5/SM3LdYgLDfY2QbFKlBb9lfQIxmFeKUT1nQaT0rTrq2R7SQVLSLkpbDKZmm0qxaQq4VpPFehqpgDtVgznbVqfQui2VYlbtNkpBv6Y7PDg31rJrKVnBwhvOwfpI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(451199021)(26005)(6666004)(38100700002)(6486002)(478600001)(2616005)(186003)(4744005)(8936002)(2906002)(5660300002)(6506007)(7416002)(36756003)(54906003)(316002)(41300700001)(6512007)(4326008)(6916009)(86362001)(66476007)(66946007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hgJLnwuCi3cbm9qf4Tif6dMaC/YcW5NdVfUdi28vQBw+tSRPwUzmPwOaIU8E?=
 =?us-ascii?Q?NZnVfJXZjYKd+MWqvMhleUkDa7nCgHVtw3pIzlvWDPeytxK1QLMKRveK5DYi?=
 =?us-ascii?Q?Qz2NxGkXgarfLtWyt7U9gc+d+oYOh+qw7TjXj6JpZVqX86YRvbNEIYQP4raq?=
 =?us-ascii?Q?x/0OIHCLTMw7LwChjQ6qIsTKea74rt/CbiClzF38XqHRIwYfmNR7m3QUDwFw?=
 =?us-ascii?Q?R5onLZbmGYQGgBpW46PzJfJt4zdIQb9UYv7LA9AqwUE7CxbRlKE/zcze/RLF?=
 =?us-ascii?Q?FPHmcYyncnooHtd794pqRw/VCjeWQ+OQwAUe1EWzQvFb/vM/uGZv75w2St0W?=
 =?us-ascii?Q?Xy3sjmXIQWY+jzKxRKLStPkGnEYBnN+J3lnr7blOU+WYy0PXBe94TgKVVC4z?=
 =?us-ascii?Q?k0KMTluflQccH5j4a1MMsMY85fNgoMuH2Tmiv6F3DQCTVo6T8UtWlqMBtOgL?=
 =?us-ascii?Q?mM7ias9blYYl99YcDpRdZLlHs0DZtl0jeX+6I9bnVqXMPajm5OTp41/cK0+2?=
 =?us-ascii?Q?kP9Mtp7fni8LFpI2LbMZtxOUMyzneLBUWkunXae+IiaJew5jj8V1z3LyaqS/?=
 =?us-ascii?Q?u8ub//LY/GBaFPaSjMhuu9anCtHOdHYIC7pO9JwutnL5mspf3qNGtfzOcS66?=
 =?us-ascii?Q?788gdirGKotB3q1/C19l028sYzR4MYQgo6Eznj3ULeAzoUEKEGlkjCjcX7E2?=
 =?us-ascii?Q?M2pZKGlZ0SX/nwPR30QKZSBo5zJEn5jyJIOtXo/hm5EFZHnxirctRRc1ai6P?=
 =?us-ascii?Q?94F70XjtZzJXsZkR5oWT5j+iORYR1cFs9nhoo928hL4KSg9ksvUA8WzZwev1?=
 =?us-ascii?Q?Ay1xraGAbXdUL65GubwLVJ1cWfawWCw8bFdxnYnowbbj6USFd9NSSe/B/YT4?=
 =?us-ascii?Q?9U7YOLL71C+kzlNy5V9j82God496bTIWLu4A1h8Ec+cDruBIu1KqNyYjZDMx?=
 =?us-ascii?Q?EG6q+PUDtyrQSq65uTzDjBZH3Zkyh9fr5ktnu+bAbKtb9MvxSr7Xi+sd7dKA?=
 =?us-ascii?Q?XKjrC1ljAbACRoKq4aeOgHCpwLtZadyotMGxAi0nLRQYmIKagyS9A0XiDmPR?=
 =?us-ascii?Q?b4ugL64A3EKuK7rfyv7ViKEQXTtlv/QZ8oUPImCV90sJiyKuWYMjowHIWCN2?=
 =?us-ascii?Q?yWV8mhAlVe4EEz3t0PFVGlWTACuH5q1PpJG+IOAxFrjk6iQqXxpVpNzbBnyp?=
 =?us-ascii?Q?kfneiWWlUdfIoQwTPV8cntMKABdTc1lpq3zrkkJbX7jQlCLmNzd8E1RwwCQB?=
 =?us-ascii?Q?Ihx/UmhJAODoXW/tdPiBIiAf0IbLIdmAGMN5YwdGd+w8cGdqYzKYTNnfvDpW?=
 =?us-ascii?Q?zdU0jWpATCV4WmzMH9YPxAc5Dcza/qm129o/9nidFgZW7Uc7pm0tsDpl0Ptm?=
 =?us-ascii?Q?ZW/YLIuPSGEvQzm33Fz1pVyMqslafvLTGT0mzL5AE8LoAMqsw4eD2+dpFRoA?=
 =?us-ascii?Q?h9dXDFZg37O2RWJoC9d+Yjy7Q/90jBhqvDW+FrwTrVTzsDtvFaXcFiEYlBN5?=
 =?us-ascii?Q?Dc/t3s2jg/mlqC2G2n9UZc70WjNXxPjLVzH392y1FB3Vcyd+B69s0KNKcEWV?=
 =?us-ascii?Q?4dPLH8LcW7eWf35L/urUDpR82LYnKhm90vofyTcW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e294c9-7686-45e6-6f5b-08db306d4d1b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 15:50:20.8456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QUuPcfGBZlU9Fl+m3m7rrDK6r1hu05chkj7O3jMHKIhp3smm4Fna8b94Um/27Jpv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4433
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023 at 09:41:26AM +0000, Tian, Kevin wrote:

> We could extend bind_iommufd to return the group id or introduce a
> new ioctl to query it per dev_id.

> Once that is in place looks we don't need a new _INFO ioctl?

The iommu_group and the reset group are different things

The issue is processing the BDF strings, not the group ID.

Probably we should have some way for iommufd to report the group_id
from the dev_id?

Jason
