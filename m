Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC75D1B9126
	for <lists+kvm@lfdr.de>; Sun, 26 Apr 2020 17:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgDZPYF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Apr 2020 11:24:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:33140 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726144AbgDZPYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Apr 2020 11:24:04 -0400
IronPort-SDR: Wq4YJGgG6hY8AaNEELigyNFYTOAzxaXs5Q/WCwXNBL2oi4N+7cWPf6Fgrh2dMexvKNiV1yMsJ6
 OLl4RcYhCO2g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2020 08:24:04 -0700
IronPort-SDR: JmsvbkoBHJVoSBiAi1qGKYGCqKECjqnfcNyiAXoeiPUYvm27D424r2oCl+DHUBH2TlE0r6PKyL
 t/rFUAVfNTkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,320,1583222400"; 
   d="scan'208";a="281440105"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by fmsmga004.fm.intel.com with ESMTP; 26 Apr 2020 08:24:02 -0700
Date:   Sun, 26 Apr 2020 23:26:01 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmattson@google.com,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 2/9] KVM: VMX: Set guest CET MSRs per KVM and host
 configuration
Message-ID: <20200426152600.GC29493@local-michael-cet-test.sh.intel.com>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-3-weijiang.yang@intel.com>
 <20200423162749.GG17824@linux.intel.com>
 <d92b9fea-95b6-73ce-c3b5-47dad95c5d42@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d92b9fea-95b6-73ce-c3b5-47dad95c5d42@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Apr 25, 2020 at 03:26:30PM +0200, Paolo Bonzini wrote:
> On 23/04/20 18:27, Sean Christopherson wrote:
> >>  
> >> +static bool is_cet_mode_allowed(struct kvm_vcpu *vcpu, u32 mode_mask)
> > CET itself isn't a mode.  And since this ends up being an inner helper for
> > is_cet_supported(), I think __is_cet_supported() would be the way to go.
> > 
> > Even @mode_mask is a bit confusing without the context of it being kernel
> > vs. user.  The callers are very readable, e.g. I'd much prefer passing the
> > mask as opposed to doing 'bool kernel'.  Maybe s/mode_mask/cet_mask?  That
> > doesn't exactly make things super clear, but at least the reader knows the
> > mask is for CET features.
> 
> What about is_cet_state_supported and xss_states?
>
It's good for me, I'll change them accordingly, thank you for review!

> Paolo
> 
> >> +{
> >> +	return ((supported_xss & mode_mask) &&
> >> +		(guest_cpuid_has(vcpu, X86_FEATURE_SHSTK) ||
> >> +		guest_cpuid_has(vcpu, X86_FEATURE_IBT)));
> >> +}
