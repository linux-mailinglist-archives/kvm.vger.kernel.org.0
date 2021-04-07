Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FA5356D0A
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 15:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344460AbhDGNQ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 09:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238715AbhDGNQ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 09:16:58 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E58C06175F
        for <kvm@vger.kernel.org>; Wed,  7 Apr 2021 06:16:47 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id d13so28458554lfg.7
        for <kvm@vger.kernel.org>; Wed, 07 Apr 2021 06:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CmyaBzs5rlfBlw22o3owRG9Y4teAsM7bByweP2c2pew=;
        b=hAGa9tnA5T5yXXeWlB51m9BDzK9gGtUXYJp31MsTp7EQg67tZAd00aancY6iyeMRBY
         tBorsdqfxjDCmtY0/RhsEE7KeveKqez9ZZXrC4hXCcf634xF9y/GJNbjqk8hmNd0GlK7
         VG9A2wHv36ouHY0YbtPjeOfn5avynYWAzdHqcZuIGu7mfh4BNRkvSXvPdUIIR8B0KOLf
         3T46aOhdFpftq6uJ4lBvUKr2NvuTF31wb7RfM0B6OMSDQHu+7ryCLjnjkHmRecvoe8Ej
         6hRRNUO0sa9YnUM0wVwoOwtGP/zaIT67UIhoW3wmpyxAfTlTYZqJK0n/gEwm7lppY/Zb
         5Gfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CmyaBzs5rlfBlw22o3owRG9Y4teAsM7bByweP2c2pew=;
        b=k9IPvWl66kBYRHGxZ9+nuSpTnLjrU4amMrwJzarKe7osS1Ji9TrsfFOGoniSKZxNfc
         XrcPX44MkYq3M93TiXwAU2NsDXAvcImU/E/646n7C7li0CRzBSCsj5q18ZVSOcTiIJim
         PnnNzeBiIWF+a6ZbEHJrwYj8XKkqZcllr+n8lLYwSIeTYSNrfoEvO48WR2Yn2WxXm+7I
         i5d/MEfkD0sVCKHyqTnYLGgQxWNDCqS+JrzvrYI6v3m2hHG36QZBGbO5vsPH049mhtlv
         NvQ2eoArNpm6tqbarbv9cebEeTsd5G21Q3NfrFziZoHIIv3WqOCKKS5fi3TTjAXx+9sa
         6hIg==
X-Gm-Message-State: AOAM533K4NqJ3FfAvmGsMXhnHCDgS2eQwVHIQMuPt9zjBCAcWwTNQFvK
        fvVGC/LrJmUY2gjOS0Ww+A8GYg==
X-Google-Smtp-Source: ABdhPJx1Cx5EZEnhUgLjREb/wy12U37HUpofuTHze5WAX/Y5AuDbDUJdubYX85KooKXYMsvjVl2pPg==
X-Received: by 2002:a05:6512:504:: with SMTP id o4mr2351551lfb.438.1617801405426;
        Wed, 07 Apr 2021 06:16:45 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id r3sm2533152ljn.13.2021.04.07.06.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 06:16:44 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 58847102413; Wed,  7 Apr 2021 16:16:47 +0300 (+03)
Date:   Wed, 7 Apr 2021 16:16:47 +0300
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
Message-ID: <20210407131647.djajbwhqsmlafsyo@box.shutemov.name>
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
 <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
 <c5f2580d-0733-4523-d1e8-c43b487f0aaf@redhat.com>
 <52518f09-7350-ebe9-7ddb-29095cd3a4d9@intel.com>
 <d94d3042-098a-8df7-9ef6-b869851a4134@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d94d3042-098a-8df7-9ef6-b869851a4134@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021 at 04:57:46PM +0200, David Hildenbrand wrote:
> On 06.04.21 16:33, Dave Hansen wrote:
> > On 4/6/21 12:44 AM, David Hildenbrand wrote:
> > > On 02.04.21 17:26, Kirill A. Shutemov wrote:
> > > > TDX architecture aims to provide resiliency against confidentiality and
> > > > integrity attacks. Towards this goal, the TDX architecture helps enforce
> > > > the enabling of memory integrity for all TD-private memory.
> > > > 
> > > > The CPU memory controller computes the integrity check value (MAC) for
> > > > the data (cache line) during writes, and it stores the MAC with the
> > > > memory as meta-data. A 28-bit MAC is stored in the ECC bits.
> > > > 
> > > > Checking of memory integrity is performed during memory reads. If
> > > > integrity check fails, CPU poisones cache line.
> > > > 
> > > > On a subsequent consumption (read) of the poisoned data by software,
> > > > there are two possible scenarios:
> > > > 
> > > >    - Core determines that the execution can continue and it treats
> > > >      poison with exception semantics signaled as a #MCE
> > > > 
> > > >    - Core determines execution cannot continue,and it does an unbreakable
> > > >      shutdown
> > > > 
> > > > For more details, see Chapter 14 of Intel TDX Module EAS[1]
> > > > 
> > > > As some of integrity check failures may lead to system shutdown host
> > > > kernel must not allow any writes to TD-private memory. This requirment
> > > > clashes with KVM design: KVM expects the guest memory to be mapped into
> > > > host userspace (e.g. QEMU).
> > > 
> > > So what you are saying is that if QEMU would write to such memory, it
> > > could crash the kernel? What a broken design.
> > 
> > IMNHO, the broken design is mapping the memory to userspace in the first
> > place.  Why the heck would you actually expose something with the MMU to
> > a context that can't possibly meaningfully access or safely write to it?
> 
> I'd say the broken design is being able to crash the machine via a simple
> memory write, instead of only crashing a single process in case you're doing
> something nasty. From the evaluation of the problem it feels like this was a
> CPU design workaround: instead of properly cleaning up when it gets tricky
> within the core, just crash the machine. And that's a CPU "feature", not a
> kernel "feature". Now we have to fix broken HW in the kernel - once again.
> 
> However, you raise a valid point: it does not make too much sense to to map
> this into user space. Not arguing against that; but crashing the machine is
> just plain ugly.
> 
> I wonder: why do we even *want* a VMA/mmap describing that memory? Sounds
> like: for hacking support for that memory type into QEMU/KVM.
> 
> This all feels wrong, but I cannot really tell how it could be better. That
> memory can really only be used (right now?) with hardware virtualization
> from some point on. From that point on (right from the start?), there should
> be no VMA/mmap/page tables for user space anymore.
> 
> Or am I missing something? Is there still valid user space access?

There is. For IO (e.g. virtio) the guest mark a range of memory as shared
(or unencrypted for AMD SEV). The range is not pre-defined.

> > This started with SEV.  QEMU creates normal memory mappings with the SEV
> > C-bit (encryption) disabled.  The kernel plumbs those into NPT, but when
> > those are instantiated, they have the C-bit set.  So, we have mismatched
> > mappings.  Where does that lead?  The two mappings not only differ in
> > the encryption bit, causing one side to read gibberish if the other
> > writes: they're not even cache coherent.
> > 
> > That's the situation *TODAY*, even ignoring TDX.
> > 
> > BTW, I'm pretty sure I know the answer to the "why would you expose this
> > to userspace" question: it's what QEMU/KVM did alreadhy for
> > non-encrypted memory, so this was the quickest way to get SEV working.
> > 
> 
> Yes, I guess so. It was the fastest way to "hack" it into QEMU.
> 
> Would we ever even want a VMA/mmap/process page tables for that memory? How
> could user space ever do something *not so nasty* with that memory (in the
> current context of VMs)?

In the future, the memory should be still managable by host MM: migration,
swapping, etc. But it's long way there. For now, the guest memory
effectively pinned on the host.

-- 
 Kirill A. Shutemov
