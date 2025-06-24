Return-Path: <kvm+bounces-50574-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB89AE7114
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 22:51:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AB133ADF5F
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 20:51:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E519B2E8E0B;
	Tue, 24 Jun 2025 20:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QfGALSzq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556F24C9F
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 20:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750798308; cv=none; b=GIqOe3D+BDHGal1kgORJCV+gEE1G7Hh9tWZN3QldO+jPlQy3vyi6eQcpa1S45fGoiY6DQnDswtjS3zishHRwYldqDo3L68cV9G993/2KiE+bWwzjEtPCwkI3Ha0hnUchDkh7wZdNWO32uvXc1iUwnEdU17aUibwexAA/o60hFxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750798308; c=relaxed/simple;
	bh=8x9qXP/S5UEvRdHC20B9d77FLYlNsihh3C+6w9hyTis=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hBSfPgTt/MnetyTPuFqN4NQaRpkTcvC7RkHsRkzhCYSO7kyqAldEl1aiy6i6zyMUpP8nUkWqdZz5ult5+jsiU18oC/cSlDDSu4sWDCar66a8qJjzXabgo52GG15VIzypLKK1ZA8Gu9tWXL5ZIVIIGol1/gILqyEXMEeyzAur3Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QfGALSzq; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ackerleytng.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-748b4d5c045so4529580b3a.1
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 13:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750798306; x=1751403106; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d8YBsgCuhiB1KQsfplkqu8KemDkiwvQdckbWSfdb9ME=;
        b=QfGALSzqwWMadD+6a48vI6q2v96+F+HW7uvOvjD1878QeRdg1T8G1KX695STPN+rke
         Rw3SgAnWnze5S1SSP7PL1N4FThDxIysTkrC2OlnYpDxNK4BgdekkZyowVxhNzLO7dtkY
         nEjQ2vHfH2zdhpRO2pR7Yow/qmRBQJd25RGZVTDR+fRByES6D+faRofVvCO6DIna2IOQ
         evbHBqZZb+7ZeR7wVmZCIRec3nmfBv8Aavw1k9d0nZXJQV2IFPMS6cXztdeZWkwERjAo
         Gm/NaoASFEHSVHFvy3Psay2R0TC6UGr/fLHBoMXYwhkPE/q6GdLRW2ZdrtO6xFx2FeED
         pBfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750798306; x=1751403106;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d8YBsgCuhiB1KQsfplkqu8KemDkiwvQdckbWSfdb9ME=;
        b=hHVCANlQxV98o6bGbTEwUH/TOqGqT0gsrjdoBGH0nFllnFhGQwVHgAFCJd8mze1p/B
         r/0dvE9rgnZ2vobxWJ472ZHGtjNpZTuyTr8CmPHybId8+ZXdWaiXaf4HlcexQBrWROyY
         P9WrtnJjgVdpH59bqkXMyUi0d6JTmGDOj+gPfsDbf7oSZrlNJat875JClKf8DWlEVF3a
         DZ8M92cIo4cHtBFrzXuU5cJ4e/Pf+wr3C9dkAIzyNXMf+JxknbLswRFOsFxoZayUbb4y
         N5OXAXbALSdHbbjK5KQJcFPt4O5SHv1NcPGcV2GYMlnAFO25MlGMaDCMNsX8qljdhvI5
         FqbA==
X-Gm-Message-State: AOJu0Yz0nOEjahL7FnwOCzJb9lK420e+Vwh2OI0B7xiLXmQ0sxsDKzSo
	Qr/MKCNfBCepg35WXwxE4QJIzg+lS503KFMXshSeUFb/wPfUDqG7/f2S9TWx7rBGxTJEiUbLV5y
	EAoEM4Npof5Bnb3qVOCgbVmLi4w==
X-Google-Smtp-Source: AGHT+IEjeeOkKZSbarts0EPQ1w+PWi2DaN3IHfHv2xkdKjbiLXsr1Pi5Gbvd6S1gibHhYGyDPXVynsSmZ7Iue9O3cQ==
X-Received: from pfbly4.prod.google.com ([2002:a05:6a00:7584:b0:749:d28:4ca2])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:170b:b0:748:f74f:6d27 with SMTP id d2e1a72fcca58-74ad45e0092mr913336b3a.24.1750798305552;
 Tue, 24 Jun 2025 13:51:45 -0700 (PDT)
Date: Tue, 24 Jun 2025 13:51:44 -0700
In-Reply-To: <aEyLlbyMmNEBCAVj@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611133330.1514028-1-tabba@google.com> <20250611133330.1514028-5-tabba@google.com>
 <aEyLlbyMmNEBCAVj@google.com>
Message-ID: <diqzh604lv6n.fsf@ackerleytng-ctop.c.googlers.com>
Subject: Re: [PATCH v12 04/18] KVM: x86: Rename kvm->arch.has_private_mem to kvm->arch.supports_gmem
From: Ackerley Tng <ackerleytng@google.com>
To: Sean Christopherson <seanjc@google.com>, Fuad Tabba <tabba@google.com>
Cc: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, chenhuacai@kernel.org, 
	mpe@ellerman.id.au, anup@brainfault.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, mail@maciej.szmigiero.name, david@redhat.com, 
	michael.roth@amd.com, wei.w.wang@intel.com, liam.merwick@oracle.com, 
	isaku.yamahata@gmail.com, kirill.shutemov@linux.intel.com, 
	suzuki.poulose@arm.com, steven.price@arm.com, quic_eberman@quicinc.com, 
	quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, quic_svaddagi@quicinc.com, 
	quic_cvanscha@quicinc.com, quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, 
	catalin.marinas@arm.com, james.morse@arm.com, yuzenghui@huawei.com, 
	oliver.upton@linux.dev, maz@kernel.org, will@kernel.org, qperret@google.com, 
	keirf@google.com, roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, 
	jgg@nvidia.com, rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, 
	hughd@google.com, jthoughton@google.com, peterx@redhat.com, 
	pankaj.gupta@amd.com, ira.weiny@intel.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Sean Christopherson <seanjc@google.com> writes:

> On Wed, Jun 11, 2025, Fuad Tabba wrote:
>> The bool has_private_mem is used to indicate whether guest_memfd is
>> supported.
>
> No?  This is at best weird, and at worst flat out wrong:
>
> 	if (kvm->arch.supports_gmem &&
> 	    fault->is_private !=3D kvm_mem_is_private(kvm, fault->gfn))
> 		return false;
>
> ditto for this code:
>
> 	if (kvm_arch_supports_gmem(vcpu->kvm) &&
> 	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))i
> 		error_code |=3D PFERR_PRIVATE_ACCESS;
>
> and for the memory_attributes code.  E.g. IIRC, with guest_memfd() mmap s=
upport,
> private vs. shared will become a property of the guest_memfd inode, i.e. =
this will
> become wrong:
>
> static u64 kvm_supported_mem_attributes(struct kvm *kvm)
> {
> 	if (!kvm || kvm_arch_supports_gmem(kvm))
> 		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
>
> 	return 0;
> }
>
> Instead of renaming kvm_arch_has_private_mem() =3D> kvm_arch_supports_gme=
m(), *add*
> kvm_arch_supports_gmem() and then kill off kvm_arch_has_private_mem() onc=
e non-x86
> usage is gone (i.e. query kvm->arch.has_private_mem directly).
>
> And then rather than rename has_private_mem, either add supports_gmem or =
do what
> you did for kvm_arch_supports_gmem_shared_mem() and explicitly check the =
VM type.
>

IIUC Fuad will be adding bool supports_gmem instead of renaming, but we
haven't discussed which usages will start using the new function.

Let me go over all the changes/usages related to has_private_mem and
supports_gmem.

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 6e0bbf4c2202..3d69da6d2d9e 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -2270,9 +2270,9 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_for=
ced_root_level,
> =20
> =20
>  #ifdef CONFIG_KVM_GMEM
> -#define kvm_arch_has_private_mem(kvm) ((kvm)->arch.has_private_mem)
> +#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)
>  #else
> -#define kvm_arch_has_private_mem(kvm) false
> +#define kvm_arch_supports_gmem(kvm) false
>  #endif
>

*The* renaming vs adding-new-function change.

>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state=
)
> @@ -2325,8 +2325,8 @@ enum {
>  #define HF_SMM_INSIDE_NMI_MASK	(1 << 2)
> =20
>  # define KVM_MAX_NR_ADDRESS_SPACES	2
> -/* SMM is currently unsupported for guests with private memory. */
> -# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_has_private_mem(kvm) =
? 1 : 2)
> +/* SMM is currently unsupported for guests with guest_memfd (esp private=
) memory. */
> +# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_supports_gmem(kvm) ? =
1 : 2)
>  # define kvm_arch_vcpu_memslots_id(vcpu) ((vcpu)->arch.hflags & HF_SMM_M=
ASK ? 1 : 0)
>  # define kvm_memslots_for_spte_role(kvm, role) __kvm_memslots(kvm, (role=
).smm)
>  #else

IIUC from the discussion at guest_memfd call on 2025-05-15, SMM can't be
supported because SMM relies on memory being shared.

This should remain as kvm_arch_has_private_mem() - as long as the VM
supports private memory at all, kvm_arch_nr_memslot_as_ids() should
return 1 (no SMM support).

> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index cbc84c6abc2e..e7ecf089780a 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4910,7 +4910,7 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vcpu=
 *vcpu,
>  	if (r)
>  		return r;
> =20
> -	if (kvm_arch_has_private_mem(vcpu->kvm) &&
> +	if (kvm_arch_supports_gmem(vcpu->kvm) &&
>  	    kvm_mem_is_private(vcpu->kvm, gpa_to_gfn(range->gpa)))
>  		error_code |=3D PFERR_PRIVATE_ACCESS;
> =20

If the VM supports private mem and KVM knows the gfn to be private
(whether based on memory attributes or in future, guest_memfd's
shareability), prefault it as private.

Here technically the kvm_arch_has_private_mem() check just helps
short-circuit to save deeper lookups, but if kvm_arch_has_private_mem()
is false, kvm_mem_is_private() always return false anyway.

This should remain as kvm_arch_has_private_mem().

> @@ -7707,7 +7707,7 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm =
*kvm,
>  	 * Zapping SPTEs in this case ensures KVM will reassess whether or not
>  	 * a hugepage can be used for affected ranges.
>  	 */
> -	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
> +	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
>  		return false;
> =20
>  	if (WARN_ON_ONCE(range->end <=3D range->start))

Skip setting memory attributes if this kvm doesn't support private
memory.

This should remain as kvm_arch_has_private_mem().

> @@ -7786,7 +7786,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm=
 *kvm,
>  	 * a range that has PRIVATE GFNs, and conversely converting a range to
>  	 * SHARED may now allow hugepages.
>  	 */
> -	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
> +	if (WARN_ON_ONCE(!kvm_arch_supports_gmem(kvm)))
>  		return false;
> =20
>  	/*

Skip setting memory attributes if this kvm doesn't support private
memory.

This should remain as kvm_arch_has_private_mem().

> @@ -7842,7 +7842,7 @@ void kvm_mmu_init_memslot_memory_attributes(struct =
kvm *kvm,
>  {
>  	int level;
> =20
> -	if (!kvm_arch_has_private_mem(kvm))
> +	if (!kvm_arch_supports_gmem(kvm))
>  		return;
> =20
>  	for (level =3D PG_LEVEL_2M; level <=3D KVM_MAX_HUGEPAGE_LEVEL; level++)=
 {

Skip initializing memory attributes if this kvm doesn't support private
memory, since for now KVM_MEMORY_ATTRIBUTE_PRIVATE is the only memory
attribute.

This should remain as kvm_arch_has_private_mem().

Or perhaps (separately from this series) this check can be changed to
kvm_supported_mem_attributes() !=3D 0.

> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 7700efc06e35..a0e661aa3f8a 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -719,11 +719,11 @@ static inline int kvm_arch_vcpu_memslots_id(struct =
kvm_vcpu *vcpu)
>  #endif
> =20
>  /*
> - * Arch code must define kvm_arch_has_private_mem if support for private=
 memory
> + * Arch code must define kvm_arch_supports_gmem if support for guest_mem=
fd
>   * is enabled.
>   */
> -#if !defined(kvm_arch_has_private_mem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> -static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
> +#if !defined(kvm_arch_supports_gmem) && !IS_ENABLED(CONFIG_KVM_GMEM)
> +static inline bool kvm_arch_supports_gmem(struct kvm *kvm)
>  {
>  	return false;
>  }

*The* renaming vs adding-new-function change.

> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 898c3d5a7ba8..6efbea208fa6 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1588,7 +1588,7 @@ static int check_memory_region_flags(struct kvm *kv=
m,
>  {
>  	u32 valid_flags =3D KVM_MEM_LOG_DIRTY_PAGES;
> =20
> -	if (kvm_arch_has_private_mem(kvm))
> +	if (kvm_arch_supports_gmem(kvm))
>  		valid_flags |=3D KVM_MEM_GUEST_MEMFD;
> =20
>  	/* Dirty logging private memory is not currently supported. */

This should be renamed - the flag is valid only if guest_memfd is
supported and squarely matches kvm_arch_supports_gmem().

> @@ -2419,7 +2419,7 @@ static int kvm_vm_ioctl_clear_dirty_log(struct kvm =
*kvm,
>  #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
>  static u64 kvm_supported_mem_attributes(struct kvm *kvm)
>  {
> -	if (!kvm || kvm_arch_has_private_mem(kvm))
> +	if (!kvm || kvm_arch_supports_gmem(kvm))
>  		return KVM_MEMORY_ATTRIBUTE_PRIVATE;
> =20
>  	return 0;

This should remain as kvm_arch_has_private_mem().

There's a little issue when mmap support is added: generally for the VM
(for non-guest_memfd memslots in this VM), KVM_MEMORY_ATTRIBUTE_PRIVATE
should be supported, but specifically for some ranges that belong to
guest_memfd-only memslots, KVM_MEMORY_ATTRIBUTE_PRIVATE should not be
supported?

I think kvm_supported_mem_attributes() respond generically for the
entire VM, so leaving this as kvm_arch_has_private_mem() is correct.

> @@ -4912,7 +4912,7 @@ static int kvm_vm_ioctl_check_extension_generic(str=
uct kvm *kvm, long arg)
>  #endif
>  #ifdef CONFIG_KVM_GMEM
>  	case KVM_CAP_GUEST_MEMFD:
> -		return !kvm || kvm_arch_has_private_mem(kvm);
> +		return !kvm || kvm_arch_supports_gmem(kvm);
>  #endif
>  	default:
>  		break;

This should be renamed - the CAP is valid only if guest_memfd is
supported and squarely matches kvm_arch_supports_gmem().

> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 3d69da6d2d9e..4bc50c1e21bd 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1341,7 +1341,7 @@ struct kvm_arch {
>  	unsigned int indirect_shadow_pages;
>  	u8 mmu_valid_gen;
>  	u8 vm_type;
> -	bool has_private_mem;
> +	bool supports_gmem;
>  	bool has_protected_state;
>  	bool pre_fault_allowed;
>  	struct hlist_head mmu_page_hash[KVM_NUM_MMU_PAGES];
> @@ -2270,7 +2270,7 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_for=
ced_root_level,
> =20
> =20
>  #ifdef CONFIG_KVM_GMEM
> -#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.has_private_mem)
> +#define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)
>  #else
>  #define kvm_arch_supports_gmem(kvm) false
>  #endif
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e7ecf089780a..c4e10797610c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3488,7 +3488,7 @@ static bool page_fault_can_be_fast(struct kvm *kvm,=
 struct kvm_page_fault *fault
>  	 * on RET_PF_SPURIOUS until the update completes, or an actual spurious
>  	 * case might go down the slow path. Either case will resolve itself.
>  	 */
> -	if (kvm->arch.has_private_mem &&
> +	if (kvm->arch.supports_gmem &&
>  	    fault->is_private !=3D kvm_mem_is_private(kvm, fault->gfn))
>  		return false;
> =20

This check should remain as a check on has_private_mem.

If the VM supports private memory, skip fast page faults on fault type
and KVM memory privacy status mismatches.

> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ab9b947dbf4f..67ab05fd3517 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5180,8 +5180,8 @@ static int svm_vm_init(struct kvm *kvm)
>  			(type =3D=3D KVM_X86_SEV_ES_VM || type =3D=3D KVM_X86_SNP_VM);
>  		to_kvm_sev_info(kvm)->need_init =3D true;
> =20
> -		kvm->arch.has_private_mem =3D (type =3D=3D KVM_X86_SNP_VM);
> -		kvm->arch.pre_fault_allowed =3D !kvm->arch.has_private_mem;
> +		kvm->arch.supports_gmem =3D (type =3D=3D KVM_X86_SNP_VM);
> +		kvm->arch.pre_fault_allowed =3D !kvm->arch.supports_gmem;
>  	}
> =20
>  	if (!pause_filter_count || !pause_filter_thresh)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b58a74c1722d..401256ee817f 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12778,8 +12778,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lo=
ng type)
>  		return -EINVAL;
> =20
>  	kvm->arch.vm_type =3D type;
> -	kvm->arch.has_private_mem =3D
> -		(type =3D=3D KVM_X86_SW_PROTECTED_VM);
> +	kvm->arch.supports_gmem =3D (type =3D=3D KVM_X86_SW_PROTECTED_VM);
>  	/* Decided by the vendor code for other VM types.  */
>  	kvm->arch.pre_fault_allowed =3D
>  		type =3D=3D KVM_X86_DEFAULT_VM || type =3D=3D KVM_X86_SW_PROTECTED_VM;

and

> arch/x86/kvm/vmx/tdx.c: In function =E2=80=98tdx_vm_init=E2=80=99:
> arch/x86/kvm/vmx/tdx.c:627:18: error: =E2=80=98struct kvm_arch=E2=80=99 h=
as no member named =E2=80=98has_private_mem=E2=80=99
>   627 |         kvm->arch.has_private_mem =3D true;
>       |                  ^
> make[5]: *** [scripts/Makefile.build:287: arch/x86/kvm/vmx/tdx.o] Error 1

These three changes make me think that maybe .has_private_mem shouldn't
be a field at all and can be removed.

What if kvm_arch_has_private_mem() for x86 always checks for a specific
list of VM types? Something like this: on x86,

* kvm_arch_has_private_mem() will return true for
  KVM_X86_SW_PROTECTED_VM, KVM_X86_SNP_VM and KVM_X86_TDX_VM.
 =20
* kvm_arch_supports_gmem() will return true for KVM_X86_SW_PROTECTED_VM,
  KVM_X86_SNP_VM and KVM_X86_TDX_VM as well.

After mmap support, kvm_arch_supports_gmem() also return true for
KVM_X86_DEFAULT_VM, in addition to the original SW_PROTECTED, SNP and
TDX.

Patrick, Nikita, am I right that for KVM_X86_DEFAULT_VM to work with
mmap-able guest_memfd, the usage in page_fault_can_be_fast() need not be
updated, and that patch 10/18 in this series will be sufficient?

>> [...]


