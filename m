Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C905B7D3F12
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbjJWSWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjJWSWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:22:16 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828BC8E;
        Mon, 23 Oct 2023 11:22:14 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56641C433C9;
        Mon, 23 Oct 2023 18:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698085334;
        bh=DuXRKNTPP+oxmrxXIzF8KREEatSCS8sUp02WksFrGHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=joEFNxBAGlFzt7+m9GSg8uOSLPPf/HstBuyv+wpoc82ZVPcmKOjVpkea0MN1e7CGo
         YdTtmzBOmG3lDwrNZmnbbPlA3I02u+TjXLBwapbyYIZEjmMVMG9nwbiZ9ELOCmdbK9
         GF9xiST4DIUhMBxcqsMz0ZuG8QqGN/XEgxtVTsG0T1RwCW39WA18gDk1JDRJ4mBOXn
         HB+IxTp3mXU0z23EWRuDI8oGeSslGA3l2xK/djKgYdyhF9RjdLaOstpDl1FsXijOV4
         dAgXubZrFZIt3WIAcX6IvJuxfbKVF2TuFjY/GEtzD3l1E4adXKnuIiDO3+D4VZJPAb
         5fahPDLQmdc3Q==
Date:   Mon, 23 Oct 2023 11:22:11 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, tony.luck@intel.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org,
        Alyssa Milburn <alyssa.milburn@linux.intel.com>,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH  2/6] x86/entry_64: Add VERW just before userspace
 transition
Message-ID: <20231023182211.5ojm2rsoqqqwqg46@treble>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-2-cff54096326d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231020-delay-verw-v1-2-cff54096326d@linux.intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 20, 2023 at 01:45:03PM -0700, Pawan Gupta wrote:
> +	/* Mitigate CPU data sampling attacks .e.g. MDS */
> +	USER_CLEAR_CPU_BUFFERS
> +
>  	jmp	.Lnative_iret
>  
>  
> @@ -774,6 +780,9 @@ native_irq_return_ldt:
>  	 */
>  	popq	%rax				/* Restore user RAX */
>  
> +	/* Mitigate CPU data sampling attacks .e.g. MDS */
> +	USER_CLEAR_CPU_BUFFERS
> +

I'm thinking the comments add unnecessary noise here.  The macro name is
self-documenting enough.

The detail about what mitigations are being done can go above the macro
definition itself, which the reader can refer to if they want more
detail about what the macro is doing and why.

Speaking of the macro name, I think just "CLEAR_CPU_BUFFERS" is
sufficient.  The "USER_" prefix makes it harder to read IMO.

-- 
Josh
