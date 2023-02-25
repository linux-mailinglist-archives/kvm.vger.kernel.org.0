Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEDC6A2CA1
	for <lists+kvm@lfdr.de>; Sun, 26 Feb 2023 00:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjBYXnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Feb 2023 18:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjBYXne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Feb 2023 18:43:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A26C65C;
        Sat, 25 Feb 2023 15:43:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C44A60B9B;
        Sat, 25 Feb 2023 23:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1970C433D2;
        Sat, 25 Feb 2023 23:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677368612;
        bh=d60Nmt1XVteziluASH8Ks/31L1dJmDv8FJP2Vc5NIOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e8PlVbubHiG+QFtCZyp64zWmL2Ua2SC3LxUUWKvW5WAfUOZnMzhii8khk0QF1BLQA
         45/JN66OcgXhCJAQNkl6xmcTd8eupKcuzAcrnDWkiyVWj2j8OqXr8+dzDgmeSf/H3b
         XuyIEWCRqz1LE/kfF934bL0vyj1yM7XLOfl+Gejz4YgClTJJC0q5MOMa06/noV2XS3
         UoKM7fpBFWc0Xo0Y7n6AT8VqPBX3D5zfCq5jFSbWSgd7KHwcIu7yPW8AuOi3pGyiSV
         S6W9Ogym/a9SlPkHdClqBW/9SzXsXzydHiLiB56weeE2ff+TOPjFM2bYj2V+FwE90Z
         yWpewhNhkCrnQ==
Date:   Sat, 25 Feb 2023 15:43:30 -0800
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
Message-ID: <20230225234330.caznxpkjhq3u5tls@treble>
References: <20230224185257.o3mcmloei5zqu7wa@treble>
 <Y/knUC0s+rg6ef2r@zn.tnic>
 <Y/k/ZXUXOFiBhOiI@zn.tnic>
 <20230225000931.wrednfun4jifkqau@treble>
 <Y/lUSC5x2ZkTIGu4@zn.tnic>
 <20230225005221.425yahqvxb57c43x@desk>
 <20230225013202.g7tibykvylprsxs5@treble>
 <Y/n9XcbnCzWv2Vul@zn.tnic>
 <20230225172832.sqdd7dejkkmjxpt6@treble>
 <Y/qSJd1Z3ABEJPPD@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y/qSJd1Z3ABEJPPD@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 25, 2023 at 11:56:37PM +0100, Borislav Petkov wrote:
> On Sat, Feb 25, 2023 at 09:28:32AM -0800, Josh Poimboeuf wrote:
> > All the other "bug" code in identify_secondary_cpu() *is*
> > vendor-specific.
> 
> I meant "vendor-specific" in the sense that AMD code goes to amd.c, etc.

Hm?  So code in bugs.c is not vendor-specific?  That seems circular and
I don't get your point.

> As to the identify_secondary_cpu()  code - I didn't like it being
> slapped there either but it got stuck in there hastily during the
> mitigations upstreaming as back then we had bigger fish to fry than
> paying too much attention to clean design...

Right, so rather than spreading all the bug-related MSR logic around,
just do it in one spot.

-- 
Josh
