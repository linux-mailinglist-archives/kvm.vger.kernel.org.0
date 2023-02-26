Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213F56A2F49
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 12:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjBZLSN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 06:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjBZLSM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 06:18:12 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1E34EE1;
        Sun, 26 Feb 2023 03:18:11 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id C4A311EC05B0;
        Sun, 26 Feb 2023 12:18:09 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677410289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=Fqca05TAjyju01u0iIdb8z1cG5MT45Cv6Y7lhY3Umj8=;
        b=jIwESVcTEQVvy+6uCr73JGWEzdJ4pig7GZmp2tyYMtE8Mp5gPFQ39fx1t41A2BJW/S0C7D
        fMkYE3m7OxzkOasn/G17ICTgpmzA/diz6Aq17Rj5O7WNtiJSAvfpEy1SVZTUNXfEt9sGly
        fTwBBZQutvKO3/lJ9F2BAmR6TgvySKU=
Date:   Sun, 26 Feb 2023 12:18:06 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Josh Poimboeuf <jpoimboe@kernel.org>
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
Message-ID: <Y/s/7rtj+SDqRuMz@zn.tnic>
References: <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic>
 <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic>
 <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble>
 <Y/n9XcbnCzWv2Vul@zn.tnic>
 <20230225172832.sqdd7dejkkmjxpt6@treble>
 <Y/qSJd1Z3ABEJPPD@zn.tnic>
 <20230225234330.caznxpkjhq3u5tls@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230225234330.caznxpkjhq3u5tls@treble>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 25, 2023 at 03:43:30PM -0800, Josh Poimboeuf wrote:
> Hm?  So code in bugs.c is not vendor-specific?  That seems circular and
> I don't get your point.

Lemme try that again...

So there's an obvious benefit of keeping vendor-specific CPU code in one
place: Intel stuff in cpu/intel*, AMD stuff in cpu/amd.c

The sekjority stuff is still vendor-specific CPU code.

Now, if you wanna add a function pointer ->bugs_init or so, say, to

	struct cpu_dev

and keep the respective code in amd.c or intel.c, then we get the best
of both worlds:

- vendor-specific code remains in the respective file

- you have a vendor-specific function which does hw vuln-specific work
  *without* vendor checks and so on

> Right, so rather than spreading all the bug-related MSR logic around,
> just do it in one spot.

It is all CPU init code and I'm wondering if splitting stuff by vendor
wouldn't make all that maze in bugs.c a lot more palatable. And get rid
of

$ git grep VENDOR arch/x86/kernel/cpu/bugs.c | wc -l
11

those, for starters.

There's this trade-off of

1. keeping bugs setup code in one place - but then you need to do vendor
   checks and the other CPU setup code is somewhere else and it is
   probably related, MSR_AMD64_DE_CFG_LFENCE_SERIALIZE_BIT in amd.c for
   example.

or

2. separating it into their respective files. Then the respective vendor
   code is simple because you don't need vendor checks. It would need to
   be done in a slick way, though, so that it remains maintainable.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
