Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9463D356EDB
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353045AbhDGOgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236166AbhDGOgY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 10:36:24 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A11F4C061756
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 07:36:12 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id d12so28878784lfv.11
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 07:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=aa4BFGHeJpWbGPL64/HwJte9ItGkmlkla6N09Ehy3vY=;
        b=ljbxVtnHP8ri2YPVz8de3UsCo/is8F+oxtmfACHwDUFjYSmDsNzacNntMNrovvMlKY
         jJhfl18ykDCxEfyh4kLYYjL/mztDwKrSJeQ6rk5ZIg6etOdfARM8NJAbAMTtj1UiHXXg
         VM00xfwsPPnB59WZ1mah9pWk1ud9ttQjcXQGc94H0aEf5TwSv2ZBPVTSC6n6atnSSGPK
         AhLNxZsuO2OXWKjtAufTZy4fsHpQWjbUznNoxXI5LMN0shPHuSrX1JndEqlIs+e5+Bpt
         xwZ6t2WxoW7DtYeVL3CU5NhwiFW+5XQwjMA392AwK4l0SV2yRQr1Vgmueje473HgzJAK
         iTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=aa4BFGHeJpWbGPL64/HwJte9ItGkmlkla6N09Ehy3vY=;
        b=L+nfDG/A9Qz2pIgCiHCssq+OZtv+XvSdFXkWYVNhD1Q4I1tNmP6qwD70sGIyOimLIt
         oda6zUjxjh1WbN2Hc8AdI6OSxo3uHnKkqxSdjHfgq500vsaNJ4z3oEv0a3gfV1EHmHY2
         yfoplgucNYdn3toUxod++oT9peFPiVO46cXI8OxtqL+sKRes5mpBMXzlap3eNOAkCMuU
         hjeu4y1AagBYcorySlUKSNLMWIFt0tnnY1dAVxNmX+2XC+2FuMN+4TTOQdOsJfxNzN7M
         LHHxWjDqvYuykdQK7rgBxZv7TbTTHrbehIdpI7+S8NepDe7SKsnV38mTf8vuRwkptT7c
         S+og==
X-Gm-Message-State: AOAM530eyh5/p2ZZaPNV/2+QHvICVljqJjumD5oE5HRVA4UXgjhv8dAD
        R9DmQ8CxHS1dEeEaRML5KXhKIw==
X-Google-Smtp-Source: ABdhPJwCuVZNiYL6VMzHS8fpF/jYx19BLzehtjDwRhlxyJnUiJZyIadz/Wtjv+XhngbgJAo1LNLlwA==
X-Received: by 2002:a19:6518:: with SMTP id z24mr2683654lfb.512.1617806171034;
        Wed, 07 Apr 2021 07:36:11 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id v20sm2478516ljh.105.2021.04.07.07.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 07:36:10 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 7EA8D102413; Wed,  7 Apr 2021 17:36:13 +0300 (+03)
Date:   Wed, 7 Apr 2021 17:36:13 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     David Hildenbrand <david@redhat.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
Message-ID: <20210407143613.4inmmgjh2qo5avfh@box.shutemov.name>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
 <c5f2580d-0733-4523-d1e8-c43b487f0aaf@redhat.com>
 <52518f09-7350-ebe9-7ddb-29095cd3a4d9@intel.com>
 <d94d3042-098a-8df7-9ef6-b869851a4134@redhat.com>
 <20210407131647.djajbwhqsmlafsyo@box.shutemov.name>
 <9c81fac4-9ac3-46d9-9ac6-da91312ad21b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9c81fac4-9ac3-46d9-9ac6-da91312ad21b@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 07, 2021 at 04:09:35PM +0200, David Hildenbrand wrote:
> On 07.04.21 15:16, Kirill A. Shutemov wrote:
> > On Tue, Apr 06, 2021 at 04:57:46PM +0200, David Hildenbrand wrote:
> > > On 06.04.21 16:33, Dave Hansen wrote:
> > > > On 4/6/21 12:44 AM, David Hildenbrand wrote:
> > > > > On 02.04.21 17:26, Kirill A. Shutemov wrote:
> > > > > > TDX architecture aims to provide resiliency against confidentiality and
> > > > > > integrity attacks. Towards this goal, the TDX architecture helps enforce
> > > > > > the enabling of memory integrity for all TD-private memory.
> > > > > > 
> > > > > > The CPU memory controller computes the integrity check value (MAC) for
> > > > > > the data (cache line) during writes, and it stores the MAC with the
> > > > > > memory as meta-data. A 28-bit MAC is stored in the ECC bits.
> > > > > > 
> > > > > > Checking of memory integrity is performed during memory reads. If
> > > > > > integrity check fails, CPU poisones cache line.
> > > > > > 
> > > > > > On a subsequent consumption (read) of the poisoned data by software,
> > > > > > there are two possible scenarios:
> > > > > > 
> > > > > >     - Core determines that the execution can continue and it treats
> > > > > >       poison with exception semantics signaled as a #MCE
> > > > > > 
> > > > > >     - Core determines execution cannot continue,and it does an unbreakable
> > > > > >       shutdown
> > > > > > 
> > > > > > For more details, see Chapter 14 of Intel TDX Module EAS[1]
> > > > > > 
> > > > > > As some of integrity check failures may lead to system shutdown host
> > > > > > kernel must not allow any writes to TD-private memory. This requirment
> > > > > > clashes with KVM design: KVM expects the guest memory to be mapped into
> > > > > > host userspace (e.g. QEMU).
> > > > > 
> > > > > So what you are saying is that if QEMU would write to such memory, it
> > > > > could crash the kernel? What a broken design.
> > > > 
> > > > IMNHO, the broken design is mapping the memory to userspace in the first
> > > > place.  Why the heck would you actually expose something with the MMU to
> > > > a context that can't possibly meaningfully access or safely write to it?
> > > 
> > > I'd say the broken design is being able to crash the machine via a simple
> > > memory write, instead of only crashing a single process in case you're doing
> > > something nasty. From the evaluation of the problem it feels like this was a
> > > CPU design workaround: instead of properly cleaning up when it gets tricky
> > > within the core, just crash the machine. And that's a CPU "feature", not a
> > > kernel "feature". Now we have to fix broken HW in the kernel - once again.
> > > 
> > > However, you raise a valid point: it does not make too much sense to to map
> > > this into user space. Not arguing against that; but crashing the machine is
> > > just plain ugly.
> > > 
> > > I wonder: why do we even *want* a VMA/mmap describing that memory? Sounds
> > > like: for hacking support for that memory type into QEMU/KVM.
> > > 
> > > This all feels wrong, but I cannot really tell how it could be better. That
> > > memory can really only be used (right now?) with hardware virtualization
> > > from some point on. From that point on (right from the start?), there should
> > > be no VMA/mmap/page tables for user space anymore.
> > > 
> > > Or am I missing something? Is there still valid user space access?
> > 
> > There is. For IO (e.g. virtio) the guest mark a range of memory as shared
> > (or unencrypted for AMD SEV). The range is not pre-defined.
> > 
> 
> Ah right, rings a bell. One obvious alternative would be to let user space
> only explicitly map what is shared and can be safely accessed, instead of
> doing it the other way around. But that obviously requires more thought/work
> and clashes with future MM changes you discuss below.

IIUC, HyperV's VMBus uses pre-defined range that communicated through
ACPI. KVM/virtio can do the same in theory, but it would require changes
in the existing driver model.

> > > > This started with SEV.  QEMU creates normal memory mappings with the SEV
> > > > C-bit (encryption) disabled.  The kernel plumbs those into NPT, but when
> > > > those are instantiated, they have the C-bit set.  So, we have mismatched
> > > > mappings.  Where does that lead?  The two mappings not only differ in
> > > > the encryption bit, causing one side to read gibberish if the other
> > > > writes: they're not even cache coherent.
> > > > 
> > > > That's the situation *TODAY*, even ignoring TDX.
> > > > 
> > > > BTW, I'm pretty sure I know the answer to the "why would you expose this
> > > > to userspace" question: it's what QEMU/KVM did alreadhy for
> > > > non-encrypted memory, so this was the quickest way to get SEV working.
> > > > 
> > > 
> > > Yes, I guess so. It was the fastest way to "hack" it into QEMU.
> > > 
> > > Would we ever even want a VMA/mmap/process page tables for that memory? How
> > > could user space ever do something *not so nasty* with that memory (in the
> > > current context of VMs)?
> > 
> > In the future, the memory should be still managable by host MM: migration,
> > swapping, etc. But it's long way there. For now, the guest memory
> 
> I was involved in the s390x implementation where this already works, simply
> because whenever encrypted memory is read/written from the hypervisor, you
> simple read/write the encrypted data; once the VM accesses that memory, it
> reads/writes unencrypted memory. For this reason, migration, swapping etc.
> works fairly naturally.

In TDX case, the encryption tied to the physical address of the encrypted
block. Moving the block to other place in memory would produce garbage.
It's done intentionally to protected against replay attack.

> I do wonder how x86-64 wants to tackle that; In the far future, will it be
> valid to again read/write encrypted memory, especially from user space?
>

It would require assistance from the guest and/or TDX module.

-- 
 Kirill A. Shutemov
