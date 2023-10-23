Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 539567D41E1
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 23:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjJWVr6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 17:47:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjJWVr5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 17:47:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56E51BD;
        Mon, 23 Oct 2023 14:47:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B60EC433C7;
        Mon, 23 Oct 2023 21:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698097675;
        bh=XHWV4RVtniMvvQ4FFzRtkV3DH5t8b9UJU2TMo/5xG1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u2LjfzR1DyITElencnYUZBJSxQhSGcdUh8qNi6hiAjhBeQgfLvgVVR3Hfhybeo7cI
         ShVL4HtQVGGNRqD9eOg345hWZQ+ClHFfhz78g6IxdSxJYnQ5IkYJYUixMbHjXfTwww
         zNpIBT2YeHMuQFtheSVnDQdgPsKx16BMIkXLmrWxjRZHKp2Q781G6runNpXpg+64DZ
         WHQ5A2kETEoqfZmB3qZMt5f2memgusVsD8M5Ch7hMJk62ZT5o1RYEYYYgH47OWvpXm
         8w0BrCd51hL7ILMuxLEpaoVw92RLHWNVcBPVxDK9uorbyzfjiU7SMpeZbMVJ2dK+BG
         WT/PepqZYTMeQ==
Date:   Mon, 23 Oct 2023 14:47:52 -0700
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
Message-ID: <20231023214752.2d75h2m64yw6qzcw@treble>
References: <20231020-delay-verw-v1-0-cff54096326d@linux.intel.com>
 <20231020-delay-verw-v1-2-cff54096326d@linux.intel.com>
 <20231023183521.zdlrfxvsdxftpxly@treble>
 <20231023210410.6oj7ekelf5puoud6@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20231023210410.6oj7ekelf5puoud6@desk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 02:04:10PM -0700, Pawan Gupta wrote:
> On Mon, Oct 23, 2023 at 11:35:21AM -0700, Josh Poimboeuf wrote:
> > On Fri, Oct 20, 2023 at 01:45:03PM -0700, Pawan Gupta wrote:
> > > @@ -663,6 +665,10 @@ SYM_INNER_LABEL(swapgs_restore_regs_and_return_to_usermode, SYM_L_GLOBAL)
> > >  	/* Restore RDI. */
> > >  	popq	%rdi
> > >  	swapgs
> > > +
> > > +	/* Mitigate CPU data sampling attacks .e.g. MDS */
> > > +	USER_CLEAR_CPU_BUFFERS
> > > +
> > >  	jmp	.Lnative_iret
> > >  
> > >  
> > > @@ -774,6 +780,9 @@ native_irq_return_ldt:
> > >  	 */
> > >  	popq	%rax				/* Restore user RAX */
> > >  
> > > +	/* Mitigate CPU data sampling attacks .e.g. MDS */
> > > +	USER_CLEAR_CPU_BUFFERS
> > > +
> > 
> > Can the above two USER_CLEAR_CPU_BUFFERS be replaced with a single one
> > just above native_irq_return_iret?  Otherwise the native_irq_return_ldt
> > case ends up getting two VERWs.
> 
> Wouldn't that make interrupts returning to kernel also execute VERWs?
> 
> idtentry_body
>   error_return
>     restore_regs_and_return_to_kernel
>       verw
> 
> native_irq_return_ldt doesn't look to be a common case. Anyways, I will
> see how to remove the extra VERW.

Ah, right.

> > >  	/*
> > >  	 * RSP now points to an ordinary IRET frame, except that the page
> > >  	 * is read-only and RSP[31:16] are preloaded with the userspace
> > > @@ -1502,6 +1511,9 @@ nmi_restore:
> > >  	std
> > >  	movq	$0, 5*8(%rsp)		/* clear "NMI executing" */
> > >  
> > > +	/* Mitigate CPU data sampling attacks .e.g. MDS */
> > > +	USER_CLEAR_CPU_BUFFERS
> > > +
> > >  	/*
> > >  	 * iretq reads the "iret" frame and exits the NMI stack in a
> > >  	 * single instruction.  We are returning to kernel mode, so this
> > 
> > This isn't needed here.  This is the NMI return-to-kernel path.
> 
> Yes, the VERW here can be omitted. But probably need to check if an NMI
> occuring between VERW and ring transition will still execute VERW after
> the NMI.

That window does exist, though I'm not sure it's worth worrying about.

-- 
Josh
