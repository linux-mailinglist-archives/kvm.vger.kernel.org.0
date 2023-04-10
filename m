Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2EB96DC954
	for <lists+kvm@lfdr.de>; Mon, 10 Apr 2023 18:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjDJQcV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Apr 2023 12:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjDJQcS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Apr 2023 12:32:18 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E073810CF
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 09:32:17 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id kw5-20020a170902f90500b001a238a5946cso1845833plb.11
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 09:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681144337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=itQxv8BbM1PWm+RuQQ5FyL8tOIW1b7TZUP7dqH3kNac=;
        b=I2sqdKuXsSOipEE4wkgH+zftrLP+ZQEvlfLiYQheAInvKEPAZuSnR3aFGMtEkqbAFR
         SyTQDDUy726SsM1SPNsqKBd5DzBF+916FXKHv5mv2odD7ZSoowegDCzdulFXqhi5bwKs
         0RO4A4u5NtsettVc7ORpAWmDOX2qoSbQfU+opLhH6bzUY5O5aHDjyJwinC8E6LxUo64O
         Xoe//XAX5WmJ3OIV4r6zkDrxkmW/WvGB5Y17zVrOwXrTEFNzp0JMRCwlE39ZCcFTfITD
         k94FBlTq7vw96Erc4nfik2gQfamsjjgLQyOplvHuAxVx/7xO6C8cRWmO2tQP/Iv4yWGs
         Itpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681144337;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=itQxv8BbM1PWm+RuQQ5FyL8tOIW1b7TZUP7dqH3kNac=;
        b=T+q0fHLKDx1BMdQb7cZZWpfzGtPh1Djkh+50GSN8F6ruJGDZN6IZMU7ZAWLn7iCY+R
         6KhGLx/NAa4HUgi+BNstImHjgAdBW1Rlw3plPrM9qnZNROWunv+tPmis7TeCIp8AGJXG
         l19QJ8LUJ5oAGwDcIOCRF5C/8WgBVjFPHR4WsDiH8oiWetfqgOXgATO8YaYjgolW9rXv
         i0ce2NaUvYjjqHIaeb2R7b0lJDQIyyWJ93BF2wJiGMwcMqPCqI4D3M0oBoQGUpobIlpc
         QKIVOxGhYIXjAA6sS9KkRK3vcBdAF73UDRgVzFBg6b/LCKwK1dkQS+IZgmj9kUCOB4Vt
         H8WQ==
X-Gm-Message-State: AAQBX9edcthqVkR8sH2Sfk2DPLTWDmCNW+kqXC73e+O+nKCjV1S0J5YU
        23dS46oCKRip4BYx3nSmVROnInkSodg=
X-Google-Smtp-Source: AKy350bYR39SqtSRv+Q85bHi/2KjFrjWdeKh6KU41dxqae4MwZtBP8V6ChtQJu17TSE+4pp4qQkXCguhBrg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:641a:0:b0:51b:fa5:7bce with SMTP id
 a26-20020a65641a000000b0051b0fa57bcemr444164pgv.1.1681144337139; Mon, 10 Apr
 2023 09:32:17 -0700 (PDT)
Date:   Mon, 10 Apr 2023 09:32:15 -0700
In-Reply-To: <20230410031021.4145297-1-alexjlzheng@tencent.com>
Mime-Version: 1.0
References: <20230410031021.4145297-1-alexjlzheng@tencent.com>
Message-ID: <ZDQ6D6BX/3mqhCbW@google.com>
Subject: Re: [PATCH kvm RESEND] KVM: i8259: Fix poll command
From:   Sean Christopherson <seanjc@google.com>
To:     alexjlzheng@gmail.com
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jinliang Zheng <alexjlzheng@tencent.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please don't use RESEND as a ping, just respond to the original patch with a "Ping",
or any question you might have.  I know Documentation/process/submitting-patches.rst
says its ok to RESEND after a couple of weeks, but IMO that's overly aggressive
and just creates noise, e.g. your original patch was in my todo list, I just hadn't
gotten too it.  If you can't get a response after multiple pings, then by all means
RESEND, but in the future, please try pinging first.

For the patch context, there's no need to put "kvm" after patch, i.e. [PATCH], or
in this case [PATCH RESEND].  The "KVM:" namespace in the shortlog provides
sufficient context.

Regarding the shortlog, if a v2 is needed, ignore the somewhat messy history of
this file and use "KVM: x86:".

On Mon, Apr 10, 2023, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> According to the hardware manual, when the Poll command is issued, the
> byte returned by the I/O read is 1 in Bit 7 when there is an interrupt,
> and the highest priority binary code in Bits 2:0. The current pic
> simulation code is not implemented strictly according to the above
> expression.

There is way too much going on in this patch for this to be a sufficient description.
pic_intack() is not a direct replacement for the open coded logic in pic_poll_read(),
modulo the setting of bit 7.  E.g. there's no explanation for the "addr1 >> 7"
logic, pic_clear_isr() is conditionally called on auto_eoi, priority_add is now
modified, pic_update_irq() is no longer called, and so on and so forth.

Maybe the patch is correct and pic_poll_read() was completely broken, but if that's
the case, the changelog needs to be _much_ more verbose in explaining everything.

> Fix the implementation of poll mode in pic simulation by pic_intack,

Add () when referencing functions by name, i.e. pic_intack().

> and remove redundant pic_poll_read code.

Removing pic_poll() needs to be done in a separate patch.  Removing the helper
while simultaneously modifying its effective code makes the patch unnecessarily
difficult to review.

> Signed-off-by: Jinliang Zheng <alexjlzheng@tencent.com>
> ---
>  arch/x86/kvm/i8259.c | 29 ++++++-----------------------
>  1 file changed, 6 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index 4756bcb5724f..bc5b758e8f73 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -397,35 +397,18 @@ static void pic_ioport_write(void *opaque, u32 addr, u32 val)
>  		}
>  }
>  
> -static u32 pic_poll_read(struct kvm_kpic_state *s, u32 addr1)
> -{
> -	int ret;
> -
> -	ret = pic_get_irq(s);
> -	if (ret >= 0) {
> -		if (addr1 >> 7) {
> -			s->pics_state->pics[0].isr &= ~(1 << 2);
> -			s->pics_state->pics[0].irr &= ~(1 << 2);
> -		}
> -		s->irr &= ~(1 << ret);
> -		pic_clear_isr(s, ret);
> -		if (addr1 >> 7 || ret != 2)
> -			pic_update_irq(s->pics_state);
> -	} else {
> -		ret = 0x07;
> -		pic_update_irq(s->pics_state);
> -	}
> -
> -	return ret;
> -}
> -
>  static u32 pic_ioport_read(void *opaque, u32 addr)
>  {
>  	struct kvm_kpic_state *s = opaque;
>  	int ret;
>  
>  	if (s->poll) {
> -		ret = pic_poll_read(s, addr);
> +		ret = pic_get_irq(s);
> +		if (ret >= 0) {
> +			pic_intack(s, ret);
> +			ret |= 0x80;
> +		} else

All branches in an if-elif-else statment need curly braces if any branch needs
statements (again, ignore the bad "prior art" in this file), i.e.

		if (ret >= 0) {
			...
		} else {
			ret = 0;
		}

> +			ret = 0;
>  		s->poll = 0;
>  	} else
>  		if ((addr & 1) == 0)
> -- 
> 2.37.3
> 
