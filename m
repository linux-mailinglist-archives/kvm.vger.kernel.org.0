Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 180DF1F6BC1
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 18:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgFKP74 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 11:59:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:55844 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbgFKP7z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jun 2020 11:59:55 -0400
IronPort-SDR: bY+V2ayMw4QpqINsoRDdT77eDGmYNPuAhXUy7OYV36KlfrAHn3CQwzULzUgfeCc2TBvuBJWnkN
 vyb215Ef2quw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 08:59:55 -0700
IronPort-SDR: vlQ6xqosUXqm2IK2atrupqAhPka9ERniiyAolofQ9QLnlgU84Ttdpz9HijVivDLr/IVeArXiV+
 xSQxjn+bUQsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,499,1583222400"; 
   d="scan'208";a="306964950"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by orsmga008.jf.intel.com with ESMTP; 11 Jun 2020 08:59:54 -0700
Date:   Thu, 11 Jun 2020 08:59:54 -0700
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
Subject: Re: [PATCH 16/21] KVM: arm64: Drop @max param from
 mmu_topup_memory_cache()
Message-ID: <20200611155954.GH29918@linux.intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-17-sean.j.christopherson@intel.com>
 <CANgfPd-x=Af6Wdn9Wz=9r5CiHDCbxEgQhS2swALUMQd00oQ3jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd-x=Af6Wdn9Wz=9r5CiHDCbxEgQhS2swALUMQd00oQ3jg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 10, 2020 at 03:00:47PM -0700, Ben Gardon wrote:
> On Fri, Jun 5, 2020 at 2:39 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Replace the @max param in mmu_topup_memory_cache() and instead use
> > ARRAY_SIZE() to terminate the loop to fill the cache.  This removes a
> > BUG_ON() and sets the stage for moving arm64 to the common memory cache
> > implementation.
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index a1f6bc70c4e4..9398b66f8a87 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -124,15 +124,13 @@ static void stage2_dissolve_pud(struct kvm *kvm, phys_addr_t addr, pud_t *pudp)
> >         put_page(virt_to_page(pudp));
> >  }
> >
> > -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache,
> > -                                 int min, int max)
> > +static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
> >  {
> >         void *page;
> >
> > -       BUG_ON(max > KVM_NR_MEM_OBJS);
> KVM_NR_MEM_OBJS should be undefined as of patch 14 in this series. I'd
> recommend changing this to use the new constant you defined in that
> patch.

My intent was to leave KVM_NR_MEM_OBJS defined by arm64 and MIPS until they
move to the common implementation, e.g. this should be defined in
arch/arm64/include/asm/kvm_host.h until patch 18.  I'll get cross-compiling
setup so I can properly test bisection before sending v2.

> >         if (cache->nobjs >= min)
> >                 return 0;
> > -       while (cache->nobjs < max) {
> > +       while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> >                 page = (void *)__get_free_page(GFP_PGTABLE_USER);
> >                 if (!page)
> >                         return -ENOMEM;
> > @@ -1356,8 +1354,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
> >                         pte = kvm_s2pte_mkwrite(pte);
> >
> >                 ret = mmu_topup_memory_cache(&cache,
> > -                                            kvm_mmu_cache_min_pages(kvm),
> > -                                            KVM_NR_MEM_OBJS);
> See above, KVM_NR_MEM_OBJS is undefined as of patch 14.
> > +                                            kvm_mmu_cache_min_pages(kvm));
> >                 if (ret)
> >                         goto out;
> >                 spin_lock(&kvm->mmu_lock);
> > @@ -1737,8 +1734,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >         up_read(&current->mm->mmap_sem);
> >
> >         /* We need minimum second+third level pages */
> > -       ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm),
> > -                                    KVM_NR_MEM_OBJS);
> See above, KVM_NR_MEM_OBJS is undefined as of patch 14.
> > +       ret = mmu_topup_memory_cache(memcache, kvm_mmu_cache_min_pages(kvm));
> >         if (ret)
> >                 return ret;
> >
> > --
> > 2.26.0
> >
