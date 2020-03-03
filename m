Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C414177B64
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730222AbgCCQAz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:00:55 -0500
Received: from mga09.intel.com ([134.134.136.24]:33796 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729543AbgCCQAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:00:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 08:00:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="274254851"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2020 08:00:53 -0800
Date:   Tue, 3 Mar 2020 08:00:52 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v2 61/66] KVM: x86: Don't propagate MMU lpage support to
 memslot.disallow_lpage
Message-ID: <20200303160052.GI1439@linux.intel.com>
References: <20200302235709.27467-1-sean.j.christopherson@intel.com>
 <20200302235709.27467-62-sean.j.christopherson@intel.com>
 <e436d608-41ed-c9ad-6584-360451fb6d65@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e436d608-41ed-c9ad-6584-360451fb6d65@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 04:31:15PM +0100, Paolo Bonzini wrote:
> On 03/03/20 00:57, Sean Christopherson wrote:
> > Stop propagating MMU large page support into a memslot's disallow_lpage
> > now that the MMU's max_page_level handles the scenario where VMX's EPT is
> > enabled and EPT doesn't support 2M pages.
> > 
> > No functional change intended.
> > 
> > Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 3 ---
> >  arch/x86/kvm/x86.c     | 6 ++----
> >  2 files changed, 2 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index f8eb081b63fe..1fbe54dc3263 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -7698,9 +7698,6 @@ static __init int hardware_setup(void)
> >  	if (!cpu_has_vmx_tpr_shadow())
> >  		kvm_x86_ops->update_cr8_intercept = NULL;
> >  
> > -	if (enable_ept && !cpu_has_vmx_ept_2m_page())
> > -		kvm_disable_largepages();
> > -
> >  #if IS_ENABLED(CONFIG_HYPERV)
> >  	if (ms_hyperv.nested_features & HV_X64_NESTED_GUEST_MAPPING_FLUSH
> >  	    && enable_ept) {
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 4fdf5b04f148..cc9b543d210b 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -9863,11 +9863,9 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> >  		ugfn = slot->userspace_addr >> PAGE_SHIFT;
> >  		/*
> >  		 * If the gfn and userspace address are not aligned wrt each
> > -		 * other, or if explicitly asked to, disable large page
> > -		 * support for this slot
> > +		 * other, disable large page support for this slot.
> >  		 */
> > -		if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1) ||
> > -		    !kvm_largepages_enabled()) {
> > +		if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1)) {
> >  			unsigned long j;
> >  
> >  			for (j = 0; j < lpages; ++j)
> > 
> 
> This should technically go in the next patch.

Hmm, yeah, I agree.  IIRC I split it this way so that the next patch didn't
touch any arch code, but removing only the call to kvm_disable_largepages()
would be cleaner.
