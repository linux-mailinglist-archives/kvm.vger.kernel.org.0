Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78CF3AF30F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 00:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfIJWwB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Sep 2019 18:52:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:4058 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725876AbfIJWwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Sep 2019 18:52:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Sep 2019 15:52:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,490,1559545200"; 
   d="scan'208";a="185649976"
Received: from lxy-dell.sh.intel.com ([10.239.159.46])
  by fmsmga007.fm.intel.com with ESMTP; 10 Sep 2019 15:51:59 -0700
Message-ID: <6ce6567e286b4432d62a730dd1697a3592c36a82.camel@intel.com>
Subject: Re: [PATCH v2 2/2] KVM: CPUID: Put maxphyaddr updating together
 with virtual address width checking
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>
Date:   Wed, 11 Sep 2019 06:45:44 +0800
In-Reply-To: <CALMp9eSbiZn6KtJ-aQuqmWZ+UBte1=hVa2V0qzLYrGqKPcP8fg@mail.gmail.com>
References: <20190910102742.47729-1-xiaoyao.li@intel.com>
         <20190910102742.47729-3-xiaoyao.li@intel.com>
         <CALMp9eSbiZn6KtJ-aQuqmWZ+UBte1=hVa2V0qzLYrGqKPcP8fg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2019-09-10 at 10:13 -0700, Jim Mattson wrote:
> On Tue, Sep 10, 2019 at 3:42 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> > 
> > Since both of maxphyaddr updating and virtual address width checking
> > need to query the cpuid leaf 0x80000008. We can put them together.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > ---
> >  arch/x86/kvm/cpuid.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 67fa44ab87af..fd0a66079001 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -118,6 +118,7 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> >                 best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> > 
> >         /*
> > +        * Update physical address width and check virtual address width.
> >          * The existing code assumes virtual address is 48-bit or 57-bit in
> > the
> >          * canonical address checks; exit if it is ever changed.
> >          */
> > @@ -127,7 +128,10 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> > 
> >                 if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
> >                         return -EINVAL;
> > +
> > +               vcpu->arch.maxphyaddr = best->eax & 0xff;
> >         }
> > +       vcpu->arch.maxphyaddr = 36;
> 
> Perhaps I'm missing something, but it looks to me like you always set
> vcpu->arch.maxphyaddr to 36, regardless of what may be enumerated by
> leaf 0x80000008.

Oh, I made a stupid mistake. It should be included in the else case.
 
> 
> Is there really much of an advantage to open-coding
> cpuid_query_maxphyaddr() here?

Indeed not so much.
It can avoid two more kvm_find_cpuid_entry() calling that we don't handle leaf
0x80000008 twice in two place. 

> >         best = kvm_find_cpuid_entry(vcpu, KVM_CPUID_FEATURES, 0);
> >         if (kvm_hlt_in_guest(vcpu->kvm) && best &&
> > @@ -144,8 +148,6 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> >                 }
> >         }
> > 
> > -       /* Update physical-address width */
> > -       vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
> >         kvm_mmu_reset_context(vcpu);
> > 
> >         kvm_pmu_refresh(vcpu);
> > --
> > 2.19.1
> > 

