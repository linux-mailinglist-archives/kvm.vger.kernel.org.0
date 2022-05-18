Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C09B52BE6E
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 17:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239178AbiERPM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 11:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiERPMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 11:12:54 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2055.outbound.protection.outlook.com [40.107.96.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5B0827CE4;
        Wed, 18 May 2022 08:12:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSSMBKvXfLjeITBsv0vmD/+sVos8ZgS2+TKe4AtrLPILeMy/3rGR2k9Pn/vdvUMIUJOM8zVHumLlWgl99TpVgPlOU6nqebIxtOoUqkKOx2nuAYr3UPaslmtSkwy2/y+ETLZIHJK7wsBgMLhEY/FhpjoB0SBzFMCELc6tG5McwM2uhqhT+/0ssb7KQfO1bOIm3rVjUkqOzFOOF346WoxO1nNuvmejHGMky/AIA2LKDMIP8zBGjHyuYaVLL1RwwmZPf6DGgsQmU88TYQSuLOhCYZ78Le7bOfPsarz27Ly/ESn6MbSTm+3QbLRBbQDUWHMUnylfFWq69H2ew+SclJolvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTGsz5wxR/hbfwvCtwIMRLzkaQrTyy4FyPBgjvizNmw=;
 b=QFi5Ye/2rCyImWvCAz7jHs0f3rLocdwuCjv/eEJONPg1qdxl+TWh79gFIFK2i0Dmz0UWzlcyCIeGRpgXJ8jMCX2r8qL3Wrj5Py/frziSjSd0q997peDq6wnRpbNIopQ7byL4rO2KmGLPfqWuvxM+7wZnGb7EDFm0sG3aHIEwcodY5RyJIN08YkPzaContLxfSY833U0XsCxiijWmTJOxT/1STHTOVNW/CFx2CFslORT4pEjOhV03ID3BuaJYJFL9kDqun+QgTXdJpYWphb9PN2LFSdvXgU6tSS5rac5+l+9hcz2hYuFoVBi4mcguGdXi01sBlW4eX0SRN4MZnu6Dgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTGsz5wxR/hbfwvCtwIMRLzkaQrTyy4FyPBgjvizNmw=;
 b=ULdX2/EXygPf8TXdAejoeAh42Y4coNVTvmNNIGcBErEjjWeTq8nEtP6+IU2H3Q3w/48SJXGbwSulGs3cN7uxW+gHHq8ZhP1fQV7vFfdrcrDc8TLjy9Di+FIbON7MbfobaX/wI/MksE+hgWk7m5YcfrTdHM6JItpClG1fldQTGvNic9/mTEkfQ2cS6Bf386jQ+IUMgxtkpb8KpxIgn1zNEClpVmBUXtL3VqUq6LyBuXsoSnY8q7K1beIcyfn3Fuy0vkHt/0XamxNK+DwV2ltzystHFKe7cqoD/ABproBb8OdxvzW2wg4JHtIlwg7dRj+Bz0PVaJGidWPkZB0ceDbW0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB2931.namprd12.prod.outlook.com (2603:10b6:408:6d::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Wed, 18 May
 2022 15:12:48 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%7]) with mapi id 15.20.5273.014; Wed, 18 May 2022
 15:12:48 +0000
Date:   Wed, 18 May 2022 12:12:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        borntraeger@linux.ibm.com, jjherne@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Message-ID: <20220518151247.GI1343366@nvidia.com>
References: <20220517180851.166538-1-mjrosato@linux.ibm.com>
 <20220517180851.166538-2-mjrosato@linux.ibm.com>
 <2e51b388-48d0-4689-07f4-65f607dbce59@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e51b388-48d0-4689-07f4-65f607dbce59@linux.ibm.com>
X-ClientProxiedBy: BLAPR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:208:32a::8) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0648f6e1-938c-4de5-5a37-08da38e0de67
X-MS-TrafficTypeDiagnostic: BN8PR12MB2931:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB29316D4D84DE88C99AEDE9B6C2D19@BN8PR12MB2931.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I30a7tiJoE7nybazReDU8lkxpsCR+nE/H5B+FFu/zeVnLpw0NjP0c4UaDIOG3R9bl9XMRnIx4uWoaYjCOYiLHFx3qYmVg51gAhSWFoBVRmXnprCxxPQyXjNv7tPufrP9PfVTq27vTf8tr0kqfLVEaY711TEfPN7kCp/SMjLhh8O/S5j7CET7yN+x4SE9fa3cSLZBsZaMzk+jvAuVLaasSWD8rDV65hMhk9oyVwORIig0hfvQwr5nlEHZWyJ/oKzv6OoebL7Os793HVnvGGH6BEw6oRRoAJTsxL+8tYcgXDNRQXgG6cJlyPgn0DewO9rkTsdL6Br2S4eJlevAWlz8kXSIF7sseVNSvbm4ZbMOf9/JpqEqbCerIqggomu/J0HUo+b7VivXbs5sX0cDHZpUBkmhB3I2k+cyx5Gcd0MFf+goK09dNMfIZ/aYvfwHHxfbD0A0li+2GSABCYWGVmMQ2e8WNXnXJjUNTil5jsrdKmn2r2zmm55ltX0Vmd39c17efpU6W+OXyoBcyAobSC8s4Nk2V61Av9D4B/96Z7q5ndulrz//2lgOwkkHQq+Z+hhWpEKAGCoBA0mlMpG0+NCjAEDaEOrEqc2OKBkdnuS+kLTqFiXC2VtyIE6GGG7dEJ2P9gHtOs6pKS8EHTyppQvfOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(33656002)(36756003)(6506007)(1076003)(6512007)(83380400001)(6486002)(26005)(8676002)(4326008)(66476007)(66556008)(38100700002)(2616005)(508600001)(7416002)(8936002)(6916009)(86362001)(316002)(2906002)(186003)(5660300002)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aTJwgm1jQ9CCs8YbRNzM7qyuwkEmzvBXUeyQATbuL3NhMdKnZtCvWK3bF6ei?=
 =?us-ascii?Q?haqiyZ2Pp2WyXvC+bJTWLsSQVkiE1RxVe2cZy2q8LDVXFej8bvi9zxENfusp?=
 =?us-ascii?Q?bDw70aG3Yx37zzlrODLOB+7g2jAcalWexC+D0MqwEA9m6eNb2x1jKxDr/cu1?=
 =?us-ascii?Q?+yl00NcqSAgu19mLJscJXsHY8xUW/hPjiXHYY6I7RBsgr3YrBaIfFLWjaMn0?=
 =?us-ascii?Q?ERc2WlDwlEorXeNLLMJzhxrleQOEIX19m4oAc56P5kl3yzSqDiLYW6+4hBED?=
 =?us-ascii?Q?VRz2Wen3ipi7UcDvOpP5RkcAhxyDJMYhyxuY3IgjsY9qT7qrYnpub7JMcYXd?=
 =?us-ascii?Q?SOxqSWNEnK3aGNlSucfgEMm8ConT1R5UvQ+B5JNNPwsNjLPkw8hMkqb9apmh?=
 =?us-ascii?Q?d8A96SnVNjhwrMh3q1KesfjMWukErIk3Wg0fSy7AlDg5iBeHWOxeyeFojm4F?=
 =?us-ascii?Q?Hob07/i8q940eCrDSglaClgRrjBb9iiDrTqg3Jlrzxc3SPbv0TDQLkCQpa5V?=
 =?us-ascii?Q?Y51atY+iOyrj5XpFAqfPFNgu7Vx6229sml6woHnfO/5lnkDh18PnugCi2gDZ?=
 =?us-ascii?Q?g60rY9XuUPBMErFYDGeGayCoXjtgDC/q+oVdZl9NVoiINTgyDSaYWZHLIpHW?=
 =?us-ascii?Q?56Wr75CdOe0nZSUC/4JgOzQzTIXe+8GztD6UOPJLaXVjK2HMao0cGVIetW4i?=
 =?us-ascii?Q?7nUJEx1HWzIyheyP8ydzms2BP4pGcIIe1dFsNoF4mF2R7VNx4LZyTODuv9B4?=
 =?us-ascii?Q?daqyLD7kC6IQSQgWUoQiODT+DyUbrT4Xdq1vukZyUCkIoTpSD++iDyiXB0gy?=
 =?us-ascii?Q?c56C0eAyLS2+DCo2w/sXv0cMJ6223wOxmC23uhEXSthW7JW2+rv68ULJPUJ3?=
 =?us-ascii?Q?x3dwLbAs7BDatviUtSZI97GEWoP6BVHjhG/gBtwbcI+wFbG3w7UUytSqYTML?=
 =?us-ascii?Q?JAGd7Nm/bf5LsvQeo24vkoIls1RDkEv9A3Eleu6o4ooXBlS3/E71Xl1rC5A+?=
 =?us-ascii?Q?f1vrBsCRF3mlEYPO2BLWuXK9ZRtitfdRRy80CRSEtTak+RJqMxzcjLrKwKF5?=
 =?us-ascii?Q?rWe1wgRpTx/QeyFTB61H6IT2/To1HgPhz9G9x+dP4KSTbywu+beICeDPHMtZ?=
 =?us-ascii?Q?rSnLBrj0H2ENc42kND6eQsq37KOaPT1+6LvsHrXV7Tt7Cl3Ab37eVYHHX++Z?=
 =?us-ascii?Q?gpngL86/rOimKvFrWy5bDs7KlFwYKYnPl0oD8TREE+b9YG6AiO8P3F4syjzV?=
 =?us-ascii?Q?cJ5BXzbbvU4EHOaDrBv+cGYJ/O40lXQgUUjUwh+EW+wcZc3a1w4E38fr4Evn?=
 =?us-ascii?Q?mowd0ZGDA1tqto7OMkrGzoaOt+6b2RPwSkmnFHVp2Zxr5C8DYoL8FzF+pMS7?=
 =?us-ascii?Q?PX/hzycCcW5L/8KWEoETXJ6V8d4mfQE8SHY6fS8b9d5S7f+aL1jYi4QYz3aC?=
 =?us-ascii?Q?QeaqYDD1U3VzX663qneX3yqoy7pMBzMVgN5VaTB1FuOcrxYz04mezO79O2/Q?=
 =?us-ascii?Q?3cA7yxt8vQo8HJiBYp+kw0r3WESrB1FxZ/V6gFisXlBxwg1C9l8YfD7PVcVV?=
 =?us-ascii?Q?JTncL6meHtPHlIKsjw4nM3sE++kEqLPAtNgroAvS9AB2tj3+5t/um9YOyuMK?=
 =?us-ascii?Q?aqyMGt8z0DYra6wgEVadOciDKHZ+hl69vymkNky/xhIQ+kEguJxGxsKPqSH6?=
 =?us-ascii?Q?vEaEoTdjI+e3S//J8M70QQAw7y3D4UsjvPiJ/vOj42ohbQJ1PE7NYms0KwYr?=
 =?us-ascii?Q?l/i9H07d0g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0648f6e1-938c-4de5-5a37-08da38e0de67
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2022 15:12:48.2428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ur2wD2C+vfI4Da+JJ+v1NdVjt5a/iIH5AIP5TzNyCKIP6AEmZenfO++Fj2zakJb/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2931
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 18, 2022 at 10:37:48AM -0400, Matthew Rosato wrote:
> On 5/17/22 2:08 PM, Matthew Rosato wrote:
> > Rather than relying on a notifier for associating the KVM with
> > the group, let's assume that the association has already been
> > made prior to device_open.  The first time a device is opened
> > associate the group KVM with the device.
> > 
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> 
> ...
> 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index cfcff7764403..c5d421eda275 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -10,6 +10,7 @@
> >    * Author: Tom Lyon, pugs@cisco.com
> >    */
> > +#include "linux/kvm_host.h"
> >   #include <linux/cdev.h>
> >   #include <linux/compat.h>
> >   #include <linux/device.h>
> > @@ -1083,6 +1084,13 @@ static struct file *vfio_device_open(struct vfio_device *device)
> >   	mutex_lock(&device->dev_set->lock);
> >   	device->open_count++;
> > +	down_write(&device->group->group_rwsem);
> > +	if (device->open_count == 1 && device->group->kvm) {
> > +		device->kvm = device->group->kvm;
> > +		kvm_get_kvm(device->kvm);
> 
> Did some more compile testing, since vfio has no hard kvm dependency,
> kvm_get_kvm and kvm_put_kvm are an issue if KVM is a module while vfio is
> built-in...

Ugh, my other plan was to have the driver itself capture the kvm, ie
we lock the group_rwsem to keep the group->kvm valid and then pass the
kvm to open_device in some way, then the driver can kvm_get_kvm() it

Alternatively, I don't know why kvm_get_kvm() is an exported symbol
when it is just calling refcount_inc() - inlining it would be an
improvement I think.

Jason
