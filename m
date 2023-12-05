Return-Path: <kvm+bounces-3627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10A86805EC9
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 20:48:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41B0C1C210D8
	for <lists+kvm@lfdr.de>; Tue,  5 Dec 2023 19:48:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C05D6ABB1;
	Tue,  5 Dec 2023 19:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jnU7G708"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F094C9;
	Tue,  5 Dec 2023 11:48:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tu2IeOcBl1ypZQtugdhRgb/iSZGtZiQGq8F6nu+25x/xns5fDE9iKgZaYNIQY/Q2EBZeF0wBW7leBzC9BgZg8PuzS5TpwSVrQz5jrtSMTDUOqZJI59GEu1bEniGH9eL0l7f9SXjyPXJ82p1M1/lJVp6X2kEWhZtmYf0youSKDCVdiSEtN5jQ+NWqFsPdxFvz0c1OrLRjT8Jz3i4t1V8uYmNqz6tcIKSy0kKTOaI/4/aPUSOn3iT8q5mZCJvi86d00fP34K2VOtbCH0U8isGUhySh8vZcuSEpPIQHU1tGO44bIsTMOhg3ggqC0TYZ+cg2zPIRcic0oBPc8q5q//kC7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eMJNRWsUWCIQVN+pKHpiDUl//w9nIrE+/GaOPb4GCjk=;
 b=mzOzWUSfljXDS2kPqUqIk+qLs3qyvEx+FBxCrXfOsxEYjyvylt9DbQMqY01/ELJad2DqwbN4D+nUv9OItf+mXyp74cSG4E6CzJ0CleO2zHZ5Z5FvO1bfE3OlwDI7/lKNPQVVuZPc5bnuSfrIvU2nEFFarcWXyHlRPxZcffZA56tXThPmRYkMc1AXwIRAUhTgSVCksWGtPJARAQsrJaJ+JhdNdnCQ3+jY8ck7rJ8Yi2ZqZmO+9tQpc0hIxmnPX+88nUFgnF5xDQmkwrJj/rFuThh7EuU9aXZodo3Niq9WX+25e1HEydY65iRWB4cAkbZkagmd1ij7nZ/Bw/vYsQEaSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eMJNRWsUWCIQVN+pKHpiDUl//w9nIrE+/GaOPb4GCjk=;
 b=jnU7G708Iv/lxuEwVvQmXhvnQzmst0wwH6D3fiCe19Vr/DvK1/KqZSuEUahWLo56mhYp1WB4I/IzdPBxvorQ2pY4PxTnWXW1cPqsoE/0PQPZEyw2OthswD3ZcCxXWIS+RAYeydndBnid0VBWXlmI9+ebzbaRoCjgxIr/Jrr8+0sILZ+lgCwMuw+TN5b4nRWKhQlbpYqonkj7zXGGyB/oMb0hcHupQ/Rge0g8twHwY6I5aGm9DnJdKCWp5l3TzojvFdYsm5U1xpcUov7WqYSirQWn6Pfv1JBNSBA8499pjsA/iJpzAMvdvJwSA0q30ojGVqOo207mEl6NwpvbaEesXw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5779.namprd12.prod.outlook.com (2603:10b6:208:392::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:48:23 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:48:23 +0000
Date: Tue, 5 Dec 2023 15:48:22 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <maz@kernel.org>, ankita@nvidia.com,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	oliver.upton@linux.dev, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, will@kernel.org, ardb@kernel.org,
	akpm@linux-foundation.org, gshan@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, lpieralisi@kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/1] KVM: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20231205194822.GL2692119@nvidia.com>
References: <20231205033015.10044-1-ankita@nvidia.com>
 <86fs0hatt3.wl-maz@kernel.org>
 <ZW8MP2tDt4_9ROBz@arm.com>
 <20231205130517.GD2692119@nvidia.com>
 <ZW9OSe8Z9gAmM7My@arm.com>
 <20231205164318.GG2692119@nvidia.com>
 <ZW949Tl3VmQfPk0L@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW949Tl3VmQfPk0L@arm.com>
X-ClientProxiedBy: MN2PR08CA0022.namprd08.prod.outlook.com
 (2603:10b6:208:239::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5779:EE_
X-MS-Office365-Filtering-Correlation-Id: 39a6521c-a71a-4a11-5fd5-08dbf5cb23a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uO1VLXyY9LveQ9yiitrlaxHgJZ6qY1I5A0roaL/E4j/yjVHSt4KAjIOX4XTB8DAH8A7bkdgSrerMqoYOjVu14/QbRd7Wr8JfXSviRcn+xcffyO8jEjA1TCSBqB6bMyfkBRj/p53eAJEvWsiOxovT3TdWGvfAUj0g3Rx2+6UWpDmkX4hdBzlCro4Txa/Iullhp0wk4cQn0A56nzDEdGidj7wcE9D1x0iV0khkjL+R6FHlvhL0jRrpHGxONOnM9eZt58w2aH9b6603KAfcIjQoR3G0BZQi9I2sgqTPi99kW3apS6Y0RxvOeHw8Ceu41SeBU9shYXH3DERGVEz9qCtj2VaMviwrovkBh16iEGTvIASdTkdaTjQEHZz3HgMsQCN38U935UdZLujd3hDWjWZ6CbRZYoqJuJVAwZPcXNXyT0QSSfVRYm9xqqWbySg3F+OTudyxeVM3ufUg60ESqlLOGdFnU00zVSFM/Y5iUsyBsT/jhmJsgxcpczvEBdXI4ah90Tsh9UJmNKWHeDnnQ8fxSIKulBN+HW0HIdw2mgEQNbhe30ht04paxcJqoCJArIOX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(396003)(39860400002)(346002)(136003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(6486002)(83380400001)(478600001)(6512007)(2616005)(6506007)(26005)(1076003)(316002)(66476007)(54906003)(6916009)(66556008)(66946007)(86362001)(8936002)(36756003)(41300700001)(4326008)(8676002)(7416002)(33656002)(2906002)(5660300002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lKa6v73Zw8jv66PsdfFRlMglbHrXfNIKk5c4NdbfC/yaqVFz1OhIemsu+WaE?=
 =?us-ascii?Q?AWlLWGoLKPzKmRVCOxBZ1LiprAW+o7AAXiexNCd4NsSAidG64rjyW9dPRldr?=
 =?us-ascii?Q?ZX32wUjbkAKYHTtEJOvWDzn38x5tBAoO9ZvbQ1S6ykDOp0FvgBEPcJDho/0P?=
 =?us-ascii?Q?HqSs7oEvzvgRoe2vQr3y5rr8lO39IYxiMMf0jhH6+eu98JQCFvE97tDAoUHv?=
 =?us-ascii?Q?9Ep1NlBpGg7tYiGK5dO0gxR6bluwgagFmf7qEBhroZnApZ9/BDN09HAHQZ8/?=
 =?us-ascii?Q?beHPKcC6juyOtQt0bMFoSR+09ESiBRZE3jzkIfEfst1J6X8A4XMnj/yDyOUo?=
 =?us-ascii?Q?IBcXxYzjKwboAFJC1CtcnoEOj6t6YFPkKylAzckJA7VG7S9nrTsoA/Th/QfV?=
 =?us-ascii?Q?JiPm/Czms3mcXS0MRBC3vflapvlkquO62OZqWUAB6MRdE4g5EjgwAwXqPHT8?=
 =?us-ascii?Q?r/E/hG3xgeWanJ6MbLFa5ngQ76WEISGTCNNQCty8GOmiySIP5usreTNMZ9n1?=
 =?us-ascii?Q?NPVH2xW5gawjdDr5FFC+EDeAS3nyt85jTdDjUhAZukZu1hOF4Lv2kQiigucR?=
 =?us-ascii?Q?RM2MpSxKCRMsUbcjGtEZXW1ZJiKSF2ngPov0G3upGcYO5sigbSYFiE378yKK?=
 =?us-ascii?Q?c4/DOUQdXVoRjIQDKmtdw/2HZAYHU23RyPGId/dTNtfzir+BBYJHr33bnb4B?=
 =?us-ascii?Q?kyH3QwTzndH1E/iEXAe245PG4CjiQJ/rvXSLRwrFZC7CEasKsb/SpTGIluE1?=
 =?us-ascii?Q?EOcvR5TbsBVD+vIxvp99zxC0goTjxz+K8TWfYIASVczwBt4PJselp3eN7RrR?=
 =?us-ascii?Q?NVuzM7YvHDrQLrqL+SfSILEQL/eHWznPULYgEQws7Z+Ejc0TB7GVtNqiRqPT?=
 =?us-ascii?Q?LjFOoNOvFxr5Le9/AYQ5obJsjjHilN7VhDBZ36BpQ9+7wFxUGpQMMCyXzqR3?=
 =?us-ascii?Q?D/2v8dd1Rl6AD0ciG62SU0Pyz0qDUQMhhYBh9heVcNtr7sbgGIijm7Xul1Uk?=
 =?us-ascii?Q?4sGEcyJ0FP1EOwv3tvWN+WB5/9Vc7zpdh3WIongLQneJKopwglnAO20QcIVP?=
 =?us-ascii?Q?XWiIuqh4GqczJjxpKVDCcaCTyqnWd1f228L0XUzR66kEpyb7siqoo57EZrMx?=
 =?us-ascii?Q?p4MyogLCqDyqrFFEc+r+dS1SrcSL6BshDWhd4Fg99bfKo3o5VWD/dWej+tqe?=
 =?us-ascii?Q?yrG2xV2RxipOGli0pBVej04GsEaySqy57fVYn2UxHfemf0hqoJk+fszEskv9?=
 =?us-ascii?Q?UprKevKl1fwE9cvGIzUqaXXn+v4QFD+max3ZxfZnt6eKHadAqHGR8IwRo8dU?=
 =?us-ascii?Q?M18vrN/r1WtfGWWZN7kmdKOIC3zNoFjo78rptdQsSOQN1Jbb0UWAoTerDvQW?=
 =?us-ascii?Q?RAxCrdjHnKY+Xw3SaoXMztOyOsWj/gYeJ2rXnKSQMYsFa+BYRdbdRCf0/O4s?=
 =?us-ascii?Q?eeWI0n0tElxir1VK1QYuJhHjNLXls0xBigYcg1oTy+CfcA0Zyci7RYyqiYlq?=
 =?us-ascii?Q?yLrITvMiegjoOq3BkQhVroqxE9bBdG1krztvF3KAM3z3OY5GveUH3vLkXUGU?=
 =?us-ascii?Q?Cboup1MxRIRlzx0hB8BO/z0qmcvITSwc2ctfiX5J?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a6521c-a71a-4a11-5fd5-08dbf5cb23a8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:48:23.1337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qTc5DakpwSKg8B0HEYKswQbqOGlRrK1+HMzkjxVgQLUmjPj3Tc2sfHMsR3q9KYEL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5779

On Tue, Dec 05, 2023 at 07:24:37PM +0000, Catalin Marinas wrote:
> On Tue, Dec 05, 2023 at 12:43:18PM -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 05, 2023 at 04:22:33PM +0000, Catalin Marinas wrote:
> > > Yeah, I made this argument in the past. But it's a fair question to ask
> > > since the Arm world is different from x86. Just reusing an existing
> > > driver in a different context may break its expectations. Does Normal NC
> > > access complete by the time a TLBI (for Stage 2) and DSB (DVMsync) is
> > > completed? It does reach some point of serialisation with subsequent
> > > accesses to the same address but not sure how it is ordered with an
> > > access to a different location like the config space used for reset.
> > > Maybe it's not a problem at all or it is safe only for PCIe but it would
> > > be good to get to the bottom of this.
> > 
> > IMHO, the answer is you can't know architecturally. The specific
> > vfio-platform driver must do an analysis of it's specific SOC and
> > determine what exactly is required to order the reset. The primary
> > purpose of the vfio-platform drivers is to provide this reset!
> > 
> > In most cases I would expect some reads from the device to be required
> > before the reset.
> 
> I can see in the vfio_platform_common.c code that the reset is either
> handled by an ACPI _RST method or some custom function in case of DT.
> Let's consider the ACPI method for now, I assume the AML code pokes some
> device registers but we can't say much about the ordering it expects
> without knowing the details. The AML may assume that the ioaddr mapped
> as Device-nRnRE (ioremap()) in the kernel has the same attributes
> wherever else is mapped in user or guests. Note that currently the
> vfio_platform and vfio_pci drivers only allow pgprot_noncached() in
> user, so they wouldn't worry about other mismatched aliases.

AML is OS agnostic. It technically shouldn't assume the OS never used
NORMAL_NC to access the device.

By the time the AML is invoked the VMAs are all revoked and all TLBs
are flushed so I think the mismatched alias problem is gone??

> It can be argued that it's the responsibility of whoever grants device
> access to know the details. However, it would help if we give some
> guidance, any expectations broken if an alias is Normal-NC? It's easier
> to start with PCIe first until we get some concrete request for other
> types of devices.

The issue was about NORMAL_NC access prior to the TLBI continuing to
float in the interconnect and not be ordered strictly before the reset
write.

Which, IMHO, is basically arguing that DSB doesn't order these
operations on some specific SOC - which I view with some doubt.

> > The complexity is my concern, and the disruption to the ecosystem with
> > some of the ideas given.
> > 
> > If there was a trivial way to convey in the VMA that it is safe then
> > sure, no objection from me.
> 
> I suggested a new VM_* flag or some way to probe the iomem_resources for
> PCIe ranges (if they are described in there, not sure). We can invent
> other tree searching for ranges that get registers from the vfio driver,
> I don't think it's that difficult.

I do not like iomem_resource probing on principle :(

A VM_ flag would be fine, but seems wasteful.

> A more complex way is to change vfio to allow Normal mappings and KVM
> would mimic them. You were actually planning to do this for Cacheable
> anyway.

This needs qemu changes, so I very much don't like it.

Cachable is always cachable, it is different thing.
 
> > I would turn it around and ask we find a way to restrict platform
> > devices when someone comes with a platform device that wants to use
> > secure kvm and has a single well defined HW problem that is solved by
> > this work.
> 
> We end up with similar search/validation mechanism, so not sure we gain
> much.

We gain by not doing it, ever. I'm expecting nobody will ever bring it
up.

The vfio-platform drivers all look to be rather old to me, and the
manifestation is, at worst, that a hostile VM that didn't crash the
machine before does crash it now.

I have serious doubts anyone will run into an issue.

> > What if we change vfio-pci to use pgprot_device() like it already
> > really should and say the pgprot_noncached() is enforced as
> > DEVICE_nGnRnE and pgprot_device() may be DEVICE_nGnRE or NORMAL_NC?
> > Would that be acceptable?
> 
> pgprot_device() needs to stay as Device, otherwise you'd get speculative
> reads with potential side-effects.

I do not mean to change pgprot_device() I mean to detect the
difference via pgprot_device() vs pgprot_noncached(). They put a
different value in the PTE that we can sense. It is very hacky.

Jason

