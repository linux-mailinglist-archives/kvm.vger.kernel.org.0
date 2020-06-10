Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 521E11F5BB7
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 21:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgFJTCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 15:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726759AbgFJTCG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 15:02:06 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84412C03E96F
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 12:02:06 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id d21so1900583vsh.12
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 12:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XkZ55trzaUYm4ZN8iiWbYVBM5yaqKCA9LC0xYy1/Ppg=;
        b=j77jjoo7BrC8ciPGZh5G4XNFx0e/IBM+vJQKsFXGHoq2TXyMMOLL5IFSAOeVWYXIHX
         UUepAz4IhQ0AlzlRyIrLJDLHLN+OtKh3UbUcbB2FA8h2jPk0dBpfyHtdvHuw98gIMd/S
         XJqRGYa0RiMBLTj/KghRH1rEWrRVKCG5FkNT65MrWebia3qbZLyzgCVQzSovmX+pk/QO
         YLuGZoIPx1vpd9s1OPQZGxAui+c216eaaqJjwovF8i+u2NRGk6b5wFirQho+mZYNHiCo
         M4pT5y57eyroD64Cjkknjiy2l/c1llHRr6NKOVDCNXHHADTAr3hlsVP2nooHvKJ0+0Qv
         boAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XkZ55trzaUYm4ZN8iiWbYVBM5yaqKCA9LC0xYy1/Ppg=;
        b=J2My0xgeDckaN0gzo7OW2BbtF80ikG3frglv78C9ULT9GGYlNH8+0OIQrOQXQhOFkT
         uDJv8bqhkDob6jiDmlaz6hLYDytF5l9iTGzAL/YtmC65SwnKL+dn508xsPdqPrSAVmg4
         vT36RN6uu4MQNg25J2Z2Fs24CkXE/hplcZbi5F46bSm5GwD4JE697BG3oXHmiwoUGX9f
         1rQNyNliDOEwVu9Kn+d4Hli/kGOMBKidtlx7qc577IYjDEuo+OwLNYopG0wajJrb01Go
         rjKJXapnRpIT3hJUwjvn30+dcO8fdo/P0a9MZlpCMDW4H1RFosm4sHz5JUtXzzkWGU52
         C5tw==
X-Gm-Message-State: AOAM532+hlOgSSBvZrzG8aj8x7+At8ONiZP4jn/QoZr74gaGnDapBqbv
        MpoRF9zqRDchrn5e9tDyfsDHaQKErB9+caQxZeEsJw==
X-Google-Smtp-Source: ABdhPJw1h1etsAjqik8ZjlfcXh6LoIcFUCUxEYjPHBc2XH6MGt7HC0fZP7/Ar9KFOlcDw0D5NiX7gZFNtlTQQHnm/A4=
X-Received: by 2002:a67:af10:: with SMTP id v16mr4200556vsl.235.1591815725256;
 Wed, 10 Jun 2020 12:02:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com> <20200605213853.14959-15-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-15-sean.j.christopherson@intel.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Jun 2020 12:01:54 -0700
Message-ID: <CANgfPd_v31zC5-mKsT14hd7W=X2Pvg3RBPjn2d4tFSChdbsr3A@mail.gmail.com>
Subject: Re: [PATCH 14/21] KVM: Move x86's version of struct
 kvm_mmu_memory_cache to common code
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Marc Zyngier <maz@kernel.org>, Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Christoffer Dall <christoffer.dall@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Move x86's 'struct kvm_mmu_memory_cache' to common code in anticipation
> of moving the entire x86 implementation code to common KVM and reusing
> it for arm64 and MIPS.  Add a new architecture specific asm/kvm_types.h
> to control the existence and parameters of the struct.  The new header
> is needed to avoid a chicken-and-egg problem with asm/kvm_host.h as all
> architectures define instances of the struct in their vCPU structs.
>
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
> ---
>  arch/arm64/include/asm/kvm_types.h   |  6 ++++++
>  arch/mips/include/asm/kvm_types.h    |  5 +++++
>  arch/powerpc/include/asm/kvm_types.h |  5 +++++
>  arch/s390/include/asm/kvm_types.h    |  5 +++++
>  arch/x86/include/asm/kvm_host.h      | 13 -------------
>  arch/x86/include/asm/kvm_types.h     |  7 +++++++
>  include/linux/kvm_types.h            | 19 +++++++++++++++++++
>  7 files changed, 47 insertions(+), 13 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_types.h
>  create mode 100644 arch/mips/include/asm/kvm_types.h
>  create mode 100644 arch/powerpc/include/asm/kvm_types.h
>  create mode 100644 arch/s390/include/asm/kvm_types.h
>  create mode 100644 arch/x86/include/asm/kvm_types.h
>
> diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
> new file mode 100644
> index 000000000000..d0987007d581
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_types.h
> @@ -0,0 +1,6 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_ARM64_KVM_TYPES_H
> +#define _ASM_ARM64_KVM_TYPES_H
> +
> +#endif /* _ASM_ARM64_KVM_TYPES_H */
> +
> diff --git a/arch/mips/include/asm/kvm_types.h b/arch/mips/include/asm/kvm_types.h
> new file mode 100644
> index 000000000000..5efeb32a5926
> --- /dev/null
> +++ b/arch/mips/include/asm/kvm_types.h
> @@ -0,0 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_MIPS_KVM_TYPES_H
> +#define _ASM_MIPS_KVM_TYPES_H
> +
> +#endif /* _ASM_MIPS_KVM_TYPES_H */
> diff --git a/arch/powerpc/include/asm/kvm_types.h b/arch/powerpc/include/asm/kvm_types.h
> new file mode 100644
> index 000000000000..f627eceaa314
> --- /dev/null
> +++ b/arch/powerpc/include/asm/kvm_types.h
> @@ -0,0 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_POWERPC_KVM_TYPES_H
> +#define _ASM_POWERPC_KVM_TYPES_H
> +
> +#endif /* _ASM_POWERPC_KVM_TYPES_H */
> diff --git a/arch/s390/include/asm/kvm_types.h b/arch/s390/include/asm/kvm_types.h
> new file mode 100644
> index 000000000000..b66a81f8a354
> --- /dev/null
> +++ b/arch/s390/include/asm/kvm_types.h
> @@ -0,0 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_S390_KVM_TYPES_H
> +#define _ASM_S390_KVM_TYPES_H
> +
> +#endif /* _ASM_S390_KVM_TYPES_H */
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index fb99e6776e27..8e8fea13b6c7 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -193,8 +193,6 @@ struct x86_exception;
>  enum x86_intercept;
>  enum x86_intercept_stage;
>
> -#define KVM_NR_MEM_OBJS 40
> -
>  #define KVM_NR_DB_REGS 4
>
>  #define DR6_BD         (1 << 13)
> @@ -245,17 +243,6 @@ enum x86_intercept_stage;
>
>  struct kvm_kernel_irq_routing_entry;
>
> -/*
> - * We don't want allocation failures within the mmu code, so we preallocate
> - * enough memory for a single page fault in a cache.
> - */
> -struct kvm_mmu_memory_cache {
> -       int nobjs;
> -       gfp_t gfp_zero;
> -       struct kmem_cache *kmem_cache;
> -       void *objects[KVM_NR_MEM_OBJS];
> -};
> -
>  /*
>   * the pages used as guest page table on soft mmu are tracked by
>   * kvm_memory_slot.arch.gfn_track which is 16 bits, so the role bits used
> diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
> new file mode 100644
> index 000000000000..08f1b57d3b62
> --- /dev/null
> +++ b/arch/x86/include/asm/kvm_types.h
> @@ -0,0 +1,7 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_X86_KVM_TYPES_H
> +#define _ASM_X86_KVM_TYPES_H
> +
> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> +
> +#endif /* _ASM_X86_KVM_TYPES_H */
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 68e84cf42a3f..a7580f69dda0 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -20,6 +20,8 @@ enum kvm_mr_change;
>
>  #include <linux/types.h>
>
> +#include <asm/kvm_types.h>
> +
>  /*
>   * Address types:
>   *
> @@ -58,4 +60,21 @@ struct gfn_to_pfn_cache {
>         bool dirty;
>  };
>
> +#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> +/*
> + * Memory caches are used to preallocate memory ahead of various MMU flows,
> + * e.g. page fault handlers.  Gracefully handling allocation failures deep in
> + * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
> + * holding MMU locks.  Note, these caches act more like prefetch buffers than
> + * classical caches, i.e. objects are not returned to the cache on being freed.
> + */
> +struct kvm_mmu_memory_cache {
> +       int nobjs;
> +       gfp_t gfp_zero;
> +       struct kmem_cache *kmem_cache;
> +       void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> +};
> +#endif
> +
> +
>  #endif /* __KVM_TYPES_H__ */
> --
> 2.26.0
>
