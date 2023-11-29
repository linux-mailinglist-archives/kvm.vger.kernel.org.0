Return-Path: <kvm+bounces-2748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 830497FD2F8
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 10:39:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E3556283142
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 09:39:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28C4D18AE7;
	Wed, 29 Nov 2023 09:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="myoOwtYn"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB971BD4;
	Wed, 29 Nov 2023 01:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1701250743;
	bh=vsrPdG817FSeXCk8MleL83TvHrXPh57pIp04z21H6/U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=myoOwtYnCMYNkSic9zkY8PttdYTgpbf4PL7ltVmiCcjFDDHamvpvFsbPNb5ijDUmL
	 /TpbvQtdmVfVWR+njBWEGRP92NjOV5+MZQaX+tT89yOGy8xnklIfEunWGvAO7qhC8O
	 gT3a7LpOh5roXxVSpgc34BoYlbs1qN2ZqeqB+tkQi/cq/vRGIdQ6gtBxxE68+B6k4i
	 bYNiLeavOIdFfO73cqyMi9+84hbh5vDQJZlxxEqHgEVKoICfhApON15kYD+5UgsOr+
	 89EIItQ+H6NgAGLE4Ijuygow0sOrow+YyHqye6OErP4sEbng//26tIroIU1W0W/3dG
	 Dt/Jm7l9QS0Ow==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4SgDmP5ZxZz4xSy;
	Wed, 29 Nov 2023 20:39:01 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Borislav Petkov <bp@alien8.de>, Catalin
 Marinas <catalin.marinas@arm.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, Janosch Frank
 <frankja@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens
 <hca@linux.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Claudio Imbrenda
 <imbrenda@linux.ibm.com>, James Morse <james.morse@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, Marc Zyngier <maz@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, Oliver Upton
 <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, Sven
 Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Will
 Deacon <will@kernel.org>, x86@kernel.org, Zenghui Yu
 <yuzenghui@huawei.com>
Subject: Re: Ping? Re: [PATCH rc] kvm: Prevent compiling virt/kvm/vfio.c
 unless VFIO is selected
In-Reply-To: <ZWagNsu1XQIqk5z9@google.com>
References: <0-v1-08396538817d+13c5-vfio_kvm_kconfig_jgg@nvidia.com>
 <87edgy87ig.fsf@mail.lhotse> <ZWagNsu1XQIqk5z9@google.com>
Date: Wed, 29 Nov 2023 20:38:54 +1100
Message-ID: <875y1k3nm9.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:
> On Fri, Nov 10, 2023, Michael Ellerman wrote:
>> Jason Gunthorpe <jgg@nvidia.com> writes:
>> > There are a bunch of reported randconfig failures now because of this,
>> > something like:
>> >
>> >>> arch/powerpc/kvm/../../../virt/kvm/vfio.c:89:7: warning: attribute declaration must precede definition [-Wignored-attributes]
>> >            fn = symbol_get(vfio_file_iommu_group);
>> >                 ^
>> >    include/linux/module.h:805:60: note: expanded from macro 'symbol_get'
>> >    #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak,visibility("hidden"))); &(x); })
>> >
>> > It happens because the arch forces KVM_VFIO without knowing if VFIO is
>> > even enabled.
>> 
>> This is still breaking some builds. Can we get this fix in please?
>> 
>> cheers
>> 
>> > Split the kconfig so the arch selects the usual HAVE_KVM_ARCH_VFIO and
>> > then KVM_VFIO is only enabled if the arch wants it and VFIO is turned on.
>
> Heh, so I was trying to figure out why things like vfio_file_set_kvm() aren't
> problematic, i.e. why the existing mess didn't cause failures.  I can't repro the
> warning (requires clang-16?), but IIUC the reason only the group code is problematic
> is that vfio.h creates a stub for vfio_file_iommu_group() and thus there's no symbol,
> whereas vfio.h declares vfio_file_set_kvm() unconditionally.

That warning I'm unsure about.

But the final report linked in Jason's mail shows a different one:

   In file included from arch/powerpc/kvm/../../../virt/kvm/vfio.c:17:
   include/linux/vfio.h: In function 'kvm_vfio_file_iommu_group':
   include/linux/vfio.h:294:35: error: weak declaration of 'vfio_file_iommu_group' being applied to a already existing, static definition
     294 | static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
         |                                   ^~~~~~~~~~~~~~~~~~~~~

Which is simple to reproduce, just build ppc64le_defconfig and then turn
off CONFIG_MODULES (I'm using GCC 13, the report is for GCC 12).

> Because KVM is doing symbol_get() and not taking a direct dependency, the lack of
> an exported symbol doesn't cause problems, i.e. simply declaring the symbol makes
> the compiler happy.
>
> Given that the vfio_file_iommu_group() stub shouldn't exist (KVM is the only user,
> and so if I'm correct the stub is worthless), what about this as a temporary "fix"?
>
> I'm 100% on-board with fixing KVM properly, my motivation is purely to minimize
> the total amount of churn.  E.g. if this works, then the only extra churn is to
> move the declaration of vfio_file_iommu_group() back under the #if, versus having
> to churn all of the KVM Kconfigs twice (once now, and again for the full cleanup).

Fine by me.

> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 454e9295970c..a65b2513f8cd 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -289,16 +289,12 @@ void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
>  /*
>   * External user API
>   */
> -#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  struct iommu_group *vfio_file_iommu_group(struct file *file);
> +
> +#if IS_ENABLED(CONFIG_VFIO_GROUP)
>  bool vfio_file_is_group(struct file *file);
>  bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
>  #else
> -static inline struct iommu_group *vfio_file_iommu_group(struct file *file)
> -{
> -       return NULL;
> -}
> -
>  static inline bool vfio_file_is_group(struct file *file)
>  {
>         return false;

That fixes the build for me.

Tested-by: Michael Ellerman <mpe@ellerman.id.au>


cheers

