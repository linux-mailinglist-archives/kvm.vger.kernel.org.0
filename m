Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C54718FBA
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 02:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbjFAAyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 20:54:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjFAAx7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 20:53:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D847119;
        Wed, 31 May 2023 17:53:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBC1164039;
        Thu,  1 Jun 2023 00:53:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE29AC433EF;
        Thu,  1 Jun 2023 00:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685580837;
        bh=E/32EdT0xaXTvoWC7qY0GPkTyfJL6jW6X1mEbBp7Z5M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P9DpyfZTY9hnnQzhb7Fqyh7liNmX7Btn/FrjuYGL0rhccuWFETqq2CP9nuyaM9xr4
         c8e0TVQbUt+WNSEOJTJkAeoIoBn5rB0upRB1b7TcTf3Vysg/FYYMYuZUS737kdJkkl
         JdPcUGR/hiybucVmkF8S8wMGF8zd1g5wtbCJtTdevtK0qV7jRq9DJqxjahzdkrpHio
         LO/lPD8NZ4XCmRpWSQou5kZ8umjBu1Olo1N9NvvuNWC/VUHjD1Wj7xSEBEIisBUhKM
         h+NRaKYs/gZGLTGTJ4o4Cv7cqoLAhg0EbOYLuvKQLZVZUBXWUDtrc5F9SbCvQJoTTI
         fefZK8i+3rgnQ==
Date:   Wed, 31 May 2023 17:53:55 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Andrew Cooper <andrew.cooper3@citrix.com>
Cc:     Jon Kohler <jon@nutanix.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Milburn, Alyssa" <alyssa.milburn@intel.com>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Message-ID: <20230601005355.7bvxufmyx27rbvyb@treble>
References: <20230531150112.76156-1-jon@nutanix.com>
 <3b48fae8-1bae-c30a-e6ef-25901314ee39@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b48fae8-1bae-c30a-e6ef-25901314ee39@citrix.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 01:29:12AM +0100, Andrew Cooper wrote:
> On 31/05/2023 4:01 pm, Jon Kohler wrote:
> > Remove barrier_nospec(), which translates to LFENCE, in
> > vmx_spec_ctrl_restore_host() as RSB-barriers (as defined by [1])
> > already exist prior to this point.
> >
> > This LFENCE was added on commit fc02735b14ff ("KVM: VMX: Prevent guest
> > RSB poisoning attacks with eIBRS") in the 5.19 timeframe; however,
> > commit 2b1299322016 ("x86/speculation: Add RSB VM Exit protections") in
> > 6.0 timeframe added a LFENCE for X86_FEATURE_RSB_VMEXIT_LITE was added
> > directly in vmx_vmexit, prior to CALL vmx_spec_ctrl_restore_host.
> >
> > For posterity, vmx_spec_ctrl_restore_host also will execute WRMSR to
> > IA32_SPEC_CTRL for X86_FEATURE_KERNEL_IBRS or when guest/host MSR value
> > does not match, which serves as an additional RSB-barrier.
> >
> > [1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html
> 
> Yeah, unfortunately PBRSB is insidious.
> 
> From memory (please correct me if I'm wrong), the required safety
> property is this:  After a VMExit (if IBRS was set prior to exit) or the
> write to MSR_SPEC_CTRL setting IBRS (if IBRS was not set prior to exit),
> one single CALL instruction must architecturally retire before any RET
> instructions execute (speculatively).
> 
> There are several ways to arrange this, but they all basically boil down
> to having some serialising instruction between the first CALL and first
> RET on any reachable path from VMExit.

The document says the problem is *unbalanced* RET, i.e. RSB underflow.

So the mitigation needs a single RSB stuff (i.e., unbalanced CALL) and
then an LFENCE anytime before the next unbalanced RET.

-- 
Josh
