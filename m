Return-Path: <kvm+bounces-48168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E03ACAD0C
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 13:13:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5E04189E063
	for <lists+kvm@lfdr.de>; Mon,  2 Jun 2025 11:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7540B2040A7;
	Mon,  2 Jun 2025 11:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iFH9H9eC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9867F20103A
	for <kvm@vger.kernel.org>; Mon,  2 Jun 2025 11:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748862826; cv=none; b=eGLYsequNjBKDXLiawiUOVkJIT/YBi1Vd2GvhS6ZZPjf9PRjX9IzEgQ/+TY35jAUK5RrcdLahXM781XRVZGPMgMVLsCBh5e1fHwUWq9EOZkzvDyt/UJZcoEk1dvEWPesgif5s5PQJsINDIbS59B49eYaqPOPF5w0vcsGUwKG7KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748862826; c=relaxed/simple;
	bh=BrD1RN8OYX6YKizEKzHZA2X5I9JMq00lX1qfL1ynoAI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C2M2+i2XJ/aRnaJPci4Vw+VVAmgdj62DbRzvdH2lBUKN4z/0Ghu6x2eMRUPfLPvqav9uteSRWe78mgxc6Aeel0HusCZ81HMsuy7Q4UNIn7ELw/Dfv9kh4eidkLoCapxfVTX/qzNop9SW9TMyznoiT+oUfjmlZ71PCz7M1UA1PP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iFH9H9eC; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4a433f52485so682811cf.0
        for <kvm@vger.kernel.org>; Mon, 02 Jun 2025 04:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748862823; x=1749467623; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=f8dEAF79E3N+09IzcVzt0JByl2jpxQuRRlI6WwFJD5s=;
        b=iFH9H9eCUy33jibGacOQokFzK2OqPrXZ3cDCFmTvF6gQHnQDu0ye6w7FVWYNowX7VO
         fF11Or1sgjAurDiAAihQQ8EtwTtwvnCe3iUHoFUWgA+JKNFnwvApu7rUxebp7q8DgBQY
         PHas19OUQZmK7WYANxf/CJkjiTjCk5CuGq8Rl+g261On4O0XQAmRSZXIcHAV+KTgyA7l
         vwX8eU3Xym0vp8wW7RDi7QuxU0TsJjysouxMzek3ayggPB08euwX14UJjkrqW5/bn5Sk
         nAMfBhHsBKNxCJ9aHbw8ugjAJ2iNfbGtbyxGfXHHEZiCdRcWe+LVLuSnlVEkqGXrC6aw
         OnTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748862823; x=1749467623;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f8dEAF79E3N+09IzcVzt0JByl2jpxQuRRlI6WwFJD5s=;
        b=cKXwojOEzOLPzoXlqO3AT1JnYuoxFCmGDb6gOiCkLIO4AL4ZOiXytYuY12q7eoBY1B
         agATccyNfEj3hRRPlD9SDEvSLZzcYaI49J3bUNavuOUz21yxmbntHoin+PMFQhU7XQkf
         gQuaU6G4QUN6qrbvSpY8I3D/u5Sh8x6ZamRxqQxqs0Qg+GhuFiKEvgcA9z2EULx2gyeP
         HjQ/RoYUFrV5m4c3tvNVWG1r5zw8luGXdcWlqvaB/ciISkvO/8+DKdbqYobAbZgkcer0
         /lFHpbAZu9bpeI8s1wLSsfEwgQ9ZEE77sCkGD0yMh6jZ1wi1siiFvKVL9wdhQDOqrhbY
         C9uQ==
X-Gm-Message-State: AOJu0YwVfhmFx3pcl7ZGLuTz9MVggeVopbXz8w1RMXIw+dQgMcPwoMe6
	hUW0v4RTZgSLaT+H2yB06cmvyfa4xFoTy+CtVMoj44EmwCYA5nIx/cFz7PpLufr2sdy/cHFiZ1T
	2Dgt5OvTxeWfIAoQVVKhzYX88N5FiksSMnX+XTwC8
X-Gm-Gg: ASbGncvjHmOab7uzKi7Airv/xQuGLiwPAdS+/NkygQKPg6XXHhX4y71fL2DynLEwizH
	5LnScFEcKr/OX0wm/HUaC8Oa2oLjeJhs0u0t2la3AHHIP6GgdZgmAU7xJu5Wc3ivk6KsGvvJONX
	4Gguvs+/NoRQqFlcDnmv6DBUX2odzoHf7LeBcyX8O3bdA=
X-Google-Smtp-Source: AGHT+IGwYjwwlPRO5odjKdIKbJHHZStw9OOAS6neCRvXXMHEHJTRLzURMRF6KmmQqeBeJGexACUuNAzOIaw2KTUsLGI=
X-Received: by 2002:a05:622a:1c0b:b0:48d:8f6e:ece7 with SMTP id
 d75a77b69052e-4a458161417mr5165681cf.3.1748862822877; Mon, 02 Jun 2025
 04:13:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250527180245.1413463-1-tabba@google.com> <20250527180245.1413463-9-tabba@google.com>
 <8f85fcf7-3593-46e8-b257-d0da2b7337b9@amd.com>
In-Reply-To: <8f85fcf7-3593-46e8-b257-d0da2b7337b9@amd.com>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 2 Jun 2025 12:13:06 +0100
X-Gm-Features: AX0GCFvtbu_WgsBEElVSF2IfOuSPM9sWX6IdM_pHws-fhAfFTMXPKjL4cYGIGz8
Message-ID: <CA+EHjTx98wjg5UBRO9c-A8CZ7tc7yHrku+AKWY6G5pu2pE=ELQ@mail.gmail.com>
Subject: Re: [PATCH v10 08/16] KVM: guest_memfd: Allow host to map guest_memfd pages
To: Shivank Garg <shivankg@amd.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, qemu-devel@nongnu.org, qemu-discuss@nongnu.org, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, nikunj@amd.com, 
	Bharata B Rao <bharata@amd.com>
Content-Type: text/plain; charset="UTF-8"

Hi Shivank,

On Mon, 2 Jun 2025 at 11:44, Shivank Garg <shivankg@amd.com> wrote:
>
>
>
> On 5/27/2025 11:32 PM, Fuad Tabba wrote:
> > This patch enables support for shared memory in guest_memfd, including
> > mapping that memory at the host userspace. This support is gated by the
> > configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd
> > flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a
> > guest_memfd instance.
> >
> > Co-developed-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 10 ++++
> >  arch/x86/kvm/x86.c              |  3 +-
> >  include/linux/kvm_host.h        | 13 ++++++
> >  include/uapi/linux/kvm.h        |  1 +
> >  virt/kvm/Kconfig                |  5 ++
> >  virt/kvm/guest_memfd.c          | 81 +++++++++++++++++++++++++++++++++
> >  6 files changed, 112 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 709cc2a7ba66..ce9ad4cd93c5 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
> >
> >  #ifdef CONFIG_KVM_GMEM
> >  #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
> > +
> > +/*
> > + * CoCo VMs with hardware support that use guest_memfd only for backing private
> > + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enabled.
> > + */
> > +#define kvm_arch_supports_gmem_shared_mem(kvm)                       \
> > +     (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \
> > +      ((kvm)->arch.vm_type == KVM_X86_SW_PROTECTED_VM ||             \
> > +       (kvm)->arch.vm_type == KVM_X86_DEFAULT_VM))
> >  #else
> >  #define kvm_arch_supports_gmem(kvm) false
> > +#define kvm_arch_supports_gmem_shared_mem(kvm) false
> >  #endif
> >
> >  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state)
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 035ced06b2dd..2a02f2457c42 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -12718,7 +12718,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >               return -EINVAL;
> >
> >       kvm->arch.vm_type = type;
> > -     kvm->arch.supports_gmem = (type == KVM_X86_SW_PROTECTED_VM);
> > +     kvm->arch.supports_gmem =
> > +             type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
>
>
> I've been testing this patch-series. I did not saw failure with guest_memfd selftests but encountered a regression on my system with KVM_X86_DEFAULT_VM.
>
> I'm getting below error in QEMU:
> Issue #1 - QEMU fails to start with KVM_X86_DEFAULT_VM, showing:
>
> qemu-system-x86_64: kvm_set_user_memory_region: KVM_SET_USER_MEMORY_REGION2 failed, slot=65536, start=0x0, size=0x80000000, flags=0x0, guest_memfd=-1, guest_memfd_offset=0x0: Invalid argument
> kvm_set_phys_mem: error registering slot: Invalid argument
>
> I did some digging to find out,
> In kvm_set_memory_region as_id >= kvm_arch_nr_memslot_as_ids(kvm) now returns true.
> (as_id:1 kvm_arch_nr_memslot_as_ids(kvm):1 id:0 KVM_MEM_SLOTS_NUM:32767)
>
> /* SMM is currently unsupported for guests with guest_memfd (esp private) memory. */
> # define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_supports_gmem(kvm) ? 1 : 2)
> evaluates to be 1
>
> I'm still debugging to find answer to these question
> Why slot=65536 and (as_id = mem->slot >> 16 = 1) is requested for KVM_X86_DEFAULT_VM case
> which is making it fail for above check.
> Was this change intentional for KVM_X86_DEFAULT_VM? Should this be considered as KVM regression or QEMU[1] compatibility issue?

Yes, this was intentional. We talked about this during the guest_memfd
biweekly sync on May 15 [*]. We came to the conclusion that we cannot
support SMM with private memory. KVM_X86_DEFAULT_VM cannot have
private memory, but guest_memfd with shared memory.

[*] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?tab=t.0#heading=h.b4x45fcfgzvo

> ---
> Issue #2: Testing challenges with QEMU changes[2] and mmap Implementation:
> Currently, QEMU only enables guest_memfd for SEV_SNP_GUEST (KVM_X86_SNP_VM) by setting require_guest_memfd=true. However, the new mmap implementation doesn't support SNP guests per kvm_arch_supports_gmem_shared_mem().
>
> static void
> sev_snp_guest_instance_init(Object *obj)
> {
>     ConfidentialGuestSupport *cgs = CONFIDENTIAL_GUEST_SUPPORT(obj);
>     SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(obj);
>
>     cgs->require_guest_memfd = true;
>
>
> To bypass this, I did two things and failed:
> 1. Enabling guest_memfd for KVM_X86_DEFAULT_VM in QEMU: Hits Issue #1 above
> 2. Adding KVM_X86_SNP_VM to kvm_arch_supports_gmem_shared_mem(): mmap() succeeds but QEMU stuck during boot.
>
>
>
> My NUMA policy support for guest-memfd patch[3] depends on mmap() support and extends
> kvm_gmem_vm_ops with get_policy/set_policy operations.
> Since NUMA policy applies to both shared and private memory scenarios, what checks should
> be included in the mmap() implementation, and what's the recommended approach for
> integrating with your shared memory restrictions?

KVM_X86_SNP_VM doesn't support in-place shared memory yet, so I think
this is to be expected for now.

Thanks,
/fuad

>
> [1] https://github.com/qemu/qemu
> [2] Snippet to QEMU changes to add mmap
>
> +                new_block->guest_memfd = kvm_create_guest_memfd(
> +                                           new_block->max_length, /*0 */GUEST_MEMFD_FLAG_SUPPORT_SHARED, errp);
> +                if (new_block->guest_memfd < 0) {
> +                        qemu_mutex_unlock_ramlist();
> +                        goto out_free;
> +                }
> +                new_block->ptr_memfd = mmap(NULL, new_block->max_length,
> +                                            PROT_READ | PROT_WRITE,
> +                                            MAP_SHARED,
> +                                            new_block->guest_memfd, 0);
> +                if (new_block->ptr_memfd == MAP_FAILED) {
> +                    error_report("Failed to mmap guest_memfd");
> +                    qemu_mutex_unlock_ramlist();
> +                    goto out_free;
> +                }
> +                printf("mmap successful\n");
> +            }
> [3] https://lore.kernel.org/linux-mm/20250408112402.181574-1-shivankg@amd.com
>
>
>
> >       /* Decided by the vendor code for other VM types.  */
> >       kvm->arch.pre_fault_allowed =
> >               type == KVM_X86_DEFAULT_VM || type == KVM_X86_SW_PROTECTED_VM;
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 80371475818f..ba83547e62b0 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
> >  }
> >  #endif
> >
> > +/*
> > + * Returns true if this VM supports shared mem in guest_memfd.
> > + *
> > + * Arch code must define kvm_arch_supports_gmem_shared_mem if support for
> > + * guest_memfd is enabled.
> > + */
> > +#if !defined(kvm_arch_supports_gmem_shared_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> > +static inline bool kvm_arch_supports_gmem_shared_mem(struct kvm *kvm)
> > +{
> > +     return false;
> > +}
> > +#endif
> > +
> >  #ifndef kvm_arch_has_readonly_mem
> >  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)
> >  {
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index b6ae8ad8934b..c2714c9d1a0e 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {
> >  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
> >
> >  #define KVM_CREATE_GUEST_MEMFD       _IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
> > +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED      (1ULL << 0)
> >
> >  struct kvm_create_guest_memfd {
> >       __u64 size;
> > diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> > index 559c93ad90be..df225298ab10 100644
> > --- a/virt/kvm/Kconfig
> > +++ b/virt/kvm/Kconfig
> > @@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE
> >  config HAVE_KVM_ARCH_GMEM_INVALIDATE
> >         bool
> >         depends on KVM_GMEM
> > +
> > +config KVM_GMEM_SHARED_MEM
> > +       select KVM_GMEM
> > +       bool
> > +       prompt "Enable support for non-private (shared) memory in guest_memfd"
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index 6db515833f61..5d34712f64fc 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -312,7 +312,81 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_slot *slot, gfn_t gfn)
> >       return gfn - slot->base_gfn + slot->gmem.pgoff;
> >  }
> >
> > +static bool kvm_gmem_supports_shared(struct inode *inode)
> > +{
> > +     u64 flags;
> > +
> > +     if (!IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM))
> > +             return false;
> > +
> > +     flags = (u64)inode->i_private;
> > +
> > +     return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +}
> > +
> > +
> > +#ifdef CONFIG_KVM_GMEM_SHARED_MEM
> > +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
> > +{
> > +     struct inode *inode = file_inode(vmf->vma->vm_file);
> > +     struct folio *folio;
> > +     vm_fault_t ret = VM_FAULT_LOCKED;
> > +
> > +     folio = kvm_gmem_get_folio(inode, vmf->pgoff);
> > +     if (IS_ERR(folio)) {
> > +             int err = PTR_ERR(folio);
> > +
> > +             if (err == -EAGAIN)
> > +                     return VM_FAULT_RETRY;
> > +
> > +             return vmf_error(err);
> > +     }
> > +
> > +     if (WARN_ON_ONCE(folio_test_large(folio))) {
> > +             ret = VM_FAULT_SIGBUS;
> > +             goto out_folio;
> > +     }
> > +
> > +     if (!folio_test_uptodate(folio)) {
> > +             clear_highpage(folio_page(folio, 0));
> > +             kvm_gmem_mark_prepared(folio);
> > +     }
> > +
> > +     vmf->page = folio_file_page(folio, vmf->pgoff);
> > +
> > +out_folio:
> > +     if (ret != VM_FAULT_LOCKED) {
> > +             folio_unlock(folio);
> > +             folio_put(folio);
> > +     }
> > +
> > +     return ret;
> > +}
> > +
> > +static const struct vm_operations_struct kvm_gmem_vm_ops = {
> > +     .fault = kvm_gmem_fault_shared,
> > +};
> > +
> > +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +     if (!kvm_gmem_supports_shared(file_inode(file)))
> > +             return -ENODEV;
> > +
> > +     if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=
> > +         (VM_SHARED | VM_MAYSHARE)) {
> > +             return -EINVAL;
> > +     }
> > +
> > +     vma->vm_ops = &kvm_gmem_vm_ops;
> > +
> > +     return 0;
> > +}
> > +#else
> > +#define kvm_gmem_mmap NULL
> > +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */
> > +
> >  static struct file_operations kvm_gmem_fops = {
> > +     .mmap           = kvm_gmem_mmap,
> >       .open           = generic_file_open,
> >       .release        = kvm_gmem_release,
> >       .fallocate      = kvm_gmem_fallocate,
> > @@ -463,6 +537,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_guest_memfd *args)
> >       u64 flags = args->flags;
> >       u64 valid_flags = 0;
> >
> > +     if (kvm_arch_supports_gmem_shared_mem(kvm))
> > +             valid_flags |= GUEST_MEMFD_FLAG_SUPPORT_SHARED;
> > +
> >       if (flags & ~valid_flags)
> >               return -EINVAL;
> >
> > @@ -501,6 +578,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory_slot *slot,
> >           offset + size > i_size_read(inode))
> >               goto err;
> >
> > +     if (kvm_gmem_supports_shared(inode) &&
> > +         !kvm_arch_supports_gmem_shared_mem(kvm))
> > +             goto err;
> > +
> >       filemap_invalidate_lock(inode->i_mapping);
> >
> >       start = offset >> PAGE_SHIFT;
>
>
>
>
>
>
>

