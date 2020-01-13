Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBF2139990
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2020 20:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728669AbgAMTFg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jan 2020 14:05:36 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:35650 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726435AbgAMTFg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Jan 2020 14:05:36 -0500
X-Greylist: delayed 614 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jan 2020 14:05:34 EST
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9B93A30747C7;
        Mon, 13 Jan 2020 20:55:19 +0200 (EET)
Received: from localhost (unknown [195.210.5.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 8A256301B92B;
        Mon, 13 Jan 2020 20:55:19 +0200 (EET)
From:   Adalbert =?iso-8859-2?b?TGF643I=?= <alazar@bitdefender.com>
Subject: Re: [RESEND PATCH v10 06/10] vmx: spp: Set up SPP paging table at
 vmentry/vmexit
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, jmattson@google.com,
        yu.c.zhang@linux.intel.com, edwin.zhai@intel.com,
        tamas@tklengyel.com, mathieu.tarral@protonmail.com
In-Reply-To: <20200113173358.GC1175@linux.intel.com>
References: <20200102061319.10077-1-weijiang.yang@intel.com>
        <20200102061319.10077-7-weijiang.yang@intel.com>
        <20200110180458.GG21485@linux.intel.com>
        <20200113081050.GF12253@local-michael-cet-test.sh.intel.com>
        <20200113173358.GC1175@linux.intel.com>
Date:   Mon, 13 Jan 2020 20:55:46 +0200
Message-ID: <15789417460.A97E650.22893@host>
User-agent: void
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 13 Jan 2020 09:33:58 -0800, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
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
> 
> What I'm hoping is that it's possible to modify the call stacks to
> explicitly propagate an exit to userspace and/or SPP fault, and shove all
> the state capture into a common location, e.g. handle_ept_violation().
> 
> Side topic, assuming the userspace VMI is going to be instrospecting the
> faulting instruction, won't it decode the instruction?  I.e. calculate
> the instruction length anyways?

Indeed, we decode the instruction from userspace. I don't know if the
instruction length helps other projects. Added Tamas and Mathieu.

In our last VMI API proposal, the breakpoint event had the instruction
length sent to userspace, but I can't remember why.

https://lore.kernel.org/kvm/20190809160047.8319-62-alazar@bitdefender.com/
