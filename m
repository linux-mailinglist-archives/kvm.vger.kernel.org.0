Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882096A2C27
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 23:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjBYW4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 17:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjBYW4p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 17:56:45 -0500
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF0814E87;
        Sat, 25 Feb 2023 14:56:44 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 492E01EC047D;
        Sat, 25 Feb 2023 23:56:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1677365803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=j3ugE7rRx7v8z7AKp5/pV3RvqKMVeAPdtvAIQTrk910=;
        b=nGfZYDreGx6HtqGQU10qPtOFE6wEB4gbo2koYbUnfRkbrqLfG4yohZ3U1rx9oMq6OJMFSu
        H8UoJ9xucF1ZPuUwOJEsVv9cvRfzUb66oYBnmwihGIwUSBo6xv9LrsifmgPPAlQlPNWh1L
        Mpt+1vCC4eufpr2zoExuzVoGTMhf1NY=
Date:   Sat, 25 Feb 2023 23:56:37 +0100
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
Message-ID: <Y/qSJd1Z3ABEJPPD@zn.tnic>
References: <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic>
 <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic>
 <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble>
 <Y/n9XcbnCzWv2Vul@zn.tnic>
 <20230225172832.sqdd7dejkkmjxpt6@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230225172832.sqdd7dejkkmjxpt6@treble>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 25, 2023 at 09:28:32AM -0800, Josh Poimboeuf wrote:
> All the other "bug" code in identify_secondary_cpu() *is*
> vendor-specific.

I meant "vendor-specific" in the sense that AMD code goes to amd.c, etc.

As to the identify_secondary_cpu()  code - I didn't like it being
slapped there either but it got stuck in there hastily during the
mitigations upstreaming as back then we had bigger fish to fry than
paying too much attention to clean design...

> And for that matter, so is most of the code in bugs.c.
> 
> I'm thinking we should just move all this MSR-writing bug-related code
> into a new cpu_init_bugs() function in bugs.c which can be called by
> identify_secondary_cpu().

I guess.
 
> Then we have more "bug" code together and all the local
> variables/functions like spectre_v2_in_ibrs_mode() can remain local.

They're still local, more or less. Note the special cpu.h header which
is private to arch/x86/kernel/cpu/

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
