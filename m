Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71636AC091
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 14:17:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjCFNRJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 08:17:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjCFNRH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 08:17:07 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05117298DB;
        Mon,  6 Mar 2023 05:17:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bnqEEQgy68MV8/yt8zPfND2K+rr4y8t/GJV+f2InQDORTwohNu66DbSmSQuYh09TKnduDpEb/JH5YQ+uBvwb/DvuyLkASHVrWFZmfoTPIhsmIpRmilTXF/C5Qsbeb2PXrAJVTm6WeqC+DWMH32ZA2kPfqDAvYNU82bkactERdjTxAxvFUs9HBnc5r1UZpi4s2aLK+HGqdYtG8K3cwC3JMBqxEoE9q/0wuZxXa0yKMvGERgt1x4jNSPSWu/LtW7ndQPqZuEOZkIF1ysvmB0uJzy97kKqDmHJ7mJVh7/lSsntqT0UNxGbGJQzKAns1uDMMHXt2Gk7YDuv8cLVuebvTQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIkuzPIqMYM8Efea3N18y2GsLOOVbGeYabgh1y3dFEk=;
 b=V3g05fBSP0l4s3DRcucAJkAW96QrO/6mIrJduTcezzvoE84iBpb3u5KZ384MYY0Mhye0OlxsoUDBqcGX1RyJbGOhPEFJrFv9sgjl8FPDLVtIVM77znadYLVgl3dOHtVmZGiKXsumkuSRQjJl8kKdxy29a9H7a+pY5gGVxDo3gJzarJtrPH7ZEYmK755HpeZYYK+E3uZyS0L2raD0liHw1a+F9ZJ9ivXYXWjKTk+ur7rDKJQL97Yn2zhsJOUSxNpuH7Hs09+n9vNx6QVtU0R2RFZ8LK8yItMFGGx1m1EEK23J6U9ISxm3UWvxWYoXmYiF6LAwri/hHCCUkwFUsVWPYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gIkuzPIqMYM8Efea3N18y2GsLOOVbGeYabgh1y3dFEk=;
 b=H44rCjyt/SAJ2tmswXN/EaG0Gp+HRBTY89D7gvSjY9NR6Fvg7HgR9yry/JvpAUGrsna3Se6yAGZ0S1OXYfWVSL9z4E3QgCO0jCvJKtMd0dEx9I7fz9nW+XSaLmeixGMHr9ltNP4fhr+Gk6Qhw783/+UEc3R8h6dVBL+3Ake1CAUnkIPRZGXDEd28nJkdHWWWTc5aH28l5oKVhixsWYYYz52fv5pRB2PttK4gu4+yJNdesCw3PCV6YCEFF4Jm+V/oyPuglJsX3OTgiWbssSDsjw6iU4+Q6fJS5mkSl6vUTIZQ0AMkESNnMtmRU5MA3/Kvcali0bwPLbrewABa1t5rvw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8724.namprd12.prod.outlook.com (2603:10b6:806:38b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Mon, 6 Mar
 2023 13:17:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6156.027; Mon, 6 Mar 2023
 13:17:00 +0000
Date:   Mon, 6 Mar 2023 09:16:59 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: Re: [PATCH v5 09/19] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZAXny4NDDq42NUxE@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-10-yi.l.liu@intel.com>
 <DS0PR11MB75295B4B2578765C8B08AC7EC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527688810514A262471E4BB78CB29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZACX+Np/IY7ygqL5@nvidia.com>
 <DS0PR11MB7529531834C0A9F1D294A5CCC3B29@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276B825071A4819479079A68CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230303095542.2bfce5c2.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303095542.2bfce5c2.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:208:fc::41) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8724:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a1f376f-ccfa-4135-fe4b-08db1e4511e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrIpGpb9Y8V7r49u6ks33LldRc0Z3JP61vn5OPhs7Lcvj9OB87xPywbxZRE/etyQxjaFwLg5KIITDXQm5i5yFzJrSnX/2hGnwMJHx0qA/jXZ2wMp6YH/WIQQR06MPfFrFIPXK9XbEa9ANJeV1Het2u6gaHskTS6akWWup7kuTY9Zgl50uXfkYtCPKgKDvCUjBdeH8vaBFYcpAVJhTV8vpC9O6NZn8SvltB6KpaPJZHXQvICYRgJEMu/b95tOZt77hWjexbmI6UI+IrtNE2rnQLEWPjGcg1Sx6CUCWIJYMOOeapSyVbkxaKq9RGr173Rkwk8GNKf39Q2oqyamPqjUUjdCgc7M4QRaBNWyfavSoYj+sB97fTPUv4qfuUdpdHrQwCfX4/SXrIU+nMCBCe0u25MOwh22UeBRJb72hdIjljHRrCgAns7ZoF7KO8626awII3Bauwqj74C1NiBRcPlG0Hb685T5lFnThoZ6oY+HksXC7b7iUCwx1Fn6HPmQpfy4tk9e4710//vFc+H5RPxLr8O++z3OeW698iNEtTZYi+/1i+x7CecMDLTbch9VtbjD/rBm0fs2uVD/IjzsxCISjZ542jphjK95zXuBqsAAO3FMyFBgmr7yGPL6/1z/xlMacCGT7HINhUCaebu9qDiGTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(346002)(136003)(39860400002)(376002)(451199018)(36756003)(478600001)(6486002)(6512007)(2616005)(26005)(186003)(6506007)(5660300002)(8936002)(66946007)(2906002)(41300700001)(4326008)(6916009)(66556008)(66476007)(7416002)(86362001)(4744005)(8676002)(38100700002)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x0gz4qsHkTLe9l+OmYo5ywPfPv5pJFDQi34S1orppr12HQ/pG3/vjoJp95db?=
 =?us-ascii?Q?1mey+OrhZqEmOaLnZ0HfFUFRkIXIkdMYdkj8OgBKOQ8wowY30VPGwN2x5qBD?=
 =?us-ascii?Q?a8T/I2eHXvWyGXyMHOOzxMhXhyrIiyqgkQU3DIDSzDM4wm3LsIytubaa5AFH?=
 =?us-ascii?Q?Xv6lzrYo+HXrIs6fMG70qWvJJgCoRljGQ2DgnGipKwoLvAJnJxaWv0vw4H+j?=
 =?us-ascii?Q?vYGIf/1SQkEv8wtQMjY06yoRDrZvjrRo2wkGw0kji5lEeNyIT7fm/EGt/Faz?=
 =?us-ascii?Q?yUqG4+cqA8wgzXc9WtVqIxsmYAAONsh7a8VwCtuq3cQ7YtQTM2G132igbDeq?=
 =?us-ascii?Q?THVtfwsM5G5Jjqn+Ju7Phn0qlWCUVvYdkLb339y1CmnFuV6LRctxA2+6A0Aw?=
 =?us-ascii?Q?oDcfaRvgpJR2sjp/In/zf/0+rUZA5V4nNaEuSnZ0GKZjo+cuR4xkSPlXjmNq?=
 =?us-ascii?Q?6bqFBwzx0hdzbhleQWuQHPugcGgz3lWPOCL2gPoPdoxBDFoFNpSi2juPDoS9?=
 =?us-ascii?Q?AZFdJVSbU+s3VNfInx+7ZHfHkQjE1FVCBoGcJPkboKGrT3HgxTIxYFs4fkka?=
 =?us-ascii?Q?WxKwFCjLt+rLW3q2sf0QeXJjGvYr29VwNdXduqqeRsKTsgvNlWWfXXyKsR+0?=
 =?us-ascii?Q?e0jxRZKdMwETCQVxFNnTdmaEOQJ8G2dMd4KyarLJUg6wzWzDBUVYCPInuo9T?=
 =?us-ascii?Q?jylQwIEtbtGm5htrs12Kw9DNE78z5R2FHFmCq/7Mt8oz6x44wBgD2DV3o1wc?=
 =?us-ascii?Q?on9pbB10oxtVij/ZwJ2bmXF1cVGT19RHXpmIjEOBKcitg1KW7IPGXtVPZKeN?=
 =?us-ascii?Q?7vvY1zYEziBOajBnnDmBT4qYRXGVjuhpxGZItr5eQWz4dM2d5VhZ5y8bXtiv?=
 =?us-ascii?Q?fSAFXsmUoIWSgztivjLnjCGDq38T5/V5vfrHgwZzv29iXszg5WJcTW8AKF3M?=
 =?us-ascii?Q?vIucKapqAC5K9UNyfIASxJgjOu1TbkuAsWl/S8h7NQJOxwe7woeFwxTi32/R?=
 =?us-ascii?Q?xDzXAoR/MFoYhoNMJ6NZqbENbHSXRSSzXhAFNxMmdBb47N9InR7ahz1UUGJ+?=
 =?us-ascii?Q?L2f++NrggThefxt7DOfqYytQHHfHVd2r4qjx8BnYM1uiYo0MZvm2r0v0dZAk?=
 =?us-ascii?Q?oIecKalvTayYJcUYqNDZE53Wlu3eOuGSwbyvshQzO+p155xcarhicKjgv1M/?=
 =?us-ascii?Q?MuGpBiRtEYJ7xCMAdFG/6Z/p7JYk2PY4rfz87wGZSNFE6PNy6H96EpnBPAyg?=
 =?us-ascii?Q?zUkH2h7pXBstM1e9YHWenuG12bKuoon6tbZ6OKJj8Y4D2xR8KFIdsrvLYQHx?=
 =?us-ascii?Q?+uMEc76AB4/2u0qmCvLLah6sad/7kv5B7IMYDipqmExKj0fFiiZdV1WAALHR?=
 =?us-ascii?Q?zD8dKBbApP27hjuUjSoo7yDnIkRpYOa2q0GnJojKsJMOQLWvHvE4Vb2ABhWt?=
 =?us-ascii?Q?zJgW6tNvPXoFIEvqhqF2JscnsyhIAirgFFLBU4JtdZwWvoJGSkEYBH+iGdaP?=
 =?us-ascii?Q?JpTa9duPNevwKryL3JQuopaZ/obu19ZARiYlNhYw7czBXk734TusYXgqbwlU?=
 =?us-ascii?Q?t7Qh05+GJkMEnAWetsI6Jw/3g4NJoBIYpOFw6/KL?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a1f376f-ccfa-4135-fe4b-08db1e4511e7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 13:17:00.7549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rESmOcajXEr9TGxjV33cQN050ubIi68l1aEYr2LHDx9cRUgGpwd9UbFvkqShNp/j
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8724
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 03, 2023 at 09:55:42AM -0700, Alex Williamson wrote:

> I can't think of a reason DPDK couldn't use hot-reset.  If we want to
> make it a policy, it should be enforced by code, but creating that
> policy based on a difficulty in supporting that mode with iommufd isn't
> great.

On the other hand adding code to allow device FDs in the hot reset
path that is never used and never tested isn't great either..

hot-reset does work for DPDK, it just doesn't work in the case where
DPDK would have many VFIO devices open and they have overlapping
device sets. Which, again, is something it doesn't do.

IMHO we should leave it out of the kernel and wait for a no-iommu user
to come forward that wants hot-reset of many devices. Then we can add
and test the device FD part. Most likely such a thing will never come
at this point.

Jason
