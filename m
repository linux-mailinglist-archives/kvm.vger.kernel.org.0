Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B783E524D54
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 14:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352118AbiELMrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 08:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353877AbiELMrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 08:47:31 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2047.outbound.protection.outlook.com [40.107.101.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DB01CE61C;
        Thu, 12 May 2022 05:47:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lzzmg2kbGd775lLtLPRi5KWX8QUeP9NaSwLnJebPjsonnGO3pW3vrQ/45S3NHlf0ZcNkAgnS/gdRQagy+7cKZxdQa8Do9j92Q4elsvG4sIQn0y3wb9NZFcyHpTzpAQ0sFT0XpR6vvNCcFB2eGIp/0htL8ekdc2r+bQNoybumSSvPflAvwhf+JO9/EZgFVRfzY7+h3lL3LDvlxFZdyYVJ9UyUuCVuGyfsRZUQfcAX4wEnVoDNMfIz5oIoDog/CX2QpgFya2yG/zeumJnjUPLJAmZozFnHJ/ksC1PNhf5BG0JrpIQWNb3007aFRjqwuM2JOG44xYCrm5ivYuLtHnfL7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vXjAZ1pHcEeVbisSpg6yafzfdOLD9QFuN+Op1WWkhXA=;
 b=Ur8Oti+srKKGaeW/u7KWCinhQe6EnO8w5uok8EFc3TnttlKPLJnul5SxLlt9ZnRSd29Uz4D/9e4vfVUJkH596B/RVBnhAkrLZ5N0YGak4cYHPCg/iStcyElsKdDBbzbYiA/yW3h9WodETPiO1FGwNL8XAFuj5WTjSjIq8b0qhkU1Z47MhLa1i7IWGwVtbw0MNDiUuKOzlfGm1+FBWRTvxGNy2KKbYHk/8xi9y0Hy+S1c4JJaIxJvdtLb9xUJztjL+HBNpx8iVLAvnKyTi7agedgjROV07ssAOZwN+Py8HWv+THhnw0C3md86e9hLSV11lmPD5I51Q0dZnoR6RqijAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vXjAZ1pHcEeVbisSpg6yafzfdOLD9QFuN+Op1WWkhXA=;
 b=HeFngArXKthD1FEIiGAzzOSXmEIP1C/P3f1C1WRrPvf1owgATSi0jGqaeNnCiHWRkfkwnz2PLi08/n61jZo7HVn+igcj/BIZASOaQ5o7sdguUpc6077dmpMJbU7pnEOULWP/gL4bGTCGxGRo75JwmW7uZw26d0hTzwUmPUa+viLaYLyTwBxI6Qq6KqcW97q0HiHJ/VvOMywCO6XnD1Q2iughIBVnGe75WpgA6a+ZNbiudKFqSQTBKQ+ZP6NVs2it2lYHsw7VeM1XQjSrX+6abdW/WWvnPn6/olQ2s2htVs3YI/T0+HvmU54IDXDR0tR7KSynqIUfaPm9ldjMDTbcpA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4619.namprd12.prod.outlook.com (2603:10b6:5:7c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Thu, 12 May
 2022 12:47:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.013; Thu, 12 May 2022
 12:47:28 +0000
Date:   Thu, 12 May 2022 09:47:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Abhishek Sahu <abhsahu@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vfio/pci: Add the support for PCI D3cold state
Message-ID: <20220512124726.GZ49344@nvidia.com>
References: <20220425092615.10133-1-abhsahu@nvidia.com>
 <20220425092615.10133-9-abhsahu@nvidia.com>
 <20220504134551.70d71bf0.alex.williamson@redhat.com>
 <9e44e9cc-a500-ab0d-4785-5ae26874b3eb@nvidia.com>
 <20220509154844.79e4915b.alex.williamson@redhat.com>
 <68463d9b-98ee-b9ec-1a3e-1375e50a2ad2@nvidia.com>
 <20220510133041.GA49344@nvidia.com>
 <fdba8dd2-4db8-81f3-d9d8-4742c88e99d9@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fdba8dd2-4db8-81f3-d9d8-4742c88e99d9@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0010.namprd03.prod.outlook.com
 (2603:10b6:208:32b::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bcec5307-3100-46a0-ba6c-08da34159256
X-MS-TrafficTypeDiagnostic: DM6PR12MB4619:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB461901559C263AE9A9F16DE6C2CB9@DM6PR12MB4619.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5yv1tyTxqAJeOkzQWY5gKjNtCyP7pqnvad4Eb62eIBugyiU9EdG34qYHiyf9TOY0BuV4CKo5WBjcy4nheXv3KgKF/AiENbt7U1gqDtlj5RJ0erMgCJpAwRoR6wPkFGNcKD5V9a2vVKuFow7UF8KFrBVXHbriqHbv0ipPSQqDP++nAQGpDfJvwWbePaK8Mu/qJIrrGSkqXrDxIUUovLnXQiKq1Mte4Qx0/aEiYoIGoLD3knMoOlPhJLA1TZbE5f6W4DTa/DI4ieyHXZ6IE6o3DNixZRKOiLYtD5VnlEbmrHT7l6x2zoODMy+X+H08+0CxgqQKlI0akIgwr3nYAIuM1bAVCMIydei7RVEnAtI5DZgPvHa3x/QV+9vGfRbQkAvHaJBOq9I7hxHBtY9Gus4x0leqIkGgy0ccjS3zGVIwb+UFkrMfttmdm91HLGp6gdA9EM5nC2uBBTDu6ROeh6IJPAVIIxRXC/bIcy2swJ/WH1LvURvgOJDaZxHY0LqB/1IBTT0Pog68+ckQ/j0Md06+RsDnewHEF8aSO0e7koNSUabdG/hXePFNlC5F2Ew7LuddmjuvirUCJLrVEtcUBMwlNLbc/WCol8dIXrkQQi7RpzgNFkgYEcgSBGmB++uBsMEIxNpg032cBz5UrZx681BTLzHnGFyzwY+ul12/vRix1gRdRE4AfFicBd5xPiuvB+uW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(186003)(508600001)(4744005)(5660300002)(8936002)(33656002)(2906002)(6486002)(38100700002)(26005)(6512007)(316002)(2616005)(54906003)(37006003)(6636002)(66556008)(66476007)(66946007)(53546011)(6506007)(86362001)(8676002)(6862004)(36756003)(1076003)(4326008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ly3SbTCHR6f18aPMLgCFkn9/VuIHm5PFzWnZAfeVYzbi3OjXxHj1e1FdXyFl?=
 =?us-ascii?Q?26mk+8DE/KxFVidATfWXFoJLOm793/JdEyR01gOikaNTV2bmYAmuPqDGV1gc?=
 =?us-ascii?Q?ke+UguK1DnpviYzW6pZpOLhW+dsUmcolhrqKsnFDoB2S1h9rKx7G6YD2JP40?=
 =?us-ascii?Q?z9z3++FDQWEeFUKCn3KcdIVwSLcom0kLJKC1vHZUtMN1ui/zyR3JQVySHM/C?=
 =?us-ascii?Q?hF9ENSAx+wuZdcsoe2ZF46oor+qEwTrCAc3CZMUigi7kXFTaDXvHqPeVwdLG?=
 =?us-ascii?Q?nQWWg1GFhwRuM6HFwh/7ImQO5wLl+TFMus5G1qF8IbBSoKEjBtfS3aD8LEz/?=
 =?us-ascii?Q?6I54RDtOK+6n/HsrRWDCWVNJxeuVdEWPhNVnkDl+IlfcgrpsCyaUv565XkKt?=
 =?us-ascii?Q?RBxsetJb5sDQG7HzQM3ZYO1sxQ/2ZVCU4VboL3T34NDzLltG+iVEmhJELDik?=
 =?us-ascii?Q?HxlymsGOq8Qg5SmEXCZrgin98wH883znqFcHLW9IxVTOWfnWxsaoxQPFQh7k?=
 =?us-ascii?Q?HkDbEIwErIfRYD5v42OC8dDOrtERBBLPVyoKJle8z1K1k13eztz+NnqLzkOh?=
 =?us-ascii?Q?wFD2li/XrOkkFVoHBw3ZGXWjDM4Qo66IIaw3RVLCEyO5cZxbA1j9Em6Acc6/?=
 =?us-ascii?Q?vm8spVY8AxPJqq5o5QY78rwiGYAFUzBa/5Mbw14Gs73NdswMVoWXLg4zgzot?=
 =?us-ascii?Q?kDJVmTseoRjr7x+1VfjY786sWaasUDsZUOzgxX3jMDGKAkr9/sOEwDqoj9Y2?=
 =?us-ascii?Q?r+dQ0lAtvZhMDHrTTQrbhEqDSQAXbl0YkD2Zm2EDQXNVtrMH9iYYK6HMf7dy?=
 =?us-ascii?Q?ASI0RmcN/IYg69JvCfRNyVt+qA6fzBe2WKXBUNvk55HGZHQKpIAOZUKuDSR3?=
 =?us-ascii?Q?HMLEsjHqJzzkmKbZpMdsHtAdEij3DCefMpJJI7YvIKVp3w4db+KJ5c2jp+b2?=
 =?us-ascii?Q?l5EHcNQFn91Ios+bSVYmrbsJqo1agHqObuzZvIYyDn5cBwUMsUSI/f/42PI2?=
 =?us-ascii?Q?/s45iPh79iyS0SJTzyDitEcOyrgDhLgzS7eTLZAESEqjHfEeFxIV4lzhc2VD?=
 =?us-ascii?Q?hC4HheEBZycXK0TY/LAYcMX3Ob+cNGAhH98UIIY9b9fgcm//J7MrK099C3pr?=
 =?us-ascii?Q?HM27bWFTmZQoGmbczyU3YB0jepgbf9aSfPHGil/30jfG8h7O5K3yeTKb2EX7?=
 =?us-ascii?Q?yAhqVAU0BzCjrqeTHGTUN0vNI9t26EBMRnojPjMXvEYrefXES8t6Vp0R7K6k?=
 =?us-ascii?Q?9sEV1oTZOhvw+M+eS6oM1ysMfq+XbPLohhw5JijtvP+9inR05zxym2NWiOB5?=
 =?us-ascii?Q?EIbwuMO0nQGuaywDwcQA9Egacrf31Fz6W3AxhV6JyShi5zTaZmQ9+UM/lqMY?=
 =?us-ascii?Q?9ahSBOixO4S54ltKqu/3D/W6/HvsGfov+gZO/o6KvrWmzX7CqKs2eh+3o7YL?=
 =?us-ascii?Q?zP5hW+S3ZjpzdzoqGTuMhk/9G646uBlmrh22Dq0Pd3iJ90T9CW1b0ITBpfnB?=
 =?us-ascii?Q?zBU3Kdppo9vr6dx2B4YKFiIsZzKs/Ru8XeeCsMUK+RozsDmacWpTvU1nGj9i?=
 =?us-ascii?Q?tVuu9M/21x+vyEUMiH/pKNk0SRybv2/sxYMdM7K3SWU0W29jhghkNB0SBRm0?=
 =?us-ascii?Q?IclD4xoyT9/ALf5eI9nN2pUG5TUBAUgK+5CRNThZbxCdbHIB2FoClcZrGrpq?=
 =?us-ascii?Q?2hoJQE+Odq5UzCk6ovUkyGmL2e8D1p5Q4bvtkaJOoPjW8FGMP6j4n6poyAL6?=
 =?us-ascii?Q?8AQgzLIhFg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcec5307-3100-46a0-ba6c-08da34159256
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2022 12:47:28.2348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mqS0HdFU71EO0xJl1vDtd5AlxWHrJxMoIu9CHYRXkX41wXvkJsISovoDIqVxCbft
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4619
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 12, 2022 at 05:57:05PM +0530, Abhishek Sahu wrote:
> On 5/10/2022 7:00 PM, Jason Gunthorpe wrote:
> > On Tue, May 10, 2022 at 06:56:02PM +0530, Abhishek Sahu wrote:
> >>> We can add a directive to enforce an alignment regardless of the field
> >>> size.  I believe the feature ioctl header is already going to be eight
> >>> byte aligned, so it's probably not strictly necessary, but Jason seems
> >>> to be adding more of these directives elsewhere, so probably a good
> >>> idea regardless.  Thanks,
> > 
> >> So, should I change it like
> >>
> >> __u8    low_power_state __attribute__((aligned(8)));
> >>
> >>  Or
> >>
> >> __aligned_u64 low_power_state
> > 
> > You should be explicit about padding, add a reserved to cover the gap.
> > 
> > Jasno
> 
> 
>  Thanks Jason.
> 
>  So, I need to make it like following. Correct ?
> 
>  __u8 low_power_state;
>  __u8 reserved[7];
> 
>  It seems, then this aligned attribute should not be required.

Yes

Jason
