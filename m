Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C89507D61ED
	for <lists+kvm@lfdr.de>; Wed, 25 Oct 2023 08:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbjJYG4v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Oct 2023 02:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjJYG4t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Oct 2023 02:56:49 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59598A6;
        Tue, 24 Oct 2023 23:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XACVKlQsgeevIRCx4krJ3Cs67Y3XIWvenl6gIVkrFAA=; b=Dl0ig3Z3i4kQ3aDi44pJMQ9FKl
        PCrkZd6wuLQSa17a34c/FzdT9XHqUgCSzaRtk1bGKuEh133gYfFWBeDy6miBnVRoYyrFxWa1Lb3MI
        rFl+zBLgTpfKfxxxs9I2N+GR0ZQ/aw7viJvLa5iE3nCLwJjGHr3GGs7gxIOJZgFxAft++PHPIMv+k
        OlUtvvyu97Ok3V8htIMXtHLoCc65AR/jcJqhRlov7BDaMLZZuRxKsfxpjIqCdCXE9eyiq5IBst6Lj
        pyhehYOt7PZxYk2sA6RLJ51O/ooeChtfDvo1XSERaiSbaqwJehBYCxczRr/O1ru2tzJYUbyI3ip87
        omGYtmwQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qvXoJ-007H0F-3E; Wed, 25 Oct 2023 06:56:11 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
        id 601FA30047C; Wed, 25 Oct 2023 08:56:10 +0200 (CEST)
Date:   Wed, 25 Oct 2023 08:56:10 +0200
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
Message-ID: <20231025065610.GA31201@noisy.programming.kicks-ass.net>
References: <20231024-delay-verw-v2-0-f1881340c807@linux.intel.com>
 <20231024-delay-verw-v2-1-f1881340c807@linux.intel.com>
 <20231024103601.GH31411@noisy.programming.kicks-ass.net>
 <20231025040029.uglv4dwmlnfhcjde@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025040029.uglv4dwmlnfhcjde@desk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 24, 2023 at 09:00:29PM -0700, Pawan Gupta wrote:

> config1: mitigations=on, 32-bit mode, post-boot
> 
> entry_SYSENTER_32:
>    ...
>    0xc1a3748e <+222>:   pop    %eax
>    0xc1a3748f <+223>:   verw   0xc1a38240
>    0xc1a37496 <+230>:   sti
>    0xc1a37497 <+231>:   sysexit
> 
> ---------------------------------------------
> 
> config2: mitigations=off, 32-bit mode, post-boot
> 
> entry_SYSENTER_32:
>    ...
>    0xc1a3748e <+222>:   pop    %eax
>    0xc1a3748f <+223>:   lea    0x0(%esi,%eiz,1),%esi   <---- Doesn't look right
>    0xc1a37496 <+230>:   sti
>    0xc1a37497 <+231>:   sysexit
> 
> ---------------------------------------------
> 
> config3: 32-bit mode, pre-boot objdump
> 
> entry_SYSENTER_32:
>    ...
>    c8e:       58                      pop    %eax
>    c8f:       90                      nop
>    c90:       90                      nop
>    c91:       90                      nop
>    c92:       90                      nop
>    c93:       90                      nop
>    c94:       90                      nop
>    c95:       90                      nop
>    c96:       fb                      sti
>    c97:       0f 35                   sysexit
> 

If you look at arch/x86/include/asm/nops.h, you'll find (for 32bit):

 * 7: leal 0x0(%esi,%eiz,1),%esi

Which reads as:

	load-effective-address of %esi[0] into %esi

which is, of course, just %esi.

You can also get this from GAS using:

	.nops 7

which results in:

   0:   8d b4 26 00 00 00 00    lea    0x0(%esi,%eiz,1),%esi

It is basically abusing bizarro x86 instruction encoding rules to create
a 7 byte nop without using NOPL. If you really want to know, volume 2
of the SDM has a ton of stuff on instruction encoding, also the interweb
:-)
