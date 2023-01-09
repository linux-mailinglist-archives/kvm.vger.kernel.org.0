Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6739A6626D7
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 14:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbjAINVe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 08:21:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237209AbjAINVS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 08:21:18 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8066962EA
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 05:21:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSUwKH99f6hyIGmzSzD6RS2hk7dqMOt4S6tCn3UqA7qkgG4L+CFvmrf5KRD32id/Y6tOpwg9NFW7pA1JTHGkY9UQF+rqgtJQjKL2zX3A0I5GdUjtUQnziakZebNAMZd0ZVp3PY44txS51dOHipFiAccP1w0LhYaFXeqAoN7tFSg0U4gm26/hL2kO22E9BRs/239KMNo2Fgn9uMfEddH43XJF+xsBNRAsVTTiZgNdjfO/eG/C90w3LQ9uB/VgJrSwM8IxsdyW+coECAJxEn0oiAK0N0bS9RtmVgNG5xrT7tAK6cPyCOpgMX8MAVM3uqWuNcF9PyQMsuMA4IFgWUQGvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KKxthsRkis89eGbq825aGvZZVusHjKIKex64KdwfXDU=;
 b=aisgym4HnwxnZRnxV5qDA4Ws1O87pYCCUvEcO1Xs+pheU0qfaJlelQjRR3IlmrWHK8bejBiqcG+t7jUcpCC2jQYJcJrtoqLUiZ4rZTmDrO+TJe+QPFtKLGz9slY08WnCv4V+4yIBLrl/pGwj7Fb6CEkOESrrNk85soyDf3ao3izjSYMlU1/ECIDyopfCBle9FbDQhVNFDZY6KSyWQxzNFAHwZIGDHRvGa5ekg5G1xaCah5xudKSce514bnk0BOeA5StBWKbtrRWP/dVeM1eeZT309Y/1RTLbzFvbWTNltEEHhi4i3Lx7XTRuN5PubSG9XBVbo5mLeoLYpkrrcmZidg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KKxthsRkis89eGbq825aGvZZVusHjKIKex64KdwfXDU=;
 b=twKvKk39g4JbFQZ/tFqI6SuWMxTbDpk3m02s7k50Y+wVW22/iPzPXNfNJG97kpBfCbHUPf64w+R7YwJPuCxAN1OWU4EvPw8eHV2kjIgRHTX41H+QyGIZybiXi1DDBNhy/j5o5WHV7BSCYLTjPPe2aEKMPmDLankIRw0rRJSIRG41JqYEfDTmM27rUyu5NDY0iaUp3il0KHOjkcNtW+eTUtHP/tIU17ySCKal4718dZvnAeCGCt4J94HIxEwjYhcBjLFEuL1zQIHTjKReaVK7e34zDexoueQQaVIUFBJ7tyazr1H2zc7yHa0TyUqqe8diSGdQhTIAE+22++KIyz08Ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4096.namprd12.prod.outlook.com (2603:10b6:208:1dc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 13:21:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:21:15 +0000
Date:   Mon, 9 Jan 2023 09:21:13 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [RFC 08/12] vfio: Add infrastructure for bind_iommufd and attach
Message-ID: <Y7wUyUbilYc67M8L@nvidia.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-9-yi.l.liu@intel.com>
 <BN9PR11MB52768928D8FF45129AF8D7CC8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52768928D8FF45129AF8D7CC8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P223CA0026.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4096:EE_
X-MS-Office365-Filtering-Correlation-Id: e1e84708-ae52-4412-6714-08daf24462a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vjs3au3ZfnHtxNP8D9k6wG4G5N2iaJcmFXlKgNgX4a0PCuMfz/Oe2JCkztd7+VW1JCV38kavAOg/DfMO202jJbwIh5gUGtUE5cov9OmFeN/N2/I9h1Az+G50oHSR0tMoFDDUdlMf2Z3A5zsjY7gT4jK8CLfVJM7mCF5aY2NQ8oRYqhyJwqxetMzq1oqUa+dLdaK0THQkjzuaCd1lqkA8kqf6Ol0zW+vlnJdZiHF1ygmWFPU/nJJRxMVQ6UyICOMy/uR1CMzgImCTnpLLlHKeW8GwMvBpKSgBaZWEYT6N6uSLeKf+HX8x9W9i4Fd87L5wRzgWbjtUUP08acQhqD+4c/fKoe0qODXl7O0bpteE5UGqTIvNqJHyy6ac54euvd/ogNs/keMX4aeMYRj3O5yC8+NBfa47q4xiFQsa9HcS6t2TudQW/AgZ+cDbHcf663lrSLxAqTsBXl682wzWcosxJNM7MSRsC1kw26AOGRYuBdMMozfFtfzDZqE91Gbj1B+L9xIHLiSwGsIE4Hk4nTiFS5c5y09Ebaqk61FGzTi4wXJa9/zfw8QpyuerM11VT7NO5nNPGsHbklr+iF7cOXLoQmUPeeu8W6uyYwGQqciW6H56h+NlF7DE9VYUh0m35r6fSlr1TqbdxZ7EsP0wLZo3/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199015)(4744005)(316002)(5660300002)(7416002)(26005)(6512007)(186003)(6486002)(478600001)(2616005)(41300700001)(6916009)(54906003)(4326008)(66556008)(66946007)(66476007)(8676002)(8936002)(86362001)(36756003)(6506007)(38100700002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UzK5Zq1z0uXJTtz7QonZxGcF040fPvZ7tTH84AXU6dRf9B5POw/SIqvazKMj?=
 =?us-ascii?Q?DCZvDKD15n5mh1W34VzZ2tMuz4aqcL5byBL5QE17gUiSO/HKRj2mNUemCmZ0?=
 =?us-ascii?Q?R2rFG37AOmdhcIAA5qqN+ZR1N9InVHpbPVcqJuhdyKdANOEvFbHogOWdYF72?=
 =?us-ascii?Q?fkUR8PQlXeX30P5jW/C5hxBGyrqAp+G8NJfTc6wpCJLQqr3/RmG4t5iZMD8N?=
 =?us-ascii?Q?L1gpjJVR5MO5CJWCPH1NyClVAxhGq1fzYebKFhFhiGHJiVRFzA6FXmLpYZ1n?=
 =?us-ascii?Q?qe5D7rERHoy6/YKHjn7J1kUnMCRhSyrsSIAMS9f90RT0xyeO/4xQPtnCOPk2?=
 =?us-ascii?Q?wcvPQjT77wO3LmTisNcQpE1KoiTDQYeV9gCUuVVBzAqjtmCX4cbo5UIn/69C?=
 =?us-ascii?Q?bLLI6HixvWMeKYtPPvCJ6khEyYUsn2TZQA5YbXMNAOxx2jqp0NXwsiHxRiF8?=
 =?us-ascii?Q?uFbluWdvX1Od0ensQ0qplvYFPiREWCPCRc9Bre8BSmz8K6fERhyRju//Vr+1?=
 =?us-ascii?Q?M+vv01WkAIpb0HwjdGR9PyM+Aih10Znka7mI0nXS1wwMA8SlwLws5MCX8Cti?=
 =?us-ascii?Q?oa+JDVKI1EUvcjoYkALw+Y93l4Inh+PrhHlLxAyZLBdB47H61RJ39xCU4Hsx?=
 =?us-ascii?Q?eqd4KNG/J6zE27RVOLxvt+8LPKKYMzgwh6ppi4HEB+gJXhdP3NK5yXVdaD6E?=
 =?us-ascii?Q?Zrbvh44bjkLO1ddrv4esYfoq28Hkbyu5p/92lZJgIWa3zTlbd0b636QjG1gK?=
 =?us-ascii?Q?t+A4v//KbkeFfhSXS0Newq6iJDiLJJIHLkWjs50KmjrBcPG7V9jZJ1tS3Giz?=
 =?us-ascii?Q?GLRlntwK3YqIQH64KLZeVZcOx0CHcorvoQmYMLPufJ5E1zeTU0KY9Sguw1VH?=
 =?us-ascii?Q?rX3JN1kFhU7YoEJYXdp94wq8NlT2vLbGUBnP8LpDazpfMcY+ZbWVRWm6ERH8?=
 =?us-ascii?Q?4o+DZpwqtUtb3CKVUU+zh9OtlymVt/gnjZXJk263iUM5vbthZJGIZHCiMLN3?=
 =?us-ascii?Q?yoJOv8nIDGJ+bZrD68R6cHaFzI+BYqy1NNrsjUmMWclIbzzpAWW5TAQg7CU+?=
 =?us-ascii?Q?oUnRXXGZ8Rz4TZdZ7JfI6yVGk1L12/hsJ3UO2eLv76u/ldDvK73cIYVIcAdk?=
 =?us-ascii?Q?nB/p5isuQOcHJ0nILMiT+vaC3L6QbKst1jY+wyfBNJRkeqz7enHx/uP135IW?=
 =?us-ascii?Q?SrQ1QJ+XXDmC0p1GEFzh7RrT3fV/t6r0FImyeM9I9Bo4saMl2MWZV8FZj22k?=
 =?us-ascii?Q?YC+bbsAgtqudhbpHqfK0tIGG445Nz7PLdMBT2d5gguOEUYfcVUOChIAiDO9a?=
 =?us-ascii?Q?x/C8vqZ9T99eCTUZnlFk9Ec53ob9EbxcKdBzKYHAmNES/V/GI9B8u09rruWM?=
 =?us-ascii?Q?2NgVBBIr8RV40n1zXotA5mrhvhUiZnlXVDwFN7/Ysi0iPkCIx6pmQDGLz6Qz?=
 =?us-ascii?Q?dueVjbmZBpO9q5y0BIm/QTrCAhXymMVMFPFoPaYWxqry4tv0cVLKLySMNnB7?=
 =?us-ascii?Q?i3mbmAPMGvh7ZjcueWDMM1E+rcmS2wFCMc2Bm1gEG0R8BvKYCLvPJB59lBNV?=
 =?us-ascii?Q?D+vULG2kNez2qVoiIqC3b+2QCKLEgMA9rWM357+w?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1e84708-ae52-4412-6714-08daf24462a2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:21:15.3948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldtvQrKgpth4YF+TY7O99NW6jyd8FZg+F3w0boEzos1s98s6JC0BE2iiR/0zC1ob
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4096
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 05:46:04AM +0000, Tian, Kevin wrote:
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Monday, December 19, 2022 4:47 PM
> > 
> > This prepares to add ioctls for device cdev fd. This infrastructure includes:
> >     - vfio_iommufd_bind() to accept pt_id, and also return back dev_id to
> > caller.
> >     - vfio_iommufd_attach() to support iommufd pgtable attach after
> > bind_iommufd.
> 
> Please mention that pt_id==-1 implies detach.

Oh, do we want that or a dedicated ioctl? -1 isn't a u32..

Jason
