Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3658B6A2481
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 23:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbjBXWve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 17:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjBXWvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 17:51:32 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BF206F83C;
        Fri, 24 Feb 2023 14:51:22 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BEAB41EC0725;
        Fri, 24 Feb 2023 23:51:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677279080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=I0/DAcvGh63kLuV/4PhWOz8jJFp5cUWvt4Uph5cz1cA=;
        b=WZMZnuxoURigfhjSznJQgfAH0AwaypgAxZF/yQQ2Vsn00FwrdnMkNoXr6wzOyxzZFwEFfS
        GL8kukbCbnZPku/47miBR5PK++t6XKmxV66obCQ9NWCPwltZqsvqCfcDwhTBVVzEJ15pVk
        VhdsP0wdLUgLLgiVqAtsT5vG7e28sEA=
Date:   Fri, 24 Feb 2023 23:51:17 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
Cc:     Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 7/8] x86/cpu: Support AMD Automatic IBRS
Message-ID: <Y/k/ZXUXOFiBhOiI@zn.tnic>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/knUC0s+rg6ef2r@zn.tnic>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 24, 2023 at 10:08:32PM +0100, Borislav Petkov wrote:
> On Fri, Feb 24, 2023 at 10:52:57AM -0800, Josh Poimboeuf wrote:
> > Doesn't this only enable it on the boot CPU?
> 
> Whoops, you might be right.

Actually, we stick that MSR - EFER - into the trampoline header and then
each AP gets it written to in arch/x86/realmode/rm/trampoline_64.S

But this is only from code staring - I'll confirm this tomorrow.

And if so, we should at least put comments in that trampoline code so
that people do not remove the MSR writes.

Or, actually, we should simply write it again because it is the init
path and not really a hot path but it should damn well make sure that
that bit gets set.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
