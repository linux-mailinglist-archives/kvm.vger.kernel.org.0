Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697D31681AF
	for <lists+kvm@lfdr.de>; Fri, 21 Feb 2020 16:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbgBUPcp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Feb 2020 10:32:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:14069 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727053AbgBUPcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Feb 2020 10:32:45 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 07:32:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,468,1574150400"; 
   d="scan'208";a="270021461"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 21 Feb 2020 07:32:44 -0800
Date:   Fri, 21 Feb 2020 07:32:44 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] KVM: VMX: Fold vpid_sync_vcpu_{single,global}()
 into vpid_sync_context()
Message-ID: <20200221153244.GD12665@linux.intel.com>
References: <20200220204356.8837-1-sean.j.christopherson@intel.com>
 <20200220204356.8837-5-sean.j.christopherson@intel.com>
 <87zhdcrrdk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87zhdcrrdk.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 21, 2020 at 02:39:51PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Fold vpid_sync_vcpu_global() and vpid_sync_vcpu_single() into their sole
> > caller.  KVM should always prefer the single variant, i.e. the only
> > reason to use the global variant is if the CPU doesn't support
> > invalidating a single VPID, which is the entire purpose of wrapping the
> > calls with vpid_sync_context().
> >
> > No functional change intended.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/ops.h | 16 ++--------------
> >  1 file changed, 2 insertions(+), 14 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
> > index 612df1bdb26b..eb6adc77a55d 100644
> > --- a/arch/x86/kvm/vmx/ops.h
> > +++ b/arch/x86/kvm/vmx/ops.h
> > @@ -253,29 +253,17 @@ static inline void __invept(unsigned long ext, u64 eptp, gpa_t gpa)
> >  	vmx_asm2(invept, "r"(ext), "m"(operand), ext, eptp, gpa);
> >  }
> >  
> > -static inline void vpid_sync_vcpu_single(int vpid)
> > +static inline void vpid_sync_context(int vpid)
> >  {
> >  	if (vpid == 0)
> >  		return;
> >  
> >  	if (cpu_has_vmx_invvpid_single())
> >  		__invvpid(VMX_VPID_EXTENT_SINGLE_CONTEXT, vpid, 0);
> > -}
> > -
> > -static inline void vpid_sync_vcpu_global(void)
> > -{
> > -	if (cpu_has_vmx_invvpid_global())
> > +	else
> >  		__invvpid(VMX_VPID_EXTENT_ALL_CONTEXT, 0, 0);
> >  }
> >  
> > -static inline void vpid_sync_context(int vpid)
> > -{
> > -	if (cpu_has_vmx_invvpid_single())
> > -		vpid_sync_vcpu_single(vpid);
> > -	else
> > -		vpid_sync_vcpu_global();
> > -}
> > -
> >  static inline void vpid_sync_vcpu_addr(int vpid, gva_t addr)
> >  {
> >  	if (vpid == 0)
> 
> In the original code it's only vpid_sync_vcpu_single() which has 'vpid
> == 0' check, vpid_sync_vcpu_global() doesn't have it. So in the
> hypothetical situation when cpu_has_vmx_invvpid_single() is false AND
> we've e.g. exhausted our VPID space and allocate_vpid() returned zero,
> the new code just won't do anything while the old one would've done
> __invvpid(VMX_VPID_EXTENT_ALL_CONTEXT, 0, 0), right?

Ah rats.  I lost track of that functional change between making the commit
and writing the changelog.

I'll spin a v2 to rewrite the changelog, and maybe add the "vpid == 0"
check in a separate patch.
