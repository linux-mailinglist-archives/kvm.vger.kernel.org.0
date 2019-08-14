Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0EBB8D62F
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 16:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfHNOcX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 10:32:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:22714 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726121AbfHNOcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 10:32:23 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Aug 2019 07:32:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,385,1559545200"; 
   d="scan'208";a="200896824"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 14 Aug 2019 07:32:20 -0700
Date:   Wed, 14 Aug 2019 22:34:01 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, yu.c.zhang@intel.com, alazar@bitdefender.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for
 SPP
Message-ID: <20190814143401.GA7847@local-michael-cet-test.sh.intel.com>
References: <20190814070403.6588-1-weijiang.yang@intel.com>
 <20190814070403.6588-6-weijiang.yang@intel.com>
 <87a7cbapdw.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a7cbapdw.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 14, 2019 at 02:43:39PM +0200, Vitaly Kuznetsov wrote:
> Yang Weijiang <weijiang.yang@intel.com> writes:
> 
> > init_spp() must be called before {get, set}_subpage
> > functions, it creates subpage access bitmaps for memory pages
> > and issues a KVM request to setup SPPT root pages.
> >
> > kvm_mmu_set_subpages() is to enable SPP bit in EPT leaf page
> > and setup corresponding SPPT entries. The mmu_lock
> > is held before above operation. If it's called in EPT fault and
> > SPPT mis-config induced handler, mmu_lock is acquired outside
> > the function, otherwise, it's acquired inside it.
> >
> > kvm_mmu_get_subpages() is used to query access bitmap for
> > protected page, it's also used in EPT fault handler to check
> > whether the fault EPT page is SPP protected as well.
> >
> > Co-developed-by: He Chen <he.chen@linux.intel.com>
> > Signed-off-by: He Chen <he.chen@linux.intel.com>
> > Co-developed-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Zhang Yi <yi.z.zhang@linux.intel.com>
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h |  18 ++++
> >  arch/x86/include/asm/vmx.h      |   2 +
> >  arch/x86/kvm/mmu.c              | 160 ++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/vmx.c          |  48 ++++++++++
> >  arch/x86/kvm/x86.c              |  40 ++++++++
> >  include/linux/kvm_host.h        |   4 +-
> >  include/uapi/linux/kvm.h        |   9 ++
> >  7 files changed, 280 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index 44f6e1757861..5c4882015acc 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -398,8 +398,13 @@ struct kvm_mmu {
> >  	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
> >  	void (*update_pte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
> >  			   u64 *spte, const void *pte);
> > +	int (*get_subpages)(struct kvm *kvm, struct kvm_subpage *spp_info);
> > +	int (*set_subpages)(struct kvm *kvm, struct kvm_subpage *spp_info);
> > +	int (*init_spp)(struct kvm *kvm);
> > +
> >  	hpa_t root_hpa;
> >  	gpa_t root_cr3;
> > +	hpa_t sppt_root;
> 
> (I'm sorry if this was previously discussed, I didn't look into previous
> submissions).
> 
> What happens when we launch a nested guest and switch vcpu->arch.mmu to
> point at arch.guest_mmu? sppt_root will point to INVALID_PAGE and SPP
> won't be enabled in VMCS?
> 
> (I'm sorry again, I'm likely missing something obvious)
> 
> -- 
> Vitaly

Hi, Vitaly,
Thanks for raising a good qeustion, I must have missed the nested case,
I'll double check how to support the nested case.
