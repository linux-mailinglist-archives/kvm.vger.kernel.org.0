Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE2501E10F4
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 16:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391034AbgEYOq7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 10:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391029AbgEYOq6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 10:46:58 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CDCC061A0E
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 07:46:58 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id z13so11353109ljn.7
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 07:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ge3nASFw5D0kEN/iXR9CvOVQFOQcrEeAVjRO6fhPUc8=;
        b=DB22HzSgwX9AldOCu5apYsRzizHnaOP3FXrs6Ll4J8OOOxl3bkdxos56kEw9/l7T4v
         NG9k4rSKMSTZeEXM115HCCEg+gajyB78HM9sA6Kp9gsIAeta1h9XHoJcgpjltn3FABxK
         KHZfcy3bgYzh6Xe8e8+MK94UyeVpIjlo1CFw26En+DG2pE8/STXwpbxoFCx9Ysw/jNgp
         NTZjgtx2YWBwi/Gp94diQK8lanQZjWWwgdJNVsUHM7gmmZggXHSRT9KWGGEh7NTBEr6D
         OWnapwJZbKy/C+4fsbVn5fbHCrjHlwjEEKkMizDujsDv0W0aOud52ir1Tecme+QR0XVV
         hzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ge3nASFw5D0kEN/iXR9CvOVQFOQcrEeAVjRO6fhPUc8=;
        b=YJDUILAXqGwCdkVEe/hHSsGzT+GwPOf0kcoHiA3J2AJwI1LekknWysw2a77XyHE2Ru
         MBb6c9T1Sg1eUJmCHmRplOGZScsrgkkCYuVLayY37x2JjFDSZVZZkUKKpQXkc9OP7Z0j
         rnU8+2xiuRPjx/QI/iT8ETtuLOKhqiOqtl8P3N551xcSpVs/kN43csMHhVYlc+NbRs2O
         XxWDC6bVDKCuRvg+oSFLUCsd8vhlvJNXq+YrN1DPGAmSnGguc2heqGAmg5vTPyiLYzV7
         g6AMR+uwx0flBvNPpdjKc78ZTLa6sHlPoMGEoQHkqSbW+g0GRzU7jJHeDr2EchJCaee9
         ndAw==
X-Gm-Message-State: AOAM533rcTowZRa6t2ozSehPhEh3qkjPGQe9U+5OXUPwTMvfmuh3rTQr
        VD7mJ//WXPeN1iG8HuM0WCb4yQ==
X-Google-Smtp-Source: ABdhPJxPCzgMGF/nVESoPuNBT575+EPidNjEbaXnnxBp45SuN1duTKLCM3mpgMNH0Ro45W7jbiC8Nw==
X-Received: by 2002:a2e:8107:: with SMTP id d7mr14344249ljg.158.1590418016358;
        Mon, 25 May 2020 07:46:56 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id g10sm3811880lja.121.2020.05.25.07.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 07:46:55 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 8D72B10230F; Mon, 25 May 2020 17:46:56 +0300 (+03)
Date:   Mon, 25 May 2020 17:46:56 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC 00/16] KVM protected memory extension
Message-ID: <20200525144656.phfxjp2qip6736fj@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <42685c32-a7a9-b971-0cf4-e8af8d9a40c6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <42685c32-a7a9-b971-0cf4-e8af8d9a40c6@oracle.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 04:47:18PM +0300, Liran Alon wrote:
> 
> On 22/05/2020 15:51, Kirill A. Shutemov wrote:
> > == Background / Problem ==
> > 
> > There are a number of hardware features (MKTME, SEV) which protect guest
> > memory from some unauthorized host access. The patchset proposes a purely
> > software feature that mitigates some of the same host-side read-only
> > attacks.
> > 
> > 
> > == What does this set mitigate? ==
> > 
> >   - Host kernel ”accidental” access to guest data (think speculation)
> 
> Just to clarify: This is any host kernel memory info-leak vulnerability. Not
> just speculative execution memory info-leaks. Also architectural ones.
> 
> In addition, note that removing guest data from host kernel VA space also
> makes guest<->host memory exploits more difficult.
> E.g. Guest cannot use already available memory buffer in kernel VA space for
> ROP or placing valuable guest-controlled code/data in general.
> 
> > 
> >   - Host kernel induced access to guest data (write(fd, &guest_data_ptr, len))
> > 
> >   - Host userspace access to guest data (compromised qemu)
> 
> I don't quite understand what is the benefit of preventing userspace VMM
> access to guest data while the host kernel can still access it.

Let me clarify: the guest memory mapped into host userspace is not
accessible by both host kernel and userspace. Host still has way to access
it via a new interface: GUP(FOLL_KVM). The GUP will give you struct page
that kernel has to map (temporarily) if need to access the data. So only
blessed codepaths would know how to deal with the memory.

It can help preventing some host->guest attack on the compromised host.
Like if an VM has successfully attacked the host it cannot attack other
VMs as easy.

It would also help to protect against guest->host attack by removing one
more places where the guest's data is mapped on the host.

> QEMU is more easily compromised than the host kernel because it's
> guest<->host attack surface is larger (E.g. Various device emulation).
> But this compromise comes from the guest itself. Not other guests. In
> contrast to host kernel attack surface, which an info-leak there can
> be exploited from one guest to leak another guest data.

Consider the case when unprivileged guest user exploits bug in a QEMU
device emulation to gain access to data it cannot normally have access
within the guest. With the feature it would able to see only other shared
regions of guest memory such as DMA and IO buffers, but not the rest.

> > 
> > == What does this set NOT mitigate? ==
> > 
> >   - Full host kernel compromise.  Kernel will just map the pages again.
> > 
> >   - Hardware attacks
> > 
> > 
> > The patchset is RFC-quality: it works but has known issues that must be
> > addressed before it can be considered for applying.
> > 
> > We are looking for high-level feedback on the concept.  Some open
> > questions:
> > 
> >   - This protects from some kernel and host userspace read-only attacks,
> >     but does not place the host kernel outside the trust boundary. Is it
> >     still valuable?
> I don't currently see a good argument for preventing host userspace access
> to guest data while host kernel can still access it.
> But there is definitely strong benefit of mitigating kernel info-leaks
> exploitable from one guest to leak another guest data.
> > 
> >   - Can this approach be used to avoid cache-coherency problems with
> >     hardware encryption schemes that repurpose physical bits?
> > 
> >   - The guest kernel must be modified for this to work.  Is that a deal
> >     breaker, especially for public clouds?
> > 
> >   - Are the costs of removing pages from the direct map too high to be
> >     feasible?
> 
> If I remember correctly, this perf cost was too high when considering XPFO
> (eXclusive Page Frame Ownership) patch-series.
> This created two major perf costs:
> 1) Removing pages from direct-map prevented direct-map from simply be
> entirely mapped as 1GB huge-pages.
> 2) Frequent allocation/free of userspace pages resulted in frequent TLB
> invalidations.
> 
> Having said that, (1) can be mitigated in case guest data is completely
> allocated from 1GB hugetlbfs to guarantee it will not
> create smaller holes in direct-map. And (2) is not relevant for QEMU/KVM
> use-case.

I'm too invested into THP to give it up to the ugly hugetlbfs. I think we
can do better :)

> This makes me wonder:
> XPFO patch-series, applied to the context of QEMU/KVM, seems to provide
> exactly the functionality of this patch-series,
> with the exception of the additional "feature" of preventing guest data from
> also being accessible to host userspace VMM.
> i.e. XPFO will unmap guest pages from host kernel direct-map while still
> keeping them mapped in host userspace VMM page-tables.
> 
> If I understand correctly, this "feature" is what brings most of the extra
> complexity of this patch-series compared to XPFO.
> It requires guest modification to explicitly specify to host which pages can
> be accessed by userspace VMM, it requires
> changes to add new VM_KVM_PROTECTED VMA flag & FOLL_KVM for GUP, and it
> creates issues with Live-Migration support.
> 
> So if there is no strong convincing argument for the motivation to prevent
> userspace VMM access to guest data *while host kernel
> can still access guest data*, I don't see a good reason for using this
> approach.

Well, I disagree with you here. See few points above.

> Furthermore, I would like to point out that just unmapping guest data from
> kernel direct-map is not sufficient to prevent all
> guest-to-guest info-leaks via a kernel memory info-leak vulnerability. This
> is because host kernel VA space have other regions
> which contains guest sensitive data. For example, KVM per-vCPU struct (which
> holds vCPU state) is allocated on slab and therefore
> still leakable.
> 
> I recommend you will have a look at my (and Alexandre Charte) KVM Forum 2019
> talk on KVM ASI which provides extensive background
> on the various attempts done by the community for mitigating host kernel
> memory info-leaks exploitable by guest to leak other guests data:
> https://static.sched.com/hosted_files/kvmforum2019/34/KVM%20Forum%202019%20KVM%20ASI.pdf

Thanks, I'll read it up.

> > == Series Overview ==
> > 
> > The hardware features protect guest data by encrypting it and then
> > ensuring that only the right guest can decrypt it.  This has the
> > side-effect of making the kernel direct map and userspace mapping
> > (QEMU et al) useless.  But, this teaches us something very useful:
> > neither the kernel or userspace mappings are really necessary for normal
> > guest operations.
> > 
> > Instead of using encryption, this series simply unmaps the memory. One
> > advantage compared to allowing access to ciphertext is that it allows bad
> > accesses to be caught instead of simply reading garbage.
> > 
> > Protection from physical attacks needs to be provided by some other means.
> > On Intel platforms, (single-key) Total Memory Encryption (TME) provides
> > mitigation against physical attacks, such as DIMM interposers sniffing
> > memory bus traffic.
> > 
> > The patchset modifies both host and guest kernel. The guest OS must enable
> > the feature via hypercall and mark any memory range that has to be shared
> > with the host: DMA regions, bounce buffers, etc. SEV does this marking via a
> > bit in the guest’s page table while this approach uses a hypercall.
> > 
> > For removing the userspace mapping, use a trick similar to what NUMA
> > balancing does: convert memory that belongs to KVM memory slots to
> > PROT_NONE: all existing entries converted to PROT_NONE with mprotect() and
> > the newly faulted in pages get PROT_NONE from the updated vm_page_prot.
> > The new VMA flag -- VM_KVM_PROTECTED -- indicates that the pages in the
> > VMA must be treated in a special way in the GUP and fault paths. The flag
> > allows GUP to return the page even though it is mapped with PROT_NONE, but
> > only if the new GUP flag -- FOLL_KVM -- is specified. Any userspace access
> > to the memory would result in SIGBUS. Any GUP access without FOLL_KVM
> > would result in -EFAULT.
> > 
> > Any anonymous page faulted into the VM_KVM_PROTECTED VMA gets removed from
> > the direct mapping with kernel_map_pages(). Note that kernel_map_pages() only
> > flushes local TLB. I think it's a reasonable compromise between security and
> > perfromance.
> > 
> > Zapping the PTE would bring the page back to the direct mapping after clearing.
> > At least for now, we don't remove file-backed pages from the direct mapping.
> > File-backed pages could be accessed via read/write syscalls. It adds
> > complexity.
> > 
> > Occasionally, host kernel has to access guest memory that was not made
> > shared by the guest. For instance, it happens for instruction emulation.
> > Normally, it's done via copy_to/from_user() which would fail with -EFAULT
> > now. We introduced a new pair of helpers: copy_to/from_guest(). The new
> > helpers acquire the page via GUP, map it into kernel address space with
> > kmap_atomic()-style mechanism and only then copy the data.
> > 
> > For some instruction emulation copying is not good enough: cmpxchg
> > emulation has to have direct access to the guest memory. __kvm_map_gfn()
> > is modified to accommodate the case.
> > 
> > The patchset is on top of v5.7-rc6 plus this patch:
> > 
> > https://urldefense.com/v3/__https://lkml.kernel.org/r/20200402172507.2786-1-jimmyassarsson@gmail.com__;!!GqivPVa7Brio!MSTb9DzpOUJMLMaMq-J7QOkopsKIlAYXpIxiu5FwFYfRctwIyNi8zBJWvlt89j8$
> > 
> > == Open Issues ==
> > 
> > Unmapping the pages from direct mapping bring a few of issues that have
> > not rectified yet:
> > 
> >   - Touching direct mapping leads to fragmentation. We need to be able to
> >     recover from it. I have a buggy patch that aims at recovering 2M/1G page.
> >     It has to be fixed and tested properly
> As I've mentioned above, not mapping all guest memory from 1GB hugetlbfs
> will lead to holes in kernel direct-map which force it to not be mapped
> anymore as a series of 1GB huge-pages.
> This have non-trivial performance cost. Thus, I am not sure addressing this
> use-case is valuable.

Here's the buggy patch I've referred to:

http://lore.kernel.org/r/20200416213229.19174-1-kirill.shutemov@linux.intel.com

I plan to get work right.

> > 
> >   - Page migration and KSM is not supported yet.
> > 
> >   - Live migration of a guest would require a new flow. Not sure yet how it
> >     would look like.
> 
> Note that Live-Migration issue is a result of not making guest data
> accessible to host userspace VMM.

Yes, I understand.

-- 
 Kirill A. Shutemov
