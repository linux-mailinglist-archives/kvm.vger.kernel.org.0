Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26CAF6DFF63
	for <lists+kvm@lfdr.de>; Wed, 12 Apr 2023 22:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbjDLUGr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Apr 2023 16:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDLUGp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Apr 2023 16:06:45 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2062.outbound.protection.outlook.com [40.107.92.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A946272B8;
        Wed, 12 Apr 2023 13:06:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B6w4NHf0SFNIVHNF3D4pVkVOE8zUD9dqN6+R+HhRPT2Qsd/gMpIUNVVbxUhWqSdheal7nmQxRo1aAkJ0zJz0al0DhO3DFSe+rVliQGlJ8l79RQLrs9LzVSqw7KfnlnyCwMiZyCnDO66FjT3ncFAokiXN6YsAcMCjg7449FtY/YclKA+e6TRix3P52TEjzvKqCd0RiJN39F2aJk5fcdXCUDft50Qmv6uNXHPZngOY3QZsAYmVDGqe7KdXt4pHtrq1n6IJp4eoBwBClU0tgJbfzCzli0/W/+dXsFJ9dDmDHK2Cspo4u3KtNaClrOpcSbrZniGiR2QdxSVrCU5hunCTog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyWeYyx0KpFIBxH0mNGsCaAesVUa6okKbhY0pu/tUJM=;
 b=Maq4rk5GZyUVl+AluIfaZ8u9Wppoqfrr3zNgiEscOEm37T8y57iBlM0OCmGxWIjt7+GrOCi+CUO4xtuvf6hVHDEGHKnhSBEnv1yNaeehFVLn42ncaUyWLBMmXNHRr5pbs6yjxwQD5qaoqx1xty9Sj+ymIZxs3SgQiyIBf2LWeSV7Fv+xtdlp7KG42Obc89ffK/QIypjZFyoClPqrjM0CeANq47d5PNBVEGWVvz2PGaeIpHIO2J1XZbd25cDRiup1a0edSDeReQSdyBxiHr4SFh4wpqWge7yFHW3ym1ofYFVbMt8FTmmC9ckwjs0eN+FIYFIdVrtpuMvecK5PCZfMgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyWeYyx0KpFIBxH0mNGsCaAesVUa6okKbhY0pu/tUJM=;
 b=jQkXgSVM0hPsrgMxo9BZqbYVUDzE/QO3r5xO0QHLuXDanOGloyK5HumFC6KhIy2LFdL8y8RL3HVpLFTD9KFwhLp8bIq8VHazdOzB5qo47HGoHd+33r1NkA28SwSL0zX7Nss/gqCsTt0VNftXUVs3wJY/vqoIBE0G2Z0l3LPp382WToX0lKe6h1wnEAzvxkwXiakLMuFRSOe8MMtyZ/GmXoZ2YVYProdCnw2PB2C0TrU/KRg4loY5XcTympL3UB9OZHANlk/8Zi+x/9m0NM6LDw97vsRwAfZ2RD6oEiAv6/4Q9BIpi1oFIjB8MRngF8c2ErJ5cImAgJYFyudRT9/Y0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB5593.namprd12.prod.outlook.com (2603:10b6:510:133::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Wed, 12 Apr
 2023 20:06:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%9]) with mapi id 15.20.6277.038; Wed, 12 Apr 2023
 20:06:39 +0000
Date:   Wed, 12 Apr 2023 17:06:37 -0300
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
Message-ID: <ZDcPTTPlni/Mi6p3@nvidia.com>
References: <ZC4CwH2ouTfZ9DNN@nvidia.com>
 <DS0PR11MB75292DA91ED15AE94A85EB3DC3919@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230406115347.7af28448.alex.williamson@redhat.com>
 <ZDVfqpOCnImKr//m@nvidia.com>
 <20230411095417.240bac39.alex.williamson@redhat.com>
 <20230411111117.0766ad52.alex.williamson@redhat.com>
 <ZDWph7g0hcbJHU1B@nvidia.com>
 <20230411155827.3489400a.alex.williamson@redhat.com>
 <ZDX0wtcvZuS4uxmG@nvidia.com>
 <20230412105045.79adc83d.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412105045.79adc83d.alex.williamson@redhat.com>
X-ClientProxiedBy: YT4PR01CA0114.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d7::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB5593:EE_
X-MS-Office365-Filtering-Correlation-Id: ac494bc5-c5a4-4c17-64ae-08db3b916d21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d+R5DyJPW1jpIjz3UeWDCJWoO7HPI8SOaaxQAVvOUVrhYYY1p/blYKMQJyPOf5uhXxQ+9qmq7J6DYIptukXhX5SqHeI1IoesHR6pQ3Y5DR8+mvOdhLLYEkXZ+tICBhJXkbcnYUqzZKKgYgJsA/g6UCwNHi0lWOSWnwwHo0iEEaYDvS+eyDFKZES5GPW83Paab0WrTeMUivWVmRBPlpc9uFyUcwiDZQr+uCbAMyimKB2Qy740PkVBOKMkuShY8R2q/rr7rAlZbDPMmlnNNOBZP+JJamdx1BmPtQHkvX5bKTy1OgFmhm6uE9pvnl/mdWp5tp+t7Z5JpZFn3YFgSweMUOYfraAQcFedl1rqBiCM+kh03Sfl8G+kwA9xxPulORNxaL1pVhjjWTnQy1CJZiwjqcui/bm1V7lWSOsUl56HvB1N3FokuGcCz4jolFZxg6CNlhNBIN8IZcAHWqsK+XSJj0rrdjUNjQErML+bT2NGj2x9AcVTpLOj3YFs1WqcyjMX5F86uieU3dLw45FgmkNXMLPxQcV4KavrLfNu7/hZ+EQmKqElvZ+GqEe33fY0WRqv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199021)(36756003)(41300700001)(66476007)(54906003)(66946007)(478600001)(8676002)(6486002)(4326008)(6916009)(66556008)(316002)(86362001)(2616005)(6506007)(6512007)(83380400001)(26005)(7416002)(2906002)(5660300002)(8936002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?unZl/TXgdHRF25uLjgni9C//glbsfMNHtY1RuaWSUBOYIv6mjlwRCyx1C2qH?=
 =?us-ascii?Q?Hev+XG9BS6jcexHaZzW1XjoB6jzerqe9pzhV5sUUeQDj7R7yB5QdvvTCElth?=
 =?us-ascii?Q?83rdzgwo7tQsSDRod0sqKb8f1jexUv7x/hqb0qzKw+fa3PiZnpney5GGi1iu?=
 =?us-ascii?Q?eoraJYOy8+8PKnFrGwEbyo/YWY+oGHFq1G1ZlbXL7G5bbgCizBuo7wssN5XK?=
 =?us-ascii?Q?84JrCeHqJIB1US07Oogk1c23OjUUtK7RRYMxEr0UIWMqauE0TQ8Sojo4pAgT?=
 =?us-ascii?Q?/FOHUvtNiSqJEqicwBya6LlH+7reInHezBHCxrJQnXDcd2d5PaDUDOy2QVQf?=
 =?us-ascii?Q?xejl+C/swV/BHMfwAjZiWeVzL0MY29Z1cMrtuvkmmGgJolVF9bdTI/FOSS3w?=
 =?us-ascii?Q?42eleH/Dl1IHo07vaFPk2a3pJYa3FPAi/z/7o2j5Hk9ZWZQ51GnCP/qnwI1L?=
 =?us-ascii?Q?AvOuubRPzInIzevCDzqrYJ6lwlyOuqEFHUMX2sx6EqFI5kKLws+BssHwXZYr?=
 =?us-ascii?Q?BhpIiuWJuQhHM5Q2tbTM6MSqUTNx+vpLrnYoMHMQomcK3/WPPEQxO2Ts6j9n?=
 =?us-ascii?Q?RSdy1q56jbdC5bLF4qLoDqlQv2egtuqAeGAz8iydw7Vm9R/PItyWYEYjJdWY?=
 =?us-ascii?Q?fglace9oxg1bhm+pfOLlRrzCnFIEL5cDz+rPI9S1ksHHOWZZFubKIGYtIh/D?=
 =?us-ascii?Q?ANscdXW1dYiXr7z89dX216b0VuJqbn6s0y8Ux5wNJzdJoIKOTUcV2Sizj5E+?=
 =?us-ascii?Q?4pl1OAbuDLL0RTW6qCPjwn37i0+bBqq3yAj171kCZTeVKhEDgywKp9Zl4vJO?=
 =?us-ascii?Q?pboXCQsmIrTU2b69Aj+OivSw+mqfdKxUunKfgJR2voy+8avxXYcJi1+AjEpX?=
 =?us-ascii?Q?GTABkrt09X/tLs9sjFUceOeYjTIrPVih4BCjXocGZMUv1YPECRHiszSFzx3f?=
 =?us-ascii?Q?FcJeTjiWOwK/5wj/HYYukyPxZv3kw935fVxc+JGg8+kRqXOPeB76xh3xxuhM?=
 =?us-ascii?Q?YJw9ye9+TbYOMJk2lHfxIVZpyFOkATFQdY23Ps9Zn0xxTCT1gYCPvuV3Phis?=
 =?us-ascii?Q?RqTfB1fPMbJiHiEBkmLvf46YQggf6GBBAJ67NCyW/6jp7vk0sZPLrwsnFSTj?=
 =?us-ascii?Q?bZlnepS1F42i8olf5a6u/r0ZqfE0uT3ttQm6kMT1qa5rRhssIsNpQjvC0+oI?=
 =?us-ascii?Q?I3vrHsvhSbl/kf3tp6JFrUpyXuPLf9evcKRbEMK4yAgB1KhN7mm82FDAM6p9?=
 =?us-ascii?Q?PrqDP+fn07f2Au3VH0gWEHt3JCVaXZYzlAtfFe6QPnNbJrN4QmW7XQOrPV0t?=
 =?us-ascii?Q?tJqWqDdxI23X7f3ylcbaULZa5YrdrCcY2Ba4os7nOhWO8TAfkJCxx13NHTi8?=
 =?us-ascii?Q?KBOehw2IxAg91xytYmwMgSg493Q9NxLGnvWBr35YwMKH48xGk/OL9EYwy9e7?=
 =?us-ascii?Q?FGnIYyqkI+HTRna5ReNlKaEaePPfMO4bgO9CM9T+5pKdC9ADa1x3EfK4B10e?=
 =?us-ascii?Q?au1Q2f+49/qM6W/DEgVq3EWDyTRCaRGxgPaJ4bxpyxqlXXpVUKJJoYeJsCvO?=
 =?us-ascii?Q?6s3vuOnAYMvukzWo3rKXUQz5bbi2S3qm7qIDkgZ4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac494bc5-c5a4-4c17-64ae-08db3b916d21
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 20:06:39.3527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: okVNVfxhaGCd/77kwRvREmk8a8RCG+QwyxEiMMwSGxjL3BFU4f2MTQDkRABZRMSK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5593
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 12, 2023 at 10:50:45AM -0600, Alex Williamson wrote:

> > You keep going back to this, but I maintain userspace doesn't
> > care. qemu is given a list of VFIO devices to use, all it wants to
> > know is if it is allowed to use reset or not. Why should it need to
> > know groups and group_ids to get that binary signal out of the kernel?
> 
> hw/vfio/pci.c:2320
>         error_report("vfio: Cannot reset device %s, "
>                      "depends on group %d which is not owned.",
>                      vdev->vbasedev.name, devices[i].group_id);
> 
> That creates a feedback loop where a user can take corrective action
> with actual information in hand to resolve the issue.

Which is why I listed debugging as requirement #4, and solve
requirement #4 by using the existing INFO and printing the BDF list it
returns.

> > The kicker is we don't force the user to generate a de-duplicated list
> > of devices FDs, one per group, just because.
> 
> So on one hand you're asking for simplicity, but on the other you're
> criticizing a trivial simplification that we chose to allow the user to
> pass number of group fds equal to number of devices affected so that
> the user doesn't need to take that step to de-duplicate the list.  We
> can't win.

It is not a simplification because the kernel is wired to accept only
a list of exactly that group length, no more no less. It turns into a
pointless puzzle that userspace has to solve, and it can only solve it
by knowing about groups.

If we get rid of groups we have to do something about this so
userspace doesn't need to do the calculation. That is the point of
this change.

> > > You've said that hot-reset works if the iommufd_ctx has
> > > representation from each affected group, the INFO ioctl remains as
> > > it is, which suggests that it's reporting group ID and BDF, yet only
> > > sysfs tells the user the relation between a vfio cdev and a group
> > > and we're trying to enable a pass-by-fd model for cdev where the
> > > user has no reference to a sysfs node for the device.  Show me how
> > > these pieces fit together.  
> > 
> > I prefer the version where INFO2 returns the dev_id, but info can work
> > if we do the BDF cap like you suggested to Yi
> 
> As discussed ad nauseam, dev-id is useless if an affected device is not
> already within the iommufd ctx.  

The purpose of INFO2 is to satisfy requirement #3 - which is to report
the effected devices *that are already opened*. For this dev_id is
fine. There is nothing qemu can do with devices that are outside its
iommufdctx, so it is pointless to tell it about them. It will generate
the debug print of #4 using INFO. I don't think we don't need one API here.

> > I see this problem as a few basic requirements from a qemu-like
> > application:
> > 
> >  1) Does the configuration I was given support reset right now?
> >  2) Will the configuration I was given support reset for the duration
> >     of my execution?
> >  3) What groups of the devices I already have open does the reset
> >     effect?
> >  4) For debugging, report to the user the full list of devices in the
> >     reset group, in a way that relates back to sysfs.
> >  5) Away to trigger a reset on a group of devices
> > 
> > #1/#2 is the API I suggested here. Ask the kernel if the current
> > configuration works, and ask it to keep it working.
> 
> That is super sketchy because you're also advocating for
> opportunistically supporting reset if the instantaneous conditions
> allow is (ex. unopened devices), and going back and forth whether "ask
> it to keep working" suggests that a user is able to extend their
> granted ownership themselves.  I think both needs to be based on some
> form of granted, not requested, ownership and not opportunism.

Ok, lets give up on ownership then

> > #3 is either INFO and a CAP for BDF or INFO2 reporting dev_id
> 
> Where dev-id is useful for... ?  I think there's a misuse of "groups"
> in 3) above, userspace needs to know specific devices affected, thus
> BDF.

I did not mean "group of devices" to mean iommu_group, I mean "the set of
devices affected by the reset"

> > #4 is either INFO and print the BDFs or INFO2 reporting the struct
> > vfio_device IDR # (eg /sys/class/vfio/vfioXXX/).
> 
> We can't assume that all the affected devices are bound to vfio,
> therefore we cannot assume a vfio_device IDR exists.

So BDF is better for the debugging print.

> > #5 is adjusting the FD list in existing RESET ioctl. Remove the need
> > for userspace to specify a minimal exact list of FDs means userspace
> > doesn't need the information to figure out what that list actually
> > is. Pass a 0 length list and use iommufdctx.
> 
> "...doesn't need the information to figure out what the list actually
> is."  That's false, userspace needs the information whether it uses it
> to make a list or not,

#3 is the need of affected devices, it is already covered.

I mean that #5 should not need this, #5 is only about triggering the
reset.

What I want is a #5 action that does not require doing a calcuation on
group IDs.

At the core, without any notion of groups, #5 requires userspace to
pass in every opened device FD and kernel checks that every opened
device is in the passed FD list. Close devices are ignored. Devices
with unattached drivers are ignored.

#5 does not need the answer to requirement #2.

> So we need one or more ioctls that a) indicates whether
> the ownership requirements are met 

If we reject the ownership direction, then I go back to suggesting
that INFO2 should do this.

> b) indicates the set of affected
> devices.  

INFO2 will return the dev_id which is sufficient to satisfy
requirement #3

> Is b) only the set of affected devices within the calling
> devices iommufd_ctx (ie. dev-ids),

I vote yes

> in which case we need c) a way to
> report the overall set of affected devices regardless of ownership in
> support of 4), BDF?

Yes, continue to use INFO unmodified.
 
> Are we back to replacing group-ids with dev-ids in the INFO structure,
> where an invalid dev-id either indicates an affected device with
> implied ownership (ok) or a gap in ownership (bad) and a flag somewhere
> is meant to indicate the overall disposition based on the availability
> of reset?  

As you explore in the following this gets ugly. I prefer to keep INFO
unchanged and add INFO2.

So maybe we should make patches that look something like this, try to
come up with a workable INFO2 and squeeze no-iommu into it somehow.

Jason
