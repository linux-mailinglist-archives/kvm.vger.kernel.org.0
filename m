Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEB91139FAD
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 04:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbgANDDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 22:03:34 -0500
Received: from mga07.intel.com ([134.134.136.100]:6662 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729325AbgANDDe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jan 2020 22:03:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 19:03:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,431,1571727600"; 
   d="scan'208";a="217601135"
Received: from local-michael-cet-test.sh.intel.com (HELO localhost) ([10.239.159.128])
  by orsmga008.jf.intel.com with ESMTP; 13 Jan 2020 19:03:32 -0800
Date:   Tue, 14 Jan 2020 11:08:20 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com,
        alazar@bitdefender.com, edwin.zhai@intel.com
Subject: Re: [RESEND PATCH v10 06/10] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
Message-ID: <20200114030820.GA4583@local-michael-cet-test.sh.intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
 <20200102061319.10077-7-weijiang.yang@intel.com>
 <20200110180458.GG21485@linux.intel.com>
 <20200113081050.GF12253@local-michael-cet-test.sh.intel.com>
 <20200113173358.GC1175@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200113173358.GC1175@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 13, 2020 at 09:33:58AM -0800, Sean Christopherson wrote:
> On Mon, Jan 13, 2020 at 04:10:50PM +0800, Yang Weijiang wrote:
> > On Fri, Jan 10, 2020 at 10:04:59AM -0800, Sean Christopherson wrote:
> > > On Thu, Jan 02, 2020 at 02:13:15PM +0800, Yang Weijiang wrote:
> > > > @@ -3585,7 +3602,30 @@ static bool fast_page_fault(struct kvm_vcpu *vcpu, gva_t gva, int level,
> > > >  		if ((error_code & PFERR_WRITE_MASK) &&
> > > >  		    spte_can_locklessly_be_made_writable(spte))
> > > >  		{
> > > > -			new_spte |= PT_WRITABLE_MASK;
> > > > +			/*
> > > > +			 * Record write protect fault caused by
> > > > +			 * Sub-page Protection, let VMI decide
> > > > +			 * the next step.
> > > > +			 */
> > > > +			if (spte & PT_SPP_MASK) {
> > > > +				int len = kvm_x86_ops->get_inst_len(vcpu);
> > > 
> > > There's got to be a better way to handle SPP exits than adding a helper
> > > to retrieve the instruction length.
> > >
> > The fault instruction was skipped by kvm_skip_emulated_instruction()
> > before, but Paolo suggested leave the re-do or skip option to user-space
> > to make it flexible for write protection or write tracking, so return
> > length to user-space.
> 
> Sorry, my comment was unclear.  I have no objection to punting the fault
> to userspace, it's the mechanics of how it's done that I dislike.
> 
> Specifically, (a) using run->exit_reason to propagate the SPP exit up the
> stack, e.g. instead of modifying affected call stacks to play nice with
> any exit to userspace, (b) assuming ->get_insn_len() will always be
> accurate, e.g. see the various caveats in skip_emulated_instruction() for
> both VMX and SVM, and (c) duplicating the state capture code in every
> location that can encounter a SPP fault.
How about calling skip_emulated_instruction() in KVM before exit to
userspace, but still return the skipped instruction length, if userspace
would like to re-execute the instruction, it can unwind RIP or simply
rely on KVM?

> 
> What I'm hoping is that it's possible to modify the call stacks to
> explicitly propagate an exit to userspace and/or SPP fault, and shove all
> the state capture into a common location, e.g. handle_ept_violation().
>
The problem is, the state capture code in fast_page_fault() and
emulation case share different causes, the former is generic occurence
of SPP induced EPT violation, the latter is atually a "faked" one while
detecting emulation instruction is writing some SPP protected area, so I
seperated them.

> Side topic, assuming the userspace VMI is going to be instrospecting the
> faulting instruction, won't it decode the instruction?  I.e. calculate
> the instruction length anyways?
