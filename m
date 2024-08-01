Return-Path: <kvm+bounces-22993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AE1F99453FB
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 23:07:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6435E1F238E2
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 21:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A353E14B08E;
	Thu,  1 Aug 2024 21:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="KjaU6uEL";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="beMWAMMm"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A57B1EB4AF;
	Thu,  1 Aug 2024 21:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722546448; cv=none; b=aFE8z5a6CttSwRN3tb9E3SDZJGlOPHIbEZC8fYZB20P1xbPPWv82r5LGsJTG/t/0SaGa9zxNFn4fcBqH/SKZFgzy1FkSKtaUQOanz9LpxtDFZYOxi42AWF2KNz+7goQH4orppjkIALytk1WWvocJOTH6QrYFWnEygxDCg7xbUYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722546448; c=relaxed/simple;
	bh=7peJ0bUZJ3+nV2B7hTBQnOhl6xnf7+8O/s8I3uHfdGQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BywOdyrVWDAQNi3TUwOG09KAaj4jKLQkEARs1rXey6TlqxvNBUxZ1v+KBALcZpQzrGIrmUxL34tm0zMrpC4ctxuyIDqNLUTT0oRFUDL81ZAuVPWwFP32qMQXEJQ5WOleS14VZnzI0gVOEkIInmeyjz+LZa3lga4eWSosvfPl3gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=KjaU6uEL; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=beMWAMMm; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1722546445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/OKHu+V1pEdMlobRw+Rl8sczFzoGndeed+m0b7YhdQ=;
	b=KjaU6uELM7qhAZKGX5V/tng+77nMgs6FGxVT75zUmKxG2IxCl8Pg2VVaY8uCRAgo2Mk0sC
	gMxXV08Fv7BEORIzexkHPhbZTLa2BQ01MjBvvTtb4PYjItNZFqtdy7IaQDo7x06r3I8Gko
	uyTWZHxrtmqSyI1LcxQv9MU6CPaDkbG9hrDnoxufSSK1gjOVppuhHD+VCbXqB63YkcVBDc
	bumz8aqAEoQ/l4JuQTmQOfijbRMM2FZPmGSz2LRoLT9Qbxe3LSoLOyxKr/XApuBOONH4UX
	pLoE0Kxz10ku4f8cR1R2FmgcQcyG2AcBhMK+qN7pGlMnUW4CwJ9e9Pu0qA0bzA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1722546445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=S/OKHu+V1pEdMlobRw+Rl8sczFzoGndeed+m0b7YhdQ=;
	b=beMWAMMmcyx4lJSVSQD7sAhhY3CrzYDDHDP1s3SN96HRAhujP01vjiHn1SBb3sIYWHSKIn
	6WCl9g+9DeLtY+AQ==
To: David Woodhouse <dwmw2@infradead.org>, mikelley@microsoft.com, kvm
 <kvm@vger.kernel.org>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, decui@microsoft.com,
 haiyangz@microsoft.com, kys@microsoft.com, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, lirongqing@baidu.com, mingo@redhat.com,
 seanjc@google.com, wei.liu@kernel.org, x86@kernel.org
Subject: Re: [PATCH] clockevents/drivers/i8253: Do not zero timer counter in
 shutdown
In-Reply-To: <4bac07dc91de1c45720f36ed6b797d3f215f131a.camel@infradead.org>
References: <8eb7ba99a746110597bbac6f1e027aa63384dfce.camel@infradead.org>
 <4bac07dc91de1c45720f36ed6b797d3f215f131a.camel@infradead.org>
Date: Thu, 01 Aug 2024 23:07:25 +0200
Message-ID: <874j842bqq.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Aug 01 2024 at 16:22, David Woodhouse wrote:
> On Thu, 2024-08-01 at 10:00 +0100, David Woodhouse wrote:
>  bool __init pit_timer_init(void)
>  {
> -	if (!use_pit())
> +	if (!use_pit()) {
> +		if (!hypervisor_is_type(X86_HYPER_NATIVE)) {
> +			/*
> +			 * Don't just ignore the PIT. Ensure it's stopped,
> +			 * because VMMs otherwise steal CPU time just to
> +			 * pointlessly waggle the (masked) IRQ.
> +			 */
> +			raw_spin_lock(&i8253_lock);
> +			outb_p(0x30, PIT_MODE);
> +
> +			/*
> +			 * It's not entirely clear from the datasheet, but some
> +			 * virtual implementations don't stop until the counter
> +			 * is actually written.
> +			 */
> +			if (i8253_clear_counter_on_shutdown) {
> +				outb_p(0, PIT_CH0);
> +				outb_p(0, PIT_CH0);
> +			}
> +			raw_spin_unlock(&i8253_lock);
> +		}
>  		return false;
> +	}

That's just wrong. What we want is to have the underlying problem
fixed in the driver and then make:
  
>  	clockevent_i8253_init(true);

bool clockevent_i8253_init(bool enable, bool oneshot);

so it can invoke the shutdown sequence instead of registering the pile:

   if (!enable) {
      shutdown();
      return false;
   }
   ...
   return true;

and the call site becomes:

    if (!clockevent_i8253_init(use_pit(), true))
    	return false;

No?

Thanks,

        tglx

