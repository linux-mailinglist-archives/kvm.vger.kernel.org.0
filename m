Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 930CDE0B9B
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 20:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732606AbfJVSll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 14:41:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:11748 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbfJVSlk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 14:41:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 11:41:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,217,1569308400"; 
   d="scan'208";a="222915653"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 22 Oct 2019 11:41:39 -0700
Date:   Tue, 22 Oct 2019 11:41:39 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Christoffer Dall <christoffer.dall@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm-ppc@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        kvm@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cornelia Huck <cohuck@redhat.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvmarm@lists.cs.columbia.edu, Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 42/45] KVM: arm64: Free sve_state via arm specific hook
Message-ID: <20191022184139.GK2343@linux.intel.com>
References: <20191022015925.31916-1-sean.j.christopherson@intel.com>
 <20191022015925.31916-43-sean.j.christopherson@intel.com>
 <20191022114342.GB2652@e113682-lin.lund.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022114342.GB2652@e113682-lin.lund.arm.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 22, 2019 at 01:43:42PM +0200, Christoffer Dall wrote:
> On Mon, Oct 21, 2019 at 06:59:22PM -0700, Sean Christopherson wrote:
> > Add an arm specific hook to free the arm64-only sve_state.  Doing so
> > eliminates the last functional code from kvm_arch_vcpu_uninit() across
> > all architectures and paves the way for removing kvm_arch_vcpu_init()
> > and kvm_arch_vcpu_uninit() entirely.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/arm/include/asm/kvm_host.h   | 1 +
> >  arch/arm64/include/asm/kvm_host.h | 1 +
> >  arch/arm64/kvm/reset.c            | 5 +++++
> >  virt/kvm/arm/arm.c                | 2 ++
> >  4 files changed, 9 insertions(+)
> > 
> > diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> > index 8a37c8e89777..cc414de5acd3 100644
> > --- a/arch/arm/include/asm/kvm_host.h
> > +++ b/arch/arm/include/asm/kvm_host.h
> > @@ -333,6 +333,7 @@ static inline void kvm_arch_sync_events(struct kvm *kvm) {}
> >  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
> >  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> >  static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
> > +static inline int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu) {}
> >  
> >  static inline void kvm_arm_init_debug(void) {}
> >  static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f656169db8c3..92d7c384a4ed 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -52,6 +52,7 @@ int kvm_arm_init_sve(void);
> >  
> >  int __attribute_const__ kvm_target_cpu(void);
> >  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> > +int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
> >  void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu);
> >  int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext);
> >  void __extended_idmap_trampoline(phys_addr_t boot_pgd, phys_addr_t idmap_start);
> > diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> > index f4a8ae918827..98abc4278f42 100644
> > --- a/arch/arm64/kvm/reset.c
> > +++ b/arch/arm64/kvm/reset.c
> > @@ -205,6 +205,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
> >  }
> >  
> >  void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
> > +{
> > +
> > +}
> > +
> > +int kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
> >  {
> >  	kfree(vcpu->arch.sve_state);
> >  }
> 
> nit: warning: control reaches end of non-void function

Doh, fixed.  Thanks for the quick review!
