Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123AB6A337E
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 19:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjBZSoT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 Feb 2023 13:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjBZSoR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 Feb 2023 13:44:17 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5838CDDD;
        Sun, 26 Feb 2023 10:44:15 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 2C8D41EC0505;
        Sun, 26 Feb 2023 19:44:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677437054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=rXoym0obEUSH1mjLiPOp+aa2Yv/KRlu/Xe4v9jWR4pY=;
        b=PMLG3AaH9U5f6W9kPb5mRHBIoo9IE7cJLKs+7MUG1UWhU32OApHTM8tDVth6IadQwMvb2J
        4DuvFZda4Eip1oVzX1RKGkgwjxruJ0XyEQKTtBpEEEIYWRvJSBGSP/WDBwE+K5V/EyiAde
        7zJLaKsOwbdCBhr1QlchNFatHTgy5fI=
Date:   Sun, 26 Feb 2023 19:44:09 +0100
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
Message-ID: <Y/uoeZKMxAgqU5eR@zn.tnic>
References: <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic>
 <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble>
 <Y/n9XcbnCzWv2Vul@zn.tnic>
 <20230225172832.sqdd7dejkkmjxpt6@treble>
 <Y/qSJd1Z3ABEJPPD@zn.tnic>
 <20230225234330.caznxpkjhq3u5tls@treble>
 <Y/s/7rtj+SDqRuMz@zn.tnic>
 <20230226172726.iidbgidy5336npi4@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230226172726.iidbgidy5336npi4@treble>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Feb 26, 2023 at 09:27:26AM -0800, Josh Poimboeuf wrote:
> At least now it's a (mostly) self-contained hornets nest.  I'm not sure
> we want to poke it :-)
> 
> And I'm not sure spreading the mess around would be an improvement.

Yah, if anything, I wanna see the change first and it has to be an
obvious and good one.

What I think we should finish doing, though, is documenting it. Because
there are aspects/mitigations that are missing, e.g., there's no
retbleed.rst in Documentation/admin-guide/hw-vuln/

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
