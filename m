Return-Path: <kvm+bounces-49686-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A3C09ADC5A4
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 11:03:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2AE0D1896712
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:04:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDA1C28FA8D;
	Tue, 17 Jun 2025 09:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FokIEwN1"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5030F28C873;
	Tue, 17 Jun 2025 09:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750151022; cv=none; b=t79OIS9ihkbnPG5zgDYc2ylj6VdHb9is+DphDHBKWP8F5pRGOnmeJvQDQGguaMmU5ZP/Y3qPDhTAJbsZBk1YWd2motS7x7kDR/WiuTOe6hJE4dcCwpaqFO2AHRCgGNNDQIm8uoIFQdI2gbYM04AbYwVaWKQiSAUq6maHqno6Rrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750151022; c=relaxed/simple;
	bh=0jXIXmWCiLrPFyDn+WH7Az5AxH7uOGz0L78bXYR4JJI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OzYijdMvAGeRuDrtUmBrFv4r3gU1JvE8ELxa18W+v6pch1hdodhY6D/M0b/QUU04A+l04WJVQigHUXtuOZk86vQDlhbk8nEsh/rbZSw/51u+S+sVvDzwltKf9GXYwnDBRYdF8VMf9Uj4/FcFw+i5S3R80wRlgcgwWFfG2K+cK/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FokIEwN1; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=O1aQjgQO8XR30rV5R8gCxQHfePvnGGG/SprTQSTa2jQ=; b=FokIEwN1p2FvqL66tn8K60SPz5
	UxyId9D5qadVtujZCBWpP+KG+S8Maktqmk6GE1Z4HyidDnL0PwQgUMbpjFVyLIkVaWErihzIuDYWU
	eNJ1PM3tJH7vrCzr3Q4XEuZXRITaqd1HIX5QS1O24phxhJe30qGcEJIQmdhQ3pAZwzn/uhkHROKtH
	GD3lD2oxvkwfVPbFwPlq6fLPDL1ONmSATfrEKCdlL+3o094P/igJY1JnYm6Jdh8R6S5hiaOvnyQyq
	6l+ImSPR79wi0VB7IGHHcMNl5dO0yfrXexEWQNJqeeVU/5pV2WmIcBmYyNSEustE4pKn215vVQRhS
	ihWPZ+pg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uRSE6-0000000GvSG-1dCk;
	Tue, 17 Jun 2025 09:03:30 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 83070308523; Tue, 17 Jun 2025 11:03:29 +0200 (CEST)
Date: Tue, 17 Jun 2025 11:03:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, sohil.mehta@intel.com, brgerst@gmail.com,
	tony.luck@intel.com, fenghuay@nvidia.com
Subject: Re: [PATCH v2 1/2] x86/traps: Initialize DR6 by writing its
 architectural reset value
Message-ID: <20250617090329.GO1613376@noisy.programming.kicks-ass.net>
References: <20250617073234.1020644-1-xin@zytor.com>
 <20250617073234.1020644-2-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617073234.1020644-2-xin@zytor.com>

On Tue, Jun 17, 2025 at 12:32:33AM -0700, Xin Li (Intel) wrote:
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 8feb8fd2957a..3bd7c9ac7576 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -2243,20 +2243,17 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard);
>  #endif
>  #endif
>  
> -/*
> - * Clear all 6 debug registers:
> - */
> -static void clear_all_debug_regs(void)
> +static void initialize_debug_regs(void)
>  {
>  	int i;
>  
> -	for (i = 0; i < 8; i++) {
> -		/* Ignore db4, db5 */
> -		if ((i == 4) || (i == 5))
> -			continue;
> +	/* Control register first */
> +	set_debugreg(0, 7);
> +	set_debugreg(DR6_RESERVED, 6);
>  
> +	/* Ignore db4, db5 */
> +	for (i = 0; i < 4; i++)
>  		set_debugreg(0, i);
> -	}
>  }
>  
>  #ifdef CONFIG_KGDB

Maybe like so?

--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2206,15 +2206,14 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard)
 
 static void initialize_debug_regs(void)
 {
-	int i;
-
-	/* Control register first */
+	/* Control register first -- to make sure everything is disabled. */
 	set_debugreg(0, 7);
 	set_debugreg(DR6_RESERVED, 6);
-
-	/* Ignore db4, db5 */
-	for (i = 0; i < 4; i++)
-		set_debugreg(0, i);
+	/* dr5 and dr4 don't exist */
+	set_debugreg(0, 3);
+	set_debugreg(0, 2);
+	set_debugreg(0, 1);
+	set_debugreg(0, 0);
 }
 
 #ifdef CONFIG_KGDB

