Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C166B1AE947
	for <lists+kvm@lfdr.de>; Sat, 18 Apr 2020 03:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgDRBzq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 21:55:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:60054 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbgDRBzq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 21:55:46 -0400
IronPort-SDR: D7r7QJaUCvRYuXXGJHmKcGSt66XQeOCvr3QvV504thBZNVjfwOyWEtC1f/aa0LJ1ma10P6fySh
 CDKl1TYOhoyQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2020 18:55:45 -0700
IronPort-SDR: 00eMWy04h6S1TpdECx7c4F30uq/Oc4xCz11NXp5J++AM0olc6MxpexxMEhYKYs+nEI3sNgyISp
 d+i2EsXaWJrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,397,1580803200"; 
   d="scan'208";a="254383854"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 17 Apr 2020 18:55:45 -0700
Date:   Fri, 17 Apr 2020 18:55:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] KVM: nVMX: KVM needs to unset "unrestricted
 guest" VM-execution control in vmcs02 if vmcs12 doesn't set it
Message-ID: <20200418015545.GB15609@linux.intel.com>
References: <20200415183047.11493-1-krish.sadhukhan@oracle.com>
 <20200415183047.11493-2-krish.sadhukhan@oracle.com>
 <20200415193016.GF30627@linux.intel.com>
 <CALMp9eRvZEzi3Ug0fL=ekMS_Weni6npwW+bXrJZjU8iLrppwEg@mail.gmail.com>
 <0b8bd238-e60f-b392-e793-0d88fb876224@redhat.com>
 <d49ce960-92f9-85eb-4cfb-d533a956223e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d49ce960-92f9-85eb-4cfb-d533a956223e@oracle.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 17, 2020 at 06:29:23PM -0700, Krish Sadhukhan wrote:
> 
> On 4/16/20 2:18 AM, Paolo Bonzini wrote:
> >On 15/04/20 22:18, Jim Mattson wrote:
> >>>Has anyone worked through all the flows to verify this won't break any
> >>>assumptions with respect to enable_unrestricted_guest?  I would be
> >>>(pleasantly) surprised if this was sufficient to run L2 without
> >>>unrestricted guest when it's enabled for L1, e.g. vmx_set_cr0() looks
> >>>suspect.
> >>I think you're right to be concerned.
> >Thirded, but it shouldn't be too hard.  Basically,
> >enable_unrestricted_guest must be moved into loaded_vmcs for this to
> >work.  It may be more work to write the test cases for L2 real mode <->
> >protected mode switch, which do not entirely fit into the vmx_tests.c
> >framework (but with the v2 tests it should not be hard to adapt).
> 
> 
> OK, I will move enable_unrestricted_guest  to loaded_vmcs.

Hmm, enable_unrestricted_guest doesn't _need_ to be moved to loaded_vmcs,
L1 can never diverge from enable_unrestricted_guest.  E.g. the main control
variable can stay global, we just need a flag in nested_vmx to override the
main control.  A simple wrapper can then take care of the check, e.g.

  static inline bool is_unrestricted_guest(struct kvm_vcpu *vcpu)
  {
	return enable_unrestricted_guest && (!is_guest_mode(vcpu) ||
	       to_vmx(vcpu)->nested.unrestricted_guest);
  }

Putting the flag in loaded_vmcs might be more performant?  My guess is it'd
be in the noise, at which point I'd rather have it be clear the override is
only possible/necessary for nested guests.

> I also see that enable_ept controls the setting of
> enable_unrestricted_guest. Perhaps both need to be moved to loaded_vmcs ?

No, letting L1 disable EPT in L0 would be pure insanity, and the overall
paging mode of L2 is already reflected in the MMU.

The dependency on EPT is that VMX requires paging of some form and
unrestricted guest allows entering non-root with CR0.PG=0, i.e. requires EPT
be enabled.

> About testing, I am thinking the test will first vmlaunch L2 in real mode or
> in protected mode, then vmexit on vmcall and then vmresume in the other
> mode. Is that how the test should flow ?
> 
> >
> >Paolo
> >
