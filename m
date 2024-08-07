Return-Path: <kvm+bounces-23565-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E38894ADAC
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 18:08:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E9B11C21E7C
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 16:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E611D13AD0F;
	Wed,  7 Aug 2024 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QbqMEAre";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Vjpe8cWi"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B801312C53B;
	Wed,  7 Aug 2024 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723046791; cv=none; b=SynK2mog70erxRwfQODDlSqcVxSNfPQXAorkWiR3IBbm6FDadYzeYWJAJN3mQ4q4YZw0V1n5j0Ri95CtqRSY9FLF/ZywNEGk7IWxWegQOZHbjYufuNlLtjyqq7ltn4AKAxowuIHGsYgqIt30OBwCi7QSK3NWwJSe/JZhNwo5THo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723046791; c=relaxed/simple;
	bh=R7Qllx4JZW1zg7H7gr7aYgLNKiP6/QMMESmdaEgPzEw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ZphpAtXbWLnLLT1Pz/Q6XPx8HcmkElPccx0V63/w3JGZylvk0vqLwvY6l6DySQ17toFh6/7kXhB5x8Lreuw6XosUduQS1ilU9FVocwl2WDcWj+eTxP+RUxzv0pY3xZkYiU6ll+f+AwQQsx6X1oz8qAoympJRMf+m4bIfHvjwiVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=QbqMEAre; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Vjpe8cWi; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1723046788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z52v8Sqeswu8CGSorbo0wWNBPUOgPGQL89gbTfBDJO4=;
	b=QbqMEAreoNIgckPSgEw3a/M7zZyGIQYxUuptE5DfYAsi11tMCsqXkzMR4DQ3HELQbQWo9q
	JBpuM10v5CeeGtwZ4MGgPnXhxfnKW6V1cwEPZ3MmxstdpM5A9z5fRd+m4PnBVYB1nwM8Ll
	ZuYlp7xbTR0rI+5FVCbj8jXw2bbWHKoWD4vZAs0PUu72uryEJxRf6FtwYIzZTMSQ+W5DQ1
	HpatqIl/d3Q9m5fOY9NuiKismm4oMZO3hQrSJ0gaXLUqqcsE3PUas4yXAySYAjQNEHlFn1
	Y0Q2dzkTvIbvDT19JQdjskHMeqeQ1cBhd/kbXTkhbgotxhB0zMVu22zSFJ/5EQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1723046788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z52v8Sqeswu8CGSorbo0wWNBPUOgPGQL89gbTfBDJO4=;
	b=Vjpe8cWiXkXmqG7GXMUtntPL0PJQs2ZR6ZUjCkNswXcHzXBOwYux6r70GxFRynedRIoxpl
	HWHcEfUvfU5k3YBg==
To: Kim Phillips <kim.phillips@amd.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth
 <michael.roth@amd.com>, Ashish Kalra <ashish.kalra@amd.com>, Nikunj A
 Dadhania <nikunj@amd.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Kishon
 Vijay Abraham I <kvijayab@amd.com>, Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH 1/2] x86/cpufeatures: Add "Allowed SEV Features" Feature
In-Reply-To: <20240802015732.3192877-2-kim.phillips@amd.com>
References: <20240802015732.3192877-1-kim.phillips@amd.com>
 <20240802015732.3192877-2-kim.phillips@amd.com>
Date: Wed, 07 Aug 2024 18:06:27 +0200
Message-ID: <87o7642u7w.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Aug 01 2024 at 20:57, Kim Phillips wrote:
> From: Kishon Vijay Abraham I <kvijayab@amd.com>
>
> Add CPU feature detection for "Allowed SEV Features" to allow the
> Hypervisor to enforce that SEV-ES and SEV-SNP guest VMs cannot
> enable features (via SEV_FEATURES) that the Hypervisor does not
> support or wish to be enabled.

Can you please add this new feature bit to the CPUID database

    https://gitlab.com/x86-cpuid.org/x86-cpuid-db

Thanks,

        tglx

