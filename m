Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCE21B8517
	for <lists+kvm@lfdr.de>; Sat, 25 Apr 2020 11:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726062AbgDYJMV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Apr 2020 05:12:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:28431 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbgDYJMV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Apr 2020 05:12:21 -0400
IronPort-SDR: mTEam8Lk2NrokMK8wOfbV6VhW2AbJXF5kMvjvUxkuRfD4C2sB46g5dy6wRYsGm3y73FAw/tBjj
 tfwXYP3hEsnw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2020 02:12:21 -0700
IronPort-SDR: Q3anePwXL0+gercRC5wVBvj8vvjE3OueL9ys+ji1dbPh2wObZrI00tjx2pAim3gjXwpodckd1n
 zsZ0Whi9cZvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,315,1583222400"; 
   d="scan'208";a="274898307"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by orsmga002.jf.intel.com with ESMTP; 25 Apr 2020 02:12:19 -0700
Date:   Sat, 25 Apr 2020 17:14:19 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 2/9] KVM: VMX: Set guest CET MSRs per KVM and host
 configuration
Message-ID: <20200425091419.GA26221@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-3-weijiang.yang@intel.com>
 <20200423162749.GG17824@linux.intel.com>
 <20200424140751.GE24039@local-michael-cet-test>
 <20200424145529.GD30013@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424145529.GD30013@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 07:55:29AM -0700, Sean Christopherson wrote:
> On Fri, Apr 24, 2020 at 10:07:51PM +0800, Yang Weijiang wrote:
> > On Thu, Apr 23, 2020 at 09:27:49AM -0700, Sean Christopherson wrote:
> > > On Thu, Mar 26, 2020 at 04:18:39PM +0800, Yang Weijiang wrote:
> > > > @@ -7102,6 +7138,10 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
> > > >  			vmx_set_guest_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
> > > >  		}
> > > >  	}
> > > > +
> > > > +	if (guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> > > > +	    guest_cpuid_has(vcpu, X86_FEATURE_IBT))
> > > > +		vmx_update_intercept_for_cet_msr(vcpu);
> > > 
> > > This is wrong, it will miss the case where userspace double configures CPUID
> > > and goes from CET=1 to CET=0.  This should instead be:
> > > 
> > > 	if (supported_xss & (XFEATURE_MASK_CET_KERNEL | XFEATURE_MASK_CET_USER))
> > > 		vmx_update_intercept_for_cet_msr(vcpu);
> > > 
> > > >  }
> > Here CET=1/0, did you mean the CET bit in XSS or CR4.CET? If it's the
> > former, then it's OK for me.
> 
> The former, i.e. update the CET MSRs if KVM supports CET virtualization and
> the guest's CPUID configuration is changing.
Yep, this case should be taken into account, thank you for pointing it out!
