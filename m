Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 444987D3D07
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 19:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjJWRFX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 13:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjJWRFW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 13:05:22 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 715B794;
        Mon, 23 Oct 2023 10:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698080719; x=1729616719;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zwazxV2v2G4q0zaiWjYMDu8qcaaTQb+HDKTqL3vinjQ=;
  b=b43KMaZfzU5P9cvi7FSbio+QH6sP+zFCYMCAyMuI6adivF74pMtB2E7r
   mNWry4bEZpl/bkAbur0XbVEpvFIbhYgnfNuvrxRqMUdQPsfJ5TnWoUR2r
   8M8GN6x9+uoKOyB8dFbBESxRxB9A8hLi/eADCpOemNvAMLFQpblTG4KYh
   HzX28ouRuLkqN1IHdqCX8MG9IU9cFvrSpeSr12aBk1gpqssjd+WlGwtoe
   ojBm4/yFM3Tzw9Bek9iXo+Q0oCTU5lzNrfHkdN+RhI/zm6C9oq+Qxkofq
   grz9dw0adgLPyHEcYnpTe3swbJPISvGx9Bc5YxsLAAWDBY4B0DDtAAD2b
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="366230253"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="366230253"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 10:05:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10872"; a="793194889"
X-IronPort-AV: E=Sophos;i="6.03,246,1694761200"; 
   d="scan'208";a="793194889"
Received: from qwilliam-mobl.amr.corp.intel.com (HELO desk) ([10.212.150.186])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2023 10:05:18 -0700
Date:   Mon, 23 Oct 2023 10:05:10 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH  6/6] KVM: VMX: Move VERW closer to VMentry for MDS
 mitigation
Message-ID: <20231023170510.ayk3f5vosyh6skmg@desk>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-6-cff54096326d@linux.intel.com>
 <ZTMFS8I2s8EroSNe@google.com>
 <20231021004633.ymughma7zijosku5@desk>
 <ZTaKMdZqq2R1xXFh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTaKMdZqq2R1xXFh@google.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 07:58:57AM -0700, Sean Christopherson wrote:
> On Fri, Oct 20, 2023, Pawan Gupta wrote:
> > On Fri, Oct 20, 2023 at 03:55:07PM -0700, Sean Christopherson wrote:
> > > On Fri, Oct 20, 2023, Pawan Gupta wrote:
> > > > During VMentry VERW is executed to mitigate MDS. After VERW, any memory
> > > > access like register push onto stack may put host data in MDS affected
> > > > CPU buffers. A guest can then use MDS to sample host data.
> > > > 
> > > > Although likelihood of secrets surviving in registers at current VERW
> > > > callsite is less, but it can't be ruled out. Harden the MDS mitigation
> > > > by moving the VERW mitigation late in VMentry path.
> > > > 
> > > > Note that VERW for MMIO Stale Data mitigation is unchanged because of
> > > > the complexity of per-guest conditional VERW which is not easy to handle
> > > > that late in asm with no GPRs available. If the CPU is also affected by
> > > > MDS, VERW is unconditionally executed late in asm regardless of guest
> > > > having MMIO access.
> > > > 
> > > > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > > > ---
> > > >  arch/x86/kvm/vmx/vmenter.S |  9 +++++++++
> > > >  arch/x86/kvm/vmx/vmx.c     | 10 +++++++---
> > > >  2 files changed, 16 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
> > > > index be275a0410a8..efa716cf4727 100644
> > > > --- a/arch/x86/kvm/vmx/vmenter.S
> > > > +++ b/arch/x86/kvm/vmx/vmenter.S
> > > > @@ -1,6 +1,7 @@
> > > >  /* SPDX-License-Identifier: GPL-2.0 */
> > > >  #include <linux/linkage.h>
> > > >  #include <asm/asm.h>
> > > > +#include <asm/segment.h>
> > > >  #include <asm/bitsperlong.h>
> > > >  #include <asm/kvm_vcpu_regs.h>
> > > >  #include <asm/nospec-branch.h>
> > > > @@ -31,6 +32,8 @@
> > > >  #define VCPU_R15	__VCPU_REGS_R15 * WORD_SIZE
> > > >  #endif
> > > >  
> > > > +#define GUEST_CLEAR_CPU_BUFFERS		USER_CLEAR_CPU_BUFFERS
> > > > +
> > > >  .macro VMX_DO_EVENT_IRQOFF call_insn call_target
> > > >  	/*
> > > >  	 * Unconditionally create a stack frame, getting the correct RSP on the
> > > > @@ -177,10 +180,16 @@ SYM_FUNC_START(__vmx_vcpu_run)
> > > >   * the 'vmx_vmexit' label below.
> > > >   */
> > > >  .Lvmresume:
> > > > +	/* Mitigate CPU data sampling attacks .e.g. MDS */
> > > > +	GUEST_CLEAR_CPU_BUFFERS
> > > 
> > > I have a very hard time believing that it's worth duplicating the mitigation
> > > for VMRESUME vs. VMLAUNCH just to land it after a Jcc.
> > 
> > VERW modifies the flags, so it either needs to be after Jcc or we
> > push/pop flags that adds 2 extra memory operations. Please let me know
> > if there is a better option.
> 
> Ugh, I assumed that piggybacking VERW overrode the original behavior entirely, I
> didn't realize it sacrifices EFLAGS.ZF on the altar of mitigations.
> 
> Luckily, this is easy to solve now that VMRESUME vs. VMLAUNCH uses a flag instead
> of a dedicated bool.

Thats great.

> From: Sean Christopherson <seanjc@google.com>
> Date: Mon, 23 Oct 2023 07:44:35 -0700
> Subject: [PATCH] KVM: VMX: Use BT+JNC, i.e. EFLAGS.CF to select VMRESUME vs.
>  VMLAUNCH
> 
> Use EFLAGS.CF instead of EFLAGS.ZF to track whether to use VMRESUME versus
> VMLAUNCH.  Freeing up EFLAGS.ZF will allow doing VERW, which clobbers ZF,
> for MDS mitigations as late as possible without needing to duplicate VERW
> for both paths.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thanks for the patch, I will include it in the next revision.
