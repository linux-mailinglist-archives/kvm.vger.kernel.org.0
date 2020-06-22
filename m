Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BCB2036A2
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 14:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgFVMVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 08:21:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57340 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728040AbgFVMVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 08:21:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592828513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fYzKPLPflHMIJ/16U5Az3dx3A/vPm3mOqM/+lY1oto8=;
        b=LGBFM9gHHA27Nhl9ePu0I1rkhPgYpledGtAi4M5mMa4+2vU8tvrIMl843jeHo6KcEolT05
        YR8KvLDvU8Ycq+THqBUTZIhmgyDIthu1kEZB7nQg2adm37LpY4gGcyZzxsvMS0abzGPDpp
        P2jawBmrar/k36LIWZZ3p73O5UoaxAc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242--JYeqed9MDebFqPIERQNlQ-1; Mon, 22 Jun 2020 08:21:49 -0400
X-MC-Unique: -JYeqed9MDebFqPIERQNlQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E8A10100A8F9;
        Mon, 22 Jun 2020 12:21:47 +0000 (UTC)
Received: from ovpn-115-200.ams2.redhat.com (ovpn-115-200.ams2.redhat.com [10.36.115.200])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B38C10013D2;
        Mon, 22 Jun 2020 12:21:41 +0000 (UTC)
Message-ID: <d57b5443b2d693be984f8df19253a1f656ae1f95.camel@redhat.com>
Subject: Re: [PATCH v2 01/11] KVM: x86: Add helper functions for illegal GPA
 checking and page fault injection
From:   Mohammed Gamal <mgamal@redhat.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, thomas.lendacky@amd.com,
        babu.moger@amd.com
Date:   Mon, 22 Jun 2020 14:21:38 +0200
In-Reply-To: <20200622044453.6t5ssz6hwvnaujwf@yy-desk-7060>
References: <20200619153925.79106-1-mgamal@redhat.com>
         <20200619153925.79106-2-mgamal@redhat.com>
         <20200622044453.6t5ssz6hwvnaujwf@yy-desk-7060>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2020-06-22 at 12:44 +0800, Yuan Yao wrote:
> On Fri, Jun 19, 2020 at 05:39:15PM +0200, Mohammed Gamal wrote:
> > This patch adds two helper functions that will be used to support
> > virtualizing
> > MAXPHYADDR in both kvm-intel.ko and kvm.ko.
> > 
> > kvm_fixup_and_inject_pf_error() injects a page fault for a user-
> > specified GVA,
> > while kvm_mmu_is_illegal_gpa() checks whether a GPA exceeds vCPU
> > address limits.
> > 
> > Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/mmu.h |  6 ++++++
> >  arch/x86/kvm/x86.c | 21 +++++++++++++++++++++
> >  arch/x86/kvm/x86.h |  1 +
> >  3 files changed, 28 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> > index 0ad06bfe2c2c..555237dfb91c 100644
> > --- a/arch/x86/kvm/mmu.h
> > +++ b/arch/x86/kvm/mmu.h
> > @@ -4,6 +4,7 @@
> >  
> >  #include <linux/kvm_host.h>
> >  #include "kvm_cache_regs.h"
> > +#include "cpuid.h"
> >  
> >  #define PT64_PT_BITS 9
> >  #define PT64_ENT_PER_PAGE (1 << PT64_PT_BITS)
> > @@ -158,6 +159,11 @@ static inline bool is_write_protection(struct
> > kvm_vcpu *vcpu)
> >  	return kvm_read_cr0_bits(vcpu, X86_CR0_WP);
> >  }
> >  
> > +static inline bool kvm_mmu_is_illegal_gpa(struct kvm_vcpu *vcpu,
> > gpa_t gpa)
> > +{
> > +        return (gpa >= BIT_ULL(cpuid_maxphyaddr(vcpu)));
> > +}
> > +
> >  /*
> >   * Check if a given access (described through the I/D, W/R and U/S
> > bits of a
> >   * page fault error code pfec) causes a permission fault with the
> > given PTE
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 00c88c2f34e4..ac8642e890b1 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10693,6 +10693,27 @@ u64 kvm_spec_ctrl_valid_bits(struct
> > kvm_vcpu *vcpu)
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
> >  
> > +void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t
> > gva, u16 error_code)
> > +{
> > +	struct x86_exception fault;
> > +
> > +	if (!(error_code & PFERR_PRESENT_MASK) ||
> > +	    vcpu->arch.walk_mmu->gva_to_gpa(vcpu, gva, error_code,
> > &fault) != UNMAPPED_GVA) {
> > +		/*
> > +		 * If vcpu->arch.walk_mmu->gva_to_gpa succeeded, the
> > page
> > +		 * tables probably do not match the TLB.  Just proceed
> > +		 * with the error code that the processor gave.
> > +		 */
> > +		fault.vector = PF_VECTOR;
> > +		fault.error_code_valid = true;
> > +		fault.error_code = error_code;
> > +		fault.nested_page_fault = false;
> > +		fault.address = gva;
> > +	}
> > +	vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault);
> 
> Should this "vcpu->arch.walk_mmu->inject_page_fault(vcpu, &fault)"
> inside the last brace?
> Otherwise an uninitialized fault variable will be passed to the
> walk_mmu->inject_page_fault.

Good catch. You're right. Will fix it in v3

> 
> > +}
> > +EXPORT_SYMBOL_GPL(kvm_fixup_and_inject_pf_error);
> > +
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
> >  EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_inj_virq);
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 6eb62e97e59f..239ae0f3e40b 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -272,6 +272,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32
> > msr, u64 *pdata);
> >  bool kvm_mtrr_check_gfn_range_consistency(struct kvm_vcpu *vcpu,
> > gfn_t gfn,
> >  					  int page_num);
> >  bool kvm_vector_hashing_enabled(void);
> > +void kvm_fixup_and_inject_pf_error(struct kvm_vcpu *vcpu, gva_t
> > gva, u16 error_code);
> >  int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t
> > cr2_or_gpa,
> >  			    int emulation_type, void *insn, int
> > insn_len);
> >  fastpath_t handle_fastpath_set_msr_irqoff(struct kvm_vcpu *vcpu);
> > -- 
> > 2.26.2
> > 

