Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC20925B65E
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 00:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgIBWOe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Sep 2020 18:14:34 -0400
Received: from mga18.intel.com ([134.134.136.126]:33555 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726226AbgIBWOe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Sep 2020 18:14:34 -0400
IronPort-SDR: xNKI59KtI4JQ28GWFVJw5SyWzIeokO5u0kngUSL6RmB1sDRwWuf1vZoSsq8Db6jwNdOy8qtFDr
 RfRjtqgddyrw==
X-IronPort-AV: E=McAfee;i="6000,8403,9732"; a="145178355"
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="145178355"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 15:14:33 -0700
IronPort-SDR: lbMj421iKrO95ouOqGcD7P4UJqcRyfC5TTrCXQFT/ZJjpd3/TSE+lpcnjEi9bjRtam6sKUTURx
 5ODWJvz3Y5rg==
X-IronPort-AV: E=Sophos;i="5.76,384,1592895600"; 
   d="scan'208";a="297831279"
Received: from sjchrist-ice.jf.intel.com (HELO sjchrist-ice) ([10.54.31.34])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 15:14:33 -0700
Date:   Wed, 2 Sep 2020 15:14:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Add VM-Enter failed tracepoints for super
 early checks
Message-ID: <20200902221430.GJ11695@sjchrist-ice>
References: <20200812180615.22372-1-sean.j.christopherson@intel.com>
 <87v9gxx5z8.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v9gxx5z8.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 01, 2020 at 10:21:15AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Add tracepoints for the early consistency checks in nested_vmx_run().
> > The "VMLAUNCH vs. VMRESUME" check in particular is useful to trace, as
> > there is no architectural way to check VMCS.LAUNCH_STATE, and subtle
> > bugs such as VMCLEAR on the wrong HPA can lead to confusing errors in
> > the L1 VMM.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 23b58c28a1c92..fb37f0972e78a 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3468,11 +3468,11 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
> >  	if (evmptrld_status == EVMPTRLD_ERROR) {
> 
> Would it make sense to add 'CC' here too for, em, consistency? :-) #UD
> is probably easy to spot anyway..

I'd prefer not to, purely because it's a #UD and not a VM-Fail.
