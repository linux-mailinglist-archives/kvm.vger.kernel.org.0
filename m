Return-Path: <kvm+bounces-8552-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D2A8513E1
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 13:57:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BD20281605
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 12:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AA5A3A1C1;
	Mon, 12 Feb 2024 12:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FErQBZyp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A113A1A3;
	Mon, 12 Feb 2024 12:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707742620; cv=fail; b=fDb59uBVdSRFaP/YBoknJAgTjtZ4OHwYMH31SNvZemjiYvSs+97GEdE0DpdosoaqkkPWIdyoh7VKkFCevXOplrREVbKMeCjBMKo1mtvta8fwQj8bmUGDX5lC/dAKFTFcOxjBHVj07VHsFLjfpFlB6BmiTHRsjVK34ezJHqD4ijY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707742620; c=relaxed/simple;
	bh=Mrsivu7FQJj8aBbg2cK17ndUBiJBSOEEsy+lOeH8yzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=caC9TfdSjKodN8VHMwzhpmD4DZpxj63yUu5wXNFxiSAK5LQyKPzmvlpdx1+Am1jHOVFeq3YaCb6+ZHz7CDGXvgkyuYq13TUp+h0EzJDHrPGbiOK34sdYLIcZeoR48kIkazr00Pubq+ai+FQfROBPFr63h8So5ncIk3ashVc/tWQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FErQBZyp; arc=fail smtp.client-ip=40.107.94.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ku+mC8wcQkz9y3hQXm362lSdw+PZkZsIE3f4jT40W2iWAEgDN3uvb7PVV2JGye/c0JRAKUYDFD7D4NzKFNbdrZUww0Re9Nifyfcq3g+Ip1X/ugCWrTAsZlz0qgTEr0CNe1l8t+DURe43rRstSR9aQm2zNZKjQXReVsn2b97voif0ySOyQqo1IDuJLFJvXf8w4uvmPR2Bticv/xdwgqZ7sVA4kQxQA1mqVAffAvAIw/DjdnHIkiufwjlmnaGccv1Euchm6aEhjNnH7sfEVjjAINwxGJgoRNwtDWxuAzMCCHqFEqqazIbQDAp8637D3fAa9B32LX4MK4C2yI8Si1Xj/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2ijP5D0AyjOPwbgv1vcIC8eaaBxrX9ITY0hxjITpYI=;
 b=C7AJIif1jBSKSfqrFWsHqc84pz6mEdKFmLJ6X7TaQGlIwn+S+qYI1AVODtv73pHBYMRT4NmabGryHyyHtqoHBLm5ehQXEDKpahhu+x15NUHurUHYiqi0U+HWnM9ovxVxkbuQLPMIciFTGWePeRZce4pgEk0dQpEs7jkeyeCFBFF+rbCXYG5H0pNgDGujacTzKVpP2me3dcXezEUeI9pmPHuwrVLrEtJB/9sFhpWr6UQ75n5DBZIEpJDEoNOAcRiTsNHlHEsJ9VbY1IturldVS+bExBc/UwBmXQGgvQiqZZmCBMoc6cH6r5Kvy/NjrDR1s1jmFnuL4P9yoT2xxI2QRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2ijP5D0AyjOPwbgv1vcIC8eaaBxrX9ITY0hxjITpYI=;
 b=FErQBZypBO1B1fbdZnMhOHXKug/mqUzGbmisMWQtPXxLr/Lh+8zS3ygqjImOv5mgasGMHpNKQt+gtB5H8ihhV5udf5gpbPMHuSPgaKAx6hjf5YRrQyktTmXPpJXee2L6GdOwvtJtHmrzqtz/X61N3D6e4itnwOR8CR/CGAcRCgUWsh+9F0ruDhYSWpxDyoGAmh5HI+AxV6/ZKfeX6d45JP4Dx1J30eBlgEEGFwOx2XAHjPrUfR05VPTX1h75A78zCgZuaT23ZVTqPXFlmnmNs6PhDWj+WGA2C2DF0elpsBEY0E4z8yZfEZiHM0T27ATe/Li3+sR2KixNtLquu4gNjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BY5PR12MB4130.namprd12.prod.outlook.com (2603:10b6:a03:20b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Mon, 12 Feb
 2024 12:56:55 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Mon, 12 Feb 2024
 12:56:55 +0000
Date: Mon, 12 Feb 2024 08:56:54 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, alex.williamson@redhat.com,
	kevin.tian@intel.com, yi.l.liu@intel.com, ardb@kernel.org,
	akpm@linux-foundation.org, andreyknvl@gmail.com,
	wangjinchao@xfusion.com, gshan@redhat.com, shahuang@redhat.com,
	ricarkol@google.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, linus.walleij@linaro.org,
	bhe@redhat.com, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, kvmarm@lists.linux.dev, mochs@nvidia.com,
	zhiw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 0/4] kvm: arm64: allow the VM to select DEVICE_* and
 NORMAL_NC for IO memory
Message-ID: <20240212125654.GV10476@nvidia.com>
References: <20240211174705.31992-1-ankita@nvidia.com>
 <aa6c1708-d6ac-46f7-b7ab-e97a273a90c2@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa6c1708-d6ac-46f7-b7ab-e97a273a90c2@redhat.com>
X-ClientProxiedBy: SA0PR11CA0015.namprd11.prod.outlook.com
 (2603:10b6:806:d3::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BY5PR12MB4130:EE_
X-MS-Office365-Filtering-Correlation-Id: cd83e47a-3382-4c8a-16f6-08dc2bca172d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	f0QjHpjT9U1mXtZwMyxuIUtuR1EAU0tX5eUCWWkHF3KsUFUPu6ygQ6+Fngag02MriL5sUp1qErZUtAKybD90rPYX+NZamt2366ZXsiSURJoYT9v9FItUQvECv75cGsjChQkiR//lD8AlJcgD4fn4091PoClcZeswCjO3othjmvax/yo4gZwWn6wEToskTu0PJvyJt+S5SajiqQ6HVptKHbLK3Y2QCR7Y6AkLqAFfdbOsTkp5JWtg2i5WMJMT/gb7M8wuekqHnVFdxWesytfQVsTOmQFFMwCmp+/PvbV9eXDCHkA7eq98OAy7zAygdu1jK7TJO+IBaBefRGKTzCO5ndGKhMkdzwi316lEUqRiX+aJ1ThkAbUS+CqSbuqRdJbdAuc1IJuvYCdTTirO2Z1z0aJLnaReStOAy2biyEPAF7YB5A5J8EVL98ogAw2X2FNpN1hx1QVvG9gn99JTQxsclqepWFo2bzj7+XgSZZfrF0ky+HNBjO8i9YOgRP/XMy0X4AukZ0s6PzMY/AALYMpeysm9djaJnW8qxv6wIlHxlXIfyk807ZHo6GuZYF3bH+nC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(136003)(366004)(39850400004)(346002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(41300700001)(7406005)(7416002)(38100700002)(2616005)(4326008)(8676002)(8936002)(2906002)(316002)(5660300002)(36756003)(66556008)(66476007)(66946007)(6916009)(86362001)(1076003)(6512007)(26005)(83380400001)(6506007)(6486002)(478600001)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?odOmyOy23e1tjrwZ2xm+gGvs92RBUT0wN2UYi/NaEctZjo8o1tMrimPR/4/q?=
 =?us-ascii?Q?nFpEy6nmpFgyFOkTlT/yHcyOO9h+nu2Cet4aXlo9gmTQdCpYyaRc7/pt4VOk?=
 =?us-ascii?Q?HwIqOPdUdh8R/AKVrppgEzNckOm7Ou6Z+zreakErgtElCiYxEgh8qO/jEG9G?=
 =?us-ascii?Q?36cbetHovWDw+dwQB49LZ9hN0n7qS6hQri6M9bqSFcsujeRqFydEe41ps1WB?=
 =?us-ascii?Q?0TNbBzKNfQKJDMtMCoSv64+v/pEPQ/M/AsG+Ja0c4Yr4PCMreuVRuhmiLJXo?=
 =?us-ascii?Q?vT7TXb0vl6ME8UxDpSUQXkELib9CSf7yQjpVBco+IOFUUAZ1ZPmmd7jGzEvO?=
 =?us-ascii?Q?Myvmmwn2+QD7M55qZOvm2fHeB96qsosUfPe8nY4PTkggEJ82sboz3lR6bnMW?=
 =?us-ascii?Q?a+nJztkrvIoZAVTKAcFJSVNb8DMVXTOy+L6SBAUsEevAj42BdMzeDwqyEdE+?=
 =?us-ascii?Q?NGwOv5Ql1srJs9NkWo7ypnTdHlaOY5r9yScZRgzmHLsDbKKfUUIw93d6+cHB?=
 =?us-ascii?Q?i0L17+2yh5fUKN+E4loOhO4NZyeT/8dBuBwuBHvIRpn4WRhk/hLmV+j1BV3u?=
 =?us-ascii?Q?QEiYMFFrornTYciJNiJTDvCuAq9hXTpfeRdg7XbweljQXUYHdd5TypSImuoY?=
 =?us-ascii?Q?gyF8K+gsNl8h6God0OD5sRZ73D7UuFATV939Gt5rPCFzadxmr+LW8I3QJEfu?=
 =?us-ascii?Q?GrreaggReyoF+FqFQ5AFsnexfD02KwFzlMDFsoBP59b14rTGphvyNPzo8yv5?=
 =?us-ascii?Q?lDvTIDTGcRWqdA7qBQKsLWC1tAvd1YG8ej91m1eZxROAAqN3B+jFKOjmtlhv?=
 =?us-ascii?Q?X3oFW2TNRNlQMHKFwnxS6GydwcpK42LcMOQzYrQ5LfKUPFkoxbsSNjDHv6mz?=
 =?us-ascii?Q?r4bHl225ZSy/Jk43bdrOIzFke/LqLYpVY8bzzXWMEDQjkOOAY/V2rrxQ1OuJ?=
 =?us-ascii?Q?HeGtoWVoviiupJQihqaThzfwtJc5qUSJEZ0afnIMM0u7ZdYuFACJB9Z2bFSx?=
 =?us-ascii?Q?0fCg1ufJ7F28sCRGyWP4oN1HovG8PuA7Jr++gQ/z3jQPpZx9zexBauMtnjTl?=
 =?us-ascii?Q?zKRnxr8MoXsUsO3DmaxOhJzb4/FjZmGRVpl9J6TyvjnfsLpUrIjCtHvcD4sB?=
 =?us-ascii?Q?w7DX+kHrEq+17CwZ9SYpdG9hIH9nVgcTAteFDq3pA+dXM6WO48hy+/hEUDS5?=
 =?us-ascii?Q?kvJzngcrcacb637XhdiewVi61wbalPY5dDjy1KHOpAbn/a21xlGbHO5WNQ1p?=
 =?us-ascii?Q?z0BqVy/327gMBL0nABEQnbhXRZyCZyoHvtq4sZbADwF5OU9+a01870BMFVNd?=
 =?us-ascii?Q?QuYFZ7WcPR9B6R1cFz5ARDnzzgg+A10hi/cpEIYjIZ7z7spWcowNY8D2qtSp?=
 =?us-ascii?Q?SAQnycMqr8Wnsr/cTk7/9BvjBoWmjzJorpuDHQwAnA6XJm4muwdRyF8C5N0x?=
 =?us-ascii?Q?lOfqfApuQT68/QKtjoBWuGcpbZOQNrheIeBlehQIC9EcL74vZy8IZi66ajvr?=
 =?us-ascii?Q?LFaamJ1JRxFse5go0gBnz3WqMUHfpRxRNdYEQCOrWGvaocKk86hIq7BUwwui?=
 =?us-ascii?Q?ZGZdZOQB1g4IaLqh9ds=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd83e47a-3382-4c8a-16f6-08dc2bca172d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2024 12:56:55.3473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RafhKT3ea9ocRpN/10DodrXtkhnKxd4j5Kkfe6FChRCj1zA0PN2pHwtnpy1U/ddS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4130

On Mon, Feb 12, 2024 at 11:26:12AM +0100, David Hildenbrand wrote:

> I still have to digest some of the stuff I learned about this issue, please
> bear with me :)
> 
> (1) PCI BARs might contain mixtures of RAM and MMIO, the exact
> locations/semantics within a BAR are only really known to the actual device
> driver.

Nit: Not RAM and MMIO but different kinds of MMIO that have different
access patterns. The conclusion is correct.

> We must not unconditionally map PFNs "the wrong way", because it can have
> undesired side effects. Side effects might include read-speculation, that
> can be very problematic with MMIO regions.

It is worse that some hand wavey "side effect". If you map memory with
NORMAL_NC (ie for write combining) then writel() doesn't work
correctly at all.

The memory must be mapped according to which kernel APIs the actual
driver in the VM will use. writel() vs __iowrite64_copy().

> We can trigger both cases right now inside VMs, where we want the device
> driver to actually make the decision.

Yes
 
> (2) For a VM, that device driver lives inside the VM, for DPDK and friends,
> it lives in user space. They have this information.

Yes
 
> We only focus here on optimizing (fixing?) the mapping for VMs, DPDK is out
> of the picture.

DPDK will be solved through some VFIO ioctl, we know how to do it,
just nobody has cared enough to do it.

> So we want to allow the VM to achieve a WC/NC mapping by using a
> relaxed (NC) mapping in stage-1. Whatever is set in stage-2 wins.

Yes
 
> 
> (3) vfio knows whether using WC (and NC?) could be problematic, and must
> forbid it, if that is the case. There are cases where we could otherwise
> cause harm (bring down the host?). We must keep mapping the memory as
> DEVICE_nGnRE when in doubt.

Yes, there is an unspecific fear that on ARM platforms using NORMAL_NC
in the wrong way can trigger a catastrophic error and kill the
host. There is no way to know if the platform has this bug, so the
agreement was to be conservative and only allow it for vfio-pci, based
on some specific details of how PCI has to be implemented and ARM
guidance on PCI integration..

> Now, what the new mmap() flag does is tell the world "using the wrong
> mapping type cannot bring down the host", and KVM uses that to use a
> different mapping type (NC) in stage-1 as setup by vfio in the user space
> page tables.

The inverse meaning, we assume VMAs with the flag can bring down the
host, but yes.

> I was trying to find ways of avoiding a mmap() flag and was hoping that we
> could just use a PTE bit that does not have semantics in VM_PFNMAP mappings.
> Unfortunately, arm64 does not support uffd-wp, which I had in mind, so it's
> not that easy.

Seems like a waste of a valuable PTE bit to me.

> Further, I was wondering if there would be a way to let DPDK similarly
> benefit, because it looks like we are happily ignoring that (I was told they
> apply some hacks to work around that).

dpdk doesn't need the VMA bit, we know how to solve it with vfio
ioctls, it is very straightforward. dpdk just does a ioctl & mmap and
VFIO will create a vma with pgprote_writecombine(). Completely
trivial, the only nasty bit is fitting this into the VFIO uAPI.

> (a) User space tells VFIO which parts of a BAR it would like to have mapped
> differently. For QEMU, this would mean, requesting a NC mapping for the
> whole BAR. For DPDK, it could mean requesting different types for parts of a
> BAR.

We don't want to have have the memory mapped as NC in qemu. As I said
above if it is mapped NC then writel() doesn't work. We can't have
conflicting mappings that go toward NC when the right answer is
DEVICE. 

writel() on NC will malfunction.

__iowrite64_copy() on DEVICE will be functionally correct but slower.

The S2 mapping that KVM creates is special because it doesn't actually
map it once the VM kernel gets started. The VM kernel always supplies
a S1 table that sets the correct type.

So if qemu has DEVICE, the S2 has NC and the VM's S1 has DEVICE then
the mapping is realiably made to be DEVICE. The hidden S2 doesn't
cause a problem.

> That would mean, that we would map NC already in QEMU. I wonder if that
> could be a problem with read speculation, even if QEMU never really accesses
> that mmap'ed region.

Also correct.

Further, qemu may need to do emulation for MMIO in various cases and
the qemu logic for this requires a DEVICE mapping or the emulation
will malfunction.

Using NC in qemu is off the table.

Jason

