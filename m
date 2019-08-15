Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6908ED25
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 15:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732413AbfHONmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 09:42:18 -0400
Received: from mga03.intel.com ([134.134.136.65]:50533 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729918AbfHONmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 09:42:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Aug 2019 06:41:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,389,1559545200"; 
   d="scan'208";a="194767632"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 15 Aug 2019 06:41:49 -0700
Date:   Thu, 15 Aug 2019 21:43:29 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com, rkrcmar@redhat.com,
        jmattson@google.com, yu.c.zhang@intel.com, alazar@bitdefender.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Subject: Re: [PATCH RESEND v4 5/9] KVM: VMX: Add init/set/get functions for
 SPP
Message-ID: <20190815134329.GA11449@local-michael-cet-test>
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
After looked into the issue and others, I feel to make SPP co-existing
with nested VM is not good, the major reason is, L1 pages protected by
SPP are transparent to L1 VM, if it launches L2 VM, probably the
pages would be allocated to L2 VM, and that will bother to L1 and L2.
Given the feature is new and I don't see nested VM can benefit
from it right now, I would like to make SPP and nested feature mutually
exclusive, i.e., detecting if the other part is active before activate one
feature,what do you think of it? 
thanks! 
