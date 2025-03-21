Return-Path: <kvm+bounces-41655-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 177DEA6BB74
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 14:10:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C123B17EB2A
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 13:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D065C22A4EA;
	Fri, 21 Mar 2025 13:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="i8/tly78";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="K6/xz13I"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983FF1F8F09;
	Fri, 21 Mar 2025 13:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742562542; cv=none; b=eqyqpR/+JDPESpi9Tuf2Ht/U1fCCRZPH/yhId+wMZJsE8lLHInCJhALQvjy+6r4gx6o/Mgh6uONugArwpWmTWhRKQ22pfowIP7Zdx6Sz4X1eAuefEwPJUja8m+CwFVQk3+mnrfi7Wl8oB7Umxpr3R1bRKWcL+4UFGyVAOAZmq5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742562542; c=relaxed/simple;
	bh=bVNrsbIps8fcC55Z7FeqWXH2YS8wvD+DrABs9rY0NEM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=AWJyYW7nXIMgDqay2k5R1C2gqletrCvaawKZa4Oytf9FWTeu9VzCr6Eu3M/9OLyb3Re1UEGxJNIW2pkAJBgARqqJQKh0QEDtqSR5zN9dIAV6vciezakh/+N0AZnrG1AKAYRTA1qNIJn/SQiJLh37cF8Z/oSy2Ca1OjuEJO3UJR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=i8/tly78; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=K6/xz13I; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1742562538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GrWALkMKbJJftvEM13t9CRU0c4xaXKYwA1n0nbUKheI=;
	b=i8/tly78QkZ1Bs6FAlV430b9z8Y99jYga75slZz+b9LwSaHSzUSWciJJVu1lINvzkVGxGv
	1cSeWKj6HRCghq+gMdoJkwQBZwjKctMOxMrgPuFqvRlwtiG5EI8yOZqlkaaDcsbBhuTf2w
	ubOM4ahPwn/Yj9JNTvyEVRcThW9gcJk8/fL8+la20Ac6fLH6u8eqaNGHiwqppGE/p6HODm
	i8RH0WOz7vKodlmATErj/ZdVr6mcdQ/YXFjtG8xsCtTYv5935JASVXgqkCugwv8e90Vmm1
	g0oVz6rpQCwGIg/Te1SlH3RwNZRO36hRE22a28Ac9WadA9hKOlHgNO+qKmnCZA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1742562538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GrWALkMKbJJftvEM13t9CRU0c4xaXKYwA1n0nbUKheI=;
	b=K6/xz13IUjnwqUvvuCIfCwH9k+YDtSvQigspN7yEDQL/835B0cZ+eaZUudusT26Fj9XtUU
	AGf/wpDuNOgEnQAg==
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>, linux-kernel@vger.kernel.org
Cc: bp@alien8.de, mingo@redhat.com, dave.hansen@linux.intel.com,
 Thomas.Lendacky@amd.com, nikunj@amd.com, Santosh.Shukla@amd.com,
 Vasant.Hegde@amd.com, Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com,
 x86@kernel.org, hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
 pbonzini@redhat.com, kvm@vger.kernel.org, kirill.shutemov@linux.intel.com,
 huibo.wang@amd.com, naveen.rao@amd.com
Subject: Re: [RFC v2 02/17] x86/apic: Initialize Secure AVIC APIC backing page
In-Reply-To: <20250226090525.231882-3-Neeraj.Upadhyay@amd.com>
References: <20250226090525.231882-1-Neeraj.Upadhyay@amd.com>
 <20250226090525.231882-3-Neeraj.Upadhyay@amd.com>
Date: Fri, 21 Mar 2025 14:08:58 +0100
Message-ID: <87sen63505.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Feb 26 2025 at 14:35, Neeraj Upadhyay wrote:
> @@ -1504,6 +1504,8 @@ static void setup_local_APIC(void)
>  		return;
>  	}
>  
> +	if (apic->setup)
> +		apic->setup();

That's broken for AP bringup. This is invoked from ap_starting()
_before_ anything of the CPU is populated. You _CANNOT_ 

> +static void x2apic_savic_setup(void)
> +{
> +	void *backing_page;
> +	enum es_result ret;
> +	unsigned long gpa;
> +
> +	if (this_cpu_read(apic_backing_page))
> +		return;
> +
> +	backing_page = kzalloc(PAGE_SIZE, GFP_KERNEL);

allocate memory at that point. This was clearly never tested with any
debugging enabled. And no GFP_ATOMIC is not the right thing either.

This allocation has to happen on the control CPU before the AP is kicked
into life.

But the right thing to do is:

struct apic_page __percpu *backing_page __ro_after_init;

and do once on the boot CPU:

    backing_page = alloc_percpu(struct apic_page);

I talk more about that struct apic_page in the context of a subsequent
patch.

Thanks,

        tglx

