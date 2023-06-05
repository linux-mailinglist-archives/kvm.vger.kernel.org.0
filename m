Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEA28722DB3
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 19:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbjFERc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 13:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbjFERcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 13:32:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED3BA7;
        Mon,  5 Jun 2023 10:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685986374; x=1717522374;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=dpMi+L6MA+Ixw4FIKF3v5NXFh2IOYnea+R3019EXnfs=;
  b=Ql4Z7OL0kDEsNn5BR296J54690Y3coYaVYhrvLh7BKi9vGz00/RIMRK3
   upobAorSjRcgmNrMkaSikPTpB0EhN1Y4nlHUsHLxQTaEXe2sgCv8Fwa5g
   a7soIbgCCZE8CgWIT9Z1hwO3XR/8TJYs8gGLl7GZ6Ro6LOyR2ZnMNR2at
   gm+dmJG95VyJNnxJ7Vd1+CPJ1f9y96dPu20ZPfVOXYK2pQQiw9jn1hkKN
   rhWvbpBSoetOcVnJQctB3vVxUdAAxmwW7zNjqp+6OFhUjGkuXTDidcSR2
   MBTRV9t2+jdRIqZ98kaMJPX0DZ8gYOD8fVpvA026inflSnDNrglWhGt6n
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336050482"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="336050482"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 10:31:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="883003346"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="883003346"
Received: from wstone-mobl1.amr.corp.intel.com (HELO desk) ([10.212.251.108])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 10:31:07 -0700
Date:   Mon, 5 Jun 2023 10:31:01 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        "kvm @ vger . kernel . org" <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Message-ID: <20230605173101.iflfly3bt6ydvvyk@desk>
References: <20230531150112.76156-1-jon@nutanix.com>
 <20230531231820.trrs2uugc24gegj4@treble>
 <F4BEBCAF-CBFC-4C3E-8B01-2ED84CF2E13A@nutanix.com>
 <20230601004202.63yulqs73kuh3ep6@treble>
 <846dd0c5-d431-e20e-fdb3-a4a26b6a22ca@citrix.com>
 <20230601012323.36te7hfv366danpf@desk>
 <20230601042345.52s5337uz62p6aow@treble>
 <21D1D290-7DE9-4864-A05B-A36779D9DC26@nutanix.com>
 <20230605163552.hi5kvh5wijegmus6@treble>
 <E704D6D6-3B03-40FA-8CDB-5FB58871BABC@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E704D6D6-3B03-40FA-8CDB-5FB58871BABC@nutanix.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05, 2023 at 04:39:02PM +0000, Jon Kohler wrote:
> 
> 
> > On Jun 5, 2023, at 12:35 PM, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> > 
> > On Mon, Jun 05, 2023 at 02:29:02PM +0000, Jon Kohler wrote:
> >> 
> >> 
> >>> On Jun 1, 2023, at 12:23 AM, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> >>> 
> >>> On Wed, May 31, 2023 at 06:24:29PM -0700, Pawan Gupta wrote:
> >>> 
> >>> ## 2023-05-31
> >>>> On Thu, Jun 01, 2023 at 01:50:48AM +0100, Andrew Cooper wrote:
> >>>>> On 01/06/2023 1:42 am, Josh Poimboeuf wrote:
> >>>>>> So each LFENCE has a distinct purpose.  That said, there are no indirect
> >>>>>> branches or unbalanced RETs between them.
> >>>>> 
> >>>>> How lucky are you feeling?
> >>>>> 
> >>>>> You're in C at this point, which means the compiler could have emitted a
> >>>>> call to mem{cpy,cmp}() in place of a simple assignment/comparison.
> >>>> 
> >>>> Moving the second LFENCE to the else part of WRMSR should be possible?
> >>>> So that the serialization can be achived either by WRMSR or LFENCE. This
> >>>> saves an LFENCE when host and guest value of MSR_SPEC_CTRL differ.
> >>> 
> >>> Yes.  Though in practice it might not make much of a difference.  With
> >>> wrmsr+lfence, the lfence has nothing to do so it might be almost
> >>> instantaneous anyway.
> >>> 
> >>> -- 
> >>> Josh
> >> 
> >> Coming back to this, what if we hoisted call vmx_spec_ctrl_restore_host above
> >> FILL_RETURN_BUFFER, and dropped this LFENCE as I did here?
> >> 
> >> That way, we wouldn’t have to mess with the internal LFENCE in nospec-branch.h,
> >> and that would act as the “final line of defense” LFENCE.
> >> 
> >> Would that be acceptable? Or does FILL_RETURN_BUFFER *need* to occur
> >> before any sort of calls no matter what?
> > 
> > If we go by Intel's statement that only unbalanced RETs are a concern,
> > that *might* be ok as long as there's a nice comment above the
> > FILL_RETURN_BUFFER usage site describing the two purposes for the
> > LFENCE.

We would then need FILL_RETURN_BUFFER to unconditionally execute LFENCE
to account for wrmsr branch misprediction. Currently LFENCE is not
executed for !X86_BUG_EIBRS_PBRSB.

> > However, based on Andy's concerns, which I've discussed with him
> > privately (but I'm not qualified to agree or disagree with), we may want
> > to just convert vmx_spec_ctrl_restore_host() to asm.  Better safe than
> > sorry.  My original implementation of that function was actually asm.  I
> > can try to dig up that code.

Note:

  VMexit
  CALL
    RET
  RET    <---- This is also a problem if the first call hasn't retired yet.
  LFENCE

Converting vmx_spec_ctrl_restore_host() to ASM should be able to take care
of this.
