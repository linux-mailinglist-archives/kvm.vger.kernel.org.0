Return-Path: <kvm+bounces-49392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D430AD83FA
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 09:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7769F189AB52
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 07:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBCED2C3271;
	Fri, 13 Jun 2025 07:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MlqHmZpo"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E552C3253;
	Fri, 13 Jun 2025 07:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749799256; cv=none; b=ADunU6U2SZZdov7HKL/e0uG+xAryw773HHoZ1uH7JICqQ37vz79cJQv8MRx6EvdjyDF4zrwgxZ1jcal5R6bJtdxXSlBxZ7slWqPjrm5JJhe03JOwpLaKks/0oAznkNKuolKRBwKKjkSdsqU6FuGKTF0u5Lw5qGfi/bDjJeEggM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749799256; c=relaxed/simple;
	bh=7oG7PdaLuoIzjD9feldhuWnbLoPMo98j5mUEc/aR7hQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H20nOZ3NFIbkPUdlZe5l3kjbIwr44gH6LknIMTZO1aDbHopv1DYqYhO7NtoBwHIl0jZ5WebvM/XxmPjJDt+WI8mIquxrhsknmLpWCNUHFjkTl/hcjxrY/SDZmau4v5fbv49FbK0jE3FIICnJ42uh2/3tjrb9bayKuOHdcLBpS68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MlqHmZpo; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JwBBviHmEevVyR2yj/WBOAB/USjZOit0uE7ec1Txdc0=; b=MlqHmZpomiTv3FPCm1DCY51m56
	OYYRsGs7+U885FPv6c1qKomXmBCLuMhytGmdKXeuFS7WLrUdZPZ26v21Sp7IOeRkUg7qyafptJutm
	MOvGEK21SHP7yYXfZMYIL+sBZY/snLgixEuyg1Hn7yGoGHycKPj8Oh1ZNvTrV0yrgwbmEtEte2ywI
	WrmqiLE551VDECZmGdVUH97hbrk8qoEBOz3OXCY1wbTfUJ14qWitpF/+5bvwsnN3qdN/oXy4t7VYw
	jY7A9VfnlHvn/bs9/MRKaDRyRVD5dhxZIVtiMdbCdxFOWpmXr1arhP2Ts/AAfiEIgULpel3VcDXTc
	VtC8Dstw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uPydV-0000000CgPh-27uq;
	Fri, 13 Jun 2025 07:15:37 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2857030BC59; Fri, 13 Jun 2025 09:15:36 +0200 (CEST)
Date: Fri, 13 Jun 2025 09:15:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, seanjc@google.com,
	pbonzini@redhat.com, brgerst@gmail.com, tony.luck@intel.com,
	fenghuay@nvidia.com
Subject: Re: [PATCH v1 2/3] x86/traps: Initialize DR7 by writing its
 architectural reset value
Message-ID: <20250613071536.GG2273038@noisy.programming.kicks-ass.net>
References: <20250613070118.3694407-1-xin@zytor.com>
 <20250613070118.3694407-3-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613070118.3694407-3-xin@zytor.com>

On Fri, Jun 13, 2025 at 12:01:16AM -0700, Xin Li (Intel) wrote:

> While at it, replace the hardcoded debug register number 7 with the
> existing DR_CONTROL macro for clarity.

Yeah, not really a fan of that... IMO that obfuscates the code more than
it helps, consider:

> -	get_debugreg(dr7, 7);
> +	get_debugreg(dr7, DR_CONTROL);

and:

> -	for (i = 0; i < 8; i++) {
> -		/* Ignore db4, db5 */
> -		if ((i == 4) || (i == 5))
> -			continue;
> +	/* Control register first */
> +	set_debugreg(DR7_RESET_VALUE, DR_CONTROL);
> +	set_debugreg(0, DR_STATUS);
>  
> +	/* Ignore db4, db5 */
> +	for (i = DR_FIRSTADDR; i <= DR_LASTADDR; i++)

I had to git-grep DR_{FIRST,LAST}ADDR to double check this was correct :(

Also, you now write them in the order:

  dr7, dr6, /* dr4, dr5 */, dr0, dr1, dr2, dr3

My OCD disagrees with this :-)

