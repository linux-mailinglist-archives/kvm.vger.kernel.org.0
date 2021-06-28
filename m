Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E0E3B6B55
	for <lists+kvm@lfdr.de>; Tue, 29 Jun 2021 01:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbhF1X2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Jun 2021 19:28:55 -0400
Received: from mail-mw2nam10on2073.outbound.protection.outlook.com ([40.107.94.73]:18529
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231723AbhF1X2y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Jun 2021 19:28:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oOFi0EJs6MPKQovMqvinDuiZMpn5+I5o+2dY+TSD5CBSnzyN8bW07amXWWWtVE3eY5cBNBKC7hnTUQ+U/a9hA3m2JXCty7nWVksxi+5KbxWr0VkyYKT+m1hlK5t6khgma8yHBH4OIqrK7cymK/vYs1iociNYYt1niFI4t9L48df4Mi1cVzisygjbLNdyw3l+HSxky7Y/O0egxJGcA3bY8Znv5dqJPypJM9QPiyicqSpvchlByKN7TFwiivXE385wbu6+Wskr3RTDbeAcQcByVL3ZhY32I2U34FP/Y0PepZXQKh7aRDebCg17eK0p3IE3GYOTbzkefCk1OZG2j1OmVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzEmHoCHNQjVh4JL46pHJQfJwi+GT+Ox1Ui0YqSFXgQ=;
 b=NhECLk0e6k9RymLzUTjz1rmaTpGRey63Qh8wMjDODZy563PE6J3wscpiBxZ4dQcYDxKsnC2esA1bcBeVBPP5Im4Glp3aQx2BblwdPuwxtmY60y97KBfUp7/k0G/wevJtr/wGTt6t7papfC4nJOX3U+FrhBD+5CWkZd4I1D8Xjj4m9X31gyf8I0R+dgJWoBOT5Q+33ZIMeAtulXIdimh0N3OrQf8NehdOKxNqb5/laq0G7wzmfYQcx7rmJ9cMGnlUbhLeL6nEgqEVmEYvjb1A4nilKoNI8urA0wPJVL4jThXKKvj6cMEf99ya3KqkpSi1ky+S+Mqes/K7IVhTPg1XBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzEmHoCHNQjVh4JL46pHJQfJwi+GT+Ox1Ui0YqSFXgQ=;
 b=SocGpWFHR6D9vl8uI77QVx1KWdq+k38sQq+XDWFtjVeOtE/YcdgSH6cK0czK45Yq7cj+WuOqgANZEQDcEa/mCLgRshLexsn4/8yyGYPuaTaguuStxFm0WqR6LPhWZ0bXq2QuHHwIRE1J/MbbJLcV2mr2QrK0q8MGL11SbFOzu7S3Pgg+7/Tz785y2NI62pAhaBRytMBxsoOaDPEAMKTEetoX4ddQMlXH3HCeQu1yxUGoeuAiyJnM7boxY4+3ZFNPajXI+BJoXkBb16IpWXBPfw6pntO4x09BgwPxNneQ1j9pTNVXFs5RL7oStIuCrNSbKE/7THl7b14sJbZklRwXvQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5302.namprd12.prod.outlook.com (2603:10b6:208:31d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.20; Mon, 28 Jun
 2021 23:26:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 23:26:26 +0000
Date:   Mon, 28 Jun 2021 20:26:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH v2] vfio/pci: Handle concurrent vma faults
Message-ID: <20210628232625.GM4459@nvidia.com>
References: <161540257788.10151.6284852774772157400.stgit@gimli.home>
 <20210628104653.4ca65921.alex.williamson@redhat.com>
 <20210628173028.GF4459@nvidia.com>
 <20210628123621.7fd36a1b.alex.williamson@redhat.com>
 <20210628185242.GI4459@nvidia.com>
 <20210628133019.6a246fec.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210628133019.6a246fec.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0103.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::18) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0103.namprd13.prod.outlook.com (2603:10b6:208:2b9::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.8 via Frontend Transport; Mon, 28 Jun 2021 23:26:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ly0e1-000mCa-PS; Mon, 28 Jun 2021 20:26:25 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1455c026-8e85-443e-a80e-08d93a8c267d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5302:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5302FD289AC42C313DDA101FC2039@BL1PR12MB5302.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NGuCZ1T8qRaX9rDiGmooSTB8wqpLK0R1c5QfrVKiN1qvXbQZ0Ppaj3ZVd7P4m/lz5ioDZHOD1c/JPFLGGGJguPr0C/hd0jEbi8DxAVilFT0RgiW+dAobapGxjYQll3IMVpo0ZXRnbXMSDnWDsP4ry08sCM91QuuvkhpG3/2t3eYdGLbr40GHHiiR/6lH/VTH3AXt4fHuj5/MFPGFhWvKoy+AuUy7C6j6CvGoST9lc/ZFrFvFkDCRCA5Slptwm8VRTZCePyc9XuA3eUjPF3/Lcaif0C7/cB4QXWUyMO3oUCzEzRh7MsDgRL0Nalddjo7mC6Ld6cDhnoKMTI6ED2WsckaC9DCyPVzC5PW0Nm6UlErN5U1BV34Mhr6UhRaXhdk5XYfZln25LENgIFh6vT3g/ojK/UP2DcoAWIbvYJ3WEYqdibUXVxQhuiH6HrMs37WGUqVgc/vbLWclPpjdgkZ3au4xeA2/x9EKCFchWR9hVlBT4yMvZA0PykVKs4sIYuaw3upqa49bEzzB0XqzVB1+j8CGep6KN/S71coQKFfJYTPsByujGue1wGnqETwALdWCgokW0a8HFEHfv0l1GKEbMxwNqFVdI1nxBoE7LTMp/XKdudHktF8p3wYhT5MpbgyEOYS/4kceWSSHUTxoBCxUiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(86362001)(26005)(6916009)(8676002)(4326008)(2906002)(186003)(2616005)(83380400001)(9746002)(5660300002)(36756003)(38100700002)(1076003)(316002)(478600001)(8936002)(9786002)(66476007)(33656002)(66556008)(66946007)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WHSLfPf1PCqfVQnV/hShN2ArELO1PAgBkLEEJeBN9ENKgjmYhcZWQBcww7fc?=
 =?us-ascii?Q?09pSgZ2503hTQSP6G3DuCR0xTv0ZAXsLBJYVcSB4NJVNO6RVM3vqFiO/F+DA?=
 =?us-ascii?Q?SinjQbRhEUB7ETA+b+TUFkWuATx7tCLXER9M4iLGxK15frCJlJFLwByOiZiL?=
 =?us-ascii?Q?EqeaBQzDsRDtMTUski/+Y/xQ6Ch4E8cu8jbN8nS4RQdqrdozAdYSRRfojVxB?=
 =?us-ascii?Q?GL5vvheYNMcLrEdH/3/aLjoVJgLY8dRs5Wky4Q+p+xzM8ueKmM/YlVJCOAYa?=
 =?us-ascii?Q?nAvmYtfyvYJxHS5kseSlZABvfKg/dbxs11UpDQcainP1A++kBA7L8mRjPRSZ?=
 =?us-ascii?Q?LWKXLc0BLuE49lYzJ9emHxKo8/5F+X2d0Ey1OJLmMvodZckZURcE/rLMizuI?=
 =?us-ascii?Q?9Yozc61sQ/VClOnwrnviWm65GbGssrUWYVkZZ/Xzgi7CwrPBDm498R8NwVZm?=
 =?us-ascii?Q?v9aW/B2SzFzpc6GaHJyw2ebv8CSGu6orM1Nx32pCqpz3cm2a/VwNSFhpO0A5?=
 =?us-ascii?Q?n+XCLni2WpQhN/sugsro2r9nYQXszlfvAwabiLj0UtU39p3yI2PJEy5p2lm7?=
 =?us-ascii?Q?YXclWCLukeMhOhvqDAiXtJQ3RYj5zkA+6EqEqETj3bw+2IUcztCTDAFIJj8o?=
 =?us-ascii?Q?eD1ZOxbsmAq4VrtBQnlDjVY0BQWte89+lig78k7gMSYdm90Zw8mFmA9S61J6?=
 =?us-ascii?Q?l5Iarkg5QUnkO6QN9InaQ5li+uHnoYEkGHpAKwYwEtA01f4i8OHMR6Zp5d/C?=
 =?us-ascii?Q?zBZVYmnOJZjzopjEDiizb5UDbvg9Ei1IaHAdtSRgvezSt19EzM+KWgLaOSDL?=
 =?us-ascii?Q?4NDRum4sax1bz8EeN+MNEEwopKRyrxKuCCozsUIPu4qZNlosZHoG8fQDtLpA?=
 =?us-ascii?Q?KmTjoriE3gWtXihcR34p3CWXsnrNXvjEGy9I5FiMTTN4CXZ5tr4CRY8aEowq?=
 =?us-ascii?Q?H+6uMQrhwuBx0jD5IN99QwaZ3KoqRjB+78rRa/SWXW4xaHrtYkPRk3R3Hajp?=
 =?us-ascii?Q?9tWuZuFblJWuX9s/nRNkZKItJpgMY1ifmMwrS4Brmi7IqmgqVHuVzAfVesnB?=
 =?us-ascii?Q?rJ/Bbl5tOwlBfaUbZY7yAN4BWnpXqqSDQC9XueM86TL34kyUndxlDtTdHGo3?=
 =?us-ascii?Q?AhwhAUbV94/Y6+fNhxAH0PnxKN6DWNM7utkbg5Fhhtl4yFoAEdlz6xBe0Jh7?=
 =?us-ascii?Q?SDOJq5iqnVEpI/ej5GwgkulVIbkaGOpphmCu0/mpUsmlBqcv1TdSk3iWkmFX?=
 =?us-ascii?Q?KGAq/vlwyKRemFdVkNW7KCuX3kc0ogWUAX5mi7PG0SGk77U50a3KgH+NNkLi?=
 =?us-ascii?Q?xnDtAQIlvbFwSZw6zZrDE+OW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1455c026-8e85-443e-a80e-08d93a8c267d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2021 23:26:26.6820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwNBAgcbMsHDnsMAjNz9kl1FISyQg/1mBvBqm7ovbacZBqC5fVir9fRZsUxB2JQD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5302
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 28, 2021 at 01:30:19PM -0600, Alex Williamson wrote:
> On Mon, 28 Jun 2021 15:52:42 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Jun 28, 2021 at 12:36:21PM -0600, Alex Williamson wrote:
> > > On Mon, 28 Jun 2021 14:30:28 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >   
> > > > On Mon, Jun 28, 2021 at 10:46:53AM -0600, Alex Williamson wrote:  
> > > > > On Wed, 10 Mar 2021 11:58:07 -0700
> > > > > Alex Williamson <alex.williamson@redhat.com> wrote:
> > > > >     
> > > > > > vfio_pci_mmap_fault() incorrectly makes use of io_remap_pfn_range()
> > > > > > from within a vm_ops fault handler.  This function will trigger a
> > > > > > BUG_ON if it encounters a populated pte within the remapped range,
> > > > > > where any fault is meant to populate the entire vma.  Concurrent
> > > > > > inflight faults to the same vma will therefore hit this issue,
> > > > > > triggering traces such as:    
> > > > 
> > > > If it is just about concurrancy can the vma_lock enclose
> > > > io_remap_pfn_range() ?  
> > > 
> > > We could extend vma_lock around io_remap_pfn_range(), but that alone
> > > would just block the concurrent faults to the same vma and once we
> > > released them they'd still hit the BUG_ON in io_remap_pfn_range()
> > > because the page is no longer pte_none().  We'd need to combine that
> > > with something like __vfio_pci_add_vma() returning -EEXIST to skip the
> > > io_remap_pfn_range(), but I've been advised that we shouldn't be
> > > calling io_remap_pfn_range() from within the fault handler anyway, we
> > > should be using something like vmf_insert_pfn() instead, which I
> > > understand can be called safely in the same situation.  That's rather
> > > the testing I was hoping someone who reproduced the issue previously
> > > could validate.  
> > 
> > Yes, using the vmf_ stuff is 'righter' for sure, but there isn't
> > really a vmf for IO mappings..
> > 
> > > > I assume there is a reason why vm_lock can't be used here, so I
> > > > wouldn't object, though I don't especially like the loss of tracking
> > > > either.  
> > > 
> > > There's no loss of tracking here, we were only expecting a single fault
> > > per vma to add the vma to our list.  This just skips adding duplicates
> > > in these cases where we can have multiple faults in-flight.  Thanks,  
> > 
> > I mean the arch tracking of IO maps that is hidden inside ioremap_pfn
> 
> Ok, so I take it you'd feel more comfortable with something like this,
> right?  Thanks,

I think so, it doesn't abuse the arch code, but it does abuse not
using vmf_* in a fault handler.

> index 759dfb118712..74fc66cf9cf4 100644
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1584,6 +1584,7 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct vfio_pci_device *vdev = vma->vm_private_data;
> +	struct vfio_pci_mmap_vma *mmap_vma;
>  	vm_fault_t ret = VM_FAULT_NOPAGE;
>  
>  	mutex_lock(&vdev->vma_lock);
> @@ -1591,24 +1592,33 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  
>  	if (!__vfio_pci_memory_enabled(vdev)) {
>  		ret = VM_FAULT_SIGBUS;
> -		mutex_unlock(&vdev->vma_lock);
>  		goto up_out;
>  	}
>  
> -	if (__vfio_pci_add_vma(vdev, vma)) {
> -		ret = VM_FAULT_OOM;
> -		mutex_unlock(&vdev->vma_lock);
> -		goto up_out;


> +	/*
> +	 * Skip existing vmas, assume concurrent in-flight faults to avoid
> +	 * BUG_ON from io_remap_pfn_range() hitting !pte_none() pages.
> +	 */
> +	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
> +		if (mmap_vma->vma == vma)
> +			goto up_out;
>  	}
>  
> -	mutex_unlock(&vdev->vma_lock);
> -
>  	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
> -			       vma->vm_end - vma->vm_start, vma->vm_page_prot))
> +			       vma->vm_end - vma->vm_start,
> +			       vma->vm_page_prot)) {
>  		ret = VM_FAULT_SIGBUS;
> +		goto up_out;
> +	}

I suppose io_remap_pfn_range can fail inside after partially
populating the range, ie if it fails to allocate another pte table or
something.

Since partial allocations are not allowed we'd have to zap it here
too.

I suppose the other idea is to do the io_remap_pfn_range() when the
mmap becomes valid and the zap when it becomes invalid and just have
the fault handler always fail. That way we don't abuse anything.

Was there some tricky locking reason why this didn't work? Does it get
better with the address_space?

Jason
