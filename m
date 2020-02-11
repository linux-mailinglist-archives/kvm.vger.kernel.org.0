Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB1215955C
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 17:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730864AbgBKQuk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 11:50:40 -0500
Received: from mail-qv1-f68.google.com ([209.85.219.68]:44391 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbgBKQuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 11:50:39 -0500
Received: by mail-qv1-f68.google.com with SMTP id n8so5264066qvg.11
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2020 08:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Jd5i4mX/Ogg4/ff2n6qJB7i2iFOPG1CrXa+uEUO9qsw=;
        b=ifBMmXPW/zhL2PKm3FCrxT+p/6/F3wl9Kh2h+E5xu7Q2TD9qIPdzdgI8LOYyye3FRr
         UtUBpmAtJ5follDHdD7SjZSZJGIh/ElsRSNlPKYJGDm6Uc7aM3xB468XblcMzBoTh6+j
         d0kT2iJCbTsVnzeZqaXmiAsbbTrcaLDK5yrV0fr0hi36Nqpkqn78C+d0FDkn4OmBg1nH
         +4J2crlppYnJKhtPKq6MpYFYYhz6L4hd/n8C0G8QoMdCooies8demjKz57mNc9gwuHqd
         iFKcwsUCFKfcOjmcSUVqeuUAUMws9OsTOw/EUB4jt7cIljVzgx4W0yBnZwk0+X8slKI6
         QdgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Jd5i4mX/Ogg4/ff2n6qJB7i2iFOPG1CrXa+uEUO9qsw=;
        b=qu4BrkclM/kBpDFDrxRaq0JjbfVj2C6FCK/K/RP6PJAhHmDVHRixSICPI4jLsAhZVW
         2F8gxnICf4UgL9T29i8yDcqHGQzlb9NUgmE9Bpuc+s/HfiPYblHelqMxs+SktZNjP3cW
         KHNePSbHc9MGgTqeSwlvoclu37A6LLRWpYbHah6NT2i+/AmRfH1O+sDFy8K9391a9/G/
         6iX+9hnWVu9v0Yo9wCFpJGAV+8P1kwCaHzML3z64T3OzRc61HhraUpGAnqtR2r8V9zkg
         PTe3sbrhPJ8vbijtTIFZLLLCSiCeKqoQ96jus7Q15wM/kVODbbw3hu9N+8ckOkD2zzSm
         ac5w==
X-Gm-Message-State: APjAAAUw+54iYiTLmTVL5cwRhU8DCW+1G8bpxzdwcrTfZtKH3X8dVzxV
        J7u+afHHXpEFWaaInYOLvJ47ng==
X-Google-Smtp-Source: APXvYqycWT/ED4KtAEPXSOdv+cBO6MkaZONwPU4iRoEq6Z7Ai40GB4O1dCWxrG5iz5rmSQk0gWbZzw==
X-Received: by 2002:ad4:4c08:: with SMTP id bz8mr15982924qvb.241.1581439838304;
        Tue, 11 Feb 2020 08:50:38 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id o6sm2206759qkk.53.2020.02.11.08.50.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Feb 2020 08:50:37 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1j1Yk9-0002J8-7b; Tue, 11 Feb 2020 12:50:37 -0400
Date:   Tue, 11 Feb 2020 12:50:37 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     linux-nvdimm@lists.01.org, Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Nikita Leshenko <nikita.leshchenko@oracle.com>,
        Barret Rhoden <brho@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC 09/10] vfio/type1: Use follow_pfn for VM_FPNMAP VMAs
Message-ID: <20200211165037.GA22564@ziepe.ca>
References: <20200110190313.17144-1-joao.m.martins@oracle.com>
 <20200110190313.17144-10-joao.m.martins@oracle.com>
 <20200207210831.GA31015@ziepe.ca>
 <98351044-a710-1d52-f030-022eec89d1d5@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <98351044-a710-1d52-f030-022eec89d1d5@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 11, 2020 at 04:23:49PM +0000, Joao Martins wrote:
> On 2/7/20 9:08 PM, Jason Gunthorpe wrote:
> > On Fri, Jan 10, 2020 at 07:03:12PM +0000, Joao Martins wrote:
> >> From: Nikita Leshenko <nikita.leshchenko@oracle.com>
> >>
> >> Unconditionally interpreting vm_pgoff as a PFN is incorrect.
> >>
> >> VMAs created by /dev/mem do this, but in general VM_PFNMAP just means
> >> that the VMA doesn't have an associated struct page and is being managed
> >> directly by something other than the core mmu.
> >>
> >> Use follow_pfn like KVM does to find the PFN.
> >>
> >> Signed-off-by: Nikita Leshenko <nikita.leshchenko@oracle.com>
> >>  drivers/vfio/vfio_iommu_type1.c | 6 +++---
> >>  1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >> index 2ada8e6cdb88..1e43581f95ea 100644
> >> +++ b/drivers/vfio/vfio_iommu_type1.c
> >> @@ -362,9 +362,9 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
> >>  	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
> >>  
> >>  	if (vma && vma->vm_flags & VM_PFNMAP) {
> >> -		*pfn = ((vaddr - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
> >> -		if (is_invalid_reserved_pfn(*pfn))
> >> -			ret = 0;
> >> +		ret = follow_pfn(vma, vaddr, pfn);
> >> +		if (!ret && !is_invalid_reserved_pfn(*pfn))
> >> +			ret = -EOPNOTSUPP;
> >>  	}
> > 
> > FWIW this existing code is a huge hack and a security problem.
> > 
> > I'm not sure how you could be successfully using this path on actual
> > memory without hitting bad bugs?
> > 
> ATM I think this codepath is largelly hit at the moment for MMIO (GPU
> passthrough, or mdev). In the context of this patch, guest memory would be
> treated similarly meaning the device-dax backing memory wouldn't have a 'struct
> page' (as introduced in this series).

I think it is being used specifically to allow two VFIO's to be
inserted into a VM and have the IOMMU setup to allow MMIO access.

> > Fudamentally VFIO can't retain a reference to a page from within a VMA
> > without some kind of recount/locking/etc to allow the thing that put
> > the page there to know it is still being used (ie programmed in a
> > IOMMU) by VFIO.
> > 
> > Otherwise it creates use-after-free style security problems on the
> > page.
>
> I take it you're referring to the past problems with long term page pinning +
> fsdax? Or you had something else in mind, perhaps related to your LSFMM topic?

No. I'm refering to retaining access to memory backed a VMA without
holding any kind of locking on it. This is an access after free scenario.

It *should* be like a long term page pin so that the VMA owner knows
something is happening.
 
> Here the memory can't be used by the kernel (and there's no struct page) except
> from device-dax managing/tearing/driving the pfn region (which is static and the
> underlying PFNs won't change throughout device lifetime), and vfio
> pinning/unpinning the pfns (which are refcounted against multiple map/unmaps);

For instance if you tear down the device-dax then VFIO will happily
continue to reference the memory. This is a bug.

There are other cases that escalate to security bugs.

> > This code needs to be deleted, not extended :(
> 
> To some extent it isn't really an extension: the patch was just removing the
> assumption @vm_pgoff being the 'start pfn' on PFNMAP vmas. This is also
> similarly done by get_vaddr_frames().

You are extending it in the sense that you plan to use it for more
cases than VMAs created by some other VFIO. That should not be
done as it will only complicate fixing this code.

KVM is allowed to use follow_pfn because it uses MMU notifiers and
does not allow the result of follow_pfn to outlive the VMA (AFAIK at
least). So it should be safe.

Jason
