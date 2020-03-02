Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 022BC176394
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 20:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgCBTNO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 14:13:14 -0500
Received: from mga06.intel.com ([134.134.136.31]:22460 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbgCBTNO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 14:13:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 11:13:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="386344227"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga004.jf.intel.com with ESMTP; 02 Mar 2020 11:13:13 -0800
Date:   Mon, 2 Mar 2020 11:13:13 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 10/13] KVM: x86: Shrink the usercopy region of the
 emulation context
Message-ID: <20200302191313.GC6244@linux.intel.com>
References: <20200218232953.5724-1-sean.j.christopherson@intel.com>
 <20200218232953.5724-11-sean.j.christopherson@intel.com>
 <87r1yhi6ex.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r1yhi6ex.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 26, 2020 at 06:51:02PM +0100, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Shuffle a few operand structs to the end of struct x86_emulate_ctxt and
> > update the cache creation to whitelist only the region of the emulation
> > context that is expected to be copied to/from user memory, e.g. the
> > instruction operands, registers, and fetch/io/mem caches.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/kvm_emulate.h |  8 +++++---
> >  arch/x86/kvm/x86.c         | 12 ++++++------
> >  2 files changed, 11 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> > index 2f0a600efdff..82f712d5c692 100644
> > --- a/arch/x86/kvm/kvm_emulate.h
> > +++ b/arch/x86/kvm/kvm_emulate.h
> > @@ -322,9 +322,6 @@ struct x86_emulate_ctxt {
> >  	u8 intercept;
> >  	u8 op_bytes;
> >  	u8 ad_bytes;
> > -	struct operand src;
> > -	struct operand src2;
> > -	struct operand dst;
> >  	int (*execute)(struct x86_emulate_ctxt *ctxt);
> >  	int (*check_perm)(struct x86_emulate_ctxt *ctxt);
> >  	/*
> > @@ -349,6 +346,11 @@ struct x86_emulate_ctxt {
> >  	u8 seg_override;
> >  	u64 d;
> >  	unsigned long _eip;
> > +
> > +	/* Here begins the usercopy section. */
> > +	struct operand src;
> > +	struct operand src2;
> > +	struct operand dst;
> 
> Out of pure curiosity, how certain are we that this is going to be
> enough for userspaces?

This is purely related to in-kernel hardening, there's no concern about
this being "enough" because it's not directly visible to userspace.

usercopy refers to the kernel copying data to/from user memory.  When
running with CONFIG_HARDENED_USERCOPY=y, copy_{to,from}_user performs
extra checks to warn if the kernel is doing something potentially
dangerous.  For this code specifically, it will warn if user data is
being copied into a struct and the affected range within the struct isn't
explicitly annotated as being safe for usercopy.  The idea is that the
kernel shouldn't be copying user data into variables that the kernel
expects are fully under its control.

Currently, KVM marks the entire struct x86_emulate_ctxt as being "safe"
for usercopy, which is sub-optimal because HARDENED_USERCOPY wouldn't be
able to detect KVM bugs, e.g. if "enum x86emul_mode mode" were overwritten
by copy_from_user().  Shuffling the emulator fields so that the all fields
that are used for usercopy are clustered together allows KVM to use a more
precise declaration for which fields are "safe", e.g. the theoretical @mode
bug would now be caught.
