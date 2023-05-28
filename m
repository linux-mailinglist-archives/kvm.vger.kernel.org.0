Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC4E71373B
	for <lists+kvm@lfdr.de>; Sun, 28 May 2023 02:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbjE1ACS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 May 2023 20:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjE1ACR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 May 2023 20:02:17 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2065.outbound.protection.outlook.com [40.107.96.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CDDA7;
        Sat, 27 May 2023 17:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9nCkmOFxqAxobnMVv7hNzj6uZ+TE+ZyDSuZtkEUezN8=;
 b=NoSL1hYSLH+hCjjvRCWtxRp25pim4IWD4morYIFSc/ApLJPDafcdYG0mojVyAUYQ/ZtSd4zoK79G/LpM9kUzMm4MZF3nnqBMXuDEmaNqc2RXxi8KjSP7OQVbXdiz+rgfCzWczuO0gZCpldEpSmuI9Gp7B6dopFYOXjE6nvZ+XGKB3FhSTiilMVeZnnklUmEb+j/0B6EE2gGV7Lf8gLtP7htsf4PPU23dFB6NH7i736/VLWZFirYz0W0lE+3O/OPecdGsLvlkxP2FbA4ouXrx8pZGQOV5UEnEnCmx3mMSSs+ORff5yEtiK2cjxQQoRb0xylUL5ova99C8uwDGXE+gUg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7224.namprd12.prod.outlook.com (2603:10b6:806:2bb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.19; Sun, 28 May
 2023 00:02:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.017; Sun, 28 May 2023
 00:02:13 +0000
Date:   Sat, 27 May 2023 21:02:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, will@kernel.org,
        catalin.marinas@arm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, robin.murphy@arm.com,
        nicolinc@nvidia.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        zhi.wang.linux@gmail.com, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH 2/2] arm64: Notify on pte permission upgrades
Message-ID: <ZHKaBQt8623s9+VK@nvidia.com>
References: <3cece716fc09724793aa832e755abfc9d70a8bb3.1684892404.git-series.apopple@nvidia.com>
 <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d8e1f752051173d2d1b5c3e14b54eb3506ed3ef.1684892404.git-series.apopple@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0427.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7224:EE_
X-MS-Office365-Filtering-Correlation-Id: 639034a2-e5c7-4949-2fd9-08db5f0eca99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kAZYL9mowSl+UVRAC5LA12XWZBraztQTfMbc5k1DgjPwImRto7l64Bpnx/O33zi9DJRIr6WGEQ84bLmTR5ww25EgFRrT9BXXi3KbcPjQ9ztZo2yCqVEeO2oclPLA7+F+EqcXyelrDQG54P2yW+DDNpdvL290CiMg+MKC9XmLv1SNlMDEQXP7uX5RPzU6B98b9R2RCZzgbld/v7SUtx0dTzyThG6HWiEZprdsDIAr6/CyCCWOWx3HD8GAD8XTFd0Ox4/kY4LeC6FswE0J0jZglua03pPEI8REZfYJ0jBRP17YXeJ8yiSqvNj6YgNH1vvrQctfDLWpY3MD9zHcHQVVqCvsE+6VjVvH8QvNqmZDoHFFfoTgvVQ/ti7KOoY3eRybCKuC5yABvcQEcF3n+oGoeB5Zy+Unbl2FcyW19OMScZ8L8J/HqXE21GbRqSfz/kHpaaJs+L3UV2gTSs0O/WhyHn9XZdBAFoahaFviPv/NZkS+H9wItf0+Two9tdlPw9cSy1X80BllQAbothbE3M4YXJxlpOzRq+hP86o5YqJ9vjFuauh41z/F27t7ZND5Cla7zjs1KM6j6h6RYOV1ffReYBCawiKnWtFm7TeVs436Xo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199021)(316002)(7416002)(6506007)(26005)(6512007)(36756003)(66556008)(66476007)(66946007)(6636002)(4326008)(38100700002)(5660300002)(6486002)(41300700001)(8936002)(8676002)(6862004)(83380400001)(86362001)(478600001)(37006003)(54906003)(186003)(2906002)(2616005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lHpEOu+N+n8/huC67kU0jKmA3cv4uo5uMQ3O0mjD81HeufLLEeEVTh0JLIgW?=
 =?us-ascii?Q?MN42dkNB1PMzdVul+HyW0o/O+K7987wTiVjPk1N7FblCqX2dk6O00FmVAmMn?=
 =?us-ascii?Q?/BQwvEMoRQ4gqmiTwt86CEV6rLgwlEsz+Qi/VuZEj8aHFazXAzCwQQXfYUf+?=
 =?us-ascii?Q?auXODap/vSubioZLQCeTmzWNXIIu7qbFBecvGaSYM67gK0AkMhab5dDzkVs/?=
 =?us-ascii?Q?o6o8Sm5IB/adNZoOYM//bZsC43NZqruY/UlbfSwkRTPCcrOn9nhR16jCB2KY?=
 =?us-ascii?Q?8dS+f7xnpmqNBMEor/QAReLcp7sKJJ3FzPj1v8zieXJIWY8SdNJM19HRVcr6?=
 =?us-ascii?Q?lUBmGWyiXemwQyka1KIBfNM0UvA+H+Z8E3UGt5lsIpQbNWw+JhxRfiPBKk0a?=
 =?us-ascii?Q?fxrkgEuSNvyu/7QZ65lJRUuqJx6PfIrQRA/somegM3LnhehUEdYVlvAp/lD7?=
 =?us-ascii?Q?QOQyqH2+/ynGQ8gm7Kna1R5clWOxWGOi6F1TeScLtD4LTBryeYhp+jsgTiBJ?=
 =?us-ascii?Q?L4lqiUPO2rsy4HRfcmW5q9/pOlsmiIGhYo9DXBCZF1inkJvZT5xo2cctuysL?=
 =?us-ascii?Q?qyazeAggwSmhsVi4x3ylnKQNU7UL4P1Oft632IkqwWK44OvWtFVThtg0dI43?=
 =?us-ascii?Q?wkvdxF5ZOe/9MnlgmBNuoGt7/2bsmxLvkQf7V1rXUYQDVJNb38QFYZF7JjEU?=
 =?us-ascii?Q?Aaw3j9ekejMoLrTWkpdciaAf7qSLzAsLOXz6yfBSN/zEpYGze7BJl6c6n19X?=
 =?us-ascii?Q?ihLrnAkUxpuehTsqiP8cj4r/+Yq/bhXGyhnbxzYfb0Ci3uZEds7NAC/4Ymoz?=
 =?us-ascii?Q?sPdwCvK0Jpas9hLz1xvqA/x0hfYHrJ1P3igqQzUvu5im1t4wbB5WelSlz8an?=
 =?us-ascii?Q?NbWMiL25/juNTsojhfmiW30EsR0oDUj9Gc1Zn0v5x7re57np1Wt3MiEvdkau?=
 =?us-ascii?Q?kCSt77eRVMX4dWu1zKdHcwOEiUMSb6dWDNT7xQzcO483BCfBgux/v3li6U82?=
 =?us-ascii?Q?OaUBiZgB3W5RU6BLhbXcMK1p/gVBhXwmHFmzLxKQIAYeEOZ7xBvjgcoUFpjC?=
 =?us-ascii?Q?a8adABI/LiXIz7CE5dswb6UR7asmEQh+AemTQqcZrBb6T008u+HlmHXfcvrY?=
 =?us-ascii?Q?CH6iK05K8kANp+b6rwdq7iWWYNY0XZM92TDX8SJFzkv4hmpCnwZz7ZgyVbBP?=
 =?us-ascii?Q?Khgcx3c2sXA96YpKWL+Xh+NdGZFFoc4GJIIZJAko4TY4WipG6f4K580qy2es?=
 =?us-ascii?Q?hPL2nSGEqXKxLOfVnfB1rREXT9umugSIiEROiBn3Zqmhmmn0pf9lUAlqa+/b?=
 =?us-ascii?Q?fuO/BtW0A+NF5a/R0H/zos4zJCVl9JMuUx09gVxGWzAJAF4Hr3KucKOJScie?=
 =?us-ascii?Q?CRhvKLlasNb2FwQyppis2NiGlXXgs4CNgwhoCIUzQxolepl2ONLafO9D4iCw?=
 =?us-ascii?Q?/ks+Mc1NdoJ9VrANgLSKwor7StlDjnVrDmYE8N2iisGr6A0LGzkzZINP/hT8?=
 =?us-ascii?Q?+PDRpee9e7aZ+4QXjrr/G8IrifXAkAX2qzcoYyf2VM/wQAWRLcacMyveaLgd?=
 =?us-ascii?Q?yB7VL1g0KcFXgtxdvkUZ5Ab3KF9gX1SLi16uqY3K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 639034a2-e5c7-4949-2fd9-08db5f0eca99
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2023 00:02:13.7903
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZljLCsotoGeRcSaOOG1Vj0gssEmVPYxI/nN44D8M0mvcA2ssoLzBJ0jLgMMF6EQx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7224
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023 at 11:47:29AM +1000, Alistair Popple wrote:
> ARM64 requires TLB invalidates when upgrading pte permission from
> read-only to read-write. However mmu_notifiers assume upgrades do not
> need notifications and none are sent. This causes problems when a
> secondary TLB such as implemented by an ARM SMMU doesn't support
> broadcast TLB maintenance (BTM) and caches a read-only PTE.

I don't really like this design, but I see how you get here..

mmu notifiers behavior should not be tied to the architecture, they
are supposed to be generic reflections of what the MM is doing so that
they can be hooked into by general purpose drivers.

If you want to hardwire invalidate_range to be only for SVA cases that
actually share the page table itself and rely on some arch-defined
invalidation, then we should give the op a much better name and
discourage anyone else from abusing the new ops variable behavior.

> As no notification is sent and the SMMU does not snoop TLB invalidates
> it will continue to return read-only entries to a device even though
> the CPU page table contains a writable entry. This leads to a
> continually faulting device and no way of handling the fault.

Doesn't the fault generate a PRI/etc? If we get a PRI maybe we should
just have the iommu driver push an iotlb invalidation command before
it acks it? PRI is already really slow so I'm not sure a pipelined
invalidation is going to be a problem? Does the SMMU architecture
permit negative caching which would suggest we need it anyhow?

Jason
