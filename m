Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9E86670C2
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 12:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbjALLUl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 06:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238814AbjALLTt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 06:19:49 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF0C13DBDD;
        Thu, 12 Jan 2023 03:12:07 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 926031EC05F1;
        Thu, 12 Jan 2023 12:12:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1673521925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=0vQOVZuKQjRWQ/e7isoLIfI6wGC5c5xNgWFk0olFibk=;
        b=p3NLvpJQL38wQx7laaSRDtG1IyQic4qNmIwn9kOtsfROkX701b3CXKkbs/R5FZTjuoprFS
        iTfWt7+i2spQAZ2yqVr7N3o52tPpqVl79crY84UzZUYQ6s31KIMeQns/7ea/LCEPoBpQkV
        yJ+FpQWMwUGgrzqcfkvOT0BfHJd6IXI=
Date:   Thu, 12 Jan 2023 12:12:02 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Alexey Kardashevskiy <aik@amd.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Venu Busireddy <venu.busireddy@oracle.com>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Sandipan Das <sandipan.das@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Huang Rui <ray.huang@amd.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH kernel v2 1/3] x86/amd: Cache values in percpu variables
Message-ID: <Y7/rAkvppxwZVIvQ@zn.tnic>
References: <20221209043804.942352-1-aik@amd.com>
 <20221209043804.942352-2-aik@amd.com>
 <Y72MwWB+Nsphjqs8@zn.tnic>
 <61fde9ac-e24f-c765-a9a8-91fac60b9cb3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <61fde9ac-e24f-c765-a9a8-91fac60b9cb3@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 12, 2023 at 04:21:28PM +1100, Alexey Kardashevskiy wrote:
> "that function" is set_dr_addr_mask() (btw should I rename it to start with
> amd_?

If you really wanna... I mean the code is already doing AMD-specific handling
but sure, it'll be more obvious then that arch_install_hw_breakpoint() does only
AMD-specific masking there under the info->mask test.

> If it is out of bounds, it won't neither set or get. And these 2 helpers are
> used only by the kernel and the callers pass 0..3 and nothing else. BUG_ON()
> would do too, for example.

Yeah, we don't do BUG_ON - look for Linus' colorful explanations why. :)

In any case, I think we should always aim for proper recovery from errors but
this case is not that important so let's leave it at the WARN_ON_ONCE.

> imho having 1,2,3 in the code eliminates the need in a comment and produces
> the exact same end result. But since nobody cares, I'll do it the shorter
> way with just +1 and +2.

Yeah, the more important goal is simplicity. And that pays off when you have to
revisit that code and figure out what it does, later.

> Sure. Out of curiosity - why?^w^w^w^w^  it reduced the vmlinux size by 48
> bytes, nice.

The same answer - simplicity and speed when reading it.

That

	if (per_cpu(amd_dr_addr_mask, smp_processor_id())[dr] == mask)

is a bit harder to parse than

	if (per_cpu(amd_dr_addr_mask, cpu)[dr] == mask)

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
