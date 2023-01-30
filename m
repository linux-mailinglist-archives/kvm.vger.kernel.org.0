Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2566468182E
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 19:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237622AbjA3SDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 13:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237678AbjA3SDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 13:03:10 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334671BF7
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:02:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gmPr3zRUZuGmhILlLBjjfAyFx2QAdYGrl8sAM4P8MZ2YnD214JB//0KwOlxK8nBUC4CdW5rqRS/BCwoe5N/pxW6dWtxXrd2lmnMpuY2ggaLRQ/VhoJyQppnxyInqg/IaPdjIHdD3gHOg5F0GIZXkmlcEZtCbvXx4XAy/rtZn6b4WIOhyb6N6pOqPJnt92B5vC0guBFZwGBUZqs5mqE7ZNLdZviZw3ah13+TR1WrFVgzD6E8VMA7P6vNWjF+pZ1xIEdMxMjQuPrph9uuWfBRgOJ67PCm0ftzpq4/vI1Fy89oJdH6lAmkgZFkGDc9UFH+KGLOyJhnqXvB4/fpza+WCzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wUvb78C/OSJASxMQ1iLjvvHkiiCRotNoyATTshw85dQ=;
 b=BzrGT6ZMrsogf4kHSLMx07cRECkQT46JrZSIm1K7UIFdKPjaKF3NiOKXPyl9dT2JAuCcL7ceSMyXSac2ljv32YVWC8YTbXy0GQKUBa40cVTqykX1UPQv4xkD5+KNEJA/Zs2nTxMfh4DNv77Ljiqc7n9pJsrf3bZElPIUGHWO89lPv+mtbewx/DbPYDSCGqJJAGQLKcxDQ2SPIujmTCjxrM1EF9OahPn3jzNt33u+48wqRtsF+Un7FIYiMcE/C2+gOd+VGuVBhWd28Pn0V+gEzKX8SLlvbapzGhAqEEOO3rN5DfY8O/aJbhE0JJp9Bosl4rUsT0azHdNVndbd8ZjASg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wUvb78C/OSJASxMQ1iLjvvHkiiCRotNoyATTshw85dQ=;
 b=WmzXkAFVtmn4c1vjp8KZpFuAZs3cWhvl+LOyJazbacYjhffH0i/238tLSdz04/g1bfWl/bxs0c3tk3BPHYv9qbYVUiaSjxjjG8YXkLhQD4QXuoKYSojeyB5RLOv9DcY7k0BthgDUjZkg4Ej8oS0vP2C4nt6vjFhEkYVfVXRHJ1NSZwQC9Xp3NX813ovwHDvDjDLvzbe/FdaFu4D3SWpVFHz4gHHp7gvc/iP2sMNkDo+5EC70S4cggWDRiq5nQ+mDTeBkI+w7RUoAU2u58FCOeC9t4sz97yAojTOvdjBykCuPEB8hGVERZ2pTHp/kAQ0hgoZSg+v0j6+AV/tFvmyu1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB7961.namprd12.prod.outlook.com (2603:10b6:a03:4c0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 18:02:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6043.033; Mon, 30 Jan 2023
 18:02:47 +0000
Date:   Mon, 30 Jan 2023 14:02:46 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: Re: [PATCH 03/13] vfio: Accept vfio device file in the driver facing
 kAPI
Message-ID: <Y9gGRiWM3Lj2QRW3@nvidia.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-4-yi.l.liu@intel.com>
 <6c95aefd-31f5-fc98-7a51-77f181dc6ec8@redhat.com>
 <DS0PR11MB7529C43DBE880EED5A04D9E4C3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB7529C43DBE880EED5A04D9E4C3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR05CA0047.namprd05.prod.outlook.com
 (2603:10b6:208:335::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB7961:EE_
X-MS-Office365-Filtering-Correlation-Id: 52e80173-c0ea-42b3-3c3c-08db02ec31be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PammLsAjJxLzX+LXZxV1m8Uvn7fuGfoQXIFXqKXaM7D6xRO09aO3ejnQ9Htt6vyDRe34xMAz+Ix5fevR9bKPPzyTabtl4/zXC/ch6LtLTfhjpgCu0hzdT1aMGeaPwbMg2+gGoqiJGEa+d5X0WSlmaayv+2xMZT3yQ/pqPeXTri8qM48Mu8z8baSAAL9YGZo/uUevYVIOJYpkxRD8VNRtpCPQeLNjmTcVWgOnZiD2gO8uy39UTW0k8fYCLYmOPfEB4sm913RikIEZ3D1bwrjunO8XwpItCt/FLJkB6crG/yZYRrcxS6hEBjNPPQzmDJS/SpklyOcpDGNkyMijiTW3k9EBloAzumVLsCKnMqtx4BrFQqzmyDuHC5tO6UNe6KCI/17zw76xCdeQoQMLByLU6pbH5v1HPIlwnW3/dTdfSIxT7EQ90Lgpue8E9WhmVfBk29CG/CSzZlaGbWaxS2tTB+8aSZg3Y8LVXRyYpFCmkB4/VWjWsUdMmdmGCfbhEfe4y70UyPFZrUBrzYccLyDUwUjmJKMWFJRXQJTBRPQhag05EeGl18v/j37dmN6T03OMn5dIgYXAKF6NJwTE9HDxyKrL5+0ajtNvOLkYOWGx4Fao0xhNCYSgBmOmRHZudCGMxsjXrwijvzVdTIos7E9yZg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(136003)(346002)(396003)(366004)(451199018)(2906002)(26005)(6512007)(186003)(478600001)(6486002)(316002)(54906003)(86362001)(36756003)(38100700002)(2616005)(66556008)(8936002)(4326008)(66476007)(6916009)(66946007)(8676002)(41300700001)(6506007)(5660300002)(7416002)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3KYPea5VMQA7U44vpd+7J58Ywx7gctdMi9Q8+Lakg76z5K6dCkGpeSDs/sxr?=
 =?us-ascii?Q?JGiXi7eouz0/YgRXdxKARZlEjCQiGSxPs2pO9QFPN2DmGYV/B9v/GYX2XKX1?=
 =?us-ascii?Q?dXNpsEYFDMWqEsAtBKiLR/wWOr82WxhfWwYRipBDDPjPNM/fHgiN5creJcsB?=
 =?us-ascii?Q?UV/4DNAlP86l/uUSBpsmPbnrT1llorJs8PNSgDlnuMcbGYe0KLwr1pWORkkx?=
 =?us-ascii?Q?iFI13yHX6AqzRnZbQLB6RYJ+vE9uEQzjhYmqPsLcAbevfT+j0/5LUPBFRsJu?=
 =?us-ascii?Q?UtAn+nSFK9IE8ePr5Zypc8CH2ngZV/0f0HK6gAA6SE+ZvInJU6aAYPFxyJCj?=
 =?us-ascii?Q?7QEg0zl2CxaarjSY19lORIWELJF7NjckSpmcxdY2y/tK4AwaX/IwmPBJt7Av?=
 =?us-ascii?Q?TavTzFV9TnkGdZUPQEqH2wtWw3LODXxUv5rSpY97gedzb+2lpbVqq/nZ7iO7?=
 =?us-ascii?Q?z9moCd/GglMKmqCy+KFyIuNf1GiCtDdSGL935o5ysokFREl7yYJO1LHNXNhw?=
 =?us-ascii?Q?q7O5PWaQjXJUaFBo09cZRQiCnHwbQK4Ag/jXm7gjdPXHfXUvzQ3qdkaSOv5h?=
 =?us-ascii?Q?aMyoXSSFAZC0M4gDBlaJmqqZWmyRv+M4Ag6COsyESxjx0bgT5qZEWy4VzSlJ?=
 =?us-ascii?Q?m2HrXeuT9UDn6eoU64vxIT0DLCV+TMWQKyqWzYjZdy+gMCFzIWiu4tL+kO0W?=
 =?us-ascii?Q?/jGa/JuOiQTdgbAlodBO/KP3FUl0I+BOoTskI3mkJYrXAxBqYKPjNhE0KIlw?=
 =?us-ascii?Q?5/eeEUMbB0kUsCHpqHFf2ESY7RqtU5MqJJ9/Cey5KqcDk+Fhi/b3O6Wq//Gb?=
 =?us-ascii?Q?4nsI1P8Q1OeHofmeJovecRW7tBn5fKz6I5yM0V4M4q93q99w5PUxvQZ25IaT?=
 =?us-ascii?Q?/uZF38htVMMaYF+UvASMTMt9K6Bulw77sDzkEDJh+MPEACTZ8BZQ+HHBmn81?=
 =?us-ascii?Q?cthpjL/3/igx53FoEHp5+GytC+A5C4ex6UBRV3qiMv81ZAO3bB98Uqz7Ysap?=
 =?us-ascii?Q?pRwaZsrqkeqIHlVRihhD8+qbSMK7Nb7HOMBrfS+K4QjlUUylWtqUDG8j+mnU?=
 =?us-ascii?Q?c1n0f7TmUUKPzrUhcoK+M33mLnYrBsrNAxhPTYnHQ+G+zROAmlH/HGZdLEc7?=
 =?us-ascii?Q?5fW3uI/mo8xu6YhvEBJdZ7M26/Sp0qkviKo9ZRxs7mqTrAOmQaOQGUVYN2ep?=
 =?us-ascii?Q?0aCTj0lvaNNiDdMHl3bCFrPm3W41vzN9YQe6iJDJK+kTcgeLo5Mu8bxwIN4H?=
 =?us-ascii?Q?O/uRMXSW1tgrIHVtuYiRMo9HDjxqIhNWHZnnCXN5xrym/mclPa2oq03OPTFH?=
 =?us-ascii?Q?BzG3YLkN5kk8qbXwF4oSt6pSGnl+wWmGOGBOi0DOgLAGNrGVO+Z+9KhMbrHe?=
 =?us-ascii?Q?gjUGgpIh2S+9nQYZqVedfgzD5jdH1m57+vEMRjsFsltpW4CT5JtHGX9/LnRT?=
 =?us-ascii?Q?2Xzc5fnll076opMR909TB9Mrw7Fv4JWOYQqsgXe/qk2ioQdnEIWfkqT1+rbK?=
 =?us-ascii?Q?pSOzbsmAVYncWNKAupTRnmAs+Y+lpKcFwV3RmHc4ae92QcxkdJPcns1U8h3N?=
 =?us-ascii?Q?Hef52IAWs+bn/9+8i679FobLDQdwWCRw+mB59/by?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52e80173-c0ea-42b3-3c3c-08db02ec31be
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 18:02:47.5176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eqdSFZb4Lm0s6llIfg2+0X6TMmiB2US5TpMBC96JXQ4uHs8RzpRBpgFeeg6B4qmF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7961
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 30, 2023 at 09:47:08AM +0000, Liu, Yi L wrote:

> The reason is the df->kvm was referenced in vfio_device_first_open() in
> the below commit. To avoid race, a common lock is needed between the
> set_kvm thread and the open thread. For group path, group_lock is used.
> However, for cdev path, there may be no group_lock compiled, so need
> to use another one. And dev_set->lock happens to be used in the open
> path, so use it avoids to adding another specific lock.

Add a comment around the kvm pointer in the struct that it is weirdly
locked

Jason
