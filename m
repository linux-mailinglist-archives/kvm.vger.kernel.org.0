Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66633EA5AC
	for <lists+kvm@lfdr.de>; Thu, 12 Aug 2021 15:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhHLN2B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Aug 2021 09:28:01 -0400
Received: from mail-dm6nam12on2051.outbound.protection.outlook.com ([40.107.243.51]:38625
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232081AbhHLN16 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Aug 2021 09:27:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZTllXf/ovdQCQ7ZzVWk01zDVrqgGFtF4eEaQN/08T8IGfB10OiWnw8I99OuNX8vr82J7mIGsaNM4UdjyBKV+l42u/k5Ic+XkfApN9D/JwbCikSS4GDeBe5Qsw3AdtUBBNNSZZZuRz6br0phEww5P7vu9l3MCTw+eK4lFVwQfZ2DAPEt5i5r8Hk10eJ75XGKGqURL8IhjfuBo5y11jaJhju20Asu5k36IKNQSw8Bx5RBOc4MDipcMAqjPIJdIHiKNQyEZVW2GSZggnKQYBL/LumIvTqw/Kgaa7ElXvsQ4117M6czt/Lkzs6HbKvDuuhqdcoygFDzGXKe3Ey8CkYI8jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdV7r+2gCD+7YxJ70ymKBZkP25XzH6TFmMdG/tqXA9c=;
 b=FWOt/A+vv8nIDa0L9CVY637ycW74JOtS8Gk62H6LiyL6C0nG72sC9AseEhnK89P8d83ZzZvYfE/ocmNef52amTrla4hvLjP6+JlPo8q96/FIkPjLvbOlXaZISsao/MeCO7XhCYdfHHAtxlax/evnYzjmN5E8FsQiMGMk0Zb6LOKPX3kzjNyhEohkfK+7C255IGhd+fcUZ3xk5V9qGYDHIXWdVUukX0fGZKRGk0WZG2Qi6hu37VjvZCIdeVrCOkPdcoLzwzDxqoIT+FOm2rDztO9nQU99QbFiTZx/3OLgVaaZOXEYz3bPf290TbJSFTHy/jJBYo4QMkuiD/ioyF16hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdV7r+2gCD+7YxJ70ymKBZkP25XzH6TFmMdG/tqXA9c=;
 b=oYBkJ+firtOErTcZ/yVlPSVoMS/ImZqlsjtJVd1OBymwVbgmQwZ6bMnKLuKUqyKKMOoQyIA8+UgDRM3O6XuslJDHbW5BqUcYM45KfB9FFawIaVSoyFypTEeaQyqDYi6pjkrIO/B4x6OEeYBtorkWujmXKdmYLTmorpGZxoClVmZqquqLPf7j20S44VEFVjLn5Z+kgemDHfMOcMMQBd9qSsJkie4NvuiNjm/V4GTCSKfzIZOejZFqVIkHoTO/witSr57ayenY4GgFoqhdOAk9hOhWNxB117iweB+Oi+QaKdoQFrbEUB+Y/LEpqpBsZwB9m9pYMaLHS7o/uL3B/ehI+A==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB5520.namprd12.prod.outlook.com (2603:10b6:5:208::9) by
 DM6PR12MB5517.namprd12.prod.outlook.com (2603:10b6:5:1be::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.15; Thu, 12 Aug 2021 13:27:31 +0000
Received: from DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::81bc:3e01:d9e0:6c52]) by DM6PR12MB5520.namprd12.prod.outlook.com
 ([fe80::81bc:3e01:d9e0:6c52%9]) with mapi id 15.20.4415.018; Thu, 12 Aug 2021
 13:27:31 +0000
Date:   Thu, 12 Aug 2021 10:27:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        corbet@lwn.net, alex.williamson@redhat.com,
        diana.craciun@oss.nxp.com, kwankhede@nvidia.com,
        eric.auger@redhat.com, masahiroy@kernel.org,
        michal.lkml@markovi.net, linux-pci@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kbuild@vger.kernel.org,
        mgurtovoy@nvidia.com, maorg@nvidia.com, leonro@nvidia.com
Subject: Re: [PATCH 09/12] PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to
 struct pci_device_id
Message-ID: <20210812132728.GB8367@nvidia.com>
References: <20210806002357.GD1672295@nvidia.com>
 <20210811190737.GA2378935@bjorn-Precision-5520>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811190737.GA2378935@bjorn-Precision-5520>
X-ClientProxiedBy: BLAPR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:208:329::30) To DM6PR12MB5520.namprd12.prod.outlook.com
 (2603:10b6:5:208::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0085.namprd03.prod.outlook.com (2603:10b6:208:329::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Thu, 12 Aug 2021 13:27:31 +0000
Received: from jgg by jggl with local (Exim 4.94)       (envelope-from <jgg@nvidia.com>)        id 1mEAk4-0002Vm-Si; Thu, 12 Aug 2021 10:27:28 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 14491c71-8df7-4eaa-d9f2-08d95d94efd9
X-MS-TrafficTypeDiagnostic: DM6PR12MB5517:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB5517CFBB3F07839B10F2E418C2F99@DM6PR12MB5517.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sKxdh9lVh+205rs+7es2PDysYWu9QUqz6HBDgUe4CmZkcj2AcTc8oD/HtC51iy/j88PTN/d1NxhAnw/RBESOr4ophAULsDKGZAzqcWUZArZ82wcoRqm4Ys7d46JphsMP92cxrbxv10/DK7yBwvECeyrwJYCrSlUJG3TN83TEExHkm4J6FFYRET6/6m7tPRdBh2uz//9fnK6WkIzcdE5FPT9wABr+rPZW75MLmqGCuWX9XqbCNrDvNGJvPw93/uH5Sb4NbpeQA5UeKsWybko/jlapRc9XsLiENksisSa+GaAoiyjXzXHN84ooge8t+C38ct+OVBuoqLbjl9nAKCK7x3b8PQn/yNjc5xdIfym/GnVcTywPfWAZeGJL/ElHIyz7J6ZHj8mqS+B/PFMpwF0+n/Rl48N0f0mMETc9ghY/D4hVVLKfDLR/REJbvhPU6//Jiu3E4G6HC361ERKQRPeH2N2nRwI1V/P3o/kVqaV6d+xoyptV6WFX0KLU1jEg7a6kfJk9i82TQQixNNtD40ATacXHkdMh84dnlrGTe6OZcL1Lg1HHwgWZYVLw0ko4b2DtJZvkQIkmdsa/ltcp2q2YqOdHw2m4f/oiLwOawY6XbNr2JR4wqG7U1yEqTT4LIbbz+GsoJSmXorxkktRdoJxpBA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5520.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(478600001)(1076003)(8676002)(186003)(4326008)(316002)(86362001)(36756003)(26005)(9746002)(66946007)(426003)(83380400001)(38100700002)(107886003)(9786002)(7416002)(8936002)(2906002)(33656002)(66556008)(66476007)(2616005)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3nSnYcwjPq1vxfgSSMQVlqjZ5DxJIdk0ZAJu3o5ArdES4wG5BqC1dtabGrMw?=
 =?us-ascii?Q?92aJcE5QnohY45GyRpi1P2ibOUNBdXRGrJH5C8FqoUCU5u7VvHTbu371eEW8?=
 =?us-ascii?Q?D6MkPB+JHKawpQvwujgFer9jN4B1xWE7fQmyqfHDgEws0sLdaRLdlbplkT3T?=
 =?us-ascii?Q?NXQRLiWLFCLEH4qsG2iqP/riF36KSiJ+xmh6VSe7r/YHjMq5fMv5pCeUiJ6i?=
 =?us-ascii?Q?Bmx8eBSbCtlAdbE92mrmvgR2j+YEBT50/r4hhsVGzaD+XMp7Nozseobhzjx8?=
 =?us-ascii?Q?n8tubnlWUzqhwzRG0uw1562mlOfFKgGqnfSmiZj5l6l90Ad3cB1dM3g12+m6?=
 =?us-ascii?Q?4Hs3GYM/nQYasczz8QB9WrWTJZSShKiUAdH+bfX0DWysk147kFrCMmY0wYTl?=
 =?us-ascii?Q?sDafCG6rWviW/yYnhkZnd3s0GRGlmtt9Uf26bm3TXUgTNsT6ogJSfk+FdgmZ?=
 =?us-ascii?Q?F6jqQdEK+lmlfZ8Q6s6a3QvUBHBB+NYxom9eXQOBQgYCm1wJXeyl0QkR9RXd?=
 =?us-ascii?Q?74d+9jYZlAVtAIDkFFWIZClWg73eo+XOMeB9GiusCfGA7tPlWR7fXt7dVq8g?=
 =?us-ascii?Q?tuNE5aAzD4ELY3vT1JvGpqc6OyUw+9N/5Q5PbB41drL8nvgY3bh8p+GfMgyM?=
 =?us-ascii?Q?OiPNmu1ovY0v+fp38GnmaolLe60Efo6b5O8riaJy3MK8m+Muu6QlJbwBf4oP?=
 =?us-ascii?Q?dP6oQzpEP26dZtGpSF+GOm0GCi/kxwcc7+XgEskGhQFJNMt6KL59jmOO3AK+?=
 =?us-ascii?Q?d9IKSRuKJhb8ZyV2oASMzFj9OyBZsl+rj7/+JjqgQbd/HCHLgnzOg0u28rtO?=
 =?us-ascii?Q?hZO76T2Ph8zOFaS+bOgMe3mna7/RXE1zTjhWL0Gk5h6zvzNXZDWVue2GFm4s?=
 =?us-ascii?Q?PixHUUL2dfEQUqRsKjSGM0XMocQ7OHAAKJWoIQ3bmm8Vapi8tkg4U5QJkvnU?=
 =?us-ascii?Q?YcSGLPUasiaxezFUbDrcfsSAi5nF9Jv5+4R2N34oJEDH/6c1U7su1E+eCX4l?=
 =?us-ascii?Q?RAP/CQG/0xoNf522zcFegTmkcHCr/ASQU5xJWqHWfXGiPNuAuYmLSYHkKfEc?=
 =?us-ascii?Q?V7xzH4BbEMQcsAMwuLn6+E3jUMGaYF1FnqA8FhaK4SOIxjfYFRuJcNQpmlv+?=
 =?us-ascii?Q?HbT5/2+BEd+jU4NdirNEwXhaGigyHmxPAa/gmHmL8B31Xx4l6GwmrecA3Ltk?=
 =?us-ascii?Q?7gxpMwX/q2axMXthDH0liAKO8DGSavABWCLBBw+Dgf1qko48NzakW2AzisyJ?=
 =?us-ascii?Q?s/TwI9NdZXWnJnq/OlX+CxfbkVDitITh0vll+BiQGAS3YDUCA/3j9lp6OraL?=
 =?us-ascii?Q?oxk0uL/75Xt79DLq8CslaSa7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14491c71-8df7-4eaa-d9f2-08d95d94efd9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5520.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2021 13:27:31.3257
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N7+8D389bnix30yW//TqLUVFYk+Ue1S00sURxmgJWo6GqndrfSmIDPLM8MQtXwlU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5517
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 11, 2021 at 02:07:37PM -0500, Bjorn Helgaas wrote:
> On Thu, Aug 05, 2021 at 09:23:57PM -0300, Jason Gunthorpe wrote:
> > On Wed, Aug 04, 2021 at 03:34:12PM -0500, Bjorn Helgaas wrote:
> > 
> > > > The first use will be to define a VFIO flag that indicates the PCI driver
> > > > is a VFIO driver.
> > >
> > > Is there such a thing as a "VFIO driver" today?  
> > 
> > Yes.
> > 
> > VFIO has long existed as a driver subsystem that binds drivers to
> > devices in various bus types. In the case of PCI the admin moves a PCI
> > device from normal operation to VFIO operation via something like:
> 
> What specifically makes a driver a "VFIO driver"?  

It is a device driver whose probe function instantiates a "struct
vfio_device" which binds it to the VFIO subsystem and triggers
creation of the char devs, ioctls, etc.

No different from every other subsystem, really. Eg a netdev driver
creates a struct ndev_device, a TPM driver creates struct tpm_chip,
etc.

> supports the VFIO ioctls in include/uapi/linux/vfio.h?  That by itself
> doesn't require special treatment by the kernel, so I think there's
> more here.

The unique thing about VFIO, compared to all other subsystems, is that
VFIO is a second choice for driver binding. A device will have a
natural kernel driver, eg mlx5 naturally creates netdevs, and it has a
VFIO driver option. Userspace selects if it wants the device to
operate in normal mode or VFIO mode.

The kernel should never move a device to VFIO mode automatically -
which is the special behavior compared to any other normal pci_driver.

> > echo vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
> > 
> > Other bus types (platform, acpi, etc) have a similar command to move
> > them to VFIO.
> 
> Do the other bus types have a flag analogous to
> PCI_ID_F_VFIO_DRIVER_OVERRIDE?  If we're doing something similar to
> other bus types, it'd be nice if the approach were similar.

They could, this series doesn't attempt it. I expect the approach to
be similar as driver_override was copied from PCI to other
busses. When this is completed I hope to take a look at it.

> > PCI: Add a PCI_ID_F_VFIO_DRIVER_OVERRIDE flag to struct pci_device_id
> > 
> > Allow device drivers to include match entries in the modules.alias file
> > produced by kbuild that are not used for normal driver autoprobing and
> > module autoloading. Drivers using these match entries can be connected to
> > the PCI device manually, by userspace, using the existing driver_override
> > sysfs.
> 
> IIUC, the end result of this is basically a tweak to the existing
> sysfs driver_override functionality.

Yes..

> And I *think* (correct me if I'm wrong), this actually has nothing in
> particular to do with VFIO.  It's just that you want to expose some
> device IDs that are only used for binding when driver_override is set.

The general concept has nothing to do with VFIO but adding the "vfio_"
prefix to the modalias is obviously VFIO specific.

The entire point is to convay to userspace the information that the
modules.alias line is just for vfio.

We could imagine in future some other use for this, in which case the
future user would use their own prefix, not vfio.
 
> > When userspace wants to change a device to the VFIO subsystem userspace
> > can implement a generic algorithm:
> > 
> >    1) Identify the sysfs path to the device:
> >     /sys/devices/pci0000:00/0000:00:01.0/0000:01:00.0
> > 
> >    2) Get the modalias string from the kernel:
> >     $ cat /sys/bus/pci/devices/0000:01:00.0/modalias
> >     pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00
> 
> So far, I think this is all the existing behavior, unaffected by this
> patch.

Yes.
 
> >    3) Prefix it with vfio_:
> >     vfio_pci:v000015B3d00001021sv000015B3sd00000001bc02sc00i00
> > 
> >    4) Search modules.alias for the above string and select the entry that
> >       has the fewest *'s:
> >     alias vfio_pci:v000015B3d00001021sv*sd*bc*sc*i* mlx5_vfio_pci
> 
> And this patch basically adds this modules.alias entry.

Yes.
 
> Previously vfio_pci contained no vendor/device IDs, and the only way
> to bind it to a device was to either:
> 
>   - Modprobe the driver and write dynamic device IDs to the driver's
>     /sys/.../new_id.  This should directly bind the driver to all
>     devices that match the new IDs (see new_id_store()).
> 
> or
> 
>   - Write "vfio_pci" to the device's /sys/.../driver_override.
>     AFAICS, this won't bind anything (see driver_override_store()),
>     but if we call the driver's .probe() method via modprobe or
>     rescan, the driver_override will match any device regardless of
>     ID.

Yes

> IIUC, after this patch, you can add vendor/device IDs to a struct
> pci_driver with this new flag.  These IDs are advertised via
> modules.alias.

Yes
 
> For driver binding, IDs with the new flag are eligible to match only
> when driver_override is set to the matching driver.

Yes
 
> Setting a device's driver_override has *always* caused the matching
> driver to bind.  The only difference after this patch is that now we
> give the driver an ID from its .id_table instead of pci_device_id_any.

Almost - before a .id_table entried might be returned as well. The
difference here is that there are "hidden" entries in the id_table
that is only used by driver_overrride and we can return that hidden
entry.

> >    5) modprobe the matched module name:
> >     $ modprobe mlx5_vfio_pci
> 
> I assume somewhere in here you need to unbind mlx5_core before binding
> mlx5_vfio_pci?

Er, yes, I skipped some steps here where unbind/bind has to be done
 
> >    6) cat the matched module name to driver_override:
> >     echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
> 
> Don't you need something here to trigger the driver attach, i.e.,
> should step 5 and step 6 be swapped?  What if the driver is already
> loaded? 

The full sequence is more like:

     echo mlx5_vfio_pci > /sys/bus/pci/devices/0000:01:00.0/driver_override
     echo 0000:01:00.0 > /sys/bus/pci/devices/0000:01:00.0/driver/unbind
     echo 0000:01:00.0 > /sys/bus/pci/drivers_probe

> Can you modprobe again to make it bind to a second device?

modprobe is a single-shot, it just loads the module and doesn't
trigger any driver binding. modprobing a second time is a NOP.

> I see drivers/vfio/platform/vfio_platform.c; is that what you mean?

Yes, look around vfio_platform_acpi_probe()

> I don't see any VFIO things with ACPI in their name, so maybe I'm
> looking the wrong place.  If this is purely *plans* for the future,
> maybe say something like "planned VFIO drivers ..."

Sure

Jason
