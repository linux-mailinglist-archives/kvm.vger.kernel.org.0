Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8851B78A0
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 16:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbgDXOzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 10:55:31 -0400
Received: from mga18.intel.com ([134.134.136.126]:32738 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726717AbgDXOza (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 10:55:30 -0400
IronPort-SDR: /I4z0bv2RTuuIrC6GfEwDkbD0YvhQcf+yRjVwXW2I8ccp+U2mnqZH/T29auk8ZFuM7DAdt8kcz
 oIMgn2eeHLeQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 07:55:30 -0700
IronPort-SDR: JZaJj6f1eFvMIMbY926b5RKpXwFGXySdN2ueXjfMALdWBWX/JabFM5axeVArYY4/a1WrcRmy0i
 cVR9LKXdDvDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="280819603"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga004.fm.intel.com with ESMTP; 24 Apr 2020 07:55:29 -0700
Date:   Fri, 24 Apr 2020 07:55:29 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 2/9] KVM: VMX: Set guest CET MSRs per KVM and host
 configuration
Message-ID: <20200424145529.GD30013@linux.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-3-weijiang.yang@intel.com>
 <20200423162749.GG17824@linux.intel.com>
 <20200424140751.GE24039@local-michael-cet-test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424140751.GE24039@local-michael-cet-test>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 10:07:51PM +0800, Yang Weijiang wrote:
> On Thu, Apr 23, 2020 at 09:27:49AM -0700, Sean Christopherson wrote:
> > On Thu, Mar 26, 2020 at 04:18:39PM +0800, Yang Weijiang wrote:
> > > @@ -7102,6 +7138,10 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> > >  			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
> > >  		}
> > >  	}
> > > +
> > > +	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > > +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> > > +		vmx_update_intercept_for_cet_msr(vcpu);
> > 
> > This is wrong, it will miss the case where userspace double configures CPUID
> > and goes from CET=1 to CET=0.  This should instead be:
> > 
> > 	if (supported_xss & (XFEATURE_MASK_CET_KERNEL | XFEATURE_MASK_CET_USER))
> > 		vmx_update_intercept_for_cet_msr(vcpu);
> > 
> > >  }
> Here CET=1/0, did you mean the CET bit in XSS or CR4.CET? If it's the
> former, then it's OK for me.

The former, i.e. update the CET MSRs if KVM supports CET virtualization and
the guest's CPUID configuration is changing.
