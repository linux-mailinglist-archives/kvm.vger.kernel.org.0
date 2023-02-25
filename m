Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FC876A2B1B
	for <lists+kvm@lfdr.de>; Sat, 25 Feb 2023 18:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjBYR2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 12:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjBYR2h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 12:28:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD88C11653;
        Sat, 25 Feb 2023 09:28:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21F0660B51;
        Sat, 25 Feb 2023 17:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBB2C433EF;
        Sat, 25 Feb 2023 17:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677346115;
        bh=OQY775V7tq8tLvORC1v+ZouMR4NkgEeJqiRqqDQjHKk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UYQdlVogKngmxvP/3HxRVbDMpZjmw8R4UaFy0fZtMwYkonGfTO48sYVSYIZ8xZs9m
         sfxYvrqldYa1qg1tzHCwwS9bR+3ZAyYtwAHZn7zMlb9pdv05c2VqFIY1TBsXrPWYzt
         bGlJUTsmy3nMAFn0lxWJrZkv3/s4/FnoMvaDZFgZTNtB7u0IY++87+ANUOue+ldtJ4
         +1RokzbkSlPeF0CtNj4xh34oA9EoCVMi1/Vr2qGo8ve3t6Gkau+QOgHVuRUqHZVu/m
         dhMse7A70f8yLkgrwnfaJazl+8EEZjSOyuBGSiwFjbnWQGfDZspTjpbCzwfQCJBF4x
         5+8MwgWK4ZVBA==
Date:   Sat, 25 Feb 2023 09:28:32 -0800
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
Message-ID: <20230225172832.sqdd7dejkkmjxpt6@treble>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
 <20230124163319.2277355-8-kim.phillips@amd.com>
 <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic>
 <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic>
 <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble>
 <Y/n9XcbnCzWv2Vul@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/n9XcbnCzWv2Vul@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 25, 2023 at 01:21:49PM +0100, Borislav Petkov wrote:
> On Fri, Feb 24, 2023 at 05:32:02PM -0800, Josh Poimboeuf wrote:
> > > Is it intended to be set regardless of the spectre_v2 mitigation status?
> > 
> > Right, it needs to check spectre_v2_enabled.
> 
> Right, I realized this too this morning, while sleeping, so I made me
> a note on the nightstand to fix it... :-)
> 
> > Also, this code might be a better fit in identify_secondary_cpu() with
> > the other MSR-writing bug-related code.
> 
> Same path:
> 
> identify_secondary_cpu->identify_cpu->this_cpu->c_init(c)->init_amd
> 
> Plus, it keeps the vendor code where it belongs.

All the other "bug" code in identify_secondary_cpu() *is*
vendor-specific.

And for that matter, so is most of the code in bugs.c.

I'm thinking we should just move all this MSR-writing bug-related code
into a new cpu_init_bugs() function in bugs.c which can be called by
identify_secondary_cpu().

Then we have more "bug" code together and all the local
variables/functions like spectre_v2_in_ibrs_mode() can remain local.

-- 
Josh
