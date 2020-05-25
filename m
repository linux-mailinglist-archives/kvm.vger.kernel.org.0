Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA1B31E0668
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 07:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgEYF1L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 01:27:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:46592 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725802AbgEYF1L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 01:27:11 -0400
IronPort-SDR: gtHPSKWX4gfNEWkgD+EO4FVcER8/zsz7eaOw6QdHKOR2+WQsNUaEYzgSFQc+pLDqWvF3TCHiDX
 aC5fLU+zP7UQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2020 22:27:10 -0700
IronPort-SDR: iJgO3NPxbSQrde39Pl/sGd3uIpknDtkS1Z6bF9xo+xNLMwaEOMKfpi1qnscwN4yVnKqkqnWG39
 FlfTk6lI7Z/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,432,1583222400"; 
   d="scan'208";a="467949545"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga006.fm.intel.com with ESMTP; 24 May 2020 22:27:06 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
        id 3F116D7; Mon, 25 May 2020 08:27:04 +0300 (EEST)
Date:   Mon, 25 May 2020 08:27:04 +0300
From:   "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
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
        linux-kernel@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Marius Hillenbrand <mhillenb@amazon.de>
Subject: Re: [RFC 00/16] KVM protected memory extension
Message-ID: <20200525052704.phyk5olkykncj3bj@black.fi.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 03:51:58PM +0300, Kirill A. Shutemov wrote:
> == Background / Problem ==
> 
> There are a number of hardware features (MKTME, SEV) which protect guest
> memory from some unauthorized host access. The patchset proposes a purely
> software feature that mitigates some of the same host-side read-only
> attacks.

CC people who worked on the related patchsets.
 
> == What does this set mitigate? ==
> 
>  - Host kernel ”accidental” access to guest data (think speculation)
> 
>  - Host kernel induced access to guest data (write(fd, &guest_data_ptr, len))
> 
>  - Host userspace access to guest data (compromised qemu)
> 
> == What does this set NOT mitigate? ==
> 
>  - Full host kernel compromise.  Kernel will just map the pages again.
> 
>  - Hardware attacks
> 
> 
> The patchset is RFC-quality: it works but has known issues that must be
> addressed before it can be considered for applying.
> 
> We are looking for high-level feedback on the concept.  Some open
> questions:
> 
>  - This protects from some kernel and host userspace read-only attacks,
>    but does not place the host kernel outside the trust boundary. Is it
>    still valuable?
> 
>  - Can this approach be used to avoid cache-coherency problems with
>    hardware encryption schemes that repurpose physical bits?
> 
>  - The guest kernel must be modified for this to work.  Is that a deal
>    breaker, especially for public clouds?
> 
>  - Are the costs of removing pages from the direct map too high to be
>    feasible?
> 
> == Series Overview ==
> 
> The hardware features protect guest data by encrypting it and then
> ensuring that only the right guest can decrypt it.  This has the
> side-effect of making the kernel direct map and userspace mapping
> (QEMU et al) useless.  But, this teaches us something very useful:
> neither the kernel or userspace mappings are really necessary for normal
> guest operations.
> 
> Instead of using encryption, this series simply unmaps the memory. One
> advantage compared to allowing access to ciphertext is that it allows bad
> accesses to be caught instead of simply reading garbage.
> 
> Protection from physical attacks needs to be provided by some other means.
> On Intel platforms, (single-key) Total Memory Encryption (TME) provides
> mitigation against physical attacks, such as DIMM interposers sniffing
> memory bus traffic.
> 
> The patchset modifies both host and guest kernel. The guest OS must enable
> the feature via hypercall and mark any memory range that has to be shared
> with the host: DMA regions, bounce buffers, etc. SEV does this marking via a
> bit in the guest’s page table while this approach uses a hypercall.
> 
> For removing the userspace mapping, use a trick similar to what NUMA
> balancing does: convert memory that belongs to KVM memory slots to
> PROT_NONE: all existing entries converted to PROT_NONE with mprotect() and
> the newly faulted in pages get PROT_NONE from the updated vm_page_prot.
> The new VMA flag -- VM_KVM_PROTECTED -- indicates that the pages in the
> VMA must be treated in a special way in the GUP and fault paths. The flag
> allows GUP to return the page even though it is mapped with PROT_NONE, but
> only if the new GUP flag -- FOLL_KVM -- is specified. Any userspace access
> to the memory would result in SIGBUS. Any GUP access without FOLL_KVM
> would result in -EFAULT.
> 
> Any anonymous page faulted into the VM_KVM_PROTECTED VMA gets removed from
> the direct mapping with kernel_map_pages(). Note that kernel_map_pages() only
> flushes local TLB. I think it's a reasonable compromise between security and
> perfromance.
> 
> Zapping the PTE would bring the page back to the direct mapping after clearing.
> At least for now, we don't remove file-backed pages from the direct mapping.
> File-backed pages could be accessed via read/write syscalls. It adds
> complexity.
> 
> Occasionally, host kernel has to access guest memory that was not made
> shared by the guest. For instance, it happens for instruction emulation.
> Normally, it's done via copy_to/from_user() which would fail with -EFAULT
> now. We introduced a new pair of helpers: copy_to/from_guest(). The new
> helpers acquire the page via GUP, map it into kernel address space with
> kmap_atomic()-style mechanism and only then copy the data.
> 
> For some instruction emulation copying is not good enough: cmpxchg
> emulation has to have direct access to the guest memory. __kvm_map_gfn()
> is modified to accommodate the case.
> 
> The patchset is on top of v5.7-rc6 plus this patch:
> 
> https://lkml.kernel.org/r/20200402172507.2786-1-jimmyassarsson@gmail.com
> 
> == Open Issues ==
> 
> Unmapping the pages from direct mapping bring a few of issues that have
> not rectified yet:
> 
>  - Touching direct mapping leads to fragmentation. We need to be able to
>    recover from it. I have a buggy patch that aims at recovering 2M/1G page.
>    It has to be fixed and tested properly
> 
>  - Page migration and KSM is not supported yet.
> 
>  - Live migration of a guest would require a new flow. Not sure yet how it
>    would look like.
> 
>  - The feature interfere with NUMA balancing. Not sure yet if it's
>    possible to make them work together.
> 
>  - Guests have no mechanism to ensure that even a well-behaving host has
>    unmapped its private data.  With SEV, for instance, the guest only has
>    to trust the hardware to encrypt a page after the C bit is set in a
>    guest PTE.  A mechanism for a guest to query the host mapping state, or
>    to constantly assert the intent for a page to be Private would be
>    valuable.
-- 
 Kirill A. Shutemov
