Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE7B7D59C1
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 19:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234859AbjJXRa3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 13:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234856AbjJXRa1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 13:30:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1378FD7F;
        Tue, 24 Oct 2023 10:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698168626; x=1729704626;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4eTWR985NBV3mAvJMXvgeRN/dPF8gIx1f+55k33TMFE=;
  b=a/fOm95V579m4pvk+0O/p+2Qyt1N+DUnZHLK/ZS5Ri+qB8tgOKqPXQX0
   vBDPTtmR8OrAfP2UEvVpndmmkx1cAMZBWjhIpFdR8FeshrrVxUlAu71wJ
   4GA2MfRXW6MhrLb0wMCKw2sIpkambUhneMuAnZ+waCvthPSF0esK33vMk
   rc9wLnSCh2/0eic1KeZ9rQ+sFTXF9djaQLJEcWjsBQolw+0s11z30L/ML
   xRV7G7RqDUcZ8+FvdJj1wZGNmQG3ojf5BZNxNfbjxgdVs/HlZxqgrVjaE
   XmJdUi65uGrSLHPG9td43+ooh9hoTG6Ugw/Y41VdU6dNvrPUEuNJj9OBd
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="418247965"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="418247965"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 10:30:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="758554073"
X-IronPort-AV: E=Sophos;i="6.03,248,1694761200"; 
   d="scan'208";a="758554073"
Received: from zijianw1-mobl.amr.corp.intel.com (HELO desk) ([10.209.109.187])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 10:30:24 -0700
Date:   Tue, 24 Oct 2023 10:30:15 -0700
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
Message-ID: <20231024173015.w5qw767akvcdwmiv@desk>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
 <20231024103601.GH31411@noisy.programming.kicks-ass.net>
 <20231024163515.aivo2xfmwmbmlm7z@desk>
 <20231024163621.GD40044@noisy.programming.kicks-ass.net>
 <20231024164520.osvqo2dja2xhb7kn@desk>
 <20231024170248.GE40044@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024170248.GE40044@noisy.programming.kicks-ass.net>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 07:02:48PM +0200, Peter Zijlstra wrote:
> On Tue, Oct 24, 2023 at 09:45:20AM -0700, Pawan Gupta wrote:
> 
> > > > modules being within 4GB of kernel.
> 
> FWIW, it's 2G, it's a s32 displacement, the highest most address can
> jump 2g down, while the lowest most address can jump 2g up. Leaving a 2G
> directly addressable range.
> 
> And yeah, we ensure kernel text and modules are inside that 2G range.

Ah, okay. Thanks for the info.
