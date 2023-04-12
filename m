Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515666DE860
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 02:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbjDLABO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 20:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDLABN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 20:01:13 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7774BD8;
        Tue, 11 Apr 2023 17:01:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eUD3xZbgOalAcIXEvZhjKrXK4dMwvk5UCMg+PMiQPciMFRI09HSXr1BDiVDhBuXJaUwF+jQ02nWtRC7RBWk3se/1SlRGOArRQfaSO6Efi6h2unrpKQe/XzC6bY70D7S4wexU5MzwhiWE1IBOnLCDZBxfrBoP/JQAVCw6FPgpmk0WHz6g82i2bpf6zpcN/x2XV3lMTlsOPKJvWuELOacTv+85LA7ps1xFd9MAVxjWTyf/tCvZ5Yz/imb0sEfxk0q9imshu2ncAWAPt56opFtSMCS4pHMnYLuCkA8MnYxYLPRIjyEsD44KbmjQxWxqQZgTGUFpv1EVN2wyPRVUfTzJlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1QvRAGshAv+ARNkgRRdKDKsD8fvybf/7895DKoXaJHU=;
 b=lCBMUoFzVbnFXUqXwtzKeNc5kxLMN9ZBv65QRAQoHBZjAClQdTAKkcEuGHHe0cx7ClhSQ8NIyCu5PX7TZaKrgfWl9rcnWNqKzO4nPVXtVVCZbdMDCnc8QqOtH4J5F8BECvq0lM/7gljzSvQJLlsy3mfm4NtdN64DjIamRcZ5NroOYoRa2MJ/QhnNBFfis/3KJC6D2BWSW7IDN2/lzQ/PTWohob19ps5ubgTaS0WYeMRCQWXWL0KxhrifhRNUybFQ1mxaDtW0n7wDrMQvWA/t+Yn9Q4BldJtLnsvfbFNXnsrNkZ7KJ1K2vZxtCXx5ppbAUYAU2JbjYWSORnTlk1k01A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QvRAGshAv+ARNkgRRdKDKsD8fvybf/7895DKoXaJHU=;
 b=oidCF1UUY50bfVvHrcXGgwaa1ex8ESxT+TSsW74a0H5Id/BIW8mkPPigWxB+zPcJNCRcO9ajfVb2acBgNTXFkHhLOTEJcdc6QS3skktP6GGCKRvNI54R8HkaB5vwGqCv8n/vdCkOZnEqLzMP+HCGKhe9q3mqpLvXi9nbo8q87OrUHgejVgegEunGjv/zf7bYymzP4GwISyxtJL0xGZG25hBylJdaUbi4EjM0HGXFDS6XKLMyyZVBIUP+wjK3QUOklronLrOJ6omRymtElAzYas61TTDAEbsNIlL39mqF5Tn6q2fhNSlTraDrfduxQpIewG1jI+jPMmF1s8T0s7o6yQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ2PR12MB8977.namprd12.prod.outlook.com (2603:10b6:a03:539::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 00:01:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 00:01:09 +0000
Date:   Tue, 11 Apr 2023 21:01:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
Subject: Re: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Message-ID: <ZDX0wtcvZuS4uxmG@nvidia.com>
References: <ZC3KJUxJa0O0M+9O@nvidia.com>
 <20230405134945.29e967be.alex.williamson@redhat.com>
 <ZC4CwH2ouTfZ9DNN@nvidia.com>
 <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406115347.7af28448.alex.williamson@redhat.com>
 <ZDVfqpOCnImKr//m@nvidia.com>
 <20230411095417.240bac39.alex.williamson@redhat.com>
 <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411155827.3489400a.alex.williamson@redhat.com>
X-ClientProxiedBy: YT4PR01CA0061.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:111::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ2PR12MB8977:EE_
X-MS-Office365-Filtering-Correlation-Id: bfd648d7-f0fa-48c6-22dc-08db3ae90486
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 19dWwHjWRjSmbUGIJZ1tX96V1jIvDblrVasclwu7X4ZG4b2+t3TXr8qc6eovyaqawyLcYMf1uIKdTAg1AxTcxC3DPTuLqu5iW4krZvd35opBb5F28du6DN82vpmc/ZKMvd47FU/ZA8I8Yjjocu3bWRNHlUNAfdwHCe6W+9wmi1dYZfXVGXhjk7y7i/rv8t8x/KfKntW6O1BxLOiFxT5A0oGPjaq080Xd8Tj+kqHzJQ/yDcFoij9On18NATD09MpoOJ/A1MIjeTtaHAEZbScEolaT8WdASWJKQZo9P4kS9rBSdJmp1o+lbaikaLbWqev5Mlw++y+HY8JcOzWi7YLCi0tRrnhytDPybKmPVe7S8Ni3lYFSlnoGjBRdksoWIdrComc15sgk/Set3cZW+iOX8kcIwaLNpJ//hrGhw8dcNoB8k0LymvlWaOqSoZSJWe5AGNDiEPQTcOosh9EpfXWDloq2PfRJUSJbdruR4Niz577uBjNrR9pr0SOuI4aN7IsuH1YtOfQFfNUuMsAXgRMW2WgSce9MYPNRgU4B0Yn9GgWqawoapKV7MIar2XEvJ/8/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199021)(86362001)(6916009)(2906002)(4326008)(8676002)(38100700002)(66476007)(186003)(66556008)(66946007)(6506007)(6512007)(26005)(66899021)(54906003)(8936002)(478600001)(316002)(7416002)(5660300002)(83380400001)(41300700001)(36756003)(2616005)(6666004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3il26cyZiiCRsd48IdbUi49N2J5IKCGGr2I5zlDDpgZ+7lUqwQmoSVIQsGOT?=
 =?us-ascii?Q?7RRtg0e63qf94J5BfJdekotd41UQ/Z7/pMqhpZWBVXmtWn26QgE3TEtLxCPN?=
 =?us-ascii?Q?kv7nJPzu0mReAWlDugVb6Qze5Mm7B99SRegbv28MjESKNiehD5CW1bjn2T9g?=
 =?us-ascii?Q?h9fQ+yZHtSwA7K5lw3/IvOUh8+NGRh4PJ9PjKmaI6cIPuVwubW/Y20Bi5Ctg?=
 =?us-ascii?Q?zr4Fn0R/wyuU7gW3WMyBfsz6Juhrn/mRZkLYc5hdC5xSGlIDS+ViKafy/fxN?=
 =?us-ascii?Q?osp1QQ7VmgC2ISFwjlSB1p0PgzCetv6L+MKroJV0OsbkERcv3i29bG0v93we?=
 =?us-ascii?Q?6SCB5F99zXt4zCTcMLAgeBEzXIU2IypwlYuOAVnhEIBt1f3UYRkwpHIk+TT2?=
 =?us-ascii?Q?jo8xmSrJNt07qTn251dCMagBlpqzdGEMM++y8z/R1K/e4skhc0O/a6ZPEOGI?=
 =?us-ascii?Q?Iw1HtIJ3SKn9TXrcjSKd6ylL0ExwPs9aTBKnolKBC3wsZRhh39AX7w9K2q/b?=
 =?us-ascii?Q?PSS2YQJEVc6ZZxS7BIttlc+NpNAHk1+E/u1nhVmE538/CncupaLR1eVZe68C?=
 =?us-ascii?Q?WxmIKcOM23J+sYineUHbTSxt+hPjkElA+WUJcN8/nlhtO5VlbjDeXw6/X5fW?=
 =?us-ascii?Q?gp8ckTlQHv1ZATfs1m+8hw8z32oqrvRs/0B7qaQEo58wCAikbTz+Hjjm2jj+?=
 =?us-ascii?Q?er8yZEwqcAv818ZV7Zc/x/uuu+gov9dkdi5HmjinfNG9mji8HVQV7BKXnYL6?=
 =?us-ascii?Q?VMlIFcWl863VrhlFiVemGXQIOmCNIpSIGoKthErUZ3ZxdFKm96dL/PztzdFu?=
 =?us-ascii?Q?NBGYThfiibYrJlSjOnf1JNCGFFgCO0vavDvELwm7bP3FkOj4s5TouGvICx/C?=
 =?us-ascii?Q?DOnrPfRMpAW1GpgxBiVRbBriGpMA8V+Yz8L7L0/F1fE3hprYpqXc29nddqYR?=
 =?us-ascii?Q?Fj8G93YcjJD/5Q/OHiiyC1FaSlO3VjP9q8CXWrIlYnWAWY+poUdtnBy7CzeG?=
 =?us-ascii?Q?gGcbpdTWbJiUzvNERAP02C76jjl/9vEwQC2Se1Sousgsb+XWYiR3i3ave8cy?=
 =?us-ascii?Q?lkIWy5ZLWrrp1m+Cd+h2W1TBp8zPZklbRb5GMR9WpLzrYq6SWKds0KSllxHF?=
 =?us-ascii?Q?NxN13SdqCsDjxJZrJwoRQ90djtbIK8+x0sJfya9z+J+yBTkiEpEj0BwZtxPJ?=
 =?us-ascii?Q?XfZ1jPFib/hUv/CHlYGvz+POWl4NFElpQsXrkoNWZ3MiyNvDMWAU/vIVC8gi?=
 =?us-ascii?Q?aTyTCogWx2dN5e6IHoEkaALy/7ActvYzkyNaIPxxnUJp14BlXLQgkkFusrOp?=
 =?us-ascii?Q?LgHaYPkjqkjC8O+jlbcQqHgjNO2itd7vFgwGBRoGD8BzgViNfoa7re1UugCG?=
 =?us-ascii?Q?5iRThikTT+bm9SC7ZWNlXGqwKdsZ1itBYBjxZ4KcnZNl+I+TknaKNNMszYUZ?=
 =?us-ascii?Q?i12/iu8A9VFgugUBAsfoqaeY2cNkXb0BV2T7VOHTL3dQge28pbpbmSTnP3lg?=
 =?us-ascii?Q?AtTW1qLo2yOhu+OdmlGBIXlKl2lezN5Mew5lDStDNnSsxkL//ja2S8OYQfBM?=
 =?us-ascii?Q?GWhmH0/OYHvVjkGyJI93iVLqNAYoGgP3pppSzCMz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfd648d7-f0fa-48c6-22dc-08db3ae90486
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 00:01:08.5122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ZeZgzmjFIa3ZcliZYxOrc2QeW9yF03TgIKcy+hjDT2d7em5ToHrquMan1yfttAp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8977
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 11, 2023 at 03:58:27PM -0600, Alex Williamson wrote:

> > Management tools already need to understand dev_set if they want to
> > offer reliable reset support to the VMs. Same as today.
> 
> I don't think that's true. Our primary hot-reset use case is GPUs and
> subordinate functions, where the isolation and reset scope are often
> sufficiently similar to make hot-reset possible, regardless whether
> all the functions are assigned to a VM.  I don't think you'll find any
> management tools that takes reset scope into account otherwise.

When I think of "reliable reset support" I think of the management
tool offering a checkbox that says "ensure PCI function reset
availability" and if checked it will not launch the VM without a
working reset.

If the user configures a set of VFIO devices and then hopes they get
working reset, that is fine, but doesn't require any reporting of
reset groups, or iommu groups to the management layer to work.

> > > As I understand the proposal, QEMU now gets to attempt to
> > > claim ownership of the dev_set, so it opportunistically extends its
> > > ownership and may block other users from the affected devices.  
> > 
> > We can decide the policy for the kernel to accept a claim. I suggested
> > below "same as today" - it must hold all the groups within the
> > iommufd_ctx.
> 
> It must hold all the groups [that the user doesn't know about because
> it's not a formal part of the cdev API] within the iommufd_ctx?

You keep going back to this, but I maintain userspace doesn't
care. qemu is given a list of VFIO devices to use, all it wants to
know is if it is allowed to use reset or not. Why should it need to
know groups and group_ids to get that binary signal out of the kernel?

> > The simplest option for no-iommu is to require it to pass in every
> > device fd to the reset ioctl.
> 
> Which ironically is exactly how it ends up working today, each no-iommu
> device has a fake IOMMU group, so every affected device (group) needs
> to be provided.

Sure, that is probably the way forward for no-iommu. Not that anyone
uses it..

The kicker is we don't force the user to generate a de-duplicated list
of devices FDs, one per group, just because.

> > I want to re-focus on the basics of what cdev is supposed to be doing,
> > because several of the idea you suggested seem against this direction:
> > 
> >  - cdev does not have, and cannot rely on vfio_groups. We enforce this
> >    by compiling all the vfio_group infrastructure out. iommu_groups
> >    continue to exist.
> >    
> >    So converting a cdev to a vfio_group is not an allowed operation.
> 
> My only statements in this respect were towards the notion that IOMMU
> groups continue to exist.  I'm well aware of the desire to deprecate
> and remove vfio groups.

Yes

> >  - no-iommu should not have iommu_groups. We enforce this by compiling
> >    out all the no-iommu vfio_group infrastructure.
> 
> This is not logically inferred from the above if IOMMU groups continue
> to exist and continue to be a basis for describing DMA ownership as
> well as "reset groups"

It is not ment to flow out of the above, it is a seperate statement. I
want the iommu_group mechanism to stop being abused outside the iommu
core code. The only thing that should be creating groups is an
attached iommu driver operating under ops->device_group().

VFIO needed this to support mdev and no-iommu. We already have mdev
free of iommu_groups, I would like no-iommu to also be free of it too,
we are very close.

That would leave POWER as the only abuser of the
iommu_group_add_device() API, and it is only doing it because it
hasn't got a proper iommu driver implementation yet. It turns out
their abuse is mislocked and maybe racy to boot :(

> >  - cdev APIs should ideally not require the user to know the group_id,
> >    we should try hard to design APIs to avoid this.
> 
> This is a nuance, group_id vs group, where it's been previously
> discussed that users will need to continue to know the boundaries of a
> group for the purpose of DMA isolation and potentially IOAS
> independence should cdev/iommufd choose to tackle those topics.

Yes, group_id is a value we have no specific use for and would require
userspace to keep seperate track of. I'd prefer to rely on dev_id as
much as possible instead.

> What is the actual proposal here?

I don't know anymore, you don't seem to like this direction either...

> You've said that hot-reset works if the iommufd_ctx has
> representation from each affected group, the INFO ioctl remains as
> it is, which suggests that it's reporting group ID and BDF, yet only
> sysfs tells the user the relation between a vfio cdev and a group
> and we're trying to enable a pass-by-fd model for cdev where the
> user has no reference to a sysfs node for the device.  Show me how
> these pieces fit together.

I prefer the version where INFO2 returns the dev_id, but info can work
if we do the BDF cap like you suggested to Yi

> OTOH, if we say IOMMU groups continue to exist [agreed], every vfio
> device has an IOMMU group

I don't desire every VFIO device to have an iommu_group. I want VFIO
devices with real IOMMU drivers to have an iommu_group. mdev and
no-iommu should not. I don't want to add them back into the design
just so INFO has a value to return.

I'd rather give no-iommu a dummy dev_id in iommufdctx then give it an
iommu_group...

I see this problem as a few basic requirements from a qemu-like
application:

 1) Does the configuration I was given support reset right now?
 2) Will the configuration I was given support reset for the duration
    of my execution?
 3) What groups of the devices I already have open does the reset
    effect?
 4) For debugging, report to the user the full list of devices in the
    reset group, in a way that relates back to sysfs.
 5) Away to trigger a reset on a group of devices

#1/#2 is the API I suggested here. Ask the kernel if the current
configuration works, and ask it to keep it working.

#3 is either INFO and a CAP for BDF or INFO2 reporting dev_id

#4 is either INFO and print the BDFs or INFO2 reporting the struct
vfio_device IDR # (eg /sys/class/vfio/vfioXXX/).

#5 is adjusting the FD list in existing RESET ioctl. Remove the need
for userspace to specify a minimal exact list of FDs means userspace
doesn't need the information to figure out what that list actually
is. Pass a 0 length list and use iommufdctx.

None of these requirements suggests to me that qemu needs to know the
group_id, or that it needs to have enough information to know how to
fix an unavailable reset.

Did I miss a requirement here?

Regards,
Jason
