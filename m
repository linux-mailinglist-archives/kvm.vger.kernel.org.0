Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F117AA7C5
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2019 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389225AbfIEP4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 11:56:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:64121 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731760AbfIEP4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 11:56:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 08:56:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,470,1559545200"; 
   d="scan'208";a="190537743"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Sep 2019 08:56:54 -0700
Date:   Thu, 5 Sep 2019 08:56:54 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: Re: [PATCH v2 1/3] KVM: X86: Trace vcpu_id for vmexit
Message-ID: <20190905155654.GA29019@linux.intel.com>
References: <20190815103458.23207-1-peterx@redhat.com>
 <20190815103458.23207-2-peterx@redhat.com>
 <20190904172658.GH24079@linux.intel.com>
 <20190905021515.GD31707@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905021515.GD31707@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 05, 2019 at 10:15:15AM +0800, Peter Xu wrote:
> On Wed, Sep 04, 2019 at 10:26:58AM -0700, Sean Christopherson wrote:
> > On Thu, Aug 15, 2019 at 06:34:56PM +0800, Peter Xu wrote:
> > > Tracing the ID helps to pair vmenters and vmexits for guests with
> > > multiple vCPUs.
> > > 
> > > Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > > ---
> > >  arch/x86/kvm/trace.h | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > > index b5c831e79094..c682f3f7f998 100644
> > > --- a/arch/x86/kvm/trace.h
> > > +++ b/arch/x86/kvm/trace.h
> > > @@ -232,17 +232,20 @@ TRACE_EVENT(kvm_exit,
> > >  		__field(	u32,	        isa             )
> > >  		__field(	u64,	        info1           )
> > >  		__field(	u64,	        info2           )
> > > +		__field(	int,	        vcpu_id         )
> > 
> > It doesn't actually affect anything, but vcpu_id is stored and printed as
> > an 'unsigned int' everywhere else in the trace code.  Stylistically I like
> > that approach even though struct kvm_vcpu holds it as a signed int.
> 
> True.  I can switch to unsigned int to get aligned with the rest if
> there's other comment to address.  Though from codebase-wise I would
> even prefer signed because it gives us a chance to set an invalid vcpu
> id (-1) where necessary, or notice something severly wrong when <-1.

I agree that a signed int makes sense for flows like kvm_get_vcpu_by_id(),
where the incoming id isn't sanitized.  But for struct kvm_vcpu, a negative 
vcpu_id is simply impossible, e.g. vcpu_id is set to a postive (and capped)
value as part of the core vcpu initialization and is never changed.  I
prefer storing an unsigned val in the tracing as it communicates that
vcpu_id is always valid.  I suspect struct kvm_vcpu uses a signed int
purely to avoid having to constantly cast it to an int.

> After all it should far cover our usage (IIUC max vcpu id should be
> 512 cross archs).
