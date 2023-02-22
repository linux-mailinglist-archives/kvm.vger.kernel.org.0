Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5E9769F4F9
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 13:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbjBVM6g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 07:58:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjBVM6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 07:58:35 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4EC2B60F;
        Wed, 22 Feb 2023 04:58:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bhASGiviVLmlK1w91RodMIWqqwMFLWliJLbIbYYBFNCfR1I9h8pK3BxorpnZDJXt9DPYQagLIjbdRCzKK/o2WgFGiCZfw8VheFGrNSWSzC52BK35u3isb1+1yli17I0sK8aBV0GK+IYWyax1/yE6mIi/LbHHAFQk8Div8ZeU5QE5b8FW8K0wiJ11AoArCh0eBMj5Pbp9CofM1fkRgJL7RlNEjJ87/mIKUK3vWy14IwkF7bdN2y/bW5igT7tOxT6A1UB9S8ahbpudKkLNxjTwiGclErd5v1hlpcRDh+kIQy1eCZ7xmpH0e5oLom1nadbQrsVk3J93BOhopTwtBjjy2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3CjzVzKASrnGuVBqZjp5q6hGLdXaemG88Vmk/mGVGfI=;
 b=gny0sYNBdPWgBopGGgT+V80cU65F6laSgeHnoAqYVH8Lk4SCOBHVnCru72UlsyC2+hEF7GQlfXoj7npA36UmenMKKjAgLok3dLqyMX5z1MIOuN3mPnJs8rORxW8S3hYYrd/YYMO32BxKbo6ksy9CJjbf+VkxRk/2ixyK1yJS2DWmBEwUeFd1CvDbj6IxfujJAQZ4VGpqnor8cAmqzsfgkSnVNBnRDisFgCJoGofU0aqli+rXqXcZXP05uq3nbt1MjQnXUeLtpHIFUmuL2zFoo7PJ996Z3gWnIksiVRfJE4VEhGzgZZCPIVnHSO3ZNdk2U80ZWMQy3+VL2Kc/rWteJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3CjzVzKASrnGuVBqZjp5q6hGLdXaemG88Vmk/mGVGfI=;
 b=QosqjJyHhZ/2b2oBlaZgNtetq28poHib0d1/N2UGrsv7FIwHF5ioClzzvRmUumdd3sGiga4kgrx2AXk1bOZPsR3pBjQPX0N/r7QpBGY2+0yoZwD0LKmAepCfnplCIgq26x/PijcYxm8Zqouty6W7wIZEp71Soj5iehDbFBAQJ7ZFo0xffQ8+u+jbmJjfDyX2xgzm0Ok+/KTRG8wDHnocb2AGSMX0I6cuh6pi9qE6vbycg83awZqNGLzwFT2iBr4zugfsb5188UVsKTBKaGjm4mi0FEjKGX27zhSk+oTSHtm9ephe4GPboYbWDX+14bTC1XEQznkbTCtlo6c9gCyYrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4038.namprd12.prod.outlook.com (2603:10b6:610:7b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.21; Wed, 22 Feb
 2023 12:58:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 12:58:31 +0000
Date:   Wed, 22 Feb 2023 08:58:30 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        yi.l.liu@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfio: Fix NULL pointer dereference caused by
 uninitialized group->iommufd
Message-ID: <Y/YRdkUQPG8Mli1H@nvidia.com>
References: <20230222074938.13681-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230222074938.13681-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: MN2PR20CA0056.namprd20.prod.outlook.com
 (2603:10b6:208:235::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4038:EE_
X-MS-Office365-Filtering-Correlation-Id: 92c65351-aa0b-4f4f-bfb5-08db14d47f96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w0653HGaGwcFyhtTa+LCi/fmSRemNzvSm7LkBBPsTlYAJ1Guj2c4uvW3qW2CMPMUWXBEAqJPqm045jVD7KNlPPvt51xmwJENMwp2pPzkHEk1MoT3mO1FzqzzGwFgurnjb1T4JJpblEciN5p7OYfyAqseW76kq1aAmB2l3YJ6P06S61fo0N8Q4nqH6PAUZD8Y74O0dci3FeXutcpeK7pml7sYzrlBBqQePlBWcnUkYhFnT25rPxQCMnXU9W8Jq9/ks0RHDNd2Q+bDwwNZ0PIyAikR4bjryiAcIDMKx1QxCER6pjJzYGRtnhfcG1PGeap/aCNkdGK5nfW/r/KyIcawr/bwGfbsdU8hXxPX8mEtw4udjaHmVx2oyJT9WwzbjQau5hvPiWCIjaUupgMx/K7CgtUhpSMwRNiS2AeiDrNb0zd9s49WhqQ/Pj+yAzogLHhqLO8y6lF+UM20ZG0Kj6FLC6GhxC6ndNivnkAwEIpBVqVs/fIxthC63TZwJlmrUn/n7srJB2MOqbmEv6KD4mYJiAmTAF7cP5QqP/bCCE0KMXO3Ya1wtJ7VY+8yhNq/p40pWoH5NiZlRMvSLPw2MLWyqpV1KOW2c9BFS3iNoru0LFOd2KRDCb24Ly6QarA4ckzf0HdMhUUQU968wpIiKu0SWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(451199018)(36756003)(8936002)(41300700001)(316002)(8676002)(5660300002)(2616005)(186003)(66476007)(6916009)(4326008)(26005)(86362001)(6512007)(2906002)(6486002)(83380400001)(66556008)(66946007)(6506007)(478600001)(4744005)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7V9BE6jQUKjFnbf44zRHvSAdbCad/aV3+4sso4uETj9/DRSViroWYFQNr3Sa?=
 =?us-ascii?Q?rUqXSve/15l20xjP1EiXGLvQi8F9I3RnMIxYysorV+sRbBLonUpJ6z8ljhs5?=
 =?us-ascii?Q?DcxFlTjW4kr2cPWSkwATkody4w6VoPRCtCiPV/SJqSyC6leitrF8SigBS+An?=
 =?us-ascii?Q?j8FO+LUzkw6EfNPQJZFnyNiAlH94TMXUdC959rFhfjoJiGvrwRYfOqq9IDl3?=
 =?us-ascii?Q?Hd5Vis+4ME/ru7hkR2SjthLwUQFcTtCBSE8bc+gNMUyNBtyRmzcngoyaj9pj?=
 =?us-ascii?Q?tQidh9Q5OA96SZIhxuz2B9XtgsadETwCTDr66vUODFEMtmhaWcsIgyP+UvwH?=
 =?us-ascii?Q?9RSQuwg5/ZU21jdwVf/JW7yJeUsp4g99YmowFoNwy6aaixULxeff4+HIALgi?=
 =?us-ascii?Q?zcokZjBsatNIZRo7o1u13RHOEptQj71pKIvCP1jRtsC9fHFBorzGstCdQxpT?=
 =?us-ascii?Q?5Hb+zZC5qI9Hd+3GdY7UjJ7tMortTEUDiUqLHatVOP5gpgSA6OszVSqCiju8?=
 =?us-ascii?Q?YIY1lbvkQvJ5nFJh9nd2Pn/oEl+eklmcRdyUaWgaZHptdRWHHJp3l0cneC26?=
 =?us-ascii?Q?7vpPzw/bAhKNWyku+Nf5pTXilay0gWW5QFFeDEHKTBuku6djMNt3vhQAHYmU?=
 =?us-ascii?Q?7KUcZRLHYtXHhThNP3XPHT5mGr/LmBcjCXqg7k39pOwANhPgAmILd8CPHidS?=
 =?us-ascii?Q?fVzjvjd3tJJxwrDUKbWaYQLQ/+UIOf6WhBrLOCvCUWFMrif86v1MrT/eRhjk?=
 =?us-ascii?Q?GBSymzpKFtjWzjbDsthEbxeTB29PmCYUkyAnUkjf93dGW5T/bFtzdVSpwdf6?=
 =?us-ascii?Q?a4XXasMQScMLSCBFEHar2qHe3JJx2CzIxhaqU9vVftJpS4w6HPh7Oxvel9lB?=
 =?us-ascii?Q?n5SmyxzE02qy8k6uL6+X9RCJ4fqImLDByPim0xlf300ZKeEg1U9lQ6bIx0n+?=
 =?us-ascii?Q?B1oGTk/ap73sCYXp2650+RIMQaqYJ9XTKB80022SXYMoUnbKWzAEOLmB8/U0?=
 =?us-ascii?Q?npox7N+cPmfjhg813XuYlTIE6UXbWn6xCKC6RipDNYD6CkckgDMFE1wKHS1u?=
 =?us-ascii?Q?dXoRsO83Mul4xnOl5pkBYDMXsWGzvgbaqrzf1O211CSRosZPL/RziFxPTWXd?=
 =?us-ascii?Q?mq6QX5ShWa6+7CWB/zEfgPt7DWraDp7fPIcUZLLEuxnizpD4M//5/mFzILfl?=
 =?us-ascii?Q?FQTSulLoy+a9OmgZkEysCIMiPM8KMlMjfSstd/s62gUDLsPgct/lD6jO5/Pm?=
 =?us-ascii?Q?UhhhL4nnHgc/AYPKFRttebYqAOLomzBoC0DV13Gw3qXi9PWa/HMkeLbumc9f?=
 =?us-ascii?Q?RLoBImhTgllBtjC7IQNNcLV0XyEaH3ujMhkmMBewmbL10XCdmNc22SLstBlx?=
 =?us-ascii?Q?xfomhIBxOEfSlzU8sxeMg0B9ZKNi20VxfUED8gRMy20KEW8JrGSUWuPDCN7d?=
 =?us-ascii?Q?VxbfXS1fE90C9l8MJ+QkNMgDfq77U1no8ScUNHILWdfMZ56+HB4FBo2LY9TU?=
 =?us-ascii?Q?eF7pAscrSHqvkrWSMHdCW0iW4vN++CukFmHtDDKk80C/aViCISD1ib1e9o/W?=
 =?us-ascii?Q?Fg/CwPfq5wC2ne2WWZtQ6Y50rTHIP2SyDIzfbhw0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92c65351-aa0b-4f4f-bfb5-08db14d47f96
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2023 12:58:31.0338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x8+Vd/sgyBOmjm8aV+ueNuI2dwDEKOuwz5CQP8JHoPriVdBPPHx8tgdknm4TseSC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4038
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 22, 2023 at 03:49:38PM +0800, Yan Zhao wrote:
> group->iommufd is not initialized for the iommufd_ctx_put()
> 
> [20018.331541] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [20018.377508] RIP: 0010:iommufd_ctx_put+0x5/0x10 [iommufd]
> ...
> [20018.476483] Call Trace:
> [20018.479214]  <TASK>
> [20018.481555]  vfio_group_fops_unl_ioctl+0x506/0x690 [vfio]
> [20018.487586]  __x64_sys_ioctl+0x6a/0xb0
> [20018.491773]  ? trace_hardirqs_on+0xc5/0xe0
> [20018.496347]  do_syscall_64+0x67/0x90
> [20018.500340]  entry_SYSCALL_64_after_hwframe+0x4b/0xb5
> 
> Fixes: 9eefba8002c2 ("vfio: Move vfio group specific code into group.c")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
>  drivers/vfio/group.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
