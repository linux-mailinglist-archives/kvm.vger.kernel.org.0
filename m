Return-Path: <kvm+bounces-64411-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BAA1C81DC4
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 18:17:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 45D21348AC3
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 17:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8272BE047;
	Mon, 24 Nov 2025 17:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="LSVtJkG0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FBE276028
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764004610; cv=none; b=TaOTcjYrYD8FrSVPIIFzcO+U1SrzDT09JCKxofwtgSsL46g6kdMK3HaFjakyLVdTk8HKtzPHwUcM5mHcNDu+eoDjr8uP3BWKJFdziADfQH44ELP6k+wsBZKyGZm6ljkUqmTbffuT0kBkyQ2lRdCeH3Lzz+DFuEl1rDUdfOIGanw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764004610; c=relaxed/simple;
	bh=YuapzkYHjvuCa1ay/PcALv/VCUd0UjDE+pRzH40tu7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FPTNkCp/wcWg1v64uS+r+tn7fyCfnV7VjAeRgtSou6hsdKjN1MNb5odjYfe7kiy03yulO8w9WLJQfS0M+Zv05rqTXgbLhJE+dtKzSOJbAM7z3otX3c/sPJFug4Eng4E8fOT+QufNBUXeHEgPBY3Abp4uQ8g+WBbijCpoAjgq9kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=LSVtJkG0; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-5dfa9e34adbso3683501137.0
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 09:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1764004607; x=1764609407; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wbW2/cvpGd1DU99cNjjO6Aj6THos7k+R5vH41KvkmjU=;
        b=LSVtJkG0HIdINSSgGsaNjPxG6ikYybYMLVTqbM1MAt12mDM90HHpTfHHSj10u0VN/0
         yTZ8kzomK2sIiqMgpZwF2riX2/Rhmt828+T5iHsnwPUwI8FPjSeiH2HHvftOUTjScYba
         L7sE9ovqszsEW6qPmtR/XQmCRrNnY2PyeSZEROLhI1/EjX7X+nlNcCSiz8yM5nD1GRKl
         ttBK4sa8KPhN2AWYaKpW6P1ftZAITxmmOZPxJrV8MFUJuW2q4wdc/qshfPtjMqKmmEzY
         WG0jLRuGVnaUD0ivGeFzW07TzXdpj2vgreM9d0B3/+PuNg/E5GL9007tQzLgJeOLXwQw
         hEoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764004607; x=1764609407;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wbW2/cvpGd1DU99cNjjO6Aj6THos7k+R5vH41KvkmjU=;
        b=oOTVRS6HlOU6vg2VrbudZV8WJ5daTIOHDXGzbLQjZ2WlqGirbnDGRIOP3M8vVE5Kx3
         4BaCqk+fzdZEirCraVLWTO3Jvfwf83JUTx9YIusTh+9D4ekKYvu8y3MWMKrS6wzGyROm
         OWLqdOpvCJe/lUnwZiEeCUNdlplyUN3vHZ47YEM2Q506ccdLXortpw+hIJXOpAi8hzi3
         20jZ9P5a39dVL9pYkDrmvk1sTfvw3x934QCGtovYEUEY7PwJMML4PliY7ba+hTCraMYI
         fgUNKNmKXGlz5S3DhsNCd2GwP+Kge6fytUffiQsYDZ229uAbvAap4twGgxxLmRwEyCTP
         kTdw==
X-Forwarded-Encrypted: i=1; AJvYcCWNC6Zq/zOASw8GfIQRrOrDyWdIiflPzL8uX4S4eHPPmCeIwNOjhLjR+n7bi1qHgZagtbI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4jPMg2v3cjADneOKNLt+M/W2+7a4aPa5ulgvJgIJz0absHz+1
	llIS8/WSLCwhhyJqGkQSsa/VOFqwFvS0SiHg8W2436VvfF++EmxIAmy0ci47oOhdyFs=
X-Gm-Gg: ASbGncvXeattozYpLjud0axBDT6k6clOyQfFYSzrOhm+9iNu0SYDX0heowE1r2nO13u
	MHDjj1J/NHIrisExo6jx0i3UKtmWyu0RmwDXR8vqKw4OpIcAbpQqskS2Yp8jqEm/foTbbLbia/Y
	5U9Iwih9bZMca5e0BCbkkNfPoV6GFaTTmsvoiNBDVN5dKSqibv9WIDXWoupaqCPWZm5rzOfeCAx
	ojofw4uIg2m59aKF2NlugAU6kMomS/X+9+MEEece9/78uoz9S3A0xnErkWHlQTY4ljQ2BdU3n/i
	3q/PL0pi36q0x7kD86p/fPg6tKTMdHiq9VNdOwVm2hgCSJynVSHRrby4zBXaS/aumnr0Izqe6n6
	O0VumhpK5rEz+Gwec3UIvf5+GEgLzr2Tnqz5AB4CYO7gHg6G9p6Z+ksVh49hIPvXtjggXwoA3dD
	OP4TVdK9iT8jniw7SsA0eQuQGSEIZ5FKugJl0TjEb4HhhEWAzqKROE6RBq
X-Google-Smtp-Source: AGHT+IFVT1+AoMmLhFAjIzUO5C0YqFK8WoID+iftFtm9mDduf03REryWXOGvp9F5blrVwoBaq3m3kw==
X-Received: by 2002:a67:e716:0:b0:5dd:c3ec:b75 with SMTP id ada2fe7eead31-5e1de4f8831mr4644498137.29.1764004607393;
        Mon, 24 Nov 2025 09:16:47 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8846e445922sm102547566d6.8.2025.11.24.09.16.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 09:16:46 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vNaBC-00000001wY9-0IF7;
	Mon, 24 Nov 2025 13:16:46 -0400
Date: Mon, 24 Nov 2025 13:16:46 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Yishai Hadas <yishaih@nvidia.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex@shazbot.org" <alex@shazbot.org>,
	Aniket Agashe <aniketa@nvidia.com>,
	Vikram Sethi <vsethi@nvidia.com>, Matt Ochs <mochs@nvidia.com>,
	"Yunxiang.Li@amd.com" <Yunxiang.Li@amd.com>,
	"yi.l.liu@intel.com" <yi.l.liu@intel.com>,
	"zhangdongdong@eswincomputing.com" <zhangdongdong@eswincomputing.com>,
	Avihai Horon <avihaih@nvidia.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"peterx@redhat.com" <peterx@redhat.com>,
	"pstanner@redhat.com" <pstanner@redhat.com>,
	Alistair Popple <apopple@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Neo Jia <cjia@nvidia.com>, Kirti Wankhede <kwankhede@nvidia.com>,
	"Tarun Gupta (SW-GPU)" <targupta@nvidia.com>,
	Zhi Wang <zhiw@nvidia.com>, Dan Williams <danw@nvidia.com>,
	Dheeraj Nigam <dnigam@nvidia.com>,
	Krishnakant Jaju <kjaju@nvidia.com>
Subject: Re: [PATCH v5 1/7] vfio/nvgrace-gpu: Use faults to map device memory
Message-ID: <20251124171646.GU233636@ziepe.ca>
References: <20251124115926.119027-1-ankita@nvidia.com>
 <20251124115926.119027-2-ankita@nvidia.com>
 <CH3PR12MB7548F47FCF28EDF9EE0FB2B6ABD0A@CH3PR12MB7548.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CH3PR12MB7548F47FCF28EDF9EE0FB2B6ABD0A@CH3PR12MB7548.namprd12.prod.outlook.com>

On Mon, Nov 24, 2025 at 05:09:30PM +0000, Shameer Kolothum wrote:
> > +static vm_fault_t nvgrace_gpu_vfio_pci_fault(struct vm_fault *vmf)
> > +{
> > +	struct vm_area_struct *vma = vmf->vma;
> > +	struct nvgrace_gpu_pci_core_device *nvdev = vma->vm_private_data;
> > +	int index = vma->vm_pgoff >> (VFIO_PCI_OFFSET_SHIFT -
> > PAGE_SHIFT);
> > +	vm_fault_t ret = VM_FAULT_SIGBUS;
> > +	struct mem_region *memregion;
> > +	unsigned long pgoff, pfn;
> > +
> > +	memregion = nvgrace_gpu_memregion(index, nvdev);
> > +	if (!memregion)
> > +		return ret;
> > +
> > +	pgoff = (vmf->address - vma->vm_start) >> PAGE_SHIFT;
> > +	pfn = PHYS_PFN(memregion->memphys) + pgoff;
> 
> The core fault code seems to calculate the BAR offset in vma_to_pfn()
> which is missing here.
> 
> pgoff = vma->vm_pgoff &
>                 ((1U << (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT)) - 1);

Yes, that should be included for this reason:

> Is the assumption here is user space will always map at BAR offset 0?

It should not be assumed.

Jason

