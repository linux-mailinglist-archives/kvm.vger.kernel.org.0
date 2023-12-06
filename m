Return-Path: <kvm+bounces-3755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5016280785F
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:07:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 59199B21014
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 19:07:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB68675A1;
	Wed,  6 Dec 2023 19:07:06 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79CF23BB3D;
	Wed,  6 Dec 2023 19:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A909AC433C9;
	Wed,  6 Dec 2023 19:07:00 +0000 (UTC)
Date: Wed, 6 Dec 2023 19:06:58 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
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
Message-ID: <ZXDGUskp1s4Bwbtr@arm.com>
References: <ZW9ezSGSDIvv5MsQ@arm.com>
 <86a5qobkt8.wl-maz@kernel.org>
 <ZW9uqu7yOtyZfmvC@arm.com>
 <868r67blwo.wl-maz@kernel.org>
 <ZXBlmt88dKmZLCU9@arm.com>
 <20231206151603.GR2692119@nvidia.com>
 <ZXCh9N2xp0efHcpE@arm.com>
 <20231206172035.GU2692119@nvidia.com>
 <ZXDEZO6sS1dE_to9@arm.com>
 <20231206190356.GD2692119@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206190356.GD2692119@nvidia.com>

On Wed, Dec 06, 2023 at 03:03:56PM -0400, Jason Gunthorpe wrote:
> On Wed, Dec 06, 2023 at 06:58:44PM +0000, Catalin Marinas wrote:
> > -------------8<----------------------------
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 1929103ee59a..b89d2dfcd534 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -1863,7 +1863,7 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
> >  	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
> >  	 * change vm_flags within the fault handler.  Set them now.
> >  	 */
> > -	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> > +	vm_flags_set(vma, VM_VFIO | VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> >  	vma->vm_ops = &vfio_pci_mmap_ops;
> > 
> >  	return 0;
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 418d26608ece..6df46fd7836a 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -391,6 +391,13 @@ extern unsigned int kobjsize(const void *objp);
> >  # define VM_UFFD_MINOR		VM_NONE
> >  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
> > 
> > +#ifdef CONFIG_64BIT
> > +#define VM_VFIO_BIT		39
> > +#define VM_VFIO			BIT(VM_VFIO_BIT)
> > +#else
> > +#define VM_VFIO			VM_NONE
> > +#endif
> > +
> >  /* Bits set in the VMA until the stack is in its final location */
> >  #define VM_STACK_INCOMPLETE_SETUP (VM_RAND_READ | VM_SEQ_READ | VM_STACK_EARLY)
> > -------------8<----------------------------
> > 
> > In KVM, Akita's patch would take this into account, not just rely on
> > "device==true".
> 
> Yes, Ankit let's try this please. I would not call it VM_VFIO though
> 
> VM_VFIO_ALLOW_WC ?

Yeah. I don't really care about the name.

-- 
Catalin

