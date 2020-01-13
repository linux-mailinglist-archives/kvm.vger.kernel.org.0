Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A354D138B1D
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 06:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726236AbgAMFkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 00:40:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:2721 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgAMFkT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 00:40:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jan 2020 21:40:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,427,1571727600"; 
   d="scan'208";a="243089700"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by fmsmga001.fm.intel.com with ESMTP; 12 Jan 2020 21:40:17 -0800
Date:   Mon, 13 Jan 2020 13:44:38 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [RESEND PATCH v10 02/10] vmx: spp: Add control flags for
 Sub-Page Protection(SPP)
Message-ID: <20200113054438.GA12253@local-michael-cet-test.sh.intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-3-weijiang.yang@intel.com>
 <20200110165859.GB21485@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110165859.GB21485@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 10, 2020 at 08:58:59AM -0800, Sean Christopherson wrote:
> On Thu, Jan 02, 2020 at 02:13:11PM +0800, Yang Weijiang wrote:
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index e3394c839dea..5713e8a6224c 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -60,6 +60,7 @@
> >  #include "vmcs12.h"
> >  #include "vmx.h"
> >  #include "x86.h"
> > +#include "../mmu/spp.h"
> 
> The ".." should be unnecessary, e.g. x86.h is obviously a level up.
>
Sean, thanks a lot for the feedback! Will change this.
> >  MODULE_AUTHOR("Qumranet");
> >  MODULE_LICENSE("GPL");
> > @@ -111,6 +112,7 @@ module_param_named(pml, enable_pml, bool, S_IRUGO);
> >  
> >  static bool __read_mostly dump_invalid_vmcs = 0;
> >  module_param(dump_invalid_vmcs, bool, 0644);
> > +static bool __read_mostly spp_supported = 0;
> 
> s/spp_supported/enable_spp to be consistent with all the other booleans.
> 
> Is there a reason this isn't exposed as a module param?
> 
Yes, in original versions, SPP is enbled by a module param, so called
"static enable", considering the SPP bitmap pre-allocated is a bit
large, the from v3, it's changed to "dynamic enable", i.e., user
application need to enable SPP via init_spp IOCTL(later changed to via
ENABLE_CAP) to remove the pre-allocation, so the flag now is used to
cross-check SPP status between functions. Will change the name.

> And if this is to be on by default, then the flag itself should be
> initialized to '1' so that it's clear to readers that the feature is
> enabled by default (if it's supported).  Looking at only this code, I would
> think that SPP is forced off and can't be enabled.
> 
> That being said, turning on the enable_spp control flag should be the last
> patch in the series, i.e. it shouldn't be turned on until all the
> underlying support code is in place.  So, I would keep this as is, but
> invert the code in hardware_setup() below.  That way the flag exists and
> is checked, but can't be turned on without modifying the code.  Then when
> all is said and done, you can add a patch to introduce the module param
> and turn on the flag by default (if that's indeed what we want).
> 
You're right, I'll re-order the patch to enable SPP bit in the last
patch, thanks!

> >  #define MSR_BITMAP_MODE_X2APIC		1
> >  #define MSR_BITMAP_MODE_X2APIC_APICV	2
> > @@ -2391,6 +2393,7 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
> >  			SECONDARY_EXEC_RDSEED_EXITING |
> >  			SECONDARY_EXEC_RDRAND_EXITING |
> >  			SECONDARY_EXEC_ENABLE_PML |
> > +			SECONDARY_EXEC_ENABLE_SPP |
> >  			SECONDARY_EXEC_TSC_SCALING |
> >  			SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
> >  			SECONDARY_EXEC_PT_USE_GPA |
> > @@ -4039,6 +4042,9 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
> >  	if (!enable_pml)
> >  		exec_control &= ~SECONDARY_EXEC_ENABLE_PML;
> >  
> > +	if (!spp_supported)
> > +		exec_control &= ~SECONDARY_EXEC_ENABLE_SPP;
> > +
> >  	if (vmx_xsaves_supported()) {
> >  		/* Exposing XSAVES only when XSAVE is exposed */
> >  		bool xsaves_enabled =
> > @@ -7630,6 +7636,9 @@ static __init int hardware_setup(void)
> >  	if (!cpu_has_vmx_flexpriority())
> >  		flexpriority_enabled = 0;
> >  
> > +	if (cpu_has_vmx_ept_spp() && enable_ept)
> > +		spp_supported = 1;
> 
> As above, invert this to disable spp when it's not supported, or when EPT
> is disabled (or not supported).
>
Sure,thank you!
> > +
> >  	if (!cpu_has_virtual_nmis())
> >  		enable_vnmi = 0;
> >  
> > -- 
> > 2.17.2
> > 
