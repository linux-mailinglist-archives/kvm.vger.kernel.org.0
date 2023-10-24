Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D7FF7D592B
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 18:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbjJXQvP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 12:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbjJXQvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 12:51:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0D512B;
        Tue, 24 Oct 2023 09:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698166271; x=1729702271;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LhfLeQjT1NBATI10s/IuG90Bv24jkdT/VZiPecD03ZY=;
  b=YxxCOlrJIAzJ97/926Qyv3/xpqc8+mRpb8jrQ7FKReUMFvVu/yW0i8DP
   nq5Hr75+/eljuZAZRgi0empLVpcJdzmnDK3wQUGbeB85wxiU7iSsG+HC5
   Myawh48UjqwT1pFlL/2Em/LEOOeHpBNq6atgnPS1zZA6Rihl+VxNgu/Au
   lvVBVoLWWN6YzjCDnrtX0nJ1t5xfQ4R1TsF4v+Fa6tAvkl1Vj+MohK17q
   NZZCPGryow67C5dDgU8fvqADgp+aWF9OeTjkz/qzeILkTn/+isL5wt+h/
   gSSF+n+J2y/hW0s4LcB7rxQf8B7+xaYJGzQqOg363G6M88E5ee9H6M41m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="451339987"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="451339987"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 09:45:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="758530739"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="758530739"
Received: from zijianw1-mobl.amr.corp.intel.com (HELO desk) ([10.209.109.187])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 09:45:37 -0700
Date:   Tue, 24 Oct 2023 09:45:20 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
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
Subject: Re: [PATCH  v2 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231024164520.osvqo2dja2xhb7kn@desk>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
 <20231024103601.GH31411@noisy.programming.kicks-ass.net>
 <20231024163515.aivo2xfmwmbmlm7z@desk>
 <20231024163621.GD40044@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024163621.GD40044@noisy.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 06:36:21PM +0200, Peter Zijlstra wrote:
> On Tue, Oct 24, 2023 at 09:35:15AM -0700, Pawan Gupta wrote:
> > On Tue, Oct 24, 2023 at 12:36:01PM +0200, Peter Zijlstra wrote:
> > > On Tue, Oct 24, 2023 at 01:08:21AM -0700, Pawan Gupta wrote:
> > > 
> > > > +.macro CLEAR_CPU_BUFFERS
> > > > +	ALTERNATIVE "jmp .Lskip_verw_\@;", "jmp .Ldo_verw_\@", X86_FEATURE_CLEAR_CPU_BUF
> > > > +		/* nopl __KERNEL_DS(%rax) */
> > > > +		.byte 0x0f, 0x1f, 0x80, 0x00, 0x00;
> > > > +.Lverw_arg_\@:	.word __KERNEL_DS;
> > > > +.Ldo_verw_\@:	verw _ASM_RIP(.Lverw_arg_\@);
> > > > +.Lskip_verw_\@:
> > > > +.endm
> > > 
> > > Why can't this be:
> > > 
> > > 	ALTERNATIVE "". "verw _ASM_RIP(mds_verw_sel)", X86_FEATURE_CLEAR_CPU_BUF
> > > 
> > > And have that mds_verw_sel thing be out-of-line ?
> > 
> > I haven't done this way because its a tad bit fragile as it depends on
> > modules being within 4GB of kernel.
> 
> We 100% rely on that *everywhere*, nothing fragile about it.

I didn't know that, doing it this way then. Thanks.
