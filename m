Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8D78187937
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 06:28:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgCQF2W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 01:28:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:50049 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725468AbgCQF2W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Mar 2020 01:28:22 -0400
IronPort-SDR: iUxmuq6hSBANSW4d5cj8M/OW7KeAOT3nRLW3D3P4lAkklxpVc4vn1qNL/XUo7/iCqAlxiOMpdw
 APxz7ExDWmBA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2020 22:28:22 -0700
IronPort-SDR: 3GJVuS7/QG0mC/tegIXXbMouLIAFkNCOVm1EHtnxF0L/oVq04Xm14XzdPJyixyk3ZVRqDnE4Yx
 UXsVtnTBK1JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,563,1574150400"; 
   d="scan'208";a="247708593"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga006.jf.intel.com with ESMTP; 16 Mar 2020 22:28:21 -0700
Date:   Mon, 16 Mar 2020 22:28:21 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH 10/10] KVM: VMX: Convert vcpu_vmx.exit_reason to a union
Message-ID: <20200317052821.GP24267@linux.intel.com>
References: <20200312184521.24579-1-sean.j.christopherson@intel.com>
 <20200312184521.24579-11-sean.j.christopherson@intel.com>
 <87eetwnxsu.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eetwnxsu.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 13, 2020 at 03:18:09PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index e64da06c7009..2d9a005d11ab 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -93,6 +93,29 @@ struct pt_desc {
> >  	struct pt_ctx guest;
> >  };
> >  
> > +union vmx_exit_reason {
> > +	struct {
> > +		u32	basic			: 16;
> > +		u32	reserved16		: 1;
> > +		u32	reserved17		: 1;
> > +		u32	reserved18		: 1;
> > +		u32	reserved19		: 1;
> > +		u32	reserved20		: 1;
> > +		u32	reserved21		: 1;
> > +		u32	reserved22		: 1;
> > +		u32	reserved23		: 1;
> > +		u32	reserved24		: 1;
> > +		u32	reserved25		: 1;
> > +		u32	reserved26		: 1;
> > +		u32	enclave_mode		: 1;
> > +		u32	smi_pending_mtf		: 1;
> > +		u32	smi_from_vmx_root	: 1;
> > +		u32	reserved30		: 1;
> > +		u32	failed_vmentry		: 1;
> 
> Just wondering, is there any particular benefit in using 'u32' instead
> of 'u16' here?

Not that I know of.  Paranoia that the compiler will do something weird?

> > +	};
> > +	u32 full;
> > +};
> > +
> >  /*
> >   * The nested_vmx structure is part of vcpu_vmx, and holds information we need
> >   * for correct emulation of VMX (i.e., nested VMX) on this vcpu.
> > @@ -263,7 +286,7 @@ struct vcpu_vmx {
> >  	int vpid;
> >  	bool emulation_required;
> >  
> > -	u32 exit_reason;
> > +	union vmx_exit_reason exit_reason;
> >  
> >  	/* Posted interrupt descriptor */
> >  	struct pi_desc pi_desc;
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
> 
