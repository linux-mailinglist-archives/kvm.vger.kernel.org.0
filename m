Return-Path: <kvm+bounces-10505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8714D86CB62
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 15:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01F2C1F24A2C
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 14:23:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94F1913777A;
	Thu, 29 Feb 2024 14:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wrp3hkCA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2058.outbound.protection.outlook.com [40.107.93.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99C11353EF;
	Thu, 29 Feb 2024 14:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709216541; cv=fail; b=qORO5CjsXHXZoeEoLt9SWh6oLuWvhLER1usttXe+dCH+eFX777a2ge4MIQP3yy9zp3X10nOA7l3S24Aw4vP30yFKObthE9Pe4ThBHu3xxVvRP5tqngvXmCty3qfI2YnzDkRB2tnMNZnX4AenP2ahyeooxxtxwkvyS4ovDRCwjSc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709216541; c=relaxed/simple;
	bh=F7cC9C8k2WtM0eKxvkf2M9pQ27NSq+ATWXOKXdZBGaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QsBts7BVbGyqW2PCgJV0cwrkbVSwn2KJcb8ZeqO7YvhSDp2wWkJFzGzSFfRn0cS7mlx2IugWDd6BIe2rRoxOJ0iLwbFksRWgX+Y6yFZ9ZhgKQUxGqpPtmfDETjL35JolHe3aXzv4eUyipVUnGGJBbgbMSjKbe8uW9U9AGUMQoCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wrp3hkCA; arc=fail smtp.client-ip=40.107.93.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApXyKoUn+hrA61YtjdHr8KO9jlJ4FcJJoPB1nE39fAmQRfbuAYCZJSoKaFM5sI5hZMGxFvlicX+C6UqZBJPipZBTyCqrars/QqNyjRXOncImzywD8KNFZM5cbDVa5eVByxL0jAys7yeBVlD+1yhl6dGZQC+/YNhDL7tTjyqi8t4e8W7l2TKlr0fqcyfsvtuoEXzuk0rY08LSON4YfIThCg9T71JrCjY4/e2R9nZsbA3c9BHl6wAjyg7FqOb0UJTWC0iEUnUhLqg5tqLTsb369//cHo4nFETDNduCGcqjEYD4qkFl/WA/PB7HnUp5/+nniB2tWk3v06oJREjqr6u6Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Hr+XhMGHg24cPtft9vD5nh+hyPau/SWcWbybsQJf/g=;
 b=nM1VU0eOjs1k2tF8dva6ilJU3LhBbi+SaV0UmGfXH0JnCxcHo7dyXqHoBE/KvmUvWMf5upZKdrMIFTYxru50UrG/8Qldz1uF9KjA5MDALc3mWScRh63RgSo7Zr7jduQFipCLX7s6xpJ+hepTFAibn9TtobsSIgVNe2HYkRd0PhWU6KV4G4JqXqf70y6Ya6ic9D9wLjAYaeLtiM+5oTLDYimqA3tdPFA0wYUeFnYrsnn/mxFZCS2aqr+5WLOt4tLfalP2ZV4D3AskZEp9rifSk8ihPgyS6cy4or/J6FJri3b2EjFPHUP4XjnbVHkqRyYG+ByrQ4kyUCLEGRZorYfQWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Hr+XhMGHg24cPtft9vD5nh+hyPau/SWcWbybsQJf/g=;
 b=Wrp3hkCAtAausWaD/194vcfmUWrhjVLVH+gQCCkTtS3NSC3tQbYCay9yHH/q6auMY3+r8K6R01AomhL+J7D5vILtRHCD3vY4IegU/grkA/jMvLvGUls8tmYLVIoDzbKphXKOrPUMYfW4UXh5cXzoGeJePE8by5bMm3tch4sRgVfipWXUi1+J+FWEOhtPXuEXXykOc7HT3oKnfFzRiY9tZZT+S9MktBHMddoYfrpnTtUAzN7xxjE42aUKiLLz1vDV/ZkW16b2EcOPDh7+6GSK96QjHpTAKtcaxx8NVUQGiav61AnGQBqRfuWSQa/IDe8i0PWhm/2q11i6XGFQHHZMaQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by IA1PR12MB8537.namprd12.prod.outlook.com (2603:10b6:208:453::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.41; Thu, 29 Feb
 2024 14:22:16 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.037; Thu, 29 Feb 2024
 14:22:16 +0000
Date: Thu, 29 Feb 2024 10:22:15 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Xin Zeng <xin.zeng@intel.com>, herbert@gondor.apana.org.au,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, qat-linux@intel.com,
	Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240229142215.GG9179@nvidia.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
 <20240221155008.960369-11-xin.zeng@intel.com>
 <20240226115556.3f494157.alex.williamson@redhat.com>
 <20240226191220.GM13330@nvidia.com>
 <20240226124107.4317b3c3.alex.williamson@redhat.com>
 <20240226194952.GO13330@nvidia.com>
 <20240226152458.2b8a0f83.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226152458.2b8a0f83.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR14CA0001.namprd14.prod.outlook.com
 (2603:10b6:208:23e::6) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|IA1PR12MB8537:EE_
X-MS-Office365-Filtering-Correlation-Id: ac03497b-195b-4f8b-afe5-08dc3931d4ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UjCYSYhGvfVdU5DMluMHYSjcAG8k9XUJxSFqQZt42Uq0largT2+RAG5g0b4kAhNlobg2wdJLEw6wGLhQBMdeT7gDT8UDQURUM2/2DpXffuyMqeAYABulj7HXqAIwthixK9/udvOSvukHSiddKbf8v62IPTu6bKxgG+xoeOJmXOx36D7N1l+Qp7Vw7KOLHYtB7R0Bqlu+rqFODaLdpR2H6yTcD90wQ/xdulvjs4H/Hgwihb6qnJCkJLu20ZZ2Di+S7aZzUo38fDi786lswp7nnElUdr0Df56QawGWSrz/Ew3po58adVZtotDDUBniBC964Vub7JKd3yGY/HzuBGO7vZbm4CunoYYKsCMJx2Ha5UZPb9R6/tI+bSpfC3uVJzCsmfTUn/kiE9FatWMkKiH8yq/jnpXdwstSMtGWBuRgnMYtTkgA4ovdNQUSwpYH+3F4HZOwuL40GxArLkoE2GukpjjE5W+1PHEw8Dax5z7BwZ4xoaJHYlwrsGrKgwDxQlrufO0Sv8aCmwUe9kM88eicP/ZQyNPGtRKPrON7Q+3at5deFjef+uXmX7gBeyxQSNoMQTGCFD04YbB20fLpGaHeQT+EDZkkSrWvjGI5bTmqk/5UdFqoYr2NvyjP/xfk6lX+LOkGhXgRHKpIahUkoBNmEQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uY3rBBbXE618x+1s+0SlgPJd8cZXxrzWVZi7FMxXBwVuu9w/5hRnzapoSqjh?=
 =?us-ascii?Q?2+vl++u5GngR0KInZffAxQ33FibAWky8l5SLN0H9aqAkQW+TbC3OuoYu8zi8?=
 =?us-ascii?Q?3iMeNaHBzjlQr1/IOCNGlbriAOuy71Mtvb0jQvPz+PbhB+05JXYa9l5wzsy8?=
 =?us-ascii?Q?i9tgsd3iN7pgg9zRoTWFkQn6xYkXg3V2K3cAjNwlbFbmIo+BY+Alu5Rg44Vt?=
 =?us-ascii?Q?ZkcGIqsyC8e7QBPS6qf876bnSmN/Q33f3BxTaroQg7LT97GPh4EyLOJgVYxx?=
 =?us-ascii?Q?w+82Sp1gaFzLUB9ySlMC8GkRAr18YaOSa6Ga1FwXIXWGdWiUPJa9b3siEdZK?=
 =?us-ascii?Q?FwOROKdvLmAqbdyQ51XyZg3L73SYNz2+ArKLTZJuyM35jPjTd1jzudNGDiEb?=
 =?us-ascii?Q?V5+BmTErHieLRylmFiGc5C8ntcB21rxRfD7efPbPKK+UAxfkWV5C4qxciQIf?=
 =?us-ascii?Q?DzKqjqWJOPGrKMOuqWeg0SJvZ1HYaLZCdzL/eOCYM7TCRSpPr8TBaum+FBBi?=
 =?us-ascii?Q?utxQS9+S5/5aKtAg/TCEap78HcL4+mGIc+F1I3y0BVikpl/zWPF7fBC61D/p?=
 =?us-ascii?Q?wdAOPurZVeqDv+Fle2UgfCkhYRNd3CmIVXctyVYhEMONTW+SGTv7FA90j54j?=
 =?us-ascii?Q?Ywenk5WLV7TN3q7i2ceAzkmlp5F0HBwuYPHYqlzR9c7npNm0pGcfoyDQJuQw?=
 =?us-ascii?Q?bAPC7dbd+XrKzjWSjNRqcv9uJGdPcuG33wX2j6pQYU+4asuoXtbEwb0rXZq9?=
 =?us-ascii?Q?z3Lk7pBHwJobQKHoAsudaw0qzsv3vFxZ8wqDIseRR1pKLj7T5eRwPX4NxpOp?=
 =?us-ascii?Q?yy4y5hah/WVTJhhtpw40WpmBe6Dwal/tNuege3/fbjH4t6JINRlZEZ3CV9wE?=
 =?us-ascii?Q?bsN9XmLTBZpDc3XwkPcibzq8Lfi31psXQEwNMkKsRqsr2wtL8cHJzuWm4Axb?=
 =?us-ascii?Q?BEdeHmGm5JD38ZpHCYQvK1TUmzDpku/EnhBC/3njWxC3acCnllFL2NbECQ1i?=
 =?us-ascii?Q?OEJGOEFyR/fonIU2xhWm2VgIyaSFQjb8IHh91G8f7XOAMdx3LQFn4LFs8BOp?=
 =?us-ascii?Q?6Ty+HkoLMnC45MbSl3yGL6vfUU8CYjcdIQgqQ1g9hHHwRcMHjz08O29Miu6N?=
 =?us-ascii?Q?lsYhVNQSE1d6u1Xiq+MhIUoknj5mmJetp2um+/r6haoZJ7SeIs8D/QxcIzDx?=
 =?us-ascii?Q?HxILdLSkOrKsmSVx9nUnxEiKbqpww5Wal1pYbjvvTGtNVIe6a1eRSXw9BcgV?=
 =?us-ascii?Q?8tcZyyK3n2ReQWBWd7+V3d7je0DIHnJRFqXHJfmcHGxZb03lebl/hWF4VYOP?=
 =?us-ascii?Q?anzW+zXm6JYOL/Hfx4xgRBIcOaUO1VWDd0gYlyXa+AkdOQdyFbQZQUdxLur+?=
 =?us-ascii?Q?G+9hmQi6DP1/qVB/rpQZZiANn6bE4go8T8Ww/9SWFfI9v/e2uZCGA9FPtGnJ?=
 =?us-ascii?Q?yC1B3oq9CclWnC8TrBC0/loEQraVzPEszC/1QCsxXD0vsktHmDrrsm8LVisy?=
 =?us-ascii?Q?OK++n9UQ0P+kxZ5T9Q46WS1Fq4tUUS1MtGdLrisytA+KJMj6S2JrYqOh8Kkh?=
 =?us-ascii?Q?2e25sanbKK3NyaDZEXa7GI8C58fcp1osfuvznK/m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac03497b-195b-4f8b-afe5-08dc3931d4ab
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Feb 2024 14:22:16.5037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1/IAgPE2tZ2dOsBfgXlL8zvUeKRQszy8daXlYcknQrh9aYYVobtviOKW4maS6uEY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8537

On Mon, Feb 26, 2024 at 03:24:58PM -0700, Alex Williamson wrote:
> On Mon, 26 Feb 2024 15:49:52 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Feb 26, 2024 at 12:41:07PM -0700, Alex Williamson wrote:
> > > On Mon, 26 Feb 2024 15:12:20 -0400
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > On Mon, Feb 26, 2024 at 11:55:56AM -0700, Alex Williamson wrote:  
> > > > > This will be the first intel vfio-pci variant driver, I don't think we
> > > > > need an intel sub-directory just yet.
> > > > > 
> > > > > Tangentially, I think an issue we're running into with
> > > > > PCI_DRIVER_OVERRIDE_DEVICE_VFIO is that we require driver_override to
> > > > > bind the device and therefore the id_table becomes little more than a
> > > > > suggestion.  Our QE is already asking, for example, if they should use
> > > > > mlx5-vfio-pci for all mlx5 compatible devices.    
> > > > 
> > > > They don't have to, but it works fine, there is no reason not to.  
> > > 
> > > But there's also no reason to.  None of the metadata exposed by the
> > > driver suggests it should be a general purpose vfio-pci stand-in.  
> > 
> > I think the intent was to bind it to all the devices in its ID table
> > automatically for VFIO use and it should always be OK to do that. Not
> > doing so is a micro optimization.
> 
> Automatic in what sense?  We use PCI_DRIVER_OVERRIDE_DEVICE_VFIO to set
> the id_table entry to override_only, so any binding requires the user
> to specify a driver_override.  Nothing automatically performs that
> driver_override except the recent support in libvirt for "managed"
> devices.

I mean in the sense the user would run some command it would find the
right driver..
 
> Effectively override_only negates the id_table to little more than a
> suggestion to userspace of how the driver should be used.

We once talked about having a "flavor" sysfs in the driver core where
instead of using driver_override you'd switch flavours to vfio and
then it would use the driver binding logic to get the right driver. I
forget why we abandoned that direction..

> > checks that ID table.. If we lack a usable tool for that then it that
> > is the problemm.
> 
> These are the sort of questions I'm currently fielding and yes, we
> don't really have any tools to make this automatic outside of the
> recent libvirt support.

I see. Having people do this manually was not my vision at a least.

> > > libvirt recently implemented support for managed="yes" with variant
> > > drivers where it will find the best "vfio_pci" driver for a device
> > > using an algorithm like Max suggested, but in practice it's not clear
> > > how useful that will be considering devices likes CX7 require
> > > configuration before binding to the variant driver.  libvirt has no
> > > hooks to specify or perform configuration at that point.  
> > 
> > I don't think this is fully accurate (or at least not what was
> > intended), the VFIO device can be configured any time up until the VM
> > mlx5 driver reaches the device startup.
> > 
> > Is something preventing this? Did we accidentally cache the migratable
> > flag in vfio or something??
> 
> I don't think so, I think this was just the policy we had decided
> relative to profiling VFs when they're created rather than providing a
> means to do it though a common vfio variant driver interface[1].

I didn't quite mean it so literally though, I imagined we could bind
the driver in VFIO, profile the VF, then open the VFIO cdev.

> Nothing necessarily prevents libvirt from configuring devices after
> binding to a vfio-pci variant driver, but per the noted thread the
> upstream policy is to have the device configured prior to giving it to
> vfio and any configuration mechanisms are specific to the device and
> variant driver, therefore what more is libvirt to do?

I admit I don't have a clear sense what the plan here is on the
userspace side. Somehow this all has to be threaded together and a
real environment needs a step to profile and provision these complex
VFIO devices.

For k8s I think we are doing this with the operator plugins. I don't
know of a plan for "raw" libvirt..

> OTOH, libvirt is more targeted and while it will work automatically for
> a "managed" device specified via domain xml, it's also available as a
> utility through virsh, ex:
> 
>  # virsh nodedev-detach pci_0000_01_10_0
> 
> Which should trigger the code to bind to vfio-pci or the best variant
> driver.

Maybe we just need to more clearly document this?

> Relative to variant driver probe() re-checking the id_table, I know we
> generally don't try to set policy in the kernel and this sort of
> behavior has been around for a long, long time with new_id, but the
> barrier to entry has been substantially lowered with things like
> driverctl that I'd still entertain the idea.  Thanks,

I'm not adverse to it, but maybe we should try to push the userspace
forward some more before putting kernel protections in?

Jason

