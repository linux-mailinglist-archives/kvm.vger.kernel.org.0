Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA3DBBDDC
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 23:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503066AbfIWVYg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 17:24:36 -0400
Received: from mga05.intel.com ([192.55.52.43]:3608 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503049AbfIWVYg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 17:24:36 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 14:24:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,541,1559545200"; 
   d="scan'208";a="189174896"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 23 Sep 2019 14:24:35 -0700
Date:   Mon, 23 Sep 2019 14:24:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
Message-ID: <20190923212435.GO18195@linux.intel.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
 <20190923190514.GB19996@redhat.com>
 <20190923202349.GL18195@linux.intel.com>
 <20190923210838.GA23063@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923210838.GA23063@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 05:08:38PM -0400, Andrea Arcangeli wrote:
> Hello,
> 
> On Mon, Sep 23, 2019 at 01:23:49PM -0700, Sean Christopherson wrote:
> > The attached patch should do the trick.
> 
> The two most attractive options to me remains what I already have
> implemented under #ifdef CONFIG_RETPOLINE with direct calls
> (optionally replacing the "if" with a small "switch" still under
> CONFIG_RETPOLINE if we give up the prioritization of the checks), or
> the replacement of kvm_vmx_exit_handlers with a switch() as suggested
> by Vitaly which would cleanup some code.
> 
> The intermediate solution that makes "const" work, has the cons of
> forcing to parse EXIT_REASON_VMCLEAR and the other vmx exit reasons
> twice, first through a pointer to function (or another if or switch
> statement) then with a second switch() statement.
> 
> If we'd use a single switch statement per Vitaly's suggestion, the "if
> nested" would better be more simply implemented as:
> 
> 	switch (exit_reason) {
> 		case EXIT_REASON_VMCLEAR:
> 			if (nested)
> 				return handle_vmclear(vcpu);
> 			else
> 				return handle_vmx_instruction(vcpu);
> 		case EXIT_REASON_VMCLEAR:
> 			if (nested)
> 		[..]

Combing if/case statements would mitigate this to some degree, e.g.:

	if (exit_reason >= EXIT_REASON_VMCALL &&
	    exit_reason <= EXIT_REASON_VMON)
		return handle_vmx_instruction(vcpu);

or

	case EXIT_REASON_VMCALL ... EXIT_REASON_VMON:
		return handle_vmx_instruction(vcpu);

> This also removes the compiler dependency to auto inline
> handle_vmclear in the added nested_vmx_handle_vmx_instruction extern
> call.

I like the idea of routing through handle_vmx_instruction() because it
allows the individual handlers to be wholly encapsulated in nested.c,
e.g. handle_vmclear() and company don't have to be exposed.

An extra CALL+RET isn't going to be noticeable, especially on modern
hardware as the high frequency VMWRITE/VMREAD fields should hit the
shadow VMCS.

> VMREAD/WRITE/RESUME are the most frequent vmexit in l0 while nested
> runs in l2.
> 
> Thanks,
> Andrea
