Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63E766CCA86
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 21:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjC1TWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 15:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjC1TWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 15:22:16 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC9D2D64;
        Tue, 28 Mar 2023 12:22:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShNGAVpOYkqMN+CYqXzafycBrSSH9tuG0i2KSg35/dZBabu3dttiwaAn4MFvkeV0CDkuDmHqxxQr87E8uncyNdTsJ+0zAuWLVxOZv50VisX/6ONYwQg4qwBFmKj5mV0dNM1cP4yU8+xixTOLNCHA0Bz9V2KA/rUmdYZjMLJKyvnArigupsNEN/0sYxfYILMZZ9s75FWNnUvDubSV675BAyy58DDmKnhx0wsl62okV1NvumY+nHjV6IcY4St1ONwtT/UYUw+/aicPl+dHJPhq18kzFWvwNBXwAJCupMgROgXiGETUFI3WoqTMGnEcLTsrKU5deJiiMo3o3f4L/mE9yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D0ZAdFBl+okG8FUaZXF76g844DJIn4+EZruRazta3y4=;
 b=H63HwwrByhwk7vJA8PInmtBzdNpHYA4JnCMcxsDPtToCfh6Ih2LNABV+s4OkMzwUJ0+azoZCUr8ON36554/VisAPlqpk+IoLwwmj+mp2Xzad47iS4hjBerYrgRZ3+Y/vCxQyTuGXIdjFbvfZI6aaHjkPfP3DVnSuhn9wywUkMyrKl4fG6p5YGjziJWAOjo65rwbstaHaW54jzJ5TGaZmZxbTthoxIINb5mqQrx5Mr9pKN7oEqqruvFfUCTzHjkFrI6coFr/GGTaSwKggYeG4H0SMtkHphR/O+KUoR3mirYbr8AYvlkz2tYkl/P5Pq2A3/8NorBQtJ59Q/F+vcCMnQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D0ZAdFBl+okG8FUaZXF76g844DJIn4+EZruRazta3y4=;
 b=nxghyvHeDVmb9kIkWYlaL39S59Eg0JP7/rO+c8YBKfoBmn67PxwapWvfQ0Pim5J9frLuARkgSiQ226YCCw/rKsY48SF8b6VB/ABy8PkZpnPGc50TYGF9uJmtiXP3enD734hSQc2c6Etxgl50z4Ax0WwOV98+Jukr337HyBqdJns0rs/SVHJZRK3zV4i3hzDc6G5piv34IWiCdhsV16k9NObraJBeyIJ8ttghD/7RrcFvK4sft4Dk8HgCk8B9uG9+z0Tr+KWLO8UfzDkWCH1/kE3UR0Q1F5BTYGEfX7DJptxGL4Wu5InDwSbyI1Z/Zi8nVwplDWzQdZ3bl5czFHTQ6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4085.namprd12.prod.outlook.com (2603:10b6:610:79::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Tue, 28 Mar
 2023 19:22:12 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Tue, 28 Mar 2023
 19:22:11 +0000
Date:   Tue, 28 Mar 2023 16:22:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
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
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v2 10/10] vfio/pci: Add
 VFIO_DEVICE_GET_PCI_HOT_RESET_GROUP_INFO
Message-ID: <ZCM+YeR6Pl2Z49cx@nvidia.com>
References: <20230327132619.5ab15440.alex.williamson@redhat.com>
 <DS0PR11MB7529E969C27995D535A24EC0C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BL1PR11MB52717FB9E6D5C10BF4B7DA0A8C889@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20230328082536.5400da67.alex.williamson@redhat.com>
 <DS0PR11MB7529B6782565BE8489D922F9C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328084616.3361a293.alex.williamson@redhat.com>
 <DS0PR11MB75290B84D334FC726A8BBA95C3889@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230328091801.13de042a.alex.williamson@redhat.com>
 <ZCMV4zMhpVJJCIKN@nvidia.com>
 <20230328130949.225bc680.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328130949.225bc680.alex.williamson@redhat.com>
X-ClientProxiedBy: YT4PR01CA0225.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::13) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4085:EE_
X-MS-Office365-Filtering-Correlation-Id: d19d7551-e591-430a-e765-08db2fc1baad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XO2ncaqMwrhnkuwMOHHfQVmjVm4YZAEIum/b/sodrkMunMZH+CShcfPRrVlVr+WADgp+6zRWe2Vvbmq4dTcl6JxCSmcNjsdk/yQWzUuLzaKQ0zOVgOu8TvkMsb6Xr5lvvSVAjyyejdw+tqIyrplebhXsQOSs23FZ6InQoglHPSwbGMMm8pUj7s7D6GoibRADWxJQwgHwJrg6txxyyaAwqbY6kuS+gdN5XULQ0qvrvs1Lt9V40SUcw8ngBFNeojs0GaR132gUYotXEynvlpyf0XMvEO1jbteKBd0axCILhp8kWAXCu1tcmAd/h1sxvrQupffTH5leImRbADbpEpjmM8lJQvs4Lna7HZJCMNoeV9vV39pq/1xskHx+U2UwCdajlsiK01RugpfH0Q/aIg4Xmwz4+sI2c+F2LjlBiH7f+cTrCnqa8CcWzyfE7WJ6L5UQqy1L70Z1jAHtjchxXYY/A4Jb1dODZcAK0c8X/+6/Asa13YKiCq3FhkdaHdO2UTcbiRQ3amvfwne7mp2o0dJ0zSz94xv0F5asQiZzLSV04n56t94C+CuAGnilifcSP3ofHYbx8EC8piCPkUDzCmRlswsaBdEw6NTAmz0LYfTs6HA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199021)(6486002)(186003)(36756003)(6512007)(6506007)(26005)(86362001)(2906002)(8676002)(4326008)(6916009)(316002)(41300700001)(66476007)(66556008)(8936002)(66946007)(38100700002)(54906003)(5660300002)(7416002)(478600001)(2616005)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UNC00VtDw/woAPAYkPcdPzjjtk+y9P7OKM9xlFP/eMqXSW3YmoXdZdYPClMq?=
 =?us-ascii?Q?VAe2QYa76l30ZEPmSigGNtrjJuiWi0m0PqwWVg9vYzVx/Y8gj4RcrvId6mUc?=
 =?us-ascii?Q?FuSV7+r8M5vfjEos+sjDzLu+fAYaNdormMcSXoEiqbNK/v9SCfpuVHu/eeVW?=
 =?us-ascii?Q?Ts+efaUQhHEG9HEbvPtjTztJeDISfZjILyvABofrOCGt2FTCbvB+jf5nX6Q/?=
 =?us-ascii?Q?2gn2BkEXARpXPQD4OUEHx6sH+pPfyFCYxdetB7B6KZ/3W7vEVXICB6AF2416?=
 =?us-ascii?Q?FyQkv2Ut/E0y1RBS/Qa1meQEwZJkZ7SUIGrsemPXXTeUa9U8+gmWivRMZb/A?=
 =?us-ascii?Q?9o0FoSJNYGXiLmpFKrrqfeGcIy96NXKGP9eN1AeK+sIFXIQ+6Ck+T17/qZdW?=
 =?us-ascii?Q?fus4FL/pyf9diEXQ1G8pD4dSLt4luF2WqLoTcUIh6WytxHpmmbWfJNUvyMaM?=
 =?us-ascii?Q?p+XQo19ML9/IfvMUjXtkDVH7PY4ddF6uhydPLI5xN+uAar95RQpY3SxPnXVU?=
 =?us-ascii?Q?NQU1DDWmxPH/D8w4+A62yHsxcn0IU/EA/vwJK1oWynN31kcpovYtQlWKf9Nq?=
 =?us-ascii?Q?u2OP6/YFpk5vp0oqpbGB1PuqUnRm3ax7xEWyiIheuxKfV2F320d18sLmlTfg?=
 =?us-ascii?Q?ccEXupiBNUY4Hn6fsOlOLI8DTsGdswe3sWYUG9MOU/eppz+hHJqqbH6MJlXh?=
 =?us-ascii?Q?vlNN4/wArb1MNKGSTga0qpzwsQraApR4tDXUytdebawybrRIiFzYfSTxr+1s?=
 =?us-ascii?Q?w07JM9dO4kG00GdMpgvH3b9DHIFf3Q8gzIvCixIZb+c5KyPPbtGt0RM6GgPI?=
 =?us-ascii?Q?fIuFLsLYcBLgShLJsbvFwVcgVU68nZBrVtqI5KgW3zlrtD28msdJPzQ2Lk0t?=
 =?us-ascii?Q?oyjAh+WUdO/ly6E9WYu4bPYsdmToiiL18bpFh6zlKsHlepfTRFP/H21tbyHN?=
 =?us-ascii?Q?8wKY0RM1UJ+3FOm8h2lofkcgxGaSILQWx1ARUeMjDznqEzhaan+wNd56Wkh3?=
 =?us-ascii?Q?+VgomBfI9Wir7qETE/qxnGVmdnxSv4pERegEf+H8xcRNbE3Kzm0Plil9mB0D?=
 =?us-ascii?Q?JxqH2jrqhWaZIZrdwaaf86k2W0dqBDrCaMQIK/b30HXJtoKPWehhN0Sun4KY?=
 =?us-ascii?Q?23hAmds3yhtXCLGrmWH6DJXu0Mq+DQ17x52zsX13aHPs8PO9yqzzN2oAaAiP?=
 =?us-ascii?Q?093ny1/bnhpwyUQ3qZxqpTCd7CchM9hO89PAcO85x72D8vSV3PEg94kZqXTq?=
 =?us-ascii?Q?jKCJvs6kBCCg5llnxJaDhy0Vm2Lp6X0ejgukQGTYynklPxQ9PGHuEixSa/XX?=
 =?us-ascii?Q?6wKx+MawkFHGF0aaU2KjdWZio4cWbBe7BPuUMuXOX/iSuFp3B5gpxcavRJ8V?=
 =?us-ascii?Q?NO523Rf6Zlst5QC+6quz8u7okgtRmrW1yNxFtJtlRO+EB5lkEatwLXb+aI2K?=
 =?us-ascii?Q?vBY89aZsQRs7eerU2i69Hz1W70w4ym8O4eliUsilf/++lsyVSWQvEQBUXaaK?=
 =?us-ascii?Q?3QO2AIVQRGLUOfhFhBDS4LuUXe81sTllSHTUDZI+R7mR9xgElXg2Mq3MUwpL?=
 =?us-ascii?Q?mUp1MdIJzQ0OhCTHKkPN4Xn4wpKk58EeGgrhtXjq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d19d7551-e591-430a-e765-08db2fc1baad
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 19:22:11.2084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cItYQlopKA9Ea04oF6DbodWveswX6rZgN3uuf+TjGd+/d4ArRag71BElXipMSacy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4085
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 28, 2023 at 01:09:49PM -0600, Alex Williamson wrote:

> "Just trigger it" is the same in either case.  It seems bold to play
> the complexity argument when we already have a function that does 90%
> the correct thing where we can share much of the implementation and
> userspace code without duplicating, but still relying on a legacy
> interface for debugging. 

It just doesn't seem like we are sharing a lot, this patch is a whole
new function and you are saying the unique implementation needs to be more
complex still.

Maybe the next version will be able to share more??

Like can we just patch the existing code that sets the group_id/dev_id
or somethiing???

Still, I'm not sure that qemu will share really share much here,
because if it runs in group mode then it has to parse the result in a
totally different way than if it runs in dev_id mode. The ioctl call
is only a line or two. I imagine qemu will end up with two different
functions that both return some kind of internal list of qemu devices
in the reset group.

Jason
