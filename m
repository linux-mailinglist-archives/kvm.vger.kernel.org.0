Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552066A4AC0
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 20:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjB0TV3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 14:21:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjB0TV1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 14:21:27 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D933024137;
        Mon, 27 Feb 2023 11:21:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlEYEqfFYQddMJZ9USIzpyRXTgeJr8N2gImWDhpilu9r+v0yj+7EsQAJnwM9M8UDpu35mXXgO2yLizDqx6rkpl+qWScCzWHR94m+cb9fVaACBy0OhAOxH2VxdpXmuxW4mfc2tzhyKErJYyGXZCrjZ8h00F2hzUjK1FOTOwDMPZ0TdBmbxOY1wYC7iYZrWwKJ6+P5MEwg4/IVhZ/yeuAZnIR11bSOjeTvSMsjsKFR52/zD6g/P4uO72Hl73Aqy+sb3JWlCsXPj5Kevyy1QmeFEYPIaqchzVk4dBFV1xfYezQ8Z9+imHMC9UDVZpUsAr3KNp6GLcmTBRVy6c8QQIE2VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kRoGoxi/TVXXxw+vyL/Q5RLxb7OW0LiXr+foWddAtMU=;
 b=S9oKxYlefYdP/8KYCwU6vlFBoEZPQ2hoKC1jfFArrXdvPnvL6IJBUfnASk0o6LjELi9anc2aSY1fu40BcRgRBVn1rn1ZPSx0jhzvnbIUBncvmVeitjzYBP5my8Q7dmx+tDDP3mo8s8EOrmXonhWkU3EtQVSspFJIjc065QfS0xS7tYniiWaquxjdLOmjIOCPf4yyi20lryQiHBxcwU/dZNFZZeKeXE+nA3K/3euHCZxSJZIddNwSQMV8b7IWZVTmqoKQJiWgec58W5d8asxpu3ZMV6HpNoX3sfmlGog0MwYsurduoo/MNNSskf0M9yR6VupsWSmaxXFYKbgMjIEF5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kRoGoxi/TVXXxw+vyL/Q5RLxb7OW0LiXr+foWddAtMU=;
 b=B9sNJ0jvF8nGaf3daRGLXh5xPPIf5FiXM+Fs5xDUI+4nleb+uZpbTm6ubtJpICJgHdkfgdrU4xwp4I7V82Ro83iqsxfskqPTD7cgp6BOd/DJQbEB3yh9zPZAZv7LHL6C7RC7edIqVuCC6Hs5Doq41Ov6eOEdi0RUR7wBUwCglcZJtJxlF5LcplTbeVvaWQVnZoZdR4txO5rZq8HvbWb5+0bGfUeVAL1qeaAz5YixGiMT0X7p1L/ZOpakb6mAyYHvrthzKlGgNd6DjENzbeR4VuZls7rB9VX6Gl89o3ZbEQH5Q7PRyB97vYdiaNkYs9uV9NcjI5YhrAuFpH0L7t7y6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5098.namprd12.prod.outlook.com (2603:10b6:408:137::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 19:21:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 19:21:20 +0000
Date:   Mon, 27 Feb 2023 15:21:19 -0400
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH v5 00/19] Add vfio_device cdev for iommufd support
Message-ID: <Y/0Cr/tcNCzzIAhi@nvidia.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227111135.61728-1-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR22CA0027.namprd22.prod.outlook.com
 (2603:10b6:208:238::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5098:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a3adbef-13ab-4661-ed99-08db18f7ce84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8PQ2txzYGZcLLiGf2PKSYU9Hrr/ncOXiNCd5mI4tNq4quypfNVtN8WuQArR6JB2cW++dyWn2n4wdnX0ie9mGOKCYFUyYE6mLYw7XsSA5MadPGDTlXEYhHWN7eSeeCOZK2YWnkuUTXZKTqCLe/YVTAmQ4GfEPX7VxyvjJelT73kfwRE7yy07TaEomeapzVhbQno6PplY+yqhyR0wak4FilSk+h2uHdwkugv8D+m8vdSH/AZRnbLNMcdtoBmfQY+Z47ieM8/3kU0REmi7VJtpgZ0vty06xdFnIjJKLgXT4lYxbxtBeGzB5MeSDFHljxbqkBctxBIl0TxORz+riQlOS/6xmCirAB29EyiWYBYQCTPTXsp0B5zUvcJXJJ2IeNNYHv1m5NwQORxMF5/78g584a4H6zgMMB4wdBSms0mteHoC8/Q0X0epiASvZWGNqQYgWdtZ6HGU28m5DiB9sG0qQHj8FEa7WoJ8FQ8Mu+B3rvfxhTMYF6A6RjpeTAWqdpYceBqDwMdXv2iG6GwK9nANNQJ2u0vwUkGzHc6n5fDilR1yHCNXmcF9VsekbHnsSAxepNdtM/LQbgc8oXnWzcosm5LEpokKNQTd6FKhzlm+Kwd5msm8LlQRUNfg1CPnkMBFqSvfk66aobhZYorSt7eqaK2f8d/LAV6gxTQINW7zoNjy5XFAoey7VAK3JvwQyL9IB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(396003)(39860400002)(376002)(346002)(451199018)(186003)(38100700002)(83380400001)(41300700001)(66476007)(66556008)(8676002)(8936002)(2906002)(66946007)(7416002)(5660300002)(4326008)(6506007)(6512007)(478600001)(26005)(6916009)(966005)(2616005)(6486002)(316002)(36756003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WvRCLbi8J4xQuZFVn/ans84c9uL7H3AaO1I7TzIEPo0mneW1vb8Y4ivq+44O?=
 =?us-ascii?Q?vKLvVFzm4UWMeNKFRMgbmDmaI2Re29QQlUH7iYo+ciYSriwZeq/IH6YWmen3?=
 =?us-ascii?Q?s+D0pmggPo9Hlrd+qQI0Tt8jJKMclWWG6HF6iDktcyYgrjfemu2So+lZkPhB?=
 =?us-ascii?Q?DnIE/GMcAhmtctxgUIEPw4WIxVvhkb5QnDKqsSl6EqJCBNKHvz5rRzSPXLPD?=
 =?us-ascii?Q?lcc7TrhzZkMJ9y9pW1BMRV2iZoD5uwZiouevMwa3+/1lXAYuqNnNRzrBIXjI?=
 =?us-ascii?Q?JRlUSWfnX08I1g1CpUDC4EuCTnheCj+R+5hmO7zJcAL9NbAVS7dKEa0AzeUL?=
 =?us-ascii?Q?nPpkw06lZIoPmyPfvQcvt6/HEE6gh5X1Yo6EoLRXnU+rOUrPZexNvQe35EFF?=
 =?us-ascii?Q?QV9AtkpCYzUWvmLHuPPHtZ8yRht8waMSBlKsdlrqqhFclhXsbqcv+XRLOsbg?=
 =?us-ascii?Q?wfSKhad8LiEcrYGLZGscGxVBd57svxLGt+B3nZSZYoZPfdLsJSdBUXi3fLku?=
 =?us-ascii?Q?hsYZWjBn1Lkly7oAcXHDMPSsMka1/M6ceb/XKdy9qkEWGNZN/Bz7Ce2/2/Sn?=
 =?us-ascii?Q?i7UuRBiPvEJ4J387qbCkQRPA+Yo2dHeyOJ140EVtkLnNy+u+hsIpaT6sZHjp?=
 =?us-ascii?Q?psYPHGrAFy/2uj3XMiKkkbTzpLHev0mZEMbWpLmUNii4J1fSa0HPMUghKW09?=
 =?us-ascii?Q?LKtAt2QQdM9eX9zqqpc8wBeLfPRnFld702xR+3zqmRvIN1dZ2Hn145QLjZcI?=
 =?us-ascii?Q?NfuSoKQDhDCLRJ7WRC5TTDoZPgEXwDI8Nn119KV/ZlzmF+atktCTmjN6+73i?=
 =?us-ascii?Q?3mSLEA1JhlUcfpo6Fb3z95s2ZcDkG3dkaTHRWKIwD3eHb0GVraGDblgxEdak?=
 =?us-ascii?Q?PgtdcYYSW07pu5J1/V7s6cDmbyPTuA/7OpsKtmUga5hFS7OqtX1q3JESSzsd?=
 =?us-ascii?Q?vrfcjuJrXMIu5PZs3GzOaHs9J2udsdgXemLSz//OwDuuQzXF9zP1fQV+TgVp?=
 =?us-ascii?Q?6L+U7sTBIBra4VB2PWSSL1nlJohAirNWfzPuYQeNX1kHeV5utTZQpQfev63b?=
 =?us-ascii?Q?rVaBLXOzcxKVbH/tHrMSo/EWVZccSeKlafxcgLE3mDe9Cg4Ijte59LAAW8JU?=
 =?us-ascii?Q?E0bafZ983lpm718C6wqwwOERH5BOqJJ+jc+hiqTM3sE0aPKSv+6+j0u4IXHI?=
 =?us-ascii?Q?0GI6z3tLLFShpOlDSq3x5jYcPhWyeaSGY2mbyvRBV4ph/DYr0GJVYyfwEjxI?=
 =?us-ascii?Q?Mx2mFjL0m5GpEkMvDj4FBXWcdrjjOjU/IpgoCN4mDaaTfndExwN8dnwqFNoG?=
 =?us-ascii?Q?9pQW8qzpzRNJuKuXnkNv1ANtmdpl/Fdk86DQA83SgftnNm7BGxzE+S9DBeoD?=
 =?us-ascii?Q?FUSsIW3PoYPK6P8zSsB/WAXT+jNeXAjkELYMZFtwt9tL8XF9007kHRaH9Ur3?=
 =?us-ascii?Q?Ihl9rybYscUiZT6zhS+dda0aiwiM+LOYYeyK1IKjg6QIErQrvImvcYTtmuOi?=
 =?us-ascii?Q?NNKUl/+fmRPcIcI7VdetoyFGf9YmIvt1l8rb66WeshGLNdQviTBVwpWyZQhB?=
 =?us-ascii?Q?+/jWvmDRf2IzsvFCf54Xk6Y9tTGbsqObX6doSU5o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a3adbef-13ab-4661-ed99-08db18f7ce84
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 19:21:20.5595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /b3BYs3Ou8Z/C4uewXhiC70EW0advlh1FbTClTaXSh6B4Fw6AmqPqgp+f3GoXOlu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5098
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 27, 2023 at 03:11:16AM -0800, Yi Liu wrote:
> Existing VFIO provides group-centric user APIs for userspace. Userspace
> opens the /dev/vfio/$group_id first before getting device fd and hence
> getting access to device. This is not the desired model for iommufd. Per
> the conclusion of community discussion[1], iommufd provides device-centric
> kAPIs and requires its consumer (like VFIO) to be device-centric user
> APIs. Such user APIs are used to associate device with iommufd and also
> the I/O address spaces managed by the iommufd.
> 
> This series first introduces a per device file structure to be prepared
> for further enhancement and refactors the kvm-vfio code to be prepared
> for accepting device file from userspace. Then refactors the vfio to be
> able to handle iommufd binding. This refactor includes the mechanism of
> blocking device access before iommufd bind, making the device_open exclusive.
> between the group path and the cdev path. Eventually, adds the cdev support
> for vfio device, and makes group infrastructure optional as it is not needed
> when vfio device cdev is compiled.
> 
> This is also a prerequisite for iommu nesting for vfio device[2].
> 
> The complete code can be found in below branch, simple test done with the
> legacy group path and the cdev path. Draft QEMU branch can be found at[3]
> 
> https://github.com/yiliu1765/iommufd/tree/vfio_device_cdev_v5
> (config CONFIG_IOMMUFD=y CONFIG_VFIO_DEVICE_CDEV=y)
> 
> base-commit: 63777bd2daa3625da6eada88bd9081f047664dad

This needs to be rebased onto a clean v6.3-rc1 when it comes out

Jason
