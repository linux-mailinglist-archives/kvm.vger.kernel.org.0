Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A264029360B
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 09:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405429AbgJTHqT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 03:46:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51205 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731309AbgJTHqR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 03:46:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603179976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sgXxImGcNfTdpL1HttYiv+7vAWjr3xqbtqxgsUpAur8=;
        b=Wgt+Am48e3HEEcJa5/saVHAFDgm9fByhqh99VoWotkuZvpewsqP6KG+LHdwQ2Z3rlHPKlP
        eRBLT0WWKi/MRZcsUQDMILrVRnFjABL8/EbeA1+uYdNxGhVZeILe/wFpo106YIXnGp0ph2
        Ky4Ss+ae8GZ0UV0fWmSZC/NtUENjEFs=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-oYp-rWJjNGOLpwcJAW_VoQ-1; Tue, 20 Oct 2020 03:46:14 -0400
X-MC-Unique: oYp-rWJjNGOLpwcJAW_VoQ-1
Received: by mail-ej1-f70.google.com with SMTP id t1so483428ejb.21
        for <kvm@vger.kernel.org>; Tue, 20 Oct 2020 00:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=sgXxImGcNfTdpL1HttYiv+7vAWjr3xqbtqxgsUpAur8=;
        b=Y9EdLVOwhhY3hi4b2EPcZS8CPGduosJZ32+7qYTs8UOp9UlIoi47Ov/Z0lVY+oiCLB
         PgUgnbmb5BIVja/yPc5O+rSOhmcu8YcTS2FHgZoRS+nMp1Zmp1T3FVmcVpjjr2revr+F
         1C97ly2lQ5L/4VsSD/pa90C4nw+o23pP7o1eV44qNGLQpXTkR+Q+7Hx3xMPpsL76TujD
         DE/E1v1I6GIOrSy1XKZWKrNlDfQ7sli1vU7nB3wXZihlh2oLjTuS8jJPft4z+kp7Xya4
         c7efBpiZplOzVxg+9fPpTGI34qV94PJrcKPBUYc9qBXwQ3PY00ka989z3OkKn/wvYDSF
         nXcQ==
X-Gm-Message-State: AOAM531QD4eXrTGNnjF7aSlcsocggdm+AFXZDY5Zkm1Bq7xA5nNoHtKm
        iWlpAuMHY1ZA0DGGtrcb7tZ1nfDnwPbOP6kDJ5o/ran+t59we/rMkhqp6p4C9J7BKfRmZfCrHo0
        KArexc/pnGmY7
X-Received: by 2002:a50:fa42:: with SMTP id c2mr1518492edq.282.1603179973461;
        Tue, 20 Oct 2020 00:46:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJ70UdcNwULC3ElIfnIU9WUEldW55FxNekhN61q+78PDLzJKQH8MyQOM4YfsYMYec8XQbuZw==
X-Received: by 2002:a50:fa42:: with SMTP id c2mr1518467edq.282.1603179973177;
        Tue, 20 Oct 2020 00:46:13 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h4sm1363839edj.1.2020.10.20.00.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2020 00:46:12 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFCv2 00/16] KVM protected memory extension
In-Reply-To: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
Date:   Tue, 20 Oct 2020 09:46:11 +0200
Message-ID: <87ft6949x8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> == Background / Problem ==
>
> There are a number of hardware features (MKTME, SEV) which protect guest
> memory from some unauthorized host access. The patchset proposes a purely
> software feature that mitigates some of the same host-side read-only
> attacks.
>
>
> == What does this set mitigate? ==
>
>  - Host kernel ”accidental” access to guest data (think speculation)
>
>  - Host kernel induced access to guest data (write(fd, &guest_data_ptr, len))
>
>  - Host userspace access to guest data (compromised qemu)
>
>  - Guest privilege escalation via compromised QEMU device emulation
>
> == What does this set NOT mitigate? ==
>
>  - Full host kernel compromise.  Kernel will just map the pages again.
>
>  - Hardware attacks
>
>
> The second RFC revision addresses /most/ of the feedback.
>
> I still didn't found a good solution to reboot and kexec. Unprotect all
> the memory on such operations defeat the goal of the feature. Clearing up
> most of the memory before unprotecting what is required for reboot (or
> kexec) is tedious and error-prone.
> Maybe we should just declare them unsupported?

Making reboot unsupported is a hard sell. Could you please elaborate on
why you think that "unprotect all" hypercall (or rather a single
hypercall supporting both protecting/unprotecting) defeats the purpose
of the feature?

(Leaving kexec aside for a while) Yes, it is not easy for a guest to
clean up *all* its memory upon reboot, however:
- It may only clean up the most sensitive parts. This should probably be
done even without this new feature and even on bare metal (think about
next boot target being malicious).
- The attack window shrinks significantly. "Speculative" bugs require
time to exploit and it will only remain open until it boots up again
(few seconds).

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
> Removing userspace mapping of the guest memory from QEMU process can help
> to address some guest privilege escalation attacks. Consider the case when
> unprivileged guest user exploits bug in a QEMU device emulation to gain
> access to data it cannot normally have access within the guest.
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
> The patchset is on top of v5.9
>
> Kirill A. Shutemov (16):
>   x86/mm: Move force_dma_unencrypted() to common code
>   x86/kvm: Introduce KVM memory protection feature
>   x86/kvm: Make DMA pages shared
>   x86/kvm: Use bounce buffers for KVM memory protection
>   x86/kvm: Make VirtIO use DMA API in KVM guest
>   x86/kvmclock: Share hvclock memory with the host
>   x86/realmode: Share trampoline area if KVM memory protection enabled
>   KVM: Use GUP instead of copy_from/to_user() to access guest memory
>   KVM: mm: Introduce VM_KVM_PROTECTED
>   KVM: x86: Use GUP for page walk instead of __get_user()
>   KVM: Protected memory extension
>   KVM: x86: Enabled protected memory extension
>   KVM: Rework copy_to/from_guest() to avoid direct mapping
>   KVM: Handle protected memory in __kvm_map_gfn()/__kvm_unmap_gfn()
>   KVM: Unmap protected pages from direct mapping
>   mm: Do not use zero page for VM_KVM_PROTECTED VMAs
>
>  arch/powerpc/kvm/book3s_64_mmu_hv.c    |   2 +-
>  arch/powerpc/kvm/book3s_64_mmu_radix.c |   2 +-
>  arch/s390/include/asm/pgtable.h        |   2 +-
>  arch/x86/Kconfig                       |  11 +-
>  arch/x86/include/asm/cpufeatures.h     |   1 +
>  arch/x86/include/asm/io.h              |   6 +-
>  arch/x86/include/asm/kvm_para.h        |   5 +
>  arch/x86/include/asm/pgtable_types.h   |   1 +
>  arch/x86/include/uapi/asm/kvm_para.h   |   3 +-
>  arch/x86/kernel/kvm.c                  |  20 +++
>  arch/x86/kernel/kvmclock.c             |   2 +-
>  arch/x86/kernel/pci-swiotlb.c          |   3 +-
>  arch/x86/kvm/Kconfig                   |   1 +
>  arch/x86/kvm/cpuid.c                   |   3 +-
>  arch/x86/kvm/mmu/mmu.c                 |   6 +-
>  arch/x86/kvm/mmu/paging_tmpl.h         |  10 +-
>  arch/x86/kvm/x86.c                     |   9 +
>  arch/x86/mm/Makefile                   |   2 +
>  arch/x86/mm/ioremap.c                  |  16 +-
>  arch/x86/mm/mem_encrypt.c              |  51 ------
>  arch/x86/mm/mem_encrypt_common.c       |  62 +++++++
>  arch/x86/mm/pat/set_memory.c           |   7 +
>  arch/x86/realmode/init.c               |   7 +-
>  drivers/virtio/virtio_ring.c           |   4 +
>  include/linux/kvm_host.h               |  11 +-
>  include/linux/kvm_types.h              |   1 +
>  include/linux/mm.h                     |  21 ++-
>  include/uapi/linux/kvm_para.h          |   5 +-
>  mm/gup.c                               |  20 ++-
>  mm/huge_memory.c                       |  31 +++-
>  mm/ksm.c                               |   2 +
>  mm/memory.c                            |  18 +-
>  mm/mmap.c                              |   3 +
>  mm/rmap.c                              |   4 +
>  virt/kvm/Kconfig                       |   3 +
>  virt/kvm/async_pf.c                    |   2 +-
>  virt/kvm/kvm_main.c                    | 238 +++++++++++++++++++++----
>  virt/lib/Makefile                      |   1 +
>  virt/lib/mem_protected.c               | 193 ++++++++++++++++++++
>  39 files changed, 666 insertions(+), 123 deletions(-)
>  create mode 100644 arch/x86/mm/mem_encrypt_common.c
>  create mode 100644 virt/lib/mem_protected.c

-- 
Vitaly

