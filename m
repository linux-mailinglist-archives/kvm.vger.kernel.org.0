Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E0E177DA7
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 18:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729814AbgCCRmn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 12:42:43 -0500
Received: from mga07.intel.com ([134.134.136.100]:24045 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728955AbgCCRmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 12:42:43 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 09:42:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="412824186"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga005.jf.intel.com with ESMTP; 03 Mar 2020 09:42:42 -0800
Date:   Tue, 3 Mar 2020 09:42:42 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/13] KVM: x86: Refactor emulate tracepoint to
 explicitly take context
Message-ID: <20200303174242.GN1439@linux.intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
 <20200218232953.5724-7-sean.j.christopherson@intel.com>
 <8736axjmte.fsf@vitty.brq.redhat.com>
 <20200303164813.GL1439@linux.intel.com>
 <2f3f7aff-2bd0-fa62-4b66-9f90f125e44e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f3f7aff-2bd0-fa62-4b66-9f90f125e44e@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 03, 2020 at 06:29:30PM +0100, Paolo Bonzini wrote:
> On 03/03/20 17:48, Sean Christopherson wrote:
> >>>  	TP_fast_assign(
> >>>  		__entry->csbase = kvm_x86_ops->get_segment_base(vcpu, VCPU_SREG_CS);
> >> This seems the only usage of 'vcpu' parameter now; I checked and even
> >> after switching to dynamic emulation context allocation we still set
> >> ctxt->vcpu in alloc_emulate_ctxt(), can we get rid of 'vcpu' parameter
> >> here then (and use ctxt->vcpu instead)?
> > Hmm, ya, not sure what I was thinking here.
> > 
> 
> As long as we have one use of vcpu, I'd rather skip this patch and
> adjust patch 8 to use "->".  Even the other "explicitly take context"
> parts are kinda debatable since you still have to do emul_to_vcpu.
> Throwing a handful of
> 
> - 	struct x86_emulate_ctxt *ctxt = &vcpu->arch.emulate_ctxt;
> + 	struct x86_emulate_ctxt *ctxt = vcpu->arch.emulate_ctxt;
> 
> into patch 8 is not bad at all and limits the churn.

Hmm, I'd prefer to explicitly pass @ctxt, even for the tracepoint.  I get
that it's technically unnecessary churn, but explicitly passing @ctxt means
that every funcition that grabs arch.emulate_ctxt (all three of 'em) checks
for a NULL ctxt.  That makes it trivial to visually audit that there's no
risk of a bad pointer dereference, and IMO having @ctxt in the prototype
is helpful to see "oh, this helper is called from within the emulator".
