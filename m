Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7F9647AEA
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 01:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiLIApB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 19:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLIAoz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 19:44:55 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E291A19BF;
        Thu,  8 Dec 2022 16:44:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sh1L+D55xmJ09gjmtFcCI4/4nNLzUlvs3Kg9dqqC9V3j6aM1fiyr6EftpskrYe2jSojEv8a5+VxOQA/8vx5dDXST+mqTrclC2KF2yapmVOYQJ1bOltNhwLHHZFLHdnleTzlgsh+NkPJ7onF1GWS8jJJloVC8RNVquyvd/419jjzAOhHM3Fz5PMumXCSWgs6CVCWCJgIW+HgtrHXI6XokwKRzo4np/ihXKobao83YvzZ+TqvHkJTbiJdhHVDqxXf0jV6N4BwNRA1oa5ERv2mtUI71OKgMna8KjCLiNEIMXgDjumrodER8Ug5Kzc0kSGeE4MV0xtnlDrER1ncrQEEKUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gz6cp/ifm4z88iAvKL2gf3lUoo70Hn1Kqp0rVwtLSVc=;
 b=K3ys8iQMAMo981xkXYv4BEzWeY8e7/QvPzC3Cm/QjWtm+QY4KbM3nG20ARIFNLQh4vGGzZcFAQzlyxH/bdhmQms2NiDzsZdRv8J4QXrAnsR74D6Rhg/mnce5swo4F+4RBJ3EpNUHwmmKCio7POf3zlBrZu0c/dANf12fpznA9Y3QJtVgsVs5K8gMsEZkYrWmx98rwXXwxEqSNexZ995UDx/xpTVCCWEPAthtDtXYbFWseGIJYFfVqYHVZSNficWCxdYR2DGucHs+a7SHu7mEMU302PK462qivIzy4BYcjdm0M1wx0kfw2a6HQ2JowkEIu/Mx6sRqyV3apJnzgP4xNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gz6cp/ifm4z88iAvKL2gf3lUoo70Hn1Kqp0rVwtLSVc=;
 b=OTINRT6dWwMGnnwety0Uf+SXWO8kpkLlRnLaRHF3ma7BjQkjKOBAEKPB8ny4VpHTrIgyoRIrl9xI68EnGjlTmEKEibX6hgob9fxeacTHGwsvl9foX5GtMuqBdFtnQn/eEzcYHWzu10JfO7jTn4W4BbPGRf+zzarv5pf7c2jgH6TbNdXvZedUnROnd7WtcuKVrp6aMQ4QxkJp4iUHt4ZzrX4RE63/P1J5dkUaMeux1R0z3fgiUs/uqzhOeVHVf/Rx2LzCZ18v+BIe3it06qXlAqF3BQI9P5gfIPWn+aG75dHtpydrXuCULTqEt88sl/yXHVeXt7K5YwZzU0rYJgCVBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4431.namprd12.prod.outlook.com (2603:10b6:806:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 00:44:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 00:44:48 +0000
Date:   Thu, 8 Dec 2022 20:44:46 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>,
        Bharat Bhushan <bharat.bhushan@nxp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tomasz Nowicki <tomasz.nowicki@caviumnetworks.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH iommufd 2/9] vfio/type1: Check that every device supports
 IOMMU_CAP_INTR_REMAP
Message-ID: <Y5KE/ikRGKnuaFAQ@nvidia.com>
References: <0-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <2-v1-9e466539c244+47b5-secure_msi_jgg@nvidia.com>
 <20221208144825.33823739.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208144825.33823739.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR19CA0045.namprd19.prod.outlook.com
 (2603:10b6:208:19b::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4431:EE_
X-MS-Office365-Filtering-Correlation-Id: 51e71c2f-17d2-4c47-9796-08dad97e92e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GMzGHVYSifPqqjrBJWq99X2GHPcbbfFK5xv7VbgsvozT+velfcbV/EZt8NvZ02e9snljc505nUl5aKhkWAJie7tXYzOq2MRchYkkm9uQc6CcMq/T+jfpEcZZlWAahILg9pJfSj78xrMUQj7dRoNwcizXUepLXiX5sDwUtqEtfTHLHAKAWbSd/9yLUnoxbX4148gwnfyaXlbOp8kzBanoV2ZfttGWc5pVxp5zIq2G+T0IflxG6LUwkaoaqGrwiXb0O7f1yWq7DMbovWHquLsfdkEUecCzcvGCFaoE5Rt9R0pSAi873ZCGyH/nHj32TTnJBj890tb+HcHrEDpfGug/47RJkkYHsmyjRVOoDMvBBuF1iA/P03lv1LdwUPvTZsJJnBDqgM0uOJLgEgJT+ybIqHjWzFn4vAcwnhKfld8PPWNIiIxmu1Y7Rna5UsC9lX9glJCj2dUsAaYtvS2Mg7QLK6FIqlllNdEudQbxYWyxAG+yXGPC8xEvZGMzW1ffQA3pBUoYvTHRFxJx81vFF84Lw0yqSchkN6uApiL2RYLZsCfnMm305WLPndPFbWjFWmkubhUIYu02M9K6tW/6fSo2o60tKLF/4YQFIi2YXxnfZSClByTnNSreAoRSnBhTQ/0DMPSzIoP7HWyeqszV5DV3Rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199015)(86362001)(41300700001)(6512007)(6486002)(186003)(6506007)(2616005)(5660300002)(8936002)(26005)(7416002)(36756003)(478600001)(2906002)(8676002)(54906003)(6916009)(316002)(4326008)(66946007)(38100700002)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KIKSfqb8/JRiT9B9uB7RGJfcMdSrIHqWYDzvtLKr/esUhExHRXH1APYM+uK6?=
 =?us-ascii?Q?yDHvxPINOxpVsx2gTA7AsV19UiUnZuhXZTVnLWYCycve6DLiOh0+vAzHTj0x?=
 =?us-ascii?Q?8vYiJV4PHuzp40DxHpOWxdGKJVOGllshmpoDhiAu1QR4+BmrJLRtVTKSxNPJ?=
 =?us-ascii?Q?3FSsewgsENP36Vf8s/7G2SH1GB0Kak6UqEMH1UUSL6byYZhytfIxLHSj81PU?=
 =?us-ascii?Q?W8RDiGcrMqYiPKc43xeP2mrEPiOvivsq5JXIctcNPHibQm+0+Hb9eiXUCYcb?=
 =?us-ascii?Q?+rX5T7aan6MLaJ16wN7AaIc/5VXD4s4kONx3oBMKTLxhk+xOQBE6w7+2CGGZ?=
 =?us-ascii?Q?YVeQy1o1LifqKWrE/VeO9Et52OX3JKd0syhUJqskBBo/uc9GDH2F+YcbNITL?=
 =?us-ascii?Q?3fJ+/O/iuseTuS5PpVqYdtxjUkoj/CWuQRHFKePUwvbUh2vt0Q1rYhgp95yn?=
 =?us-ascii?Q?AByYx0vXHCn04T7y+sE84dnpLRCVeKI3M4PQ09y9RICW8R7ao6Az+KxVruUy?=
 =?us-ascii?Q?Zih49DfUWc8UPjVx2N2ik3dtM+7VlroFwiqLEJmpkzNDNw9QRAQSKI7k9vBw?=
 =?us-ascii?Q?v4mO5RPf44fSK6t3RqUYN1pt4+g1doOHMLFu4ElCy4B1RfkMSPY3IU6zltf2?=
 =?us-ascii?Q?mbLYPQUClEKhBBSCX77L0F0mAXhu862wK2CU21IjCJDLWCUfKsTGbXE/qjkI?=
 =?us-ascii?Q?qyZ2SGffkzOeANJLkBgfo6AMUFMowmOjOiTGAWGSSXJzV80OVw7xY4gBL35u?=
 =?us-ascii?Q?5t6T19JOD264tyKlQ2BnAght+ndJtQX1+VBn2GCcGYBQAXogKqonRtPyUiuQ?=
 =?us-ascii?Q?9jjhRKc94mjAdrkb1XTIUe6g9f3nml8h4xe89DuImriHvdWah/JE7ThW6PJL?=
 =?us-ascii?Q?39fRRenuwo2njjdpYRZ0MRNcAsfZZlzIuNt8/jg9o7GN56GeXct3lOT0Yebs?=
 =?us-ascii?Q?eJWw9d8aiatQO2P8rpTk+J56yR4R3VSSEgLzE35q9r/n8EtdAPDBKc4oEu8G?=
 =?us-ascii?Q?Rhp1VtVJEl1Zxn57+insxRrYkSPoY72t8Fli/cfoWck4/ZpI5qGUCsNA5AEs?=
 =?us-ascii?Q?/yeg0YTupfK81kTQ8xcFc/aWWyPVnEy7rqlMsGyhoXNLbRRqGc+2tV5nEjQO?=
 =?us-ascii?Q?SDIPkVGd/j4aAaj4ij6z7mlrM5eg3Yq1gBTZklsAqZ/PWHMhrxnks/3VZUL0?=
 =?us-ascii?Q?C1K+uJMWx8DY0VC6o7F0VOM9UtZs7jixqNPVQMJhK2BjCpb9KmgKrF2lBJBE?=
 =?us-ascii?Q?3Q4NggsynnZwVpEp0s7dnRvDmvfg37qHZRZ7x1Tafips0YUlwTNy3xAg3QPr?=
 =?us-ascii?Q?MX4x7oUC6HHGEuZVGvxQfejEY4fDjRnxTmuQme2rQzeg8ufR4NoGDh29DHZL?=
 =?us-ascii?Q?gp1KWnuLbuIbDBbt2+EIFLgfG9RyOHHONEyCTsMWyd1Tri/bBg/g83a+kgMI?=
 =?us-ascii?Q?SNKlxBMEtxORMdMqpov0z8Y0KK144J4ZLh3RytQ1Ljn7LQFyajm2ERSE4Wmv?=
 =?us-ascii?Q?RFhiw0/GBNwYabauExO/CuaG+DjCTmYAZycbIIuhNjIkyZwGVDrH8Bplyuu4?=
 =?us-ascii?Q?jOEaR26UB5niNXQjEpw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51e71c2f-17d2-4c47-9796-08dad97e92e7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 00:44:48.2447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRvCxZbE5zvFC9H5VTMuvSG3Dt2pC4nBQHKsqmHn1OlH3RGWUeRWAevVOG73Y3D+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4431
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022 at 02:48:25PM -0700, Alex Williamson wrote:
> On Thu,  8 Dec 2022 16:26:29 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > iommu_group_for_each_dev() exits the loop at the first callback that
> > returns 1 - thus returning 1 fails to check the rest of the devices in the
> > group.
> > 
> > msi_remap (aka secure MSI) requires that all the devices in the group
> > support it, not just any one. This is only a theoretical problem as no
> > current drivers will have different secure MSI properties within a group.
> 
> Which is exactly how Robin justified the behavior in the referenced
> commit:
> 
>   As with domains, any capability must in practice be consistent for
>   devices in a given group - and after all it's still the same
>   capability which was expected to be consistent across an entire bus!
>   - so there's no need for any complicated validation.
> 
> That suggests to me that it's intentional that we break if any device
> supports the capability and therefore this isn't so much a "Fixes:", as
> it is a refactoring expressly to support msi_device_has_secure_msi(),
> which cannot make these sort of assumptions as a non-group API.  Thanks,

Sure, lets drop the fixes and your analysis seems correct

Jason
