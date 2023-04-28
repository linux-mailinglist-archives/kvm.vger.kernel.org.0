Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1CB96F1745
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:08:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346000AbjD1MIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345939AbjD1MIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:08:17 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2088.outbound.protection.outlook.com [40.107.96.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECE01FF0;
        Fri, 28 Apr 2023 05:08:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EsIkQmkyKMip5sjk6upOyxYzqB/4njkTG6GD6f6l/ATTVbzGDG4i93kFMS4GOwkUVgfq3A9/YxU6dCHVwHnGFEwYdwIY+089D/7fSmJoZ/RcHpiCJE05xn8CiHMaHRswUfZZl7wOq/RJYb0atkPCqISknaFSl0HNUDyHBXx7ay5KVvQE63Os4czCbirEXNKR0NWVw+Tz5FDp9TtnCa4JynLQSvG+KH4O96f8e2ACN+CXbOOtDCfwhfNVD6BUViQp4oeNOuMFeW4YU9czLCubNSs2ymGawz+sydP+1QdO/ywUB8oFEC2Ai3Ldon+KGN2hk853ngJsBTVP8ykDU3oPAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2uImoL4LiVexEFMM/9dLpTYNmMCZP0UiNJDRTYG6354=;
 b=BCjaTdBeMrO688Rt2FcBAyNdrGWibKIVznxkhRtnceeibH/d+YJTZ4Z0Ma13Yjw1T4p3i2I/IuOLoeaTRm8+c9gt80uqqtxcRW+RgsB4cOKY7qoFkGfNOdHu7fL05zH2BwYL3VmRAL7hHEpxvGrc8aqykEUZVP68p4VBCRZev5Kc5fEnoYguDjcLzeO8reqjZ6W6rk66n/lJY42cexIpLHutqhYW6rW3gaBvDR4lw5AyQ9gO/BzLCUtKHFzeZzkKVZh2QsLokgW4SFtuW++WouVYMktRACp/kNnRefgz9jZ/csI2cNtLXteICoDzQ7FfM7gUo1Gvi1PihAX6eTc33g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2uImoL4LiVexEFMM/9dLpTYNmMCZP0UiNJDRTYG6354=;
 b=ugskKAKYJ26tjwCbPUAkGV/eKOLJyQWL0/myvT/l0HEVoEaoXTTE0YlRbEpSPkiFpFZDBeKcbR37lSTaF6in5oJsP/Lijt9OO0Z47WhC7Fs8An0tzsvUYCCkkXdJ6uV0f9JLAYvveeBjyz3d5jBxqma5ZILzz47D1v2IOmwkYOWVjFiWy5Aj054A81C0klbtLFnRAUieEeyuQHFe31bqMDlUNeaX00r0+olKUSRKXPmtKb6k1FCL7Vxm4JBzDfaqf8MUOv+75i948mDQSO51PsquEUhhkXWgV4aR6T+3Zdy4YmCvzjUtJeHXr7PhjcaL4ngIsC4dSDhiTJtLcH618g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB6030.namprd12.prod.outlook.com (2603:10b6:208:3ce::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 12:07:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6340.024; Fri, 28 Apr 2023
 12:07:55 +0000
Date:   Fri, 28 Apr 2023 09:07:53 -0300
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
Message-ID: <ZEu3Ga9cIQAykBGf@nvidia.com>
References: <20230426145419.450922-1-yi.l.liu@intel.com>
 <20230426145419.450922-3-yi.l.liu@intel.com>
 <BN9PR11MB52768AF474FAB2AF36AC00508C6A9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB752972AC1A6030CB442ACF3FC36A9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230427123203.22307c4f.alex.williamson@redhat.com>
 <a6b77884-1678-b17c-f6a4-28d56e6c366b@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6b77884-1678-b17c-f6a4-28d56e6c366b@intel.com>
X-ClientProxiedBy: BL0PR1501CA0006.namprd15.prod.outlook.com
 (2603:10b6:207:17::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB6030:EE_
X-MS-Office365-Filtering-Correlation-Id: a6d4f4be-470f-4942-a83f-08db47e132ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sQsRQApWphFtto8gTMqI2qR2VE1FDOBMifsEUgBQg85LmIiAeCqKCmARR5zhI0XFgX7fBqH4LBtSID558r5RXnUIo5XNuagkvyOspoJlvkUczX5UKKpskpstJKwD/awhLJZV9dufQhWnNycu4no6sqIodL9//d0Rm5lDTCw9h41CMrtg4W7P8U4UYEu5vtPxFk9skpMlsP4BTYvVQ26U1IR71qHj48T9C31e+IPlsZ93lgFkEJusxv5eTOWaO9Tpy+Dlik9jYmhf/IQbQ1y1IOBKT92pp0PiXcPYYuXgF7i3cR7d/nNHO5woysftByGQfQKPSt40m0QmDYAVed2kz6JfriES1QmpsvAFtYZ0T9+KPwvrruh/sWhVDETHBRZ9vJ1zngVm/UrIP6CIHZhzpb/2iGzdL8oPi3TuiSOqKvYNw9YAN+DAOATMRS74bmrGxi8iw1nNMxVFiPgCuiLZyIUUYbRIE2/z5NOK5EXGwIfn4tgb2en+l/Ee6vsx1Nri57Fd/tDwrjYT6L+J1KepqpMGrDCNNtGPAhOOxuWK1euH2nhIUbj1FERtqO6V2qE/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199021)(86362001)(186003)(54906003)(478600001)(26005)(6506007)(6512007)(36756003)(6486002)(8676002)(8936002)(2616005)(41300700001)(38100700002)(4744005)(2906002)(7416002)(83380400001)(5660300002)(6916009)(316002)(4326008)(66556008)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?spgQbcMN+Iu9SGUGP//NdMubjfGbDSyrVtijwsBIK9Vksoqo5pvcksFpbcEy?=
 =?us-ascii?Q?z/9oOmXB32DjwutsuPOeF7V8onH4XOckE9MJnvnQkfNW/aRbfJx3Vh1bwm/A?=
 =?us-ascii?Q?AU09h/MXxwFzGvqxJ+SODJXaYkoT9lHNtA+ZzrW5CywGT8q0fk2rlv1YYABN?=
 =?us-ascii?Q?MYcN68xoXTh3HmTJK6gFwsdwHzC+h/DtPg+uGrxGHv5bMW+ycNjd2Pua/lNh?=
 =?us-ascii?Q?/heAtSIPBGiw50iZwfVY5T2/t2Gu35C53kRQnQohqdltWpOidQMq7+E+qmOW?=
 =?us-ascii?Q?UB/5GCdaXzDH4th8frUB9f2hfekc6IXwjctsN0otsMtwNMlx7xdhdL1LMa5C?=
 =?us-ascii?Q?kytwXB0Frb4oRZF928GLW9pHJvtp98+bepZr0wZNK0wGxAcbbxOOlYYP3sao?=
 =?us-ascii?Q?8oJeyrwN4iBB8a1kJLOFOXq0teAGV1nYvVCrd6ASwxUrKU17Ct2npbJu15J1?=
 =?us-ascii?Q?+c10nXLLvC7GKqddNIUKr7G+QA+1UgqsqmRRTcmYGZNy7WlzI41LX4DqV8Cy?=
 =?us-ascii?Q?q3J2mvp85QpuMl+Ct9yu/Tl0JM16N9GdipcwdbnamrdQrdrHYQzhsZS3/tLW?=
 =?us-ascii?Q?jbKCYbP79hOCF5sC1/87w3vpD0TmVgjxxxkYUUX9WgX7naY6GcHThODHnnX4?=
 =?us-ascii?Q?bcKwf4duqkr8cdLBU7EQ9wnAIHlPRuMcZVnJkx2nV8EsNyNxcIK/Kwpqjufm?=
 =?us-ascii?Q?QMSpJ+bW255eOevDS1viTaJmVeCypAUvai3/SSr8Vrru5MzKO0s8EiVB2NT2?=
 =?us-ascii?Q?cPrYishJSSo4zhTN8WVeQrzsKgQe3DXBv9E36Uop6f4NIKqePM0EKSPSiJiw?=
 =?us-ascii?Q?SFQQiNxjqSRVgPRLaBMS5CVUl5cCr13EA5O5Skg1/LKCDX9bah1sLioxLj5k?=
 =?us-ascii?Q?OaxP8mShcw8EwZPUbrXOIrGlr4vYODZYVvoWI5YuG5CrdAWqHhSu/Lj2jVLh?=
 =?us-ascii?Q?cp1V8bnko/4jlGf0GvVZsNJSSIsgDZnj72tMUlYf13oA5LxHF57D+IK4Gsi6?=
 =?us-ascii?Q?C5z3m79HuxIuTYPU8dlI+T/OWG4j73Sr8nWGb0TTK2R2RYM809Sw5Am80u+o?=
 =?us-ascii?Q?8etBN2Q1b2XixmHAuLzb/6NXGczvWlMfV7mOfDIYlC6giHvFvu5hr+Uhdlpp?=
 =?us-ascii?Q?gn5wxBVsp2WOnsiGd8oRms9BtwO/Ke23lVwe7KHszOxWsFgwXuBG25Y1a/gm?=
 =?us-ascii?Q?kYwewoVJ/dg7m2m/XzKZzG1XYMmb1xoRTaL/hbWavW6LjXf5vzO682FkiGzA?=
 =?us-ascii?Q?kkEpDrp6IAXCZu70zqce+v4hsZfnRXbVHjbgqPklkOoL3UKTnmqnXJOkwKru?=
 =?us-ascii?Q?WVt4HckVVc4Z11IHhoFibrlsMwG3hy602JQ8QBNiKsqzKleohGsblCF73c+e?=
 =?us-ascii?Q?u33fh750FK+chHLWByG4YB4fHcOvt2ULZ6i7U54AGgFFPmD0gLHvMBl1Q9sd?=
 =?us-ascii?Q?wzvp9MVj5NqNBUCkSVFa/SeaKnVsFI3HPuetTMhxh1b+EByzhJ4GgjLocUb7?=
 =?us-ascii?Q?5RdF4ELSd7vDj5sJwYjoZDSqDRuPOkMKZ+Hhe+neyrODp1crC8gVTbFHZ9VY?=
 =?us-ascii?Q?fZhhWuCRYlu4En0agCuUXk3SKDnHvlZGEsXq9Oiv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6d4f4be-470f-4942-a83f-08db47e132ba
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2023 12:07:55.1201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HNewE4Wpio7+dKi4UxJukqb5PFXm1M1akJ3SkzkGbYFWvGbWHX+1SPn3z5rs1tvW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6030
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 28, 2023 at 02:21:26PM +0800, Yi Liu wrote:

> but this patch needs to use vfio_iommufd_emulated_bind() and
> vfio_iommufd_emulated_unbind() for the noiommu devices when binding
> to iommufd. So needs to check noiommu in the vfio_iommufd_bind()
> and vfio_iommu_unbind() as well.

I'm not sure this is strictly necessary, it just needs an access

The emulated stuff is for mdev only, it should not be confused with
no-iommu

Eg if you had a no_iommu_access value to store the access it would be
fine and could serve as the 'this is no_iommu' flag

The only purpose of the access at this moment is to get an iommufdctx
id to return to userspace.

Jason
