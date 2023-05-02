Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C97A26F4983
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 20:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233971AbjEBSMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 14:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbjEBSMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 14:12:18 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5E2197;
        Tue,  2 May 2023 11:12:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cRxjeuyj5y/y2w3/Azrcs0e55zxTaeYPhP6uQDdv4vxjgVtIBO7aDOuF+tnjQQJnPIRn254PP3abLlNft76RUi/8sbsLCyrbN5Dwxbw3lfeZHlZW5hrkZjxt3vb83B3TtWaMFjysH7zENX0fBhTbsEW9rDAPJ6TZR7sfHobHC9t8ah1icKz18zo+6nuCB1m3yvGYCK5f3ojDOh1CO/hLkDZgB2VOEzqftaDNgiXDkSdIV+oQ28TivqZWPSWPHw3yGqNmv3ka0QUImd8/5x385SyTbUMG+/eU+fiA4kjBpqsMxAmb1OW7IAXBiBD4I+y9743vcvCEaB51foAJ/W2SAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gAOQcUsey8oFEZQH2ZjwJpAXK6Xtjeue4VwkMqJv2+Q=;
 b=B05qqDE0noioSuKzwnus45D0G3BfWrkm/nBxl3leoNBQJZw/57jYFgf+8AyYDogl6koGMfIBckp8o3U4WDulq+ll7150fUZGIw3HVtWIUkqYpmWjUgUez6OCzIdNMXTxnPYcuph+vJTCLZAcdWNJXyyHNA+btX0b6+TMI3qE4G6KRd5l2xdi5HS12xEfDSf+1iGPdl8GMrkZRK5QO/Qh8HBApnK20GdaH9m7lbOJKLclXCnbcLXNcWvmKgggCQsJKFz7gr8AsFre71POBm0BeulMe+nymi9BHRWA/qlXpIhyAFBDbaqV/0VZIisMHU9j09J6XSGyphxb4gl1ZzJDaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAOQcUsey8oFEZQH2ZjwJpAXK6Xtjeue4VwkMqJv2+Q=;
 b=qAZvhYm4RQxHIEDfG5fcGs2BSVzdcSuwfQQbEbLc9O4ZVjP+5pgNBNmwbJcln9R/y4nAEtxTDqxLug3iaG41oLVJz87rMdTxYmLSuZCSpFwJsSj4pyjSwSuymd1c88nvAJm+k4H2oXTMhowd8j61UbtboXhigg2oJ4wNcDtlYeJDFrtNq+oYBmno3HS1Wgv11z9t5zlim95XeZRbzOweWjpZ5MdgpS76zknxydCmVCbHUq5si/iGqg8TIGV8haPYn18dtXvqympS4wOt0sR5btCHMihM0OZ2x37ZzNVSDaVDfwOJbOxOJWX8tb1l2V0U7/9rQ/D9+RnstX7He1NuEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ1PR12MB6241.namprd12.prod.outlook.com (2603:10b6:a03:458::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.27; Tue, 2 May
 2023 18:12:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.030; Tue, 2 May 2023
 18:12:14 +0000
Date:   Tue, 2 May 2023 15:12:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v4 2/9] vfio-iommufd: Create iommufd_access for noiommu
 devices
Message-ID: <ZFFSff0cV/eC7IZ2@nvidia.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
 <a6b77884-1678-b17c-f6a4-28d56e6c366b@intel.com>
 <ZEu3Ga9cIQAykBGf@nvidia.com>
 <3b83d829-048b-174f-a21d-b28ad0b7b49e@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b83d829-048b-174f-a21d-b28ad0b7b49e@intel.com>
X-ClientProxiedBy: BLAPR03CA0119.namprd03.prod.outlook.com
 (2603:10b6:208:32a::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ1PR12MB6241:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b02debd-a601-4922-4bd0-08db4b38c1b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G92Vt7lKBRB+wzgPPbADJLonMW2EwEujnBAvXzSmGWfMKefBF/VDjXk87Xi/ZL06Vte7qdVz4eC8hM3E8EpfyfNEp+ZzWob42cL4qGm0oUAKAZURdsAQC3+AZbWq4++pNQ5rpn0hUaNPmf6jV+QWviLv0lrQWL4pd8HjLPYsL7AF3WiAk8oGkEVxgoYNgYmsVhUPz7qnQQT3rFxe2+WhUDMluEhEXrXWAySZg5DgUwlcsVqz7iv5Jxt1k8w0tQNP5jvhfELqVJMDmAxr82vmK8x6PKReG5xdIRyeVgWx3KH6HlyIWIg4VXSabiSFYhBcqO695wJp3XVpOSqfY7b4j8d9z470I9spRcAiVO25QAL5LJVDCqjIsCEuZXVQOtGq0hhoqWqYYXH6l+zb/4fAmD5cgch8JB07Ruc1tWHv333jE6w+XmAKxZI/LjHemrLT24nwhbD11yINraQDd+I2nnwjI3YMy10vhZbuOQ6eqf3JcwDtI+ZaYqMtMBMpOzzm/LM5EQpPNqtQFOYXBXcfpIMC/FGfpmTwbIdmnek6cRvpLKvymYdzuzaJEFldn9UP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(376002)(346002)(396003)(136003)(451199021)(86362001)(36756003)(54906003)(6486002)(478600001)(8676002)(8936002)(38100700002)(66946007)(66556008)(316002)(66476007)(41300700001)(6916009)(2616005)(83380400001)(4326008)(6512007)(6506007)(186003)(26005)(4744005)(7416002)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MmQI5ZF4CcVzHb1uYIudgT04zYKnLzrKJCgK9nA93kFqIV0PPInLDxAV3kDs?=
 =?us-ascii?Q?wqA6S6Achzh+VkoAS5ZlBCDjY/F6RZ8ihhRBezekB47oTLx2jeanXCWIF91F?=
 =?us-ascii?Q?VojQB2IEuq+6ql6kWaql7cjJ53COOhManFFsvqM5tcd+H192+lJFhpQr5D2d?=
 =?us-ascii?Q?rBHZF16xK+zBO7bmlWzuRg08Dy9iBLfZIEH65aKDjX0L48e/5bVwAJCNPEKp?=
 =?us-ascii?Q?JggFS2qZzOHddfs2nkCWSu/oBEZ7h/XTImEU7dL4tU4jzbTXhD5kXu6/AR/4?=
 =?us-ascii?Q?vbZ9rYHSAMX68SGJ12GZvTl53sx36Bh8pRNVfPvOwABND7kPcSXkKAXFT19t?=
 =?us-ascii?Q?bpuuz8CLF6YxlFbuWOGJBUPoM2VrlDZFBnr+fKmYKMowFNDoldWYLg1Q51tq?=
 =?us-ascii?Q?BCPV/UygtoUXC8tCcemgaxQaKiKQjTghpwLqciHrEFocEfyV5avcmP9+bZEM?=
 =?us-ascii?Q?+nKYsSX9Y1fYCK0O7DFYihAMmPbZFsUQyRvgUtiLSUB+xYRbOtYte3EklAk0?=
 =?us-ascii?Q?XZcEv7AwPINCueKUfWL5jIATazUsxkctf0Wjdv1eam/J5c2L6nuVSrdKOTNx?=
 =?us-ascii?Q?ZtQ80n2bcisdFUGYBcfel7teu5sMTQbv1rrhucKEYepqPYeuoomMC/zE9uw5?=
 =?us-ascii?Q?n+rTYbCV4nYFBTJNIf8uAsE+3yg8zGhCovHJGjEv/QQjaJZRNut5q3WN2EiI?=
 =?us-ascii?Q?PvM3yzHZrJWicmnvrwbcXovroWAV0bP1A7A4zMjOe+IaQ1b1+QbTnS+zpNEb?=
 =?us-ascii?Q?Bqu4pw7xcG3AlbBTVSDoA1cCJazLTcTCzjDWE55j6QCJfex2FjbrQYkXBmue?=
 =?us-ascii?Q?kbMD1qlVSImiqKPQqNPxb6WQeENXBY3bmcxNq06XQaa9wU5UI/g8kL9baPHK?=
 =?us-ascii?Q?m7XBn7TxphItz6VC1RYoo3R98fcDQkUkJoQwSH+HhnZKDkPcVs7DvTHuLVKn?=
 =?us-ascii?Q?t/Q+FxMGF6bu1fM/HCNwHGzY+18TECXQJcDBXMJUf4M5/jCuminqCx9Yi60g?=
 =?us-ascii?Q?VfyluoVT98+ZrNOXK7t6J8PejuHEw5gseMi/6be5LRHH8ISlxrs40ByaeQ4A?=
 =?us-ascii?Q?SKuhsuB8NwJno+SDrn1Q2BS49Y0lrcK4Jf5MPONq4yX3m5pohaf+UtTD6qE+?=
 =?us-ascii?Q?/XFYBQ9lByqsHND6ojcH5sVoYMtfPwKoW4vomsDJcWDAKN/vF5QERDjTrJ13?=
 =?us-ascii?Q?c/LQl4jRQJxLJXaI1KoKYlTm7IJ5R2sc9tuFC8cP8dBIEyNfezOj00sxhgVM?=
 =?us-ascii?Q?Pay/J1FulFL0/JAh76oUkeLUlVQkzdEEeh1333HZtWzNMbYrcOFQx1pFEGZs?=
 =?us-ascii?Q?AK9bFtFRBYwTDKCxdnsbwXQYeoD5aY272Ae9gQMX5j7NA4I33Q3jl4At1emN?=
 =?us-ascii?Q?QMSykTNub0/SSTHgp8kA1EtPWk+DFRexg5JTMGvKonTrlfYW1SHwlAKd6X7/?=
 =?us-ascii?Q?iDVL0fyQhJU+dEB4LoTIc08nUpcGKqlZzpBCf/R/VrYYlhcMRfnIazmF5qZA?=
 =?us-ascii?Q?4FBwEPsQTFKI8OXghgRyKmV7xE/VgXgoSqL916/x3c+cyfGMIl3qM6TDj00E?=
 =?us-ascii?Q?V+guFBdxg7mHDLlxxYls+yOc65yGXtJTuU6aSotq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b02debd-a601-4922-4bd0-08db4b38c1b8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2023 18:12:14.9392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2ReOCfsp/GdU0EDAWP9fqgC46c6UE/TSwyGxjHBYOLiB3KDRMZtrIb3pb+XLXxB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6241
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 29, 2023 at 12:07:24AM +0800, Yi Liu wrote:
> > The emulated stuff is for mdev only, it should not be confused with
> > no-iommu
> 
> hmmm. I guess the confusion is due to the reuse of
> vfio_iommufd_emulated_bind().

This is probabl y not a good direction

> > Eg if you had a no_iommu_access value to store the access it would be
> > fine and could serve as the 'this is no_iommu' flag
> 
> So this no_iommu_access shall be created per iommufd bind, and call the
> iommufd_access_create() with iommufd_access_ops. is it? If so, this is
> not 100% the same with no_iommu flag as this flag is static after device
> registration.

Something like that, yes

I don't think it is any real difference with the current flag, both
are determined at the first ioctl when the iommufd is presented and
both would state permanently until the fd close

Jason
