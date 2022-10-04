Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D3635F484D
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 19:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiJDRWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 13:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiJDRWO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 13:22:14 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2065.outbound.protection.outlook.com [40.107.102.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A698F1E3CF;
        Tue,  4 Oct 2022 10:22:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECMsi3mAhisUeHVaETDtXrBPZtGIisIecIiPFSUtZNLzzShqFEbp1hiSThzKAO2rVuKX4X5qnQaf2lLVaDNLIo2j0sWoAbMHpEkQFC8CH7p6MrECruGLoAmz2f27Ny0ks76W0rS5JV8YLzC2uQmkceyD2v49mveKmSL6gqW5KzWtBp4ys1332vl/BvXTpiJkhCjyrms8y5wp2ffT2XJejEt+baE4Xj110pzCpdb6ibUJrg1WXktnQZ+BpE1OrY2zIz6fWhRMT3fGbGjC3YH97XXLjJYareIVzOolqA5BdmZDuoXGjTpUa5xZdZYo3TZMdzJJN7m+FvmL6YQM3ydc8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0ki7CNWI81NeXwkQsLs/6J7GorbnlB1EGHGDNc9p68=;
 b=m+WLYbDIK6CEt1BkUn08Mt6hb6H5h3dyqsybGfHg8PGQIyIW54uEqhCq1fM6abQQdM/XZNL9DDGwbT3nBzqW3QPnUNU+WZHvqfJ4qR8oSoWuL89Mm6nylL25vhitg9+9mCF10eDv6eRfubUIevwH23H2+48vJ9N+z5Pr6+KEj5GsYf37zPGgIyYI7lopS7A442B4gPKP6Cd6WgySdxWRnJEslmt+oflY7lk+nSzYTVWRtDKpWi1tWEfSOV+8954TxOFZznHYxgb2d5yIk9+SclI0pROarYoM1pig7OGlZtAJM/+J7A+42+Dz7fQ8OIrr+ptx6j9epMBMOjPSFOVd9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0ki7CNWI81NeXwkQsLs/6J7GorbnlB1EGHGDNc9p68=;
 b=NgzSojPpZxhUXueqetztT+oMSC6NXPlqL4UBRCJ2r9zv7yEwQDYUQRA/qZnhNjUSlkqH1T/9CtBTKUMJp8TZF4lxd04ExfpW/veFuraumsfCV3TMogvWwvTuJV0Ur1vZMG4Q6ae54s2WgmPXy1m3AAR2rYgCHufGVqwcAvpVmX8RcKoP/JHk8uL7YeM39FlryKVrCaYv7hi0Pckc7PIygz4cRI3EDGc1YbLfQZMy/IuTPdXqbEFi7FYq1+WMlc1gYp5lARryWUUu6aRY/ewugTiCYaSKnuYQSJgfjcshskEgw/9ST+4z/4IhHnocP8g3YxBlFZax97snEdchOFJiyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH0PR12MB5025.namprd12.prod.outlook.com (2603:10b6:610:d5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.24; Tue, 4 Oct
 2022 17:22:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::8557:6d56:cba9:dbba%5]) with mapi id 15.20.5676.031; Tue, 4 Oct 2022
 17:22:09 +0000
Date:   Tue, 4 Oct 2022 14:22:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        "Jason J . Herne" <jjherne@linux.ibm.com>,
        Marc Hartmayer <mhartmay@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Qian Cai <cai@lca.pw>, Joerg Roedel <jroedel@suse.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v2] vfio: Follow a strict lifetime for struct iommu_group
Message-ID: <Yzxrv4M5sQWcusLp@nvidia.com>
References: <0-v2-a3c5f4429e2a+55-iommu_group_lifetime_jgg@nvidia.com>
 <4cb6e49e-554e-57b3-e2d3-bc911d99083f@linux.ibm.com>
 <20220927140541.6f727b01.alex.williamson@redhat.com>
 <52545d8b-956b-8934-8a7e-212729ea2855@linux.ibm.com>
 <YzxT6Suu+272gDvP@nvidia.com>
 <1aebfa84-8310-5dff-1862-3d143878d9dd@linux.ibm.com>
 <YzxfK/e14Bx9yNyo@nvidia.com>
 <b11044c1-af26-4442-25a6-655a9872e956@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b11044c1-af26-4442-25a6-655a9872e956@linux.ibm.com>
X-ClientProxiedBy: BLAPR03CA0088.namprd03.prod.outlook.com
 (2603:10b6:208:329::33) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|CH0PR12MB5025:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a708e43-6213-4150-7fd1-08daa62cf7df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 84AEwGsKNGff9WPYdgb/CqLAruPBMAf0oe31KR/JqDGU9R6VS/7JgzRhGRoTdd6JITGJrYZyRVQeXXy11on/OyGOS0s4CnGY8VBWI4jUd+Dh0M8lapjRdXs0bJmZI8J7YpOp+mBfJdxczBE9dTZN8v03RKTej/XM2rl5qtVKriYWzfWijlFZHYTk8+fsIfWgyVCv7qoLJNNhaMrREY8OJZERXC8WHqs14dz/s3Ow1BkNBh5rMcV8Y/ysmt4oZJWgO1SfwsH3Q6vtCAeySClHYBt3lR7xt9QlmFJPrOXdu9LOja+pLc3XYI0f9d4x0JPhgBdcKdcZ4tzcBK1+tTHtlE7EwpysHqspctfruMeEb8SWJMXS6iCMv3O5ZrYDfXkKlzfEDGoSbeJmRpLwrHZMvxpXAvlH4YQkP7tVgxlIuzSO9lD5PKVp3PKl8YSWBm88g7IliugSdHt4DNMnJjQVQUr6Kl+CNQheIvJAZDUj/Up6doT74ExLXr0kgYpl2lhFW+cQObXDON+G1dlOKEwBCQyShrqA1s5FFfb4MHuwp4uZ4bCXYnvLrnCspiazsKqCRFGAe5kkDhLzD0T2GboYrpvPo2baROhOwEjPq5NFjwUURFnDkb7Bn2RvnXUm9x0ag0ABsB43S9f6ZJEV23idsLj05PfGJLa3Qr7QteWFdANk4Mnr1ZjFLxqzIZRFltSIjT2UVSlz9zYZxPV/hO4VKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(136003)(366004)(376002)(39860400002)(451199015)(26005)(6512007)(6916009)(6506007)(54906003)(41300700001)(66556008)(66946007)(8936002)(66476007)(83380400001)(4326008)(86362001)(8676002)(186003)(316002)(2616005)(36756003)(6486002)(5660300002)(2906002)(478600001)(38100700002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?97Jy/mlnf8SW0cn5215Qb/qSWWIGUSDS7VBiejndW3c6TDriXwaDxTRpgLwn?=
 =?us-ascii?Q?SSRSdhlPX9mWCwgRcab5WGb6gBDjI53YCo4ngokm7MovX/WyMvQt3cy0QTid?=
 =?us-ascii?Q?muMB6awjC1DdQFxfXRmAjjyDbg7Z4TUjM/g2x8dJL8dl8OWnKbw9gXT72OkX?=
 =?us-ascii?Q?jPCxFlEFr9N5arpG+nVyouMyd7SYHXIUuJKUoSwPxEwyPSnEQaDdLVQ3xm05?=
 =?us-ascii?Q?qCbVfJRX/s9cpyhoCVOU2b4KrO+3G6kG/AuRPlelArqzTGrMPOj4e78wE+PL?=
 =?us-ascii?Q?FKy88SS6JAdnUptVJVbuY7BbrzNmmcuSlJbNZzXcLIrvPtskjStSiK0mis9w?=
 =?us-ascii?Q?Pp96zTgassSPxnYaSwfG8IB19Fz76G/FP6jyz9q9ZCCel7pyA6evym7k+tqy?=
 =?us-ascii?Q?2yQZp9wEsypV2U0gHOFjVF1Ianh7Sktn3yfk1iWJzKRfG9sgAsKB/+15FaTR?=
 =?us-ascii?Q?xadY7G42HV/pLY7jxDS4J/zGyG+wULKoHZ8XRRKwCBYeuZHn3W7LBiPoppIz?=
 =?us-ascii?Q?AMjvq9d1yRKD9cB2HS31R4vxqoyzaRJkq4oXpcVbn9tWugWg5l/hhT7RRkU+?=
 =?us-ascii?Q?pkc9snGoqULPyort79keF1lKujNUVOEsU7Latw1VB8j9dytpGvPIkyogGm9v?=
 =?us-ascii?Q?sClJYcl2dhcb08qghnpP70RpKiDacdUHXYS3jHp+XpY2jYWlsHDMZoRM7ETw?=
 =?us-ascii?Q?UkrgFLm8giIlPN8cN39CngHous5ONUcoAABYuUteu+oMDf8hnBD8dgu1f8T7?=
 =?us-ascii?Q?AfrfZgpEJRIVHE8PtoY9Sm/a5/BDk0mj7xa5kGMc+vvThT6YOpofmJ/QysoG?=
 =?us-ascii?Q?e83oxfdF2YIbr7g63k7kWnVm5h+138A0u/pdFGfq5HlSBJ0R5LJ87oDPj/go?=
 =?us-ascii?Q?d8PipXMwxnV7yOqFCODR5RqheV1d97KrstMwqV5r591329RCdB9Jppc3jGtC?=
 =?us-ascii?Q?T+5NGDWSR0WDjhxnCBbGL8h8wm0dV3P/YT+bcbFUk3tRX34mFJ9+ZmxxfMT6?=
 =?us-ascii?Q?ybDG12Gt+YR1RxEH9af1TnsrwF179gp4dSUDIlol/dHNBH6/ufMSWrqt++mF?=
 =?us-ascii?Q?rJcVXbnVi4nRRx/4YNs9Tvdomz2Afiro2UDhXoDMvcKCxKea3DOpejqW+PkF?=
 =?us-ascii?Q?y2HXbbcGiV78TblwbBA+E1yFFpzcU9/P/qgGzMz8H1DRpx/n7kU+viqSTrru?=
 =?us-ascii?Q?eZI5JbvNNN8g73nBpbAV+4L4iipgYWWwStuP3gCdL6xXCBGQzW5ti6JJD2fe?=
 =?us-ascii?Q?gfadBERet9hAqIchohU/T1Vq0/BJA2V7QQNp5mvfU70Ls8Urn/D1m+z7dT+Y?=
 =?us-ascii?Q?wYX1rX9G0G+phBMkYPMMtwQSlVfGK05OIu6mKGwueyhZksV2Gfnn/pfP/qhv?=
 =?us-ascii?Q?BYyqVTSygtOEKz9B5S8diWdeGysgd5Xtg7/PI6kthg8axu8t3VHDJyorBVcv?=
 =?us-ascii?Q?LfzkPUmr/YilyO/j8lHKfffHQdwgLP6/HfO/Z7k4nQxmLfGx3z+QNZ2/xNdB?=
 =?us-ascii?Q?e15gLj5BVpc5+sU4K081SjZbxeaJ/wUe9ML2+6i04nk4TFPodlry9LAa2taO?=
 =?us-ascii?Q?tlHsyX7aiR7RAiJe1W0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a708e43-6213-4150-7fd1-08daa62cf7df
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 17:22:09.5313
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /opM8U9bRyCUWDO+m1GXUk2R6kSs3JXOfZtkGC3JJtKuWpZ0XtPGnFnz+6ZVSgIs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5025
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 04, 2022 at 07:15:51PM +0200, Christian Borntraeger wrote:
> 
> Am 04.10.22 um 18:28 schrieb Jason Gunthorpe:
> > On Tue, Oct 04, 2022 at 05:44:53PM +0200, Christian Borntraeger wrote:
> > 
> > > > Does some userspace have the group FD open when it stucks like this,
> > > > eg what does fuser say?
> > > 
> > > /proc/<virtnodedevd>/fd
> > > 51480 0 dr-x------. 2 root root  0  4. Okt 17:16 .
> > > 43593 0 dr-xr-xr-x. 9 root root  0  4. Okt 17:16 ..
> > > 65252 0 lr-x------. 1 root root 64  4. Okt 17:42 0 -> /dev/null
> > > 65253 0 lrwx------. 1 root root 64  4. Okt 17:42 1 -> 'socket:[51479]'
> > > 65261 0 lrwx------. 1 root root 64  4. Okt 17:42 10 -> 'anon_inode:[eventfd]'
> > > 65262 0 lrwx------. 1 root root 64  4. Okt 17:42 11 -> 'socket:[51485]'
> > > 65263 0 lrwx------. 1 root root 64  4. Okt 17:42 12 -> 'socket:[51487]'
> > > 65264 0 lrwx------. 1 root root 64  4. Okt 17:42 13 -> 'socket:[51486]'
> > > 65265 0 lrwx------. 1 root root 64  4. Okt 17:42 14 -> 'anon_inode:[eventfd]'
> > > 65266 0 lrwx------. 1 root root 64  4. Okt 17:42 15 -> 'socket:[60421]'
> > > 65267 0 lrwx------. 1 root root 64  4. Okt 17:42 16 -> 'anon_inode:[eventfd]'
> > > 65268 0 lrwx------. 1 root root 64  4. Okt 17:42 17 -> 'socket:[28008]'
> > > 65269 0 l-wx------. 1 root root 64  4. Okt 17:42 18 -> /run/libvirt/nodedev/driver.pid
> > > 65270 0 lrwx------. 1 root root 64  4. Okt 17:42 19 -> 'socket:[28818]'
> > > 65254 0 lrwx------. 1 root root 64  4. Okt 17:42 2 -> 'socket:[51479]'
> > > 65271 0 lr-x------. 1 root root 64  4. Okt 17:42 20 -> '/dev/vfio/3 (deleted)'
> > 
> > Seems like a userspace bug to keep the group FD open after the /dev/
> > file has been deleted :|
> > 
> > What do you think about this?
> 
> On top of which tree is this?

It should apply on vfio-next

Jason
