Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92CA47D1A49
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 03:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232860AbjJUB20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 21:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJUB2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 21:28:25 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24622D68;
        Fri, 20 Oct 2023 18:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697851704; x=1729387704;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mUdZYVXimImfRLdgMfRGzWaY3JrjlP3m7bhFqgBKk8k=;
  b=BNXqtnlDZAOoc4pm/ZziKCBLkJ1HK8gnKNgcmCMio+Uqx9WCEqqSOrcx
   Qm2WXm3tmsPKL9TtpW4Ez004xS+9sC599Wn6cBtDdA6I5l3XQ4xIhJFYl
   VWnKrdkZ+S6qdgqKHxoVxDvnTETtPTg0ZsRjT2gsyqAi+VMmFhEFT/cl7
   AjJcQxXrGkGfI+nxlD11MvY9W28ZvG16Jc8OhrO69cHV9coT+ci887Wuz
   vgqWGF7cYfwtH7LnSJoG06gk/31xPNqmLQFqzsqw0p3XYPDC/ZaVtOSlp
   Y4o6dct2r4nNFW2eGB8BsfEmpiwVcpcJHGQt5Rx3x1oIZdcafpeo6AYsm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="389453049"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="389453049"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 18:28:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="823428780"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="823428780"
Received: from hkchanda-mobl.amr.corp.intel.com (HELO desk) ([10.209.90.113])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 18:28:22 -0700
Date:   Fri, 20 Oct 2023 18:28:11 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Andi Kleen <ak@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com
Subject: Re: [PATCH  3/6] x86/entry_32: Add VERW just before userspace
 transition
Message-ID: <20231021012744.3yz7lpo2w6gyvytr@desk>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-3-cff54096326d@linux.intel.com>
 <ZTMSDkBzUZBiTBoG@tassilo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTMSDkBzUZBiTBoG@tassilo>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 04:49:34PM -0700, Andi Kleen wrote:
> On Fri, Oct 20, 2023 at 01:45:09PM -0700, Pawan Gupta wrote:
> > As done for entry_64, add support for executing VERW late in exit to
> > user path for 32-bit mode.
> > 
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >  arch/x86/entry/entry_32.S | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/arch/x86/entry/entry_32.S b/arch/x86/entry/entry_32.S
> > index 6e6af42e044a..bbf77d2aab2e 100644
> > --- a/arch/x86/entry/entry_32.S
> > +++ b/arch/x86/entry/entry_32.S
> > @@ -886,6 +886,9 @@ SYM_FUNC_START(entry_SYSENTER_32)
> >  	popfl
> >  	popl	%eax
> >  
> > +	/* Mitigate CPU data sampling attacks .e.g. MDS */
> > +	USER_CLEAR_CPU_BUFFERS
> > +
> >  	/*
> >  	 * Return back to the vDSO, which will pop ecx and edx.
> >  	 * Don't bother with DS and ES (they already contain __USER_DS).
> 
> Did you forget the INT 0x80 entry point?

I do have VERW in the INT80 path, the diff is showing just the label
restore_all_switch_stack. Below is the sequence:

SYM_FUNC_START(entry_INT80_32)
	ASM_CLAC
	pushl	%eax			/* pt_regs->orig_ax */

	SAVE_ALL pt_regs_ax=$-ENOSYS switch_stacks=1	/* save rest */

	movl	%esp, %eax
	call	do_int80_syscall_32
.Lsyscall_32_done:
	STACKLEAK_ERASE

restore_all_switch_stack:
	SWITCH_TO_ENTRY_STACK
	CHECK_AND_APPLY_ESPFIX

	/* Switch back to user CR3 */
	SWITCH_TO_USER_CR3 scratch_reg=%eax

	BUG_IF_WRONG_CR3

	/* Restore user state */
	RESTORE_REGS pop=4			# skip orig_eax/error_code

	/* Mitigate CPU data sampling attacks .e.g. MDS */
	USER_CLEAR_CPU_BUFFERS
	^^^^^^^^^^^^^^^^^^^^^^
