Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D4D638BEE
	for <lists+kvm@lfdr.de>; Fri, 25 Nov 2022 15:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiKYOPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Nov 2022 09:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiKYOPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Nov 2022 09:15:09 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5192181B
        for <kvm@vger.kernel.org>; Fri, 25 Nov 2022 06:15:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=isqoPCFNpcaqAAZRX2ZNw/a7EIEQSjMsVIsc1883nreStI28DW4/amTRWmgTW+y9YYOerw7jcd8W+R0LlDGZhcA/COKFfGXA6KTWZ+muR/OZ0rkJdeG5y4S61W/wUGjJ+NxM3NH5OLI0QQVYRt9w8IgZDQ3vtGlgpAbfM9MRZBVNvhbSGh57/Z/zszex2VfEk/jua3qv7tzfe8wblZudPeQaiJlUvRt8G72a/DhMSPotx1s0761RUJYNDuyFXmharY2/jiLh+6jaZ8bpMLkOblDr5TT9RSKhF7laKwwgfZLe4nIArVxTYsOSBtdtzhW/7tyV1rMR/e6fLuNIHxu7QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=970iXUvuggT2Xfadyk70m0x2HFVsOV+Tn8TsMKCw184=;
 b=M2hpg7tkBM03/f+NZH1KRz9FOtWUWNNVcc/w0iDTiS2BjjftGiuQH8EvOpGKCzByNcc6Q7mU+EiSijZPFRLMYCQ418FFzsXTC8QV5+ZweaRygVGAJaCRu8lGP01DmxNOyJkpB4ONmfi5YdmlzpDHiyhUSU1wOiDEJIe7tagMeRY44eajxjJTcmRHlS0EoqZ5gSKFYdhWnPqi39GbqGDsW9NYkA6rAGFdQ86le5YEtgcdWJvFGJuKLP3nImKWE2KMoLpNyKFKjHrth3f5ox0zU8z+c+jNO+M3hdS2cuoy6lVG/Zqg70C32tRZgjjwwjTBynnBZ1VcQq9tDGJgBuu9Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=970iXUvuggT2Xfadyk70m0x2HFVsOV+Tn8TsMKCw184=;
 b=PBrmGHdiMxeYjUWCEx0ZMNreQiuraRt35uMT0pbIkPrgOCiYPt3d5ZoXJZrKtfGcdBw0TGsLcp8l3s9H3dd7T2e+LPtyrn1m9t35cp0PgquUtxRONCE5cuc8ixWg6wjiqNxfcBivMdPlB0oXrUjKMrKkAvHdmZkr+9t3XHP/hievwW01nQ5mDeHOOXuX7Ru3tMUAEInlmU+ZggTIkMP/9qVZlsw0p+meqL95NsVyplyhlS7Ob8kcqT0tDKCwr7BJ2AI07qIXJxg98bIBWwR4hq6GS+PUM+H6CzGle9fb7GEXYAu6oclNwk1hAewCNU3QeuaukA7AAsvmLXCF31KGUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM8PR12MB5397.namprd12.prod.outlook.com (2603:10b6:8:38::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.20; Fri, 25 Nov 2022 14:15:06 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Fri, 25 Nov 2022
 14:15:06 +0000
Date:   Fri, 25 Nov 2022 10:15:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        eric.auger@redhat.com, cohuck@redhat.com, nicolinc@nvidia.com,
        yi.y.sun@linux.intel.com, chao.p.peng@linux.intel.com,
        mjrosato@linux.ibm.com, kvm@vger.kernel.org
Subject: Re: [RFC v2 08/11] vfio: Refactor vfio_device_first_open() and
 _last_close()
Message-ID: <Y4DN6Q28mVAm+/w1@nvidia.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-9-yi.l.liu@intel.com>
 <Y3+GHbf4EkvyqukE@nvidia.com>
 <955100c9-970a-71a0-8b80-c24d7dbb35f2@intel.com>
 <Y4C28lraaKU1v8NE@nvidia.com>
 <f73ee554-807b-0123-bd93-3e3ba24feaaf@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f73ee554-807b-0123-bd93-3e3ba24feaaf@intel.com>
X-ClientProxiedBy: BL0PR0102CA0041.prod.exchangelabs.com
 (2603:10b6:208:25::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM8PR12MB5397:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a53cd04-4b30-46e4-71c3-08daceef7414
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QFeRDoc72WeH2wHcFV1SbXiQ775BWxkU64kToEM23JM5RubFJ0EYPw+qQaOUIUG3APAkdpn1KtUOo8C+C2/KGycGgdsHZlgcaGWQv31tA/QrvgVncsnenG/y+ybMVwt4NkvfYWH+R1VkkJl1iorFbplg9mQYZAtHGoULmlFbfph/F+3XV5cik+wC5etzwC57UyNlgWPgYpn98N1wU2nAMcaBac7B5jf2JuMoF2Al6IX173lNZCBvcvdGdQIVpqnu0+ca1N5+6bgMA+2iRJQ3NWol730UWTe7cHx9gEngDBGXeSQ29aRlsrhuj47ylQ6ky+eTxPRNncZ7yANFW6o1iv6r7GzCUYMAFADTcMoeaNsuyNUshmSKEEDI/2ps/8bYvg/FfL7OC2/fMYWtaCeXbpeJgqDbMFKYUjmFYNAbiCWnMSZe8qyuP/8o/pTJLBWIhk+yJZgEfSw1B+ptS54F+KTBUiGNzt70Lb+W2IbdobKU1n+vo6C7tneCvpdM6zbNkie3cyuoS2iRL2ygeUhwnppASYhzoyJgRXqbWiwWVvI59KM+VgR8Lpc0YpQHfLN4qN8DV5uQe/rLqzrqX2Ns0aAFLCQbOJQm+MJBS4AqoSSArs9iIlYdQtcbd03Erf9bK64VCgklnOmacS4VE9vM7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199015)(36756003)(5660300002)(86362001)(4744005)(8936002)(2616005)(186003)(83380400001)(4326008)(6486002)(53546011)(6506007)(478600001)(26005)(6512007)(66476007)(66556008)(66946007)(8676002)(38100700002)(41300700001)(6916009)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JdKPXxJ+3Hq3XSV/3tp0gekRyIWzfgOyQLjgeu/HTXSQG5XQ1xOhHe/Nwy8V?=
 =?us-ascii?Q?Im6x5+ETyqduD5kzBMLdXDcOKTCloNDTcn8TbodRVEmm4J+Qo1gRbdVj7KkT?=
 =?us-ascii?Q?FfOWAj3CwfnC7Y7Y3LWOI1YxhUcygkxwC6Oak3SOiRY61kGyLFzUhY4islPv?=
 =?us-ascii?Q?xiyF1X5WN8XaX0izLFutKxdnfx69G49I/c3uetTQZNBYAX9XKXgVJwwiRWHF?=
 =?us-ascii?Q?c0ZfQXqYb6bllQnylSxmhWXfZbhBrUL2MrhgA91k0Lp5Zp/SOy9puThkU02t?=
 =?us-ascii?Q?G4QjfYpg/dCMtu9b8Q407VN5ZZ1cEIx2fYsCE/GBSZ7X+dRSp6iQVlK6+L7f?=
 =?us-ascii?Q?oDsg6MuXGTweUIJPeohK1Wh0xTPYrjPdzqwphWk+YHygsX1axTBS2SallO8g?=
 =?us-ascii?Q?AHudQq/Pa7FYc127ZnRu2GS422ipFSuKiSdWwuBsxosXx26BT8jYK0cC8A0S?=
 =?us-ascii?Q?18cHCx3Zu3LmjWZWa76T8anOk1Ry+R3rN+NkwtEgDf9ydNlQzI9cR/UikMNg?=
 =?us-ascii?Q?uTFc849jBFyUifkvc7miVzGz9JwEjdmpygByFeblHHFYT/FGCydix0RpqM50?=
 =?us-ascii?Q?ncRGHAXaC69RqFZumz+v6KGkm5hvMIYFTwkBfeiA/emK4HdQyF1R1tq5x4lW?=
 =?us-ascii?Q?wARY+88AFUGliLPF6TOZg1o0v3VCOEgDfwrg0UQR3iAKJ/yFGclhTz3Mq3tm?=
 =?us-ascii?Q?xaupYxxz2o+doZYfOT/DkGJ/PKO8t5Px6PqLkj9TkKG3EHXFNyTPcQezyK85?=
 =?us-ascii?Q?ZsjiXwvYmCeGV6ArMoGg/v0UNcTdZPEUPodREIN41SxEht84ScdwYASzwzYN?=
 =?us-ascii?Q?WIfguOhxzrTjsA9U1meL57fDyXQzehXeKmRl0PKPHtvfvHBEUKUWrr6/zTis?=
 =?us-ascii?Q?A+NLpcukh43JxnH9ftlv3SzL1O6tQsPY+Im47gvKCTzJOHOIvf6A806s2Qab?=
 =?us-ascii?Q?i8dqzShGOG6zHo7evXjv/eQolt90299X7pcB6S9sylmx6tJKqG3DKYqdc6iL?=
 =?us-ascii?Q?fJiKm2YUMQFLrUkV/1sekhSlybnENOUwtXF1BH5+OnihYeBDqKOfWjRwZqav?=
 =?us-ascii?Q?CWXvLyxvG4+DB3IPW8KljOJRMUCOWLWLzJjurwUvnTUeTwdhwWfDCFvrYCCK?=
 =?us-ascii?Q?xEHKxx3KdFbHFuGgA22+V1X3BDVfZvnwZwJyItMaPC92GLpUZYE418pQAkKd?=
 =?us-ascii?Q?RB6V9sjRLy2aMNcm9pDfABofJHFB10CXHh5VioeT9WbXd6wz0hiXZS2ogc09?=
 =?us-ascii?Q?D7LYP/8S8Udx8JsnWvJdsMkComrJ9y/TPtP9ehgXaxOCyr4VuR1xGpeCpqum?=
 =?us-ascii?Q?0yiIZE4VWsdz82c6V+BBfyKWxbwdomPBjTI267TA5YxqouqqBk7iGaq+VA4r?=
 =?us-ascii?Q?KJmhHNITSSGsm+u240c17s9yluQO8Qd4dOlpiaDz/6uFgzbFG7210dwct4th?=
 =?us-ascii?Q?j2FshVV2cdnF8weXGjSeJ1kHAkPqkBSdbhTOQ8ai0Mdv2fBfl4lOL7XNuzo0?=
 =?us-ascii?Q?b9kCtI5TQbvBym/p92OJD9OcmngnzEpO580UC93/Og47vkFI5rAH+3jDR+TU?=
 =?us-ascii?Q?tX1zS6rJM0MxU8H6cDc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a53cd04-4b30-46e4-71c3-08daceef7414
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 14:15:06.8236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N2e1iQbMLYkjHP6/S1mdgCaHE6Nm3eaS2yT23AO1MFDt5tieLwf7HFj8DqwL9Pwn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5397
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022 at 10:06:13PM +0800, Yi Liu wrote:
> On 2022/11/25 20:37, Jason Gunthorpe wrote:
> > On Fri, Nov 25, 2022 at 04:57:27PM +0800, Yi Liu wrote:
> > 
> > > > +static int vfio_device_group_open(struct vfio_device *device)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	mutex_lock(&device->group->group_lock);
> > > 
> > > now the group path holds group_lock first, and then device_set->lock.
> > > this is different with existing code. is it acceptable? I had a quick
> > > check with this change, basic test is good. no a-b-b-a locking issue.
> > 
> > I looked for a while and couldn't find a reason why it wouldn't be OK
> 
> ok, so updated this commit as below:

Yeah, can you update the cdev series too, lets see how it looks

Jason
