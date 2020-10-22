Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A2129595C
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 09:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2508709AbgJVHjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 03:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2506731AbgJVHjs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 03:39:48 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDF91C0613D5
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 00:39:47 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e17so846082wru.12
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 00:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ffwll.ch; s=google;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=FUnmmeK5QmN6I6X95NR6HhlReLcd0WiZp6VBOWMixY8=;
        b=E/MPYUGexYpX5poBWZtyJ39mlDhFG9B6MQdMbkqfAlosbuXR0KbLsXkH8XsRroHwK0
         /z7PTmxv54Le3uyVqgU2BJoYAcDBAKDf93cFoIPUObTp1nwUXkwW9LrbIa/QW11E9gxi
         dUfc5MnZ1w7Z5dq/D5VWhQ+QyH68LGgtFOW8g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=FUnmmeK5QmN6I6X95NR6HhlReLcd0WiZp6VBOWMixY8=;
        b=Wyw9Fe+6CTXJIoULJ9WIHoIVWAI4srBd3pCzWmkjwwvw3BO+ogu2e1qHWwTA3bpLfe
         uMzkKDJrGEmLNJ8h3McOLW3p8yefC3OaghCleWqpAeOzT7xRlyLzmPpxZzTJH3YKh2co
         qlTF94FaWigX0bxioPWLKpuT7V4h6M+GTfIJxJgqeMgvmByDe0By9jgVALjIwjMagJv8
         C56HDbKMNRXVjvHZamWdpmPP+rVMq0HjZfHrmmVN/s6r3iuw28GIF7/Gvr2itmzgo1j5
         SLF49OLVPURFs93kNyJWZqBONnGoph7kyyNIpXfSLJJpA/glGlJkdlKctsZv+UkKMx9G
         iFVw==
X-Gm-Message-State: AOAM531Rp+B+LZ/gGNpc2yK4BjOzuM8OslAoH9rY7S8qAhGOXR3wtVPO
        IRxa9ebyiRn6cmWz3IUV0XidYw==
X-Google-Smtp-Source: ABdhPJw5HQV9NuUaTW2fOSG+4dZhqrMNCjk+Neg7/gkBYNKwDOO+9vGK8A43OgHPliV3xlB5PKsA7A==
X-Received: by 2002:adf:f986:: with SMTP id f6mr1319485wrr.38.1603352386434;
        Thu, 22 Oct 2020 00:39:46 -0700 (PDT)
Received: from phenom.ffwll.local ([2a02:168:57f4:0:efd0:b9e5:5ae6:c2fa])
        by smtp.gmail.com with ESMTPSA id j7sm2061526wrn.81.2020.10.22.00.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 00:39:45 -0700 (PDT)
Date:   Thu, 22 Oct 2020 09:39:43 +0200
From:   Daniel Vetter <daniel@ffwll.ch>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2 08/17] s390/pci: Remove races against pte updates
Message-ID: <20201022073943.GS401619@phenom.ffwll.local>
Mail-Followup-To: Niklas Schnelle <schnelle@linux.ibm.com>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Dan Williams <dan.j.williams@intel.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        John Hubbard <jhubbard@nvidia.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>
References: <20201009075934.3509076-1-daniel.vetter@ffwll.ch>
 <20201009075934.3509076-9-daniel.vetter@ffwll.ch>
 <6deb08dd-46f3-bf26-5362-fdc696f6fd74@linux.ibm.com>
 <20201012141906.GX438822@phenom.ffwll.local>
 <3594c115-541f-806a-ee33-e99a2d1d31e8@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3594c115-541f-806a-ee33-e99a2d1d31e8@linux.ibm.com>
X-Operating-System: Linux phenom 5.7.0-1-amd64 
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 21, 2020 at 09:55:57AM +0200, Niklas Schnelle wrote:
> Hi Daniel,
> 
> friendly ping. I haven't seen a new version of this patch series,
> as I said I think your change for s390/pci is generally useful so
> I'm curious, are you planning on sending a new version soon?
> If you want you can also just sent this patch with the last few
> nitpicks (primarily the mail address) fixed and I'll happily apply.

(I think this was stuck somewhere in moderation, only showed up just now)

I was waiting for the testing result for the habana driver from Oded, but
I guess Oded was waiting for v3. Hence the delay.

Cheers, Daniel

> 
> Best regards,
> Niklas Schnelle
> 
> On 10/12/20 4:19 PM, Daniel Vetter wrote:
> > On Mon, Oct 12, 2020 at 04:03:28PM +0200, Niklas Schnelle wrote:
> ... snip ....
> >>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> >>> Cc: Dan Williams <dan.j.williams@intel.com>
> >>> Cc: Kees Cook <keescook@chromium.org>
> >>> Cc: Andrew Morton <akpm@linux-foundation.org>
> >>> Cc: John Hubbard <jhubbard@nvidia.com>
> >>> Cc: Jérôme Glisse <jglisse@redhat.com>
> >>> Cc: Jan Kara <jack@suse.cz>
> >>> Cc: Dan Williams <dan.j.williams@intel.com>
> >>
> >> The above Cc: line for Dan Williams is a duplicate
> >>
> >>> Cc: linux-mm@kvack.org
> >>> Cc: linux-arm-kernel@lists.infradead.org
> >>> Cc: linux-samsung-soc@vger.kernel.org
> >>> Cc: linux-media@vger.kernel.org
> >>> Cc: Niklas Schnelle <schnelle@linux.ibm.com>
> >>> Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> >>> Cc: linux-s390@vger.kernel.org
> >>> --
> >>> v2: Move VM_IO | VM_PFNMAP checks around so they keep returning EINVAL
> >>> like before (Gerard)
> >>
> >> I think the above should go before the CC/Signed-off/Reviewev block.
> > 
> > This is a per-subsystem bikeshed :-) drivers/gpu definitely wants it
> > above, but most core subsystems want it below. I'll move it.
> > 
> >>> ---
> >>>  arch/s390/pci/pci_mmio.c | 98 +++++++++++++++++++++++-----------------
> >>>  1 file changed, 57 insertions(+), 41 deletions(-)
> >>>
> >>> diff --git a/arch/s390/pci/pci_mmio.c b/arch/s390/pci/pci_mmio.c
> >>> index 401cf670a243..1a6adbc68ee8 100644
> >>> --- a/arch/s390/pci/pci_mmio.c
> >>> +++ b/arch/s390/pci/pci_mmio.c
> >>> @@ -119,33 +119,15 @@ static inline int __memcpy_toio_inuser(void __iomem *dst,
> >>>  	return rc;
> >>>  }
> >>>  
> >>> -static long get_pfn(unsigned long user_addr, unsigned long access,
> >>> -		    unsigned long *pfn)
> >>> -{
> >>> -	struct vm_area_struct *vma;
> >>> -	long ret;
> >>> -
> >>> -	mmap_read_lock(current->mm);
> >>> -	ret = -EINVAL;
> >>> -	vma = find_vma(current->mm, user_addr);
> >>> -	if (!vma)
> >>> -		goto out;
> >>> -	ret = -EACCES;
> >>> -	if (!(vma->vm_flags & access))
> >>> -		goto out;
> >>> -	ret = follow_pfn(vma, user_addr, pfn);
> >>> -out:
> >>> -	mmap_read_unlock(current->mm);
> >>> -	return ret;
> >>> -}
> >>> -
> >>>  SYSCALL_DEFINE3(s390_pci_mmio_write, unsigned long, mmio_addr,
> >>>  		const void __user *, user_buffer, size_t, length)
> >>>  {
> >>>  	u8 local_buf[64];
> >>>  	void __iomem *io_addr;
> >>>  	void *buf;
> >>> -	unsigned long pfn;
> >>> +	struct vm_area_struct *vma;
> >>> +	pte_t *ptep;
> >>> +	spinlock_t *ptl;
> >>
> >> With checkpatch.pl --strict the above yields a complained
> >> "CHECK: spinlock_t definition without comment" but I think
> >> that's really okay since your commit description is very clear.
> >> Same oin line 277.
> > 
> > I think this is a falls positive, checkpatch doesn't realize that
> > SYSCALL_DEFINE3 is a function, not a structure. And in a structure I'd
> > have added the kerneldoc or comment.
> > 
> > I'll fix up all the nits you've found for the next round. Thanks for
> > taking a look.
> > -Daniel
> > 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
