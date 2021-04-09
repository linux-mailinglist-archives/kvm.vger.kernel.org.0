Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC326359FE0
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 15:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233604AbhDINeG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 09:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233552AbhDINeF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 09:34:05 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F4C0C061760
        for <kvm@vger.kernel.org>; Fri,  9 Apr 2021 06:33:51 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id w28so9738378lfn.2
        for <kvm@vger.kernel.org>; Fri, 09 Apr 2021 06:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+pHQi2OzKPyPC0KIDsVeHvTEz5QYwkp15iNvMnsgf9c=;
        b=qmgSCtmourr9L2RlDFZgGr4egPrINyGU02cvXp0bbLU/zh8hYLJR8gXLKqNI4rVRfJ
         Y216MNdtd9ViTgOGuvoA2McTPPYzN0win0s9md94sOKiqH2TEjZY3SVXFR816pgHmWIj
         RJpmJtHdZG+harWrFFsinPRs7DedCERbBb/Phy3ALRYSDN+7W4FegvBBC1Q9iE2jUsbU
         J9RsxSre6uR+dDfvM0SbyPOCbKo8C8dLPayB43e/MzuBtfwuvoGEHn+kEZQKJvqQBCz8
         RJbvO2AHT87yb4G5GXW6K6QwzW/fRa02DLSME+nD2WtO0RwDg5nzWQPhXPzcqRCURtWK
         NuWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+pHQi2OzKPyPC0KIDsVeHvTEz5QYwkp15iNvMnsgf9c=;
        b=Fu6L1pDP7nMfUeQwaWCFD4no4RWwjPHqWyjcUJpfKUTEGQNpjKJytpUGzPpoxs8P42
         kDa3/DujLxwbETGiquv9kXpZ9njtLeBcf4WNDvQpUrKeAdjXLvjiMPXvhS1SjlODX52U
         OCNL2gHKOif/l/aPm56tnWcoWa/rmEg42GPsEKIrvFSJnvDVGDCKQS513qzcgHoroPeo
         BSunvMqrV6rpzWNKAgK8c4vCfQYghwF58TTa9jjbJJWNjLwrBKsj7sp7Ld6xwNqym1H/
         GtMDPfEUbehhMuZd2c9P1REi4P/XdVZ/hBbFxYFBAJ5GYLN3lQOtvtFYzVDEu3w9zmfq
         yDzQ==
X-Gm-Message-State: AOAM530UZvl1wuD2kGfG9DHQNLOGLNVIYKZGXn2JRMNOLj/myDH2CYIn
        fqCKL7+iyVscNmgy51GnELm7XA==
X-Google-Smtp-Source: ABdhPJynjRSJthCRwTX5vDn44O6h7SJMm8/0v0Lujd09ADcCsNIQoU7fugG96bOELQBpOXbWEJf18g==
X-Received: by 2002:a05:6512:3091:: with SMTP id z17mr10257535lfd.84.1617975229701;
        Fri, 09 Apr 2021 06:33:49 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id z9sm282834lfa.80.2021.04.09.06.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Apr 2021 06:33:48 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id F213F102498; Fri,  9 Apr 2021 16:33:47 +0300 (+03)
Date:   Fri, 9 Apr 2021 16:33:47 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     David Hildenbrand <david@redhat.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
Message-ID: <20210409133347.r2uf3u5g55pp27xn@box>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
 <5e934d94-414c-90de-c58e-34456e4ab1cf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e934d94-414c-90de-c58e-34456e4ab1cf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 04:55:54PM +0200, David Hildenbrand wrote:
> On 02.04.21 17:26, Kirill A. Shutemov wrote:
> > TDX architecture aims to provide resiliency against confidentiality and
> > integrity attacks. Towards this goal, the TDX architecture helps enforce
> > the enabling of memory integrity for all TD-private memory.
> > 
> > The CPU memory controller computes the integrity check value (MAC) for
> > the data (cache line) during writes, and it stores the MAC with the
> > memory as meta-data. A 28-bit MAC is stored in the ECC bits.
> > 
> > Checking of memory integrity is performed during memory reads. If
> > integrity check fails, CPU poisones cache line.
> > 
> > On a subsequent consumption (read) of the poisoned data by software,
> > there are two possible scenarios:
> > 
> >   - Core determines that the execution can continue and it treats
> >     poison with exception semantics signaled as a #MCE
> > 
> >   - Core determines execution cannot continue,and it does an unbreakable
> >     shutdown
> > 
> > For more details, see Chapter 14 of Intel TDX Module EAS[1]
> > 
> > As some of integrity check failures may lead to system shutdown host
> > kernel must not allow any writes to TD-private memory. This requirment
> > clashes with KVM design: KVM expects the guest memory to be mapped into
> > host userspace (e.g. QEMU).
> > 
> > This patch aims to start discussion on how we can approach the issue.
> > 
> > For now I intentionally keep TDX out of picture here and try to find a
> > generic way to unmap KVM guest memory from host userspace. Hopefully, it
> > makes the patch more approachable. And anyone can try it out.
> > 
> > To the proposal:
> > 
> > Looking into existing codepaths I've discovered that we already have
> > semantics we want. That's PG_hwpoison'ed pages and SWP_HWPOISON swap
> > entries in page tables:
> > 
> >    - If an application touches a page mapped with the SWP_HWPOISON, it will
> >      get SIGBUS.
> > 
> >    - GUP will fail with -EFAULT;
> > 
> > Access the poisoned memory via page cache doesn't match required
> > semantics right now, but it shouldn't be too hard to make it work:
> > access to poisoned dirty pages should give -EIO or -EHWPOISON.
> > 
> > My idea is that we can mark page as poisoned when we make it TD-private
> > and replace all PTEs that map the page with SWP_HWPOISON.
> 
> It looks quite hacky (well, what did I expect from an RFC :) ) you can no
> longer distinguish actually poisoned pages from "temporarily poisoned"
> pages. FOLL_ALLOW_POISONED sounds especially nasty and dangerous -  "I want
> to read/write a poisoned page, trust me, I know what I am doing".
> 
> Storing the state for each individual page initially sounded like the right
> thing to do, but I wonder if we couldn't handle this on a per-VMA level. You
> can just remember the handful of shared ranges internally like you do right
> now AFAIU.

per-VMA would not fly for file-backed (e.g. tmpfs) memory. We may need to
combine PG_hwpoison with VMA flag. Maybe per-inode tracking would also be
required. Or per-memslot. I donno. Need more experiments.

Note, I use PG_hwpoison now, but if we find a show-stopper issue where we
would see confusion with a real poison, we can switch to new flags and
a new swap_type(). I have not seen a reason yet.

> From what I get, you want a way to
> 
> 1. Unmap pages from the user space page tables.

Plain unmap would not work for some use-cases. Some CSPs want to
preallocate memory in a specific way. It's a way to provide a fine-grained
NUMA policy.

The existing mapping has to be converted.

> 2. Disallow re-faulting of the protected pages into the page tables. On user
> space access, you want to deliver some signal (e.g., SIGBUS).

Note that userspace mapping is the only source of pfn's for VM's shadow
mapping. The fault should be allow, but lead to non-present PTE that still
encodes pfn.

> 3. Allow selected users to still grab the pages (esp. KVM to fault them into
> the page tables).

As long as fault leads to non-present PTEs we are fine. Usespace still may
want to mlock() some of guest memory. There's no reason to prevent this.

> 4. Allow access to currently shared specific pages from user space.
> 
> Right now, you achieve
> 
> 1. Via try_to_unmap()
> 2. TestSetPageHWPoison
> 3. TBD (e.g., FOLL_ALLOW_POISONED)
> 4. ClearPageHWPoison()
> 
> 
> If we could bounce all writes to shared pages through the kernel, things
> could end up a little easier. Some very rough idea:
> 
> We could let user space setup VM memory as
> mprotect(PROT_READ) (+ PROT_KERNEL_WRITE?), and after activating protected
> memory (I assume via a KVM ioctl), make sure the VMAs cannot be set to
> PROT_WRITE anymore. This would already properly unmap and deliver a SIGSEGV
> when trying to write from user space.
> 
> You could then still access the pages, e.g., via FOLL_FORCE or a new fancy
> flag that allows to write with VM_MAYWRITE|VM_DENYUSERWRITE. This would
> allow an ioctl to write page content and to map the pages into NPTs.
> 
> As an extension, we could think about (re?)mapping some shared pages
> read|write. The question is how to synchronize with user space.
> 
> I have no idea how expensive would be bouncing writes (and reads?) through
> the kernel. Did you ever experiment with that/evaluate that?

It's going to be double bounce buffer: on the guest we force swiotlb to
make it go through shared region. I don't think it's a good idea.

There are a number of way to share a memory. It's going to be decided by
the way we get these pages unmapped in the first place.

-- 
 Kirill A. Shutemov
