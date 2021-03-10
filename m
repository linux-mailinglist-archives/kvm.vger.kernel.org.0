Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3D3334665
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 19:15:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhCJSOw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 13:14:52 -0500
Received: from mail-bn7nam10on2066.outbound.protection.outlook.com ([40.107.92.66]:24544
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233339AbhCJSOu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 13:14:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KlObuqZBsymMED72MmZhIFI+jY34vP10abLzqTi2JH9oMZZjsyN4LZEpey+6UbUhOnc3y+4zQXB+ZMF62O8J0dBIs1tZ/KGLROMM400Pn40TcSVtvve37Z/YPOTh4776zcl0t65Q+Ppe7EUsfYBU84V88Wc9PUEV2o/4GgNpl1oWmsixi0XzDAu9MRwwtodWxYHHcLg7hgpxS8mI5bqOiSTjmGP5N8n6eFFiqbVeKjb61E8FfWPdroAz7JMJknY8k4vhRkyKZFL1ZJeeG+H2ezdJf0012aUiph35tUehfJepeuerwpqC6Ya+BmByik5cekIeJ65b1J/60NG6OtGUwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/ZGC5spIkw9fHjH5wGLGKuowDJUZbVmFYSqPVjK3Wg=;
 b=djnKYHMFAJh/1o+bA03pzLENlLPItHex9ZIhOdD5UmZdPJ4h60jPt6rGFpHT9a5/EZy/4ZftaogXNK56rr+MoVPAHFWrYLpdfS18Ta22FpKdG0dvSLKKi22T4JxqGhgGjfq2fiQLQ4JVC5yIOgqzQLJtCYvk3s6JFj4zQjvn9eZmn5/9TQS3TAiRN3t1DHO404H2ocphixJQPJ6eE3m1sel69YyR+MipyQGIDpi6Xk+yBGyg41auPblfgx5iKOtVmR+3ABw813I1pFwao0doiKKONkav+riNX0UG760Vzv7lH6Jk87flzmIBSxiqlfvtQg2igGbTc/cQ5ppCS+j1BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/ZGC5spIkw9fHjH5wGLGKuowDJUZbVmFYSqPVjK3Wg=;
 b=JHpDu1mA0g6VlsZZuDamStz32ewu8CqkHFP21LLQC8xmx60zbeNNl8sh+nBYvY3D2WEvs1on67T/QI4SZ4EPrwMDD7pSFJRcGuPiJES30ajqUgaQPzfDk+YUbXSXfKX/2uIF9LfDdrj5Tjqlu2hX2wspLXav1am3HEeL88phjnKOKIsiRLyT3IBAfe/wDq6/Ns/3LRJxwvanQzhOJRlI2Jz3GiSj8ZScdO9VbdeCzzc2KZG5ofa0zqEGfSw8iXzKjXprk8MgPssllHb0mgtR9j9KK6RyV69/2qUalIQZ6uGBJfszGdLcqTlM5LaISFB8/RP5XG9PT2X/bb1a7wBaKg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3594.namprd12.prod.outlook.com (2603:10b6:5:11f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 18:14:48 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Wed, 10 Mar 2021
 18:14:47 +0000
Date:   Wed, 10 Mar 2021 14:14:46 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterx@redhat.com, prime.zeng@hisilicon.com, cohuck@redhat.com
Subject: Re: [PATCH] vfio/pci: Handle concurrent vma faults
Message-ID: <20210310181446.GZ2356281@nvidia.com>
References: <161539852724.8302.17137130175894127401.stgit@gimli.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161539852724.8302.17137130175894127401.stgit@gimli.home>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR15CA0036.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::49) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0036.namprd15.prod.outlook.com (2603:10b6:208:1b4::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 18:14:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lK3M6-00Apxs-Gx; Wed, 10 Mar 2021 14:14:46 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7050641f-2e5a-4110-c2ec-08d8e3f063aa
X-MS-TrafficTypeDiagnostic: DM6PR12MB3594:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3594E6EE30F609FF3B6C8F3CC2919@DM6PR12MB3594.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /lNYbZ3Olw2VubIo0Ignjia10sWWg/3iHkpiYzeOyKXlG7AFom+W0o8GbIwE2HSFMNP5Lu3G4DH4YXjjdmmH9TS10WhBOLCrryMXOUjdNIIBfkMajmuGkhNJwPxmBzsxDgAvkdhzxjuZB9GN7mpUKm2Tm2NIhJRJ5kLI8dPYic4tavR+mLkSVcVWsPV+qm4c6KHcIi7xJ9H866u3DZlVnQV3aSvDqWII0vrNzI48ax3wdwvn9caK7TWPmNAta/JD6oJQOvDXqRaOCJnEg0Z+z2bU6KILTkpedXYALfv58IZxk3C9eTAsJEBfj4R/ecUjel2VMcP75uPaAId0V73i/M0BcmwjMZFUOZGrGO2AT8DAfzgwdzVTFOEknpLczmVbLy7As9d6f0SeNgB3V8CNpqItfZCarVztUOTbzB9rhan4n6LuWZq+iYTljml1fW8LX5ehruHoZuG4nTej35iexqWOs185D0ryy1iZdodtzoLiPv7jD3kHaQVYbDFcf8p2Hosnd2UXwlmFiHhUgEA7ug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(366004)(39860400002)(5660300002)(1076003)(2906002)(83380400001)(33656002)(6916009)(426003)(66476007)(2616005)(478600001)(66556008)(9746002)(66946007)(4326008)(8936002)(186003)(9786002)(316002)(26005)(36756003)(8676002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?q7T2TswuLQddNvaJ6N/TRxyYpgjey9AIstSAsjW94rRL7nR+CbkfIju6AVdo?=
 =?us-ascii?Q?V9SHiLdGD9xTqUkchIPA6SgaNCsNwxxyC2TJcPWPBeyWrP2BbEetVzsJkWtc?=
 =?us-ascii?Q?WIYVlWa2qp/fVxNvi31eBertRUeg0yKKhjf+MBaktLuYHkWFeKHvD8wwUtQB?=
 =?us-ascii?Q?cT48Wjlp8Uy0tcPzOy9ri4zXjM2l4o7VdZWBO37VC4OamnNL9YhRjtuAZtKV?=
 =?us-ascii?Q?BYFd0Vs5x2ZgB6xImmjsZc0iIa1ZJPU1vIC4m3hLhajyxfH8PmGdJX5d1bbI?=
 =?us-ascii?Q?wDxoVv/4hXxjevpJL6vIXdN5LHvhOL9t7bgyNOnqv/GRVleoYMKbCE4OiYAL?=
 =?us-ascii?Q?zTiU4Yg6R7TvBrXzuswCkqld1qGns6bHknnCBE2arTYwMC1/c8Jyo+uTrmO2?=
 =?us-ascii?Q?p+WQGj5TMSvPj0F4/2ZB0cpSLa0PqZ6NmZvmRZkpM+wJoT7FIFnQpUYDqoSY?=
 =?us-ascii?Q?JR0LUqH/VBZzP/7i47fQv2DPAiVhUcbCpsyWag4YXlXJKMJ9fHzB344vyIVg?=
 =?us-ascii?Q?mvYwpbScS2nXNipr22WIBC39O+zf0v4SglYX8ov14OjpNYGULGssF/mh8QgP?=
 =?us-ascii?Q?C02WBlfy5rKz79w24oFcyAVdUFWvOXtyZ725ynx2mqOhLOchwij5RhHlO5h9?=
 =?us-ascii?Q?OFQ8Dw68djL1zZvKHYTNn69wIJpFBY4f4sLqiNG263ckGoRbVNmy5bukmEoo?=
 =?us-ascii?Q?Rr1MWp3bUBIq4UV8ZanHG2X6wPPBbh8hDmKtk2u44fNOmU0SENp9/rR5TW2n?=
 =?us-ascii?Q?6fgcu3R2OsA6jsipWFAG0SaJTZS5PJpBVuDPdOZg+aLXfh+NYgEOfgOrFGcv?=
 =?us-ascii?Q?db+u8Uu6uIM9ffDIFcYjv6VpDoFA76rd4K+0clgfw+vlVCGMFtm2UbTn6meg?=
 =?us-ascii?Q?ndws5YgHR9C0yY9tOzQ/CQfJs06qc5nPh8yV8N7dvE4mF1MjIDgdWuxyzwMY?=
 =?us-ascii?Q?1/vJyjKEvKV07pX+kz3SfzzdSyeiK2lzf5Qs3WemTmWpS9N7vhZ1+bEPK4vR?=
 =?us-ascii?Q?4zswhtpRD5wSGKsSIKBdj2OeSxXW+5hSi5Eh/FtCbBgo2OiVGd3BZtuK3yWF?=
 =?us-ascii?Q?myE8jm/4/Q7mhXlhdCHh0QgWGszc4jfVee/QWgKEAsZP2cCmNOSe9P8gYlUB?=
 =?us-ascii?Q?xorCaWvCmWA+d46aUcxCbPJrhvl3NDr35u6XLQdqiX2/nKmazBoIO35OiIcU?=
 =?us-ascii?Q?6AEGrOCTg+IW+khDVbr3O+UjRJII4GEdpXY6NvMcditsZOM+c3r4eYET6c0k?=
 =?us-ascii?Q?J3osXhJTYNRKb7N9Nwpf8hTUCKpHUYMl0FC9XxSDtyNj/YGJB27LQa2Lwmqj?=
 =?us-ascii?Q?soma4AquT7Axz2c+2+/zvdl1Mu43aiRg5wuvjzeLsBc1rA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7050641f-2e5a-4110-c2ec-08d8e3f063aa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 18:14:47.8185
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4nLVcOMOoJdW2lxrt3TTfv3HzPGQw6R1jQPzGMnrmhTovh5ryVEP9B5nimsMQpO7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3594
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 10:53:29AM -0700, Alex Williamson wrote:

> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 65e7e6b44578..ae723808e08b 100644
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -1573,6 +1573,11 @@ static int __vfio_pci_add_vma(struct vfio_pci_device *vdev,
>  {
>  	struct vfio_pci_mmap_vma *mmap_vma;
>  
> +	list_for_each_entry(mmap_vma, &vdev->vma_list, vma_next) {
> +		if (mmap_vma->vma == vma)
> +			return 0; /* Swallow the error, the vma is tracked */
> +	}
> +
>  	mmap_vma = kmalloc(sizeof(*mmap_vma), GFP_KERNEL);
>  	if (!mmap_vma)
>  		return -ENOMEM;
> @@ -1612,31 +1617,32 @@ static vm_fault_t vfio_pci_mmap_fault(struct vm_fault *vmf)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct vfio_pci_device *vdev = vma->vm_private_data;
> -	vm_fault_t ret = VM_FAULT_NOPAGE;
> +	unsigned long vaddr = vma->vm_start, pfn = vma->vm_pgoff;
> +	vm_fault_t ret = VM_FAULT_SIGBUS;
>  
>  	mutex_lock(&vdev->vma_lock);
>  	down_read(&vdev->memory_lock);
>  
> -	if (!__vfio_pci_memory_enabled(vdev)) {
> -		ret = VM_FAULT_SIGBUS;
> -		mutex_unlock(&vdev->vma_lock);
> +	if (!__vfio_pci_memory_enabled(vdev))
>  		goto up_out;
> +
> +	for (; vaddr < vma->vm_end; vaddr += PAGE_SIZE, pfn++) {
> +		ret = vmf_insert_pfn_prot(vma, vaddr, pfn,
> +					  pgprot_decrypted(vma->vm_page_prot));

I investigated this, I think the above pgprot_decrypted() should be
moved here:

static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
{
        vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+       vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);


And since:

vm_fault_t vmf_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
			unsigned long pfn)
{
	return vmf_insert_pfn_prot(vma, addr, pfn, vma->vm_page_prot);

The above can just use vfm_insert_pfn()

The only thing that makes me nervous about this arrangment is loosing
the track_pfn_remap() which was in remap_pfn_range() - I think it
means we miss out on certain PAT manipulations.. I *suspect* this is
not a problem for VFIO because it will rely on the MTRRs generally on
x86 - but I also don't know this mechanim too well.

I think after the address_space changes this should try to stick with
a normal io_rmap_pfn_range() done outside the fault handler.

Jason
