Return-Path: <kvm+bounces-50303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BE16AE3DE0
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 13:27:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2A3A6172246
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 11:27:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12AA923F294;
	Mon, 23 Jun 2025 11:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="C2KTII+t"
X-Original-To: kvm@vger.kernel.org
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7F1231C8D;
	Mon, 23 Jun 2025 11:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750678011; cv=none; b=Gdji8NrYXoZXDwXCvtS98wqDtEUCsiLOs7/UReQ77uGzJzlCndPcVTF9UCsW3CAzN+6Wmm82mNBBmcoouwtrbzd7vkwJ1kJcCBVZnP/zX3a6HxE6W1F84R/KG2//N2zM61TiWmW1Usn1ZLmUfcULU+BbCUr7qhHxSZNDfwU9zkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750678011; c=relaxed/simple;
	bh=AFKyudrR7+szYWjXjrL9H5jQwyzAn4iMDd/27Hht0Hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KOC/UXIPf9eZclFTKH8z7PeL5ASlaWuswt8wRWFXcpweF0bgiPeGKOjx7bXVZ5vwi14kVZnchObVEyFqXTTEZ+3ftptdUbw6FnvFqPHGAYJAT6yS/sbneHaKfLqL2gwEnkucr4Np41KcHDKwa7U6xgyjps1PRaNdkcD5coxIhRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=C2KTII+t; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id A08BB40E01FC;
	Mon, 23 Jun 2025 11:26:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id O1-0Nqdl9xpc; Mon, 23 Jun 2025 11:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1750678001; bh=b8YW3wQQJsx2YWUhHESzkkFpIy/unRLxkCns1tBbzj8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C2KTII+t5MujHsZ93m7d+MPYpXKuVuKvwYVMea5vJV70q9v48dwSLwUy3m4Y4tQRe
	 bGc+xBYoN7ORB7HAXP6d5LAY3FAvTkWECoZkxZtQfJg+TCGJQsqF3Y8a5E9zfO8n/B
	 FjZQWzv8Bd3DKoLexqcCG4GAUwh0mUAARsrFrNO+I9mY8jQqkznvupVwZAQbHIem2w
	 7WXoCg3inwEGORZ3T+OAFucZXShJMKnkTTdqENJoGHI5ay0xvza8FHoanXXa/jynvy
	 HOojC6jl/v2rXJkd/wHwtba3Uge690+R25laGv586oeZsABk7X8oMAbvjZBMnwOZr3
	 jKHyjm6x6mAr6ggmMcwFB5KyDt9RloVV4N3E+d/wSoKZlzn+5WhWa8Jw46sIVoXSii
	 V4/L7zLZcVONjCRWpCbtEdYxZkUvZmQe9tcVgmevA8/dft1Ue18gH0dYCyfDZlu6Je
	 P8INwZ86NTFna/2j3/Mlktyt1mpUMjWAu8M6yCQ1m8JXofvcMyLsjYDr3cRsglWHlE
	 CpVvJJXdWG482S56rwJU281hj0BHoCergidzChMQS7qEmQjVHn5R2Ktt54eX/b7o9H
	 z15CaYKR/1qutHlFfGHbO5yyO+lHtjI6xGq2hS04kEslK5qAD4lVzc9m1zgEgvH5EE
	 PrPw2TmfaY6D/dyHVggwZsG4=
Received: from zn.tnic (p57969c58.dip0.t-ipconnect.de [87.150.156.88])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 5868840E00CE;
	Mon, 23 Jun 2025 11:26:19 +0000 (UTC)
Date: Mon, 23 Jun 2025 13:26:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
	dave.hansen@linux.intel.com, Thomas.Lendacky@amd.com,
	nikunj@amd.com, Santosh.Shukla@amd.com, Vasant.Hegde@amd.com,
	Suravee.Suthikulpanit@amd.com, David.Kaplan@amd.com, x86@kernel.org,
	hpa@zytor.com, peterz@infradead.org, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org,
	kirill.shutemov@linux.intel.com, huibo.wang@amd.com,
	naveen.rao@amd.com, francescolavra.fl@gmail.com,
	tiala@microsoft.com
Subject: Re: [RFC PATCH v7 01/37] KVM: lapic: Remove
 __apic_test_and_{set|clear}_vector()
Message-ID: <20250623112612.GEaFk51EOLBBvZWWJm@fat_crate.local>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
 <20250610175424.209796-2-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250610175424.209796-2-Neeraj.Upadhyay@amd.com>

On Tue, Jun 10, 2025 at 11:23:48PM +0530, Neeraj Upadhyay wrote:
> Remove __apic_test_and_set_vector() and __apic_test_and_clear_vector(),
> because the _only_ register that's safe to modify with a non-atomic
> operation is ISR, because KVM isn't running the vCPU, i.e. hardware can't
> service an IRQ or process an EOI for the relevant (virtual) APIC.
> 
> No functional change intended.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> [Neeraj: Add "inline" for apic_vector_to_isr()]
> Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
> ---
> Changes since v6:
> 
>  - New change.
> 
>  arch/x86/kvm/lapic.c | 19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)

FWIW: LGTM.

:-)

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

