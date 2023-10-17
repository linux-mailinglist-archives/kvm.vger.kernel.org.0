Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17B387CC40D
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 15:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343775AbjJQNKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 09:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343638AbjJQNKt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 09:10:49 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2068.outbound.protection.outlook.com [40.107.100.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39BDAF0
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 06:10:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EHL1+6+ixv/X7Q1SI7EFHF8yDNwrwwH5PwYO0di70ayBUZcIcDwnvr+s9bODDP9slc+e+FXwzmM0T1XVn7HGAJfFrN0yNMbh+BWVB1+e/K4SIF7pmSubFhj9qxJhlCuTAIOpnwNYRGonJORO9RG/z3Q3a4gWijD05eiWCKXej2hIJC62nTbGGBXgzjuo+JIIgqLMjq3LjlaWh8tmcifjG7r88NMUv4fpLfYWSrPBCf3V2IWUCVmDcaKfTn3UkTnr+rEZGvOPhoB6WH4XXXHjhtW0xWEOx6ONLzETptjS740Sxjg//jr0WqWaBXvKRyH2kluZc/a3naX0eWPtJlOnXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7wRg+7lGUHc4u8sd0D986jnHTWV8NOUnMmdR9hFjW6A=;
 b=Uw1ChpQKyGCamdRTc43wgmlwnr5r1z6HbOgr+Fdr9PAny1uo23Lp6VZfdxK6hKncsDWYUF/M1OPG1bph9ag3v9CwaxOCorZEF6KwIyfBHay55ltmPoYVfEJhpl3imXl1yV+bo/tkPOcpFyCkGBa7L0x8weJS2Na10oaErZGjUltsrqW+K70UH5D30xKxyAPdZspeb6AfEjLLxxcmxQPZBUo+fIh9yUsXnOoyAnP4lE6mzqH4z1zJ6ujn64Pm07J0nDkJhYirEqlSs4GPGTvVTBNAPE7L/tdsD04fwLaWNmgJ1jYaKmF0x3fdMOJ/mtMeCoRDmpunwyxws/BK5crjYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7wRg+7lGUHc4u8sd0D986jnHTWV8NOUnMmdR9hFjW6A=;
 b=Jk+KCaXe6UmXQnPIp29WxFfD8f3EncN4p0/lo5sgYiVRe1AnrhKg6YZPKX0Ius2f79ha5vEyV6AjXtpVS3D78xUxYgBHl+zud90RJNhbi0pTukGvGHcF+O+kCwBAKyDu3H2TxBGmwIK2GSF4Ph8FL6FD3ACyBOMLMPfoSj9B2a+onyJIX3zV2HZLKDShd3hnX9KNHIqc5zCCOyhgVjUnwkOXBXfeOaJnn29HNAm2vXMXOjyc9bnJbSkvgpmvcpoe2RLM2NzA7MXe8l02Yjwv7IyTZvEfFdXCMyi6Y1BTANYFImqsgUGvgTOZauSOEeITs5x9V2q858nP+AdJ5Mzd2Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN6PR12MB8542.namprd12.prod.outlook.com (2603:10b6:208:477::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Tue, 17 Oct
 2023 13:10:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Tue, 17 Oct 2023
 13:10:46 +0000
Date:   Tue, 17 Oct 2023 10:10:45 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 16/19] iommu/amd: Add domain_alloc_user based domain
 allocation
Message-ID: <20231017131045.GA3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-17-joao.m.martins@oracle.com>
 <6c1a0f25-f701-8448-d46c-15c9848f90a3@amd.com>
 <401bae66-b1b4-4d02-b50b-ab2e4e2f4e2d@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <401bae66-b1b4-4d02-b50b-ab2e4e2f4e2d@oracle.com>
X-ClientProxiedBy: MN2PR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:208:239::6) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN6PR12MB8542:EE_
X-MS-Office365-Filtering-Correlation-Id: 77aa4135-3566-497d-91aa-08dbcf127999
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 40EScPOrfnYcDZTHuvqABzZtZ5RGrkjMc33400oEKMo93sBwapkeoOdmPfSYMxIGWmeWs09s6+sj5FX1MhoDRZajbOiZO5nhhLwtmb53QR+5u2LHTflQBwHde72QpFWWJnik3jBEn3L76XqqT4/FC8e7h7PDqvPX/I+LtbV/0aq32iL0xZ0MUVm6Se3Wsx9lmI3WCDv4dfChlYkhwD9qXgDLXIeOATg/Ga/fCW6OJvEIHH2TJ5A0kdHeuMgEGmmabVqxcgR9FwJhZAzyCQGHQfKiO+oAVDvVuD5BoMqlBR2+dhnAEZUdhv1uTFZ0uw+22xA0wiafmJcN3mH2lRxY1qo2BHApulHqpbuS0YAOuhAWXvkyBNTR7owDhsoZ++Cn3IruqRa+dpTnh7kjeJGZ3PzlkJnD+zmwEvVi5XJKU/bXoQhPFyMfmA0EnBiLVvxmg75L19HmfP3kbIsFfzRM3cf43JFRZbxVg0pWIBxAA86mMp0rBh1eyg4YIV//SxRlN8kjy2+GatfeaHqwd1ZWhc8OIxUJEO971GI21Bm7G6Ohf49wQFCDZ+CuuquEOkwX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(346002)(376002)(136003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(6486002)(54906003)(1076003)(66476007)(316002)(6916009)(2616005)(478600001)(66946007)(66556008)(33656002)(6506007)(26005)(2906002)(7416002)(8936002)(8676002)(4326008)(5660300002)(4744005)(41300700001)(6512007)(86362001)(36756003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9K+kubW8SNGFf9Cdq7o8FYTpkb09yS+angUPBwjQFR7oAvwNEjrEcg9Y/4r8?=
 =?us-ascii?Q?GWCRGcNO3BCHXcNxeD/w/WY6JKf7NGhtIRhl8CRaBYvfUcWVNTwuBwNQEPIQ?=
 =?us-ascii?Q?lDaPv9jnr82r5sTdBzEn3qnWN13WduU8fe53gsToWmV2JU+iI6TCfbyEh00q?=
 =?us-ascii?Q?mx5pHjUgelR0+sMe63plkyKvlAZnknOPTuYZ0zU48wVNFgv5MlwqLipNiZJR?=
 =?us-ascii?Q?07QLmE6F42P+8gKUvBr3vo+C94zYM4yGL4PyTNiiHWVKwgo9tZeEsXLYaKD4?=
 =?us-ascii?Q?xevnrjDuCnFELpEE9f/ZatNCwHB9XnSDimO3xH9jSHqyQvXI6zaRys7lq7V2?=
 =?us-ascii?Q?KGzI66Rp2reG6K1EuEgjLgdiRuZpjTrHtjuic/fAKmJsaKSYOTsClMc7Jh/u?=
 =?us-ascii?Q?fet6AIv9oom4TFDPz3+wXTgSHVnOH+LBVO0OIpioFErTR+8wa6s4TtapfjNI?=
 =?us-ascii?Q?tKF8EKTZ1nRMQqUGjZxuMYuoJZ+pe+5YnmOVGugwN7DZMrBUJjvtUg6tPQEq?=
 =?us-ascii?Q?spRgI4mfqqDx7NehXxwKPw7bVLtb7sTwcGzcTgb3QXIiapagvv2FX5JFeSlm?=
 =?us-ascii?Q?OaEeCfnj4iQQkDhxYGoDNaT/kJFNly1FmqpFqVBiuSTlcGlCyfOCL1nuKLX5?=
 =?us-ascii?Q?FAU1o4sQaajUx6QFczvLmr0b9PRC90Z+zAvw4Nzk7S8nc8SElDJNdWfDFrNo?=
 =?us-ascii?Q?/z9alfAx52HUMUf27izQjEPj6hH0VJnZ7RUjyYNTriVKjtDozjahxd1gtKQT?=
 =?us-ascii?Q?/pGKyx5jhPOciam7MAuIYCaNcGP1CHuo3Drr6fU/MItKGEVj7MUZWvhKS0bC?=
 =?us-ascii?Q?+RZ1JowhsG5b1Eh6fglkYyXnm7eFXuANG6YfjVcorZGobLs6IGab48WCJMcP?=
 =?us-ascii?Q?p14EL6v/qdxxNi9cYQ9fDA+xhR8JacPQACUXWog6UVmS9QxMgA+kJQkv+Dui?=
 =?us-ascii?Q?251YkpyKFG0A4NnH+1rL2hzUrNAleWjxUjD7Qia2K9OgyMOf4xj7xelXC4BP?=
 =?us-ascii?Q?LgilKfedWiGAFg/gMPG8J6qeF9OiA9mUo/6EA6HqzFEIHPy/MtNdMhxRBq44?=
 =?us-ascii?Q?/5YtGP8mLNhxw9L7nGAduQwT/u2w3v5+QXW2tHqsQWpHs9sW/jfW+CJw8IZ+?=
 =?us-ascii?Q?IDEG+V2+DokFXOJ+fR542T1QhS02w7XZsVtTVRw6jmEm+50c9bVLV677l1N/?=
 =?us-ascii?Q?jX/dARmhcC4/ytlffuUehVk+gC7/NbmM93nWnKPlDxe/mE66PCw8wI2kJH3H?=
 =?us-ascii?Q?Pm+NpqDfLvoi5U/+np6iJUgalOeKZnDuKEVDvSkNuojaCmdl95pB1PGYN904?=
 =?us-ascii?Q?XV2XfrNcQXXN7RlioFGQeR9s6fasvSmpwhxVhQWb/FnZSUwiXHS/5d1RzkLB?=
 =?us-ascii?Q?x6t8FHZ0aHJr9pocV0vHLO/UHzM/FB8Komw4xTx95VFIOp3pkCdhLFIbEPh/?=
 =?us-ascii?Q?06txz8ciaZ9JHjOBriOYTTBBPBOlxDH7R1Wt8aQB7tevWh0eCxykF67y6gz3?=
 =?us-ascii?Q?zas8h9y+DV6fZ0PXnhtpzucg4JDYHH3F6zZ5SlDygE6h160BiqsjzSI3SR9h?=
 =?us-ascii?Q?EGsN3uOr9dx/S0CsbZK8oaA98NgfSXMWbGOKZE4A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77aa4135-3566-497d-91aa-08dbcf127999
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2023 13:10:46.0929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: svGQl2pqvsZ5Yz4ymcjOFNTqmRNG1ZzP7GU2lp4XsVaZ+7c1ngL9LJA1nDIRnTMO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8542
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 10:07:11AM +0100, Joao Martins wrote:
> 
>  static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
> -                                                 struct amd_iommu *iommu,
>                                                   struct device *dev,
>                                                   u32 flags)
>  {
>         struct protection_domain *domain;
> +       struct amd_iommu *iommu = NULL;
> +
> +       if (dev) {
> +               iommu = rlookup_amd_iommu(dev);
> +               if (!iommu)

This really shouldn't be rlookup_amd_iommu, didn't the series fixing
this get merged?

Jason
