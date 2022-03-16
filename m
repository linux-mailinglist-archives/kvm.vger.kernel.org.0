Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F144DBA78
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 23:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358199AbiCPWDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 18:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236240AbiCPWDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 18:03:32 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4864820F5E;
        Wed, 16 Mar 2022 15:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=GtlS9wUSOZ9cfsjzMLAk/9sxHz72iwQmD4i95Y7gkJQ=; b=OmxwiRiGh7EnEXL97rZBDmAXaK
        At6CvUVW5iPvS71Irp4wkJ8dULsmym7frUR0ocnOiQMsX5Z5XbXJkEs/+ojpCRo7TyzgB87IdwltB
        4GdrkzDbB1wL7EUP8uzuL2r5vn0883tecRfjDRDL3LT1rDAcbZl3AP4oCIO1uM18RDsRp649uYnA+
        b9duNID+1QRN9MY+Vb9aD7i2HfMG3BpEvwMexExCBWeo1CC2ic1Usf83nU7vDql5n9ibjQrLfO79B
        QR7mvzkdAUviuG6B4wP7HshnJN7DzOC1cJydreYb2CD8Lwns9qR8LSrl1oURd1TyulHVoCNg5X0Io
        205ZL/8g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nUbiW-006PXt-BM; Wed, 16 Mar 2022 22:02:04 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id C052F9882B3; Wed, 16 Mar 2022 23:02:01 +0100 (CET)
Date:   Wed, 16 Mar 2022 23:02:01 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Jamie Heilman <jamie@audible.transient.net>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: system locks up with CONFIG_SLS=Y; 5.17.0-rc
Message-ID: <20220316220201.GM8939@worktop.programming.kicks-ass.net>
References: <YjGzJwjrvxg5YZ0Z@audible.transient.net>
 <YjHYh3XRbHwrlLbR@zn.tnic>
 <YjIwRR5UsTd3W4Bj@audible.transient.net>
 <YjI69aUseN/IuzTj@zn.tnic>
 <YjJFb02Fc0jeoIW4@audible.transient.net>
 <YjJVWYzHQDbI6nZM@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjJVWYzHQDbI6nZM@zn.tnic>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 16, 2022 at 10:23:37PM +0100, Borislav Petkov wrote:
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index f667bd8df533..e88ce4171c4a 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -430,8 +430,11 @@ static int fastop(struct x86_emulate_ctxt *ctxt, fastop_t fop);
>  	FOP_END
>  
>  /* Special case for SETcc - 1 instruction per cc */
> +
> +#define SETCC_ALIGN 8

I'd suggest writing that like:

	#define SETCC_ALIGN	(4 * (1 + IS_ENABLED(CONFIG_SLS)))

That way people can enjoy smaller text when they don't do the whole SLS
thing.... Also, it appears to me I added an ENDBR to this in
tip/x86/core, well, that needs fixing too. Tomorrow tho.

> +
>  #define FOP_SETCC(op) \
> -	".align 4 \n\t" \
> +	".align " __stringify(SETCC_ALIGN) " \n\t" \
>  	".type " #op ", @function \n\t" \
>  	#op ": \n\t" \
>  	ASM_ENDBR \
> @@ -1049,7 +1052,7 @@ static int em_bsr_c(struct x86_emulate_ctxt *ctxt)
>  static __always_inline u8 test_cc(unsigned int condition, unsigned long flags)
>  {
>  	u8 rc;
> -	void (*fop)(void) = (void *)em_setcc + 4 * (condition & 0xf);
> +	void (*fop)(void) = (void *)em_setcc + SETCC_ALIGN * (condition & 0xf);
>  
>  	flags = (flags & EFLAGS_MASK) | X86_EFLAGS_IF;
>  	asm("push %[flags]; popf; " CALL_NOSPEC
> -- 
> 2.29.2
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette
