Return-Path: <kvm+bounces-3754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 423A5807855
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:04:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 593081C20F33
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 19:04:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDF7B4E63D;
	Wed,  6 Dec 2023 19:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LKEvBTQD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2040.outbound.protection.outlook.com [40.107.243.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF69EE;
	Wed,  6 Dec 2023 11:04:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WWZp5Y0WSAJ9DrCk96YqlVPVWjeszC+HAULQ2fNwt2jvanfqKSoJOkYjti1Z9C1rco/N0lPt8hB2zagaGxaFaGH/wP0e5JZxTFkuWG/ILvV+yEJDyg4E/MOc3pqd33AeNUd4TrHGShCRxnrc4yNQRZ/mn8K+FTSjUQBIAnGbujm5oXKiRw08CnCroUbqSZ3aYQ7jw8EYblPiy3PSv498cop86lWWyCifs37yrM7ugK0BNGQDbZjb2UdHlWtYidnD4RSSctzuqxNvRiSpqmR/xX6tWDsVE6bPFK2kUVMfGXqLxv4Ocx6k7xyb00UM28QvRWlDt3yhMsTQdDgo8dNOSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGhAJKaPRo4idY/zZpwx7xvBENsuApJs26+9HL3NsFY=;
 b=diFuTE1it+DcZ6ZNYYXSsvEv30y+EsUqLQhvtP7frt+zVanWH/P+C+fskFm6M+xfbD7hOvEDVMEfeKAqJkzPtfyC6u0tddacHb0fSRdpCqEoWCopqGkk71lV7R+jLIclSc0FSQuw5e387zjegCuXs4y0ngCKv9Zz6EZgIPv9FYuaQAMakThIEAjQv8xfy5ghMygAGzfxd+nAKbKBs/A4KpKiQ02cqC7pOgDYnQAk96LlHFdjhug0zDJ+5xxOa8jn/sVBrd3xLy2SaVnqofux7Ef54x0Y1KnnMLEdo5+Zm4mdFehIfMr4RuzpMdi8IJZF6Dj8RKIu+12UMC7cyixRvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGhAJKaPRo4idY/zZpwx7xvBENsuApJs26+9HL3NsFY=;
 b=LKEvBTQDn22gbxEUVzeEw24gQIgks63b7DqPbEaO/ks0IcJm2Zx4fEPCtx3ILwTMc7wcaZks18fzFgbS81xjG/gK5T476S+8K6hcYyizpFIayFsn4ZYlC7kplvmCnzsNGoqtwj/zxXBJbzYZoXWxVzn49nrqV0WbTb/gFP23prxvMB/n9IQ1WuHzSzQqFEaUSogcZ5fkVfdd5H0J1QLnD1Pi0544A+IlN65ZpqkB1zLFDio7MITHPsYP0qyZG38xURkDWR2DLs3dc/mZmsx7cJ0SKDyQDbvH4+J5KtKt70Vcl6Iati4plonKzAN5OIwKujEzBvAspxYAWfpEmTOsxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV8PR12MB9335.namprd12.prod.outlook.com (2603:10b6:408:1fc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 19:04:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 19:03:57 +0000
Date: Wed, 6 Dec 2023 15:03:56 -0400
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
Message-ID: <20231206190356.GD2692119@nvidia.com>
References: <86bkb4bn2v.wl-maz@kernel.org>
 <ZW9ezSGSDIvv5MsQ@arm.com>
 <86a5qobkt8.wl-maz@kernel.org>
 <ZW9uqu7yOtyZfmvC@arm.com>
 <868r67blwo.wl-maz@kernel.org>
 <ZXBlmt88dKmZLCU9@arm.com>
 <20231206151603.GR2692119@nvidia.com>
 <ZXCh9N2xp0efHcpE@arm.com>
 <20231206172035.GU2692119@nvidia.com>
 <ZXDEZO6sS1dE_to9@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZXDEZO6sS1dE_to9@arm.com>
X-ClientProxiedBy: MN2PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:208:c0::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV8PR12MB9335:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d08d957-f149-4023-8a02-08dbf68e194b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zIiag/Az7xGkiLA5U7/Sej/u15hOVo+5O5Nss/PGkDOgfuUbUG/qdTNQ/dajBd/dF1SuvzyToIuR677+74H/Za+ivXDTGgl4ztwRMyQCchFYljTKpK2tGglIf+VKvW/POfxI9jQO1pOuiOf8vSRzMOSN+F8iskJ/5+GyXI8M6eD7QXczmTzlokQwmf0nzt5XE95P9rQy4WvzwQjckzSni2AnartHfisCbCxx0wfr457G8tmTYa8nYfnO3PikrNzdbMVFYb74aBopIuayQsgSoiXGotHHPdnYP79CUCKpqRxDtXF6TDwl6tN426qEkBY5/WVHKL5m8veovuAB5nsnYc33x2mRuHrRnWF5jrbZWOUS9eDWCgdcMRlQ9rBl3Tw+o3CyiUxmAGLYEIAS69CNJHxAcTKz3n59CmUVmTEOxoIhGRD1iPVZRv1MHjJXYpRjKOSyQP1XW08pc9XQ8441Wu51ZKMDfRGymyGAl3Dvc7lfSpClRk0rF55RIYuK1JjSP/ZnN8tamB09uSZu9qs0sbaOLd+2YC191LOjICV11YDjcbSeUSs00jk9F3Y67xnZ
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(376002)(136003)(396003)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(478600001)(1076003)(6512007)(2616005)(4326008)(8676002)(8936002)(66556008)(66946007)(66476007)(38100700002)(54906003)(6916009)(316002)(26005)(83380400001)(6506007)(6486002)(5660300002)(2906002)(7416002)(86362001)(41300700001)(36756003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?10QolA+TLjWeK+LcibziUc+KVOZj26TphedV+k2oKSFcSv6BrviLLXP1jSUB?=
 =?us-ascii?Q?XsBvvGC3IZ7z1z70yhPteuJDS+5NMCW11hTBNeDHQl8icgaegb+jPUO6njBV?=
 =?us-ascii?Q?NzUPnE1VuoqjQYm2Qul9LQP9FCvLPFBgMgwavPqt9v3McnfJ04z9XqQUxxw9?=
 =?us-ascii?Q?XneBZdzJfQb+x6jsfUZEABQPqjw6awPm7gJJGBZeSez5zBEXoj9H51FrgIkT?=
 =?us-ascii?Q?3Oxoc7pczOUfO1KiLtLzBnWW9LvV0eSMuhEH6jaxmuuegi2OTvonYogfAH0l?=
 =?us-ascii?Q?P+DczJ9Od106jPudbjSvmiQPqnbFn9ZkYYQSeBcfyjuiNcAvfSCVhgBO2uqo?=
 =?us-ascii?Q?ojUAwMo6kfiMqnOdhDnE9Ou2GagDNfBGLsvlQjHv2AHbdFtEmzQ3ozVw09rL?=
 =?us-ascii?Q?ttil+q1VTsyGW7P+sPk5XSEqo0bYqJLihMlOFiZQ1yOKU8edMDvGv86tkTkM?=
 =?us-ascii?Q?1WuLtKfLnNM4c4av4NqRsoK6tE+MGSByETrosBQU1Bc0wkS0vzE6Mn3okIpn?=
 =?us-ascii?Q?yBLMxIX0eFgYXUbaKTi0yDz9TRnDmGv7iFlfN/PTAJ3SuDxUzjYQmF3wVfgC?=
 =?us-ascii?Q?5+M2AlJxHtEJey0Zf/VeaYiN18KTYpfaYY4haS34RsFrugWepx4iz+2XvHjk?=
 =?us-ascii?Q?qxGIkfDfl4gkkUPcz2AbgOLdSykFThzm6Fnei9lJANIpwhvKs2XRPxQsNaIM?=
 =?us-ascii?Q?yLyhpaxVfxwd1EKxXl7C5FuNwwLvIsEJ9HUbuu9fZ8M6JJBAGE22mC/5myrO?=
 =?us-ascii?Q?/ZoVTmTFkvUygsZEn/ozfYDNAEUWPlvQRkPp6jtYBhaCvRWyhnbmZ4n2QNAe?=
 =?us-ascii?Q?aJAZgyiLVdfmilV1UXVyAwPKdCR4bF4UjNnhUJ/cBmw9BQ225OOtmVSv6dIf?=
 =?us-ascii?Q?JOoBhmYaHQ2mu20A7z783d0pYk7nUYvABbAB+GvxfMGs6SyTXfe49QZxbCUB?=
 =?us-ascii?Q?cfk0LQDsQDLkCg2CMXjbsyTwtutghGmII2bwRf8UfwM/BeBm/uuQUN0kOUwC?=
 =?us-ascii?Q?+/wsjWZLtBk+YV/PF90mBO6MZi4yhjWKQ8tyvPEmlT1o9NC8x1i/kajVQsZh?=
 =?us-ascii?Q?JZDixLDfC+AglDtykVf0gXMZolDc4YuIq9LSMhW4o7sfhuC1E9Xom+xtj0Ci?=
 =?us-ascii?Q?/XMd+CL2093mI2I9ePnQH2N9NHTqULb80v8JNKmQbREeMxoce0+vc8K6OVxR?=
 =?us-ascii?Q?9iP1y0DAREnQuYl+9/OpjS8pCA6L/k9oUTEuxsOXClNKkpGKWA24UDxLQ+3s?=
 =?us-ascii?Q?pw0866q2COdxo8j/K7CjtZLLqpPxa6TH1+BM2uRYvFv4szUKKeUrKSIAWRAI?=
 =?us-ascii?Q?z3PfdxNIZx8GmJBadhnl9jIruNM9xzzfq2hKvGnXTp3gz8zeGbUyvDB81Vtr?=
 =?us-ascii?Q?foPnBbtBSxs3Sc2KmspLHcbku4/xJXK8oTUhvYDn9NhAlcZwE83P0REG4Ob5?=
 =?us-ascii?Q?jV1LC0pCObaEtzIyXtUmdSFV22n4jAPlVd0AfzUK7UFjk8Jp6PqV+HPF1IhV?=
 =?us-ascii?Q?LY+rn5v6qbsbjxKIXfDU8Seyb3ohxlkeNwW8MVuvwutj66M44FDCLbBHUaXg?=
 =?us-ascii?Q?LuQ5qLFQ09pMlm/DrDw0jpKbBpfJuX6/vJC360zV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d08d957-f149-4023-8a02-08dbf68e194b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 19:03:57.4940
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFknsj/jYuGbD5Z1yEixkeLsw7qJbJwSVWhcZVinPfzE0TN0CdC72R7EVFvDLEx/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9335

On Wed, Dec 06, 2023 at 06:58:44PM +0000, Catalin Marinas wrote:

> -------------8<----------------------------
> diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> index 1929103ee59a..b89d2dfcd534 100644
> --- a/drivers/vfio/pci/vfio_pci_core.c
> +++ b/drivers/vfio/pci/vfio_pci_core.c
> @@ -1863,7 +1863,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
>  	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
>  	 * change vm_flags within the fault handler.  Set them now.
>  	 */
> -	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +	vm_flags_set(vma, VM_VFIO | VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
>  	vma->vm_ops = &vfio_pci_mmap_ops;
> 
>  	return 0;
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 418d26608ece..6df46fd7836a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -391,6 +391,13 @@ extern unsigned int kobjsize(const void *objp);
>  # define VM_UFFD_MINOR		VM_NONE
>  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
> 
> +#ifdef CONFIG_64BIT
> +#define VM_VFIO_BIT		39
> +#define VM_VFIO			BIT(VM_VFIO_BIT)
> +#else
> +#define VM_VFIO			VM_NONE
> +#endif
> +
>  /* Bits set in the VMA until the stack is in its final location */
>  #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
> -------------8<----------------------------
> 
> In KVM, Akita's patch would take this into account, not just rely on
> "device==true".

Yes, Ankit let's try this please. I would not call it VM_VFIO though

VM_VFIO_ALLOW_WC ?

Introduce it in a separate patch and summarize this thread, with a
suggested-by from Catalin :)

Cc Sean Christopherson <seanjc@google.com> too as x86 kvm might
support the idea

> I think that's a key argument. The VMM cannot, on its own, configure the
> BAR and figure a way to communicate this to the guest. We could invent
> some para-virtualisation/trapping mechanism but that's unnecessarily
> complicated. In the DPDK case, DPDK both configures and interacts with
> the device. In the VMM/VM case, we need the VM to do this, we can't
> split the configuration in VMM and interaction with the device in the
> VM.

Yes

Thanks,
Jason 

