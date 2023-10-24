Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338487D4E0A
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 12:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbjJXKhE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 06:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbjJXKhD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 06:37:03 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03283E5;
        Tue, 24 Oct 2023 03:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KYIweJyPgr9jAYgFFkbgWAnl0FwkE/8DRBNzonPBpYs=; b=EvGpMu9X6nvshe85ULHBCy5v/f
        C9JgwzXXscrhZXKuDcpU31k+pwk8Xm15cBQsSR9Q6fjRNN2uOWnCjDya2gRvha5K5qoSZUq6iafSb
        wkyDZ8aM2xJCPR/UqcplUsQuezVo+KNxc0LYsjSiLU2reYFfzjkTDUbutGKaqrg85T7w85/nrVInl
        UKuPLvzxP6YocbkDMLeWXfpylzjGF1/rNATP/3fk3gFOA2FwvtkXo7ZXnXOgbwETduTvsFqRk8RaL
        ObomnPC3uKC/KSGTznkeClCRgJ/qVDVyJe3bLutna/bZDDns3H3f3pVakwlHIGzK9df1n6wAnYNQa
        Tlj/SGng==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qvElX-00FR15-11;
        Tue, 24 Oct 2023 10:36:03 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id D6FCA300392; Tue, 24 Oct 2023 12:36:01 +0200 (CEST)
Date:   Tue, 24 Oct 2023 12:36:01 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
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
        Alyssa Milburn <alyssa.milburn@intel.com>
Subject: Re: [PATCH  v2 1/6] x86/bugs: Add asm helpers for executing VERW
Message-ID: <20231024103601.GH31411@noisy.programming.kicks-ass.net>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 01:08:21AM -0700, Pawan Gupta wrote:

> +.macro CLEAR_CPU_BUFFERS
> +	ALTERNATIVE "jmp .Lskip_verw_\@;", "jmp .Ldo_verw_\@", X86_FEATURE_CLEAR_CPU_BUF
> +		/* nopl __KERNEL_DS(%rax) */
> +		.byte 0x0f, 0x1f, 0x80, 0x00, 0x00;
> +.Lverw_arg_\@:	.word __KERNEL_DS;
> +.Ldo_verw_\@:	verw _ASM_RIP(.Lverw_arg_\@);
> +.Lskip_verw_\@:
> +.endm

Why can't this be:

	ALTERNATIVE "". "verw _ASM_RIP(mds_verw_sel)", X86_FEATURE_CLEAR_CPU_BUF

And have that mds_verw_sel thing be out-of-line ? That gives much better
code for the case where we don't need this.
