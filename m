Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090F41F5E04
	for <lists+kvm@lfdr.de>; Wed, 10 Jun 2020 23:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgFJV6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jun 2020 17:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbgFJV6e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jun 2020 17:58:34 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF82C08C5C2
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 14:58:34 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id y123so2235843vsb.6
        for <kvm@vger.kernel.org>; Wed, 10 Jun 2020 14:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q55NYjy9IRmkKRciGyl293b435BFJrXWdUL8I09kIMU=;
        b=W6J9UkKFqBOh6IZVBDPOthBCXab0QZziKeEa8pn13Vr5J8K7h1X58Xb6OmuCCjEhOb
         92gem+OhVNk7kSF2F0BUdLkFKKg5ROVVbpsqxDgCpafDITiIZamI2Vry6Aog71jIZo8h
         NiD26bt+GKRoofdVOB/75RW7uwmApZl8QFmK1s6MT//oW9G+svD3zlytHSextcXbDuOv
         y9pQW8NIgzMZzDeYq/95xGCrFZR1LNU3HnOc4zwE/u+v8axp4rGvGkkNauOwDQCqQjf9
         2j8VU13YtK2Z4G+LXtKQblPwmmZ0YbNkS/g2LzBxhn7LOE6G4a9uJFutNjZyOutkrtp+
         BPZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q55NYjy9IRmkKRciGyl293b435BFJrXWdUL8I09kIMU=;
        b=QxdlI4RQtSDEs69DR3A3q4BvmiX8nmJhmQI/et7ke1KinRwkYxkI9H55ArY5P4ENJh
         KgeI5RHcCHw4yvI8Wr2evfEearJFN54BrMGMEpGLP41p2SQ0FhohPD11sn/Jd7eNYXeA
         cD1YxVriRm2b55xpHIjKOcCguttkEPbxZIRVN2FqDCRpEl8NZrSCX9/OnQO5hb0hyAwQ
         /MW9OPIN05CWvFKonq0OaNF7IpPgrbBW92AIuEAz/JEcv/vgj1EkbKyjdhRNuOJaFCiO
         hjy27Q9LtE5YUe5CRGaJKJR9B0LEaLX/mQUo1U5GwXCEok5l/GOFaRFjkF4H5L0TUmHr
         aJIQ==
X-Gm-Message-State: AOAM530RaWaBQQ7NodE6Ejv0I6TyeZzskljy/PSFnDh/EiDidjXLaWzH
        OjJI2z/yOhgeP3K7KOU+qFbAL3IjPImFmDM2U+bR4A==
X-Google-Smtp-Source: ABdhPJw6lF5ItCEwInvZaqrMjCHdyoCSi+CaoOEbwdfTwpuV0Gz1ZwsXr/d3YOGarQap09er1s6bIDnIsVVF9gciZiY=
X-Received: by 2002:a67:f982:: with SMTP id b2mr4385200vsq.202.1591826312742;
 Wed, 10 Jun 2020 14:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-15-sean.j.christopherson@intel.com> <CANgfPd_v31zC5-mKsT14hd7W=X2Pvg3RBPjn2d4tFSChdbsr3A@mail.gmail.com>
In-Reply-To: <CANgfPd_v31zC5-mKsT14hd7W=X2Pvg3RBPjn2d4tFSChdbsr3A@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 10 Jun 2020 14:58:21 -0700
Message-ID: <CANgfPd-iH8AShSPPJiaDCxV1H76kfpTOQMZSMP_+nP3LoXbYBg@mail.gmail.com>
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

On Wed, Jun 10, 2020 at 12:01 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Move x86's 'struct kvm_mmu_memory_cache' to common code in anticipation
> > of moving the entire x86 implementation code to common KVM and reusing
> > it for arm64 and MIPS.  Add a new architecture specific asm/kvm_types.h
> > to control the existence and parameters of the struct.  The new header
> > is needed to avoid a chicken-and-egg problem with asm/kvm_host.h as all
> > architectures define instances of the struct in their vCPU structs.
> >
> > Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Ben Gardon <bgardon@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_types.h   |  6 ++++++
> >  arch/mips/include/asm/kvm_types.h    |  5 +++++
> >  arch/powerpc/include/asm/kvm_types.h |  5 +++++
> >  arch/s390/include/asm/kvm_types.h    |  5 +++++
> >  arch/x86/include/asm/kvm_host.h      | 13 -------------
> >  arch/x86/include/asm/kvm_types.h     |  7 +++++++
> >  include/linux/kvm_types.h            | 19 +++++++++++++++++++
> >  7 files changed, 47 insertions(+), 13 deletions(-)
> >  create mode 100644 arch/arm64/include/asm/kvm_types.h
> >  create mode 100644 arch/mips/include/asm/kvm_types.h
> >  create mode 100644 arch/powerpc/include/asm/kvm_types.h
> >  create mode 100644 arch/s390/include/asm/kvm_types.h
> >  create mode 100644 arch/x86/include/asm/kvm_types.h
> >
> > diff --git a/arch/arm64/include/asm/kvm_types.h b/arch/arm64/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..d0987007d581
> > --- /dev/null
> > +++ b/arch/arm64/include/asm/kvm_types.h
> > @@ -0,0 +1,6 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_ARM64_KVM_TYPES_H
> > +#define _ASM_ARM64_KVM_TYPES_H
> > +
> > +#endif /* _ASM_ARM64_KVM_TYPES_H */
> > +
> > diff --git a/arch/mips/include/asm/kvm_types.h b/arch/mips/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..5efeb32a5926
> > --- /dev/null
> > +++ b/arch/mips/include/asm/kvm_types.h
> > @@ -0,0 +1,5 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_MIPS_KVM_TYPES_H
> > +#define _ASM_MIPS_KVM_TYPES_H
> > +
> > +#endif /* _ASM_MIPS_KVM_TYPES_H */
> > diff --git a/arch/powerpc/include/asm/kvm_types.h b/arch/powerpc/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..f627eceaa314
> > --- /dev/null
> > +++ b/arch/powerpc/include/asm/kvm_types.h
> > @@ -0,0 +1,5 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_POWERPC_KVM_TYPES_H
> > +#define _ASM_POWERPC_KVM_TYPES_H
> > +
> > +#endif /* _ASM_POWERPC_KVM_TYPES_H */
> > diff --git a/arch/s390/include/asm/kvm_types.h b/arch/s390/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..b66a81f8a354
> > --- /dev/null
> > +++ b/arch/s390/include/asm/kvm_types.h
> > @@ -0,0 +1,5 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_S390_KVM_TYPES_H
> > +#define _ASM_S390_KVM_TYPES_H
> > +
> > +#endif /* _ASM_S390_KVM_TYPES_H */
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index fb99e6776e27..8e8fea13b6c7 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -193,8 +193,6 @@ struct x86_exception;
> >  enum x86_intercept;
> >  enum x86_intercept_stage;
> >
> > -#define KVM_NR_MEM_OBJS 40
> > -
Oops I didn't catch this on my first read through, but in patch 16 in
this series I see some references to KVM_NR_MEM_OBJS being removed. As
a result I would not expect this patch to build. Other references to
this value should probably replaced with
KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE as well.
> >  #define KVM_NR_DB_REGS 4
> >
> >  #define DR6_BD         (1 << 13)
> > @@ -245,17 +243,6 @@ enum x86_intercept_stage;
> >
> >  struct kvm_kernel_irq_routing_entry;
> >
> > -/*
> > - * We don't want allocation failures within the mmu code, so we preallocate
> > - * enough memory for a single page fault in a cache.
> > - */
> > -struct kvm_mmu_memory_cache {
> > -       int nobjs;
> > -       gfp_t gfp_zero;
> > -       struct kmem_cache *kmem_cache;
> > -       void *objects[KVM_NR_MEM_OBJS];
> > -};
> > -
> >  /*
> >   * the pages used as guest page table on soft mmu are tracked by
> >   * kvm_memory_slot.arch.gfn_track which is 16 bits, so the role bits used
> > diff --git a/arch/x86/include/asm/kvm_types.h b/arch/x86/include/asm/kvm_types.h
> > new file mode 100644
> > index 000000000000..08f1b57d3b62
> > --- /dev/null
> > +++ b/arch/x86/include/asm/kvm_types.h
> > @@ -0,0 +1,7 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +#ifndef _ASM_X86_KVM_TYPES_H
> > +#define _ASM_X86_KVM_TYPES_H
> > +
> > +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> > +
> > +#endif /* _ASM_X86_KVM_TYPES_H */
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index 68e84cf42a3f..a7580f69dda0 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -20,6 +20,8 @@ enum kvm_mr_change;
> >
> >  #include <linux/types.h>
> >
> > +#include <asm/kvm_types.h>
> > +
> >  /*
> >   * Address types:
> >   *
> > @@ -58,4 +60,21 @@ struct gfn_to_pfn_cache {
> >         bool dirty;
> >  };
> >
> > +#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> > +/*
> > + * Memory caches are used to preallocate memory ahead of various MMU flows,
> > + * e.g. page fault handlers.  Gracefully handling allocation failures deep in
> > + * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
> > + * holding MMU locks.  Note, these caches act more like prefetch buffers than
> > + * classical caches, i.e. objects are not returned to the cache on being freed.
> > + */
> > +struct kvm_mmu_memory_cache {
> > +       int nobjs;
> > +       gfp_t gfp_zero;
> > +       struct kmem_cache *kmem_cache;
> > +       void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> > +};
> > +#endif
> > +
> > +
> >  #endif /* __KVM_TYPES_H__ */
> > --
> > 2.26.0
> >
