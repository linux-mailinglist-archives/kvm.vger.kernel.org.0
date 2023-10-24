Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F117D5883
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 18:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344007AbjJXQf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 12:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234833AbjJXQfY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 12:35:24 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF38110C9;
        Tue, 24 Oct 2023 09:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698165318; x=1729701318;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vHBCAUM4hc+mv/WCTAYZTH9LHpXPIFgRr4vgKJHjnS4=;
  b=fLyULUq7KDymHT1vNpyTKdOPF4G3JZp/y/dTJn3Jss/cI8Knw00vfbI9
   Yipno6Lt9dwXLl5EWWX94ES/gFTatAKi+S5YVkANVCqkURnezx8Z6Q2R7
   j0YDg1lFjUmj7bkRpF4uaFUkrd7BFt1bOfCyKftRynSRQ78noKbhFPwhg
   nIyAHcJg6pVUBasGNTithF+qzHjX7NzyYj6IT4/xWl4PpfOZiHPSSxFDV
   n1X81BIk0IZ15ZL6HZPWg8Uum1dh1ce5XbyYLrg3Gr1e8Msb8upMjObX7
   TznnOL6AsDSudLaXRmng0BN7cg2yvD6FM6P6MwekfK0/RKzFq2k3kYCd0
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="453581497"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="453581497"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 09:35:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="932088939"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="932088939"
Received: from zijianw1-mobl.amr.corp.intel.com (HELO desk) ([10.209.109.187])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 09:35:17 -0700
Date:   Tue, 24 Oct 2023 09:35:15 -0700
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
Message-ID: <20231024163515.aivo2xfmwmbmlm7z@desk>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
 <20231024103601.GH31411@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024103601.GH31411@noisy.programming.kicks-ass.net>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 12:36:01PM +0200, Peter Zijlstra wrote:
> On Tue, Oct 24, 2023 at 01:08:21AM -0700, Pawan Gupta wrote:
> 
> > +.macro CLEAR_CPU_BUFFERS
> > +	ALTERNATIVE "jmp .Lskip_verw_\@;", "jmp .Ldo_verw_\@", X86_FEATURE_CLEAR_CPU_BUF
> > +		/* nopl __KERNEL_DS(%rax) */
> > +		.byte 0x0f, 0x1f, 0x80, 0x00, 0x00;
> > +.Lverw_arg_\@:	.word __KERNEL_DS;
> > +.Ldo_verw_\@:	verw _ASM_RIP(.Lverw_arg_\@);
> > +.Lskip_verw_\@:
> > +.endm
> 
> Why can't this be:
> 
> 	ALTERNATIVE "". "verw _ASM_RIP(mds_verw_sel)", X86_FEATURE_CLEAR_CPU_BUF
> 
> And have that mds_verw_sel thing be out-of-line ?

I haven't done this way because its a tad bit fragile as it depends on
modules being within 4GB of kernel.

> That gives much better code for the case where we don't need this.

If this is the preferred way let me test this and roll a new revision.
