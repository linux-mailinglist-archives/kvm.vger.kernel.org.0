Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B1C718F02
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 01:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbjEaXS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 19:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbjEaXSZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 19:18:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A87C98;
        Wed, 31 May 2023 16:18:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D26AB63FF2;
        Wed, 31 May 2023 23:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94305C433D2;
        Wed, 31 May 2023 23:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685575103;
        bh=kTjW0S3jU9gKgIyH/dX5OVo1fp8tM6EMcyDIvWxjZU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qlosJiHLhYVPXEBCaAIc1b6aPea1z+R0xWLMOD6/o4YNGFOlVn0xRxzFRWH9zS63e
         UmxkDAwS4+mJHe3vWGSHord887uaMQNfZ7oW/6+d1vacdBzg/ceX4OZFBRSFPgmXq1
         mY73atm6g8pjHwJvYk4I/4h7q8IEvObCq4hDyWW+gztl32dYxcBSX/rQPQefzwtiqJ
         aTCGBho2jcmKBBsuy1opjFyZbzrmxEX2QUTT/765MRa7fHRHpYLTOPlFSj/YDpqbBn
         S4KMFqlry5I8aC5evOJa8GaRVnHY10hd6apuUIuR/3H3CnLj/hh3h3ZyCmnz5hOKS6
         RZvC5fqU2Z1zw==
Date:   Wed, 31 May 2023 16:18:20 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [PATCH] KVM: VMX: remove LFENCE in vmx_spec_ctrl_restore_host()
Message-ID: <20230531231820.trrs2uugc24gegj4@treble>
References: <20230531150112.76156-1-jon@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230531150112.76156-1-jon@nutanix.com>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 11:01:12AM -0400, Jon Kohler wrote:
> Remove barrier_nospec(), which translates to LFENCE, in
> vmx_spec_ctrl_restore_host() as RSB-barriers (as defined by [1])
> already exist prior to this point.
> 
> This LFENCE was added on commit fc02735b14ff ("KVM: VMX: Prevent guest
> RSB poisoning attacks with eIBRS") in the 5.19 timeframe; however,
> commit 2b1299322016 ("x86/speculation: Add RSB VM Exit protections") in
> 6.0 timeframe added a LFENCE for X86_FEATURE_RSB_VMEXIT_LITE was added
> directly in vmx_vmexit, prior to CALL vmx_spec_ctrl_restore_host.
> 
> For posterity, vmx_spec_ctrl_restore_host also will execute WRMSR to
> IA32_SPEC_CTRL for X86_FEATURE_KERNEL_IBRS or when guest/host MSR value
> does not match, which serves as an additional RSB-barrier.
> 
> [1] https://www.intel.com/content/www/us/en/developer/articles/technical/software-security-guidance/advisory-guidance/post-barrier-return-stack-buffer-predictions.html
> 
> Fixes: fc02735b14ff ("KVM: VMX: Prevent guest RSB poisoning attacks with eIBRS")
> Fixes: 2b1299322016 ("x86/speculation: Add RSB VM Exit protections")

Sorry, I knew I should have put a comment there.

The goal of this barrier_nospec() is to prevent speculative execution
from bypassing the SPEC_CTRL write (due to misprediction of the
conditional branch, Spectre v1 style).  Otherwise the next indirect
branch or unbalanced RET could be an attack target.

So any previous LFENCEs before that conditional branch won't help here.

-- 
Josh
