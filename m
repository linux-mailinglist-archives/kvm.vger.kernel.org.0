Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A8A4E6AA6
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 23:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355356AbiCXW3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 18:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238178AbiCXW3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 18:29:16 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2057.outbound.protection.outlook.com [40.107.237.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF55BA31C
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 15:27:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/KaCteWdqg2rpedbPUCZaxg2QRFOUbgIvXa5ffvA5ZEPx48P8ZzIhU15Dsz53WLXhAZ9TXJP8Pl+q/tB2T+s9KxUS2ZKemfkjoHQY/teUhB/DvMJRGMUyN/yOUbmIWWmfo9L3yLblk0+0QTbVhtIUQmyzOblRFqP3aUYR+9b53+s0KUcnIFGIk1jyZt27FkpXpfk3bX9V7l7H7523ij9OQSMKpKvO+HbG4qsqtD2/z4sAX9IrgdySjnAeIB/UfUDOirbRh5Y4iLd+PjEl9aSuF9QYM3R7lpQ7XoSNTwJd9z+JFteOLlflEZYzTpd4KvWH5VrTyBOEAs6Xh2QkHc+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gPBkYv17GgaCnchvWVFsKty1aq+9Gi8oVs/m/f9a6U=;
 b=ASceTw3c9VVs2E+P5JFTztpKu5G9U7zIBdxWG172brXUc2XDolfVC9O7DiF5NR7x7Lj5dEmTTlv0uQ4w5J2rjfqNZ5CsgQXdGivFtdNdWkBHwZ7JulSjEegTYzK9M47zygurI+QnW51G9G715z7dLppfy04MT+S2lU0Qmi8t3Hs80NQyVlJBMXH4nnb1fvu9jc8Nl6qey1jvZ3JHMAdsMjWj9M+lFF3aUkJNKfxiu1/inK+FGGSr8IwRHRq1wiBMJhSR/k6kgO9U9Gm58gRsYOpu4v1wStIt3Jt01Z7STdT4jPEXGnL9mZx0hIESs69NoczEQYQTACOpCEcmlBzZig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4gPBkYv17GgaCnchvWVFsKty1aq+9Gi8oVs/m/f9a6U=;
 b=ZWZ/jByBD2Rg3KzU1gmBgc7VNFMSWPWUwsc3IxDMZjfHOpFNSdlB/dGawD6dKAtMlBs4B9D0etUWrYf9Tz9ZnHtKfhf1acuu6xLUpIMASyi79t1E3KirUMsPgoW5Ao2cN7YvCB1YMq8Mr/UfOe9SFZ1OAKY2v5by5vq/rEbQYwdmgPccIy0kjWnLemDriM+0BwNE9HT3egYN96ezx6NA0CEkxfxjIRwYB5QadLboNvf/n0vHTY4CeHPntMYngdHxtj0zQ3L/LaUgp+p8Y+gQ+0k9hxi1XVzMCp1pj3z7PFKhDLHWTk/DUMi0DMNZLrNnE631Iqy8TAjxkg3riqERPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by PH7PR12MB5902.namprd12.prod.outlook.com (2603:10b6:510:1d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 24 Mar
 2022 22:27:41 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.019; Thu, 24 Mar 2022
 22:27:41 +0000
Date:   Thu, 24 Mar 2022 19:27:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe via iommu <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        kvm@vger.kernel.org, Niklas Schnelle <schnelle@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Message-ID: <20220324222739.GZ11336@nvidia.com>
References: <4-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
 <20220322145741.GH11336@nvidia.com>
 <20220322092923.5bc79861.alex.williamson@redhat.com>
 <20220322161521.GJ11336@nvidia.com>
 <20220324144015.031ca277.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324144015.031ca277.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR03CA0009.namprd03.prod.outlook.com
 (2603:10b6:208:23a::14) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d45c3de4-d089-4578-efe2-08da0de5822a
X-MS-TrafficTypeDiagnostic: PH7PR12MB5902:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB59029C9EAEA2E8DE05DAE5DAC2199@PH7PR12MB5902.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x5Bs7aJv+k8U9fYb+dOTWfWJdJmYOwKnY97rVqW3ssPcZE+zigttB964Y9pBBUyRk8jLeTIqAAzh5ckTqc6FnZ5UzFd+p8gXvS/TAYwtxwPZq7q5QLz4JA1ZWre8bdJ1LfKZ2kWcWdXy3DAIitmJHzzYGMhN/SgWxyoulJtmYJsqFD98seZ2cBg7Z/FBQVkjemtIgXl/bH07t72afXytHLsyG6kcnoamG6Gwecsqxpj7guyUz+f66wzepvJ3l2P86oPHacazuudxNuiN2nsu67VJvaZ/DX1LESJJbUodBkOD+L/kGuF/UeV30QSSaYAFq7rPu100dMHefmvLAi1IqCbuAFHT1MXyGNDOQazl86ngB+g7fuw+MnqelmQLrvQHRbxAFMpgW9UZJ2bj2upzhDmJjC/aL9Ar3wWEt5Xop/6gErgRI86dRG/C1It6x9olATQkY6o3Lvs0t6TSdAnQDW+YLyvV13P9zpEFrMREv3yI8+rEvqFuoNP+NRrs4t6T5r9SFYkx6Z1Kedc9Kru81tTxcTk0zC69b25ox291+lQg+uJpMBZVpeSUO2E2WmI6xsrkurAP7nIdOBr1ni9/AWEslpOU9Snw2BcatiKMtbEJkD7T/Mg4w67dBBUPp1PJHf5HOvOypux3qrwtQRhq/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6916009)(36756003)(316002)(38100700002)(54906003)(33656002)(6512007)(6506007)(8676002)(66476007)(86362001)(1076003)(7416002)(4326008)(8936002)(66946007)(2906002)(26005)(2616005)(186003)(83380400001)(66556008)(5660300002)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZwPkJyQPnOR0uZn4YduRRGnZjvEIek/T0+jZ5d4jzbcjqiwpsf0TT/5ywpR+?=
 =?us-ascii?Q?qD47vL74Cu8U0SArLBlWYysZ6cXoNy95O2YuExqGw66MvXcVsHplzqW5hVI1?=
 =?us-ascii?Q?9LODSlhi6F8omj1Hc9U/wi8ecC3SynMlOho1h3LBqzlmuLMAnS9L3+HJ6Ebg?=
 =?us-ascii?Q?QEkuuWGRgm5+fGEQ5kfM9oXrvrV60dCkFpZKa+9TXYDnlYzOW0V26x8Xc+tY?=
 =?us-ascii?Q?653jwRp/eFH0p7ex/AC6XPSRT/k6mNsoqiHMBIhu6txbjZDqrRYKH5vC0lve?=
 =?us-ascii?Q?PQc2z4WJrWwmsMy+oL+6eh4abTY77jb6bk2jpBRXVQS20f+qUqpmPCLOkOv5?=
 =?us-ascii?Q?gseWDsKYVIwhlbu9+2OzSO3BPPwUJtWUPogKcR/0p5hWpHTx4kAWcbjAD5ZH?=
 =?us-ascii?Q?Qzq4D4YONEi/cp/ZsWvGBVEQXNZcWz7tByTseCorBvUyb3FoNSXCcA0s2s+f?=
 =?us-ascii?Q?NA+KWHex9WIL/PGykszDdGomUSae5E6mJrBRAq3YsNNjFFE0+2KH1+YznJ4h?=
 =?us-ascii?Q?Ab0UOskf1BIV/ny82zR2Tyox6OWwDcKX7uljPTPyPBpO8VdBqD9ryJmL+XIs?=
 =?us-ascii?Q?NKkbYqUNoFyoTZxZm13r+sxfu39k6/fUn1dpIfm6P3zWTzx88M7l3p0sJqFP?=
 =?us-ascii?Q?Q16/KKUDaN+hnA35UnSPZDNcJrY6Av7MMMnK39nr+zlYPIcmLBn65F8xbWXV?=
 =?us-ascii?Q?+vYHh/n6c3qSeOvUGQO5COpVn8c2/UDXM1WjAYvpJYl8a2pYIq0lYIybJKw0?=
 =?us-ascii?Q?tg5ELauzGZ3M28yFonlWHL5GKRQ8MR5btoVgNFnQUH1iGXF0c/Sc+Ino0bFi?=
 =?us-ascii?Q?LAvjZOluNIDLiLPsglWxRo6TTnyvGZmph6gjuPETi1GMYV6vlgUVBnnw3FFK?=
 =?us-ascii?Q?93n8d3FaHLImvPqvtsk1Bj2SErWTBd4lLRE5OMCKr42oaYHyT5r98ibd0iMi?=
 =?us-ascii?Q?ZxU2vcpumeCakBAqxMKEopDLFC3//v1ene6gnsZvysrslUA+6g2idSQ1EgDA?=
 =?us-ascii?Q?Wzu86l8nTn2lxI8u1WF+7jad2GwiY5NxAu8GenoPBENlp+ZwcWB2yQEnNgaP?=
 =?us-ascii?Q?E/UrJoSuAyF4k60jTAf42OD4ExJr/L87trXnYwyfij7ndMvgCmcd/9tOfFzz?=
 =?us-ascii?Q?IXs+tzZbSeOKhU38yfxZyj/l6XiQNegx7qC3jx3xWs5+sdcgTFRaTQArNofR?=
 =?us-ascii?Q?aEnVd2vuJD1i1x7DwHUt3uUATMw85Wkjt1dCEgz5thY/dljuU3Nrt0EFD5qj?=
 =?us-ascii?Q?TslP79gm+k5rw4I5ZzyDzCf0PM4cQLx0vC809p8CMO+cMowH0+5ly6DlmSaw?=
 =?us-ascii?Q?fmDIKYly6lEYoKeb+vahinEU+lGNC0LnritDIIT2RX1/gTn/ph4MuzvQSB7O?=
 =?us-ascii?Q?htpJafm2Zwnh62mD/yqHp1TVuUgWom20TM4Gz+SE95ondoNLJNAQcmNP80KP?=
 =?us-ascii?Q?GsRePu0MbVCfH2hdLvKoAiAEZXf0Mr3S?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d45c3de4-d089-4578-efe2-08da0de5822a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 22:27:41.1994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W7gHnQTvKcE15NS5Kt7olCyi1QIL3OhcHz01rfInFfBuaFArdS8dyUVSmDcgwDSW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5902
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 02:40:15PM -0600, Alex Williamson wrote:
> On Tue, 22 Mar 2022 13:15:21 -0300
> Jason Gunthorpe via iommu <iommu@lists.linux-foundation.org> wrote:
> 
> > On Tue, Mar 22, 2022 at 09:29:23AM -0600, Alex Williamson wrote:
> > 
> > > I'm still picking my way through the series, but the later compat
> > > interface doesn't mention this difference as an outstanding issue.
> > > Doesn't this difference need to be accounted in how libvirt manages VM
> > > resource limits?    
> > 
> > AFACIT, no, but it should be checked.
> > 
> > > AIUI libvirt uses some form of prlimit(2) to set process locked
> > > memory limits.  
> > 
> > Yes, and ulimit does work fully. prlimit adjusts the value:
> > 
> > int do_prlimit(struct task_struct *tsk, unsigned int resource,
> > 		struct rlimit *new_rlim, struct rlimit *old_rlim)
> > {
> > 	rlim = tsk->signal->rlim + resource;
> > [..]
> > 		if (new_rlim)
> > 			*rlim = *new_rlim;
> > 
> > Which vfio reads back here:
> > 
> > drivers/vfio/vfio_iommu_type1.c:        unsigned long pfn, limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > drivers/vfio/vfio_iommu_type1.c:        unsigned long limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > 
> > And iommufd does the same read back:
> > 
> > 	lock_limit =
> > 		task_rlimit(pages->source_task, RLIMIT_MEMLOCK) >> PAGE_SHIFT;
> > 	npages = pages->npinned - pages->last_npinned;
> > 	do {
> > 		cur_pages = atomic_long_read(&pages->source_user->locked_vm);
> > 		new_pages = cur_pages + npages;
> > 		if (new_pages > lock_limit)
> > 			return -ENOMEM;
> > 	} while (atomic_long_cmpxchg(&pages->source_user->locked_vm, cur_pages,
> > 				     new_pages) != cur_pages);
> > 
> > So it does work essentially the same.
> 
> Well, except for the part about vfio updating mm->locked_vm and iommufd
> updating user->locked_vm, a per-process counter versus a per-user
> counter.  prlimit specifically sets process resource limits, which get
> reflected in task_rlimit.

Indeed, but that is not how the majority of other things seem to
operate it.

> For example, let's say a user has two 4GB VMs and they're hot-adding
> vfio devices to each of them, so libvirt needs to dynamically modify
> the locked memory limit for each VM.  AIUI, libvirt would look at the
> VM size and call prlimit to set that value.  If libvirt does this to
> both VMs, then each has a task_rlimit of 4GB.  In vfio we add pinned
> pages to mm->locked_vm, so this works well.  In the iommufd loop above,
> we're comparing a per-task/process limit to a per-user counter.  So I'm
> a bit lost how both VMs can pin their pages here.

I don't know anything about libvirt - it seems strange to use a
securityish feature like ulimit but not security isolate processes
with real users.

But if it really does this then it really does this.

So at the very least VFIO container has to keep working this way.

The next question is if we want iommufd's own device node to work this
way and try to change libvirt somehow. It seems libvirt will have to
deal with this at some point as iouring will trigger the same problem.

> > This whole area is a bit peculiar (eg mlock itself works differently),
> > IMHO, but with most of the places doing pins voting to use
> > user->locked_vm as the charge it seems the right path in today's
> > kernel.
> 
> The philosophy of whether it's ultimately a better choice for the
> kernel aside, if userspace breaks because we're accounting in a
> per-user pool rather than a per-process pool, then our compatibility
> layer ain't so transparent.

Sure, if it doesn't work it doesn't work. Lets be sure and clearly
document what the compatability issue is and then we have to keep it
per-process.

And the same reasoning likely means I can't change RDMA either as qemu
will break just as well when qemu uses rdma mode.

Which is pretty sucky, but it is what it is..

Jason
