Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DD37D3F51
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjJWSf1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:35:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjJWSf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:35:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 689E8B7;
        Mon, 23 Oct 2023 11:35:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465DCC433C7;
        Mon, 23 Oct 2023 18:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698086124;
        bh=ZsGdHEJshdR0ozQSfQrtf6wqTgfeXHC3XAo8ZSd8pBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R4ShAgpxrBRydKmuUVFVNqKZZf2P1pZNI3c3pn71hOqSL3rMDVW4qYqLdeox0rkgY
         EWMFK7pUlfLLfzyOzNY/m9LKCct1tP33FcbmOx3d8WckKt1fTqo1/coGrwZNetYfIM
         D7XIDHR4ByBwehxXpJ7yjsFWpTUgQ7YOyKxKrTQ9XUyzr+zks1VB6cP2XisGX7e2Cq
         wtyN3iJ3u+b7JPef/WPICWcVC5p/7ts0sS9cRTeXod1fItZRVeijhR+QtPHaHcGQNS
         5BNO+lnuP/igOYZjK/2PuobSAs+SO+PpgVsOmoNm3oLlcsF+lnfWeAdDQd2giW7sCT
         UE4WGukub5n2A==
Date:   Mon, 23 Oct 2023 11:35:21 -0700
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
Message-ID: <20231023183521.zdlrfxvsdxftpxly@treble>
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
> @@ -663,6 +665,10 @@ SYM_INNER_LABEL(swapgs_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
>  	/* Restore RDI. */
>  	popq	%rdi
>  	swapgs
> +
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

Can the above two USER_CLEAR_CPU_BUFFERS be replaced with a single one
just above native_irq_return_iret?  Otherwise the native_irq_return_ldt
case ends up getting two VERWs.

>  	/*
>  	 * RSP now points to an ordinary IRET frame, except that the page
>  	 * is read-only and RSP[31:16] are preloaded with the userspace
> @@ -1502,6 +1511,9 @@ nmi_restore:
>  	std
>  	movq	$0, 5*8(%rsp)		/* clear "NMI executing" */
>  
> +	/* Mitigate CPU data sampling attacks .e.g. MDS */
> +	USER_CLEAR_CPU_BUFFERS
> +
>  	/*
>  	 * iretq reads the "iret" frame and exits the NMI stack in a
>  	 * single instruction.  We are returning to kernel mode, so this

This isn't needed here.  This is the NMI return-to-kernel path.

The NMI return-to-user path is already mitigated as it goes through
swapgs_restore_regs_and_return_to_usermode.

-- 
Josh
