Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4316BF6BA
	for <lists+kvm@lfdr.de>; Sat, 18 Mar 2023 01:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjCRAAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Mar 2023 20:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjCRAAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Mar 2023 20:00:11 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56BAE1D923;
        Fri, 17 Mar 2023 17:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679097610; x=1710633610;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=54+9w11FyBycDMrEZnRqQoNXdQMiD2O9yYzVr/7CDsE=;
  b=E1CRz8qVrHkWcSzqfkYt8BYbuc/94A28XjDBKhF9AAyCjWGbyDklAgYo
   U84iq5HS7Zyeq2MurMN0JaCDPn7/UtHWvuy+DxgZctLn0CErCl2GxkArN
   3FmiISFGq3bw3ttDakddI1neuU/+QZGTG/ErxhJ+uWNLN4ARr9ezyzWTX
   3DuLoWSNRgp82ChV8bHk2wFGRd8//hemY1bo0C3Ab6GCaS2MRv0/3tRR1
   QS5/OkXlqlbDFmI4B+imiNUoItjkcxobn8nVlKeb1nHFU5kUpOP4T9jPY
   Iw6VNFCC9iXqWx9JXVMmjsWdB2ZQZ02LwOJ2tIcwNhjwi9MNl1zBhFSp7
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="400964714"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="400964714"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 17:00:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10652"; a="712932148"
X-IronPort-AV: E=Sophos;i="5.98,270,1673942400"; 
   d="scan'208";a="712932148"
Received: from mupadhya-mobl1.amr.corp.intel.com (HELO desk) ([10.209.15.93])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2023 17:00:09 -0700
Date:   Fri, 17 Mar 2023 16:59:59 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Ben Serebrin <serebrin@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] kvm: vmx: Add IA32_FLUSH_CMD guest support
Message-ID: <20230317235959.buk3y25iwllscrbe@desk>
References: <20230201132905.549148-1-eesposit@redhat.com>
 <20230201132905.549148-2-eesposit@redhat.com>
 <20230317190432.GA863767@dev-arch.thelio-3990X>
 <20230317225345.z5chlrursjfbz52o@desk>
 <20230317231401.GA4100817@dev-arch.thelio-3990X>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230317231401.GA4100817@dev-arch.thelio-3990X>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 17, 2023 at 04:14:01PM -0700, Nathan Chancellor wrote:
> On Fri, Mar 17, 2023 at 03:53:45PM -0700, Pawan Gupta wrote:
> > On Fri, Mar 17, 2023 at 12:04:32PM -0700, Nathan Chancellor wrote:
> > > Hi Emanuele,
> > > 
> > > On Wed, Feb 01, 2023 at 08:29:03AM -0500, Emanuele Giuseppe Esposito wrote:
> > > > Expose IA32_FLUSH_CMD to the guest if the guest CPUID enumerates
> > > > support for this MSR. As with IA32_PRED_CMD, permission for
> > > > unintercepted writes to this MSR will be granted to the guest after
> > > > the first non-zero write.
> > > > 
> > > > Signed-off-by: Jim Mattson <jmattson@google.com>
> > > > Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/nested.c |  3 ++
> > > >  arch/x86/kvm/vmx/vmx.c    | 70 +++++++++++++++++++++++++--------------
> > > >  2 files changed, 48 insertions(+), 25 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > > > index 557b9c468734..075b5ade7c80 100644
> > > > --- a/arch/x86/kvm/vmx/nested.c
> > > > +++ b/arch/x86/kvm/vmx/nested.c
> > > > @@ -654,6 +654,9 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> > > >  	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> > > >  					 MSR_IA32_PRED_CMD, MSR_TYPE_W);
> > > >  
> > > > +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
> > > > +					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
> > > > +
> > > >  	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
> > > >  
> > > >  	vmx->nested.force_msr_bitmap_recalc = false;
> > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > index c788aa382611..9a78ea96a6d7 100644
> > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > @@ -2133,6 +2133,39 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
> > > >  	return debugctl;
> > > >  }
> > > >  
> > > > +static int vmx_set_msr_ia32_cmd(struct kvm_vcpu *vcpu,
> > > > +				struct msr_data *msr_info,
> > > > +				bool guest_has_feat, u64 cmd,
> > > > +				int x86_feature_bit)
> > > > +{
> > > > +	if (!msr_info->host_initiated && !guest_has_feat)
> > > > +		return 1;
> > > > +
> > > > +	if (!(msr_info->data & ~cmd))
> > 
> > Looks like this is doing a reverse check. Shouldn't this be as below:
> 
> That diff on top of next-20230317 appears to resolve the issue for me
> and my L1 guest can spawn an L2 guest without any issues (which is the
> extent of my KVM testing).

Great!

> Is this a problem for the SVM version? It has the same check it seems,
> although I did not have any issues on my AMD test platform (but I guess
> that means that the system has the support?).

IIUC, SVM version also needs to be fixed.

> I assume this will just be squashed into the original change but if not:

Thats what I think, and if its too late to be squashed I will send a
formal patch. Maintainers?

> Tested-by: Nathan Chancellor <nathan@kernel.org>
> 
> Cheers,
> Nathan
> 
> > ---
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index f88578407494..e8d9033559c4 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2141,7 +2141,7 @@ static int vmx_set_msr_ia32_cmd(struct kvm_vcpu *vcpu,
> >  	if (!msr_info->host_initiated && !guest_has_feat)
> >  		return 1;
> >  
> > -	if (!(msr_info->data & ~cmd))
> > +	if (msr_info->data & ~cmd)
> >  		return 1;
> >  	if (!boot_cpu_has(x86_feature_bit))
> >  		return 1;
