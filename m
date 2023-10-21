Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146247D1A3F
	for <lists+kvm@lfdr.de>; Sat, 21 Oct 2023 03:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbjJUBTO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 21:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjJUBTN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 21:19:13 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3526BD67;
        Fri, 20 Oct 2023 18:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1697851148; x=1729387148;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=czgDYYnGMR+x6IWe3MoUs9kSDZkqARZu11lHJOx2X7w=;
  b=bqTLis+SD8VPoBFNPZmTqWEaHYUC/5bhprHxghuFu9y0J/EToCBfZqNe
   X8yxzE6QcgIa8uDzrrYI7AaDOKCvQwBfAfcqFA9SUTMwaZw32YbXtH2DI
   DhNYc8hd7Q+Z/E+//Q8kZPM5QOPQTn15Gv/V11z3z3FUP+YIRP7JoHLiN
   UITYBpYHdwx3tRtreV60os912VwjsBxbj/GBDRjS2pjdSx9YzIxj5yc4T
   kX7YU8btB1USQ6Z2HELCAbzh+VfQXLmzY7KFXrF5yyfoHBu5GXp9L+asX
   Ou/iLx6PC8nJ2odqQTbr+mU68Audt8nSwnI1h9GNec4TEqD5VSQS3wn++
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10869"; a="417732654"
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="417732654"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 18:19:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,239,1694761200"; 
   d="scan'208";a="5268375"
Received: from hkchanda-mobl.amr.corp.intel.com (HELO desk) ([10.209.90.113])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2023 18:17:55 -0700
Date:   Fri, 20 Oct 2023 18:18:59 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
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
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [RESEND][PATCH 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231021011859.c2rtc4vl7l2cl4q6@desk>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-1-cff54096326d@linux.intel.com>
 <f620c7d4-6345-4ad0-8a45-c8089e3c34df@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f620c7d4-6345-4ad0-8a45-c8089e3c34df@citrix.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 21, 2023 at 12:55:45AM +0100, Andrew Cooper wrote:
> On 20/10/2023 9:44 pm, Pawan Gupta wrote:
> > +#define EXEC_VERW				\
> > +	__EXEC_VERW(551f);			\
> > +	/* nopl __KERNEL_DS(%rax) */		\
> > +	.byte 0x0f, 0x1f, 0x80, 0x00, 0x00;	\
> > +551:	.word __KERNEL_DS;			\
> 
> Is this actually wise from a perf point of view?
> 
> You're causing a data access to the instruction stream, and not only
> that, the immediate next instruction.  Some parts don't take kindly to
> snoops hitting L1I.

I suspected the same and asked CPU architects, they did not anticipate
reads being interpreted as part of self modifying code. The perf numbers
do not indicate a problem, but they dont speak for all the parts. It
could be an issue with some parts.

> A better option would be to simply have
> 
> .section .text.entry
> .align CACHELINE
> mds_verw_sel:
>     .word __KERNEL_DS
>     int3
> .align CACHELINE
> 
> 
> And then just have EXEC_VERW be
> 
>     verw mds_verw_sel(%rip)
> 
> in the fastpaths.  That keeps the memory operand in .text.entry it works
> on Meltdown-vulnerable CPUs, but creates effectively a data cacheline
> that isn't mixed into anywhere in the frontend, which also gets far
> better locality of reference rather than having it duplicated in 9
> different places.

> Also it avoids playing games with hiding data inside an instruction.
> It's a neat trick, but the neater trick is avoid it whenever possible.

Thanks for the pointers. I think verw in 32-bit mode won't be able to
address the operand outside of 4GB range. Maybe this is fine or could it
be a problem addressing from e.g. KVM module?
