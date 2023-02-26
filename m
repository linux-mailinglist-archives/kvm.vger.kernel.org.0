Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF716A332A
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 18:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjBZR1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 12:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjBZR1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 12:27:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1585A17140;
        Sun, 26 Feb 2023 09:27:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA915B80B07;
        Sun, 26 Feb 2023 17:27:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D9D9C433EF;
        Sun, 26 Feb 2023 17:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677432448;
        bh=Ua3oPrmvH330KRAKtpBqRdRMZ6rjHIhfTvhZmK/Msjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ub165GqcmsTkskmKhqJhReLW5ZD7W9DJzka+7J1mJHsf7XfNCvZegWntw6E0tti4Y
         Qy7IO2GGjhFRq27bcfh5VXzJFfU+3K41AjgouwbRt6qDkWUrTlrP2D6DFfrYlaCuDr
         byq+a2Y5BWGKGmRMV6esJX4nyrToJia5O9lgspISIyMIQUrKQGvUX81FC5rC+S7Yut
         idIEh3i+AuRxM5/cc0cTqLBfcfvKHXDSHF18zAALVbHmW9ss1KPFoI097udPW+pxRb
         QTIK4+XF9QJoM/88cxNwSMuZlVTL+jSZSWmUU0ENKJHkSgNiH+ni2CbxMI9L5tECZ5
         AJFQScnS9xCYQ==
Date:   Sun, 26 Feb 2023 09:27:26 -0800
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Kim Phillips <kim.phillips@amd.com>, x86@kernel.org,
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
Subject: Re: [PATCH] x86/CPU/AMD: Make sure EFER[AIBRSE] is set
Message-ID: <20230226172726.iidbgidy5336npi4@treble>
References: <Y/k/ZXUXOFiBhOiI@zn.tnic>
 <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic>
 <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble>
 <Y/n9XcbnCzWv2Vul@zn.tnic>
 <20230225172832.sqdd7dejkkmjxpt6@treble>
 <Y/qSJd1Z3ABEJPPD@zn.tnic>
 <20230225234330.caznxpkjhq3u5tls@treble>
 <Y/s/7rtj+SDqRuMz@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/s/7rtj+SDqRuMz@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 26, 2023 at 12:18:06PM +0100, Borislav Petkov wrote:
> > Right, so rather than spreading all the bug-related MSR logic around,
> > just do it in one spot.
> 
> It is all CPU init code and I'm wondering if splitting stuff by vendor
> wouldn't make all that maze in bugs.c a lot more palatable. And get rid
> of
> 
> $ git grep VENDOR arch/x86/kernel/cpu/bugs.c | wc -l
> 11
> 
> those, for starters.
> 
> There's this trade-off of
> 
> 1. keeping bugs setup code in one place - but then you need to do vendor
>    checks and the other CPU setup code is somewhere else and it is
>    probably related, MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT in amd.c for
>    example.
> 
> or
> 
> 2. separating it into their respective files. Then the respective vendor
>    code is simple because you don't need vendor checks. It would need to
>    be done in a slick way, though, so that it remains maintainable.

At least now it's a (mostly) self-contained hornets nest.  I'm not sure
we want to poke it :-)

And I'm not sure spreading the mess around would be an improvement.

-- 
Josh
