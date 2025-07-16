Return-Path: <kvm+bounces-52657-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6601B07D09
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 20:40:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23B791C2849D
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 18:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A60729B205;
	Wed, 16 Jul 2025 18:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Xyz/HKIE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D537C29AB00
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752691235; cv=none; b=VLtTxeGtfOvWSKmrQDKal/2LAkXx/gn/1A5trsxxsCz2TuYrbFfRBWtYR07j6FlFpQfzEm/lBzBUdCHuDJReIHZRjugtywhgCnvStPzpX7sLqV9fzPeu+plzqwbJp8xEx4dl6c+PEb9mHQKdFuFGCpFqHMG0cg3TiVTZ/9lHyyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752691235; c=relaxed/simple;
	bh=AZ76K+qEXwWLSJ1tAbNdmEOp+0MBZ/0OlIqEvNsuCeY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aISkaKvq5TxrpqjGniaGD3WBoaquWh0fgjLEQjDFkbdu/Hq2fzimIKA+WzS7L9zlY8DjuKERs/Qdj6X/7pXnyp/aq+jKzQD6as01CeuHew6vL/7Vl7R/fHSYp2hzDJ4Z6KYCZ8gU699KrMiZu9rjeSJoSiN29U2fHLueceIuSv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Xyz/HKIE; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ab71ac933eso1865531cf.2
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 11:40:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1752691230; x=1753296030; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WVHNmdJCLkn822xRAmHr2AKLVfj2WNtHN72ptxLyUcY=;
        b=Xyz/HKIEe4TOswHohEPRZmikV4UACBBja9bR6F/fsVl71ilZjK2rEeuk3V3Atkqoz4
         3lIvKvef5rZqw3aTOpHiDg0p0Xo6iKqPOlAGN4FiU0/xTj3Dv9MUm9trs6ejKYtVzDYF
         WoPQGvdlHsmdv49piaF3Ohk8hGK09ukhOoQpylTtk3Tv4Stoy4TF5Cg4yWLYoPMl2apr
         T+D+IUiBkTXqsZQPw8a/0iMPKzFUUKyM/agznjtdq7IA6oM6LqJg51bup2zNuEexMmiA
         0sIAT12y0y6iX1pxbcKAvbBOsrgUcJjJCL/ybAA44/sPBfHs9fFl6U41pfvWo/kfPuZt
         BfOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752691230; x=1753296030;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WVHNmdJCLkn822xRAmHr2AKLVfj2WNtHN72ptxLyUcY=;
        b=Sxh10YDBnXo13R0HqUUjBdc3P94bOifCA/ybsn3hmOltnt5c4JXElanIFpEphP59h3
         CKdOI1HW6HLMSgtv2RGSKQOiQvsbRSQJVGbMIYVwiU0iAnJ/U+RrvjhZWs+83cHCPHG/
         RW4MjEboDoXGkdI6wySyd++No2gzgZ2UIzjmdf8Q2edsfBChsnraiCtFTTst7TRR0R4w
         ZyQokGGIbQS4FbyAdkM4TXD9U2imDbL4nmSsRszdsE16N1lCh1552HwZW7ehTKUT6VI+
         qbSGVpm76X3+38RJQjcVul/zWtE3U9+JEA+AZ4XrngnrtpkoMEWgM+RgN+1gvGVCZZ5Q
         aimg==
X-Gm-Message-State: AOJu0YxHZrcr/uiR/iNx1u4981Nxqv6QMaszBiRnBJICfdG+dCljn3Js
	ffCTJdPtFTl4HFK9bVlum2JdnFgZ3GzfglrJ5GIxL695b3JISxxIolOpAow6hiWz2K15Kp5Zqqx
	vmCwf
X-Gm-Gg: ASbGncv+BVMIZMcHB+B+ukdEVj+DVU9ZYtfPe33YiPgpYsOIJunnxc1jZPH6bAMkfs0
	uCo4lf8E383iuD7HLPC2lXXuDO8hoeRcwVkjd/ENixnVZJ8TDb4HGA8bwsFITjS0GCc/G2Lj2Ys
	blyCguZv9DIyjh5w2AJNI6TZrictYofZIk77EEgFnBcjHHjyxxTZjQf/iUmOcb0nBGT9NC1L9vy
	EUMYOPdiFNsuCtTKEUiJ84d0HWCRAuWN/QSdU34no/FiFoG+vmGRRNGA3JbZJ99j12Ush7voYPC
	7IzAqP0j9+a+VVbpNl47f1SliQwXrmYg+bo5tKUZVXto+QSrcL20FcYEzm8xE4IcS73TeNGJzPg
	+ZTJhhPVoMmWRz6vLmQFf1RZfIEOdc2WppPn1UynF2McXNkvUC7mXTOt89d/UHJFztUtmt0CtyA
	==
X-Google-Smtp-Source: AGHT+IHINv5f+/CiYOEiM3HxhWRcNPh7D+X+9dtPGJy0RpWkzk/9p7xWhhOHJBcYy4UPn7cdHS3Bxg==
X-Received: by 2002:a05:622a:1bab:b0:4ab:85a5:bf05 with SMTP id d75a77b69052e-4ab93dd693bmr54275041cf.45.1752691230422;
        Wed, 16 Jul 2025 11:40:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-167-56-70.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.167.56.70])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ab76bdb57fsm30091261cf.19.2025.07.16.11.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 11:40:29 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1uc73M-00000009AEO-3A5Z;
	Wed, 16 Jul 2025 15:40:28 -0300
Date: Wed, 16 Jul 2025 15:40:28 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mahmoud Nagy Adam <mngyadam@amazon.de>
Cc: kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
	Praveen Kumar <pravkmr@amazon.de>, nagy@khwaternagy.com
Subject: Re: Revisiting WC mmap Support for VFIO PCI
Message-ID: <20250716184028.GA2177603@ziepe.ca>
References: <lrkyq4ivccb6x.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lrkyq4ivccb6x.fsf@dev-dsk-mngyadam-1c-cb3f7548.eu-west-1.amazon.com>

On Wed, Jul 16, 2025 at 07:11:50PM +0200, Mahmoud Nagy Adam wrote:

> - Dealing with legacy regions & drivers created regions, this could be
>   handled as suggested[1] from Jason using maple tree, which I'm
>   implementing to insert flags entry of the range to be mmapped, since
>   this would give us the flexibility to set the flags of any ranges.

I think we agreed that the mmap offset we use today is not ABI so the
maple tree should be filled in either during file open time or
probably simpler done during the regions info ioctl.

> - Scoping the mmap flags locally per request instead of defining it
>   globally on vfio_device/vfio_pci_core_device. This afaict from the
>   code could be handled if vfio_device_file struct is used with the
>   vfio_device_ops instead of the vfio_device, specifically the mmap &
>   ioctl since these the ops of interest here, so that we could access it
>   there and have a per fd maple tree to keep the flags in. This will
>   also keep the life time of the flags to the FD not to the device which
>   I think is better in this case.

It would be best to put the maple tree in the vfio_device_file.

The core code should just do the maple tree lookup and pass the struct
down to the driver, sort of like:

static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
{
	struct vfio_device_file *df = filep->private_data;
[..]

	struct vfio_mmap *mmap_obj = mtree_load(&df->mt_mmap, vma->vm_pgoff << PAGE_SHIFT);
	if (!mmap_obj)
		return -ENXIO;
	/* mmap must be contained to a single object */
	if (vma->vm_start < mmap_obj->vm_pgoff || vma->vm_end > (mmap_obj->vm_pgoff + mmap_obj->length))
		return -ENXIO;
	return device->ops->mmap_obj(device, vma, mmap_obj);

And the ioctls would need the df as well, but that is trivial.

Then all the pgoff touching in the driver around mmap goes away.

Drivers implementing the mmap ops should be structured to sub-struct
the vfio_mmap to store their own information:

struct vfio_pci_mmap {
       struct vfio_mmap core;
       unsigned int bar_index;
       phys_addr_t phys_start;
       unsigned int pgprot;
};

Or similar perhaps.

> Since I'm in the middle of investigating & implementing this topic, I
> would like to collect opinions on the approach so far, specially the
> last point. better ideas or objections with dealing with local flags
> using vfio_device_file or other points would be appreciated.

I strongly feel using a maple tree to translate pgoff's back into
kernel objects associated with the mmap is the right design for every
subsystem to follow.

Nicolin implemented this for iommufd:

https://lore.kernel.org/linux-iommu/9a888a326b12aa5fe940083eae1156304e210fe0.1752126748.git.nicolinc@nvidia.com/

Which shows the basic shape of the idea. It is quite easy to implement
on top of maple tree.

We are getting close to having problems in VFIO. The 40bits allocated
in VFIO is only about a 1TB of MMIO which is now a real-world size for
CXL devices. Making pgoff dynamic is the best solution to that
problem. It avoids running out of pgoff space as long as possible and
maximally retains compatibility with 32 bit systems.

Just sort of looking at it, I would suggest trying a sequence of
patches like:

 1) Make a new function op for VFIO_DEVICE_GET_REGION_INFO. It looks
    like there is quite some duplication here that can be improved on
    regardless.

 2) N patches converting drivers to use the new op.

 3) Add the basic maple tree stuff and a new mmap_obj op and new
    VFIO_DEVICE_GET_REGION_INFO that returns a 'struct vfio_mmap *'

 4) N patches moving to use the vfio_mmap ops

 5) Remove the unusued old APIs.

From there you can figure out the right uapi to get another maple tree
entry that selects WC/cachable/etc mode.

Note though compared to what Nicolin did VFIO will need pgoff
alignment during the allocations. BARs should be aligned to
min(PUD_SIZE, bar_size)/PAGE_SIZE within the pgoff space to make
things work well.

I think this is a striaghtforward project, though the rework of
REGION_INFO will be some typing.

Jason

