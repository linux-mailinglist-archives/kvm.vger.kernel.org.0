Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC352203D3D
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 18:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgFVQ5c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 12:57:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:43835 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729807AbgFVQ5b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 12:57:31 -0400
IronPort-SDR: q/tRks1hscFs2MNhMH5PButSYmFl+L/ggYNHf5xZCioFe++saGujHG+dSjYINvaarLidUDkE4J
 RhVk9bvYvtSg==
X-IronPort-AV: E=McAfee;i="6000,8403,9660"; a="161896136"
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="161896136"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2020 09:57:30 -0700
IronPort-SDR: S4VEirMcNhQ2lH0bAVvJJDP7s7VRkd36rpU/H5Pu+0zC5Ty7uMfI7DemqqyQV4/pP77ANcjPYf
 AXdGOcNkkbyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,268,1589266800"; 
   d="scan'208";a="384580750"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga001.fm.intel.com with ESMTP; 22 Jun 2020 09:57:30 -0700
Date:   Mon, 22 Jun 2020 09:57:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Ben Gardon <bgardon@google.com>
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
Subject: Re: [PATCH 14/21] KVM: Move x86's version of struct
 kvm_mmu_memory_cache to common code
Message-ID: <20200622165730.GD5150@linux.intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-15-sean.j.christopherson@intel.com>
 <CANgfPd_v31zC5-mKsT14hd7W=X2Pvg3RBPjn2d4tFSChdbsr3A@mail.gmail.com>
 <CANgfPd-iH8AShSPPJiaDCxV1H76kfpTOQMZSMP_+nP3LoXbYBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-iH8AShSPPJiaDCxV1H76kfpTOQMZSMP_+nP3LoXbYBg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 02:58:21PM -0700, Ben Gardon wrote:
> On Wed, Jun 10, 2020 at 12:01 PM Ben Gardon <bgardon@google.com> wrote:
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index fb99e6776e27..8e8fea13b6c7 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -193,8 +193,6 @@ struct x86_exception;
> > >  enum x86_intercept;
> > >  enum x86_intercept_stage;
> > >
> > > -#define KVM_NR_MEM_OBJS 40
> > > -
> Oops I didn't catch this on my first read through, but in patch 16 in
> this series I see some references to KVM_NR_MEM_OBJS being removed. As
> a result I would not expect this patch to build. Other references to
> this value should probably replaced with
> KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE as well.

This patch intentionally uses a different name for the #define (see below)
so that the existing arm64 and MIPS declarations don't get picked up by
common KVM code.  This is required so that arm64 and MIPS continue to use
their versions of the cache implementation until they are converted to the
common implementation later in the series, e.g. in patch 16 when the
references to KVM_NR_MEM_OBJS are removed.

I confirmed the above (after sending v1) by compiling all non-x86 changes
on arm64, MIPS, s390 and PPC to verify that this doesn't break bisection.

> > >  #define KVM_NR_DB_REGS 4
> > >
> > >  #define DR6_BD         (1 << 13)
> > > @@ -245,17 +243,6 @@ enum x86_intercept_stage;
> > >
> > >  struct kvm_kernel_irq_routing_entry;

...

> > > +#ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
> > > +/*
> > > + * Memory caches are used to preallocate memory ahead of various MMU flows,
> > > + * e.g. page fault handlers.  Gracefully handling allocation failures deep in
> > > + * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
> > > + * holding MMU locks.  Note, these caches act more like prefetch buffers than
> > > + * classical caches, i.e. objects are not returned to the cache on being freed.
> > > + */
> > > +struct kvm_mmu_memory_cache {
> > > +       int nobjs;
> > > +       gfp_t gfp_zero;
> > > +       struct kmem_cache *kmem_cache;
> > > +       void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> > > +};
> > > +#endif
> > > +
> > > +
> > >  #endif /* __KVM_TYPES_H__ */
> > > --
> > > 2.26.0
> > >
