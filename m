Return-Path: <kvm+bounces-46470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E84F3AB6864
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 12:07:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CC483B70C1
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 10:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5776326FA57;
	Wed, 14 May 2025 10:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="TBJP0K/t"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C91C1FC7E7;
	Wed, 14 May 2025 10:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747217263; cv=none; b=dgpajGao1rCd48a+3Vq2J/btRvNVMiAyRX3Fnwhx1FMpDujEYReN1qfpD3A6onMtTrwGfXamNUBPeC4RQQmgcLQIqSdS+/Uz+M5VmllMjsqdUXakj9tCCmzEk5uSxDbOP7fXpqKc2KQok/HLaeD+Doc4rbeIVVYQOLdh4iGNLXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747217263; c=relaxed/simple;
	bh=bzkJl6/jfNlb95QMNc7WxtN/cHw0kQWf9yJuT7evvWs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BtlA5RLqN0cayTmXZdbKuHBX17RKXELRH0u/vYrKg8Skn94S8nYWu7OVo7FHXApl8ApZVbHn3jY6gaqfTDAjW/hMEbV8EXclb562ZteE5OiqFZzlBYqSI/ZodnfoUIoFrO8narHd5JfL0bHPyMPgw3pLJM/NKt8o0qFAIXiJk4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=TBJP0K/t; arc=none smtp.client-ip=99.78.197.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1747217261; x=1778753261;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=O80ty1yqpXbTaL+UjBfL3mdZeaH2h46dgujCYTLNm4U=;
  b=TBJP0K/tcTSImdfCuLtlgXA4W5JmpbLqESzn9Wpi4W828Rvnww/dzt9O
   FtQ9zXXyHNtR4s2w5w6yBvLUQffBp62F7o1Q0z2tw2gS9bHoEW5dxlBR2
   XffGygenUdLhgLT58FqANylZWyCOkATvawAZ2v9yAEtvRELqPsU/2MDR/
   lxVe0zF3lKJpt5+6C002fB4ibDl5MpPBxsFsBG9y+Xj5MPMHD3Hpnve9K
   86Rho+jzynM0/lpUoq4DX4aJyRLB40YCP8SbJ5tDF/brqVMLbMB2XqsOm
   z45ZrkzD84E+tilY8SBHpt3/drdEtYtW9THPQZoHGLLoT4XpiF3wwKMEM
   w==;
X-IronPort-AV: E=Sophos;i="6.15,287,1739836800"; 
   d="scan'208";a="49833496"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2025 10:07:39 +0000
Received: from EX19MTAEUB002.ant.amazon.com [10.0.10.100:33366]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.6.93:2525] with esmtp (Farcaster)
 id 2c71b68b-6ba4-4eb9-bf75-92427a0e7f0b; Wed, 14 May 2025 10:07:37 +0000 (UTC)
X-Farcaster-Flow-ID: 2c71b68b-6ba4-4eb9-bf75-92427a0e7f0b
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 14 May 2025 10:07:35 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1544.14;
 Wed, 14 May 2025 10:07:35 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.1544.014; Wed, 14 May 2025 10:07:35 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "tabba@google.com" <tabba@google.com>
CC: "ackerleytng@google.com" <ackerleytng@google.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"amoorthy@google.com" <amoorthy@google.com>, "anup@brainfault.org"
	<anup@brainfault.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"brauner@kernel.org" <brauner@kernel.org>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "chenhuacai@kernel.org"
	<chenhuacai@kernel.org>, "david@redhat.com" <david@redhat.com>,
	"dmatlack@google.com" <dmatlack@google.com>, "fvdl@google.com"
	<fvdl@google.com>, "hch@infradead.org" <hch@infradead.org>,
	"hughd@google.com" <hughd@google.com>, "ira.weiny@intel.com"
	<ira.weiny@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"isaku.yamahata@intel.com" <isaku.yamahata@intel.com>, "james.morse@arm.com"
	<james.morse@arm.com>, "jarkko@kernel.org" <jarkko@kernel.org>,
	"jgg@nvidia.com" <jgg@nvidia.com>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"keirf@google.com" <keirf@google.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
	"linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "mail@maciej.szmigiero.name"
	<mail@maciej.szmigiero.name>, "maz@kernel.org" <maz@kernel.org>,
	"mic@digikod.net" <mic@digikod.net>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "mpe@ellerman.id.au" <mpe@ellerman.id.au>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	"paul.walmsley@sifive.com" <paul.walmsley@sifive.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"qperret@google.com" <qperret@google.com>, "quic_cvanscha@quicinc.com"
	<quic_cvanscha@quicinc.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "quic_mnalajal@quicinc.com"
	<quic_mnalajal@quicinc.com>, "quic_pderrin@quicinc.com"
	<quic_pderrin@quicinc.com>, "quic_pheragu@quicinc.com"
	<quic_pheragu@quicinc.com>, "quic_svaddagi@quicinc.com"
	<quic_svaddagi@quicinc.com>, "quic_tsoni@quicinc.com"
	<quic_tsoni@quicinc.com>, "rientjes@google.com" <rientjes@google.com>, "Roy,
 Patrick" <roypat@amazon.co.uk>, "seanjc@google.com" <seanjc@google.com>,
	"shuah@kernel.org" <shuah@kernel.org>, "steven.price@arm.com"
	<steven.price@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"wei.w.wang@intel.com" <wei.w.wang@intel.com>, "will@kernel.org"
	<will@kernel.org>, "willy@infradead.org" <willy@infradead.org>,
	"xiaoyao.li@intel.com" <xiaoyao.li@intel.com>, "yilun.xu@intel.com"
	<yilun.xu@intel.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>
Subject: Re: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
 guest_memfd() pages 
Thread-Topic: [PATCH v9 07/17] KVM: guest_memfd: Allow host to map
 guest_memfd() pages 
Thread-Index: AQHbxLgD+WjV4+XNDE2KBPZMSZ/lWA==
Date: Wed, 14 May 2025 10:07:34 +0000
Message-ID: <20250514100733.4079-1-roypat@amazon.co.uk>
References: <20250513163438.3942405-8-tabba@google.com>
In-Reply-To: <20250513163438.3942405-8-tabba@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-05-13 at 17:34 +0100, Fuad Tabba wrote:=0A=
> This patch enables support for shared memory in guest_memfd, including=0A=
> mapping that memory at the host userspace. This support is gated by the=
=0A=
> configuration option KVM_GMEM_SHARED_MEM, and toggled by the guest_memfd=
=0A=
> flag GUEST_MEMFD_FLAG_SUPPORT_SHARED, which can be set when creating a=0A=
> guest_memfd instance.=0A=
> =0A=
> Co-developed-by: Ackerley Tng <ackerleytng@google.com>=0A=
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>=0A=
> Signed-off-by: Fuad Tabba <tabba@google.com>=0A=
> ---=0A=
>  arch/x86/include/asm/kvm_host.h | 10 ++++=0A=
>  include/linux/kvm_host.h        | 13 +++++=0A=
>  include/uapi/linux/kvm.h        |  1 +=0A=
>  virt/kvm/Kconfig                |  5 ++=0A=
>  virt/kvm/guest_memfd.c          | 88 +++++++++++++++++++++++++++++++++=
=0A=
>  5 files changed, 117 insertions(+)=0A=
> =0A=
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h=0A=
> index 709cc2a7ba66..f72722949cae 100644=0A=
> --- a/arch/x86/include/asm/kvm_host.h=0A=
> +++ b/arch/x86/include/asm/kvm_host.h=0A=
> @@ -2255,8 +2255,18 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_fo=
rced_root_level,=0A=
> =0A=
>  #ifdef CONFIG_KVM_GMEM=0A=
>  #define kvm_arch_supports_gmem(kvm) ((kvm)->arch.supports_gmem)=0A=
> +=0A=
> +/*=0A=
> + * CoCo VMs with hardware support that use guest_memfd only for backing =
private=0A=
> + * memory, e.g., TDX, cannot use guest_memfd with userspace mapping enab=
led.=0A=
> + */=0A=
> +#define kvm_arch_vm_supports_gmem_shared_mem(kvm)                      \=
=0A=
> +       (IS_ENABLED(CONFIG_KVM_GMEM_SHARED_MEM) &&                      \=
=0A=
> +        ((kvm)->arch.vm_type =3D=3D KVM_X86_SW_PROTECTED_VM ||          =
   \=0A=
> +         (kvm)->arch.vm_type =3D=3D KVM_X86_DEFAULT_VM))=0A=
=0A=
I forgot what we ended up deciding wrt "allow guest_memfd usage for default=
 VMs=0A=
on x86" in the call two weeks ago, but if we want to do that as part of thi=
s=0A=
series, then this also needs =0A=
=0A=
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c=0A=
index 12433b1e755b..904b15c678d6 100644=0A=
--- a/arch/x86/kvm/x86.c=0A=
+++ b/arch/x86/kvm/x86.c=0A=
@@ -12716,7 +12716,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long=
 type)=0A=
                return -EINVAL;=0A=
 =0A=
        kvm->arch.vm_type =3D type;=0A=
-       kvm->arch.supports_gmem =3D (type =3D=3D KVM_X86_SW_PROTECTED_VM);=
=0A=
+       kvm->arch.supports_gmem =3D type =3D=3D KVM_X86_SW_PROTECTED_VM || =
type =3D=3D KVM_X86_DEFAULT_VM;=0A=
        /* Decided by the vendor code for other VM types.  */=0A=
        kvm->arch.pre_fault_allowed =3D=0A=
                type =3D=3D KVM_X86_DEFAULT_VM || type =3D=3D KVM_X86_SW_PR=
OTECTED_VM;=0A=
=0A=
and with that I was able to run my firecracker tests on top of this patch=
=0A=
series with X86_DEFAULT_VM. But I did wonder about this define in=0A=
x86/include/asm/kvm_host.h:=0A=
=0A=
/* SMM is currently unsupported for guests with guest_memfd (esp private) m=
emory. */=0A=
# define kvm_arch_nr_memslot_as_ids(kvm) (kvm_arch_supports_gmem(kvm) ? 1 :=
 2)=0A=
=0A=
which I'm not really sure what to make of, but which I think means enabling=
=0A=
guest_memfd for X86_DEFAULT_VM isn't as straight-forward as the above diff =
:/=0A=
=0A=
Best,=0A=
Patrick=0A=
=0A=
>  #else=0A=
>  #define kvm_arch_supports_gmem(kvm) false=0A=
> +#define kvm_arch_vm_supports_gmem_shared_mem(kvm) false=0A=
>  #endif=0A=
> =0A=
>  #define kvm_arch_has_readonly_mem(kvm) (!(kvm)->arch.has_protected_state=
)=0A=
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h=0A=
> index ae70e4e19700..2ec89c214978 100644=0A=
> --- a/include/linux/kvm_host.h=0A=
> +++ b/include/linux/kvm_host.h=0A=
> @@ -729,6 +729,19 @@ static inline bool kvm_arch_supports_gmem(struct kvm=
 *kvm)=0A=
>  }=0A=
>  #endif=0A=
> =0A=
> +/*=0A=
> + * Returns true if this VM supports shared mem in guest_memfd.=0A=
> + *=0A=
> + * Arch code must define kvm_arch_vm_supports_gmem_shared_mem if support=
 for=0A=
> + * guest_memfd is enabled.=0A=
> + */=0A=
> +#if !defined(kvm_arch_vm_supports_gmem_shared_mem) && !IS_ENABLED(CONFIG=
_KVM_GMEM)=0A=
> +static inline bool kvm_arch_vm_supports_gmem_shared_mem(struct kvm *kvm)=
=0A=
> +{=0A=
> +       return false;=0A=
> +}=0A=
> +#endif=0A=
> +=0A=
>  #ifndef kvm_arch_has_readonly_mem=0A=
>  static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)=0A=
>  {=0A=
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h=0A=
> index b6ae8ad8934b..9857022a0f0c 100644=0A=
> --- a/include/uapi/linux/kvm.h=0A=
> +++ b/include/uapi/linux/kvm.h=0A=
> @@ -1566,6 +1566,7 @@ struct kvm_memory_attributes {=0A=
>  #define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)=0A=
> =0A=
>  #define KVM_CREATE_GUEST_MEMFD _IOWR(KVMIO,  0xd4, struct kvm_create_gue=
st_memfd)=0A=
> +#define GUEST_MEMFD_FLAG_SUPPORT_SHARED        (1UL << 0)=0A=
> =0A=
>  struct kvm_create_guest_memfd {=0A=
>         __u64 size;=0A=
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig=0A=
> index 559c93ad90be..f4e469a62a60 100644=0A=
> --- a/virt/kvm/Kconfig=0A=
> +++ b/virt/kvm/Kconfig=0A=
> @@ -128,3 +128,8 @@ config HAVE_KVM_ARCH_GMEM_PREPARE=0A=
>  config HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
>         bool=0A=
>         depends on KVM_GMEM=0A=
> +=0A=
> +config KVM_GMEM_SHARED_MEM=0A=
> +       select KVM_GMEM=0A=
> +       bool=0A=
> +       prompt "Enables in-place shared memory for guest_memfd"=0A=
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c=0A=
> index 6db515833f61..8e6d1866b55e 100644=0A=
> --- a/virt/kvm/guest_memfd.c=0A=
> +++ b/virt/kvm/guest_memfd.c=0A=
> @@ -312,7 +312,88 @@ static pgoff_t kvm_gmem_get_index(struct kvm_memory_=
slot *slot, gfn_t gfn)=0A=
>         return gfn - slot->base_gfn + slot->gmem.pgoff;=0A=
>  }=0A=
> =0A=
> +#ifdef CONFIG_KVM_GMEM_SHARED_MEM=0A=
> +=0A=
> +static bool kvm_gmem_supports_shared(struct inode *inode)=0A=
> +{=0A=
> +       uint64_t flags =3D (uint64_t)inode->i_private;=0A=
> +=0A=
> +       return flags & GUEST_MEMFD_FLAG_SUPPORT_SHARED;=0A=
> +}=0A=
> +=0A=
> +static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)=0A=
> +{=0A=
> +       struct inode *inode =3D file_inode(vmf->vma->vm_file);=0A=
> +       struct folio *folio;=0A=
> +       vm_fault_t ret =3D VM_FAULT_LOCKED;=0A=
> +=0A=
> +       filemap_invalidate_lock_shared(inode->i_mapping);=0A=
> +=0A=
> +       folio =3D kvm_gmem_get_folio(inode, vmf->pgoff);=0A=
> +       if (IS_ERR(folio)) {=0A=
> +               int err =3D PTR_ERR(folio);=0A=
> +=0A=
> +               if (err =3D=3D -EAGAIN)=0A=
> +                       ret =3D VM_FAULT_RETRY;=0A=
> +               else=0A=
> +                       ret =3D vmf_error(err);=0A=
> +=0A=
> +               goto out_filemap;=0A=
> +       }=0A=
> +=0A=
> +       if (folio_test_hwpoison(folio)) {=0A=
> +               ret =3D VM_FAULT_HWPOISON;=0A=
> +               goto out_folio;=0A=
> +       }=0A=
> +=0A=
> +       if (WARN_ON_ONCE(folio_test_large(folio))) {=0A=
> +               ret =3D VM_FAULT_SIGBUS;=0A=
> +               goto out_folio;=0A=
> +       }=0A=
> +=0A=
> +       if (!folio_test_uptodate(folio)) {=0A=
> +               clear_highpage(folio_page(folio, 0));=0A=
> +               kvm_gmem_mark_prepared(folio);=0A=
> +       }=0A=
> +=0A=
> +       vmf->page =3D folio_file_page(folio, vmf->pgoff);=0A=
> +=0A=
> +out_folio:=0A=
> +       if (ret !=3D VM_FAULT_LOCKED) {=0A=
> +               folio_unlock(folio);=0A=
> +               folio_put(folio);=0A=
> +       }=0A=
> +=0A=
> +out_filemap:=0A=
> +       filemap_invalidate_unlock_shared(inode->i_mapping);=0A=
> +=0A=
> +       return ret;=0A=
> +}=0A=
> +=0A=
> +static const struct vm_operations_struct kvm_gmem_vm_ops =3D {=0A=
> +       .fault =3D kvm_gmem_fault_shared,=0A=
> +};=0A=
> +=0A=
> +static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)=
=0A=
> +{=0A=
> +       if (!kvm_gmem_supports_shared(file_inode(file)))=0A=
> +               return -ENODEV;=0A=
> +=0A=
> +       if ((vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) !=3D=0A=
> +           (VM_SHARED | VM_MAYSHARE)) {=0A=
> +               return -EINVAL;=0A=
> +       }=0A=
> +=0A=
> +       vma->vm_ops =3D &kvm_gmem_vm_ops;=0A=
> +=0A=
> +       return 0;=0A=
> +}=0A=
> +#else=0A=
> +#define kvm_gmem_mmap NULL=0A=
> +#endif /* CONFIG_KVM_GMEM_SHARED_MEM */=0A=
> +=0A=
>  static struct file_operations kvm_gmem_fops =3D {=0A=
> +       .mmap           =3D kvm_gmem_mmap,=0A=
>         .open           =3D generic_file_open,=0A=
>         .release        =3D kvm_gmem_release,=0A=
>         .fallocate      =3D kvm_gmem_fallocate,=0A=
> @@ -463,6 +544,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_creat=
e_guest_memfd *args)=0A=
>         u64 flags =3D args->flags;=0A=
>         u64 valid_flags =3D 0;=0A=
> =0A=
> +       if (kvm_arch_vm_supports_gmem_shared_mem(kvm))=0A=
> +               valid_flags |=3D GUEST_MEMFD_FLAG_SUPPORT_SHARED;=0A=
> +=0A=
>         if (flags & ~valid_flags)=0A=
>                 return -EINVAL;=0A=
> =0A=
> @@ -501,6 +585,10 @@ int kvm_gmem_bind(struct kvm *kvm, struct kvm_memory=
_slot *slot,=0A=
>             offset + size > i_size_read(inode))=0A=
>                 goto err;=0A=
> =0A=
> +       if (kvm_gmem_supports_shared(inode) &&=0A=
> +           !kvm_arch_vm_supports_gmem_shared_mem(kvm))=0A=
> +               goto err;=0A=
> +=0A=
>         filemap_invalidate_lock(inode->i_mapping);=0A=
> =0A=
>         start =3D offset >> PAGE_SHIFT;=0A=
> --=0A=
> 2.49.0.1045.g170613ef41-goog=0A=
> =0A=
=0A=

