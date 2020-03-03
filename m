Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5034177C4B
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbgCCQsO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:48:14 -0500
Received: from mga11.intel.com ([192.55.52.93]:7499 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730088AbgCCQsO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:48:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 08:48:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="351870260"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 03 Mar 2020 08:48:13 -0800
Date:   Tue, 3 Mar 2020 08:48:13 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/13] KVM: x86: Refactor emulate tracepoint to
 explicitly take context
Message-ID: <20200303164813.GL1439@linux.intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
 <20200218232953.5724-7-sean.j.christopherson@intel.com>
 <8736axjmte.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8736axjmte.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 26, 2020 at 06:11:25PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Explicitly pass the emulation context to the emulate tracepoint in
> > preparation of dynamically allocation the emulation context.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/trace.h | 22 +++++++++++-----------
> >  arch/x86/kvm/x86.c   | 13 ++++++++-----
> >  2 files changed, 19 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> > index f194dd058470..5605000ca5f6 100644
> > --- a/arch/x86/kvm/trace.h
> > +++ b/arch/x86/kvm/trace.h
> > @@ -731,8 +731,9 @@ TRACE_EVENT(kvm_skinit,
> >  	})
> >  
> >  TRACE_EVENT(kvm_emulate_insn,
> > -	TP_PROTO(struct kvm_vcpu *vcpu, __u8 failed),
> > -	TP_ARGS(vcpu, failed),
> > +	TP_PROTO(struct kvm_vcpu *vcpu, struct x86_emulate_ctxt *ctxt,
> > +		 __u8 failed),
> > +	TP_ARGS(vcpu, ctxt, failed),
> >  
> >  	TP_STRUCT__entry(
> >  		__field(    __u64, rip                       )
> > @@ -745,13 +746,10 @@ TRACE_EVENT(kvm_emulate_insn,
> >  
> >  	TP_fast_assign(
> >  		__entry->csbase = kvm_x86_ops->get_segment_base(vcpu, VCPU_SREG_CS);
> 
> This seems the only usage of 'vcpu' parameter now; I checked and even
> after switching to dynamic emulation context allocation we still set
> ctxt->vcpu in alloc_emulate_ctxt(), can we get rid of 'vcpu' parameter
> here then (and use ctxt->vcpu instead)?

Hmm, ya, not sure what I was thinking here.

> > -		__entry->len = vcpu->arch.emulate_ctxt.fetch.ptr
> > -			       - vcpu->arch.emulate_ctxt.fetch.data;
> > -		__entry->rip = vcpu->arch.emulate_ctxt._eip - __entry->len;
> > -		memcpy(__entry->insn,
> > -		       vcpu->arch.emulate_ctxt.fetch.data,
> > -		       15);
> > -		__entry->flags = kei_decode_mode(vcpu->arch.emulate_ctxt.mode);
> > +		__entry->len = ctxt->fetch.ptr - ctxt->fetch.data;
> > +		__entry->rip = ctxt->_eip - __entry->len;
> > +		memcpy(__entry->insn, ctxt->fetch.data, 15);
> > +		__entry->flags = kei_decode_mode(ctxt->mode);
> >  		__entry->failed = failed;
> >  		),
> >  
> > @@ -764,8 +762,10 @@ TRACE_EVENT(kvm_emulate_insn,
> >  		)
> >  	);
> >  
> > -#define trace_kvm_emulate_insn_start(vcpu) trace_kvm_emulate_insn(vcpu, 0)
> > -#define trace_kvm_emulate_insn_failed(vcpu) trace_kvm_emulate_insn(vcpu, 1)
> > +#define trace_kvm_emulate_insn_start(vcpu, ctxt)	\
> > +	trace_kvm_emulate_insn(vcpu, ctxt, 0)
> > +#define trace_kvm_emulate_insn_failed(vcpu, ctxt)	\
> > +	trace_kvm_emulate_insn(vcpu, ctxt, 1)
> >  
> >  TRACE_EVENT(
> >  	vcpu_match_mmio,
